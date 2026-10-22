import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/player/golden_generation.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// Young Finns: Finland for three cycles with a golden generation in place of
/// its seniors. A World Championship place is one star, the European title
/// two, the world title three; settled at three or at the end of the third
/// cycle, never ended by a sacking, never moved into the saves.
const finland = 17;

void main() {
  late ProviderContainer container;
  late List<Nation> nations;
  late Set<int> storedFinns;
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
    final players = PoolGenerator.expand(base);
    storedFinns = {
      for (final p in players)
        if (p.nationId == finland) p.id,
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
          InMemorySeedSource(nationList: nations, playerList: players),
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

  Future<int> start() async => (await container
      .read(campaignServiceProvider)
      .start(Campaigns.youngFinns, managerName: 'Me')).id;

  Future<int> cycleOf(int careerId) async =>
      (await container.read(careerRepositoryProvider).byId(careerId))!
          .cyclePointer;

  List<int> europeans(int n) => [
    for (final x in nations)
      if (x.confederation == Confederation.europe && x.id != finland) x.id,
  ].take(n).toList();

  /// A World Championship finals group holding Finland, this cycle.
  Future<void> drawWorldFinals(int careerId) async {
    final cycle = await cycleOf(careerId);
    final group = [finland, ...europeans(3)];
    await comp().saveTournamentGroups(
      careerId: careerId,
      cycle: cycle,
      confederation: Confederation.europe,
      kind: CompetitionKind.worldCupFinals,
      name: 'World Championship',
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
      groupStart: DateTime(CareerService.worldCupYear(cycle), 6, 12),
      round: 'GROUP',
    );
  }

  /// A one-match knockout of [kind] in round [round], [home] beating [away].
  Future<void> final1(
    int careerId, {
    required CompetitionKind kind,
    required String round,
    required int home,
    required int away,
    required DateTime date,
  }) async {
    // Into the cycle's tournament when one is drawn already (the finals
    // group), else a tournament of its own.
    final conf = kind == CompetitionKind.worldCupFinals
        ? null
        : Confederation.europe;
    if (await comp().hasTournament(careerId, kind, confederation: conf)) {
      await comp().addKnockoutFixtures(
        careerId: careerId,
        round: round,
        pairings: [(home, away)],
        date: date,
        kind: kind,
        confederation: conf,
      );
    } else {
      await comp().createKnockout(
        careerId: careerId,
        cycle: await cycleOf(careerId),
        confederation: Confederation.europe,
        kind: kind,
        name: kind == CompetitionKind.worldCupFinals
            ? 'World Championship'
            : 'European Championship',
        pairings: [(home, away)],
        date: date,
        firstRound: round,
      );
    }
    final f = (kind == CompetitionKind.worldCupFinals
            ? await comp().fixturesByRound(careerId, round)
            : await comp().fixturesByRound(
                careerId,
                round,
                kind: kind,
                confederation: Confederation.europe,
              ))
        .single;
    await comp().recordResult(fixtureId: f.id, homeScore: 2, awayScore: 0);
  }

  /// The European Championship final of this cycle, won by Finland.
  Future<void> winEuro(int careerId) async => final1(
    careerId,
    kind: CompetitionKind.continentalFinals,
    round: 'CFINAL',
    home: finland,
    away: europeans(1).single,
    date: DateTime(
      CareerService.continentalFinalsYear(await cycleOf(careerId)),
      7,
      10,
    ),
  );

  /// The World Championship final of this cycle: Finland win it when
  /// [finlandWins], otherwise two other sides play it.
  Future<void> decideWorld(int careerId, {bool finlandWins = false}) async {
    final others = europeans(2);
    await final1(
      careerId,
      kind: CompetitionKind.worldCupFinals,
      round: 'FINAL',
      home: finlandWins ? finland : others[0],
      away: others[1],
      date: DateTime(CareerService.worldCupYear(await cycleOf(careerId)), 7, 19),
    );
  }

  Future<void> intoCycle(int careerId, int cycle) => container
      .read(careerRepositoryProvider)
      .advanceCycle(careerId, cycle, CareerService.cycleOpens(cycle));

  test('a free manager cannot start it: it needs Pro', () async {
    premium = false;
    await expectLater(
      container
          .read(campaignServiceProvider)
          .start(Campaigns.youngFinns, managerName: 'Me'),
      throwsStateError,
    );
  });

  test('the run starts with Finland\'s golden generation, and the XI is '
      'picked from it', () async {
    final id = await start();
    expect(
      await comp().hasWatchedDraw(id, 0, GoldenGeneration.markerFor(finland)),
      isTrue,
    );
    final finns = await container
        .read(playerRepositoryProvider)
        .byNation(
          finland,
          saveSeed: Campaigns.youngFinns.rngSeed,
          careerId: id,
          minAge: PlayerLifecycle.callUpMinAge,
        );
    expect(finns.every((p) => p.age <= 18), isTrue);
    expect(finns.where((p) => storedFinns.contains(p.id)), isEmpty);
    final tactic = await container
        .read(tacticsRepositoryProvider)
        .tacticForCareer(id);
    final xi = tactic!.lineup.whereType<int>().toSet();
    expect(xi, hasLength(11));
    expect(xi.where(storedFinns.contains), isEmpty);
    expect(xi.difference({for (final p in finns) p.id}), isEmpty);
  });

  test('other campaigns and normal careers keep the real Finland', () async {
    final normal = (await container
        .read(careerServiceProvider)
        .create(nationId: finland, managerName: 'N', rngSeed: 17))
        .valueOrNull!;
    final finns = await container
        .read(playerRepositoryProvider)
        .byNation(finland, saveSeed: 17, careerId: normal.id);
    expect(finns.where((p) => storedFinns.contains(p.id)), isNotEmpty);
    expect(finns.where((p) => GoldenGeneration.isGoldenId(p.id)), isEmpty);
  });

  test('a World Championship place is one star; the run goes on', () async {
    final id = await start();
    await drawWorldFinals(id);
    final p = await progress(id);
    expect(p.reached, 1);
    expect(p.settled, isFalse);
    expect(p.worldRuns.single.ordinal, 2);
  });

  test('the European title is two, counted in later cycles too', () async {
    final id = await start();
    await winEuro(id);
    var p = await progress(id);
    expect(p.reached, 2);
    expect(p.settled, isFalse);
    await decideWorld(id);
    p = await progress(id);
    expect(p.settled, isFalse, reason: 'two more cycles to go');
    await intoCycle(id, 1);
    p = await progress(id);
    expect(p.reached, 2);
    expect(p.cycleRuns.map((r) => r.ordinal), [7, 0]);
  });

  test('the world title is three and settles at once', () async {
    final id = await start();
    await drawWorldFinals(id);
    await decideWorld(id, finlandWins: true);
    final p = await progress(id);
    expect(p.reached, 3);
    expect(p.settled, isTrue);
    expect(p.stars, 3);
  });

  test('otherwise it is judged at the end of the third cycle', () async {
    final id = await start();
    await decideWorld(id);
    expect((await progress(id)).settled, isFalse);
    await intoCycle(id, 1);
    await drawWorldFinals(id);
    await decideWorld(id);
    var p = await progress(id);
    expect(p.reached, 1);
    expect(p.settled, isFalse);
    await intoCycle(id, 2);
    p = await progress(id);
    expect(p.worldRuns.map((r) => r.ordinal), [0, 2, 0]);
    expect(p.reached, 1);
    expect(p.settled, isFalse);
    await decideWorld(id);
    p = await progress(id);
    expect(p.settled, isTrue);
    expect(p.stars, 1);
  });

  test('an unmoved run rolls through its first two cycles only', () {
    const tag = (def: Campaigns.youngFinns, moved: false);
    expect(campaignMayRoll(tag, 0), isTrue);
    expect(campaignMayRoll(tag, 1), isTrue);
    expect(campaignMayRoll(tag, 2), isFalse);
  });

  test('no sacking fails it: the run goes on to its last cycle', () async {
    // A verdict that says sacked (the board never says it for this run: see
    // campaign_no_sacking_test.dart) does not end it either.
    sackedAtEnd = true;
    final id = await start();
    await drawWorldFinals(id);
    await decideWorld(id);
    var p = await progress(id);
    expect(p.reached, 1);
    expect(p.settled, isFalse);
    await intoCycle(id, 2);
    await decideWorld(id);
    p = await progress(id);
    expect(p.settled, isTrue);
    expect(p.stars, 1);
  });

  test('a settled run cannot be moved into the saves', () async {
    final id = await start();
    await drawWorldFinals(id);
    await decideWorld(id, finlandWins: true);
    expect(
      await container.read(campaignServiceProvider).moveToSaves(id),
      CampaignMoveResult.notAllowed,
    );
  });
}
