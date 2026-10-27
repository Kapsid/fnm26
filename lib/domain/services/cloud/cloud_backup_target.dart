import 'dart:io';

/// Where an automatic backup goes. One per platform: iCloud on Apple devices,
/// the Google Drive app folder on Android. Moving between the two stays a
/// manual job (a backup file, shared and picked back up).
enum CloudProvider { icloud, googleDrive }

/// Whether a [CloudBackupTarget] can be used right now, in words the settings
/// screen can turn into one calm status line.
enum CloudAvailability {
  /// Ready: signed in, entitled, reachable.
  available,

  /// The account is missing: signed out of iCloud or iCloud Drive off, or
  /// not signed in with Google.
  signedOut,

  /// This build is not set up for it (no iCloud entitlement, no OAuth client).
  /// Nothing the player can fix; the feature is simply off.
  notConfigured,

  /// Anything else: no network, the service refusing, an unexpected error.
  unavailable,
}

/// One file in a target's backup folder.
class CloudFile {
  const CloudFile({
    required this.name,
    this.size,
    this.modified,
    this.uploaded = true,
  });

  /// The bare file name, no folders.
  final String name;
  final int? size;

  /// When the service says the file last changed (Drive's server time; on
  /// iCloud the container file's change date).
  final DateTime? modified;

  /// Whether the file has actually reached the cloud. Always true on Drive,
  /// where a file exists only once uploaded. On iCloud a file copied into the
  /// container is uploaded by iOS later, maybe days later, and until then it
  /// exists only on this phone: rotation must not count it as a backup.
  final bool uploaded;
}

/// A folder in somebody's cloud storage, reduced to the six things a backup
/// needs from it.
///
/// Everything above this works on names in ONE flat folder that belongs to the
/// app alone (the iCloud container's backup folder, Drive's hidden app data
/// folder), so the rotation and listing logic can be tested against a fake
/// without a phone, an Apple ID or a Google account.
///
/// Every method may throw; callers treat a throw as "the cloud said no" and
/// carry on. Nothing here is ever allowed to take the game down with it.
abstract interface class CloudBackupTarget {
  CloudProvider get provider;

  /// Whether the target is usable now. Never throws.
  Future<CloudAvailability> availability();

  /// Copies [local] into the folder as [name], replacing any file of that name.
  Future<void> upload(File local, String name);

  /// Writes a small text file (the metadata next to a backup).
  Future<void> writeText(String name, String text);

  /// Every file in the folder, including ones another device put there and
  /// this one has not downloaded yet.
  Future<List<CloudFile>> list();

  /// A small text file's contents, or null when it is not there.
  Future<String?> readText(String name);

  /// Copies [name] out of the folder to [toPath] on this device.
  Future<void> download(String name, String toPath);

  /// Removes [name] from the folder. Only ever called by the keep-two rotation
  /// on this device's own older backups.
  Future<void> delete(String name);
}
