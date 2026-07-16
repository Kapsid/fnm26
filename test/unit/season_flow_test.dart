import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
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
    // Six European nations (the player's confederation) plus one Asian nation
    // that is the deterministic World Cup host for 2030 (the Asia rotation
    // year) — hosts sit out qualifying, so this keeps the host out of the
    // player's Europe qualifying group instead of falling back to the
    // globally-strongest nation (which would be the player).
    final nations = [
      for (var i = 1; i <= 6; i++) nation(id: i, ranking: i),
      nation(id: 7, ranking: 7, confederation: Confederation.asia),
    ];
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

  test('creating a save generates a competitive group with fixtures', () async {
    await container.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await container.read(careerServiceProvider).create(
          nationId: 1,
          managerName: 'A',
        ))
            .valueOrNull!;

    final hub = await container.read(hubDataProvider(career.id).future);
    expect(hub, isNotNull);
    // The Nations League opens the calendar for this small world (no full
    // continental qualifying), then World Cup qualifying follows.
    expect(hub!.group, isNotNull);
    expect(hub.group!.standings, isNotEmpty);
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
    // Advancing is an explicit quick-sim/skip: it plays the world up to (and
    // including) the player's next fixture, so at least one match has now been
    // played (a friendly or a qualifier — the cycle opens with continental
    // qualifying / friendlies before the World Cup).
    expect(after.recentResults, isNotEmpty);
  });
}
