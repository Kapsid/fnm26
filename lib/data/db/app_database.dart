import 'package:drift/drift.dart';
import 'package:fnm/data/db/connection.dart';
import 'package:fnm/data/db/tables.dart';
// Imported so the generated part file can resolve the enum types used by
// `textEnum` columns (Confederation, PlayerPosition, Formation).
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';

part 'app_database.g.dart';

/// The app's Drift database.
///
/// Use the default constructor in the app (opens the on-device file) and
/// [AppDatabase.forTesting] with an in-memory executor in tests.
@DriftDatabase(
  tables: [
    Nations,
    Players,
    Careers,
    Competitions,
    QualifyingGroups,
    GroupMembers,
    Fixtures,
    Tactics,
    LineupSlots,
    CallUps,
    GoalEvents,
    Honours,
    DrawsWatched,
    PlayerAbsences,
    RankPoints,
    SeedRankings,
    RankingReleases,
    Achievements,
    Appearances,
    TournamentAppearances,
    Messages,
    CareerStints,
    PlayerRatings,
    FederationInvestments,
    MatchTeamStats,
    NationsCupTiers,
    NaturalizedPlayers,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Opens the on-device database.
  AppDatabase() : super(openConnection());

  /// Creates a database backed by the supplied [executor] (e.g. an in-memory
  /// `NativeDatabase.memory()` for tests).
  ///
  /// A super parameter isn't used because the generated super-constructor
  /// parameter is named `e`; an explicit, descriptive name reads better.
  // ignore: use_super_parameters
  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 30;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // While the game is still in active development its schema changes
          // often, and stepping every intermediate migration is brittle (a
          // table created in an early step already carries columns added
          // later, so a subsequent ADD COLUMN duplicates it). Saves are
          // disposable for now, so any version change wipes the database and
          // rebuilds it fresh; reference data (nations/players) is re-seeded on
          // the next launch by the seed loader.
          //
          // Use only migration-safe APIs: drop every table the current schema
          // knows (deleteTable issues DROP TABLE IF EXISTS, a no-op when the
          // table is absent), then recreate. Reading sqlite_master or using the
          // normal query APIs mid-migration is unreliable on device, so it is
          // avoided here.
          for (final table in allTables) {
            await m.deleteTable(table.actualTableName);
          }
          await m.createAll();
        },
      );
}
