import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The shared_preferences key holding one save's per-player role assignments
/// (playerId → role name). Kept outside the save database — like tactic presets
/// — so per-player roles need no schema bump/wipe, yet stay scoped per career.
String _rolesKey(int careerId) => 'player_roles_v1:$careerId';

PlayerRole _roleByName(String name) => PlayerRole.values.firstWhere(
      (r) => r.name == name,
      orElse: () => PlayerRole.none,
    );

/// Loads and saves a save's per-player tactical roles.
class PlayerRolesStore {
  const PlayerRolesStore(this._ref);

  final Ref _ref;

  Future<Map<int, PlayerRole>> load(int careerId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_rolesKey(careerId));
    if (raw == null || raw.isEmpty) return const {};
    try {
      final map = jsonDecode(raw);
      if (map is! Map) return const {};
      return {
        for (final e in map.entries)
          if (int.tryParse('${e.key}') case final id?)
            id: _roleByName('${e.value}'),
      }..removeWhere((_, role) => role == PlayerRole.none);
    } on FormatException {
      return const {};
    }
  }

  /// Sets [player]'s role (clearing it when [role] is [PlayerRole.none]).
  Future<void> setRole(int careerId, int player, PlayerRole role) async {
    final roles = {...await load(careerId)};
    if (role == PlayerRole.none) {
      roles.remove(player);
    } else {
      roles[player] = role;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _rolesKey(careerId),
      jsonEncode({for (final e in roles.entries) '${e.key}': e.value.name}),
    );
    _ref.invalidate(playerRolesProvider(careerId));
  }
}

final Provider<PlayerRolesStore> playerRolesStoreProvider =
    Provider(PlayerRolesStore.new);

/// One save's per-player role assignments (playerId → role; absent = none).
final AutoDisposeFutureProviderFamily<Map<int, PlayerRole>, int>
    playerRolesProvider =
    FutureProvider.autoDispose.family<Map<int, PlayerRole>, int>(
        (ref, careerId) => ref.watch(playerRolesStoreProvider).load(careerId));
