import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/dormant_seed.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

const _albania = 1;

/// A city-built country (no curated league) and its cities, biggest first.
const _city = 'xcb';
const _cities = ['Alpha', 'Beta', 'Gamma', 'Delta', 'Epsilon', 'Zeta'];

/// [n] varied players: ids, ages 16 to 36 and overalls 45 to 92.
List<Player> _players(int n) => [
  for (var i = 0; i < n; i++)
    Player(
      id: 1000 + i * 37,
      nationId: 1,
      name: 'P$i',
      age: 16 + (i * 7) % 21,
      position: PlayerPosition.values[i % PlayerPosition.values.length],
      attributes: PlayerAttributes(
        physical: 45 + (i * 13) % 48,
        technical: 45 + (i * 29) % 48,
        stamina: 45 + (i * 5) % 48,
      ),
    ),
];

/// The home contexts every club test runs across: a league country, a
/// city-built one, and no home at all.
const _homes = <({String code, List<String> cities})>[
  (code: 'cze', cities: <String>[]),
  (code: _city, cities: _cities),
  (code: 'eng', cities: <String>[]),
  // No league and no cities: his players go abroad, added clubs or not.
  (code: 'xnc', cities: <String>[]),
  (code: '', cities: <String>[]),
];

const _seeds = [0, 7, 4242];

void main() {
  test('empty added: clubForSeed identical for 2 000 players and 3 '
      'seeds', () {
    // An added club in a country nobody plays at home in, and which has
    // no league, is no destination either: nothing moves.
    const elsewhere = {
      'zzz': ['Nowhere Rovers'],
    };
    for (final home in _homes) {
      for (final seed in _seeds) {
        for (final p in _players(2000)) {
          final today = ClubService.clubForSeed(
            p,
            seed,
            homeCode: home.code,
            homeCities: home.cities,
          );
          for (final added in [const <String, List<String>>{}, elsewhere]) {
            expect(
              ClubService.clubForSeed(
                p,
                seed,
                homeCode: home.code,
                homeCities: home.cities,
                added: added,
              ),
              today,
              reason: '${home.code} seed $seed id ${p.id}',
            );
          }
        }
      }
    }
  });

  test('an added Czech club receives Czech players', () {
    const added = {
      'cze': ['Brno Kestrels'],
    };
    var at = 0;
    var home = 0;
    for (final seed in _seeds) {
      for (final p in _players(2000)) {
        final c = ClubService.clubForSeed(
          p,
          seed,
          homeCode: 'cze',
          added: added,
        );
        if (c.country == 'cze') home++;
        if (c.name == 'Brno Kestrels') {
          expect(c.country, 'cze');
          at++;
        }
      }
    }
    // One club among fifteen: about a fifteenth of the home players.
    expect(at, greaterThan(home ~/ 30));
    expect(at, lessThan(home ~/ 7));
  });

  test('two clubs added to a city-built country: players spread over city '
      'clubs and both added clubs, none holding more than 40% of the home '
      'players', () {
    const added = {
      _city: ['Alpha Kestrels', 'Omega Town'],
    };
    for (final seed in _seeds) {
      final byClub = <String, int>{};
      var home = 0;
      for (final p in _players(2000)) {
        final c = ClubService.clubForSeed(
          p,
          seed,
          homeCode: _city,
          homeCities: _cities,
          added: added,
        );
        if (c.country != _city) continue;
        home++;
        byClub.update(c.name, (n) => n + 1, ifAbsent: () => 1);
      }
      expect(home, greaterThan(500), reason: 'seed $seed');
      expect(byClub['Alpha Kestrels'] ?? 0, greaterThan(0));
      expect(byClub['Omega Town'] ?? 0, greaterThan(0));
      final cityClubs = byClub.keys.where(
        (n) => !added[_city]!.contains(n),
      );
      expect(cityClubs, isNotEmpty);
      for (final MapEntry(key: name, value: n) in byClub.entries) {
        expect(n, lessThanOrEqualTo(home * 0.4), reason: '$name seed $seed');
      }
    }
  });

  test('a city-built country with added clubs is never a destination '
      'abroad', () {
    const added = {
      _city: ['Alpha Kestrels', 'Omega Town'],
    };
    for (final seed in _seeds) {
      for (final p in _players(2000)) {
        final c = ClubService.clubForSeed(
          p,
          seed,
          homeCode: 'cze',
          added: added,
        );
        expect(c.country, isNot(_city));
      }
    }
  });

  test('no player changes country or ClubService.tierOfCountry when clubs '
      'are added', () {
    const added = {
      'cze': ['Brno Kestrels', 'Ostrava Owls'],
      'eng': ['Thames Herons'],
      _city: ['Alpha Kestrels', 'Omega Town'],
      'xnc': ['Lonely Athletic'],
    };
    var moved = 0;
    for (final home in _homes) {
      for (final seed in _seeds) {
        for (final p in _players(2000)) {
          final before = ClubService.clubForSeed(
            p,
            seed,
            homeCode: home.code,
            homeCities: home.cities,
          );
          final after = ClubService.clubForSeed(
            p,
            seed,
            homeCode: home.code,
            homeCities: home.cities,
            added: added,
          );
          expect(after.country, before.country);
          expect(
            ClubService.tierOfCountry(after.country),
            ClubService.tierOfCountry(before.country),
          );
          if (after.name != before.name) moved++;
        }
      }
    }
    // The added clubs really do take players.
    expect(moved, greaterThan(0));
  });

  test('allLeagues lists the curated leagues in table order', () {
    final leagues = ClubService.allLeagues();
    expect(leagues.first.country, 'eng');
    expect(leagues.last.country, 'tpe');
    expect(
      leagues.singleWhere((l) => l.country == 'cze').clubs,
      ClubService.leagueClubs('cze'),
    );
    expect(leagues.map((l) => l.country).toSet().length, leagues.length);
  });

  group('in a career', () {
    Future<ProviderContainer> world() async {
      final db = createTestDatabase();
      addTearDown(db.close);
      // Albania's cities, as the app's seed gives them: a city-built
      // country whose own players can be placed at home.
      final c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
          seedSourceProvider.overrideWithValue(
            InMemorySeedSource(
              nationList: seedNations,
              playerList: seedPlayers,
              cityLists: const {
                _albania: [
                  'Tirana',
                  'Durrës',
                  'Vlorë',
                  'Elbasan',
                  'Shkodër',
                  'Korçë',
                ],
              },
              dormantNations: DormantNations.all,
              dormantPlayers: dormantPool(),
            ),
          ),
        ],
      );
      addTearDown(c.dispose);
      await c.read(seedLoaderProvider).ensureSeeded();
      return c;
    }

    Future<int> career(ProviderContainer c, int packId) async =>
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: _albania,
                  managerName: 'M',
                  rngSeed: 7,
                  worldPackId: packId,
                ))
            .valueOrNull!
            .id;

    Future<String> albaniaCode(ProviderContainer c) async {
      final db = c.read(appDatabaseProvider);
      final n = await (db.select(
        db.nations,
      )..where((t) => t.id.equals(_albania))).getSingle();
      return n.code.toLowerCase();
    }

    test('a pack career with added clubs develops every player exactly as '
        'without them', () async {
      final c = await world();
      final packs = c.read(worldPackRepositoryProvider);
      final service = c.read(worldPackServiceProvider);
      final code = await albaniaCode(c);
      final plainId = await service.createFromDefault('Plain');
      final addedId = await service.createFromDefault('Added');
      final pack = (await packs.load(addedId))!;
      await packs.save(
        addedId,
        pack.copyWith(
          addedClubs: [
            PackClub(id: 700000001, name: 'Tirana Kestrels', country: code),
            PackClub(id: 700000002, name: 'Durrës Herons', country: code),
            const PackClub(
              id: 700000003,
              name: 'Brno Kestrels',
              country: 'cze',
            ),
          ],
        ),
      );
      final plain = await career(c, plainId);
      final withAdded = await career(c, addedId);
      final players = c.read(playerRepositoryProvider);
      for (final years in [0, 8]) {
        Future<List<Player>> read(int careerId) => players.byNation(
          _albania,
          agingYears: years,
          saveSeed: 7,
          careerId: careerId,
          minAge: 15,
        );
        final a = await read(plain);
        final b = await read(withAdded);
        expect(
          {for (final p in b) p.id: p.overall},
          {for (final p in a) p.id: p.overall},
          reason: 'year $years',
        );
        expect(
          {for (final p in b) p.id: p.clubCountry},
          {for (final p in a) p.id: p.clubCountry},
          reason: 'year $years',
        );
      }
      final now = await players.byNation(
        _albania,
        saveSeed: 7,
        careerId: withAdded,
        minAge: 15,
      );
      expect(
        now.where(
          (p) => p.club == 'Tirana Kestrels' || p.club == 'Durrës Herons',
        ),
        isNotEmpty,
      );
    });

    test('a pack player can start at an added club', () async {
      final c = await world();
      final packs = c.read(worldPackRepositoryProvider);
      final code = await albaniaCode(c);
      final packId = await c
          .read(worldPackServiceProvider)
          .createFromDefault('W');
      final pack = (await packs.load(packId))!;
      final squad = pack.squads[_albania]!;
      final first = squad.first;
      await packs.save(
        packId,
        pack.copyWith(
          addedClubs: [
            PackClub(id: 700000001, name: 'Tirana Kestrels', country: code),
          ],
          squads: {
            ...pack.squads,
            _albania: [
              PackPlayer(
                id: first.id,
                name: first.name,
                age: first.age,
                position: first.position,
                attributes: first.attributes,
                potential: first.potential,
                club: 'Tirana Kestrels',
                clubCountry: code,
                traits: first.traits,
              ),
              ...squad.skip(1),
            ],
          },
        ),
      );
      final id = await career(c, packId);
      final p = (await c
          .read(playerRepositoryProvider)
          .byId(first.id, saveSeed: 7, careerId: id))!;
      expect(p.club, 'Tirana Kestrels');
      expect(p.clubCountry, code);
    });
  });
}
