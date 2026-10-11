import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/federation/department_effect.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

/// The budget is spent in whole levels, and every level buys something the
/// manager can see. A free slider let a few hundred thousand buy a figure that
/// rounded to nothing; rounding it up instead would have paid out for
/// spreading crumbs over every department.
///
/// A level is €1M, and the sliders on a phone and on a tablet move one a
/// notch (the phone used to move four, €4M).
void main() {
  const million = 1000000;
  const price = FederationFinance.investLevelPrice;

  /// The old €4M level price, which the arithmetic below was written in.
  final phoneNotch = budgetStepEuros(4);

  test('a level is €1M: forty of them, Medical twenty-four', () {
    expect(price, million);
    for (final dept in Department.values) {
      expect(
        FederationFinance.maxLevels(dept),
        dept == Department.medical ? 24 : 40,
        reason: '$dept',
      );
    }
  });

  test('the ceilings in euros did not move: 40M, Medical 24M', () {
    // The effect curves are keyed to euros, so the same top sum reads the
    // same as when a level was €4M (ten levels, Medical six).
    for (final dept in Department.values) {
      expect(
        FederationFinance.maxLevels(dept) * price,
        (dept == Department.medical ? 6 : 10) * 4 * million,
        reason: '$dept',
      );
    }
  });

  test('a phone slider has forty notches of €1M, Medical twenty-four', () {
    expect(budgetStepEuros(kPhoneBudgetStepLevels), million);
    for (final dept in Department.values) {
      expect(
        FederationFinance.maxLevels(dept) ~/ kPhoneBudgetStepLevels,
        dept == Department.medical ? 24 : 40,
      );
    }
  });

  // Priced per old €4M notch, the arithmetic these cases always pinned:
  // the editor hands [affordableLevel] its notch price and notch count.
  group('affordableLevel', () {
    test('takes the level asked for when it is paid for', () {
      expect(
        affordableLevel(
          wanted: 3,
          room: 20 * million,
          price: phoneNotch,
          max: 10,
        ),
        3,
      );
    });

    test('never more levels than the room left pays for', () {
      expect(
        affordableLevel(
          wanted: 9,
          room: 13 * million,
          price: phoneNotch,
          max: 10,
        ),
        3,
      );
      // The tablet's notch is a million: thirteen of them fit.
      expect(
        affordableLevel(wanted: 20, room: 13 * million, price: price, max: 40),
        13,
      );
    });

    test('never above the department\'s top level', () {
      expect(
        affordableLevel(
          wanted: 10,
          room: 99 * million,
          price: phoneNotch,
          max: 6,
        ),
        6,
      );
      expect(
        affordableLevel(wanted: 40, room: 99 * million, price: price, max: 24),
        24,
      );
    });

    test('less than one level of room buys nothing', () {
      expect(
        affordableLevel(
          wanted: 1,
          room: phoneNotch - 1,
          price: phoneNotch,
          max: 10,
        ),
        0,
      );
      expect(
        affordableLevel(wanted: 1, room: price - 1, price: price, max: 40),
        0,
      );
      expect(
        affordableLevel(wanted: 1, room: -1, price: phoneNotch, max: 10),
        0,
      );
    });
  });

  test(
    'every €4M of every department visibly improves on the last',
    () {
      final l = AppLocalizationsEn();
      for (final dept in Department.values) {
        final notches = FederationFinance.maxLevels(dept) ~/ 4;
        final lines = [
          for (var n = 1; n <= notches; n++)
            DepartmentEffect.describe(l, dept, n * phoneNotch),
        ];
        expect(lines.toSet(), hasLength(lines.length), reason: '$dept: $lines');
      }
    },
  );

  // At a million a level the effect lines are rounded figures and two
  // neighbouring millions can read the same (the academy gains ~0.3 overall
  // a million), so a tablet level is held to "never worse", not "always
  // different": the money still buys its effect, the words round it.
  test('no tablet level reads worse than the one below it', () {
    for (final dept in Department.values) {
      int figure(int euros) => switch (dept) {
        Department.youth => DepartmentEffect.youthOverall(euros),
        Department.commercial => FederationFinance.commercialReturn(euros),
        Department.medical => DepartmentEffect.injuryReductionPct(euros),
        Department.naturalization => DepartmentEffect.naturalisationPct(euros),
        Department.boardRelations => FederationFinance.boardTolerance(euros),
      };
      for (var level = 1; level <= FederationFinance.maxLevels(dept); level++) {
        expect(
          figure(level * price),
          greaterThanOrEqualTo(figure((level - 1) * price)),
          reason: '$dept level $level',
        );
      }
    }
  });

  test('medical stops where its injury reduction reaches the floor', () {
    final top = FederationFinance.maxLevels(Department.medical) * price;
    expect(FederationFinance.injuryFactor(top), closeTo(0.3, 1e-9));
    expect(
      FederationFinance.injuryFactor(top - price),
      greaterThan(FederationFinance.injuryFactor(top)),
    );
  });

  test('a budget with every department full is spent, whatever is left', () {
    for (final step in [kPhoneBudgetStepLevels, kTabletBudgetStepLevels]) {
      expect(
        budgetReady(
          available: 500 * million,
          allocated: 200 * million,
          stepLevels: step,
          levelsLeft: false,
        ),
        isTrue,
      );
    }
  });

  test('a single academy million never reads as 0 overall', () {
    expect(DepartmentEffect.youthOverall(0), 0);
    expect(DepartmentEffect.youthOverall(price), 1);
  });
}
