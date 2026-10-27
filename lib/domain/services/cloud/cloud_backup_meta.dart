import 'dart:convert';

/// One save inside a backup, as the restore list shows it.
class BackupCareerSummary {
  const BackupCareerSummary({
    required this.managerName,
    required this.year,
    this.nationName,
  });

  factory BackupCareerSummary.fromJson(Map<String, Object?> json) =>
      BackupCareerSummary(
        managerName: json['manager'] as String? ?? '',
        nationName: json['nation'] as String?,
        year: (json['year'] as num?)?.toInt() ?? 0,
      );

  final String managerName;

  /// The nation's stored (English) name; null when it could not be read.
  final String? nationName;

  /// The in-game year the save had reached.
  final int year;

  Map<String, Object?> toJson() => {
    'manager': managerName,
    if (nationName != null) 'nation': nationName,
    'year': year,
  };
}

/// The small JSON file kept beside every cloud backup.
///
/// It exists so the restore list on ANOTHER device can say what each backup is
/// (when, from which phone, which careers at which year) without downloading
/// a whole database to find out. It is a convenience, never the source of
/// truth: a backup with a missing or unreadable metadata file is still listed,
/// dated from its name, and restoring always goes through the schema guard.
class CloudBackupMeta {
  const CloudBackupMeta({
    required this.createdAt,
    required this.deviceId,
    required this.deviceName,
    required this.platform,
    required this.schemaVersion,
    required this.careers,
    this.sizeBytes,
    this.seq = 0,
  });

  /// Bumped only if the shape changes incompatibly.
  static const int format = 1;

  /// Reads [text], or null when it is not one of ours. Tolerant of missing
  /// fields: a metadata file is a hint, and a bad hint must not hide a backup.
  static CloudBackupMeta? tryParse(String? text) {
    if (text == null || text.isEmpty) return null;
    try {
      final json = jsonDecode(text);
      if (json is! Map<String, Object?>) return null;
      if (json['app'] != 'fnm') return null;
      final created = DateTime.tryParse(json['createdAt'] as String? ?? '');
      if (created == null) return null;
      final careers = json['careers'];
      return CloudBackupMeta(
        createdAt: created.toUtc(),
        deviceId: json['deviceId'] as String? ?? '',
        deviceName: json['deviceName'] as String? ?? '',
        platform: json['platform'] as String? ?? '',
        schemaVersion: (json['schema'] as num?)?.toInt() ?? 0,
        sizeBytes: (json['size'] as num?)?.toInt(),
        seq: (json['seq'] as num?)?.toInt() ?? 0,
        careers: [
          if (careers is List)
            for (final c in careers)
              if (c is Map<String, Object?>) BackupCareerSummary.fromJson(c),
        ],
      );
    } on Object {
      return null;
    }
  }

  final DateTime createdAt;

  /// A random id this install made for itself, so the rotation only ever
  /// touches its own backups and never another device's.
  final String deviceId;

  /// What the player will recognise ("iPhone 15", "Pixel 8").
  final String deviceName;

  /// 'ios' or 'android'.
  final String platform;

  /// The database schema the backup was written at.
  final int schemaVersion;

  final int? sizeBytes;
  final List<BackupCareerSummary> careers;

  /// This install's upload counter for the backup; see [CloudBackupNames].
  final int seq;

  Map<String, Object?> toJson() => {
    'app': 'fnm',
    'format': format,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'deviceId': deviceId,
    'deviceName': deviceName,
    'platform': platform,
    'schema': schemaVersion,
    if (sizeBytes != null) 'size': sizeBytes,
    'seq': seq,
    'careers': [for (final c in careers) c.toJson()],
  };

  String encode() => jsonEncode(toJson());
}

/// How automatic backups are named in the cloud folder.
///
/// `fnm-auto-<device>-<yyyyMMdd>-<HHmmss>-s<seq>.fnmsave`, the moment in UTC,
/// with the metadata beside it under the same stem and `.json`. `<seq>` is this
/// install's own upload counter. Rotation orders by IT, not by the clock: a
/// phone whose clock was once wrong must not sort its newest backup as its
/// oldest and rotate it straight out. Names from before the counter (no
/// `-s<seq>`) read as sequence 0, older than anything numbered.
abstract final class CloudBackupNames {
  static const String prefix = 'fnm-auto-';
  static const String saveExtension = '.fnmsave';
  static const String metaExtension = '.json';

  static final RegExp _pattern = RegExp(
    r'^fnm-auto-([a-z0-9]+)-(\d{4})(\d{2})(\d{2})-(\d{2})(\d{2})(\d{2})'
    r'(?:-s(\d+))?\.fnmsave$',
  );

  /// The backup file's name for [deviceId] at [at], upload number [seq].
  static String saveName(String deviceId, DateTime at, {int seq = 0}) {
    final u = at.toUtc();
    String two(int v) => v.toString().padLeft(2, '0');
    return '$prefix$deviceId-${u.year.toString().padLeft(4, '0')}'
        '${two(u.month)}${two(u.day)}-${two(u.hour)}${two(u.minute)}'
        '${two(u.second)}${seq > 0 ? '-s$seq' : ''}$saveExtension';
  }

  /// The metadata file that goes with [saveName].
  static String metaNameFor(String saveName) => saveName.endsWith(saveExtension)
      ? '${saveName.substring(0, saveName.length - saveExtension.length)}'
            '$metaExtension'
      : '$saveName$metaExtension';

  /// The device, moment and upload number in [name], or null for anything
  /// that is not an automatic backup file.
  static ({String deviceId, DateTime at, int seq})? parse(String name) {
    final m = _pattern.firstMatch(name);
    if (m == null) return null;
    int g(int i) => int.parse(m.group(i)!);
    return (
      deviceId: m.group(1)!,
      at: DateTime.utc(g(2), g(3), g(4), g(5), g(6), g(7)),
      seq: m.group(8) == null ? 0 : g(8),
    );
  }
}
