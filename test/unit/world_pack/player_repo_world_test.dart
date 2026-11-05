import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

const _andorra = 2;

/// Albania, Andorra, Croatia: a mid nation, a minnow and one with frozen
/// (V4) name lists.
const _goldenNations = [1, 2, 10];
const _goldenSeed = 42;
const _goldenFile = 'test/unit/world_pack/fixtures/default_world_seed42.json';

/// A seeded container over a fresh database.
Future<ProviderContainer> _world() async {
  final db = createTestDatabase();
  addTearDown(db.close);
  final c = greenlandContainer(db);
  addTearDown(c.dispose);
  await c.read(seedLoaderProvider).ensureSeeded();
  return c;
}

/// A new pack from the default world, edited by [edit], and a career on it.
Future<({int career, int seed, WorldPack pack})> _packCareer(
  ProviderContainer c, [
  WorldPack Function(WorldPack)? edit,
]) async {
  final packs = c.read(worldPackRepositoryProvider);
  final packId = await c.read(worldPackServiceProvider).createFromDefault('W');
  var pack = (await packs.load(packId))!;
  if (edit != null) {
    pack = edit(pack);
    await packs.save(packId, pack);
  }
  final career =
      (await c
              .read(careerServiceProvider)
              .create(
                nationId: 1,
                managerName: 'M',
                rngSeed: 7,
                worldPackId: packId,
              ))
          .valueOrNull!;
  return (career: career.id, seed: career.rngSeed, pack: pack);
}

/// [pack] with nation [nationId]'s squad replaced by [squad] of its own.
WorldPack _withSquad(
  WorldPack pack,
  int nationId,
  List<PackPlayer> Function(List<PackPlayer>) squad,
) => pack.copyWith(
  squads: {...pack.squads, nationId: squad(pack.squads[nationId]!)},
);

/// The youngest player of [squad]: never retired early in a test.
PackPlayer _youngest(List<PackPlayer> squad) =>
    squad.reduce((a, b) => a.age <= b.age ? a : b);

PackPlayer _copy(
  PackPlayer p, {
  String? name,
  PlayerAttributes? attributes,
  int? potential,
  String? club,
  String? clubCountry,
}) => PackPlayer(
  id: p.id,
  name: name ?? p.name,
  age: p.age,
  position: p.position,
  attributes: attributes ?? p.attributes,
  potential: potential ?? p.potential,
  club: club ?? p.club,
  clubCountry: clubCountry ?? p.clubCountry,
);

List<Object> _row(Player p) => [
  p.name,
  p.age,
  p.attributes.physical,
  p.attributes.technical,
  p.attributes.stamina,
  p.club,
  p.clubCountry,
];

/// Every read the golden pins, for a default career at [_goldenSeed].
Future<Map<String, Object>> _snapshot(ProviderContainer c, int career) async {
  final players = c.read(playerRepositoryProvider);
  final out = <String, Object>{};
  for (final n in _goldenNations) {
    for (final years in [0, 8]) {
      out['$n/senior/$years'] = {
        for (final p in await players.byNation(
          n,
          agingYears: years,
          saveSeed: _goldenSeed,
          careerId: career,
          minAge: 15,
        ))
          '${p.id}': _row(p),
      };
    }
    out['$n/youth/0'] = {
      for (final p in await players.youthByNation(
        n,
        saveSeed: _goldenSeed,
        careerId: career,
      ))
        '${p.id}': _row(p),
    };
  }
  return out;
}

void main() {
  test(
    'default career: names, attributes and clubs identical to before',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(nationId: 1, managerName: 'M', rngSeed: _goldenSeed))
              .valueOrNull!;
      // Round-trip through JSON so the comparison is like for like.
      final got = jsonDecode(jsonEncode(await _snapshot(c, career.id)));
      final file = File(_goldenFile);
      if (Platform.environment['WRITE_GOLDEN'] == '1') {
        file
          ..createSync(recursive: true)
          ..writeAsStringSync(const JsonEncoder.withIndent(' ').convert(got));
      }
      expect(got, jsonDecode(file.readAsStringSync()));
    },
  );

  test(
    'pack career: the edited name and attributes come back exactly',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      const attrs = PlayerAttributes(physical: 61, technical: 73, stamina: 58);
      late PackPlayer target;
      final w = await _packCareer(
        c,
        (pack) => _withSquad(pack, _andorra, (squad) {
          target = _youngest(squad);
          return [
            for (final p in squad)
              if (p.id == target.id)
                _copy(p, name: 'Zdeněk Edited', attributes: attrs)
              else
                p,
          ];
        }),
      );
      final players = c.read(playerRepositoryProvider);
      final pool = {
        for (final p in await players.byNation(
          _andorra,
          saveSeed: w.seed,
          careerId: w.career,
        ))
          p.id: p,
      };
      expect(pool[target.id]?.name, 'Zdeněk Edited');
      expect(pool[target.id]?.attributes, attrs);
      // Every other core player keeps the pack's name too.
      for (final p in w.pack.squads[_andorra]!) {
        if (pool[p.id] case final got?) expect(got.name, p.name);
      }
      final byId = await players.byId(
        target.id,
        saveSeed: w.seed,
        careerId: w.career,
      );
      expect(byId?.name, 'Zdeněk Edited');
      expect(byId?.attributes, attrs);
    },
  );

  test(
    'pack career: an added player is in byNation and byId',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      const id = kPackPlayerIdBase + 17;
      final w = await _packCareer(
        c,
        (pack) => _withSquad(
          pack,
          _andorra,
          (squad) => [
            ...squad,
            const PackPlayer(
              id: id,
              name: 'Added Player',
              age: 21,
              position: PlayerPosition.st,
              attributes: PlayerAttributes(
                physical: 70,
                technical: 72,
                stamina: 68,
              ),
              potential: 80,
              club: 'Klokani Praha',
              clubCountry: 'cze',
            ),
          ],
        ),
      );
      final players = c.read(playerRepositoryProvider);
      final pool = await players.byNation(
        _andorra,
        saveSeed: w.seed,
        careerId: w.career,
      );
      final added = pool.where((p) => p.id == id).single;
      expect(added.name, 'Added Player');
      expect(added.club, 'Klokani Praha');
      expect(added.clubCountry, 'cze');
      final byId = await players.byId(id, saveSeed: w.seed, careerId: w.career);
      expect(byId?.name, 'Added Player');
      expect(byId?.nationId, _andorra);
      expect(byId?.attributes, added.attributes);
    },
  );

  test(
    'a removed player is gone',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      late PackPlayer gone;
      final w = await _packCareer(
        c,
        (pack) => _withSquad(pack, _andorra, (squad) {
          gone = _youngest(squad);
          return [
            for (final p in squad)
              if (p.id != gone.id) p,
          ];
        }),
      );
      final players = c.read(playerRepositoryProvider);
      final pool = await players.byNation(
        _andorra,
        saveSeed: w.seed,
        careerId: w.career,
      );
      expect(pool.where((p) => p.id == gone.id), isEmpty);
      expect(
        await players.byId(gone.id, saveSeed: w.seed, careerId: w.career),
        isNull,
      );
    },
  );

  test(
    'day-one club holds until his first contract ends, then the clock moves '
    'him',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      // A young player whose deal ends within a few years.
      final plain = await _packCareer(c);
      final squad = plain.pack.squads[_andorra]!;
      final candidates = [
        for (final p in squad)
          if (p.age <= 26)
            (
              p: p,
              years: [
                for (var k = 1; k <= 6; k++)
                  if (ClubService.contractAt(p.id, p.age + k).index !=
                      ClubService.contractAt(p.id, p.age).index)
                    k,
              ],
            ),
      ].where((e) => e.years.isNotEmpty).toList();
      expect(candidates, isNotEmpty);
      final target = candidates.first.p;
      final moves = candidates.first.years.first;

      final edited = await _packCareer(
        c,
        (pack) => _withSquad(
          pack,
          _andorra,
          (s) => [
            for (final p in s)
              if (p.id == target.id)
                _copy(p, club: 'Klokani Praha', clubCountry: 'cze')
              else
                p,
          ],
        ),
      );
      final players = c.read(playerRepositoryProvider);
      Future<Player?> at(int career, int years) async =>
          (await players.byNation(
            _andorra,
            agingYears: years,
            saveSeed: 7,
            careerId: career,
          )).where((p) => p.id == target.id).firstOrNull;

      for (var y = 0; y < moves; y++) {
        final p = await at(edited.career, y);
        expect(p?.club, 'Klokani Praha', reason: 'year $y');
        expect(p?.clubCountry, 'cze', reason: 'year $y');
      }
      // Once the deal is up he is wherever the clock puts him, exactly as in
      // the career without the edit.
      final moved = await at(edited.career, moves);
      final reference = await at(plain.career, moves);
      expect(moved, isNotNull);
      expect(moved!.club, reference!.club);
      expect(moved.clubCountry, reference.clubCountry);
    },
  );

  test(
    'a renamed club is renamed for every player',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      final plain = await _packCareer(c);
      final players = c.read(playerRepositoryProvider);
      Future<List<Player>> read(int career, int years) async => [
        for (final n in _goldenNations)
          ...await players.byNation(
            n,
            agingYears: years,
            saveSeed: 7,
            careerId: career,
          ),
      ];
      // The club most players of these nations are at on day one.
      final counts = <String, int>{};
      for (final p in await read(plain.career, 0)) {
        counts[p.club] = (counts[p.club] ?? 0) + 1;
      }
      final club =
          (counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
              .first
              .key;

      final renamed = await _packCareer(
        c,
        (pack) => pack.copyWith(clubs: {club: 'Renamed FC'}),
      );
      for (final years in [0, 4]) {
        final before = await read(plain.career, years);
        final after = {
          for (final p in await read(renamed.career, years)) p.id: p,
        };
        var hits = 0;
        for (final p in before) {
          final now = after[p.id]!;
          if (p.club == club) {
            hits++;
            expect(now.club, 'Renamed FC');
            expect(now.clubCountry, p.clubCountry);
          } else {
            expect(now.club, p.club);
          }
        }
        if (years == 0) expect(hits, greaterThan(0));
        expect(after.values.where((p) => p.club == club), isEmpty);
      }
    },
  );

  test(
    'youth intake reads the edited squad strength',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      final plain = await _packCareer(c);
      final strong = await _packCareer(
        c,
        (pack) => _withSquad(
          pack,
          _andorra,
          (squad) => [
            for (final p in squad)
              _copy(
                p,
                attributes: const PlayerAttributes(
                  physical: 90,
                  technical: 90,
                  stamina: 90,
                ),
                potential: 95,
              ),
          ],
        ),
      );
      final players = c.read(playerRepositoryProvider);
      Future<double> intake(int career) async {
        final youth = [
          for (final p in await players.youthByNation(
            _andorra,
            saveSeed: 7,
            careerId: career,
          ))
            if (PlayerLifecycle.isNewgenId(p.id)) p.overall,
        ];
        expect(youth, isNotEmpty);
        return youth.reduce((a, b) => a + b) / youth.length;
      }

      expect(
        await intake(strong.career),
        greaterThan(await intake(plain.career)),
      );
    },
  );

  test('ClubService.leagueClubs lists a curated league and nothing else', () {
    expect(ClubService.leagueClubs('cze'), contains('Klokani Praha'));
    expect(ClubService.leagueClubs('CZE'), contains('Klokani Praha'));
    expect(ClubService.leagueClubs('and'), isEmpty);
  });

  test('ClubService.renamed renames only a listed club', () {
    const side = (name: 'Man Blue', country: 'eng');
    expect(ClubService.renamed(side, {'Man Blue': 'Sky FC'}), (
      name: 'Sky FC',
      country: 'eng',
    ));
    expect(ClubService.renamed(side, {'Man Red': 'X'}), side);
    expect(ClubService.renamed(side, const {}), side);
  });
}
