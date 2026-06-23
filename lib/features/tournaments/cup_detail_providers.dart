import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';

/// Data for the cup-detail (World Championship) screen.
class CupData {
  const CupData({
    required this.groups,
    required this.nations,
    required this.playerNationId,
    required this.playerConfederation,
    required this.finalsGroups,
    required this.knockout,
    required this.champion,
  });

  /// Every confederation's qualifying groups.
  final List<ConfederationGroupTable> groups;
  final Map<int, Nation> nations;
  final int playerNationId;
  final Confederation? playerConfederation;

  /// Finals group tables (empty until the finals are drawn).
  final List<FinalsGroupTable> finalsGroups;

  /// All finals knockout fixtures (empty until the bracket begins).
  final List<Fixture> knockout;

  /// The World Cup winner once decided.
  final int? champion;

  bool get hasFinals => finalsGroups.isNotEmpty;
}

final AutoDisposeFutureProviderFamily<CupData?, int> cupDetailProvider =
    FutureProvider.autoDispose.family<CupData?, int>((ref, careerId) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final comp = ref.watch(competitionRepositoryProvider);
      final groups = await comp.allGroupTablesByConfederation(careerId);
      final finalsGroups = await comp.finalsGroupTables(careerId);
      final knockout = await comp.finalsKnockoutFixtures(careerId);
      final champion = await comp.worldChampion(careerId);
      final nations = {
        for (final n in await ref.watch(nationRepositoryProvider).all())
          n.id: n,
      };
      return CupData(
        groups: groups,
        nations: nations,
        playerNationId: career.nationId,
        playerConfederation: nations[career.nationId]?.confederation,
        finalsGroups: finalsGroups,
        knockout: knockout,
        champion: champion,
      );
    });
