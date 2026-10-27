import 'dart:async';
import 'dart:io';

import 'package:fnm/core/config/cloud_config.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_target.dart';
import 'package:icloud_storage_plus/icloud_storage.dart';
import 'package:path/path.dart' as p;

/// Automatic backups in the app's own iCloud container.
///
/// Files are copied INTO the container on this device; iOS uploads them in
/// the background on its own schedule, and brings them down on the player's
/// other iPhones and iPads signed into the same Apple ID. So an "upload" here
/// is a local, coordinated file copy and is quick; it is iCloud, not the app,
/// that needs the network.
///
/// The folder is `Documents/` in the container. It is not published to the
/// Files app (no `NSUbiquitousContainers` entry), so the player cannot delete
/// a backup by accident while tidying iCloud Drive.
class ICloudBackupTarget implements CloudBackupTarget {
  ICloudBackupTarget({this.containerId = kICloudContainerId});

  final String containerId;

  static const String _folder = 'Documents';

  /// How long a listing or a metadata read may wait on iCloud before it is
  /// given up on: a file still on its way from another device must not hang
  /// the restore list.
  static const Duration _patience = Duration(seconds: 20);

  /// For one metadata file: the restore list reads them all in parallel and
  /// lists a backup without details rather than wait on one still on its way.
  static const Duration _metaPatience = Duration(seconds: 8);

  @override
  CloudProvider get provider => CloudProvider.icloud;

  String _rel(String name) => '$_folder/$name';

  @override
  Future<CloudAvailability> availability() async {
    if (!kICloudEnabled || (!Platform.isIOS && !Platform.isMacOS)) {
      return CloudAvailability.notConfigured;
    }
    try {
      // Signed in to iCloud with iCloud Drive on.
      if (!await ICloudStorage.icloudAvailable()) {
        return CloudAvailability.signedOut;
      }
    } on Object {
      return CloudAvailability.unavailable;
    }
    try {
      // No container path means the build has no iCloud entitlement for it.
      final path = await ICloudStorage.getContainerPath(
        containerId: containerId,
      ).timeout(_patience);
      return path == null || path.isEmpty
          ? CloudAvailability.notConfigured
          : CloudAvailability.available;
    } on TimeoutException {
      return CloudAvailability.unavailable;
    } on Object {
      return CloudAvailability.notConfigured;
    }
  }

  @override
  Future<void> upload(File local, String name) => ICloudStorage.uploadFile(
    containerId: containerId,
    localPath: local.path,
    relativePath: _rel(name),
  );

  @override
  Future<void> writeText(String name, String text) =>
      ICloudStorage.writeInPlace(
        containerId: containerId,
        relativePath: _rel(name),
        contents: text,
      );

  @override
  Future<List<CloudFile>> list() async {
    // The metadata query rather than a directory listing: it also finds files
    // another device has put there that this one has not downloaded yet,
    // which is the whole point of restoring on a new iPhone.
    final result = await ICloudStorage.gather(
      containerId: containerId,
    ).timeout(_patience);
    return [
      for (final f in result.files)
        if (!f.isDirectory && p.posix.dirname(f.relativePath) == _folder)
          CloudFile(
            name: p.posix.basename(f.relativePath),
            size: f.sizeInBytes,
            modified: f.contentChangeDate,
            // Copied into the container is not the same as in iCloud: iOS
            // may take days to upload it. Rotation only trusts this.
            uploaded: f.isUploaded,
          ),
    ];
  }

  @override
  Future<String?> readText(String name) async {
    try {
      // A coordinated read brings the file down first if it is not here yet.
      return await ICloudStorage.readInPlace(
        containerId: containerId,
        relativePath: _rel(name),
      ).timeout(_metaPatience);
    } on ICloudItemNotFoundException {
      return null;
    }
  }

  @override
  Future<void> download(String name, String toPath) =>
      ICloudStorage.downloadFile(
        containerId: containerId,
        relativePath: _rel(name),
        localPath: toPath,
      );

  @override
  Future<void> delete(String name) =>
      ICloudStorage.delete(containerId: containerId, relativePath: _rel(name));
}
