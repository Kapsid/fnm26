import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/squad/camp_scandal.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/squad/camp_scandal_providers.dart';
import 'package:fnm/features/squad/camp_scandal_screen.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

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

  /// Runs [body] in the test's own zone, letting real time pass and frames
  /// pump until it is done: once a screen has been up, the save may still be
  /// finishing work that screen started on the test's fake clock, and a read
  /// in real time alone would queue behind it for ever.
  Future<T> pumped<T>(WidgetTester tester, Future<T> Function() body) async {
    late T value;
    Object? error;
    StackTrace? trace;
    var done = false;
    unawaited(
      body().then(
        (v) {
          value = v;
          done = true;
        },
        onError: (Object e, StackTrace st) {
          error = e;
          trace = st;
          done = true;
        },
      ),
    );
    for (var i = 0; !done; i++) {
      if (i > 60000) fail('pumped: never finished');
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 5)),
      );
      await tester.pump(const Duration(milliseconds: 5));
    }
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

  /// A story container, disposed by hand: Riverpod 2.6 throws "Future already
  /// completed" disposing a future provider a screen started in the test's
  /// fake zone. The app never disposes its container.
  ProviderContainer container() {
    final c = storyContainer();
    addTearDown(() {
      try {
        c.dispose();
        // The lint is right in general; here the error is Riverpod's own.
        // ignore: avoid_catching_errors
      } on StateError catch (_) {}
    });
    return c;
  }

  /// The scandal as the hub reads it: fresh, never through a cache.
  Future<PendingScandal?> fresh(
    WidgetTester tester,
    ProviderContainer c,
    int careerId,
  ) => pumped(tester, () => pendingScandal(c.read(_refProvider), careerId));

  /// The scandal of the Colombia save's Copa camp, broken and offered by the
  /// hub.
  Future<({StoryDriver d, PendingScandal scandal})> reachScandal(
    WidgetTester tester,
    ProviderContainer c,
  ) async {
    late StoryDriver d;
    await real(tester, () async {
      d = await StoryDriver.start(c, 2, nationId: colombia);
    });
    await driveTo(tester, d, (e) async => e.kind == HubEventKind.scandal);
    final scandal = await fresh(tester, c, d.careerId);
    expect(scandal, isNotNull);
    return (d: d, scandal: scandal!);
  }

  /// Lets go of every screen, so the save can be read in real time again (a
  /// provider a mounted screen holds waits on the test's fake clock).
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  }

  /// Names a new squad through the call-up screen, as the manager does after
  /// the story broke: the previous squad restored, [out] unticked, [into]
  /// ticked (both optional), confirmed.
  Future<void> renameSquad(
    WidgetTester tester,
    ProviderContainer c,
    int careerId, {
    Player? out,
    Player? into,
  }) async {
    await pumpApp(tester, c, '${Routes.callUps}?careerId=$careerId');
    await settle(tester);
    await tester.tap(find.text(l.tacticsQuickPrevious));
    await settle(tester);
    Future<void> toggle(Player p) async {
      await tester.tap(
        find.byType(AppTabSegment).at(p.position.category.index),
      );
      await settle(tester);
      final row = find.widgetWithText(ListTile, p.name);
      // Into the middle of the list: neither under the header nor under
      // the confirm bar.
      Scrollable.ensureVisible(tester.element(row), alignment: 0.5);
      await settle(tester);
      await tester.tap(row);
      await settle(tester);
    }

    if (out != null) await toggle(out);
    if (into != null) await toggle(into);
    await tester.tap(find.text(l.tacticsConfirmSquad));
    await settle(tester, maxWait: const Duration(seconds: 30));
    await unmount(tester);
  }

  /// The decision screen, opened as the hub's button opens it: both answers
  /// on screen, never only the way out.
  Future<void> expectDecision(
    WidgetTester tester,
    ProviderContainer c,
    int careerId,
  ) async {
    await pumpApp(tester, c, '${Routes.campScandal}?careerId=$careerId');
    await settle(tester);
    expect(find.byKey(CampScandalScreen.keepKey), findsOneWidget);
    expect(find.byKey(CampScandalScreen.sendHomeKey), findsOneWidget);
    expect(find.text(l.federationContinue), findsNothing);
  }

  /// The squad's pool and call-ups as the save holds them.
  Future<SquadData> squadOf(
    WidgetTester tester,
    ProviderContainer c,
    int careerId,
  ) => pumped(tester, () async {
    final sub = c.listen(squadDataProvider(careerId).future, (_, _) {});
    try {
      return (await sub.read())!;
    } finally {
      sub.close();
    }
  });

  /// The stored call-ups, straight from the save.
  Future<Set<int>> callUpsOf(
    WidgetTester tester,
    ProviderContainer c,
    int careerId,
  ) => pumped(tester, () => c.read(squadRepositoryProvider).callUps(careerId));

  Future<List<CampScandalRecord>> records(
    WidgetTester tester,
    ProviderContainer c,
    int careerId,
  ) => pumped(tester, () async {
    c.invalidate(campScandalsProvider(careerId));
    final sub = c.listen(campScandalsProvider(careerId).future, (_, _) {});
    try {
      return await sub.read();
    } finally {
      sub.close();
    }
  });

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
      final c = container();
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

  // The 1.0.8 report: "changing the call-ups broke the whole game". The roll
  // read the squad as it stood, so every new squad named a new man, and the
  // screen the hub sent him to could come up empty, round in a loop. The
  // story is pinned to its man once it breaks (the scandalRoll marker), and
  // dropping him is sending him home.
  group('the call-ups changed after the story broke', () {
    testWidgets(
      'another man swapped: the story stays on its man, both answers shown',
      (tester) async {
        await tester.runAsync(loadMaterialIcons);
        setPhone(tester);
        final c = container();
        final (:d, :scandal) = await reachScandal(tester, c);
        final squad = await squadOf(tester, c, d.careerId);
        bool fit(Player p) =>
            p.age >= 18 && (squad.absences[p.id]?.isAvailable ?? true);
        bool outside(Player q) => !squad.callUps.contains(q.id) && fit(q);
        // Somebody else in the squad out, a man of his line from outside in.
        final out = squad.pool.firstWhere(
          (p) =>
              squad.callUps.contains(p.id) &&
              p.id != scandal.playerId &&
              fit(p) &&
              squad.pool.any(
                (q) => outside(q) && q.position.category == p.position.category,
              ),
        );
        final into = squad.pool.firstWhere(
          (q) => outside(q) && q.position.category == out.position.category,
        );
        await renameSquad(tester, c, d.careerId, out: out, into: into);

        final after = await callUpsOf(tester, c, d.careerId);
        expect(after, contains(into.id), reason: 'the swap was saved');
        expect(after, isNot(contains(out.id)));
        expect(after, contains(scandal.playerId));
        // Still his story, still waiting for an answer, still offered.
        expect(
          await fresh(tester, c, d.careerId),
          scandal,
          reason: 'the story moved to somebody else',
        );
        expect((await pumped(tester, d.nextEvent)).kind, HubEventKind.scandal);
        await expectDecision(tester, c, d.careerId);

        await tester.tap(find.byKey(CampScandalScreen.keepKey));
        await settle(tester, maxWait: const Duration(seconds: 30));
        await unmount(tester);
        final answered = await records(tester, c, d.careerId);
        expect(answered.single.playerId, scandal.playerId);
        expect(answered.single.choice, ScandalChoice.kept);
        expect(
          (await pumped(tester, d.nextEvent)).kind,
          isNot(HubEventKind.scandal),
        );
        await settle(tester, rounds: 60);
      },
      timeout: const Timeout(Duration(minutes: 10)),
    );

    testWidgets(
      'its man dropped: he is sent home, and the hub moves on',
      (tester) async {
        await tester.runAsync(loadMaterialIcons);
        setPhone(tester);
        final c = container();
        final (:d, :scandal) = await reachScandal(tester, c);
        final squad = await squadOf(tester, c, d.careerId);
        final him = squad.pool.firstWhere((p) => p.id == scandal.playerId);
        await renameSquad(tester, c, d.careerId, out: him);

        final after = await callUpsOf(tester, c, d.careerId);
        expect(after, isNot(contains(him.id)));
        // Answered by the new squad: sent home.
        final answered = await records(tester, c, d.careerId);
        expect(answered.single.playerId, him.id);
        expect(answered.single.choice, ScandalChoice.sentHome);
        expect(await fresh(tester, c, d.careerId), isNull);
        // The hub does not offer it again: its button leads on.
        final next = await pumped(tester, d.nextEvent);
        expect(next.kind, isNot(HubEventKind.scandal));
        await pumpApp(tester, c, '${Routes.hub}?careerId=${d.careerId}');
        await settle(tester);
        expect(find.text(l.hubEventScandal(him.name)), findsNothing);
        expect(find.text(next.label), findsWidgets);
        await unmount(tester);
        await settle(tester, rounds: 60);
      },
      timeout: const Timeout(Duration(minutes: 10)),
    );
  });

  // After the answer the cycle plays on: the window's matches are reached and
  // played, and no second story breaks in it.
  testWidgets(
    'answered: the save plays on, and the story does not come back',
    (tester) async {
      await tester.runAsync(loadMaterialIcons);
      setPhone(tester);
      final c = container();
      final (:d, :scandal) = await reachScandal(tester, c);
      await expectDecision(tester, c, d.careerId);
      await tester.tap(find.byKey(CampScandalScreen.keepKey));
      await settle(tester, maxWait: const Duration(seconds: 30));
      // Back on the hub, which no longer offers the story.
      expect(find.text(l.hubEventScandal(scandal.playerName)), findsNothing);
      await unmount(tester);

      // On through the window (the Copa camp and its matches) and a month
      // past it: every event is reached, and the story never comes back.
      final run = await pumped(tester, () async {
        final repo = c.read(careerRepositoryProvider);
        final until = scandal.window.add(const Duration(days: 45));
        final kinds = <HubEventKind>[];
        for (var i = 0; i < 400; i++) {
          if ((await repo.byId(d.careerId))!.inGameDate.isAfter(until)) {
            return (kinds: kinds, through: true);
          }
          final e = await d.nextEvent();
          kinds.add(e.kind);
          if (e.kind == HubEventKind.scandal ||
              e.kind == HubEventKind.cycleRollover) {
            break;
          }
          await d.step();
        }
        return (kinds: kinds, through: false);
      });
      expect(run.kinds, isNot(contains(HubEventKind.scandal)));
      expect(run.kinds, contains(HubEventKind.match), reason: 'no match');
      expect(run.through, isTrue, reason: 'the save stopped moving');
      final answered = await records(tester, c, d.careerId);
      expect(answered.single.playerId, scandal.playerId);
      expect(answered.single.choice, ScandalChoice.kept);
      await settle(tester, rounds: 60);
    },
    timeout: const Timeout(Duration(minutes: 15)),
  );
}

/// A plain [Ref] on the test's container, for the functions the hub calls
/// with its own (`pendingScandal`).
final Provider<Ref> _refProvider = Provider((ref) => ref);
