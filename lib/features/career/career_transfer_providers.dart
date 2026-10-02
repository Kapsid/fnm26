import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Sharing one career out, and taking one in.
///
/// The whole-database backup in Settings is the safety net; this is the
/// sociable one. It MERGES: importing adds a save rather than replacing what
/// is there, which is what makes it safe to accept a file from somebody else.
class CareerTransferService {
  CareerTransferService(this._ref);

  final Ref _ref;

  /// Writes [careerId] to a file ready to be shared, and returns it.
  ///
  /// Written to the temporary directory: the share sheet copies it wherever
  /// the player wants, and a permanent second copy of a career in app storage
  /// is just a way to run out of room.
  Future<File> export(int careerId, {DateTime? at}) async {
    final db = _ref.read(appDatabaseProvider);
    final bundle = await CareerBundle.export(db, careerId);
    final dir = await getTemporaryDirectory();
    final file = File(
      p.join(
        dir.path,
        CareerBundle.suggestedFileName(
          (bundle['managerName'] as String?) ?? 'career',
          at ?? DateTime.now(),
        ),
      ),
    );
    await file.writeAsBytes(CareerBundle.encode(bundle));
    return file;
  }

  /// The career's copy in the app's own `FNM` folder, written at the end of
  /// every cycle. One file per career, overwritten each time, so it stays the
  /// size of one career: the folder rides in the phone's own backup, and that
  /// has a quota. It lives inside the app, so uninstalling removes it; a copy
  /// off the phone is the saves list's Back up button.
  Future<File> appFolderBackupFile(int careerId) async {
    final dir = await getApplicationDocumentsDirectory();
    return File(
      p.join(dir.path, 'FNM', 'career-$careerId.${CareerBundle.extension}'),
    );
  }

  /// Writes [careerId] to [appFolderBackupFile], replacing the last one.
  Future<File> backupToAppFolder(int careerId) async {
    final file = await appFolderBackupFile(careerId);
    await file.parent.create(recursive: true);
    final bundle = await CareerBundle.export(
      _ref.read(appDatabaseProvider),
      careerId,
    );
    // Written beside and renamed over, so a backup cut short never replaces
    // the good one with half a file.
    final partial = File('${file.path}.partial');
    await partial.writeAsBytes(CareerBundle.encode(bundle), flush: true);
    return partial.rename(file.path);
  }

  /// Removes [careerId]'s app-folder copy, when the career itself is deleted.
  Future<void> removeAppFolderBackup(int careerId) async {
    final file = await appFolderBackupFile(careerId);
    if (file.existsSync()) await file.delete();
  }

  /// Adds the career in [path] as a new save. Returns why it was refused, or
  /// null once it is in.
  Future<BundleRejection?> import(String path) async {
    final read = await CareerBundle.readFile(File(path));
    if (read.rejection != null) return read.rejection;
    await CareerBundle.import(_ref.read(appDatabaseProvider), read.bundle!);
    _ref.invalidate(savesProvider);
    return null;
  }
}

final Provider<CareerTransferService> careerTransferServiceProvider =
    Provider<CareerTransferService>(CareerTransferService.new);
