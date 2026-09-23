import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/squad/captaincy.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

/// The current captain, or null if the manager has not named one — or if the
/// player they named is no longer available to wear it.
///
/// Resolved rather than trusted: a captain can retire, be dropped from the
/// squad or be left behind by a move to another nation, and a stale id would
/// otherwise quietly keep paying its morale bonus for a player who is not
/// there. The stored id is the manager's INTENT; this is the fact.
final AutoDisposeFutureProviderFamily<Player?, int> captainProvider =
    FutureProvider.autoDispose.family<Player?, int>((ref, careerId) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      final id = career?.captainPlayerId;
      if (career == null || id == null) return null;
      final squad = await ref.watch(squadDataProvider(careerId).future);
      if (squad == null) return null;
      if (!squad.callUps.contains(id)) return null;
      return squad.pool.where((p) => p.id == id).firstOrNull;
    });

/// The id the manager last gave the armband to, resolved or not.
///
/// [captainProvider] answers "who is leading the side out", which is null both
/// for a manager who never named anybody and for one whose captain is injured
/// or was left out — two different situations that need two different things
/// said about them. This is the raw INTENT, so the two can be told apart.
final AutoDisposeFutureProviderFamily<int?, int> storedCaptainIdProvider =
    FutureProvider.autoDispose.family<int?, int>((ref, careerId) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      return career?.captainPlayerId;
    });

/// The morale the current captain is worth (0 when there is none).
final AutoDisposeFutureProviderFamily<int, int> captainMoraleProvider =
    FutureProvider.autoDispose.family<int, int>((ref, careerId) async {
      final captain = await ref.watch(captainProvider(careerId).future);
      if (captain == null) return 0;
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      return Captaincy.moraleBonus(captain, saveSeed: career?.rngSeed ?? 0);
    });

/// Names [playerId] captain (null clears the armband).
///
/// Takes a [WidgetRef] rather than a `Ref`: naming a captain is something the
/// manager does from a screen, never something the simulation does to itself.
Future<void> setCaptain(WidgetRef ref, int careerId, int? playerId) async {
  await ref.read(careerRepositoryProvider).setCaptain(careerId, playerId);
  ref
    ..invalidate(captainProvider)
    // The stored INTENT is read straight from the career row, so it goes stale
    // the moment the row changes. Leaving it out meant taking the armband back
    // off somebody left the old id cached, and the pre-match strip went on
    // reporting a captain who could not play for a save that had no captain.
    ..invalidate(storedCaptainIdProvider)
    ..invalidate(captainMoraleProvider)
    ..invalidate(squadDataProvider);
}
