import 'dart:io';

import 'package:drift/drift.dart'
    show LazyDatabase, QueryExecutor, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/shared/widgets/save_open_gate.dart';
import 'package:fnm/shared/widgets/save_upgrade_failed_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The launch gate: a save that will not open shows the failure screen, never
/// the saves list with nothing on it.
void main() {
  /// Stands in for the app: the saves list, which must never show empty.
  const careerList = Text('CAREER LIST', textDirection: TextDirection.ltr);

  // Every test builds its own database on purpose.
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> pumpGate(
    WidgetTester tester, {
    required QueryExecutor executor,
    File? copy,
    bool opens = false,
  }) async {
    final db = AppDatabase.forTesting(executor);
    // Only a database that opened has anything to close; one whose open
    // failed is left alone.
    if (opens) addTearDown(() => tester.runAsync(db.close));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          saveRecoveryProvider.overrideWith(
            (ref) async => (live: File('/nowhere/fnm.sqlite'), copy: copy),
          ),
        ],
        child: SaveOpenGate(onRetry: () {}, child: careerList),
      ),
    );
    // The open, the copy lookup and the stored language are real futures:
    // let them finish outside the fake clock, then build what they left.
    for (var i = 0; i < 3; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
    }
    await tester.pump(const Duration(milliseconds: 500));
  }

  QueryExecutor failingOpen() =>
      LazyDatabase(() async => throw StateError('migration failed'));

  testWidgets('a failed open with no copy shows the neutral screen', (
    tester,
  ) async {
    await pumpGate(tester, executor: failingOpen());

    expect(find.byType(SaveUpgradeFailedScreen), findsOneWidget);
    expect(find.text('CAREER LIST'), findsNothing);
    expect(find.text('Your saves could not be opened'), findsOneWidget);
    expect(find.text('Restore the copy from before the update'), findsNothing);
    expect(find.text('Retry'), findsOneWidget);
  }, timeout: const Timeout(Duration(minutes: 2)));

  testWidgets('a failed upgrade with a copy offers to restore it', (
    tester,
  ) async {
    await pumpGate(
      tester,
      executor: failingOpen(),
      copy: File('/nowhere/before-update-v54.fnmsave'),
    );

    expect(find.text('CAREER LIST'), findsNothing);
    expect(find.text('Your save could not be updated'), findsOneWidget);
    expect(
      find.text('Restore the copy from before the update'),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsOneWidget);
  }, timeout: const Timeout(Duration(minutes: 2)));

  testWidgets('the screen speaks the language chosen in Settings', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'settings.locale': 'cs'});
    await pumpGate(tester, executor: failingOpen());

    expect(find.text('Uložené hry se nepodařilo otevřít'), findsOneWidget);
  }, timeout: const Timeout(Duration(minutes: 2)));

  testWidgets('a save that opens shows the app', (tester) async {
    await pumpGate(tester, executor: NativeDatabase.memory(), opens: true);

    expect(find.text('CAREER LIST'), findsOneWidget);
    expect(find.byType(SaveUpgradeFailedScreen), findsNothing);
  }, timeout: const Timeout(Duration(minutes: 2)));
}
