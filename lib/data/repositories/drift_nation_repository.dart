import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/nation_repository.dart';

/// Drift-backed [NationRepository].
class DriftNationRepository implements NationRepository {
  DriftNationRepository(this._db, {this.languageCode = 'en'});

  final AppDatabase _db;

  /// The UI language nation names are written for. Resolving it here rather
  /// than at each of the hundred-odd places a country is printed is what makes
  /// a Czech save Czech everywhere — including the news and the social feed,
  /// which build their text in providers with no BuildContext.
  final String languageCode;

  @override
  Future<List<Nation>> all() async {
    final query = _db.select(_db.nations)
      ..orderBy([(t) => OrderingTerm(expression: t.ranking)]);
    final rows = await query.get();
    return rows.map((r) => r.toDomain(languageCode: languageCode)).toList();
  }

  @override
  Future<List<Nation>> freeDemo() async {
    final query = _db.select(_db.nations)
      ..where((t) => t.isFreeDemo.equals(true))
      ..orderBy([(t) => OrderingTerm(expression: t.ranking)]);
    final rows = await query.get();
    return rows.map((r) => r.toDomain(languageCode: languageCode)).toList();
  }

  @override
  Future<Nation?> byId(int id) async {
    final query = _db.select(_db.nations)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row?.toDomain(languageCode: languageCode);
  }
}
