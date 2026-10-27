import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/match/match_conditions.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';

import '../../helpers/fixtures.dart';

// Nation ids as seeded (assets/data/nations.json).
const _argentina = 56;
const _bolivia = 57;
const _colombia = 60;
const _ecuador = 61;
const _england = 14;
const _norway = 39;
const _qatar = 187;

MatchConditions _at(int ground, String city, int month, int home, int away) =>
    MatchConditions.at(
      groundNationId: ground,
      city: city,
      month: month,
      homeNationId: home,
      awayNationId: away,
    );

/// Home win share (%) of an even 80 v 80 in the played engine.
double _engineHomeWins(MatchConditions c, {int n = 1500}) {
  var wins = 0;
  for (var i = 0; i < n; i++) {
    final r = const MatchEngine().play(
      home: ratedTeam(1, 80),
      away: ratedTeam(2, 80),
      rng: SeededRng.forFixture(0xA17, i),
      conditions: c,
    );
    if (r.homeScore > r.awayScore) wins++;
  }
  return 100 * wins / n;
}

/// Home win share (%) of an even 78 v 78 in the background simulator.
double _backgroundHomeWins(MatchConditions c, {int n = 4000}) {
  var wins = 0;
  for (var i = 0; i < n; i++) {
    final r = const RatingMatchSimulator().simulate(
      homeStrength: 78,
      awayStrength: 78,
      rng: SeededRng.forFixture(0xB17, i),
      conditions: c,
    );
    if (r.homeScore > r.awayScore) wins++;
  }
  return 100 * wins / n;
}

void main() {
  final laPaz = _at(_bolivia, 'La Paz', 10, _bolivia, _argentina);
  final laPazEcuador = _at(_bolivia, 'La Paz', 10, _bolivia, _ecuador);
  final quito = _at(_ecuador, 'Quito', 10, _ecuador, _argentina);

  group('the data', () {
    test('the high grounds carry their real altitude', () {
      expect(MatchClimate.altitudeOf(_bolivia, 'La Paz'), 3640);
      expect(MatchClimate.altitudeOf(_ecuador, 'Quito'), 2850);
      expect(MatchClimate.altitudeOf(_colombia, 'Bogotá'), 2640);
      expect(MatchClimate.altitudeOf(88, 'Mexico City'), 2240);
      expect(MatchClimate.altitudeOf(119, 'Addis Ababa'), 2355);
      // Below about a kilometre is sea level, and a name is per country.
      expect(MatchClimate.altitudeOf(_ecuador, 'Guayaquil'), 0);
      expect(MatchClimate.altitudeOf(90, 'León'), 0); // Nicaragua's
      expect(MatchClimate.altitudeOf(88, 'León'), 1815); // Mexico's
    });

    test('Ecuador and Colombia play up in the mountains', () {
      expect(MatchClimate.homeCityOf(_ecuador), 'Quito');
      expect(MatchClimate.homeCityOf(_colombia), 'Bogotá');
      expect(MatchClimate.homeCityOf(_bolivia), 'La Paz');
      expect(MatchClimate.acclimatisedAltitude(_ecuador), 2850);
      expect(MatchClimate.acclimatisedAltitude(_argentina), 0);
    });

    test('the home side at its own altitude pays nothing', () {
      expect(laPaz.homeDrain, 1.0);
      expect(laPaz.awayDrain, greaterThan(1.9));
      // Bolivia, used to more, pays nothing in Quito either.
      expect(_at(_ecuador, 'Quito', 10, _ecuador, _bolivia).awayDrain, 1.0);
    });

    test('an acclimatised visitor pays far less', () {
      expect(laPazEcuador.awayDrain, greaterThan(1.0));
      expect(laPazEcuador.awayDrain - 1, lessThan((laPaz.awayDrain - 1) / 2));
    });

    test('sea level in temperate weather changes nothing at all', () {
      final oslo = _at(_norway, 'Oslo', 6, _norway, _england);
      expect(oslo.homeDrain, 1.0);
      expect(oslo.awayDrain, 1.0);
      expect(oslo.strengthEdge, 0.0);
      expect(oslo.matters, isFalse);
      expect(MatchConditions.none.matters, isFalse);
    });

    test('a June final in Doha is hot, and hotter for the cool side', () {
      final doha = _at(_qatar, 'Doha', 6, _qatar, _england);
      expect(doha.isHot, isTrue);
      expect(doha.temperature, greaterThanOrEqualTo(38));
      expect(doha.homeDrain, greaterThan(1.0));
      expect(doha.awayDrain, greaterThan(doha.homeDrain));
      // Heat is the small one: well under the thin air of La Paz.
      expect(doha.awayDrain - doha.homeDrain, lessThan(0.4));
    });

    test('a tropical ground drains only a side from a cool climate', () {
      // Brazil (58) at home in March: warm, as it always is.
      final v = _at(58, 'São Paulo', 3, 58, _argentina);
      expect(v.homeHeatDrain, 0);
      expect(v.awayHeatDrain, 0); // Argentina's summers are hot too
      expect(v.isHot, isFalse);
      final cold = _at(58, 'São Paulo', 3, 58, _norway);
      expect(cold.homeHeatDrain, 0);
      expect(cold.awayHeatDrain, greaterThan(0));
      expect(cold.isHot, isTrue);
      // A tropical visitor is used to it on a tropical ground (Nigeria, 139).
      expect(_at(58, 'São Paulo', 3, 58, 139).matters, isFalse);
    });

    test('a seasonal climate keeps the month: Doha bites a tropical side', () {
      final june = _at(_qatar, 'Doha', 6, _qatar, 139);
      expect(june.awayHeatDrain, greaterThan(0));
      final march = _at(_qatar, 'Doha', 1, _qatar, _england);
      expect(march.matters, isFalse);
    });

    test('a costless altitude says nothing; a high one says who pays', () {
      // Andorra (2) at 1,023 m: next to nothing for England.
      final andorra = _at(2, 'Andorra la Vella', 10, 2, _england);
      expect(andorra.showsAltitude, isFalse);
      // Bolivia in Quito: high, and nobody pays.
      final quitoBol = _at(_ecuador, 'Quito', 10, _ecuador, _bolivia);
      expect(quitoBol.showsAltitude, isTrue);
      expect(quitoBol.awayFeelsAltitude, isFalse);
      expect(laPaz.awayFeelsAltitude, isTrue);
      expect(laPaz.homeFeelsAltitude, isFalse);
    });

    test('Southern summer is December, not June', () {
      expect(
        MatchClimate.temperatureAt(_argentina, 'Buenos Aires', 1),
        greaterThan(MatchClimate.temperatureAt(_argentina, 'Buenos Aires', 7)),
      );
    });
  });

  group('the played engine', () {
    test('sea level plays exactly as before, goal for goal', () {
      final oslo = _at(_norway, 'Oslo', 6, _norway, _england);
      for (var i = 0; i < 60; i++) {
        final a = const MatchEngine().play(
          home: ratedTeam(1, 80),
          away: ratedTeam(2, 80),
          rng: SeededRng.forFixture(0xC0, i),
        );
        final b = const MatchEngine().play(
          home: ratedTeam(1, 80),
          away: ratedTeam(2, 80),
          rng: SeededRng.forFixture(0xC0, i),
          conditions: oslo,
        );
        expect((b.homeScore, b.awayScore), (a.homeScore, a.awayScore));
        expect(b.energyByPlayer, a.energyByPlayer);
      }
    });

    test('La Paz is a real, not absurd, edge; Ecuador loses less', () {
      final sea = _engineHomeWins(MatchConditions.none);
      final high = _engineHomeWins(laPaz);
      final used = _engineHomeWins(laPazEcuador);
      final q = _engineHomeWins(quito);
      expect(high - sea, inInclusiveRange(7, 15));
      expect(q - sea, inInclusiveRange(3, high - sea));
      expect(used - sea, lessThan((high - sea) / 2));
    });

    test('the visitors fade late, the hosts do not', () {
      final r = const MatchEngine().play(
        home: ratedTeam(1, 80),
        away: ratedTeam(2, 80),
        rng: SeededRng.forFixture(0xC1, 1),
        conditions: laPaz,
      );
      double mean(int nation) {
        final e = [
          for (final x in r.energyByPlayer.entries)
            if (x.key ~/ 100 == nation) x.value,
        ];
        return e.reduce((a, b) => a + b) / e.length;
      }

      expect(mean(2), lessThan(mean(1) - 15));
    });
  });

  group('the background simulator', () {
    test('sea level is untouched', () {
      final oslo = _at(_norway, 'Oslo', 6, _norway, _england);
      for (var i = 0; i < 200; i++) {
        final a = const RatingMatchSimulator().simulate(
          homeStrength: 80,
          awayStrength: 76,
          rng: SeededRng.forFixture(0xD0, i),
        );
        final b = const RatingMatchSimulator().simulate(
          homeStrength: 80,
          awayStrength: 76,
          rng: SeededRng.forFixture(0xD0, i),
          conditions: oslo,
        );
        expect((b.homeScore, b.awayScore), (a.homeScore, a.awayScore));
      }
    });

    test('La Paz swings about as much as in the played engine', () {
      final sea = _backgroundHomeWins(MatchConditions.none);
      final high = _backgroundHomeWins(laPaz);
      final used = _backgroundHomeWins(laPazEcuador);
      expect(high - sea, inInclusiveRange(7, 15));
      expect(used - sea, lessThan((high - sea) / 2));
    });
  });
}
