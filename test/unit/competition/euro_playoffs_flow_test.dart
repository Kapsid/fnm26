import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/calendar2.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/euro_playoffs.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/qualification.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';

import '../../helpers/calendar2_draws.dart';
import '../../helpers/test_database.dart';

/// Europe's play-offs on the calendar2 rhythm, with every result set by hand
/// (the better-ranked side wins) and the season's progression run one pass
/// at a time: the draws are stored when qualifying ends, the paths are real
/// fixtures, and the EURO is created from the stored draw, each path's
/// winner in the slot its placeholder was drawn into. An unmarked cycle
/// keeps today's straight-from-the-tables field.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const europe = Confederation.europe;

  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List<dynamic>)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList();
  final rankOf = {for (final n in nations) n.id: n.ranking};

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
    final career = (await c
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

  Future<List<int>> euroHosts(int id) async {
    final career = (await c.read(careerRepositoryProvider).byId(id))!;
    return WorldCupHosts.continentalHostsFor(
      confederation: europe,
      cycle: career.cyclePointer,
      seed: career.rngSeed,
      nations: await c.read(nationRepositoryProvider).forCareer(id),
    );
  }

  test('qualifying ends: both draws stored, paths on the calendar; '
      'the play-offs resolve into the exact slots', () async {
    final europeans = [
      for (final n in nations)
        if (n.confederation == europe) n,
    ]..sort((a, b) => a.ranking.compareTo(b.ranking));
    final id = await create(europeans[20].id);
    final comp = c.read(competitionRepositoryProvider);
    final season = c.read(seasonServiceProvider);
    final wcYear = CareerService.worldCupYear(0);

    // The first Nations Cup's league phase, then Euro qualifying, played.
    await play(
      await fixturesOf(id, CompetitionKind.nationsLeague, round: 'NGROUP'),
    );
    await drawEuroQualifyingNow(c, id);
    await play(await fixturesOf(id, CompetitionKind.continentalQualifying));
    await season.progressForTest(id);

    final hosts = await euroHosts(id);
    final tables = await comp.tournamentGroupTables(
      id,
      CompetitionKind.continentalQualifying,
      confederation: europe,
    );
    final count = EuroPlayoffs.pathCount(
      size: 24,
      hosts: hosts.length,
      groupCount: tables.length,
    );
    expect(count, greaterThan(0));

    // The paths, stored: four sides each, none qualified or hosting.
    final paths = EuroPlayoffs.fromSlots(
      await comp.drawSlots(
        id,
        0,
        CompetitionKind.continentalPlayoff,
        confederation: europe,
      ),
    );
    expect(paths, hasLength(count));
    final direct = Qualification.qualifiers([
      for (final t in tables) t.standings,
    ], 24 - hosts.length - count);
    for (final p in paths) {
      expect(p.seeds, hasLength(4));
      expect(p.seeds.toSet().intersection({...direct, ...hosts}), isEmpty);
    }
    expect(paths.first.letter, 'A');

    // The EURO's draw, stored: 24 slots, a placeholder per path in pot 4,
    // every direct qualifier and host by name. No finals yet.
    final slots = await comp.drawSlots(
      id,
      0,
      CompetitionKind.continentalFinals,
      confederation: europe,
    );
    expect(slots, hasLength(24));
    final placeholders = [
      for (final s in slots)
        if (s.placeholderKey != null) s,
    ];
    expect(placeholders, hasLength(count));
    for (final s in placeholders) {
      expect(s.position, 3, reason: 'pot 4');
      expect(s.nationId, isNull);
    }
    expect(
      {
        for (final s in slots)
          if (s.nationId != null) s.nationId,
      },
      {...direct, ...hosts},
    );
    expect(
      await comp.hasTournament(
        id,
        CompetitionKind.continentalFinals,
        confederation: europe,
      ),
      isFalse,
    );

    // The board reads the stored draw: a direct qualifier is through, an
    // entrant is a rung below, anybody else is out.
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
    final entrant = paths.first.seeds.last;
    expect(await run(entrant), (ordinal: 1, over: false));
    final outsider = europeans
        .map((n) => n.id)
        .where(
          (n) =>
              !direct.contains(n) &&
              !hosts.contains(n) &&
              !paths.any((p) => p.seeds.contains(n)),
        )
        .first;
    expect(await run(outsider), (ordinal: 0, over: true));

    // The semi-finals: real fixtures on 21 March, seed 1 and 2 at home.
    final semis = await fixturesOf(
      id,
      CompetitionKind.continentalPlayoff,
      round: EuroPlayoffs.semiRound,
    );
    expect(semis, hasLength(2 * count));
    final plan = Calendar2.euroPlayoffs(wcYear);
    for (final f in semis) {
      expect(f.date, plan.semis);
    }
    for (final p in paths) {
      expect(
        {
          for (final f in semis)
            if (p.seeds.contains(f.homeNationId))
              (f.homeNationId, f.awayNationId),
        },
        EuroPlayoffs.semis(p).toSet(),
      );
    }

    // Semis played: each path's final, at the drawn semi winner's home.
    await play(semis);
    await season.progressForTest(id);
    final finals = await fixturesOf(
      id,
      CompetitionKind.continentalPlayoff,
      round: EuroPlayoffs.finalRound,
    );
    expect(finals, hasLength(count));
    for (final p in paths) {
      final f = finals.singleWhere((f) => p.seeds.contains(f.homeNationId));
      // Each semi went to the better-ranked side; the drawn one hosts.
      int better(int a, int b) => rankOf[a]! < rankOf[b]! ? a : b;
      final winners = [
        better(p.seeds[0], p.seeds[3]),
        better(p.seeds[1], p.seeds[2]),
      ];
      expect(f.homeNationId, winners[p.finalHostSemi]);
      expect(f.awayNationId, winners[1 - p.finalHostSemi]);
      expect(f.date, plan.finalDay);
    }
    expect(
      await comp.hasTournament(
        id,
        CompetitionKind.continentalFinals,
        confederation: europe,
      ),
      isFalse,
      reason: 'no finals until every path is won',
    );

    // Finals played (upsets, the worse-ranked side winning): the EURO
    // exists, each winner in its placeholder's group and place.
    await play(finals, upset: true);
    await season.progressForTest(id);
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
    final groups = {
      for (final t in await comp.tournamentGroupTables(
        id,
        CompetitionKind.continentalFinals,
        confederation: europe,
      ))
        t.name: {for (final s in t.standings) s.nationId},
    };
    for (final p in paths) {
      final f = finals.singleWhere((f) => p.seeds.contains(f.homeNationId));
      // The upset: the worse-ranked side won.
      final winner = rankOf[f.homeNationId]! > rankOf[f.awayNationId]!
          ? f.homeNationId
          : f.awayNationId;
      final slot = resolved.singleWhere(
        (s) => s.placeholderKey == EuroPlayoffs.placeholderKey(p.letter),
      );
      expect(slot.resolvedNationId, winner);
      expect(groups[slot.groupName], contains(winner));
    }
    // Every stored slot's side, in its stored group, and nobody else.
    for (final s in resolved) {
      expect(groups[s.groupName], contains(EuroPlayoffs.occupant(s)));
    }
    expect(groups.values.expand((g) => g), hasLength(24));
    // The group stage in June, as before.
    final euro = await fixturesOf(id, CompetitionKind.continentalFinals);
    expect(euro, hasLength(36));
    for (final f in euro) {
      expect(f.date.year, wcYear - 2);
      expect(f.date.month >= 6, isTrue);
    }

    // The career bundle carries the stored draws.
    final bundle = await CareerBundle.export(db, id);
    final copy = await CareerBundle.import(db, bundle);
    expect(
      await comp.drawSlots(
        copy,
        0,
        CompetitionKind.continentalFinals,
        confederation: europe,
      ),
      resolved,
    );
    expect(
      EuroPlayoffs.fromSlots(
        await comp.drawSlots(
          copy,
          0,
          CompetitionKind.continentalPlayoff,
          confederation: europe,
        ),
      ).map((p) => p.seeds),
      paths.map((p) => p.seeds),
    );
  });

  test('an unmarked cycle keeps its EURO straight from the tables', () async {
    final europeans = [
      for (final n in nations)
        if (n.confederation == europe) n,
    ]..sort((a, b) => a.ranking.compareTo(b.ranking));
    final id = await create(europeans[20].id, calendar2: false);
    final comp = c.read(competitionRepositoryProvider);
    expect(await comp.hasWatchedDraw(id, 0, Calendar2.kind), isFalse);

    await play(await fixturesOf(id, CompetitionKind.continentalQualifying));
    await c.read(seasonServiceProvider).progressForTest(id);

    expect(
      await comp.hasTournament(
        id,
        CompetitionKind.continentalFinals,
        confederation: europe,
      ),
      isTrue,
    );
    expect(
      await comp.hasTournament(
        id,
        CompetitionKind.continentalPlayoff,
        confederation: europe,
      ),
      isFalse,
    );
    for (final kind in CompetitionKind.values) {
      expect(
        await comp.drawSlots(id, 0, kind, confederation: europe),
        isEmpty,
      );
    }
    final hosts = await euroHosts(id);
    final tables = await comp.tournamentGroupTables(
      id,
      CompetitionKind.continentalQualifying,
      confederation: europe,
    );
    final expected = {
      ...Qualification.qualifiers([
        for (final t in tables) t.standings,
      ], ContinentalCups.byConfederation[europe]!.size - hosts.length),
      ...hosts,
    };
    final field = {
      for (final t in await comp.tournamentGroupTables(
        id,
        CompetitionKind.continentalFinals,
        confederation: europe,
      ))
        for (final s in t.standings) s.nationId,
    };
    expect(field, expected);
  });
}
