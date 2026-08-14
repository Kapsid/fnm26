import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/competition/real_history.dart';

int _lastYearOf(String competition) => RealHistory.editions
    .where((e) => e.competition == competition)
    .map((e) => e.year)
    .reduce((a, b) => a > b ? a : b);

void main() {
  test('the North America Cup record runs to the present', () {
    expect(
      _lastYearOf(RealHistory.northAmericaCup),
      greaterThanOrEqualTo(2025),
    );
  });

  test('the North America Cup runs biennially in odd years', () {
    final years =
        RealHistory.editions
            .where((e) => e.competition == RealHistory.northAmericaCup)
            .map((e) => e.year)
            .toList()
          ..sort();
    // A gap at 2024 is the tournament's cadence, not missing data.
    for (final y in years) {
      expect(y.isOdd, isTrue, reason: '$y is not an odd year');
    }
    for (var i = 1; i < years.length; i++) {
      expect(years[i] - years[i - 1], 2);
    }
  });

  test('every edition names a champion and a runner-up', () {
    for (final e in RealHistory.editions) {
      expect(e.champion, isNotEmpty, reason: '${e.competition} ${e.year}');
      expect(e.runnerUp, isNotEmpty, reason: '${e.competition} ${e.year}');
    }
  });
}
