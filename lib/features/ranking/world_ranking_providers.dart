import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';

/// World ranking data: all nations ordered by ranking, plus the player's id.
class RankingData {
  const RankingData({required this.nations, required this.playerNationId});

  final List<Nation> nations;
  final int playerNationId;
}

/// Selected confederation filter (null = all).
final selectedRankRegionProvider = StateProvider<Confederation?>((_) => null);

final AutoDisposeFutureProviderFamily<RankingData?, int> worldRankingProvider =
    FutureProvider.autoDispose.family<RankingData?, int>((ref, careerId) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      final nations = await ref.watch(nationRepositoryProvider).all();
      return RankingData(
        nations: nations, // already ordered by ranking
        playerNationId: career?.nationId ?? -1,
      );
    });

/// A FIFA-style points value derived from a nation's ranking position.
int rankingPoints(int ranking) => (1900 - (ranking - 1) * 4).clamp(1000, 1900);
