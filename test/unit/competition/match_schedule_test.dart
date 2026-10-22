import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/match_schedule.dart';

Fixture fx(
  int id,
  DateTime date, {
  String? round,
  int matchday = 1,
  int? home,
  int? away,
  bool played = false,
  int? groupId,
  int? homePens,
  int? awayPens,
}) => Fixture(
  id: id,
  careerId: 1,
  competitionId: 1,
  matchday: matchday,
  date: date,
  homeNationId: 1,
  awayNationId: 2,
  groupId: groupId,
  round: round,
  played: played,
  homeScore: home ?? (played ? 0 : null),
  awayScore: away ?? (played ? 0 : null),
  homePenalties: homePens,
  awayPenalties: awayPens,
);

List<ScheduleBlock> blocksOf(List<Fixture> f) =>
    MatchSchedule.blocks(f, nationId: 1);

void main() {
  test('a month of qualifiers is one block', () {
    final b = blocksOf([
      fx(1, DateTime(2026, 9, 6), round: 'CQ'),
      fx(2, DateTime(2026, 9, 9), round: 'CQ', matchday: 2),
      fx(3, DateTime(2026, 9, 12), round: 'CQ', matchday: 3),
    ]);
    expect(b, hasLength(1));
    expect((b.single.year, b.single.month), (2026, 9));
    expect(b.single.fixtures.map((f) => f.id), [1, 2, 3]);
  });

  test('a friendly after qualifiers in the same month is its own block', () {
    final b = blocksOf([
      fx(1, DateTime(2026, 9, 6), round: 'CQ'),
      fx(2, DateTime(2026, 9, 9), round: 'CQ', matchday: 2),
      fx(3, DateTime(2026, 9, 20), round: 'FRIENDLY'),
    ]);
    expect(b, hasLength(2));
  });

  test('empty months are omitted', () {
    final b = blocksOf([
      fx(1, DateTime(2026, 9, 6), round: 'CQ'),
      fx(2, DateTime(2026, 11, 6), round: 'CQ', matchday: 2),
    ]);
    expect(b.map((x) => x.month), [9, 11]);
  });

  test('a tournament splits by stage', () {
    final b = blocksOf([
      fx(1, DateTime(2030, 6, 11), round: 'GROUP'),
      fx(2, DateTime(2030, 6, 14), round: 'GROUP', matchday: 2),
      fx(3, DateTime(2030, 6, 17), round: 'GROUP', matchday: 3),
      fx(4, DateTime(2030, 6, 28), round: 'R16'),
    ]);
    expect(b, hasLength(2));
    expect(b.first.fixtures, hasLength(3));
  });

  test(
    'an unfinished group stage promises the knockouts from the day after',
    () {
      final b = blocksOf([
        fx(1, DateTime(2030, 6, 11), round: 'GROUP', played: true),
        fx(2, DateTime(2030, 6, 14), round: 'GROUP', matchday: 2),
        fx(3, DateTime(2030, 6, 17), round: 'GROUP', matchday: 3),
      ]);
      expect(b.last.pending, (
        knockoutStage: true,
        from: DateTime(2030, 6, 18),
      ));
    },
  );

  test(
    'a finished group stage with no knockouts drawn still promises them',
    () {
      // A five-team group (Copa America) gives each side a bye on one
      // matchday: a nation can have played its last group match while the
      // others have not, and the knockouts are created at the next sim step.
      final b = blocksOf([
        fx(1, DateTime(2030, 6, 11), round: 'GROUP', played: true),
        fx(2, DateTime(2030, 6, 14), round: 'GROUP', matchday: 2, played: true),
      ]);
      expect(b.last.pending, (
        knockoutStage: true,
        from: DateTime(2030, 6, 15),
      ));
    },
  );

  test('a group exit with the world knockouts drawn promises nothing', () {
    final b = MatchSchedule.blocks(
      [
        fx(1, DateTime(2030, 6, 11), round: 'GROUP', played: true),
        fx(2, DateTime(2030, 6, 14), round: 'GROUP', matchday: 2, played: true),
      ],
      nationId: 1,
      knockoutsDrawnFor: {'GROUP'},
    );
    expect(b.last.pending, isNull);
  });

  test('a group finished while the world knockouts are not drawn promises', () {
    final b = MatchSchedule.blocks(
      [fx(1, DateTime(2030, 6, 11), round: 'CGROUP', played: true)],
      nationId: 1,
      knockoutsDrawnFor: {'GROUP'}, // another tournament's does not count
    );
    expect(b.last.pending, (knockoutStage: true, from: DateTime(2030, 6, 12)));
  });

  test('knockouts of another tournament this cycle do not hide the row', () {
    final b = blocksOf([
      fx(1, DateTime(2030, 3, 5), round: 'CR16', played: true, home: 2),
      fx(2, DateTime(2030, 4, 5), round: 'POFINAL', played: true, home: 2),
      fx(3, DateTime(2030, 6, 11), round: 'GROUP', played: true),
    ]);
    expect(b.last.pending, (knockoutStage: true, from: DateTime(2030, 6, 12)));
  });

  test('a group stage followed by drawn knockouts promises nothing extra', () {
    final b = blocksOf([
      fx(1, DateTime(2030, 6, 11), round: 'GROUP', played: true),
      fx(2, DateTime(2030, 6, 20), round: 'R16'),
    ]);
    expect(b.last.pending, isNull);
  });

  group('a knockout', () {
    Fixture ko(String round, {int h = 2, int a = 1, int? hp, int? ap}) => fx(
      9,
      DateTime(2030, 6, 28),
      round: round,
      home: h,
      away: a,
      played: true,
      homePens: hp,
      awayPens: ap,
    );
    SchedulePending? pend(Fixture f) => blocksOf([f]).last.pending;

    test('won promises the next round', () {
      expect(
        pend(ko('R16')),
        (knockoutStage: false, from: DateTime(2030, 6, 29)),
      );
    });
    test(
      'lost promises none',
      () => expect(pend(ko('R16', h: 1, a: 2)), isNull),
    );
    test('a won final promises none', () => expect(pend(ko('FINAL')), isNull));
    test('a won third-place match promises none', () {
      expect(pend(ko('CFINAL')), isNull);
      expect(pend(ko('C3RD')), isNull);
    });
    test('won on penalties promises the next round', () {
      expect(
        pend(ko('QF', h: 1, a: 1, hp: 4, ap: 3)),
        (knockoutStage: false, from: DateTime(2030, 6, 29)),
      );
      expect(pend(ko('QF', h: 1, a: 1, hp: 3, ap: 4)), isNull);
    });
  });

  test('the Nations Cup gets no pending row', () {
    final b = blocksOf([
      fx(
        1,
        DateTime(2030, 6, 11),
        round: 'NSF',
        home: 2,
        away: 1,
        played: true,
      ),
    ]);
    expect(b.last.pending, isNull);
  });

  test('current skips a stale unplayed fixture left behind', () {
    final b = blocksOf([
      fx(1, DateTime(2026, 3, 14), round: 'FRIENDLY'),
      fx(2, DateTime(2026, 6, 6), round: 'CQ', played: true),
      fx(3, DateTime(2026, 6, 9), round: 'CQ', matchday: 2),
    ]);
    expect(
      MatchSchedule.currentIndex(b),
      b.indexWhere((x) => x.fixtures.any((f) => f.id == 3)),
    );
  });

  test('no current block once everything is played', () {
    final b = blocksOf([
      fx(1, DateTime(2026, 6, 6), round: 'CQ', played: true),
    ]);
    expect(MatchSchedule.currentIndex(b), -1);
    expect(MatchSchedule.currentIndex(const []), -1);
  });

  test('a legacy three-match month reads as one window', () {
    final b = blocksOf([
      fx(1, DateTime(2026, 10, 6), round: 'CQ', matchday: 4),
      fx(2, DateTime(2026, 10, 9), round: 'CQ', matchday: 5),
      fx(3, DateTime(2026, 10, 12), round: 'CQ', matchday: 6),
    ]);
    expect(b, hasLength(1));
  });
}
