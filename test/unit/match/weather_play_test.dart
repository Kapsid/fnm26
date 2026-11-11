import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/match/match_conditions.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';
import 'package:fnm/domain/services/match/weather_play.dart';
import 'package:fnm/features/match/conditions_note.dart';
import 'package:fnm/features/match/pitch/pitch_commentary.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../../helpers/fixtures.dart';

/// Weather that plays (release 1.2, workstream B): one weather per fixture,
/// read by the Pitch view, the shown match and the background world alike,
/// and the small effects it has on each.
void main() {
  final l = AppLocalizationsEn();

  group('one weather per fixture', () {
    final f = Fixture(
      id: 4242,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      round: 'QA',
      homeNationId: 14,
      awayNationId: 20,
      date: DateTime(2031, 1, 14),
    );

    test('forFixture is MatchWeather.of at its own kick-off', () {
      for (final seed in [1, 7, 99, 12345, 0xBEEF]) {
        final kickOff = KickOff.forFixture(f, seed);
        expect(
          MatchWeather.forFixture(
            fixture: f,
            code: 'ENG',
            confederation: Confederation.europe,
            saveSeed: seed,
          ),
          MatchWeather.of(
            code: 'ENG',
            confederation: Confederation.europe,
            date: f.date,
            fixtureId: f.id,
            kickOffHours: kickOff.hours,
          ),
        );
      }
    });

    test('a fixture always gets the same weather for the same save', () {
      for (var id = 1; id < 300; id++) {
        final g = f.copyWith(id: id);
        WeatherKind w() => MatchWeather.forFixture(
          fixture: g,
          code: 'SCO',
          confederation: Confederation.europe,
          saveSeed: 77,
        );
        expect(w(), w());
      }
    });

    test('the round decides the kick-off slots as the Pitch view had it', () {
      expect(
        KickOff.competitionOfRound('FRIENDLY'),
        CompetitionKind.friendly,
      );
      expect(
        KickOff.competitionOfRound('FINAL'),
        CompetitionKind.worldCupFinals,
      );
      expect(
        KickOff.competitionOfRound('CGROUP'),
        CompetitionKind.continentalFinals,
      );
      expect(KickOff.competitionOfRound('FFINAL'), CompetitionKind.finalissima);
      expect(
        KickOff.competitionOfRound('QA'),
        CompetitionKind.worldCupQualifying,
      );
    });
  });

  group('what each weather plays as', () {
    test('a clear sky, light rain and a dust storm play as nothing', () {
      for (final w in [
        WeatherKind.clear,
        WeatherKind.rain,
        WeatherKind.dustStorm,
      ]) {
        expect(WeatherPlay.of(w).matters, isFalse, reason: w.name);
        expect(MatchConditions(weather: w).matters, isFalse, reason: w.name);
      }
    });

    test('heavy rain and storms: finishing, long balls, crosses, slips', () {
      for (final w in [WeatherKind.heavyRain, WeatherKind.thunderstorm]) {
        final p = WeatherPlay.of(w);
        expect(p.finishing, lessThan(1));
        expect(p.longBall, lessThan(1));
        expect(p.delivery, lessThan(1));
        expect(p.fouls, greaterThan(1));
        expect(p.tempo, 1);
      }
    });

    test('snow and frost: tempo and passing', () {
      for (final w in [WeatherKind.snow, WeatherKind.frostyNight]) {
        final p = WeatherPlay.of(w);
        expect(p.tempo, lessThan(1));
        expect(p.passing, lessThan(1));
        expect(p.finishing, 1);
      }
    });

    test('a gale: long balls, crosses and long shots', () {
      const p = WeatherPlay.gale;
      expect(p.longBall, lessThan(1));
      expect(p.delivery, lessThan(1));
      expect(p.longRange, lessThan(1));
    });

    test('fog: long shots only', () {
      const p = WeatherPlay.fog;
      expect(p.longRange, lessThan(1));
      expect(p.finishing, 1);
      expect(p.delivery, 1);
      expect(p.tempo, 1);
    });

    test('long range bites the poor chances most', () {
      const p = WeatherPlay.fog;
      expect(p.longRangeOn(0.10), lessThan(p.longRangeOn(0.16)));
      expect(p.longRangeOn(0.16), lessThan(p.longRangeOn(0.25)));
      expect(p.longRangeOn(0.25), lessThan(1));
      expect(WeatherPlay.none.longRangeOn(0.10), 1);
    });

    test('a direct side feels the long-ball factor more', () {
      const p = WeatherPlay.gale;
      expect(p.longBallOn(90), lessThan(p.longBallOn(50)));
      expect(p.longBallOn(50), lessThan(p.longBallOn(10)));
      expect(WeatherPlay.none.longBallOn(90), 1);
    });

    test('a heat haze is a hotter day, read by the heat drain', () {
      // Doha in January: 25 typical, the haze floor makes it 31.
      MatchConditions at(WeatherKind w) => MatchConditions.at(
        groundNationId: 187,
        city: 'Doha',
        month: 1,
        homeNationId: 187,
        awayNationId: 14,
        weather: w,
      );
      final clear = at(WeatherKind.clear);
      final haze = at(WeatherKind.haze);
      expect(clear.isHot, isFalse);
      expect(haze.temperature, MatchConditions.hazeFloor);
      expect(haze.isHot, isTrue);
      // The visitor from a cool climate pays more than the hosts.
      expect(haze.awayDrain, greaterThan(haze.homeDrain));
      // And in summer, hotter than the month already is, not counted twice.
      MatchConditions june(WeatherKind w) => MatchConditions.at(
        groundNationId: 187,
        city: 'Doha',
        month: 6,
        homeNationId: 187,
        awayNationId: 14,
        weather: w,
      );
      expect(
        june(WeatherKind.haze).temperature,
        june(WeatherKind.clear).temperature + MatchConditions.hazeExtraHeat,
      );
      expect(
        june(WeatherKind.haze).awayHeatDrain,
        closeTo(
          june(WeatherKind.clear).awayHeatDrain +
              MatchConditions.heatDrainPerDegree *
                  MatchConditions.hazeExtraHeat,
          1e-9,
        ),
      );
    });
  });

  group('a weather that plays as nothing changes nothing', () {
    test('the engine draws exactly what it drew', () {
      const engine = MatchEngine();
      for (var i = 0; i < 40; i++) {
        String play(MatchConditions c) {
          final r = engine.play(
            home: ratedTeam(1, 78),
            away: ratedTeam(2, 72),
            rng: SeededRng.forFixture(0x5EED, i),
            conditions: c,
          );
          return jsonEncode([
            r.homeScore,
            r.awayScore,
            r.homeShots,
            r.awayShots,
            r.homeXg,
            r.awayXg,
            r.moments.length,
            for (final e in r.events) [e.minute, e.type.name, e.playerId],
          ]);
        }

        final base = play(MatchConditions.none);
        expect(play(const MatchConditions(weather: WeatherKind.rain)), base);
        expect(
          play(const MatchConditions(weather: WeatherKind.dustStorm)),
          base,
        );
      }
    });

    test('the background world plays exactly as it did', () {
      const sim = RatingMatchSimulator();
      for (var seed = 0; seed < 300; seed++) {
        final plain = sim.simulate(
          homeStrength: 60 + seed % 30,
          awayStrength: 85 - seed % 27,
          rng: SeededRng(seed),
        );
        final rain = sim.simulate(
          homeStrength: 60 + seed % 30,
          awayStrength: 85 - seed % 27,
          rng: SeededRng(seed),
          conditions: const MatchConditions(weather: WeatherKind.rain),
        );
        expect(
          (rain.homeScore, rain.awayScore),
          (
            plain.homeScore,
            plain.awayScore,
          ),
        );
      }
    });
  });

  group('the weather is said out loud', () {
    test('the preview names every weather that plays, and only those', () {
      for (final w in WeatherKind.values) {
        final line = ConditionsNote.weatherLine(l, w);
        expect(
          line != null,
          WeatherPlay.of(w).matters || w == WeatherKind.haze,
          reason: w.name,
        );
      }
      final lines = ConditionsNote.linesFor(
        l,
        const MatchConditions(weather: WeatherKind.windy),
        playerIsHome: true,
      );
      expect(lines.map((e) => e.$2), [l.matchWeatherPlaysGale]);
    });

    test('the commentary opens on it', () {
      for (final w in WeatherKind.values) {
        expect(
          pitchKickOffLine(l, w) != null,
          ConditionsNote.weatherLine(l, w) != null,
          reason: w.name,
        );
      }
      expect(pitchKickOffLine(l, WeatherKind.fog), l.pitchComKickOffFog);
    });
  });
}
