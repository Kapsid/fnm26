import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/achievements/achievements.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/competition/cycle_finish.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/achievements/challenge_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/hub/round_popup.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';
import 'package:fnm/features/tournaments/tournaments_providers.dart';

import '../../helpers/test_database.dart';

/// The manager-facing side of the three Nations Cups: the hub, the draw, the
/// board and the trophy count all follow the cup of the manager's OWN
/// confederation (none at all for one that has no cup), while the tournaments
/// screen lists every cup for everybody.
void main() {
  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List<dynamic>)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList();
  final byCode = {for (final n in nations) n.code: n};

  Future<({ProviderContainer c, AppDatabase db, int careerId})> open(
    String code,
  ) async {
    final db = createTestDatabase();
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
    final career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: byCode[code]!.id,
                  managerName: 'M',
                  rngSeed: 4242,
                ))
            .valueOrNull!;
    final comp = c.read(competitionRepositoryProvider);
    // Clear the cycle's opening prompts so the hub's next event is the one
    // under test.
    await comp.markDrawWatched(career.id, 0, budgetSetupKind);
    await comp.markDrawWatched(career.id, 0, skillsPromptKind);
    return (c: c, db: db, careerId: career.id);
  }

  /// Puts [conf]'s cup into its finals: a knockout round between [pairs],
  /// dated on the manager's next fixture so it is due before it.
  Future<void> finalsUnderWay(
    ProviderContainer c,
    int careerId,
    Confederation conf,
    String round,
    List<(int, int)> pairs,
  ) async {
    final comp = c.read(competitionRepositoryProvider);
    final career = await c.read(careerRepositoryProvider).byId(careerId);
    final next = await comp.nextFixtureForNation(careerId, career!.nationId);
    await comp.addKnockoutFixtures(
      careerId: careerId,
      round: round,
      kind: CompetitionKind.nationsLeague,
      confederation: conf,
      pairings: pairs,
      date: next!.date,
    );
  }

  List<(int, int)> pairsOf(List<String> codes) => [
    for (var i = 0; i + 1 < codes.length; i += 2)
      (byCode[codes[i]]!.id, byCode[codes[i + 1]]!.id),
  ];

  group('an African manager', () {
    test('watches the draw of his own zone', () async {
      final s = await open('ZAM');
      final draw = await s.c.read(nationsCupDrawProvider(s.careerId).future);
      expect(draw, isNotNull);
      final prefix = NationsCups.zonePrefix(AfricaZone.centralSouthern);
      expect(draw!.groups, hasLength(4));
      for (final g in draw.groups) {
        expect(g.name, startsWith(prefix), reason: 'his zone only');
      }
      expect(
        draw.groups.any((g) => g.nationIds.contains(byCode['ZAM']!.id)),
        isTrue,
      );
    });

    test('is set an objective for the African Nations Cup', () async {
      final s = await open('ZAM');
      final outcomes = await s.c.read(
        cycleObjectiveOutcomesProvider(s.careerId).future,
      );
      final nc = outcomes.where((o) => o.tier == TournamentTier.nationsCup);
      expect(nc, hasLength(1));
      expect(nc.single.competition, NationsCups.africa);
      // Win your group … win it, or the top half for the weakest: never
      // "avoid relegation", since the African cup relegates nobody.
      expect(nc.single.target, inInclusiveRange(3, 7));
    });

    test('is sent to watch his cup\'s Finals Eight', () async {
      final s = await open('ZAM');
      await finalsUnderWay(
        s.c,
        s.careerId,
        Confederation.africa,
        'NQF',
        pairsOf(['SEN', 'CMR', 'MAR', 'EGY', 'NGA', 'CIV', 'ALG', 'GHA']),
      );
      final event = await s.c.read(nextEventProvider(s.careerId).future);
      expect(event.kind, HubEventKind.watchTournament);
      expect(event.route, contains('/nations-cup'));
      expect(event.route, contains('conf=africa'));
    });
  });

  test('a European manager is not sent to watch Africa\'s finals', () async {
    final s = await open('GER');
    await finalsUnderWay(
      s.c,
      s.careerId,
      Confederation.africa,
      'NQF',
      pairsOf(['SEN', 'CMR', 'MAR', 'EGY', 'NGA', 'CIV', 'ALG', 'GHA']),
    );
    final event = await s.c.read(nextEventProvider(s.careerId).future);
    expect(event.route ?? '', isNot(contains('/nations-cup')));
    final outcomes = await s.c.read(
      cycleObjectiveOutcomesProvider(s.careerId).future,
    );
    expect(
      outcomes
          .where((o) => o.tier == TournamentTier.nationsCup)
          .single
          .competition,
      NationsCups.europe,
    );
  });

  test('an Asian manager has no Nations Cup events at all', () async {
    final s = await open('JPN');
    await finalsUnderWay(
      s.c,
      s.careerId,
      Confederation.europe,
      'NSF',
      pairsOf(['ESP', 'FRA', 'ENG', 'POR']),
    );
    final event = await s.c.read(nextEventProvider(s.careerId).future);
    expect(event.route ?? '', isNot(contains('/nations-cup')));
    expect(await s.c.read(nationsCupDrawProvider(s.careerId).future), isNull);
    final outcomes = await s.c.read(
      cycleObjectiveOutcomesProvider(s.careerId).future,
    );
    expect(outcomes.where((o) => o.tier == TournamentTier.nationsCup), isEmpty);

    // …but the tournaments screen still lists all three cups, read-only.
    final overview = await s.c.read(
      tournamentsOverviewProvider(s.careerId).future,
    );
    expect(overview!.nationsCup, isNull);
    expect(overview.otherNationsCups.keys.toSet(), {
      Confederation.europe,
      Confederation.northAmerica,
      Confederation.africa,
    });
  });

  test(
    'a manager who moves Europe to CONCACAF follows CONCACAF\'s cup',
    () async {
      final s = await open('GER');
      final before = await s.c.read(
        tournamentsOverviewProvider(s.careerId).future,
      );
      expect(before!.nationsCupConfederation, Confederation.europe);

      await s.c
          .read(careerRepositoryProvider)
          .switchNation(s.careerId, byCode['MEX']!.id);
      s.c
        ..invalidate(cycleObjectiveOutcomesProvider)
        ..invalidate(nationsCupDrawProvider)
        ..invalidate(tournamentsOverviewProvider);

      final outcomes = await s.c.read(
        cycleObjectiveOutcomesProvider(s.careerId).future,
      );
      expect(
        outcomes
            .where((o) => o.tier == TournamentTier.nationsCup)
            .single
            .competition,
        NationsCups.northAmerica,
      );
      final draw = await s.c.read(nationsCupDrawProvider(s.careerId).future);
      expect(draw, isNotNull);
      final mexicoGroup = draw!.groups.where(
        (g) => g.nationIds.contains(byCode['MEX']!.id),
      );
      expect(mexicoGroup, hasLength(1));
      for (final g in draw.groups) {
        for (final id in g.nationIds) {
          expect(
            nations.firstWhere((n) => n.id == id).confederation,
            Confederation.northAmerica,
          );
        }
      }
      final overview = await s.c.read(
        tournamentsOverviewProvider(s.careerId).future,
      );
      expect(overview!.nationsCupConfederation, Confederation.northAmerica);
      expect(overview.otherNationsCups.keys.toSet(), {
        Confederation.europe,
        Confederation.africa,
      });
    },
  );

  group('a North America Nations Cup win', () {
    test('earns the Nations Cup achievement', () {
      final def = AchievementCatalog.all.firstWhere(
        (a) => a.id == 'title_nations_league',
      );
      expect(
        def.isEarned(_stats(titlesWon: {NationsCups.northAmerica})),
        isTrue,
      );
      expect(
        def.isEarned(_stats(titlesWon: {NationsCups.africa})),
        isTrue,
      );
    });

    test('counts once towards the Nations Cup challenge', () async {
      final s = await open('MEX');
      final career = await s.c.read(careerRepositoryProvider).byId(s.careerId);
      final year = CareerService.worldCupYear(0) - 2;
      await s.c
          .read(competitionRepositoryProvider)
          .recordHonour(
            careerId: s.careerId,
            competition: NationsCups.northAmerica,
            year: year,
            championId: career!.nationId,
            runnerUpId: byCode['USA']!.id,
          );
      final views = await s.c.read(challengesViewProvider(s.careerId).future);
      final nc = views.firstWhere((v) => v.def.id == 'ch_nc_1');
      expect(nc.current, 1);
      expect(nc.complete, isTrue);
    });
  });

  test("the latest-results popup reads the manager's own cup", () async {
    final s = await open('ZAM');
    final comp = s.c.read(competitionRepositoryProvider);
    final year = CareerService.worldCupYear(0) - 2;
    Future<void> played(
      Confederation conf,
      String round,
      List<String> codes,
      DateTime date,
    ) async {
      await comp.addKnockoutFixtures(
        careerId: s.careerId,
        round: round,
        kind: CompetitionKind.nationsLeague,
        confederation: conf,
        pairings: pairsOf(codes),
        date: date,
      );
      for (final f in await comp.fixturesByRound(
        s.careerId,
        round,
        kind: CompetitionKind.nationsLeague,
        confederation: conf,
      )) {
        await comp.recordResult(fixtureId: f.id, homeScore: 1, awayScore: 0);
      }
    }

    await played(
      Confederation.africa,
      'NQF',
      ['SEN', 'CMR', 'MAR', 'EGY', 'NGA', 'CIV', 'ALG', 'GHA'],
      DateTime(year, 11, 12),
    );
    // Europe's semi-finals, played LATER: not his cup, so not his popup.
    await played(
      Confederation.europe,
      'NSF',
      ['ESP', 'FRA', 'ENG', 'POR'],
      DateTime(year + 1, 6, 18),
    );
    final popup = await s.c.read(latestRoundPopupProvider(s.careerId).future);
    expect(popup, isNotNull);
    expect(popup!.competition, NationsCups.africa);
    expect(popup.fixtures, hasLength(4));
    expect(popup.fixtures.every((f) => f.round == 'NQF'), isTrue);
  });

  test('an African quarter-finalist has that finish in his history', () async {
    final s = await open('ZAM');
    final comp = s.c.read(competitionRepositoryProvider);
    final zam = byCode['ZAM']!.id;
    await comp.addKnockoutFixtures(
      careerId: s.careerId,
      round: 'NQF',
      kind: CompetitionKind.nationsLeague,
      confederation: Confederation.africa,
      pairings: [(byCode['SEN']!.id, zam)],
      date: DateTime(CareerService.worldCupYear(0) - 2, 11, 12),
    );
    final qf = (await comp.fixturesByRound(
      s.careerId,
      'NQF',
      kind: CompetitionKind.nationsLeague,
      confederation: Confederation.africa,
    )).single;
    await comp.recordResult(fixtureId: qf.id, homeScore: 2, awayScore: 0);

    final finishes = await comp.nationsCupFinishes(s.careerId, zam);
    expect(finishes, hasLength(1));
    expect(finishes.single.finals, NationsCupFinish.quarterFinalist);
    expect(finishes.single.zone, AfricaZone.centralSouthern);
  });
}

AchievementStats _stats({Set<String> titlesWon = const {}}) => AchievementStats(
  matchesPlayed: 0,
  wins: 0,
  reachedWorldCup: false,
  reachedContinental: false,
  titlesWon: titlesWon,
  biggestWinMargin: 0,
  wcMarksmanGoals: 0,
  hasChampionshipGoldenBoot: false,
  playerInAllStars: false,
  wonWorldCupAndContinental: false,
  satisfaction: 50,
  cleanSheets: 0,
  totalGoals: 0,
  longestWinStreak: 0,
  longestUnbeatenRun: 0,
  hatTricks: 0,
  playerMotms: 0,
  shootoutsWon: 0,
  bestPlayerRating: 0,
);
