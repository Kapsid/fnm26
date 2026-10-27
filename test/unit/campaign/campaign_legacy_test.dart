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
import 'package:fnm/domain/services/campaign/campaign_grading.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// Finish the Legacy: Spain, the reigning European champions, for one cycle.
/// The European Championship is one star; that and the World Championship
/// two; both and the Nations Cup three. Every star needs the European title,
/// so losing it ends the run at once.
const spain = 50;

void main() {
  late ProviderContainer container;
  late List<Nation> nations;
  late bool sackedAtEnd;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sackedAtEnd = false;
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
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
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
            playerList: PoolGenerator.expand(base),
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
              .start(Campaigns.legacy, managerName: 'Me'))
          .id;

  List<int> europeans(int n) => [
    for (final x in nations)
      if (x.confederation == Confederation.europe && x.id != spain) x.id,
  ].take(n).toList();

  /// A one-match final of [kind] in [round], [home] beating [away] 2-0.
  Future<void> final1(
    int careerId, {
    required CompetitionKind kind,
    required String round,
    required int home,
    required int away,
    required DateTime date,
  }) async {
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
        cycle: 0,
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
    final f =
        (kind == CompetitionKind.worldCupFinals
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

  Future<void> euro(int careerId, {required bool spainWins}) => final1(
    careerId,
    kind: CompetitionKind.continentalFinals,
    round: 'CFINAL',
    home: spainWins ? spain : europeans(1).single,
    away: spainWins ? europeans(1).single : spain,
    date: DateTime(CareerService.continentalFinalsYear(0), 7, 10),
  );

  Future<void> nationsCup(int careerId, {required bool spainWins}) => final1(
    careerId,
    kind: CompetitionKind.nationsLeague,
    round: 'NFINAL',
    home: spainWins ? spain : europeans(2).last,
    away: spainWins ? europeans(2).last : spain,
    date: DateTime(CareerService.worldCupYear(0) - 1, 6, 21),
  );

  Future<void> world(int careerId, {required bool spainWins}) => final1(
    careerId,
    kind: CompetitionKind.worldCupFinals,
    round: 'FINAL',
    home: spainWins ? spain : europeans(3).last,
    away: spainWins ? europeans(3).last : spain,
    date: DateTime(CareerService.worldCupYear(0), 7, 19),
  );

  test('titleTrebleStars: each star needs every title before it', () {
    for (final euro in [false, true]) {
      for (final wc in [false, true]) {
        for (final nc in [false, true]) {
          expect(
            titleTrebleStars(
              wonContinental: euro,
              wonWorld: wc,
              wonNationsCup: nc,
            ),
            !euro
                ? 0
                : !wc
                ? 1
                : nc
                ? 3
                : 2,
            reason: 'euro $euro world $wc nations cup $nc',
          );
        }
      }
    }
  });

  test('the campaign: Spain, one cycle, Pro, hard, can be continued', () {
    const def = Campaigns.legacy;
    expect(def.nationId, spain);
    expect(def.cycles, 1);
    expect(def.goal, CampaignGoal.titleTreble);
    expect(def.needsPro, isTrue);
    expect(def.canContinue, isTrue);
    expect(def.difficulty, CampaignDifficulty.hard);
    expect(def.goldenGeneration, isFalse);
    expect(def.donorNationId, isNull);
    expect(Campaigns.byId('legacy'), def);
    expect(nations.firstWhere((n) => n.id == spain).name, 'Spain');
  });

  test('seed 2024: Spain host neither championship, and play qualifying', () {
    const def = Campaigns.legacy;
    expect(
      WorldCupHosts.hostsFor(
        year: CareerService.worldCupYear(0),
        nations: nations,
        seed: def.rngSeed,
      ),
      isNot(contains(spain)),
    );
    expect(
      WorldCupHosts.continentalQualifiers(
        confederation: Confederation.europe,
        cycle: 0,
        seed: def.rngSeed,
        nations: nations,
      ).map((n) => n.id),
      contains(spain),
    );
  });

  test('one cycle holds all three titles: Spain start a top side in League A '
      'of the Nations Cup, played between the two championships', () async {
    final id = await start();
    final tables = await comp().tournamentGroupTables(
      id,
      CompetitionKind.nationsLeague,
      confederation: Confederation.europe,
    );
    final mine = tables.firstWhere(
      (t) => t.standings.any((s) => s.nationId == spain),
    );
    expect(NationsCup.tierOfGroupName(mine.name), 0, reason: mine.name);
    final group = [
      for (final f in await comp().cycleFixturesForNation(id, spain))
        if (f.round == 'NGROUP') f,
    ];
    expect(group, isNotEmpty);
    // After the European Championship (June of the World Championship year
    // minus two), done before the year of the World Championship; the
    // Finals Four follows in June of the year before it.
    final euroYear = CareerService.continentalFinalsYear(0);
    for (final f in group) {
      expect(f.date.isAfter(DateTime(euroYear, 7)), isTrue, reason: '$f');
      expect(f.date.isBefore(DateTime(euroYear + 1)), isTrue, reason: '$f');
    }
    final p = await progress(id);
    expect(p.nationsCupRun, isNotNull);
    expect(p.nationsCupRun!.ordinal, inInclusiveRange(1, 4));
    expect(p.nationsCupRun!.over, isFalse);
    expect(p.reached, 0);
    expect(p.settled, isFalse);
  });

  test('one star: the European title; the run goes on', () async {
    final id = await start();
    await euro(id, spainWins: true);
    final p = await progress(id);
    expect(p.reached, 1);
    expect(p.settled, isFalse);
  });

  test('the Nations Cup alone adds nothing to the European title', () async {
    final id = await start();
    await euro(id, spainWins: true);
    await nationsCup(id, spainWins: true);
    final p = await progress(id);
    expect(p.nationsCupRun, (ordinal: 7, over: true));
    expect(p.reached, 1);
    expect(p.settled, isFalse);
  });

  test('two stars: European and world titles, the Nations Cup lost', () async {
    final id = await start();
    await euro(id, spainWins: true);
    await nationsCup(id, spainWins: false);
    expect((await progress(id)).nationsCupRun, (ordinal: 6, over: true));
    await world(id, spainWins: true);
    final p = await progress(id);
    expect(p.reached, 2);
    expect(p.settled, isTrue);
    expect(p.stars, 2);
  });

  test('three stars: the treble settles it', () async {
    final id = await start();
    await euro(id, spainWins: true);
    await nationsCup(id, spainWins: true);
    await world(id, spainWins: true);
    final p = await progress(id);
    expect(p.reached, 3);
    expect(p.settled, isTrue);
    expect(p.stars, 3);
  });

  test('losing the European Championship fails it there and then', () async {
    final id = await start();
    await euro(id, spainWins: false);
    var p = await progress(id);
    expect(p.settled, isTrue);
    expect(p.stars, 0);
    // A world title after it changes nothing: every star needs the first.
    await world(id, spainWins: true);
    p = await progress(id);
    expect(p.stars, 0);
  });

  test('the European title kept, the world lost: one star at the cycle '
      'end', () async {
    final id = await start();
    await euro(id, spainWins: true);
    await nationsCup(id, spainWins: true);
    await world(id, spainWins: false);
    final p = await progress(id);
    expect(p.settled, isTrue);
    expect(p.stars, 1);
  });

  test('a sacking at the cycle end keeps the banked European title', () async {
    sackedAtEnd = true;
    final id = await start();
    await euro(id, spainWins: true);
    await world(id, spainWins: false);
    final p = await progress(id);
    expect(p.settled, isTrue);
    expect(p.stars, 1);
  });

  test(
    'a sacking with nothing banked fails it, as any one-cycle run',
    () async {
      sackedAtEnd = true;
      final id = await start();
      await world(id, spainWins: false);
      final p = await progress(id);
      expect(p.settled, isTrue);
      expect(p.stars, 0);
    },
  );

  test('the real schedule: the Finals Four of the Nations Cup falls in June '
      'of the year before the World Championship', () async {
    final id = await start();
    final season = container.read(seasonServiceProvider);
    final wcYear = CareerService.worldCupYear(0);
    Future<List<DateTime>> semis() async => [
      for (final f in await comp().fixturesByRound(
        id,
        'NSF',
        kind: CompetitionKind.nationsLeague,
        confederation: Confederation.europe,
      ))
        f.date,
    ];
    var last = DateTime(1900);
    for (var i = 0; i < 600 && (await semis()).isEmpty; i++) {
      await season.advance(id);
      container.invalidate(hubDataProvider(id));
      final date = (await container.read(
        hubDataProvider(id).future,
      ))!.career.inGameDate;
      if (!date.isAfter(last) || date.year >= wcYear) break;
      last = date;
    }
    final dates = await semis();
    expect(dates, isNotEmpty, reason: 'the Finals Four is drawn in the cycle');
    for (final d in dates) {
      expect(d.year, wcYear - 1, reason: '$d');
      expect(d.month, 6, reason: '$d');
    }
  });

  test('the Nations Cup counts however it is crowned: a lone League A winner '
      'with no final is the champion', () async {
    final id = await start();
    await euro(id, spainWins: true);
    await comp().recordHonour(
      careerId: id,
      year: CareerService.continentalFinalsYear(0),
      competition: 'Nations Cup',
      championId: spain,
      runnerUpId: europeans(1).single,
    );
    var p = await progress(id);
    expect(p.nationsCupRun, (ordinal: 7, over: true));
    await world(id, spainWins: true);
    p = await progress(id);
    expect(p.stars, 3);
  });
}
