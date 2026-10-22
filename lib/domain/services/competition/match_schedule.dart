import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/finals_participation.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/squad/nomination.dart';

/// A stage the nation may still reach whose fixtures are not drawn yet.
typedef SchedulePending = ({bool knockoutStage, DateTime from});

/// One window, or one stage of a tournament.
typedef ScheduleBlock = ({
  int year,
  int month, // of the block's first fixture
  List<Fixture> fixtures, // date order
  SchedulePending? pending,
});

/// A nation's cycle fixtures folded into the blocks the schedule screen shows.
///
/// A window is exactly a call-up window ([Nomination.isPeriodStart]), so the
/// schedule and the squad lock never disagree about where one window ends. A
/// finals tournament keeps one squad throughout, but the schedule splits it by
/// stage: the group matches are one block, each knockout round its own.
abstract final class MatchSchedule {
  static const _finalRounds = {'FINAL', '3RD', 'CFINAL', 'C3RD'};

  static bool _inFinals(String? round) =>
      FinalsRounds.worldChampionship.contains(round) ||
      FinalsRounds.continental.contains(round);

  static bool _isGroup(String? round) => round == 'GROUP' || round == 'CGROUP';

  /// Whether [f] opens a new block after [previous].
  static bool _blockStart(Fixture f, Fixture previous) {
    if (Nomination.isPeriodStart(f, previous)) return true;
    // Inside a tournament Nomination keeps one period; split it by stage.
    if (_inFinals(f.round) && _inFinals(previous.round)) {
      if (_isGroup(f.round) && _isGroup(previous.round)) return false;
      return f.round != previous.round;
    }
    return false;
  }

  /// [knockoutsDrawnFor] holds the group round codes (`GROUP`, `CGROUP`)
  /// whose tournament has knockout fixtures anywhere in the world. A nation
  /// that went out in the group never gets one of its own, so its fixtures
  /// alone cannot say whether a knockout stage is still to come.
  static List<ScheduleBlock> blocks(
    List<Fixture> fixtures, {
    required int nationId,
    Set<String> knockoutsDrawnFor = const {},
  }) {
    final sorted = [...fixtures]..sort((a, b) => a.date.compareTo(b.date));
    final groups = <List<Fixture>>[];
    for (var i = 0; i < sorted.length; i++) {
      if (i == 0 || _blockStart(sorted[i], sorted[i - 1])) {
        groups.add([sorted[i]]);
      } else {
        groups.last.add(sorted[i]);
      }
    }
    final out = <ScheduleBlock>[
      for (final g in groups)
        (
          year: g.first.date.year,
          month: g.first.date.month,
          fixtures: g,
          pending: null,
        ),
    ];
    if (out.isNotEmpty) {
      final last = out.last;
      out[out.length - 1] = (
        year: last.year,
        month: last.month,
        fixtures: last.fixtures,
        pending: _pending(sorted, nationId, knockoutsDrawnFor),
      );
    }
    return out;
  }

  /// The stage still to come after the last fixture, or null. Only a WC or
  /// continental finals promise one; the Nations Cup's Finals Four is a year
  /// away and only for group winners, so it gets no row.
  static SchedulePending? _pending(
    List<Fixture> all,
    int nationId,
    Set<String> knockoutsDrawnFor,
  ) {
    final last = all.last;
    if (!_inFinals(last.round)) return null;
    DateTime dayAfter(DateTime d) => DateTime(d.year, d.month, d.day + 1);

    if (_isGroup(last.round)) {
      // Also when the nation's own group matches are all played: a five-team
      // group (Copa America) gives each side a bye on one matchday, so the
      // nation can be done while others still play, and the knockouts only
      // exist from the next sim step. Once the tournament has any knockout
      // fixture the stage is drawn: the nation is in it (its own fixtures
      // show) or went out in the group (no row).
      // Only this tournament's own knockouts count: an earlier continental
      // knockout, a play-off or a Finals Four in the same cycle is not it.
      final family = FinalsRounds.familyOf(last.round)!;
      final knockoutDrawn =
          all.any(
            (f) => family.contains(f.round) && Rounds.isKnockout(f.round),
          ) ||
          knockoutsDrawnFor.contains(last.round);
      if (!knockoutDrawn) {
        return (knockoutStage: true, from: dayAfter(last.date));
      }
      return null;
    }
    if (Rounds.isKnockout(last.round) &&
        !_finalRounds.contains(last.round) &&
        last.hasResult &&
        _won(last, nationId)) {
      return (knockoutStage: false, from: dayAfter(last.date));
    }
    return null;
  }

  /// Whether [nationId] won the played knockout [f]: score, else penalties.
  static bool _won(Fixture f, int nationId) {
    final home = f.homeNationId == nationId;
    final mine = home ? f.homeScore! : f.awayScore!;
    final theirs = home ? f.awayScore! : f.homeScore!;
    if (mine != theirs) return mine > theirs;
    if (!f.wentToShootout) return false;
    final myPens = home ? f.homePenalties! : f.awayPenalties!;
    final theirPens = home ? f.awayPenalties! : f.homePenalties!;
    return myPens > theirPens;
  }

  /// Index into [blocks] of the block holding the match the nation is on, -1
  /// when none: the first unplayed fixture after the last played one, the same
  /// rule as `Nomination._currentIndex`, so a stale unplayed fixture left
  /// behind never pins "current" in the past.
  static int currentIndex(List<ScheduleBlock> blocks) {
    final flat = [
      for (var b = 0; b < blocks.length; b++)
        for (final f in blocks[b].fixtures) (b, f),
    ];
    var lastPlayed = -1;
    for (var i = 0; i < flat.length; i++) {
      if (flat[i].$2.hasResult) lastPlayed = i;
    }
    for (var i = lastPlayed + 1; i < flat.length; i++) {
      if (!flat[i].$2.hasResult) return flat[i].$1;
    }
    return -1;
  }
}
