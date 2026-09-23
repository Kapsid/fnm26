import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';

/// When the federation's money may be considered distributed.
///
/// The rule used to be "the remainder is smaller than one step", which is true
/// of every NEGATIVE remainder too — so an over-committed budget read as a
/// finished one and could be confirmed, spending money that was not there.
void main() {
  const million = 1000000;

  group('a budget is ready when it is spent, not when it is overspent', () {
    test('spent to the last step', () {
      expect(budgetReady(available: 12 * million, allocated: 12 * million), isTrue);
    });

    test('within one step of the bottom', () {
      expect(
        budgetReady(
          available: 12 * million,
          allocated: 12 * million - (kBudgetStep - 1),
        ),
        isTrue,
      );
    });

    test('a whole step still unspent is not finished', () {
      expect(
        budgetReady(
          available: 12 * million,
          allocated: 12 * million - kBudgetStep,
        ),
        isFalse,
      );
    });

    test('nothing allocated at all is not finished', () {
      expect(budgetReady(available: 12 * million, allocated: 0), isFalse);
    });

    test('a euro over is refused', () {
      expect(
        budgetReady(available: 12 * million, allocated: 12 * million + 1),
        isFalse,
      );
    });

    test('far over — the reported bug — is refused', () {
      // Allocate the lot, then hire an elite assistant on the same screen and
      // watch the ceiling drop underneath the allocation.
      expect(
        budgetReady(available: 9 * million, allocated: 12 * million),
        isFalse,
      );
    });

    test('nothing available and nothing promised is finished', () {
      expect(budgetReady(available: 0, allocated: 0), isTrue);
    });

    test('nothing available and something promised is refused', () {
      expect(budgetReady(available: 0, allocated: million), isFalse);
    });
  });
}
