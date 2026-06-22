import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/nation_repository.dart';

/// Drift-backed [NationRepository].
class DriftNationRepository implements NationRepository {
  DriftNationRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Nation>> all() async {
    final query = _db.select(_db.nations)
      ..orderBy([(t) => OrderingTerm(expression: t.ranking)]);
    final rows = await query.get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<List<Nation>> freeDemo() async {
    final query = _db.select(_db.nations)
      ..where((t) => t.isFreeDemo.equals(true))
      ..orderBy([(t) => OrderingTerm(expression: t.ranking)]);
    final rows = await query.get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Nation?> byId(int id) async {
    final query = _db.select(_db.nations)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row?.toDomain();
  }
}
