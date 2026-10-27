import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/cloud/auto_backup_runner.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_meta.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_policy.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_store.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_target.dart';
import 'package:fnm/domain/services/cloud/fake_cloud_backup_target.dart';

class _Ledger implements AutoBackupLedger {
  @override
  bool enabled = true;

  @override
  bool paused = false;

  @override
  DateTime? lastUploadAt;

  @override
  int? preRestoreSeq;

  int seq = 0;

  @override
  Future<int> claimSequence() async => ++seq;

  final List<DateTime> recorded = [];

  @override
  Future<void> recordUpload(DateTime at) async {
    recorded.add(at);
    lastUploadAt = at;
  }
}

/// The automatic backup end to end against an in-memory cloud: triggers,
/// throttling, the change check, one-at-a-time, rotation and metadata.
void main() {
  late Directory dir;
  late FakeCloudBackupTarget cloud;
  late _Ledger ledger;
  late DateTime now;
  late DateTime? changedAt;
  late int snapshots;
  late bool simBusy;
  Completer<void>? snapshotGate;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('fnm_cloud');
    cloud = FakeCloudBackupTarget();
    ledger = _Ledger();
    now = DateTime.utc(2026, 10, 23, 12);
    changedAt = now;
    snapshots = 0;
    simBusy = false;
    snapshotGate = null;
  });

  tearDown(() async {
    if (dir.existsSync()) await dir.delete(recursive: true);
  });

  AutoBackupRunner runner({String device = 'dev1', _Ledger? own}) =>
      AutoBackupRunner(
        target: cloud,
        ledger: own ?? ledger,
        isSimBusy: () => simBusy,
        clock: () => now,
        lastChangeAt: () async => changedAt,
        snapshot: () async {
          await snapshotGate?.future;
          snapshots++;
          final f = File('${dir.path}/snap$snapshots.fnmsave');
          await f.writeAsString('save #$snapshots');
          return f;
        },
        describe: (file, at, seq) async => CloudBackupMeta(
          seq: seq,
          createdAt: at,
          deviceId: device,
          deviceName: 'Test Phone',
          platform: 'ios',
          schemaVersion: 50,
          sizeBytes: file.lengthSync(),
          careers: const [
            BackupCareerSummary(
              managerName: 'Ota',
              nationName: 'Czechia',
              year: 2034,
            ),
          ],
        ),
      );

  Iterable<String> saves() =>
      cloud.files.keys.where((k) => k.endsWith('.fnmsave'));

  test('every trigger uploads when due, and records it', () async {
    for (final trigger in BackupTrigger.values) {
      final r = runner();
      final out = await r.run(trigger);
      expect(out.result, AutoBackupResult.uploaded, reason: trigger.name);
      now = now.add(const Duration(hours: 1));
      changedAt = now;
    }
    expect(ledger.recorded, hasLength(3));
  });

  test('throttled within 30 minutes, even when the save changed', () async {
    final r = runner();
    expect(
      (await r.run(BackupTrigger.committed)).result,
      AutoBackupResult.uploaded,
    );
    now = now.add(const Duration(minutes: 10));
    changedAt = now;
    expect(
      (await r.run(BackupTrigger.cycleEnd)).result,
      AutoBackupResult.throttled,
    );
    expect(
      (await r.run(BackupTrigger.committed)).result,
      AutoBackupResult.throttled,
    );
    now = now.add(const Duration(minutes: 25));
    expect(
      (await r.run(BackupTrigger.appBackground)).result,
      AutoBackupResult.uploaded,
    );
    expect(cloud.uploads, 2);
  });

  test('skipped when nothing changed since the last upload', () async {
    final r = runner();
    await r.run(BackupTrigger.committed);
    now = now.add(const Duration(hours: 3));
    // The last write is still the one before the upload.
    expect(
      (await r.run(BackupTrigger.appBackground)).result,
      AutoBackupResult.unchanged,
    );
    expect(snapshots, 1, reason: 'no snapshot is even taken');
  });

  test('off: nothing happens', () async {
    ledger.enabled = false;
    expect(
      (await runner().run(BackupTrigger.committed)).result,
      AutoBackupResult.disabled,
    );
    expect(cloud.files, isEmpty);
  });

  test('a second trigger while one runs is turned away', () async {
    final r = runner();
    snapshotGate = Completer<void>();
    final first = r.run(BackupTrigger.committed);
    final second = await r.run(BackupTrigger.appBackground);
    expect(second.result, AutoBackupResult.busy);
    snapshotGate!.complete();
    expect((await first).result, AutoBackupResult.uploaded);
    expect(cloud.uploads, 1);
  });

  test('unavailable cloud: reported, nothing recorded, never throws', () async {
    cloud.state = CloudAvailability.signedOut;
    final out = await runner().run(BackupTrigger.committed);
    expect(out.result, AutoBackupResult.unavailable);
    expect(out.availability, CloudAvailability.signedOut);
    expect(ledger.recorded, isEmpty);
    expect(snapshots, 0);
  });

  test('a failed upload is reported and leaves the old backups', () async {
    final r = runner();
    await r.run(BackupTrigger.committed);
    now = now.add(const Duration(hours: 1));
    changedAt = now;
    cloud.failNextUpload = true;
    final out = await r.run(BackupTrigger.committed);
    expect(out.result, AutoBackupResult.failed);
    expect(saves(), hasLength(1));
    expect(ledger.recorded, hasLength(1));
  });

  test('keeps the latest and one previous, per device', () async {
    // Another device's backups are on the same account.
    final other = runner(device: 'dev2', own: _Ledger());
    await other.run(BackupTrigger.committed);
    final r = runner();
    for (var i = 0; i < 4; i++) {
      now = now.add(const Duration(hours: 1));
      changedAt = now;
      await r.run(BackupTrigger.committed);
    }
    final mine = saves().where((n) => n.contains('-dev1-')).toList()..sort();
    expect(mine, hasLength(2));
    expect(mine.last, CloudBackupNames.saveName('dev1', now, seq: ledger.seq));
    expect(saves().where((n) => n.contains('-dev2-')), hasLength(1));
    // Every remaining backup still has its metadata; none is orphaned.
    for (final s in saves()) {
      expect(cloud.files.containsKey(CloudBackupNames.metaNameFor(s)), isTrue);
    }
  });

  test('a failed delete in the rotation does not fail the backup', () async {
    final r = runner();
    for (var i = 0; i < 2; i++) {
      await r.run(BackupTrigger.committed);
      now = now.add(const Duration(hours: 1));
      changedAt = now;
    }
    cloud.undeletable.addAll(cloud.files.keys);
    expect(
      (await r.run(BackupTrigger.committed)).result,
      AutoBackupResult.uploaded,
    );
  });

  test('while the simulation is mid-step: postponed, nothing taken', () async {
    simBusy = true;
    for (final t in BackupTrigger.values) {
      expect((await runner().run(t)).result, AutoBackupResult.postponed);
    }
    expect(snapshots, 0);
    expect(cloud.files, isEmpty);
    // The step ends and its own completion trigger runs: now it uploads.
    simBusy = false;
    expect(
      (await runner().run(BackupTrigger.committed)).result,
      AutoBackupResult.uploaded,
    );
  });

  test('paused after a restore until a healthy start', () async {
    ledger.paused = true;
    expect(
      (await runner().run(BackupTrigger.committed)).result,
      AutoBackupResult.paused,
    );
    expect(snapshots, 0);
    ledger.paused = false;
    expect(
      (await runner().run(BackupTrigger.committed)).result,
      AutoBackupResult.uploaded,
    );
  });

  test(
    'one upload per process: a second runner (a restarted scope) waits',
    () async {
      snapshotGate = Completer<void>();
      final first = runner().run(BackupTrigger.committed);
      // A brand-new runner, as the in-app restart after a restore builds.
      final second = await runner().run(BackupTrigger.appBackground);
      expect(second.result, AutoBackupResult.busy);
      var idle = false;
      final waiting = AutoBackupRunner.whenIdle().then((_) => idle = true);
      await Future<void>.delayed(Duration.zero);
      expect(idle, isFalse);
      snapshotGate!.complete();
      await first;
      await waiting;
      expect(idle, isTrue);
      expect(cloud.uploads, 1);
    },
  );

  test('held off during a restore', () async {
    final release = AutoBackupRunner.holdOff();
    expect(
      (await runner().run(BackupTrigger.committed)).result,
      AutoBackupResult.busy,
    );
    release();
    expect(
      (await runner().run(BackupTrigger.committed)).result,
      AutoBackupResult.uploaded,
    );
  });

  test(
    'going to the background skips the 30-minute wait when changed',
    () async {
      final r = runner();
      await r.run(BackupTrigger.committed);
      now = now.add(const Duration(minutes: 10));
      changedAt = now;
      expect(
        (await r.run(BackupTrigger.committed)).result,
        AutoBackupResult.throttled,
      );
      expect(
        (await r.run(BackupTrigger.appBackground)).result,
        AutoBackupResult.uploaded,
      );
    },
  );

  test('clock set back: the new backup is kept, the old ones rotate', () async {
    final r = runner();
    // Two uploads while the clock ran a year fast.
    now = DateTime.utc(2027, 10, 23, 12);
    for (var i = 0; i < 2; i++) {
      now = now.add(const Duration(hours: 1));
      changedAt = now;
      await r.run(BackupTrigger.committed);
    }
    // The clock is corrected.
    now = DateTime.utc(2026, 10, 23, 12);
    changedAt = now.add(const Duration(minutes: 1));
    ledger.lastUploadAt = null;
    expect(
      (await r.run(BackupTrigger.committed)).result,
      AutoBackupResult.uploaded,
    );
    final newest = CloudBackupNames.saveName('dev1', now, seq: 3);
    expect(cloud.files.containsKey(newest), isTrue);
    expect(saves(), hasLength(2));
  });

  test(
    'iCloud stalled: unuploaded copies do not rotate the cloud ones out',
    () async {
      final icloud = _StallingTarget();
      cloud = icloud;
      final r = runner();
      for (var i = 0; i < 2; i++) {
        await r.run(BackupTrigger.committed);
        now = now.add(const Duration(hours: 1));
        changedAt = now;
      }
      final reached = saves().toSet();
      icloud.stalled = true;
      for (var i = 0; i < 3; i++) {
        await r.run(BackupTrigger.committed);
        now = now.add(const Duration(hours: 1));
        changedAt = now;
      }
      expect(
        saves().toSet().containsAll(reached),
        isTrue,
        reason: 'both backups that reached iCloud are still there',
      );
    },
  );

  test('slow metadata reads in parallel, never holding the list up', () async {
    final slow = _SlowMetaTarget();
    for (var i = 1; i <= 6; i++) {
      final n = CloudBackupNames.saveName('dev7', now, seq: i);
      slow.files[n] = Uint8List.fromList([i]);
      slow.files[CloudBackupNames.metaNameFor(n)] = Uint8List(0);
    }
    final clock = Stopwatch()..start();
    final list = await CloudBackupStore(
      slow,
      metaPatience: const Duration(milliseconds: 200),
    ).list();
    expect(list, hasLength(6));
    expect(list.every((e) => e.meta == null), isTrue);
    // Six 200 ms waits one after another would be 1.2 s.
    expect(clock.elapsedMilliseconds, lessThan(1000));
  });

  test('the temporary snapshot is cleaned up', () async {
    await runner().run(BackupTrigger.committed);
    expect(File('${dir.path}/snap1.fnmsave').existsSync(), isFalse);
  });

  test('the listing reads the metadata, newest first', () async {
    final r = runner();
    await r.run(BackupTrigger.committed);
    now = now.add(const Duration(hours: 2));
    changedAt = now;
    await r.run(BackupTrigger.committed);
    // A backup whose metadata is lost is still listed, dated by its name.
    final orphanAt = DateTime.utc(2026, 1, 1, 8);
    cloud.files[CloudBackupNames.saveName('dev9', orphanAt)] =
        cloud.files[saves().first]!;
    final list = await CloudBackupStore(cloud).list();
    expect(list, hasLength(3));
    expect(list.first.at, now);
    expect(list.first.meta!.deviceName, 'Test Phone');
    expect(list.first.meta!.careers.single.managerName, 'Ota');
    expect(list.first.meta!.careers.single.year, 2034);
    expect(list.last.meta, isNull);
    expect(list.last.at, orphanAt);
    expect(list.last.deviceId, 'dev9');

    final out = '${dir.path}/back.fnmsave';
    await CloudBackupStore(cloud).fetch(list.first, out);
    expect(File(out).readAsStringSync(), 'save #2');
  });
}

/// iCloud as it behaves when uploads stall: files land in the container but
/// are reported as not uploaded.
class _StallingTarget extends FakeCloudBackupTarget {
  bool stalled = false;
  final Set<String> local = {};

  @override
  Future<void> upload(File file, String name) async {
    await super.upload(file, name);
    if (stalled) local.add(name);
  }

  @override
  Future<List<CloudFile>> list() async => [
    for (final f in await super.list())
      CloudFile(name: f.name, size: f.size, uploaded: !local.contains(f.name)),
  ];
}

/// A target whose metadata files never finish downloading.
class _SlowMetaTarget extends FakeCloudBackupTarget {
  @override
  Future<String?> readText(String name) => Completer<String?>().future; // never completes
}
