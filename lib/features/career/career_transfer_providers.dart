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
