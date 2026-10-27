import 'dart:math' as math;

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/match/ai_counter.dart';
import 'package:fnm/domain/services/match/ai_substitutions.dart';
import 'package:fnm/domain/services/match/ai_tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';
import 'package:fnm/domain/services/match/mid_tier_difficulty.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';

import 'fixtures.dart';

/// THE DIFFICULTY LAB: what a manager's side is worth against an AI side,
/// against what the same fixture is worth when the AI plays both ends.
///
/// Three ways to play one fixture, all on the same seeds and both ways round
/// (each seed once with the manager at home, once away, home advantage ON, as
/// in a qualifier):
///  * [labPlayed]: `MatchEngine`, set up the way `match_providers` sets up a
///    live match (an AI opponent from `AiTactics.forOpponent` bent by
///    `AiCounter` at predictability 0.5, managing itself by the scoreline,
///    both sides making the AI's planned substitutions, the manager's side
///    with its chemistry and the scout's dossier);
///  * [labSkipped]: `RatingMatchSimulator`, set up the way
///    `SeasonService._withManagerTactics` lifts the manager's side;
///  * [labWorld]: `RatingMatchSimulator` with nobody's plan, as the world
///    plays the same two nations.
///
/// Background strengths blend the XI with the ranking anchor exactly as
/// `SeasonService._squadStrength` does (0.75 x XI + 0.25 x
/// `RatingMatchSimulator.strengthOf`). The ranking a squad of a given rating
/// typically holds is read off [typicalRankFor], the start-of-save world.
///
/// All players on a side sit at the side's rating.

/// One cell's averages, from the manager's side.
typedef DifficultyStats = ({
  double points,
  double win,
  double draw,
  double loss,
});

/// What the manager has going for him beyond the squad.
typedef ManagerEdge = ({String name, double familiarity, StaffTier scout});

const ManagerEdge bareEdge = (
  name: 'bare',
  familiarity: 0,
  scout: StaffTier.none,
);
const ManagerEdge typicalEdge = (
  name: 'drilled+scout',
  familiarity: 0.75,
  scout: StaffTier.good,
);

/// The typical world ranking of a nation whose best eleven averages [rating],
/// read off the start-of-save world (best-XI overall ordered, 209 nations):
/// 89 is first, 81 about 26th, 70 about 66th, 64 about 91st, 56 about 131st.
int typicalRankFor(double rating) {
  const table = <(double, int)>[
    (89, 1), (86, 8), (84, 14), (83, 21), (81, 26), (80, 31), (78, 36), //
    (76, 41), (75, 46), (73, 51), (72, 56), (71, 61), (70, 66), (68, 71),
    (67, 76), (66, 81), (65, 86), (64, 91), (63, 96), (61, 101), (60, 111),
    (59, 116), (58, 121), (57, 126), (56, 131), (55, 136), (54, 141),
    (52, 151), (50, 161), (48, 171), (45, 186), (42, 206),
  ];
  if (rating >= table.first.$1) return 1;
  for (var i = 1; i < table.length; i++) {
    final (hiR, hiRank) = table[i - 1];
    final (loR, loRank) = table[i];
    if (rating >= loR) {
      final t = (hiR - rating) / (hiR - loR);
      return (hiRank + t * (loRank - hiRank)).round();
    }
  }
  return table.last.$2;
}

/// A side's background strength, as `SeasonService._squadStrength` reads it.
int backgroundStrength(double rating) {
  final ranked = RatingMatchSimulator.strengthOf(
    nation(id: 0, ranking: typicalRankFor(rating)),
  );
  return (rating * 0.75 + ranked * 0.25).round().clamp(40, 92);
}

List<Player> _flat(int nationId, Formation f, double rating, {int from = 0}) {
  final positions = f.positions;
  return [
    for (var i = 0; i < 11; i++)
      player(
        id: nationId * 100 + from + i,
        nationId: nationId,
        position: positions[i],
        attributes: flatAttributes(rating.round()),
      ),
  ];
}

const _managerId = 1;
const _opponentId = 2;
const TacticalInstructions _plan = TacticalInstructions();
const Formation _formation = Formation.f433;

AiSetup _opponentSetup(int seed, double mine, double theirs) {
  final base = AiTactics.forOpponent(
    opponentStrength: theirs,
    playerStrength: mine,
    seed: seed,
    style: NationStyle.balanced,
  );
  return AiCounter.apply(
    base: base,
    scouted: const ScoutedPlan(
      formation: _formation,
      instructions: _plan,
      predictability: 0.5,
    ),
    opponentStrength: theirs,
    style: NationStyle.balanced,
    seed: seed ^ 0x5C0D7,
  );
}

DifficultyStats _stats(int w, int d, int l) {
  final n = w + d + l;
  return (points: (3 * w + d) / n, win: w / n, draw: d / n, loss: l / n);
}

/// The manager's side played out in `MatchEngine`. [difficulty] applies
/// [MidTierDifficulty] exactly as `match_providers` does; off gives the
/// engine as it was before it existed.
DifficultyStats labPlayed({
  required double mine,
  required double theirs,
  ManagerEdge edge = bareEdge,
  bool difficulty = true,
  int seeds = 2000,
}) {
  const engine = MatchEngine();
  final xi = _flat(_managerId, _formation, mine);
  final bench = _flat(_managerId, Formation.f433, mine, from: 50).take(7);
  // The production seam when on; the drilled shape alone when off.
  final chemistry = difficulty
      ? MidTierDifficulty.chemistryByNation(
          managerNationId: _managerId,
          familiarity: edge.familiarity,
          fieldedRating: mine,
        )
      : {_managerId: TeamChemistry.factor(edge.familiarity)};
  var w = 0;
  var d = 0;
  var l = 0;
  for (var i = 0; i < seeds; i++) {
    final setup = _opponentSetup(i, mine, theirs);
    final oppXi = _flat(_opponentId, setup.formation, theirs);
    final oppBench = _flat(
      _opponentId,
      Formation.f433,
      theirs,
      from: 50,
    ).take(7);
    final me = MatchTeam(
      nationId: _managerId,
      xi: xi,
      instructions: _plan,
      formation: _formation,
      ratingBonus: Staff.dossierBonus(edge.scout),
    );
    final them = MatchTeam(
      nationId: _opponentId,
      xi: oppXi,
      instructions: setup.instructions,
      formation: setup.formation,
    );
    final subs = [
      ...AiSubstitutions.plan(
        nationId: _opponentId,
        xi: oppXi,
        bench: oppBench.toList(),
        rng: SeededRng.forFixture(0xD1FF, i ^ 0x5195),
      ),
      ...AiSubstitutions.plan(
        nationId: _managerId,
        xi: xi,
        bench: bench.toList(),
        rng: SeededRng.forFixture(0xD1FF, i ^ 0x7777),
      ),
    ];
    for (final atHome in const [true, false]) {
      final r = engine.play(
        home: atHome ? me : them,
        away: atHome ? them : me,
        rng: SeededRng.forFixture(0xD1FF, i),
        subs: subs,
        aiManagedNationIds: const {_opponentId},
        chemistryByNation: chemistry,
      );
      final gd = atHome ? r.homeScore - r.awayScore : r.awayScore - r.homeScore;
      if (gd > 0) {
        w++;
      } else if (gd < 0) {
        l++;
      } else {
        d++;
      }
    }
  }
  return _stats(w, d, l);
}

/// The manager's side skipped: `RatingMatchSimulator` with his side lifted
/// as `SeasonService._withManagerTactics` lifts it.
DifficultyStats labSkipped({
  required double mine,
  required double theirs,
  ManagerEdge edge = bareEdge,
  bool difficulty = true,
  int seeds = 2000,
}) {
  const sim = RatingMatchSimulator();
  final base = backgroundStrength(mine);
  final opp = backgroundStrength(theirs);
  final chemistry = TeamChemistry.factor(edge.familiarity) - 1;
  var w = 0;
  var d = 0;
  var l = 0;
  for (var i = 0; i < seeds; i++) {
    final setup = _opponentSetup(i, mine, theirs);
    final effect = MatchEngine.planEffect(
      plan: _plan,
      formation: _formation,
      opponent: setup.instructions,
      opponentFormation: setup.formation,
    );
    final lifted =
        base +
        effect.ratingDelta +
        Staff.dossierBonus(edge.scout) +
        chemistry * 30;
    // The production seam when on (dithered on the fixture's stream, as
    // `_withManagerTactics` does); the plain round it replaced when off.
    final strength = difficulty
        ? MidTierDifficulty.skippedStrength(
            lift: lifted,
            fieldedRating: mine,
            rng: MidTierDifficulty.ditherRng(0xD1FF, i),
          )
        : lifted.round();
    for (final atHome in const [true, false]) {
      final r = sim.simulate(
        homeStrength: atHome ? strength : opp,
        awayStrength: atHome ? opp : strength,
        rng: SeededRng.forFixture(0xD1FF, i),
        openness: effect.openness,
      );
      final gd = atHome ? r.homeScore - r.awayScore : r.awayScore - r.homeScore;
      if (gd > 0) {
        w++;
      } else if (gd < 0) {
        l++;
      } else {
        d++;
      }
    }
  }
  return _stats(w, d, l);
}

/// The same two nations when the AI plays both ends.
DifficultyStats labWorld({
  required double mine,
  required double theirs,
  int seeds = 2000,
}) {
  const sim = RatingMatchSimulator();
  final a = backgroundStrength(mine);
  final b = backgroundStrength(theirs);
  var w = 0;
  var d = 0;
  var l = 0;
  for (var i = 0; i < seeds; i++) {
    for (final atHome in const [true, false]) {
      final r = sim.simulate(
        homeStrength: atHome ? a : b,
        awayStrength: atHome ? b : a,
        rng: SeededRng.forFixture(0xD1FF, i),
      );
      final gd = atHome ? r.homeScore - r.awayScore : r.awayScore - r.homeScore;
      if (gd > 0) {
        w++;
      } else if (gd < 0) {
        l++;
      } else {
        d++;
      }
    }
  }
  return _stats(w, d, l);
}

/// Formats [v] to two places, signed when [signed].
String fmt(double v, {bool signed = false}) =>
    '${signed && v >= 0 ? '+' : ''}${v.toStringAsFixed(2)}';

/// Standard error of a points mean over [n] matches, a rough guide.
double pointsSe(DifficultyStats s, int n) {
  final mean = s.points;
  final sq = 9 * s.win + 1 * s.draw;
  return math.sqrt(math.max(0, sq - mean * mean) / n);
}
