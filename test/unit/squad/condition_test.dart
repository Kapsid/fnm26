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
        DateTime(2030, 6, 7),
      ];
      final f = Condition.fatigue(dates, asOf);
      expect(f.games, 6);
      expect(f.state, FatigueState.exhausted);
      expect(f.delta, lessThan(0));
    });

    test('two games in a fortnight is just football', () {
      final f = Condition.fatigue([
        DateTime(2030, 6, 17),
        DateTime(2030, 6, 13),
      ], asOf);
      expect(f.state, FatigueState.fresh);
      expect(f.delta, 0);
    });

    test('a starter rested once in a tournament is not tired', () {
      // Games every four days; he sat out the last one.
      final f = Condition.fatigue([
        DateTime(2030, 6, 12),
        DateTime(2030, 6, 8),
      ], asOf);
      expect(f.state, FatigueState.fresh);
    });

    test('an eleven played straight through a three-day run tires', () {
      final f = Condition.fatigue([
        DateTime(2030, 6, 17),
        DateTime(2030, 6, 14),
        DateTime(2030, 6, 11),
        DateTime(2030, 6, 8),
      ], asOf);
      expect(f.state, FatigueState.tired);
      expect(f.delta, lessThan(0));
    });

    test('games outside the window do not count', () {
      final f = Condition.fatigue([DateTime(2030, 1, 1)], asOf);
      expect(f.games, 0);
    });
  });

  group('Condition.weightedFatigue (spaced finals)', () {
    final asOf = DateTime(2030, 6, 20);
    List<DateTime> every(int days, int games) => [
      for (var i = 1; i <= games; i++) asOf.subtract(Duration(days: days * i)),
    ];
    ({FatigueState state, int games, int delta}) w(
      List<DateTime> dates, {
      double travel = 1,
    }) => Condition.fatigue(
      dates,
      asOf,
      weighted: true,
      travelFatigue: travel,
    );

    test('an appearance weighs by the days since it', () {
      expect(Condition.appearanceWeightTenths(0), 10);
      expect(Condition.appearanceWeightTenths(3), 10);
      expect(Condition.appearanceWeightTenths(4), 6);
      expect(Condition.appearanceWeightTenths(5), 6);
      expect(Condition.appearanceWeightTenths(6), 3);
      expect(Condition.appearanceWeightTenths(9), 3);
      expect(Condition.appearanceWeightTenths(10), 0);
    });

    test('a normal tournament rhythm (every four or five days) is fit', () {
      expect(w(every(4, 6)).delta, 0);
      expect(w(every(5, 6)).delta, 0);
      expect(w(every(6, 6)).state, FatigueState.fresh);
    });

    test('a window double-header is fit for its second game', () {
      expect(w(every(3, 1)).state, FatigueState.fresh);
    });

    test('a three-day run tires, and congestion exhausts', () {
      // The third game of a three-day window: 1.0 + 0.3.
      expect(w(every(3, 2)).state, FatigueState.ready);
      // Straight through a three-day run: 1.0 + 0.3 + 0.3.
      expect(w(every(3, 5)).state, FatigueState.tired);
      // Every other day: 1.0 + 0.6 + 0.3 + 0.3.
      expect(w(every(2, 6)).delta, lessThanOrEqualTo(-4));
      expect(
        w([asOf, ...every(1, 3), ...every(2, 4)]).state,
        FatigueState.exhausted,
      );
    });

    test('one match off in a tournament clears it', () {
      // Played every four days, rested for the last one.
      final dates = [
        for (var i = 2; i <= 6; i++) asOf.subtract(Duration(days: 4 * i)),
      ];
      expect(w(dates).state, FatigueState.fresh);
    });

    test('the base camp scales the weighted load', () {
      // 1.3 on the road (1.12) reads 1.5: tired rather than ready.
      final dates = every(3, 2);
      expect(w(dates).state, FatigueState.ready);
      expect(w(dates, travel: 1.12).state, FatigueState.tired);
      // And a city camp (0.88) brings a 1.6 run back under 1.5.
      final run = every(3, 5);
      expect(w(run).state, FatigueState.tired);
      expect(w(run, travel: 0.88).state, FatigueState.ready);
    });

    test('a later appearance is ignored', () {
      expect(w([asOf.add(const Duration(days: 1))]).games, 0);
    });

    test('Condition.of reads it only when asked', () {
      final dates = every(4, 5); // 0.9: fresh weighted, tired by count
      final weighted = Condition.of(const [], dates, asOf, 0, weighted: true);
      final counted = Condition.of(const [], dates, asOf, 0);
      expect(weighted.fatigueState, FatigueState.fresh);
      expect(counted.fatigueState, FatigueState.ready);
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
