import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_meta.dart';
import 'package:sqlite3/sqlite3.dart';

/// The careers inside the backup file at [path], read straight from the file
/// (read-only), so the metadata describes exactly what was uploaded.
///
/// Best effort: anything that cannot be read leaves the list shorter, never
/// the backup unmade.
List<BackupCareerSummary> careersInBackup(String path) {
  Database? db;
  try {
    db = sqlite3.open(path, mode: OpenMode.readOnly);
    final rows = db.select(
      'SELECT c.manager_name AS manager, c.in_game_date AS date, '
      'n.name AS nation FROM careers c '
      'LEFT JOIN nations n ON n.id = c.nation_id ORDER BY c.id',
    );
    return [
      for (final r in rows)
        BackupCareerSummary(
          managerName: r['manager'] as String? ?? '',
          nationName: r['nation'] as String?,
          year: _yearOf(r['date']),
        ),
    ];
  } on Object {
    return const [];
  } finally {
    db?.close();
  }
}

/// drift stores a DateTime as Unix seconds by default; text is tolerated too.
int _yearOf(Object? stored) {
  if (stored is int) {
    return DateTime.fromMillisecondsSinceEpoch(
      stored * 1000,
      isUtc: true,
    ).year;
  }
  if (stored is String) return DateTime.tryParse(stored)?.year ?? 0;
  return 0;
}

/// A name for this device the player will recognise in a list of backups:
/// the model ("iPhone 15 Pro", "Google Pixel 8"). Falls back to the platform.
Future<String> thisDeviceName() async {
  try {
    final info = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final ios = await info.iosInfo;
      // Since iOS 16 `name` is only the generic "iPhone" without a special
      // entitlement, so the model is the more telling of the two.
      return ios.modelName.isNotEmpty ? ios.modelName : ios.model;
    }
    if (Platform.isAndroid) {
      final a = await info.androidInfo;
      final model = a.model;
      final maker = a.manufacturer;
      if (model.toLowerCase().startsWith(maker.toLowerCase())) return model;
      return '${_capitalised(maker)} $model'.trim();
    }
  } on Object {
    // Fall through to the platform's name.
  }
  return Platform.operatingSystem;
}

String _capitalised(String s) =>
    s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
