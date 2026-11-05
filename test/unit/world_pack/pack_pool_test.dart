import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

const _andorra = 2;
const _czechia = 12;

/// A seeded container over a fresh database.
Future<ProviderContainer> _world() async {
  final db = createTestDatabase();
  addTearDown(db.close);
  final c = greenlandContainer(db);
  addTearDown(c.dispose);
  await c.read(seedLoaderProvider).ensureSeeded();
  return c;
}

/// A new pack from the default world, edited by [edit] (handed the service
/// for [WorldPackService.generatedPool]), and a career on it at [seed].
Future<({int career, int seed, WorldPack pack})> _packCareer(
  ProviderContainer c, {
  Future<WorldPack> Function(WorldPack, WorldPackService)? edit,
  int seed = 7,
}) async {
  final packs = c.read(worldPackRepositoryProvider);
  final service = c.read(worldPackServiceProvider);
  final packId = await service.createFromDefault('W');
  var pack = (await packs.load(packId))!;
  if (edit != null) {
    pack = await edit(pack, service);
    await packs.save(packId, pack);
  }
  final career =
      (await c
              .read(careerServiceProvider)
              .create(
                nationId: 1,
                managerName: 'M',
                rngSeed: seed,
                worldPackId: packId,
              ))
          .valueOrNull!;
  return (career: career.id, seed: career.rngSeed, pack: pack);
}

/// [pack] with [nationId]'s pool fixed as [pool].
WorldPack _withPool(WorldPack pack, int nationId, List<PackPlayer> pool) =>
    pack.copyWith(pools: {...pack.pools, nationId: pool});

/// Czechia's generated pool, fixed.
Future<WorldPack> _fixCzechia(WorldPack pack, WorldPackService s) async =>
    _withPool(pack, _czechia, await s.generatedPool(_czechia, pack));

PackPlayer _copy(PackPlayer p, {List<PlayerTrait>? traits}) => PackPlayer(
  id: p.id,
  name: p.name,
  age: p.age,
  position: p.position,
  attributes: p.attributes,
  potential: p.potential,
  club: p.club,
  clubCountry: p.clubCountry,
  traits: traits ?? p.traits,
);

/// A stored fringe player (not a newgen, not pack-made).
bool _storedFringe(Player p) =>
    p.id >= PoolGenerator.firstFringeId && !PlayerLifecycle.isNewgenId(p.id);

List<Object> _row(Player p) => [
  p.name,
  p.age,
  p.attributes.physical,
  p.attributes.technical,
  p.attributes.stamina,
  p.club,
  p.clubCountry,
  p.fixedTraits?.map((t) => t.name).toList() ?? 'random',
];

void main() {
  test(
    'a pool fixed from generatedPool reads back on day one with the same '
    'ids, names, overalls and clubs',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      final w = await _packCareer(c, edit: _fixCzechia);
      final fixed = w.pack.pools[_czechia]!;
      expect(fixed, isNotEmpty);
      for (final p in fixed) {
        expect(p.id, greaterThanOrEqualTo(PoolGenerator.firstFringeId));
        expect(p.traits, isNull);
        expect(p.club, isNotNull);
        final overall = OverallRating.forPosition(p.position, p.attributes);
        expect(p.potential, greaterThanOrEqualTo(overall));
      }
      final players = c.read(playerRepositoryProvider);
      final read = {
        for (final p in await players.byNation(
          _czechia,
          saveSeed: w.seed,
          careerId: w.career,
          minAge: PlayerLifecycle.intakeAge,
        ))
          if (_storedFringe(p)) p.id: p,
      };
      expect(read.keys.toSet(), {for (final p in fixed) p.id});
      for (final p in fixed) {
        final got = read[p.id]!;
        expect(got.name, p.name, reason: '${p.id}');
        expect(got.age, p.age);
        expect(got.attributes, p.attributes);
        expect(
          got.overall,
          OverallRating.forPosition(p.position, p.attributes),
        );
        expect(got.club, p.club);
        expect(got.clubCountry, p.clubCountry ?? '');
        final byId = await players.byId(
          p.id,
          saveSeed: w.seed,
          careerId: w.career,
        );
        expect(byId == null ? null : _row(byId), _row(got));
      }
    },
  );

  test(
    'a removed pool player is gone from byNation and byId',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      late PackPlayer gone;
      final w = await _packCareer(
        c,
        edit: (pack, s) async {
          final pool = await s.generatedPool(_czechia, pack);
          gone = pool.first;
          return _withPool(pack, _czechia, pool.skip(1).toList());
        },
      );
      final players = c.read(playerRepositoryProvider);
      final pool = await players.byNation(
        _czechia,
        saveSeed: w.seed,
        careerId: w.career,
        minAge: PlayerLifecycle.intakeAge,
      );
      expect(pool.map((p) => p.id), isNot(contains(gone.id)));
      expect(
        await players.byId(gone.id, saveSeed: w.seed, careerId: w.career),
        isNull,
      );
      // Everybody kept is still there.
      final ids = {for (final p in pool) p.id};
      for (final p in w.pack.pools[_czechia]!) {
        expect(ids, contains(p.id));
      }
    },
  );

  test(
    'an added pool player (id >= kPackPlayerIdBase) is in byNation and byId',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      const id = kPackPlayerIdBase + 501;
      const added = PackPlayer(
        id: id,
        name: 'Pool Addition',
        age: 22,
        position: PlayerPosition.cm,
        attributes: PlayerAttributes(physical: 66, technical: 70, stamina: 64),
        potential: 78,
        club: 'Klokani Praha',
        clubCountry: 'cze',
        traits: [PlayerTrait.leader],
      );
      final w = await _packCareer(
        c,
        edit: (pack, s) async => _withPool(pack, _czechia, [
          ...await s.generatedPool(_czechia, pack),
          added,
        ]),
      );
      final players = c.read(playerRepositoryProvider);
      final got = (await players.byNation(
        _czechia,
        saveSeed: w.seed,
        careerId: w.career,
      )).where((p) => p.id == id).single;
      expect(got.name, 'Pool Addition');
      expect(got.attributes, added.attributes);
      expect(got.club, 'Klokani Praha');
      expect(got.clubCountry, 'cze');
      // His picked traits replace the roll, as a squad player's do.
      expect(got.fixedTraits, [PlayerTrait.leader]);
      expect(PlayerTraits.of(got), [PlayerTrait.leader]);
      final byId = await players.byId(id, saveSeed: w.seed, careerId: w.career);
      expect(byId?.name, 'Pool Addition');
      expect(byId?.nationId, _czechia);
      expect(byId?.attributes, added.attributes);
      expect(byId?.fixedTraits, [PlayerTrait.leader]);
    },
  );

  test(
    'a stored fringe player given picked traits in a fixed pool carries them',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      late PackPlayer picked;
      final w = await _packCareer(
        c,
        edit: (pack, s) async {
          final pool = await s.generatedPool(_czechia, pack);
          picked = _copy(pool.first, traits: const []);
          return _withPool(pack, _czechia, [picked, ...pool.skip(1)]);
        },
      );
      final players = c.read(playerRepositoryProvider);
      final byId = await players.byId(
        picked.id,
        saveSeed: w.seed,
        careerId: w.career,
      );
      expect(byId?.fixedTraits, isEmpty);
      expect(PlayerTraits.of(byId!), isEmpty);
    },
  );

  test(
    'an untouched pool reads exactly as before',
    timeout: const Timeout.factor(6),
    () async {
      final c = await _world();
      final plain = await _packCareer(c, seed: 31);
      final fixed = await _packCareer(c, seed: 31, edit: _fixCzechia);
      final players = c.read(playerRepositoryProvider);
      Future<Map<String, Object>> snapshot(int career) async {
        final out = <String, Object>{};
        for (final years in [0, 8]) {
          out['senior/$years'] = {
            for (final p in await players.byNation(
              _andorra,
              agingYears: years,
              saveSeed: 31,
              careerId: career,
              minAge: 15,
            ))
              '${p.id}': _row(p),
          };
        }
        final youth = await players.youthByNation(
          _andorra,
          saveSeed: 31,
          careerId: career,
        );
        out['youth'] = {for (final p in youth) '${p.id}': _row(p)};
        final fringe = (await players.byNation(
          _andorra,
          saveSeed: 31,
          careerId: career,
        )).where(_storedFringe).take(5);
        for (final p in fringe) {
          final byId = await players.byId(
            p.id,
            agingYears: 4,
            saveSeed: 31,
            careerId: career,
          );
          out['byId/${p.id}'] = byId == null ? 'none' : _row(byId);
        }
        return out;
      }

      final before = await snapshot(plain.career);
      expect(before['senior/0']! as Map, isNotEmpty);
      expect(before.keys.where((k) => k.startsWith('byId/')), isNotEmpty);
      expect(await snapshot(fixed.career), before);
    },
  );

  test(
    "editing Czechia's squad does not change Czechia's generated pool",
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      final packs = c.read(worldPackRepositoryProvider);
      final service = c.read(worldPackServiceProvider);
      final pack = (await packs.load(await service.createFromDefault('W')))!;
      final squad = pack.squads[_czechia]!;
      final edited = pack.copyWith(
        squads: {
          ...pack.squads,
          _czechia: [
            for (final p in squad.skip(1))
              PackPlayer(
                id: p.id,
                name: 'Renamed ${p.id}',
                age: p.age,
                position: p.position,
                attributes: const PlayerAttributes(
                  physical: 90,
                  technical: 90,
                  stamina: 90,
                ),
                potential: 99,
                club: p.club,
                clubCountry: p.clubCountry,
              ),
          ],
        },
      );
      List<Object?> json(List<PackPlayer> pool) => [
        for (final p in pool) p.toJson(),
      ];
      final generated = await service.generatedPool(_czechia, pack);
      expect(generated, isNotEmpty);
      expect(
        json(await service.generatedPool(_czechia, edited)),
        json(generated),
      );

      // The pack's own name lists are what the pool is drawn from.
      final listed = await service.generatedPool(
        _czechia,
        pack.copyWith(
          nameLists: {
            _czechia: const PackNameLists(first: ['Ota'], sur: ['Pavel']),
          },
        ),
      );
      expect(listed.map((p) => p.name).toSet(), {'Ota Pavel'});
      expect(listed.map((p) => p.id), generated.map((p) => p.id));
    },
  );

  test(
    'newgens still arrive in a nation with a fixed pool',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      final w = await _packCareer(c, edit: _fixCzechia);
      final players = c.read(playerRepositoryProvider);
      final later = await players.byNation(
        _czechia,
        agingYears: 8,
        saveSeed: w.seed,
        careerId: w.career,
      );
      final newgens = later.where((p) => PlayerLifecycle.isNewgenId(p.id));
      expect(newgens, isNotEmpty);
      final youth = await players.youthByNation(
        _czechia,
        saveSeed: w.seed,
        careerId: w.career,
      );
      expect(youth.where((p) => PlayerLifecycle.isNewgenId(p.id)), isNotEmpty);
      // And one is found by id.
      final one = newgens.first;
      final byId = await players.byId(
        one.id,
        agingYears: 8,
        saveSeed: w.seed,
        careerId: w.career,
      );
      expect(byId?.name, one.name);
    },
  );

  test('WorldZoneData.of knows pool players as it knows squad players', () {
    const pooled = PackPlayer(
      id: kPackPlayerIdBase + 9,
      name: 'Pooled',
      age: 19,
      position: PlayerPosition.st,
      attributes: PlayerAttributes(physical: 60, technical: 62, stamina: 58),
      potential: 88,
    );
    final zone = WorldZoneData.of(
      const WorldPack(
        uuid: 'u',
        name: 'n',
        author: '',
        formatVersion: kPackFormatVersion,
        madeWithVersion: '1.1.0',
        pools: {
          _czechia: [pooled],
        },
      ),
    );
    expect(zone.potentials[pooled.id], 88);
    expect(zone.dayOne[pooled.id], (
      age: 19,
      overall: OverallRating.forPosition(pooled.position, pooled.attributes),
    ));
  });
}
