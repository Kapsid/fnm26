import 'package:drift/drift.dart'
    show ApplyInterceptor, QueryExecutor, QueryInterceptor, TransactionExecutor;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_world_manager_repository.dart';
import 'package:fnm/data/seed/frozen_name_pools.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/repositories/world_manager_repository.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/world_managers/world_manager_markers.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';

import '../../helpers/save_fixtures.dart';
import '../../story/driver.dart';

/// Counts the transactions begun on a database.
class _BeginCounter extends QueryInterceptor {
  int begins = 0;

  @override
  TransactionExecutor beginTransaction(QueryExecutor parent) {
    begins++;
    return super.beginTransaction(parent);
  }
}

/// A repository whose first [apply] fails, as a full disk would.
class _FailsOnce implements WorldManagerRepository {
  _FailsOnce(this._inner);

  final WorldManagerRepository _inner;
  int applies = 0;

  @override
  Future<void> apply(int careerId, ManagerChanges c) async {
    applies++;
    if (applies == 1) throw StateError('disk full');
    await _inner.apply(careerId, c);
  }

  @override
  Future<bool> hasManagers(int careerId) => _inner.hasManagers(careerId);

  @override
  Future<ManagerWorld> load(int careerId) => _inner.load(careerId);

  @override
  Future<ManagerSpell?> inChargeOn(int careerId, int nationId, DateTime d) =>
      _inner.inChargeOn(careerId, nationId, d);

  @override
  Future<List<ManagerSpell>> spellsOf(int careerId, int managerId) =>
      _inner.spellsOf(careerId, managerId);

  @override
  Future<List<ManagerTie>> ties(int careerId) => _inner.ties(careerId);

  @override
  Future<void> addTie(
    int careerId, {
    required int managerId,
    required TieKind kind,
    required int delta,
    required DateTime date,
  }) => _inner.addTie(
    careerId,
    managerId: managerId,
    kind: kind,
    delta: delta,
    date: date,
  );

  @override
  Future<List<ManagerSpell>> movesSince(int careerId, DateTime since) =>
      _inner.movesSince(careerId, since);
}

/// The 1.1.0 (37) mid-cycle save, opened as the app opens it.
Future<({AppDatabase db, ProviderContainer c, int careerId})> _openFixture({
  QueryInterceptor? interceptor,
}) async {
  final file = await unpackFixture('v110_37', 'mid_cycle');
  final native = NativeDatabase(file);
  final db = AppDatabase.forTesting(
    interceptor == null ? native : native.interceptWith(interceptor),
  );
  final c = storyContainer(db);
  await c.read(seedLoaderProvider).ensureSeeded();
  final last = (await c.read(savesProvider.future)).first;
  return (db: db, c: c, careerId: last.id);
}

Future<void> _close(ProviderContainer c, AppDatabase db) async {
  c.dispose();
  await db.close();
}

void main() {
  setUp(() => AppLog.debugUse(null));

  testWidgets('opening a career and reading the hub seeds nothing', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final o = await _openFixture();
      final hub = o.c.listen(hubDataProvider(o.careerId).future, (_, _) {});
      await hub.read();
      final next = o.c.listen(
        nextEventProvider(o.careerId).future,
        (_, _) {},
      );
      await next.read();
      expect(
        await o.c.read(worldManagerRepositoryProvider).hasManagers(o.careerId),
        isFalse,
      );
      // An unmarked cycle reads the nation's own style, and seeds nothing
      // for asking.
      final career = (await o.c
          .read(careerRepositoryProvider)
          .byId(o.careerId))!;
      final service = o.c.read(worldManagerServiceProvider);
      expect(
        await service.cycleHasManagers(o.careerId, career.inGameDate),
        isFalse,
      );
      expect(await service.styleOn(o.careerId, 1, career.inGameDate), isNull);
      expect(
        await o.c.read(worldManagerRepositoryProvider).hasManagers(o.careerId),
        isFalse,
      );
      hub.close();
      next.close();
      await _close(o.c, o.db);
    });
  }, timeout: const Timeout(Duration(minutes: 5)));

  testWidgets('a new career is marked for managers and not seeded', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final db = storyDb();
      final c = storyContainer(db);
      final d = await StoryDriver.start(c, 42);
      expect(
        await c
            .read(competitionRepositoryProvider)
            .hasWatchedDraw(d.careerId, 0, worldManagersKind),
        isTrue,
      );
      expect(
        await c.read(worldManagerRepositoryProvider).hasManagers(d.careerId),
        isFalse,
      );
      // Asking for a style in a marked cycle seeds, once.
      final service = c.read(worldManagerServiceProvider);
      expect(
        await service.cycleHasManagers(d.careerId, CareerService.cycleStart),
        isTrue,
      );
      final career = (await c.read(careerRepositoryProvider).byId(d.careerId))!;
      final nations = await c
          .read(nationRepositoryProvider)
          .forCareer(d.careerId);
      final ai = nations.firstWhere((n) => n.id != career.nationId);
      expect(
        await service.styleOn(d.careerId, ai.id, CareerService.cycleStart),
        isNotNull,
      );
      expect(
        await service.styleOn(
          d.careerId,
          career.nationId,
          CareerService.cycleStart,
        ),
        isNull,
        reason: "the player's nation has no world manager",
      );
      await _close(c, db);
    });
  }, timeout: const Timeout(Duration(minutes: 5)));

  testWidgets("namePoolsFor reads the pools of the career's own era", (
    tester,
  ) async {
    await tester.runAsync(() async {
      final db = storyDb();
      final c = storyContainer(db);
      final d = await StoryDriver.start(c, 42);
      // A career from before the pool marks: no mark at all.
      final old = await db
          .into(db.careers)
          .insert(
            CareersCompanion.insert(
              nationId: 1,
              managerName: 'Old',
              createdAt: DateTime(2026),
              inGameDate: DateTime(2027),
              rngSeed: 9,
            ),
          );
      final players = c.read(playerRepositoryProvider);
      final now = await players.namePoolsFor(d.careerId);
      final then = await players.namePoolsFor(old);
      expect(now['CRO']!.sur, contains('Kovačić'));
      expect(then['CRO']!.sur, croatiaSurnamesV4);
      expect(then['CRO']!.sur, isNot(contains('Kovačić')));
      expect(now.keys.where((k) => k != k.toUpperCase()), isEmpty);
      expect(now, contains('ENG'));
      await _close(c, db);
    });
  }, timeout: const Timeout(Duration(minutes: 5)));

  testWidgets('a failed seeding is not kept: the next call seeds', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final db = storyDb();
      final failing = _FailsOnce(DriftWorldManagerRepository(db));
      final c = storyContainer(db, 0, [
        worldManagerRepositoryProvider.overrideWithValue(failing),
      ]);
      final d = await StoryDriver.start(c, 42);
      final service = c.read(worldManagerServiceProvider);
      await expectLater(service.ensureSeeded(d.careerId), throwsStateError);
      expect(await failing.hasManagers(d.careerId), isFalse);
      await service.ensureSeeded(d.careerId);
      expect(failing.applies, 2);
      expect(await failing.hasManagers(d.careerId), isTrue);
      await _close(c, db);
    });
  }, timeout: const Timeout(Duration(minutes: 5)));

  testWidgets('ensureSeeded twice writes once', (tester) async {
    await tester.runAsync(() async {
      final o = await _openFixture();
      final service = o.c.read(worldManagerServiceProvider);
      await Future.wait([
        service.ensureSeeded(o.careerId),
        service.ensureSeeded(o.careerId),
      ]);
      final first = await o.c
          .read(worldManagerRepositoryProvider)
          .load(o.careerId);
      await service.ensureSeeded(o.careerId);
      // A fresh service (the app restarted) finds the rows and adds none.
      o.c.invalidate(worldManagerServiceProvider);
      await o.c.read(worldManagerServiceProvider).ensureSeeded(o.careerId);
      final again = await o.c
          .read(worldManagerRepositoryProvider)
          .load(o.careerId);
      expect(first.managers, isNotEmpty);
      expect(again.managers.length, first.managers.length);
      expect(again.spells.length, first.spells.length);
      expect(await AppLog.read(), contains('mgr-seed'));
      expect(
        RegExp('mgr-seed').allMatches(await AppLog.read()).length,
        1,
        reason: 'logged once: seeded once',
      );
      await _close(o.c, o.db);
    });
  }, timeout: const Timeout(Duration(minutes: 5)));

  testWidgets('an upgraded 1.1.0 (37) mid_cycle fixture seeds as of its own '
      'cycle', (tester) async {
    await tester.runAsync(() async {
      final o = await _openFixture();
      final career = (await o.c
          .read(careerRepositoryProvider)
          .byId(o.careerId))!;
      final manifest = readManifest('v110_37', 'mid_cycle');
      expect(career.cyclePointer, manifest.cyclePointer);
      await o.c.read(worldManagerServiceProvider).ensureSeeded(o.careerId);
      final w = await o.c.read(worldManagerRepositoryProvider).load(o.careerId);
      final asOf = CareerService.cycleOpens(career.cyclePointer);
      final nations = await o.c
          .read(nationRepositoryProvider)
          .forCareer(o.careerId);
      final current = w.spells.where((s) => s.current).toList();
      expect(current.length, nations.length - 1);
      expect(w.free(asOf).length, 60);
      for (final s in current) {
        expect(s.fromDate.isAfter(asOf), isFalse);
        expect(
          s.fromDate.isBefore(DateTime(asOf.year - 6, asOf.month, asOf.day)),
          isFalse,
        );
        expect(
          s.contractUntil.isBefore(
            DateTime(asOf.year + 1, asOf.month, asOf.day),
          ),
          isFalse,
        );
      }
      expect(w.currentAt(career.nationId), isNull);
      // Every manager is named from a pool: two words or more, never blank.
      for (final m in w.managers) {
        expect(m.name.trim().split(' ').length, greaterThanOrEqualTo(2));
        expect(m.nationality, m.nationality.toUpperCase());
      }
      // Seeded as of the cycle's opening, not the save's date, which lies
      // well past it.
      expect(career.inGameDate.isAfter(asOf), isTrue);
      await _close(o.c, o.db);
    });
  }, timeout: const Timeout(Duration(minutes: 5)));

  testWidgets('seeding the 1.1.0 (37) fixture takes one transaction', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final counter = _BeginCounter();
      final o = await _openFixture(interceptor: counter);
      counter.begins = 0;
      await o.c.read(worldManagerServiceProvider).ensureSeeded(o.careerId);
      expect(counter.begins, 1);
      expect(
        await o.c.read(worldManagerRepositoryProvider).hasManagers(o.careerId),
        isTrue,
      );
      await _close(o.c, o.db);
    });
  }, timeout: const Timeout(Duration(minutes: 5)));
}
