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
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/campaign/campaign_record_store.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// A campaign's goal is graded from what the save has recorded: the Grudge
/// from Georgia's qualifying table against Albania's, the Transplant from how
/// far San Marino went in the European Championship.
/// The Grudge's rival.
const albania = 1;

void main() {
  late ProviderContainer container;
  late List<Nation> nations;
  // What the board decides at the cycle's end, for the tests that reach it.
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
        premiumUnlockedProvider.overrideWith((ref) => false),
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

  Future<CampaignProgress?> progress(int careerId) {
    container.invalidate(campaignProgressProvider(careerId));
    return container.read(campaignProgressProvider(careerId).future);
  }

  /// The European qualifying group holding [nationId], as nation ids.
  Future<List<int>> qualifyingGroupOf(int careerId, int nationId) async {
    final tables = await container
        .read(competitionRepositoryProvider)
        .tournamentGroupTables(
          careerId,
          CompetitionKind.continentalQualifying,
          confederation: Confederation.europe,
        );
    final t = tables.firstWhere(
      (t) => t.standings.any((s) => s.nationId == nationId),
    );
    return [for (final s in t.standings) s.nationId];
  }

  /// Plays every qualifying fixture of the group so it finishes in [order]:
  /// the side higher in [order] wins each meeting 1-0.
  Future<void> playGroup(int careerId, List<int> order) async {
    final comp = container.read(competitionRepositoryProvider);
    final members = order.toSet();
    final seen = <int>{};
    for (final id in order) {
      for (final f in await comp.cycleFixturesForNation(careerId, id)) {
        if (f.round != 'CQ' || !seen.add(f.id)) continue;
        if (!members.contains(f.homeNationId) ||
            !members.contains(f.awayNationId)) {
          continue;
        }
        final homeAbove =
            order.indexOf(f.homeNationId) < order.indexOf(f.awayNationId);
        await comp.recordResult(
          fixtureId: f.id,
          homeScore: homeAbove ? 1 : 0,
          awayScore: homeAbove ? 0 : 1,
        );
      }
    }
  }

  /// European nations outside [exclude], strongest first.
  List<int> othersIn(Set<int> exclude) => [
    for (final n in nations)
      if (n.confederation == Confederation.europe && !exclude.contains(n.id)) n,
  ].map((n) => n.id).toList();

  /// Saves a European Championship finals draw of one group, [group].
  Future<void> drawFinals(int careerId, List<int> group) async {
    final career = await container
        .read(careerRepositoryProvider)
        .byId(careerId);
    await container
        .read(competitionRepositoryProvider)
        .saveTournamentGroups(
          careerId: careerId,
          cycle: career!.cyclePointer,
          confederation: Confederation.europe,
          kind: CompetitionKind.continentalFinals,
          name: 'European Championship',
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
          groupStart: DateTime(2028, 6, 8),
          round: 'CGROUP',
        );
  }

  Future<List<Fixture>> finalsGroupFixtures(int careerId) => container
      .read(competitionRepositoryProvider)
      .fixturesByRound(
        careerId,
        'CGROUP',
        kind: CompetitionKind.continentalFinals,
        confederation: Confederation.europe,
      );

  test('a normal career has no campaign progress', () async {
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: 26, managerName: 'M'))
            .valueOrNull!;
    expect(await progress(career.id), isNull);
  });

  test(
    'Grudge: above Albania, qualified, both meetings won is 3 stars',
    () async {
      final career = await container
          .read(campaignServiceProvider)
          .start(Campaigns.grudge, managerName: 'Me');
      final group = await qualifyingGroupOf(career.id, 19);
      expect(group, contains(albania));
      final rest = [...group]
        ..remove(19)
        ..remove(albania);
      final order = [rest[0], 19, rest[1], albania, ...rest.skip(2)];
      await playGroup(career.id, order);

      final before = (await progress(career.id))!;
      expect(before.def.id, 'grudge');
      expect(before.settled, isFalse);
      expect(before.myPosition, 2);
      expect(before.rivalPosition, 4);
      expect(before.rivalWins, 2);
      expect(before.rivalMatchesPlayed, 2);

      final field = othersIn(group.toSet()).take(3).toList();
      await drawFinals(career.id, [19, ...field]);
      final after = (await progress(career.id))!;
      expect(after.settled, isTrue);
      expect(after.ordinal, 2);
      expect(after.stars, 3);
    },
  );

  test(
    'Grudge: Albania above is settled with no stars once the group ends',
    () async {
      final career = await container
          .read(campaignServiceProvider)
          .start(Campaigns.grudge, managerName: 'Me');
      final group = await qualifyingGroupOf(career.id, 19);
      final rest = [...group]
        ..remove(19)
        ..remove(albania);
      await playGroup(career.id, [albania, 19, ...rest]);
      // Below the rival with the group played out: failed there and then, no
      // need to wait for the finals draw.
      final early = (await progress(career.id))!;
      expect(early.settled, isTrue);
      expect(early.stars, 0);
      await drawFinals(career.id, othersIn(group.toSet()).take(4).toList());
      final p = (await progress(career.id))!;
      expect(p.settled, isTrue);
      expect(p.myPosition, 2);
      expect(p.rivalPosition, 1);
      expect(p.stars, 0);
    },
  );

  test(
    'Transplant: missing from the finals draw is settled, 0 stars',
    () async {
      final career = await container
          .read(campaignServiceProvider)
          .start(Campaigns.transplant, managerName: 'Me');
      expect((await progress(career.id))!.settled, isFalse);
      await drawFinals(career.id, othersIn({45}).take(4).toList());
      final p = (await progress(career.id))!;
      expect(p.settled, isTrue);
      expect(p.ordinal, 0);
      expect(p.stars, 0);
    },
  );

  test(
    'Transplant: a settled run is refused the move into the saves',
    () async {
      final svc = container.read(campaignServiceProvider);
      final career = await svc.start(Campaigns.transplant, managerName: 'Me');
      await drawFinals(career.id, othersIn({45}).take(4).toList());
      expect((await progress(career.id))!.settled, isTrue);
      expect(Campaigns.transplant.canContinue, isFalse);
      expect(await svc.moveToSaves(career.id), CampaignMoveResult.notAllowed);
      // Nothing changed: still an unmoved run, holding no slot.
      expect(await container.read(campaignRunsProvider.future), isNotEmpty);
      expect(
        (await container.read(campaignOfProvider(career.id).future))!.moved,
        isFalse,
      );
    },
  );

  test(
    'Grudge and Guineas can be continued; a settled Grudge is moved',
    () async {
      expect(Campaigns.grudge.canContinue, isTrue);
      expect(Campaigns.guineas.canContinue, isTrue);
      final svc = container.read(campaignServiceProvider);
      final career = await svc.start(Campaigns.grudge, managerName: 'Me');
      final group = await qualifyingGroupOf(career.id, 19);
      final rest = [...group]
        ..remove(19)
        ..remove(albania);
      await playGroup(career.id, [albania, 19, ...rest]);
      expect((await progress(career.id))!.settled, isTrue);
      expect(await svc.moveToSaves(career.id), CampaignMoveResult.moved);
      container.invalidate(campaignOfProvider(career.id));
      expect(
        (await container.read(campaignOfProvider(career.id).future))!.moved,
        isTrue,
      );
    },
  );

  test('Transplant: drawn and out in the group is 1 star', () async {
    final career = await container
        .read(campaignServiceProvider)
        .start(Campaigns.transplant, managerName: 'Me');
    final field = othersIn({45}).take(3).toList();
    await drawFinals(career.id, [45, ...field]);
    final comp = container.read(competitionRepositoryProvider);
    for (final f in await finalsGroupFixtures(career.id)) {
      final smHome = f.homeNationId == 45;
      final smAway = f.awayNationId == 45;
      await comp.recordResult(
        fixtureId: f.id,
        homeScore: smAway ? 2 : 1,
        awayScore: smHome ? 2 : 1,
      );
    }
    // Group played, San Marino unplaced; still running until the knockout
    // draw names the field without them.
    expect((await progress(career.id))!.settled, isFalse);
    await comp.addKnockoutFixtures(
      careerId: career.id,
      round: 'CR16',
      pairings: [(field[0], field[1])],
      date: DateTime(2028, 6, 28),
      kind: CompetitionKind.continentalFinals,
      confederation: Confederation.europe,
    );
    final p = (await progress(career.id))!;
    expect(p.settled, isTrue);
    expect(p.ordinal, 2);
    expect(p.stars, 1);
  });

  /// Records a World Championship final, which ends the cycle.
  Future<void> decideWorldChampionship(int careerId) async {
    final comp = container.read(competitionRepositoryProvider);
    final career = await container
        .read(careerRepositoryProvider)
        .byId(careerId);
    await comp.createKnockout(
      careerId: careerId,
      cycle: career!.cyclePointer,
      confederation: Confederation.europe,
      kind: CompetitionKind.worldCupFinals,
      name: 'World Championship',
      pairings: [(26, 1)],
      date: DateTime(2030, 7, 19),
      firstRound: 'FINAL',
    );
    final fin = await comp.fixturesByRound(careerId, 'FINAL');
    await comp.recordResult(
      fixtureId: fin.single.id,
      homeScore: 1,
      awayScore: 0,
    );
  }

  /// San Marino drawn into the finals and beaten in every group game; with
  /// [knockoutDrawn] the last 16 is drawn without them (the run is over).
  Future<void> transplantOutInGroup(
    int careerId, {
    required bool knockoutDrawn,
  }) async {
    final field = othersIn({45}).take(3).toList();
    await drawFinals(careerId, [45, ...field]);
    final comp = container.read(competitionRepositoryProvider);
    for (final f in await finalsGroupFixtures(careerId)) {
      await comp.recordResult(
        fixtureId: f.id,
        homeScore: f.awayNationId == 45 ? 2 : 1,
        awayScore: f.homeNationId == 45 ? 2 : 1,
      );
    }
    if (!knockoutDrawn) return;
    await comp.addKnockoutFixtures(
      careerId: careerId,
      round: 'CR16',
      pairings: [(field[0], field[1])],
      date: DateTime(2028, 6, 28),
      kind: CompetitionKind.continentalFinals,
      confederation: Confederation.europe,
    );
  }

  test('a verdict reached before the cycle ends survives a sacking', () async {
    sackedAtEnd = true;
    final career = await container
        .read(campaignServiceProvider)
        .start(Campaigns.transplant, managerName: 'Me');
    await transplantOutInGroup(career.id, knockoutDrawn: true);
    expect((await progress(career.id))!.stars, 1);
    await decideWorldChampionship(career.id);
    final p = (await progress(career.id))!;
    expect(p.settled, isTrue);
    expect(p.stars, 1);
  });

  test('an open campaign at the cycle end is judged as it stands', () async {
    final career = await container
        .read(campaignServiceProvider)
        .start(Campaigns.transplant, managerName: 'Me');
    await transplantOutInGroup(career.id, knockoutDrawn: false);
    expect((await progress(career.id))!.settled, isFalse);
    await decideWorldChampionship(career.id);
    final p = (await progress(career.id))!;
    expect(p.settled, isTrue);
    expect(p.stars, 1);
  });

  test('a sacking at the cycle end fails an open campaign', () async {
    sackedAtEnd = true;
    final career = await container
        .read(campaignServiceProvider)
        .start(Campaigns.transplant, managerName: 'Me');
    await transplantOutInGroup(career.id, knockoutDrawn: false);
    expect((await progress(career.id))!.settled, isFalse);
    await decideWorldChampionship(career.id);
    final p = (await progress(career.id))!;
    expect(p.settled, isTrue);
    expect(p.stars, 0);
  });

  test('the World Championship decided settles an open campaign', () async {
    final career = await container
        .read(campaignServiceProvider)
        .start(Campaigns.transplant, managerName: 'Me');
    final comp = container.read(competitionRepositoryProvider);
    await comp.createKnockout(
      careerId: career.id,
      cycle: career.cyclePointer,
      confederation: Confederation.europe,
      kind: CompetitionKind.worldCupFinals,
      name: 'World Championship',
      pairings: [(26, 1)],
      date: DateTime(2030, 7, 19),
      firstRound: 'FINAL',
    );
    final fin = await comp.fixturesByRound(career.id, 'FINAL');
    await comp.recordResult(
      fixtureId: fin.single.id,
      homeScore: 1,
      awayScore: 0,
    );
    final p = (await progress(career.id))!;
    expect(p.settled, isTrue);
    expect(p.stars, 0);
  });

  /// A Grudge run settled as a failure: Albania above Georgia, group over.
  Future<int> settledGrudge() async {
    final career = await container
        .read(campaignServiceProvider)
        .start(Campaigns.grudge, managerName: 'Me');
    final group = await qualifyingGroupOf(career.id, 19);
    final rest = [...group]
      ..remove(19)
      ..remove(albania);
    await playGroup(career.id, [albania, 19, ...rest]);
    expect((await progress(career.id))!.settled, isTrue);
    return career.id;
  }

  Future<T> listenRead<T>(AutoDisposeFutureProvider<T> p) async {
    final sub = container.listen(p.future, (_, _) {});
    try {
      return await sub.read();
    } finally {
      sub.close();
    }
  }

  test(
    'a moved Grudge rolled into its next cycle is an ordinary save: no '
    'progress, no verdict, still listed',
    () async {
      final id = await settledGrudge();
      expect(
        await container.read(campaignServiceProvider).moveToSaves(id),
        CampaignMoveResult.moved,
      );
      await container
          .read(careerRepositoryProvider)
          .advanceCycle(id, 1, DateTime(2030, 9));
      container
        ..invalidate(hubDataProvider(id))
        ..invalidate(nextEventProvider(id));

      expect(await progress(id), isNull, reason: 'no campaign card');
      final e = await listenRead(nextEventProvider(id));
      expect(e.kind, isNot(HubEventKind.campaignVerdict));
      expect(
        (await container.read(savesProvider.future)).map((c) => c.id),
        contains(id),
      );
    },
  );

  test(
    'a settled run abandoned unacknowledged keeps its stamp (failed)',
    () async {
      final id = await settledGrudge();
      expect(
        await container.read(campaignBestProvider(Campaigns.grudge.id).future),
        isNull,
      );
      await container.read(campaignServiceProvider).abandon(id);
      expect(
        await container.read(campaignBestProvider(Campaigns.grudge.id).future),
        0,
      );
    },
  );

  test(
    'a settled run moved, then deleted unacknowledged, keeps its stamp',
    () async {
      final id = await settledGrudge();
      expect(
        await container.read(campaignServiceProvider).moveToSaves(id),
        CampaignMoveResult.moved,
      );
      await container.read(careerServiceProvider).delete(id);
      expect(
        await container.read(campaignBestProvider(Campaigns.grudge.id).future),
        0,
      );
    },
  );

  test('an unsettled run abandoned files no stamp', () async {
    final career = await container
        .read(campaignServiceProvider)
        .start(Campaigns.grudge, managerName: 'Me');
    await container.read(campaignServiceProvider).abandon(career.id);
    expect(
      await container.read(campaignBestProvider(Campaigns.grudge.id).future),
      isNull,
    );
  });
}
