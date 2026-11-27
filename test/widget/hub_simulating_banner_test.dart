import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/hub/hub_event_button.dart';
import 'package:fnm/features/hub/hub_sim_banner.dart';

import '../helpers/pump_app.dart';

/// The hub's "Simulating matchday…" banner: up once a step has run past the
/// delay, never for a quick one.
void main() {
  const careerId = 1;

  Future<ProviderContainer> pumpOverlay(WidgetTester tester) async {
    await tester.pumpApp(
      const Scaffold(
        body: HubSimulatingOverlay(
          careerId: careerId,
          child: SizedBox.expand(),
        ),
      ),
    );
    return ProviderScope.containerOf(
      tester.element(find.byType(HubSimulatingOverlay)),
    );
  }

  final banner = find.byKey(HubSimulatingOverlay.bannerKey);

  testWidgets('a slow step shows the banner, and it goes when the step ends', (
    tester,
  ) async {
    final c = await pumpOverlay(tester);
    c.read(hubActionBusyProvider(careerId).notifier).state = true;
    await tester.pump(const Duration(milliseconds: 100));
    expect(banner, findsNothing);
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump(const Duration(milliseconds: 200));
    expect(banner, findsOneWidget);
    expect(find.text('Simulating matchday…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    c.read(hubActionBusyProvider(careerId).notifier).state = false;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(banner, findsNothing);
  });

  testWidgets('a quick step never shows it', (tester) async {
    final c = await pumpOverlay(tester);
    c.read(hubActionBusyProvider(careerId).notifier).state = true;
    await tester.pump(const Duration(milliseconds: 150));
    c.read(hubActionBusyProvider(careerId).notifier).state = false;
    await tester.pump();
    // Well past the delay: the timer the step started was called off.
    await tester.pump(const Duration(seconds: 1));
    expect(banner, findsNothing);
    expect(find.text('Simulating matchday…'), findsNothing);
  });

  testWidgets('the banner lets taps through to the hub', (tester) async {
    var taps = 0;
    await tester.pumpApp(
      Scaffold(
        body: HubSimulatingOverlay(
          careerId: careerId,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextButton(
                onPressed: () => taps++,
                child: const Text('under'),
              ),
            ),
          ),
        ),
      ),
    );
    final c = ProviderScope.containerOf(
      tester.element(find.byType(HubSimulatingOverlay)),
    );
    c.read(hubActionBusyProvider(careerId).notifier).state = true;
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 200));
    expect(banner, findsOneWidget);
    await tester.tap(find.text('under'), warnIfMissed: false);
    expect(taps, 1);
    c.read(hubActionBusyProvider(careerId).notifier).state = false;
    await tester.pump(const Duration(milliseconds: 300));
  });
}
