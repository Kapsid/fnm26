import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../helpers/match_baseline.dart';

/// Pins today's engine (before the pitch view): an exact golden of 200 matches
/// and aggregate figures within bands. Regenerate with
/// `dart run tool/capture_match_baseline.dart` only for an intended change.
void main() {
  final base =
      jsonDecode(File('test/fixtures/match_baseline.json').readAsStringSync())
          as Map<String, dynamic>;

  test('the engine still produces the golden', () {
    final golden = base['golden'] as List;
    expect(golden.length, goldenMatches);
    for (var i = 0; i < goldenMatches; i++) {
      expect(
        jsonDecode(jsonEncode(goldenMatch(i))),
        golden[i],
        reason: 'golden match $i changed',
      );
    }
  });

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
      'yellows': (0.08, true),
      'reds': (0.08, true),
      'shots': (0.06, true),
    };
    for (final pair in baselinePairs) {
      for (final neutral in [true, false]) {
        final key = figureKey(pair, neutral);
        final was = figures[key] as Map<String, dynamic>;
        final now = measureCell(pair, neutral: neutral);
        bands.forEach((name, band) {
          final b = was[name];
          if (b == null) return;
          final v = now[name]!;
          final tol = band.$2 ? (b as num).abs() * band.$1 : band.$1;
          expect(
            v,
            closeTo((b as num).toDouble(), tol + 1e-9),
            reason: '$key $name',
          );
        });
      }
    }
  });
}
