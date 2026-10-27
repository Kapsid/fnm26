import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/library_tactic.dart';
import 'package:fnm/domain/repositories/tactic_library_repository.dart';

class DriftTacticLibraryRepository implements TacticLibraryRepository {
  DriftTacticLibraryRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  @override
  Future<List<LibraryTactic>> all() async {
    final rows = await _db.select(_db.tacticLibrary).get();
    return [
      for (final r in rows)
        LibraryTactic.fromData(id: r.id, name: r.name, data: r.data),
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future<TacticLibraryRow?> _named(String name, {int? except}) async {
    final lower = name.toLowerCase();
    final rows = await _db.select(_db.tacticLibrary).get();
    return rows
        .where((r) => r.name.toLowerCase() == lower && r.id != except)
        .firstOrNull;
  }

  @override
  Future<int> save(LibraryTactic tactic) => _db.transaction(() async {
    final existing = await _named(tactic.name);
    final row = TacticLibraryCompanion(
      name: Value(tactic.name),
      data: Value(tactic.toData()),
      updatedAt: Value(_clock()),
    );
    if (existing != null) {
      await (_db.update(
        _db.tacticLibrary,
      )..where((t) => t.id.equals(existing.id))).write(row);
      return existing.id;
    }
    return _db.into(_db.tacticLibrary).insert(row);
  });

  @override
  Future<bool> rename(int id, String name) => _db.transaction(() async {
    if (await _named(name, except: id) != null) return false;
    await (_db.update(_db.tacticLibrary)..where((t) => t.id.equals(id))).write(
      TacticLibraryCompanion(name: Value(name), updatedAt: Value(_clock())),
    );
    return true;
  });

  @override
  Future<void> delete(int id) async {
    await (_db.delete(_db.tacticLibrary)..where((t) => t.id.equals(id))).go();
  }
}
