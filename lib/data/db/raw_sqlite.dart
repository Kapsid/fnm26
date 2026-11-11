// Raw `sqlite3` (FFI) for the save-file tools that open the database file
// directly. The web editor has no save files and no FFI, so it compiles
// against a stub that refuses to open anything (`raw_sqlite_web.dart`).
export 'package:sqlite3/sqlite3.dart'
    if (dart.library.js_interop) 'raw_sqlite_web.dart';
