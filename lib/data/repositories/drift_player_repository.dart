import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/player/player_aging.dart';

/// Drift-backed [PlayerRepository].
class DriftPlayerRepository implements PlayerRepository {
  DriftPlayerRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Player>> byNation(int nationId, {int agingCycles = 0}) async {
    final query = _db.select(_db.players)
      ..where((t) => t.nationId.equals(nationId));
    // `overall` is position-weighted and derived (not a column), so age and
    // order in Dart after mapping.
    final players = (await query.get())
        .map((r) => PlayerAging.aged(r.toDomain(), agingCycles))
        .toList()
      ..sort((a, b) => b.overall.compareTo(a.overall));
    return players;
  }

  @override
  Future<List<Player>> all() async {
    final rows = await _db.select(_db.players).get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Player?> byId(int id, {int agingCycles = 0}) async {
    final query = _db.select(_db.players)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    final p = row?.toDomain();
    return p == null ? null : PlayerAging.aged(p, agingCycles);
  }
}
