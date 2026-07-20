import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/match/ai_substitutions.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/venue.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/features/tactics/player_roles_providers.dart';
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
    this.opponentSubs = const [],
    this.injuryFactorByNation = const {},
    this.neutralVenue = false,
    this.venueHostId,
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

  /// The AI opponent's pre-planned substitutions, applied on every (re-)sim so
  /// the timeline stays stable when the human manager makes a change.
  final List<Substitution> opponentSubs;

  /// Per-nation injury-rate multipliers (the player's nation carries its
  /// medical investment); passed to the engine on every (re-)sim.
  final Map<int, double> injuryFactorByNation;

  /// Whether this is a neutral-venue finals match (no automatic home advantage),
  /// and — if the tournament host is playing — which nation still gets it.
  final bool neutralVenue;
  final int? venueHostId;

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
      );
      if (fixture == null) return null;

      final playerNationId = career.nationId;
      final opponentId = fixture.homeNationId == playerNationId
          ? fixture.awayNationId
          : fixture.homeNationId;

      // Player's team from their saved tactic (falling back to a best XI),
      // restricted to the called-up squad. The nation's youth-academy
      // investment lifts its home-grown players.
      final youthBonus =
          await ref.watch(youthBonusByCycleProvider(careerId).future);
      // A well-used player who plays in a strong league develops over a career.
      final careerDev =
          await ref.watch(careerDevBonusProvider(careerId).future);
      // Form, fatigue and morale shift each of the manager's players' effective
      // rating for this match (opponents are unaffected — you manage your own
      // squad's condition).
      final condition =
          await ref.watch(squadConditionProvider(careerId).future);
      final fullPool = [
        for (final p in [
          ...await playerRepo.byNation(
            playerNationId,
            agingYears: CareerService.agingYears(career),
            saveSeed: career.rngSeed,
            youthBonusByCycle: youthBonus,
            careerStartsByPlayer: careerDev,
          ),
          ...await naturalizedPlayersFor(ref, career),
        ])
          withConditionDelta(p, condition[p.id]?.overallDelta ?? 0),
      ];
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
      // Per-player tactical roles the manager has assigned (shapes who scores /
      // creates and the set-piece threat; opponents play roleless).
      final roles = await ref.watch(playerRolesProvider(careerId).future);
      final playerTeam = MatchTeam(
        nationId: playerNationId,
        xi: playerXi,
        instructions: tactic?.instructions ?? const TacticalInstructions(),
        // Both the saved lineup and the auto-filled fallback are laid out in
        // the tactic's shape (f433 when there's no saved tactic).
        formation: playerFormation,
        roles: roles,
      );

      // Opponent: a best XI in a default shape, with a bench to sub from.
      final oppPool = await playerRepo.byNation(
        opponentId,
        agingYears: CareerService.agingYears(career),
        saveSeed: career.rngSeed,
      );
      final oppXi = _xiFrom(oppPool, bestEleven(Formation.f433, oppPool));
      final oppStartingIds = oppXi.map((p) => p.id).toSet();
      final oppBench = oppPool
          .where((p) => !oppStartingIds.contains(p.id))
          .toList()
        ..sort((a, b) => b.overall.compareTo(a.overall));
      final oppTeam = MatchTeam(
        nationId: opponentId,
        xi: oppXi,
        instructions: const TacticalInstructions(),
      );

      // Plan the AI's substitutions up front on a stream tied to this fixture,
      // so re-sims after a human change reproduce them exactly.
      final opponentSubs = AiSubstitutions.plan(
        nationId: opponentId,
        xi: oppXi,
        bench: oppBench,
        rng: SeededRng.forFixture(career.rngSeed, fixture.id ^ 0x5195),
      );

      // The nation's medical investment for the current cycle reduces its
      // players' injury risk this match; heavy fatigue in the fielded XI pushes
      // it back up (tired legs pull up more often).
      final medical =
          (await careerRepo.investment(careerId, career.cyclePointer)).medical;
      int fatigueLevel(int id) => switch (
          condition[id]?.fatigueState ?? FatigueState.fresh) {
        FatigueState.fresh => 0,
        FatigueState.ready => 1,
        FatigueState.tired => 2,
        FatigueState.exhausted => 3,
      };
      final avgFatigue = playerXi.isEmpty
          ? 0.0
          : playerXi
                  .map((p) => fatigueLevel(p.id))
                  .fold<int>(0, (a, b) => a + b) /
              playerXi.length;
      final injuryFactorByNation = {
        playerNationId:
            FederationFinance.injuryFactor(medical) * (1 + avgFatigue * 0.14),
      };

      final playerIsHome = fixture.homeNationId == playerNationId;
      final homeTeam = playerIsHome ? playerTeam : oppTeam;
      final awayTeam = playerIsHome ? oppTeam : playerTeam;

      final allNations = await ref.watch(nationRepositoryProvider).all();
      // A finals match is played at a neutral host — only the host keeps a home
      // crowd. Qualifiers, friendlies and the Nations Cup are home-and-away.
      final venue = venueForFixture(
        fixture: fixture,
        nations: allNations,
        seed: career.rngSeed,
        cycle: career.cyclePointer,
      );

      final result = const MatchEngine().play(
        home: homeTeam,
        away: awayTeam,
        rng: SeededRng.forFixture(career.rngSeed, fixture.id),
        subs: opponentSubs,
        // The AI opponent reactively manages the game by the scoreline (chases
        // when behind, protects a lead); the player controls their own side.
        aiManagedNationIds: {opponentId},
        injuryFactorByNation: injuryFactorByNation,
        neutralVenue: venue.neutral,
        venueHostId: venue.hostId,
      );

      final nations = {for (final n in allNations) n.id: n};
      return MatchPreview(
        fixture: fixture,
        result: result,
        nations: nations,
        homeTeam: homeTeam,
        awayTeam: awayTeam,
        playerNationId: playerNationId,
        bench: bench,
        saveSeed: career.rngSeed,
        opponentSubs: opponentSubs,
        injuryFactorByNation: injuryFactorByNation,
        neutralVenue: venue.neutral,
        venueHostId: venue.hostId,
      );
    });

/// The finals opening-ceremony details shown once, right before the player's
/// first World Cup finals match: the year and the host nation(s).
typedef FinalsOpening = ({
  int year,
  List<String> hostCodes,
  List<String> hostNames,
});

/// Non-null only when the player's next fixture is their FIRST match of the
/// current World Cup finals — so the match preview can open with a trophy/host
/// ceremony exactly at kick-off of the tournament, then never again.
final AutoDisposeFutureProviderFamily<FinalsOpening?, int>
    finalsOpeningProvider =
    FutureProvider.autoDispose.family<FinalsOpening?, int>((
  ref,
  careerId,
) async {
  const wcFinalsRounds = {'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'};
  final comp = ref.watch(competitionRepositoryProvider);
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final fixture = await comp.nextFixtureForNation(careerId, career.nationId);
  if (fixture == null || !wcFinalsRounds.contains(fixture.round)) return null;
  // Only ahead of the very first finals match — once any finals game has a
  // result, the tournament is under way and the ceremony has served its purpose.
  final playerFixtures =
      await comp.fixturesForNation(careerId, career.nationId);
  final alreadyStarted = playerFixtures.any(
    (f) => f.hasResult && wcFinalsRounds.contains(f.round),
  );
  if (alreadyStarted) return null;
  final allNations = await ref.watch(nationRepositoryProvider).all();
  final year = CareerService.worldCupYear(career.cyclePointer);
  final hosts = WorldCupHosts.hostsFor(
    year: year,
    nations: allNations,
    seed: career.rngSeed,
  );
  final byId = {for (final n in allNations) n.id: n};
  return (
    year: year,
    hostCodes: [
      for (final h in hosts)
        if (byId[h] != null) byId[h]!.code,
    ],
    hostNames: [
      for (final h in hosts)
        if (byId[h] != null) byId[h]!.name,
    ],
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
