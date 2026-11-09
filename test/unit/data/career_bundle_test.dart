import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' show DriftSqlType, Value, Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

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
    // A table is either seed data, the manager's own (no career), the career
    // row, scoped by career_id, or reached through a parent -- and there is
    // no sixth option.
    for (final table in db.allTables) {
      final name = table.actualTableName;
      if (CareerBundle.seedTables.contains(name)) continue;
      if (CareerBundle.globalTables.contains(name)) continue;
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

  test('every binary column a bundle carries is one it knows', () {
    // Bundles are JSON. A blob column travels as base64 text, which
    // CareerBundle does by column type; this list makes a NEW blob column a
    // deliberate decision (with a round-trip test) rather than a surprise.
    final carried = <String>{
      for (final table in db.allTables)
        if (!CareerBundle.seedTables.contains(table.actualTableName) &&
            !CareerBundle.globalTables.contains(table.actualTableName))
          for (final column in table.$columns)
            if (column.type == DriftSqlType.blob)
              '${table.actualTableName}.${column.$name}',
    };
    expect(carried, {'career_world_trophies.png'});
  });

  test('the world packs themselves never travel in a bundle', () {
    expect(
      CareerBundle.globalTables,
      containsAll(['world_packs', 'world_pack_trophies']),
    );
    expect(CareerBundle.tablesOf(db), isNot(contains('world_packs')));
    expect(CareerBundle.tablesOf(db), isNot(contains('world_pack_trophies')));
  });

  test(
    'a career on a world exports and imports with its world and trophies',
    () async {
      await aCareerNamed('Bystander'); // so the career id must shift
      final original = await aCareerNamed('Worldly');
      final packs = WorldPackRepository(db);
      const pack = WorldPack(
        uuid: 'u-1',
        name: 'My World',
        author: 'Me',
        formatVersion: kPackFormatVersion,
        madeWithVersion: '1.1.0',
        nations: {7: (name: 'Testland', code: 'TST')},
        trophies: {'worldChampionship'},
      );
      final png = Uint8List.fromList([137, 80, 78, 71, 0, 255, 9]);
      final packId = await packs.insert(pack, {'worldChampionship': png});
      await db.transaction(() => packs.copyToCareer(packId, original));

      // Through bytes, as a real file would go.
      final bundle = CareerBundle.decode(
        CareerBundle.encode(await CareerBundle.export(db, original)),
      ).bundle!;
      // A format-2 world: 1.1.0 must read the bundle as newer.
      expect(bundle['format'], 3);
      expect(
        (bundle['tables']! as Map).keys,
        isNot(contains('world_packs')),
        reason: 'the device library is not part of a career',
      );

      // Import on a device that has never seen the pack.
      await packs.delete(packId);
      final imported = await CareerBundle.import(db, bundle);
      expect(imported, isNot(original));

      final world = await packs.forCareer(imported);
      expect(world, isNotNull);
      expect(world!.pack, pack);
      expect(world.trophies, {'worldChampionship': png});
      expect(await db.select(db.worldPacks).get(), isEmpty);
    },
  );

  test(
    'a career on a format-1 world, or none, still writes bundle format 2',
    () async {
      final plain = await aCareerNamed('Plain');
      expect((await CareerBundle.export(db, plain))['format'], 2);

      // A career a 1.1.0 build started: its world stored in pack format 1.
      final old = await aCareerNamed('OldWorld');
      await db
          .into(db.careerWorlds)
          .insert(
            CareerWorldsCompanion.insert(
              careerId: Value(old),
              packName: 'Old World',
              json: jsonEncode({
                'formatVersion': 1,
                'uuid': 'u-1',
                'name': 'Old World',
                'author': '',
                'madeWithVersion': '1.1.0',
              }),
            ),
          );
      final bundle = await CareerBundle.export(db, old);
      expect(bundle['format'], 2);
      // And this build reads both formats.
      for (final f in [2, 3]) {
        bundle['format'] = f;
        expect(
          CareerBundle.decode(CareerBundle.encode(bundle)).rejection,
          isNull,
        );
      }
    },
  );

  test('a bundle written before 53 imports as a default career', () async {
    final original = await aCareerNamed('Classic');
    final bundle = await CareerBundle.export(db, original);
    // What a v52 build wrote: format 1, and no world tables at all.
    bundle
      ..['format'] = 1
      ..['schemaVersion'] = 52;
    (bundle['tables']! as Map)
      ..remove('career_worlds')
      ..remove('career_world_trophies');

    final decoded = CareerBundle.decode(CareerBundle.encode(bundle));
    expect(decoded.rejection, isNull);
    final imported = await CareerBundle.import(db, decoded.bundle!);

    expect(await WorldPackRepository(db).forCareer(imported), isNull);
    final name =
        await (db.select(
              db.careers,
            )..where((t) => t.id.equals(imported)))
            .map((c) => c.managerName)
            .getSingle();
    expect(name, 'Classic');
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

  test('the captain and both vice-captains travel with the career', () async {
    final original = await aCareerNamed('Leaders');
    await (db.update(db.careers)..where((t) => t.id.equals(original))).write(
      const CareersCompanion(
        captainPlayerId: Value(11),
        viceCaptain1PlayerId: Value(12),
        viceCaptain2PlayerId: Value(13),
      ),
    );
    final bundle = CareerBundle.decode(
      CareerBundle.encode(await CareerBundle.export(db, original)),
    ).bundle!;

    final imported = await CareerBundle.import(db, bundle);
    final row = await (db.select(
      db.careers,
    )..where((t) => t.id.equals(imported))).getSingle();
    // Player ids name seed data, stable across installs: carried as they are.
    expect(row.captainPlayerId, 11);
    expect(row.viceCaptain1PlayerId, 12);
    expect(row.viceCaptain2PlayerId, 13);
  });

  test('a bundle from before vice-captains imports with none named', () async {
    final original = await aCareerNamed('Older');
    await (db.update(db.careers)..where((t) => t.id.equals(original))).write(
      const CareersCompanion(captainPlayerId: Value(11)),
    );
    final bundle = await CareerBundle.export(db, original);
    // What a v51 build wrote: the careers row has no vice-captain columns.
    bundle['schemaVersion'] = 51;
    final careers = ((bundle['tables']! as Map)['careers']! as List)
        .cast<Map<String, Object?>>();
    expect(careers.single, contains('vice_captain1_player_id'));
    for (final row in careers) {
      row
        ..remove('vice_captain1_player_id')
        ..remove('vice_captain2_player_id');
    }

    final imported = await CareerBundle.import(db, bundle);
    final row = await (db.select(
      db.careers,
    )..where((t) => t.id.equals(imported))).getSingle();
    expect(row.captainPlayerId, 11);
    expect(row.viceCaptain1PlayerId, isNull);
    expect(row.viceCaptain2PlayerId, isNull);
  });

  test('manager rows keep their ids through a round trip', () async {
    final original = await aCareerNamed('Managers');
    final on = DateTime.utc(2030, 7);
    for (final id in const [501, 502]) {
      await db
          .into(db.worldManagers)
          .insert(
            WorldManagersCompanion.insert(
              careerId: original,
              managerId: id,
              name: 'Manager $id',
              nationality: 'CZE',
              birthYear: 1975,
              style: 'balanced',
              origin: 'seeded',
              enteredAt: on,
            ),
          );
    }
    for (final (spell, manager, nation) in const [
      (1, 501, 10),
      (2, 502, 11),
      (3, 501, 12),
    ]) {
      await db
          .into(db.managerSpells)
          .insert(
            ManagerSpellsCompanion.insert(
              careerId: original,
              spellNo: spell,
              managerId: manager,
              nationId: nation,
              fromDate: on,
              contractUntil: DateTime.utc(2034),
            ),
          );
    }
    await db
        .into(db.managerTies)
        .insert(
          ManagerTiesCompanion.insert(
            careerId: original,
            tieNo: 7,
            managerId: 502,
            kind: 'grudge',
            delta: -2,
            date: on,
          ),
        );

    final bundle = CareerBundle.decode(
      CareerBundle.encode(await CareerBundle.export(db, original)),
    ).bundle!;
    final imported = await CareerBundle.import(db, bundle);

    expect(imported, isNot(original));
    final managers = await (db.select(
      db.worldManagers,
    )..where((t) => t.careerId.equals(imported))).get();
    expect(managers.map((m) => m.managerId).toSet(), {501, 502});
    final spells = await (db.select(
      db.managerSpells,
    )..where((t) => t.careerId.equals(imported))).get();
    expect(
      {for (final s in spells) (s.spellNo, s.managerId, s.nationId)},
      {(1, 501, 10), (2, 502, 11), (3, 501, 12)},
    );
    final ties = await (db.select(
      db.managerTies,
    )..where((t) => t.careerId.equals(imported))).get();
    expect(ties.single.tieNo, 7);
    expect(ties.single.managerId, 502);
    expect(ties.single.delta, -2);
  });

  test('a bundle from 54 imports with no manager rows', () async {
    final original = await aCareerNamed('Pre55');
    final bundle = await CareerBundle.export(db, original);
    // What a schema-54 build wrote: no manager tables at all.
    bundle['schemaVersion'] = 54;
    (bundle['tables']! as Map)
      ..remove('world_managers')
      ..remove('manager_spells')
      ..remove('manager_ties');

    final decoded = CareerBundle.decode(CareerBundle.encode(bundle));
    expect(decoded.rejection, isNull);
    final imported = await CareerBundle.import(db, decoded.bundle!);

    for (final table in const [
      'world_managers',
      'manager_spells',
      'manager_ties',
    ]) {
      final n = await db
          .customSelect(
            'SELECT COUNT(*) AS n FROM $table WHERE career_id = ?',
            variables: [Variable<int>(imported)],
          )
          .map((r) => r.read<int>('n'))
          .getSingle();
      expect(n, 0, reason: '$table should be empty');
    }
    final name =
        await (db.select(
              db.careers,
            )..where((t) => t.id.equals(imported)))
            .map((c) => c.managerName)
            .getSingle();
    expect(name, 'Pre55');
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

  test('press statements and conferences follow their fixture', () async {
    await aCareerNamed('Bystander'); // so the fixture ids must shift
    final original = await aCareerNamed('Pundit');
    final fixtureId = await (db.select(
      db.fixtures,
    )..where((t) => t.careerId.equals(original))).map((f) => f.id).getSingle();
    await db
        .into(db.pressStatements)
        .insert(
          PressStatementsCompanion.insert(
            careerId: original,
            cycle: 0,
            nationId: 1,
            kind: 'winNext',
            madeOn: DateTime.utc(2030, 6, 10),
            madeAfterFixtureId: fixtureId,
          ),
        );
    await db
        .into(db.pressConferences)
        .insert(
          PressConferencesCompanion.insert(
            careerId: original,
            cycle: 0,
            reason: 'bigWin',
            fixtureId: fixtureId,
            triggeredOn: DateTime.utc(2030, 6, 10),
          ),
        );

    final bundle = await CareerBundle.export(db, original);
    final imported = await CareerBundle.import(db, bundle);

    final importedFixture = await (db.select(
      db.fixtures,
    )..where((t) => t.careerId.equals(imported))).map((f) => f.id).getSingle();
    expect(importedFixture, isNot(fixtureId));
    final statement = await (db.select(
      db.pressStatements,
    )..where((t) => t.careerId.equals(imported))).getSingle();
    final conference = await (db.select(
      db.pressConferences,
    )..where((t) => t.careerId.equals(imported))).getSingle();
    expect(statement.madeAfterFixtureId, importedFixture);
    expect(conference.fixtureId, importedFixture);
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

    test('refuses a bundle in a later file format', () async {
      final careerId = await aCareerNamed('Future');
      final bundle = await CareerBundle.export(db, careerId);
      bundle['format'] = CareerBundle.formatVersion + 1;

      expect(
        CareerBundle.decode(CareerBundle.encode(bundle)).rejection,
        BundleRejection.fromANewerBuild,
      );
    });
  });
}
