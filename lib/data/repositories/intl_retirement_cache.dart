import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/services/player/international_retirement.dart';

/// The decoded international retirements of each career, held per database.
///
/// Every save-bound `byNation` filters its pool through them, and a long save
/// carries thousands of retirement markers: decoding them all on every pool
/// read stalled the world simulation (210 pools per wave, each re-decoding
/// the lot). They change only when a wave or a comeback roll writes markers,
/// and that write path ([forget]) drops the career's entry, so a read after
/// it sees the new markers.
///
/// Held on the database instance (an [Expando]), so the player repository
/// that reads and the retirement repository that writes share one cache, and
/// a restored or reopened database starts empty.
class IntlRetirementCache {
  IntlRetirementCache._();

  static final Expando<IntlRetirementCache> _byDb = Expando();

  /// The cache of [db].
  static IntlRetirementCache of(AppDatabase db) =>
      _byDb[db] ??= IntlRetirementCache._();

  final Map<int, _Entry> _entries = {};

  /// Bumped on every [forget], so a read that started before a write never
  /// stores what it decoded from the older markers.
  final Map<int, int> _generation = {};

  /// [careerId]'s retirements by player id, decoding them with [load] on a
  /// miss. The map is read-only.
  Future<Map<int, IntlRetirement>> all(
    int careerId,
    Future<Map<int, IntlRetirement>> Function() load,
  ) async => (await _entry(careerId, load)).all;

  /// [careerId]'s retirements by the nation each retired from (0 for a
  /// marker that names none), then by player id.
  Future<Map<int, Map<int, IntlRetirement>>> byNation(
    int careerId,
    Future<Map<int, IntlRetirement>> Function() load,
  ) async => (await _entry(careerId, load)).byNation;

  Future<_Entry> _entry(
    int careerId,
    Future<Map<int, IntlRetirement>> Function() load,
  ) async {
    final hit = _entries[careerId];
    if (hit != null) return hit;
    final gen = _generation[careerId] ?? 0;
    final entry = _Entry(Map.unmodifiable(await load()));
    // A marker written while this read was decoding: keep it uncached.
    if ((_generation[careerId] ?? 0) == gen) _entries[careerId] = entry;
    return entry;
  }

  /// Drops [careerId]'s entry: its retirement markers have changed.
  void forget(int careerId) {
    _entries.remove(careerId);
    _generation[careerId] = (_generation[careerId] ?? 0) + 1;
  }
}

class _Entry {
  _Entry(this.all);

  final Map<int, IntlRetirement> all;

  late final Map<int, Map<int, IntlRetirement>> byNation = () {
    final out = <int, Map<int, IntlRetirement>>{};
    for (final r in all.values) {
      (out[r.nationId ?? 0] ??= {})[r.playerId] = r;
    }
    return Map<int, Map<int, IntlRetirement>>.unmodifiable({
      for (final e in out.entries)
        e.key: Map<int, IntlRetirement>.unmodifiable(e.value),
    });
  }();
}
