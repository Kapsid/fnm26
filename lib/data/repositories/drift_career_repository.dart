import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/domain/entities/career.dart';
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
  Future<void> delete(int id) async {
    await (_db.delete(_db.careers)..where((t) => t.id.equals(id))).go();
  }
}
