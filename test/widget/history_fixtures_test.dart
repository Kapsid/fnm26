import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The fakes later tasks lean on must be what they say they are.
void main() {
  test('a squad deep enough for three boards and a hall of fame', () {
    expect(squadOf(seededNationId).length, greaterThanOrEqualTo(16));
    final book = fakeRecordBook();
    final ids = {
      for (final board in [book.mostCaps, book.topScorers, book.topAssists])
        for (final r in board) r.playerId,
    };
    expect(ids, hasLength(15));
    expect(rivalNation.id, isNot(seededNationId));
    expect(fakeRivalry().rival.id, rivalNation.id);
  });

  test('legends: a ranked hall of fame and an XI of eleven at most', () {
    final legends = fakeLegends();
    expect(legends.hallOfFame, hasLength(16));
    expect(legends.allTimeXi.length, inInclusiveRange(1, 11));
    expect(
      legends.hallOfFame.first.score,
      greaterThanOrEqualTo(legends.hallOfFame.last.score),
    );
  });

  test("the world's boards span four nations, the manager's first", () {
    final records = fakeAllTimeRecords();
    expect({for (final r in records.topScorers) r.nationId}, hasLength(4));
    expect(records.topScorers.first.nationId, seededNationId);
    expect(records.myNationIds, {seededNationId});
  });

  test("the ledger adds up; the pairing's record matches its meetings", () {
    for (final line in fakeLedger()) {
      expect(line.wins + line.draws + line.losses, line.played);
    }
    expect(fakeLedger().first.opponentId, rivalNation.id);
    final h = fakeHeadToHead();
    final m = fakeMeetings();
    expect(h.played, m.length);
    expect(h.winsA, m.where((x) => x.forA > x.forB).length);
    expect(h.draws, m.where((x) => x.forA == x.forB).length);
    expect(h.winsB, m.where((x) => x.forA < x.forB).length);
  });

  test('one set of results: the ledger, the head to head, the rivalry and '
      'the team records all read the same meetings', () {
    final byOpponent = fakeMeetingsByOpponent();
    final ledger = fakeLedger();
    expect({for (final l in ledger) l.opponentId}, byOpponent.keys.toSet());
    for (final line in ledger) {
      final h = headToHeadOf(byOpponent[line.opponentId]!);
      expect(
        (h.played, h.winsA, h.draws, h.winsB, h.goalsA, h.goalsB),
        (
          line.played,
          line.wins,
          line.draws,
          line.losses,
          line.goalsFor,
          line.goalsAgainst,
        ),
        reason: line.opponentName,
      );
    }
    // The rival is the most-met opponent, and every view of it agrees.
    final rival = ledger.first;
    expect(
      ledger.every((l) => l.played <= rival.played),
      isTrue,
    );
    expect(byOpponent[rivalNation.id], fakeMeetings());
    expect(headToHeadOf(fakeMeetings()), fakeHeadToHead());
    final r = fakeRivalry();
    expect(
      (
        r.rival.id,
        r.played,
        r.wins,
        r.draws,
        r.losses,
        r.goalsFor,
        r.goalsAgainst,
      ),
      (
        rival.opponentId,
        rival.played,
        rival.wins,
        rival.draws,
        rival.losses,
        rival.goalsFor,
        rival.goalsAgainst,
      ),
    );

    // The record book's biggest win and unbeaten run, from every meeting.
    final all = [
      for (final e in byOpponent.entries)
        for (final m in e.value) (opp: e.key, m: m),
    ]..sort((a, b) => a.m.date.compareTo(b.m.date));
    final best = all
        .where((x) => x.m.forA > x.m.forB)
        .reduce(
          (a, b) => b.m.forA - b.m.forB > a.m.forA - a.m.forB ? b : a,
        );
    final book = fakeRecordBook();
    expect(book.biggestWin, (
      oppId: best.opp,
      gf: best.m.forA,
      ga: best.m.forB,
    ));
    var run = 0;
    var longest = 0;
    for (final x in all) {
      run = x.m.forA >= x.m.forB ? run + 1 : 0;
      if (run > longest) longest = run;
    }
    expect(book.longestUnbeaten, longest);
  });

  test('the head-to-head fakes honour the pairing', () {
    final me = seededNationId;
    final rival = rivalNation.id;
    final key = (careerId: kSeededCareerId, nationA: me, nationB: rival);
    expect(fakeMeetingsFor(key), fakeMeetings());
    expect(headToHeadOf(fakeMeetingsFor(key)), fakeHeadToHead());

    // From the rival's side, the wins and the goals swap.
    final flipped = headToHeadOf(
      fakeMeetingsFor((careerId: kSeededCareerId, nationA: rival, nationB: me)),
    );
    final h = fakeHeadToHead();
    expect(flipped, (
      played: h.played,
      winsA: h.winsB,
      draws: h.draws,
      winsB: h.winsA,
      goalsA: h.goalsB,
      goalsB: h.goalsA,
      biggestWinMarginA: h.biggestWinMarginB,
      biggestWinMarginB: h.biggestWinMarginA,
    ));
    final first = fakeMeetingsFor(
      (careerId: kSeededCareerId, nationA: rival, nationB: me),
    ).first;
    expect((first.forA, first.penA), (fakeMeetings().first.forB, 3));

    // Two nations that never met: nothing.
    final strangers = (
      careerId: kSeededCareerId,
      nationA: rival,
      nationB: fakeLedger()[1].opponentId,
    );
    expect(fakeMeetingsFor(strangers), isEmpty);
    expect(headToHeadOf(fakeMeetingsFor(strangers)).played, 0);
  });

  testWidgets('a second save, on the rival nation, its news read', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final second = await addSecondSave(tester, save);
    expect(second, isNot(save.careerId));
    await tester.runAsync(() async {
      final all = await save.container.read(careerRepositoryProvider).all();
      expect({for (final c in all) c.id}, {save.careerId, second});
      // The second was stamped played more recently, so it lists first.
      expect([for (final c in all) c.id], [second, save.careerId]);
      expect(all.firstWhere((c) => c.id == second).nationId, rivalNation.id);
      expect(
        await save.container.read(unreadMessagesProvider(save.careerId).future),
        0,
      );
      expect(
        await save.container.read(unreadMessagesProvider(second).future),
        0,
      );
    });
  });
}
