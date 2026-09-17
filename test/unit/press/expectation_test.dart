import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/expectation.dart';

/// The same scoreline is not the same story.
///
/// The world used to read a result off the scoreline and a ±25 ranking gap, so
/// a sixtieth-ranked side holding the champions and a favourite scraping past
/// a minnow drew identical coverage. Everything the press and the feed now say
/// hangs off this reading, so it is worth pinning hard.
void main() {
  const giant = 2;
  const decent = 30;
  const minnow = 120;

  ResultStanding read(
    int us,
    int them,
    int scored,
    int conceded, {
    bool competitive = true,
  }) => Expectation.standing(
    nationRank: us,
    opponentRank: them,
    scored: scored,
    conceded: conceded,
    competitive: competitive,
  );

  group('a minnow against a giant', () {
    test('winning is heroic', () {
      expect(read(minnow, giant, 1, 0), ResultStanding.heroic);
    });

    test('drawing is creditable, not merely par', () {
      expect(read(minnow, giant, 1, 1), ResultStanding.creditable);
    });

    test('losing narrowly is par — that was always going to happen', () {
      expect(read(minnow, giant, 0, 1), ResultStanding.par);
    });

    test('being taken apart is still only par', () {
      // Nobody is disgraced by losing 4-0 to the best side in the world. The
      // margin counts for less the more of it the form book predicted.
      expect(read(minnow, giant, 0, 4), ResultStanding.par);
    });
  });

  group('a giant against a minnow', () {
    test('winning is par — it is the job', () {
      expect(read(giant, minnow, 2, 0), ResultStanding.par);
    });

    test('a rout is still par — running up the score is the job too', () {
      // The margin earns nothing it was always going to earn. Undamped this
      // read as "creditable", which said a favourite deserves credit for
      // beating a minnow heavily.
      expect(read(giant, minnow, 5, 0), ResultStanding.par);
    });

    test('drawing is poor', () {
      expect(read(giant, minnow, 1, 1), ResultStanding.poor);
    });

    test('losing is a humiliation', () {
      expect(read(giant, minnow, 0, 1), ResultStanding.humiliating);
    });
  });

  group('two of a kind', () {
    test('a win is creditable', () {
      expect(read(decent, decent, 1, 0), ResultStanding.creditable);
    });

    test('a draw is par', () {
      expect(read(decent, decent, 1, 1), ResultStanding.par);
    });

    test('a defeat is poor', () {
      expect(read(decent, decent, 0, 1), ResultStanding.poor);
    });

    test('a hammering between equals is a humiliation', () {
      // Here the margin is unexpected, so it counts in full.
      expect(read(decent, decent, 0, 4), ResultStanding.humiliating);
    });
  });

  test('the same scoreline reads differently by who got it', () {
    // The whole point, in one assertion.
    expect(
      read(minnow, giant, 1, 1),
      isNot(read(giant, minnow, 1, 1)),
      reason:
          'a draw is a triumph for one of these sides and a crisis for the '
          'other',
    );
  });

  test('a friendly is not evidence', () {
    // Same result, damped: a summer runaround is neither a coronation nor a
    // crisis.
    final competitive = read(giant, minnow, 0, 1);
    final friendly = read(giant, minnow, 0, 1, competitive: false);
    expect(competitive, ResultStanding.humiliating);
    expect(
      Expectation.weight(friendly),
      greaterThan(Expectation.weight(competitive)),
      reason: 'losing a friendly to a minnow is embarrassing, not fatal',
    );
  });

  test('expectation is symmetric about an even tie', () {
    final up = Expectation.of(nationRank: minnow, opponentRank: giant);
    final down = Expectation.of(nationRank: giant, opponentRank: minnow);
    expect(up, closeTo(-down, 0.0001));
    expect(Expectation.of(nationRank: decent, opponentRank: decent), 0);
  });

  test('expectation saturates rather than running away', () {
    // A 200-place gap is not twice as certain as a 100-place one.
    expect(Expectation.of(nationRank: 1, opponentRank: 209), 1.0);
    expect(Expectation.of(nationRank: 209, opponentRank: 1), -1.0);
  });

  test('only the extremes are loud', () {
    expect(Expectation.isLoud(ResultStanding.heroic), isTrue);
    expect(Expectation.isLoud(ResultStanding.humiliating), isTrue);
    for (final quiet in [
      ResultStanding.creditable,
      ResultStanding.par,
      ResultStanding.poor,
    ]) {
      expect(Expectation.isLoud(quiet), isFalse, reason: quiet.name);
    }
  });
}
