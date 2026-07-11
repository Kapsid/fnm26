import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../helpers/fixtures.dart';
import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = createTestDatabase();
    final nations = [for (var i = 1; i <= 6; i++) nation(id: i, ranking: i)];
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);
  });

  test('creating a save generates a qualifying group with fixtures', () async {
    await container.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await container.read(careerServiceProvider).create(
          nationId: 1,
          managerName: 'A',
        ))
            .valueOrNull!;

    final hub = await container.read(hubDataProvider(career.id).future);
    expect(hub, isNotNull);
    expect(hub!.group, isNotNull);
    expect(hub.group!.standings, hasLength(6));
    expect(hub.next, isNotNull); // an upcoming fixture exists
  });

  test('advancing simulates the matchday and moves the date forward', () async {
    await container.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await container.read(careerServiceProvider).create(
          nationId: 1,
          managerName: 'A',
        ))
            .valueOrNull!;

    final before = await container.read(hubDataProvider(career.id).future);
    await container.read(seasonServiceProvider).advance(career.id);
    final after = await container.read(hubDataProvider(career.id).future);

    expect(
      after!.career.inGameDate.isAfter(before!.career.inGameDate),
      isTrue,
    );
    // Advancing simulates the world up to the player's next fixture: at least
    // one match has now been played (a friendly or a qualifier — the cycle
    // opens with continental qualifying / friendlies before the World Cup).
    expect(after.recentResults, isNotEmpty);
  });
}
