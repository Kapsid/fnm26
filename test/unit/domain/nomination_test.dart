import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/squad/nomination.dart';

Fixture _f({
  required int md,
  String? round,
  required int day,
  bool played = false,
}) => Fixture(
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
      'period starts before qualifying, every window, friendlies, tournaments',
      () {
        // Qualifying re-opens at MD1, 3, 5, … — every international WINDOW,
        // which is two matches. It used to be every four matchdays, so a
        // manager named one squad and lived with it through four or six
        // qualifiers spread over half a year, which nobody does.
        expect(
          Nomination.isPeriodStart(_f(md: 1, round: null, day: 1), null),
          isTrue,
        );
        // The second match of a gathering is played by the side named for it.
        expect(
          Nomination.isPeriodStart(
            _f(md: 2, round: null, day: 2),
            _f(md: 1, round: null, day: 1),
          ),
          isFalse,
        );
        expect(
          Nomination.isPeriodStart(
            _f(md: 3, round: null, day: 3),
            _f(md: 2, round: null, day: 2),
          ),
          isTrue,
        );
        expect(
          Nomination.isPeriodStart(
            _f(md: 5, round: null, day: 5),
            _f(md: 4, round: null, day: 4),
          ),
          isTrue,
        );
        // MD6 is the second match of the MD5 gathering, not a new one.
        expect(
          Nomination.isPeriodStart(
            _f(md: 6, round: null, day: 6),
            _f(md: 5, round: null, day: 5),
          ),
          isFalse,
        );
        // A friendly opening a window (previous wasn't a friendly).
        expect(
          Nomination.isPeriodStart(
            _f(md: 1, round: 'FRIENDLY', day: 20),
            _f(md: 10, round: null, day: 10),
          ),
          isTrue,
        );
        // A tournament group's first match.
        expect(
          Nomination.isPeriodStart(_f(md: 1, round: 'GROUP', day: 30), null),
          isTrue,
        );
        // A knockout round mid-tournament is NOT a new window.
        expect(
          Nomination.isPeriodStart(
            _f(md: 1, round: 'QF', day: 40),
            _f(md: 3, round: 'GROUP', day: 39),
          ),
          isFalse,
        );
      },
    );

    test('currentPeriod covers up to the next window', () {
      final fixtures = [
        _f(md: 1, round: null, day: 1, played: true), // played qualifier
        _f(md: 2, round: null, day: 2), // next unplayed
        _f(md: 3, round: null, day: 3),
        _f(md: 4, round: null, day: 4),
        _f(md: 5, round: null, day: 5),
        _f(md: 6, round: null, day: 6),
      ];
      final period = Nomination.currentPeriod(fixtures);
      // MD2 is the back half of the MD1 gathering; MD3 opens the next one, so
      // the squad currently named has exactly one match left to play.
      expect(period.map((f) => f.matchday), [2]);
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
