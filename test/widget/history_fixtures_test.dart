import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';

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

  testWidgets('a second save, on the rival nation', (tester) async {
    final save = await seedSave(tester);
    final second = await addSecondSave(tester, save);
    expect(second, isNot(save.careerId));
    await tester.runAsync(() async {
      final all = await save.container.read(careerRepositoryProvider).all();
      expect({for (final c in all) c.id}, {save.careerId, second});
      expect(all.firstWhere((c) => c.id == second).nationId, rivalNation.id);
    });
  });
}
