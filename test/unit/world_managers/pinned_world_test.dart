import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Variable;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';

import '../../story/driver.dart';

/// The world of seed 42 (England) after its first 120 hub events, pinned
/// before world managers: with manager style switched off, the world must
/// stay exactly this. FNM_GOLDEN=1 writes the golden; a plain run compares.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const golden = 'test/fixtures/managers/pinned_world_seed42.json';

  test('seed 42 plays the pinned world', () async {
    final db = storyDb();
    // Manager style off: the world managers' one effect on play.
    final c = storyContainer(db, 0, [
      worldManagerStyleEnabledProvider.overrideWithValue(false),
    ]);
    addTearDown(() async {
      c.dispose();
      await db.close();
    });
    final d = await StoryDriver.start(c, 42);
    for (var i = 0; i < 120; i++) {
      await d.step();
    }
    final rows = await db
        .customSelect(
          'SELECT id, date, home_nation_id, away_nation_id, home_score, '
          'away_score, home_penalties, away_penalties FROM fixtures '
          'WHERE career_id = ? ORDER BY id',
          variables: [Variable<int>(d.careerId)],
        )
        .get();
    final world = [
      for (final r in rows)
        [
          r.read<int>('id'),
          r.read<DateTime>('date').toUtc().toIso8601String(),
          r.read<int>('home_nation_id'),
          r.read<int>('away_nation_id'),
          r.readNullable<int>('home_score'),
          r.readNullable<int>('away_score'),
          r.readNullable<int>('home_penalties'),
          r.readNullable<int>('away_penalties'),
        ],
    ];
    if (Platform.environment['FNM_GOLDEN'] == '1') {
      File(golden).writeAsStringSync(
        // One fixture to a line, so a diff names the fixture that moved.
        '[\n${[for (final f in world) jsonEncode(f)].join(',\n')}\n]\n',
      );
      return;
    }
    final pinned = (jsonDecode(File(golden).readAsStringSync()) as List)
        .cast<List<Object?>>();
    expect(world.length, pinned.length, reason: 'fixture count');
    for (var i = 0; i < pinned.length; i++) {
      expect(world[i], pinned[i], reason: 'fixture ${pinned[i].first}');
    }
  }, timeout: const Timeout(Duration(minutes: 15)));
}
