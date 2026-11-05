import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'match_baseline.dart';

/// The golden checks against `test/fixtures/match_baseline.json`, shared by
/// `match_baseline_test.dart` and the moment tests so the goldens are
/// asserted one way. Kept apart from `match_baseline.dart`, which the capture
/// tool runs outside the test framework.

/// The stored baseline: `figures` and the three goldens.
Map<String, dynamic> loadMatchBaseline() =>
    jsonDecode(File('test/fixtures/match_baseline.json').readAsStringSync())
        as Map<String, dynamic>;

/// The flat golden: [goldenMatches] matches of [goldenPair].
void expectFlatGolden([Map<String, dynamic>? base]) {
  final golden = (base ?? loadMatchBaseline())['golden'] as List;
  expect(golden.length, goldenMatches);
  for (var i = 0; i < goldenMatches; i++) {
    expect(
      jsonDecode(jsonEncode(goldenMatch(i))),
      golden[i],
      reason: 'golden match $i changed',
    );
  }
}

/// The long-throw golden.
void expectLongThrowGolden([Map<String, dynamic>? base]) {
  final golden = (base ?? loadMatchBaseline())['longThrowGolden'] as List;
  expect(golden.length, longThrowGoldenMatches);
  for (var i = 0; i < longThrowGoldenMatches; i++) {
    expect(
      jsonDecode(
        jsonEncode(goldenMatch(i, longThrow: true, seed: longThrowGoldenSeed)),
      ),
      golden[i],
      reason: 'long-throw golden match $i changed',
    );
  }
}

/// The extra-time golden: the same fixtures still go to extra time and play
/// out the same.
void expectExtraTimeGolden([Map<String, dynamic>? base]) {
  final golden = (base ?? loadMatchBaseline())['extraTimeGolden'] as List;
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
}

/// All three goldens.
void expectMatchGoldens() {
  final base = loadMatchBaseline();
  expectFlatGolden(base);
  expectLongThrowGolden(base);
  expectExtraTimeGolden(base);
}
