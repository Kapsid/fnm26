import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';

/// Everything the Hub screen needs for a save, in one fetch.
class HubData {
  const HubData({
    required this.career,
    required this.group,
    required this.next,
    required this.fixtures,
    required this.nations,
    required this.squadSize,
    required this.squadRating,
  });

  final Career career;
  final GroupTable? group;
  final Fixture? next;
  final List<Fixture> fixtures;
  final Map<int, Nation> nations;

  /// Number of players in the nation's pool.
  final int squadSize;

  /// Average overall rating of the nation's pool.
  final int squadRating;

  /// Played fixtures, most recent first.
  List<Fixture> get recentResults =>
      fixtures.where((f) => f.hasResult).toList().reversed.toList();
}

final FutureProviderFamily<HubData?, int> hubDataProvider =
    FutureProvider.family<HubData?, int>((ref, careerId) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final careerRepo = ref.watch(careerRepositoryProvider);
  final compRepo = ref.watch(competitionRepositoryProvider);

  final career = await careerRepo.byId(careerId);
  if (career == null) return null;

  final group = await compRepo.groupTableForNation(careerId, career.nationId);
  final next = await compRepo.nextFixtureForNation(
    careerId,
    career.nationId,
    career.inGameDate,
  );
  final fixtures = await compRepo.fixturesForNation(careerId, career.nationId);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  final squad = await ref.watch(playerRepositoryProvider).byNation(
        career.nationId,
      );
  final squadRating = squad.isEmpty
      ? 0
      : (squad.fold<int>(0, (s, p) => s + p.overall) / squad.length).round();

  return HubData(
    career: career,
    group: group,
    next: next,
    fixtures: fixtures,
    nations: nations,
    squadSize: squad.length,
    squadRating: squadRating,
  );
});

/// Advances the save to the player's next fixture, simulating every match due
/// up to and including that date (placeholder results until the M6 engine).
class SeasonService {
  SeasonService(this._ref);

  final Ref _ref;

  Future<void> advance(int careerId) async {
    final careerRepo = _ref.read(careerRepositoryProvider);
    final compRepo = _ref.read(competitionRepositoryProvider);

    final career = await careerRepo.byId(careerId);
    if (career == null) return;

    final next = await compRepo.nextFixtureForNation(
      careerId,
      career.nationId,
      career.inGameDate,
    );
    if (next == null) return; // qualifying complete

    final due = await compRepo.unplayedDueBy(careerId, next.date);
    final nations = {
      for (final n in await _ref.read(nationRepositoryProvider).all()) n.id: n,
    };
    const sim = RatingMatchSimulator();

    for (final f in due) {
      final home = nations[f.homeNationId];
      final away = nations[f.awayNationId];
      if (home == null || away == null) continue;
      final outcome = sim.simulate(
        homeStrength: RatingMatchSimulator.strengthOf(home),
        awayStrength: RatingMatchSimulator.strengthOf(away),
        rng: SeededRng.forFixture(career.rngSeed, f.id),
      );
      await compRepo.recordResult(
        fixtureId: f.id,
        homeScore: outcome.homeScore,
        awayScore: outcome.awayScore,
      );
    }

    await careerRepo.updateInGameDate(careerId, next.date);
    _ref.invalidate(hubDataProvider);
  }

  /// Records the player's [result] for [fixture] (from the tactical engine),
  /// quick-sims every other match due that matchday, and advances the date.
  Future<void> playPlayerMatch(
    int careerId,
    Fixture fixture,
    MatchResult result,
  ) async {
    final careerRepo = _ref.read(careerRepositoryProvider);
    final compRepo = _ref.read(competitionRepositoryProvider);

    await compRepo.recordResult(
      fixtureId: fixture.id,
      homeScore: result.homeScore,
      awayScore: result.awayScore,
    );

    final career = await careerRepo.byId(careerId);
    if (career == null) return;

    final due = await compRepo.unplayedDueBy(careerId, fixture.date);
    final nations = {
      for (final n in await _ref.read(nationRepositoryProvider).all()) n.id: n,
    };
    const sim = RatingMatchSimulator();
    for (final f in due) {
      final home = nations[f.homeNationId];
      final away = nations[f.awayNationId];
      if (home == null || away == null) continue;
      final outcome = sim.simulate(
        homeStrength: RatingMatchSimulator.strengthOf(home),
        awayStrength: RatingMatchSimulator.strengthOf(away),
        rng: SeededRng.forFixture(career.rngSeed, f.id),
      );
      await compRepo.recordResult(
        fixtureId: f.id,
        homeScore: outcome.homeScore,
        awayScore: outcome.awayScore,
      );
    }

    await careerRepo.updateInGameDate(careerId, fixture.date);
    _ref.invalidate(hubDataProvider);
  }
}

final Provider<SeasonService> seasonServiceProvider =
    Provider(SeasonService.new);
