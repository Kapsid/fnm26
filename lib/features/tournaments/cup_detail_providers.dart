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
    required this.scorersQualifying,
    required this.scorersFinals,
    required this.honours,
    required this.playerNames,
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

  /// Top scorers in qualifying and in the finals.
  final List<ScorerTally> scorersQualifying;
  final List<ScorerTally> scorersFinals;

  /// Roll of honour (past champions), newest first.
  final List<Honour> honours;

  /// Names for any player id referenced by the scorer charts.
  final Map<int, String> playerNames;

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
      final scorersQualifying = await comp.topScorers(
        careerId,
        kind: CompetitionKind.worldCupQualifying,
        limit: 15,
      );
      final scorersFinals = await comp.topScorers(
        careerId,
        kind: CompetitionKind.worldCupFinals,
        limit: 15,
      );
      final honours = await comp.honours(careerId);
      final nations = {
        for (final n in await ref.watch(nationRepositoryProvider).all())
          n.id: n,
      };

      final playerRepo = ref.watch(playerRepositoryProvider);
      final scorerIds = {
        for (final s in scorersQualifying) s.playerId,
        for (final s in scorersFinals) s.playerId,
      };
      final playerNames = <int, String>{};
      for (final id in scorerIds) {
        final p = await playerRepo.byId(id);
        if (p != null) playerNames[id] = p.name;
      }

      return CupData(
        groups: groups,
        nations: nations,
        playerNationId: career.nationId,
        playerConfederation: nations[career.nationId]?.confederation,
        finalsGroups: finalsGroups,
        knockout: knockout,
        champion: champion,
        scorersQualifying: scorersQualifying,
        scorersFinals: scorersFinals,
        honours: honours,
        playerNames: playerNames,
      );
    });
