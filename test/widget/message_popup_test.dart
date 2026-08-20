import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/messages/message_popup.dart';
import 'package:fnm/features/messages/message_providers.dart';

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
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        // These tests are about what the popup SHOWS, and they file their news
        // by hand. The real generator would file its own on top and change
        // what is on screen; standing it down keeps each test's subject the
        // messages it wrote itself.
        messageServiceProvider.overrideWith(_NoNewsService.new),
      ],
    );
    comp = container.read(competitionRepositoryProvider);
    // A career row for the messages to hang off.
    await container
        .read(careerRepositoryProvider)
        .create(
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

  testWidgets('a run steps through with Next, then marks them read', (
    tester,
  ) async {
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

  testWidgets('news written by the sync pops on this visit, not the next', (
    tester,
  ) async {
    // The whole point of the fix. The popup used to read the repository
    // WITHOUT syncing, on the reasoning that the hub's unread badge syncs as a
    // side effect of building. It does — but the popup runs on the hub's first
    // frame, before that provider has resolved, so a step that had just
    // generated news popped nothing, and the news appeared only on the NEXT
    // visit to the hub. A fake service standing in for the real generator is
    // the honest way to say "the message exists only once sync has run".
    container.dispose();
    db = createTestDatabase();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        messageServiceProvider.overrideWith(_LateNewsService.new),
      ],
    );
    comp = container.read(competitionRepositoryProvider);
    await container
        .read(careerRepositoryProvider)
        .create(
          managerName: 'M',
          nationId: 1,
          rngSeed: 1,
          startDate: DateTime(2026, 9),
        );

    await pumpAndPop(tester);

    expect(find.text('Filed by the sync'), findsOneWidget);
  });

  testWidgets('nothing pops when everything has been read', (tester) async {
    await addMessage('a', 'Old news');
    await comp.markMessagesRead(careerId);
    await pumpAndPop(tester);

    expect(find.text('Old news'), findsNothing);
  });

  testWidgets('a long run is capped, and the rest stay unread for next time', (
    tester,
  ) async {
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

/// A generator that files nothing, for the tests that write their own news.
class _NoNewsService extends MessageService {
  _NoNewsService(super.ref);

  @override
  Future<void> sync(int careerId) async {}
}

/// A message service whose sync is the only thing that ever writes the news —
/// exactly like the real one, and unlike a test that inserts rows by hand.
class _LateNewsService extends MessageService {
  _LateNewsService(this._ownRef) : super(_ownRef);

  final Ref _ownRef;

  @override
  Future<void> sync(int careerId) => _ownRef
      .read(competitionRepositoryProvider)
      .addMessage(
        careerId: careerId,
        dedupKey: 'late',
        category: 'ranking',
        title: 'Filed by the sync',
        body: 'Body',
        year: 2026,
      );
}
