import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A boy the manager has marked, as he was on the day he was marked.
///
/// The rating, age and save year are stored WITH the mark, and that is the
/// whole point of the feature: a watchlist that only holds an id can show what
/// a boy is, and what a manager wants to know is what he has BECOME since he
/// caught the eye. The name is stored too, so a boy who has since been released
/// can still be named on the list — the youth pool is derived, and a released
/// player is not in it to be looked up.
typedef YouthMark = ({
  int playerId,
  String name,

  /// His overall rating when he was marked.
  int rating,

  /// His age when he was marked.
  int age,

  /// The save's aging year when he was marked, so his age now can be worked
  /// out even when he is no longer anywhere to be found.
  int year,
});

/// Prefs key — outside the save database (no schema bump), scoped per career,
/// exactly as `set_piece_takers_v1:<careerId>` is.
///
/// Preferences rather than a table because there is nothing in the database to
/// hang a flag off: the youth pyramid is DERIVED from the save seed, ages 11 to
/// 20, and none of those boys has a row. A marks table would be a table of
/// foreign keys pointing at players who do not exist, needing a schema bump and
/// a migration to store what is really a per-device UI preference.
String _marksKey(int careerId) => 'youth_watchlist_v1:$careerId';

/// Reads a save's marks, outside any provider.
///
/// Top level for the same reason `_loadTakers` is: the store invalidates the
/// provider after a write, and a provider that depended on the store would be
/// invalidating its own dependant, which Riverpod calls a circular dependency.
/// The inbox reads it here too, without going near a widget.
Future<List<YouthMark>> loadYouthMarks(int careerId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_marksKey(careerId));
    if (raw == null || raw.isEmpty) return const [];
    final json = jsonDecode(raw);
    if (json is! List) return const [];
    final out = <YouthMark>[];
    for (final entry in json) {
      if (entry is! Map) continue;
      final id = _asInt(entry['i']);
      if (id == null) continue;
      out.add((
        playerId: id,
        name: entry['n'] as String? ?? '',
        rating: _asInt(entry['r']) ?? 0,
        age: _asInt(entry['a']) ?? 0,
        year: _asInt(entry['y']) ?? 0,
      ));
    }
    return out;
  } on Object {
    // Unreadable marks are an empty watchlist, not a crash on the youth screen.
    return const [];
  }
}

int? _asInt(Object? v) => v is int ? v : int.tryParse('$v');

/// Forgets a save's marks entirely.
///
/// The watchlist does NOT travel to a new nation, for the same reason the
/// captain's armband and the staff room do not (see `switchNation`): those boys
/// are another federation's academy and not one of them is in the new nation's
/// pyramid, so every name left on the list would read as released or gone.
///
/// Swallows a preferences failure rather than throwing: this is called from the
/// cycle rollover, and a save must never be left half-rolled over a UI list.
Future<void> clearYouthMarks(int careerId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_marksKey(careerId));
  } on Object {
    // Nothing to do about it, and nothing worth failing a rollover for.
  }
}

Future<void> _saveMarks(int careerId, List<YouthMark> marks) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    _marksKey(careerId),
    jsonEncode([
      for (final m in marks)
        {
          'i': m.playerId,
          'n': m.name,
          'r': m.rating,
          'a': m.age,
          'y': m.year,
        },
    ]),
  );
}

/// Marks and unmarks the boys a manager is following.
class YouthWatchStore {
  const YouthWatchStore(this._ref);

  final Ref _ref;

  Future<List<YouthMark>> load(int careerId) => loadYouthMarks(careerId);

  /// Marks [player] as he is now, in save year [year]; marking a boy who is
  /// already marked leaves the ORIGINAL mark alone, because the rating it
  /// carries is the reading the whole list is measured against.
  Future<void> mark(int careerId, Player player, int year) async {
    final marks = [...await load(careerId)];
    if (marks.any((m) => m.playerId == player.id)) return;
    marks.add((
      playerId: player.id,
      name: player.name,
      rating: player.overall,
      age: player.age,
      year: year,
    ));
    await _saveMarks(careerId, marks);
    _ref.invalidate(youthMarksProvider(careerId));
  }

  Future<void> unmark(int careerId, int playerId) async {
    final marks = [...await load(careerId)]
      ..removeWhere((m) => m.playerId == playerId);
    await _saveMarks(careerId, marks);
    _ref.invalidate(youthMarksProvider(careerId));
  }

  /// Marks [player] if he is not marked, unmarks him if he is.
  Future<void> toggle(int careerId, Player player, int year) async {
    final marks = await load(careerId);
    if (marks.any((m) => m.playerId == player.id)) {
      await unmark(careerId, player.id);
    } else {
      await mark(careerId, player, year);
    }
  }
}

final Provider<YouthWatchStore> youthWatchStoreProvider = Provider(
  YouthWatchStore.new,
);

/// The boys this save has marked, in the order they were marked.
final AutoDisposeFutureProviderFamily<List<YouthMark>, int> youthMarksProvider =
    FutureProvider.autoDispose.family<List<YouthMark>, int>(
      // Reads the prefs directly, not through [youthWatchStoreProvider]: see
      // [loadYouthMarks] for why this provider must not depend on the store.
      (ref, careerId) => loadYouthMarks(careerId),
    );
