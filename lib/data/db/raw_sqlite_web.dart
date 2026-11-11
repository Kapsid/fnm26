import 'package:sqlite3/common.dart';

export 'package:sqlite3/common.dart' show OpenMode;

/// The web build's stand-in for `package:sqlite3`'s FFI database: the save
/// file tools never run in the web editor, so nothing here opens a file.
typedef Database = CommonDatabase;

/// The web build's stand-in for `package:sqlite3`'s global [sqlite3].
const RawSqliteUnavailable sqlite3 = RawSqliteUnavailable();

/// Refuses every open: there is no database file on the web.
class RawSqliteUnavailable {
  const RawSqliteUnavailable();

  Database open(String filename, {OpenMode mode = OpenMode.readWriteCreate}) =>
      throw UnsupportedError('No database files on the web');
}
