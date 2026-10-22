import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/settings/settings_screen.dart';

import '../helpers/pump_app.dart';

/// The Discord and Instagram rows: each opens its own link through the
/// launcher, and copies the link when the launcher cannot.
void main() {
  Future<void> pump(
    WidgetTester tester,
    Future<bool> Function(Uri) launcher,
  ) async {
    await tester.pumpApp(
      const Scaffold(body: CommunityCard()),
      overrides: [linkLauncherProvider.overrideWithValue(launcher)],
    );
    await tester.pumpAndSettle();
  }

  testWidgets('both rows render and open their own link', (tester) async {
    final opened = <Uri>[];
    await pump(tester, (u) async {
      opened.add(u);
      return true;
    });
    expect(find.text('Discord'), findsOneWidget);
    expect(find.text('Instagram'), findsOneWidget);
    expect(find.text('@fnm.football'), findsOneWidget);

    await tester.tap(find.byKey(CommunityCard.discordKey));
    await tester.tap(find.byKey(CommunityCard.instagramKey));
    expect(opened.map((u) => u.toString()), [
      'https://discord.gg/SEnYCRnU6J',
      'https://instagram.com/fnm.football',
    ]);
  });

  testWidgets('a launcher that fails or throws falls back to copying', (
    tester,
  ) async {
    String? clip;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          clip = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await pump(tester, (_) async => false);
    await tester.tap(find.byKey(CommunityCard.discordKey));
    await tester.pump();
    expect(clip, 'https://discord.gg/SEnYCRnU6J');
    expect(find.text('Link copied.'), findsOneWidget);

    await pump(tester, (_) async => throw Exception('no handler'));
    await tester.tap(find.byKey(CommunityCard.instagramKey));
    await tester.pump();
    expect(clip, 'https://instagram.com/fnm.football');
  });
}
