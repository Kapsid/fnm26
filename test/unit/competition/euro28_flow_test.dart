import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/calendar2.dart';
import 'package:fnm/domain/services/competition/euro_playoffs.dart';
import 'package:fnm/domain/services/competition/euro_qualifying28.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';

import '../../helpers/calendar2_draws.dart';
import '../../helpers/test_database.dart';

/// Europe's qualifying for the EURO in the EURO 2028 shape (`Euro28`), with
/// every result set by hand (the better-ranked side wins) and the season's
/// progression run one pass at a time: every member drawn, the hosts too,
/// into twelve groups; twenty straight through; the hosts who miss out on
/// their held places; the play-offs (paths or two-legged ties) on the
/// calendar in March and resolved into the EURO's stored draw.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const europe = Confederation.europe;

  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List<dynamic>)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList();

  late AppDatabase db;
  late ProviderContainer c;

  setUp(() async {
    db = createTestDatabase();
    c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    await c.read(seedLoaderProvider).ensureSeeded();
  });
  tearDown(() async {
    c.dispose();
    await db.close();
  });

  Future<int> create(int nationId, {int seed = 4242}) async {
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: nationId, managerName: 'M', rngSeed: seed))
            .valueOrNull!;
    await c
        .read(competitionRepositoryProvider)
        .markDrawWatched(career.id, 0, budgetSetupKind);
    return career.id;
  }

  Future<List<FixtureRow>> fixturesOf(
    int id,
    CompetitionKind kind, {
    String? round,
  }) async {
    final comps =
        await (db.select(db.competitions)..where(
              (t) =>
                  t.careerId.equals(id) &
                  t.kind.equalsValue(kind) &
                  t.confederation.equalsValue(europe),
            ))
            .get();
    if (comps.isEmpty) return const [];
    return (db.select(db.fixtures)..where(
          (t) =>
              t.competitionId.isIn([for (final r in comps) r.id]) &
              (round == null ? const Constant(true) : t.round.equals(round)),
        ))
        .get();
  }

  Future<Map<int, int>> rankOf(int id) async => {
    for (final n in await c.read(nationRepositoryProvider).forCareer(id))
      n.id: n.ranking,
  };

  /// Plays [fx] by hand: the better-ranked side wins 2-0.
  Future<void> play(int id, Iterable<FixtureRow> fx) async {
    final comp = c.read(competitionRepositoryProvider);
    final rank = await rankOf(id);
    for (final f in fx) {
      if (f.played) continue;
      final homeWins =
          (rank[f.homeNationId] ?? 999) < (rank[f.awayNationId] ?? 999);
      await comp.recordResult(
        fixtureId: f.id,
        homeScore: homeWins ? 2 : 0,
        awayScore: homeWins ? 0 : 2,
      );
    }
  }

  Future<List<int>> euroHosts(int id) async {
    final career = (await c.read(careerRepositoryProvider).byId(id))!;
    return WorldCupHosts.continentalHostsFor(
      confederation: europe,
      cycle: career.cyclePointer,
      seed: career.rngSeed,
      nations: await c.read(nationRepositoryProvider).forCareer(id),
    );
  }

  test('a new career is marked; every member and the hosts are drawn into '
      'twelve groups, the hosts apart', () async {
    final europeans = [
      for (final n in nations)
        if (n.confederation == europe) n,
    ]..sort((a, b) => a.ranking.compareTo(b.ranking));
    final id = await create(europeans[20].id);
    final comp = c.read(competitionRepositoryProvider);
    expect(await isEuro28(comp, id, 0), isTrue);

    await play(
      id,
      await fixturesOf(id, CompetitionKind.nationsLeague, round: 'NGROUP'),
    );
    await drawEuroQualifyingNow(c, id);
    final tables = await comp.tournamentGroupTables(
      id,
      CompetitionKind.continentalQualifying,
      confederation: europe,
    );
    final members = [
      for (final n in await c.read(nationRepositoryProvider).forCareer(id))
        if (n.confederation == europe) n.id,
    ];
    expect(tables, hasLength(12));
    expect(
      [for (final t in tables) t.standings.length]..sort(),
      Euro28.groupSizes(members.length).reversed.toList(),
    );
    final drawn = {
      for (final t in tables)
        for (final s in t.standings) s.nationId,
    };
    expect(drawn, members.toSet(), reason: 'the hosts play too');
    final hosts = await euroHosts(id);
    expect(hosts, isNotEmpty);
    for (final t in tables) {
      expect(
        t.standings.where((s) => hosts.contains(s.nationId)).length,
        lessThanOrEqualTo(1),
        reason: 'hosts in separate groups',
      );
    }
    // Groups of five play ten matchdays, groups of four six: March to
    // November of the year after the draw.
    final wcYear = CareerService.worldCupYear(0);
    final fx = await fixturesOf(id, CompetitionKind.continentalQualifying);
    final span = Calendar2.euroQualifying(wcYear);
    for (final f in fx) {
      expect(f.date.isBefore(span.start), isFalse);
      expect(f.date.isAfter(span.deadline), isFalse);
    }
    // The pots are the first Nations Cup's: each group has one side of each
    // pot of twelve on that order.
    final order = await CareerService.euro28PotOrder(
      comp: comp,
      careerId: id,
      members: [
        for (final n in await c.read(nationRepositoryProvider).forCareer(id))
          if (n.confederation == europe) n,
      ]..sort((a, b) => a.ranking.compareTo(b.ranking)),
    );
    final pot = {for (final (i, id) in order.indexed) id: i ~/ 12};
    for (final t in tables) {
      expect(
        {for (final s in t.standings) pot[s.nationId]},
        hasLength(t.standings.length),
        reason: 'one side a pot in group ${t.name}',
      );
    }
  });

  // Seed 4242: one host, through directly, so four two-legged ties. Seed
  // 13: three hosts, one of them out on a held place, so three paths.
  for (final (seed, shape) in const [(4242, 'ties'), (13, 'paths')]) {
    test('qualifying ends ($shape): twenty through, held host places, the '
        'play-offs drawn and played into the exact slots', () async {
      final europeans = [
        for (final n in nations)
          if (n.confederation == europe) n,
      ]..sort((a, b) => a.ranking.compareTo(b.ranking));
      final id = await create(europeans[20].id, seed: seed);
      final comp = c.read(competitionRepositoryProvider);
      final season = c.read(seasonServiceProvider);
      final wcYear = CareerService.worldCupYear(0);

      await play(
        id,
        await fixturesOf(id, CompetitionKind.nationsLeague, round: 'NGROUP'),
      );
      await drawEuroQualifyingNow(c, id);
      await play(
        id,
        await fixturesOf(id, CompetitionKind.continentalQualifying),
      );
      await season.progressForTest(id);

      final hosts = await euroHosts(id);
      final groups = [
        for (final t in await comp.tournamentGroupTables(
          id,
          CompetitionKind.continentalQualifying,
          confederation: europe,
        ))
          t.standings,
      ];
      final direct = Euro28.direct(groups);
      expect(direct, hasLength(20));
      final held = Euro28.hostPlaces(
        groups: groups,
        hosts: hosts,
        direct: direct,
      );
      expect(held.length, lessThanOrEqualTo(2));
      final places = 4 - held.length;
      expect(places == 4, shape == 'ties', reason: 'the world moved: re-find');

      final paths = EuroPlayoffs.fromSlots(
        await comp.drawSlots(
          id,
          0,
          CompetitionKind.continentalPlayoff,
          confederation: europe,
        ),
      );
      expect(paths, hasLength(places));
      final ties = places == 4;
      for (final p in paths) {
        expect(p.seeds, hasLength(ties ? 2 : 4));
        expect(p.seeds.toSet().intersection({...direct, ...held}), isEmpty);
      }
      // The four runners-up the ladder leaves out are in (less any host on a
      // held place), seeded first.
      final others = [
        for (final s in Euro28.runnersUp(groups).skip(8))
          if (!held.contains(s.nationId)) s.nationId,
      ];
      final entrants = {for (final p in paths) ...p.seeds};
      expect(entrants.containsAll(others), isTrue);

      // The EURO's draw: 24 slots, a placeholder per play-off, the twenty and
      // the held hosts by name.
      final slots = await comp.drawSlots(
        id,
        0,
        CompetitionKind.continentalFinals,
        confederation: europe,
      );
      expect(slots, hasLength(24));
      expect(slots.where((s) => s.placeholderKey != null), hasLength(places));
      expect(
        {
          for (final s in slots)
            if (s.nationId != null) s.nationId,
        },
        {...direct, ...held},
      );

      // The board: a direct qualifier through, an entrant a rung below.
      Future<({int ordinal, bool over})> run(int nation) async =>
          continentalRun(
            comp: comp,
            careerId: id,
            nationId: nation,
            confederation: europe,
            fixtures: await comp.cycleFixturesForNation(id, nation),
            cycle: 0,
          );
      expect(await run(direct.first), (ordinal: 2, over: false));
      for (final h in held) {
        expect(await run(h), (ordinal: 2, over: false));
      }
      final entrant = paths.first.seeds.last;
      expect(await run(entrant), (ordinal: 1, over: false));

      final plan = Calendar2.euro28Playoffs(wcYear);
      final rank = await rankOf(id);
      int better(int a, int b) => (rank[a] ?? 999) < (rank[b] ?? 999) ? a : b;
      if (ties) {
        final legOne = await fixturesOf(
          id,
          CompetitionKind.continentalPlayoff,
          round: EuroPlayoffs.legOneRound,
        );
        final legTwo = await fixturesOf(
          id,
          CompetitionKind.continentalPlayoff,
          round: EuroPlayoffs.legTwoRound,
        );
        expect(legOne, hasLength(4));
        expect(legTwo, hasLength(4));
        for (final p in paths) {
          final l1 = legOne.singleWhere(
            (f) => p.seeds.contains(f.homeNationId),
          );
          final l2 = legTwo.singleWhere(
            (f) => p.seeds.contains(f.homeNationId),
          );
          expect((l1.homeNationId, l1.awayNationId), EuroPlayoffs.firstLeg(p));
          expect((l2.homeNationId, l2.awayNationId), EuroPlayoffs.secondLeg(p));
          expect(l1.date, plan.semis);
          expect(l2.date, plan.finalDay);
        }
        // The first legs to the unseeded sides at home, 1-0: nobody is out.
        for (final f in legOne) {
          await comp.recordResult(fixtureId: f.id, homeScore: 1, awayScore: 0);
        }
        final unseeded = paths.first.seeds[1];
        final seeded = paths.first.seeds[0];
        expect(await run(seeded), (ordinal: 1, over: false));
        await season.progressForTest(id);
        expect(
          await comp.hasTournament(
            id,
            CompetitionKind.continentalFinals,
            confederation: europe,
          ),
          isFalse,
        );
        // The second legs 3-0 to the seeded sides: through on aggregate.
        for (final f in legTwo) {
          await comp.recordResult(fixtureId: f.id, homeScore: 3, awayScore: 0);
        }
        expect(await run(unseeded), (ordinal: 1, over: true));
        await season.progressForTest(id);
        final resolved = await comp.drawSlots(
          id,
          0,
          CompetitionKind.continentalFinals,
          confederation: europe,
        );
        for (final p in paths) {
          expect(
            resolved
                .singleWhere(
                  (s) =>
                      s.placeholderKey == EuroPlayoffs.placeholderKey(p.letter),
                )
                .resolvedNationId,
            p.seeds[0],
          );
        }
      } else {
        final semis = await fixturesOf(
          id,
          CompetitionKind.continentalPlayoff,
          round: EuroPlayoffs.semiRound,
        );
        expect(semis, hasLength(2 * places));
        for (final f in semis) {
          expect(f.date, plan.semis);
        }
        for (final p in paths) {
          expect({
            for (final f in semis)
              if (p.seeds.contains(f.homeNationId))
                (f.homeNationId, f.awayNationId),
          }, EuroPlayoffs.semis(p).toSet());
        }
        await play(id, semis);
        await season.progressForTest(id);
        final finals = await fixturesOf(
          id,
          CompetitionKind.continentalPlayoff,
          round: EuroPlayoffs.finalRound,
        );
        expect(finals, hasLength(places));
        for (final p in paths) {
          final f = finals.singleWhere((f) => p.seeds.contains(f.homeNationId));
          final winners = [
            better(p.seeds[0], p.seeds[3]),
            better(p.seeds[1], p.seeds[2]),
          ];
          expect(f.homeNationId, winners[p.finalHostSemi]);
          expect(f.date, plan.finalDay);
        }
        await play(id, finals);
        await season.progressForTest(id);
      }

      // The EURO, from the stored draw: 24 sides, every slot's in its group.
      expect(
        await comp.hasTournament(
          id,
          CompetitionKind.continentalFinals,
          confederation: europe,
        ),
        isTrue,
      );
      final resolved = await comp.drawSlots(
        id,
        0,
        CompetitionKind.continentalFinals,
        confederation: europe,
      );
      final finalsGroups = {
        for (final t in await comp.tournamentGroupTables(
          id,
          CompetitionKind.continentalFinals,
          confederation: europe,
        ))
          t.name: {for (final s in t.standings) s.nationId},
      };
      for (final s in resolved) {
        expect(finalsGroups[s.groupName], contains(EuroPlayoffs.occupant(s)));
      }
      expect(finalsGroups.values.expand((g) => g), hasLength(24));
    });
  }
}
