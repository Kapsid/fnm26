import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/tournaments/playoff_paths.dart';
import 'package:fnm/features/tournaments/wc_host_berths.dart';

/// The intercontinental play-off, replayed deterministically for display: the
/// ties that decided the last two World Cup places.
typedef PlayoffView = ({
  List<PlayoffTie> ties,
  Map<int, Nation> nations,
  int playerNationId,
});

final AutoDisposeFutureProviderFamily<PlayoffView?, int>
intercontinentalPlayoffProvider = FutureProvider.autoDispose
    .family<PlayoffView?, int>((ref, careerId) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final comp = ref.watch(competitionRepositoryProvider);
      if (!await comp.allQualifyingPlayed(careerId)) return null;

      final byConfederation = await comp.allGroupTablesByConfederation(
        careerId,
      );
      final grouped = <Confederation, List<List<GroupStanding>>>{};
      for (final t in byConfederation) {
        (grouped[t.confederation] ??= []).add(t.standings);
      }
      final nations = {
        for (final n
            in await ref.watch(nationRepositoryProvider).forCareer(careerId))
          n.id: n,
      };
      // The play-off's own frozen seeding when there is one (there is whenever
      // the manager was an entrant), else the finals-draw snapshot — the
      // ranking the instant resolution was seeded on.
      final playoffRank = await ref.watch(
        seedRankByIdProvider((
          careerId: careerId,
          cycle: drawSeedCycle(career.cyclePointer, drawSlotWorldCupPlayoff),
        )).future,
      );
      final rankingById = playoffRank.isNotEmpty
          ? playoffRank
          : await ref.watch(
              seedRankByIdProvider((
                careerId: careerId,
                cycle: drawSeedCycle(
                  career.cyclePointer,
                  drawSlotWorldCupFinals,
                ),
              )).future,
            );
      final hostBerths = await worldCupHostBerthsFor(ref, careerId);
      final pool = WorldCupFinals.playoffPoolFor(
        byConfederation: grouped,
        rankingById: rankingById,
        hostBerths: hostBerths,
      );
      // The manager's own ties were played, not modelled. Read them back so the
      // bracket shows what happened on the pitch — a bracket that contradicted
      // the result he just played would also contradict the finals draw.
      final path = playoffPathOf(
        pool: pool,
        rankingById: rankingById,
        nationId: career.nationId,
      );
      var results = const <String, int>{};
      var scores = const <String, (int, int)>{};
      if (path != null) {
        const kind = CompetitionKind.worldCupPlayoff;
        final played = playoffPlayed(
          path: path,
          semis: await comp.fixturesByRound(
            careerId,
            playoffSemiFixtureRound,
            kind: kind,
          ),
          finals: await comp.fixturesByRound(
            careerId,
            playoffFinalFixtureRound,
            kind: kind,
          ),
        );
        results = played.results;
        scores = played.scores;
      }
      // Same seed the finalist selection uses, so the shown ties are exactly how
      // the last two places were decided.
      final ties = WorldCupFinals.playoffBracket(
        byConfederation: grouped,
        rankingById: rankingById,
        rng: SeededRng(
          career.rngSeed ^ (career.cyclePointer * 0x50FF) ^ 0xB1A0,
        ),
        hostBerths: hostBerths,
        pool: pool,
        playedResults: results,
        playedScores: scores,
      );
      if (ties.isEmpty) return null;
      return (ties: ties, nations: nations, playerNationId: career.nationId);
    });
