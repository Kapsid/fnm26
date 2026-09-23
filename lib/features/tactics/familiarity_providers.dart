import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/formation.dart';

/// How drilled the side is in each shape it has actually been fielded in —
/// familiarity only, `0..1`, and shapes never played left out.
///
/// The stored record carries a second figure beside familiarity:
/// predictability, how well opponents have read the side. That one is hidden
/// by design (see `TeamChemistry`) — it is what the opposition knows, not what
/// the manager is told — so it is dropped HERE, at the boundary, rather than
/// carried into the widget layer and trusted not to be drawn. A
/// `Map<Formation, double>` cannot leak what it cannot hold.
final AutoDisposeFutureProviderFamily<Map<Formation, double>, int>
shapeDrillingProvider = FutureProvider.autoDispose
    .family<Map<Formation, double>, int>((ref, careerId) async {
      final stored = await ref
          .watch(tacticFamiliarityRepositoryProvider)
          .forCareer(careerId);
      return {
        for (final entry in stored.entries) entry.key: entry.value.familiarity,
      };
    });
