import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/pool_generator.dart';
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
  ///
  /// Nearly every provider awaits this, so on a fresh database several callers
  /// race: each sees an empty nations table and each inserts the seed. The
  /// slower one used to die on `UNIQUE constraint failed: nations.id` — the
  /// "nations error" the new-game screen showed on first launch (a relaunch
  /// found the table populated and looked fine). The seed batch now uses
  /// `insertOrIgnore`, so a duplicate row from a concurrent seeder is skipped
  /// rather than throwing the whole insert away — the race resolves silently.
  Future<bool> ensureSeeded() async {
    final existing =
        await (_db.select(_db.nations)..limit(1)).getSingleOrNull();
    if (existing != null) {
      // Already seeded: prune any nations dropped from the source data, then
      // top up the deeper pool + clubs for pre-v10 saves.
      await _reconcileNations();
      await _ensureDeepPool();
      return false;
    }

    final nations = await _source.nations();
    final players = await _source.players();

    await _db.batch((batch) {
      batch
        // insertOrIgnore: if a concurrent seeder landed the row first, skip it
        // rather than throwing the whole batch away (see the doc comment).
        ..insertAll(
          _db.nations,
          nations.map(_nationCompanion),
          mode: InsertMode.insertOrIgnore,
        )
        ..insertAll(
          _db.players,
          players.map(_playerCompanion),
          mode: InsertMode.insertOrIgnore,
        );
    });
    return true;
  }

  /// Removes nations (and their players) that are no longer in the source data
  /// — e.g. teams dropped for eligibility reasons — so an existing save's
  /// reference data self-heals on launch without a full re-seed. A no-op when
  /// the DB already matches the source. In-progress careers keep any fixtures
  /// already drawn against a removed nation, but it disappears from every new
  /// draw and from selection.
  Future<void> _reconcileNations() async {
    final source = await _source.nations();
    if (source.isEmpty) return; // never prune against an empty/failed source
    final keep = source.map((n) => n.id).toSet();
    final present = await _db.select(_db.nations).get();
    final drop = [
      for (final n in present)
        if (!keep.contains(n.id)) n.id,
    ];
    if (drop.isEmpty) return;
    await _db.transaction(() async {
      await (_db.delete(_db.players)..where((p) => p.nationId.isIn(drop))).go();
      await (_db.delete(_db.nations)..where((n) => n.id.isIn(drop))).go();
    });
  }

  /// Rebuilds the player pool on databases seeded with a shallower one (the
  /// base 23-per-nation squads, or an earlier, smaller expansion). A cheap
  /// count gate skips it once the pool is at target; the rebuild is atomic so a
  /// mid-flight kill can't lose the squads.
  Future<void> _ensureDeepPool() async {
    final have = await _count(_db.players, _db.players.id);
    final nationCount = await _count(_db.nations, _db.nations.id);
    final target = nationCount * (23 + PoolGenerator.extraPerNation);
    if (have >= target - nationCount) return; // within a squad of target → done

    final players = await _source.players();
    if (have >= players.length) return; // in-memory/test source: nothing to add

    await _db.transaction(() async {
      await _db.delete(_db.players).go();
      await _db.batch(
        (batch) => batch.insertAll(_db.players, players.map(_playerCompanion)),
      );
    });
  }

  Future<int> _count(
    TableInfo<Table, dynamic> table,
    GeneratedColumn id,
  ) async {
    final c = id.count();
    final row = await (_db.selectOnly(table)..addColumns([c])).getSingle();
    return row.read(c) ?? 0;
  }

  NationsCompanion _nationCompanion(Nation n) => NationsCompanion.insert(
        id: Value(n.id),
        name: n.name,
        code: n.code,
        confederation: n.confederation,
        ranking: Value(n.ranking),
        isFreeDemo: Value(n.isFreeDemo),
        primaryColor: Value(n.primaryColor),
        secondaryColor: Value(n.secondaryColor),
      );

  PlayersCompanion _playerCompanion(Player p) => PlayersCompanion.insert(
        id: Value(p.id),
        nationId: p.nationId,
        name: p.name,
        age: p.age,
        position: p.position,
        physical: p.attributes.physical,
        technical: p.attributes.technical,
        stamina: p.attributes.stamina,
        club: Value(p.club),
      );
}
