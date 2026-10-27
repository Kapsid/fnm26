import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/nations/career_nations_providers.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';
import 'greenland_fixtures.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('all() and freeDemo() are the base world; byId and everyKnown find '
      'Greenland', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final repo = c.read(nationRepositoryProvider);

    final all = await repo.all();
    expect(all.map((n) => n.id), isNot(contains(212)));
    expect(all, hasLength(seedNations.length));
    expect((await repo.freeDemo()).map((n) => n.id), isNot(contains(212)));
    expect((await repo.byId(212))?.name, 'Greenland');
    final known = await repo.everyKnown();
    expect(known, hasLength(seedNations.length + 1));
    expect(known.map((n) => n.id), containsAll([212, 45]));
    expect(await c.read(nationsProvider.future), all);
    expect((await c.read(knownNationsByIdProvider.future))[212]?.code, 'GRL');
  });

  test("forCareer: the base world, or Greenland in San Marino's place for a "
      'marked career', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final repo = c.read(nationRepositoryProvider);
    final careers = c.read(careerRepositoryProvider);
    final comp = c.read(competitionRepositoryProvider);

    final normal = await careers.create(
      managerName: 'M',
      nationId: 1,
      rngSeed: 1,
      startDate: DateTime(2026, 9),
    );
    final marked = await careers.create(
      managerName: 'M',
      nationId: 1,
      rngSeed: 1,
      startDate: DateTime(2026, 9),
    );
    final base = await repo.all();
    expect(await repo.forCareer(normal.id), base);
    // Read BEFORE the marker lands: a "no" must not be cached.
    expect(await repo.forCareer(marked.id), base);
    await comp.markDrawWatched(
      marked.id,
      0,
      DormantNations.markerFor(DormantNations.greenlandId),
    );

    final world = await repo.forCareer(marked.id);
    expect(world, hasLength(base.length));
    expect(world.map((n) => n.id), contains(212));
    expect(world.map((n) => n.id), isNot(contains(45)));
    // Last in the world by seed ranking, and otherwise the base order.
    expect(world.last.id, 212);
    expect(
      world.where((n) => n.id != 212).toList(),
      base.where((n) => n.id != 45).toList(),
    );
    expect(await repo.forCareer(normal.id), base);
    expect(await c.read(careerNationsProvider(marked.id).future), world);
    expect(
      (await c.read(careerNationsByIdProvider(marked.id).future)).keys,
      isNot(contains(45)),
    );
  });

  test('create(worldMarkers:) draws a world with Greenland and without San '
      'Marino', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: 212,
                  managerName: 'M',
                  rngSeed: 212,
                  worldMarkers: [
                    DormantNations.markerFor(DormantNations.greenlandId),
                  ],
                ))
            .valueOrNull!;
    final fixtures = await c
        .read(competitionRepositoryProvider)
        .allFixtures(career.id);
    final teams = {
      for (final f in fixtures) ...[f.homeNationId, f.awayNationId],
    };
    expect(teams, contains(212));
    expect(teams, isNot(contains(45)));
    final tiers = await c
        .read(careerRepositoryProvider)
        .nationsCupTiers(career.id);
    expect(tiers.keys, contains(212));
    expect(tiers.keys, isNot(contains(45)));
  });

  test(
    'worldFrom swaps only a nation the base world has, so it never grows',
    () {
      Nation dormant(int id) => DormantNations.greenland;
      final swapped = DormantNations.worldFrom(seedNations, {
        212,
      }, dormant: dormant);
      expect(swapped, hasLength(seedNations.length));
      expect(swapped.last.id, 212);
      // No San Marino to stand in for: no Greenland either.
      final noSm = [
        for (final n in seedNations)
          if (n.id != 45) n,
      ];
      expect(
        DormantNations.worldFrom(noSm, {212}, dormant: dormant),
        same(noSm),
      );
      expect(
        DormantNations.worldFrom(seedNations, {}, dormant: dormant),
        same(seedNations),
      );
    },
  );
}
