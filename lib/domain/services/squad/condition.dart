import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/club/club_form.dart';

/// A player's short-term form, from their recent match ratings.
enum PlayerForm { onFire, good, steady, poor, cold }

/// A player's physical freshness, from how heavily they've been played lately.
enum FatigueState { fresh, ready, tired, exhausted }

/// A player's live condition: form (recent ratings), fatigue (recent minutes)
/// and the net adjustment to their effective rating in the next match.
typedef PlayerCondition = ({
  PlayerForm form,
  double formRating, // average of recent ratings (0 if none)
  FatigueState fatigueState,
  int gamesInWindow, // appearances counted toward fatigue
  int overallDelta, // net rating shift applied in the match

  /// Where he stands at his club, or null when it was not supplied.
  ClubStanding? clubStanding,
});

/// Derives form, fatigue and morale from data already recorded (match ratings,
/// appearance dates, recent results) — no extra state to persist. All pure so
/// the effects stay deterministic and are easy to test and tune.
abstract final class Condition {
  /// The neutral match rating; form is measured as deviation from it.
  static const double _baseline = 6.7;

  /// How many recent matches make up the form window.
  static const int formWindow = 5;

  /// Appearances within this many days count toward fatigue; older ones have
  /// been rested off.
  static const int fatigueWindowDays = 14;

  /// A player's form from their [recentRatings] (newest first). Fewer than two
  /// games reads as [PlayerForm.steady] — not enough to judge.
  static ({PlayerForm state, double avg, int delta}) form(
    List<double> recentRatings,
  ) {
    final window = recentRatings.take(formWindow).toList();
    if (window.length < 2) {
      return (state: PlayerForm.steady, avg: 0, delta: 0);
    }
    final avg = window.reduce((a, b) => a + b) / window.length;
    final delta = ((avg - _baseline) * 1.8).clamp(-4.0, 4.0).round();
    final state = avg >= 7.6
        ? PlayerForm.onFire
        : avg >= 7.05
            ? PlayerForm.good
            : avg >= 6.4
                ? PlayerForm.steady
                : avg >= 5.9
                    ? PlayerForm.poor
                    : PlayerForm.cold;
    return (state: state, avg: avg, delta: delta);
  }

  /// A player's fatigue from their [appearanceDates] (newest first) relative to
  /// [asOf]. Games stack up across a tournament or double-header; a long rest
  /// clears it. Returns the state, the games counted, and a rating penalty.
  static ({FatigueState state, int games, int delta}) fatigue(
    List<DateTime> appearanceDates,
    DateTime asOf,
  ) {
    final cutoff = asOf.subtract(const Duration(days: fatigueWindowDays));
    final games = appearanceDates
        .where((d) => !d.isAfter(asOf) && d.isAfter(cutoff))
        .length;
    final (state, delta) = switch (games) {
      <= 1 => (FatigueState.fresh, 0),
      2 => (FatigueState.ready, -1),
      3 => (FatigueState.tired, -2),
      4 => (FatigueState.tired, -4),
      _ => (FatigueState.exhausted, -6),
    };
    return (state: state, games: games, delta: delta);
  }

  /// A player's overall condition from their recent ratings + appearance dates.
  ///
  /// [travelFatigue] scales how heavily a congested run of games weighs — the
  /// base camp's contribution during a tournament (under 1 = a squad that
  /// isn't spending the month on a coach). [campBonus] is that camp's flat lift
  /// to sharpness. Both default to no effect, which is every match outside a
  /// tournament.
  static PlayerCondition of(
    List<double> recentRatings,
    List<DateTime> appearanceDates,
    DateTime asOf,
    int moraleDelta, {
    double travelFatigue = 1,
    int campBonus = 0,
    int clubDelta = 0,
    ClubStanding? clubStanding,
  }) {
    final f = form(recentRatings);
    final t = fatigue(appearanceDates, asOf);
    final tired = (t.delta * travelFatigue).round();
    final net =
        (f.delta + tired + moraleDelta + campBonus + clubDelta).clamp(-9, 6);
    return (
      form: f.state,
      formRating: f.avg,
      fatigueState: t.state,
      gamesInWindow: t.games,
      overallDelta: net,
      clubStanding: clubStanding,
    );
  }

  /// Team morale (0–100, 50 neutral) from the nation's [fixtures] — the last
  /// few competitive results, most recent weighted heaviest. A friendly counts
  /// for less. Wins lift morale, defeats sap it.
  static int morale(List<Fixture> fixtures, int nationId) {
    final played = [
      for (final f in fixtures)
        if (f.hasResult) f,
    ]..sort((a, b) => b.date.compareTo(a.date)); // newest first
    if (played.isEmpty) return 50;
    var score = 0.0;
    var weightSum = 0.0;
    for (var i = 0; i < played.length && i < 6; i++) {
      final f = played[i];
      final isHome = f.homeNationId == nationId;
      final gf = isHome ? f.homeScore! : f.awayScore!;
      final ga = isHome ? f.awayScore! : f.homeScore!;
      final outcome = gf > ga
          ? 1.0
          : gf < ga
              ? -1.0
              : 0.0;
      final friendly = f.round == 'FRIENDLY';
      final weight = (6 - i) * (friendly ? 0.4 : 1.0);
      score += outcome * weight;
      weightSum += weight;
    }
    if (weightSum == 0) return 50;
    // Map the weighted W/D/L average (−1…1) onto 15…85 around a neutral 50.
    return (50 + (score / weightSum) * 35).clamp(0, 100).round();
  }

  /// The rating shift applied team-wide from [moraleValue] (0–100): −3…+3.
  static int moraleDelta(int moraleValue) =>
      ((moraleValue - 50) / 50 * 3).clamp(-3.0, 3.0).round();

  /// A short label for a morale value, for the hub badge.
  static String moraleLabel(int m) => m >= 78
      ? 'Buoyant'
      : m >= 60
          ? 'Positive'
          : m >= 42
              ? 'Settled'
              : m >= 25
                  ? 'Uneasy'
                  : 'Rock bottom';
}
