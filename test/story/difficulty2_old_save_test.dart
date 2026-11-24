@Tags(['slow'])
library;

import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/services/match/big_game_difficulty.dart';
import 'package:fnm/domain/services/player/growth_difficulty.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/federation/youth_hand.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart'
    show kMatchViewModePrefsKey;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/save_fixtures.dart';
import 'driver.dart';

/// The 1.1.2 difficulty (`BigGameDifficulty`, `GrowthDifficulty`) on a real
/// save from before it (1.1.0 (37)) and on a new career.
///
/// Owner rule: never break saves. The difficulty is a per-cycle
/// `draws_watched` marker and nothing else, so an old save's cycle under
/// way carries none and plays as it always did; its rollover marks the next
/// cycle, records the manager's hand in that cycle's intake, and leaves every
/// intake and every start banked before it exactly as it was.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const build = 'v110_37';

  Future<(AppDatabase, ProviderContainer)> open(String name) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      kMatchViewModePrefsKey: 'timeline',
    });
    final file = await unpackFixture(build, name);
    final db = AppDatabase.forTesting(NativeDatabase(file));
    final c = storyContainer(db);
    await c.read(seedLoaderProvider).ensureSeeded();
    return (db, c);
  }

  Future<T> read<T>(ProviderContainer c, AutoDisposeFutureProvider<T> p) async {
    final sub = c.listen(p.future, (_, _) {});
    try {
      return await sub.read();
    } finally {
      sub.close();
    }
  }

  test(
    'an old save marks nothing until its rollover, and keeps its past',
    () async {
      final manifest = readManifest(build, 'late_cycle');
      final id = manifest.careerId;
      final (db, c) = await open('late_cycle');
      addTearDown(() async {
        c.dispose();
        await db.close();
      });
      final comp = c.read(competitionRepositoryProvider);
      final from = manifest.cyclePointer;
      for (var cycle = 0; cycle <= from; cycle++) {
        expect(await isDifficulty2(comp, id, cycle), isFalse);
      }
      final bonusBefore = await read(c, youthBonusByCycleProvider(id));
      final startsBefore = await comp.careerStartsByPlayer(id);
      expect(startsBefore, isA<CareerStarts>());
      expect((startsBefore as CareerStarts).marked, isEmpty);

      final d = StoryDriver(c, id);
      expect((await d.nextEvent()).kind, HubEventKind.cycleRollover);
      await d.step();
      final career = (await c.read(careerRepositoryProvider).byId(id))!;
      final next = from + 1;
      expect(career.cyclePointer, next);
      for (var cycle = 0; cycle <= from; cycle++) {
        expect(await isDifficulty2(comp, id, cycle), isFalse);
      }
      expect(await isDifficulty2(comp, id, next), isTrue);
      // The new cycle's intake is credited with the hand he holds now.
      final stamps = [
        for (final m in await comp.watchedKindsWithPrefix(
          GrowthDifficulty.youthHandPrefix,
        ))
          if (m.careerId == id) m.kind,
      ];
      expect(stamps, [
        GrowthDifficulty.youthHandKind(next, youthHandOf(career)),
      ]);

      // Every intake born before the rollover is exactly what it was, and
      // the starts banked before it are all unmarked.
      c.invalidate(youthBonusByCycleProvider(id));
      final bonusAfter = await read(c, youthBonusByCycleProvider(id));
      for (var cycle = 0; cycle <= from; cycle++) {
        expect(bonusAfter[cycle], bonusBefore[cycle], reason: 'cycle $cycle');
      }
      expect(
        bonusAfter[next] ?? 0,
        lessThanOrEqualTo(GrowthDifficulty.intakeBonusCap),
      );
      final startsAfter = await comp.careerStartsByPlayer(id);
      expect(startsAfter, startsBefore);
      expect((startsAfter as CareerStarts).marked, isEmpty);
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );

  test('a new career is marked from its first cycle', () async {
    final db = storyDb();
    final c = storyContainer(db);
    addTearDown(() async {
      c.dispose();
      await db.close();
    });
    final d = await StoryDriver.start(c, 7);
    final comp = c.read(competitionRepositoryProvider);
    expect(await isDifficulty2(comp, d.careerId, 0), isTrue);
    final stamps = [
      for (final m in await comp.watchedKindsWithPrefix(
        GrowthDifficulty.youthHandPrefix,
      ))
        if (m.careerId == d.careerId) m.kind,
    ];
    expect(stamps, hasLength(1));

    final old = await StoryDriver.start(c, 8, difficulty2: false);
    expect(await isDifficulty2(comp, old.careerId, 0), isFalse);
  });
}
