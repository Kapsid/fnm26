import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';
import 'greenland_fixtures.dart';

/// The guard: Greenland being in the database changes nothing about a normal
/// career. Same nation list, same order, same draws, same seeds, same squads.
///
/// Every normal career is built twice, once on a database that holds the
/// dormant data and once on one that does not, and the two must match.

/// The European qualifying draw of cycle 0, rebuilt exactly as
/// `CareerService.buildCalendar` does it (as `campaign_seeds_test.dart` does).
List<List<int>> _euroQualifyingGroups(int seed, List<Nation> nations) {
  const conf = Confederation.europe;
  final members = nations.where((n) => n.confederation == conf).toList()
    ..sort((a, b) => a.ranking.compareTo(b.ranking));
  final field = {
    for (final n in WorldCupHosts.continentalQualifiers(
      confederation: conf,
      cycle: 0,
      seed: seed,
      nations: nations,
    ))
      n.id,
  };
  final cq = const ScheduleGenerator().generate(
    confederation: conf,
    nations: members.where((n) => field.contains(n.id)).toList(),
    rngSeed: seed ^ 0 ^ 0xCAFE,
    start: DateTime(2026, 9),
    groupSize: 6,
    windows: (
      start: DateTime(2026, 9),
      deadline: DateTime(2027, 6, 30),
      seed: seed ^ 0xCAFE ^ 0xF1D0,
      fillAll: false,
    ),
  );
  return [
    for (final g in cq.groups) [...g.nationIds]..sort(),
  ];
}

Future<({ProviderContainer c, Career career})> _start(
  int seed,
  int nationId, {
  required bool dormant,
}) async {
  final db = createTestDatabase();
  addTearDown(db.close);
  final c = greenlandContainer(db, dormant: dormant);
  addTearDown(c.dispose);
  await c.read(seedLoaderProvider).ensureSeeded();
  final career =
      (await c
              .read(careerServiceProvider)
              .create(nationId: nationId, managerName: 'M', rngSeed: seed))
          .valueOrNull!;
  return (c: c, career: career);
}

void main() {
  // Two databases at once, on purpose.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'with the dormant data seeded, all() is exactly the base world',
    () async {
      final withG = await _start(1, 19, dormant: true);
      final without = await _start(1, 19, dormant: false);
      final a = await withG.c.read(nationRepositoryProvider).all();
      final b = await without.c.read(nationRepositoryProvider).all();
      expect(a.map((n) => n.id), isNot(contains(212)));
      expect(a, b);
      expect(
        {for (final n in a) n.id},
        {for (final n in seedNations) n.id},
      );
    },
  );

  // San Marino's own career too: the nation Greenland replaces must be
  // untouched in a world that does not include Greenland.
  for (final (seed, nationId) in [(1, 19), (10, 19), (10, 45)]) {
    test('a normal career (seed $seed, nation $nationId) is identical with '
        'and without the dormant data', () async {
      final withG = await _start(seed, nationId, dormant: true);
      final without = await _start(seed, nationId, dormant: false);
      final id = withG.career.id;
      expect(without.career.id, id);
      final repo = withG.c.read(nationRepositoryProvider);

      // Its world is the base world.
      final world = await repo.forCareer(id);
      expect(world, await repo.all());
      expect(world.map((n) => n.id), isNot(contains(212)));

      // Every fixture of both cycles' calendars, byte for byte.
      final fixtures = await withG.c
          .read(competitionRepositoryProvider)
          .allFixtures(id);
      expect(fixtures, isNotEmpty);
      expect(
        fixtures,
        await without.c.read(competitionRepositoryProvider).allFixtures(id),
      );
      expect(
        fixtures.where((f) => f.homeNationId == 212 || f.awayNationId == 212),
        isEmpty,
      );

      // The Nations Cup ladder, and the budget the seed ranking sizes.
      final careers = withG.c.read(careerRepositoryProvider);
      final tiers = await careers.nationsCupTiers(id);
      expect(
        tiers,
        await without.c.read(careerRepositoryProvider).nationsCupTiers(id),
      );
      expect(tiers, NationsCup.seedTiers(seedNations, (n) => n.ranking));
      expect(
        (await careers.byId(id))!.budget,
        (await without.c.read(careerRepositoryProvider).byId(id))!.budget,
      );

      // The stored European qualifying groups are the ones nations.json
      // alone gives.
      final tables = await withG.c
          .read(competitionRepositoryProvider)
          .tournamentGroupTables(
            id,
            CompetitionKind.continentalQualifying,
            confederation: Confederation.europe,
          );
      final stored = [
        for (final t in tables)
          [for (final s in t.standings) s.nationId]..sort(),
      ];
      final rebuilt = _euroQualifyingGroups(seed, seedNations);
      expect(
        {for (final g in stored) g.join(',')},
        {for (final g in rebuilt) g.join(',')},
      );

      // Both cycles' hosts, as every display provider recomputes them.
      for (var cycle = 0; cycle < 2; cycle++) {
        expect(
          WorldCupHosts.hostsFor(
            year: CareerService.worldCupYear(cycle),
            nations: world,
            seed: seed,
          ),
          WorldCupHosts.hostsFor(
            year: CareerService.worldCupYear(cycle),
            nations: seedNations,
            seed: seed,
          ),
        );
        expect(
          WorldCupHosts.continentalHostsFor(
            confederation: Confederation.europe,
            cycle: cycle,
            seed: seed,
            nations: world,
          ),
          WorldCupHosts.continentalHostsFor(
            confederation: Confederation.europe,
            cycle: cycle,
            seed: seed,
            nations: seedNations,
          ),
        );
      }

      // The ranking and the news never mention Greenland.
      final ranking = await withG.c.read(worldRankingProvider(id).future);
      expect(ranking!.nations.map((n) => n.id), isNot(contains(212)));
      expect(ranking.nations, hasLength(seedNations.length));
      final messages = await withG.c
          .read(competitionRepositoryProvider)
          .messages(id);
      expect(
        messages.where((m) => '${m.title} ${m.body}'.contains('Greenland')),
        isEmpty,
      );

      // The manager's squad: same players, same names, same clubs.
      final career = (await careers.byId(id))!;
      Future<List<Object>> squad(ProviderContainer c) async => [
        for (final p
            in await c
                .read(playerRepositoryProvider)
                .byNation(nationId, saveSeed: career.rngSeed, careerId: id))
          (p.id, p.name, p.club, p.overall),
      ];
      expect(await squad(withG.c), await squad(without.c));
    });
  }
}
