import 'dart:math' as math;

import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/domain/services/press/expectation.dart';

/// How the supporters feel about the side, in five words.
enum FanMoodBand {
  /// Banners, a hashtag with the manager's name in it, seats left empty on
  /// purpose.
  furious,

  /// Grumbling. The ground is not full and the ones who came are quiet.
  restless,

  /// Neither here nor there.
  neutral,

  /// Behind the side. The tickets go.
  warm,

  /// The best team in years, and every seat taken.
  euphoric,
}

/// One result as the stands remember it.
typedef FanResult = ({
  int nationRank,
  int opponentRank,
  int scored,
  int conceded,
  bool competitive,
  DateTime date,

  /// For a tie settled on penalties, whether we won the shoot-out (null for
  /// every other match). The stands count the shoot-out as the result, as the
  /// feed does: a final lost on penalties is a defeat, not a draw.
  bool? shootoutWon,
});

/// Something a tournament did to the country that is not a scoreline.
enum FanEventKind { trophy, runnerUp, qualified, eliminated }

/// A dated [FanEventKind].
typedef FanEvent = ({FanEventKind kind, DateTime date});

/// The mood, its band, and the run behind it.
typedef FanMoodReading = ({
  int score,
  FanMoodBand band,

  /// Wins on the bounce, newest backwards.
  int winRun,

  /// Defeats on the bounce, newest backwards.
  int lossRun,
});

/// What the supporters think of the side, 0..100, neutral at 50.
///
/// Not [PublicMood], though it reads the same [Expectation]. The public mood
/// is a verdict on the MANAGER that the board weighs, over his own spell. This
/// is the stands: the nation's whole recent run, how long it has been going on
/// (a fifth straight defeat is worse than five scattered ones), and what the
/// tournaments did (a trophy keeps a country warm for a year). It decides how
/// many turn up (see `Attendance.forFixture`), what a ground earns, and when
/// the country takes to Y with banners.
///
/// Derived, never stored: the same results always give the same mood, so a
/// post from three years ago reads the mood of its own day.
abstract final class FanMood {
  /// The mood with nothing to go on.
  static const int neutral = 50;

  /// How many recent results the stands remember.
  static const int window = 8;

  /// How far back they remember anything at all. A result from two summers
  /// ago is history, not a grievance.
  static const Duration memory = Duration(days: 540);

  /// The weight of each older result relative to the one after it.
  static const double _decay = 0.7;

  /// A neutral result's worth of weight added to every average, so one
  /// afternoon moves the mood without deciding it.
  static const double _prior = 2;

  /// How far the results alone can move the mood from [neutral].
  static const double _amplitude = 40;

  /// The bands' upper edges: furious up to [furiousAt], restless up to
  /// [restlessAt], warm from [warmAt], euphoric from [euphoricAt].
  static const int furiousAt = 20;
  static const int restlessAt = 38;
  static const int warmAt = 62;
  static const int euphoricAt = 78;

  /// The supporters' mood as of [asOf]: [results] in any order (anything
  /// after [asOf] or older than [memory] is ignored), [events] likewise.
  static FanMoodReading of({
    required Iterable<FanResult> results,
    required DateTime asOf,
    Iterable<FanEvent> events = const [],
  }) {
    final from = asOf.subtract(memory);
    final recent = [
      for (final r in results)
        if (!r.date.isAfter(asOf) && r.date.isAfter(from)) r,
    ]..sort((a, b) => b.date.compareTo(a.date));
    final games = recent.take(window).toList();

    var sum = 0.0;
    var weights = _prior;
    for (var i = 0; i < games.length; i++) {
      final w = math.pow(_decay, i).toDouble();
      sum += verdict(games[i]) * w;
      weights += w;
    }
    var score = neutral + sum / weights * _amplitude;

    // The run, newest backwards.
    var winRun = 0;
    var lossRun = 0;
    for (final g in recent) {
      if (wonOf(g) && lossRun == 0) {
        winRun++;
      } else if (lostOf(g) && winRun == 0) {
        lossRun++;
      } else {
        break;
      }
    }
    if (lossRun >= 3) score -= math.min(24, (lossRun - 2) * 6);
    if (winRun >= 3) score += math.min(20, (winRun - 2) * 4);

    for (final e in events) {
      if (e.date.isAfter(asOf)) continue;
      final (lift, lasts) = switch (e.kind) {
        FanEventKind.trophy => (24.0, 540),
        FanEventKind.runnerUp => (10.0, 365),
        FanEventKind.qualified => (8.0, 240),
        FanEventKind.eliminated => (-6.0, 180),
      };
      final age = asOf.difference(e.date).inDays;
      if (age >= lasts) continue;
      score += lift * (1 - age / lasts);
    }

    final clamped = score.round().clamp(0, 100);
    return (
      score: clamped,
      band: bandOf(clamped),
      winRun: winRun,
      lossRun: lossRun,
    );
  }

  /// One result on a -1..+1 scale: partly what happened, mostly what happened
  /// against what was expected. A routine win over a minnow is a small plus,
  /// a defeat by a giant barely a minus, a defeat by a minnow the worst of it.
  /// A friendly counts for less than half.
  static double verdict(FanResult g) {
    final outcome = wonOf(g)
        ? 1.0
        : lostOf(g)
        ? -1.0
        : 0.0;
    final surprise = Expectation.surprise(
      nationRank: g.nationRank,
      opponentRank: g.opponentRank,
      scored: g.scored,
      conceded: g.conceded,
      competitive: g.competitive,
    );
    final value =
        (g.competitive ? 0.35 : 0.15) * outcome + 0.65 * surprise / 1.25;
    return value.clamp(-1.0, 1.0);
  }

  /// Whether [g] was won, a shoot-out included.
  static bool wonOf(FanResult g) => g.shootoutWon ?? g.scored > g.conceded;

  /// Whether [g] was lost, a shoot-out included.
  static bool lostOf(FanResult g) =>
      g.shootoutWon == null ? g.scored < g.conceded : !g.shootoutWon!;

  /// The band a [score] falls in.
  static FanMoodBand bandOf(int score) {
    if (score <= furiousAt) return FanMoodBand.furious;
    if (score <= restlessAt) return FanMoodBand.restless;
    if (score < warmAt) return FanMoodBand.neutral;
    if (score < euphoricAt) return FanMoodBand.warm;
    return FanMoodBand.euphoric;
  }

  /// How much fuller (or emptier) the mood makes a home ground, as a share of
  /// capacity: up to 30 points emptier at rock bottom, up to 36 fuller at the
  /// top. Zero at [neutral], so a save with no results reads as before. Big
  /// enough that a qualifier sells out on a good run and visibly half-fills on
  /// a losing one.
  static double fillShift(int score) {
    final d = (score - neutral) / neutral;
    return d >= 0 ? d * 0.36 : d * 0.30;
  }

  /// What the mood does to the stadium estate's cycle income: a fifth less
  /// when the stands are furious, a fifth more when every seat goes. Applied
  /// BEFORE the grant cap, which still holds.
  static double incomeFactor(FanMoodBand band) => switch (band) {
    FanMoodBand.furious => 0.8,
    FanMoodBand.restless => 0.9,
    FanMoodBand.neutral => 1.0,
    FanMoodBand.warm => 1.1,
    FanMoodBand.euphoric => 1.2,
  };

  /// [income] with the mood applied, to the thousand.
  static int moodIncome(int income, FanMoodBand band) =>
      ((income * incomeFactor(band)) / 1000).round() * 1000;

  /// What a stadium estate earning [estate] actually pays for a cycle whose
  /// grant is [grant]: the mood first ([moodIncome], [mood] null for a nation
  /// whose mood the game does not read), the grant cap last
  /// ([NationalStadiums.cappedToGrant]). The one place the order is decided,
  /// so the rollover and every estimate agree.
  static int stadiumIncome({
    required int estate,
    required int grant,
    FanMoodBand? mood,
  }) => NationalStadiums.cappedToGrant(
    mood == null ? estate : moodIncome(estate, mood),
    grant,
  );

  /// What the mood really changes about that payment, in percent of what it
  /// would be without it, after the cap: zero when the estate earns nothing,
  /// when it already sits at the cap, or when the mood is neutral.
  static int effectivePercent({
    required int estate,
    required int grant,
    required FanMoodBand mood,
  }) {
    final without = stadiumIncome(estate: estate, grant: grant);
    if (without <= 0) return 0;
    final with_ = stadiumIncome(estate: estate, grant: grant, mood: mood);
    return ((with_ - without) * 100 / without).round();
  }

  /// How many matches must pass between two protest (or two sell-out) posts:
  /// the stands make the point once, not after every result.
  static const int postGap = 5;

  /// Whether a result is a cue for the stands to protest, given the mood it
  /// left behind: furious after anything but a win, or restless after a
  /// humiliation.
  static bool protests(
    FanMoodReading after,
    ResultStanding standing, {
    required bool won,
  }) {
    if (won) return false;
    if (after.band == FanMoodBand.furious) return true;
    return after.band == FanMoodBand.restless &&
        standing == ResultStanding.humiliating;
  }

  /// Whether a result is a cue for the sold-out, best-team-in-years posts.
  static bool sellsOut(FanMoodReading after, {required bool won}) =>
      won && after.band == FanMoodBand.euphoric;
}
