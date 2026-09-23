import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/squad/absence_outlook.dart';

Fixture fx(int id, DateTime date, {int home = 1, int away = 2}) => Fixture(
  id: id,
  careerId: 1,
  competitionId: 1,
  groupId: null,
  matchday: id,
  date: date,
  homeNationId: home,
  awayNationId: away,
  round: 'CQ',
);

void main() {
  final now = DateTime(2026, 3);
  final upcoming = [
    fx(1, DateTime(2026, 3, 25)),
    fx(2, DateTime(2026, 3, 29), home: 3, away: 1),
    fx(3, DateTime(2026, 6, 6)),
    fx(4, DateTime(2026, 6, 10), home: 4, away: 1),
  ];

  test('an available player has no outlook', () {
    expect(
      AbsenceOutlooks.forAbsence(
        const PlayerAbsence(playerId: 9, yellows: 1),
        upcoming: upcoming,
        from: now,
        nationId: 1,
      ),
      isNull,
    );
    expect(
      AbsenceOutlooks.forAbsence(
        null,
        upcoming: upcoming,
        from: now,
        nationId: 1,
      ),
      isNull,
    );
  });

  test('a two-game knock names the match back and the weeks to it', () {
    final o = AbsenceOutlooks.forAbsence(
      const PlayerAbsence(playerId: 9, injuryMatches: 2),
      upcoming: upcoming,
      from: now,
      nationId: 1,
    )!;
    expect(o.injured, isTrue);
    expect(o.matches, 2);
    // Misses the two March games, back for the June opener.
    expect(o.returnDate, DateTime(2026, 6, 6));
    expect(o.returnOpponentId, 2);
    // 3 March → 6 June is a shade over 14 weeks.
    expect(o.weeks, 14);
  });

  test('the opponent is read from the squad\'s side of the fixture', () {
    final o = AbsenceOutlooks.forAbsence(
      const PlayerAbsence(playerId: 9, banMatches: 1),
      upcoming: upcoming,
      from: now,
      nationId: 1,
    )!;
    expect(o.injured, isFalse);
    // Back for fixture 2, where nation 1 is away to nation 3.
    expect(o.returnOpponentId, 3);
  });

  test('a ban and a knock run concurrently, not back to back', () {
    // Discipline serves a match off both every game, so three games out is
    // three games out — not four.
    final o = AbsenceOutlooks.forAbsence(
      const PlayerAbsence(playerId: 9, banMatches: 1, injuryMatches: 3),
      upcoming: upcoming,
      from: now,
      nationId: 1,
    )!;
    expect(o.matches, 3);
    expect(o.returnDate, DateTime(2026, 6, 10));
  });

  test('nothing scheduled that far ahead falls back to a game count', () {
    final o = AbsenceOutlooks.forAbsence(
      const PlayerAbsence(playerId: 9, injuryMatches: 9),
      upcoming: upcoming,
      from: now,
      nationId: 1,
    )!;
    expect(o.matches, 9);
    expect(o.weeks, 0);
    expect(o.returnDate, isNull);
  });

  test('fixtures need not be given in order', () {
    final o = AbsenceOutlooks.forAbsence(
      const PlayerAbsence(playerId: 9, injuryMatches: 1),
      upcoming: upcoming.reversed.toList(),
      from: now,
      nationId: 1,
    )!;
    expect(o.returnDate, DateTime(2026, 3, 29));
  });
}
