import 'package:fnm/domain/entities/career.dart';

/// Persists and retrieves save games.
abstract interface class CareerRepository {
  /// Creates a new save and returns it (with its assigned id).
  ///
  /// [startDate] seeds both the creation timestamp and the initial in-game
  /// date; the cycle pointer starts at `0`.
  Future<Career> create({
    required String managerName,
    required int nationId,
    required int rngSeed,
    required DateTime startDate,
  });

  /// All saves, most recently created first.
  Future<List<Career>> all();

  /// The save with [id], or `null` if none exists.
  Future<Career?> byId(int id);

  /// Advances (or sets) the in-game date of a save.
  Future<void> updateInGameDate(int id, DateTime date);

  /// Deletes the save with [id] (no-op if it does not exist).
  Future<void> delete(int id);
}
