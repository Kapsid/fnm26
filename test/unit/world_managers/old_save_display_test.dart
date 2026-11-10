@Tags(['slow'])
library;

import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart'
    show kMatchViewModePrefsKey;
import 'package:fnm/features/world_managers/managers_list_providers.dart';
import 'package:fnm/features/world_managers/world_manager_markers.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/save_fixtures.dart';
import '../../story/driver.dart';

typedef _Open = ({AppDatabase db, ProviderContainer c, int careerId});

/// A 1.1.0 (37) fixture, opened as the app opens it.
Future<_Open> _open(String name) async {
  // As [storyDb]: matches on the Timeline, no view question before kick-off.
  SharedPreferences.setMockInitialValues(<String, Object>{
    kMatchViewModePrefsKey: 'timeline',
  });
  final file = await unpackFixture('v110_37', name);
  final db = AppDatabase.forTesting(NativeDatabase(file));
  final c = storyContainer(db);
  await c.read(seedLoaderProvider).ensureSeeded();
  final last = (await c.read(savesProvider.future)).first;
  return (db: db, c: c, careerId: last.id);
}

Future<void> _close(_Open o) async {
  o.c.dispose();
  await o.db.close();
}

/// What a screen does on an old save: the nation page, the managers list
/// and the moves tab, which seed the managers for display.
Future<void> _showManagers(_Open o, int nationId) async {
  final key = (careerId: o.careerId, nationId: nationId);
  final a = o.c.listen(nationManagerProvider(key).future, (_, _) {});
  await a.read();
  final b = o.c.listen(managersListProvider(o.careerId).future, (_, _) {});
  await b.read();
  final m = o.c.listen(recentMovesProvider(o.careerId).future, (_, _) {});
  await m.read();
  a.close();
  b.close();
  m.close();
}

/// Every played result of the career, by fixture id.
Future<Map<int, String>> _results(_Open o) async {
  final rows = await o.db
      .customSelect(
        'SELECT id, home_score, away_score FROM fixtures '
        'WHERE career_id = ? AND home_score IS NOT NULL ORDER BY id',
        variables: [Variable.withInt(o.careerId)],
      )
      .get();
  return {
    for (final r in rows)
      r.read<int>('id'):
          '${r.read<int>('home_score')}-'
          '${r.read<int>('away_score')}',
  };
}

Future<int> _anyAi(_Open o) async {
  final career = (await o.c.read(careerRepositoryProvider).byId(o.careerId))!;
  final nations = await o.c
      .read(nationRepositoryProvider)
      .forCareer(o.careerId);
  return nations.firstWhere((n) => n.id != career.nationId).id;
}

void main() {
  setUp(() => AppLog.debugUse(null));

  testWidgets('an old save shows its managers at once, and they do nothing '
      'until the next cycle', (tester) async {
    await tester.runAsync(() async {
      final o = await _open('mid_cycle');
      final career = (await o.c
          .read(careerRepositoryProvider)
          .byId(o.careerId))!;
      final service = o.c.read(worldManagerServiceProvider);
      expect(
        await service.cycleHasManagers(o.careerId, career.inGameDate),
        isFalse,
        reason: 'the upgrade cycle stays unmarked',
      );
      expect(await service.managersVisible(o.careerId), isTrue);

      final ai = await _anyAi(o);
      final view = await o.c.read(
        nationManagerProvider((careerId: o.careerId, nationId: ai)).future,
      );
      expect(view, isNotNull);
      expect(view!.m.name.trim(), isNotEmpty);
      expect(
        await o.c.read(
          nationManagerProvider((
            careerId: o.careerId,
            nationId: career.nationId,
          )).future,
        ),
        isNull,
        reason: "the player's own nation has no world manager",
      );

      final nations = await o.c
          .read(nationRepositoryProvider)
          .forCareer(o.careerId);
      final list = await o.c.read(managersListProvider(o.careerId).future);
      expect(list.length, nations.length - 1);
      // Only the seeded history (as a new career has it): nothing moved
      // after the cycle opened.
      final opened = CareerService.cycleOpens(career.cyclePointer);
      for (final m in await o.c.read(
        recentMovesProvider(o.careerId).future,
      )) {
        expect(m.date.isAfter(opened), isFalse, reason: '${m.date}');
      }
      final detail = await o.c.read(
        managerDetailProvider((
          careerId: o.careerId,
          managerId: view.m.managerId,
        )).future,
      );
      expect(detail, isNotNull);

      // The match preview's man, on the player's next fixture.
      final next =
          (await o.c
                  .read(competitionRepositoryProvider)
                  .fixturesForNation(o.careerId, career.nationId))
              .where((f) => !f.hasResult)
              .toList()
            ..sort((a, b) => a.date.compareTo(b.date));
      expect(next, isNotEmpty);
      final f = next.first;
      final opp = f.homeNationId == career.nationId
          ? f.awayNationId
          : f.homeNationId;
      expect(
        await o.c.read(
          opponentManagerProvider((
            careerId: o.careerId,
            nationId: opp,
            date: f.date,
          )).future,
        ),
        isNotNull,
      );

      // Seeded, yet the AI still reads each nation's own style in this
      // cycle: no effect before the marker.
      expect(
        await o.c.read(worldManagerRepositoryProvider).hasManagers(o.careerId),
        isTrue,
      );
      expect(await service.styleOn(o.careerId, opp, f.date), isNull);
      expect(await service.styleOn(o.careerId, ai, career.inGameDate), isNull);
      await _close(o);
    });
  }, timeout: const Timeout(Duration(minutes: 5)));

  testWidgets('showing the managers of an old save changes no result', (
    tester,
  ) async {
    await tester.runAsync(() async {
      const steps = 12;
      Future<Map<int, String>> run({required bool show}) async {
        final o = await _open('mid_cycle');
        if (show) await _showManagers(o, await _anyAi(o));
        expect(
          await o.c
              .read(worldManagerRepositoryProvider)
              .hasManagers(o.careerId),
          show,
        );
        final before = (await _results(o)).length;
        final d = StoryDriver(o.c, o.careerId);
        for (var i = 0; i < steps; i++) {
          if (!await d.step(stopAtRollover: true)) break;
        }
        final r = await _results(o);
        expect(r.length, greaterThan(before), reason: 'nothing was played');
        await _close(o);
        return r;
      }

      final plain = await run(show: false);
      final shown = await run(show: true);
      expect(shown, plain);
    });
  }, timeout: const Timeout(Duration(minutes: 10)));

  testWidgets('the rollover keeps the managers shown before it and switches '
      'their effects on', (tester) async {
    await tester.runAsync(() async {
      // Rolled once with the managers shown first, once without.
      Future<({List<String> managers, List<String> spells})> roll({
        required bool show,
      }) async {
        final o = await _open('late_cycle');
        final career = (await o.c
            .read(careerRepositoryProvider)
            .byId(o.careerId))!;
        final from = career.cyclePointer;
        final service = o.c.read(worldManagerServiceProvider);
        final repo = o.c.read(worldManagerRepositoryProvider);
        final ai = await _anyAi(o);
        List<String>? shownBefore;
        if (show) {
          await _showManagers(o, ai);
          shownBefore = [
            for (final m in (await repo.load(o.careerId)).managers)
              '${m.managerId}|${m.name}|${m.nationality}|${m.birthYear}',
          ];
          expect(shownBefore, isNotEmpty);
          expect(
            await service.styleOn(o.careerId, ai, career.inGameDate),
            isNull,
          );
        }
        final d = StoryDriver(o.c, o.careerId);
        expect((await d.nextEvent()).kind, HubEventKind.cycleRollover);
        await d.step();

        final opens = CareerService.cycleOpens(from + 1);
        final comp = o.c.read(competitionRepositoryProvider);
        expect(
          await comp.hasWatchedDraw(o.careerId, from + 1, worldManagersKind),
          isTrue,
        );
        expect(
          await comp.hasWatchedDraw(o.careerId, from + 1, mgrRolloverKind),
          isTrue,
          reason: 'the decision engine ran at the rollover',
        );
        expect(await service.cycleHasManagers(o.careerId, opens), isTrue);
        final now = (await o.c
            .read(careerRepositoryProvider)
            .byId(o.careerId))!;
        final aiNow =
            (await o.c.read(nationRepositoryProvider).forCareer(o.careerId))
                .firstWhere((n) => n.id != now.nationId)
                .id;
        expect(
          await service.styleOn(o.careerId, aiNow, opens),
          isNotNull,
          reason: 'effects switch on in the marked cycle',
        );

        final w = await repo.load(o.careerId);
        final managers = [
          for (final m in w.managers)
            '${m.managerId}|${m.name}|${m.nationality}|${m.birthYear}',
        ];
        if (shownBefore != null) {
          // The same people: nobody reseeded or duplicated.
          expect(managers.take(shownBefore.length), shownBefore);
          expect(
            managers.toSet().length,
            managers.length,
            reason: 'no manager twice',
          );
        }
        final spells = [
          for (final s in w.spells)
            [
              s.spellNo,
              s.managerId,
              s.nationId,
              s.fromDate,
              s.toDate,
              s.contractUntil,
            ].join('|'),
        ];
        await _close(o);
        return (managers: managers, spells: spells);
      }

      final shown = await roll(show: true);
      final plain = await roll(show: false);
      // Seeding early for the screens builds the very world the rollover
      // would have seeded itself, and its decisions run the same.
      expect(shown.managers, plain.managers);
      expect(shown.spells, plain.spells);
    });
  }, timeout: const Timeout(Duration(minutes: 15)));
}
