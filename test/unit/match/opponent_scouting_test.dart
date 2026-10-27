import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/match/ai_tactics.dart';
import 'package:fnm/domain/services/match/opponent_scouting.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';

import '../../helpers/fixtures.dart';

/// A high-pressing posture in [formation]: the dial the report should name.
AiSetup _pressing(Formation formation) => (
  formation: formation,
  instructions: const TacticalInstructions(pressing: 80, defensiveLine: 70),
);

/// An XI laid out in [formation] whose forwards are much quicker than they
/// are good: the squad line the report should name.
List<Player> _quickForwardsXi(Formation formation) => [
  for (final (i, slot) in formation.positions.indexed)
    player(
      id: i + 1,
      nationId: 2,
      position: slot,
      attributes: slot.category == PositionCategory.forward
          ? const PlayerAttributes(physical: 92, technical: 70, stamina: 70)
          : flatAttributes(75),
    ),
];

ScoutReport _report(
  StaffTier scout, {
  List<AiSetup>? recent,
  double opponentStrength = 80,
  double playerStrength = 70,
}) => OpponentScouting.build(
  scout: scout,
  worldRank: 7,
  recentSetups:
      recent ??
      [
        _pressing(Formation.f4141),
        _pressing(Formation.f442),
        _pressing(Formation.f4141),
      ],
  fallbackSetups: [_pressing(Formation.f532)],
  xiFor: _quickForwardsXi,
  opponentStrength: opponentStrength,
  playerStrength: playerStrength,
);

void main() {
  group('typical formation', () {
    test('is the shape used most in the recent matches', () {
      expect(
        OpponentScouting.typicalFormation(const [
          Formation.f442,
          Formation.f4141,
          Formation.f433,
          Formation.f4141,
        ], fallback: Formation.f532),
        Formation.f4141,
      );
    });

    test('a tie goes to the shape used most recently', () {
      expect(
        OpponentScouting.typicalFormation(const [
          Formation.f433,
          Formation.f442,
          Formation.f442,
          Formation.f433,
        ], fallback: Formation.f532),
        Formation.f433,
      );
    });

    test('with no history it falls back', () {
      expect(
        OpponentScouting.typicalFormation(
          const [],
          fallback: Formation.f532,
        ),
        Formation.f532,
      );
    });

    test('the report reads it off the recent matches, not the fallback', () {
      expect(_report(StaffTier.basic).formation, Formation.f4141);
      expect(
        _report(StaffTier.basic, recent: const []).formation,
        Formation.f532,
      );
    });

    test('the fallback is what the side could do against the manager', () {
      // A heavy underdog's postures: low block, park the bus, counter.
      final setups = AiTactics.typicalSetups(
        opponentStrength: 60,
        playerStrength: 75,
        style: NationStyle.counter,
      );
      expect(
        setups.map((s) => s.formation),
        containsAll(const [Formation.f451, Formation.f541, Formation.f4141]),
      );
    });
  });

  group('each scout tier says the right amount', () {
    test('nobody in the job: the ranking and one vague line', () {
      final r = _report(StaffTier.none);
      expect(r.depth, ScoutDepth.glimpse);
      expect(r.worldRank, 7);
      expect(r.leaning, isNotNull);
      expect(r.formation, isNull);
      expect(r.strengths, isEmpty);
      expect(r.weakness, isNull);
      expect(r.approach, isNull);
    });

    test('basic: the ranking, the shape and one strength', () {
      final r = _report(StaffTier.basic);
      expect(r.depth, ScoutDepth.outline);
      expect(r.worldRank, 7);
      expect(r.formation, Formation.f4141);
      expect(r.strengths, [ScoutStrength.pressing]);
      expect(r.weakness, isNull);
      expect(r.approach, isNull);
    });

    test('good: two strengths, one of each kind, and a weakness', () {
      final r = _report(StaffTier.good);
      expect(r.depth, ScoutDepth.detailed);
      expect(r.strengths, [
        ScoutStrength.pressing,
        ScoutStrength.quickForwards,
      ]);
      // A high line and a high press leave space in behind.
      expect(r.weakness, ScoutWeakness.spaceBehind);
      expect(r.approach, isNull);
    });

    test('elite: all of that and how they will likely approach you', () {
      final r = _report(StaffTier.elite);
      expect(r.depth, ScoutDepth.full);
      expect(r.strengths, hasLength(2));
      expect(r.weakness, isNotNull);
      expect(r.approach, ScoutApproach.takeTheGame);
      expect(
        _report(
          StaffTier.elite,
          opponentStrength: 65,
          playerStrength: 75,
        ).approach,
        ScoutApproach.sitDeep,
      );
    });
  });

  group('readings', () {
    test(
      'a balanced side with a flat squad: no strength, its weakest line',
      () {
        final r = OpponentScouting.build(
          scout: StaffTier.elite,
          worldRank: 40,
          recentSetups: const [
            (formation: Formation.f442, instructions: TacticalInstructions()),
          ],
          fallbackSetups: const [],
          xiFor: (f) => [
            for (final (i, slot) in f.positions.indexed)
              player(id: i + 1, nationId: 2, position: slot),
          ],
          opponentStrength: 70,
          playerStrength: 70,
        );
        expect(r.strengths, isEmpty);
        // Flat attributes put physical AT the overall, which is below what is
        // usual in the world, and furthest below it at the back.
        expect(r.weakness, ScoutWeakness.aerial);
        expect(r.approach, ScoutApproach.even);
      },
    );

    test('deep, direct and quick reads as a counter-attacking side', () {
      final s = OpponentScouting.tacticalStrengths(
        const TacticalInstructions(
          defensiveLine: 30,
          directness: 72,
          tempo: 64,
        ),
      ).map((e) => e.$1);
      expect(s, contains(ScoutStrength.counter));
      expect(s, isNot(contains(ScoutStrength.direct)));
    });

    test('a set-piece specialist tips an aerial edge into a strength', () {
      // Half a spread above the world's usual aerial threat: not enough on
      // its own, enough with a specialist on the ball.
      const z = (
        fwdPace: 0.0,
        defPace: 0.0,
        midPassing: 0.0,
        midLegs: 0.0,
        aerial: 0.5,
        aerialDefence: 0.0,
      );
      List<ScoutStrength> read({required bool specialist}) => [
        for (final e in OpponentScouting.squadStrengthsOf(
          z,
          setPieceSpecialist: specialist,
        ))
          e.$1,
      ];
      expect(read(specialist: false), isEmpty);
      expect(read(specialist: true), [ScoutStrength.setPieces]);
    });

    test('squad lines are read against what is usual in the world', () {
      final z = OpponentScouting.standouts(OpponentScouting.worldUsual);
      expect(z.fwdPace, 0);
      expect(z.aerialDefence, 0);
      expect(OpponentScouting.squadStrengthsOf(z), isEmpty);
    });

    test('the leaning follows the typical mentality', () {
      expect(
        OpponentScouting.leaningOf(const TacticalInstructions(mentality: 64)),
        ScoutLeaning.attacking,
      );
      expect(
        OpponentScouting.leaningOf(const TacticalInstructions(mentality: 32)),
        ScoutLeaning.cautious,
      );
      expect(
        OpponentScouting.leaningOf(const TacticalInstructions()),
        ScoutLeaning.unclear,
      );
    });
  });
}
