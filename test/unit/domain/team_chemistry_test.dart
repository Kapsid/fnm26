import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';

void main() {
  group('TeamChemistry.factor', () {
    test('is neutral (1.0) for an unfamiliar side, never a penalty', () {
      expect(TeamChemistry.factor(0), 1.0);
    });

    test('rises with familiarity, capped at the drilled bonus', () {
      expect(TeamChemistry.factor(1), closeTo(1.08, 1e-9));
      expect(TeamChemistry.factor(0.5), greaterThan(TeamChemistry.factor(0)));
      // Out-of-range inputs are clamped.
      expect(TeamChemistry.factor(2), closeTo(1.08, 1e-9));
      expect(TeamChemistry.factor(-1), 1.0);
    });

    test('a side that has been read gives part of the bonus back', () {
      // Drilled but completely worked out: still ahead of a raw side, but by
      // half of what it would otherwise be worth — continuity stays worth
      // having, it is just never free. The HALF is the guarantee (see
      // `readPenalty`); the old figures took four sevenths.
      expect(TeamChemistry.factor(1, 1), closeTo(1.04, 1e-9));
      expect(TeamChemistry.factor(1, 1), lessThan(TeamChemistry.factor(1)));
      expect(TeamChemistry.factor(1, 1), greaterThan(TeamChemistry.factor(0)));
      expect(TeamChemistry.factor(1, 2), closeTo(1.04, 1e-9));
    });
  });

  group('TeamChemistry.bumpFamiliarity', () {
    test('the fielded shape climbs, others decay, both clamped to 0..1', () {
      expect(
        TeamChemistry.bumpFamiliarity(0.5, used: true),
        closeTo(0.58, 1e-9),
      );
      expect(
        TeamChemistry.bumpFamiliarity(0.5, used: false),
        closeTo(0.47, 1e-9),
      );
      expect(TeamChemistry.bumpFamiliarity(1, used: true), 1.0);
      expect(TeamChemistry.bumpFamiliarity(0, used: false), 0.0);
    });
  });

  group('TeamChemistry.bumpPredictability', () {
    test('the same shape with the same plan gets read a little more', () {
      expect(
        TeamChemistry.bumpPredictability(0.5, used: true, samePlan: true),
        closeTo(0.55, 1e-9),
      );
    });

    test('a change of plan makes what opponents knew stale', () {
      expect(
        TeamChemistry.bumpPredictability(0.5, used: true, samePlan: false),
        closeTo(0.38, 1e-9),
      );
    });

    test('a shape not fielded fades from the scouting reports', () {
      expect(
        TeamChemistry.bumpPredictability(0.5, used: false, samePlan: true),
        closeTo(0.43, 1e-9),
      );
    });

    test('stays inside 0..1', () {
      expect(
        TeamChemistry.bumpPredictability(1, used: true, samePlan: true),
        1.0,
      );
      expect(
        TeamChemistry.bumpPredictability(0, used: false, samePlan: false),
        0.0,
      );
    });
  });

  group('TeamChemistry.planKey', () {
    test('the same plan fingerprints the same, and is never 0', () {
      const plan = TacticalInstructions(mentality: 60, pressing: 70);
      expect(TeamChemistry.planKey(plan), TeamChemistry.planKey(plan));
      expect(TeamChemistry.planKey(plan), isNot(0));
    });

    test('nudging a dial is not a new plan; a real change is', () {
      const plan = TacticalInstructions(mentality: 60);
      expect(
        TeamChemistry.planKey(const TacticalInstructions(mentality: 61)),
        TeamChemistry.planKey(plan),
      );
      expect(
        TeamChemistry.planKey(const TacticalInstructions(mentality: 30)),
        isNot(TeamChemistry.planKey(plan)),
      );
    });
  });
}
