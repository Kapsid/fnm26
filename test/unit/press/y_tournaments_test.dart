import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/y/y_providers.dart';

import '../../helpers/test_database.dart';

/// The feed reacts to the tournaments, not only to the scorelines.
///
/// `YFeed.forEvent` was written, given four phrasings per template in two
/// languages, given its own tests — and never called by the app. A manager
/// could win the World Cup and the country would post four reports about the
/// final and not one word about the trophy. These tests are about the WIRING,
/// so they go through the provider rather than the pure layer.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late List<Nation> nations;
  late List<Player> players;

  ProviderContainer open() {
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  setUp(() async {
    db = createTestDatabase();
    addTearDown(db.close);
    nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    container = open();
    await container.read(seedLoaderProvider).ensureSeeded();
  });

  /// Plays out the nation's Nations Cup group, and returns its fixtures.
  ///
  /// [win] decides whether the manager's side takes every game or loses every
  /// game, which is the difference between topping the group and finishing
  /// bottom of it.
  Future<List<Fixture>> playNationsCupGroup(
    Career career, {
    required bool win,
  }) async {
    final comp = container.read(competitionRepositoryProvider);
    final fixtures = await comp.fixturesForNation(career.id, career.nationId);
    final group = [
      for (final f in fixtures)
        if (f.round == 'NGROUP') f,
    ];
    expect(group, isNotEmpty, reason: 'a new career is in the Nations Cup');
    for (final f in group) {
      final home = f.homeNationId == career.nationId;
      await comp.recordResult(
        fixtureId: f.id,
        homeScore: home == win ? 3 : 0,
        awayScore: home == win ? 0 : 3,
      );
    }
    return group;
  }

  /// Draws the Finals Four between two nations that are NOT the manager's, so
  /// the tournament has visibly moved on without him.
  Future<void> drawFinalsFourWithout(Career career) async {
    final comp = container.read(competitionRepositoryProvider);
    final others = [
      for (final n in nations)
        if (n.id != career.nationId) n.id,
    ].take(2).toList();
    await comp.addKnockoutFixtures(
      careerId: career.id,
      round: 'NSF',
      kind: CompetitionKind.nationsLeague,
      pairings: [(others[0], others[1])],
      date: DateTime(2030, 6, 18),
    );
  }

  test('a tournament that moved on without you is talked about', () async {
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;
    await playNationsCupGroup(career, win: false);
    await drawFinalsFourWithout(career);

    final feed = await open().read(yFeedProvider(career.id).future);
    expect(
      feed.map((p) => p.template),
      contains(YTemplate.eliminated),
      reason: 'going out of a tournament is news, and used to be silence',
    );
  });

  test('a group WINNER is never told he has been eliminated', () async {
    // The reported bug. The Nations Cup is one competition with several
    // leagues stacked inside it, so the Finals Four exists whether or not the
    // manager's group feeds it — and "no fixtures left" read as "out" told a
    // side that had just won its group that its tournament had ended badly.
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;
    await playNationsCupGroup(career, win: true);
    await drawFinalsFourWithout(career);

    final feed = await open().read(yFeedProvider(career.id).future);
    expect(
      feed.map((p) => p.template),
      isNot(contains(YTemplate.eliminated)),
      reason: 'topping a group is not an elimination',
    );
  });

  test('a group finish says nothing while the draw is still to come', () async {
    // Between the last group game and the knockout draw a side has no
    // fixtures left and has gone out of nothing.
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;
    await playNationsCupGroup(career, win: false);

    final feed = await open().read(yFeedProvider(career.id).future);
    expect(
      feed.map((p) => p.template),
      isNot(contains(YTemplate.eliminated)),
      reason: 'nothing has moved on yet, so nothing has been decided',
    );
  });

  test('a campaign still being played draws no obituary', () async {
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;
    final comp = container.read(competitionRepositoryProvider);
    final fixtures = await comp.fixturesForNation(career.id, career.nationId);
    final group = [
      for (final f in fixtures)
        if (f.round == 'NGROUP') f,
    ];
    // All but the last: the side is still in it.
    for (final f in group.take(group.length - 1)) {
      await comp.recordResult(fixtureId: f.id, homeScore: 0, awayScore: 1);
    }

    final feed = await open().read(yFeedProvider(career.id).future);
    expect(
      feed.map((p) => p.template),
      isNot(contains(YTemplate.eliminated)),
      reason: 'a side with a match left to play has not gone out',
    );
  });

  test(
    'a qualifying campaign is not credited with somebody else\'s cup',
    () async {
      // The Nations Cup runs ALONGSIDE continental qualifying. A rule as loose
      // as "a tournament started after this campaign ended" would read the
      // Nations Cup as the finals the qualifiers earned a place at, and announce
      // a place booked for a campaign that had just been lost.
      final career =
          (await container
                  .read(careerServiceProvider)
                  .create(nationId: nations.first.id, managerName: 'M'))
              .valueOrNull!;
      final comp = container.read(competitionRepositoryProvider);
      final fixtures = await comp.fixturesForNation(career.id, career.nationId);
      final qualifiers = [
        for (final f in fixtures)
          if (f.round == 'CQ') f,
      ];
      expect(qualifiers, isNotEmpty);
      // Lost the lot: this campaign booked nothing.
      for (final f in qualifiers) {
        final home = f.homeNationId == career.nationId;
        await comp.recordResult(
          fixtureId: f.id,
          homeScore: home ? 0 : 3,
          awayScore: home ? 3 : 0,
        );
      }

      final feed = await open().read(yFeedProvider(career.id).future);
      expect(
        feed.map((p) => p.template),
        isNot(contains(YTemplate.qualified)),
        reason: 'a campaign lost outright books no place at anything',
      );
    },
  );
}
