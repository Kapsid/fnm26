import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';

/// Smallest squad a manager may call up (must field an XI plus cover).
const int kMinSquadSize = 16;

/// Largest squad a manager may call up (a full tournament squad).
const int kMaxSquadSize = 23;

/// Resolves the squad actually available for selection from a nation [pool]
/// given the manager's [callUps]. An empty call-up set means the whole pool is
/// available (the default for new/legacy saves).
List<Player> availableSquad(List<Player> pool, Set<int> callUps) {
  if (callUps.isEmpty) return pool;
  return pool.where((p) => callUps.contains(p.id)).toList();
}

/// Everything the tactics screen needs for a save.
class TacticData {
  const TacticData({
    required this.tactic,
    required this.pool,
    required this.byId,
  });

  final Tactic tactic;

  /// The called-up squad (selectable for the XI and bench).
  final List<Player> pool;
  final Map<int, Player> byId;
}

final FutureProviderFamily<TacticData?, int> tacticDataProvider =
    FutureProvider.family<TacticData?, int>((ref, careerId) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final tactic = await ref.watch(tacticsRepositoryProvider).tacticForCareer(
        careerId,
      );
  if (tactic == null) return null;
  final fullPool =
      await ref.watch(playerRepositoryProvider).byNation(
        career.nationId,
        agingCycles: career.cyclePointer,
      );
  final callUps = await ref.watch(squadRepositoryProvider).callUps(careerId);
  final pool = availableSquad(fullPool, callUps);
  return TacticData(
    tactic: tactic,
    pool: pool,
    // Resolve over the full pool so the XI renders even if a player was just
    // dropped from the squad (the squad service repairs the lineup on save).
    byId: {for (final p in fullPool) p.id: p},
  );
});

/// Everything the call-up (squad selection) screen needs for a save.
class SquadData {
  const SquadData({
    required this.pool,
    required this.callUps,
    required this.absences,
  });

  /// The full nation pool, eligible to be called up.
  final List<Player> pool;

  /// The currently called-up player ids (every pool member when none have been
  /// explicitly chosen yet).
  final Set<int> callUps;

  /// Suspension/injury standing keyed by player id (only notable players).
  final Map<int, PlayerAbsence> absences;
}

final FutureProviderFamily<SquadData?, int> squadDataProvider =
    FutureProvider.family<SquadData?, int>((ref, careerId) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final pool =
      await ref.watch(playerRepositoryProvider).byNation(
        career.nationId,
        agingCycles: career.cyclePointer,
      );
  final stored = await ref.watch(squadRepositoryProvider).callUps(careerId);
  final callUps = stored.isEmpty ? {for (final p in pool) p.id} : stored;
  final absences =
      await ref.watch(absenceRepositoryProvider).forCareer(careerId);
  return SquadData(pool: pool, callUps: callUps, absences: absences);
});

/// Mutates and persists the team tactic for a save.
class TacticService {
  TacticService(this._ref);

  final Ref _ref;

  Future<void> _update(
    int careerId,
    Tactic Function(Tactic current, List<Player> pool) change,
  ) async {
    final repo = _ref.read(tacticsRepositoryProvider);
    final current = await repo.tacticForCareer(careerId);
    if (current == null) return;
    final pool = await _availablePool(careerId);
    await repo.saveTactic(careerId, change(current, pool));
    _ref.invalidate(tacticDataProvider);
  }

  Future<List<Player>> _availablePool(int careerId) async {
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return const [];
    final pool =
        await _ref.read(playerRepositoryProvider).byNation(
          career.nationId,
          agingCycles: career.cyclePointer,
        );
    final callUps = await _ref.read(squadRepositoryProvider).callUps(careerId);
    return availableSquad(pool, callUps);
  }

  Future<void> setFormation(int careerId, Formation formation) => _update(
        careerId,
        (t, pool) => t.copyWith(
          formation: formation,
          lineup: bestEleven(formation, pool),
        ),
      );

  /// Changes the shape but keeps the players currently in the XI, re-fitting
  /// them to the new formation's slots (used when a drag reshapes the team, so
  /// dragging one player doesn't reshuffle the whole side from the pool).
  Future<void> reshapeFormation(int careerId, Formation formation) => _update(
        careerId,
        (t, pool) {
          final ids = t.lineup.whereType<int>().toSet();
          final current = pool.where((p) => ids.contains(p.id)).toList();
          final fitPool = current.length >= 11
              ? current
              : [...current, ...pool.where((p) => !ids.contains(p.id))];
          return t.copyWith(
            formation: formation,
            lineup: bestEleven(formation, fitPool),
          );
        },
      );

  Future<void> setInstructions(int careerId, TacticalInstructions i) =>
      _update(careerId, (t, _) => t.copyWith(instructions: i));

  /// Assigns [playerId] to [slot], swapping if they already start elsewhere.
  Future<void> setSlot(int careerId, int slot, int playerId) =>
      _update(careerId, (t, _) {
        final lineup = [...t.lineup];
        final existing = lineup.indexOf(playerId);
        if (existing != -1) lineup[existing] = lineup[slot];
        lineup[slot] = playerId;
        return t.copyWith(lineup: lineup);
      });

  /// Swaps the players occupying [slotA] and [slotB] (drag-and-drop on pitch).
  Future<void> swapSlots(int careerId, int slotA, int slotB) =>
      _update(careerId, (t, _) {
        if (slotA == slotB) return t;
        final lineup = [...t.lineup];
        final tmp = lineup[slotA];
        lineup[slotA] = lineup[slotB];
        lineup[slotB] = tmp;
        return t.copyWith(lineup: lineup);
      });
}

final Provider<TacticService> tacticServiceProvider =
    Provider(TacticService.new);

/// Mutates and persists the called-up squad for a save.
class SquadService {
  SquadService(this._ref);

  final Ref _ref;

  /// Replaces the called-up squad, then repairs the saved XI so it only
  /// contains called-up players (refilling dropped slots from the new squad).
  Future<void> setCallUps(int careerId, Set<int> ids) async {
    if (ids.length < kMinSquadSize) return;
    await _ref.read(squadRepositoryProvider).setCallUps(careerId, ids);

    final tacticRepo = _ref.read(tacticsRepositoryProvider);
    final tactic = await tacticRepo.tacticForCareer(careerId);
    if (tactic != null) {
      final career = await _ref.read(careerRepositoryProvider).byId(careerId);
      final pool = career == null
          ? <Player>[]
          : await _ref
              .read(playerRepositoryProvider)
              .byNation(career.nationId, agingCycles: career.cyclePointer);
      final squad = availableSquad(pool, ids);
      final dropped =
          tactic.lineup.whereType<int>().any((id) => !ids.contains(id));
      if (dropped) {
        await tacticRepo.saveTactic(
          careerId,
          tactic.copyWith(lineup: bestEleven(tactic.formation, squad)),
        );
      }
    }

    _ref
      ..invalidate(squadDataProvider)
      ..invalidate(tacticDataProvider);
  }
}

final Provider<SquadService> squadServiceProvider =
    Provider(SquadService.new);
