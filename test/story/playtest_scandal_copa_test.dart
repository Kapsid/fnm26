import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/squad/camp_scandal.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_event_button.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/squad/camp_scandal_providers.dart';
import 'package:fnm/features/squad/camp_scandal_screen.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart' show settle;
import 'capture.dart';
import 'driver.dart';

/// Two playtest reports (1.1.1, a Copa run), played through the real hub on a
/// phone rather than through the services alone.
void main() {
  const colombia = 60;
  const ecuador = 61;
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

  Future<void> tapHubAction(WidgetTester tester) async {
    await tester.tap(find.byKey(TourKeys.hubAction));
    // A watched round's popup keeps the hub's button busy under it: a
    // spinner there is expected.
    await settle(
      tester,
      maxWait: const Duration(seconds: 60),
      allowSpinner: true,
    );
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

  // "The final (Copa) was not shown to me after I was knocked out."
  testWidgets(
    'knocked out of the Copa: its final is shown when stepped',
    (tester) async {
      await tester.runAsync(loadMaterialIcons);
      setPhone(tester);
      final c = storyContainer();
      addTearDown(c.dispose);
      late StoryDriver d;
      await real(tester, () async {
        d = await StoryDriver.start(c, 1, nationId: ecuador);
      });
      final comp = c.read(competitionRepositoryProvider);
      Future<List<Fixture>> round(String r) => comp.fixturesByRound(
        d.careerId,
        r,
        kind: CompetitionKind.continentalFinals,
        confederation: Confederation.southAmerica,
      );
      late Fixture last;
      // The hub offers the next Copa round to watch, and that round is the
      // final: everything else of the cup is played, the manager is out.
      await driveTo(tester, d, (e) async {
        if (e.kind != HubEventKind.watchTournament) return false;
        final finals = await round('CFINAL');
        if (finals.isEmpty || finals.single.hasResult) return false;
        last = finals.single;
        return (await round('CSF')).every((f) => f.hasResult);
      });
      expect(
        [last.homeNationId, last.awayNationId],
        isNot(contains(ecuador)),
        reason: 'the manager is only watching',
      );

      await pumpApp(tester, c, '${Routes.hub}?careerId=${d.careerId}');
      await settle(tester);
      await tapHubAction(tester);

      // The final's result, in the round popup over the hub.
      expect(find.text(l.hubFinal.toUpperCase()), findsOneWidget);
      expect(
        find.textContaining(nationById[last.homeNationId]!.code),
        findsWidgets,
      );
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
      // Let the reads the last screen started finish before the container
      // goes.
      await settle(tester, rounds: 60);
    },
    timeout: const Timeout(Duration(minutes: 10)),
  );

  // The same report, the other way to follow the cup: "Simulate to the
  // final" ("Simulovat až do finále") from the semi-finals played the final
  // too and went straight on. It now stops with the final still to watch.
  testWidgets(
    'knocked out of the Copa: simulate to the final leaves the final',
    (tester) async {
      await tester.runAsync(loadMaterialIcons);
      setPhone(tester);
      final c = storyContainer();
      addTearDown(c.dispose);
      late StoryDriver d;
      await real(tester, () async {
        d = await StoryDriver.start(c, 1, nationId: ecuador);
      });
      final comp = c.read(competitionRepositoryProvider);
      Future<List<Fixture>> round(String r) => comp.fixturesByRound(
        d.careerId,
        r,
        kind: CompetitionKind.continentalFinals,
        confederation: Confederation.southAmerica,
      );
      // Out in the quarter-finals; the semi-finals are next to watch.
      await driveTo(tester, d, (e) async {
        if (e.kind != HubEventKind.watchTournament) return false;
        final semis = await round('CSF');
        return semis.isNotEmpty && semis.every((f) => !f.hasResult);
      });

      await pumpApp(tester, c, '${Routes.hub}?careerId=${d.careerId}');
      await settle(tester);
      await tester.tap(find.byKey(HubEventButton.simToFinalKey));
      await settle(
        tester,
        maxWait: const Duration(seconds: 60),
        allowSpinner: true,
      );

      // The semi-finals are shown; the final is drawn and still to watch.
      expect(find.text(l.finishSemiFinals.toUpperCase()), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
      final semis = await real(tester, () => round('CSF'));
      expect(semis.every((f) => f.hasResult), isTrue);
      final finals = await real(tester, () => round('CFINAL'));
      expect(finals.single.hasResult, isFalse, reason: 'left to watch');
    },
    timeout: const Timeout(Duration(minutes: 10)),
  );
}
