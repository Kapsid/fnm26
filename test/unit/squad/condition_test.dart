import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/club/club_form.dart';
import 'package:fnm/domain/services/squad/condition.dart';

Fixture result({
  required int id,
  required int home,
  required int away,
  required int hs,
  required int as,
  required DateTime date,
  String? round,
}) => Fixture(
  id: id,
  careerId: 1,
  competitionId: 1,
  matchday: 1,
  date: date,
  homeNationId: home,
  awayNationId: away,
  homeScore: hs,
  awayScore: as,
  round: round,
  played: true,
);

void main() {
  group('Condition.form', () {
    test('a hot streak reads as on fire with a positive delta', () {
      final f = Condition.form([8.2, 7.9, 8.0, 7.6, 7.8]);
      expect(f.state, PlayerForm.onFire);
      expect(f.delta, greaterThan(0));
    });

    test('a cold run reads as cold with a negative delta', () {
      final f = Condition.form([5.4, 5.8, 5.2, 6.0, 5.5]);
      expect(f.state, PlayerForm.cold);
      expect(f.delta, lessThan(0));
    });

    test('too few games is steady with no delta', () {
      final f = Condition.form([8.5]);
      expect(f.state, PlayerForm.steady);
      expect(f.delta, 0);
    });
  });

  group('Condition.fatigue', () {
    final asOf = DateTime(2030, 6, 20);

    test('a rested player is fresh', () {
      final f = Condition.fatigue([DateTime(2030, 5, 1)], asOf);
      expect(f.state, FatigueState.fresh);
      expect(f.delta, 0);
    });

    test('a heavy tournament load exhausts a player', () {
      final dates = [
        DateTime(2030, 6, 18),
        DateTime(2030, 6, 15),
        DateTime(2030, 6, 12),
        DateTime(2030, 6, 9),
        DateTime(2030, 6, 8),
      ];
      final f = Condition.fatigue(dates, asOf);
      expect(f.games, 5);
      expect(f.state, FatigueState.exhausted);
      expect(f.delta, lessThan(0));
    });

    test('games outside the window do not count', () {
      final f = Condition.fatigue([DateTime(2030, 1, 1)], asOf);
      expect(f.games, 0);
    });
  });

  group('Condition.morale', () {
    test('recent wins lift morale above neutral', () {
      final wins = [
        result(id: 1, home: 1, away: 2, hs: 3, as: 0, date: DateTime(2030, 6)),
        result(id: 2, home: 2, away: 1, hs: 0, as: 2, date: DateTime(2030, 5)),
      ];
      expect(Condition.morale(wins, 1), greaterThan(50));
    });

    test('recent defeats drag morale below neutral', () {
      final losses = [
        result(id: 1, home: 1, away: 2, hs: 0, as: 3, date: DateTime(2030, 6)),
        result(id: 2, home: 2, away: 1, hs: 4, as: 1, date: DateTime(2030, 5)),
      ];
      expect(Condition.morale(losses, 1), lessThan(50));
    });

    test('no results is neutral', () {
      expect(Condition.morale(const [], 1), 50);
    });
  });

  group('club sharpness', () {
    test('a frozen-out player is rated below a sharp one', () {
      final sharp = Condition.of(
        const [],
        const [],
        DateTime(2030),
        0,
        clubDelta: ClubForm.sharpnessDelta(ClubStanding.firstChoice),
      );
      final rusty = Condition.of(
        const [],
        const [],
        DateTime(2030),
        0,
        clubDelta: ClubForm.sharpnessDelta(ClubStanding.frozenOut),
      );
      expect(rusty.overallDelta, lessThan(sharp.overallDelta));
    });

    test('the combined delta still respects its clamp', () {
      // Poor form, exhausted, frozen out, low morale: bad, but never beyond
      // the bound the match engine is tuned against.
      final worst = Condition.of(
        const [3.0, 3.0, 3.0, 3.0, 3.0],
        [for (var i = 0; i < 6; i++) DateTime(2030, 6, 10 + i)],
        DateTime(2030, 6, 16),
        -3,
        clubDelta: ClubForm.sharpnessDelta(ClubStanding.frozenOut),
      );
      expect(worst.overallDelta, greaterThanOrEqualTo(-9));
      expect(worst.overallDelta, lessThanOrEqualTo(6));
    });

    test('no club delta leaves the old behaviour exactly', () {
      final before = Condition.of(
        const [7.0, 7.0],
        const [],
        DateTime(2030),
        0,
      );
      final after = Condition.of(
        const [7.0, 7.0],
        const [],
        DateTime(2030),
        0,
        clubDelta: 0,
      );
      expect(after.overallDelta, before.overallDelta);
    });
  });
}
