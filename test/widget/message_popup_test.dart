import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/messages/message_popup.dart';

import '../helpers/test_database.dart';

/// News should arrive over the screen, not only land in the inbox to be found.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late CompetitionRepository comp;
  const careerId = 1;

  setUp(() async {
    db = createTestDatabase();
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    comp = container.read(competitionRepositoryProvider);
    // A career row for the messages to hang off.
    await container.read(careerRepositoryProvider).create(
          managerName: 'M',
          nationId: 1,
          rngSeed: 1,
          startDate: DateTime(2026, 9),
        );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<void> addMessage(String key, String title) => comp.addMessage(
        careerId: careerId,
        dedupKey: key,
        category: 'ranking',
        title: title,
        body: 'Body of $title',
        year: 2026,
      );

  /// Pumps a host widget that runs the popups against the real container.
  Future<void> pumpAndPop(WidgetTester tester) async {
    late WidgetRef capturedRef;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Consumer(
            builder: (context, ref, _) {
              capturedRef = ref;
              return const Scaffold(body: Text('host'));
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    unawaited(
      showUnreadMessagePopups(
        tester.element(find.text('host')),
        capturedRef,
        careerId,
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('an unread message pops up over the screen', (tester) async {
    await addMessage('a', 'World ranking · #7');
    await pumpAndPop(tester);

    expect(find.text('World ranking · #7'), findsOneWidget);
    expect(find.text('Body of World ranking · #7'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
  });

  testWidgets('a run steps through with Next, then marks them read',
      (tester) async {
    await addMessage('a', 'First');
    await addMessage('b', 'Second');
    await pumpAndPop(tester);

    // Oldest first: the order the events happened.
    expect(find.text('First'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Second'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(await comp.unreadMessageCount(careerId), 0);
  });

  testWidgets('nothing pops when everything has been read', (tester) async {
    await addMessage('a', 'Old news');
    await comp.markMessagesRead(careerId);
    await pumpAndPop(tester);

    expect(find.text('Old news'), findsNothing);
  });

  testWidgets('a long run is capped, and the rest stay unread for next time',
      (tester) async {
    for (var i = 0; i < kMaxMessagePopups + 2; i++) {
      await addMessage('m$i', 'News $i');
    }
    await pumpAndPop(tester);

    for (var i = 0; i < kMaxMessagePopups; i++) {
      expect(find.text('News $i'), findsOneWidget, reason: 'popup $i');
      await tester.tap(find.text(i == kMaxMessagePopups - 1 ? 'Done' : 'Next'));
      await tester.pumpAndSettle();
    }

    // Only the shown ones were marked read — the overflow waits in the inbox.
    expect(await comp.unreadMessageCount(careerId), 2);
  });
}
