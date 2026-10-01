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
}
