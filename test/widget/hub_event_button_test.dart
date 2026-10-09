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

      await tester.tap(buttons.first);
      await tester.pump();
      await tester.tap(buttons.last);
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
}
