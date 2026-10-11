import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';

import '../../helpers/fixtures.dart';

/// A balance guard for the two simulators. Squad quality must decide matches —
/// but PROPORTIONATELY: two comparable sides (a Brazil against an Ecuador, a
/// dozen rating points apart) play a tight game, and only a genuine gulf runs
/// the score up. The bounds below are deliberately wide; they exist to catch a
/// tuning change that turns every mismatch into a rout, not to pin exact
/// numbers.

MatchTeam team(int nationId, int rating) {
  final positions = Formation.f433.positions;
  return MatchTeam(
    nationId: nationId,
    instructions: const TacticalInstructions(),
    xi: [
      for (var i = 0; i < 11; i++)
        player(
          id: nationId * 100 + i,
          nationId: nationId,
          position: positions[i],
          attributes: flatAttributes(rating),
        ),
    ],
  );
}

/// Aggregate outcome of a run of neutral-venue matches between two flat
/// squads.
typedef Sample = ({
  double homeGoals,
  double awayGoals,
  double homeWinPct,
  double drawPct,
  double routPct, // games settled by four goals or more
});

Sample sample(int homeRating, int awayRating, {int n = 600}) {
  const engine = MatchEngine();
  var hg = 0;
  var ag = 0;
  var hw = 0;
  var d = 0;
  var rout = 0;
  for (var i = 0; i < n; i++) {
    final r = engine.play(
      home: team(1, homeRating),
      away: team(2, awayRating),
      rng: SeededRng.forFixture(0x51DE, i),
      neutralVenue: true,
    );
    hg += r.homeScore;
    ag += r.awayScore;
    if (r.homeScore > r.awayScore) hw++;
    if (r.homeScore == r.awayScore) d++;
    if ((r.homeScore - r.awayScore).abs() >= 4) rout++;
  }
  return (
    homeGoals: hg / n,
    awayGoals: ag / n,
    homeWinPct: 100 * hw / n,
    drawPct: 100 * d / n,
    routPct: 100 * rout / n,
  );
}

void main() {
  group('MatchEngine balance', () {
    test('evenly matched sides play a realistic, tight game', () {
      final s = sample(84, 84);
      // ~2.7 goals a game between two good sides, split evenly.
      expect(s.homeGoals + s.awayGoals, inInclusiveRange(2.2, 3.3));
      expect((s.homeGoals - s.awayGoals).abs(), lessThan(0.25));
      expect(s.homeWinPct, inInclusiveRange(32, 46));
      expect(s.drawPct, greaterThan(18));
      // A four-goal margin between equals must stay a rarity.
      expect(s.routPct, lessThan(10));
    });

    test('a class apart wins more often without running up the score', () {
      // The Brazil-v-Ecuador case: a dozen rating points is a clear edge, not a
      // mismatch. The favourite should win around three times in five, the
      // underdog still take something from the game, and the scoreline stay in
      // believable territory.
      final s = sample(88, 76);
      expect(s.homeWinPct, inInclusiveRange(50, 70));
      // The underdog takes something from the game (a draw or a win) often
      // enough that the tie is worth playing.
      expect(100 - s.homeWinPct, greaterThan(30));
      expect(s.homeGoals, lessThan(2.4));
      expect(s.awayGoals, greaterThan(0.7));
      expect(s.routPct, lessThan(18));
    });

    test('a genuine gulf still shows on the scoreboard', () {
      // A superpower against a minnow is where a rout belongs.
      final s = sample(88, 45);
      expect(s.homeWinPct, greaterThan(90));
      expect(s.homeGoals, greaterThan(3.5));
      expect(s.awayGoals, lessThan(0.5));
    });

    test('the strength gap, not the absolute level, drives the result', () {
      // Two mid-table sides play much the same game as two elite ones.
      final elite = sample(84, 84, n: 400);
      final mid = sample(64, 64, n: 400);
      expect(
        (elite.homeGoals + elite.awayGoals) - (mid.homeGoals + mid.awayGoals),
        inInclusiveRange(-0.6, 0.6),
      );
    });
  });

  group('RatingMatchSimulator balance', () {
    ({
      double home,
      double away,
      double homeWinPct,
      double drawPct,
      double awayWinPct,
      double homeLosesByFourPct,
    })
    sim(int homeStrength, int awayStrength, {int n = 4000}) {
      const s = RatingMatchSimulator();
      var hg = 0;
      var ag = 0;
      var hw = 0;
      var dr = 0;
      var aw = 0;
      var routed = 0;
      for (var i = 0; i < n; i++) {
        final o = s.simulate(
          homeStrength: homeStrength,
          awayStrength: awayStrength,
          rng: SeededRng.forFixture(0xB0A7, i),
          homeAdvantage: false,
        );
        hg += o.homeScore;
        ag += o.awayScore;
        if (o.homeScore > o.awayScore) {
          hw++;
        } else if (o.homeScore == o.awayScore) {
          dr++;
        } else {
          aw++;
        }
        if (o.awayScore - o.homeScore >= 4) routed++;
      }
      return (
        home: hg / n,
        away: ag / n,
        homeWinPct: 100 * hw / n,
        drawPct: 100 * dr / n,
        awayWinPct: 100 * aw / n,
        homeLosesByFourPct: 100 * routed / n,
      );
    }

    // Bands measured on whole careers (see world_variance_test). The
    // background simulator was retuned on its own; MatchEngine, above, was
    // deliberately left as it was.

    test('equals stay equal, at a realistic scoring rate', () {
      for (final level in [85, 64]) {
        final even = sim(level, level);
        expect(even.home + even.away, inInclusiveRange(2.0, 2.8));
        // A neutral ground favours nobody — the nominal home slot used to
        // carry a second, hidden home advantage in its base xG.
        expect((even.homeWinPct - even.awayWinPct).abs(), lessThan(4));
      }
    });

    test('a top-six side beats a 34th-ranked one about two times in three', () {
      // Spain (88) against Turkey (79) at the start of a save. At the old
      // tuning this was 55/26/20: a favourite that lost one game in five.
      final gap = sim(88, 79);
      expect(gap.homeWinPct, inInclusiveRange(63, 74));
      expect(gap.drawPct, inInclusiveRange(17, 26));
      expect(gap.away, greaterThan(0.5), reason: 'the underdog still scores');
      expect(gap.home + gap.away, inInclusiveRange(2.2, 2.9));
      // A favourite thrashed by four is a once-a-decade story, not a habit.
      expect(gap.homeLosesByFourPct, lessThanOrEqualTo(0.1));
    });

    test('a genuine gulf is still a rout, not a cricket score', () {
      final gulf = sim(89, 48);
      expect(gulf.homeWinPct, greaterThan(95));
      expect(gulf.home, greaterThan(3.3));
      expect(gulf.away, lessThan(0.5));
    });

    test('a level background knockout leans to the better side', () {
      // Extra time and penalties used to be split by the raw share 88/168 =
      // 0.52, a coin toss. The background path now hands `decideKnockout` the
      // simulator's knockout weights instead.
      var better = 0;
      const n = 4000;
      for (var i = 0; i < n; i++) {
        final ko = WorldCupFinals.decideKnockout(
          1,
          1,
          SeededRng.forFixture(0x0C0A, i),
          homeStrength: RatingMatchSimulator.knockoutWeight(88),
          awayStrength: RatingMatchSimulator.knockoutWeight(80),
        );
        if (ko.homeWon) better++;
      }
      // Printed so the number is on the record, not just asserted.
      // ignore: avoid_print
      print(
        'level knockout, 88 v 80: ${(100 * better / n).toStringAsFixed(1)}%',
      );
      expect(100 * better / n, inInclusiveRange(58, 75));
    });
  });
}
