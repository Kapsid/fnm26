import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/calendar2.dart';
import 'package:fnm/domain/services/competition/euro_playoffs.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/wc_playoffs.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/match/venue.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/tournaments/playoff_paths.dart';
import 'package:fnm/features/tournaments/wc_host_berths.dart';

import '../../helpers/calendar2_draws.dart';
import '../../helpers/test_database.dart';

/// The World Championship's play-offs on the calendar2 rhythm, every result
/// set by hand (the better-ranked side wins) and the season's progression run
/// one pass at a time: three draws stored when qualifying ends, every path a
/// real fixture in late March, and the finals created from the stored draw
/// with each winner in the exact slot its placeholder was drawn into. An
/// unmarked cycle keeps today's qualification and play-off.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const europe = Confederation.europe;

  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List<dynamic>)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList();
  final rankOf = {for (final n in nations) n.id: n.ranking};
  final confOf = {for (final n in nations) n.id: n.confederation};

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

  Future<int> create(int nationId, {bool calendar2 = true}) async {
    final career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: nationId,
                  managerName: 'M',
                  rngSeed: 4242,
                  calendar2: calendar2,
                ))
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
    Confederation? confederation,
  }) async {
    final comps =
        await (db.select(db.competitions)..where(
              (t) =>
                  t.careerId.equals(id) &
                  t.kind.equalsValue(kind) &
                  (confederation == null
                      ? const Constant(true)
                      : t.confederation.equalsValue(confederation)),
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

  /// Plays [fx] by hand: the better-ranked side wins 2-0, unless [upset].
  Future<void> play(Iterable<FixtureRow> fx, {bool upset = false}) async {
    final comp = c.read(competitionRepositoryProvider);
    for (final f in fx) {
      if (f.played) continue;
      final homeBetter = rankOf[f.homeNationId]! < rankOf[f.awayNationId]!;
      final homeWins = upset ? !homeBetter : homeBetter;
      await comp.recordResult(
        fixtureId: f.id,
        homeScore: homeWins ? 2 : 0,
        awayScore: homeWins ? 0 : 2,
      );
    }
  }

  int better(int a, int b) => rankOf[a]! < rankOf[b]! ? a : b;
  int worse(int a, int b) => better(a, b) == a ? b : a;

  /// Qualifying everywhere and Europe's second Nations Cup, played.
  Future<void> playQualifying(int id) async {
    await drawSecondNationsCupNow(c, id);
    await play(
      await fixturesOf(
        id,
        CompetitionKind.nationsLeague,
        round: 'NGROUP',
        confederation: europe,
      ),
    );
    await drawWcQualifyingNow(c, id);
    await play(await fixturesOf(id, CompetitionKind.worldCupQualifying));
  }

  test(
    'qualifying ends: three draws stored, every path on the calendar in '
    'March; the finals created from the stored draw, slot for slot',
    () async {
      final europeans = [
        for (final n in nations)
          if (n.confederation == europe) n,
      ]..sort((a, b) => a.ranking.compareTo(b.ranking));
      final id = await create(europeans[20].id);
      final comp = c.read(competitionRepositoryProvider);
      final season = c.read(seasonServiceProvider);
      final wcYear = CareerService.worldCupYear(0);
      final career = (await c.read(careerRepositoryProvider).byId(id))!;

      await playQualifying(id);
      // Europe plays twelve groups on the calendar2 rhythm.
      final tables = await comp.allGroupTablesByConfederation(id);
      final euroGroups = [
        for (final t in tables)
          if (t.confederation == europe) t.standings,
      ];
      expect(euroGroups, hasLength(12));

      // Africa's, Asia's and Oceania's own steps first (see
      // confed_playoffs_flow_test): the draws wait for them.
      await playConfedStepsNow(c, id);
      expect(await comp.hasFinals(id), isFalse);

      final hosts = WorldCupHosts.hostsFor(
        year: wcYear,
        nations: nations,
        seed: career.rngSeed,
      );
      final grouped = <Confederation, List<List<GroupStanding>>>{};
      for (final t in tables) {
        (grouped[t.confederation] ??= []).add(t.standings);
      }
      final hostBerths = WorldCupFinals.hostBerths(
        hosts: hosts,
        confederationOf: (i) => confOf[i],
        byConfederation: grouped,
      );
      final count = UefaWcPlayoffs.pathsFor(
        calendar2: true,
        confederation: europe,
        hosts: hostBerths[europe] ?? 0,
        groupCount: 12,
      );
      expect(count, greaterThan(0));

      // Europe's paths: three runners-up and a Nations Cup side each.
      final uefa = EuroPlayoffs.fromSlots(
        await comp.drawSlots(
          id,
          0,
          CompetitionKind.worldCupPlayoffEurope,
          confederation: europe,
        ),
      );
      expect(uefa, hasLength(count));
      final winners = {for (final g in euroGroups) g.first.nationId};
      final runnersUp = {for (final g in euroGroups) g[1].nationId};
      for (final p in uefa) {
        expect(p.seeds.take(3).every(runnersUp.contains), isTrue);
        expect(runnersUp.contains(p.seeds[3]), isFalse);
        expect(winners.contains(p.seeds[3]), isFalse);
        expect(confOf[p.seeds[3]], europe);
      }

      // The intercontinental paths: six sides, none European.
      final ic = IcPlayoffs.fromSlots(
        await comp.drawSlots(id, 0, CompetitionKind.worldCupPlayoff),
      );
      expect(ic, hasLength(2));
      final icSides = {for (final p in ic) ...IcPlayoffs.members(p)};
      expect(icSides, hasLength(6));
      expect(icSides.any((n) => confOf[n] == europe), isFalse);
      // Seeded on the play-off's frozen ranking, as the legacy bracket is.
      final icRank = await c
          .read(seedRankingRepositoryProvider)
          .forCycle(id, drawSeedCycle(0, drawSlotWorldCupPlayoff));
      for (final p in ic) {
        final path = playoffPathOf(
          pool: icSides.toList(),
          rankingById: icRank,
          nationId: p.seed,
        );
        expect(path?.semiSlot, isNull, reason: 'a seed waits in its final');
      }

      // The finals' draw: 48 slots, six placeholders in pot 4, every group
      // winner and host by name, no play-off side.
      final slots = await comp.drawSlots(id, 0, CompetitionKind.worldCupFinals);
      expect(slots, hasLength(48));
      final placeholders = [
        for (final s in slots)
          if (s.placeholderKey != null) s,
      ];
      expect(placeholders, hasLength(count + 2));
      for (final s in placeholders) {
        expect(s.position, 3, reason: 'pot 4');
      }
      final named = {
        for (final s in slots)
          if (s.nationId != null) s.nationId!,
      };
      expect(named, hasLength(48 - count - 2));
      expect(named.containsAll(winners), isTrue);
      expect(named.containsAll(hosts), isTrue);
      for (final p in uefa) {
        expect(named.intersection(p.seeds.toSet()), isEmpty);
      }
      expect(named.intersection(icSides), isEmpty);

      // The board reads the stored draw.
      Future<({int ordinal, bool over})> run(int nation) async => worldRun(
        comp: comp,
        careerId: id,
        nationId: nation,
        fixtures: await comp.cycleFixturesForNation(id, nation),
        cycle: 0,
      );
      expect(await run(winners.first), (ordinal: 2, over: false));
      expect(await run(uefa.first.seeds.last), (ordinal: 1, over: false));
      expect(await run(ic.first.semiHome), (ordinal: 1, over: false));
      final outsider = europeans
          .map((n) => n.id)
          .where(
            (n) => !named.contains(n) && !uefa.any((p) => p.seeds.contains(n)),
          )
          .first;
      expect(await run(outsider), (ordinal: 0, over: true));

      // The semi-finals: real fixtures on 26 March; the intercontinental ones
      // played in the finals' host nation.
      final dates = Calendar2.wcPlayoffs(wcYear);
      final uSemis = await fixturesOf(
        id,
        CompetitionKind.worldCupPlayoffEurope,
        round: UefaWcPlayoffs.semiRound,
      );
      final iSemis = await fixturesOf(
        id,
        CompetitionKind.worldCupPlayoff,
        round: IcPlayoffs.semiRound,
      );
      expect(uSemis, hasLength(2 * count));
      expect(iSemis, hasLength(2));
      for (final f in [...uSemis, ...iSemis]) {
        expect(f.date, dates.semis);
      }
      for (final p in uefa) {
        expect(
          {
            for (final f in uSemis)
              if (p.seeds.contains(f.homeNationId))
                (f.homeNationId, f.awayNationId),
          },
          EuroPlayoffs.semis(p).toSet(),
        );
      }
      final venue = venueForFixture(
        fixture: (await comp.fixturesByRound(
          id,
          IcPlayoffs.semiRound,
          kind: CompetitionKind.worldCupPlayoff,
        )).first,
        nations: nations,
        seed: career.rngSeed,
        cycle: 0,
      );
      expect(venue.neutral, isTrue);
      expect(venue.tournamentHostIds, hosts);

      // Semis played: every path's final on 31 March, at the drawn host.
      await play([...uSemis, ...iSemis]);
      // A beaten semi-finalist is out on the board's reading.
      final beaten = worse(uefa.first.seeds[0], uefa.first.seeds[3]);
      expect(await run(beaten), (ordinal: 1, over: true));
      await season.progressForTest(id);
      final uFinals = await fixturesOf(
        id,
        CompetitionKind.worldCupPlayoffEurope,
        round: UefaWcPlayoffs.finalRound,
      );
      final iFinals = await fixturesOf(
        id,
        CompetitionKind.worldCupPlayoff,
        round: IcPlayoffs.finalRound,
      );
      expect(uFinals, hasLength(count));
      expect(iFinals, hasLength(2));
      for (final p in uefa) {
        final f = uFinals.singleWhere((f) => p.seeds.contains(f.homeNationId));
        final w = [
          better(p.seeds[0], p.seeds[3]),
          better(p.seeds[1], p.seeds[2]),
        ];
        expect(f.homeNationId, w[p.finalHostSemi]);
        expect(f.awayNationId, w[1 - p.finalHostSemi]);
        expect(f.date, dates.finalDay);
      }
      for (final p in ic) {
        final f = iFinals.singleWhere((f) => f.homeNationId == p.seed);
        expect(f.awayNationId, better(p.semiHome, p.semiAway));
      }
      expect(await comp.hasFinals(id), isFalse);

      // Finals played, upsets all round: the finals exist, each winner in the
      // group AND place its placeholder held.
      await play([...uFinals, ...iFinals], upset: true);
      await season.progressForTest(id);
      expect(await comp.hasFinals(id), isTrue);
      final resolved = await comp.drawSlots(
        id,
        0,
        CompetitionKind.worldCupFinals,
      );
      final groups = {
        for (final t in await comp.finalsGroupTables(id))
          t.name: [for (final s in t.standings) s.nationId],
      };
      for (final f in [...uFinals, ...iFinals]) {
        final winner = worse(f.homeNationId, f.awayNationId);
        final slot = resolved.singleWhere((s) => s.resolvedNationId == winner);
        expect(groups[slot.groupName], contains(winner));
      }
      final finalsDraw = EuroPlayoffs.resolvedDraw(resolved, rngSeed: 1);
      for (final g in finalsDraw.groups) {
        expect(groups[g.name]!.toSet(), g.nationIds.toSet());
      }
      expect(groups.values.expand((g) => g).toSet(), hasLength(48));
      final group = await fixturesOf(
        id,
        CompetitionKind.worldCupFinals,
        round: 'GROUP',
      );
      expect(group, hasLength(72));
      for (final f in group) {
        expect(f.date.year, wcYear);
        expect(f.date.month >= 6, isTrue);
      }

      // The career bundle carries the stored draws.
      final bundle = await CareerBundle.export(db, id);
      final copy = await CareerBundle.import(db, bundle);
      expect(
        await comp.drawSlots(copy, 0, CompetitionKind.worldCupFinals),
        resolved,
      );
      expect(
        IcPlayoffs.fromSlots(
          await comp.drawSlots(copy, 0, CompetitionKind.worldCupPlayoff),
        ),
        ic,
      );
    },
  );

  test('an unmarked cycle keeps its qualification, its modelled play-off '
      'and its finals timing exactly', () async {
    final europeans = [
      for (final n in nations)
        if (n.confederation == europe) n,
    ]..sort((a, b) => a.ranking.compareTo(b.ranking));
    final id = await create(europeans[20].id, calendar2: false);
    final comp = c.read(competitionRepositoryProvider);
    final career = (await c.read(careerRepositoryProvider).byId(id))!;
    expect(await comp.hasWatchedDraw(id, 0, Calendar2.kind), isFalse);

    await drawWcQualifyingNow(c, id);
    final tables = await comp.allGroupTablesByConfederation(id);
    // Groups of five, as always: eleven of them.
    expect(tables.where((t) => t.confederation == europe), hasLength(11));
    await play(await fixturesOf(id, CompetitionKind.worldCupQualifying));
    await c.read(seasonServiceProvider).progressForTest(id);

    // The finals at once, no stored draw, no play-off fixtures.
    expect(await comp.hasFinals(id), isTrue);
    for (final kind in CompetitionKind.values) {
      expect(await comp.drawSlots(id, 0, kind), isEmpty);
      expect(await comp.drawSlots(id, 0, kind, confederation: europe), isEmpty);
    }
    expect(
      await fixturesOf(id, CompetitionKind.worldCupPlayoffEurope),
      isEmpty,
    );
    for (final round in IcPlayoffs.rounds) {
      expect(
        await comp.fixturesByRound(
          id,
          round,
          kind: CompetitionKind.worldCupPlayoff,
        ),
        isEmpty,
      );
    }
    // The legacy play-off stream is still stamped (see wcPlayoffStreamKind).
    expect(await comp.hasWatchedDraw(id, 0, wcPlayoffStreamKind), isTrue);

    // The field is today's selection: Europe's sixteen off the ladder and
    // the modelled play-off's two winners.
    final grouped = <Confederation, List<List<GroupStanding>>>{};
    for (final t in await comp.allGroupTablesByConfederation(id)) {
      (grouped[t.confederation] ??= []).add(t.standings);
    }
    final wcYear = CareerService.worldCupYear(0);
    final rank = await c
        .read(seedRankingRepositoryProvider)
        .forCycle(id, drawSeedCycle(0, drawSlotWorldCupFinals));
    final expected = WorldCupFinals.selectFinalists(
      byConfederation: grouped,
      rankingById: rank,
      hosts: WorldCupHosts.hostsFor(
        year: wcYear,
        nations: nations,
        seed: career.rngSeed,
      ),
      hostBerths: await resolveWorldCupHostBerths(
        comp: comp,
        seedRanks: c.read(seedRankingRepositoryProvider),
        career: career,
        nations: {for (final n in nations) n.id: n},
        byConfederation: grouped,
      ),
      playoffWinnersOverride: WorldCupFinals.playoffWinners(
        WorldCupFinals.playoffPoolFor(
          byConfederation: grouped,
          rankingById: await c
              .read(seedRankingRepositoryProvider)
              .forCycle(id, drawSeedCycle(0, drawSlotWorldCupPlayoff)),
          hostBerths: await resolveWorldCupHostBerths(
            comp: comp,
            seedRanks: c.read(seedRankingRepositoryProvider),
            career: career,
            nations: {for (final n in nations) n.id: n},
            byConfederation: grouped,
          ),
        ),
        await c
            .read(seedRankingRepositoryProvider)
            .forCycle(id, drawSeedCycle(0, drawSlotWorldCupPlayoff)),
        SeededRng(career.rngSeed ^ 0xB1A0),
      ),
    );
    final field = {
      for (final t in await comp.finalsGroupTables(id))
        for (final s in t.standings) s.nationId,
    };
    expect(field, expected.toSet());
    // The group stage opens on 11 June, as before.
    final group = await fixturesOf(
      id,
      CompetitionKind.worldCupFinals,
      round: 'GROUP',
    );
    final first = group
        .map((f) => f.date)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    expect(first, DateTime(wcYear, 6, 11));
  });
}
