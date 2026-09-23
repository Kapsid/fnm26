import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';

/// How well a player performs when fielded in a given slot. A player in their
/// natural position plays at full strength; the further the slot is from it,
/// the more their effective rating is docked.
///
/// This is the single source of truth for the out-of-position penalty — the
/// match engine uses it to rate lines, and the tactics pitch uses it to show
/// the manager the recalculated rating before they commit the lineup.
abstract final class PositionFit {
  /// The rating multiplier for a [natural]-position player fielded in [slot]:
  /// `1.0` at their own position, tapering as the slot moves away. Same line is
  /// barely a dent; crossing lines (or into/out of goal) hurts sharply — a
  /// player shoved right out of position should be a clear downgrade, so the
  /// manager only does it in an emergency.
  static double factor(PlayerPosition natural, PlayerPosition slot) {
    if (natural == slot) return 1;
    if (natural.category == slot.category) return 0.95;
    int line(PositionCategory c) => switch (c) {
      PositionCategory.goalkeeper => 0,
      PositionCategory.defender => 1,
      PositionCategory.midfielder => 2,
      PositionCategory.forward => 3,
    };
    final gap = (line(natural.category) - line(slot.category)).abs();
    final involvesKeeper =
        natural.category == PositionCategory.goalkeeper ||
        slot.category == PositionCategory.goalkeeper;
    if (involvesKeeper) return gap <= 1 ? 0.55 : 0.40;
    // One line off (e.g. a midfielder at full-back or up front) is a real dent;
    // two lines off (a defender leading the line) is a heavy penalty.
    return gap <= 1 ? 0.80 : 0.60;
  }

  /// [player]'s overall rating as it counts when fielded in [slot] (their base
  /// overall for their own position, reduced out of position). Rounded `1..99`.
  static int effectiveOverall(Player player, PlayerPosition slot) =>
      (player.overall * factor(player.position, slot)).round().clamp(1, 99);

  /// How naturally [p] suits [slot] for lineup/substitute suggestions: 2 = the
  /// exact position, 1 = same line, 0 = out of line. Higher is a better fit.
  static int fitRank(Player p, PlayerPosition slot) {
    if (p.position == slot) return 2;
    if (p.position.category == slot.category) return 1;
    return 0;
  }

  /// A comparator ordering players for a [slot] by the rating they would
  /// actually play at there — best first.
  ///
  /// It used to sort by positional fit FIRST and only then by rating, so the
  /// list opened with every same-position player in the squad before the first
  /// out-of-position one, however much better that player was: a 62-rated
  /// reserve full-back sat above an 84-rated centre-back who would play the
  /// slot at 80. The number the picker shows is the effective rating, so that
  /// is the number it now orders by; fit and raw overall only break ties (a
  /// natural fit ahead of a converted one at the same effective rating).
  static int Function(Player, Player) bySlotFit(PlayerPosition slot) => (a, b) {
    final byEffective = effectiveOverall(
      b,
      slot,
    ).compareTo(effectiveOverall(a, slot));
    if (byEffective != 0) return byEffective;
    final byFit = fitRank(b, slot) - fitRank(a, slot);
    return byFit != 0 ? byFit : b.overall.compareTo(a.overall);
  };
}
