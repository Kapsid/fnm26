import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/federation/investment_editor.dart';

/// A budget has to be finishable.
///
/// Every department rounded down to the nearest €500k, and a federation's
/// balance is whatever it happens to hold — so a manager who dragged every
/// slider to its limit was still left looking at money no slider would take,
/// on the one screen he is not allowed to leave unfinished.
void main() {
  const step = 500000;

  test('an ordinary drag rounds down to the step', () {
    expect(clampDepartment(raw: 1_700_000, room: 12_000_000, step: step), 1_500_000);
    expect(clampDepartment(raw: 499_999, room: 12_000_000, step: step), 0);
  });

  test('the top of the slider takes the exact remainder', () {
    // 12,345,678 is not a whole number of steps, and it must still be spendable.
    expect(
      clampDepartment(raw: 99_000_000, room: 12_345_678, step: step),
      12_345_678,
    );
  });

  test('an odd balance can always be assigned down to nothing', () {
    for (final balance in [
      12_345_678,
      9_000_001,
      7_499_999,
      1,
      step - 1,
      step + 1,
    ]) {
      final taken = clampDepartment(raw: 1e12, room: balance, step: step);
      expect(taken, balance, reason: 'balance $balance left ${balance - taken}');
    }
  });

  test('it never takes more than there is', () {
    for (var room = 0; room < 3_000_000; room += 97_777) {
      final taken = clampDepartment(raw: 1e12, room: room, step: step);
      expect(taken, lessThanOrEqualTo(room));
      expect(taken, greaterThanOrEqualTo(0));
    }
  });

  test('no room means no money', () {
    expect(clampDepartment(raw: 5_000_000, room: 0, step: step), 0);
    expect(clampDepartment(raw: 5_000_000, room: -1, step: step), 0);
  });
}
