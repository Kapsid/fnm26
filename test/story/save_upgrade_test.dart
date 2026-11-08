import 'dart:io';

import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart'
    show kMatchViewModePrefsKey;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/save_fixtures.dart';
import 'driver.dart';

/// Opens the saves of earlier builds (test/fixtures/saves) with today's code
/// and checks nothing they hold is lost or rewritten: the owner's rule is
/// "never break saves". Later tasks append their own assertions here.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// [file] opened as the app opens a save: migrated, then seeded.
  Future<(AppDatabase, ProviderContainer)> open(File file) async {
    // As [storyDb]: matches on the Timeline, no Pitch question.
    SharedPreferences.setMockInitialValues(<String, Object>{
      kMatchViewModePrefsKey: 'timeline',
    });
    final db = AppDatabase.forTesting(NativeDatabase(file));
    final c = storyContainer(db);
    await c.read(seedLoaderProvider).ensureSeeded();
    return (db, c);
  }

  Future<void> close(AppDatabase db, ProviderContainer c) async {
    c.dispose();
    await db.close();
  }

  void expectHosts(
    SaveManifest now,
    SaveManifest then, {
    bool Function(String key)? only,
  }) {
    for (final key in then.hosts.keys.where(only ?? (_) => true)) {
      expect(now.hosts[key], then.hosts[key], reason: 'hosts $key');
      expect(now.venues[key], then.venues[key], reason: 'venues $key');
    }
  }

  for (final build in kFixtureBuilds) {
    for (final save in ['mid_cycle', 'late_cycle']) {
      if (!File('$kFixtureSavesDir/$build/$save.db.gz').existsSync()) continue;

      group('$build $save', () {
        late SaveManifest manifest;
        setUp(() => manifest = readManifest(build, save));

        test(
          'opening migrates to ${AppDatabase.currentSchemaVersion} and '
          'changes no existing row',
          () async {
            final file = await unpackFixture(build, save);
            final before = await dumpTables(file.path);
            final (db, c) = await open(file);
            final version = await db
                .customSelect('PRAGMA user_version')
                .getSingle();
            expect(
              version.data.values.single,
              AppDatabase.currentSchemaVersion,
            );
            await close(db, c);
            final after = await dumpTables(file.path);
            for (final MapEntry(key: table, value: rows) in before.entries) {
              final now = after[table];
              expect(now, isNotNull, reason: '$table dropped');
              expect(now!.length, rows.length, reason: '$table row count');
              for (var i = 0; i < rows.length; i++) {
                expect(
                  rowOn(now[i], rows[i].keys),
                  rows[i],
                  reason: '$table row $i',
                );
              }
            }
          },
          timeout: const Timeout(Duration(minutes: 5)),
        );

        test(
          "names, hosts and venues match the old build's manifest",
          () async {
            final (db, c) = await open(await unpackFixture(build, save));
            addTearDown(() => close(db, c));
            final now = await computeManifest(c, manifest.careerId);
            expect(now.cyclePointer, manifest.cyclePointer);
            expectHosts(now, manifest);
            expect(now.hosts.keys.toSet(), containsAll(manifest.hosts.keys));
            for (final MapEntry(key: nation, value: names)
                in manifest.names.entries) {
              expect(now.names[nation], names, reason: 'names of $nation');
            }
          },
          timeout: const Timeout(Duration(minutes: 5)),
        );

        if (save == 'late_cycle') {
          test(
            'a rollover keeps every existing row outside the mutable tables',
            () async {
              final file = await unpackFixture(build, save);
              final (db, c) = await open(file);
              addTearDown(() => close(db, c));
              final d = StoryDriver(c, manifest.careerId);
              expect((await d.nextEvent()).kind, HubEventKind.cycleRollover);
              final career = (await c
                  .read(careerRepositoryProvider)
                  .byId(manifest.careerId))!;
              final at = career.inGameDate;
              final before = await dumpTables(file.path);
              await d.step();
              expect(
                (await c
                        .read(careerRepositoryProvider)
                        .byId(manifest.careerId))!
                    .cyclePointer,
                manifest.cyclePointer + 1,
              );
              final after = await dumpTables(file.path);

              final changed = <String>{};
              for (final MapEntry(key: table, value: rows) in before.entries) {
                if (kRolloverMutableTables.contains(table)) continue;
                final now = {
                  for (final r
                      in after[table] ?? const <Map<String, Object?>>[])
                    rowKey(r),
                };
                final lost = rows.where((r) => !now.contains(rowKey(r)));
                if (lost.isNotEmpty) changed.add(table);
              }
              expect(changed, isEmpty, reason: 'tables a rollover rewrote');

              // The record of what was played and won before the rollover.
              final atSeconds = at.millisecondsSinceEpoch ~/ 1000;
              bool dated(String table, Map<String, Object?> r) =>
                  switch (table) {
                    'fixtures' => _seconds(r['date']) < atSeconds,
                    'career_stints' =>
                      (r['cycle']! as int) <= manifest.cyclePointer,
                    _ => (r['year']! as int) <= at.year,
                  };
              for (final table in const [
                'honours',
                'career_stints',
                'player_honours',
                'fixtures',
              ]) {
                final now = {
                  for (final r
                      in after[table] ?? const <Map<String, Object?>>[])
                    rowKey(r),
                };
                final lost = [
                  for (final r
                      in before[table] ?? const <Map<String, Object?>>[])
                    if (dated(table, r) && !now.contains(rowKey(r))) r,
                ];
                expect(lost, isEmpty, reason: '$table rows before rollover');
              }

              final now = await computeManifest(c, manifest.careerId);
              expectHosts(now, manifest, only: (k) => k.endsWith(':0'));
            },
            timeout: const Timeout(Duration(minutes: 10)),
          );

          test(
            "the old build's bundle imports",
            () async {
              final bytes = File(
                '$kFixtureSavesDir/$build/late_cycle.fnmcareer',
              ).readAsBytesSync();
              final decoded = CareerBundle.decode(bytes);
              expect(decoded.rejection, isNull);
              final bundle = decoded.bundle!;
              final db = storyDb();
              final c = storyContainer(db);
              addTearDown(() => close(db, c));
              await c.read(seedLoaderProvider).ensureSeeded();
              final id = await CareerBundle.import(db, bundle);
              final count = await db
                  .customSelect(
                    'SELECT COUNT(*) AS n FROM fixtures WHERE career_id = ?',
                    variables: [Variable<int>(id)],
                  )
                  .getSingle();
              final source =
                  ((bundle['tables']! as Map)['fixtures']! as List).length;
              expect(count.read<int>('n'), source);
            },
            timeout: const Timeout(Duration(minutes: 5)),
          );
        }

        if (save == 'mid_cycle') {
          test(
            'fifty more events play',
            () async {
              final (db, c) = await open(await unpackFixture(build, save));
              addTearDown(() => close(db, c));
              final d = StoryDriver(c, manifest.careerId);
              for (var i = 0; i < 50; i++) {
                await d.step(stopAtRollover: true);
              }
              final now = await computeManifest(c, manifest.careerId);
              expectHosts(
                now,
                manifest,
                only: (k) => k.endsWith(':${manifest.cyclePointer}'),
              );
            },
            timeout: const Timeout(Duration(minutes: 10)),
          );
        }
      });
    }
  }
}

/// A fixture's stored date as Unix seconds: drift's default integer form, or
/// an ISO string if a build ever stored text.
int _seconds(Object? v) =>
    v is int ? v : DateTime.parse(v! as String).millisecondsSinceEpoch ~/ 1000;
