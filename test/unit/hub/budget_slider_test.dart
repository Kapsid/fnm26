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
void main() {
  const price = FederationFinance.investLevelPrice;

  group('affordableLevel', () {
    test('takes the level asked for when it is paid for', () {
      expect(
        affordableLevel(wanted: 3, room: 20 * 1000000, price: price, max: 10),
        3,
      );
    });

    test('never more levels than the room left pays for', () {
      expect(
        affordableLevel(wanted: 9, room: 13 * 1000000, price: price, max: 10),
        3,
      );
    });

    test('never above the department\'s top level', () {
      expect(
        affordableLevel(wanted: 10, room: 99 * 1000000, price: price, max: 6),
        6,
      );
    });

    test('less than one level of room buys nothing', () {
      expect(
        affordableLevel(wanted: 1, room: price - 1, price: price, max: 10),
        0,
      );
      expect(affordableLevel(wanted: 1, room: -1, price: price, max: 10), 0);
    });
  });

  test('every level of every department visibly improves on the last', () {
    final l = AppLocalizationsEn();
    for (final dept in Department.values) {
      final lines = [
        for (var level = 1; level <= FederationFinance.maxLevels(dept); level++)
          DepartmentEffect.describe(l, dept, level * price),
      ];
      expect(lines.toSet(), hasLength(lines.length), reason: '$dept: $lines');
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
    expect(
      budgetReady(
        available: 500 * 1000000,
        allocated: 200 * 1000000,
        levelsLeft: false,
      ),
      isTrue,
    );
  });
}
