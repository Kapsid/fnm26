import 'package:fnm/domain/entities/enums.dart';

/// The one definition of a player's performance mark for a match (`3.0`–`10.0`).
///
/// Shared deliberately. The tactical engine rates the manager's own matches and
/// the background layer rates every other match in the world; if the two used
/// different formulas then a Team of the Tournament, a Player of the Year or
/// any all-time "best rating" record would be comparing two different scales,
/// and the manager's own players would win or lose those awards for reasons
/// that have nothing to do with how they played.
abstract final class PerformanceMark {
  /// The mark for one player, from what they did and how the match finished.
  /// Pure and RNG-free.
  static double forPlayer({
    required PositionCategory category,
    required int goals,
    required int assists,
    required bool booked,
    required bool sentOff,
    required int teamScore,
    required int oppScore,
  }) {
    var r = 6.5;
    r += goals * 1.0 + assists * 0.6;
    if (teamScore > oppScore) {
      r += 0.4;
    } else if (teamScore < oppScore) {
      r -= 0.3;
    }
    final defensive =
        category == PositionCategory.defender ||
        category == PositionCategory.goalkeeper;
    if (defensive) {
      r += oppScore == 0 ? 0.5 : -0.15 * oppScore;
    }
    if (booked) r -= 0.3;
    if (sentOff) r -= 1.2;
    return (r.clamp(3.0, 10.0) * 10).roundToDouble() / 10;
  }
}
