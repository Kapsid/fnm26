import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/squad/camp_scandal.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/squad/camp_scandal_providers.dart';
import 'package:fnm/features/squad/camp_scandal_screen.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart' show settle;
import 'capture.dart';
import 'driver.dart';

/// A playtest report (1.1.1, a Copa run), played through the real hub on a
/// phone rather than through the services alone.
void main() {
  const colombia = 60;
  final l = lookupAppLocalizations(const Locale('en'));

  /// Runs [body] in real time, and fails the test if it throws (runAsync
  /// alone only parks the error for takeException).
  Future<T> real<T>(WidgetTester tester, Future<T> Function() body) async {
    Object? error;
    StackTrace? trace;
    late T value;
    await tester.runAsync(() async {
      try {
        value = await body();
      } on Object catch (e, st) {
        error = e;
        trace = st;
      }
    });
    if (error != null) Error.throwWithStackTrace(error!, trace!);
    return value;
  }

  /// Steps [d] (in real time) until [stop] says the hub's event is the one
  /// wanted, then clears what would pop over the hub (the news, the
  /// achievements).
  Future<void> driveTo(
    WidgetTester tester,
    StoryDriver d,
    Future<bool> Function(HubEvent e) stop,
  ) async {
    await real(tester, () async {
      for (var i = 0; i < 2000; i++) {
        final e = await d.nextEvent();
        if (await stop(e)) break;
        expect(e.kind, isNot(HubEventKind.cycleRollover), reason: 'missed');
        await d.step();
      }
      await d.c.read(messageInboxProvider(d.careerId).future);
      await d.c
          .read(competitionRepositoryProvider)
          .markMessagesRead(d.careerId);
      d.c.read(pendingAchievementUnlocksProvider(d.careerId).notifier).state =
          const [];
      d.c
        ..invalidate(messageInboxProvider(d.careerId))
        ..invalidate(unreadMessagesProvider(d.careerId));
    });
  }

  // "The scandal is broken: I can continue past it with the button but I
  // cannot decide anything."
  //
  // The hub works its scandal event out fresh, but the decision screen read
  // the cached pendingScandalProvider, which the Y feed (the hub's badge)
  // keeps alive. Read before the squad was named, it held "no scandal" for
  // good: the hub offered the story and the screen showed only its way out,
  // which settled the story as kept.
  testWidgets(
    'a scandal breaking with the hub on screen can be answered',
    (tester) async {
      await tester.runAsync(loadMaterialIcons);
      setPhone(tester);
      final c = storyContainer();
      // Disposed by hand: Riverpod 2.6 throws "Future already completed"
      // disposing a future provider the decision screen started in the
      // test's fake zone. The app never disposes its container.
      addTearDown(() {
        try {
          c.dispose();
          // The lint is right in general; here the error is Riverpod's own.
          // ignore: avoid_catching_errors
        } on StateError catch (_) {}
      });
      late StoryDriver d;
      await real(tester, () async {
        d = await StoryDriver.start(c, 2, nationId: colombia);
      });
      // The call-up for the Copa, whose camp has this save's scandal.
      await driveTo(
        tester,
        d,
        (e) async =>
            e.kind == HubEventKind.callUp &&
            !(await c
                    .read(careerRepositoryProvider)
                    .byId(
                      d.careerId,
                    ))!
                .inGameDate
                .isBefore(DateTime(2028, 5, 1)),
      );
      // The manager is on the hub before the squad is named: its Y badge
      // counts the feed, which holds the scandal read as it stood then (as
      // the hub's badge does, held here directly).
      late ProviderSubscription<Future<int>> y;
      await real(tester, () async {
        y = c.listen(yUnreadCountProvider(d.careerId).future, (_, _) {});
        await y.read();
        // The squad is named (as the call-up screen saves it), and on to the
        // scandal.
        await d.step();
        for (var i = 0; i < 20; i++) {
          final e = await d.nextEvent();
          if (e.kind == HubEventKind.scandal) return;
          expect(e.kind, isNot(HubEventKind.match), reason: 'no scandal');
          await d.step();
        }
        fail('no scandal');
      });
      // The hub's button opens the decision screen.
      await pumpApp(
        tester,
        c,
        '${Routes.campScandal}?careerId=${d.careerId}',
      );
      await settle(tester);
      y.close();
      // Both answers are on screen, not just the way out.
      expect(find.byType(CampScandalScreen), findsOneWidget);
      expect(find.byKey(CampScandalScreen.keepKey), findsOneWidget);
      expect(find.byKey(CampScandalScreen.sendHomeKey), findsOneWidget);
      expect(find.text(l.federationContinue), findsNothing);

      await tester.tap(find.byKey(CampScandalScreen.sendHomeKey));
      await settle(tester, maxWait: const Duration(seconds: 30));
      final records = await real(
        tester,
        () => c.read(campScandalsProvider(d.careerId).future),
      );
      expect(records.single.choice, ScandalChoice.sentHome);
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
      // Let the reads the last screen started finish before the container
      // goes.
      await settle(tester, rounds: 60);
    },
    timeout: const Timeout(Duration(minutes: 10)),
  );
}
