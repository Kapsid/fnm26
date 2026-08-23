import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/career/saves_screen.dart';

/// "Last played 3 days ago" is a sentence, and it shared a narrow row with the
/// share and delete buttons — so it was the thing that got cut, leaving the
/// manager reading "Last played 3 days…" and learning nothing.
void main() {
  final now = DateTime(2026, 8, 23, 20);

  String at({int minutes = 0, int hours = 0, int days = 0}) => agoShort(
    now.subtract(Duration(minutes: minutes, hours: hours, days: days)),
    now: now,
  );

  test('minutes, while it is still minutes', () {
    expect(at(minutes: 5), '5m');
    expect(at(minutes: 59), '59m');
  });

  test('a moment ago is still a minute, never zero', () {
    expect(at(), '1m');
    expect(at(minutes: 0), '1m');
  });

  test('hours through the first day', () {
    expect(at(hours: 1), '1h');
    expect(at(hours: 23), '23h');
  });

  test('days through the first week', () {
    expect(at(days: 1), '1d');
    expect(at(days: 6), '6d');
  });

  test('weeks, then years', () {
    expect(at(days: 7), '1w');
    expect(at(days: 40), '5w');
    expect(at(days: 400), '1y');
  });

  test('it always fits: a number and one letter', () {
    for (var d = 0; d < 800; d++) {
      final text = at(days: d);
      expect(text.length, lessThanOrEqualTo(4), reason: '$d days gave "$text"');
      expect(RegExp(r'^\d+[mhdwy]$').hasMatch(text), isTrue, reason: text);
    }
  });
}
