import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

import 'fixtures.dart';

/// THE CHASE CELL: what going all-out when a goal down is worth, and what it
/// costs at the back.
///
/// Every seed is played both ways round at a neutral venue between two equal
/// sides, both on the neutral 4-3-3, the opponent AI-managed as in a live
/// match (it reacts to the scoreline and the clock). Where the manager's side
/// is exactly one goal down after minute `chaseMinute - 1`, the same match is
/// played again with a live switch at `chaseMinute` to all-out attack
/// (4-2-4, mentality 100, line 75, tempo 75). Up to that minute the two runs
/// are identical (a change consumes no randomness), so every difference after
/// it is the switch.
///
/// Deliberately built from APIs that predate the tactics impact build, so the
/// same file measures the base commit (1574f85) as well.
typedef ChaseStats = ({
  int matches,
  double stayNotLose,
  double chaseNotLose,
  double stayGfAfter,
  double chaseGfAfter,
  double stayGaAfter,
  double chaseGaAfter,
});

/// The all-out plan the chasing manager switches to.
const TacticalInstructions chaseInstructions = TacticalInstructions(
  mentality: 100,
  defensiveLine: 75,
  tempo: 75,
);

/// The posture of the side the manager chases: a shape and its dials.
typedef ChaseOpponent = ({
  Formation formation,
  TacticalInstructions instructions,
});

/// The neutral 4-3-3.
const ChaseOpponent neutralOpponent = (
  formation: Formation.f433,
  instructions: TacticalInstructions(),
);

/// `AiTactics`' dominant archetype (a favourite taking the game to you).
const ChaseOpponent dominantOpponent = (
  formation: Formation.f433,
  instructions: TacticalInstructions(
    mentality: 68,
    pressing: 66,
    tempo: 58,
    width: 60,
    defensiveLine: 66,
    directness: 40,
  ),
);

/// `AiTactics`' gegenPress archetype.
const ChaseOpponent gegenPressOpponent = (
  formation: Formation.f4231,
  instructions: TacticalInstructions(
    mentality: 64,
    pressing: 80,
    tempo: 66,
    width: 58,
    defensiveLine: 72,
    directness: 44,
  ),
);

MatchTeam _side(
  int nationId,
  double rating, [
  ChaseOpponent plan = neutralOpponent,
]) => MatchTeam(
  nationId: nationId,
  instructions: plan.instructions,
  formation: plan.formation,
  xi: [
    for (var i = 0; i < 11; i++)
      player(
        id: nationId * 100 + i,
        nationId: nationId,
        position: plan.formation.positions[i],
        attributes: flatAttributes(rating.round()),
      ),
  ],
);

/// [opponent] is the posture the opponent starts in (the engine then
/// manages it by the scoreline and clock), at [opponentRating] (default:
/// [rating]).
ChaseStats runChase({
  int seeds = 4000,
  int chaseMinute = 60,
  double rating = 80,
  ChaseOpponent opponent = neutralOpponent,
  double? opponentRating,
}) {
  const engine = MatchEngine();
  const me = 1;
  const them = 2;
  var n = 0;
  var stayNotLose = 0;
  var chaseNotLose = 0;
  var stayGf = 0;
  var chaseGf = 0;
  var stayGa = 0;
  var chaseGa = 0;
  for (var i = 0; i < seeds; i++) {
    for (final atHome in const [true, false]) {
      final mine = _side(me, rating);
      final theirs = _side(them, opponentRating ?? rating, opponent);
      MatchResult play(List<TacticalChange> changes) => engine.play(
        home: atHome ? mine : theirs,
        away: atHome ? theirs : mine,
        rng: SeededRng.forFixture(0xC4A5E, i),
        neutralVenue: true,
        aiManagedNationIds: const {them},
        changes: changes,
      );
      ({int gf, int ga}) score(MatchResult r, {int? before}) {
        var gf = 0;
        var ga = 0;
        for (final e in r.events) {
          if (e.type != MatchEventType.goal) continue;
          if (before != null && e.minute >= before) continue;
          if (e.teamNationId == me) {
            gf++;
          } else {
            ga++;
          }
        }
        return (gf: gf, ga: ga);
      }

      final stay = play(const []);
      final at = score(stay, before: chaseMinute);
      if (at.gf - at.ga != -1) continue;
      final chase = play([
        TacticalChange(
          teamNationId: me,
          minute: chaseMinute,
          formation: Formation.f424,
          instructions: chaseInstructions,
          xi: mine.xi,
        ),
      ]);
      final s = score(stay);
      final c = score(chase);
      n++;
      if (s.gf >= s.ga) stayNotLose++;
      if (c.gf >= c.ga) chaseNotLose++;
      stayGf += s.gf - at.gf;
      chaseGf += c.gf - at.gf;
      stayGa += s.ga - at.ga;
      chaseGa += c.ga - at.ga;
    }
  }
  return (
    matches: n,
    stayNotLose: stayNotLose / n,
    chaseNotLose: chaseNotLose / n,
    stayGfAfter: stayGf / n,
    chaseGfAfter: chaseGf / n,
    stayGaAfter: stayGa / n,
    chaseGaAfter: chaseGa / n,
  );
}

String chaseReport(ChaseStats s) {
  String f(double v) => v.toStringAsFixed(3);
  String pct(double v) => '${(v * 100).toStringAsFixed(1)}%';
  return 'n=${s.matches} notLose ${pct(s.stayNotLose)} -> '
      '${pct(s.chaseNotLose)} '
      '(+${((s.chaseNotLose - s.stayNotLose) * 100).toStringAsFixed(1)}pp) '
      'GF after ${f(s.stayGfAfter)} -> ${f(s.chaseGfAfter)} '
      '(+${f(s.chaseGfAfter - s.stayGfAfter)}) '
      'GA after ${f(s.stayGaAfter)} -> ${f(s.chaseGaAfter)} '
      '(+${f(s.chaseGaAfter - s.stayGaAfter)})';
}
