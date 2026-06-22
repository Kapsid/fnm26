import 'package:fnm/domain/entities/player.dart';

/// Read access to the player reference data.
abstract interface class PlayerRepository {
  /// All players eligible for [nationId], ordered by overall (best first).
  Future<List<Player>> byNation(int nationId);

  /// The player with [id], or `null` if none exists.
  Future<Player?> byId(int id);
}
