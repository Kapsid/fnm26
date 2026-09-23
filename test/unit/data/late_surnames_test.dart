import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_player_repository.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';

import '../../helpers/test_database.dart';

/// Surnames added to a pool after saves already existed.
///
/// A name is drawn by index into a save-seeded shuffle of the whole
/// first x surname cross product, so putting a new surname in `sur` grows that
/// product and renames every player of the nation in every existing save.
/// Appending instead is safe and useless: a nation's product runs to a couple
/// of thousand combinations and a whole career consumes a few hundred, so
/// anything at the end is never reached.
///
/// So `surLate` is spliced into a handful of low slots. This checks the two
/// halves of that bargain: the names DO turn up, and they cost exactly one
/// existing player each.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late DriftPlayerRepository repo;
  late Map<String, dynamic> names;
  late List<Nation> nations;

  int idOf(String code) =>
      nations.firstWhere((n) => n.code.toUpperCase() == code).id;

  setUp(() async {
    db = createTestDatabase();
    nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    names =
        jsonDecode(File('assets/data/country_names.json').readAsStringSync())
            as Map<String, dynamic>;
    await SeedLoader(
      db,
      InMemorySeedSource(nationList: nations, playerList: players),
    ).ensureSeeded();
    repo = DriftPlayerRepository(db);
  });

  tearDown(() => db.close());

  List<String> lateOf(int nationId) =>
      ((names['$nationId'] as Map)['surLate'] as List? ?? const [])
          .cast<String>();

  test('every late surname is somebody, in every save', () async {
    for (final code in ['CZE', 'POL', 'SVK']) {
      final id = idOf(code);
      final late = lateOf(id);
      expect(late, isNotEmpty, reason: '$code should carry late surnames');
      // Several saves: the slots are save-seeded, so this also says the names
      // are not a fluke of one lucky seed.
      for (final seed in [1, 7, 99, 12345]) {
        final pool = await repo.byNation(id, saveSeed: seed, minAge: 15);
        for (final surname in late) {
          final holders = pool.where((p) => p.name.endsWith(' $surname'));
          expect(
            holders,
            hasLength(1),
            reason: '$code save $seed should field exactly one $surname',
          );
        }
      }
    }
  });

  test('a late surname costs exactly one existing player each', () async {
    // The splice is the whole cost of the feature: N surnames overwrite N
    // slots, so N players are renamed and nobody else moves. More holders than
    // that would mean the cross product had been grown after all.
    final id = idOf('CZE');
    final late = lateOf(id);
    final pool = await repo.byNation(id, saveSeed: 4242, minAge: 15);
    final touched = pool
        .where((p) => late.any((s) => p.name.endsWith(' $s')))
        .toList();
    expect(touched, hasLength(late.length));
  });

  test('names stay unique inside a nation', () async {
    // The splice picks its own first name, so it can collide with a name the
    // shuffle already handed out.
    final id = idOf('CZE');
    final pool = await repo.byNation(id, saveSeed: 4242, minAge: 15);
    final names = pool.map((p) => p.name).toList();
    expect(names.toSet(), hasLength(names.length));
  });

  test('a nation with no late surnames is untouched by any of this', () async {
    final id = idOf('ENG');
    expect(lateOf(id), isEmpty);
    final pool = await repo.byNation(id, saveSeed: 4242, minAge: 15);
    for (final surname in ['Urbanczyk', 'Pavelek', 'Homolka', 'Vasilišin']) {
      expect(
        pool.where((p) => p.name.endsWith(' $surname')),
        isEmpty,
        reason: 'a Czech surname must not leak into England',
      );
    }
  });
}
