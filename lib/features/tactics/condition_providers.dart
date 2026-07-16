import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/squad/condition.dart';

/// Returns [p] with every attribute shifted by [delta] (their condition), so
/// the derived overall — and thus their weight in the match engine — reflects
/// form, fatigue and morale. A no-op when [delta] is zero.
Player withConditionDelta(Player p, int delta) {
  if (delta == 0) return p;
  int adj(int v) => (v + delta).clamp(1, 99);
  final a = p.attributes;
  return p.copyWith(
    attributes: a.copyWith(
      passing: adj(a.passing),
      shooting: adj(a.shooting),
      dribbling: adj(a.dribbling),
      tackling: adj(a.tackling),
      positioning: adj(a.positioning),
      composure: adj(a.composure),
      decisions: adj(a.decisions),
      pace: adj(a.pace),
      stamina: adj(a.stamina),
      strength: adj(a.strength),
    ),
  );
}

/// Team morale (0–100) for the manager's nation, derived from recent results.
final AutoDisposeFutureProviderFamily<int, int> moraleProvider =
    FutureProvider.autoDispose.family<int, int>((ref, careerId) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return 50;
  final fixtures = await ref
      .watch(competitionRepositoryProvider)
      .fixturesForNation(careerId, career.nationId);
  return Condition.morale(fixtures, career.nationId);
});

/// Every squad player's live condition (form + fatigue + the morale shift),
/// keyed by player id, for the manager's nation as of the current in-game date.
final AutoDisposeFutureProviderFamily<Map<int, PlayerCondition>, int>
    squadConditionProvider =
    FutureProvider.autoDispose.family<Map<int, PlayerCondition>, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return const {};
  final recent = await ref
      .watch(competitionRepositoryProvider)
      .recentRatingsByNation(careerId, career.nationId);
  final morale = await ref.watch(moraleProvider(careerId).future);
  final mDelta = Condition.moraleDelta(morale);
  final asOf = career.inGameDate;
  return {
    for (final entry in recent.entries)
      entry.key: Condition.of(
        [for (final r in entry.value) r.rating],
        [for (final r in entry.value) r.date],
        asOf,
        mDelta,
      ),
  };
});

/// A map of player id → net rating delta from condition, for the match engine
/// to apply. Read without watching (the match preview builds once).
Future<Map<int, int>> conditionDeltasFor(Ref ref, int careerId) async {
  final conditions = await ref.read(squadConditionProvider(careerId).future);
  return {
    for (final e in conditions.entries)
      if (e.value.overallDelta != 0) e.key: e.value.overallDelta,
  };
}
