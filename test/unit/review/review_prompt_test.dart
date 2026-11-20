import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/review/review_prompt.dart';

/// When the store's rating dialog is asked for: a won match, from the third
/// cycle or right after a trophy, at most three times, a cycle and ninety
/// days apart.
void main() {
  final now = DateTime(2027, 6, 1);
  bool ask({
    bool won = true,
    int cycle = 2,
    bool trophy = false,
    int asks = 0,
    DateTime? lastAt,
    bool thisCycle = false,
  }) => ReviewPrompt.shouldAsk(
    won: won,
    cycle: cycle,
    newTrophy: trophy,
    asks: asks,
    lastAt: lastAt,
    askedThisCycle: thisCycle,
    now: now,
  );

  test('a won match in the third cycle', () {
    expect(ask(), isTrue);
    expect(ask(won: false), isFalse, reason: 'never after a bad day');
  });

  test('before the third cycle only after a trophy', () {
    expect(ask(cycle: 0), isFalse);
    expect(ask(cycle: 1), isFalse);
    expect(ask(cycle: 0, trophy: true), isTrue);
  });

  test('three times at most, a cycle and ninety days apart', () {
    expect(ask(asks: 3), isFalse);
    expect(ask(asks: 3, trophy: true), isFalse);
    expect(ask(thisCycle: true), isFalse);
    expect(ask(lastAt: now.subtract(const Duration(days: 89))), isFalse);
    expect(ask(lastAt: now.subtract(const Duration(days: 90))), isTrue);
  });
}
