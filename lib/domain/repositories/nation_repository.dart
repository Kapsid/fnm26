import 'package:fnm/domain/entities/nation.dart';

/// Read access to the national-team reference data.
abstract interface class NationRepository {
  /// All nations, ordered by FIFA ranking (strongest first).
  Future<List<Nation>> all();

  /// Only nations available in the free demo.
  Future<List<Nation>> freeDemo();

  /// The nation with [id], or `null` if none exists.
  Future<Nation?> byId(int id);
}
