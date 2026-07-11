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
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // v2 adds the competition/fixture tables.
          if (from < 2) {
            await m.createTable(competitions);
            await m.createTable(qualifyingGroups);
            await m.createTable(groupMembers);
            await m.createTable(fixtures);
          }
          // v3 adds the tactics/lineup tables.
          if (from < 3) {
            await m.createTable(tactics);
            await m.createTable(lineupSlots);
          }
          // v4 adds the World Cup finals: competition kind + fixture round.
          if (from < 4) {
            await m.addColumn(competitions, competitions.kind);
            await m.addColumn(fixtures, fixtures.round);
          }
          // v5 adds goal events (top scorers) and the honours roll.
          if (from < 5) {
            await m.createTable(goalEvents);
            await m.createTable(honours);
          }
          // v6 enriches honours with host, final score, and golden boot.
          if (from < 6) {
            await m.addColumn(honours, honours.hostId);
            await m.addColumn(honours, honours.finalHomeScore);
            await m.addColumn(honours, honours.finalAwayScore);
            await m.addColumn(honours, honours.topScorerName);
            await m.addColumn(honours, honours.topScorerGoals);
          }
          // v7 scopes competitions to an endless 4-year cycle.
          if (from < 7) {
            await m.addColumn(competitions, competitions.cycle);
          }
          // v8 adds the call-up (squad selection) table.
          if (from < 8) {
            await m.createTable(callUps);
          }
          // v9 tracks which draw ceremonies have been watched (one-time play).
          if (from < 9) {
            await m.createTable(drawsWatched);
          }
          // v10 adds the player's club (pool is topped up by the seed loader).
          if (from < 10) {
            await m.addColumn(players, players.club);
          }
          // v11 tracks suspensions and injuries.
          if (from < 11) {
            await m.createTable(playerAbsences);
          }
        },
      );
}
