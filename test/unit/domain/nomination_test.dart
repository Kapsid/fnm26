import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/squad/nomination.dart';

Fixture _f({
  required int md,
  String? round,
  required int day,
  int month = 1,
  bool played = false,
}) => Fixture(
  id: month * 100 + day,
  careerId: 1,
  competitionId: 1,
  matchday: md,
  date: DateTime(2026, month, day),
  homeNationId: 1,
  awayNationId: 2,
  round: round,
  played: played,
  homeScore: played ? 1 : null,
  awayScore: played ? 0 : null,
);

void main() {
  group('Nomination', () {
    test('a tournament always opens a fresh nomination after friendlies', () {
      // Warm-up friendlies, then the finals group stage. The friendlies are one
      // period; the tournament must open its own.
      final fixtures = [
        _f(md: 1, round: 'FRIENDLY', day: 1, played: true),
        _f(md: 2, round: 'FRIENDLY', day: 4, played: true),
        _f(md: 1, round: 'GROUP', day: 10),
        _f(md: 2, round: 'GROUP', day: 13),
        _f(md: 3, round: 'GROUP', day: 16),
      ];
      expect(Nomination.windowOpen(fixtures), isTrue);
      final period = Nomination.currentPeriod(fixtures);
      expect(period.map((f) => f.round), everyElement('GROUP'));
      expect(period, hasLength(3), reason: 'the squad is locked for the group');
    });

    test('a fixture the world left behind does not pin the window shut', () {
      // The friendly on day 4 was never played, but the tournament kicked off
      // and its first game HAS been. The nomination for the second group match
      // must be read from where the nation actually is, not from the orphan.
      final fixtures = [
        _f(md: 1, round: 'FRIENDLY', day: 1, played: true),
        _f(md: 2, round: 'FRIENDLY', day: 4), // abandoned, never played
        _f(md: 1, round: 'GROUP', day: 10, played: true),
        _f(md: 2, round: 'GROUP', day: 13),
      ];
      expect(
        Nomination.windowOpen(fixtures),
        isFalse,
        reason: 'mid-tournament',
      );
      expect(Nomination.currentPeriod(fixtures).single.round, 'GROUP');
    });

    test(
      'period starts at each campaign, each window, friendlies, tournaments',
      () {
        // A window is a calendar month, whatever it holds: two, three or four
        // matches. It used to be every second matchday, which opened a call-up
        // in the middle of a three-match window.
        expect(
          Nomination.isPeriodStart(_f(md: 1, round: null, day: 6), null),
          isTrue,
        );
        // The rest of the window is played by the side named for it.
        expect(
          Nomination.isPeriodStart(
            _f(md: 2, round: null, day: 9),
            _f(md: 1, round: null, day: 6),
          ),
          isFalse,
        );
        expect(
          Nomination.isPeriodStart(
            _f(md: 3, round: null, day: 12),
            _f(md: 2, round: null, day: 9),
          ),
          isFalse,
          reason: 'a third match in the same window',
        );
        // The next month is the next window.
        expect(
          Nomination.isPeriodStart(
            _f(md: 4, round: 'CQ', day: 6, month: 2),
            _f(md: 3, round: 'CQ', day: 12),
          ),
          isTrue,
        );
        // A Nations Cup window too.
        expect(
          Nomination.isPeriodStart(
            _f(md: 3, round: 'NGROUP', day: 6, month: 2),
            _f(md: 2, round: 'NGROUP', day: 9),
          ),
          isTrue,
        );
        // A friendly opening a window (previous wasn't a friendly).
        expect(
          Nomination.isPeriodStart(
            _f(md: 1, round: 'FRIENDLY', day: 14, month: 3),
            _f(md: 10, round: null, day: 9, month: 2),
          ),
          isTrue,
        );
        // Friendlies in different windows are different gatherings.
        expect(
          Nomination.isPeriodStart(
            _f(md: 2, round: 'FRIENDLY', day: 14, month: 6),
            _f(md: 1, round: 'FRIENDLY', day: 14, month: 3),
          ),
          isTrue,
        );
        // A tournament group's first match.
        expect(
          Nomination.isPeriodStart(
            _f(md: 1, round: 'GROUP', day: 11, month: 6),
            null,
          ),
          isTrue,
        );
        // A knockout round is NOT a new window, even in the next month.
        expect(
          Nomination.isPeriodStart(
            _f(md: 1, round: 'QF', day: 2, month: 7),
            _f(md: 3, round: 'GROUP', day: 28, month: 6),
          ),
          isFalse,
        );
      },
    );

    test('currentPeriod covers the rest of the window', () {
      final fixtures = [
        _f(md: 1, round: null, day: 6, played: true), // played qualifier
        _f(md: 2, round: null, day: 9), // next unplayed
        _f(md: 3, round: null, day: 12),
        _f(md: 4, round: null, day: 6, month: 2),
        _f(md: 5, round: null, day: 9, month: 2),
        _f(md: 6, round: null, day: 6, month: 3),
      ];
      final period = Nomination.currentPeriod(fixtures);
      // The rest of the first window; the second opens in month 2.
      expect(period.map((f) => f.matchday), [2, 3]);
      // Mid-period → the nomination window is closed.
      expect(Nomination.windowOpen(fixtures), isFalse);
    });

    test('window is open when the next fixture starts a period', () {
      final fixtures = [
        _f(md: 4, round: null, day: 12, played: true),
        _f(md: 5, round: null, day: 6, month: 2), // the next window
      ];
      expect(Nomination.windowOpen(fixtures), isTrue);
    });

    test('the matches already played in this window', () {
      final fixtures = [
        _f(md: 1, round: null, day: 6, played: true),
        _f(md: 2, round: null, day: 9, played: true),
        _f(md: 3, round: null, day: 12),
        _f(md: 4, round: null, day: 6, month: 2),
      ];
      expect(
        Nomination.playedInCurrentPeriod(fixtures).map((f) => f.matchday),
        [1, 2],
      );
      // Between windows: nothing played in the next one yet.
      final between = [
        _f(md: 1, round: null, day: 6, played: true),
        _f(md: 2, round: null, day: 6, month: 2),
      ];
      expect(Nomination.playedInCurrentPeriod(between), isEmpty);
    });
  });
}
