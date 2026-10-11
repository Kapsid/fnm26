import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/federation/investment_editor.dart';

/// When the federation's money may be considered distributed.
///
/// The rule used to be "the remainder is smaller than one step", which is true
/// of every NEGATIVE remainder too — so an over-committed budget read as a
/// finished one and could be confirmed, spending money that was not there.
void main() {
  const million = 1000000;

  /// A four-level (€4M) notch: the step these cases were written against
  /// when the phone still moved €4M. The rule is the same for any notch.
  const fourLevels = 4;
  final phoneStep = budgetStepEuros(fourLevels);

  bool phoneReady({required int available, required int allocated}) =>
      budgetReady(
        available: available,
        allocated: allocated,
        stepLevels: fourLevels,
      );

  test('a phone notch and a tablet notch are both €1M', () {
    expect(phoneStep, 4 * million);
    expect(budgetStepEuros(kPhoneBudgetStepLevels), million);
    expect(budgetStepEuros(kTabletBudgetStepLevels), million);
  });

  group('a budget is ready when it is spent, not when it is overspent', () {
    test('spent to the last step', () {
      expect(
        phoneReady(available: 12 * million, allocated: 12 * million),
        isTrue,
      );
    });

    test('within one step of the bottom', () {
      expect(
        phoneReady(
          available: 12 * million,
          allocated: 12 * million - (phoneStep - 1),
        ),
        isTrue,
      );
    });

    test('a whole step still unspent is not finished', () {
      expect(
        phoneReady(
          available: 12 * million,
          allocated: 12 * million - phoneStep,
        ),
        isFalse,
      );
    });

    test('nothing allocated at all is not finished', () {
      expect(phoneReady(available: 12 * million, allocated: 0), isFalse);
    });

    test('a euro over is refused', () {
      expect(
        phoneReady(available: 12 * million, allocated: 12 * million + 1),
        isFalse,
      );
    });

    test('far over — the reported bug — is refused', () {
      // Allocate the lot, then hire an elite assistant on the same screen and
      // watch the ceiling drop underneath the allocation.
      expect(
        phoneReady(available: 9 * million, allocated: 12 * million),
        isFalse,
      );
    });

    test('nothing available and nothing promised is finished', () {
      expect(phoneReady(available: 0, allocated: 0), isTrue);
    });

    test('nothing available and something promised is refused', () {
      expect(phoneReady(available: 0, allocated: million), isFalse);
    });
  });

  group('the notch decides what is left over', () {
    bool tabletReady({required int available, required int allocated}) =>
        budgetReady(
          available: available,
          allocated: allocated,
          stepLevels: kTabletBudgetStepLevels,
        );

    test('a tablet banks €0.5M: no million fits in it', () {
      expect(
        tabletReady(available: 12500000, allocated: 12 * million),
        isTrue,
      );
    });

    test('a tablet with a whole €1M left is not finished', () {
      expect(
        tabletReady(available: 13 * million, allocated: 12 * million),
        isFalse,
      );
    });

    test('a phone still banks anything under €4M', () {
      expect(
        phoneReady(available: 15 * million, allocated: 12 * million),
        isTrue,
      );
      expect(
        phoneReady(available: 16 * million, allocated: 12 * million),
        isFalse,
      );
    });
  });
}
