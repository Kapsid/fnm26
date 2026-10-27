import 'package:fnm/domain/entities/library_tactic.dart';

/// The manager's tactics library, shared by every career on the device.
abstract interface class TacticLibraryRepository {
  /// Every saved tactic, alphabetically by name.
  Future<List<LibraryTactic>> all();

  /// Saves [tactic] under its name, replacing an entry with the same name
  /// (ignoring case), so saving a plan again updates it rather than doubling
  /// it. Returns the stored entry's id.
  Future<int> save(LibraryTactic tactic);

  /// Renames entry [id] to [name]. Returns false, changing nothing, when
  /// another entry already has that name (ignoring case).
  Future<bool> rename(int id, String name);

  Future<void> delete(int id);
}
