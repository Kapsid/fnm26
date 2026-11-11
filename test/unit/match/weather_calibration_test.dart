@Tags(['slow'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/match/match_conditions.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';
import 'package:fnm/domain/services/match/weather_play.dart';

import '../../helpers/fixtures.dart';

/// The calibration bar for weather that plays (release 1.2, B): no weather
/// moves the average goals a match by more than about 3% against today (a
/// clear sky, which plays exactly as every match did before 1.2), the
/// world's mix of weathers moves it by less, and the background simulator
/// loses what the played engine loses, so a skipped match and a watched one
/// agree in expectation.
///
/// Paired seeds: the same fixtures are played in clear skies and in each
/// weather, so the difference is measured, not the noise.
///
/// Measured 2026-11-11 (2000 paired engine matches a cell, the change in
/// goals a match against the same fixtures in clear skies):
///
///   weather        75 v 75   80 v 70
///   heavy rain     -2.8%     -2.6%
///   snow / frost   -2.3%     -2.1%
///   gale           -2.7%     -2.4%
///   fog            -2.3%     -1.8%
///   heat haze      +0.1% (Doha in January: through the heat drain)
///
/// The world's mix of weathers (78.8% clear, 10.9% light rain) moves goals
/// about -0.2% overall.
void main() {
  const engine = MatchEngine();
  const sim = RatingMatchSimulator();
  const n = 2000;
  const bgN = 20000;
  const seed = 0xC0FFEE;

  double engineGoals((int, int) pair, MatchConditions c) {
    var goals = 0;
    for (var i = 0; i < n; i++) {
      final r = engine.play(
        home: ratedTeam(1, pair.$1),
        away: ratedTeam(2, pair.$2),
        rng: SeededRng.forFixture(seed, i),
        conditions: c,
      );
      goals += r.homeScore + r.awayScore;
    }
    return goals / n;
  }

  double backgroundGoals((int, int) pair, MatchConditions c) {
    var goals = 0;
    for (var i = 0; i < bgN; i++) {
      final o = sim.simulate(
        homeStrength: pair.$1,
        awayStrength: pair.$2,
        rng: SeededRng.forFixture(seed, i),
        conditions: c,
      );
      goals += o.homeScore + o.awayScore;
    }
    return goals / bgN;
  }

  // The weathers that play, one of each kind of effect (a thunderstorm plays
  // as heavy rain, a frosty night as snow).
  const playing = [
    WeatherKind.heavyRain,
    WeatherKind.snow,
    WeatherKind.windy,
    WeatherKind.fog,
  ];

  final engineRatio = <WeatherKind, double>{};

  for (final pair in const [(75, 75), (80, 70)]) {
    group('$pair', () {
      final clear = engineGoals(pair, MatchConditions.none);
      final bgClear = backgroundGoals(pair, MatchConditions.none);
      for (final w in playing) {
        test('${w.name}: within the bar, and the background agrees', () {
          final c = MatchConditions(weather: w);
          final ratio = engineGoals(pair, c) / clear;
          final bgRatio = backgroundGoals(pair, c) / bgClear;
          engineRatio[w] = ratio;
          // The measured figures, for the calibration record.
          // ignore: avoid_print
          print(
            '$pair ${w.name}: engine ${(100 * (ratio - 1)).toStringAsFixed(2)}%'
            ' background ${(100 * (bgRatio - 1)).toStringAsFixed(2)}%',
          );
          expect(ratio, lessThan(1), reason: 'the weather plays');
          expect(ratio, greaterThan(0.97), reason: 'the 3% bar');
          expect(bgRatio, closeTo(ratio, 0.012), reason: 'in expectation');
          expect(
            WeatherPlay.of(w).backgroundGoals,
            closeTo(ratio, 0.012),
            reason: 'backgroundGoals is the measured engine ratio',
          );
        });
      }
    });
  }

  test('a heat haze: within the bar, and the background agrees', () {
    // England visiting Qatar in January: 25°C on a clear day, a hazy one
    // plays at the haze floor, and the visitors' legs pay for it.
    MatchConditions doha(WeatherKind w) => MatchConditions.at(
      groundNationId: 187,
      city: 'Doha',
      month: 1,
      homeNationId: 187,
      awayNationId: 14,
      weather: w,
    );
    const pair = (75, 75);
    final ratio =
        engineGoals(pair, doha(WeatherKind.haze)) /
        engineGoals(pair, doha(WeatherKind.clear));
    final bgRatio =
        backgroundGoals(pair, doha(WeatherKind.haze)) /
        backgroundGoals(pair, doha(WeatherKind.clear));
    // The measured figures, for the calibration record.
    // ignore: avoid_print
    print(
      'haze: engine ${(100 * (ratio - 1)).toStringAsFixed(2)}% '
      'background ${(100 * (bgRatio - 1)).toStringAsFixed(2)}%',
    );
    expect(ratio, closeTo(1, 0.03));
    expect(bgRatio, closeTo(1, 0.03));
    expect(doha(WeatherKind.haze).awayDrain, greaterThan(1));
  });

  test("the world's mix of weathers moves goals by well under the bar", () {
    // Every nation's ground, every month, a spread of fixtures: the share of
    // each weather the world plays in.
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List)
            .cast<Map<String, Object?>>();
    final count = {for (final w in WeatherKind.values) w: 0};
    var total = 0;
    for (final nation in nations) {
      final code = nation['code']! as String;
      final conf = Confederation.values.byName(
        nation['confederation']! as String,
      );
      for (var m = 1; m <= 12; m++) {
        for (var k = 0; k < 6; k++) {
          final id = (nation['id']! as int) * 1000 + m * 10 + k;
          final w = MatchWeather.forFixture(
            fixture: Fixture(
              id: id,
              careerId: 1,
              competitionId: 1,
              matchday: 1,
              round: 'QA',
              date: DateTime(2031, m, 3 + 4 * k),
              homeNationId: 1,
              awayNationId: 2,
            ),
            code: code,
            confederation: conf,
            saveSeed: 7,
          );
          count[w] = count[w]! + 1;
          total++;
        }
      }
    }
    double ratioOf(WeatherKind w) => switch (WeatherPlay.of(w)) {
      final p when !p.matters => 1.0,
      final p => p.backgroundGoals,
    };
    var overall = 0.0;
    for (final w in WeatherKind.values) {
      overall += count[w]! / total * ratioOf(w);
    }
    // The measured figures, for the calibration record.
    // ignore: avoid_print
    print(
      'world mix: ${{for (final w in WeatherKind.values) w.name: (100 * count[w]! / total).toStringAsFixed(1)}} '
      'overall ${(100 * (overall - 1)).toStringAsFixed(2)}%',
    );
    expect(overall, lessThan(1));
    expect(overall, greaterThan(0.99));
  });
}
