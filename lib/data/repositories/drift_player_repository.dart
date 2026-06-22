import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/player_repository.dart';

/// Drift-backed [PlayerRepository].
class DriftPlayerRepository implements PlayerRepository {
  DriftPlayerRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Player>> byNation(int nationId) async {
    final query = _db.select(_db.players)
      ..where((t) => t.nationId.equals(nationId));
    // `overall` is position-weighted and derived (not a column), so order in
    // Dart after mapping.
    final players = (await query.get()).map((r) => r.toDomain()).toList()
      ..sort((a, b) => b.overall.compareTo(a.overall));
    return players;
  }

  @override
  Future<Player?> byId(int id) async {
    final query = _db.select(_db.players)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row?.toDomain();
  }
}
