import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/squad/nomination.dart';

/// What a player got up to when the squad gathered.
///
/// The order is part of the save: a recorded scandal stores the kind by NAME
/// (see [CampScandal.markerOf]), so a value may be added but never renamed.
enum ScandalKind {
  /// A party that went on far too long.
  party,

  /// Out after the curfew, caught coming back in.
  curfew,

  /// Photographed in a nightclub on the eve of a match.
  nightclub,

  /// A night at the casino.
  casino,
}

/// What the manager did about it.
enum ScandalChoice {
  /// Out of the squad for the rest of the window.
  sentHome,

  /// He stays, and the dressing room and the board remember it.
  kept,
}

/// A scandal the dice have dealt for one window: who, and what he did.
typedef ScandalRoll = ({int playerId, ScandalKind kind});

/// A scandal as the save remembers it, decided or not.
typedef CampScandalRecord = ({
  int cycle,

  /// The window it broke in: the date of the window's first match. A date
  /// rather than a fixture id, because a career bundle re-numbers fixtures on
  /// import and a marker naming an old id would point at nothing.
  DateTime window,
  int playerId,
  ScandalKind kind,
  ScandalChoice choice,
});

/// One called-up man, as the roll needs him.
typedef ScandalCandidate = ({int playerId, int age});

/// A rare night out that turns into a story, and the decision it forces.
///
/// RARITY IS THE POINT. Grievances were switched off because they fired
/// between every pair of matches, and an interruption that always happens is
/// a toll rather than an event.
///
/// The roll is PER CYCLE, not per window. A per-window chance made the rate
/// depend on how many call-ups a nation has. Instead, once a cycle (from the
/// save seed and the cycle alone) the dice decide whether the cycle has a
/// scandal at all ([chancePerCycle]) and, if it does, a TARGET DATE drawn
/// evenly across the cycle's calendar, from the day it opens to its World
/// Championship final ([targetDate]). The scandal breaks at the manager's
/// first call-up window that opens on or after that date.
///
/// The calendar, not the fixtures, because the fixtures are written lazily:
/// World Championship qualifying is drawn only once the continental cup is
/// decided, and a finals only at its draw. Counting only the windows that
/// existed would pile every scandal into the early campaigns and leave the
/// World Championship camps clean for ever. A side with no window left after
/// its target (knocked out early, nothing more to play) simply has no scandal
/// that cycle, so the rate is a little under [chancePerCycle] (pinned, walked
/// in game, by `test/unit/squad/camp_scandal_flow_test.dart`).
///
/// Nothing about the roll is stored. It is derived from the save seed, the
/// cycle and the window, so a reload or a rebuilt hub asks the same question
/// and gets the same answer. Only the manager's ANSWER is stored, as a
/// draws-watched marker (see [markerOf]), which also keeps it to one a cycle.
abstract final class CampScandal {
  /// The share of cycles that have a scandal: about one every two.
  static const double chancePerCycle = 0.5;

  /// The ages the tabloids are most interested in. Not a rule: an older or a
  /// younger man can still be the one, he is just less likely to be.
  static const int likelyFromAge = 20;
  static const int likelyToAge = 30;

  /// How much more likely a man in [likelyFromAge]..[likelyToAge] is to be
  /// the one, against anybody else in the squad.
  static const int likelyWeight = 3;

  /// What keeping him costs, for the rest of the cycle.
  static const int keepMorale = -4;
  static const int keepBoard = -3;

  /// The tone a kept scandal's press row carries.
  static const String keepTone = 'scandalKeep';

  /// The prefix of every scandal marker and press row.
  static const String prefix = 'scandal:';

  /// The window key a roll and a marker share: the window's first match date.
  static String windowKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}'
      '${d.month.toString().padLeft(2, '0')}'
      '${d.day.toString().padLeft(2, '0')}';

  /// Whether the window opening on [window] has the cycle's scandal, and if
  /// it does, who and what. Null for a quiet window, or a squad with nobody
  /// in it who could be the one.
  ///
  /// [starts] are the manager's call-up windows as the save knows them now
  /// (see [windowStarts]); [opens] and [closes] the cycle's calendar span
  /// (its first day and its World Championship final).
  ///
  /// [candidates] are the called-up men who are fit: an injured player is
  /// nowhere near the night out, and a man already sent home is not in the
  /// squad to be picked. Ordered by player id before the pick, so the order
  /// the caller hands them over in never changes the answer. Under-18s are
  /// only ever the curfew story: a boy is not at the casino.
  static ScandalRoll? roll({
    required int seed,
    required int cycle,
    required DateTime window,
    required List<DateTime> starts,
    required DateTime opens,
    required DateTime closes,
    required List<ScandalCandidate> candidates,
  }) {
    if (candidates.isEmpty) return null;
    if (!fires(
      seed: seed,
      cycle: cycle,
      window: window,
      starts: starts,
      opens: opens,
      closes: closes,
    )) {
      return null;
    }
    final rng = _windowRng(seed, cycle, window);
    final sorted = [...candidates]
      ..sort((a, b) => a.playerId.compareTo(b.playerId));
    int weightOf(ScandalCandidate c) =>
        c.age >= likelyFromAge && c.age <= likelyToAge ? likelyWeight : 1;
    final total = sorted.fold<int>(0, (s, c) => s + weightOf(c));
    var pick = rng.nextInt(total);
    var chosen = sorted.last;
    for (final c in sorted) {
      final w = weightOf(c);
      if (pick < w) {
        chosen = c;
        break;
      }
      pick -= w;
    }
    final drawn = ScandalKind.values[rng.nextInt(ScandalKind.values.length)];
    final kind = chosen.age < adultAge ? ScandalKind.curfew : drawn;
    return (playerId: chosen.playerId, kind: kind);
  }

  /// Below this age a scandal is only ever a curfew breach.
  static const int adultAge = 18;

  /// Whether [cycle] has a scandal at all: one draw from the save seed and
  /// the cycle, whatever its schedule.
  static bool cycleHasScandal({required int seed, required int cycle}) =>
      SeededRng(
        varietySeed('scandal|cycle|$cycle') ^ seed,
      ).chance(chancePerCycle);

  /// The day [cycle]'s scandal is due from: drawn evenly between [opens] and
  /// [closes] from the save seed and the cycle.
  static DateTime targetDate({
    required int seed,
    required int cycle,
    required DateTime opens,
    required DateTime closes,
  }) {
    final span = closes.difference(opens).inDays;
    if (span <= 0) return opens;
    final day = SeededRng(
      varietySeed('scandal|target|$cycle') ^ seed,
    ).nextInt(span + 1);
    return DateTime(opens.year, opens.month, opens.day + day);
  }

  /// Whether the window opening on [window] is the one the cycle's scandal
  /// falls in: the cycle has one, and [window] is the first of [starts] on or
  /// after its [targetDate]. The cheap question, asked before the squad is
  /// loaded.
  static bool fires({
    required int seed,
    required int cycle,
    required DateTime window,
    required List<DateTime> starts,
    required DateTime opens,
    required DateTime closes,
  }) {
    if (!cycleHasScandal(seed: seed, cycle: cycle)) return false;
    final target = targetDate(
      seed: seed,
      cycle: cycle,
      opens: opens,
      closes: closes,
    );
    DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);
    final due = [
      for (final d in starts)
        if (!day(d).isBefore(day(target))) day(d),
    ]..sort();
    return due.isNotEmpty && due.first == day(window);
  }

  static SeededRng _windowRng(int seed, int cycle, DateTime window) =>
      SeededRng(varietySeed('scandal|$cycle|${windowKey(window)}') ^ seed);

  /// The dates the call-up windows of a nation's cycle open on: the first
  /// match of every nomination period in [fixtures] (any order).
  static List<DateTime> windowStarts(List<Fixture> fixtures) {
    final sorted = [...fixtures]..sort((a, b) => a.date.compareTo(b.date));
    return [
      for (var i = 0; i < sorted.length; i++)
        if (Nomination.isPeriodStart(sorted[i], i == 0 ? null : sorted[i - 1]))
          sorted[i].date,
    ];
  }

  /// The draws-watched marker that records an answered scandal. It carries
  /// everything the inbox and the feed need to tell the story again, so
  /// nothing else is stored and no schema changes.
  static String markerOf(CampScandalRecord r) =>
      '$prefix${r.cycle}:${windowKey(r.window)}:${r.playerId}:'
      '${r.kind.name}:${r.choice.name}';

  /// The prefix every marker of [cycle] starts with: one of them means the
  /// cycle has had its scandal.
  static String cyclePrefix(int cycle) => '$prefix$cycle:';

  /// [marker] read back, or null for anything that is not a scandal marker.
  static CampScandalRecord? parse(String marker) {
    if (!marker.startsWith(prefix)) return null;
    final parts = marker.substring(prefix.length).split(':');
    if (parts.length != 5) return null;
    final cycle = int.tryParse(parts[0]);
    final w = parts[1];
    final playerId = int.tryParse(parts[2]);
    final kind = ScandalKind.values.where((k) => k.name == parts[3]);
    final choice = ScandalChoice.values.where((c) => c.name == parts[4]);
    if (cycle == null ||
        playerId == null ||
        w.length != 8 ||
        kind.isEmpty ||
        choice.isEmpty) {
      return null;
    }
    final y = int.tryParse(w.substring(0, 4));
    final m = int.tryParse(w.substring(4, 6));
    final d = int.tryParse(w.substring(6, 8));
    if (y == null || m == null || d == null) return null;
    return (
      cycle: cycle,
      window: DateTime(y, m, d),
      playerId: playerId,
      kind: kind.first,
      choice: choice.first,
    );
  }

  /// The press row a kept scandal writes: the cycle and the man, so it is
  /// written once.
  static String pressKeyOf(int cycle, int playerId) =>
      '$prefix$cycle:$playerId';

  /// The day the story broke: two days before the window's first match, when
  /// the squad has gathered.
  static DateTime brokeOn(DateTime window) =>
      window.subtract(const Duration(days: 2));
}
