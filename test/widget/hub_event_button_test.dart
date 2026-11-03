import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_event_button.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/shared/widgets/primary_button.dart';

import '../helpers/pump_app.dart';

class _FakeSeason implements SeasonService {
  int calls = 0;
  Completer<void> gate = Completer<void>();

  @override
  Future<void> advance(int careerId) {
    calls++;
    return gate.future;
  }

  int simulated = 0;

  @override
  Future<void> simulateTournament(int careerId) {
    simulated++;
    return gate.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  const event = HubEvent(
    kind: HubEventKind.advance,
    label: 'Play match',
    icon: Icons.play_arrow_rounded,
    subtitle: 'Czechia v Norway',
  );
  final overrides = [nextEventProvider(1).overrideWith((ref) async => event)];

  testWidgets('full button shows label and subtitle and carries the tour key', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(body: HubEventButton(careerId: 1)),
      overrides: overrides,
    );
    await tester.pump();
    expect(find.text('Play match'), findsOneWidget);
    expect(find.text('Czechia v Norway'), findsOneWidget);
    expect(find.byKey(TourKeys.hubAction), findsOneWidget);
  });

  testWidgets('compact button has no subtitle and no tour key', (tester) async {
    await tester.pumpApp(
      const Scaffold(body: HubEventButton(careerId: 1, compact: true)),
      overrides: overrides,
    );
    await tester.pump();
    expect(find.text('Play match'), findsOneWidget);
    expect(find.text('Czechia v Norway'), findsNothing);
    expect(find.byKey(TourKeys.hubAction), findsNothing);
  });

  testWidgets('both on screen at once: no duplicate key, one busy flag', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(
        body: Column(
          children: [
            HubEventButton(careerId: 1, compact: true),
            HubEventButton(careerId: 1),
          ],
        ),
      ),
      overrides: overrides,
    );
    await tester.pump();
    expect(tester.takeException(), isNull);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(Scaffold)),
    );
    container.read(hubActionBusyProvider(1).notifier).state = true;
    await tester.pump();

    final buttons = tester.widgetList<PrimaryButton>(
      find.byType(PrimaryButton),
    );
    expect(buttons, hasLength(2));
    expect(buttons.every((b) => b.isLoading), isTrue);
  });

  Future<_FakeSeason> pumpBoth(WidgetTester tester) async {
    final season = _FakeSeason();
    await tester.pumpApp(
      const Scaffold(
        body: Column(
          children: [
            HubEventButton(careerId: 1, compact: true),
            HubEventButton(careerId: 1),
          ],
        ),
      ),
      overrides: [
        ...overrides,
        seasonServiceProvider.overrideWith((ref) => season),
      ],
    );
    await tester.pump();
    return season;
  }

  bool allLoading(WidgetTester tester, bool value) => tester
      .widgetList<PrimaryButton>(find.byType(PrimaryButton))
      .every((b) => b.isLoading == value);

  testWidgets(
    'a second tap while advancing is ignored; flag resets on success',
    (
      tester,
    ) async {
      final season = await pumpBoth(tester);
      final buttons = find.byType(PrimaryButton);

      // Captured BEFORE the first tap: once busy, the buttons disable
      // themselves, so only a stale closure can reach `_guarded` again.
      final staleTap = tester.widget<PrimaryButton>(buttons.last).onPressed!;

      await tester.tap(buttons.first);
      await tester.pump();
      staleTap();
      await tester.pump();

      expect(season.calls, 1);
      expect(allLoading(tester, true), isTrue);

      season.gate.complete();
      await tester.pump();
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(Scaffold)),
      );
      expect(container.read(hubActionBusyProvider(1)), isFalse);
      expect(allLoading(tester, false), isTrue);
    },
  );

  testWidgets('a failing advance resets the flag and shows a snackbar', (
    tester,
  ) async {
    final season = await pumpBoth(tester);

    await tester.tap(find.byType(PrimaryButton).first);
    await tester.pump();
    expect(allLoading(tester, true), isTrue);

    season.gate.completeError(StateError('boom'));
    await tester.pump();
    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(Scaffold)),
    );
    expect(container.read(hubActionBusyProvider(1)), isFalse);
    expect(allLoading(tester, false), isTrue);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets(
    'a watch event offers "simulate to the final", which runs it in one go',
    (tester) async {
      final season = _FakeSeason();
      const watch = HubEvent(
        kind: HubEventKind.watchTournament,
        label: 'Play the next round',
        icon: Icons.fast_forward_rounded,
      );
      await tester.pumpApp(
        const Scaffold(
          body: Column(
            children: [
              HubEventButton(careerId: 1, compact: true),
              HubEventButton(careerId: 1),
            ],
          ),
        ),
        overrides: [
          nextEventProvider(1).overrideWith((ref) async => watch),
          seasonServiceProvider.overrideWith((ref) => season),
        ],
      );
      await tester.pump();
      expect(find.byKey(HubEventButton.simToFinalKey), findsOneWidget);
      expect(find.byTooltip('Simulate to the final'), findsOneWidget);

      await tester.tap(find.byKey(HubEventButton.simToFinalKey));
      await tester.pump();
      expect(season.simulated, 1);
      expect(season.calls, 0);
      expect(allLoading(tester, true), isTrue);
    },
  );

  testWidgets('no such choice on any other event', (tester) async {
    await tester.pumpApp(
      const Scaffold(body: HubEventButton(careerId: 1)),
      overrides: overrides,
    );
    await tester.pump();
    expect(find.byKey(HubEventButton.simToFinalKey), findsNothing);
  });

  // Owner, 1.0.9: "sometimes a match is skipped entirely and I find the
  // result in the table". After a step of the world the hub works out its
  // next event afresh; until it has, the button still showed the old
  // "Advance", and a tap in that moment ran the skip step that quick-sims
  // the manager's next match. A tap must never act on an event the hub is
  // still recomputing.
  testWidgets('a tap while the next event is being worked out does nothing', (
    tester,
  ) async {
    final season = _FakeSeason()..gate.complete();
    final version = StateProvider<int>((ref) => 0);
    final recomputed = Completer<HubEvent>();
    await tester.pumpApp(
      const Scaffold(body: HubEventButton(careerId: 1)),
      overrides: [
        nextEventProvider(1).overrideWith((ref) async {
          if (ref.watch(version) == 0) return event;
          return recomputed.future;
        }),
        seasonServiceProvider.overrideWith((ref) => season),
      ],
    );
    await tester.pump();
    final staleTap = tester
        .widget<PrimaryButton>(find.byType(PrimaryButton))
        .onPressed!;
    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();
    expect(season.calls, 1);

    // The step is done; the hub is now working out what comes next.
    ProviderScope.containerOf(
      tester.element(find.byType(Scaffold)),
    ).read(version.notifier).state = 1;
    await tester.pump();
    await tester.tap(find.byType(PrimaryButton), warnIfMissed: false);
    staleTap();
    await tester.pump();
    expect(season.calls, 1, reason: 'the match must not be simulated');

    // Its match is next: the button says so, and advances nothing.
    recomputed.complete(
      const HubEvent(
        kind: HubEventKind.match,
        label: 'Play Norway',
        icon: Icons.play_arrow_rounded,
      ),
    );
    await tester.pump();
    expect(find.text('Play Norway'), findsOneWidget);
    expect(season.calls, 1);
  });
}
