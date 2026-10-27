import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/cloud/drive_backup_target.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_meta.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_target.dart';
import 'package:fnm/domain/services/cloud/fake_cloud_backup_target.dart';
import 'package:fnm/features/cloud/cloud_backup_providers.dart';
import 'package:fnm/features/settings/backups_card.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/expect_whole.dart';

class _FakeDrive implements GoogleDriveAccount {
  _FakeDrive({this.configured = true});

  @override
  final bool configured;
  final String email = 'manager@example.com';
  int signIns = 0;
  int signOuts = 0;

  @override
  Future<String?> signIn() async {
    signIns++;
    if (!configured) throw const CloudSetupException('none');
    return email;
  }

  @override
  Future<void> signOut() async => signOuts++;
}

AppLocalizations get _en => lookupAppLocalizations(const Locale('en'));

/// The Settings Backups section on its own: what it shows, its switches, the
/// cloud restore list, and that it fits a phone at text scale 1.4.
void main() {
  late FakeCloudBackupTarget cloud;

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    CloudProvider? kind = CloudProvider.icloud,
    GoogleDriveAccount? drive,
    Map<String, Object> prefs = const {},
    Size size = const Size(390, 1400),
    double textScale = 1,
    Locale locale = const Locale('en'),
    List<File> safetyCopies = const [],
  }) async {
    SharedPreferences.setMockInitialValues(prefs);
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        cloudProviderKindProvider.overrideWithValue(kind),
        cloudBackupTargetProvider.overrideWithValue(
          kind == null ? null : cloud,
        ),
        googleDriveAccountProvider.overrideWithValue(drive ?? _FakeDrive()),
        safetyCopiesProvider.overrideWith((ref) async => safetyCopies),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.theme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: const Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: BackupsCard(),
            ),
          ),
        ),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    return container;
  }

  setUp(() {
    cloud = FakeCloudBackupTarget();
  });

  testWidgets('shows the file backup, restore, reminders and the help', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text(_en.backupTitle), findsOneWidget);
    expect(
      find.widgetWithText(PrimaryButton, _en.backupExport),
      findsOneWidget,
    );
    expect(find.text(_en.backupRestore), findsOneWidget);
    expect(find.text(_en.backupNever), findsOneWidget);
    expect(find.text(_en.backupRemindersTitle), findsOneWidget);
    expect(find.byKey(BackupsCard.helpKey), findsOneWidget);
    // iPhone: iCloud.
    expect(find.text(_en.backupAutoICloudTitle), findsOneWidget);
    expect(find.text(_en.backupRestoreICloud), findsOneWidget);
    expect(find.text(_en.backupAutoDriveTitle), findsNothing);
  });

  testWidgets('the last backup date is shown', (tester) async {
    await pump(
      tester,
      prefs: {
        'backup.lastAt': DateTime(2026, 10, 20, 9, 30).millisecondsSinceEpoch,
      },
    );
    expect(
      find.text(_en.backupLastAt('20 Oct 2026 09:30')),
      findsOneWidget,
    );
  });

  testWidgets('the reminder switch is remembered', (tester) async {
    final c = await pump(tester);
    expect(c.read(backupSettingsProvider).remindersOn, isTrue);
    await tester.tap(find.byKey(BackupsCard.remindersKey));
    await tester.pumpAndSettle();
    expect(c.read(backupSettingsProvider).remindersOn, isFalse);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('backup.reminders'), isFalse);
  });

  testWidgets('automatic iCloud backup: off by default, on is kept', (
    tester,
  ) async {
    final c = await pump(tester);
    expect(c.read(backupSettingsProvider).autoEnabled, isFalse);
    await tester.tap(find.byKey(BackupsCard.autoKey));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(c.read(backupSettingsProvider).autoEnabled, isTrue);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('backup.autoEnabled'), isTrue);
  });

  testWidgets('iCloud signed out: a calm status line, no crash', (
    tester,
  ) async {
    cloud.state = CloudAvailability.signedOut;
    await pump(tester);
    expect(tester.takeException(), isNull);
    expect(find.text(_en.backupStatusICloudSignedOut), findsOneWidget);
  });

  testWidgets('Drive: signing in turns it on and shows the account', (
    tester,
  ) async {
    final drive = _FakeDrive();
    final c = await pump(tester, kind: CloudProvider.googleDrive, drive: drive);
    expect(find.text(_en.backupAutoDriveTitle), findsOneWidget);
    expect(find.text(_en.backupRestoreDrive), findsOneWidget);
    await tester.tap(find.byKey(BackupsCard.autoKey));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(drive.signIns, 1);
    expect(c.read(backupSettingsProvider).autoEnabled, isTrue);
    expect(
      find.textContaining(_en.backupDriveSignedInAs('manager@example.com')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(BackupsCard.signOutKey));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(drive.signOuts, 1);
    expect(c.read(backupSettingsProvider).autoEnabled, isFalse);
    expect(c.read(backupSettingsProvider).driveEmail, isNull);
  });

  testWidgets('Drive not set up in this build: says so, stays off', (
    tester,
  ) async {
    final c = await pump(
      tester,
      kind: CloudProvider.googleDrive,
      drive: _FakeDrive(configured: false),
    );
    await tester.tap(find.byKey(BackupsCard.autoKey));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(c.read(backupSettingsProvider).autoEnabled, isFalse);
    expect(find.text(_en.backupStatusNotConfigured), findsOneWidget);
  });

  testWidgets('no cloud on this platform: only the file backup', (
    tester,
  ) async {
    await pump(tester, kind: null);
    expect(find.byKey(BackupsCard.autoKey), findsNothing);
    expect(find.byKey(BackupsCard.restoreCloudKey), findsNothing);
    expect(find.text(_en.backupRestore), findsOneWidget);
  });

  testWidgets('restore from iCloud lists the backups with their careers, '
      'and asks before anything', (tester) async {
    final meta = CloudBackupMeta(
      createdAt: DateTime.utc(2026, 10, 22, 18),
      deviceId: 'otherphone',
      deviceName: 'iPad Air',
      platform: 'ios',
      schemaVersion: 50,
      careers: const [
        BackupCareerSummary(
          managerName: 'Ota',
          nationName: 'Czechia',
          year: 2038,
        ),
      ],
    );
    final name = CloudBackupNames.saveName(meta.deviceId, meta.createdAt);
    cloud.files[name] = Uint8ListHelper.bytes;
    await cloud.writeText(CloudBackupNames.metaNameFor(name), meta.encode());
    await pump(tester);
    await tester.ensureVisible(find.byKey(BackupsCard.restoreCloudKey));
    await tester.tap(find.byKey(BackupsCard.restoreCloudKey));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('iPad Air'), findsOneWidget);
    expect(find.textContaining('Ota, Czechia, 2038'), findsOneWidget);
    await tester.tap(find.textContaining('iPad Air'));
    await tester.pumpAndSettle();
    expect(find.text(_en.backupRestoreWarnTitle), findsOneWidget);
    expect(find.textContaining(_en.backupRestoreSafetyNote), findsOneWidget);
    await tester.tap(find.text(_en.backupCancel));
    await tester.pumpAndSettle();
    expect(cloud.deleted, isEmpty);
  });

  testWidgets('safety copies from before a restore are offered back', (
    tester,
  ) async {
    final dir = Directory.systemTemp.createTempSync('fnm_safety_w');
    addTearDown(() => dir.deleteSync(recursive: true));
    final copy = File('${dir.path}/before-restore.fnmsave')
      ..writeAsStringSync('x')
      ..setLastModifiedSync(DateTime(2026, 10, 21, 8, 15));
    await pump(tester, safetyCopies: [copy]);
    expect(find.byKey(BackupsCard.safetyKey), findsOneWidget);
    expect(find.text(_en.backupSafetyTitle), findsOneWidget);
    expect(find.text('21 Oct 2026 08:15'), findsOneWidget);
    expect(find.text(_en.backupSafetyRestore), findsOneWidget);
    expect(find.text(_en.backupSafetyShare), findsOneWidget);
    await tester.ensureVisible(find.text(_en.backupSafetyRestore));
    await tester.tap(find.text(_en.backupSafetyRestore));
    await tester.pumpAndSettle();
    // Asked first, like every restore.
    expect(find.text(_en.backupRestoreWarnTitle), findsOneWidget);
    await tester.tap(find.text(_en.backupCancel));
    await tester.pumpAndSettle();
  });

  testWidgets('no safety copies: the section is not shown', (tester) async {
    await pump(tester);
    expect(find.byKey(BackupsCard.safetyKey), findsNothing);
  });

  testWidgets('a backup whose details have not arrived still lists', (
    tester,
  ) async {
    cloud.files[CloudBackupNames.saveName(
          'otherphone',
          DateTime.utc(2026, 10, 22, 18),
          seq: 4,
        )] =
        Uint8ListHelper.bytes;
    await pump(tester);
    await tester.ensureVisible(find.byKey(BackupsCard.restoreCloudKey));
    await tester.tap(find.byKey(BackupsCard.restoreCloudKey));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining(_en.backupCloudNoDetails), findsOneWidget);
  });

  testWidgets('an empty cloud says so', (tester) async {
    await pump(tester);
    await tester.ensureVisible(find.byKey(BackupsCard.restoreCloudKey));
    await tester.tap(find.byKey(BackupsCard.restoreCloudKey));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(find.text(_en.backupCloudListEmpty), findsOneWidget);
  });

  late File safetyFile;
  setUpAll(() {
    final dir = Directory.systemTemp.createTempSync('fnm_safety_fit');
    safetyFile = File('${dir.path}/before-restore.fnmsave')
      ..writeAsStringSync('x');
  });

  for (final kind in [CloudProvider.icloud, CloudProvider.googleDrive]) {
    for (final code in ['en', 'cs', 'de', 'el', 'hu', 'fil', 'hi']) {
      testWidgets('$code ${kind.name}: fits a 360 phone at text scale 1.4', (
        tester,
      ) async {
        cloud.state = kind == CloudProvider.icloud
            ? CloudAvailability.signedOut
            : CloudAvailability.notConfigured;
        await pump(
          tester,
          kind: kind,
          size: const Size(360, 3000),
          textScale: 1.4,
          locale: Locale(code),
          prefs: {
            'backup.lastAt': DateTime(
              2026,
              10,
              20,
              9,
              30,
            ).millisecondsSinceEpoch,
            'backup.driveEmail':
                'a.very.long.address.for.a.manager@example.com',
          },
          safetyCopies: [safetyFile],
        );
        expect(tester.takeException(), isNull);
        expectNothingCut(tester);
      });
    }
  }
}

abstract final class Uint8ListHelper {
  static final bytes = Uint8List.fromList([1, 2, 3]);
}
