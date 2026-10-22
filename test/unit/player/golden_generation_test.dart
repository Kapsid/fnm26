import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/player/golden_generation.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

/// The golden generation behind the Young Finns campaign: a fixed cohort of
/// teenagers that replaces a nation's senior pool in a marked career.
void main() {
  const finland = 17;

  /// A stand-in seeded pool: the cohort's pool keeps the nation's own newgen
  /// intakes, which are anchored on it.
  final seeded = [
    for (var i = 0; i < 30; i++)
      Player(
        id: 1700 + i,
        nationId: finland,
        name: 'Senior $i',
        age: 20 + i % 14,
        position: PlayerPosition.values[i % PlayerPosition.values.length],
        attributes: const PlayerAttributes(
          physical: 70,
          technical: 68,
          stamina: 70,
        ),
      ),
  ];

  test('Finland has a cohort, other nations do not', () {
    expect(GoldenGeneration.hasCohort(finland), isTrue);
    expect(GoldenGeneration.hasCohort(26), isFalse);
    expect(GoldenGeneration.cohort(26), isEmpty);
  });

  test('every member is 15 to 18 at the start, most 17 or 18', () {
    final c = GoldenGeneration.cohort(finland);
    expect(c.length, inInclusiveRange(30, 35));
    expect(c.every((p) => p.age >= 15 && p.age <= 18), isTrue);
    expect(c.where((p) => p.age >= 17).length, greaterThan(c.length * 2 / 3));
    expect(c.every((p) => p.nationId == finland), isTrue);
  });

  test('a full squad in every position, with depth', () {
    final c = GoldenGeneration.cohort(finland);
    int count(PositionCategory cat) =>
        c.where((p) => p.position.category == cat).length;
    expect(count(PositionCategory.goalkeeper), greaterThanOrEqualTo(3));
    expect(count(PositionCategory.defender), greaterThanOrEqualTo(10));
    expect(count(PositionCategory.midfielder), greaterThanOrEqualTo(8));
    expect(count(PositionCategory.forward), greaterThanOrEqualTo(6));
    // Senior-eligible (17+) on day one: still at least two keepers.
    expect(
      c.where((p) => p.age >= 17 && p.position == PlayerPosition.gk).length,
      greaterThanOrEqualTo(2),
    );
  });

  test('deterministic: the same youngsters every time', () {
    final a = GoldenGeneration.cohort(finland);
    final b = GoldenGeneration.cohortUncached(finland);
    expect(b, a);
  });

  test('ids are their own range: not seeded, not newgen, unique', () {
    final c = GoldenGeneration.cohort(finland);
    final ids = {for (final p in c) p.id};
    expect(ids.length, c.length);
    for (final id in ids) {
      expect(GoldenGeneration.isGoldenId(id), isTrue);
      expect(PlayerLifecycle.isNewgenId(id), isFalse);
      expect(id, greaterThan(10100000)); // past the seeded fringe
      expect(GoldenGeneration.nationOf(id), finland);
    }
    expect(GoldenGeneration.isGoldenId(1701), isFalse);
    expect(GoldenGeneration.isGoldenId(10000005), isFalse);
    expect(GoldenGeneration.isGoldenId(1000017001), isFalse); // a newgen
  });

  test('ids stay clear of the staff candidates for a two-hundred-cycle '
      'save', () {
    final staff = <int>{
      for (var cycle = 0; cycle < 200; cycle++)
        for (final role in StaffRole.values)
          for (final c in StaffMarket.forRole(
            saveSeed: 17,
            cycle: cycle,
            role: role,
            namePool: const {
              'fin': ['Aku Ankka', 'Iines Ankka'],
            },
          ))
            c.id,
    };
    final low = GoldenGeneration.idBase;
    expect(staff.every((id) => id < low), isTrue);
    for (final p in GoldenGeneration.cohort(finland)) {
      expect(staff, isNot(contains(p.id)));
    }
  });

  test('high potential, a few stars, not a team of superstars', () {
    final c = GoldenGeneration.cohort(finland);
    final pots = [
      for (final p in c) PlayerLifecycle.developmentPotential(p.id),
    ];
    expect(pots.every((v) => v >= 1.1), isTrue);
    final superstars = c.where((p) => PlayerLifecycle.isSuperstar(p.id)).length;
    expect(superstars, inInclusiveRange(1, 2));
  });

  test('the pool drops every seeded senior and keeps the youth intakes', () {
    final pool = GoldenGeneration.poolAt(seeded, finland, 0);
    expect(
      pool.any((p) => p.id < 10100000 && p.id >= 1700 && p.id < 1730),
      isFalse,
    );
    expect(pool.every((p) => p.age <= 18), isTrue);
    expect(pool.every((p) => p.age >= PlayerLifecycle.seniorMinAge), isTrue);
    final golden = pool.where((p) => GoldenGeneration.isGoldenId(p.id));
    expect(golden.length, greaterThanOrEqualTo(22));
    // The newgens the ordinary pool has at seventeen are still there.
    final normalNewgens = PlayerLifecycle.poolAt(
      seeded,
      finland,
      0,
    ).where((p) => PlayerLifecycle.isNewgenId(p.id)).map((p) => p.id).toSet();
    expect(
      pool
          .where((p) => PlayerLifecycle.isNewgenId(p.id))
          .map((p) => p.id)
          .toSet(),
      normalNewgens,
    );
    // The call-up floor reaches the fifteen-year-olds.
    final callUp = GoldenGeneration.poolAt(
      seeded,
      finland,
      0,
      minAge: PlayerLifecycle.callUpMinAge,
    );
    expect(
      callUp.where((p) => GoldenGeneration.isGoldenId(p.id)).length,
      GoldenGeneration.cohort(finland).length,
    );
  });

  test('they age and grow like anybody: eight years on they are men', () {
    final start = {
      for (final p in GoldenGeneration.poolAt(seeded, finland, 0))
        if (GoldenGeneration.isGoldenId(p.id)) p.id: p,
    };
    final later = {
      for (final p in GoldenGeneration.poolAt(seeded, finland, 8))
        if (GoldenGeneration.isGoldenId(p.id)) p.id: p,
    };
    for (final id in start.keys) {
      expect(later[id]!.age, start[id]!.age + 8);
      expect(later[id]!.overall, greaterThan(start[id]!.overall));
    }
  });

  test('byId resolves a member as the pool reads him, at any year', () {
    final pool = GoldenGeneration.poolAt(seeded, finland, 5);
    final p = pool.firstWhere((p) => GoldenGeneration.isGoldenId(p.id));
    expect(GoldenGeneration.byId(p.id, 5), p);
    expect(GoldenGeneration.byId(1701, 5), isNull);
  });
}
