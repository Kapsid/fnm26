import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/squad/nomination.dart';

/// Tester, 1.0.9: the squad named for the finals and its warm-up camp was
/// offered as "Name your squad for the friendlies", because the label read
/// the window's first match, a send-off friendly. The window is the
/// tournament's.
void main() {
  Fixture f(int id, DateTime date, String round, {int matchday = 1}) => Fixture(
    id: id,
    careerId: 1,
    competitionId: 1,
    homeNationId: 1,
    awayNationId: 2,
    date: date,
    matchday: matchday,
    round: round,
  );

  test('warm-ups then the finals: the window is led by the finals opener', () {
    final fixtures = [
      f(1, DateTime(2028, 6, 1), 'FRIENDLY'),
      f(2, DateTime(2028, 6, 5), 'FRIENDLY'),
      f(3, DateTime(2028, 6, 11), 'CGROUP'),
      f(4, DateTime(2028, 6, 15), 'CGROUP', matchday: 2),
    ];
    final period = Nomination.currentPeriod(fixtures);
    expect(period.first.round, 'FRIENDLY');
    expect(Nomination.leadOf(period).id, 3);
  });

  test('a plain friendly window is led by its first friendly', () {
    final fixtures = [
      f(1, DateTime(2027, 3, 20), 'FRIENDLY'),
      f(2, DateTime(2027, 3, 24), 'FRIENDLY'),
    ];
    expect(Nomination.leadOf(Nomination.currentPeriod(fixtures)).id, 1);
  });
}
