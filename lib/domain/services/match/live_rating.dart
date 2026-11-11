import 'dart:math';

import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/performance_mark.dart';

/// What each player did in a match, counted from its events and recorded
/// shots: the inputs [PerformanceMark] turns into a mark.
///
/// The ONE tally. The engine counts the whole match with it when it rates the
/// players at the whistle, and the live line-ups count the part of the match
/// already played with it, so a live mark at full time is the stored mark by
/// construction, not by two copies of the same loop agreeing.
final class MatchTally {
  /// Counts [events] and [moments]. Nothing is filtered here: the caller hands
  /// in exactly the part of the match it wants counted.
  factory MatchTally.of(
    Iterable<MatchEvent> events,
    Iterable<MatchMoment> moments,
  ) {
    final t = MatchTally._();
    for (final e in events) {
      switch (e.type) {
        // An own goal is the scoring side's goal and its scorer's blot: it
        // never counts as a goal of his.
        case MatchEventType.goal when e.ownGoal:
          t.ownGoals.update(e.playerId, (v) => v + 1, ifAbsent: () => 1);
        case MatchEventType.goal:
          t.goals.update(e.playerId, (v) => v + 1, ifAbsent: () => 1);
          final a = e.assistPlayerId;
          if (a != null) {
            t.assists.update(a, (v) => v + 1, ifAbsent: () => 1);
          }
        case MatchEventType.yellowCard:
          t.yellows.add(e.playerId);
        case MatchEventType.redCard:
          t.reds.add(e.playerId);
        case MatchEventType.substitution:
        case MatchEventType.injury:
          break;
      }
    }
    // A missed or saved kick makes no event, so the shots say who missed one
    // and which keeper kept one out.
    for (final s in moments.whereType<ShotMoment>()) {
      if (s.origin != ShotOrigin.penalty || s.outcome == ShotOutcome.goal) {
        continue;
      }
      t.penaltiesMissed.update(s.shooterId, (v) => v + 1, ifAbsent: () => 1);
      final keeper = s.keeperId;
      if (s.outcome == ShotOutcome.saved && keeper != null) {
        t.penaltiesSaved.update(keeper, (v) => v + 1, ifAbsent: () => 1);
      }
    }
    return t;
  }

  MatchTally._();

  final goals = <int, int>{};
  final assists = <int, int>{};
  final yellows = <int>{};
  final reds = <int>{};
  final penaltiesMissed = <int, int>{};
  final penaltiesSaved = <int, int>{};
  final ownGoals = <int, int>{};

  /// [playerId]'s mark with the score at [teamScore]–[oppScore]. See
  /// [PerformanceMark.forPlayer] for [cleanSheetShare].
  double markFor(
    int playerId, {
    required PositionCategory category,
    required int teamScore,
    required int oppScore,
    double cleanSheetShare = 1.0,
  }) => PerformanceMark.forPlayer(
    category: category,
    goals: goals[playerId] ?? 0,
    assists: assists[playerId] ?? 0,
    booked: yellows.contains(playerId),
    sentOff: reds.contains(playerId),
    teamScore: teamScore,
    oppScore: oppScore,
    penaltiesMissed: penaltiesMissed[playerId] ?? 0,
    penaltiesSaved: penaltiesSaved[playerId] ?? 0,
    ownGoals: ownGoals[playerId] ?? 0,
    cleanSheetShare: cleanSheetShare,
  );
}

/// A player the live ratings may mark: who he is, which side he plays for and
/// the line he plays in.
typedef RatedPlayer = ({int id, int nationId, PositionCategory category});

/// The running match ratings shown in the line-ups while a match is played.
///
/// NO LOOK-AHEAD. A match is simulated whole before the clock starts, so the
/// result in hand already knows every goal and card still to come. The live
/// mark is therefore built from scratch at every minute out of only what the
/// clock has reached: the events up to [asOf]'s minute, the shots strictly
/// before it, and the score those events make. The result's final score,
/// final ratings and later events are never read, so nothing still to come
/// can move a mark early.
///
/// The one input that grows with time rather than with events is the clean
/// sheet: a defender is not owed the whole bonus at 10', so it is earned
/// across the ninety ([cleanSheetShareAt]). It reaches the full bonus at 90'
/// whether or not extra time follows, so it cannot hint that there will be
/// any.
///
/// At full time (`fullTime`) everything is counted with the whole bonus,
/// which is exactly the engine's own computation: the live mark at the
/// whistle IS the stored mark.
abstract final class LiveRatings {
  /// The share of the clean-sheet bonus earned by [minute]: linear to 90',
  /// then whole.
  static double cleanSheetShareAt(int minute) => min(max(minute, 0), 90) / 90;

  /// Whether an event at [e]'s minute and added time has been reached by a
  /// clock at [minute] + [added]: the screen's own reveal rule.
  static bool eventReached(MatchEvent e, int minute, int added) =>
      e.minute < minute || (e.minute == minute && e.stoppage <= added);

  /// Whether a shot is safely in the past for a clock at [minute] + [added].
  /// Stricter than [eventReached]: a kick missed in the minute on the clock
  /// may not have been shown yet, so it counts from the next one.
  static bool shotReached(MatchMoment s, int minute, int added) =>
      s.minute < minute || (s.minute == minute && s.stoppage < added);

  /// The live mark of every player who has been on the pitch by the clock
  /// ([minute], plus [added] stoppage minutes at 90'), keyed by player id.
  ///
  /// [players] is everyone who might be marked (both teamsheets, bench
  /// included); [starterIds] are the two elevens that kicked off. A
  /// substitute is marked once his substitution has been reached.
  ///
  /// [events] and [moments] may be the whole match: anything the clock has
  /// not reached is ignored here, whatever the caller passes.
  static Map<int, double> asOf({
    required Iterable<RatedPlayer> players,
    required Set<int> starterIds,
    required List<MatchEvent> events,
    required List<MatchMoment> moments,
    required int homeNationId,
    required int minute,
    int added = 0,
    bool fullTime = false,
  }) {
    final seen = fullTime
        ? events
        : [
            for (final e in events)
              if (eventReached(e, minute, minute > 90 ? 0 : added)) e,
          ];
    // Added time belongs to the 90th minute alone. A clock past 90 may still
    // carry the stoppage count it ran up there, and must not read it as
    // added time in extra time.
    final clockAdded = minute > 90 ? 0 : added;
    final shots = fullTime
        ? moments
        : [
            for (final s in moments)
              if (shotReached(s, minute, clockAdded)) s,
          ];
    final tally = MatchTally.of(seen, shots);
    var home = 0;
    var away = 0;
    final appeared = {...starterIds};
    for (final e in seen) {
      if (e.type == MatchEventType.goal) {
        if (e.teamNationId == homeNationId) {
          home++;
        } else {
          away++;
        }
      } else if (e.type == MatchEventType.substitution) {
        appeared.add(e.playerId);
      }
    }
    final share = fullTime ? 1.0 : cleanSheetShareAt(minute);
    return {
      for (final p in players)
        if (appeared.contains(p.id))
          p.id: tally.markFor(
            p.id,
            category: p.category,
            teamScore: p.nationId == homeNationId ? home : away,
            oppScore: p.nationId == homeNationId ? away : home,
            cleanSheetShare: share,
          ),
    };
  }
}
