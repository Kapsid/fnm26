import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/achievements/achievements.dart';
import 'package:fnm/features/achievements/achievement_popup.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart';

Future<void> _open(WidgetTester tester, {required bool compact}) async {
  tester.view.physicalSize = kTabletSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  var closed = false;
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () async {
                await showAchievementsUnlocked(
                  context,
                  AchievementCatalog.all.take(2).toList(),
                  compact: compact,
                );
                closed = true;
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  expect(find.text(enL.achievementsUnlockedBanner(2)), findsOneWidget);
  for (final d in AchievementCatalog.all.take(2)) {
    expect(find.text(achievementText(enL, d).title), findsOneWidget);
  }
  // The Dialog fills the screen; its card is the Material inside it.
  final card = tester.getRect(
    find
        .descendant(of: find.byType(Dialog), matching: find.byType(Material))
        .first,
  );
  if (compact) {
    // A small card low on the right, not a dialog across the screen.
    expect(card.width, inInclusiveRange(360, 420));
    expect(card.height, lessThan(kTabletSize.height / 2));
    expect(card.center.dx, greaterThan(kTabletSize.width / 2));
    expect(card.center.dy, greaterThan(kTabletSize.height / 2));
  } else {
    expect(card.width, greaterThan(420));
  }
  await tester.tap(find.text(enL.achievementsNice));
  await tester.pumpAndSettle();
  expect(find.byType(Dialog), findsNothing);
  expect(closed, isTrue);
}

void main() {
  testWidgets(
    'the tablet unlocked card is compact and closes on Nice',
    (
      tester,
    ) => _open(tester, compact: true),
  );

  testWidgets(
    'without compact it is the dialog as before',
    (tester) => _open(tester, compact: false),
  );
}
