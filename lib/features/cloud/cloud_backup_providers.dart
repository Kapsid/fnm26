import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/sim_activity.dart';
import 'package:fnm/core/config/cloud_config.dart';
import 'package:fnm/data/cloud/backup_describer.dart';
import 'package:fnm/data/cloud/drive_backup_target.dart';
import 'package:fnm/data/cloud/icloud_backup_target.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/save_backup.dart';
import 'package:fnm/domain/services/cloud/auto_backup_runner.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_meta.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_policy.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_store.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_target.dart';
import 'package:fnm/features/cloud/backup_settings.dart';
import 'package:fnm/features/settings/save_backup_providers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

export 'package:fnm/features/cloud/backup_settings.dart';

/// Which automatic backup this device offers: iCloud on an iPhone or iPad,
/// none elsewhere. A provider so a test can pick.
///
/// Android offers none until Google Drive is set up in the Google Cloud
/// console ([kGoogleServerClientId]): the owner's call is to hide the whole
/// cloud section there rather than show a switch that cannot work.
final Provider<CloudProvider?> cloudProviderKindProvider =
    Provider<CloudProvider?>((ref) {
      if (kIsWeb) return null;
      return switch (defaultTargetPlatform) {
        TargetPlatform.iOS => CloudProvider.icloud,
        TargetPlatform.android when kGoogleServerClientId.isNotEmpty =>
          CloudProvider.googleDrive,
        _ => null,
      };
    });

/// The Google account behind Drive backups. A provider so a test can fake it.
final Provider<GoogleDriveAccount> googleDriveAccountProvider =
    Provider<GoogleDriveAccount>((ref) => GoogleSignInDriveAccount());

/// The cloud folder for this device's kind, or null when there is none.
final Provider<CloudBackupTarget?> cloudBackupTargetProvider =
    Provider<CloudBackupTarget?>((ref) {
      return switch (ref.watch(cloudProviderKindProvider)) {
        CloudProvider.icloud => ICloudBackupTarget(),
        CloudProvider.googleDrive => switch (ref.watch(
          googleDriveAccountProvider,
        )) {
          final GoogleSignInDriveAccount a => DriveBackupTarget(a),
          _ => null,
        },
        null => null,
      };
    });

/// What the automatic backup last did, for the status line under its switch.
enum CloudStatus {
  idle,
  uploading,
  uploaded,
  signedOut,
  notConfigured,
  unavailable,
  failed,
}

final StateProvider<CloudStatus> cloudStatusProvider =
    StateProvider<CloudStatus>((ref) => CloudStatus.idle);

/// Whether the cloud can be used right now, asked when the settings screen
/// opens. Never throws.
final AutoDisposeFutureProvider<CloudAvailability?> cloudAvailabilityProvider =
    FutureProvider.autoDispose<CloudAvailability?>((ref) async {
      final target = ref.watch(cloudBackupTargetProvider);
      if (target == null) return null;
      try {
        return await target.availability();
      } on Object {
        return CloudAvailability.unavailable;
      }
    });

CloudStatus statusFor(CloudAvailability a) => switch (a) {
  CloudAvailability.available => CloudStatus.idle,
  CloudAvailability.signedOut => CloudStatus.signedOut,
  CloudAvailability.notConfigured => CloudStatus.notConfigured,
  CloudAvailability.unavailable => CloudStatus.unavailable,
};

/// Automatic cloud backups, the reminder bookkeeping they share with the
/// manual backup, and restoring from the cloud.
///
/// [trigger] is called from the places a save changes for good (a match or a
/// window committed, a cycle ending) and when the app goes to the background.
/// It never throws and never blocks: callers fire it and move on.
class CloudBackupService {
  CloudBackupService(this._ref);

  final Ref _ref;
  AutoBackupRunner? _runner;
  CloudBackupTarget? _runnerTarget;

  BackupSettingsNotifier get _settings =>
      _ref.read(backupSettingsProvider.notifier);

  /// Asks for an automatic backup. See the class comment.
  Future<void> trigger(BackupTrigger trigger) async {
    try {
      final settings = _settings;
      await settings.ensureLoaded();
      if (trigger == BackupTrigger.cycleEnd) {
        await settings.noteCycleEnd(DateTime.now());
      }
      if (!settings.current.autoEnabled) return;
      final target = _ref.read(cloudBackupTargetProvider);
      if (target == null) return;
      final runner = _runnerFor(target);
      if (runner.busy) return;
      final outcome = await runner.run(trigger);
      _report(outcome);
    } on Object catch (e, stack) {
      AppLog.error('cloud-backup', e, stack);
    }
  }

  AutoBackupRunner _runnerFor(CloudBackupTarget target) {
    final existing = _runner;
    if (existing != null && identical(_runnerTarget, target)) return existing;
    _runnerTarget = target;
    return _runner = AutoBackupRunner(
      target: target,
      ledger: _SettingsLedger(_settings),
      snapshot: _snapshot,
      describe: describe,
      lastChangeAt: SaveBackup.lastDataChange,
      isSimBusy: () => SimActivity.busy,
      onStart: () => _setStatus(CloudStatus.uploading),
    );
  }

  void _report(AutoBackupOutcome outcome) {
    switch (outcome.result) {
      case AutoBackupResult.uploaded:
        _setStatus(CloudStatus.uploaded);
      case AutoBackupResult.unavailable:
        _setStatus(
          statusFor(outcome.availability ?? CloudAvailability.unavailable),
        );
      case AutoBackupResult.failed:
        if (outcome.error case final Object e) {
          AppLog.error('cloud-backup-upload', e, StackTrace.current);
        }
        _setStatus(CloudStatus.failed);
      case AutoBackupResult.disabled:
      case AutoBackupResult.paused:
      case AutoBackupResult.postponed:
      case AutoBackupResult.busy:
      case AutoBackupResult.throttled:
      case AutoBackupResult.unchanged:
        break;
    }
  }

  void _setStatus(CloudStatus s) {
    try {
      _ref.read(cloudStatusProvider.notifier).state = s;
    } on Object {
      // The scope is gone (a restore restarted the app); nobody to tell.
    }
  }

  /// A snapshot under a name of its own: two uploads (say, one from the scope
  /// a restore replaced) must never write or delete each other's file.
  Future<File> _snapshot() async {
    final dir = await getTemporaryDirectory();
    final stamp = DateTime.now().microsecondsSinceEpoch;
    final salt = Random().nextInt(1 << 32).toRadixString(36);
    return SaveBackup.writeSnapshot(
      _ref.read(appDatabaseProvider),
      p.join(dir.path, 'cloud-upload-$stamp-$salt.${SaveBackup.extension}'),
    );
  }

  /// The metadata for [snapshot], taken at [at]. The careers are read from
  /// the snapshot itself, off the UI isolate.
  Future<CloudBackupMeta> describe(File snapshot, DateTime at, int seq) async {
    final path = snapshot.path;
    final careers = await Isolate.run(() => careersInBackup(path));
    return CloudBackupMeta(
      createdAt: at.toUtc(),
      deviceId: _settings.current.deviceId,
      deviceName: await thisDeviceName(),
      platform: Platform.operatingSystem,
      schemaVersion: AppDatabase.currentSchemaVersion,
      sizeBytes: snapshot.lengthSync(),
      careers: careers,
      seq: seq,
    );
  }

  /// Every automatic backup on the account, newest first. Throws when the
  /// cloud cannot be read; the restore sheet says so.
  Future<List<CloudBackupEntry>> listBackups() async {
    final target = _ref.read(cloudBackupTargetProvider);
    if (target == null) return const [];
    return CloudBackupStore(target).list();
  }

  /// Brings [entry] down and restores it through the same path (schema guard,
  /// safety copy, restart) as a file restore. Returns the refusal, or null once
  /// the app is restarting.
  Future<BackupRejection?> restore(CloudBackupEntry entry) async {
    final target = _ref.read(cloudBackupTargetProvider);
    if (target == null) return BackupRejection.unreadable;
    // Read before the awaits: the restore tears this scope down.
    final backup = _ref.read(saveBackupServiceProvider);
    final dir = await getTemporaryDirectory();
    final local = p.join(
      dir.path,
      'cloud-restore-${DateTime.now().microsecondsSinceEpoch}'
      '.${SaveBackup.extension}',
    );
    final file = File(local);
    if (file.existsSync()) await file.delete();
    await CloudBackupStore(target).fetch(entry, local);
    return backup.restore(local);
  }

  /// Called once the app has started: after a restore, checks the restored
  /// saves really open (SQLite's quick check and a read of the careers) and
  /// only then lets automatic uploads resume. A restore that left a broken
  /// database is never uploaded over the good backups.
  Future<void> confirmHealthyStart() async {
    try {
      final settings = _settings;
      await settings.ensureLoaded();
      if (!settings.current.restorePending) return;
      if (!await SaveBackup.isHealthy(_ref.read(appDatabaseProvider))) {
        return;
      }
      await settings.clearRestorePending();
    } on Object catch (e, stack) {
      AppLog.error('restore-health-check', e, stack);
    }
  }

  /// Signs in to Google for Drive backups and, on success, switches automatic
  /// backup on. Returns the email, or null when the player backed out.
  /// Throws [CloudSetupException] when the build is not set up for Drive.
  Future<String?> signInToDrive() async {
    final email = await _ref.read(googleDriveAccountProvider).signIn();
    if (email == null) return null;
    await _settings.setDriveEmail(email);
    await _settings.setAutoEnabled(true);
    _setStatus(CloudStatus.idle);
    _ref.invalidate(cloudAvailabilityProvider);
    return email;
  }

  /// Signs out of Google and switches automatic Drive backup off. The backups
  /// already in Drive stay there.
  Future<void> signOutOfDrive() async {
    await _ref.read(googleDriveAccountProvider).signOut();
    await _settings.setAutoEnabled(false);
    await _settings.setDriveEmail(null);
    _setStatus(CloudStatus.idle);
    _ref.invalidate(cloudAvailabilityProvider);
  }
}

class _SettingsLedger implements AutoBackupLedger {
  _SettingsLedger(this._settings);

  final BackupSettingsNotifier _settings;

  @override
  bool get enabled => _settings.current.autoEnabled;

  @override
  DateTime? get lastUploadAt => _settings.current.lastAutoUploadAt;

  @override
  bool get paused => _settings.current.restorePending;

  @override
  int? get preRestoreSeq => _settings.current.preRestoreSeq;

  @override
  Future<int> claimSequence() => _settings.claimSequence();

  @override
  Future<void> recordUpload(DateTime at) =>
      _settings.recordBackup(at, auto: true);
}

/// The safety copies a restore left behind, newest first, for the Backups
/// section to offer back.
final AutoDisposeFutureProvider<List<File>> safetyCopiesProvider =
    FutureProvider.autoDispose<List<File>>((ref) async {
      try {
        return SaveBackup.safetyCopiesIn(await SaveBackup.safetyDirectory());
      } on Object {
        return const [];
      }
    });

final Provider<CloudBackupService> cloudBackupServiceProvider =
    Provider<CloudBackupService>(CloudBackupService.new);
