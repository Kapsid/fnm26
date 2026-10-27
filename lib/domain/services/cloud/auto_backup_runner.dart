import 'dart:async';
import 'dart:io';

import 'package:fnm/domain/services/cloud/cloud_backup_meta.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_policy.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_store.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_target.dart';

/// The persisted state an automatic backup reads and writes.
abstract interface class AutoBackupLedger {
  /// Whether the player has switched automatic backup on.
  bool get enabled;

  /// True from a restore until the first healthy start after it. A restore
  /// that went wrong must never be uploaded over the good backups.
  bool get paused;

  /// When the last automatic upload finished, or null.
  DateTime? get lastUploadAt;

  /// The upload number at the last restore, or null: the pre-restore pin
  /// (see [namesToPrune]).
  int? get preRestoreSeq;

  /// The next upload number, persisted before it is used.
  Future<int> claimSequence();

  /// Writes down a finished upload started at [at].
  Future<void> recordUpload(DateTime at);
}

/// How one automatic-backup request ended.
enum AutoBackupResult {
  uploaded,
  disabled,

  /// Another upload was running, in this app scope or the one a restore
  /// replaced, or a restore is under way.
  busy,

  /// Paused after a restore until the app has started healthily.
  paused,

  /// The simulation was mid-operation. The operation's own completion
  /// triggers the backup again, so nothing is lost.
  postponed,
  throttled,
  unchanged,

  /// The target was not usable; see the outcome's `availability`.
  unavailable,

  /// Something threw on the way; see the outcome's `error`.
  failed,
}

/// The result, plus whatever the status line needs to explain it.
typedef AutoBackupOutcome = ({
  AutoBackupResult result,
  CloudAvailability? availability,
  Object? error,
});

/// Decides whether an automatic backup is due and, if so, makes one.
///
/// Every dependency is passed in so the throttle, the change check, the
/// single-flight guard and the rotation are tested with fakes; see
/// `CloudBackupService` for the real wiring. [run] never throws.
///
/// The single-flight guard is PROCESS-WIDE (static), not per runner: a restore
/// rebuilds the whole provider scope, and with it a new runner, while an
/// upload from the old scope may still be going. The restore also waits for
/// it ([whenIdle]) and holds new ones off ([holdOff]) while it swaps files.
class AutoBackupRunner {
  AutoBackupRunner({
    required this.target,
    required this.ledger,
    required this.snapshot,
    required this.describe,
    required this.lastChangeAt,
    this.isSimBusy,
    this.onStart,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final CloudBackupTarget target;
  final AutoBackupLedger ledger;

  /// Writes a fresh whole-database snapshot to a temporary file of its own.
  final Future<File> Function() snapshot;

  /// The metadata for a [snapshot] taken at the given moment with the given
  /// upload number.
  final Future<CloudBackupMeta> Function(File snapshot, DateTime at, int seq)
  describe;

  /// When the save data was last written, or null if that cannot be told.
  final Future<DateTime?> Function() lastChangeAt;

  /// Whether the simulation is in the middle of a multi-transaction step. A
  /// snapshot then could hold a half-advanced world.
  final bool Function()? isSimBusy;

  /// Told when an upload actually begins (after every check has passed).
  final void Function()? onStart;

  final DateTime Function() _clock;

  static Completer<void>? _running;
  static int _holds = 0;

  /// Whether an upload is under way anywhere in the process.
  static bool get anyRunning => _running != null;

  /// Whether an upload is under way.
  bool get busy => anyRunning;

  /// Completes once no upload is running (or after [timeout]).
  static Future<void> whenIdle({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final running = _running;
    if (running == null) return;
    await running.future.timeout(timeout, onTimeout: () {});
  }

  /// Turns new uploads away until the returned callback is called. A restore
  /// holds them off while it swaps the database file.
  static void Function() holdOff() {
    _holds++;
    var released = false;
    return () {
      if (released) return;
      released = true;
      _holds--;
    };
  }

  /// Handles one request from [trigger].
  Future<AutoBackupOutcome> run(BackupTrigger trigger) async {
    if (_running != null || _holds > 0) return _skip(AutoBackupResult.busy);
    // Claimed before the first await, so a second trigger in the same frame
    // (or from another scope) sees it.
    final mine = _running = Completer<void>();
    File? file;
    try {
      if (!ledger.enabled) return _skip(AutoBackupResult.disabled);
      if (ledger.paused) return _skip(AutoBackupResult.paused);
      if (isSimBusy?.call() ?? false) return _skip(AutoBackupResult.postponed);
      final now = _clock();
      DateTime? changed;
      try {
        changed = await lastChangeAt();
      } on Object {
        changed = null;
      }
      final decision = decideUpload(
        enabled: true,
        busy: false,
        now: now,
        lastUploadAt: ledger.lastUploadAt,
        lastChangeAt: changed,
        trigger: trigger,
      );
      switch (decision) {
        case UploadDecision.disabled:
          return _skip(AutoBackupResult.disabled);
        case UploadDecision.busy:
          return _skip(AutoBackupResult.busy);
        case UploadDecision.throttled:
          return _skip(AutoBackupResult.throttled);
        case UploadDecision.unchanged:
          return _skip(AutoBackupResult.unchanged);
        case UploadDecision.upload:
          break;
      }
      final availability = await target.availability();
      if (availability != CloudAvailability.available) {
        return (
          result: AutoBackupResult.unavailable,
          availability: availability,
          error: null,
        );
      }
      // Checked again after the awaits: the sim may have started meanwhile.
      if (isSimBusy?.call() ?? false) return _skip(AutoBackupResult.postponed);
      onStart?.call();
      file = await snapshot();
      final seq = await ledger.claimSequence();
      final meta = await describe(file, now, seq);
      await CloudBackupStore(
        target,
      ).push(snapshot: file, meta: meta, preRestoreSeq: ledger.preRestoreSeq);
      await ledger.recordUpload(now);
      return (
        result: AutoBackupResult.uploaded,
        availability: availability,
        error: null,
      );
    } on Object catch (e) {
      return (result: AutoBackupResult.failed, availability: null, error: e);
    } finally {
      // The temporary snapshot only; the cloud copy is the backup now.
      try {
        if (file != null && file.existsSync()) await file.delete();
      } on Object {
        // A stray temp file is the OS's to clear.
      }
      if (identical(_running, mine)) _running = null;
      mine.complete();
    }
  }

  static AutoBackupOutcome _skip(AutoBackupResult r) =>
      (result: r, availability: null, error: null);
}
