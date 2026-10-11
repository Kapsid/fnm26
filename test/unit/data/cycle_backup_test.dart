import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/features/career/career_transfer_providers.dart';
import 'package:path/path.dart' as p;

/// Points the app folder at a temporary directory (path_provider has no
/// platform in a unit test).
class _InTemp extends CareerTransferService {
  _InTemp(super.ref, this.root);

  final Directory root;

  @override
  Future<File> appFolderBackupFile(int careerId) async =>
      File(p.join(root.path, 'FNM', 'career-$careerId.fnmcareer'));
}

/// The end-of-cycle copy in the app's FNM folder: one readable file per
/// career, replaced each cycle rather than piling up (the folder rides in the
/// phone's own backup, which has a quota), and gone with its career.
void main() {
  late AppDatabase db;
  late Directory root;
  late ProviderContainer c;
  late CareerTransferService service;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    root = Directory.systemTemp.createTempSync('fnm-cycle-backup');
    c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        careerTransferServiceProvider.overrideWith((ref) => _InTemp(ref, root)),
      ],
    );
    service = c.read(careerTransferServiceProvider);
  });

  tearDown(() async {
    c.dispose();
    await db.close();
    root.deleteSync(recursive: true);
  });

  Future<int> aCareer(String manager) => db
      .into(db.careers)
      .insert(
        CareersCompanion.insert(
          nationId: 1,
          managerName: manager,
          createdAt: DateTime.utc(2030),
          inGameDate: DateTime.utc(2030, 6, 1),
          rngSeed: 7,
        ),
      );

  test('writes a career file the import can read back', () async {
    final id = await aCareer('Ann');
    final file = await service.backupToAppFolder(id);
    expect(p.basename(p.dirname(file.path)), 'FNM');
    final read = await CareerBundle.readFile(file);
    expect(read.rejection, isNull);
    expect(read.bundle!['managerName'], 'Ann');
  });

  test('a second cycle replaces the first copy, it does not add one', () async {
    final id = await aCareer('Ann');
    await service.backupToAppFolder(id);
    await service.backupToAppFolder(id);
    final files = Directory(p.join(root.path, 'FNM')).listSync();
    expect(files.map((f) => p.basename(f.path)), ['career-$id.fnmcareer']);
  });

  test('deleting the career removes its copy', () async {
    final id = await aCareer('Ann');
    final file = await service.backupToAppFolder(id);
    await service.removeAppFolderBackup(id);
    expect(file.existsSync(), isFalse);
  });
}
