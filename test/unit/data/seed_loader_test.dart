import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_nation_repository.dart';
import 'package:fnm/data/repositories/drift_player_repository.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  SeedLoader loaderWith() => SeedLoader(
    db,
    InMemorySeedSource(
      nationList: [nation(id: 1, isFreeDemo: true)],
      playerList: [
        player(id: 101, nationId: 1, position: PlayerPosition.st),
      ],
    ),
  );

  setUp(() => db = createTestDatabase());
  tearDown(() => db.close());

  test('ensureSeeded() populates reference tables on first run', () async {
    final didSeed = await loaderWith().ensureSeeded();

    expect(didSeed, isTrue);
    expect(await DriftNationRepository(db).all(), hasLength(1));
    // The pool also carries the nation's backfilled youth intakes, which are
    // generated rather than seeded; only the seeded row came from the source.
    final pool = await DriftPlayerRepository(db).byNation(1);
    expect(
      pool.where((p) => !PlayerLifecycle.isNewgenId(p.id)),
      hasLength(1),
    );
  });

  test('ensureSeeded() is idempotent and does not duplicate data', () async {
    await loaderWith().ensureSeeded();
    final secondRun = await loaderWith().ensureSeeded();

    expect(secondRun, isFalse);
    expect(await DriftNationRepository(db).all(), hasLength(1));
  });

  group('runs once per database', () {
    Future<int> nationRows() async =>
        (await db.customSelect('SELECT COUNT(*) AS c FROM nations').getSingle())
            .read<int>('c');

    Future<void> addStrayNation() => db.customStatement(
      "INSERT INTO nations (id, name, code, confederation) "
      "VALUES (999, 'Stray', 'STR', 'europe')",
    );

    test('a second call on the same source reuses the first run', () async {
      final source = InMemorySeedSource(
        nationList: [nation(id: 1, isFreeDemo: true)],
        playerList: const [],
      );
      final loader = SeedLoader(db, source);
      expect(await loader.ensureSeeded(), isTrue);
      // A nation the source does not have: a re-run of the reconcile would
      // prune it.
      await addStrayNation();
      expect(await loader.ensureSeeded(), isFalse);
      expect(await nationRows(), 2, reason: 'no reconcile ran again');
      // A loader on the same database and source shares the run too.
      expect(await SeedLoader(db, source).ensureSeeded(), isFalse);
      expect(await nationRows(), 2);

      SeedLoader.invalidate(db);
      expect(await loader.ensureSeeded(), isFalse);
      expect(await nationRows(), 1, reason: 'invalidate re-runs the reconcile');
    });

    test('another source or another database runs again', () async {
      await loaderWith().ensureSeeded();
      await addStrayNation();
      // loaderWith() builds a new source each time.
      await loaderWith().ensureSeeded();
      expect(await nationRows(), 1);

      final other = createTestDatabase();
      addTearDown(other.close);
      final source = InMemorySeedSource(
        nationList: [nation(id: 1, isFreeDemo: true)],
        playerList: const [],
      );
      expect(await SeedLoader(db, source).ensureSeeded(), isFalse);
      expect(await SeedLoader(other, source).ensureSeeded(), isTrue);
    });

    test('a failed run is forgotten, so the next call retries', () async {
      final source = _FlakySource(
        InMemorySeedSource(
          nationList: [nation(id: 1, isFreeDemo: true)],
          playerList: const [],
        ),
      );
      final loader = SeedLoader(db, source);
      await expectLater(loader.ensureSeeded(), throwsStateError);
      expect(await loader.ensureSeeded(), isTrue);
      expect(await nationRows(), 1);
    });

    test('concurrent first calls seed once', () async {
      final loader = loaderWith();
      final results = await Future.wait([
        loader.ensureSeeded(),
        loader.ensureSeeded(),
        loader.ensureSeeded(),
      ]);
      expect(results, [isTrue, isFalse, isFalse]);
      expect(await nationRows(), 1);
    });
  });
}

/// Fails its first [nations] read, then reads as [_inner].
class _FlakySource implements SeedSource {
  _FlakySource(this._inner);

  final SeedSource _inner;
  var _failed = false;

  @override
  Future<List<Nation>> nations() async {
    if (!_failed) {
      _failed = true;
      throw StateError('flaky');
    }
    return _inner.nations();
  }

  @override
  Future<List<Player>> players() => _inner.players();

  @override
  Future<Map<int, List<String>>> cities() => _inner.cities();

  @override
  Future<Map<int, NameLists>> nameLists() => _inner.nameLists();

  @override
  Future<({List<Nation> nations, List<Player> players})> dormant() =>
      _inner.dormant();
}
