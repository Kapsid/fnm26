import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_meta.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_policy.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_target.dart';

/// The pure rules behind automatic backups: when to upload, which old ones
/// to rotate out, and when to remind.
void main() {
  final t0 = DateTime(2026, 10, 23, 12);

  group('decideUpload', () {
    UploadDecision decide({
      bool enabled = true,
      bool busy = false,
      DateTime? now,
      DateTime? lastUploadAt,
      DateTime? lastChangeAt,
    }) => decideUpload(
      enabled: enabled,
      busy: busy,
      now: now ?? t0,
      lastUploadAt: lastUploadAt,
      lastChangeAt: lastChangeAt,
    );

    test('off means off, whatever else', () {
      expect(decide(enabled: false), UploadDecision.disabled);
    });

    test('one at a time', () {
      expect(decide(busy: true), UploadDecision.busy);
    });

    test('the first upload always goes', () {
      expect(decide(lastChangeAt: t0), UploadDecision.upload);
    });

    test('nothing written since the last upload: skipped', () {
      final last = t0.subtract(const Duration(hours: 5));
      expect(
        decide(
          lastUploadAt: last,
          lastChangeAt: last.subtract(const Duration(minutes: 1)),
        ),
        UploadDecision.unchanged,
      );
      expect(
        decide(lastUploadAt: last, lastChangeAt: last),
        UploadDecision.unchanged,
      );
    });

    test('changed, but within 30 minutes of the last: throttled', () {
      final last = t0.subtract(const Duration(minutes: 29));
      expect(
        decide(lastUploadAt: last, lastChangeAt: t0),
        UploadDecision.throttled,
      );
    });

    test('changed and 30 minutes on: uploads', () {
      final last = t0.subtract(kAutoBackupMinGap);
      expect(
        decide(lastUploadAt: last, lastChangeAt: t0),
        UploadDecision.upload,
      );
    });

    test('going to the background uses the short gap', () {
      final last = t0.subtract(const Duration(minutes: 6));
      expect(
        decideUpload(
          enabled: true,
          busy: false,
          now: t0,
          lastUploadAt: last,
          lastChangeAt: t0,
          trigger: BackupTrigger.appBackground,
        ),
        UploadDecision.upload,
      );
      expect(
        decideUpload(
          enabled: true,
          busy: false,
          now: t0,
          lastUploadAt: t0.subtract(const Duration(minutes: 4)),
          lastChangeAt: t0,
          trigger: BackupTrigger.appBackground,
        ),
        UploadDecision.throttled,
      );
      expect(
        decide(lastUploadAt: last, lastChangeAt: t0),
        UploadDecision.throttled,
      );
    });

    test('an unknown change time counts as changed', () {
      final last = t0.subtract(const Duration(hours: 1));
      expect(decide(lastUploadAt: last), UploadDecision.upload);
    });

    test('a clock set back past the last upload does not hold it off', () {
      final last = t0.add(const Duration(days: 2));
      expect(
        decide(
          lastUploadAt: last,
          lastChangeAt: last.add(const Duration(minutes: 1)),
        ),
        UploadDecision.upload,
      );
    });
  });

  group('namesToPrune', () {
    final base = DateTime.utc(2026, 10, 1, 9);
    String save(String device, int seq, {DateTime? at}) =>
        CloudBackupNames.saveName(
          device,
          at ?? base.add(Duration(hours: seq)),
          seq: seq,
        );
    CloudFile up(String name, {bool uploaded = true}) =>
        CloudFile(name: name, uploaded: uploaded);
    Set<String> pruned(
      List<CloudFile> files,
      String just, {
      int? preRestoreSeq,
    }) => namesToPrune(
      files,
      deviceId: 'aaa',
      justUploaded: just,
      preRestoreSeq: preRestoreSeq,
    ).toSet();

    test('keeps the newest two of this device, with their metadata', () {
      final files = [
        for (final s in [1, 2, 3, 4]) ...[
          up(save('aaa', s)),
          up(CloudBackupNames.metaNameFor(save('aaa', s))),
        ],
      ];
      expect(pruned(files, save('aaa', 4)), {
        save('aaa', 1),
        CloudBackupNames.metaNameFor(save('aaa', 1)),
        save('aaa', 2),
        CloudBackupNames.metaNameFor(save('aaa', 2)),
      });
    });

    test("never touches another device's backups or foreign files", () {
      final files = [
        up(save('bbb', 1)),
        up(save('bbb', 2)),
        up(save('bbb', 3)),
        up(save('aaa', 4)),
        up('notes.txt'),
        up('fnm-auto-aaa-garbage.fnmsave'),
      ];
      expect(pruned(files, save('aaa', 4)), isEmpty);
    });

    test('iCloud: copies not yet uploaded never push out uploaded ones', () {
      // Uploads 1 and 2 reached iCloud; 3, 4 and 5 are still only on the
      // phone (iCloud Drive stalled for days).
      final files = [
        up(save('aaa', 1)),
        up(save('aaa', 2)),
        up(save('aaa', 3), uploaded: false),
        up(save('aaa', 4), uploaded: false),
        up(save('aaa', 5), uploaded: false),
      ];
      final gone = pruned(files, save('aaa', 5));
      expect(gone, isNot(contains(save('aaa', 1))));
      expect(gone, isNot(contains(save('aaa', 2))));
      // Only the stale local-only copy goes.
      expect(gone, {save('aaa', 3)});
    });

    test('the last uploaded backup is never deleted', () {
      final files = [
        up(save('aaa', 1)),
        up(save('aaa', 2), uploaded: false),
        up(save('aaa', 3), uploaded: false),
        up(save('aaa', 4), uploaded: false),
      ];
      expect(pruned(files, save('aaa', 4)), isNot(contains(save('aaa', 1))));
    });

    test('keeps a "last week" anchor besides the newest two', () {
      final latest = DateTime.utc(2026, 10, 20, 12);
      String at(int seq, Duration back) =>
          save('aaa', seq, at: latest.subtract(back));
      final names = [
        at(1, const Duration(days: 20)),
        at(2, const Duration(days: 9)),
        at(3, const Duration(days: 3)),
        at(4, const Duration(hours: 2)),
        at(5, Duration.zero),
      ];
      final gone = pruned([for (final n in names) up(n)], names[4]);
      // 5 and 4 are the newest two; 2 is the newest at least 7 days older.
      expect(gone, {names[0], names[2]});
    });

    test('a restored older state cannot push out the pre-restore backup', () {
      // Uploads 1 to 3 were the real progress; the player then restored an
      // older backup and the app uploaded 4 and 5 from that older state.
      final files = [
        for (final s in [1, 2, 3, 4, 5]) up(save('aaa', s)),
      ];
      final gone = pruned(files, save('aaa', 5), preRestoreSeq: 3);
      expect(gone, isNot(contains(save('aaa', 3))));
      expect(gone, {save('aaa', 1), save('aaa', 2)});
    });

    test('clock skew: order by upload number, never delete the new one', () {
      // Two old backups were named while the clock ran a year fast; the
      // clock is right again now.
      final future = DateTime.utc(2027, 10, 1);
      final files = [
        up(save('aaa', 1, at: future)),
        up(save('aaa', 2, at: future.add(const Duration(hours: 1)))),
        up(save('aaa', 3, at: base)),
      ];
      final gone = pruned(files, save('aaa', 3, at: base));
      expect(gone, isNot(contains(save('aaa', 3, at: base))));
      expect(gone, {save('aaa', 1, at: future)});
    });

    test('older names without a number sort before numbered ones', () {
      final legacy = CloudBackupNames.saveName(
        'aaa',
        DateTime.utc(2030),
      ); // far "future", no number
      final files = [up(legacy), up(save('aaa', 1)), up(save('aaa', 2))];
      expect(pruned(files, save('aaa', 2)), {legacy});
    });
  });

  group('backupReminderDue', () {
    final firstSeen = t0.subtract(const Duration(days: 60));

    bool due({
      bool enabled = true,
      DateTime? now,
      DateTime? firstSeenAt,
      DateTime? lastBackupAt,
      DateTime? lastCycleEndAt,
      DateTime? lastReminderAt,
    }) => backupReminderDue(
      enabled: enabled,
      now: now ?? t0,
      firstSeenAt: firstSeenAt ?? firstSeen,
      lastBackupAt: lastBackupAt,
      lastCycleEndAt: lastCycleEndAt,
      lastReminderAt: lastReminderAt,
    );

    test('a fresh install is not nagged', () {
      expect(due(firstSeenAt: t0), isFalse);
      expect(due(firstSeenAt: t0.subtract(const Duration(days: 13))), isFalse);
    });

    test('a backup older than 14 days is due', () {
      expect(
        due(lastBackupAt: t0.subtract(const Duration(days: 14))),
        isTrue,
      );
      expect(
        due(lastBackupAt: t0.subtract(const Duration(days: 13))),
        isFalse,
      );
    });

    test('a cycle ended since the last backup is due, after a day', () {
      final backup = t0.subtract(const Duration(days: 3));
      expect(
        due(
          lastBackupAt: backup,
          lastCycleEndAt: backup.add(const Duration(days: 1)),
        ),
        isTrue,
      );
      // A cycle before the backup does not count.
      expect(
        due(
          lastBackupAt: backup,
          lastCycleEndAt: backup.subtract(const Duration(hours: 1)),
        ),
        isFalse,
      );
      // Nor right after a backup.
      final recent = t0.subtract(const Duration(hours: 2));
      expect(
        due(
          lastBackupAt: recent,
          lastCycleEndAt: t0.subtract(const Duration(hours: 1)),
        ),
        isFalse,
      );
    });

    test('at most once a week', () {
      final old = t0.subtract(const Duration(days: 30));
      expect(
        due(
          lastBackupAt: old,
          lastReminderAt: t0.subtract(const Duration(days: 6)),
        ),
        isFalse,
      );
      expect(
        due(
          lastBackupAt: old,
          lastReminderAt: t0.subtract(kBackupReminderEvery),
        ),
        isTrue,
      );
    });

    test('can be turned off', () {
      expect(
        due(
          enabled: false,
          lastBackupAt: t0.subtract(const Duration(days: 90)),
        ),
        isFalse,
      );
    });
  });

  group('CloudBackupNames', () {
    test('a name round-trips its device, moment and number', () {
      final at = DateTime.utc(2031, 2, 3, 4, 5, 6);
      final name = CloudBackupNames.saveName('x9k2', at, seq: 17);
      expect(name, 'fnm-auto-x9k2-20310203-040506-s17.fnmsave');
      final parsed = CloudBackupNames.parse(name)!;
      expect(parsed.deviceId, 'x9k2');
      expect(parsed.at, at);
      expect(parsed.seq, 17);
      expect(
        CloudBackupNames.metaNameFor(name),
        'fnm-auto-x9k2-20310203-040506-s17.json',
      );
      expect(
        CloudBackupNames.parse('fnm-auto-x9k2-20310203-040506.fnmsave')!.seq,
        0,
      );
    });

    test('anything else is not ours', () {
      expect(CloudBackupNames.parse('photo.jpg'), isNull);
      expect(
        CloudBackupNames.parse('fnm-auto-x9k2-20310203-040506.json'),
        isNull,
      );
    });
  });
}
