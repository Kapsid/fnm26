import 'dart:math' as math;

/// One result as the public reads it: who was ranked where, and how it went.
typedef MoodResult = ({
  int nationRank,
  int opponentRank,
  bool won,
  bool drew,
});

/// What the country thinks of the manager, 0–100, neutral at 50.
///
/// Deliberately NOT a second copy of the board's form term. The board already
/// weighs recent results heavily, and a mood derived the same way would just
/// double-weight them and make the gauge twice as jumpy for no new
/// information. This measures what the board does not see: EXPECTATION against
/// REALITY. Beating a side far above you thrills people out of all proportion
/// to the point it earns; grinding past a minnow moves nobody; losing to one is
/// a catastrophe the table would call a minor setback.
abstract final class PublicMood {
  /// Where a public with no opinion sits.
  static const int neutral = 50;

  /// How many recent results the public remembers. Shorter than the board's
  /// window on purpose — this is a mob, not a committee.
  static const int window = 6;

  /// The public's verdict on [recent] (newest first).
  static int of(Iterable<MoodResult> recent) {
    final games = recent.take(window).toList();
    if (games.isEmpty) return neutral;
    var score = 0.0;
    var weightSum = 0.0;
    for (var i = 0; i < games.length; i++) {
      final g = games[i];
      // The newest result weighs most, and steeply: this is a mob. One great
      // day really does wipe out a bad month, which a linear taper never
      // manages — the older games simply out-number the new one.
      final weight = math.pow(0.55, i).toDouble();
      score += _verdict(g) * weight;
      weightSum += weight;
    }
    final avg = score / weightSum; // −1 … +1
    return (neutral + avg * 50).round().clamp(0, 100);
  }

  /// One result on a −1 … +1 scale, judged against the ranking gap.
  static double _verdict(MoodResult g) {
    // How much the public EXPECTED to win: +1 when the opponent is ranked far
    // worse (a higher number is a worse rank), −1 when they are far better.
    final expected =
        ((g.opponentRank - g.nationRank) / 60.0).clamp(-1.0, 1.0);
    if (g.won) {
      // Beating a better side is everything; beating a worse one is the job,
      // and the floor keeps it from reading as a disappointment.
      return (0.15 - expected * 0.95).clamp(0.05, 1.0);
    }
    if (g.drew) {
      return (-0.25 - expected * 0.7).clamp(-1.0, 0.7);
    }
    // A defeat: forgiven against a giant, unforgivable against a minnow.
    return (-0.55 - expected * 0.5).clamp(-1.0, 0.15);
  }

  /// What the public's mood does to the board.
  ///
  /// Sized like the ranking bonus — the board reading the room, not being
  /// governed by it. ZERO at [neutral], so a board with no public opinion to
  /// weigh behaves exactly as it did before this existed.
  static int boardShift(int publicMood) =>
      ((publicMood - neutral) / 10).round().clamp(-5, 5);
}
