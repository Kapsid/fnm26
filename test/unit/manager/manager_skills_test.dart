import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/manager/manager_skills.dart';
import 'package:fnm/domain/services/manager/staff.dart';

/// The manager's own progression, and the people he hires.
///
/// The rule the whole design rests on: a save that has never touched any of
/// this must play EXACTLY as it did before it existed. Every effect is a
/// departure from a neutral starting point, and neutral has to mean neutral.
void main() {
  Map<ManagerSkill, int> at(Map<ManagerSkill, int> overrides) => {
    for (final skill in ManagerSkill.values)
      skill: overrides[skill] ?? ManagerSkills.starting,
  };

  group('a manager who has done nothing changes nothing', () {
    test('every skill at its starting level is perfectly neutral', () {
      expect(ManagerSkills.moraleSwing(ManagerSkills.starting), 1.0);
      expect(ManagerSkills.familiarityGain(ManagerSkills.starting), 1.0);
      expect(ManagerSkills.youthTalentBonus(ManagerSkills.starting), 0.0);
      expect(ManagerSkills.incomeBonus(ManagerSkills.starting), 1.0);
    });

    test('no staff costs nothing and does nothing', () {
      expect(Staff.totalCost(const {}), 0);
      expect(Staff.injuryFactor(StaffTier.none), 1.0);
      expect(Staff.capsToKnow(StaffTier.none, 20), 20);
    });

    test('a balanced focus is a no-op whoever is running it', () {
      for (final tier in StaffTier.values) {
        expect(Training.injuryFactor(TrainingFocus.balanced, tier), 1.0);
        expect(Training.familiarityGain(TrainingFocus.balanced, tier), 1.0);
        expect(Training.youthTalentBonus(TrainingFocus.balanced, tier), 0.0);
      }
    });
  });

  group('earning and spending points', () {
    test('points come from time served and from winning', () {
      expect(
        ManagerSkills.pointsEarned(cyclesCompleted: 3, trophies: 2),
        3 * ManagerSkills.pointsPerCycle + 2 * ManagerSkills.pointsPerTrophy,
      );
    });

    test('what is left is what has not been put into a skill', () {
      final earned = ManagerSkills.pointsEarned(
        cyclesCompleted: 5,
        trophies: 0,
      );
      expect(
        ManagerSkills.pointsAvailable(earned: earned, levels: at({})),
        earned,
        reason: 'nothing spent yet',
      );
      expect(
        ManagerSkills.pointsAvailable(
          earned: earned,
          levels: at({ManagerSkill.tactical: ManagerSkills.starting + 4}),
        ),
        earned - 4,
      );
    });

    test('a skill cannot be raised without a point', () {
      expect(
        ManagerSkills.canRaise(
          skill: ManagerSkill.tactical,
          earned: 0,
          levels: at({}),
        ),
        isFalse,
      );
      expect(
        ManagerSkills.canRaise(
          skill: ManagerSkill.tactical,
          earned: 1,
          levels: at({}),
        ),
        isTrue,
      );
    });

    test('a skill cannot be raised past the ceiling', () {
      expect(
        ManagerSkills.canRaise(
          skill: ManagerSkill.tactical,
          earned: 99,
          levels: at({ManagerSkill.tactical: ManagerSkills.ceiling}),
        ),
        isFalse,
      );
    });
  });

  group('the effects are worth having and not worth breaking the game for', () {
    test('a skill helps above the start and hurts below it', () {
      // Both directions on purpose: a weak man-manager should be WORSE than
      // average, or the skill is just a slow drip of free morale.
      expect(ManagerSkills.moraleSwing(ManagerSkills.ceiling), greaterThan(1));
      expect(ManagerSkills.moraleSwing(ManagerSkills.floor), lessThan(1));
    });

    test('even a maxed skill is an edge, not a different game', () {
      for (final effect in [
        ManagerSkills.moraleSwing(ManagerSkills.ceiling),
        ManagerSkills.familiarityGain(ManagerSkills.ceiling),
        ManagerSkills.incomeBonus(ManagerSkills.ceiling),
      ]) {
        expect(effect, lessThan(1.6));
      }
      expect(
        ManagerSkills.youthTalentBonus(ManagerSkills.ceiling),
        lessThan(0.2),
      );
    });

    test('a value outside the scale cannot produce a wild multiplier', () {
      // A corrupted or hand-edited save must not hand somebody a 10x.
      expect(
        ManagerSkills.moraleSwing(9999),
        ManagerSkills.moraleSwing(ManagerSkills.ceiling),
      );
      expect(
        ManagerSkills.moraleSwing(-50),
        ManagerSkills.moraleSwing(ManagerSkills.floor),
      );
    });
  });

  group('staff', () {
    test('better costs more, at every step', () {
      final costs = [
        for (final tier in StaffTier.values) Staff.costPerCycle(tier),
      ];
      for (var i = 1; i < costs.length; i++) {
        expect(costs[i], greaterThan(costs[i - 1]));
      }
    });

    test('a full elite staff is a real share of a cycle budget', () {
      // If it were cheap it would not be a decision. A mid-table nation opens
      // a cycle on roughly EUR 12M.
      final all = {for (final role in StaffRole.values) role: StaffTier.elite};
      expect(Staff.totalCost(all), greaterThan(6000000));
    });

    test('a better scout tells you sooner', () {
      final caps = [
        for (final tier in StaffTier.values) Staff.capsToKnow(tier, 20),
      ];
      for (var i = 1; i < caps.length; i++) {
        expect(caps[i], lessThan(caps[i - 1]));
      }
    });

    test('a fitness coach lowers the injury rate without abolishing it', () {
      expect(Staff.injuryFactor(StaffTier.elite), lessThan(1));
      expect(Staff.injuryFactor(StaffTier.elite), greaterThan(0.5));
    });

    test(
      'an assistant multiplies the training, and none of it is negative',
      () {
        expect(
          Staff.trainingEffect(StaffTier.none),
          lessThan(Staff.trainingEffect(StaffTier.elite)),
        );
        expect(Staff.trainingEffect(StaffTier.none), greaterThan(0));
      },
    );
  });

  group('training focus', () {
    test('fitness cuts injuries, and a better assistant cuts more', () {
      final none = Training.injuryFactor(TrainingFocus.fitness, StaffTier.none);
      final elite = Training.injuryFactor(
        TrainingFocus.fitness,
        StaffTier.elite,
      );
      expect(none, lessThan(1));
      expect(elite, lessThan(none));
      expect(elite, greaterThan(0.5), reason: 'still a nudge, not immunity');
    });

    test('cohesion beds a shape in faster', () {
      expect(
        Training.familiarityGain(TrainingFocus.cohesion, StaffTier.good),
        greaterThan(1),
      );
    });

    test('youth work adds to the academy rather than replacing it', () {
      expect(
        Training.youthTalentBonus(TrainingFocus.youth, StaffTier.good),
        greaterThan(0),
      );
      // Each focus does its OWN thing only -- picking youth must not quietly
      // also make the side fitter.
      expect(
        Training.injuryFactor(TrainingFocus.youth, StaffTier.elite),
        1.0,
      );
    });
  });
}
