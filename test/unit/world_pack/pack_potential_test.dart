import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

const _andorra = 2;

Future<ProviderContainer> _world() async {
  final db = createTestDatabase();
  addTearDown(db.close);
  final c = greenlandContainer(db);
  addTearDown(c.dispose);
  await c.read(seedLoaderProvider).ensureSeeded();
  return c;
}

/// A career on a new pack from the default world, edited by [edit].
Future<({int career, WorldPack pack})> _packCareer(
  ProviderContainer c,
  WorldPack Function(WorldPack) edit,
) async {
  final packs = c.read(worldPackRepositoryProvider);
  final packId = await c.read(worldPackServiceProvider).createFromDefault('W');
  final pack = edit((await packs.load(packId))!);
  await packs.save(packId, pack);
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
  return (career: career.id, pack: pack);
}

/// [pack] with player [id] of [nationId] replaced by [change] of him.
WorldPack _edit(
  WorldPack pack,
  int nationId,
  int id,
  PackPlayer Function(PackPlayer) change,
) => pack.copyWith(
  squads: {
    ...pack.squads,
    nationId: [
      for (final p in pack.squads[nationId]!)
        if (p.id == id) change(p) else p,
    ],
  },
);

PackPlayer _set(
  PackPlayer p, {
  required int age,
  required PlayerAttributes attributes,
  required int potential,
}) => PackPlayer(
  id: p.id,
  name: p.name,
  age: age,
  position: p.position,
  attributes: attributes,
  potential: potential,
  club: p.club,
  clubCountry: p.clubCountry,
);

PlayerAttributes _flat(int v) =>
    PlayerAttributes(physical: v, technical: v, stamina: v);

void main() {
  group('WorldZone', () {
    test('inactive outside a zone, carried across awaits inside one', () async {
      expect(WorldZone.active, isFalse);
      expect(WorldZone.potentialOf(5), isNull);
      final seen = await WorldZone.run({5: 80}, () async {
        await Future<void>.delayed(Duration.zero);
        return (WorldZone.active, WorldZone.potentialOf(5));
      });
      expect(seen, (true, 80));
      expect(WorldZone.active, isFalse);
    });

    test('no hidden superstars in a pack zone; default unchanged', () {
      var star = 1;
      while (!PlayerLifecycle.isSuperstar(star)) {
        star++;
      }
      expect(PlayerLifecycle.isSuperstar(star), isTrue);
      expect(
        WorldZone.run(const {}, () => PlayerLifecycle.isSuperstar(star)),
        isFalse,
      );
    });

    test('pack growth multiplier is linear in the gap to potential', () {
      double mult(int overall) => WorldZone.run(
        {9: 80},
        () => PlayerLifecycle.developmentPotential(9, overall: overall),
      );
      expect(mult(80), closeTo(0.35, 1e-9));
      expect(mult(65), closeTo(1.05, 1e-9));
      expect(mult(50), closeTo(1.75, 1e-9));
      expect(mult(20), closeTo(1.75, 1e-9));
    });

    test('prospect stars read the edited headroom', () {
      int stars(int overall, int potential) => WorldZone.run(
        {9: potential},
        () => Prospects.trueStars(9, age: 19),
        dayOne: {9: (age: 19, overall: overall)},
      );
      expect(stars(65, 95), 5);
      expect(stars(70, 70), 1);
    });
  });

  group('pack career', () {
    test(
      'potential 90 for an 19-year-old 70: reaches 86..90 by 27 with full '
      'minutes, never above 90',
      timeout: const Timeout.factor(4),
      () async {
        final c = await _world();
        late int id;
        final w = await _packCareer(c, (pack) {
          id = pack.squads[_andorra]!.first.id;
          return _edit(
            pack,
            _andorra,
            id,
            (p) => _set(p, age: 19, attributes: _flat(70), potential: 90),
          );
        });
        final players = c.read(playerRepositoryProvider);
        Future<Player> at(int years) async => (await players.byId(
          id,
          agingYears: years,
          careerId: w.career,
          careerStartsByPlayer: {id: years * 6},
        ))!;
        expect((await at(0)).overall, 70);
        final peak = (await at(8)).overall;
        expect(peak, inInclusiveRange(86, 90));
        for (var y = 0; y <= 16; y++) {
          expect((await at(y)).overall, lessThanOrEqualTo(90), reason: '$y');
        }
      },
    );

    test(
      'potential equal to overall: stays within 1 of it until decline',
      timeout: const Timeout.factor(4),
      () async {
        final c = await _world();
        late int id;
        final w = await _packCareer(c, (pack) {
          id = pack.squads[_andorra]!.first.id;
          return _edit(
            pack,
            _andorra,
            id,
            (p) => _set(p, age: 22, attributes: _flat(75), potential: 75),
          );
        });
        final players = c.read(playerRepositoryProvider);
        for (var y = 0; y <= 6; y++) {
          final p = (await players.byId(
            id,
            agingYears: y,
            careerId: w.career,
            careerStartsByPlayer: {id: y * 6},
          ))!;
          expect(p.overall, inInclusiveRange(74, 75), reason: 'age ${p.age}');
        }
      },
    );

    test(
      'a default-superstar id plays at the edited overall in a pack career',
      timeout: const Timeout.factor(4),
      () async {
        final c = await _world();
        late int id;
        late int nation;
        final w = await _packCareer(c, (pack) {
          final hit = [
            for (final e in pack.squads.entries)
              for (final p in e.value)
                if (PlayerLifecycle.isSuperstar(p.id)) (e.key, p.id),
          ].first;
          (nation, id) = hit;
          return _edit(
            pack,
            nation,
            id,
            (p) => _set(p, age: 26, attributes: _flat(60), potential: 60),
          );
        });
        final players = c.read(playerRepositoryProvider);
        final byId = await players.byId(id, careerId: w.career);
        expect(byId!.overall, 60);
        final inPool = (await players.byNation(
          nation,
          careerId: w.career,
        )).firstWhere((p) => p.id == id);
        expect(inPool.overall, 60);
        // And no lift later either.
        final later = await players.byId(id, agingYears: 3, careerId: w.career);
        expect(later!.overall, lessThanOrEqualTo(60));
      },
    );

    test(
      'a young player edited above 95 plays at the edited strength',
      timeout: const Timeout.factor(4),
      () async {
        final c = await _world();
        late int id;
        const attrs = PlayerAttributes(
          physical: 97,
          technical: 98,
          stamina: 96,
        );
        final w = await _packCareer(c, (pack) {
          id = pack.squads[_andorra]!.first.id;
          return _edit(
            pack,
            _andorra,
            id,
            (p) => _set(p, age: 19, attributes: attrs, potential: 99),
          );
        });
        final players = c.read(playerRepositoryProvider);
        final p = await players.byId(id, careerId: w.career);
        expect(p!.attributes, attrs);
        final youth = (await players.youthByNation(
          _andorra,
          careerId: w.career,
        )).firstWhere((x) => x.id == id);
        expect(youth.attributes, attrs);
      },
    );
  });
}
