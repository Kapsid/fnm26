import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/real_internationals.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/world_managers/manager_seeder.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
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
}
