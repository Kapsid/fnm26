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
    final id = await _db.into(_db.careers).insert(
          CareersCompanion.insert(
            managerName: managerName,
            nationId: nationId,
            rngSeed: rngSeed,
            createdAt: startDate,
            inGameDate: startDate,
          ),
        );
    final row = await (_db.select(_db.careers)..where((t) => t.id.equals(id)))
        .getSingle();
    return row.toDomain();
  }

  @override
  Future<List<Career>> all() async {
    final query = _db.select(_db.careers)
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Career?> byId(int id) async {
    final query = _db.select(_db.careers)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<void> updateInGameDate(int id, DateTime date) async {
    await (_db.update(_db.careers)..where((t) => t.id.equals(id)))
        .write(CareersCompanion(inGameDate: Value(date)));
  }

  @override
  Future<void> advanceCycle(int id, int cyclePointer, DateTime date) async {
    await (_db.update(_db.careers)..where((t) => t.id.equals(id))).write(
      CareersCompanion(
        cyclePointer: Value(cyclePointer),
        inGameDate: Value(date),
      ),
    );
  }

  @override
  Future<void> switchNation(int id, int nationId) async {
    await (_db.update(_db.careers)..where((t) => t.id.equals(id)))
        .write(CareersCompanion(nationId: Value(nationId)));
  }

  @override
  Future<void> recordStint(int careerId, int cycle, int nationId) async {
    await _db.into(_db.careerStints).insertOnConflictUpdate(
          CareerStintRow(
            careerId: careerId,
            cycle: cycle,
            nationId: nationId,
          ),
        );
  }

  @override
  Future<Map<int, int>> stints(int careerId) async {
    final rows = await (_db.select(_db.careerStints)
          ..where((t) => t.careerId.equals(careerId)))
        .get();
    return {for (final r in rows) r.cycle: r.nationId};
  }

  @override
  Future<void> setBudget(int id, int budget) async {
    await (_db.update(_db.careers)..where((t) => t.id.equals(id)))
        .write(CareersCompanion(budget: Value(budget)));
  }

  @override
  Future<FederationInvestment> investment(int careerId, int cycle) async {
    final row = await (_db.select(_db.federationInvestments)
          ..where((t) => t.careerId.equals(careerId) & t.cycle.equals(cycle)))
        .getSingleOrNull();
    return row == null
        ? (youth: 0, commercial: 0, medical: 0, naturalization: 0)
        : (
            youth: row.youth,
            commercial: row.commercial,
            medical: row.medical,
            naturalization: row.naturalization,
          );
  }

  @override
  Future<Map<int, FederationInvestment>> investments(int careerId) async {
    final rows = await (_db.select(_db.federationInvestments)
          ..where((t) => t.careerId.equals(careerId)))
        .get();
    return {
      for (final r in rows)
        r.cycle: (
          youth: r.youth,
          commercial: r.commercial,
          medical: r.medical,
          naturalization: r.naturalization,
        ),
    };
  }

  @override
  Future<void> setInvestment(
    int careerId,
    int cycle,
    FederationInvestment i,
  ) async {
    await _db.into(_db.federationInvestments).insertOnConflictUpdate(
          FederationInvestmentRow(
            careerId: careerId,
            cycle: cycle,
            youth: i.youth,
            commercial: i.commercial,
            medical: i.medical,
            naturalization: i.naturalization,
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
    await _db.into(_db.naturalizedPlayers).insertOnConflictUpdate(
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
    final row = await (_db.select(_db.naturalizedPlayers)
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
    await (_db.update(_db.naturalizedPlayers)
          ..where(
            (t) => t.careerId.equals(careerId) & t.playerId.equals(playerId),
          ))
        .write(NaturalizedPlayersCompanion(status: Value(status)));
  }

  @override
  Future<List<NaturalizationLink>> acceptedNaturalizations(
    int careerId,
  ) async {
    final rows = await (_db.select(_db.naturalizedPlayers)
          ..where(
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
    final rows = await (_db.select(_db.nationsCupTiers)
          ..where((t) => t.careerId.equals(careerId)))
        .get();
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
  Future<void> delete(int id) async {
    await (_db.delete(_db.careers)..where((t) => t.id.equals(id))).go();
  }
}
