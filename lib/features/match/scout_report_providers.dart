import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/match/ai_tactics.dart';
import 'package:fnm/domain/services/match/opponent_scouting.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/features/federation/career_pool.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';

/// The scout's report on `nationId` for the manager of `careerId`: the "how
/// they play" section of the pre-match dossier (see [OpponentScouting]).
///
/// The side's recent postures are REPLAYED, not stored: nothing records the
/// shape a side lined up in, but its posture in a fixture is a pure function
/// of the two sides' strength, its national style and the fixture's own seed
/// (`AiTactics.forOpponent` with `AiTactics.fixtureSeed`), so it is read back
/// the way the match itself picked it. Two honest approximations: strength is
/// read off today's pools (a side two years on is not the side it was), and
/// the replay is the posture alone, without the counter it may have bent
/// towards the manager in his own meetings with it. That counter is hidden on
/// purpose, and the report must not hint at it.
final AutoDisposeFutureProviderFamily<
  ScoutReport?,
  ({int careerId, int nationId})
>
scoutReportProvider = FutureProvider.autoDispose
    .family<ScoutReport?, ({int careerId, int nationId})>((ref, key) async {
      final career = await ref
          .watch(careerRepositoryProvider)
          .byId(key.careerId);
      if (career == null) return null;
      final nations = await ref
          .watch(nationRepositoryProvider)
          .forCareer(key.careerId);
      final codeOf = {for (final n in nations) n.id: n.code};
      final nation = nations.where((n) => n.id == key.nationId).firstOrNull;
      if (nation == null) return null;
      final ranking = await ref.watch(
        worldRankingProvider(key.careerId).future,
      );
      final worldRank = ranking?.position[key.nationId] ?? nation.ranking;

      // One pool read per nation, shared by every replayed fixture.
      final strengthCache = <int, double>{};
      final poolCache = <int, List<Player>>{};
      Future<List<Player>> poolOf(int id) async =>
          poolCache[id] ??= await careerPoolOf(ref, career, id);
      Future<double> strengthOf(int id) async =>
          strengthCache[id] ??= AiTactics.readStrength(await poolOf(id));

      final pool = await poolOf(key.nationId);
      final strength = await strengthOf(key.nationId);
      final myStrength = await strengthOf(career.nationId);
      final style = NationIdentity.styleOf(nation.code);

      final fixtures = await ref
          .watch(competitionRepositoryProvider)
          .fixturesForNation(key.careerId, key.nationId);
      final recent = [
        for (final f in fixtures)
          if (f.hasResult) f,
      ]..sort((a, b) => b.date.compareTo(a.date)); // newest first
      final recentSetups = <AiSetup>[];
      for (final f in recent.take(OpponentScouting.recentMatches)) {
        final otherId = f.homeNationId == key.nationId
            ? f.awayNationId
            : f.homeNationId;
        if (!codeOf.containsKey(otherId)) continue;
        recentSetups.add(
          AiTactics.forOpponent(
            opponentStrength: strength,
            playerStrength: await strengthOf(otherId),
            seed: AiTactics.fixtureSeed(
              opponentId: key.nationId,
              fixtureId: f.id,
              rngSeed: career.rngSeed,
            ),
            style: style,
          ),
        );
      }

      List<Player> xiFor(Formation formation) {
        final byId = {for (final p in pool) p.id: p};
        return [
          for (final id in bestEleven(formation, pool))
            if (id != null && byId[id] != null) byId[id]!,
        ];
      }

      return OpponentScouting.build(
        scout: career.staffScout,
        worldRank: worldRank,
        recentSetups: recentSetups,
        fallbackSetups: AiTactics.typicalSetups(
          opponentStrength: strength,
          playerStrength: myStrength,
          style: style,
        ),
        xiFor: xiFor,
        opponentStrength: strength,
        playerStrength: myStrength,
        hasSetPieceSpecialist: (xi) => xi.any(
          (p) => PlayerTraits.of(
            p,
            saveSeed: career.rngSeed,
          ).contains(PlayerTrait.setPiece),
        ),
      );
    });
