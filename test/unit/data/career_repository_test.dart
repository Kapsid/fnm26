import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_career_repository.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/data/seed/seed_source.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftCareerRepository repo;

  setUp(() async {
    db = createTestDatabase();
    await SeedLoader(
      db,
      InMemorySeedSource(nationList: [nation(id: 1)], playerList: const []),
    ).ensureSeeded();
    repo = DriftCareerRepository(db);
  });

  tearDown(() => db.close());

  test('create() persists a save and assigns an id', () async {
    final start = DateTime(2026, 6, 1);
    final career = await repo.create(
      managerName: 'Alex',
      nationId: 1,
      rngSeed: 4242,
      startDate: start,
    );

    expect(career.id, greaterThan(0));
    expect(career.managerName, 'Alex');
    expect(career.nationId, 1);
    expect(career.rngSeed, 4242);
    expect(career.createdAt, start);
    expect(career.inGameDate, start);
    expect(career.cyclePointer, 0);
  });

  test('all() lists saves most-recent first', () async {
    await repo.create(
      managerName: 'First',
      nationId: 1,
      rngSeed: 1,
      startDate: DateTime(2026),
    );
    await repo.create(
      managerName: 'Second',
      nationId: 1,
      rngSeed: 2,
      startDate: DateTime(2027),
    );

    final all = await repo.all();
    expect(all.map((c) => c.managerName), ['Second', 'First']);
  });

  test('byId() and delete()', () async {
    final career = await repo.create(
      managerName: 'Alex',
      nationId: 1,
      rngSeed: 7,
      startDate: DateTime(2026),
    );

    expect((await repo.byId(career.id))?.managerName, 'Alex');

    await repo.delete(career.id);
    expect(await repo.byId(career.id), isNull);
    expect(await repo.all(), isEmpty);
  });

  test('investment round-trips the naturalisation allocation', () async {
    final career = await repo.create(
      managerName: 'Alex',
      nationId: 1,
      rngSeed: 7,
      startDate: DateTime(2026),
    );

    await repo.setInvestment(
      career.id,
      1,
      (
        youth: 1000000,
        commercial: 2000000,
        medical: 0,
        naturalization: 3500000,
        boardRelations: 0,
      ),
    );

    final read = await repo.investment(career.id, 1);
    expect(read.naturalization, 3500000);
    expect(read.commercial, 2000000);

    // A cycle with no allocation defaults to zero across the board.
    expect((await repo.investment(career.id, 2)).naturalization, 0);
  });

  test('naturalisation offer lifecycle: pending → accepted', () async {
    final career = await repo.create(
      managerName: 'Alex',
      nationId: 1,
      rngSeed: 7,
      startDate: DateTime(2026),
    );

    expect(await repo.pendingNaturalization(career.id), isNull);

    await repo.addNaturalizationOffer(
      careerId: career.id,
      playerId: 555,
      sourceNationId: 9,
      cycle: 1,
    );

    final pending = await repo.pendingNaturalization(career.id);
    expect(pending?.playerId, 555);
    expect(pending?.sourceNationId, 9);
    expect(await repo.acceptedNaturalizations(career.id), isEmpty);

    await repo.setNaturalizationStatus(career.id, 555, 'accepted');
    expect(await repo.pendingNaturalization(career.id), isNull);
    final accepted = await repo.acceptedNaturalizations(career.id);
    expect(accepted.map((l) => l.playerId), [555]);

    // A declined offer is neither pending nor accepted.
    await repo.addNaturalizationOffer(
      careerId: career.id,
      playerId: 777,
      sourceNationId: 3,
      cycle: 1,
    );
    await repo.setNaturalizationStatus(career.id, 777, 'declined');
    expect(await repo.pendingNaturalization(career.id), isNull);
    expect(
      (await repo.acceptedNaturalizations(career.id)).map((l) => l.playerId),
      [555],
    );
  });
}
