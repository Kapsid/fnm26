import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_nation_repository.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/data/seed/seed_source.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftNationRepository repo;

  setUp(() async {
    db = createTestDatabase();
    final source = InMemorySeedSource(
      nationList: [
        nation(id: 1, ranking: 5, isFreeDemo: true),
        nation(id: 2, ranking: 2, isFreeDemo: true),
        nation(id: 3, ranking: 10),
      ],
      playerList: const [],
    );
    await SeedLoader(db, source).ensureSeeded();
    repo = DriftNationRepository(db);
  });

  tearDown(() => db.close());

  test('all() returns nations ordered by ranking (strongest first)', () async {
    final all = await repo.all();
    expect(all.map((n) => n.id), [2, 1, 3]);
  });

  test('freeDemo() returns only free-demo nations', () async {
    final free = await repo.freeDemo();
    expect(free.map((n) => n.id).toSet(), {1, 2});
  });

  test('byId() returns the nation or null', () async {
    expect((await repo.byId(1))?.isFreeDemo, isTrue);
    expect((await repo.byId(3))?.isFreeDemo, isFalse);
    expect(await repo.byId(999), isNull);
  });
}
