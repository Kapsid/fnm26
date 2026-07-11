import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

/// Turns a match's disciplinary and injury events into updated player
/// standings for a nation.
///
/// The model is deliberately simple and deterministic:
/// * two accumulated yellow cards earn a one-match ban;
/// * a red card (straight or a second booking) is a one-match ban;
/// * a knock sidelines the player for one to four matches.
///
/// Before new events are applied, every existing ban and injury is served down
/// by one match — the players who sat out the game just played have now missed
/// it. Only players with something left to track are returned.
abstract final class Discipline {
  /// Two yellows (across the cycle) trigger a one-match ban.
  static const int _yellowsPerBan = 2;

  /// Returns the nation's new standings after [events], having first served one
  /// match off every current ban and injury in [before].
  static Map<int, PlayerAbsence> applyMatch({
    required Map<int, PlayerAbsence> before,
    required List<MatchEvent> events,
    required int nationId,
    required SeededRng rng,
  }) {
    final next = <int, PlayerAbsence>{
      for (final a in before.values)
        a.playerId: a.copyWith(
          banMatches: (a.banMatches - 1).clamp(0, 99),
          injuryMatches: (a.injuryMatches - 1).clamp(0, 99),
        ),
    };

    PlayerAbsence current(int id) =>
        next[id] ?? PlayerAbsence(playerId: id);

    for (final e in events) {
      if (e.teamNationId != nationId) continue;
      switch (e.type) {
        case MatchEventType.yellowCard:
          final a = current(e.playerId);
          final yellows = a.yellows + 1;
          if (yellows >= _yellowsPerBan) {
            next[e.playerId] = a.copyWith(
              yellows: yellows - _yellowsPerBan,
              banMatches: a.banMatches + 1,
            );
          } else {
            next[e.playerId] = a.copyWith(yellows: yellows);
          }
        case MatchEventType.redCard:
          final a = current(e.playerId);
          next[e.playerId] =
              a.copyWith(yellows: 0, banMatches: a.banMatches + 1);
        case MatchEventType.injury:
          final a = current(e.playerId);
          final weeks = 1 + rng.nextInt(4); // 1..4 matches
          next[e.playerId] = a.copyWith(
            injuryMatches: weeks > a.injuryMatches ? weeks : a.injuryMatches,
          );
        case MatchEventType.goal:
        case MatchEventType.substitution:
          break;
      }
    }

    next.removeWhere((_, a) => !a.isNotable);
    return next;
  }
}
