import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// A log with a fixed timestamp, so the golden is the same every run.
const String _log = '--- 2026-10-01T09:30:00.000  [hub:advance]\n'
    'Bad state: an example failure\n'
    '#0      SeasonService.advance '
    '(package:fnm/features/hub/hub_providers.dart:1200:7)\n';

/// Points the log at a file holding [_log] for this test.
void useFixedLog() {
  final dir = Directory.systemTemp.createTempSync('fnm-diagnostics');
  final file = File('${dir.path}/diagnostics.log')..writeAsStringSync(_log);
  AppLog.debugUse(file);
  addTearDown(() {
    AppLog.debugUse(null);
    dir.deleteSync(recursive: true);
  });
}

/// The phone diagnostics, pinned before the tablet layout is added beside
/// them: nothing recorded, and a recorded failure.
void main() {
  testWidgets('diagnostics_empty_phone', (tester) async {
    AppLog.debugUse(null);
    final save = await seedSave(tester);
    await pumpRoute(tester, save, Routes.diagnostics);
    expect(find.text(enL.diagnosticsEmpty), findsOneWidget);
    await expectAppGolden('goldens/diagnostics_empty_phone.png');
  });

  testWidgets('diagnostics_log_phone', (tester) async {
    useFixedLog();
    final save = await seedSave(tester);
    await pumpRoute(tester, save, Routes.diagnostics);
    expect(find.text(enL.diagnosticsCopy), findsOneWidget);
    await expectAppGolden('goldens/diagnostics_log_phone.png');
  });
}
