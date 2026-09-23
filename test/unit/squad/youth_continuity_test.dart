import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

import '../../helpers/fixtures.dart';

/// A DIAGNOSTIC before a fix.
///
/// The report was "why is there an intake in the U-17s as well?" — new faces
/// appearing partway up the pyramid rather than only at the bottom. Intake is
/// supposed to happen once, at eleven, and everything above it should be boys
/// who were already there a year younger.
///
/// So this asserts exactly that and nothing else: no generated player may
/// appear for the first time above [PlayerLifecycle.intakeAge]. If it fails,
/// it names the age they are arriving at.
///
/// It PASSED the first time it was run, which is the answer: generation was
/// never the problem. What the manager was seeing was the inbox — two reports
/// arrived each year, "Academy intake" (the eleven-year-olds) and "New faces"
/// (the seventeen-year-olds newly in the senior pool), rendered identically
/// with the same "new" tag and the same scout stars. The second one is boys
/// who came THROUGH this pyramid, and now says so. This test stays as the
/// guard that keeps the underlying model honest.
void main() {
  List<Player> seeded(int nation) => [
    for (var i = 0; i < 25; i++)
      player(id: nation * 1000 + i, nationId: nation, age: 18 + i % 15),
  ];

  test('nobody joins the pyramid above the intake age', () {
    final offenders = <String>[];

    for (var nation = 1; nation <= 6; nation++) {
      final pool = seeded(nation);
      var previous = <int>{};
      for (var year = 0; year <= 10; year++) {
        final youth = PlayerLifecycle.youthPoolAt(pool, nation, year);
        final present = <int>{};
        for (final p in youth) {
          if (!PlayerLifecycle.isNewgenId(p.id)) continue;
          present.add(p.id);
          // Year zero is the backfill: every age is populated at once by
          // definition, so there is nothing to have arrived from.
          if (year == 0) continue;
          if (previous.contains(p.id)) continue;
          if (p.age <= PlayerLifecycle.intakeAge) continue;
          offenders.add('nation $nation, year $year: id ${p.id} at ${p.age}');
        }
        previous = present;
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'these generated players appeared partway up the pyramid instead of '
          'at ${PlayerLifecycle.intakeAge}:\n${offenders.take(20).join('\n')}',
    );
  });
}
