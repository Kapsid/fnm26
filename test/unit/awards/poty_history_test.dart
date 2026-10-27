import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/awards/poty_history.dart';
import 'package:fnm/features/awards/poty_history_providers.dart';
import 'package:fnm/features/messages/poty_card.dart';

PotyHistoryPlayer _p(int id, int nation, {String? name}) => (
  playerId: id,
  nationId: nation,
  name: name ?? 'Player $id',
  nationCode: 'n$nation',
  position: PlayerPosition.st,
  age: 25,
);

PotyHistoryYear _y(
  int year,
  PotyHistoryPlayer best, {
  List<PotyHistoryPlayer> rest = const [],
}) => (
  year: year,
  best: best,
  young: null,
  topFive: [
    (rank: 1, player: best),
    for (final (i, p) in rest.indexed) (rank: i + 2, player: p),
  ],
);

PlayerAward _h(int player, int nation, AwardKind kind, int year) => (
  playerId: player,
  nationId: nation,
  kind: kind,
  competition: '',
  year: year,
);

MessageItem _msg(int year, String body) => (
  id: year,
  category: 'award',
  title: 'Player of the Year $year',
  body: body,
  spec: null,
  year: year,
  read: true,
);

PotyPlace _place(int rank, int player, int nation, {int age = 24}) => (
  rank: rank,
  playerId: player,
  nationId: nation,
  own: false,
  name: 'Voted $player',
  nationCode: 'n$nation',
  nationName: '',
  age: age,
  overall: 80,
  position: PlayerPosition.cb,
  apps: 8,
  goals: 1,
  assists: 0,
  cleanSheets: 3,
  meanRating: 7.2,
  motms: 1,
  score: 30,
);

void main() {
  group('PotyHistory.build', () {
    test('most wins: by count, ties to the most recent win', () {
      final h = PotyHistory.build([
        _y(2027, _p(1, 10)),
        _y(2028, _p(2, 20)),
        _y(2029, _p(1, 10)),
        _y(2030, _p(3, 30)),
        _y(2031, _p(2, 20)),
        _y(2032, _p(4, 30)),
      ], ownNationId: 99);

      expect(h.years.map((y) => y.year), [2032, 2031, 2030, 2029, 2028, 2027]);
      // Players 1 and 2 both won twice; 2's latest (2031) beats 1's (2029).
      expect(h.mostWins.map((m) => m.player.playerId), [2, 1, 4, 3]);
      expect(h.mostWins.first.years, [2031, 2028]);
      expect(h.mostDecorated!.player.playerId, 2);
      expect(h.latest!.year, 2032);
    });

    test('by nation: wins summed over players, ties to the most recent', () {
      final h = PotyHistory.build([
        _y(2027, _p(1, 10)),
        _y(2028, _p(2, 20)),
        _y(2029, _p(1, 10)),
        _y(2030, _p(3, 30)),
        _y(2031, _p(2, 20)),
        _y(2032, _p(4, 30)),
      ], ownNationId: 99);

      // Each nation won twice: 30 most recently (2032), then 20, then 10.
      expect(h.byNation.map((n) => n.nationId), [30, 20, 10]);
      expect(h.byNation.first.years, [2032, 2030]);
    });

    test("the manager's nation: winners and top-five finishes", () {
      final h = PotyHistory.build([
        _y(2027, _p(1, 10), rest: [_p(5, 7), _p(6, 7)]),
        _y(2028, _p(5, 7), rest: [_p(2, 20)]),
        _y(2029, _p(3, 30), rest: [_p(4, 40)]),
      ], ownNationId: 7);

      expect(h.ownWinners, 1);
      expect(h.ownFinishes.length, 3);
      expect(
        h.ownFinishes.map((f) => (f.year, f.rank, f.player.playerId)),
        [(2028, 1, 5), (2027, 2, 5), (2027, 3, 6)],
      );
    });

    test('a year with no stored top five still counts its winner', () {
      final h = PotyHistory.build([
        (year: 2027, best: _p(1, 7), young: null, topFive: const []),
      ], ownNationId: 7);

      expect(h.ownWinners, 1);
      expect(h.ownFinishes.single.rank, 1);
    });

    test('empty', () {
      final h = PotyHistory.build(const [], ownNationId: 7);
      expect(h.isEmpty, isTrue);
      expect(h.latest, isNull);
      expect(h.mostDecorated, isNull);
      expect(h.byNation, isEmpty);
    });
  });

  group('assemblePotyYears', () {
    const codes = {10: 'AAA', 20: 'BBB', 30: 'CCC'};

    test('an old save with honours only still lists its winners', () {
      final honours = [
        _h(1, 10, AwardKind.playerOfYear, 2027),
        _h(2, 20, AwardKind.youngPlayerOfYear, 2027),
        _h(1, 10, AwardKind.playerOfYear, 2028),
        // The cabinet's other honours are not Player of the Year.
        _h(9, 30, AwardKind.goldenBall, 2028),
      ];
      // Its messages were plain sentences, which decode to nothing.
      final messages = [_msg(2027, 'Player 1 is the Player of the Year.')];

      final bare = assemblePotyYears(
        honours: honours,
        messages: messages,
        nationCodes: codes,
      );
      expect(bare.map((y) => y.year), [2028, 2027]);
      expect(bare.last.best!.playerId, 1);
      expect(bare.last.best!.nationCode, 'aaa');
      expect(bare.last.best!.name, isNull);
      expect(bare.last.young!.playerId, 2);
      expect(bare.every((y) => y.topFive.isEmpty), isTrue);

      // Named from the pool, his age wound back to the year.
      final named = assemblePotyYears(
        honours: honours,
        messages: messages,
        nationCodes: codes,
        pool: {
          1: (name: 'Old Hand', position: PlayerPosition.cm, ageNow: 33),
        },
        nowYear: 2032,
      );
      expect(named.last.best!.name, 'Old Hand');
      expect(named.last.best!.age, 28);
      expect(named.first.best!.age, 29);
      expect(named.last.best!.position, PlayerPosition.cm);

      final h = PotyHistory.build(named, ownNationId: 10);
      expect(h.mostWins.single.years, [2028, 2027]);
      expect(h.ownWinners, 2);
      // No top five stored: each winning year is one top-five finish.
      expect(h.ownFinishes.length, 2);
    });

    test('a version 1 body names the two winners', () {
      final body = encodePotyReport([
        (
          young: false,
          name: 'Version One',
          nationCode: 'aaa',
          nationName: 'A',
          age: 27,
          overall: 85,
          apps: 9,
          goals: 5,
          assists: 2,
          meanRating: 7.4,
          motms: 2,
        ),
      ]);
      final years = assemblePotyYears(
        honours: [_h(1, 10, AwardKind.playerOfYear, 2027)],
        messages: [_msg(2027, body)],
        nationCodes: codes,
      );
      expect(years.single.best!.name, 'Version One');
      expect(years.single.best!.age, 27);
      expect(years.single.topFive, isEmpty);
    });

    test('a version 2 body adds the top five', () {
      final body = encodePotyVote((
        best: [
          _place(1, 1, 10),
          _place(2, 2, 20),
          _place(3, 3, 30),
        ],
        young: [_place(1, 2, 20, age: 19)],
      ));
      final years = assemblePotyYears(
        honours: [
          _h(1, 10, AwardKind.playerOfYear, 2029),
          _h(2, 20, AwardKind.youngPlayerOfYear, 2029),
        ],
        messages: [_msg(2029, body)],
        nationCodes: codes,
      );
      final y = years.single;
      expect(y.best!.name, 'Voted 1');
      expect(y.best!.position, PlayerPosition.cb);
      expect(y.young!.age, 19);
      expect(y.topFive.map((p) => p.rank), [1, 2, 3]);
      expect(y.topFive[1].player.playerId, 2);
    });
  });
}
