import 'package:fnm/domain/entities/player.dart';

/// Read access to the player reference data.
///
/// `agingCycles` ages the returned players by that many four-year cycles (0 =
/// the base seed state) — callers pass the active save's `cyclePointer` so the
/// squad reflects the current point in that save's timeline.
abstract interface class PlayerRepository {
  /// All players eligible for [nationId], ordered by overall (best first).
  Future<List<Player>> byNation(int nationId, {int agingCycles});

  /// Every player across all nations (unordered).
  Future<List<Player>> all();

  /// The player with [id], or `null` if none exists.
  Future<Player?> byId(int id, {int agingCycles});
}
