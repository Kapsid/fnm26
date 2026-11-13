import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/ranking/world_ranking_screen.dart';

import '../helpers/seeded_save.dart';

/// The phone ranking (1.1.2 variant A): the manager's nation on a card above
/// the table, the table one card of dense rows with his row tagged, and the
/// full chart one tap away on the card.
void main() {
  testWidgets('the team card names the place and opens the full chart', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.ranking}?careerId=${save.careerId}',
    );
    final card = find.byKey(WorldRankingScreen.teamCardKey);
    expect(card, findsOneWidget);
    final mine = tester
        .widgetList<RankRow>(find.byType(RankRow))
        .firstWhere((r) => r.isPlayer);
    expect(
      find.descendant(
        of: card,
        matching: find.text('#${mine.rank} ${mine.nation.name}'),
      ),
      findsOneWidget,
    );
    // His row in the table carries the tag; the movement caption says what
    // the arrows measure from.
    expect(find.text(enL.rankingYourTeam), findsOneWidget);
    expect(
      find.descendant(
        of: card,
        matching: find.textContaining(
          RegExp(
            '${enL.rankingSinceCycleStartShort}|${enL.rankingSinceWcDrawShort}',
            caseSensitive: false,
          ),
        ),
      ),
      findsOneWidget,
    );
    // The old separate chart card is gone from the page.
    expect(find.text(enL.rankingYourRankingOverTime), findsNothing);

    await tester.tap(card);
    await settle(tester);
    expect(find.byKey(WorldRankingScreen.historySheetKey), findsOneWidget);
    expect(find.byType(RankMovementHeader), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("the table opens centred on the manager's row", (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.ranking}?careerId=${save.careerId}',
    );
    final mine = find.byWidgetPredicate((w) => w is RankRow && w.isPlayer);
    expect(mine, findsOneWidget);
    final list = tester.getRect(find.byType(ListView).last);
    final row = tester.getRect(mine);
    expect(row.top, greaterThanOrEqualTo(list.top));
    expect(row.bottom, lessThanOrEqualTo(list.bottom));
    await tester.pumpWidget(const SizedBox());
  });
}
