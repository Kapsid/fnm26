import 'package:flutter_test/flutter_test.dart';

import '../../helpers/match_baseline.dart';
import '../../helpers/match_goldens.dart';

/// Pins the engine: exact goldens (200 flat matches, 50 with long throws, 30
/// that go to extra time) and aggregate figures within bands.
///
/// The figures are the engine as it was before the pitch view, and stay the
/// reference: a recalibrated engine must land inside the bands around them.
/// The goldens follow intended outcome changes: regenerate them with
/// `dart run tool/capture_match_baseline.dart --goldens-only`, which keeps the
/// figures. Without the flag the tool re-measures the figures too.
void main() {
  final base = loadMatchBaseline();

  test('the engine still produces the golden', () => expectFlatGolden(base));

  test(
    'the engine still produces the long-throw golden',
    () => expectLongThrowGolden(base),
  );

  test(
    'the engine still produces the extra-time golden',
    () => expectExtraTimeGolden(base),
  );

  test('figures stay near baseline', () {
    final figures = base['figures'] as Map<String, dynamic>;
    // key -> allowed delta (relative if rel, else absolute share points).
    const bands = <String, (double, bool)>{
      'goals': (0.04, true),
      'homeWin': (0.03, false),
      'draw': (0.03, false),
      'awayWin': (0.03, false),
      'favouriteWin': (0.03, false),
      'penaltyGoalShare': (0.015, false),
      'longThrowGoalShare': (0.015, false),
      'yellows': (0.08, true),
      'reds': (0.08, true),
      'shots': (0.06, true),
    };
    void check(
      String key,
      Map<String, dynamic> was,
      Map<String, double?> now,
    ) {
      bands.forEach((name, band) {
        final b = was[name];
        if (b == null) return;
        final tol = band.$2 ? (b as num).abs() * band.$1 : band.$1;
        expect(
          now[name]!,
          closeTo((b as num).toDouble(), tol + 1e-9),
          reason: '$key $name',
        );
      });
    }

    for (final pair in baselinePairs) {
      for (final neutral in [true, false]) {
        final key = figureKey(pair, neutral);
        final was = figures[key] as Map<String, dynamic>;
        final now = measureCell(pair, neutral: neutral);
        check(key, was, now);
      }
    }
    final was = figures[longThrowKey] as Map<String, dynamic>;
    expect(was['longThrowGoalShare'] as num, greaterThan(0));
    check(
      longThrowKey,
      was,
      measureCell(longThrowPair, neutral: false, longThrow: true),
    );
  });
}
