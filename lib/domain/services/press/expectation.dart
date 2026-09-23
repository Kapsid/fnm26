/// How a result reads against what was expected of the side that got it.
///
/// One reading, shared. There were three before this existed and they
/// disagreed: [PublicMood] weighed expectation against reality properly and
/// told only the board about it; `YFeed.classify` re-derived its own ±25
/// ranking gap and used it to pick a sentence; the press ignored strength
/// altogether. So a sixtieth-ranked side holding the world champions and a
/// favourite scraping past a minnow drew the same coverage of the same
/// scoreline, and nothing anywhere in the game knew the difference.
enum ResultStanding {
  /// Nobody saw that coming. The country is beside itself.
  heroic,

  /// Better than the form book asked for.
  creditable,

  /// About what should have happened.
  par,

  /// Below what this side ought to be doing.
  poor,

  /// An embarrassment measured against who you are.
  humiliating,
}

/// The reading itself.
abstract final class Expectation {
  /// How much the side was EXPECTED to win, −1 … +1.
  ///
  /// +1 when the opponent is ranked far worse (a higher number is a worse
  /// rank), −1 when they are far better. Sixty places is the span over which
  /// a tie becomes a foregone conclusion — wide enough that the top twenty are
  /// not all "even", narrow enough that 90th vs 150th still reads as a gap.
  static double of({required int nationRank, required int opponentRank}) =>
      ((opponentRank - nationRank) / _rankSpan).clamp(-1.0, 1.0);

  static const double _rankSpan = 60;

  /// Where a result sits against what was expected of it.
  ///
  /// The whole judgement is one subtraction: what happened, minus what should
  /// have happened. A win is +1, a draw 0, a defeat −1, and [of] says what the
  /// form book asked for — so a minnow's win over a giant scores +2 and a
  /// favourite's defeat to one scores −2, on the same scale, without either
  /// needing a rule of its own.
  static ResultStanding standing({
    required int nationRank,
    required int opponentRank,
    required int scored,
    required int conceded,
    bool competitive = true,
  }) {
    final expected = of(nationRank: nationRank, opponentRank: opponentRank);
    final outcome = scored > conceded
        ? 1.0
        : scored == conceded
        ? 0.0
        : -1.0;
    var surprise = outcome - expected;
    // The scoreline on top of the result, damped by how much of it was
    // expected. A rout is only news when a rout was not the likely afternoon:
    // undamped, a favourite's routine 3–0 over a minnow scored the same bonus
    // as a minnow's 3–0 over a favourite, and read back as "creditable" — for
    // doing exactly the job. By the same token a heavy defeat to a far better
    // side is a scoreline, not a disgrace.
    final margin = scored - conceded;
    if (margin >= _routMargin) {
      surprise += _marginWeight * (1 - expected) / 2;
    }
    if (margin <= -_routMargin) {
      surprise -= _marginWeight * (1 + expected) / 2;
    }
    // A friendly is not nothing, but it is not evidence either: everything
    // pulls back toward "that happened, next" so a summer runaround does not
    // read as a crisis or a coronation.
    if (!competitive) surprise *= _friendlyDamping;

    if (surprise >= _heroicAt) return ResultStanding.heroic;
    if (surprise >= _creditableAt) return ResultStanding.creditable;
    if (surprise > _poorAt) return ResultStanding.par;
    if (surprise > _humiliatingAt) return ResultStanding.poor;
    return ResultStanding.humiliating;
  }

  /// A win by this many is a statement rather than a result.
  static const int _routMargin = 3;

  /// What that statement is worth, in surprise.
  static const double _marginWeight = 0.4;

  /// How much of a friendly's surprise survives.
  static const double _friendlyDamping = 0.45;

  static const double _heroicAt = 1.25;
  static const double _creditableAt = 0.35;
  static const double _poorAt = -0.35;
  static const double _humiliatingAt = -1.15;

  /// Whether a standing is worth raising your voice about, either way.
  ///
  /// The feed's volume hangs off this: an ordinary afternoon gets a line from
  /// the stats account, and everything else brings people out.
  static bool isLoud(ResultStanding s) =>
      s == ResultStanding.heroic || s == ResultStanding.humiliating;

  /// The standing as a signed step, −2 … +2. Used where a caller wants to
  /// weigh a run of results rather than name one.
  static int weight(ResultStanding s) => switch (s) {
    ResultStanding.heroic => 2,
    ResultStanding.creditable => 1,
    ResultStanding.par => 0,
    ResultStanding.poor => -1,
    ResultStanding.humiliating => -2,
  };
}
