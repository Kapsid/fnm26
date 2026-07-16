import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_absence_repository.dart';
import 'package:fnm/data/repositories/drift_career_repository.dart';
import 'package:fnm/data/repositories/drift_competition_repository.dart';
import 'package:fnm/data/repositories/drift_nation_repository.dart';
import 'package:fnm/data/repositories/drift_player_repository.dart';
import 'package:fnm/data/repositories/drift_ranking_release_repository.dart';
import 'package:fnm/data/repositories/drift_ranking_repository.dart';
import 'package:fnm/data/repositories/drift_seed_ranking_repository.dart';
import 'package:fnm/data/repositories/drift_squad_repository.dart';
import 'package:fnm/data/repositories/drift_tactics_repository.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/repositories/absence_repository.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/repositories/nation_repository.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/repositories/ranking_release_repository.dart';
import 'package:fnm/domain/repositories/ranking_repository.dart';
import 'package:fnm/domain/repositories/seed_ranking_repository.dart';
import 'package:fnm/domain/repositories/squad_repository.dart';
import 'package:fnm/domain/repositories/tactics_repository.dart';

/// Data-layer dependency wiring.
///
/// Providers are declared manually (no Riverpod codegen — see project notes).
/// Repository providers expose the domain *interface* type so the rest of the
/// app depends on abstractions, and any provider can be overridden with a fake
/// in tests.

/// The singleton Drift database, closed when the scope is disposed.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Source of first-run seed data (bundled JSON assets).
final seedSourceProvider =
    Provider<SeedSource>((ref) => AssetSeedSource(rootBundle));

/// Seeds reference data on first run.
final seedLoaderProvider = Provider<SeedLoader>(
  (ref) => SeedLoader(
    ref.watch(appDatabaseProvider),
    ref.watch(seedSourceProvider),
  ),
);

/// Resolves once the database is seeded and ready; the UI can gate first
/// render on this.
final databaseReadyProvider = FutureProvider<void>((ref) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
});

final nationRepositoryProvider = Provider<NationRepository>(
  (ref) => DriftNationRepository(ref.watch(appDatabaseProvider)),
);

final playerRepositoryProvider = Provider<PlayerRepository>(
  (ref) => DriftPlayerRepository(ref.watch(appDatabaseProvider)),
);

final careerRepositoryProvider = Provider<CareerRepository>(
  (ref) => DriftCareerRepository(ref.watch(appDatabaseProvider)),
);

final competitionRepositoryProvider = Provider<CompetitionRepository>(
  (ref) => DriftCompetitionRepository(ref.watch(appDatabaseProvider)),
);

final tacticsRepositoryProvider = Provider<TacticsRepository>(
  (ref) => DriftTacticsRepository(ref.watch(appDatabaseProvider)),
);

final squadRepositoryProvider = Provider<SquadRepository>(
  (ref) => DriftSquadRepository(ref.watch(appDatabaseProvider)),
);

final absenceRepositoryProvider = Provider<AbsenceRepository>(
  (ref) => DriftAbsenceRepository(ref.watch(appDatabaseProvider)),
);

final rankingRepositoryProvider = Provider<RankingRepository>(
  (ref) => DriftRankingRepository(ref.watch(appDatabaseProvider)),
);

final seedRankingRepositoryProvider = Provider<SeedRankingRepository>(
  (ref) => DriftSeedRankingRepository(ref.watch(appDatabaseProvider)),
);

final rankingReleaseRepositoryProvider = Provider<RankingReleaseRepository>(
  (ref) => DriftRankingReleaseRepository(ref.watch(appDatabaseProvider)),
);
