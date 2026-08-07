import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

/// Turns a match's disciplinary and injury events into updated player
/// standings for a nation.
///
/// The model is deterministic and mirrors how real bans work:
/// * two accumulated yellow cards earn a one-match ban;
/// * a second booking (two yellows in one game) is a one-match ban;
/// * a straight red is a **one-to-three-match** ban by severity — most are a
///   single game (serious foul play), some two (violent conduct), a few three
///   (the worst offences);
/// * a knock sidelines the player for one to four matches.
///
/// Bans **carry** until served: [banMatches] counts national-team games the
/// player must still sit out, whatever competition they fall in, so a red in a
/// qualifier is served in the next fixture even if that is a finals match — as
/// a real suspension carries across stages.
///
/// Before new events are applied, every existing ban and injury is served down
/// by one match — the players who sat out the game just played have now missed
/// it. Only players with something left to track are returned.
abstract final class Discipline {
  /// Three yellows (across the cycle) trigger a one-match ban. A higher
  /// threshold than club football keeps accumulation bans occasional rather
  /// than a regular starter sitting out every few games.
  static const int _yellowsPerBan = 3;

  /// The ban length for a straight red, by severity (deterministic from [rng]):
  /// mostly one match, sometimes two, rarely three.
  static int _straightRedBan(SeededRng rng) {
    final r = rng.nextDouble();
    if (r < 0.12) return 3; // violent conduct / off-the-ball assault
    if (r < 0.40) return 2; // serious foul play
    return 1; // last-man / professional foul
  }

  /// Returns the nation's new standings after [events], having first served one
  /// match off every current ban and injury in [before].
  ///
  /// [competitive] gates suspensions: a friendly neither earns a card-based ban
  /// nor counts toward serving an existing one (real bans are served only in
  /// competitive games), but injuries still happen and still heal, so a knock
  /// picked up in a friendly is real and recovery ticks on regardless.
  static Map<int, PlayerAbsence> applyMatch({
    required Map<int, PlayerAbsence> before,
    required List<MatchEvent> events,
    required int nationId,
    required SeededRng rng,
    bool competitive = true,
  }) {
    final next = <int, PlayerAbsence>{
      for (final a in before.values)
        a.playerId: a.copyWith(
          // A friendly does not count toward serving a competitive ban.
          banMatches:
              competitive ? (a.banMatches - 1).clamp(0, 99) : a.banMatches,
          injuryMatches: (a.injuryMatches - 1).clamp(0, 99),
        ),
    };

    PlayerAbsence current(int id) =>
        next[id] ?? PlayerAbsence(playerId: id);

    for (final e in events) {
      if (e.teamNationId != nationId) continue;
      // Cards in a friendly carry no suspension consequences.
      if (!competitive &&
          (e.type == MatchEventType.yellowCard ||
              e.type == MatchEventType.redCard)) {
        continue;
      }
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
          // A second booking is a one-match ban; a straight red is weighted by
          // severity. A dismissal also wipes the pending-yellow count.
          final ban = e.secondYellow ? 1 : _straightRedBan(rng);
          next[e.playerId] =
              a.copyWith(yellows: 0, banMatches: a.banMatches + ban);
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
