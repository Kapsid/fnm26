import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/tablet_shell_scope.dart';
import 'package:fnm/shared/widgets/app_bottom_nav.dart';

import '../helpers/pump_app.dart';

void main() {
  const nav = AppBottomNav(careerId: 1, current: AppTab.hub);

  testWidgets('on a phone the bottom nav is drawn as before', (tester) async {
    await tester.pumpApp(const Scaffold(bottomNavigationBar: nav));
    expect(find.text('Hub'), findsOneWidget);
    expect(find.text('Squad'), findsOneWidget);
  });

  testWidgets('inside the tablet shell the sidebar replaces it', (
    tester,
  ) async {
    await tester.pumpApp(
      const TabletShellScope(child: Scaffold(bottomNavigationBar: nav)),
    );
    expect(find.text('Hub'), findsNothing);
    expect(find.text('Squad'), findsNothing);
  });
}
