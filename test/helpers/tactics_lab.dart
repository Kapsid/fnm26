import 'dart:math' as math;

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/ai_counter.dart';
import 'package:fnm/domain/services/match/ai_tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';

import 'fixtures.dart';

/// THE TACTICS LAB: a repeatable measurement of what a manager's plan is worth.
///
/// It exists so that changes to how `MatchEngine` weighs tactics can be judged
/// by numbers (goals for, goals against, results, spread) instead of by feel.
/// The report test in `test/unit/match/tactics_lab_test.dart` prints one row
/// per plan; the figures from before any change live in
/// `docs/superpowers/specs/2026-10-16-tactics-lab-results.md`.

/// A named manager plan: a shape and the six dials.
typedef LabPlan = ({
  String name,
  Formation formation,
  TacticalInstructions instructions,
});

/// The seven plans the lab compares. `neutral` is the control every other row
/// is read against.
const List<LabPlan> labPlans = [
  (
    name: 'neutral',
    formation: Formation.f433,
    instructions: TacticalInstructions(),
  ),
  (
    name: 'allOutAttack',
    formation: Formation.f424,
    instructions: TacticalInstructions(
      mentality: 90,
      defensiveLine: 75,
      tempo: 75,
    ),
  ),
  (
    name: 'parkTheBus',
    formation: Formation.f541,
    instructions: TacticalInstructions(
      mentality: 15,
      defensiveLine: 25,
      pressing: 30,
    ),
  ),
  (
    name: 'highPress',
    formation: Formation.f433,
    instructions: TacticalInstructions(
      pressing: 90,
      defensiveLine: 80,
      tempo: 70,
    ),
  ),
  (
    name: 'possession',
    formation: Formation.f4231,
    instructions: TacticalInstructions(directness: 20, tempo: 40),
  ),
  (
    name: 'counter',
    formation: Formation.f4141,
    instructions: TacticalInstructions(
      mentality: 35,
      directness: 80,
      defensiveLine: 30,
      tempo: 70,
    ),
  ),
  (
    name: 'wide',
    formation: Formation.f343,
    instructions: TacticalInstructions(width: 85),
  ),
];

/// Per-match averages for the manager's side over a cell.
///
/// `gdSpread` is the standard deviation of the goal difference and `fourPlus`
/// the share of matches with four or more goals in total.
typedef LabStats = ({
  double gf,
  double ga,
  double total,
  double win,
  double draw,
  double loss,
  double gdSpread,
  double fourPlus,
});

MatchTeam _team({
  required int nationId,
  required LabPlan plan,
  required double rating,
}) {
  final positions = plan.formation.positions;
  return MatchTeam(
    nationId: nationId,
    instructions: plan.instructions,
    formation: plan.formation,
    xi: [
      for (var i = 0; i < 11; i++)
        player(
          id: nationId * 100 + i,
          nationId: nationId,
          position: positions[i],
          attributes: flatAttributes(rating.round()),
        ),
    ],
  );
}

/// Plays [seeds] x 2 neutral-venue matches of [manager] against an AI opponent
/// and averages the manager's side.
///
/// Every seed is played BOTH ways round (manager at home, then away) with the
/// same fixture seed, and home advantage is off. Alternating ends by seed
/// parity instead is biased, because `SeededRng.forFixture` is not
/// parity-neutral; `tactics_swing_test.dart` documents the +0.08 goal ghost it
/// produced. Pairing each seed with itself cancels the venue slot exactly.
///
/// The opponent's setup comes from `AiTactics.forOpponent` using the two
/// ratings and the seed, as a real fixture would, with a balanced nation style.
/// All players on a side sit at that side's rating.
///
/// With [aiCounters] the opponent then bends that setup with
/// `AiCounter.apply`, scouting the manager's own lab plan at [predictability]
/// (as if he had fielded exactly this plan in his recent matches). Without it
/// the opponent plays the uncountered posture. [predictability] no longer
/// moves the chemistry (`TeamChemistry.factor` ignores it), only the counter.
LabStats runCell({
  required LabPlan manager,
  required double managerRating,
  required double opponentRating,
  required bool aiCounters,
  int seeds = 1000,
  double familiarity = 0,
  double predictability = 0,
}) {
  const engine = MatchEngine();
  const managerId = 1;
  const opponentId = 2;
  final chemistry = {managerId: TeamChemistry.factor(familiarity)};
  final scouted = ScoutedPlan(
    formation: manager.formation,
    instructions: manager.instructions,
    predictability: predictability,
  );

  var gf = 0;
  var ga = 0;
  var wins = 0;
  var draws = 0;
  var losses = 0;
  var fourPlus = 0;
  var gdSum = 0;
  var gdSquares = 0;
  for (var i = 0; i < seeds; i++) {
    final base = AiTactics.forOpponent(
      opponentStrength: opponentRating,
      playerStrength: managerRating,
      seed: i,
      style: NationStyle.balanced,
    );
    final setup = aiCounters
        ? AiCounter.apply(
            base: base,
            scouted: scouted,
            opponentStrength: opponentRating,
            style: NationStyle.balanced,
            // A separate stream from the posture's, as in a real fixture.
            seed: i ^ 0x5C0D7,
          )
        : base;
    final opponentPlan = (
      name: 'ai',
      formation: setup.formation,
      instructions: setup.instructions,
    );
    for (final managerAtHome in const [true, false]) {
      final mine = _team(
        nationId: managerId,
        plan: manager,
        rating: managerRating,
      );
      final theirs = _team(
        nationId: opponentId,
        plan: opponentPlan,
        rating: opponentRating,
      );
      final r = engine.play(
        home: managerAtHome ? mine : theirs,
        away: managerAtHome ? theirs : mine,
        rng: SeededRng.forFixture(0x7AB0, i),
        neutralVenue: true,
        chemistryByNation: chemistry,
      );
      final forMe = managerAtHome ? r.homeScore : r.awayScore;
      final against = managerAtHome ? r.awayScore : r.homeScore;
      gf += forMe;
      ga += against;
      final gd = forMe - against;
      gdSum += gd;
      gdSquares += gd * gd;
      if (gd > 0) {
        wins++;
      } else if (gd < 0) {
        losses++;
      } else {
        draws++;
      }
      if (forMe + against >= 4) fourPlus++;
    }
  }
  final n = seeds * 2;
  final meanGd = gdSum / n;
  return (
    gf: gf / n,
    ga: ga / n,
    total: (gf + ga) / n,
    win: wins / n,
    draw: draws / n,
    loss: losses / n,
    gdSpread: math.sqrt(math.max(0, gdSquares / n - meanGd * meanGd)),
    fourPlus: fourPlus / n,
  );
}

/// Renders [rows] (label to stats) as a markdown table.
String labTable(Map<String, LabStats> rows) {
  String f(double v) => v.toStringAsFixed(2);
  String pct(double v) => '${(v * 100).toStringAsFixed(1)}%';
  final b = StringBuffer()
    ..writeln(
      '| Cell | GF | GA | Total | Win | Draw | Loss | GD sd | 4+ goals |',
    )
    ..writeln('|---|---|---|---|---|---|---|---|---|');
  rows.forEach((label, s) {
    b.writeln(
      '| $label | ${f(s.gf)} | ${f(s.ga)} | ${f(s.total)} | ${pct(s.win)} '
      '| ${pct(s.draw)} | ${pct(s.loss)} | ${f(s.gdSpread)} '
      '| ${pct(s.fourPlus)} |',
    );
  });
  return b.toString();
}
