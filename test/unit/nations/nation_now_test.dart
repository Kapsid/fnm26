import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/draw_reveal.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/nations/nation_now_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

void main() {
  late ProviderContainer c;
  late int careerId;
  late int ownId;
  late int rngSeed;
  late List<Nation> nations;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    addTearDown(db.close);
    List<T> load<T>(String f, T Function(Map<String, Object?>) from) =>
        (jsonDecode(File('assets/data/$f').readAsStringSync()) as List)
            .map((e) => from(e as Map<String, Object?>))
            .toList();
    nations = load('nations.json', Nation.fromJson);
    final players = load('players.json', Player.fromJson);
    c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final europe =
        nations.where((n) => n.confederation == Confederation.europe).toList()
          ..sort((a, b) => a.ranking.compareTo(b.ranking));
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: europe[10].id, managerName: 'M', rngSeed: 7))
            .valueOrNull!;
    careerId = career.id;
    ownId = career.nationId;
    rngSeed = career.rngSeed;
  });

  Future<NationNow> now(int nationId) async {
    final result = await c.read(
      nationNowProvider((careerId: careerId, nationId: nationId)).future,
    );
    return result!;
  }

  test('another nation: ranking, form, next, squad and against-you', () async {
    final comp = c.read(competitionRepositoryProvider);
    final mine = await comp.cycleFixturesForNation(careerId, ownId);
    // An opponent the manager meets at least twice.
    final counts = <int, List<Fixture>>{};
    for (final f in mine) {
      final other = f.homeNationId == ownId ? f.awayNationId : f.homeNationId;
      (counts[other] ??= []).add(f);
    }
    final x = counts.entries.firstWhere((e) => e.value.length >= 2);
    final meetings = [...x.value]..sort((a, b) => a.date.compareTo(b.date));
    await comp.recordResult(
      fixtureId: meetings[0].id,
      homeScore: 2,
      awayScore: 0,
    );
    await comp.recordResult(
      fixtureId: meetings[1].id,
      homeScore: 1,
      awayScore: 1,
    );

    // The draws are watched, so the schedule is open.
    for (final kind in const [
      worldCupQualDrawKind,
      continentalQualDrawKind,
      continentalFinalsDrawKind,
      worldCupDrawKind,
    ]) {
      await comp.markDrawWatched(careerId, 0, kind);
    }
    final n = await now(x.key);
    final ranking = (await c.read(worldRankingProvider(careerId).future))!;
    expect(n.rank, ranking.position[x.key]);
    expect(n.points, ranking.points[x.key]);
    expect(n.movement, ranking.movement[x.key]);
    expect(n.isPlayerNation, isFalse);

    expect(n.form, hasLength(2));
    expect(n.form[0].fixture.id, meetings[1].id);
    expect(n.form[0].outcome, 'D');
    expect(n.form[1].fixture.id, meetings[0].id);
    final firstHome = meetings[0].homeNationId == x.key;
    expect(n.form[1].outcome, firstHome ? 'W' : 'L');
    expect(n.form[1].opponentId, ownId);

    final unplayed = [
      for (final f in await comp.cycleFixturesForNation(careerId, x.key))
        if (!f.played) f,
    ]..sort((a, b) => a.date.compareTo(b.date));
    expect(n.next!.id, unplayed.first.id);

    expect(n.topPlayers, hasLength(3));
    for (var i = 1; i < 3; i++) {
      expect(
        n.topPlayers[i - 1].overall,
        greaterThanOrEqualTo(n.topPlayers[i].overall),
      );
    }
    final pool = await c
        .read(playerRepositoryProvider)
        .byNation(
          x.key,
          saveSeed: rngSeed,
          careerId: careerId,
          agingYears: CareerService.agingYears(
            (await c.read(careerRepositoryProvider).byId(careerId))!,
          ),
        );
    final byId = {for (final p in pool) p.id: p};
    final xi = [
      for (final id in bestEleven(Formation.f433, pool)) byId[id]!,
    ];
    expect(n.overall, squadOverall(xi));

    expect(n.againstYou!.record.played, 2);
    expect(n.againstYou!.last!.id, meetings[1].id);
  });

  test('next match is hidden until its draw has been watched', () async {
    final comp = c.read(competitionRepositoryProvider);
    final mine = await comp.cycleFixturesForNation(careerId, ownId);
    final drawn = mine.firstWhere((f) => drawKindForFixture(f) != null);
    final other = drawn.homeNationId == ownId
        ? drawn.awayNationId
        : drawn.homeNationId;
    final before = await now(other);
    expect(
      before.next == null || drawKindForFixture(before.next!) == null,
      isTrue,
      reason: 'an undrawn opponent must not be named',
    );
    await comp.markDrawWatched(careerId, 0, drawKindForFixture(drawn)!);
    c.invalidate(
      nationNowProvider((careerId: careerId, nationId: other)),
    );
    final after = await now(other);
    expect(after.next, isNotNull);
  });

  test('a player who is out is left out of the squad shown', () async {
    final other = nations.firstWhere((n) => n.id != ownId).id;
    final before = await now(other);
    final star = before.topPlayers.first;
    await c.read(absenceRepositoryProvider).replace(careerId, [
      PlayerAbsence(playerId: star.id, injuryMatches: 3),
    ]);
    c.invalidate(nationNowProvider((careerId: careerId, nationId: other)));
    final after = await now(other);
    expect(after.topPlayers.map((p) => p.id), isNot(contains(star.id)));
  });

  test('own nation: overall from the current lineup, no against-you', () async {
    final n = await now(ownId);
    final data = (await c.read(tacticDataProvider(careerId).future))!;
    final lineup = [
      for (final id in data.tactic.lineup)
        if (id != null) data.byId[id]!,
    ];
    expect(n.isPlayerNation, isTrue);
    expect(n.overall, squadOverall(lineup));
    expect(n.againstYou, isNull);
  });

  test(
    'a nation with no fixtures: empty form, no next, ranking shown',
    () async {
      final comp = c.read(competitionRepositoryProvider);
      int? idle;
      for (final nation in nations) {
        if (nation.id == ownId) continue;
        if ((await comp.fixturesForNation(careerId, nation.id)).isEmpty) {
          idle = nation.id;
          break;
        }
      }
      expect(idle, isNotNull, reason: 'a fresh save has an undrawn nation');
      final n = await now(idle!);
      expect(n.form, isEmpty);
      expect(n.next, isNull);
      expect(n.againstYou, isNull);
      expect(n.rank, isNotNull);
      expect(n.overall, isNotNull);
    },
  );
}
