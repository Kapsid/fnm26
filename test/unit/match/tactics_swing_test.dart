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

typedef Swing = ({double goalDiffPerGame, double pointsPerGameEdge});

/// Plays [n] neutral-venue matches, half with the drilled side at home, and
/// reports what the drilling and the plan were worth.
///
/// Home advantage is off and the sides swap ends every other match, so nothing
/// but the tactics can show up in the difference.
Swing swing({
  required double familiarity,
  required double predictability,
  required TacticalInstructions plan,
  required TacticalInstructions counterPlan,
  int n = 2000,
}) {
  const engine = MatchEngine();
  const drilledId = 1;
  const ordinaryId = 2;
  var drilledGoals = 0;
  var ordinaryGoals = 0;
  var drilledPoints = 0;
  var ordinaryPoints = 0;
  for (var i = 0; i < n; i++) {
    final drilledAtHome = i.isEven;
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
  return (
    goalDiffPerGame: (drilledGoals - ordinaryGoals) / n,
    pointsPerGameEdge: (drilledPoints - ordinaryPoints) / n,
  );
}

void main() {
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

      // THE BAND. Roughly a goal every three games, with room either side.
      //
      // Lower bound: below this the manager is right — the dials do nothing.
      // Before this was tuned the same match-up measured 0.16, which is one
      // goal every six games from drilling AND out-thinking the opponent put
      // together, and it failed here.
      //
      // Upper bound: above this a plan starts beating a better squad, and the
      // game stops being about players. Note what it is NOT allowed to reach:
      // a goal a game.
      expect(
        s.goalDiffPerGame,
        inInclusiveRange(0.22, 0.55),
        reason:
            'a drilled, well-judged side should be worth about a goal every '
            'three or four games — not nothing, and not one a game',
      );

      // The same statement in the currency the manager actually reads.
      expect(s.pointsPerGameEdge, inInclusiveRange(0.28, 0.85));
    });

    test('the best a manager can do still does not run away with it', () {
      // The ceiling: the same drilled shape, kept unpredictable by varying the
      // plan behind it, plus the right plan on the day. This is the most
      // tactics can ever be worth between two identical squads, and it must
      // stay well short of a goal a game.
      final s = swing(
        familiarity: 1,
        predictability: 0,
        plan: _wellJudged,
        counterPlan: _outplanned,
      );
      expect(s.goalDiffPerGame, lessThan(0.80));
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
      // multiplier cancels and the ONLY thing left is the plan: the six
      // sliders on the tactics screen, judged against the opponent's shape.
      //
      // This is the test that failed when the feedback was written. The plan
      // was worth 0.065 of a goal a game — real in a spreadsheet, invisible
      // across a career, which is exactly what "the dials aren't connected to
      // anything" feels like from the inside.
      final planOnly = swing(
        familiarity: 0,
        predictability: 0,
        plan: _wellJudged,
        counterPlan: _outplanned,
      );
      expect(
        planOnly.goalDiffPerGame,
        inInclusiveRange(0.08, 0.30),
        reason:
            'reading the opponent right should be worth roughly a goal every '
            'eight to ten games by itself',
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
