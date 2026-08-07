import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/club/club_form.dart';

void main() {
  ClubStanding standing(int id, int overall, {int age = 26, int window = 10}) =>
      ClubForm.standingFor(
        playerId: id,
        overall: overall,
        age: age,
        saveSeed: 4242,
        windowIndex: window,
      );

  /// How often [overall] draws a starting place across a big sample.
  double startingShare(int overall, {int age = 26}) {
    var starts = 0;
    const n = 2000;
    for (var id = 1; id <= n; id++) {
      final s = standing(id, overall, age: age);
      if (s == ClubStanding.firstChoice || s == ClubStanding.rotation) {
        starts++;
      }
    }
    return starts / n;
  }

  group('windowIndexFor', () {
    test('advances once per international window', () {
      final march = ClubForm.windowIndexFor(DateTime(2030, 3, 20));
      final june = ClubForm.windowIndexFor(DateTime(2030, 6, 10));
      final september = ClubForm.windowIndexFor(DateTime(2030, 9, 8));
      expect(june, greaterThan(march));
      expect(september, greaterThan(june));
    });

    test('is stable within a window and rolls over the year', () {
      expect(
        ClubForm.windowIndexFor(DateTime(2030, 6, 3)),
        ClubForm.windowIndexFor(DateTime(2030, 6, 28)),
      );
      expect(
        ClubForm.windowIndexFor(DateTime(2031, 3, 1)),
        greaterThan(ClubForm.windowIndexFor(DateTime(2030, 11, 20))),
      );
    });
  });

  group('standingFor', () {
    test('is deterministic', () {
      expect(standing(77, 80), standing(77, 80));
    });

    test('a player far above his league keeps his place; a marginal one '
        'does not', () {
      // 84 is the floor of tier 1 and 89 sits well inside it — the same
      // league, different standing within it.
      expect(startingShare(89), greaterThan(startingShare(84)));
      expect(startingShare(89), greaterThan(0.8));
    });

    test('a teenager is squeezed out more often than a peak-age player', () {
      expect(startingShare(74, age: 18), lessThan(startingShare(74, age: 27)));
    });

    test('a veteran drifts down too', () {
      expect(startingShare(74, age: 36), lessThan(startingShare(74, age: 27)));
    });

    test('standing moves across windows for a mid-band player', () {
      final seen = <ClubStanding>{};
      for (var w = 0; w < 40; w++) {
        seen.add(standing(501, 75, window: w));
      }
      expect(seen.length, greaterThan(1), reason: 'never moved in ten years');
    });
  });

  group('the deltas', () {
    test('sharpness runs from a lift to a real penalty', () {
      expect(ClubForm.sharpnessDelta(ClubStanding.firstChoice), greaterThan(0));
      expect(ClubForm.sharpnessDelta(ClubStanding.rotation), 0);
      expect(ClubForm.sharpnessDelta(ClubStanding.fringe), lessThan(0));
      expect(
        ClubForm.sharpnessDelta(ClubStanding.frozenOut),
        lessThan(ClubForm.sharpnessDelta(ClubStanding.fringe)),
      );
      // Bounded: this must never on its own make a player unusable.
      expect(ClubForm.sharpnessDelta(ClubStanding.frozenOut), greaterThan(-7));
    });

    test('minutes rise with standing', () {
      expect(
        ClubForm.minutesShare(ClubStanding.firstChoice),
        greaterThan(ClubForm.minutesShare(ClubStanding.rotation)),
      );
      expect(ClubForm.minutesShare(ClubStanding.frozenOut), 0);
    });
  });

  group('yearMinutesFactor', () {
    test('a regular develops faster than a man who never plays', () {
      // Two players at the same rating whose draws differ; compare the
      // extremes of the mapping rather than specific ids.
      var best = 0.0;
      var worst = 2.0;
      for (var id = 1; id <= 500; id++) {
        final f = ClubForm.yearMinutesFactor(
          playerId: id,
          overall: 75,
          age: 26,
          saveSeed: 4242,
          year: 6,
        );
        if (f > best) best = f;
        if (f < worst) worst = f;
      }
      expect(best, greaterThan(worst));
      expect(worst, greaterThan(0.5), reason: 'nobody stops developing');
      expect(best, lessThan(1.5), reason: 'nobody develops at double rate');
    });

    test('THE GUARD: the mean factor across the population is 1.0', () {
      // The senior pool's equilibrium depends on average development being
      // unchanged. If this drifts, every nation in the world slowly inflates
      // or starves.
      var sum = 0.0;
      var n = 0;
      for (var overall = 55; overall <= 90; overall += 5) {
        for (var age = 18; age <= 34; age += 2) {
          for (var id = 1; id <= 400; id++) {
            sum += ClubForm.yearMinutesFactor(
              playerId: id,
              overall: overall,
              age: age,
              saveSeed: 4242,
              year: 6,
            );
            n++;
          }
        }
      }
      expect(sum / n, closeTo(1.0, 0.05));
    });
  });
}
