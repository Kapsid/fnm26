import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/save_backup.dart';
import 'package:fnm/features/settings/save_backup_providers.dart';
import 'package:sqlite3/sqlite3.dart';

/// A restore (from a file or from the cloud, they share this path) keeps a
/// copy of the saves already on the phone BEFORE it touches anything, and
/// refuses outright when it cannot.
class _Recording extends SaveBackupService {
  // ignore: use_super_parameters, the ref is kept for the safety copy too.
  _Recording(Ref ref, this.safetyDir) : _r = ref, super(ref);

  final Ref _r;
  final Directory safetyDir;
  final List<String> steps = [];
  bool failSafety = false;

  @override
  Future<File> writeSafetyCopy({String? protect}) async {
    steps.add('safety');
    if (failSafety) throw const FileSystemException('disk full');
    final copy = await SaveBackup.writeSafetyCopy(
      _r.read(appDatabaseProvider),
      safetyDir,
      DateTime(2026, 10, 23, 14, 5, 9),
    );
    await SaveBackup.pruneSafetyCopies(safetyDir, protect: protect);
    return copy;
  }

  @override
  Future<void> noteRestoreStarted() async => steps.add('pause-uploads');

  @override
  Future<void> closeDatabase() async => steps.add('close');

  @override
  Future<BackupRejection?> replaceLive(String path) async {
    steps.add('replace');
    return null;
  }

  @override
  void restartApp() => steps.add('restart');
}

void main() {
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('fnm_safety');
  });

  tearDown(() async {
    if (dir.existsSync()) await dir.delete(recursive: true);
  });

  Future<String> aSave(String name, String manager) async {
    final path = '${dir.path}/$name.sqlite';
    final db = AppDatabase.forTesting(NativeDatabase(File(path)));
    await db
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
    await db.close();
    return path;
  }

  test(
    'the safety copy is written first and holds the current saves',
    () async {
      final livePath = await aSave('live', 'Current');
      final incoming = await aSave('incoming', 'FromBackup');
      final live = AppDatabase.forTesting(NativeDatabase(File(livePath)));
      addTearDown(live.close);
      final safety = Directory('${dir.path}/safety');
      late _Recording service;
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(live),
          saveBackupServiceProvider.overrideWith(
            (ref) => service = _Recording(ref, safety),
          ),
        ],
      );
      addTearDown(container.dispose);
      container.read(saveBackupServiceProvider);

      final refusal = await service.restore(incoming);

      expect(refusal, isNull);
      expect(service.steps, [
        'safety',
        'pause-uploads',
        'close',
        'replace',
        'restart',
      ]);
      final copies = safety.listSync().whereType<File>().toList();
      expect(copies, hasLength(1));
      expect(copies.single.path, endsWith('.fnmsave'));
      final read = sqlite3.open(copies.single.path, mode: OpenMode.readOnly);
      addTearDown(read.close);
      expect(
        read.select('SELECT manager_name FROM careers').single['manager_name'],
        'Current',
      );
    },
  );

  test('no safety copy, no restore', () async {
    final livePath = await aSave('live', 'Current');
    final incoming = await aSave('incoming', 'FromBackup');
    final live = AppDatabase.forTesting(NativeDatabase(File(livePath)));
    addTearDown(live.close);
    late _Recording service;
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(live),
        saveBackupServiceProvider.overrideWith(
          (ref) =>
              service = _Recording(ref, Directory('${dir.path}/s'))
                ..failSafety = true,
        ),
      ],
    );
    addTearDown(container.dispose);
    container.read(saveBackupServiceProvider);

    final refusal = await service.restore(incoming);

    expect(refusal, BackupRejection.safetyCopyFailed);
    expect(service.steps, ['safety'], reason: 'nothing closed or replaced');
  });

  test('a bad file is refused before even the safety copy', () async {
    final livePath = await aSave('live', 'Current');
    final junk = File('${dir.path}/junk.fnmsave')..writeAsStringSync('nope');
    final live = AppDatabase.forTesting(NativeDatabase(File(livePath)));
    addTearDown(live.close);
    late _Recording service;
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(live),
        saveBackupServiceProvider.overrideWith(
          (ref) => service = _Recording(ref, Directory('${dir.path}/s')),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.read(saveBackupServiceProvider);

    expect(await service.restore(junk.path), BackupRejection.unreadable);
    expect(service.steps, isEmpty);
  });
}
