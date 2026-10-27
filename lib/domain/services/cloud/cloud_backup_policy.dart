import 'package:fnm/domain/services/cloud/cloud_backup_meta.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_target.dart';

/// What asked for an automatic backup.
enum BackupTrigger {
  /// The app went to the background.
  appBackground,

  /// A match or a window was committed.
  committed,

  /// A cycle ended (the rollover into the next one).
  cycleEnd,
}

/// What an automatic-backup request came to.
enum UploadDecision {
  upload,

  /// The toggle is off.
  disabled,

  /// One is already running.
  busy,

  /// The last upload was too recent: [kAutoBackupMinGap], or
  /// [kAutoBackupBackgroundGap] when the app is going to the background.
  throttled,

  /// Nothing has been written since the last upload.
  unchanged,
}

/// At most one automatic upload in this long for match, window and cycle-end
/// triggers.
const Duration kAutoBackupMinGap = Duration(minutes: 30);

/// The shorter gap when the app goes to the background with changes: it may
/// be the last chance before the phone is put away (or lost), so up to half
/// an hour of play is not left behind.
const Duration kAutoBackupBackgroundGap = Duration(minutes: 5);

/// How many of its newest automatic backups each device keeps in the cloud.
const int kAutoBackupsKept = 2;

/// The "last week" anchor: besides the newest [kAutoBackupsKept], rotation
/// keeps the newest backup at least this much older than the latest one.
const Duration kAutoBackupAnchorAge = Duration(days: 7);

/// The reminder fires when the last backup is this old...
const Duration kBackupReminderAfter = Duration(days: 14);

/// ...or a cycle has ended since it, once it is at least this old (so a
/// rollover an hour after a backup does not nag).
const Duration kBackupReminderCycleGap = Duration(days: 1);

/// And never more often than this.
const Duration kBackupReminderEvery = Duration(days: 7);

/// Whether an automatic upload should run now.
///
/// [lastChangeAt] is when the save data was last written (null when it cannot
/// be told, which counts as changed: a backup too many is cheap, one too few
/// is the thing this exists to prevent). A clock that has gone backwards past
/// the last upload does not hold uploads off until it catches up.
UploadDecision decideUpload({
  required bool enabled,
  required bool busy,
  required DateTime now,
  DateTime? lastUploadAt,
  DateTime? lastChangeAt,
  BackupTrigger trigger = BackupTrigger.committed,
}) {
  if (!enabled) return UploadDecision.disabled;
  if (busy) return UploadDecision.busy;
  if (lastUploadAt == null) return UploadDecision.upload;
  if (lastChangeAt != null && !lastChangeAt.isAfter(lastUploadAt)) {
    return UploadDecision.unchanged;
  }
  final gap = trigger == BackupTrigger.appBackground
      ? kAutoBackupBackgroundGap
      : kAutoBackupMinGap;
  if (!now.isBefore(lastUploadAt) && now.difference(lastUploadAt) < gap) {
    return UploadDecision.throttled;
  }
  return UploadDecision.upload;
}

/// The files to remove from a cloud folder holding [files] after device
/// [deviceId] has just uploaded [justUploaded].
///
/// Only this device's own automatic backups are ever candidates: two phones on
/// one account never rotate each other's backups away, and nothing that is
/// not an automatic backup is touched. Of this device's backups, these stay:
///
///  * [justUploaded], always, whatever its name says;
///  * the newest [keep], ordered by upload number (then server time), never
///    by the clock in the name, so a clock that was once wrong cannot make
///    the newest backup sort as the oldest;
///  * the newest [keep] that have actually REACHED the cloud
///    ([CloudFile.uploaded]): on iCloud a backup copied into the container
///    can wait days for iOS to upload it, and deleting the uploaded ones in
///    the meantime would leave copies that exist only on the phone;
///  * a "last week" anchor: the newest uploaded backup at least
///    [kAutoBackupAnchorAge] older than the latest, so a run of bad uploads
///    (an older state restored, a broken save) within a few days cannot push
///    every good backup out;
///  * the pre-restore pin: when the player has restored, the newest uploaded
///    backup numbered at or below [preRestoreSeq], which is the progress he
///    had before restoring. It is kept until the next restore moves the pin.
///
/// Everything else of this device's goes, each with its metadata file.
List<String> namesToPrune(
  Iterable<CloudFile> files, {
  required String deviceId,
  required String justUploaded,
  int? preRestoreSeq,
  int keep = kAutoBackupsKept,
}) {
  final all = {for (final f in files) f.name};
  final mine =
      <({String name, int seq, DateTime at, bool uploaded})>[
        for (final f in files)
          if (CloudBackupNames.parse(f.name) case final p?
              when p.deviceId == deviceId)
            (
              name: f.name,
              seq: p.seq,
              at: f.modified?.toUtc() ?? p.at,
              uploaded: f.uploaded,
            ),
      ]..sort((a, b) {
        final bySeq = b.seq.compareTo(a.seq);
        return bySeq != 0 ? bySeq : b.at.compareTo(a.at);
      });
  if (mine.isEmpty) return const [];
  final confirmed = [
    for (final m in mine)
      if (m.uploaded) m,
  ];
  final kept = <String>{
    justUploaded,
    for (final m in mine.take(keep)) m.name,
    for (final m in confirmed.take(keep)) m.name,
  };
  final latestAt = mine.first.at;
  for (final m in confirmed) {
    if (!m.at.isAfter(latestAt.subtract(kAutoBackupAnchorAge))) {
      kept.add(m.name);
      break;
    }
  }
  if (preRestoreSeq != null) {
    for (final m in confirmed) {
      if (m.seq <= preRestoreSeq && m.name != justUploaded) {
        kept.add(m.name);
        break;
      }
    }
  }
  return [
    for (final m in mine)
      if (!kept.contains(m.name)) ...[
        m.name,
        if (all.contains(CloudBackupNames.metaNameFor(m.name)))
          CloudBackupNames.metaNameFor(m.name),
      ],
  ];
}

/// Whether the in-game "back up your saves" reminder is due.
///
/// [firstSeenAt] stands in for the last backup on a phone that has never made
/// one, so a new player is not greeted with a nag on his first day.
bool backupReminderDue({
  required bool enabled,
  required DateTime now,
  required DateTime firstSeenAt,
  DateTime? lastBackupAt,
  DateTime? lastCycleEndAt,
  DateTime? lastReminderAt,
}) {
  if (!enabled) return false;
  if (lastReminderAt != null &&
      !now.isBefore(lastReminderAt) &&
      now.difference(lastReminderAt) < kBackupReminderEvery) {
    return false;
  }
  final since = lastBackupAt ?? firstSeenAt;
  final age = now.difference(since);
  if (age >= kBackupReminderAfter) return true;
  return lastCycleEndAt != null &&
      lastCycleEndAt.isAfter(since) &&
      age >= kBackupReminderCycleGap;
}
