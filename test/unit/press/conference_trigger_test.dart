import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/expectation.dart';

OwnMatch om(
  int day,
  int s,
  int c, {
  ResultStanding standing = ResultStanding.par,
  bool knockout = false,
  bool last = false,
}) => (
  fixtureId: day,
  date: DateTime.utc(2030, 1, 1).add(Duration(days: day)),
  scored: s,
  conceded: c,
  knockout: knockout,
  lastGroupMatch: last,
  standing: standing,
);

ConferenceReason? reason(
  List<OwnMatch> played, {
  int board = 60,
  bool job = false,
  int count = 0,
  DateTime? last,
}) => ConferenceTrigger.reasonFor(
  played: played,
  board: board,
  jobJustBroken: job,
  conferencesThisCycle: count,
  lastConference: last,
);

void main() {
  test('nothing before his first competitive match', () {
    expect(reason(const [], board: 10), isNull);
  });

  test('a heroic knockout win is a big win', () {
    expect(
      reason([om(10, 2, 0, standing: ResultStanding.heroic, knockout: true)]),
      ConferenceReason.bigWin,
    );
  });

  test('a heroic win that changes nothing is not', () {
    expect(reason([om(10, 2, 0, standing: ResultStanding.heroic)]), isNull);
  });

  test('a humiliating loss on the last group matchday is a big loss', () {
    expect(
      reason([om(10, 0, 4, standing: ResultStanding.humiliating, last: true)]),
      ConferenceReason.bigLoss,
    );
  });

  test('a heroic win that ends a winless run of three matters', () {
    expect(
      reason([
        om(1, 0, 1),
        om(2, 0, 0),
        om(3, 0, 2),
        om(10, 3, 0, standing: ResultStanding.heroic),
      ]),
      ConferenceReason.bigWin,
    );
  });

  test('three winless with two losses is a crisis; three draws are not', () {
    expect(
      reason([om(1, 0, 1), om(2, 0, 0), om(3, 0, 2)]),
      ConferenceReason.crisis,
    );
    expect(reason([om(1, 0, 0), om(2, 1, 1), om(3, 2, 2)]), isNull);
  });

  test('a worried board is a crisis only after a match he did not win', () {
    expect(reason([om(1, 0, 1)], board: 39), ConferenceReason.crisis);
    expect(reason([om(1, 1, 0)], board: 39), isNull);
  });

  test('crisis outranks a big result', () {
    expect(
      reason([
        om(1, 0, 1),
        om(2, 0, 2),
        om(3, 0, 5, standing: ResultStanding.humiliating, knockout: true),
      ]),
      ConferenceReason.crisis,
    );
  });

  test('45 quiet days, which only a broken job promise breaks', () {
    final played = [om(10, 0, 1), om(20, 0, 0), om(30, 0, 2)];
    final last = DateTime.utc(2030, 1, 1).add(Duration.zero);
    expect(reason(played, last: last), isNull);
    expect(reason(played, last: last, job: true), ConferenceReason.jobVerdict);
  });

  test('six a cycle at most, except a job verdict', () {
    final played = [om(1, 0, 1), om(2, 0, 0), om(3, 0, 2)];
    expect(reason(played, count: 6), isNull);
    expect(reason(played, count: 6, job: true), ConferenceReason.jobVerdict);
  });

  test('startsRun: two wins then a heroic win (run of 3) is a big win', () {
    expect(
      reason([
        om(1, 1, 0),
        om(2, 2, 1),
        om(10, 2, 0, standing: ResultStanding.heroic),
      ]),
      ConferenceReason.bigWin,
    );
  });

  test('startsRun: heroic win after only one prior win (run of 2) is not', () {
    expect(
      reason([
        om(1, 1, 0),
        om(10, 2, 0, standing: ResultStanding.heroic),
      ]),
      isNull,
    );
  });

  test('endsRun: three wins then humiliating loss is a big loss', () {
    expect(
      reason([
        om(1, 1, 0),
        om(2, 2, 1),
        om(3, 1, 0),
        om(10, 0, 2, standing: ResultStanding.humiliating),
      ]),
      ConferenceReason.bigLoss,
    );
  });

  test(
    'endsRun negative: two winless then heroic win (prior run < 3) is not',
    () {
      expect(
        reason([
          om(1, 0, 1),
          om(2, 0, 0),
          om(10, 2, 0, standing: ResultStanding.heroic),
        ]),
        isNull,
      );
    },
  );

  test(
    'unsorted input: ends winless run scenario shuffled gives same result',
    () {
      final ordered = [
        om(1, 0, 1),
        om(2, 0, 0),
        om(3, 0, 2),
        om(10, 3, 0, standing: ResultStanding.heroic),
      ];
      final shuffled = [
        om(10, 3, 0, standing: ResultStanding.heroic),
        om(1, 0, 1),
        om(3, 0, 2),
        om(2, 0, 0),
      ];
      expect(reason(ordered), ConferenceReason.bigWin);
      expect(reason(shuffled), ConferenceReason.bigWin);
    },
  );

  test('quiet boundary: 44 days after lastConference is not enough', () {
    final played = [om(10, 0, 1), om(20, 0, 0), om(30, 0, 2)];
    final last = DateTime.utc(2030, 1, 1).add(const Duration(days: 30 - 44));
    expect(reason(played, last: last), isNull);
  });

  test('quiet boundary: 45 days after lastConference breaks silence', () {
    final played = [om(10, 0, 1), om(20, 0, 0), om(30, 0, 2)];
    final last = DateTime.utc(2030, 1, 1).add(const Duration(days: 30 - 45));
    expect(reason(played, last: last), ConferenceReason.crisis);
  });

  test('ceiling boundary: 5 conferences with crisis sequence → crisis', () {
    final played = [om(1, 0, 1), om(2, 0, 0), om(3, 0, 2)];
    expect(reason(played, count: 5), ConferenceReason.crisis);
  });

  test('board boundary: board 40 after a loss is not a crisis', () {
    expect(reason([om(1, 0, 1)], board: 40), isNull);
  });

  test('same date, higher fixtureId is latest (deterministic sort)', () {
    final date = DateTime.utc(2030, 1, 1);
    final m1 = (
      fixtureId: 1,
      date: date,
      scored: 1,
      conceded: 0,
      knockout: false,
      lastGroupMatch: false,
      standing: ResultStanding.par,
    );
    final m2 = (
      fixtureId: 2,
      date: date,
      scored: 1,
      conceded: 0,
      knockout: false,
      lastGroupMatch: false,
      standing: ResultStanding.par,
    );
    final m3 = (
      fixtureId: 3,
      date: date,
      scored: 2,
      conceded: 0,
      knockout: true,
      lastGroupMatch: false,
      standing: ResultStanding.heroic,
    );
    // All orderings should sort to [m1, m2, m3] and recognize m3 as latest
    expect(reason([m3, m1, m2]), ConferenceReason.bigWin);
    expect(reason([m1, m3, m2]), ConferenceReason.bigWin);
    expect(reason([m1, m2, m3]), ConferenceReason.bigWin);
  });
}
