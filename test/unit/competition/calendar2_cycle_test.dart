@Tags(['slow'])
library;

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
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../../helpers/test_database.dart';

/// A new career on the calendar2 rhythm, advanced through its whole first
/// cycle (no squads, so every match is the background sim): every event lands
/// on its new dates, Europe plays two Nations Cups whose ladder moves after
/// each, and the cycle rolls into another calendar2 cycle.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a calendar2 cycle plays out on its new dates', () async {
    final db = createTestDatabase();
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(c.dispose);
    addTearDown(db.close);
    await c.read(seedLoaderProvider).ensureSeeded();

    // A mid-ranked European side: in League B, away from any Finals Four.
    final europeans = [
      for (final n in nations)
        if (n.confederation == Confederation.europe) n,
    ]..sort((a, b) => a.ranking.compareTo(b.ranking));
    final me = europeans[25];
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: me.id, managerName: 'M', rngSeed: 4242))
            .valueOrNull!;
    final id = career.id;
    final comp = c.read(competitionRepositoryProvider);
    final careers = c.read(careerRepositoryProvider);
    final season = c.read(seasonServiceProvider);
    await comp.markDrawWatched(id, 0, budgetSetupKind);

    expect(await comp.hasWatchedDraw(id, 0, calendar2Kind), isTrue);

    // Every fixture of one competition kind/confederation/edition.
    Future<List<FixtureRow>> fixturesOf(
      CompetitionKind kind,
      Confederation conf, {
      int? edition,
      int cycle = 0,
    }) async {
      final comps =
          await (db.select(db.competitions)..where(
                (t) =>
                    t.careerId.equals(id) &
                    t.cycle.equals(cycle) &
                    t.kind.equalsValue(kind) &
                    t.confederation.equalsValue(conf),
              ))
              .get();
      final ids = [
        for (final r in comps)
          if (edition == null || r.edition == edition) r.id,
      ];
      if (ids.isEmpty) return const [];
      return (db.select(db.fixtures)
            ..where((t) => t.competitionId.isIn(ids))
            ..orderBy([(t) => OrderingTerm(expression: t.date)]))
          .get();
    }

    void inSpan(List<FixtureRow> fx, DateTime from, DateTime to, String what) {
      expect(fx, isNotEmpty, reason: what);
      for (final f in fx) {
        expect(
          !f.date.isBefore(from) && !f.date.isAfter(to),
          isTrue,
          reason: '$what: ${f.date}',
        );
      }
    }

    // Day one: Europe's first Nations Cup in the autumn of 2026, nothing of
    // Euro qualifying yet; the other cups and campaigns where they were.
    const europe = Confederation.europe;
    inSpan(
      await fixturesOf(CompetitionKind.nationsLeague, europe, edition: 0),
      DateTime(2026, 9),
      DateTime(2026, 11, 30),
      'NC edition 1',
    );
    expect(
      await fixturesOf(CompetitionKind.continentalQualifying, europe),
      isEmpty,
    );
    inSpan(
      await fixturesOf(
        CompetitionKind.nationsLeague,
        Confederation.northAmerica,
      ),
      DateTime(2028, 9),
      DateTime(2028, 11, 30),
      'North America cup',
    );
    inSpan(
      await fixturesOf(
        CompetitionKind.continentalQualifying,
        Confederation.africa,
      ),
      DateTime(2026, 9),
      DateTime(2027, 6, 30),
      'African qualifying',
    );
    expect(
      await comp.hasTournament(id, CompetitionKind.worldCupQualifying),
      isFalse,
    );
    final tiersAtStart = await careers.nationsCupTiers(id);

    // Advance through the cycle, noting what happens when.
    DateTime? euroQualDrawnOn;
    DateTime? secondCupDrawnOn;
    DateTime? conmebolDrawnOn;
    DateTime? wcQualDrawnOn;
    var last = DateTime(1900);
    for (var i = 0; i < 3000; i++) {
      if (await comp.worldChampion(id) != null) break;
      final at = (await careers.byId(id))!.inGameDate;
      if (euroQualDrawnOn == null &&
          await comp.hasTournament(
            id,
            CompetitionKind.continentalQualifying,
            confederation: europe,
          )) {
        euroQualDrawnOn = at;
        // Drawn once the first league phase is played, ladder moved first.
        final group = await fixturesOf(
          CompetitionKind.nationsLeague,
          europe,
          edition: 0,
        );
        expect(
          group.where((f) => f.round == 'NGROUP').every((f) => f.played),
          isTrue,
        );
        expect(await comp.hasWatchedDraw(id, 0, 'ncLadder:e0'), isTrue);
      }
      if (secondCupDrawnOn == null &&
          await comp.hasTournament(
            id,
            CompetitionKind.nationsLeague,
            confederation: europe,
            edition: 1,
          )) {
        secondCupDrawnOn = at;
      }
      if (conmebolDrawnOn == null &&
          await comp.hasTournament(
            id,
            CompetitionKind.worldCupQualifying,
            confederation: Confederation.southAmerica,
          )) {
        conmebolDrawnOn = at;
      }
      if (wcQualDrawnOn == null &&
          await comp.hasTournament(
            id,
            CompetitionKind.worldCupQualifying,
            confederation: europe,
          )) {
        wcQualDrawnOn = at;
      }
      await season.advance(id);
      final now = (await careers.byId(id))!.inGameDate;
      expect(now.isBefore(last), isFalse, reason: 'the clock never goes back');
      last = now;
    }
    expect(await comp.worldChampion(id), isNotNull, reason: 'cycle finished');

    // The draws, each in its turn.
    expect(euroQualDrawnOn, isNotNull);
    expect(euroQualDrawnOn!.isBefore(DateTime(2027)), isTrue);
    expect(euroQualDrawnOn.isAfter(DateTime(2026, 11)), isTrue);
    expect(secondCupDrawnOn, isNotNull);
    expect(secondCupDrawnOn!.isBefore(DateTime(2027, 7)), isFalse);
    expect(secondCupDrawnOn.isBefore(DateTime(2028)), isTrue);
    expect(conmebolDrawnOn, isNotNull);
    expect(conmebolDrawnOn!.isBefore(DateTime(2028, 9)), isTrue);
    expect(wcQualDrawnOn, isNotNull);
    expect(wcQualDrawnOn!.isAfter(DateTime(2028, 11)), isTrue);
    expect(wcQualDrawnOn.isBefore(DateTime(2029)), isTrue);

    // Euro qualifying, March to November 2027; the first Finals Four's
    // sides have no June qualifier.
    final euroQual = await fixturesOf(
      CompetitionKind.continentalQualifying,
      europe,
    );
    inSpan(euroQual, DateTime(2027, 3), DateTime(2027, 11, 30), 'Euro quals');
    final firstFour = await fixturesOf(
      CompetitionKind.nationsLeague,
      europe,
      edition: 0,
    );
    final semis1 = [
      for (final f in firstFour)
        if (f.round == 'NSF') f,
    ];
    expect(semis1, hasLength(2));
    expect(
      {for (final f in semis1) f.date},
      {DateTime(2027, 6, 4), DateTime(2027, 6, 5)},
    );
    final final1 = firstFour.singleWhere((f) => f.round == 'NFINAL');
    expect(final1.date, DateTime(2027, 6, 8));
    final four1 = {
      for (final f in semis1) ...[f.homeNationId, f.awayNationId],
    };
    for (final f in euroQual) {
      if (f.date.month != 6) continue;
      expect(four1.contains(f.homeNationId), isFalse, reason: '${f.date}');
      expect(four1.contains(f.awayNationId), isFalse, reason: '${f.date}');
    }

    // The EURO in June 2028, drawn after qualifying.
    inSpan(
      await fixturesOf(CompetitionKind.continentalFinals, europe),
      DateTime(2028, 6),
      DateTime(2028, 7, 31),
      'EURO',
    );

    // The second cup, autumn 2028, on the ladder the first left behind.
    final secondCup = await fixturesOf(
      CompetitionKind.nationsLeague,
      europe,
      edition: 1,
    );
    inSpan(
      [
        for (final f in secondCup)
          if (f.round == 'NGROUP') f,
      ],
      DateTime(2028, 9),
      DateTime(2028, 11, 30),
      'NC edition 2',
    );
    final semis2 = [
      for (final f in secondCup)
        if (f.round == 'NSF') f,
    ];
    expect(
      {for (final f in semis2) f.date},
      {DateTime(2029, 6, 4), DateTime(2029, 6, 5)},
    );
    expect(
      secondCup.singleWhere((f) => f.round == 'NFINAL').date,
      DateTime(2029, 6, 8),
    );
    final cupName = NationsCups.forConfederation(europe)!.name;
    final honours = await comp.honours(id);
    expect(
      honours.where((h) => h.competition == cupName).map((h) => h.year),
      containsAll([2026, 2028]),
    );

    // The ladder moved after the first edition: its League B group winners
    // play the second in League A.
    Future<Map<String, List<int>>> tablesOf(int edition) async => {
      for (final t in await comp.tournamentGroupTables(
        id,
        CompetitionKind.nationsLeague,
        confederation: europe,
        edition: edition,
      ))
        t.name: [for (final s in t.standings) s.nationId],
    };
    final firstTables = await tablesOf(0);
    final secondTables = await tablesOf(1);
    final leagueOfSecond = {
      for (final t in secondTables.entries)
        for (final n in t.value) n: NationsCup.tierOfGroupName(t.key),
    };
    final promoted = [
      for (final t in firstTables.entries)
        if (NationsCup.tierOfGroupName(t.key) == 1) t.value.first,
    ];
    expect(promoted, isNotEmpty);
    expect(tiersAtStart.isNotEmpty, isTrue);

    // WC qualifying: CONMEBOL September 2028 to November 2029, the rest
    // March to November 2029; the second Finals Four's sides have no June
    // qualifier.
    inSpan(
      await fixturesOf(
        CompetitionKind.worldCupQualifying,
        Confederation.southAmerica,
      ),
      DateTime(2028, 9),
      DateTime(2029, 11, 30),
      'CONMEBOL qualifying',
    );
    for (final conf in Confederation.values) {
      if (conf == Confederation.southAmerica) continue;
      final fx = await fixturesOf(CompetitionKind.worldCupQualifying, conf);
      if (fx.isEmpty) continue;
      inSpan(fx, DateTime(2029, 3), DateTime(2029, 11, 30), '${conf.name} WCQ');
    }
    final four2 = {
      for (final f in semis2) ...[f.homeNationId, f.awayNationId],
    };
    for (final f in await fixturesOf(
      CompetitionKind.worldCupQualifying,
      europe,
    )) {
      if (f.date.month != 6) continue;
      expect(four2.contains(f.homeNationId), isFalse, reason: '${f.date}');
      expect(four2.contains(f.awayNationId), isFalse, reason: '${f.date}');
    }

    // The World Championship in June 2030.
    final finals =
        await (db.select(db.competitions)..where(
              (t) =>
                  t.careerId.equals(id) &
                  t.kind.equalsValue(CompetitionKind.worldCupFinals),
            ))
            .get();
    expect(finals, hasLength(1));

    // Rolled over: the next cycle is calendar2 too, its ladder moved on the
    // second edition, and its first cup is in the autumn of 2030.
    final tiersBefore = await careers.nationsCupTiers(id);
    await season.startNextCycle(id);
    final rolled = (await careers.byId(id))!;
    expect(rolled.cyclePointer, 1);
    expect(await comp.hasWatchedDraw(id, 1, calendar2Kind), isTrue);
    final tiersAfter = await careers.nationsCupTiers(id);
    for (final t in secondTables.entries) {
      if (NationsCup.tierOfGroupName(t.key) != 1) continue;
      final winner = t.value.first;
      expect(
        tiersAfter[winner],
        tiersBefore[winner]! - 1,
        reason: 'a League B winner of the second edition goes up',
      );
    }
    inSpan(
      await fixturesOf(
        CompetitionKind.nationsLeague,
        europe,
        edition: 0,
        cycle: 1,
      ),
      DateTime(2030, 9),
      DateTime(2030, 11, 30),
      'next cycle NC edition 1',
    );
    // A League B winner of the first edition played the second in League A.
    for (final n in promoted) {
      expect(leagueOfSecond[n], 0, reason: 'nation $n went up');
    }
  }, timeout: const Timeout(Duration(minutes: 20)));
}
