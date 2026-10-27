import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/intl_retirement_cache.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/repositories/international_retirement_repository.dart';
import 'package:fnm/domain/services/player/international_retirement.dart';

/// Drift-backed [InternationalRetirementRepository].
class DriftInternationalRetirementRepository
    implements InternationalRetirementRepository {
  DriftInternationalRetirementRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<FinishedFinals>> finishedFinals(
    int careerId, {
    Set<int> skip = const {},
  }) async {
    final all =
        await (_db.select(_db.competitions)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  t.kind.isIn([
                    CompetitionKind.worldCupFinals.name,
                    CompetitionKind.continentalFinals.name,
                  ]),
            ))
            .get();
    final comps = [
      for (final c in all)
        if (!skip.contains(c.id)) c,
    ];
    if (comps.isEmpty) return const [];
    final fixtures =
        await (_db.select(_db.fixtures)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  t.competitionId.isIn([for (final c in comps) c.id]),
            ))
            .get();
    final byComp = <int, List<FixtureRow>>{};
    for (final f in fixtures) {
      (byComp[f.competitionId] ??= []).add(f);
    }
    final out = <FinishedFinals>[];
    for (final c in comps) {
      final fs = byComp[c.id];
      if (fs == null || fs.isEmpty) continue;
      final finished = fs.every(
        (f) => f.played && f.homeScore != null && f.awayScore != null,
      );
      if (!finished) continue;
      // The final is the last fixture of a finals tournament (the World
      // Championship's third-place play-off comes two days before it).
      final last = fs.reduce((a, b) {
        final byDate = a.date.compareTo(b.date);
        if (byDate != 0) return byDate > 0 ? a : b;
        return a.id > b.id ? a : b;
      });
      out.add((
        competitionId: c.id,
        kind: c.kind,
        confederation: c.confederation,
        cycle: c.cycle,
        participants: {
          for (final f in fs) ...[f.homeNationId, f.awayNationId],
        },
        championId: _winner(last),
        endedOn: last.date,
      ));
    }
    out.sort((a, b) => a.endedOn.compareTo(b.endedOn));
    return out;
  }

  static int? _winner(FixtureRow f) {
    final h = f.homeScore!;
    final a = f.awayScore!;
    if (h != a) return h > a ? f.homeNationId : f.awayNationId;
    final hp = f.homePenalties;
    final ap = f.awayPenalties;
    if (hp == null || ap == null || hp == ap) return null;
    return hp > ap ? f.homeNationId : f.awayNationId;
  }

  @override
  Future<bool> hasMarker(int careerId, String kind) async {
    final row =
        await (_db.select(_db.drawsWatched)
              ..where((t) => t.careerId.equals(careerId) & t.kind.equals(kind))
              ..limit(1))
            .getSingleOrNull();
    return row != null;
  }

  @override
  Future<Set<String>> markersWithPrefix(int careerId, String prefix) async {
    final rows =
        await (_db.select(_db.drawsWatched)..where(
              (t) => t.careerId.equals(careerId) & t.kind.like('$prefix%'),
            ))
            .get();
    return {for (final r in rows) r.kind};
  }

  @override
  Future<void> addMarkers(
    int careerId,
    int cycle,
    Iterable<String> kinds,
  ) async {
    final rows = [
      for (final k in kinds)
        DrawWatchedRow(careerId: careerId, cycle: cycle, kind: k),
    ];
    if (rows.isEmpty) return;
    try {
      await _db.batch(
        (b) => b.insertAll(
          _db.drawsWatched,
          rows,
          mode: InsertMode.insertOrIgnore,
        ),
      );
    } finally {
      // The decoded retirements every pool read filters by are stale now.
      if (kinds.any(_isRetirementMarker)) {
        IntlRetirementCache.of(_db).forget(careerId);
      }
    }
  }

  static bool _isRetirementMarker(String k) =>
      k.startsWith(InternationalRetirement.retiredPrefix) ||
      k.startsWith(InternationalRetirement.comebackPrefix);
}
