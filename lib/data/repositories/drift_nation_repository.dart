import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/nation_repository.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';

/// Drift-backed [NationRepository].
class DriftNationRepository implements NationRepository {
  DriftNationRepository(this._db, {this.languageCode = 'en'});

  final AppDatabase _db;

  /// The UI language nation names are written for. Resolving it here rather
  /// than at each of the hundred-odd places a country is printed is what makes
  /// a Czech save Czech everywhere — including the news and the social feed,
  /// which build their text in providers with no BuildContext.
  final String languageCode;

  /// Careers known to carry a dormant nation's marker, with the dormant ids.
  /// Only a yes is kept: a career id is never reused and the marker is never
  /// removed, so a yes cannot go stale, while a no could if anything read the
  /// career's world before its marker landed. A no is asked again (one small
  /// indexed query).
  final Map<int, Set<int>> _dormantByCareer = {};

  @override
  Future<List<Nation>> all() async {
    final query = _db.select(_db.nations)
      ..where((t) => t.id.isNotIn(DormantNations.ids))
      ..orderBy([(t) => OrderingTerm(expression: t.ranking)]);
    final rows = await query.get();
    return rows.map((r) => r.toDomain(languageCode: languageCode)).toList();
  }

  @override
  Future<List<Nation>> freeDemo() async {
    final query = _db.select(_db.nations)
      ..where(
        (t) => t.isFreeDemo.equals(true) & t.id.isNotIn(DormantNations.ids),
      )
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

  @override
  Future<List<Nation>> everyKnown() async {
    final query = _db.select(_db.nations)
      ..orderBy([(t) => OrderingTerm(expression: t.ranking)]);
    final rows = await query.get();
    return rows.map((r) => r.toDomain(languageCode: languageCode)).toList();
  }

  @override
  Future<List<Nation>> forCareer(int careerId) async =>
      _withHostBids(careerId, await _worldOf(careerId));

  /// [world] with the career's host bids attached to the nations that lodged
  /// them (see `Nation.hostBids`). Not cached: a bid is placed mid-career and
  /// must be seen by the very next read. A career that never bid has no
  /// marker, and its world comes back untouched.
  Future<List<Nation>> _withHostBids(int careerId, List<Nation> world) async {
    final rows =
        await (_db.select(_db.drawsWatched)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  t.kind.like('${HostBidMarker.prefix}%'),
            ))
            .get();
    if (rows.isEmpty) return world;
    final byNation = <int, Map<String, int>>{};
    for (final r in rows) {
      final m = HostBidMarker.decode(r.kind);
      if (m == null) continue;
      (byNation[m.nationId] ??= {})[m.nationKey] = m.permille;
    }
    if (byNation.isEmpty) return world;
    return [
      for (final n in world)
        if (byNation[n.id] case final bids?)
          n.copyWith(hostBids: {...n.hostBids, ...bids})
        else
          n,
    ];
  }

  /// Careers whose starting positions are known: their cycle-0 seed
  /// ranking, or an empty map for a career on the nations' own ranking (as
  /// every career this build creates without starting ranks is). The rows
  /// are written once and never removed, so a yes cannot go stale. A no is
  /// kept too, because it is asked on every [forCareer], but only once the
  /// launch reconcile has run (see `SeedLoader.rankingReconciled`), the one
  /// writer that adds rows to careers already being read; the only other
  /// writer, `CareerService.create`, calls [forgetStartingRanks] after its
  /// snapshot.
  final Map<int, Map<int, int>> _startingRanksByCareer = {};

  /// Drops what is known of [careerId]'s starting positions, after a writer
  /// gave it a cycle-0 seed ranking: the next read asks the table again.
  void forgetStartingRanks(int careerId) =>
      _startingRanksByCareer.remove(careerId);

  /// The career's own starting positions, empty for a career that starts on
  /// the nations' ranking. Only a career begun before the stored ranking last
  /// moved has them (see `SeedLoader._reconcileRanking`): it keeps the
  /// ranking it started on.
  Future<Map<int, int>> _startingRanksFor(int careerId) async {
    final cached = _startingRanksByCareer[careerId];
    if (cached != null) return cached;
    final rows = await (_db.select(
      _db.seedRankings,
    )..where((t) => t.careerId.equals(careerId) & t.cycle.equals(0))).get();
    final ranks = {for (final r in rows) r.nationId: r.rank};
    if (ranks.isNotEmpty || SeedLoader.rankingReconciled(_db)) {
      _startingRanksByCareer[careerId] = ranks;
    }
    return ranks;
  }

  /// [base] with each nation on its position in [ranks], re-sorted by it.
  /// [base] itself when [ranks] is empty.
  static List<Nation> _onRanks(List<Nation> base, Map<int, int> ranks) {
    if (ranks.isEmpty) return base;
    final indexed =
        [
          for (var i = 0; i < base.length; i++)
            (
              i,
              switch (ranks[base[i].id]) {
                final r? when r != base[i].ranking => base[i].copyWith(
                  ranking: r,
                ),
                _ => base[i],
              },
            ),
        ]..sort((a, b) {
          final c = a.$2.ranking.compareTo(b.$2.ranking);
          return c != 0 ? c : a.$1.compareTo(b.$1);
        });
    return [for (final e in indexed) e.$2];
  }

  Future<List<Nation>> _worldOf(int careerId) async {
    final starting = await _startingRanksFor(careerId);
    final base = _onRanks(await all(), starting);
    final active = await _dormantFor(careerId);
    if (active.isEmpty) return base;
    final rows = await (_db.select(
      _db.nations,
    )..where((t) => t.id.isIn(active))).get();
    // A dormant nation starts where the career froze it too: a Greenland run
    // begun on the old ranking keeps its 210, a new one starts on 209.
    final dormant = {
      for (final r in rows)
        r.id: switch ((
          r.toDomain(languageCode: languageCode),
          starting[r.id],
        )) {
          (final n, final rank?) => n.copyWith(ranking: rank),
          (final n, _) => n,
        },
    };
    // A marker whose row is missing (it cannot be, the seed loader inserts
    // it on every launch) would leave the replaced nation in place rather
    // than drop a nation from the world.
    final present = {
      for (final d in active)
        if (dormant.containsKey(d)) d,
    };
    return DormantNations.worldFrom(
      base,
      present,
      dormant: (id) => dormant[id]!,
    );
  }

  Future<Set<int>> _dormantFor(int careerId) async {
    final cached = _dormantByCareer[careerId];
    if (cached != null) return cached;
    final rows =
        await (_db.select(_db.drawsWatched)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  t.cycle.equals(0) &
                  t.kind.like('${DormantNations.markerPrefix}%'),
            ))
            .get();
    final ids = {
      for (final r in rows) ?DormantNations.fromMarker(r.kind),
    };
    if (ids.isNotEmpty) _dormantByCareer[careerId] = ids;
    return ids;
  }
}
