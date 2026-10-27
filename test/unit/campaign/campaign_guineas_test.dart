import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/campaign/campaign_record_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// Best of Guineas: Equatorial Guinea must beat Guinea and Guinea-Bissau
/// within two cycles; the African Championship adds the other stars. Graded
/// from the recorded fixtures of both cycles, settled at the third star or at
/// the end of the second cycle; never failed by a sacking (no campaign longer
/// than one cycle sacks its manager).
const eqGuinea = 116;
const guinea = 123;
const guineaBissau = 124;
const papuaNewGuinea = 206;

void main() {
  late ProviderContainer container;
  late List<Nation> nations;
  late bool sackedAtEnd;
  late bool premium;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sackedAtEnd = false;
    premium = true;
    final db = createTestDatabase();
    nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final base =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    final namesRaw =
        jsonDecode(File('assets/data/country_names.json').readAsStringSync())
            as Map<String, Object?>;
    final names = <int, ({List<String> first, List<String> sur})>{
      for (final e in namesRaw.entries)
        int.parse(e.key): (
          first: ((e.value! as Map)['first'] as List).cast<String>(),
          sur: ((e.value! as Map)['sur'] as List).cast<String>(),
        ),
    };
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => premium),
        rolloverVerdictProvider.overrideWith(
          (ref, careerId) async => RolloverVerdict(
            performance: 50,
            headline: const MsgText(MsgKey.finishGroupStage),
            detail: const MsgText(MsgKey.finishGroupStage),
            sacked: sackedAtEnd,
            currentNation: null,
            offers: const [],
            reputation: 0,
            nationalHero: false,
            cyclesAtNation: 1,
          ),
        ),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(
            nationList: nations,
            playerList: PoolGenerator.expand(base, namesByNation: names),
          ),
        ),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await db.close();
    });
    await container.read(seedLoaderProvider).ensureSeeded();
  });

  CompetitionRepository comp() => container.read(competitionRepositoryProvider);

  Future<CampaignProgress> progress(int careerId) async {
    container
      ..invalidate(hubDataProvider(careerId))
      ..invalidate(campaignProgressProvider(careerId));
    final p = await container.read(campaignProgressProvider(careerId).future);
    return p!;
  }

  Future<int> start() async =>
      (await container
              .read(campaignServiceProvider)
              .start(Campaigns.guineas, managerName: 'Me'))
          .id;

  Future<int> cycleOf(int careerId) async =>
      (await container.read(careerRepositoryProvider).byId(careerId))!
          .cyclePointer;

  /// A friendly against [opponent] on [date], played [mine]-[theirs].
  Future<void> friendly(
    int careerId,
    int opponent,
    DateTime date, {
    required int mine,
    required int theirs,
  }) async {
    await comp().saveFriendlies(
      careerId: careerId,
      nationId: eqGuinea,
      cycle: await cycleOf(careerId),
      friendlies: [(date: date, opponentId: opponent, home: true)],
    );
    final f = (await comp().fixturesForNation(careerId, eqGuinea)).firstWhere(
      (f) =>
          f.date == date &&
          (f.homeNationId == opponent || f.awayNationId == opponent),
    );
    final home = f.homeNationId == eqGuinea;
    await comp().recordResult(
      fixtureId: f.id,
      homeScore: home ? mine : theirs,
      awayScore: home ? theirs : mine,
    );
  }

  /// Both rivals beaten in friendlies in [year].
  Future<void> beatBoth(int careerId, int year) async {
    await friendly(careerId, guinea, DateTime(year, 3, 14), mine: 2, theirs: 1);
    await friendly(
      careerId,
      guineaBissau,
      DateTime(year, 11, 14),
      mine: 1,
      theirs: 0,
    );
  }

  List<int> africans(int n) => [
    for (final x in nations)
      if (x.confederation == Confederation.africa &&
          ![eqGuinea, guinea, guineaBissau].contains(x.id))
        x.id,
  ].take(n).toList();

  /// An African Championship finals draw of one group holding Equatorial
  /// Guinea, in the current cycle, opening in [year].
  Future<void> drawFinals(int careerId, int year) async {
    final group = [eqGuinea, ...africans(3)];
    await comp().saveTournamentGroups(
      careerId: careerId,
      cycle: await cycleOf(careerId),
      confederation: Confederation.africa,
      kind: CompetitionKind.continentalFinals,
      name: 'African Championship',
      draw: FinalsDraw(
        groups: [
          FinalsGroupDraw(
            name: 'A',
            nationIds: group,
            fixtures: [
              for (var i = 0; i < group.length; i++)
                for (var j = i + 1; j < group.length; j++)
                  (i + j, group[i], group[j]),
            ],
          ),
        ],
      ),
      groupStart: DateTime(year, 1, 15),
      round: 'CGROUP',
    );
  }

  /// A World Championship final recorded in the current cycle.
  Future<void> decideWorldChampionship(int careerId) async {
    final cycle = await cycleOf(careerId);
    await comp().createKnockout(
      careerId: careerId,
      cycle: cycle,
      confederation: Confederation.europe,
      kind: CompetitionKind.worldCupFinals,
      name: 'World Championship',
      pairings: [(26, 1)],
      date: DateTime(CareerService.worldCupYear(cycle), 7, 19),
      firstRound: 'FINAL',
    );
    final fin = await comp().fixturesByRound(careerId, 'FINAL');
    await comp().recordResult(
      fixtureId: fin.single.id,
      homeScore: 1,
      awayScore: 0,
    );
  }

  Future<void> intoSecondCycle(int careerId) => container
      .read(careerRepositoryProvider)
      .advanceCycle(careerId, 1, CareerService.cycleOpens(1));

  test('a free manager cannot start it: it needs Pro', () async {
    premium = false;
    await expectLater(
      container
          .read(campaignServiceProvider)
          .start(Campaigns.guineas, managerName: 'Me'),
      throwsStateError,
    );
    expect(await container.read(campaignRunsProvider.future), isEmpty);
  });

  test('the start books a home friendly with Papua New Guinea in the first '
      'cycle', () async {
    final id = await start();
    final png = (await comp().cycleFixturesForNation(id, eqGuinea))
        .where(
          (f) =>
              f.round == 'FRIENDLY' &&
              (f.homeNationId == papuaNewGuinea ||
                  f.awayNationId == papuaNewGuinea),
        )
        .toList();
    expect(png, hasLength(1));
    expect(png.single.homeNationId, eqGuinea);
    // Pinned for this seed: June, three years before the World Championship.
    expect(
      png.single.date,
      DateTime(CareerService.worldCupYear(0) - 3, 6, 14),
    );
    expect(png.single.date.isBefore(CareerService.cycleOpens(1)), isTrue);
    // Nothing else of the nation's is on that month.
    final sameMonth = (await comp().fixturesForNation(id, eqGuinea)).where(
      (f) =>
          f.date.year == png.single.date.year &&
          f.date.month == png.single.date.month,
    );
    expect(sameMonth, hasLength(1));
  });

  test('beating one rival is not the goal yet', () async {
    final id = await start();
    await friendly(id, guinea, DateTime(2027, 3, 14), mine: 1, theirs: 0);
    await friendly(id, guineaBissau, DateTime(2027, 6, 14), mine: 1, theirs: 1);
    final p = await progress(id);
    expect(p.rivalsBeaten, {guinea});
    expect(p.rivalWins, 1);
    expect(p.rivalMatchesPlayed, 2);
    expect(p.reached, 0);
    expect(p.settled, isFalse);
  });

  test('beating both is one star, settled only at the end of the second '
      'cycle, and the meetings of both cycles count', () async {
    final id = await start();
    await friendly(id, guinea, DateTime(2027, 3, 14), mine: 3, theirs: 0);
    var p = await progress(id);
    expect(p.reached, 0);

    // The first cycle ends: the run carries on into the second.
    await decideWorldChampionship(id);
    p = await progress(id);
    expect(p.settled, isFalse);
    expect(p.stars, 0);

    await intoSecondCycle(id);
    await friendly(
      id,
      guineaBissau,
      DateTime(2031, 3, 14),
      mine: 2,
      theirs: 1,
    );
    p = await progress(id);
    expect(p.rivalsBeaten, {guinea, guineaBissau});
    expect(p.reached, 1);
    expect(p.settled, isFalse);
    expect(p.cycleRuns, hasLength(2));

    await decideWorldChampionship(id);
    p = await progress(id);
    expect(p.settled, isTrue);
    expect(p.stars, 1);
  });

  test('qualified in the first cycle is two stars, still counted in the '
      'second', () async {
    final id = await start();
    await beatBoth(id, 2027);
    await drawFinals(id, 2028);
    var p = await progress(id);
    expect(p.reached, 2);
    expect(p.cycleRuns.single.ordinal, 2);
    expect(p.settled, isFalse);

    await decideWorldChampionship(id);
    await intoSecondCycle(id);
    p = await progress(id);
    expect(p.cycleRuns.map((r) => r.ordinal), [2, 0]);
    expect(p.ordinal, 2);
    expect(p.reached, 2);
    expect(p.settled, isFalse);
  });

  test('qualified without beating both is nothing', () async {
    final id = await start();
    await friendly(id, guinea, DateTime(2027, 3, 14), mine: 1, theirs: 0);
    await drawFinals(id, 2028);
    final p = await progress(id);
    expect(p.ordinal, 2);
    expect(p.reached, 0);
  });

  test(
    'a quarter-final with both beaten is three stars and settles at once',
    () async {
      final id = await start();
      await beatBoth(id, 2027);
      await drawFinals(id, 2028);
      await comp().addKnockoutFixtures(
        careerId: id,
        round: 'CQF',
        pairings: [(eqGuinea, africans(4).last)],
        date: DateTime(2028, 2, 1),
        kind: CompetitionKind.continentalFinals,
        confederation: Confederation.africa,
      );
      final p = await progress(id);
      expect(p.ordinal, 4);
      expect(p.reached, 3);
      expect(p.settled, isTrue);
      expect(p.stars, 3);
    },
  );

  test('no sacking fails it: a run longer than one cycle goes on', () async {
    // Even a verdict that says sacked (the board never says it here: see
    // campaign_no_sacking_test.dart) does not end the run.
    sackedAtEnd = true;
    final id = await start();
    await beatBoth(id, 2027);
    await drawFinals(id, 2028);
    await decideWorldChampionship(id);
    final p = await progress(id);
    expect(p.reached, 2);
    expect(p.settled, isFalse);
    expect(p.stars, 0);
  });

  test('a shootout won counts as a win, one lost does not', () {
    Fixture tie({required int homePens, required int awayPens}) => Fixture(
      id: 1,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      date: DateTime(2028),
      homeNationId: eqGuinea,
      awayNationId: guinea,
      homeScore: 1,
      awayScore: 1,
      played: true,
      homePenalties: homePens,
      awayPenalties: awayPens,
    );
    expect(campaignNationWon(tie(homePens: 4, awayPens: 3), eqGuinea), isTrue);
    expect(campaignNationWon(tie(homePens: 2, awayPens: 3), eqGuinea), isFalse);
    expect(campaignNationWon(tie(homePens: 2, awayPens: 3), guinea), isTrue);
  });

  Future<T> listenRead<T>(AutoDisposeFutureProvider<T> p) async {
    final sub = container.listen(p.future, (_, _) {});
    try {
      return await sub.read();
    } finally {
      sub.close();
    }
  }

  Future<HubEvent> nextEvent(int id) {
    container
      ..invalidate(hubDataProvider(id))
      ..invalidate(campaignProgressProvider(id))
      ..invalidate(nextEventProvider(id));
    return listenRead(nextEventProvider(id));
  }

  /// Both rivals beaten and a quarter-final reached in the first cycle: the
  /// third star, settled.
  Future<int> threeStarsInFirstCycle() async {
    final id = await start();
    await beatBoth(id, 2027);
    await drawFinals(id, 2028);
    await comp().addKnockoutFixtures(
      careerId: id,
      round: 'CQF',
      pairings: [(eqGuinea, africans(4).last)],
      date: DateTime(2028, 2, 1),
      kind: CompetitionKind.continentalFinals,
      confederation: Confederation.africa,
    );
    expect((await progress(id)).stars, 3);
    return id;
  }

  test('three stars in the first cycle, then sacked at its end: the run ends '
      'with its stars, never at the rollover', () async {
    final id = await threeStarsInFirstCycle();
    sackedAtEnd = true;
    await decideWorldChampionship(id);
    final verdict = await nextEvent(id);
    expect(verdict.kind, HubEventKind.campaignVerdict);
    expect(verdict.route, startsWith(Routes.campaignVerdict));
    await container.read(campaignServiceProvider).acknowledgeVerdict(id);
    final done = await nextEvent(id);
    expect(done.kind, HubEventKind.campaignVerdict);
    expect(done.route, Routes.campaigns);
    final p = await progress(id);
    expect(p.settled, isTrue);
    expect(p.stars, 3);
    expect(
      await container.read(campaignBestProvider(Campaigns.guineas.id).future),
      3,
    );
    // Below the UI too: it does not roll.
    await container.read(seasonServiceProvider).startNextCycle(id);
    expect(await cycleOf(id), 0);
  });

  Future<CampaignProgress?> maybeProgress(int id) {
    container
      ..invalidate(hubDataProvider(id))
      ..invalidate(campaignProgressProvider(id));
    return container.read(campaignProgressProvider(id).future);
  }

  test('a settled Pro run whose purchase has gone is not moved, and no moved '
      'marker is written', () async {
    final id = await threeStarsInFirstCycle();
    container
      ..read(premiumUnlockedProvider.notifier).state = false
      ..read(entitlementSettledProvider.notifier).state = true;
    expect(
      await container.read(campaignServiceProvider).moveToSaves(id),
      CampaignMoveResult.needsPremium,
    );
    final tag = (await campaignTags(comp()))[id];
    expect(tag?.moved, isFalse);
  });

  test('moved, then rolled with the same nation: an ordinary career, no card '
      'and no verdict', () async {
    final id = await threeStarsInFirstCycle();
    expect(
      await container.read(campaignServiceProvider).moveToSaves(id),
      CampaignMoveResult.moved,
    );
    // Still the campaign for the rest of the cycle it was moved in.
    expect(await maybeProgress(id), isNotNull);
    await decideWorldChampionship(id);
    await container.read(campaignServiceProvider).acknowledgeVerdict(id);
    await container.read(seasonServiceProvider).startNextCycle(id);
    expect(await cycleOf(id), 1);
    expect(await maybeProgress(id), isNull);
    expect((await nextEvent(id)).kind, isNot(HubEventKind.campaignVerdict));
  });

  test('moved after its verdict, then rolled to another nation: no card, no '
      'verdict, no new stars', () async {
    // A sacking can no longer settle this run (no campaign longer than one
    // cycle sacks its manager), so the verdict here is the early third star.
    final id = await start();
    await beatBoth(id, 2027);
    await drawFinals(id, 2028);
    await comp().addKnockoutFixtures(
      careerId: id,
      round: 'CQF',
      pairings: [(eqGuinea, africans(4).last)],
      date: DateTime(2028, 2, 1),
      kind: CompetitionKind.continentalFinals,
      confederation: Confederation.africa,
    );
    await decideWorldChampionship(id);
    final done = await progress(id);
    expect(done.settled, isTrue);
    expect(done.stars, 3);
    expect(
      await container.read(campaignServiceProvider).moveToSaves(id),
      CampaignMoveResult.moved,
    );
    await container.read(campaignServiceProvider).acknowledgeVerdict(id);
    // A moved run is an ordinary save: the manager may take a new job.
    await container
        .read(seasonServiceProvider)
        .startNextCycle(id, switchToNationId: 26);
    expect(await cycleOf(id), 1);
    // Equatorial Guinea, now someone else's side, play on.
    await beatBoth(id, 2031);
    expect(await maybeProgress(id), isNull);
    expect((await nextEvent(id)).kind, isNot(HubEventKind.campaignVerdict));
    await container.read(campaignServiceProvider).acknowledgeVerdict(id);
    expect(
      await container.read(campaignBestProvider(Campaigns.guineas.id).future),
      3,
    );
  });
}
