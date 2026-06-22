import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_player_repository.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftPlayerRepository repo;

  setUp(() async {
    db = createTestDatabase();
    final source = InMemorySeedSource(
      nationList: [nation(id: 1), nation(id: 2)],
      playerList: [
        player(
          id: 101,
          nationId: 1,
          position: PlayerPosition.st,
          attributes: flatAttributes(70),
        ),
        player(
          id: 102,
          nationId: 1,
          position: PlayerPosition.cb,
          attributes: flatAttributes(90),
        ),
        player(
          id: 103,
          nationId: 1,
          position: PlayerPosition.cm,
          attributes: flatAttributes(80),
        ),
        player(id: 201, nationId: 2, attributes: flatAttributes(85)),
      ],
    );
    await SeedLoader(db, source).ensureSeeded();
    repo = DriftPlayerRepository(db);
  });

  tearDown(() => db.close());

  test('byNation() filters by nation and orders by overall (best first)',
      () async {
    final squad = await repo.byNation(1);
    expect(squad.map((p) => p.id), [102, 103, 101]);
    expect(squad.first.overall, 90);
  });

  test('byNation() returns only the requested nation', () async {
    final squad = await repo.byNation(2);
    expect(squad.map((p) => p.id), [201]);
  });

  test('byId() round-trips attributes and derived overall', () async {
    final p = await repo.byId(102);
    expect(p, isNotNull);
    expect(p!.overall, 90);
    expect(p.attributes.tackling, 90);
    expect(await repo.byId(999), isNull);
  });
}
