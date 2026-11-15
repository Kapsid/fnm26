import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/confed_playoffs.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/qualification.dart';
import 'package:fnm/domain/services/competition/wc_playoffs.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/match/venue.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';

import '../../helpers/calendar2_draws.dart';
import '../../helpers/test_database.dart';

/// Africa's, Asia's and Oceania's World Championship qualifying play-off
/// steps on the calendar2 rhythm, every result set by hand and the season's
/// progression run one pass at a time: each step drawn and stored the day
/// qualifying is played out, every match a November fixture, and the
/// World Championship's draws made only once all of them are decided, with
/// their qualifiers in the finals and their entrants in the intercontinental
/// play-off. An unmarked cycle keeps today's ladder.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const europe = Confederation.europe;
  const africa = Confederation.africa;
  const asia = Confederation.asia;
  const oceania = Confederation.oceania;
  const kind = ConfedPlayoffs.kind;

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

  Future<void> score(int fixtureId, int h, int a) => c
      .read(competitionRepositoryProvider)
      .recordResult(fixtureId: fixtureId, homeScore: h, awayScore: a);

  /// Plays [fx] by hand: the better-ranked side wins 2-0.
  Future<void> play(Iterable<FixtureRow> fx) async {
    for (final f in fx) {
      if (f.played) continue;
      final homeBetter = rankOf[f.homeNationId]! < rankOf[f.awayNationId]!;
      await score(f.id, homeBetter ? 2 : 0, homeBetter ? 0 : 2);
    }
  }

  int better(int a, int b) => rankOf[a]! < rankOf[b]! ? a : b;
  int worse(int a, int b) => better(a, b) == a ? b : a;

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
    'the steps are drawn when qualifying ends, played in November, and '
    'the World Championship waits for them',
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
      final tables = await comp.allGroupTablesByConfederation(id);
      final grouped = <Confederation, List<List<GroupStanding>>>{};
      for (final t in tables) {
        (grouped[t.confederation] ??= []).add(t.standings);
      }
      final hosts = WorldCupHosts.hostsFor(
        year: wcYear,
        nations: nations,
        seed: career.rngSeed,
      );
      final hostBerths = WorldCupFinals.hostBerths(
        hosts: hosts,
        confederationOf: (i) => confOf[i],
        byConfederation: grouped,
      );
      List<int> entrantsOf(Confederation conf) => ConfedPlayoffs.entrants(
        conf,
        grouped[conf]!,
        hosts: hostBerths[conf] ?? 0,
      );
      final caf = entrantsOf(africa);
      final afc = entrantsOf(asia);
      final ofc = entrantsOf(oceania);
      expect(caf, hasLength(4));
      expect(afc, hasLength(6));
      expect(ofc, hasLength(2));

      await season.progressForTest(id);
      // Nothing of the World Championship is drawn while the steps run.
      expect(
        await comp.drawSlots(id, 0, CompetitionKind.worldCupFinals),
        isEmpty,
      );
      expect(
        await comp.drawSlots(id, 0, CompetitionKind.worldCupPlayoff),
        isEmpty,
      );

      // Africa: the four best runners-up, 1 v 4 and 2 v 3, at the African
      // Championship's host.
      final cafSemis = await fixturesOf(
        id,
        kind,
        round: ConfedPlayoffs.cafSemi,
        confederation: africa,
      );
      expect(cafSemis, hasLength(2));
      final seeds = ConfedPlayoffs.cafSeeds(caf, rankOf);
      expect(
        {for (final f in cafSemis) (f.homeNationId, f.awayNationId)},
        {
          (seeds[0], seeds[3]),
          (seeds[1], seeds[2]),
        },
      );
      for (final f in cafSemis) {
        expect(f.date.year, wcYear - 1);
        expect(f.date.month, 11);
      }
      final semi = (await comp.fixturesByRound(
        id,
        ConfedPlayoffs.cafSemi,
        kind: kind,
        confederation: africa,
      )).first;
      final venue = venueForFixture(
        fixture: semi,
        nations: nations,
        seed: career.rngSeed,
        cycle: 0,
      );
      expect(venue.neutral, isTrue);
      expect(
        venue.tournamentHostIds,
        WorldCupHosts.continentalHostsFor(
          confederation: africa,
          cycle: 0,
          seed: career.rngSeed,
          nations: nations,
        ),
      );

      // Asia: two groups of three, all three matchdays on the calendar.
      final afc4 = await fixturesOf(
        id,
        kind,
        round: ConfedPlayoffs.afc4,
        confederation: asia,
      );
      expect(afc4, hasLength(6));
      expect({
        for (final f in afc4) f.homeNationId,
        for (final f in afc4) f.awayNationId,
      }, afc.toSet());
      expect({for (final f in afc4) f.date}, hasLength(3));
      final afcGroups = ConfedPlayoffs.fromSlots(
        await comp.drawSlots(id, 0, kind, confederation: asia),
      );
      expect(afcGroups.keys.toSet(), {'A', 'B'});

      // Oceania: its two group winners.
      final ofcFinal = await fixturesOf(
        id,
        kind,
        round: ConfedPlayoffs.ofcFinal,
        confederation: oceania,
      );
      expect(ofcFinal, hasLength(1));
      expect({
        ofcFinal.single.homeNationId,
        ofcFinal.single.awayNationId,
      }, ofc.toSet());

      // Round one in: Africa's final and both legs of Asia's fifth round.
      await play([...cafSemis, ...afc4, ...ofcFinal]);
      await season.progressForTest(id);
      expect(
        await comp.drawSlots(id, 0, CompetitionKind.worldCupFinals),
        isEmpty,
      );
      final cafFinal = await fixturesOf(
        id,
        kind,
        round: ConfedPlayoffs.cafFinal,
        confederation: africa,
      );
      expect(cafFinal, hasLength(1));
      expect(
        {cafFinal.single.homeNationId, cafFinal.single.awayNationId},
        {
          better(seeds[0], seeds[3]),
          better(seeds[1], seeds[2]),
        },
      );
      final leg1 = await fixturesOf(
        id,
        kind,
        round: ConfedPlayoffs.afc5Leg1,
        confederation: asia,
      );
      final leg2 = await fixturesOf(
        id,
        kind,
        round: ConfedPlayoffs.afc5Leg2,
        confederation: asia,
      );
      expect(leg1, hasLength(1));
      expect(leg2, hasLength(1));
      // Each group's runner-up: the middle-ranked side (better wins all).
      final runnersUp = {
        for (final sides in afcGroups.values)
          ([...sides]..sort((a, b) => rankOf[a]!.compareTo(rankOf[b]!)))[1],
      };
      final groupWinners = {
        for (final sides in afcGroups.values)
          ([...sides]..sort((a, b) => rankOf[a]!.compareTo(rankOf[b]!)))[0],
      };
      expect({leg1.single.homeNationId, leg1.single.awayNationId}, runnersUp);
      // The first leg at the lower-ranked side's, the second back the
      // other way, later.
      expect(
        leg1.single.homeNationId,
        worse(leg1.single.homeNationId, leg1.single.awayNationId),
      );
      expect(leg2.single.homeNationId, leg1.single.awayNationId);
      expect(leg2.single.awayNationId, leg1.single.homeNationId);
      expect(leg2.single.date.isAfter(leg1.single.date), isTrue);

      // The underdog wins the first leg 2-0 at home and loses 3-0 away: the
      // favourite through on aggregate.
      await score(leg1.single.id, 2, 0);
      await play(cafFinal);
      await season.progressForTest(id);
      expect(
        await comp.drawSlots(id, 0, CompetitionKind.worldCupFinals),
        isEmpty,
      );
      await score(leg2.single.id, 3, 0);
      await season.progressForTest(id);

      // Every step decided: the draws are made.
      final slots = await comp.drawSlots(id, 0, CompetitionKind.worldCupFinals);
      expect(slots, hasLength(48));
      final named = {
        for (final s in slots)
          if (s.nationId != null) s.nationId!,
      };
      final ic = IcPlayoffs.fromSlots(
        await comp.drawSlots(id, 0, CompetitionKind.worldCupPlayoff),
      );
      final icSides = {for (final p in ic) ...IcPlayoffs.members(p)};
      expect(icSides, hasLength(6));
      final cafWinner = better(
        cafFinal.single.homeNationId,
        cafFinal.single.awayNationId,
      );
      final afcWinner = leg2.single.homeNationId;
      final ofcLoser = worse(
        ofcFinal.single.homeNationId,
        ofcFinal.single.awayNationId,
      );
      final ofcWinner = better(
        ofcFinal.single.homeNationId,
        ofcFinal.single.awayNationId,
      );
      expect(icSides, containsAll([cafWinner, afcWinner, ofcLoser]));
      expect(named, containsAll([...groupWinners, ofcWinner]));
      expect(named.intersection({...runnersUp, ofcLoser, ...caf}), isEmpty);

      // Each confederation sends its allocation, less its hosts.
      int sent(Confederation conf) =>
          named.where((n) => confOf[n] == conf && !hosts.contains(n)).length;
      expect(sent(asia), 8 - (hostBerths[asia] ?? 0));
      expect(sent(oceania), 1 - (hostBerths[oceania] ?? 0));
      expect(sent(africa), 9 - (hostBerths[africa] ?? 0));
      // Asia's groups handed out six of them.
      expect(
        named.intersection(
          Qualification.qualifiers(
            grouped[asia]!,
            ConfedPlayoffs.groupBerths(asia, hostBerths[asia] ?? 0),
          ).toSet(),
        ),
        hasLength(ConfedPlayoffs.groupBerths(asia, hostBerths[asia] ?? 0)),
      );

      // The board: a fourth-round winner is through, a beaten step side out.
      Future<({int ordinal, bool over})> run(int nation) async => worldRun(
        comp: comp,
        careerId: id,
        nationId: nation,
        fixtures: await comp.cycleFixturesForNation(id, nation),
        cycle: 0,
      );
      expect(await run(groupWinners.first), (ordinal: 2, over: false));
      expect(await run(afcWinner), (ordinal: 1, over: false));
      expect(await run(leg1.single.homeNationId), (ordinal: 0, over: true));
    },
  );

  test('a manager in a step plays it: never dated behind his clock, and '
      'told where he stands', () async {
    final africans = [
      for (final n in nations)
        if (n.confederation == africa) n,
    ]..sort((a, b) => a.ranking.compareTo(b.ranking));
    // Find an African side the hand-played qualifying sends to the step.
    final probe = await create(africans.first.id);
    await playQualifying(probe);
    final comp = c.read(competitionRepositoryProvider);
    final groups = [
      for (final t in await comp.allGroupTablesByConfederation(probe))
        if (t.confederation == africa) t.standings,
    ];
    final career0 = (await c.read(careerRepositoryProvider).byId(probe))!;
    final hosts = WorldCupHosts.hostsFor(
      year: CareerService.worldCupYear(0),
      nations: nations,
      seed: career0.rngSeed,
    );
    final entrant = ConfedPlayoffs.entrants(
      africa,
      groups,
      hosts: hosts.where((h) => confOf[h] == africa).length,
    ).first;

    final id = await create(entrant);
    await playQualifying(id);
    final career = (await c.read(careerRepositoryProvider).byId(id))!;
    final late = DateTime(career.inGameDate.year + 3, 11, 20);
    await c.read(careerRepositoryProvider).updateInGameDate(id, late);
    await c.read(seasonServiceProvider).progressForTest(id);
    final mine = [
      for (final f in await fixturesOf(
        id,
        kind,
        round: ConfedPlayoffs.cafSemi,
        confederation: africa,
      ))
        if (f.homeNationId == entrant || f.awayNationId == entrant) f,
    ];
    expect(mine, hasLength(1));
    expect(mine.single.date.isAfter(late), isTrue);
    final news = await (db.select(
      db.messages,
    )..where((t) => t.careerId.equals(id))).get();
    expect(
      news.any(
        (m) => m.dedupKey == 'confplayoff:${CareerService.worldCupYear(0)}',
      ),
      isTrue,
    );
  });

  test(
    'an unmarked cycle keeps the ladder: no step, no step fixture',
    () async {
      final europeans = [
        for (final n in nations)
          if (n.confederation == europe) n,
      ]..sort((a, b) => a.ranking.compareTo(b.ranking));
      final id = await create(europeans[20].id, calendar2: false);
      final comp = c.read(competitionRepositoryProvider);
      await drawWcQualifyingNow(c, id);
      await play(await fixturesOf(id, CompetitionKind.worldCupQualifying));
      await c.read(seasonServiceProvider).progressForTest(id);
      expect(await comp.hasFinals(id), isTrue);
      expect(await fixturesOf(id, kind), isEmpty);
      for (final conf in ConfedPlayoffs.confederations) {
        expect(await comp.drawSlots(id, 0, kind, confederation: conf), isEmpty);
      }
    },
  );
}
