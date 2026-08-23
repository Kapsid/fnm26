import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/settings/settings_screen.dart';

import '../helpers/pump_app.dart';

/// What the free game covers, said once, where somebody who wants to know can
/// find it — and nowhere on the way into a save, where a manager is being
/// asked to care about a nation rather than about a price.
void main() {
  Future<void> pumpSettings(WidgetTester tester, {required bool premium}) =>
      tester.pumpApp(
        const SettingsScreen(),
        overrides: [premiumUnlockedProvider.overrideWith((ref) => premium)],
      );

  testWidgets('a free player is told what the free part is', (tester) async {
    await pumpSettings(tester, premium: false);
    await tester.pumpAndSettle();

    expect(find.text('One free four-year cycle'), findsOneWidget);
    expect(find.textContaining('single payment'), findsOneWidget);
  });

  testWidgets('somebody who has paid is thanked, not sold to', (tester) async {
    await pumpSettings(tester, premium: true);
    await tester.pumpAndSettle();

    expect(find.text('Unlocked'), findsOneWidget);
    expect(find.text('One free four-year cycle'), findsNothing);
    expect(find.textContaining('single payment'), findsNothing);
  });
}
