import 'package:drift/drift.dart';
import 'package:fnm/data/db/connection.dart';
import 'package:fnm/data/db/schema_versions.dart';
import 'package:fnm/data/db/tables.dart';
// Imported so the generated part file can resolve the enum types used by
// `textEnum` columns (Confederation, PlayerPosition, Formation, Playstyle).
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';

part 'app_database.g.dart';

/// Where generated-player ids begin — see [PlayerLifecycle]. Repeated here as
/// a literal because a migration must describe the world as it was, and must
/// not shift if that constant is ever re-tuned.
const int _newgenIdBase = 1000000000;

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
    CallUpDrafts,
    TrainingCampChoices,
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
    TacticFamiliarities,
    PressAnswers,
    PlayerHonours,
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
  int get schemaVersion => 40;

  /// The first schema version with a recorded shape in `drift_schemas/`, and so
  /// the oldest save that can be migrated forward rather than rebuilt.
  ///
  /// Everything below this was written while the schema changed daily and no
  /// snapshot of it exists, so there is nothing to migrate *from*. Those saves
  /// predate any released build; they are rebuilt, as they always were.
  static const int firstManagedVersion = 38;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < firstManagedVersion) {
            // Use only migration-safe APIs: drop every table the current schema
            // knows (deleteTable issues DROP TABLE IF EXISTS, a no-op when the
            // table is absent), then recreate. Reading sqlite_master or using
            // the normal query APIs mid-migration is unreliable on device, so
            // it is avoided here. Reference data (nations/players) is re-seeded
            // on the next launch by the seed loader.
            for (final table in allTables) {
              await m.deleteTable(table.actualTableName);
            }
            await m.createAll();
            return;
          }
          // From [firstManagedVersion] on, every bump is a recorded step and
          // saves survive it.
          //
          // Adding a version:
          //   1. change the tables and bump [schemaVersion];
          //   2. `dart run drift_dev schema dump lib/data/db/app_database.dart
          //      drift_schemas/` — snapshots the new shape;
          //   3. `dart run drift_dev schema steps drift_schemas/
          //      lib/data/db/schema_versions.dart` — regenerates the stubs;
          //   4. fill in the new `from38To39`-style callback in
          //      `schema_versions.dart`;
          //   5. `dart run drift_dev schema generate drift_schemas/
          //      test/generated_migrations/` and extend
          //      `test/unit/data/schema_migration_test.dart`.
          //
          // The generated helper is what makes this safe: each step sees the
          // schema *as it was at that version*, so an ADD COLUMN can never
          // duplicate a column that a later version's `createAll` would have
          // included — the brittleness that made the old wipe-everything
          // strategy the pragmatic choice.
          await stepByStep(
            // 38 → 39 changed no table. What it changed is what a newgen id
            // MEANS: intake moved from four-year batches of twenty-two
            // sixteen-year-olds to seven eleven-year-olds a year, so the id
            // encodes an intake year where it used to encode a cycle. Every
            // stored reference to a generated player therefore points at
            // somebody who no longer exists — a call-up nobody can field, a
            // goal nobody scored. The rows are deleted rather than the save,
            // so a career's seeded players, results and honours all survive.
            from38To39: (m, schema) async {
              for (final table in const [
                'call_ups',
                'call_up_drafts',
                'player_absences',
                'appearances',
                'tournament_appearances',
                'player_ratings',
                'goal_events',
                'naturalized_players',
              ]) {
                await m.database.customStatement(
                  'DELETE FROM $table WHERE player_id >= $_newgenIdBase',
                );
              }
              // The XI and the armband may name one too.
              await m.database.customStatement(
                'UPDATE lineup_slots SET player_id = NULL '
                'WHERE player_id >= $_newgenIdBase',
              );
              await m.database.customStatement(
                'UPDATE careers SET captain_player_id = NULL '
                'WHERE captain_player_id >= $_newgenIdBase',
              );
            },
            // 39 → 40 adds the trophy cabinet. Nothing else moves: existing
            // rows are untouched and the new table simply starts empty, so a
            // career carries on with its history intact and begins collecting
            // individual honours from here.
            from39To40: (m, schema) async {
              await m.createTable(schema.playerHonours);
            },
          )(m, from, to);
        },
      );
}
