import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';

/// Everything the tactics screen needs for a save.
class TacticData {
  const TacticData({
    required this.tactic,
    required this.pool,
    required this.byId,
  });

  final Tactic tactic;

  /// The nation's full player pool (selectable squad).
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
  final pool =
      await ref.watch(playerRepositoryProvider).byNation(career.nationId);
  return TacticData(
    tactic: tactic,
    pool: pool,
    byId: {for (final p in pool) p.id: p},
  );
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
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    final pool = career == null
        ? <Player>[]
        : await _ref.read(playerRepositoryProvider).byNation(career.nationId);
    await repo.saveTactic(careerId, change(current, pool));
    _ref.invalidate(tacticDataProvider);
  }

  Future<void> setFormation(int careerId, Formation formation) => _update(
        careerId,
        (t, pool) => t.copyWith(
          formation: formation,
          lineup: bestEleven(formation, pool),
        ),
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
}

final Provider<TacticService> tacticServiceProvider =
    Provider(TacticService.new);
