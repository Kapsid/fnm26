import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/squad/nomination.dart';

Fixture _f({
  required int md,
  String? round,
  required int day,
  bool played = false,
}) =>
    Fixture(
      id: day,
      careerId: 1,
      competitionId: 1,
      matchday: md,
      date: DateTime(2026, 1, day),
      homeNationId: 1,
      awayNationId: 2,
      round: round,
      played: played,
      homeScore: played ? 1 : null,
      awayScore: played ? 0 : null,
    );

void main() {
  group('Nomination', () {
    test('period starts before qualifying, every 4 MDs, friendlies, tournaments',
        () {
      // Qualifying re-opens at MD1, 5, 9, …; the matchdays in between do not.
      expect(Nomination.isPeriodStart(_f(md: 1, round: null, day: 1), null),
          isTrue);
      expect(
          Nomination.isPeriodStart(
              _f(md: 2, round: null, day: 2), _f(md: 1, round: null, day: 1)),
          isFalse);
      expect(
          Nomination.isPeriodStart(
              _f(md: 5, round: null, day: 5), _f(md: 4, round: null, day: 4)),
          isTrue);
      // MD6 is now mid-period, not a window.
      expect(
          Nomination.isPeriodStart(
              _f(md: 6, round: null, day: 6), _f(md: 5, round: null, day: 5)),
          isFalse);
      // A friendly opening a window (previous wasn't a friendly).
      expect(
          Nomination.isPeriodStart(_f(md: 1, round: 'FRIENDLY', day: 20),
              _f(md: 10, round: null, day: 10)),
          isTrue);
      // A tournament group's first match.
      expect(
          Nomination.isPeriodStart(_f(md: 1, round: 'GROUP', day: 30), null),
          isTrue);
      // A knockout round mid-tournament is NOT a new window.
      expect(
          Nomination.isPeriodStart(_f(md: 1, round: 'QF', day: 40),
              _f(md: 3, round: 'GROUP', day: 39)),
          isFalse);
    });

    test('currentPeriod covers up to the next window', () {
      final fixtures = [
        _f(md: 1, round: null, day: 1, played: true), // played qualifier
        _f(md: 2, round: null, day: 2), // next unplayed
        _f(md: 3, round: null, day: 3),
        _f(md: 4, round: null, day: 4),
        _f(md: 5, round: null, day: 5), // next window boundary (every 4)
        _f(md: 6, round: null, day: 6),
      ];
      final period = Nomination.currentPeriod(fixtures);
      expect(period.map((f) => f.matchday), [2, 3, 4]);
      // Mid-period → the nomination window is closed.
      expect(Nomination.windowOpen(fixtures), isFalse);
    });

    test('window is open when the next fixture starts a period', () {
      final fixtures = [
        _f(md: 4, round: null, day: 4, played: true),
        _f(md: 5, round: null, day: 5), // next unplayed = MD5 boundary
      ];
      expect(Nomination.windowOpen(fixtures), isTrue);
    });
  });
}
