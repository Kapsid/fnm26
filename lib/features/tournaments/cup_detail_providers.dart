import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';

/// Data for the cup-detail (World Championship) screen.
class CupData {
  const CupData({
    required this.groups,
    required this.nations,
    required this.playerNationId,
  });

  final List<GroupTable> groups;
  final Map<int, Nation> nations;
  final int playerNationId;
}

final AutoDisposeFutureProviderFamily<CupData?, int> cupDetailProvider =
    FutureProvider.autoDispose.family<CupData?, int>((ref, careerId) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final groups =
          await ref.watch(competitionRepositoryProvider).allGroupTables(
                careerId,
              );
      final nations = {
        for (final n in await ref.watch(nationRepositoryProvider).all())
          n.id: n,
      };
      return CupData(
        groups: groups,
        nations: nations,
        playerNationId: career.nationId,
      );
    });
