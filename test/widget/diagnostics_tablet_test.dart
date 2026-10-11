import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/settings/diagnostics_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

/// Points the log at a temporary file holding one failure; returns it.
File _logFile() {
  final dir = Directory.systemTemp.createTempSync('fnm-diagnostics');
  final file = File('${dir.path}/diagnostics.log')
    ..writeAsStringSync('--- [hub:advance]\nBad state: an example failure\n');
  AppLog.debugUse(file);
  addTearDown(() {
    AppLog.debugUse(null);
    dir.deleteSync(recursive: true);
  });
  return file;
}

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(tester, save, Routes.diagnostics, size: size);
  return save;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('nothing recorded, $size', (tester) async {
      AppLog.debugUse(null);
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(DiagnosticsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      expect(find.text(enL.diagnosticsEmpty), findsOneWidget);
      expect(find.text(enL.diagnosticsClear), findsNothing);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('the log across the screen, Copy and Clear in the heading', (
    tester,
  ) async {
    _logFile();
    await _open(tester, kTabletSize);
    expect(find.textContaining('an example failure'), findsOneWidget);
    final title = tester.getRect(find.text(enL.settingsDiagnosticsTitle));
    final clear = tester.getRect(find.text(enL.diagnosticsClear));
    expect(clear.left, greaterThan(title.right));
    expect((clear.center.dy - title.center.dy).abs(), lessThan(24));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("Clear empties the log, as the phone's does", (tester) async {
    final file = _logFile();
    await _open(tester, kTabletSize);
    expect(file.readAsStringSync(), isNotEmpty);
    await tester.tap(find.text(enL.diagnosticsClear));
    await settle(tester);
    expect(file.readAsStringSync(), isEmpty);
    expect(find.text(enL.diagnosticsEmpty), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Copy puts the log on the clipboard and says so', (tester) async {
    _logFile();
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String?;
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
    await _open(tester, kTabletSize);
    expect(copied, isNull);
    await tester.tap(find.text(enL.diagnosticsCopy));
    await settle(tester);
    expect(copied, contains('an example failure'));
    expect(find.text(enL.diagnosticsCopied), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('back with nothing to pop goes to settings', (tester) async {
    AppLog.debugUse(null);
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(
      save.container
          .read(routerProvider)
          .routeInformationProvider
          .value
          .uri
          .path,
      Routes.settings,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
