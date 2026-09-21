import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/club/club_form.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/match/strength_factors.dart';
import 'package:fnm/domain/services/squad/captaincy.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';

/// PlayerCondition is a plain record typedef — built inline with whatever the
/// case under test needs, and neutral everywhere else.
PlayerCondition aCondition({
  required int overallDelta,
  ClubStanding? clubStanding,
  int gamesInWindow = 0,
}) => (
  form: PlayerForm.steady,
  formRating: 0,
  fatigueState: FatigueState.fresh,
  gamesInWindow: gamesInWindow,
  overallDelta: overallDelta,
  clubStanding: clubStanding,
);

int? deltaOf(List<StrengthFactor> factors, StrengthFactorKind kind) {
  for (final f in factors) {
    if (f.kind == kind) return f.delta;
  }
  return null;
}

void main() {
  group('StrengthFactors', () {
    test('a drilled shape and a tired squad both show up, biggest first', () {
      final factors = StrengthFactors.of(
        familiarity: 1,
        conditionByPlayer: {
          1: aCondition(overallDelta: -6),
          2: aCondition(overallDelta: -4),
        },
        morale: 50,
        hasCaptain: false,
        staff: const {},
      );
      expect(factors.first.kind, StrengthFactorKind.fatigue);
      expect(factors.map((f) => f.kind), contains(StrengthFactorKind.familiarity));
      expect(factors.every((f) => f.delta != 0), isTrue);
    });

    test('a neutral side has nothing to report', () {
      expect(
        StrengthFactors.of(
          familiarity: 0,
          conditionByPlayer: const {},
          morale: 50,
          hasCaptain: false,
          staff: const {},
        ),
        isEmpty,
      );
    });

    test('familiarity is the chemistry multiplier against the side rating', () {
      final factors = StrengthFactors.of(
        familiarity: 1,
        conditionByPlayer: const {},
        morale: 50,
        hasCaptain: false,
        staff: const {},
        sideRating: 80,
        formationName: '4-3-3',
      );
      expect(
        deltaOf(factors, StrengthFactorKind.familiarity),
        ((TeamChemistry.factor(1) - 1) * 80).round(),
      );
      expect(factors.single.subject, '4-3-3');
    });

    test('a half-drilled shape is worth less than a settled one', () {
      int drilling(double familiarity) =>
          deltaOf(
            StrengthFactors.of(
              familiarity: familiarity,
              conditionByPlayer: const {},
              morale: 50,
              hasCaptain: false,
              staff: const {},
            ),
            StrengthFactorKind.familiarity,
          ) ??
          0;
      expect(drilling(0.5), lessThan(drilling(1)));
      expect(drilling(0), 0);
    });

    test('club standing reads as its own line, not as tired legs', () {
      // One man frozen out at his club: all of his delta is the club, so the
      // fatigue line has nothing left in it and drops out entirely.
      final factors = StrengthFactors.of(
        familiarity: 0,
        conditionByPlayer: {
          1: aCondition(
            overallDelta: ClubForm.sharpnessDelta(ClubStanding.frozenOut),
            clubStanding: ClubStanding.frozenOut,
          ),
        },
        morale: 50,
        hasCaptain: false,
        staff: const {},
      );
      expect(
        deltaOf(factors, StrengthFactorKind.clubForm),
        ClubForm.sharpnessDelta(ClubStanding.frozenOut),
      );
      expect(deltaOf(factors, StrengthFactorKind.fatigue), isNull);
    });

    test('tired legs and club standing are told apart in the same squad', () {
      final factors = StrengthFactors.of(
        familiarity: 0,
        conditionByPlayer: {
          // −4 in all: +1 for playing every week at his club, −5 of legs.
          1: aCondition(overallDelta: -4, clubStanding: ClubStanding.firstChoice),
        },
        morale: 50,
        hasCaptain: false,
        staff: const {},
      );
      expect(deltaOf(factors, StrengthFactorKind.fatigue), -5);
      expect(deltaOf(factors, StrengthFactorKind.clubForm), 1);
    });

    test('the dressing room is read from the morale seam', () {
      final factors = StrengthFactors.of(
        familiarity: 0,
        conditionByPlayer: const {},
        morale: 90,
        hasCaptain: false,
        staff: const {},
      );
      expect(
        deltaOf(factors, StrengthFactorKind.morale),
        Condition.moraleDelta(90),
      );
    });

    test('the captain is taken out of morale rather than added to it', () {
      const morale = 80;
      final factors = StrengthFactors.of(
        familiarity: 0,
        conditionByPlayer: const {},
        morale: morale,
        hasCaptain: true,
        staff: const {},
        captainMoraleBonus: Captaincy.maxMoraleBonus,
      );
      final captain = deltaOf(factors, StrengthFactorKind.captain) ?? 0;
      final room = deltaOf(factors, StrengthFactorKind.morale) ?? 0;
      expect(captain, greaterThan(0));
      // The two together are exactly what the engine applies — no point is
      // counted twice.
      expect(captain + room, Condition.moraleDelta(morale));
    });

    test('no captain, no captain line', () {
      final factors = StrengthFactors.of(
        familiarity: 0,
        conditionByPlayer: const {},
        morale: 80,
        hasCaptain: false,
        staff: const {},
      );
      expect(deltaOf(factors, StrengthFactorKind.captain), isNull);
      expect(
        deltaOf(factors, StrengthFactorKind.morale),
        Condition.moraleDelta(80),
      );
    });

    test('an elite staff room shows, an empty one does not', () {
      List<StrengthFactor> withStaff(Map<StaffRole, StaffTier> staff) =>
          StrengthFactors.of(
            familiarity: 0,
            conditionByPlayer: const {},
            morale: 50,
            hasCaptain: false,
            staff: staff,
          );
      expect(
        deltaOf(
          withStaff(const {
            StaffRole.fitnessCoach: StaffTier.elite,
            StaffRole.assistant: StaffTier.elite,
          }),
          StrengthFactorKind.staff,
        ),
        greaterThan(0),
      );
      expect(deltaOf(withStaff(const {}), StrengthFactorKind.staff), isNull);
      // The scout does nothing for today's eleven.
      expect(
        deltaOf(
          withStaff(const {StaffRole.scout: StaffTier.elite}),
          StrengthFactorKind.staff,
        ),
        isNull,
      );
    });

    test('everything at once reads biggest absolute first', () {
      final factors = StrengthFactors.of(
        familiarity: 1,
        conditionByPlayer: {
          1: aCondition(overallDelta: -9),
          2: aCondition(overallDelta: -9, clubStanding: ClubStanding.fringe),
          3: aCondition(overallDelta: 3, clubStanding: ClubStanding.firstChoice),
        },
        morale: 20,
        hasCaptain: true,
        staff: const {
          StaffRole.fitnessCoach: StaffTier.elite,
          StaffRole.assistant: StaffTier.elite,
        },
      );
      final sizes = <int>[for (final f in factors) f.delta.abs()];
      final descending = <int>[...sizes]..sort((a, b) => b.compareTo(a));
      expect(sizes, orderedEquals(descending));
      expect(factors.every((f) => f.delta != 0), isTrue);
    });
  });
}
