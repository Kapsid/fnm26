import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/cloud/backup_describer.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_meta.dart';

/// The small JSON next to every cloud backup, and reading the careers for it
/// out of a real backup file.
void main() {
  test('round-trips, names with diacritics included', () {
    final meta = CloudBackupMeta(
      createdAt: DateTime.utc(2026, 10, 23, 14, 5),
      deviceId: 'abc123',
      deviceName: 'iPhone 15 Pro',
      platform: 'ios',
      schemaVersion: 50,
      sizeBytes: 1234,
      careers: const [
        BackupCareerSummary(
          managerName: 'Řehoř Šťastný',
          nationName: 'Czechia',
          year: 2038,
        ),
        BackupCareerSummary(managerName: 'Ana', year: 2031),
      ],
    );
    final back = CloudBackupMeta.tryParse(meta.encode())!;
    expect(back.createdAt, meta.createdAt);
    expect(back.deviceId, 'abc123');
    expect(back.deviceName, 'iPhone 15 Pro');
    expect(back.platform, 'ios');
    expect(back.schemaVersion, 50);
    expect(back.sizeBytes, 1234);
    expect(back.careers.first.managerName, 'Řehoř Šťastný');
    expect(back.careers.first.nationName, 'Czechia');
    expect(back.careers.first.year, 2038);
    expect(back.careers.last.nationName, isNull);
  });

  test('anything that is not ours reads as null, never throws', () {
    expect(CloudBackupMeta.tryParse(null), isNull);
    expect(CloudBackupMeta.tryParse(''), isNull);
    expect(CloudBackupMeta.tryParse('not json'), isNull);
    expect(CloudBackupMeta.tryParse('[1,2]'), isNull);
    expect(CloudBackupMeta.tryParse('{"app":"other"}'), isNull);
    expect(CloudBackupMeta.tryParse('{"app":"fnm"}'), isNull);
  });

  test('missing fields are tolerated', () {
    final m = CloudBackupMeta.tryParse(
      '{"app":"fnm","createdAt":"2026-10-23T10:00:00Z","careers":[{"x":1}]}',
    )!;
    expect(m.deviceName, '');
    expect(m.careers.single.managerName, '');
    expect(m.careers.single.year, 0);
  });

  test('careers are read from the backup file itself', () async {
    final dir = await Directory.systemTemp.createTemp('fnm_meta');
    addTearDown(() => dir.delete(recursive: true));
    final path = '${dir.path}/save.sqlite';
    final db = AppDatabase.forTesting(NativeDatabase(File(path)));
    await db.customStatement(
      'INSERT INTO nations (id, name, code, confederation) '
      "VALUES (7, 'Czechia', 'CZE', 'europe')",
    );
    await db
        .into(db.careers)
        .insert(
          CareersCompanion.insert(
            nationId: 7,
            managerName: 'Pavel',
            createdAt: DateTime.utc(2030),
            inGameDate: DateTime.utc(2036, 6, 1),
            rngSeed: 7,
          ),
        );
    await db.close();
    final careers = careersInBackup(path);
    expect(careers.single.managerName, 'Pavel');
    expect(careers.single.nationName, 'Czechia');
    expect(careers.single.year, 2036);
    expect(careersInBackup('${dir.path}/missing.sqlite'), isEmpty);
  });
}
