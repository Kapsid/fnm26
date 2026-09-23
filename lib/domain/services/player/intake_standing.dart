import 'package:fnm/domain/services/ranking/elo.dart';

/// The talent bonus a nation's intake earns from how the senior side is doing:
/// where it sits in the world, how far it has moved, and what it has just won.
/// Added to the academy's own bonus, never replacing it.
///
/// A rising national team is a magnet. The best athletes in the country pick
/// football over the other sports, the good ones get taken seriously by bigger
/// clubs earlier, and the next generation arrives better than the last. A side
/// sliding out of the reckoning loses that pull, and its intake is thinner.
///
/// Three rules this obeys, all of them load-bearing:
///
///  * **Movement is measured in POINTS, not places.** The world table is
///    nothing like a straight line — the gap between first and fifth is wider
///    than the gap between fortieth and hundredth (see [Elo.seedFromRanking]).
///    Counting places would price a climb from 60th to 55th the same as one
///    from 6th to 1st, and after the ranking was widened on 2026-09-21 it would
///    have been roughly four times too hot at the top of the table. So the
///    climb is converted to the points it is actually worth first, and
///    [worldRank] only decides what a place up there costs. It is never a
///    bonus on its own.
///  * **Standing still earns NOTHING.** A nation whose rank has not moved and
///    who won nothing gets exactly zero from here, at any rank. Being good is
///    not news to the country's fifteen-year-olds; getting better is. This is
///    the null control, and it is asserted as a permanent test.
///  * **There is a hard ceiling.** The intake's talent draw is
///    `0.56 + rng × 0.38 + bonus` — an unbounded bonus would hand a nation a
///    generation of superstars inside two cycles and permanently distort the
///    world. [maxBonus] is the most any run of form can be worth, and the
///    falling side of it is deliberately shallower: a collapse should thin an
///    intake, not end a footballing nation.
abstract final class IntakeStanding {
  /// The most a nation's standing can add to an intake's talent, whatever it
  /// has just won and however far it has climbed. Roughly +4 overall points on
  /// an eleven-year-old's ceiling — real, and nowhere near a free generation.
  static const double maxBonus = 0.06;

  /// The most it can take away. Shallower than the ceiling on purpose.
  static const double minBonus = -0.04;

  /// The ranking points a championship-winning cycle is worth, which is what
  /// [maxClimbBonus] is priced against. Measured off the widened seed table:
  /// a champion moving from 25th to 5th gains about 170 points, so 200 is a
  /// cycle nobody has a right to expect.
  static const int fullClimbPoints = 200;

  /// The most the climb alone can be worth, before anything that was won.
  static const double maxClimbBonus = 0.04;

  /// The most the trophies alone can be worth. A World Championship is the
  /// whole of it; any other title is half.
  static const double maxTitleBonus = 0.02;

  /// The title that is worth the full [maxTitleBonus] on its own. Stored names
  /// are canonical English and are only translated at display, so matching on
  /// this string is safe.
  static const String worldChampionship = 'World Championship';

  /// The talent shift the intake arriving at the end of this cycle inherits.
  ///
  /// [worldRank] is where the side finished the cycle (1 = best) and
  /// [rankChangeOverCycle] is how many places it CLIMBED getting there
  /// (negative = slid down), so the rank it started from is the sum of the two.
  /// [titlesWon] is the competition names it won over the cycle, as stored.
  static double bonus({
    required int worldRank,
    required int rankChangeOverCycle,
    required Set<String> titlesWon,
  }) {
    final now = worldRank < 1 ? 1 : worldRank;
    final before = now + rankChangeOverCycle;
    // What the move was worth in ranking points, which is the only honest way
    // to compare a climb at the top of the table with one at the bottom.
    final gained =
        Elo.seedFromRanking(now) -
        Elo.seedFromRanking(before < 1 ? 1 : before);
    final climb = (gained / fullClimbPoints * maxClimbBonus).clamp(
      minBonus,
      maxClimbBonus,
    );

    // What it won. Winning is its own signal: a nation can lift a trophy from
    // a rank it was already sitting at, and the kids watching it do not care
    // that the table barely moved.
    var titles = 0.0;
    for (final t in titlesWon) {
      titles += t == worldChampionship ? maxTitleBonus : maxTitleBonus / 2;
    }
    if (titles > maxTitleBonus) titles = maxTitleBonus;

    return (climb + titles).clamp(minBonus, maxBonus);
  }
}
