import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/real_internationals.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/world_managers/manager_decisions.dart';
import 'package:fnm/domain/services/world_managers/manager_seeder.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_managers/manager_windows.dart';
import 'package:fnm/features/world_managers/world_manager_markers.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart'
    show worldManagerStyleEnabledProvider;
import 'package:fnm/features/world_pack/world_pack_providers.dart'
    show worldPackRepositoryProvider;

/// The world managers of a career: seeded the first time something asks
/// for them, and read by date.
///
/// Seeding never runs on its own: not when a career opens, not on a hub
/// read. Only [ensureSeeded] (directly, or through [styleOn]) seeds.
class WorldManagerService {
  WorldManagerService(this._ref);

  final Ref _ref;

  /// One seeding per career, shared by every caller while it runs. A failed
  /// one is forgotten, so the next caller tries again.
  final Map<int, Future<void>> _seeding = {};

  /// Seeds career [careerId]'s managers unless it has them already: as of
  /// the day its current cycle opened, in one transaction.
  Future<void> ensureSeeded(int careerId) =>
      _seeding[careerId] ??= _seedOnce(careerId);

  Future<void> _seedOnce(int careerId) async {
    try {
      await _seed(careerId);
    } on Object {
      _seeding.removeWhere((id, _) => id == careerId);
      rethrow;
    }
  }

  /// Every real person the pools are known to be able to name, whatever
  /// the era: a manager is named once, when he is seeded, so guarding them
  /// all moves nobody's name.
  static final Set<String> _realNames = {
    ...realFinlandInternationals,
    for (final m in [
      guardedNamesByNation,
      guardedNamesFullPoolsByNation,
      guardedNamesPoolsV4ByNation,
      guardedNamesPoolsV5ByNation,
    ])
      for (final names in m.values) ...names,
  };

  Future<void> _seed(int careerId) async {
    final repo = _ref.read(worldManagerRepositoryProvider);
    if (await repo.hasManagers(careerId)) return;
    final watch = Stopwatch()..start();
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return;
    final seedCycle = career.cyclePointer;
    final players = _ref.read(playerRepositoryProvider);
    final nations = await _ref
        .read(nationRepositoryProvider)
        .forCareer(careerId);
    final snapshot = await _ref
        .read(seedRankingRepositoryProvider)
        .forCycle(careerId, seedCycle);
    final world = ManagerSeeder.seed(
      rngSeed: career.rngSeed,
      seedCycle: seedCycle,
      asOf: CareerService.cycleOpens(seedCycle),
      nations: nations,
      // The cycle's seeding snapshot; the live table only where there is
      // none (a cycle 0 from before snapshots).
      rankById: snapshot.isNotEmpty
          ? snapshot
          : {for (final n in nations) n.id: n.ranking},
      playerNationIds: {career.nationId},
      pools: await players.namePoolsFor(careerId),
      defaultPools: await players.namePoolsFor(careerId, worldLists: false),
      // Checked again here: a world can come in by a career bundle too.
      packManagers: WorldPack.usableManagers(
        await _ref.read(worldPackRepositoryProvider).managersFor(careerId),
        nationIds: {for (final n in nations) n.id},
        codes: {for (final n in nations) n.code.toUpperCase()},
        dropped: (id, why) =>
            AppLog.info('mgr-seed', 'manager of nation $id dropped: $why'),
      ),
      realNames: _realNames,
    );
    await repo.apply(
      careerId,
      ManagerChanges(added: world.managers, opened: world.spells),
    );
    AppLog.info('mgr-seed', '${watch.elapsedMilliseconds} ms');
  }

  /// Whether the cycle open on [date] is run by world managers.
  Future<bool> cycleHasManagers(int careerId, DateTime date) => _ref
      .read(competitionRepositoryProvider)
      .hasWatchedDraw(careerId, CareerService.cycleAt(date), worldManagersKind);

  /// The style of the manager in charge of [nationId] on [date]: the style
  /// the AI's tactics blend into the nation's own (`AiTactics.forOpponent`).
  /// Null when that date's cycle is not run by world managers, when nobody
  /// was in charge, or when manager style is switched off
  /// ([worldManagerStyleEnabledProvider]); the nation's own style is read
  /// alone then, exactly as before world managers.
  ///
  /// Every AI-tactics reading (the live match, the skip path, the scout's
  /// replays) asks this with the FIXTURE's date, never today's, so all of
  /// them meet the same manager for the same fixture.
  ///
  /// It sits on the match hot paths, so it reads two indexed rows (the
  /// spell in charge, then its manager) rather than the whole manager world,
  /// and keeps no cache that a later write could leave stale.
  Future<NationStyle?> styleOn(
    int careerId,
    int nationId,
    DateTime date,
  ) async {
    if (!_ref.read(worldManagerStyleEnabledProvider)) return null;
    if (!await cycleHasManagers(careerId, date)) return null;
    await ensureSeeded(careerId);
    final repo = _ref.read(worldManagerRepositoryProvider);
    final spell = await repo.inChargeOn(careerId, nationId, date);
    if (spell == null) return null;
    final manager = await repo.managerById(careerId, spell.managerId);
    if (manager == null) return null;
    return NationStyle.values.asNameMap()[manager.style];
  }

  /// The decision point after a finals tournament settles: [key] is the
  /// tournament's ([ManagerWindows.worldKey] or
  /// [ManagerWindows.continentalKey]), [scope] the nations whose brief it
  /// settles, [date] the day of its final. Runs once per [key], and only in
  /// a cycle run by world managers; returns the moves it made.
  Future<List<ManagerMove>> afterFinals(
    int careerId, {
    required String key,
    required Set<int> scope,
    required DateTime date,
  }) {
    final cycle = CareerService.cycleAt(date);
    return _pass(
      careerId,
      cycle: cycle,
      closing: cycle,
      marker: mgrDecidedKind(key),
      key: key,
      scope: scope,
      date: date,
      rollover: false,
    );
  }

  /// The decision point of the rollover into [nextCycle], on the day it
  /// opens: retirements, contracts, poaching and hiring across the world.
  /// Called once the cycle pointer has moved and [nextCycle]'s seeding
  /// ranking is frozen; runs once, and only if [nextCycle] is marked
  /// [worldManagersKind].
  Future<List<ManagerMove>> atRollover(
    int careerId, {
    required int nextCycle,
  }) => _pass(
    careerId,
    cycle: nextCycle,
    closing: nextCycle - 1,
    marker: mgrRolloverKind,
    key: 'rollover:$nextCycle',
    scope: null,
    date: CareerService.cycleOpens(nextCycle),
    rollover: true,
  );

  /// One decision point. [cycle] is the cycle the point belongs to (its
  /// markers live there); [closing] is the cycle whose results it judges,
  /// the same one except at a rollover. [scope] null is every nation.
  ///
  /// Reads: the managers once, the [closing] cycle's competitions and
  /// fixtures once, the honours once, the seeding rankings, and a marker per
  /// earlier finals point. Writes the changes and [marker] in one
  /// transaction.
  Future<List<ManagerMove>> _pass(
    int careerId, {
    required int cycle,
    required int closing,
    required String marker,
    required String key,
    required Set<int>? scope,
    required DateTime date,
    required bool rollover,
  }) async {
    final comp = _ref.read(competitionRepositoryProvider);
    if (!await comp.hasWatchedDraw(careerId, cycle, worldManagersKind)) {
      return const [];
    }
    if (await comp.hasWatchedDraw(careerId, cycle, marker)) return const [];
    await ensureSeeded(careerId);
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return const [];
    final repo = _ref.read(worldManagerRepositoryProvider);
    final w = await repo.load(careerId);
    final nations = await _ref
        .read(nationRepositoryProvider)
        .forCareer(careerId);
    final rankings = _ref.read(seedRankingRepositoryProvider);
    Future<Map<int, int>> rankOf(int c) async {
      final snap = await rankings.forCycle(careerId, c);
      return snap.isNotEmpty
          ? snap
          : {for (final n in nations) n.id: n.ranking};
    }

    final rankById = await rankOf(cycle);
    final inScope = scope ?? {for (final n in nations) n.id};
    final players = {career.nationId};

    // The windows. A rollover judges only a cycle that was itself run by
    // world managers: an upgraded save's first cycle had none, and its
    // results sack nobody.
    final windows = <int, NationWindow>{};
    final metOn = <int, DateTime>{};
    if (!rollover ||
        await comp.hasWatchedDraw(careerId, closing, worldManagersKind)) {
      final read = await comp.cycleFixtures(careerId, closing);
      final briefs = ManagerWindows(
        nations: nations,
        baseline: closing == cycle ? rankById : await rankOf(closing),
        competitions: read.competitions,
        fixtures: read.fixtures,
      );
      _windows(
        briefs,
        windows: windows,
        metOn: metOn,
        w: w,
        scope: inScope,
        players: players,
        own: rollover ? null : ManagerWindows.fromKey(key, date),
        ran: {
          for (final t in briefs.decided)
            if (t.key != key &&
                t.finalOn.isBefore(date) &&
                await comp.hasWatchedDraw(
                  careerId,
                  closing,
                  mgrDecidedKind(t.key),
                ))
              t.key,
        },
        opens: CareerService.cycleOpens(closing),
        date: date,
      );
    }

    final changes = ManagerDecisions.decide(
      w,
      windows,
      (
        date: date,
        rankById: rankById,
        scope: inScope,
        playerNationIds: players,
        rngSeed: career.rngSeed,
        key: key,
        rollover: rollover,
      ),
      honoursByManager: _honoursByManager(await comp.honours(careerId), w),
      finalsBriefMetOn: metOn,
      codeById: {for (final n in nations) n.id: n.code},
    );

    var applied = false;
    await _ref.read(appDatabaseProvider).transaction(() async {
      if (await comp.hasWatchedDraw(careerId, cycle, marker)) return;
      await repo.apply(careerId, changes);
      await comp.markDrawWatched(careerId, cycle, marker);
      applied = true;
    });
    if (!applied) return const [];
    AppLog.info(
      'mgr-pass',
      '$key: ${changes.moves.length} moves, ${windows.length} windows',
    );
    return changes.moves;
  }

  /// Fills [windows] and [metOn] for the AI nations of [scope] that have a
  /// manager in charge.
  ///
  /// A nation's window runs from the later of its manager's start and its
  /// last decision point (the closing cycle's opening [opens], or an earlier
  /// finals point that [ran]) up to [date]. The briefs settled in it are
  /// [own] (the point's own tournament) and any other tournament whose final
  /// fell inside it without its own point having run; a nation with none
  /// gets no window at all, so a rollover judges contracts on the score each
  /// spell carries.
  ///
  /// [metOn] is the shield's memory, which nothing stores: the day of the
  /// latest earlier finals point that [ran] in the last 12 months at which
  /// the nation met its brief, re-read from the same fixtures. Finals points
  /// are two years apart, so the only one ever inside 12 months is the
  /// World Championship before its rollover, in the same cycle.
  static void _windows(
    ManagerWindows briefs, {
    required Map<int, NationWindow> windows,
    required Map<int, DateTime> metOn,
    required ManagerWorld w,
    required Set<int> scope,
    required Set<int> players,
    required SettlingTournament? own,
    required Set<String> ran,
    required DateTime opens,
    required DateTime date,
  }) {
    final yearAgo = DateTime(date.year - 1, date.month, date.day);
    for (final n in scope) {
      if (players.contains(n)) continue;
      final spell = w.currentAt(n);
      if (spell == null) continue;
      var from = spell.fromDate.isAfter(opens) ? spell.fromDate : opens;
      for (final t in briefs.decided) {
        if (!ran.contains(t.key) || !briefs.touches(n, t)) continue;
        if (t.finalOn.isAfter(from)) from = t.finalOn;
        if (t.finalOn.isAfter(yearAgo) && briefs.met(n, t)) {
          final seen = metOn[n];
          if (seen == null || t.finalOn.isAfter(seen)) metOn[n] = t.finalOn;
        }
      }
      final settled = [
        if (own != null && briefs.touches(n, own)) own,
        for (final t in briefs.decided)
          if (t.key != own?.key &&
              !ran.contains(t.key) &&
              briefs.touches(n, t) &&
              t.finalOn.isAfter(from) &&
              !t.finalOn.isAfter(date))
            t,
      ];
      final win = briefs.window(n, from: from, to: date, settled: settled);
      if (win != null) windows[n] = win;
    }
  }

  /// Each manager's major titles (World Championships and continental
  /// championships this career has played): credited to whoever was in
  /// charge of the champion mid-tournament, the 15th of the month it is
  /// played in. No decision point falls inside a nation's own tournament,
  /// so that is the man who took it to the final.
  static Map<int, int> _honoursByManager(
    List<Honour> honours,
    ManagerWorld w,
  ) {
    final month = {
      'World Championship': 6,
      for (final cup in ContinentalCups.byConfederation.values)
        cup.name: cup.month,
    };
    final out = <int, int>{};
    for (final h in honours) {
      final m = month[h.competition];
      if (m == null || !CareerService.isOwnHonourYear(h.year)) continue;
      final on = DateTime(h.year, m, 15);
      for (final nationId in h.champions) {
        final spell = w.inChargeOn(nationId, on);
        if (spell == null) continue;
        out[spell.managerId] = (out[spell.managerId] ?? 0) + 1;
      }
    }
    return out;
  }
}
