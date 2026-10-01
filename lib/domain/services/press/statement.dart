import 'package:fnm/domain/services/press/press.dart' show PressEffect;

/// What the manager can put on the record at a press conference.
enum StatementKind { winNext, jobOnTheLine, backPlayer, blamePlayer }

/// Where a statement stands: waiting on its window, or judged by what followed.
enum StatementStatus { open, kept, broken, lapsed }

/// A promise or a verdict the manager gave the press, kept so that what
/// happens next can be held against it.
typedef PressStatement = ({
  int id,
  int cycle,
  int nationId,
  StatementKind kind,
  int? playerId,
  DateTime madeOn, // the date of the match the conference was about
  int madeAfterFixtureId,
  StatementStatus status,
  DateTime? judgedOn,
  bool thrownBack,
});

typedef JudgedMatch = ({
  int fixtureId,
  DateTime date,
  int scored,
  int conceded,
});
typedef Appearance = ({int fixtureId, DateTime date, double rating});
typedef StatementVerdict = ({StatementStatus status, PressEffect effect});

/// Judging what the manager said against what happened next. Pure: the press
/// desk gathers the matches and appearances and stores the verdicts.
abstract final class StatementJudge {
  static const int jobWindow = 3;
  static const int playerWindow = 3;
  static const double playerBar = 6.8;

  /// A backed player who came good stays a little sharper for this long.
  static const int backingDays = 90;

  static const PressEffect none = (morale: 0, board: 0);
  static const PressEffect winNextKept = (morale: 4, board: 3);
  static const PressEffect winNextBroken = (morale: -2, board: -6);
  static const PressEffect jobKept = (morale: 0, board: 10);
  static const PressEffect jobBroken = (morale: 0, board: -12);
  static const PressEffect backKept = (morale: 2, board: 0);
  static const PressEffect backBroken = (morale: 0, board: -2);
  static const PressEffect blameStood = (morale: 0, board: 2);

  static StatementVerdict? judge(
    PressStatement s, {
    required List<JudgedMatch> matches,
    required List<Appearance> appearances,
    required int currentNationId,
    required int currentCycle,
  }) {
    if (s.status != StatementStatus.open) return null;
    const lapsed = (status: StatementStatus.lapsed, effect: none);
    if (s.nationId != currentNationId) return lapsed;
    final cycleOver = s.cycle < currentCycle;
    switch (s.kind) {
      case StatementKind.winNext:
      case StatementKind.jobOnTheLine:
        final after = [
          for (final x in matches)
            if (x.date.isAfter(s.madeOn)) x,
        ]..sort((a, b) => a.date.compareTo(b.date));
        final need = s.kind == StatementKind.winNext ? 1 : jobWindow;
        if (after.length < need) return cycleOver ? lapsed : null;
        final wins = after
            .take(need)
            .where((x) => x.scored > x.conceded)
            .length;
        if (s.kind == StatementKind.winNext) {
          return wins == 1
              ? (status: StatementStatus.kept, effect: winNextKept)
              : (status: StatementStatus.broken, effect: winNextBroken);
        }
        return wins >= 2
            ? (status: StatementStatus.kept, effect: jobKept)
            : (status: StatementStatus.broken, effect: jobBroken);
      case StatementKind.backPlayer:
      case StatementKind.blamePlayer:
        final after = [
          for (final x in appearances)
            if (x.date.isAfter(s.madeOn)) x,
        ]..sort((a, b) => a.date.compareTo(b.date));
        if (after.length < playerWindow) return cycleOver ? lapsed : null;
        final mean =
            after
                .take(playerWindow)
                .map((x) => x.rating)
                .reduce((a, b) => a + b) /
            playerWindow;
        final cameGood = mean >= playerBar;
        if (s.kind == StatementKind.backPlayer) {
          return cameGood
              ? (status: StatementStatus.kept, effect: backKept)
              : (status: StatementStatus.broken, effect: backBroken);
        }
        return cameGood
            ? (status: StatementStatus.broken, effect: none)
            : (status: StatementStatus.kept, effect: blameStood);
    }
  }

  /// Player id → rating shift the record puts on him: an open blame is −2, a
  /// backing that came good within [backingDays] is +1.
  static Map<int, int> conditionDeltas(
    Iterable<PressStatement> all,
    DateTime asOf,
  ) {
    final out = <int, int>{};
    for (final s in all) {
      final id = s.playerId;
      if (id == null) continue;
      if (s.kind == StatementKind.blamePlayer &&
          s.status == StatementStatus.open) {
        out[id] = (out[id] ?? 0) - 2;
      } else if (s.kind == StatementKind.backPlayer &&
          s.status == StatementStatus.kept &&
          s.judgedOn != null &&
          asOf.difference(s.judgedOn!).inDays <= backingDays) {
        out[id] = (out[id] ?? 0) + 1;
      }
    }
    return out;
  }
}

enum CredibilityBand { low, mid, high }

/// How far the room believes him. Derived from the record, never stored.
abstract final class Credibility {
  static const int start = 50;
  static const int keptStep = 8;
  static const int brokenStep = -10;
  static const int deflectStep = -2;

  static int of(Iterable<PressStatement> statements, {required int deflects}) {
    var c = start + deflects * deflectStep;
    for (final s in statements) {
      if (s.status == StatementStatus.kept) c += keptStep;
      if (s.status == StatementStatus.broken) c += brokenStep;
    }
    return c.clamp(0, 100);
  }

  static CredibilityBand band(int c) => c < 35
      ? CredibilityBand.low
      : c > 65
      ? CredibilityBand.high
      : CredibilityBand.mid;

  /// How hard an answer lands: ×0.6 with no credibility, ×1.4 with full.
  static double multiplier(int c) => 0.6 + 0.8 * c / 100;
}
