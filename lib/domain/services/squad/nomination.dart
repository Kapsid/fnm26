import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/finals_participation.dart';

/// The rules for when a manager may (re-)nominate their squad. A squad is named
/// at the start of a *period* and then locked for that whole period's matches;
/// the next period opens the next window. Periods begin:
///
///  * at the start of a qualifying campaign or Nations Cup (matchday 1), and
///    again at every new international window, which is a new calendar month;
///  * before a friendly window;
///  * before a tournament (the group stage's first match — the squad is then
///    locked for the entire tournament, knockouts included, even when it runs
///    from June into July).
abstract final class Nomination {
  /// Rounds whose matchday 1 opens a fresh nomination period (a qualifying
  /// campaign or a tournament group stage).
  static const _periodStartRounds = <String?>{
    null, // World Cup qualifying
    'CQ', // continental qualifying
    'GROUP', // World Cup finals group
    'CGROUP', // continental finals group
    'NGROUP', // Nations Cup group
  };

  /// A finals tournament's rounds: one squad from the opening group match to
  /// the final.
  static const _tournamentRounds = <String?>{
    ...FinalsRounds.worldChampionship,
    ...FinalsRounds.continental,
  };

  /// Whether [f] begins a new nomination period, given the fixture immediately
  /// before it by date ([previous], null if [f] is the very first).
  ///
  /// A window is a calendar month. It used to be every second qualifying
  /// matchday, which held while every window was exactly three matches and
  /// even then opened a fresh call-up in the middle of one (matchdays 1-2 in
  /// early September, 3 on the 12th with 4 in October). Windows now hold two
  /// to four matches, and the month is what a window is.
  static bool isPeriodStart(Fixture f, Fixture? previous) {
    if (previous == null) return true;
    if (f.matchday == 1 && _periodStartRounds.contains(f.round)) return true;
    if (_tournamentRounds.contains(f.round)) return false;
    if (f.round == 'FRIENDLY' && previous.round != 'FRIENDLY') return true;
    return f.date.year != previous.date.year ||
        f.date.month != previous.date.month;
  }

  /// The index of the match the nation is actually ON, in a date-sorted list:
  /// the first unplayed fixture *after the last one that was played*. −1 when
  /// the season is over.
  ///
  /// Taking simply the first unplayed fixture is wrong once anything has been
  /// left behind. A fixture the world moved past without playing — an arranged
  /// friendly a tournament swallowed, say — keeps its place at the head of the
  /// list for ever, and every later period is judged against it: the window
  /// stays shut, and no tournament ever opens a fresh nomination again.
  static int _currentIndex(List<Fixture> sorted) {
    var lastPlayed = -1;
    for (var i = 0; i < sorted.length; i++) {
      if (sorted[i].hasResult) lastPlayed = i;
    }
    for (var i = lastPlayed + 1; i < sorted.length; i++) {
      if (!sorted[i].hasResult) return i;
    }
    return -1;
  }

  /// From a nation's fixtures (any order), returns the matches the *current*
  /// squad covers: the run from the next unplayed fixture up to — but not
  /// including — the fixture that starts the following period. Empty when there
  /// are no upcoming matches.
  static List<Fixture> currentPeriod(List<Fixture> fixtures) {
    final sorted = [...fixtures]..sort((a, b) => a.date.compareTo(b.date));
    final firstUnplayedIndex = _currentIndex(sorted);
    if (firstUnplayedIndex == -1) return const [];

    final out = <Fixture>[sorted[firstUnplayedIndex]];
    for (var i = firstUnplayedIndex + 1; i < sorted.length; i++) {
      if (isPeriodStart(sorted[i], sorted[i - 1])) break;
      out.add(sorted[i]);
    }
    return out;
  }

  /// Whether a nomination window is open right now — i.e. the next unplayed
  /// fixture starts a period (so the squad may be edited before it kicks off).
  static bool windowOpen(List<Fixture> fixtures) {
    final sorted = [...fixtures]..sort((a, b) => a.date.compareTo(b.date));
    final idx = _currentIndex(sorted);
    if (idx == -1) return false;
    return isPeriodStart(sorted[idx], idx == 0 ? null : sorted[idx - 1]);
  }

  /// The matches of the current period already played: those from the
  /// period's first match up to the next unplayed one. Empty between periods
  /// (the next match opens a new one) and when the season is over.
  static List<Fixture> playedInCurrentPeriod(List<Fixture> fixtures) {
    final sorted = [...fixtures]..sort((a, b) => a.date.compareTo(b.date));
    final idx = _currentIndex(sorted);
    if (idx <= 0) return const [];
    if (isPeriodStart(sorted[idx], sorted[idx - 1])) return const [];
    var start = idx - 1;
    while (start > 0 && !isPeriodStart(sorted[start], sorted[start - 1])) {
      start--;
    }
    return [
      for (var i = start; i < idx; i++)
        if (sorted[i].hasResult) sorted[i],
    ];
  }
}
