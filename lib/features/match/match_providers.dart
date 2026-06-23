import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';

/// The player's next fixture, simulated by the tactical engine and ready to
/// display.
class MatchPreview {
  const MatchPreview({
    required this.fixture,
    required this.result,
    required this.nations,
  });

  final Fixture fixture;
  final MatchResult result;
  final Map<int, Nation> nations;
}

// autoDispose so re-opening the match screen always recomputes the *current*
// next fixture (otherwise the first preview is cached and replayed forever).
final AutoDisposeFutureProviderFamily<MatchPreview?, int> matchPreviewProvider =
    FutureProvider.autoDispose.family<MatchPreview?, int>((
  ref,
  careerId,
) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final careerRepo = ref.watch(careerRepositoryProvider);
      final compRepo = ref.watch(competitionRepositoryProvider);
      final playerRepo = ref.watch(playerRepositoryProvider);

      final career = await careerRepo.byId(careerId);
      if (career == null) return null;
      final fixture = await compRepo.nextFixtureForNation(
        careerId,
        career.nationId,
        career.inGameDate,
      );
      if (fixture == null) return null;

      final playerNationId = career.nationId;
      final opponentId = fixture.homeNationId == playerNationId
          ? fixture.awayNationId
          : fixture.homeNationId;

      // Player's team from their saved tactic (falling back to a best XI).
      final playerPool = await playerRepo.byNation(playerNationId);
      final byId = {for (final p in playerPool) p.id: p};
      final tactic = await ref
          .watch(tacticsRepositoryProvider)
          .tacticForCareer(
            careerId,
          );
      final selected = (tactic?.lineup ?? const <int?>[])
          .whereType<int>()
          .map((id) => byId[id])
          .whereType<Player>()
          .toList();
      final playerXi = selected.length == 11
          ? selected
          : _xiFrom(playerPool, bestEleven(Formation.f433, playerPool));
      final playerTeam = MatchTeam(
        nationId: playerNationId,
        xi: playerXi,
        instructions: tactic?.instructions ?? const TacticalInstructions(),
      );

      // Opponent: a best XI in a default shape.
      final oppPool = await playerRepo.byNation(opponentId);
      final oppTeam = MatchTeam(
        nationId: opponentId,
        xi: _xiFrom(oppPool, bestEleven(Formation.f433, oppPool)),
        instructions: const TacticalInstructions(),
      );

      final playerIsHome = fixture.homeNationId == playerNationId;
      final result = const MatchEngine().play(
        home: playerIsHome ? playerTeam : oppTeam,
        away: playerIsHome ? oppTeam : playerTeam,
        rng: SeededRng.forFixture(career.rngSeed, fixture.id),
      );

      final nations = {
        for (final n in await ref.watch(nationRepositoryProvider).all())
          n.id: n,
      };
      return MatchPreview(fixture: fixture, result: result, nations: nations);
    });

List<Player> _xiFrom(List<Player> pool, List<int?> ids) {
  final byId = {for (final p in pool) p.id: p};
  return ids
      .whereType<int>()
      .map((id) => byId[id])
      .whereType<Player>()
      .toList();
}
