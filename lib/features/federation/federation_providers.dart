import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';

/// The youth-academy talent bonus for the manager's nation, keyed by the cycle
/// each newgen intake was born in. Derived from the committed per-cycle
/// investment allocations, so it re-produces identically on replay/restore.
/// Passed only for the player's own nation's pool.
final AutoDisposeFutureProviderFamily<Map<int, double>, int>
    youthBonusByCycleProvider =
    FutureProvider.autoDispose.family<Map<int, double>, int>((
  ref,
  careerId,
) async {
  final invests =
      await ref.watch(careerRepositoryProvider).investments(careerId);
  return {
    for (final e in invests.entries)
      if (e.value.youth > 0)
        e.key: FederationFinance.youthTalentBonus(e.value.youth),
  };
});
