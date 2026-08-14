import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

import '../../helpers/fixtures.dart';

/// New faces must arrive at the bottom of the pyramid and grow up through it —
/// a generation that appeared at seventeen, fully formed, would rob the youth
/// levels of the thing that makes them worth watching.
void main() {
  List<Player> seeded() => [
    for (var i = 0; i < 25; i++)
      player(id: i + 1, nationId: 1, age: 20 + i % 12),
  ];

  test('new faces first appear in the youngest bands', () {
    final youth = PlayerLifecycle.youthPoolAt(seeded(), 1, 0);
    final youngest = youth.map((p) => p.age).reduce((a, b) => a < b ? a : b);
    expect(youngest, lessThanOrEqualTo(15));
    expect(youngest, PlayerLifecycle.intakeAge);
  });

  test('the intake-fed bands are populated at every stage of a save', () {
    // U-19 and U-21 are fed by the seeded teenagers as much as by intake, so
    // the bands that prove intake reaches the bottom are the three below them.
    const fromIntake = [YouthLevel.u13, YouthLevel.u15, YouthLevel.u17];
    for (final years in [0, 1, 4]) {
      final youth = PlayerLifecycle.youthPoolAt(seeded(), 1, years);
      for (final level in fromIntake) {
        expect(
          youth.any((p) => YouthLevel.forAge(p.age) == level),
          isTrue,
          reason: '${level.label} should have players in year $years',
        );
      }
    }
  });

  test('a boy generated at intake is the same player four years later', () {
    // The point of the pyramid: players PROGRESS through it. A fresh cohort
    // generated per band would show a different id at every level.
    final young = PlayerLifecycle.youthPoolAt(
      seeded(),
      1,
      0,
    ).where((p) => p.age == PlayerLifecycle.intakeAge).toList();
    expect(young, isNotEmpty);

    final later = PlayerLifecycle.youthPoolAt(seeded(), 1, 4);
    final byId = {for (final p in later) p.id: p};
    // Someone from that cohort is still there, four years older. (Not all of
    // them — the pyramid releases boys who do not make it.)
    final survivors = young.where((p) => byId.containsKey(p.id)).toList();
    expect(survivors, isNotEmpty);
    for (final p in survivors) {
      expect(byId[p.id]!.age, p.age + 4);
    }
  });

  test('the senior pool still starts at seventeen', () {
    // The youth levels are visible on the youth screen; the senior world, the
    // rankings and AI selection do not want thirteen-year-olds in the pool.
    final senior = PlayerLifecycle.poolAt(seeded(), 1, 0);
    expect(senior.every((p) => p.age >= 17), isTrue);
  });
}
