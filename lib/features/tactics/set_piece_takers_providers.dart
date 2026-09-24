import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The manager's designated set-piece takers for a save: who steps up for
/// penalties, and who whips in the corners / free-kicks. Null = let the engine
/// pick the best-suited player automatically.
typedef SetPieceTakers = ({int? penalty, int? deadBall});

/// Prefs key — outside the save database (no schema bump), scoped per career.
String _takersKey(int careerId) => 'set_piece_takers_v1:$careerId';

/// Prefs key for "I am happy with the coach picking".
///
/// Its own key rather than a third field in the stored pair: [SetPieceTakers]
/// is read in four places and none of them wants to know about this.
String _autoKey(int careerId) => 'set_piece_auto_v1:$careerId';

/// Whether the manager has said he is content to leave the takers automatic.
///
/// The pre-match strip warned on every single match until somebody was named,
/// which a tester reported as being asked to change his takers after almost
/// every game with an unchanged side. Leaving the choice to the coach is a
/// legitimate way to play and the code already said so in a comment; it simply
/// had no way to hear it said back. This is that way.
Future<bool> _loadAuto(int careerId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoKey(careerId)) ?? false;
  } on Object {
    // Unreadable preferences are not an acknowledgement. Warning a manager
    // who had waved this away is a small annoyance; silencing one who never
    // did is the bug this whole thing is fixing.
    return false;
  }
}

/// Reads a save's stored pair, outside any provider.
///
/// Top level rather than a method on the store because the provider below must
/// NOT depend on the store: the store invalidates that provider after a write,
/// and Riverpod calls invalidating your own dependant a circular dependency —
/// which in a debug build threw after the prefs write had already landed, so
/// the choice was saved and the screen never heard about it.
Future<SetPieceTakers> _loadTakers(int careerId) async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_takersKey(careerId));
  if (raw == null || raw.isEmpty) return (penalty: null, deadBall: null);
  try {
    final map = jsonDecode(raw);
    if (map is! Map) return (penalty: null, deadBall: null);
    int? id(Object? v) => v is int ? v : int.tryParse('$v');
    return (penalty: id(map['penalty']), deadBall: id(map['deadBall']));
  } on FormatException {
    return (penalty: null, deadBall: null);
  }
}

/// Loads and saves a save's set-piece taker choices.
class SetPieceTakersStore {
  const SetPieceTakersStore(this._ref);

  final Ref _ref;

  Future<SetPieceTakers> load(int careerId) => _loadTakers(careerId);

  /// Sets the penalty taker ([penalty] true) or the dead-ball taker; a null
  /// [playerId] clears that choice (back to automatic).
  Future<void> set(
    int careerId, {
    required bool penalty,
    required int? playerId,
  }) async {
    final cur = await load(careerId);
    final next = penalty
        ? (penalty: playerId, deadBall: cur.deadBall)
        : (penalty: cur.penalty, deadBall: playerId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _takersKey(careerId),
      jsonEncode({'penalty': next.penalty, 'deadBall': next.deadBall}),
    );
    _ref.invalidate(setPieceTakersProvider(careerId));
  }

  /// Records that the manager is content to let the coach pick.
  ///
  /// Naming anybody afterwards is a change of mind, and the warning goes back
  /// to judging the named man — see [setPieceAutoAcceptedProvider] for why the
  /// acknowledgement only holds while nobody is named.
  Future<void> acceptAuto(int careerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoKey(careerId), true);
    _ref.invalidate(setPieceAutoAcceptedProvider(careerId));
  }

  /// Names BOTH takers at once — the quick pick.
  ///
  /// Not two calls to [set]: each of those re-reads the stored pair to keep the
  /// other half, so the second would race the first's write and the penalty
  /// taker could be dropped again the moment the dead-ball man was named.
  Future<void> setBoth(
    int careerId, {
    required int? penalty,
    required int? deadBall,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _takersKey(careerId),
      jsonEncode({'penalty': penalty, 'deadBall': deadBall}),
    );
    _ref.invalidate(setPieceTakersProvider(careerId));
  }
}

final Provider<SetPieceTakersStore> setPieceTakersStoreProvider = Provider(
  SetPieceTakersStore.new,
);

/// One save's set-piece taker choices.
final AutoDisposeFutureProviderFamily<SetPieceTakers, int>
setPieceTakersProvider = FutureProvider.autoDispose.family<SetPieceTakers, int>(
  // Reads the prefs directly, not through [setPieceTakersStoreProvider]: see
  // [_loadTakers] for why this provider must not depend on the store.
  (ref, careerId) => _loadTakers(careerId),
);

/// Whether the manager has accepted automatic takers for this save.
///
/// Read alongside the stored pair rather than instead of it. The
/// acknowledgement means "nobody named is fine", so it holds only while
/// nobody IS named: a manager who later picks a penalty taker and then loses
/// him to a ban must be told, and an old acknowledgement must not swallow it.
final AutoDisposeFutureProviderFamily<bool, int>
setPieceAutoAcceptedProvider = FutureProvider.autoDispose.family<bool, int>(
  (ref, careerId) => _loadAuto(careerId),
);
