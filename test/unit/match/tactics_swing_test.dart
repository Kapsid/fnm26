import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';

import '../../helpers/fixtures.dart';

/// THE GUARD FOR TASK 16 — "do the tactical dials do anything?"
///
/// The feedback behind this file was that the tactics screen felt decorative:
/// a manager could drill one shape for four years and pick the textbook
/// counter to the opponent's plan and see no difference in the results. The
/// engine WAS applying both — just at a magnitude a human could not detect
/// over a career.
///
/// So this pins the intent rather than a constant:
///
///   A drilled, well-judged side should be worth roughly A GOAL EVERY THREE OR
///   FOUR GAMES against an identical side that is neither — not a goal every
///   game.
///
/// The bounds below sit either side of that, so the test fails in BOTH
/// directions: too small and the dial is back to being invisible (the original
/// complaint), too large and squad quality stops deciding football matches (the
/// risk this change introduces).
///
/// The two sides are deliberately IDENTICAL in every flat term. The plans are
/// chosen so that the flat attack/defence contributions in `MatchEngine._attack`
/// and `._defence` cancel exactly (see [_wellJudged] / [_outplanned]): the only
/// things separating them are the match-up (`MatchEngine._matchup`) and the
/// chemistry multiplier (`TeamChemistry.factor`). That is what makes this a
/// guard on TACTICS and not an accidental guard on the mentality slider.

/// The counter-plan: direct into a high line, pressing the build-up, and
/// stretching a narrow block. Every dial that carries a flat bonus is left
/// neutral or mirrored by [_outplanned].
const _wellJudged = TacticalInstructions(
  pressing: 80,
  width: 80,
  directness: 80,
  defensiveLine: 70,
);

/// The plan it is aimed at: slow possession behind the same high line, narrow
/// and passive. Its pressing/width flat terms are the exact mirror of
/// [_wellJudged]'s, so neither side starts the match a rating point ahead.
const _outplanned = TacticalInstructions(
  pressing: 20,
  width: 20,
  directness: 20,
  defensiveLine: 70,
);

/// A one-sided plan that moves only the FLAT dials — the line, the tempo and
/// the press — leaving width and directness neutral so `MatchEngine._matchup`
/// contributes nothing and these constants are measured alone. Nothing else in
/// the repo covers them: this file's other cases mirror them exactly, and both
/// older balance guards run at a neutral 50 on every slider, where every
/// `(i.x - 50)` term is zero.
const _forward = TacticalInstructions(
  defensiveLine: 85,
  tempo: 85,
  pressing: 30,
);

/// Its opposite number: deep, slow, and pressing to make up for it.
const _cautious = TacticalInstructions(
  defensiveLine: 30,
  tempo: 30,
  pressing: 70,
);

/// Two sides with nothing chosen at all — the baseline every flat dial is
/// measured against, since each one contributes exactly zero at 50.
const _neutral = TacticalInstructions();

MatchTeam _team(int nationId, TacticalInstructions instructions) {
  final positions = Formation.f433.positions;
  return MatchTeam(
    nationId: nationId,
    instructions: instructions,
    xi: [
      for (var i = 0; i < 11; i++)
        player(
          id: nationId * 100 + i,
          nationId: nationId,
          position: positions[i],
          attributes: flatAttributes(82),
        ),
    ],
  );
}

typedef Swing = ({
  double goalDiffPerGame,
  double pointsPerGameEdge,
  double goalsPerGame,
});

/// Plays [seeds] x 2 neutral-venue matches — EVERY seed played twice, once with
/// the drilled side at home and once with it away — and reports what the
/// drilling and the plan were worth per match.
///
/// Playing each seed BOTH ways is the whole point, and it is not the obvious
/// alternative of swapping ends on alternate seeds. That version shipped first
/// and was wrong: `drilledAtHome = i.isEven` ties the venue slot to the PARITY
/// of the seed index, and `SeededRng.forFixture` is not parity-neutral, so the
/// two ends were sampled from systematically different streams. The null case
/// below — identical sides, identical plans, identical chemistry, which must
/// read zero — came out at +0.083 on 2000 seeds and +0.041 on 20000, a 3-sigma
/// bias that inflated every figure this file measures by about 0.08. Pairing
/// each seed with itself cancels the venue slot exactly instead of relying on
/// it to average out.
///
/// Home advantage is off as well, so nothing but the tactics can show up in
/// the difference.
Swing swing({
  required double familiarity,
  required double predictability,
  required TacticalInstructions plan,
  required TacticalInstructions counterPlan,
  int seeds = 1000,
}) {
  const engine = MatchEngine();
  const drilledId = 1;
  const ordinaryId = 2;
  var drilledGoals = 0;
  var ordinaryGoals = 0;
  var drilledPoints = 0;
  var ordinaryPoints = 0;
  for (var i = 0; i < seeds; i++) {
    for (final drilledAtHome in const [true, false]) {
      final drilled = _team(drilledId, plan);
      final ordinary = _team(ordinaryId, counterPlan);
      final r = engine.play(
        home: drilledAtHome ? drilled : ordinary,
        away: drilledAtHome ? ordinary : drilled,
        rng: SeededRng.forFixture(0x7AC7, i),
        neutralVenue: true,
        chemistryByNation: {
          drilledId: TeamChemistry.factor(familiarity, predictability),
        },
      );
      final forDrilled = drilledAtHome ? r.homeScore : r.awayScore;
      final forOrdinary = drilledAtHome ? r.awayScore : r.homeScore;
      drilledGoals += forDrilled;
      ordinaryGoals += forOrdinary;
      if (forDrilled > forOrdinary) {
        drilledPoints += 3;
      } else if (forDrilled < forOrdinary) {
        ordinaryPoints += 3;
      } else {
        drilledPoints += 1;
        ordinaryPoints += 1;
      }
    }
  }
  final matches = seeds * 2;
  return (
    goalDiffPerGame: (drilledGoals - ordinaryGoals) / matches,
    pointsPerGameEdge: (drilledPoints - ordinaryPoints) / matches,
    goalsPerGame: (drilledGoals + ordinaryGoals) / matches,
  );
}

void main() {
  group('the harness itself', () {
    test('two identical sides with identical plans read exactly nothing', () {
      // THE NULL CONTROL, and the reason this file can be trusted at all.
      //
      // The first version of this guard swapped ends on alternate seeds
      // (`drilledAtHome = i.isEven`). That ties the venue slot to the PARITY of
      // the seed index, and `SeededRng.forFixture` is not parity-neutral, so
      // the two ends drew from systematically different streams: this control
      // read +0.083 on 2000 seeds and +0.041 on 20000 (3.2 sigma), and every
      // headline figure in the file was inflated by about that much. Playing
      // each seed BOTH ways cancels it exactly rather than hoping it averages
      // out.
      //
      // This assertion is cheap, it is the one that would have caught the bug,
      // and it must never be deleted.
      final nothing = swing(
        familiarity: 0,
        predictability: 0,
        plan: _outplanned,
        counterPlan: _outplanned,
      );
      expect(nothing.goalDiffPerGame.abs(), lessThan(0.01));
      expect(nothing.pointsPerGameEdge.abs(), lessThan(0.01));

      // Equal chemistry on both sides must cancel too, not just equal plans.
      final drilledBoth = swing(
        familiarity: 0,
        predictability: 0,
        plan: _neutral,
        counterPlan: _neutral,
      );
      expect(drilledBoth.goalDiffPerGame.abs(), lessThan(0.01));
    });
  });

  group('tactics are worth something the manager can feel', () {
    test('a drilled, well-judged side beats an identical one that is neither', () {
      // The side a long-serving manager actually HAS: the shape drilled to the
      // hilt, and — because he has kept naming it — thoroughly scouted. Pricing
      // the artificial familiarity-without-predictability case instead would
      // flatter a state the game rarely produces; that one is pinned separately
      // below as the ceiling.
      final s = swing(
        familiarity: 1,
        predictability: 1,
        plan: _wellJudged,
        counterPlan: _outplanned,
      );

      // THE BAND. Roughly a goal every three or four games (0.25-0.33), with
      // room either side. Measures 0.3255 as written (0.311 before the two
      // width terms in `_matchup` were separated — see the width case below;
      // the wide reading is worth a shade more than the narrow one, so the
      // drilled side keeps a little of what it used to hand back).
      //
      // Lower bound: below this the manager is right — the dials do nothing.
      // On the constants that drew the feedback, and on THIS corrected harness,
      // the same match-up measured 0.090: one goal every eleven games from
      // drilling AND out-thinking the opponent put together.
      //
      // Upper bound: above this a plan starts beating a better squad, and the
      // game stops being about players. Note what it is not allowed to reach:
      // a goal a game.
      expect(
        s.goalDiffPerGame,
        inInclusiveRange(0.18, 0.45),
        reason:
            'a drilled, well-judged side should be worth about a goal every '
            'three or four games — not nothing, and not one a game',
      );

      // The same statement in the currency the manager actually reads.
      expect(s.pointsPerGameEdge, inInclusiveRange(0.22, 0.70));
    });

    test('the best a manager can do still does not run away with it', () {
      // The ceiling: the same drilled shape, kept unpredictable by varying the
      // plan behind it, plus the right plan on the day. This is the most
      // tactics can ever be worth between two identical squads, and it must
      // stay well short of a goal a game. Measures 0.4815.
      final s = swing(
        familiarity: 1,
        predictability: 0,
        plan: _wellJudged,
        counterPlan: _outplanned,
      );
      expect(s.goalDiffPerGame, lessThan(0.70));
      // …and still clearly better than being read, or there is no reason to
      // vary the plan.
      final read = swing(
        familiarity: 1,
        predictability: 1,
        plan: _wellJudged,
        counterPlan: _outplanned,
      );
      expect(s.goalDiffPerGame, greaterThan(read.goalDiffPerGame));
    });

    test('the instruction dials carry a real share of it on their own', () {
      // THE DIAL GUARD. Both sides equally unfamiliar, so the chemistry
      // multiplier cancels and the ONLY thing left is the plan: the sliders on
      // the tactics screen, judged against the opponent's shape.
      //
      // This is what the feedback was about. On the old constants, measured on
      // this corrected harness, picking the textbook counter was worth −0.038
      // of a goal a game — not merely nothing, marginally WORSE than not
      // bothering. Measures +0.090 now (+0.056 before the width terms in
      // `_matchup` were separated: the double pay was identical on both sides
      // and so cancelled here, and paying each side once leaves the wide
      // reading its intended 7.5-against-6.0 edge).
      //
      // The band is small on purpose. Out-thinking an opponent should be worth
      // about a goal every twenty games by itself; the rest of what a good
      // manager gets comes from drilling the shape, which is the slower and
      // more expensive thing to earn.
      final planOnly = swing(
        familiarity: 0,
        predictability: 0,
        plan: _wellJudged,
        counterPlan: _outplanned,
      );
      expect(
        planOnly.goalDiffPerGame,
        inInclusiveRange(0.025, 0.11),
        reason:
            'reading the opponent right should be worth something real and '
            'small — and never, as it once did, less than nothing',
      );

      // And it must be a genuine ADDITION to the drilling, not absorbed by it.
      final drillingOnly = swing(
        familiarity: 1,
        predictability: 1,
        plan: _outplanned,
        counterPlan: _outplanned,
      );
      final both = swing(
        familiarity: 1,
        predictability: 1,
        plan: _wellJudged,
        counterPlan: _outplanned,
      );
      expect(
        both.goalDiffPerGame - drillingOnly.goalDiffPerGame,
        greaterThan(0.05),
      );
    });

    test('the flat dials open a game up or shut it down', () {
      // COVERAGE FOR THE FLAT TERMS in `_attack` / `_defence` — the line, the
      // tempo and the press. Every other case in this file mirrors them so
      // they cancel, and both older balance guards run at a neutral 50 where
      // they contribute zero, so without this they are measured nowhere.
      //
      // They do not show up in goal DIFFERENCE, and that is by design: each
      // dial's attacking gain is paired with a defensive cost, so pushing up
      // is a fair-ish bargain rather than free. What they move is how OPEN the
      // game is. A side playing a high line at a quick tempo against one
      // sitting deep and slow produces a more stretched, higher-scoring match
      // than two sides with nothing chosen.
      final base = swing(
        familiarity: 0,
        predictability: 0,
        plan: _neutral,
        counterPlan: _neutral,
      );
      final onesided = swing(
        familiarity: 0,
        predictability: 0,
        plan: _forward,
        counterPlan: _cautious,
      );
      final lift = onesided.goalsPerGame - base.goalsPerGame;
      // Measures +0.20 goals a match on a 2.52 baseline. On the old, halved
      // constants it was +0.13 — the sliders moved an attack about two rating
      // points end to end, which is a decoration rather than a decision.
      expect(
        lift,
        inInclusiveRange(0.15, 0.35),
        reason:
            'committing forward should visibly open the game up, without '
            'turning every match into a basketball score',
      );
      // The bargain stays fair: committing forward is favourable, never a
      // free win. Measures +0.15.
      expect(onesided.goalDiffPerGame.abs(), lessThan(0.30));
    });

    test('a width mismatch stretches a game, it does not double it', () {
      // WIDTH, FROM BOTH ENDS. A wide side against a narrow one is SUPPOSED to
      // open the game up at both ends — one stretches the block, the other
      // overloads the middle it left — so this is a band, not a ceiling. It
      // fails in both directions: too high and width is quietly inflating
      // every scoreline in the world, too low and the dial has been flattened
      // out of existence.
      //
      // It was a bare ceiling until 2026-09, when the two terms in
      // `MatchEngine._matchup` turned out to be the same expression written
      // twice (`n(a) * -n(d)` and `-n(a) * n(d)` are both `-n(a) * n(d)`), so
      // every side collected BOTH coefficients whenever the widths straddled
      // 50 — double pay, in either direction, cancelling out of goal
      // difference and so out of every other measurement in this file.
      // Separating the two cases halved it. The figures below are what each
      // case reads with each side paid once.
      final base = swing(
        familiarity: 0,
        predictability: 0,
        plan: _neutral,
        counterPlan: _neutral,
      );
      final mismatch = swing(
        familiarity: 0,
        predictability: 0,
        plan: const TacticalInstructions(width: 80),
        counterPlan: const TacticalInstructions(width: 20),
      );
      final extreme = swing(
        familiarity: 0,
        predictability: 0,
        plan: const TacticalInstructions(width: 100),
        counterPlan: const TacticalInstructions(width: 0),
      );

      // The neutral case is the anchor: at 50 on every dial both width terms
      // are exactly zero, so this must not move when width is retuned. 2.515.
      expect(base.goalsPerGame, inInclusiveRange(2.2, 2.9));

      // The bands are stated as a LIFT over that neutral baseline, so a future
      // change to overall scoring rates moves both ends together instead of
      // silently eating the headroom.
      //
      // An ordinary mismatch — wing play at 70-80 against a narrow counter,
      // which real playstyles produce constantly — is worth +0.166 of a goal
      // a game. Call it a goal every six matches: felt over a season, not over
      // a match. The double-paid version read +0.327 and fails this.
      final ordinaryLift = mismatch.goalsPerGame - base.goalsPerGame;
      expect(
        ordinaryLift,
        inInclusiveRange(0.06, 0.28),
        reason:
            'a routine width mismatch should open a game by a fraction of a '
            'goal — neither invisible nor a third of a scoreline',
      );

      // The extreme, which no sane plan reaches: touchline-to-touchline
      // against a side in a phone box. +0.467. Double-paid it read +0.874, a
      // third of the whole baseline scoreline, and fails this.
      final extremeLift = extreme.goalsPerGame - base.goalsPerGame;
      expect(
        extremeLift,
        inInclusiveRange(0.25, 0.70),
        reason:
            'even the most lopsided width mismatch imaginable must stay under '
            'half a goal-and-a-bit a game',
      );

      // And the shape has to stay monotonic: more mismatch, more open game.
      expect(extremeLift, greaterThan(ordinaryLift));
    });

    test('a side that has been read gives part of it back, never all of it', () {
      // Four years of the same eleven and the same plan: the video room has it.
      // The drilled side should still be ahead — continuity has to stay worth
      // having — but by clearly less.
      final fresh = swing(
        familiarity: 1,
        predictability: 0,
        plan: _outplanned,
        counterPlan: _outplanned,
      );
      final read = swing(
        familiarity: 1,
        predictability: 1,
        plan: _outplanned,
        counterPlan: _outplanned,
      );
      expect(read.goalDiffPerGame, lessThan(fresh.goalDiffPerGame));
      expect(
        read.goalDiffPerGame,
        greaterThan(0),
        reason: 'being read must never cost more than the drilling was worth',
      );
      // The same thing said about the constants, so a future tuning pass cannot
      // quietly invert them — nor let the video room take a bigger share of the
      // drilling than it does today.
      expect(
        TeamChemistry.readPenalty / TeamChemistry.drilledBonus,
        lessThanOrEqualTo(0.5),
      );
    });
  });
}
