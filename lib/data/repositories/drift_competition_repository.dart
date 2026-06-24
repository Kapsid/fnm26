import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';

/// Drift-backed [CompetitionRepository].
class DriftCompetitionRepository implements CompetitionRepository {
  DriftCompetitionRepository(this._db);

  final AppDatabase _db;

  /// The save's current 4-year cycle (Careers.cyclePointer).
  Future<int> _cycle(int careerId) async {
    final c = await (_db.select(_db.careers)
          ..where((t) => t.id.equals(careerId))
          ..limit(1))
        .getSingleOrNull();
    return c?.cyclePointer ?? 0;
  }

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
    int cycle = 0,
    CompetitionKind kind = CompetitionKind.worldCupQualifying,
    String? fixtureRound,
  }) async {
    await _db.transaction(() async {
      final compId = await _db.into(_db.competitions).insert(
            CompetitionsCompanion.insert(
              careerId: careerId,
              confederation: schedule.confederation,
              name: schedule.name,
              cycle: Value(cycle),
              kind: Value(kind),
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
                  round: Value(fixtureRound),
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
    final cycle = await _cycle(careerId);
    final comps = await (_db.select(_db.competitions)
          ..where((t) => t.careerId.equals(careerId) & t.cycle.equals(cycle)))
        .get();
    if (comps.isEmpty) return null;

    // Prefer the finals group (the active stage) over the qualifying group.
    final ordered = [
      ...comps.where((c) => c.kind == CompetitionKind.worldCupFinals),
      ...comps.where((c) => c.kind != CompetitionKind.worldCupFinals),
    ];
    final groups = await (_db.select(_db.qualifyingGroups)
          ..where(
            (t) => t.competitionId.isIn(ordered.map((c) => c.id).toList()),
          ))
        .get();
    if (groups.isEmpty) return null;

    final memberships = await (_db.select(_db.groupMembers)
          ..where((t) => t.nationId.equals(nationId)))
        .get();
    final groupById = {for (final g in groups) g.id: g};
    // Pick the membership in the most advanced competition.
    final rank = {for (var i = 0; i < ordered.length; i++) ordered[i].id: i};

    // Bias towards the competition the player's next match belongs to, so the
    // active stage (qualifying → Nations League → finals) is what's shown.
    final compIds = ordered.map((c) => c.id).toList();
    final nextFx = await (_db.select(_db.fixtures)
          ..where(
            (t) =>
                t.careerId.equals(careerId) &
                t.competitionId.isIn(compIds) &
                t.played.equals(false) &
                (t.homeNationId.equals(nationId) |
                    t.awayNationId.equals(nationId)),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.date)])
          ..limit(1))
        .getSingleOrNull();
    if (nextFx != null) rank[nextFx.competitionId] = -1;

    QualifyingGroupRow? group;
    var best = 1 << 30;
    for (final m in memberships) {
      final g = groupById[m.groupId];
      if (g == null) continue;
      final r = rank[g.competitionId] ?? best;
      if (r < best) {
        best = r;
        group = g;
      }
    }
    if (group == null) return null;
    final groupId = group.id;
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
    final cycle = await _cycle(careerId);
    final comps = await (_db.select(_db.competitions)
          ..where(
            (t) =>
                t.careerId.equals(careerId) &
                t.cycle.equals(cycle) &
                t.kind.equalsValue(CompetitionKind.worldCupQualifying),
          )
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
    final cycle = await _cycle(careerId);
    final comp = await (_db.select(_db.competitions)
          ..where(
            (t) =>
                t.careerId.equals(careerId) &
                t.cycle.equals(cycle) &
                t.confederation.equalsValue(confederation) &
                t.kind.equalsValue(CompetitionKind.worldCupQualifying),
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

  @override
  Future<void> saveFriendlies({
    required int careerId,
    required int nationId,
    required int cycle,
    required List<({DateTime date, int opponentId, bool home})> friendlies,
  }) async {
    if (friendlies.isEmpty) return;
    final compId = await _db.into(_db.competitions).insert(
          CompetitionsCompanion.insert(
            careerId: careerId,
            confederation: Confederation.northAmerica, // unused for friendlies
            name: 'Friendlies',
            kind: const Value(CompetitionKind.friendly),
            cycle: Value(cycle),
          ),
        );
    await _db.batch((b) {
      var matchday = 1;
      for (final f in friendlies) {
        b.insert(
          _db.fixtures,
          FixturesCompanion.insert(
            careerId: careerId,
            competitionId: compId,
            matchday: matchday++,
            date: f.date,
            homeNationId: f.home ? nationId : f.opponentId,
            awayNationId: f.home ? f.opponentId : nationId,
            round: const Value('FRIENDLY'),
          ),
        );
      }
    });
  }

  // --- World Cup finals -----------------------------------------------------

  Future<CompetitionRow?> _finals(int careerId) async {
    final cycle = await _cycle(careerId);
    return (_db.select(_db.competitions)
          ..where(
            (t) =>
                t.careerId.equals(careerId) &
                t.cycle.equals(cycle) &
                t.kind.equalsValue(CompetitionKind.worldCupFinals),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<bool> allQualifyingPlayed(int careerId) async {
    final cycle = await _cycle(careerId);
    final qualifying = await (_db.select(_db.competitions)
          ..where(
            (t) =>
                t.careerId.equals(careerId) &
                t.cycle.equals(cycle) &
                t.kind.equalsValue(CompetitionKind.worldCupQualifying),
          ))
        .get();
    if (qualifying.isEmpty) return false;
    final ids = qualifying.map((c) => c.id).toList();
    final unplayed = await (_db.select(_db.fixtures)
          ..where(
            (t) => t.competitionId.isIn(ids) & t.played.equals(false),
          )
          ..limit(1))
        .getSingleOrNull();
    return unplayed == null;
  }

  @override
  Future<bool> hasFinals(int careerId) async =>
      (await _finals(careerId)) != null;

  @override
  Future<DateTime?> earliestUnplayedDate(
    int careerId,
    DateTime onOrAfter,
  ) async {
    final row = await (_db.select(_db.fixtures)
          ..where(
            (t) =>
                t.careerId.equals(careerId) &
                t.played.equals(false) &
                t.date.isBiggerOrEqualValue(onOrAfter),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.date)])
          ..limit(1))
        .getSingleOrNull();
    return row?.date;
  }

  @override
  Future<void> saveFinals({
    required int careerId,
    required FinalsDraw draw,
    required DateTime groupStart,
    int cycle = 0,
  }) async {
    await _db.transaction(() async {
      final compId = await _db.into(_db.competitions).insert(
            CompetitionsCompanion.insert(
              careerId: careerId,
              // Finals are global; a value is required but never read (queries
              // filter by kind), so a placeholder confederation is stored.
              confederation: Confederation.northAmerica,
              name: 'World Championship Finals',
              kind: const Value(CompetitionKind.worldCupFinals),
              cycle: Value(cycle),
            ),
          );

      for (final group in draw.groups) {
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
              for (final (matchday, home, away) in group.fixtures)
                FixturesCompanion.insert(
                  careerId: careerId,
                  competitionId: compId,
                  groupId: Value(groupId),
                  matchday: matchday,
                  date: groupStart.add(Duration(days: (matchday - 1) * 3)),
                  homeNationId: home,
                  awayNationId: away,
                  round: const Value('GROUP'),
                ),
            ]);
        });
      }
    });
  }

  @override
  Future<List<FinalsGroupTable>> finalsGroupTables(int careerId) async {
    final comp = await _finals(careerId);
    if (comp == null) return [];
    final groups = await (_db.select(_db.qualifyingGroups)
          ..where((t) => t.competitionId.equals(comp.id))
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .get();
    final tables = <FinalsGroupTable>[];
    for (final group in groups) {
      final members = await (_db.select(_db.groupMembers)
            ..where((t) => t.groupId.equals(group.id)))
          .get();
      final fixtures = await (_db.select(_db.fixtures)
            ..where((t) => t.groupId.equals(group.id)))
          .get();
      tables.add((
        name: group.name,
        standings: GroupStanding.table(
          members.map((m) => m.nationId).toList(),
          fixtures.map((r) => r.toDomain()).toList(),
        ),
      ));
    }
    return tables;
  }

  @override
  Future<List<Fixture>> fixturesByRound(int careerId, String round) async {
    final comp = await _finals(careerId);
    if (comp == null) return [];
    final query = _db.select(_db.fixtures)
      ..where(
        (t) => t.competitionId.equals(comp.id) & t.round.equals(round),
      )
      ..orderBy([(t) => OrderingTerm(expression: t.id)]);
    return (await query.get()).map((r) => r.toDomain()).toList();
  }

  @override
  Future<List<Fixture>> finalsKnockoutFixtures(int careerId) async {
    final comp = await _finals(careerId);
    if (comp == null) return [];
    final query = _db.select(_db.fixtures)
      ..where(
        (t) =>
            t.competitionId.equals(comp.id) & t.round.equals('GROUP').not(),
      )
      ..orderBy([
        (t) => OrderingTerm(expression: t.date),
        (t) => OrderingTerm(expression: t.id),
      ]);
    return (await query.get()).map((r) => r.toDomain()).toList();
  }

  @override
  Future<void> addKnockoutFixtures({
    required int careerId,
    required String round,
    required List<(int home, int away)> pairings,
    required DateTime date,
  }) async {
    final comp = await _finals(careerId);
    if (comp == null) return;
    await _db.batch((b) {
      b.insertAll(_db.fixtures, [
        for (final (home, away) in pairings)
          FixturesCompanion.insert(
            careerId: careerId,
            competitionId: comp.id,
            matchday: 99,
            date: date,
            homeNationId: home,
            awayNationId: away,
            round: Value(round),
          ),
      ]);
    });
  }

  @override
  Future<int?> worldChampion(int careerId) async {
    final comp = await _finals(careerId);
    if (comp == null) return null;
    final f = await (_db.select(_db.fixtures)
          ..where(
            (t) =>
                t.competitionId.equals(comp.id) &
                t.round.equals(WorldCupFinals.finalRound) &
                t.played.equals(true),
          )
          ..limit(1))
        .getSingleOrNull();
    if (f == null || f.homeScore == null || f.awayScore == null) return null;
    return f.homeScore! >= f.awayScore! ? f.homeNationId : f.awayNationId;
  }

  // --- Goals & honours ------------------------------------------------------

  @override
  Future<void> recordGoals(List<GoalRecord> goals) async {
    if (goals.isEmpty) return;
    await _db.batch((b) {
      b.insertAll(_db.goalEvents, [
        for (final g in goals)
          GoalEventsCompanion.insert(
            careerId: g.careerId,
            competitionId: g.competitionId,
            fixtureId: g.fixtureId,
            nationId: g.nationId,
            playerId: g.playerId,
            minute: g.minute,
          ),
      ]);
    });
  }

  @override
  Future<List<ScorerTally>> topScorers(
    int careerId, {
    CompetitionKind? kind,
    int limit = 20,
  }) async {
    // Scope to the current cycle's competitions (optionally of one kind).
    final cycle = await _cycle(careerId);
    final comps = await (_db.select(_db.competitions)
          ..where(
            (t) =>
                t.careerId.equals(careerId) &
                t.cycle.equals(cycle) &
                (kind == null
                    ? const Constant(true)
                    : t.kind.equalsValue(kind)),
          ))
        .get();
    final compIds = comps.map((c) => c.id).toSet();
    if (compIds.isEmpty) return [];

    final rows = await (_db.select(_db.goalEvents)
          ..where((t) => t.careerId.equals(careerId)))
        .get();

    final tally = <int, ({int nationId, int goals})>{};
    for (final r in rows) {
      if (!compIds.contains(r.competitionId)) continue;
      final cur = tally[r.playerId];
      tally[r.playerId] = (
        nationId: r.nationId,
        goals: (cur?.goals ?? 0) + 1,
      );
    }

    final list = tally.entries
        .map(
          (e) => (
            playerId: e.key,
            nationId: e.value.nationId,
            goals: e.value.goals,
          ),
        )
        .toList()
      ..sort((a, b) => b.goals.compareTo(a.goals));
    return list.take(limit).toList();
  }

  @override
  Future<void> recordHonour({
    required int careerId,
    required int year,
    required String competition,
    required int championId,
    required int runnerUpId,
    int? thirdId,
    int? hostId,
    int? finalHomeScore,
    int? finalAwayScore,
    String? topScorerName,
    int? topScorerGoals,
  }) async {
    await _db.into(_db.honours).insert(
          HonoursCompanion.insert(
            careerId: careerId,
            year: year,
            competition: competition,
            championId: championId,
            runnerUpId: runnerUpId,
            thirdId: Value(thirdId),
            hostId: Value(hostId),
            finalHomeScore: Value(finalHomeScore),
            finalAwayScore: Value(finalAwayScore),
            topScorerName: Value(topScorerName),
            topScorerGoals: Value(topScorerGoals),
          ),
        );
  }

  @override
  Future<bool> hasHonour(int careerId, String competition, int year) async {
    final row = await (_db.select(_db.honours)
          ..where(
            (t) =>
                t.careerId.equals(careerId) &
                t.competition.equals(competition) &
                t.year.equals(year),
          )
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  @override
  Future<List<Honour>> honours(int careerId) async {
    final rows = await (_db.select(_db.honours)
          ..where((t) => t.careerId.equals(careerId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.year, mode: OrderingMode.desc),
          ]))
        .get();
    return [
      for (final r in rows)
        (
          year: r.year,
          competition: r.competition,
          championId: r.championId,
          runnerUpId: r.runnerUpId,
          thirdId: r.thirdId,
          hostId: r.hostId,
          finalHomeScore: r.finalHomeScore,
          finalAwayScore: r.finalAwayScore,
          topScorerName: r.topScorerName,
          topScorerGoals: r.topScorerGoals,
        ),
    ];
  }
}
