import 'package:fnm/domain/entities/player.dart';

/// One club move inside a window: the player as he is now, and as he was.
typedef ClubMove = ({Player now, Player was});

/// Who changed club between two snapshots of the same national pool.
///
/// The one place that decides what a transfer window CONTAINS, so the window
/// report and a player's own club history cannot disagree about it. They used
/// to: the report was built from the nation's top ten by overall, while the
/// club history card walks every season the player existed for. A manager's
/// eleventh-best player could change club four times in a career and the
/// window never said a word about any of them, which is exactly what the
/// history card then showed him.
///
/// The old cap was sized against a `take(3)` limit on the message that no
/// longer exists — the report is a paged table now, built to hold the thirty
/// or forty moves a window really makes. So there is no cap: everyone in the
/// selectable pool who moved is in the window, and every move in a player's
/// history is in the window report for the year it happened.
abstract final class TransferWindow {
  /// The moves between [before] and [after], the biggest first.
  ///
  /// A player missing from either snapshot is not a move: he had not come
  /// through yet, or he has retired out of the pool. A club is compared with
  /// its country, because two leagues can field a club of the same name.
  static List<ClubMove> moves(List<Player> before, List<Player> after) {
    final was = {for (final p in before) p.id: p};
    return <ClubMove>[
      for (final p in after)
        if (was[p.id] case final b?)
          if (b.club != p.club || b.clubCountry != p.clubCountry)
            (now: p, was: b),
    ]..sort((a, b) => b.now.value.compareTo(a.now.value));
  }
}
