import 'dart:io';

import 'package:fnm/domain/services/cloud/cloud_backup_meta.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_policy.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_target.dart';

/// One automatic backup as the restore list shows it.
class CloudBackupEntry {
  const CloudBackupEntry({
    required this.saveName,
    required this.at,
    required this.deviceId,
    this.meta,
    this.size,
  });

  /// The backup file's name in the cloud folder.
  final String saveName;

  /// When it was made.
  final DateTime at;

  final String deviceId;

  /// What the metadata file says, or null when it could not be read.
  final CloudBackupMeta? meta;

  final int? size;
}

/// Automatic backups in one cloud folder: putting one there (and rotating the
/// old ones out), listing what is there, and fetching one back.
///
/// Knows nothing about iCloud or Drive; see [CloudBackupTarget].
class CloudBackupStore {
  const CloudBackupStore(this.target, {this.metaPatience = defaultPatience});

  final CloudBackupTarget target;

  /// How long the listing waits for any one metadata file. They are read in
  /// parallel, so this is roughly the longest the restore list can take; a
  /// metadata file still on its way from another device leaves its backup
  /// listed without details instead of holding the list up.
  final Duration metaPatience;

  /// The default [metaPatience].
  static const Duration defaultPatience = Duration(seconds: 8);

  /// Uploads [snapshot] with [meta] beside it, then rotates this device's
  /// older backups out as [namesToPrune] decides ([preRestoreSeq] is the
  /// pre-restore pin).
  ///
  /// The new one goes up FIRST and the old ones only come down once it is
  /// there, so a failure at any point leaves at least as many good backups as
  /// before. A failed delete is shrugged off: the next upload retries it.
  Future<void> push({
    required File snapshot,
    required CloudBackupMeta meta,
    int? preRestoreSeq,
  }) async {
    final name = CloudBackupNames.saveName(
      meta.deviceId,
      meta.createdAt,
      seq: meta.seq,
    );
    await target.upload(snapshot, name);
    await target.writeText(CloudBackupNames.metaNameFor(name), meta.encode());
    final present = await target.list();
    // A listing that does not show the new file yet (iCloud's metadata
    // index lags) still has it, conservatively as not yet uploaded.
    final files = [
      ...present,
      if (!present.any((f) => f.name == name))
        CloudFile(name: name, uploaded: false),
    ];
    final prune = namesToPrune(
      files,
      deviceId: meta.deviceId,
      justUploaded: name,
      preRestoreSeq: preRestoreSeq,
    );
    for (final old in prune) {
      try {
        await target.delete(old);
      } on Object {
        // Left for the next rotation.
      }
    }
  }

  /// Every automatic backup in the folder, newest first, from every device on
  /// the account. A metadata file that cannot be read leaves its backup listed
  /// with what its name says.
  Future<List<CloudBackupEntry>> list() async {
    final files = await target.list();
    Future<CloudBackupEntry?> read(CloudFile f) async {
      final parsed = CloudBackupNames.parse(f.name);
      if (parsed == null) return null;
      CloudBackupMeta? meta;
      try {
        meta = CloudBackupMeta.tryParse(
          await target
              .readText(CloudBackupNames.metaNameFor(f.name))
              .timeout(metaPatience),
        );
      } on Object {
        meta = null;
      }
      return CloudBackupEntry(
        saveName: f.name,
        at: meta?.createdAt ?? parsed.at,
        deviceId: parsed.deviceId,
        meta: meta,
        size: f.size ?? meta?.sizeBytes,
      );
    }

    final entries = [
      for (final e in await Future.wait(files.map(read))) ?e,
    ]..sort((a, b) => b.at.compareTo(a.at));
    return entries;
  }

  /// Copies [entry] down to [toPath].
  Future<void> fetch(CloudBackupEntry entry, String toPath) =>
      target.download(entry.saveName, toPath);
}
