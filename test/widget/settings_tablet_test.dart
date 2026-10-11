import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/db/save_backup.dart';
import 'package:fnm/features/onboarding/tour_providers.dart';
import 'package:fnm/features/settings/save_backup_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/settings/settings_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/seeded_save.dart';

/// The whole-database export and restore without the file system: the share
/// sheet only takes the path, so the file is never written; the restore is
/// refused, so the database is never closed and the app never restarted.
class _FakeBackup extends SaveBackupService {
  _FakeBackup(super._ref);

  int exports = 0;
  final List<String> restored = [];

  /// When set, an export is held until it completes.
  Future<void>? exportGate;

  /// When set, the next export (or restore) throws and clears the flag.
  bool exportThrows = false;
  bool restoreThrows = false;

  @override
  Future<File> export({DateTime? at}) async {
    exports++;
    await exportGate;
    if (exportThrows) {
      exportThrows = false;
      throw const FileSystemException('disk full');
    }
    return File('fnm-test-backup.fnmbackup');
  }

  @override
  Future<BackupRejection?> restore(String path) async {
    restored.add(path);
    if (restoreThrows) {
      restoreThrows = false;
      throw const FileSystemException('restore failed');
    }
    return BackupRejection.notAFnmSave;
  }
}

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [saveBackupServiceProvider.overrideWith(_FakeBackup.new)],
  );
  await pumpRoute(tester, save, Routes.settings, size: size);
  return save;
}

// The router's own state: routeInformationProvider misses a push.
Uri _uri(SeededSave save) => save.container.read(routerProvider).state.uri;

/// Settings under a MaterialApp that follows [localeProvider] as FnmApp's
/// does (the harness of [pumpRoute] pins English), so a language change
/// rebuilds the app as it does on a device. Not FnmApp itself: its initState
/// opens the store connection, which has no platform in a test.
Future<SeededSave> _openApp(WidgetTester tester) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  tester.view.physicalSize = kTabletSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  save.container.read(routerProvider).go(Routes.settings);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: save.container,
      child: Consumer(
        builder: (context, ref, _) => MaterialApp.router(
          theme: AppTheme.theme,
          locale: ref.watch(localeProvider),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: ref.watch(routerProvider),
        ),
      ),
    ),
  );
  await settle(tester);
  return save;
}

Future<SharedPreferences> _prefs(WidgetTester tester) async {
  late SharedPreferences prefs;
  await tester.runAsync(() async {
    prefs = await SharedPreferences.getInstance();
  });
  return prefs;
}

/// Records every share-sheet call, answering as a platform with no sheet.
List<MethodCall> _mockShare(WidgetTester tester) {
  const channel = MethodChannel('dev.fluttercommunity.plus/share');
  final calls = <MethodCall>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
    call,
  ) async {
    calls.add(call);
    return 'dev.fluttercommunity.plus/share/unavailable';
  });
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      null,
    ),
  );
  return calls;
}

/// Records every file-picker call, answering with one backup file once
/// [gate] completes, or with nothing (the picker cancelled) when [cancel].
List<MethodCall> _mockPicker(
  WidgetTester tester,
  Future<void> gate, {
  bool cancel = false,
}) {
  const channel = MethodChannel('miguelruivo.flutter.plugins.filepicker');
  final calls = <MethodCall>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
    call,
  ) async {
    calls.add(call);
    await gate;
    if (cancel) return null;
    return [
      {'name': 'old.fnmbackup', 'path': '/picked/old.fnmbackup', 'size': 0},
    ];
  });
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      null,
    ),
  );
  return calls;
}

/// Whether the backup card's two buttons take taps.
void _expectButtonsLive(WidgetTester tester) {
  expect(
    tester
        .widget<PrimaryButton>(
          find.widgetWithText(PrimaryButton, enL.backupExport),
        )
        .onPressed,
    isNotNull,
    reason: 'export is live',
  );
  expect(
    tester
        .widget<OutlinedButton>(
          find.ancestor(
            of: find.text(enL.backupRestore),
            matching: find.byType(OutlinedButton),
          ),
        )
        .onPressed,
    isNotNull,
    reason: 'restore is live',
  );
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the game left, the data right, $size', (tester) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(SettingsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      final sound = tester.getRect(find.text(enL.settingsSoundHapticsTitle));
      final backup = tester.getRect(find.text(enL.backupTitle));
      expect(backup.left, greaterThan(sound.right));
      expect(find.text(enL.settingsTourTitle), findsOneWidget);
      expect(find.text(enL.settingsDiagnosticsTitle), findsOneWidget);
      // Every card is on show without a scroll, the backup's two buttons too.
      final screen = Offset.zero & size;
      for (final text in [
        enL.settingsTourTitle,
        enL.settingsContactTitle,
        enL.backupExport,
        enL.backupRestore,
      ]) {
        expect(
          screen.contains(tester.getRect(find.text(text)).bottomRight),
          isTrue,
          reason: text,
        );
      }
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets("the sound switch writes the phone's setting", (tester) async {
    final save = await _open(tester, kTabletSize);
    expect((await _prefs(tester)).getBool('settings.soundHaptics'), isNull);
    expect(save.container.read(soundHapticsEnabledProvider), isTrue);
    await tester.tap(find.text(enL.settingsSoundHapticsTitle));
    await settle(tester);
    expect(save.container.read(soundHapticsEnabledProvider), isFalse);
    expect((await _prefs(tester)).getBool('settings.soundHaptics'), isFalse);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the language dialog closes itself and the choice is kept', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    expect((await _prefs(tester)).getString('settings.locale'), isNull);
    expect(save.container.read(localeProvider), isNull);
    await tester.tap(find.byKey(const Key('settings-language-tile')));
    await settle(tester);
    // On a tablet the picker is a root dialog.
    expect(find.byType(Dialog), findsOneWidget);
    await tester.tap(find.byKey(const Key('language-option-cs')));
    await settle(tester);
    expect(find.byType(Dialog), findsNothing);
    expect(_uri(save).path, Routes.settings);
    expect(save.container.read(localeProvider), const Locale('cs'));
    expect((await _prefs(tester)).getString('settings.locale'), 'cs');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a language change rebuilds the app on the tablet settings', (
    tester,
  ) async {
    final save = await _openApp(tester);
    expect(save.container.read(localeProvider), isNull);
    expect(find.byKey(SettingsScreen.tabletLayoutKey), findsOneWidget);
    expect(find.text(enL.homeSettings), findsOneWidget);
    await tester.tap(find.byKey(const Key('settings-language-tile')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('language-option-cs')));
    await settle(tester);
    final cs = lookupAppLocalizations(const Locale('cs'));
    expect(tester.takeException(), isNull);
    expect(save.container.read(localeProvider), const Locale('cs'));
    expect(_uri(save).path, Routes.settings);
    expect(find.byKey(SettingsScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(FullScreenPhoneFrame), findsNothing);
    expect(find.text(cs.homeSettings), findsOneWidget);
    expect(find.text(cs.settingsSoundHapticsTitle), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the backup export points the share sheet at its button '
      '(Review Focus 7)', (tester) async {
    final save = await _open(tester, kTabletSize);
    final calls = _mockShare(tester);
    final backup =
        save.container.read(saveBackupServiceProvider) as _FakeBackup;
    expect(backup.exports, 0);
    final export = find.widgetWithText(PrimaryButton, enL.backupExport);
    final button = tester.getRect(export);
    await tester.tap(export);
    await settle(tester);
    expect(backup.exports, 1);
    expect(calls, hasLength(1));
    final args = calls.single.arguments as Map<Object?, Object?>;
    expect(
      Rect.fromLTWH(
        args['originX']! as double,
        args['originY']! as double,
        args['originWidth']! as double,
        args['originHeight']! as double,
      ),
      button,
    );
    expect(find.text(enL.backupFailed), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('two taps on export while it runs make one backup', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final calls = _mockShare(tester);
    final backup =
        save.container.read(saveBackupServiceProvider) as _FakeBackup;
    // Armed after the save is seeded: the first export is held.
    final held = Completer<void>();
    backup.exportGate = held.future;
    expect(backup.exports, 0);
    final export = find.widgetWithText(PrimaryButton, enL.backupExport);
    // No frame between the taps: the button still holds the handler it was
    // built with, so only the handler itself can refuse the second.
    await tester.tap(export);
    await tester.tap(export);
    expect(backup.exports, 1);
    held.complete();
    await settle(tester);
    expect(backup.exports, 1);
    expect(calls, hasLength(1));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('restore asks first, hands the picked file to the phone '
      'restore once, and tells a refusal', (tester) async {
    final save = await _open(tester, kTabletSize);
    // Armed after the save is seeded: the picker stays open until released.
    final picked = Completer<void>();
    final picks = _mockPicker(tester, picked.future);
    final backup =
        save.container.read(saveBackupServiceProvider) as _FakeBackup;
    expect(backup.restored, isEmpty);
    final restore = find.text(enL.backupRestore);
    // A second tap while the picker is still open: one picker, one question,
    // one restore.
    await tester.tap(restore);
    await tester.pump();
    await tester.tap(restore);
    await tester.pump();
    picked.complete();
    await settle(tester);
    expect(picks, hasLength(1));
    expect(find.text(enL.backupRestoreWarnTitle), findsOneWidget);
    expect(backup.restored, isEmpty, reason: 'nothing before the yes');
    await tester.tap(find.text(enL.backupRestoreConfirm));
    await settle(tester);
    expect(backup.restored, ['/picked/old.fnmbackup']);
    expect(find.text(enL.backupRejectedNotFnm), findsOneWidget);
    expect(_uri(save).path, Routes.settings);
    expect(find.byKey(SettingsScreen.tabletLayoutKey), findsOneWidget);
    // The refusal gave the buttons back.
    final button = tester.widget<OutlinedButton>(
      find.ancestor(of: restore, matching: find.byType(OutlinedButton)),
    );
    expect(button.onPressed, isNotNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a cancelled picker restores nothing and leaves the buttons '
      'live', (tester) async {
    final save = await _open(tester, kTabletSize);
    final picks = _mockPicker(tester, Future<void>.value(), cancel: true);
    final backup =
        save.container.read(saveBackupServiceProvider) as _FakeBackup;
    expect(backup.restored, isEmpty);
    expect(picks, isEmpty);
    await tester.tap(find.text(enL.backupRestore));
    await settle(tester);
    expect(picks, hasLength(1));
    expect(find.text(enL.backupRestoreWarnTitle), findsNothing);
    expect(backup.restored, isEmpty);
    _expectButtonsLive(tester);
    // Not still "asking": a second restore opens the picker again.
    await tester.tap(find.text(enL.backupRestore));
    await settle(tester);
    expect(picks, hasLength(2));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a declined restore restores nothing', (tester) async {
    final save = await _open(tester, kTabletSize);
    _mockPicker(tester, Future<void>.value());
    final backup =
        save.container.read(saveBackupServiceProvider) as _FakeBackup;
    expect(backup.restored, isEmpty);
    await tester.tap(find.text(enL.backupRestore));
    await settle(tester);
    expect(find.text(enL.backupRestoreWarnTitle), findsOneWidget);
    await tester.tap(find.text(enL.backupCancel));
    await settle(tester);
    expect(find.text(enL.backupRestoreWarnTitle), findsNothing);
    expect(backup.restored, isEmpty);
    _expectButtonsLive(tester);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('an export that throws says so, and a retry exports once', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final calls = _mockShare(tester);
    // Armed after the save is seeded.
    final backup = save.container.read(saveBackupServiceProvider) as _FakeBackup
      ..exportThrows = true;
    expect(backup.exports, 0);
    final export = find.widgetWithText(PrimaryButton, enL.backupExport);
    await tester.tap(export);
    await settle(tester);
    expect(backup.exports, 1);
    expect(calls, isEmpty, reason: 'nothing to share');
    expect(find.text(enL.backupFailed), findsOneWidget);
    _expectButtonsLive(tester);
    await tester.tap(export);
    await settle(tester);
    expect(backup.exports, 2, reason: 'the retry exported once');
    expect(calls, hasLength(1));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a restore that throws gives the buttons back', (tester) async {
    final save = await _open(tester, kTabletSize);
    _mockPicker(tester, Future<void>.value());
    final backup = save.container.read(saveBackupServiceProvider) as _FakeBackup
      ..restoreThrows = true;
    expect(backup.restored, isEmpty);
    // The failure escapes `_restore` as it would on a device (to the zone's
    // handler, which logs it); caught here so it does not fail the test. The
    // zone is the one `_restore` starts in: its later steps run there.
    final errors = <Object>[];
    await runZonedGuarded(
      () => tester.tap(find.text(enL.backupRestore)),
      (e, _) => errors.add(e),
    );
    await settle(tester);
    expect(find.text(enL.backupRestoreWarnTitle), findsOneWidget);
    await tester.tap(find.text(enL.backupRestoreConfirm));
    await settle(tester);
    expect(errors, [isA<FileSystemException>()]);
    expect(backup.restored, ['/picked/old.fnmbackup']);
    _expectButtonsLive(tester);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("the walk through starts the phone's tour on the save", (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    expect(save.container.read(tourCareerProvider), isNull);
    expect(save.container.read(tourStepProvider), isNull);
    await tester.tap(find.text(enL.settingsTourTitle));
    await settle(tester);
    expect(save.container.read(tourCareerProvider), save.careerId);
    expect(save.container.read(tourStepProvider), 0);
    expect(_uri(save).path, Routes.hub);
    expect(_uri(save).queryParameters['careerId'], '${save.careerId}');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("diagnostics and the back arrow go where the phone's do", (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.text(enL.settingsDiagnosticsTitle));
    await settle(tester);
    expect(_uri(save).path, Routes.diagnostics);
    save.container.read(routerProvider).go(Routes.settings);
    await settle(tester);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(_uri(save).path, Routes.home);
    await tester.pumpWidget(const SizedBox());
  });
}
