import 'dart:math' as math;

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/ai_counter.dart';
import 'package:fnm/domain/services/match/ai_tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
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
    final setup = _opponentSetup(
      seed: i,
      managerRating: managerRating,
      opponentRating: opponentRating,
      scouted: aiCounters ? scouted : null,
    );
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

/// The AI opponent's setup for lab seed [seed]: `AiTactics.forOpponent` from
/// the two ratings, then, when [scouted] is set, `AiCounter.apply` against it
/// on a separate stream, as in a real fixture. Shared by [runCell] and
/// [runSkipCell] so a played and a skipped cell meet the same opponent.
AiSetup _opponentSetup({
  required int seed,
  required double managerRating,
  required double opponentRating,
  required ScoutedPlan? scouted,
}) {
  final base = AiTactics.forOpponent(
    opponentStrength: opponentRating,
    playerStrength: managerRating,
    seed: seed,
    style: NationStyle.balanced,
  );
  return AiCounter.apply(
    base: base,
    scouted: scouted,
    opponentStrength: opponentRating,
    style: NationStyle.balanced,
    // A separate stream from the posture's, as in a real fixture.
    seed: seed ^ 0x5C0D7,
  );
}

/// The mean overall of an XI built the way [runCell] builds one: the rating
/// the skip path's strength is derived from, so both halves of a parity
/// comparison read the same squads.
double _xiOverall(LabPlan plan, int nationId, double rating) {
  final xi = _team(nationId: nationId, plan: plan, rating: rating).xi;
  return xi.fold<int>(0, (s, p) => s + p.overall) / xi.length;
}

/// [runCell]'s twin for a SKIPPED match: the same seeds, the same opponent
/// setups and the same squads, played through `RatingMatchSimulator` the way
/// the skip path plays the manager's match (`SeasonService._withManagerTactics`):
/// each side's strength is its XI's mean overall, the manager's is lifted by
/// [MatchEngine.planEffect] (rounded, as the skip path rounds it), and the
/// effect's openness widens or narrows both sides' xG.
///
/// Neutral venue, every seed both ways round, as in [runCell]. Only the
/// figures a parity check reads are reported, but in the same [LabStats].
LabStats runSkipCell({
  required LabPlan manager,
  required double managerRating,
  required double opponentRating,
  required bool aiCounters,
  int seeds = 1000,
  double predictability = 0,
}) {
  const sim = RatingMatchSimulator();
  const managerId = 1;
  const opponentId = 2;
  final scouted = ScoutedPlan(
    formation: manager.formation,
    instructions: manager.instructions,
    predictability: predictability,
  );
  final mine = _xiOverall(manager, managerId, managerRating);

  var gf = 0;
  var ga = 0;
  var wins = 0;
  var draws = 0;
  var losses = 0;
  var fourPlus = 0;
  var gdSum = 0;
  var gdSquares = 0;
  for (var i = 0; i < seeds; i++) {
    final setup = _opponentSetup(
      seed: i,
      managerRating: managerRating,
      opponentRating: opponentRating,
      scouted: aiCounters ? scouted : null,
    );
    final theirs = _xiOverall(
      (
        name: 'ai',
        formation: setup.formation,
        instructions: setup.instructions,
      ),
      opponentId,
      opponentRating,
    ).round();
    final effect = MatchEngine.planEffect(
      plan: manager.instructions,
      formation: manager.formation,
      opponent: setup.instructions,
      opponentFormation: setup.formation,
    );
    final boosted = (mine + effect.ratingDelta).round();
    for (final managerAtHome in const [true, false]) {
      final r = sim.simulate(
        homeStrength: managerAtHome ? boosted : theirs,
        awayStrength: managerAtHome ? theirs : boosted,
        rng: SeededRng.forFixture(0x7AB0, i),
        homeAdvantage: false,
        openness: effect.openness,
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

/// Plays lab plan [a] at [aRating] against lab plan [b] at [bRating], no AI
/// on either side: [seeds] x 2 neutral-venue matches, every seed both ways
/// round, reported from [a]'s side. The plan-against-plan grid the lab's
/// guards read ("no dominant plan", "squad still decides").
LabStats runPair(
  LabPlan a,
  LabPlan b, {
  double aRating = 80,
  double bRating = 80,
  int seeds = 1000,
}) {
  const engine = MatchEngine();
  var gf = 0;
  var ga = 0;
  var wins = 0;
  var draws = 0;
  var losses = 0;
  var fourPlus = 0;
  var gdSum = 0;
  var gdSquares = 0;
  for (var i = 0; i < seeds; i++) {
    for (final aAtHome in const [true, false]) {
      final x = _team(nationId: 1, plan: a, rating: aRating);
      final y = _team(nationId: 2, plan: b, rating: bRating);
      final r = engine.play(
        home: aAtHome ? x : y,
        away: aAtHome ? y : x,
        rng: SeededRng.forFixture(0x7AB1, i),
        neutralVenue: true,
      );
      final forA = aAtHome ? r.homeScore : r.awayScore;
      final forB = aAtHome ? r.awayScore : r.homeScore;
      gf += forA;
      ga += forB;
      final gd = forA - forB;
      gdSum += gd;
      gdSquares += gd * gd;
      if (gd > 0) {
        wins++;
      } else if (gd < 0) {
        losses++;
      } else {
        draws++;
      }
      if (forA + forB >= 4) fourPlus++;
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

/// [runPair] with real squads instead of flat ones: each side fields the
/// `bestEleven` of its [aSquad] / [bSquad] pool in its plan's shape, so every
/// attribute term of the match-up (pace duel, pass relief, press engine)
/// reads the real spread. Same seeds and venue handling as [runPair].
LabStats runSquadPair(
  LabPlan a,
  LabPlan b, {
  required List<Player> aSquad,
  required List<Player> bSquad,
  int seeds = 1000,
}) {
  MatchTeam team(LabPlan plan, List<Player> pool) {
    final byId = {for (final p in pool) p.id: p};
    return MatchTeam(
      nationId: pool.first.nationId,
      formation: plan.formation,
      instructions: plan.instructions,
      xi: [
        for (final id in bestEleven(plan.formation, pool))
          if (id != null) byId[id]!,
      ],
    );
  }

  final x = team(a, aSquad);
  final y = team(b, bSquad);
  const engine = MatchEngine();
  var gf = 0;
  var ga = 0;
  var wins = 0;
  var draws = 0;
  var losses = 0;
  var fourPlus = 0;
  var gdSum = 0;
  var gdSquares = 0;
  for (var i = 0; i < seeds; i++) {
    for (final aAtHome in const [true, false]) {
      final r = engine.play(
        home: aAtHome ? x : y,
        away: aAtHome ? y : x,
        rng: SeededRng.forFixture(0x7AB2, i),
        neutralVenue: true,
      );
      final forA = aAtHome ? r.homeScore : r.awayScore;
      final forB = aAtHome ? r.awayScore : r.homeScore;
      gf += forA;
      ga += forB;
      final gd = forA - forB;
      gdSum += gd;
      gdSquares += gd * gd;
      if (gd > 0) {
        wins++;
      } else if (gd < 0) {
        losses++;
      } else {
        draws++;
      }
      if (forA + forB >= 4) fourPlus++;
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
