import 'package:drift/drift.dart';
import 'package:fnm/data/db/connection.dart';
import 'package:fnm/data/db/schema_versions.dart';
import 'package:fnm/data/db/tables.dart';
// Imported so the generated part file can resolve the enum types used by
// `textEnum` columns (Confederation, PlayerPosition, Formation, Playstyle,
// TrainingFocus) AND the constants used as column defaults
// (ManagerSkills.starting). The part file has no imports of its own, so a name
// only tables.dart can see is a name it cannot compile against — an
// unresolved one reads as "not a constant expression", which is a confusing
// way to be told about a missing import.
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/manager/manager_skills.dart';
import 'package:fnm/domain/services/manager/staff.dart';

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

  /// The schema this build expects.
  ///
  /// A constant as well as the override so the migration tests can derive the
  /// full set of upgrade paths from it — see `schema_migration_test.dart`.
  /// A hand-written list of paths is a step somebody forgets on the bump that
  /// matters.
  static const int currentSchemaVersion = 46;

  @override
  int get schemaVersion => currentSchemaVersion;

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
        // 40 → 41 adds the Y read watermark. Additive and nullable: an
        // existing save simply has never opened the feed, so everything in it
        // counts as unread until the manager looks.
        from40To41: (m, schema) async {
          await m.addColumn(schema.careers, schema.careers.yReadAt);
        },
        // 41 → 42 adds the played-time counter. Additive with a default of
        // zero: a save that existed before it simply starts counting from
        // here, which is honest — the time before this was never measured.
        from41To42: (m, schema) async {
          await m.addColumn(schema.careers, schema.careers.playedSeconds);
        },
        // 42 → 43 gives the MANAGER a career of his own: four skills he can
        // raise, the staff he has hired, and what the side works on between
        // windows. Purely additive, and every column defaults to the neutral
        // value — a save from before this played without any of it and must
        // carry on playing exactly the same until the manager spends a point.
        from42To43: (m, schema) async {
          for (final column in [
            schema.careers.skillManManagement,
            schema.careers.skillTactical,
            schema.careers.skillYouthDevelopment,
            schema.careers.skillNegotiation,
            schema.careers.staffAssistant,
            schema.careers.staffScout,
            schema.careers.staffFitnessCoach,
            schema.careers.trainingFocus,
          ]) {
            await m.addColumn(schema.careers, column);
          }
        },
        // 43 → 44 names the staff and pins the call-up window.
        //
        // The staff columns are additive and nullable: a save that already has
        // a tier in a job keeps the tier and has nobody in the chair, so every
        // effect reads exactly as it did until the manager hires a person.
        //
        // The training focus goes the other way — it is DROPPED. The choice
        // was noise (there was never a reason to change it once made), so the
        // assistant now does all three of its jobs at half weight and the
        // column has nothing left to say. A dropped column needs the table
        // rebuilt, which is what alterTable does here; every other column and
        // every row survives it.
        from43To44: (m, schema) async {
          for (final column in [
            schema.careers.staffAssistantId,
            schema.careers.staffScoutId,
            schema.careers.staffFitnessCoachId,
            // Added here and dropped again at 45 — see that step. A save that
            // upgrades straight from 43 still passes through this one, so the
            // column has to be created for the drop to have something to drop.
            schema.careers.callUpWindowId,
          ]) {
            await m.addColumn(schema.careers, column);
          }
          await m.alterTable(TableMigration(schema.careers));
        },
        // 44 → 45 remembers where the board's gauge finished the last cycle.
        //
        // It also drops call_up_window_id, added one version earlier to pin a
        // squad to its window — which turned out to be a mechanism the save
        // already had: hasWatchedDraw, keyed on the window's first fixture,
        // has always fired a nomination exactly once per period. What was
        // actually wrong was the PERIOD, four matchdays long, so a manager
        // named one squad and lived with it through half a year of qualifiers.
        // See Nomination._qualWindowEvery, now two.
        // Additive and nullable: a save upgraded from before it has no closing
        // figure to carry, so its next cycle opens neutral exactly as every
        // cycle used to.
        from44To45: (m, schema) async {
          await m.addColumn(schema.careers, schema.careers.lastCycleBoard);
          await m.alterTable(TableMigration(schema.careers));
        },
        // 45 → 46 records every host of an edition, not only the first. Purely
        // additive and nullable: an existing honour simply has no list, and
        // reads back as its single stored [hostId], which is what it was.
        from45To46: (m, schema) async {
          await m.addColumn(schema.honours, schema.honours.hostIds);
        },
      )(m, from, to);
    },
  );
}
