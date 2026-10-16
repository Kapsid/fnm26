import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/repositories/tactic_familiarity_repository.dart';
import 'package:fnm/domain/services/match/ai_counter.dart';
import 'package:fnm/domain/services/match/ai_tactics.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';

import '../../helpers/fixtures.dart';

/// A plain AI posture to counter FROM: every dial at 50, a 4-4-2.
const AiSetup _base = (
  formation: Formation.f442,
  instructions: TacticalInstructions(),
);

ScoutedPlan _scouted(
  Formation formation,
  TacticalInstructions instructions, {
  double predictability = 1,
}) => ScoutedPlan(
  formation: formation,
  instructions: instructions,
  predictability: predictability,
);

void main() {
  group('TeamChemistry.decodePlanKey', () {
    test('inverts planKey, to bands of ten', () {
      for (final x in const [
        TacticalInstructions(),
        TacticalInstructions(
          mentality: 90,
          pressing: 10,
          tempo: 74,
          width: 0,
          defensiveLine: 100,
          directness: 33,
        ),
        TacticalInstructions(
          mentality: 15,
          pressing: 86,
          tempo: 41,
          width: 66,
          defensiveLine: 25,
          directness: 58,
        ),
      ]) {
        int band(int v) => (v / 10).round() * 10;
        expect(
          TeamChemistry.decodePlanKey(TeamChemistry.planKey(x)),
          TacticalInstructions(
            mentality: band(x.mentality),
            pressing: band(x.pressing),
            tempo: band(x.tempo),
            width: band(x.width),
            defensiveLine: band(x.defensiveLine),
            directness: band(x.directness),
          ),
        );
      }
    });

    test('0 means never fielded and has no plan to decode', () {
      expect(() => TeamChemistry.decodePlanKey(0), throwsArgumentError);
    });
  });

  group('ScoutedPlan.fromDrilling', () {
    test('reads the most drilled shape that has a stored plan', () {
      const plan = TacticalInstructions(width: 80, directness: 20);
      final scouted = ScoutedPlan.fromDrilling({
        // Most drilled, but never stored a plan (a pre-plan-key row).
        Formation.f433: (familiarity: 0.9, predictability: 0.9, lastPlanKey: 0),
        Formation.f343: (
          familiarity: 0.6,
          predictability: 0.4,
          lastPlanKey: TeamChemistry.planKey(plan),
        ),
        Formation.f442: (
          familiarity: 0.2,
          predictability: 0.8,
          lastPlanKey: TeamChemistry.planKey(const TacticalInstructions()),
        ),
      });
      expect(scouted, isNotNull);
      expect(scouted!.formation, Formation.f343);
      expect(scouted.instructions, plan);
      expect(scouted.predictability, 0.4);
    });

    test('no stored plan, nothing to scout', () {
      expect(ScoutedPlan.fromDrilling(const {}), isNull);
      expect(
        ScoutedPlan.fromDrilling({
          Formation.f433: (
            familiarity: 0.5,
            predictability: 0.5,
            lastPlanKey: 0,
          ),
        }),
        isNull,
      );
    });
  });

  group('AiCounter.apply', () {
    test('no history, no counter', () {
      final out = AiCounter.apply(
        base: _base,
        scouted: null,
        opponentStrength: 90,
        style: NationStyle.balanced,
        seed: 7,
      );
      expect(identical(out, _base) || out == _base, isTrue);
    });

    test('a high line draws a direct opponent', () {
      final out = AiCounter.apply(
        base: _base,
        scouted: _scouted(
          Formation.f433,
          const TacticalInstructions(defensiveLine: 80),
        ),
        opponentStrength: 85,
        style: NationStyle.balanced,
        seed: 1,
      );
      expect(
        out.instructions.directness,
        greaterThan(_base.instructions.directness + 10),
      );
    });

    test('a weak, rigid side barely reads you', () {
      // A pronounced plan, fully predictable, in a shape with no extra men at
      // either end (so the only counter on offer is in the sliders).
      final scouted = _scouted(
        Formation.f433,
        const TacticalInstructions(
          mentality: 70,
          pressing: 80,
          width: 70,
          defensiveLine: 75,
          directness: 30,
        ),
      );
      var unchanged = 0;
      for (var seed = 0; seed < 200; seed++) {
        final out = AiCounter.apply(
          base: _base,
          scouted: scouted,
          opponentStrength: 60,
          style: NationStyle.defensive,
          seed: seed,
        );
        final a = out.instructions;
        final b = _base.instructions;
        for (final (x, y) in [
          (a.mentality, b.mentality),
          (a.pressing, b.pressing),
          (a.tempo, b.tempo),
          (a.width, b.width),
          (a.defensiveLine, b.defensiveLine),
          (a.directness, b.directness),
        ]) {
          expect((x - y).abs(), lessThanOrEqualTo(6));
        }
        if (out.formation == _base.formation) unchanged++;
      }
      expect(unchanged / 200, greaterThanOrEqualTo(0.95));
    });

    test('three up front meets a back five, sometimes', () {
      final scouted = _scouted(
        Formation.f424,
        const TacticalInstructions(mentality: 90),
      );
      var backFive = 0;
      for (var seed = 0; seed < 500; seed++) {
        final out = AiCounter.apply(
          base: _base,
          scouted: scouted,
          opponentStrength: 85,
          style: NationStyle.balanced,
          seed: seed,
        );
        if (out.formation == Formation.f532 ||
            out.formation == Formation.f541) {
          backFive++;
        }
      }
      expect(backFive / 500, inInclusiveRange(0.40, 0.90));
    });
  });

  group('AiCounter.forFixture', () {
    test('the plan set for today is not read', () {
      // The manager's CURRENT tactic is not an input to the opponent's setup
      // at all: only the stored rows (written after each match he has played)
      // are. Two previews of the same fixture with the same stored history
      // must give the same opponent, whatever he has set up for today.
      final stored = <Formation, ShapeDrilling>{
        Formation.f433: (
          familiarity: 0.7,
          predictability: 0.8,
          lastPlanKey: TeamChemistry.planKey(
            const TacticalInstructions(defensiveLine: 85, pressing: 80),
          ),
        ),
      };
      AiSetup preview(TacticalInstructions today) {
        // `today` is deliberately unused below: there is no parameter to pass
        // it through, which is the guarantee this test pins.
        final base = AiTactics.forOpponent(
          opponentStrength: 82,
          playerStrength: 80,
          seed: AiTactics.fixtureSeed(
            opponentId: 9,
            fixtureId: 1234,
            rngSeed: 42,
          ),
        );
        return AiCounter.forFixture(
          base: base,
          drilling: stored,
          opponentStrength: 82,
          style: NationStyle.balanced,
          seed: AiCounter.fixtureSeed(
            opponentId: 9,
            fixtureId: 1234,
            rngSeed: 42,
          ),
        );
      }

      final a = preview(const TacticalInstructions(mentality: 95));
      final b = preview(const TacticalInstructions(defensiveLine: 10));
      expect(a, b);
      // And the stored history really was read (otherwise the equality above
      // proves nothing).
      expect(
        a.instructions.directness,
        greaterThan(
          AiTactics.forOpponent(
            opponentStrength: 82,
            playerStrength: 80,
            seed: AiTactics.fixtureSeed(
              opponentId: 9,
              fixtureId: 1234,
              rngSeed: 42,
            ),
          ).instructions.directness,
        ),
      );
    });
  });

  test('a thin pool still fields eleven after a shape change', () {
    final pool = [
      player(id: 1, nationId: 1, position: PlayerPosition.gk),
      for (var i = 2; i <= 4; i++)
        player(id: i, nationId: 1, position: PlayerPosition.cb),
      for (var i = 5; i <= 11; i++)
        player(id: i, nationId: 1, position: PlayerPosition.cm),
      for (var i = 12; i <= 14; i++)
        player(id: i, nationId: 1, position: PlayerPosition.st),
    ];
    final xi = bestEleven(Formation.f541, pool);
    expect(xi.whereType<int>().length, 11);
  });

  test('predictability is no longer charged in the chemistry factor', () {
    for (final f in const [0.0, 0.5, 1.0]) {
      expect(TeamChemistry.factor(f, 1), TeamChemistry.factor(f, 0));
    }
  });
}
