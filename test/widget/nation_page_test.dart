import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';

import '../helpers/seeded_save.dart';

/// The nation with the longest name: the hardest for the header to fit.
Nation _longest(SeededSave save) =>
    save.nations.reduce((a, b) => b.name.length > a.name.length ? b : a);

Future<void> _open(
  WidgetTester tester,
  SeededSave save,
  int nationId,
  Size size,
) => pumpRoute(
  tester,
  save,
  '${Routes.nationVitrine}?careerId=${save.careerId}&nationId=$nationId',
  size: size,
);

/// Opens every tab in turn, settling each, and checks nothing overflows.
Future<void> _visitTabs(WidgetTester tester) async {
  for (final key in NationVitrineScreen.tabKeys) {
    await tester.tap(find.byKey(key));
    await settle(tester, rounds: 10);
    expect(tester.takeException(), isNull, reason: '$key');
  }
}

void main() {
  for (final width in [360.0, 390.0]) {
    final size = Size(width, 800);
    testWidgets('phone $width: every tab fits, own nation', (tester) async {
      final save = await seedSave(tester);
      await _open(tester, save, save.nationId, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(NationVitrineScreen.headerKey), findsOneWidget);
      expect(find.byKey(NationVitrineScreen.collapsedKey), findsNothing);
      await _visitTabs(tester);
    });

    testWidgets('phone $width: every tab fits, the longest name', (
      tester,
    ) async {
      final save = await seedSave(tester);
      await _open(tester, save, _longest(save).id, size);
      expect(tester.takeException(), isNull);
      await _visitTabs(tester);
    });
  }

  testWidgets('each tab shows its own blocks', (tester) async {
    final save = await seedSave(tester);
    final other = save.nations.firstWhere((n) => n.id != save.nationId);
    await _open(tester, save, other.id, kPhoneSize);
    expect(find.byKey(NationVitrineScreen.nextKey), findsOneWidget);
    expect(find.byKey(NationVitrineScreen.xiKey), findsNothing);

    await tester.tap(find.byKey(NationVitrineScreen.tabKeys[1]));
    await settle(tester, rounds: 10);
    expect(find.byKey(NationVitrineScreen.nextKey), findsNothing);
    expect(find.byKey(NationVitrineScreen.xiKey), findsOneWidget);

    await tester.tap(find.byKey(NationVitrineScreen.tabKeys[2]));
    await settle(tester, rounds: 10);
    expect(find.byKey(NationVitrineScreen.upcomingKey), findsOneWidget);
    // Never met the manager's side: no record to show.
    expect(find.byKey(NationVitrineScreen.againstYouKey), findsNothing);

    await tester.tap(find.byKey(NationVitrineScreen.tabKeys[3]));
    await settle(tester, rounds: 10);
    expect(find.text(enL.nationsTopScorers), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(NationVitrineScreen.hostingKey),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(NationVitrineScreen.hostingKey), findsOneWidget);

    await tester.tap(find.byKey(NationVitrineScreen.tabKeys[4]));
    await settle(tester, rounds: 10);
    expect(find.byKey(NationVitrineScreen.stadiumListKey), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the header folds into one row as the page scrolls', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await _open(tester, save, save.nationId, kPhoneSize);
    // The Squad tab: the pitch makes it tall enough to scroll.
    await tester.tap(find.byKey(NationVitrineScreen.tabKeys[1]));
    await settle(tester, rounds: 10);
    expect(find.byKey(NationVitrineScreen.headerKey), findsOneWidget);
    expect(find.byKey(NationVitrineScreen.collapsedKey), findsNothing);

    await tester.drag(
      find.byKey(NationVitrineScreen.xiKey),
      const Offset(0, -600),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(NationVitrineScreen.headerKey), findsNothing);
    expect(find.byKey(NationVitrineScreen.collapsedKey), findsOneWidget);
    // The tabs stay pinned under the folded row.
    final bar = tester.getRect(find.byKey(NationVitrineScreen.collapsedKey));
    final tab = tester.getRect(find.byKey(NationVitrineScreen.tabKeys[0]));
    expect(tab.top, greaterThanOrEqualTo(bar.bottom - 1));
    expect(tester.takeException(), isNull);

    await tester.drag(
      find.byKey(NationVitrineScreen.tabKeys[0]),
      const Offset(0, 1200),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(NationVitrineScreen.headerKey), findsOneWidget);
    expect(find.byKey(NationVitrineScreen.collapsedKey), findsNothing);
  });
}
