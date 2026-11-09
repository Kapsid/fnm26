import 'package:drift/drift.dart'
    show ApplyInterceptor, QueryExecutor, QueryInterceptor, Variable;
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/world_managers/manager_decisions.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart'
    show kMatchViewModePrefsKey;
import 'package:fnm/features/world_managers/world_manager_markers.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
import 'package:fnm/features/world_managers/world_manager_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../story/driver.dart';

/// Counts the reads that touch the `fixtures` table.
class _FixtureReads extends QueryInterceptor {
  int reads = 0;
  static final _fixtures = RegExp(r'\bfixtures\b');

  @override
  Future<List<Map<String, Object?>>> runSelect(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    if (_fixtures.hasMatch(statement)) reads++;
    return super.runSelect(executor, statement, args);
  }
}

/// The real service, except that every manager pass throws, as a bug in
/// one would. Notes, at each finals call, whether the continental honours
/// were already on the roll (the finals' own work runs first).
class _Throwing extends WorldManagerService {
  // ignore: matching_super_parameters, the service keeps its ref private.
  _Throwing(super.ref) : _r = ref;

  final Ref _r;
  final calls = <String>[];
  bool continentalsFirst = true;

  @override
  Future<List<ManagerMove>> afterFinals(
    int careerId, {
    required String key,
    required Set<int> scope,
    required DateTime date,
  }) async {
    calls.add(key);
    if (key.startsWith('wc:')) {
      final names = {
        for (final h
            in await _r.read(competitionRepositoryProvider).honours(careerId))
          if (h.year == date.year - 2) h.competition,
      };
      for (final cup in ContinentalCups.byConfederation.values) {
        if (!names.contains(cup.name)) continentalsFirst = false;
      }
    }
    throw StateError('manager pass bug');
  }

  @override
  Future<List<ManagerMove>> atRollover(
    int careerId, {
    required int nextCycle,
  }) async {
    calls.add('rollover:$nextCycle');
    throw StateError('manager pass bug');
  }
}

typedef _Save = ({
  AppDatabase db,
  ProviderContainer c,
  int careerId,
  List<Nation> nations,
  int playerNationId,
});

/// The World Championship of cycle 0 and Europe's championship before it.
final _wcDate = DateTime(2030, 7, 19);
final _euroDate = DateTime(2028, 7, 10);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUp(() => AppLog.debugUse(null));

  Future<_Save> start({
    QueryInterceptor? interceptor,
    List<Override> overrides = const [],
  }) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      kMatchViewModePrefsKey: 'timeline',
    });
    final native = NativeDatabase.memory();
    final db = AppDatabase.forTesting(
      interceptor == null ? native : native.interceptWith(interceptor),
    );
    final c = storyContainer(db, 0, overrides);
    addTearDown(() async {
      c.dispose();
      await db.close();
    });
    final d = await StoryDriver.start(c, 7);
    final career = (await c.read(careerRepositoryProvider).byId(d.careerId))!;
    return (
      db: db,
      c: c,
      careerId: d.careerId,
      nations: await c.read(nationRepositoryProvider).forCareer(d.careerId),
      playerNationId: career.nationId,
    );
  }

  /// Stubs every fixture before [upTo]: the better-ranked side loses 0-4,
  /// so the world's favourites all miss their briefs badly.
  Future<void> upsets(_Save s, DateTime upTo) async {
    final rank = {for (final n in s.nations) n.id: n.ranking};
    final fixtures = await s.c
        .read(competitionRepositoryProvider)
        .allFixtures(s.careerId);
    await s.db.transaction(() async {
      for (final f in fixtures) {
        if (!f.date.isBefore(upTo)) continue;
        final homeBetter =
            (rank[f.homeNationId] ?? 999) < (rank[f.awayNationId] ?? 999);
        final home = homeBetter ? 0 : 4;
        await s.db.customStatement(
          'UPDATE fixtures SET played = 1, home_score = ?, away_score = ? '
          'WHERE id = ?',
          [home, 4 - home, f.id],
        );
      }
    });
  }

  Future<ManagerWorld> world(_Save s) =>
      s.c.read(worldManagerRepositoryProvider).load(s.careerId);

  Future<bool> marked(_Save s, int cycle, String kind) => s.c
      .read(competitionRepositoryProvider)
      .hasWatchedDraw(s.careerId, cycle, kind);

  String spellsOf(ManagerWorld w, bool Function(int nationId) only) {
    final rows = [
      for (final sp in w.spells)
        if (only(sp.nationId))
          [
            sp.spellNo,
            sp.managerId,
            sp.nationId,
            sp.fromDate,
            sp.toDate,
            sp.endReason,
            sp.contractUntil,
            sp.briefNet,
          ].join(':'),
    ]..sort();
    return rows.join('\n');
  }

  test('a decided World Championship runs one pass', () async {
    final s = await start();
    await upsets(s, _wcDate);
    final service = s.c.read(worldManagerServiceProvider);
    final moves = await service.afterFinals(
      s.careerId,
      key: 'wc:2030',
      scope: {for (final n in s.nations) n.id},
      date: _wcDate,
    );
    expect(moves, isNotEmpty, reason: 'favourites who all missed');
    expect(moves.where((m) => m.why == SpellEnd.sacked), isNotEmpty);
    expect(await marked(s, 0, mgrDecidedKind('wc:2030')), isTrue);
    expect(moves.map((m) => m.nationId), isNot(contains(s.playerNationId)));

    final w = await world(s);
    final closed = w.spells.where((sp) => sp.toDate == _wcDate).toList();
    expect(
      closed.length,
      moves.where((m) => m.outgoingId != null).length,
      reason: 'every departure is a closed spell, dated on the final',
    );
    // At most a quarter of the world changes at one point.
    expect(closed.length, lessThanOrEqualTo(s.nations.length ~/ 4));
    // Every AI nation has a manager the day after.
    for (final n in s.nations) {
      if (n.id == s.playerNationId) continue;
      expect(w.inChargeOn(n.id, _wcDate), isNotNull, reason: n.name);
    }
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('re-running the hook is a no-op', () async {
    final s = await start();
    await upsets(s, _wcDate);
    final service = s.c.read(worldManagerServiceProvider);
    final all = {for (final n in s.nations) n.id};
    final first = await service.afterFinals(
      s.careerId,
      key: 'wc:2030',
      scope: all,
      date: _wcDate,
    );
    expect(first, isNotEmpty);
    final before = spellsOf(await world(s), (_) => true);
    final again = await service.afterFinals(
      s.careerId,
      key: 'wc:2030',
      scope: all,
      date: _wcDate,
    );
    expect(again, isEmpty);
    expect(spellsOf(await world(s), (_) => true), before);
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('a continental honour only touches its confederation', () async {
    final s = await start();
    await upsets(s, _euroDate);
    final service = s.c.read(worldManagerServiceProvider);
    await service.ensureSeeded(s.careerId);
    final europe = {
      for (final n in s.nations)
        if (n.confederation == Confederation.europe) n.id,
    };
    final outside = spellsOf(await world(s), (n) => !europe.contains(n));
    final moves = await service.afterFinals(
      s.careerId,
      key: 'cont:EUROPE:2028',
      scope: europe,
      date: _euroDate,
    );
    expect(moves, isNotEmpty);
    for (final m in moves) {
      expect(europe, contains(m.nationId));
    }
    expect(spellsOf(await world(s), (n) => !europe.contains(n)), outside);
    expect(await marked(s, 0, mgrDecidedKind('cont:EUROPE:2028')), isTrue);
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('a rollover runs retirements and poaching', () async {
    final s = await start();
    final service = s.c.read(worldManagerServiceProvider);
    final repo = s.c.read(worldManagerRepositoryProvider);
    await service.ensureSeeded(s.careerId);
    await s.c
        .read(competitionRepositoryProvider)
        .markDrawWatched(s.careerId, 1, worldManagersKind);

    final ai = [
      for (final n in s.nations)
        if (n.id != s.playerNationId) n,
    ]..sort((a, b) => a.ranking.compareTo(b.ranking));
    final top = ai.first;
    final strong = ai.firstWhere((n) => n.ranking >= top.ranking + 25);
    final old = ai.last;
    final w = await world(s);
    final byId = {for (final m in w.managers) m.managerId: m};
    final topSpell = w.currentAt(top.id)!;
    final strongSpell = w.currentAt(strong.id)!;
    final oldSpell = w.currentAt(old.id)!;
    final aged = byId[oldSpell.managerId]!;
    await repo.apply(
      s.careerId,
      ManagerChanges(
        // The top nation's man is gone: a vacancy at a top-40 nation.
        closed: [topSpell.close(_wcDate, SpellEnd.sacked)],
        // A manager far above the free pool, ranked well below it.
        renewed: [
          ManagerSpell(
            spellNo: strongSpell.spellNo,
            managerId: strongSpell.managerId,
            nationId: strongSpell.nationId,
            fromDate: strongSpell.fromDate,
            contractUntil: DateTime(2034),
            briefNet: 25,
          ),
        ],
        updated: [
          // He is 45: no chance of retiring.
          _born(byId[strongSpell.managerId]!, 1985),
          // An eighty-year-old, who retires for certain.
          _born(aged, 1950),
        ],
      ),
    );

    final moves = await service.atRollover(s.careerId, nextCycle: 1);
    final opens = CareerService.cycleOpens(1);
    expect(
      moves.where((m) => m.nationId == old.id && m.why == SpellEnd.retired),
      isNotEmpty,
      reason: 'the eighty-year-old retires',
    );
    final poach = moves.where((m) => m.why == SpellEnd.poached).toList();
    expect(
      poach.map((m) => m.nationId),
      contains(strong.id),
      reason: 'a vacant top-40 nation takes the far better man',
    );
    final poachedBy = moves.firstWhere(
      (m) => m.incomingId == strongSpell.managerId,
    );
    expect(
      ai.indexWhere((n) => n.id == poachedBy.nationId),
      lessThan(ManagerDecisions.poachTopRank),
    );
    expect(
      moves.firstWhere((m) => m.nationId == top.id).incomingId,
      isNotNull,
      reason: 'the vacancy is filled',
    );
    expect(await marked(s, 1, mgrRolloverKind), isTrue);
    final after = await world(s);
    for (final n in ai) {
      expect(after.inChargeOn(n.id, opens), isNotNull, reason: n.name);
    }
    expect(await service.atRollover(s.careerId, nextCycle: 1), isEmpty);
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('an unmarked cycle runs no pass', () async {
    final s = await start();
    await upsets(s, _wcDate);
    await s.db.customStatement(
      'DELETE FROM draws_watched WHERE career_id = ? AND kind = ?',
      [s.careerId, worldManagersKind],
    );
    final service = s.c.read(worldManagerServiceProvider);
    expect(
      await service.afterFinals(
        s.careerId,
        key: 'wc:2030',
        scope: {for (final n in s.nations) n.id},
        date: _wcDate,
      ),
      isEmpty,
    );
    expect(await service.atRollover(s.careerId, nextCycle: 1), isEmpty);
    expect(
      await s.c.read(worldManagerRepositoryProvider).hasManagers(s.careerId),
      isFalse,
      reason: 'an unmarked cycle seeds nothing',
    );
    expect(await marked(s, 0, mgrDecidedKind('wc:2030')), isFalse);
    final n = await s.db
        .customSelect(
          'SELECT COUNT(*) AS n FROM draws_watched '
          "WHERE career_id = ? AND kind LIKE 'mgr%'",
          variables: [Variable<int>(s.careerId)],
        )
        .map((r) => r.read<int>('n'))
        .getSingle();
    expect(n, 0);
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('a pass reads fixtures once', () async {
    final reads = _FixtureReads();
    final s = await start(interceptor: reads);
    await upsets(s, _wcDate);
    reads.reads = 0;
    final moves = await s.c
        .read(worldManagerServiceProvider)
        .afterFinals(
          s.careerId,
          key: 'wc:2030',
          scope: {for (final n in s.nations) n.id},
          date: _wcDate,
        );
    expect(moves, isNotEmpty);
    // The decision reads the cycle's fixtures once (2 at most); the news it
    // files then reads the player's own fixtures, once per nation he has
    // led (one here).
    expect(reads.reads, lessThanOrEqualTo(2 + 1));
  }, timeout: const Timeout(Duration(minutes: 5)));

  test(
    'a throwing manager pass stops neither the finals nor the rollover',
    () async {
      final s = await start(
        overrides: [worldManagerServiceProvider.overrideWith(_Throwing.new)],
      );
      final spy = s.c.read(worldManagerServiceProvider) as _Throwing;
      final d = StoryDriver(s.c, s.careerId);
      // The whole cycle plays to its rollover, every pass throwing.
      while (await d.step(stopAtRollover: true)) {}
      final comp = s.c.read(competitionRepositoryProvider);
      expect(await comp.worldChampion(s.careerId), isNotNull);
      expect(spy.calls, contains('wc:2030'));
      expect(
        spy.continentalsFirst,
        isTrue,
        reason: 'the pass runs after the backstop, after the ranking settles',
      );
      // The rollover builds the next cycle's calendar regardless.
      await d.step();
      final career = (await s.c
          .read(careerRepositoryProvider)
          .byId(s.careerId))!;
      expect(career.cyclePointer, 1);
      expect(spy.calls, contains('rollover:1'));
      expect((await comp.cycleFixtures(s.careerId, 1)).fixtures, isNotEmpty);
      // No pass succeeded, so none is marked as run.
      expect(await marked(s, 0, mgrDecidedKind('wc:2030')), isFalse);
      expect(await marked(s, 1, mgrRolloverKind), isFalse);
    },
    timeout: const Timeout(Duration(minutes: 15)),
  );
}

/// [m], born in [year].
WorldManager _born(WorldManager m, int year) => WorldManager(
  managerId: m.managerId,
  name: m.name,
  nationality: m.nationality,
  birthYear: year,
  style: m.style,
  origin: m.origin,
  enteredAt: m.enteredAt,
  retiredAt: m.retiredAt,
  sourceId: m.sourceId,
);
