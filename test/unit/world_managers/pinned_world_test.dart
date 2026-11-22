import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Variable;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart' show regionalCupsEnabledProvider;

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
      // And no regional cups (1.1.2): the world pinned before them.
      regionalCupsEnabledProvider.overrideWithValue(false),
    ]);
    addTearDown(() async {
      c.dispose();
      await db.close();
    });
    final d = await StoryDriver.start(
      c,
      42,
      // Hosts as the build before the stadium bars decided them.
      stadiumHostRules: false,
      // And its first cycle on the calendar before calendar2 (1.1.2): every
      // fixture of it is byte for byte the 1.1.1 world (re-pinned for
      // 1.1.2 from fixture 2697 on, the rollover into a calendar2 cycle;
      // scores re-pinned again for the 1.1.2 engine tuning).
      calendar2: false,
      // And its finals on the old 3-day spacing (TournamentCalendar).
      tournamentSpacing: false,
      // And its first cycle before the 1.1.2 difficulty (BigGameDifficulty,
      // GrowthDifficulty): an unmarked cycle plays byte for byte as before.
      difficulty2: false,
    );
    // 121 steps reach the rollover into the second cycle (a wonderkid no
    // academy releases since 1.1.2 is one more event on the way, and the
    // scores from fixture 1013 on are re-pinned for him).
    for (var i = 0; i < 121; i++) {
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
