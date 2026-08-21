import 'package:fnm/domain/entities/fixture.dart';

/// The rules for when a manager may (re-)nominate their squad. A squad is named
/// at the start of a *period* and then locked for that whole period's matches;
/// the next period opens the next window. Periods begin:
///
///  * before a qualifying campaign (matchday 1) and again every four matchdays
///    (5, 9, 13, …), so a long campaign is re-selected regularly rather than
///    a squad being locked in for six games at a time;
///  * before a friendly window;
///  * before a tournament (the group stage's first match — the squad is then
///    locked for the entire tournament, knockouts included).
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

  /// Qualifying rounds, which get a fresh nomination window every four matchdays
  /// through the campaign.
  static const _qualRounds = <String?>{null, 'CQ'};

  /// How often (in matchdays) a qualifying campaign re-opens the squad.
  ///
  /// TWO, because that is what an international window is. At four, a manager
  /// named one squad and lived with it through four or six qualifiers spread
  /// across half a year — nobody does that. A country names a squad, plays the
  /// two matches of that window with it, and names another one next time.
  static const _qualWindowEvery = 2;

  /// Whether [f] begins a new nomination period, given the fixture immediately
  /// before it by date ([previous], null if [f] is the very first).
  static bool isPeriodStart(Fixture f, Fixture? previous) {
    if (f.round == 'FRIENDLY') {
      return previous == null || previous.round != 'FRIENDLY';
    }
    if (f.matchday == 1 && _periodStartRounds.contains(f.round)) return true;
    if (_qualRounds.contains(f.round) &&
        f.matchday > 1 &&
        (f.matchday - 1) % _qualWindowEvery == 0) {
      return true;
    }
    return false;
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
}
