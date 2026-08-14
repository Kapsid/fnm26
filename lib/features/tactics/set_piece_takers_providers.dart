import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The manager's designated set-piece takers for a save: who steps up for
/// penalties, and who whips in the corners / free-kicks. Null = let the engine
/// pick the best-suited player automatically.
typedef SetPieceTakers = ({int? penalty, int? deadBall});

/// Prefs key — outside the save database (no schema bump), scoped per career.
String _takersKey(int careerId) => 'set_piece_takers_v1:$careerId';

/// Loads and saves a save's set-piece taker choices.
class SetPieceTakersStore {
  const SetPieceTakersStore(this._ref);

  final Ref _ref;

  Future<SetPieceTakers> load(int careerId) async {
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
}

final Provider<SetPieceTakersStore> setPieceTakersStoreProvider = Provider(
  SetPieceTakersStore.new,
);

/// One save's set-piece taker choices.
final AutoDisposeFutureProviderFamily<SetPieceTakers, int>
setPieceTakersProvider = FutureProvider.autoDispose.family<SetPieceTakers, int>(
  (ref, careerId) => ref.watch(setPieceTakersStoreProvider).load(careerId),
);
