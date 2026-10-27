import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Everything about backups the phone remembers between launches.
class BackupSettings {
  const BackupSettings({
    this.loaded = false,
    this.lastBackupAt,
    this.lastAutoUploadAt,
    this.autoEnabled = false,
    this.remindersOn = true,
    this.lastReminderAt,
    this.firstSeenAt,
    this.lastCycleEndAt,
    this.driveEmail,
    this.deviceId = '',
    this.uploadSeq = 0,
    this.preRestoreSeq,
    this.restorePending = false,
  });

  /// Whether the stored values have been read yet.
  final bool loaded;

  /// The last backup of any kind: a file shared out, or an automatic upload.
  final DateTime? lastBackupAt;

  /// The last automatic cloud upload.
  final DateTime? lastAutoUploadAt;

  /// Automatic iCloud (iPhone) or Google Drive (Android) backup. Default off.
  final bool autoEnabled;

  /// Whether the inbox may remind the manager to back up. Default on.
  final bool remindersOn;

  final DateTime? lastReminderAt;

  /// When this install first looked; stands in for a last backup that never
  /// happened, so a new player is not nagged on day one.
  final DateTime? firstSeenAt;

  /// When a cycle last ended on this phone.
  final DateTime? lastCycleEndAt;

  /// The Google account automatic Drive backups go to, for display.
  final String? driveEmail;

  /// This install's own id, which names its cloud backups.
  final String deviceId;

  /// The last upload number used; rotation orders by it, not by the clock.
  final int uploadSeq;

  /// [uploadSeq] at the last restore: the pre-restore pin for rotation.
  final int? preRestoreSeq;

  /// Set when a restore starts, cleared at the first healthy start after it.
  /// Automatic uploads wait while it is set.
  final bool restorePending;

  BackupSettings copyWith({
    bool? loaded,
    DateTime? lastBackupAt,
    DateTime? lastAutoUploadAt,
    bool? autoEnabled,
    bool? remindersOn,
    DateTime? lastReminderAt,
    DateTime? firstSeenAt,
    DateTime? lastCycleEndAt,
    String? driveEmail,
    bool clearDriveEmail = false,
    String? deviceId,
    int? uploadSeq,
    int? preRestoreSeq,
    bool? restorePending,
  }) => BackupSettings(
    loaded: loaded ?? this.loaded,
    lastBackupAt: lastBackupAt ?? this.lastBackupAt,
    lastAutoUploadAt: lastAutoUploadAt ?? this.lastAutoUploadAt,
    autoEnabled: autoEnabled ?? this.autoEnabled,
    remindersOn: remindersOn ?? this.remindersOn,
    lastReminderAt: lastReminderAt ?? this.lastReminderAt,
    firstSeenAt: firstSeenAt ?? this.firstSeenAt,
    lastCycleEndAt: lastCycleEndAt ?? this.lastCycleEndAt,
    driveEmail: clearDriveEmail ? null : driveEmail ?? this.driveEmail,
    deviceId: deviceId ?? this.deviceId,
    uploadSeq: uploadSeq ?? this.uploadSeq,
    preRestoreSeq: preRestoreSeq ?? this.preRestoreSeq,
    restorePending: restorePending ?? this.restorePending,
  );
}

/// Reads and writes [BackupSettings] in [SharedPreferences].
///
/// Every write is best effort: a preference that will not save must never
/// fail a backup, a restore or a match commit.
class BackupSettingsNotifier extends StateNotifier<BackupSettings> {
  BackupSettingsNotifier({DateTime Function()? clock, Random? random})
    : _clock = clock ?? DateTime.now,
      _random = random ?? Random.secure(),
      super(const BackupSettings());

  final DateTime Function() _clock;
  final Random _random;
  Future<void>? _loading;

  static const String kLastAt = 'backup.lastAt';
  static const String kAutoLastAt = 'backup.autoLastAt';
  static const String kAutoEnabled = 'backup.autoEnabled';
  static const String kReminders = 'backup.reminders';
  static const String kLastReminderAt = 'backup.lastReminderAt';
  static const String kFirstSeenAt = 'backup.firstSeenAt';
  static const String kLastCycleEndAt = 'backup.lastCycleEndAt';
  static const String kDriveEmail = 'backup.driveEmail';
  static const String kDeviceId = 'backup.deviceId';
  static const String kUploadSeq = 'backup.uploadSeq';
  static const String kPreRestoreSeq = 'backup.preRestoreSeq';
  static const String kRestorePending = 'backup.restorePending';

  /// Loads once; later calls wait on the same read.
  Future<void> ensureLoaded() => _loading ??= _load();

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      DateTime? at(String k) {
        final v = prefs.getInt(k);
        return v == null ? null : DateTime.fromMillisecondsSinceEpoch(v);
      }

      var firstSeen = at(kFirstSeenAt);
      if (firstSeen == null) {
        firstSeen = _clock();
        await prefs.setInt(kFirstSeenAt, firstSeen.millisecondsSinceEpoch);
      }
      var id = prefs.getString(kDeviceId) ?? '';
      if (id.isEmpty) {
        id = _newDeviceId();
        await prefs.setString(kDeviceId, id);
      }
      if (!mounted) return;
      state = BackupSettings(
        loaded: true,
        lastBackupAt: at(kLastAt),
        lastAutoUploadAt: at(kAutoLastAt),
        autoEnabled: prefs.getBool(kAutoEnabled) ?? false,
        remindersOn: prefs.getBool(kReminders) ?? true,
        lastReminderAt: at(kLastReminderAt),
        firstSeenAt: firstSeen,
        lastCycleEndAt: at(kLastCycleEndAt),
        driveEmail: prefs.getString(kDriveEmail),
        deviceId: id,
        uploadSeq: prefs.getInt(kUploadSeq) ?? 0,
        preRestoreSeq: prefs.getInt(kPreRestoreSeq),
        restorePending: prefs.getBool(kRestorePending) ?? false,
      );
    } on Object {
      // No preferences (a test, a broken store): run on defaults, with an id
      // and a first-seen moment so nothing downstream has to cope with none.
      if (!mounted) return;
      state = state.copyWith(
        loaded: true,
        firstSeenAt: state.firstSeenAt ?? _clock(),
        deviceId: state.deviceId.isEmpty ? _newDeviceId() : state.deviceId,
      );
    }
  }

  static const String _alphabet = '0123456789abcdefghijklmnopqrstuvwxyz';

  String _newDeviceId() => [
    for (var i = 0; i < 10; i++) _alphabet[_random.nextInt(_alphabet.length)],
  ].join();

  /// The settings as they stand, for services outside the widget tree.
  BackupSettings get current => state;

  Future<void> _write(Future<void> Function(SharedPreferences p) body) async {
    try {
      await body(await SharedPreferences.getInstance());
    } on Object {
      // Best effort; see the class comment.
    }
  }

  void _set(BackupSettings next) {
    if (mounted) state = next;
  }

  /// A backup was made at [at]; [auto] when it was an automatic upload.
  Future<void> recordBackup(DateTime at, {bool auto = false}) async {
    await ensureLoaded();
    _set(
      state.copyWith(lastBackupAt: at, lastAutoUploadAt: auto ? at : null),
    );
    await _write((p) async {
      await p.setInt(kLastAt, at.millisecondsSinceEpoch);
      if (auto) await p.setInt(kAutoLastAt, at.millisecondsSinceEpoch);
    });
  }

  // ignore: avoid_positional_boolean_parameters, a switch's own value.
  Future<void> setAutoEnabled(bool on) async {
    await ensureLoaded();
    _set(state.copyWith(autoEnabled: on));
    await _write((p) => p.setBool(kAutoEnabled, on));
  }

  // ignore: avoid_positional_boolean_parameters, a switch's own value.
  Future<void> setReminders(bool on) async {
    await ensureLoaded();
    _set(state.copyWith(remindersOn: on));
    await _write((p) => p.setBool(kReminders, on));
  }

  Future<void> noteCycleEnd(DateTime at) async {
    await ensureLoaded();
    _set(state.copyWith(lastCycleEndAt: at));
    await _write((p) => p.setInt(kLastCycleEndAt, at.millisecondsSinceEpoch));
  }

  Future<void> noteReminder(DateTime at) async {
    await ensureLoaded();
    _set(state.copyWith(lastReminderAt: at));
    await _write((p) => p.setInt(kLastReminderAt, at.millisecondsSinceEpoch));
  }

  /// The next upload number, written down before it is used so two uploads
  /// can never share one.
  Future<int> claimSequence() async {
    await ensureLoaded();
    final next = state.uploadSeq + 1;
    _set(state.copyWith(uploadSeq: next));
    await _write((p) => p.setInt(kUploadSeq, next));
    return next;
  }

  /// A restore is about to replace the saves: pause automatic uploads until
  /// the app has started healthily on the result, and pin the newest backup
  /// made before it. Awaited before the restore touches anything, so the new
  /// app scope reads it back.
  Future<void> noteRestoreStarted() async {
    await ensureLoaded();
    final pin = state.uploadSeq;
    _set(state.copyWith(restorePending: true, preRestoreSeq: pin));
    await _write((p) async {
      await p.setBool(kRestorePending, true);
      await p.setInt(kPreRestoreSeq, pin);
    });
  }

  /// The restored saves opened and checked out: uploads may resume.
  Future<void> clearRestorePending() async {
    await ensureLoaded();
    _set(state.copyWith(restorePending: false));
    await _write((p) => p.setBool(kRestorePending, false));
  }

  Future<void> setDriveEmail(String? email) async {
    await ensureLoaded();
    _set(
      email == null
          ? state.copyWith(clearDriveEmail: true)
          : state.copyWith(driveEmail: email),
    );
    await _write(
      (p) async => email == null
          ? await p.remove(kDriveEmail)
          : await p.setString(kDriveEmail, email),
    );
  }
}

final StateNotifierProvider<BackupSettingsNotifier, BackupSettings>
backupSettingsProvider =
    StateNotifierProvider<BackupSettingsNotifier, BackupSettings>(
      (ref) => BackupSettingsNotifier(),
    );
