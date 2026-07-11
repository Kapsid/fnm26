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
import 'package:fnm/features/tactics/tactics_providers.dart';

/// The player's preferred live-match playback speed, as an index into the
/// screen's speed steps. Kept in a session-wide provider so the choice carries
/// from one match to the next instead of resetting each game.
final matchSpeedProvider = StateProvider<int>((ref) => 0);

/// The player's next fixture, simulated by the tactical engine and ready to
/// display. Carries everything the live screen needs to re-simulate after a
/// substitution (the starting teams, the player's bench, and the seed).
class MatchPreview {
  const MatchPreview({
    required this.fixture,
    required this.result,
    required this.nations,
    required this.homeTeam,
    required this.awayTeam,
    required this.playerNationId,
    required this.bench,
    required this.saveSeed,
  });

  final Fixture fixture;
  final MatchResult result;
  final Map<int, Nation> nations;
  final MatchTeam homeTeam;
  final MatchTeam awayTeam;

  /// The nation the human manager controls in this fixture.
  final int playerNationId;

  /// Substitutes available to the player (called-up players not in the XI).
  final List<Player> bench;

  /// The save-level RNG seed, so the screen can deterministically re-run the
  /// engine with substitutions applied.
  final int saveSeed;

  bool get playerIsHome => fixture.homeNationId == playerNationId;
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

      // Player's team from their saved tactic (falling back to a best XI),
      // restricted to the called-up squad.
      final fullPool = await playerRepo.byNation(
        playerNationId,
        agingCycles: career.cyclePointer,
      );
      final callUps =
          await ref.watch(squadRepositoryProvider).callUps(careerId);
      // Drop suspended and injured players — they can't be fielded, so a
      // saved lineup that names one auto-fills their slot from who's fit.
      final absences =
          await ref.watch(absenceRepositoryProvider).forCareer(careerId);
      final calledUp = availableSquad(fullPool, callUps);
      final playerPool = calledUp
          .where((p) => absences[p.id]?.isAvailable ?? true)
          .toList();
      final byId = {for (final p in playerPool) p.id: p};
      final tactic = await ref
          .watch(tacticsRepositoryProvider)
          .tacticForCareer(
            careerId,
          );
      final playerFormation = tactic?.formation ?? Formation.f433;
      final selected = (tactic?.lineup ?? const <int?>[])
          .whereType<int>()
          .map((id) => byId[id])
          .whereType<Player>()
          .toList();
      final usingTactic = selected.length == 11;
      final playerXi = usingTactic
          ? selected
          : _xiFrom(playerPool, bestEleven(playerFormation, playerPool));
      final startingIds = playerXi.map((p) => p.id).toSet();
      final bench = playerPool
          .where((p) => !startingIds.contains(p.id))
          .toList()
        ..sort((a, b) => b.overall.compareTo(a.overall));
      final playerTeam = MatchTeam(
        nationId: playerNationId,
        xi: playerXi,
        instructions: tactic?.instructions ?? const TacticalInstructions(),
        // Both the saved lineup and the auto-filled fallback are laid out in
        // the tactic's shape (f433 when there's no saved tactic).
        formation: playerFormation,
      );

      // Opponent: a best XI in a default shape.
      final oppPool = await playerRepo.byNation(
        opponentId,
        agingCycles: career.cyclePointer,
      );
      final oppTeam = MatchTeam(
        nationId: opponentId,
        xi: _xiFrom(oppPool, bestEleven(Formation.f433, oppPool)),
        instructions: const TacticalInstructions(),
      );

      final playerIsHome = fixture.homeNationId == playerNationId;
      final homeTeam = playerIsHome ? playerTeam : oppTeam;
      final awayTeam = playerIsHome ? oppTeam : playerTeam;
      final result = const MatchEngine().play(
        home: homeTeam,
        away: awayTeam,
        rng: SeededRng.forFixture(career.rngSeed, fixture.id),
      );

      final nations = {
        for (final n in await ref.watch(nationRepositoryProvider).all())
          n.id: n,
      };
      return MatchPreview(
        fixture: fixture,
        result: result,
        nations: nations,
        homeTeam: homeTeam,
        awayTeam: awayTeam,
        playerNationId: playerNationId,
        bench: bench,
        saveSeed: career.rngSeed,
      );
    });

List<Player> _xiFrom(List<Player> pool, List<int?> ids) {
  final byId = {for (final p in pool) p.id: p};
  return ids
      .whereType<int>()
      .map((id) => byId[id])
      .whereType<Player>()
      .toList();
}
