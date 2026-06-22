import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';

/// Populates the reference tables (nations, players) from a [SeedSource] on
/// first run.
///
/// [ensureSeeded] is idempotent: if any nations already exist it returns
/// immediately, so it is safe to call on every launch.
class SeedLoader {
  SeedLoader(this._db, this._source);

  final AppDatabase _db;
  final SeedSource _source;

  /// Seeds the database if it has not been seeded yet. Returns `true` if
  /// seeding was performed, `false` if it was already populated.
  Future<bool> ensureSeeded() async {
    final existing =
        await (_db.select(_db.nations)..limit(1)).getSingleOrNull();
    if (existing != null) return false;

    final nations = await _source.nations();
    final players = await _source.players();

    await _db.batch((batch) {
      batch
        ..insertAll(_db.nations, nations.map(_nationCompanion))
        ..insertAll(_db.players, players.map(_playerCompanion));
    });
    return true;
  }

  NationsCompanion _nationCompanion(Nation n) => NationsCompanion.insert(
        id: Value(n.id),
        name: n.name,
        code: n.code,
        confederation: n.confederation,
        ranking: Value(n.ranking),
        isFreeDemo: Value(n.isFreeDemo),
      );

  PlayersCompanion _playerCompanion(Player p) => PlayersCompanion.insert(
        id: Value(p.id),
        nationId: p.nationId,
        name: p.name,
        age: p.age,
        position: p.position,
        passing: p.attributes.passing,
        shooting: p.attributes.shooting,
        dribbling: p.attributes.dribbling,
        tackling: p.attributes.tackling,
        positioning: p.attributes.positioning,
        composure: p.attributes.composure,
        decisions: p.attributes.decisions,
        pace: p.attributes.pace,
        stamina: p.attributes.stamina,
        strength: p.attributes.strength,
      );
}
