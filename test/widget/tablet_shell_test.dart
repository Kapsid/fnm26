import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/shell/tablet_sidebar.dart';
import 'package:fnm/features/shell/tablet_top_bar.dart';

import '../helpers/pump_app.dart';

void main() {
  final overrides = [
    hubDataProvider(1).overrideWith((ref) async => null),
    unreadMessagesProvider(1).overrideWith((ref) async => 0),
    nextEventProvider(1).overrideWith(
      (ref) async => const HubEvent(
        kind: HubEventKind.advance,
        label: 'Continue',
        icon: Icons.play_arrow_rounded,
      ),
    ),
  ];
  const screen = Scaffold(body: Text('the screen'));

  Future<void> pump(WidgetTester tester, Size size, String location) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      TabletShell(location: Uri.parse(location), child: screen),
      overrides: overrides,
    );
    await tester.pump();
  }

  testWidgets('on a tablet the screen sits inside sidebar and top bar', (
    tester,
  ) async {
    await pump(tester, const Size(1194, 834), '/hub?careerId=1');
    expect(find.byType(TabletSidebar), findsOneWidget);
    expect(find.byType(TabletTopBar), findsOneWidget);
    expect(find.text('the screen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a screen with no tablet layout yet is held at phone width', (
    tester,
  ) async {
    await pump(tester, const Size(1194, 834), '/hub?careerId=1');
    final frame = tester.getSize(find.byType(PhoneWidthFrame));
    final inner = tester.getSize(find.byType(Scaffold).last);
    expect(frame.width, greaterThan(PhoneWidthFrame.maxWidth));
    expect(inner.width, PhoneWidthFrame.maxWidth);
  });

  testWidgets('a split-view window gets the plain phone screen', (
    tester,
  ) async {
    await pump(tester, const Size(507, 834), '/hub?careerId=1');
    expect(find.byType(TabletSidebar), findsNothing);
    expect(find.text('the screen'), findsOneWidget);
  });

  testWidgets('no career in the link: no shell', (tester) async {
    await pump(tester, const Size(1194, 834), '/hub');
    expect(find.byType(TabletSidebar), findsNothing);
    expect(find.text('the screen'), findsOneWidget);
  });
}
