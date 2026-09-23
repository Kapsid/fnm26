import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/data/db/save_backup.dart';
import 'package:sqlite3/sqlite3.dart';

/// The saves screen writes TWO kinds of file and takes both back in.
///
/// "Export this save" makes a career bundle: gzipped JSON. "Back up all saves"
/// makes the whole SQLite database. They sit one above the other on the same
/// screen, and import used to accept only the first, so backing everything up
/// and then pressing the button underneath answered "that file is not an FNM
/// career" — true, useless, and our doing.
///
/// Import now reads what it was handed. That only works while the two readers
/// disagree cleanly about every file, which is what this pins: each format is
/// accepted by its own reader and refused by the other, so neither can be
/// mistaken for the other and routed to the wrong place.
void main() {
  late Directory tmp;

  setUp(() => tmp = Directory.systemTemp.createTempSync('fnm-import'));
  tearDown(() => tmp.deleteSync(recursive: true));

  /// A file shaped like the whole-database backup: a careers table and a
  /// schema version this build can take.
  File wholeDatabase() {
    final path = '${tmp.path}/all.${SaveBackup.extension}';
    final db = sqlite3.open(path)
      ..execute('CREATE TABLE careers (id INTEGER PRIMARY KEY)')
      ..execute('PRAGMA user_version = ${AppDatabase.currentSchemaVersion}');
    db.dispose();
    return File(path);
  }

  /// A file shaped like one shared career.
  File careerBundle() {
    final path = '${tmp.path}/one.${CareerBundle.extension}';
    return File(path)..writeAsBytesSync(
      CareerBundle.encode({
        'format': 1,
        'schemaVersion': AppDatabase.currentSchemaVersion,
        'tables': <String, Object?>{},
      }),
    );
  }

  test('a whole-database backup is taken as a backup, not as a career', () {
    final file = wholeDatabase();

    expect(
      SaveBackup.inspect(file.path).rejection,
      isNull,
      reason: 'the backup reader must accept its own file',
    );
    expect(
      CareerBundle.decode(file.readAsBytesSync()).rejection,
      BundleRejection.unreadable,
      reason: 'and the career reader must refuse it, which is the whole '
          'reason import has to look before it complains',
    );
  });

  test('a shared career is taken as a career, not as a backup', () {
    final file = careerBundle();

    expect(
      CareerBundle.decode(file.readAsBytesSync()).rejection,
      isNull,
      reason: 'the career reader must accept its own file',
    );
    expect(
      SaveBackup.inspect(file.path).rejection,
      isNotNull,
      reason: 'a gzipped bundle is not a database',
    );
  });

  test('neither reader claims a file that is neither', () {
    final junk = File('${tmp.path}/junk.txt')
      ..writeAsStringSync('not a save, not a career, not anything');

    expect(CareerBundle.decode(junk.readAsBytesSync()).rejection, isNotNull);
    expect(SaveBackup.inspect(junk.path).rejection, isNotNull);
  });
}
