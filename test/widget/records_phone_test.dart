import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/records/record_book_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';
import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone record book (1.1.2 redesign, variant A): three headline tiles,
/// the team records card, the record holders, the fiercest rival, and the
/// way out to the legends, the world and head to head at the bottom.
void main() {
  Future<SeededSave> open(
    WidgetTester tester, {
    Size size = const Size(390, 1600),
    Locale locale = const Locale('en'),
  }) async {
    final save = await seedSave(tester, overrides: fakeRecordsOverrides());
    await pumpRoute(
      tester,
      save,
      '${Routes.records}?careerId=${save.careerId}',
      size: size,
      locale: locale,
    );
    return save;
  }

  Finder inTiles(String text) => find.descendant(
    of: find.byKey(const Key('records.statTiles')),
    matching: find.text(text),
  );

  testWidgets('the three tiles: matches, win share, trophies', (tester) async {
    await open(tester);
    final book = fakeRecordBook();
    final t = book.totals;
    expect(inTiles(enL.recordsTileMatches.toUpperCase()), findsOneWidget);
    expect(inTiles('${t.played}'), findsOneWidget);
    expect(inTiles(enL.recordsWdl(t.wins, t.draws, t.losses)), findsOneWidget);
    // 2 of 6 won.
    expect(inTiles(enL.recordsWinSharePercent('33')), findsOneWidget);
    expect(inTiles('${t.goalsFor}–${t.goalsAgainst}'), findsOneWidget);
    final trophies = tester.widget<Text>(inTiles('${book.trophies}'));
    expect(trophies.style?.color, isNot(isNull));
    expect(inTiles(book.latestTrophy!), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the team records include the heaviest defeat', (tester) async {
    await open(tester);
    final book = fakeRecordBook();
    final defeat = book.biggestDefeat!;
    expect(
      find.text(enL.recordsBiggestDefeat.toUpperCase()),
      findsOneWidget,
    );
    expect(
      find.text(
        enL.recordsBiggestWinValue(
          defeat.gf,
          defeat.ga,
          book.nations[defeat.oppId]!.name,
        ),
      ),
      findsOneWidget,
    );
    expect(find.text(book.bestFinish), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('one record holder per board, the leader of each', (
    tester,
  ) async {
    await open(tester);
    final book = fakeRecordBook();
    expect(find.text(enL.recordsRecordHolders.toUpperCase()), findsOneWidget);
    for (final (category, board) in [
      (enL.playerStatCaps, book.mostCaps),
      (enL.playerStatGoals, book.topScorers),
      (enL.playerStatAssists, book.topAssists),
      (enL.playerStatCleanSheets, book.topCleanSheets),
    ]) {
      expect(find.text(category.toUpperCase()), findsOneWidget);
      expect(find.text(board.first.name), findsOneWidget);
    }
    // The full boards live behind the rows: the runner-up is not on the page.
    expect(find.text(book.mostCaps[1].name), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a record holder opens his whole board, and a man on it his '
      'page', (tester) async {
    await open(tester);
    final book = fakeRecordBook();
    await tester.tap(find.text(enL.playerStatCaps.toUpperCase()));
    await settle(tester);
    expect(find.text(enL.recordsMostCaps), findsOneWidget);
    for (final r in book.mostCaps) {
      expect(find.text(r.name), findsWidgets);
    }
    final second = book.mostCaps[1];
    await tester.tap(find.text(second.name));
    await settle(tester);
    expect(find.byType(PlayerDetailScreen), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the rival card, then the way out at the bottom', (
    tester,
  ) async {
    await open(tester);
    final r = fakeRivalry();
    expect(find.text(r.rival.name), findsOneWidget);
    expect(
      find.text(enL.recordsMeetingsWdl(r.played, r.wins, r.draws, r.losses)),
      findsOneWidget,
    );
    expect(find.text('${r.goalsFor}–${r.goalsAgainst}'), findsOneWidget);
    final rival = tester.getRect(find.text(r.rival.name));
    final legends = tester.getRect(find.text(enL.recordsLegends));
    expect(legends.top, greaterThan(rival.bottom));
    expect(find.text(enL.recordsAllTimeWorld), findsOneWidget);
    expect(find.text(enL.recordsHeadToHead), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  for (final lang in const ['en', 'cs', 'de', 'hu']) {
    testWidgets('nothing is cut on a 360 phone in $lang', (tester) async {
      await open(tester, size: const Size(360, 1600), locale: Locale(lang));
      expect(tester.takeException(), isNull);
      expect(find.byType(RecordBookScreen), findsOneWidget);
      expectNothingCut(tester, 'the record book');
      final l = lookupAppLocalizations(Locale(lang));
      expect(find.byType(ActiveBadge), findsWidgets);
      expect(find.text(l.recordsRecordHolders.toUpperCase()), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
