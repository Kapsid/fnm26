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

  test('the engine still produces the long-throw golden', () {
    final golden = base['longThrowGolden'] as List;
    expect(golden.length, longThrowGoldenMatches);
    for (var i = 0; i < longThrowGoldenMatches; i++) {
      expect(
        jsonDecode(
          jsonEncode(
            goldenMatch(i, longThrow: true, seed: longThrowGoldenSeed),
          ),
        ),
        golden[i],
        reason: 'long-throw golden match $i changed',
      );
    }
  });

  test('the engine still produces the extra-time golden', () {
    final golden = base['extraTimeGolden'] as List;
    expect(golden.length, extraTimeGoldenMatches);
    final indices = extraTimeGoldenIndices();
    for (var k = 0; k < extraTimeGoldenMatches; k++) {
      final i = indices[k];
      expect(
        jsonDecode(jsonEncode({'fixture': i, ...extraTimeGoldenMatch(i)})),
        golden[k],
        reason: 'extra-time golden match $i changed',
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
