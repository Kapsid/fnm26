import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('upgrading from an older schema rebuilds without SQL errors', () async {
    final dir = await Directory.systemTemp.createTemp('fnm_mig');
    final path = '${dir.path}/app.db';

    // Simulate an OLD install: a couple of legacy tables at an old version,
    // WITHOUT the tables/columns the current code expects (mirrors a real
    // device that has been through several schema versions).
    final raw = sqlite3.open(path);
    raw
      ..execute('CREATE TABLE nations (id INTEGER PRIMARY KEY, name TEXT)')
      ..execute(
        'CREATE TABLE careers (id INTEGER PRIMARY KEY, manager_name TEXT)',
      )
      // A table the current schema no longer defines — the wipe must drop it
      // (via sqlite_master) so it can't linger and break things.
      ..execute('CREATE TABLE legacy_dropped (id INTEGER PRIMARY KEY)')
      ..execute('PRAGMA user_version = 18');
    raw.dispose();

    // Opening the app database must run the destructive upgrade cleanly — no
    // "no such table"/"duplicate column" errors.
    final db = AppDatabase.forTesting(NativeDatabase(File(path)));
    addTearDown(() async {
      await db.close();
      await dir.delete(recursive: true);
    });

    // Every current table must exist and be queryable after the rebuild —
    // including new tables and the careers table with its added columns.
    expect(await db.select(db.nationsCupTiers).get(), isEmpty);
    expect(await db.select(db.playerRatings).get(), isEmpty);
    expect(await db.select(db.matchTeamStats).get(), isEmpty);
    expect(await db.select(db.federationInvestments).get(), isEmpty);
    expect(await db.select(db.careers).get(), isEmpty); // has the budget column
  });
}
