import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/ranking/elo.dart';

/// World ranking data: nations ordered by their live points, each nation's
/// current points and world position, and how far it has moved from where the
/// static seed ranking started it.
class RankingData {
  const RankingData({
    required this.nations,
    required this.points,
    required this.position,
    required this.movement,
    required this.playerNationId,
  });

  /// Nations ordered by live points (strongest first).
  final List<Nation> nations;

  /// Live points, keyed by nation id.
  final Map<int, int> points;

  /// Live world position (1 = top), keyed by nation id.
  final Map<int, int> position;

  /// Positions climbed since the season began (negative = dropped).
  final Map<int, int> movement;

  final int playerNationId;
}

/// Selected confederation filter (null = all).
final selectedRankRegionProvider = StateProvider<Confederation?>((_) => null);

/// Argument for [seedRankByIdProvider]: the save and the cycle being drawn.
typedef SeedRankArg = ({int careerId, int cycle});

/// The ranking a cycle's draws seed from: the positions frozen at the cycle's
/// start, or — for cycle 0 or any legacy save with no snapshot — the static
/// seed ranking. Every draw and its ceremony read this so they always agree.
final AutoDisposeFutureProviderFamily<Map<int, int>, SeedRankArg>
seedRankByIdProvider =
    FutureProvider.autoDispose.family<Map<int, int>, SeedRankArg>((
  ref,
  arg,
) async {
  final snap = await ref
      .watch(seedRankingRepositoryProvider)
      .forCycle(arg.careerId, arg.cycle);
  if (snap.isNotEmpty) return snap;
  final nations = await ref.watch(nationRepositoryProvider).all();
  return {for (final n in nations) n.id: n.ranking};
});

final AutoDisposeFutureProviderFamily<RankingData?, int> worldRankingProvider =
    FutureProvider.autoDispose.family<RankingData?, int>((ref, careerId) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      final nations = await ref.watch(nationRepositoryProvider).all();

      final seed = {
        for (final n in nations) n.id: Elo.seedFromRanking(n.ranking),
      };
      final points = await ref
          .watch(rankingRepositoryProvider)
          .pointsFor(careerId, seed);

      // Baseline: where each nation stood when the current cycle began, so the
      // arrows highlight how form has moved them this campaign.
      final baseline = await ref.watch(
        seedRankByIdProvider((
          careerId: careerId,
          cycle: career?.cyclePointer ?? 0,
        )).future,
      );

      final ordered = [...nations]
        ..sort((a, b) {
          final byPoints = (points[b.id] ?? Elo.base)
              .compareTo(points[a.id] ?? Elo.base);
          return byPoints != 0 ? byPoints : a.ranking.compareTo(b.ranking);
        });

      final position = <int, int>{};
      final movement = <int, int>{};
      for (var i = 0; i < ordered.length; i++) {
        final n = ordered[i];
        final rank = i + 1;
        position[n.id] = rank;
        // + = climbed since the cycle's starting position.
        movement[n.id] = (baseline[n.id] ?? n.ranking) - rank;
      }

      return RankingData(
        nations: ordered,
        points: points,
        position: position,
        movement: movement,
        playerNationId: career?.nationId ?? -1,
      );
    });
