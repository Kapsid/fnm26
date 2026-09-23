import 'package:drift/drift.dart' show DriftSqlType, Value, Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/domain/entities/enums.dart';

/// Exporting one career to a file and importing it back.
///
/// The two things that make this more than a copy, and so the two things worth
/// testing hardest: the save is not cleanly partitioned by career (two tables
/// belong to one only through their parents), and the ids of competitions,
/// groups and fixtures have to be renumbered on the way in so the incoming
/// career does not attach itself to whatever already holds those ids.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  /// A career with something in every part of the graph that matters.
  Future<int> aCareerNamed(String manager) async {
    final careerId = await db
        .into(db.careers)
        .insert(
          CareersCompanion.insert(
            nationId: 1,
            managerName: manager,
            createdAt: DateTime.utc(2030),
            inGameDate: DateTime.utc(2030, 6, 1),
            rngSeed: 7,
          ),
        );
    final competitionId = await db
        .into(db.competitions)
        .insert(
          CompetitionsCompanion.insert(
            careerId: careerId,
            name: '$manager Cup',
            kind: const Value(CompetitionKind.worldCupFinals),
            confederation: Confederation.europe,
            cycle: const Value(0),
          ),
        );
    final groupId = await db
        .into(db.qualifyingGroups)
        .insert(
          QualifyingGroupsCompanion.insert(
            competitionId: competitionId,
            name: 'A',
          ),
        );
    await db
        .into(db.groupMembers)
        .insert(
          GroupMembersCompanion.insert(groupId: groupId, nationId: 1),
        );
    final fixtureId = await db
        .into(db.fixtures)
        .insert(
          FixturesCompanion.insert(
            careerId: careerId,
            competitionId: competitionId,
            groupId: Value(groupId),
            matchday: 1,
            date: DateTime.utc(2030, 6, 10),
            homeNationId: 1,
            awayNationId: 2,
          ),
        );
    await db
        .into(db.goalEvents)
        .insert(
          GoalEventsCompanion.insert(
            careerId: careerId,
            competitionId: competitionId,
            fixtureId: fixtureId,
            nationId: 1,
            playerId: 100,
            minute: 12,
          ),
        );
    await db
        .into(db.callUps)
        .insert(
          CallUpsCompanion.insert(careerId: careerId, playerId: 100),
        );
    return careerId;
  }

  test('every table is classified, so a new one cannot be forgotten', () {
    // The maintenance tax this feature would otherwise carry: add a table,
    // forget the exporter, and saves silently lose it on every round trip.
    // A table is either seed data, the career row, scoped by career_id, or
    // reached through a parent -- and there is no fifth option.
    for (final table in db.allTables) {
      final name = table.actualTableName;
      if (CareerBundle.seedTables.contains(name)) continue;
      if (name == CareerBundle.rootTable) continue;
      if (CareerBundle.derivedScope.containsKey(name)) continue;
      expect(
        table.$columns.map((c) => c.$name),
        contains('career_id'),
        reason:
            '"$name" has no career_id and is not listed in '
            'CareerBundle.derivedScope -- decide which it is, or a career '
            'exports without it',
      );
    }
  });

  test('a bundle carries no binary columns', () {
    // Bundles are JSON. A blob column would survive export as something
    // jsonEncode cannot write, and the failure would land on a player rather
    // than here.
    for (final table in db.allTables) {
      for (final column in table.$columns) {
        expect(
          column.type,
          isNot(DriftSqlType.blob),
          reason:
              '${table.actualTableName}.${column.$name} is a blob -- '
              'CareerBundle.encode has to learn how to carry it',
        );
      }
    }
  });

  test('a career survives a round trip', () async {
    final original = await aCareerNamed('Original');
    final bundle = await CareerBundle.export(db, original);

    final imported = await CareerBundle.import(db, bundle);

    expect(imported, isNot(original), reason: 'it lands as a NEW save');
    final name = await db
        .customSelect(
          'SELECT manager_name FROM careers WHERE id = ?',
          variables: [Variable<int>(imported)],
        )
        .map((r) => r.read<String>('manager_name'))
        .getSingle();
    expect(name, 'Original');

    for (final table in [
      'competitions',
      'fixtures',
      'goal_events',
      'call_ups',
    ]) {
      final count = await db
          .customSelect(
            'SELECT COUNT(*) AS n FROM $table WHERE career_id = ?',
            variables: [Variable<int>(imported)],
          )
          .map((r) => r.read<int>('n'))
          .getSingle();
      expect(count, 1, reason: '$table did not come across');
    }
  });

  test('importing leaves the career it was exported from alone', () async {
    final original = await aCareerNamed('Untouched');
    final bundle = await CareerBundle.export(db, original);
    await CareerBundle.import(db, bundle);

    final fixtures = await db
        .customSelect(
          'SELECT COUNT(*) AS n FROM fixtures WHERE career_id = ?',
          variables: [Variable<int>(original)],
        )
        .map((r) => r.read<int>('n'))
        .getSingle();
    expect(fixtures, 1, reason: 'the original still has exactly its own row');
  });

  test('the imported career points at its OWN competitions and groups', () async {
    // The bug this pins: insert the rows as they came and the new career's
    // fixtures still name the old competition ids -- which belong to somebody
    // else's save. Two careers are imported so the ids cannot coincide.
    final original = await aCareerNamed('First');
    final bundle = await CareerBundle.export(db, original);
    await CareerBundle.import(db, bundle);
    final second = await CareerBundle.import(db, bundle);

    final row = await db
        .customSelect(
          'SELECT f.competition_id AS comp, f.group_id AS grp '
          'FROM fixtures f WHERE f.career_id = ?',
          variables: [Variable<int>(second)],
        )
        .getSingle();
    final competitionId = row.read<int>('comp');
    final groupId = row.read<int>('grp');

    final ownsCompetition = await db
        .customSelect(
          'SELECT COUNT(*) AS n FROM competitions WHERE id = ? AND career_id = ?',
          variables: [Variable<int>(competitionId), Variable<int>(second)],
        )
        .map((r) => r.read<int>('n'))
        .getSingle();
    expect(ownsCompetition, 1, reason: 'the fixture names another save\'s cup');

    // And the group hangs off that same competition, not the original's.
    final groupCompetition = await db
        .customSelect(
          'SELECT competition_id AS comp FROM qualifying_groups WHERE id = ?',
          variables: [Variable<int>(groupId)],
        )
        .map((r) => r.read<int>('comp'))
        .getSingle();
    expect(groupCompetition, competitionId);

    // group_members has no career_id at all -- it is reached only through the
    // group, and is exactly the row a naive exporter drops.
    final members = await db
        .customSelect(
          'SELECT COUNT(*) AS n FROM group_members WHERE group_id = ?',
          variables: [Variable<int>(groupId)],
        )
        .map((r) => r.read<int>('n'))
        .getSingle();
    expect(members, 1, reason: 'the group came across without its members');
  });

  test('goal events follow their fixture to its new number', () async {
    final original = await aCareerNamed('Scorer');
    final bundle = await CareerBundle.export(db, original);
    final imported = await CareerBundle.import(db, bundle);

    final orphaned = await db
        .customSelect(
          'SELECT COUNT(*) AS n FROM goal_events g '
          'LEFT JOIN fixtures f ON f.id = g.fixture_id '
          'WHERE g.career_id = ? AND f.id IS NULL',
          variables: [Variable<int>(imported)],
        )
        .map((r) => r.read<int>('n'))
        .getSingle();
    expect(orphaned, 0, reason: 'a goal that belongs to no fixture');
  });

  group('reading a file back', () {
    test('survives the round trip through bytes', () async {
      final careerId = await aCareerNamed('Encoded');
      final bundle = await CareerBundle.export(db, careerId);

      final decoded = CareerBundle.decode(CareerBundle.encode(bundle));

      expect(decoded.rejection, isNull);
      expect(decoded.bundle!['managerName'], 'Encoded');
    });

    test('refuses nonsense', () {
      expect(
        CareerBundle.decode([1, 2, 3]).rejection,
        BundleRejection.unreadable,
      );
    });

    test('refuses a bundle from a later build', () async {
      final careerId = await aCareerNamed('Future');
      final bundle = await CareerBundle.export(db, careerId);
      bundle['schemaVersion'] = AppDatabase.currentSchemaVersion + 1;

      expect(
        CareerBundle.decode(CareerBundle.encode(bundle)).rejection,
        BundleRejection.fromANewerBuild,
      );
    });
  });
}
