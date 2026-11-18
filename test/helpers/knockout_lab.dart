import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/match/ai_counter.dart';
import 'package:fnm/domain/services/match/ai_substitutions.dart';
import 'package:fnm/domain/services/match/ai_tactics.dart';
import 'package:fnm/domain/services/match/big_game_difficulty.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';
import 'package:fnm/domain/services/match/mid_tier_difficulty.dart';
import 'package:fnm/domain/services/match/penalty_takers.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';

import 'difficulty_lab.dart' show backgroundStrength;
import 'fixtures.dart';

/// THE KNOCKOUT LAB: the chance the manager's side wins a one-off neutral
/// finals knockout tie (extra time and penalties included), played and
/// skipped, with the 1.1.2 big-game difficulty (`BigGameDifficulty`) on
/// (`difficulty: true`, a `difficulty2` cycle) or off (any older cycle).
///
/// Each seed is played once, the manager nominally at home on even seeds and
/// away on odd ones, at a neutral ground (no home crowd unless the edge says
/// he hosts). All players on a side sit at the side's rating.
///
///  * [koPlayed]: `MatchEngine`, set up as `match_providers` and the live
///    screen set it up (an AI opponent from `AiTactics.forOpponent` bent by
///    `AiCounter` at predictability 0.5, both sides' planned substitutions,
///    the manager's chemistry, dossier, condition and talks), extra time in
///    the engine and the shootout drawn as `match_screen` draws it;
///  * [koSkipped]: `RatingMatchSimulator` with his side lifted as
///    `SeasonService._withManagerTactics` lifts it and the tie settled as
///    `_playBackground` settles it;
///  * [koWorld]: the AI world's tie between the same two strengths (with the
///    World Championship finals stretch when [stretch]).

/// What the manager has going for him beyond the squad, in a knockout.
typedef KoEdge = ({
  String name,
  double familiarity,
  StaffTier scout,
  int condition,
  TeamTalkTone? talk,
  bool host,
  bool smart,
});

const KoEdge koBare = (
  name: 'bare',
  familiarity: 0,
  scout: StaffTier.none,
  condition: 0,
  talk: null,
  host: false,
  smart: false,
);

/// The lab's "typical" manager: a drilled shape and a good scout.
const KoEdge koTypical = (
  name: 'typical',
  familiarity: 0.75,
  scout: StaffTier.good,
  condition: 0,
  talk: null,
  host: false,
  smart: false,
);

/// The lab's "well-run" side: typical, plus good condition (+3 a man), a
/// "believe" talk at the interval and before extra time, and the best plan
/// against the opponent's setup (a search over a grid of instructions).
const KoEdge koHotSmart = (
  name: 'hot+smart',
  familiarity: 0.75,
  scout: StaffTier.good,
  condition: 3,
  talk: TeamTalkTone.believe,
  host: false,
  smart: true,
);

/// [koHotSmart] at a finals he hosts, in a packed ground, with the best
/// condition a squad can have (+6 a man).
const KoEdge koHotHost = (
  name: 'hot+host+6',
  familiarity: 0.75,
  scout: StaffTier.good,
  condition: 6,
  talk: TeamTalkTone.believe,
  host: true,
  smart: true,
);

const _me = 1;
const _them = 2;
const _plan = TacticalInstructions();
const _f = Formation.f433;

/// A finals knockout round code for [stage] (`finalsKnockoutStage`).
String koRound(int stage) => const ['R16', 'QF', 'SF'][stage];

List<Player> _flat(int nid, Formation f, double r, {int from = 0}) => [
  for (var i = 0; i < 11; i++)
    player(
      id: nid * 100 + from + i,
      nationId: nid,
      position: f.positions[i],
      attributes: flatAttributes(r.round()),
    ),
];

AiSetup _opp(int seed, double mine, double theirs) => AiCounter.apply(
  base: AiTactics.forOpponent(
    opponentStrength: theirs,
    playerStrength: mine,
    seed: seed,
    style: NationStyle.balanced,
  ),
  scouted: const ScoutedPlan(
    formation: _f,
    instructions: _plan,
    predictability: 0.5,
  ),
  opponentStrength: theirs,
  style: NationStyle.balanced,
  seed: seed ^ 0x5C0D7,
);

final _grid = [
  for (final m in const [25, 50, 75])
    for (final pr in const [25, 50, 75])
      for (final l in const [25, 50, 75])
        for (final d in const [25, 50, 75])
          for (final w in const [25, 50, 75])
            TacticalInstructions(
              mentality: m,
              pressing: pr,
              defensiveLine: l,
              directness: d,
              width: w,
            ),
];

TacticalInstructions _best(AiSetup s) {
  var best = _plan;
  var bv = MatchEngine.planEffect(
    plan: _plan,
    formation: _f,
    opponent: s.instructions,
    opponentFormation: s.formation,
  ).ratingDelta;
  for (final p in _grid) {
    final v = MatchEngine.planEffect(
      plan: p,
      formation: _f,
      opponent: s.instructions,
      opponentFormation: s.formation,
    ).ratingDelta;
    if (v > bv) {
      bv = v;
      best = p;
    }
  }
  return best;
}

/// The win probability of the manager's side, played out live.
double koPlayed({
  required double mine,
  required double theirs,
  required KoEdge edge,
  required bool difficulty,
  int stage = 1,
  double myPedigree = 0,
  double theirPedigree = 0,
  int seeds = 1200,
}) {
  const engine = MatchEngine();
  final round = koRound(stage);
  final xi = _flat(_me, _f, mine);
  final bench = _flat(_me, _f, mine, from: 50).take(7).toList();
  // The production seams, as `match_providers` assembles them.
  final base = MidTierDifficulty.chemistryByNation(
    managerNationId: _me,
    familiarity: edge.familiarity,
    fieldedRating: mine,
    wide: difficulty,
  );
  final chemistry = difficulty
      ? BigGameDifficulty.withTerm(
          base,
          managerNationId: _me,
          opponentNationId: _them,
          term: BigGameDifficulty.term(
            round: round,
            mine: mine,
            theirs: theirs,
            myPedigree: myPedigree,
            theirPedigree: theirPedigree,
          ),
        )
      : base;
  final condition = difficulty
      ? (edge.condition > BigGameDifficulty.knockoutConditionCap
            ? BigGameDifficulty.knockoutConditionCap
            : edge.condition)
      : edge.condition;
  const packed = 1.1;
  final atmosphere = edge.host && difficulty
      ? packed * BigGameDifficulty.hostCrowdScale
      : packed;
  var wins = 0;
  for (var i = 0; i < seeds; i++) {
    final s = _opp(i, mine, theirs);
    final oxi = _flat(_them, s.formation, theirs);
    final obench = _flat(_them, _f, theirs, from: 50).take(7).toList();
    final me = MatchTeam(
      nationId: _me,
      xi: xi,
      instructions: edge.smart ? _best(s) : _plan,
      formation: _f,
      ratingBonus: Staff.dossierBonus(edge.scout),
      conditionByPlayer: {
        for (final p in [...xi, ...bench]) p.id: condition,
      },
    );
    final them = MatchTeam(
      nationId: _them,
      xi: oxi,
      instructions: s.instructions,
      formation: s.formation,
    );
    final subs = [
      ...AiSubstitutions.plan(
        nationId: _them,
        xi: oxi,
        bench: obench,
        rng: SeededRng.forFixture(0xD1FF, i ^ 0x5195),
      ),
      ...AiSubstitutions.plan(
        nationId: _me,
        xi: xi,
        bench: bench,
        rng: SeededRng.forFixture(0xD1FF, i ^ 0x7777),
      ),
    ];
    final talks = edge.talk == null
        ? const <TeamTalk>[]
        : [
            TeamTalk(teamNationId: _me, minute: 46, tone: edge.talk!),
            TeamTalk(teamNationId: _me, minute: 91, tone: edge.talk!),
          ];
    final atHome = i.isEven;
    final r = engine.play(
      home: atHome ? me : them,
      away: atHome ? them : me,
      rng: SeededRng.forFixture(0xD1FF, i),
      subs: subs,
      talks: talks,
      aiManagedNationIds: const {_them},
      chemistryByNation: chemistry,
      talkScaleByNation: difficulty
          ? const {_me: BigGameDifficulty.talkScale}
          : const {},
      neutralVenue: true,
      venueHostId: edge.host ? _me : null,
      atmosphere: edge.host ? atmosphere : 1.0,
      bigMatch: true,
      extraTimeIfLevel: true,
    );
    final et = r.extraTime ?? (homeScore: r.homeScore, awayScore: r.awayScore);
    var gd = et.homeScore - et.awayScore;
    if (!atHome) gd = -gd;
    if (gd == 0) {
      final mine5 = PenaltyTakers.skillOrder(PenaltyTakers.autoOrder(xi));
      final theirs5 = PenaltyTakers.skillOrder(PenaltyTakers.autoOrder(oxi));
      final myW = difficulty ? BigGameDifficulty.shootoutWeight(mine) : 1.0;
      final theirW = difficulty
          ? BigGameDifficulty.shootoutWeight(theirs)
          : 1.0;
      final o = WorldCupFinals.decideShootout(
        0,
        0,
        SeededRng.forFixture(0xD1FF, i ^ 0x7F),
        homeStrength: atHome ? myW : theirW,
        awayStrength: atHome ? theirW : myW,
        homeTakerSkill: atHome ? mine5 : theirs5,
        awayTakerSkill: atHome ? theirs5 : mine5,
      );
      gd = (o.homeWon == atHome) ? 1 : -1;
    }
    if (gd > 0) wins++;
  }
  return wins / seeds;
}

/// The win probability of the manager's side in a tie he skipped.
double koSkipped({
  required double mine,
  required double theirs,
  required KoEdge edge,
  required bool difficulty,
  int stage = 1,
  double myPedigree = 0,
  double theirPedigree = 0,
  int seeds = 4000,
}) {
  const sim = RatingMatchSimulator();
  final round = koRound(stage);
  final base = backgroundStrength(mine);
  final opp = backgroundStrength(theirs);
  final term = difficulty
      ? BigGameDifficulty.term(
          round: round,
          mine: mine,
          theirs: theirs,
          myPedigree: myPedigree,
          theirPedigree: theirPedigree,
        )
      : 0.0;
  final against = BigGameDifficulty.skippedEdge(term);
  var wins = 0;
  for (var i = 0; i < seeds; i++) {
    final s = _opp(i, mine, theirs);
    final eff = MatchEngine.planEffect(
      plan: edge.smart ? _best(s) : _plan,
      formation: _f,
      opponent: s.instructions,
      opponentFormation: s.formation,
    );
    final lifted =
        base +
        eff.ratingDelta +
        Staff.dossierBonus(edge.scout) +
        (TeamChemistry.factor(edge.familiarity) - 1) * 30;
    final strength = MidTierDifficulty.skippedStrength(
      lift: lifted,
      fieldedRating: mine,
      rng: MidTierDifficulty.ditherRng(0xD1FF, i),
      wide: difficulty,
    );
    final atHome = i.isEven;
    final hs = atHome ? strength : opp;
    final as = atHome ? opp : strength;
    // The edge is the home side's: against him when he is home, for the
    // opponent's side when he is away.
    final homeEdge = atHome ? against : -against;
    final r = sim.simulate(
      homeStrength: hs,
      awayStrength: as,
      rng: SeededRng.forFixture(0xD1FF, i),
      homeAdvantage: false,
      openness: eff.openness,
      strengthEdge: homeEdge,
    );
    var gd = r.homeScore - r.awayScore;
    if (gd == 0) {
      final ko = WorldCupFinals.decideKnockout(
        r.awayScore,
        r.awayScore,
        SeededRng.forFixture(0xD1FF, i ^ 0x7F),
        homeStrength: RatingMatchSimulator.knockoutWeight(hs + homeEdge),
        awayStrength: RatingMatchSimulator.knockoutWeight(as),
      );
      gd = ko.homeWon ? 1 : -1;
    }
    if (!atHome) gd = -gd;
    if (gd > 0) wins++;
  }
  return wins / seeds;
}

/// The AI world's tie between the same two strengths.
double koWorld({
  required double mine,
  required double theirs,
  bool stretch = true,
  int seeds = 4000,
}) {
  const sim = RatingMatchSimulator();
  final a = backgroundStrength(mine);
  final b = backgroundStrength(theirs);
  var wins = 0;
  for (var i = 0; i < seeds; i++) {
    final atHome = i.isEven;
    final hs = atHome ? a : b;
    final as = atHome ? b : a;
    final edge = stretch
        ? RatingMatchSimulator.finalsKnockoutEdge(
            homeStrength: hs,
            awayStrength: as,
          )
        : 0.0;
    final r = sim.simulate(
      homeStrength: hs,
      awayStrength: as,
      rng: SeededRng.forFixture(0xD1FF, i),
      homeAdvantage: false,
      strengthEdge: edge,
    );
    var gd = r.homeScore - r.awayScore;
    if (gd == 0) {
      final ko = WorldCupFinals.decideKnockout(
        r.awayScore,
        r.awayScore,
        SeededRng.forFixture(0xD1FF, i ^ 0x7F),
        homeStrength: RatingMatchSimulator.knockoutWeight(hs + edge),
        awayStrength: RatingMatchSimulator.knockoutWeight(as),
      );
      gd = ko.homeWon ? 1 : -1;
    }
    if (!atHome) gd = -gd;
    if (gd > 0) wins++;
  }
  return wins / seeds;
}
