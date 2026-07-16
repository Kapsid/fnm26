import 'package:fnm/domain/entities/fixture.dart';

/// The rules for when a manager may (re-)nominate their squad. A squad is named
/// at the start of a *period* and then locked for that whole period's matches;
/// the next period opens the next window. Periods begin:
///
///  * before a qualifying campaign (matchday 1) and again before matchday 6;
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

  /// Qualifying rounds, which get a second nomination window at matchday 6.
  static const _qualRounds = <String?>{null, 'CQ'};

  /// Whether [f] begins a new nomination period, given the fixture immediately
  /// before it by date ([previous], null if [f] is the very first).
  static bool isPeriodStart(Fixture f, Fixture? previous) {
    if (f.round == 'FRIENDLY') {
      return previous == null || previous.round != 'FRIENDLY';
    }
    if (f.matchday == 1 && _periodStartRounds.contains(f.round)) return true;
    if (f.matchday == 6 && _qualRounds.contains(f.round)) return true;
    return false;
  }

  /// From a nation's fixtures (any order), returns the matches the *current*
  /// squad covers: the run from the next unplayed fixture up to — but not
  /// including — the fixture that starts the following period. Empty when there
  /// are no upcoming matches.
  static List<Fixture> currentPeriod(List<Fixture> fixtures) {
    final sorted = [...fixtures]..sort((a, b) => a.date.compareTo(b.date));
    final firstUnplayedIndex = sorted.indexWhere((f) => !f.hasResult);
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
    final idx = sorted.indexWhere((f) => !f.hasResult);
    if (idx == -1) return false;
    return isPeriodStart(sorted[idx], idx == 0 ? null : sorted[idx - 1]);
  }
}
