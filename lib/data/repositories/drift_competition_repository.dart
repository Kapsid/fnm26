import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';

/// Drift-backed [CompetitionRepository].
class DriftCompetitionRepository implements CompetitionRepository {
  DriftCompetitionRepository(this._db);

  final AppDatabase _db;

  @override
  Future<bool> hasSchedule(int careerId) async {
    final row = await (_db.select(_db.competitions)
          ..where((t) => t.careerId.equals(careerId))
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  @override
  Future<void> saveSchedule({
    required int careerId,
    required GeneratedSchedule schedule,
  }) async {
    await _db.transaction(() async {
      final compId = await _db.into(_db.competitions).insert(
            CompetitionsCompanion.insert(
              careerId: careerId,
              confederation: schedule.confederation,
              name: schedule.name,
            ),
          );

      for (final group in schedule.groups) {
        final groupId = await _db.into(_db.qualifyingGroups).insert(
              QualifyingGroupsCompanion.insert(
                competitionId: compId,
                name: group.name,
              ),
            );
        await _db.batch((b) {
          b
            ..insertAll(_db.groupMembers, [
              for (final nationId in group.nationIds)
                GroupMembersCompanion.insert(
                  groupId: groupId,
                  nationId: nationId,
                ),
            ])
            ..insertAll(_db.fixtures, [
              for (final f in group.fixtures)
                FixturesCompanion.insert(
                  careerId: careerId,
                  competitionId: compId,
                  groupId: Value(groupId),
                  matchday: f.matchday,
                  date: f.date,
                  homeNationId: f.homeNationId,
                  awayNationId: f.awayNationId,
                ),
            ]);
        });
      }
    });
  }

  @override
  Future<List<Fixture>> fixturesForNation(int careerId, int nationId) async {
    final query = _db.select(_db.fixtures)
      ..where(
        (t) =>
            t.careerId.equals(careerId) &
            (t.homeNationId.equals(nationId) | t.awayNationId.equals(nationId)),
      )
      ..orderBy([(t) => OrderingTerm(expression: t.date)]);
    return (await query.get()).map((r) => r.toDomain()).toList();
  }

  @override
  Future<List<Fixture>> allFixtures(int careerId) async {
    final query = _db.select(_db.fixtures)
      ..where((t) => t.careerId.equals(careerId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.matchday),
        (t) => OrderingTerm(expression: t.date),
      ]);
    return (await query.get()).map((r) => r.toDomain()).toList();
  }

  @override
  Future<List<Fixture>> unplayedDueBy(int careerId, DateTime date) async {
    final query = _db.select(_db.fixtures)
      ..where(
        (t) =>
            t.careerId.equals(careerId) &
            t.played.equals(false) &
            t.date.isSmallerOrEqualValue(date),
      )
      ..orderBy([(t) => OrderingTerm(expression: t.date)]);
    return (await query.get()).map((r) => r.toDomain()).toList();
  }

  @override
  Future<Fixture?> nextFixtureForNation(
    int careerId,
    int nationId,
    DateTime onOrAfter,
  ) async {
    final query = _db.select(_db.fixtures)
      ..where(
        (t) =>
            t.careerId.equals(careerId) &
            t.played.equals(false) &
            (t.homeNationId.equals(nationId) |
                t.awayNationId.equals(nationId)) &
            t.date.isBiggerOrEqualValue(onOrAfter),
      )
      ..orderBy([(t) => OrderingTerm(expression: t.date)])
      ..limit(1);
    return (await query.getSingleOrNull())?.toDomain();
  }

  @override
  Future<void> recordResult({
    required int fixtureId,
    required int homeScore,
    required int awayScore,
  }) async {
    await (_db.update(_db.fixtures)..where((t) => t.id.equals(fixtureId)))
        .write(
      FixturesCompanion(
        homeScore: Value(homeScore),
        awayScore: Value(awayScore),
        played: const Value(true),
      ),
    );
  }

  @override
  Future<GroupTable?> groupTableForNation(int careerId, int nationId) async {
    // Search across every confederation's competition for this save.
    final comps = await (_db.select(_db.competitions)
          ..where((t) => t.careerId.equals(careerId)))
        .get();
    if (comps.isEmpty) return null;
    final compIds = comps.map((c) => c.id).toList();

    final groups = await (_db.select(_db.qualifyingGroups)
          ..where((t) => t.competitionId.isIn(compIds)))
        .get();
    final groupIds = groups.map((g) => g.id).toList();
    if (groupIds.isEmpty) return null;

    final member = await (_db.select(_db.groupMembers)
          ..where((t) => t.nationId.equals(nationId) & t.groupId.isIn(groupIds))
          ..limit(1))
        .getSingleOrNull();
    if (member == null) return null;

    final groupId = member.groupId;
    final group = groups.firstWhere((g) => g.id == groupId);
    final members = await (_db.select(_db.groupMembers)
          ..where((t) => t.groupId.equals(groupId)))
        .get();
    final fixtures = await (_db.select(_db.fixtures)
          ..where((t) => t.groupId.equals(groupId)))
        .get();

    final standings = GroupStanding.table(
      members.map((m) => m.nationId).toList(),
      fixtures.map((r) => r.toDomain()).toList(),
    );
    return (groupId: groupId, name: group.name, standings: standings);
  }

  @override
  Future<List<ConfederationGroupTable>> allGroupTablesByConfederation(
    int careerId,
  ) async {
    final comps = await (_db.select(_db.competitions)
          ..where((t) => t.careerId.equals(careerId))
          ..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .get();

    final result = <ConfederationGroupTable>[];
    for (final comp in comps) {
      final groups = await (_db.select(_db.qualifyingGroups)
            ..where((t) => t.competitionId.equals(comp.id))
            ..orderBy([(t) => OrderingTerm(expression: t.name)]))
          .get();
      for (final group in groups) {
        final members = await (_db.select(_db.groupMembers)
              ..where((t) => t.groupId.equals(group.id)))
            .get();
        final fixtures = await (_db.select(_db.fixtures)
              ..where((t) => t.groupId.equals(group.id)))
            .get();
        result.add((
          confederation: comp.confederation,
          groupName: group.name,
          standings: GroupStanding.table(
            members.map((m) => m.nationId).toList(),
            fixtures.map((r) => r.toDomain()).toList(),
          ),
        ));
      }
    }
    return result;
  }

  @override
  Future<List<Fixture>> fixturesForConfederation(
    int careerId,
    Confederation confederation,
  ) async {
    final comp = await (_db.select(_db.competitions)
          ..where(
            (t) =>
                t.careerId.equals(careerId) &
                t.confederation.equalsValue(confederation),
          )
          ..limit(1))
        .getSingleOrNull();
    if (comp == null) return [];
    final query = _db.select(_db.fixtures)
      ..where((t) => t.competitionId.equals(comp.id))
      ..orderBy([
        (t) => OrderingTerm(expression: t.matchday),
        (t) => OrderingTerm(expression: t.date),
      ]);
    return (await query.get()).map((r) => r.toDomain()).toList();
  }

  @override
  Future<List<GroupTable>> allGroupTables(int careerId) async {
    final comp = await (_db.select(_db.competitions)
          ..where((t) => t.careerId.equals(careerId))
          ..limit(1))
        .getSingleOrNull();
    if (comp == null) return [];

    final groups = await (_db.select(_db.qualifyingGroups)
          ..where((t) => t.competitionId.equals(comp.id))
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .get();

    final tables = <GroupTable>[];
    for (final group in groups) {
      final members = await (_db.select(_db.groupMembers)
            ..where((t) => t.groupId.equals(group.id)))
          .get();
      final fixtures = await (_db.select(_db.fixtures)
            ..where((t) => t.groupId.equals(group.id)))
          .get();
      tables.add((
        groupId: group.id,
        name: group.name,
        standings: GroupStanding.table(
          members.map((m) => m.nationId).toList(),
          fixtures.map((r) => r.toDomain()).toList(),
        ),
      ));
    }
    return tables;
  }
}
