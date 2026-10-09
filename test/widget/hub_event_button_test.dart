import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_event_button.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/shared/widgets/primary_button.dart';

import '../helpers/pump_app.dart';

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
}
