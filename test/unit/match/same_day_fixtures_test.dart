import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/match/same_day_results.dart';

/// Which fixtures are the Summary's "other matches", and what of them shows
/// at each point of our match.
void main() {
  final day = DateTime(2030, 6, 14);
  var nextId = 100;
  var nextNation = 10;
  Fixture fx({
    int competitionId = 7,
    DateTime? date,
    int? groupId,
    String? round,
    int matchday = 2,
    int? home,
    int? away,
    int careerId = 1,
  }) => Fixture(
    id: nextId++,
    careerId: careerId,
    competitionId: competitionId,
    matchday: matchday,
    date: date ?? day,
    homeNationId: home ?? nextNation++,
    awayNationId: away ?? nextNation++,
    groupId: groupId,
    round: round,
  );

  group('select', () {
    test('a group: the rest of the group that day, nothing else', () {
      final ours = fx(groupId: 3, round: 'Q', home: 1, away: 2);
      final mate = fx(groupId: 3, round: 'Q');
      final otherGroup = fx(groupId: 4, round: 'Q');
      final otherDay = fx(groupId: 3, round: 'Q', date: DateTime(2030, 6, 17));
      final otherCup = fx(groupId: 3, competitionId: 8);
      final otherCareer = fx(groupId: 3, round: 'Q', careerId: 2);
      expect(
        SameDayFixtures.select(ours, [
          ours,
          otherGroup,
          otherDay,
          otherCup,
          otherCareer,
          mate,
        ]),
        [mate],
      );
    });

    test('a finals group or a Nations Cup league reads the same way', () {
      final ours = fx(groupId: 9, round: 'GROUP', home: 1, away: 2);
      final mates = [fx(groupId: 9, round: 'GROUP'), fx(groupId: 9)];
      expect(SameDayFixtures.select(ours, [ours, ...mates]), mates);
    });

    test('a knockout round: the other ties of that round that day', () {
      final ours = fx(round: 'QF', home: 1, away: 2);
      final tie = fx(round: 'QF');
      final laterTie = fx(round: 'QF', date: DateTime(2030, 6, 15));
      final semi = fx(round: 'SF');
      final grouped = fx(round: 'QF', groupId: 1);
      expect(
        SameDayFixtures.select(ours, [ours, semi, laterTie, grouped, tie]),
        [tie],
      );
    });

    test('a time of day on the date still reads as that day', () {
      final ours = fx(round: 'R16', home: 1, away: 2);
      final evening = fx(round: 'R16', date: DateTime(2030, 6, 14, 21));
      expect(SameDayFixtures.select(ours, [evening]), [evening]);
    });

    test('no round and no group: the same matchday', () {
      final ours = fx(home: 1, away: 2);
      final same = fx();
      final other = fx(matchday: 3);
      expect(SameDayFixtures.select(ours, [ours, other, same]), [same]);
    });

    test('a friendly has none', () {
      final ours = fx(round: Rounds.friendly, home: 1, away: 2);
      expect(
        SameDayFixtures.select(ours, [fx(round: Rounds.friendly)]),
        isEmpty,
      );
    });

    test('never a fixture of ours or of the manager', () {
      final ours = fx(groupId: 3, home: 1, away: 2);
      final mine = fx(groupId: 3, home: 2);
      final his = fx(groupId: 3, away: 99);
      final mate = fx(groupId: 3);
      expect(
        SameDayFixtures.select(ours, [mine, his, mate], managerNationId: 99),
        [mate],
      );
    });
  });

  group('reveal by our clock', () {
    test('the phase follows our half time and our whistle', () {
      expect(
        SameDayPhase.of(halfTime: false, fullTime: false),
        SameDayPhase.live,
      );
      expect(
        SameDayPhase.of(halfTime: true, fullTime: false),
        SameDayPhase.halfTime,
      );
      expect(
        SameDayPhase.of(halfTime: true, fullTime: true),
        SameDayPhase.fullTime,
      );
    });

    test('live nothing, then the goals to 45, then the result', () {
      final f = fx(groupId: 3, home: 1, away: 2).copyWith(
        homeScore: 2,
        awayScore: 2,
        played: true,
      );
      final s = SameDayResult.of(f, const [
        (nationId: 1, playerId: 1, minute: 3),
        (nationId: 2, playerId: 2, minute: 45),
        (nationId: 2, playerId: 2, minute: 46),
        (nationId: 1, playerId: 1, minute: 90),
      ]);
      expect(s.scoreAt(SameDayPhase.live), isNull);
      expect(s.scoreAt(SameDayPhase.halfTime), (home: 1, away: 1));
      expect(s.scoreAt(SameDayPhase.fullTime), (home: 2, away: 2));
    });

    test('a shootout shows the level score, not the stored extra goal', () {
      final f = fx(round: 'QF', home: 1, away: 2).copyWith(
        homeScore: 1,
        awayScore: 2,
        afterExtraTime: true,
        homePenalties: 3,
        awayPenalties: 5,
        played: true,
      );
      final s = SameDayResult.of(f, const [
        (nationId: 2, playerId: 2, minute: 30),
        (nationId: 1, playerId: 1, minute: 104),
      ]);
      expect(s.scoreAt(SameDayPhase.halfTime), (home: 0, away: 1));
      expect(s.scoreAt(SameDayPhase.fullTime), (home: 1, away: 1));
    });
  });
}
