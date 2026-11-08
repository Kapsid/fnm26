import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/ai_counter.dart';
import 'package:fnm/domain/services/match/ai_substitutions.dart';
import 'package:fnm/domain/services/match/ai_tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/mid_tier_difficulty.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';

import '../../helpers/fixtures.dart';

/// How many penalties the manager's OWN matches give, set up the way
/// `match_providers` sets a live match up (an AI opponent from
/// `AiTactics.forOpponent` bent by `AiCounter`, managing itself and
/// subbing, the manager's chemistry; his side at home, away or at a neutral
/// ground), and the balance guards' plain rated sides by strength mix.
///
/// The owner played ten of his own matches on 1.1.0 and saw no penalty at
/// all: the engine gave about 0.24 a match in his matches, and ten without
/// one came up about one time in eleven. He asked for one most second or
/// third match, sometimes in consecutive ones (2026-11-08): about 0.40 a
/// match, so ten in a row without one is under 2%. Real home sides win
/// about 55-60% of the penalties given.
void main() {
  const engine = MatchEngine();
  const me = 1;
  const opp = 2;

  // An XI at [rating] with each player jittered +-6 on every attribute, so
  // the side is not eleven clones.
  List<Player> xi(
    int nationId,
    Formation f,
    int rating,
    SeededRng r, {
    int from = 0,
  }) => [
    for (var i = 0; i < 11; i++)
      player(
        id: nationId * 100 + from + i,
        nationId: nationId,
        position: f.positions[i],
        attributes: flatAttributes(
          (rating + r.nextInt(13) - 6).clamp(35, 99),
        ),
      ),
  ];

  ({double pens, double scored, double goals, double mine, double homeShare})
  userPath({required int seeds, required int salt}) {
    final pick = SeededRng(salt);
    var pens = 0,
        scored = 0,
        goals = 0,
        mine = 0,
        homePens = 0,
        homeSidePens = 0;
    var matches = 0;
    for (var i = 0; i < seeds; i++) {
      final myRating = 62 + pick.nextInt(25); // 62..86
      final theirRating = 55 + pick.nextInt(36); // 55..90
      final venue = pick.nextInt(3); // 0 home, 1 away, 2 neutral
      final base = AiTactics.forOpponent(
        opponentStrength: theirRating.toDouble(),
        playerStrength: myRating.toDouble(),
        seed: i,
        style: NationStyle.balanced,
      );
      final setup = AiCounter.apply(
        base: base,
        scouted: const ScoutedPlan(
          formation: Formation.f433,
          instructions: TacticalInstructions(),
          predictability: 0.5,
        ),
        opponentStrength: theirRating.toDouble(),
        style: NationStyle.balanced,
        seed: i ^ 0x5C0D7,
      );
      final myXi = xi(me, Formation.f433, myRating, pick);
      final myBench = xi(
        me,
        Formation.f433,
        myRating - 3,
        pick,
        from: 50,
      ).take(7).toList();
      final oppXi = xi(opp, setup.formation, theirRating, pick);
      final oppBench = xi(
        opp,
        Formation.f433,
        theirRating - 3,
        pick,
        from: 50,
      ).take(7).toList();
      final mt = MatchTeam(
        nationId: me,
        xi: myXi,
        instructions: const TacticalInstructions(),
        formation: Formation.f433,
      );
      final ot = MatchTeam(
        nationId: opp,
        xi: oppXi,
        instructions: setup.instructions,
        formation: setup.formation,
      );
      final subs = [
        ...AiSubstitutions.plan(
          nationId: opp,
          xi: oppXi,
          bench: oppBench,
          rng: SeededRng.forFixture(salt, i ^ 0x5195),
        ),
      ];
      final atHome = venue != 1;
      final r = engine.play(
        home: atHome ? mt : ot,
        away: atHome ? ot : mt,
        rng: SeededRng.forFixture(salt, i),
        subs: subs,
        aiManagedNationIds: const {opp},
        chemistryByNation: MidTierDifficulty.chemistryByNation(
          managerNationId: me,
          familiarity: 0.5,
          fieldedRating: myRating.toDouble(),
        ),
        neutralVenue: venue == 2,
      );
      matches++;
      goals += r.homeScore + r.awayScore;
      final homeId = atHome ? me : opp;
      for (final s in r.moments.whereType<ShotMoment>()) {
        if (s.origin != ShotOrigin.penalty) continue;
        pens++;
        if (s.outcome == ShotOutcome.goal) scored++;
        if (s.teamNationId == me) mine++;
        if (venue != 2) {
          homeSidePens++;
          if (s.teamNationId == homeId) homePens++;
        }
      }
    }
    return (
      pens: pens / matches,
      scored: scored / pens,
      goals: goals / matches,
      mine: mine / matches,
      homeShare: homePens / homeSidePens,
    );
  }

  test('the manager\'s own matches: 0.34-0.46 penalties a match over 2,000, '
      'about 3 in 4 scored, the home side given 53-62% of them', () {
    final u = userPath(seeds: 2000, salt: 0x9E11);
    // ignore: avoid_print, a measurement worth reading when it moves
    print(
      'his matches: ${u.pens.toStringAsFixed(3)} pens/match '
      '(his side ${u.mine.toStringAsFixed(3)}), scored '
      '${u.scored.toStringAsFixed(3)}, goals ${u.goals.toStringAsFixed(3)}, '
      'home share ${u.homeShare.toStringAsFixed(3)}',
    );
    expect(u.pens, inInclusiveRange(0.34, 0.46));
    expect(u.scored, inInclusiveRange(0.72, 0.80));
    expect(u.homeShare, inInclusiveRange(0.53, 0.62));
  });

  test('by strength mix: 0.33-0.50 a match wherever the sides are within '
      '15 points, the home side given more of them between equals', () {
    for (final (h, a) in const [
      (70, 70),
      (78, 70),
      (85, 70),
      (85, 85),
      (70, 85),
      (60, 88),
      (88, 60),
    ]) {
      var pens = 0, scored = 0, goals = 0, home = 0;
      const n = 600;
      for (var i = 0; i < n; i++) {
        final r = engine.play(
          home: ratedTeam(1, h),
          away: ratedTeam(2, a),
          rng: SeededRng.forFixture(0xAB12, i),
          aiManagedNationIds: const {1, 2},
        );
        goals += r.homeScore + r.awayScore;
        for (final s in r.moments.whereType<ShotMoment>()) {
          if (s.origin != ShotOrigin.penalty) continue;
          pens++;
          if (s.outcome == ShotOutcome.goal) scored++;
          if (s.teamNationId == 1) home++;
        }
      }
      // ignore: avoid_print, a measurement worth reading when it moves
      print(
        '$h v $a home: ${(pens / n).toStringAsFixed(3)} pens/match, scored '
        '${(scored / pens).toStringAsFixed(3)}, goals '
        '${(goals / n).toStringAsFixed(3)}, home share '
        '${(home / pens).toStringAsFixed(3)}',
      );
      if ((h - a).abs() <= 15) {
        expect(pens / n, inInclusiveRange(0.33, 0.50), reason: '$h v $a');
      }
      if (h == a) {
        expect(home / pens, inInclusiveRange(0.52, 0.66), reason: '$h v $a');
      }
    }
  });
}
