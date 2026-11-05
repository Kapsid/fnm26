import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/match/background_match.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/domain/services/squad/captaincy.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

const _albania = 1;

/// A seeded container over a fresh database.
Future<ProviderContainer> _world() async {
  final db = createTestDatabase();
  addTearDown(db.close);
  final c = greenlandContainer(db);
  addTearDown(c.dispose);
  await c.read(seedLoaderProvider).ensureSeeded();
  return c;
}

/// A pack from the default world with Albania's squad passed through
/// [edit], and one career on it per seed of [seeds].
Future<({List<({int career, int seed})> careers, WorldPack pack})> _careers(
  ProviderContainer c,
  List<PackPlayer> Function(List<PackPlayer>) edit, {
  List<int> seeds = const [7, 11],
}) async {
  final packs = c.read(worldPackRepositoryProvider);
  final packId = await c.read(worldPackServiceProvider).createFromDefault('W');
  var pack = (await packs.load(packId))!;
  pack = pack.copyWith(
    squads: {...pack.squads, _albania: edit(pack.squads[_albania]!)},
  );
  await packs.save(packId, pack);
  final out = <({int career, int seed})>[];
  for (final s in seeds) {
    final career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: _albania,
                  managerName: 'M',
                  rngSeed: s,
                  worldPackId: packId,
                ))
            .valueOrNull!;
    out.add((career: career.id, seed: career.rngSeed));
  }
  return (careers: out, pack: pack);
}

PackPlayer _with(
  PackPlayer p, {
  List<PlayerTrait>? traits,
  PlayerAttributes? attributes,
}) => PackPlayer(
  id: p.id,
  name: p.name,
  age: p.age,
  position: p.position,
  attributes: attributes ?? p.attributes,
  potential: attributes == null ? p.potential : 99,
  club: p.club,
  clubCountry: p.clubCountry,
  traits: traits,
);

/// The youngest player of [squad]: still in the pool eight years on.
PackPlayer _youngest(List<PackPlayer> squad) =>
    squad.reduce((a, b) => a.age <= b.age ? a : b);

Player _plain(int id, {int age = 30, int q = 80}) => Player(
  id: id,
  nationId: 1,
  name: 'P$id',
  age: age,
  position: PlayerPosition.cm,
  attributes: PlayerAttributes(physical: q, technical: q, stamina: q),
);

void main() {
  group('PlayerTraits.of', () {
    test('a fixed list replaces the roll, earned traits included', () {
      final pacey = _plain(5, q: 90);
      expect(PlayerTraits.of(pacey), contains(PlayerTrait.pacey));
      final fixed = pacey.copyWith(fixedTraits: const [PlayerTrait.wasteful]);
      for (final seed in [0, 7, 99]) {
        expect(PlayerTraits.of(fixed, saveSeed: seed), [PlayerTrait.wasteful]);
      }
      expect(PlayerTraits.of(pacey.copyWith(fixedTraits: const [])), isEmpty);
    });

    test('a fixed list is cut to maxTraits and cannot be changed', () {
      final p = _plain(5).copyWith(
        fixedTraits: const [
          PlayerTrait.leader,
          PlayerTrait.setPiece,
          PlayerTrait.hothead,
        ],
      );
      final t = PlayerTraits.of(p);
      expect(t, [PlayerTrait.leader, PlayerTrait.setPiece]);
      expect(() => t.add(PlayerTrait.pacey), throwsUnsupportedError);
    });

    test('an old JSON without fixedTraits reads as null; null writes no '
        'key', () {
      final p = _plain(5);
      Map<String, Object?> json(Player p) =>
          jsonDecode(jsonEncode(p)) as Map<String, Object?>;
      expect(json(p).containsKey('fixedTraits'), isFalse);
      expect(Player.fromJson(json(p)).fixedTraits, isNull);
      final fixed = p.copyWith(fixedTraits: const [PlayerTrait.leader]);
      expect(Player.fromJson(json(fixed)).fixedTraits, [
        PlayerTrait.leader,
      ]);
    });
  });

  test('a pack player with traits [leader, setPiece] has them at agingYears '
      '0 and 8, from byNation and byId, on two seeds', () async {
    final c = await _world();
    late int id;
    final w = await _careers(c, (squad) {
      final y = _youngest(squad);
      id = y.id;
      return [
        for (final p in squad)
          p.id == id
              ? _with(
                  p,
                  traits: const [PlayerTrait.leader, PlayerTrait.setPiece],
                )
              : p,
      ];
    });
    final players = c.read(playerRepositoryProvider);
    for (final (:career, :seed) in w.careers) {
      for (final years in [0, 8]) {
        final pool = await players.byNation(
          _albania,
          agingYears: years,
          saveSeed: seed,
          careerId: career,
          minAge: 15,
        );
        final fromPool = pool.singleWhere((p) => p.id == id);
        final fromId = (await players.byId(
          id,
          agingYears: years,
          saveSeed: seed,
          careerId: career,
        ))!;
        for (final p in [fromPool, fromId]) {
          expect(
            PlayerTraits.of(p, saveSeed: seed),
            [PlayerTrait.leader, PlayerTrait.setPiece],
            reason: 'seed $seed, year $years',
          );
        }
      }
    }
  });

  test(
    'traits [] gives no traits even for a pacey 90-physical player',
    () async {
      final c = await _world();
      late int id;
      final w = await _careers(c, (squad) {
        final y = _youngest(squad);
        id = y.id;
        return [
          for (final p in squad)
            p.id == id
                ? _with(
                    p,
                    traits: const [],
                    attributes: const PlayerAttributes(
                      physical: 90,
                      technical: 80,
                      stamina: 90,
                    ),
                  )
                : p,
        ];
      });
      final players = c.read(playerRepositoryProvider);
      for (final (:career, :seed) in w.careers) {
        final p = (await players.byId(id, saveSeed: seed, careerId: career))!;
        expect(p.attributes.physical, greaterThanOrEqualTo(84));
        // Without the pick he would be pacey.
        expect(
          PlayerTraits.of(p.copyWith(fixedTraits: null), saveSeed: seed),
          contains(PlayerTrait.pacey),
        );
        expect(PlayerTraits.of(p, saveSeed: seed), isEmpty);
      }
    },
  );

  test('traits null rolls as today', () async {
    final c = await _world();
    final w = await _careers(c, (squad) => squad);
    final players = c.read(playerRepositoryProvider);
    for (final (:career, :seed) in w.careers) {
      final pool = await players.byNation(
        _albania,
        saveSeed: seed,
        careerId: career,
      );
      expect(pool, isNotEmpty);
      for (final p in pool) {
        expect(p.fixedTraits, isNull);
        final bare = Player(
          id: p.id,
          nationId: p.nationId,
          name: p.name,
          age: p.age,
          position: p.position,
          attributes: p.attributes,
          club: p.club,
          clubCountry: p.clubCountry,
        );
        expect(
          PlayerTraits.of(p, saveSeed: seed),
          PlayerTraits.of(bare, saveSeed: seed),
        );
      }
    }
  });

  test('Captaincy.leadership counts a fixed leader', () async {
    final c = await _world();
    late int id;
    final w = await _careers(c, (squad) {
      final y = _youngest(squad);
      id = y.id;
      return [
        for (final p in squad)
          p.id == id ? _with(p, traits: const [PlayerTrait.leader]) : p,
      ];
    });
    final (:career, :seed) = w.careers.first;
    final p = (await c
        .read(playerRepositoryProvider)
        .byId(id, saveSeed: seed, careerId: career))!;
    final without = p.copyWith(fixedTraits: const []);
    expect(
      Captaincy.leadership(p, saveSeed: seed) -
          Captaincy.leadership(without, saveSeed: seed),
      5,
    );
  });

  test('BackgroundMatch sees the fixed traits', () async {
    final c = await _world();
    final w = await _careers(
      c,
      (squad) => [
        for (final p in squad) _with(p, traits: const [PlayerTrait.hothead]),
      ],
    );
    final (:career, :seed) = w.careers.first;
    final pool = await c
        .read(playerRepositoryProvider)
        .byNation(_albania, saveSeed: seed, careerId: career);
    // The squad's players (the stored fringe around it rolls as ever).
    final xi = pool.where((p) => p.fixedTraits != null).take(11).toList();
    expect(xi, hasLength(11));
    // The read background_match.dart makes for every player.
    for (final p in xi) {
      expect(PlayerTraits.of(p, saveSeed: seed), [PlayerTrait.hothead]);
    }
    final calm = [for (final p in xi) p.copyWith(fixedTraits: const [])];

    int cards(List<Player> home) {
      var n = 0;
      for (var i = 0; i < 300; i++) {
        final d = BackgroundMatch.detail(
          homeXi: home,
          awayXi: calm,
          homeNationId: 1,
          awayNationId: 2,
          homeScore: 0,
          awayScore: 0,
          homeStrength: 75,
          awayStrength: 75,
          goalsByPlayer: const {},
          rng: SeededRng(i),
          competitive: true,
          saveSeed: seed,
        );
        n += d.events
            .where(
              (e) =>
                  e.teamNationId == 1 &&
                  (e.type == MatchEventType.yellowCard ||
                      e.type == MatchEventType.redCard),
            )
            .length;
      }
      return n;
    }

    expect(cards(xi), greaterThan(cards(calm) * 1.6));
  });
}
