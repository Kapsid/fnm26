import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/legacy_seed_ranking.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';

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
    final existing = await (_db.select(
      _db.nations,
    )..limit(1)).getSingleOrNull();
    if (existing != null) {
      // Already seeded: prune any nations dropped from the source data, bring
      // the starting ranking up to date (every career already begun keeps
      // its own), then top up the deeper pool + clubs for pre-v10 saves.
      await _reconcileNations();
      await _reconcileRanking();
      await _ensureDeepPool();
      // Last: the deep-pool rebuild deletes every player, the dormant ones
      // with them.
      await _ensureDormant();
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
    await _ensureDormant();
    return true;
  }

  /// The source whose dormant data a database was last found to match, per
  /// database: the check runs once per launch (and source), not on each of
  /// the many [ensureSeeded] calls.
  static final Expando<SeedSource> _dormantVerified = Expando();

  /// Makes each dormant nation (see [DormantNations]) and its players exactly
  /// the source's: inserted when missing, rewritten by id when they differ
  /// (an earlier build's squad, say, after a retune). This is how a dormant
  /// nation reaches an existing database, and how a change to it reaches one
  /// that already has it: no schema change, no migration. Idempotent, and
  /// safe under the concurrent seeder race (one transaction of upserts).
  Future<void> _ensureDormant() async {
    if (identical(_dormantVerified[_db], _source)) return;
    final dormant = await _source.dormant();
    if (dormant.nations.isEmpty) return;
    final ids = [for (final n in dormant.nations) n.id];
    final players = [
      for (final p in dormant.players)
        if (ids.contains(p.nationId)) p,
    ];
    if (!await _dormantMatches(dormant.nations, players, ids)) {
      // Upserts by id, never a REPLACE (a delete and an insert): a career
      // references its nation, and nothing may see the row go missing.
      final keep = {for (final p in players) p.id};
      await _db.transaction(() async {
        await _db.batch((batch) {
          batch
            ..insertAllOnConflictUpdate(
              _db.nations,
              dormant.nations.map(_nationCompanion),
            )
            ..insertAllOnConflictUpdate(
              _db.players,
              players.map(_playerCompanion),
            );
        });
        await (_db.delete(_db.players)..where(
              (p) => p.nationId.isIn(ids) & p.id.isNotIn(keep),
            ))
            .go();
      });
    }
    _dormantVerified[_db] = _source;
  }

  /// Whether the stored rows of the dormant nations [ids] are exactly
  /// [nations] and [players].
  Future<bool> _dormantMatches(
    List<Nation> nations,
    List<Player> players,
    List<int> ids,
  ) async {
    String nationKey(NationsCompanion c) => c.toString();
    String playerKey(PlayersCompanion c) => c.toString();
    final storedNations = {
      for (final r in await (_db.select(
        _db.nations,
      )..where((n) => n.id.isIn(ids))).get())
        nationKey(r.toCompanion(false)),
    };
    final wantNations = {
      for (final n in nations) nationKey(_nationCompanion(n)),
    };
    if (storedNations.length != wantNations.length ||
        !storedNations.containsAll(wantNations)) {
      return false;
    }
    final storedPlayers = {
      for (final r in await (_db.select(
        _db.players,
      )..where((p) => p.nationId.isIn(ids))).get())
        playerKey(r.toCompanion(false)),
    };
    final wantPlayers = {
      for (final p in players) playerKey(_playerCompanion(p)),
    };
    return storedPlayers.length == wantPlayers.length &&
        storedPlayers.containsAll(wantPlayers);
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
    // A dormant nation is never pruned, even when a source fails to supply
    // it: a career whose world includes it would lose its own nation.
    final keep = {
      ...source.map((n) => n.id),
      ...DormantNations.ids,
      ...(await _source.dormant()).nations.map((n) => n.id),
    };
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

  /// The source whose starting ranking a database was last found to match,
  /// per database: like [_dormantVerified], once per launch.
  static final Expando<SeedSource> _rankingVerified = Expando();

  /// Whether [db]'s starting ranking has been reconciled this launch: from
  /// here [_reconcileRanking] gives no career a new cycle-0 seed ranking, so
  /// `DriftNationRepository` may keep a career's "none".
  static bool rankingReconciled(AppDatabase db) => _rankingVerified[db] != null;

  /// Brings the stored starting ranking (`nations.ranking`) up to the
  /// source's, without changing any career already begun.
  ///
  /// A career reads its starting positions from the nations' ranking unless
  /// it has a cycle-0 seed ranking of its own, which its world then reads
  /// instead (see `NationRepository.forCareer`). Nothing else writes cycle 0,
  /// so before the stored ranking moves, every career without one is given
  /// the stored ranking as it stands, the ranking it started on. New careers
  /// start on the source's. This is how 1.0.7's move to FIFA's ranking of 1
  /// October 2026 reaches an existing database (see `legacySeedRanking`).
  ///
  /// One transaction: a concurrent seeder finds nothing left to do. A no-op
  /// once the database matches the source, and never against an empty
  /// source. Dormant nations are left alone: they are not in the source.
  Future<void> _reconcileRanking() async {
    if (identical(_rankingVerified[_db], _source)) return;
    final source = await _source.nations();
    if (source.isEmpty) return;
    final want = {for (final n in source) n.id: n.ranking};
    await _db.transaction(() async {
      final stored = await _db.select(_db.nations).get();
      final stale = <int, int>{
        for (final r in stored)
          if (!DormantNations.ids.contains(r.id))
            if (want[r.id] case final w? when w != r.ranking) r.id: w,
      };
      if (stale.isEmpty) return;
      final rankOf = {for (final r in stored) r.id: r.ranking};
      final base = {
        for (final r in stored)
          if (!DormantNations.ids.contains(r.id)) r.id: r.ranking,
      };
      for (final career in await _db.select(_db.careers).get()) {
        final frozen =
            await (_db.select(_db.seedRankings)
                  ..where(
                    (t) => t.careerId.equals(career.id) & t.cycle.equals(0),
                  )
                  ..limit(1))
                .getSingleOrNull();
        if (frozen != null) continue;
        // The career's own world: a dormant nation stands in for the one
        // it replaces.
        final world = careerWorldRanks(base, [
          for (final marker
              in await (_db.select(_db.drawsWatched)..where(
                    (t) =>
                        t.careerId.equals(career.id) &
                        t.cycle.equals(0) &
                        t.kind.like('${DormantNations.markerPrefix}%'),
                  ))
                  .get())
            marker.kind,
        ], dormantRank: (d) => rankOf[d]);
        await _db.batch((batch) {
          batch.insertAll(_db.seedRankings, [
            for (final e in world.entries)
              SeedRankingsCompanion.insert(
                careerId: career.id,
                cycle: 0,
                nationId: e.key,
                rank: e.value,
              ),
          ], mode: InsertMode.insertOrIgnore);
        });
      }
      for (final e in stale.entries) {
        await (_db.update(_db.nations)..where((t) => t.id.equals(e.key))).write(
          NationsCompanion(ranking: Value(e.value)),
        );
      }
    });
    _rankingVerified[_db] = _source;
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

    // Every player goes, the dormant ones too: check them again after.
    _dormantVerified[_db] = null;
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
