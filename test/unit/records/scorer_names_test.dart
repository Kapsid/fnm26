import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_player_repository.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

/// A generated player is not a database row: he is reconstructed from his id
/// by [PlayerLifecycle.newgenById], and that reconstruction can only reach an
/// intake year that is not in the future. Ask for him with the default
/// `agingYears: 0` and every newgen who came in after the save opened is
/// outside the window, so the lookup returns null and the screen prints
/// "Unknown".
///
/// Which is exactly what the top-scorer lists of a late World Championship
/// were doing: by then most of the scorers are newgens.
void main() {
  const saveSeed = 4242;

  /// Three cycles in — far enough that most of the pool came through the
  /// youth intakes rather than off the seed.
  const agingYears = 12;

  late AppDatabase db;
  late DriftPlayerRepository repo;

  setUp(() async {
    db = createTestDatabase();
    await SeedLoader(
      db,
      InMemorySeedSource(
        nationList: [nation(id: 1)],
        playerList: [
          player(
            id: 101,
            nationId: 1,
            position: PlayerPosition.st,
            attributes: flatAttributes(78),
          ),
          player(
            id: 102,
            nationId: 1,
            position: PlayerPosition.cb,
            attributes: flatAttributes(82),
          ),
          player(
            id: 103,
            nationId: 1,
            position: PlayerPosition.cm,
            attributes: flatAttributes(74),
          ),
          player(
            id: 104,
            nationId: 1,
            position: PlayerPosition.gk,
            attributes: flatAttributes(76),
          ),
        ],
      ),
    ).ensureSeeded();
    repo = DriftPlayerRepository(db);
  });

  tearDown(() => db.close());

  /// The ids a late tournament's scorer list would be holding: everyone in the
  /// nation's pool twelve years in.
  Future<List<Player>> poolNow() =>
      repo.byNation(1, agingYears: agingYears, saveSeed: saveSeed);

  test('every player in a late pool resolves to a name by id', () async {
    final pool = await poolNow();
    expect(
      pool.where((p) => PlayerLifecycle.isNewgenId(p.id)),
      isNotEmpty,
      reason: 'twelve years in, the pool should carry generated players',
    );

    for (final p in pool) {
      final resolved = await repo.byId(
        p.id,
        agingYears: agingYears,
        saveSeed: saveSeed,
      );
      expect(resolved, isNotNull, reason: 'scorer ${p.id} has no name');
      expect(resolved!.name, p.name, reason: 'scorer ${p.id} renamed');
    }
  });

  test('without agingYears a late newgen cannot be reconstructed', () async {
    // The diagnosis, pinned: this is not a broken lookup, it is a lookup asked
    // the wrong question. An id whose intake year is after the save opened is
    // simply not in the world `agingYears: 0` describes.
    final newgens = [
      for (final p in await poolNow())
        if (PlayerLifecycle.isNewgenId(p.id)) p,
    ];
    final missing = <int>[];
    for (final p in newgens) {
      if (await repo.byId(p.id, saveSeed: saveSeed) == null) missing.add(p.id);
    }
    expect(
      missing,
      isNotEmpty,
      reason: 'the default agingYears must lose the later intakes',
    );
  });

  test('every screen that resolves a player by id passes agingYears', () {
    // The guard on the fix. `byId` defaults `agingYears` to 0, which is the
    // right default for the world's opening day and wrong for every screen
    // that reads a save. Two screens were taking the default and printing
    // "Unknown" for most of a late tournament's scorers.
    // `saveSeed:` is the tell that it is the PLAYER repository being asked
    // (no other `byId` takes it), so the rule reads: a player lookup that
    // knows which save it is in must also say which year.
    final offenders = <String>[];
    for (final file in Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      final source = file.readAsStringSync();
      for (final m in RegExp(
        r'\.byId\(([^;]*?)\)\s*;',
        dotAll: true,
      ).allMatches(source)) {
        final args = m.group(1)!;
        if (args.contains('saveSeed:') && !args.contains('agingYears:')) {
          offenders.add('${file.path}: ${m.group(0)}');
        }
      }
    }
    expect(offenders, isEmpty);
  });
}
