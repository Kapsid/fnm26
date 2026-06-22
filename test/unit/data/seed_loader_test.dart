import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_nation_repository.dart';
import 'package:fnm/data/repositories/drift_player_repository.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';

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
    expect((await DriftNationRepository(db).all()), hasLength(1));
    expect((await DriftPlayerRepository(db).byNation(1)), hasLength(1));
  });

  test('ensureSeeded() is idempotent and does not duplicate data', () async {
    await loaderWith().ensureSeeded();
    final secondRun = await loaderWith().ensureSeeded();

    expect(secondRun, isFalse);
    expect((await DriftNationRepository(db).all()), hasLength(1));
  });
}
