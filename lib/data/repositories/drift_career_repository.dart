import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/manager/manager_skills.dart';
import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/domain/entities/career.dart';
// FederationInvestment typedef.
import 'package:fnm/domain/repositories/career_repository.dart';

/// Drift-backed [CareerRepository].
class DriftCareerRepository implements CareerRepository {
  DriftCareerRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Career> create({
    required String managerName,
    required int nationId,
    required int rngSeed,
    required DateTime startDate,
  }) async {
    final id = await _db
        .into(_db.careers)
        .insert(
          CareersCompanion.insert(
            managerName: managerName,
            nationId: nationId,
            rngSeed: rngSeed,
            createdAt: startDate,
            inGameDate: startDate,
            // A brand-new save counts as just played, so it opens at the top
            // of the list rather than below older saves.
            lastPlayedAt: Value(DateTime.now()),
          ),
        );
    final row = await (_db.select(
      _db.careers,
    )..where((t) => t.id.equals(id))).getSingle();
    return row.toDomain();
  }

  @override
  Future<List<Career>> all() async {
    // Most recently played first. A save that predates the column has a null
    // lastPlayedAt; SQLite sorts nulls last under DESC, so those fall to the
    // bottom and are then ordered among themselves by creation date.
    final query = _db.select(_db.careers)
      ..orderBy([
        (t) =>
            OrderingTerm(expression: t.lastPlayedAt, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<void> touch(int id, DateTime at) async {
    await (_db.update(_db.careers)..where((t) => t.id.equals(id))).write(
      CareersCompanion(lastPlayedAt: Value(at)),
    );
  }

  @override
  Future<Career?> byId(int id) async {
    final query = _db.select(_db.careers)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<void> updateInGameDate(int id, DateTime date) async {
    await (_db.update(_db.careers)..where((t) => t.id.equals(id))).write(
      CareersCompanion(inGameDate: Value(date)),
    );
  }

  @override
  Future<void> advanceCycle(
    int id,
    int cyclePointer,
    DateTime date, {
    int? closingBoard,
  }) async {
    await (_db.update(_db.careers)..where((t) => t.id.equals(id))).write(
      CareersCompanion(
        cyclePointer: Value(cyclePointer),
        inGameDate: Value(date),
        // Recorded as the cycle closes, because everything it was computed
        // from is about to stop being this cycle.
        lastCycleBoard: closingBoard == null
            ? const Value.absent()
            : Value(closingBoard),
      ),
    );
  }

  @override
  Future<void> switchNation(int id, int nationId) async {
    await (_db.update(_db.careers)..where((t) => t.id.equals(id))).write(
      // The armband does not travel: a captain named at the old nation is
      // not even eligible for the new one, and leaving the id behind would
      // point the captaincy at a player in somebody else's squad.
      CareersCompanion(
        nationId: Value(nationId),
        captainPlayerId: const Value(null),
      ),
    );
  }

  @override
  Future<void> recordStint(int careerId, int cycle, int nationId) async {
    await _db
        .into(_db.careerStints)
        .insertOnConflictUpdate(
          CareerStintRow(
            careerId: careerId,
            cycle: cycle,
            nationId: nationId,
          ),
        );
  }

  @override
  Future<Map<int, int>> stints(int careerId) async {
    final rows = await (_db.select(
      _db.careerStints,
    )..where((t) => t.careerId.equals(careerId))).get();
    return {for (final r in rows) r.cycle: r.nationId};
  }

  @override
  Future<void> setBudget(int id, int budget) async {
    await (_db.update(_db.careers)..where((t) => t.id.equals(id))).write(
      CareersCompanion(budget: Value(budget)),
    );
  }

  @override
  Future<void> setCaptain(int id, int? playerId) async {
    await (_db.update(_db.careers)..where((t) => t.id.equals(id))).write(
      CareersCompanion(captainPlayerId: Value(playerId)),
    );
  }

  @override
  Future<void> raiseSkill(int id, ManagerSkill skill) async {
    // Written as an increment in SQL rather than read-modify-write: two taps
    // in the same frame would otherwise both read the old level and spend two
    // points to buy one.
    final column = switch (skill) {
      ManagerSkill.manManagement => 'skill_man_management',
      ManagerSkill.tactical => 'skill_tactical',
      ManagerSkill.youthDevelopment => 'skill_youth_development',
      ManagerSkill.negotiation => 'skill_negotiation',
    };
    await _db.customStatement(
      'UPDATE careers SET $column = MIN($column + 1, ?) WHERE id = ?',
      [ManagerSkills.ceiling, id],
    );
  }

  @override
  Future<void> setStaff(int id, StaffRole role, int? candidateId) async {
    // The tier is derived from the id rather than passed in, so the person and
    // his ability can never disagree.
    final tier = Value(
      candidateId == null ? StaffTier.none.index : StaffMarket.tierOf(candidateId).index,
    );
    final person = Value(candidateId);
    await (_db.update(_db.careers)..where((t) => t.id.equals(id))).write(
      switch (role) {
        StaffRole.assistant => CareersCompanion(
          staffAssistant: tier,
          staffAssistantId: person,
        ),
        StaffRole.scout => CareersCompanion(
          staffScout: tier,
          staffScoutId: person,
        ),
        StaffRole.fitnessCoach => CareersCompanion(
          staffFitnessCoach: tier,
          staffFitnessCoachId: person,
        ),
      },
    );
  }

  @override
  Future<void> addPlayedSeconds(int id, int seconds) async {
    if (seconds <= 0) return;
    // Incremented in SQL so two ticks landing together cannot lose one.
    await _db.customUpdate(
      'UPDATE careers SET played_seconds = played_seconds + ? WHERE id = ?',
      variables: [Variable.withInt(seconds), Variable.withInt(id)],
      updates: {_db.careers},
    );
  }

  @override
  Future<void> setYReadAt(int id, DateTime date) async {
    await (_db.update(_db.careers)..where((t) => t.id.equals(id))).write(
      CareersCompanion(yReadAt: Value(date)),
    );
  }

  @override
  Future<FederationInvestment> investment(int careerId, int cycle) async {
    final row =
        await (_db.select(_db.federationInvestments)..where(
              (t) => t.careerId.equals(careerId) & t.cycle.equals(cycle),
            ))
            .getSingleOrNull();
    return row == null
        ? (
            youth: 0,
            commercial: 0,
            medical: 0,
            naturalization: 0,
            boardRelations: 0,
          )
        : (
            youth: row.youth,
            commercial: row.commercial,
            medical: row.medical,
            naturalization: row.naturalization,
            boardRelations: row.boardRelations,
          );
  }

  @override
  Future<Map<int, FederationInvestment>> investments(int careerId) async {
    final rows = await (_db.select(
      _db.federationInvestments,
    )..where((t) => t.careerId.equals(careerId))).get();
    return {
      for (final r in rows)
        r.cycle: (
          youth: r.youth,
          commercial: r.commercial,
          medical: r.medical,
          naturalization: r.naturalization,
          boardRelations: r.boardRelations,
        ),
    };
  }

  @override
  Future<void> setInvestment(
    int careerId,
    int cycle,
    FederationInvestment i,
  ) async {
    await _db
        .into(_db.federationInvestments)
        .insertOnConflictUpdate(
          FederationInvestmentRow(
            careerId: careerId,
            cycle: cycle,
            youth: i.youth,
            commercial: i.commercial,
            medical: i.medical,
            naturalization: i.naturalization,
            boardRelations: i.boardRelations,
          ),
        );
  }

  @override
  Future<void> addNaturalizationOffer({
    required int careerId,
    required int playerId,
    required int sourceNationId,
    required int cycle,
  }) async {
    await _db
        .into(_db.naturalizedPlayers)
        .insertOnConflictUpdate(
          NaturalizedPlayerRow(
            careerId: careerId,
            playerId: playerId,
            sourceNationId: sourceNationId,
            cycle: cycle,
            status: 'pending',
          ),
        );
  }

  @override
  Future<NaturalizationLink?> pendingNaturalization(int careerId) async {
    final row =
        await (_db.select(_db.naturalizedPlayers)
              ..where(
                (t) => t.careerId.equals(careerId) & t.status.equals('pending'),
              )
              ..limit(1))
            .getSingleOrNull();
    return row == null
        ? null
        : (
            playerId: row.playerId,
            sourceNationId: row.sourceNationId,
            cycle: row.cycle,
          );
  }

  @override
  Future<void> setNaturalizationStatus(
    int careerId,
    int playerId,
    String status,
  ) async {
    await (_db.update(_db.naturalizedPlayers)..where(
          (t) => t.careerId.equals(careerId) & t.playerId.equals(playerId),
        ))
        .write(NaturalizedPlayersCompanion(status: Value(status)));
  }

  @override
  Future<List<NaturalizationLink>> acceptedNaturalizations(
    int careerId,
  ) async {
    final rows =
        await (_db.select(_db.naturalizedPlayers)..where(
              (t) => t.careerId.equals(careerId) & t.status.equals('accepted'),
            ))
            .get();
    return [
      for (final r in rows)
        (
          playerId: r.playerId,
          sourceNationId: r.sourceNationId,
          cycle: r.cycle,
        ),
    ];
  }

  @override
  Future<Map<int, int>> nationsCupTiers(int careerId) async {
    final rows = await (_db.select(
      _db.nationsCupTiers,
    )..where((t) => t.careerId.equals(careerId))).get();
    return {for (final r in rows) r.nationId: r.tier};
  }

  @override
  Future<void> setNationsCupTiers(int careerId, Map<int, int> tiers) async {
    if (tiers.isEmpty) return;
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(_db.nationsCupTiers, [
        for (final e in tiers.entries)
          NationsCupTierRow(
            careerId: careerId,
            nationId: e.key,
            tier: e.value,
          ),
      ]);
    });
  }

  @override
  Future<void> recordPressAnswer({
    required int careerId,
    required int cycle,
    required String questionKey,
    required String tone,
    required int moraleDelta,
    required int boardDelta,
    required DateTime answeredAt,
  }) async {
    await _db
        .into(_db.pressAnswers)
        .insert(
          PressAnswersCompanion.insert(
            careerId: careerId,
            cycle: cycle,
            questionKey: questionKey,
            tone: tone,
            moraleDelta: moraleDelta,
            boardDelta: boardDelta,
            answeredAt: answeredAt,
          ),
        );
  }

  @override
  Future<List<PressAnswerRow>> pressAnswers(int careerId, {int? cycle}) async {
    final rows =
        await (_db.select(_db.pressAnswers)
              ..where(
                (t) => cycle == null
                    ? t.careerId.equals(careerId)
                    : t.careerId.equals(careerId) & t.cycle.equals(cycle),
              )
              ..orderBy([
                (t) => OrderingTerm.desc(t.answeredAt),
              ]))
            .get();
    return [
      for (final r in rows)
        (
          questionKey: r.questionKey,
          tone: r.tone,
          moraleDelta: r.moraleDelta,
          boardDelta: r.boardDelta,
          cycle: r.cycle,
          answeredAt: r.answeredAt,
        ),
    ];
  }

  @override
  Future<({int hostId, int campIndex})?> trainingCamp(
    int careerId,
    int cycle,
    String tournament,
  ) async {
    final row =
        await (_db.select(_db.trainingCampChoices)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) &
                    t.cycle.equals(cycle) &
                    t.tournament.equals(tournament),
              )
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : (hostId: row.hostId, campIndex: row.campIndex);
  }

  @override
  Future<void> setTrainingCamp({
    required int careerId,
    required int cycle,
    required String tournament,
    required int hostId,
    required int campIndex,
  }) async {
    await _db
        .into(_db.trainingCampChoices)
        .insertOnConflictUpdate(
          TrainingCampChoicesCompanion.insert(
            careerId: careerId,
            cycle: cycle,
            tournament: tournament,
            hostId: hostId,
            campIndex: campIndex,
          ),
        );
  }

  @override
  Future<void> delete(int id) async {
    await (_db.delete(_db.careers)..where((t) => t.id.equals(id))).go();
  }
}
