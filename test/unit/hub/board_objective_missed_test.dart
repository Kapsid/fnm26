import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';

import '../../helpers/test_database.dart';

/// The board must answer a MISSED brief with the missed wording.
///
/// The manager's report was that the objectives news always arrived as "they
/// have what they asked for". The wording is picked from `met`, so these pin
/// `met` down from the two ends the sim can reach it from: a side that played
/// the tournament and went out early, and a side whose whole cycle was a
/// qualifying campaign that fell short.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// A container over a fresh in-memory save seeded with the real nations.
  ({ProviderContainer container, List<Nation> nations}) boot() {
    final db = createTestDatabase();
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);
    return (container: container, nations: nations);
  }

  test('a group-stage exit is answered as a missed brief', () async {
    final booted = boot();
    final container = booted.container;
    final nations = booted.nations;
    await container.read(seedLoaderProvider).ensureSeeded();
    // South America runs no qualifying, so its cup exists from the moment the
    // career is created — no two years of advancing to reach it.
    final player = nations
        .where((n) => n.confederation == Confederation.southAmerica)
        .reduce((a, b) => a.ranking <= b.ranking ? a : b);
    final career = (await container
            .read(careerServiceProvider)
            .create(nationId: player.id, managerName: 'M'))
        .valueOrNull!;

    final comp = container.read(competitionRepositoryProvider);
    await comp.markDrawWatched(career.id, career.cyclePointer, budgetSetupKind);
    // The hub keeps the objective chain alive from the moment the cycle opens,
    // so the grade the simulation later reads has a cached, pre-tournament
    // value sitting in front of it. That cache is what once swallowed the
    // verdict entirely; the news below is what proves it no longer does.
    container.listen(cycleObjectiveOutcomesProvider(career.id), (_, _) {});
    await container.read(cycleObjectiveOutcomesProvider(career.id).future);

    // The continent's best-ranked side is told to win it — and loses every
    // group game.
    final group = await comp.fixturesByRound(
      career.id,
      'CGROUP',
      kind: CompetitionKind.continentalFinals,
      confederation: Confederation.southAmerica,
    );
    for (final f in group) {
      final playerIsHome = f.homeNationId == career.nationId;
      final mine =
          playerIsHome || f.awayNationId == career.nationId;
      await comp.recordResult(
        fixtureId: f.id,
        homeScore: mine ? (playerIsHome ? 0 : 3) : 1,
        awayScore: mine ? (playerIsHome ? 3 : 0) : 0,
      );
    }
    // Someone else lifts the cup, which settles the brief.
    final others = nations
        .where(
          (n) =>
              n.confederation == Confederation.southAmerica &&
              n.id != career.nationId,
        )
        .toList();
    await comp.addKnockoutFixtures(
      careerId: career.id,
      round: 'CFINAL',
      kind: CompetitionKind.continentalFinals,
      confederation: Confederation.southAmerica,
      pairings: [(others[0].id, others[1].id)],
      date: DateTime(career.inGameDate.year + 1, 7),
    );
    final finals = await comp.fixturesByRound(
      career.id,
      'CFINAL',
      kind: CompetitionKind.continentalFinals,
      confederation: Confederation.southAmerica,
    );
    await comp.recordResult(
      fixtureId: finals.first.id,
      homeScore: 2,
      awayScore: 0,
    );
    await container.read(seasonServiceProvider).advance(career.id);

    container.invalidate(cycleObjectiveOutcomesProvider);
    final cont =
        (await container.read(
          cycleObjectiveOutcomesProvider(career.id).future,
        )).where((o) => o.tier == TournamentTier.continental).single;
    expect(cont.decided, isTrue);
    expect(cont.met, isFalse, reason: 'a group-stage exit is not winning it');

    final board = (await comp.messages(career.id))
        .where((m) => m.category == 'board')
        .toList();
    expect(board, hasLength(1));
    expect(board.single.title, contains('missed'));
    expect(board.single.body, isNot(contains('what they asked for')));
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('a qualifying campaign in the bottom half is a missed brief', () async {
    // The board's LOWEST rung. It used to be "do not finish last", which four
    // or five sides in every group of five clear without trying, so the verdict
    // on it was "they have what they asked for" whatever the campaign did —
    // printed next to a finish line that read "did not qualify". This is the
    // manager's report, reproduced.
    final booted = boot();
    final container = booted.container;
    final nations = booted.nations;
    await container.read(seedLoaderProvider).ensureSeeded();
    const conf = Confederation.northAmerica;
    // Well outside the continent's leading two dozen, so the brief is the
    // bottom rung: the qualifying campaign itself.
    final player = (nations.where((n) => n.confederation == conf).toList()
      ..sort((a, b) => a.ranking.compareTo(b.ranking)))[28];
    final career = (await container
            .read(careerServiceProvider)
            .create(nationId: player.id, managerName: 'M'))
        .valueOrNull!;
    final comp = container.read(competitionRepositoryProvider);
    final season = container.read(seasonServiceProvider);
    await comp.markDrawWatched(career.id, career.cyclePointer, budgetSetupKind);

    final myGroup = (await comp.tournamentGroupTables(
      career.id,
      CompetitionKind.continentalQualifying,
      confederation: conf,
    )).firstWhere((t) => t.standings.any((s) => s.nationId == career.nationId));
    final ids = myGroup.standings.map((s) => s.nationId).toList();
    expect(ids.length, greaterThanOrEqualTo(4));
    // A strict pecking order inside the group, with the manager's side in the
    // first BOTTOM-half place — below half the group, but not bottom of it.
    final slot = (ids.length + 1) ~/ 2;
    final rest = ids.where((id) => id != career.nationId);
    final order = [...rest.take(slot), career.nationId, ...rest.skip(slot)];
    final place = {for (var i = 0; i < order.length; i++) order[i]: i};

    for (final f in await comp.fixturesByRound(
      career.id,
      'CQ',
      kind: CompetitionKind.continentalQualifying,
      confederation: conf,
    )) {
      final h = place[f.homeNationId];
      final a = place[f.awayNationId];
      final homeWins = h == null || a == null || h < a;
      await comp.recordResult(
        fixtureId: f.id,
        homeScore: homeWins ? 2 : 0,
        awayScore: homeWins ? 0 : 2,
      );
    }
    final finished = (await comp.tournamentGroupTables(
      career.id,
      CompetitionKind.continentalQualifying,
      confederation: conf,
    )).firstWhere((t) => t.standings.any((s) => s.nationId == career.nationId));
    final pos =
        finished.standings.indexWhere((s) => s.nationId == career.nationId) + 1;
    expect(pos, greaterThan((finished.standings.length + 1) ~/ 2));
    expect(pos, lessThan(finished.standings.length), reason: 'not bottom');

    // Qualifying is over, so the cup is drawn without them: the brief settles.
    for (var i = 0; i < 12; i++) {
      final drawn = await comp.fixturesByRound(
        career.id,
        'CGROUP',
        kind: CompetitionKind.continentalFinals,
        confederation: conf,
      );
      if (drawn.isNotEmpty) break;
      await season.advance(career.id);
    }

    container.invalidate(cycleObjectiveOutcomesProvider);
    final cont =
        (await container.read(
          cycleObjectiveOutcomesProvider(career.id).future,
        )).where((o) => o.tier == TournamentTier.continental).single;
    expect(cont.target, 1, reason: 'the board asks for the campaign itself');
    expect(cont.decided, isTrue);
    expect(
      cont.met,
      isFalse,
      reason: 'the bottom half of the group is short of the bottom rung',
    );

    final board = (await comp.messages(career.id))
        .where((m) => m.category == 'board')
        .toList();
    expect(board, hasLength(1));
    expect(board.single.title, contains('missed'));
    expect(board.single.body, isNot(contains('what they asked for')));
  }, timeout: const Timeout(Duration(minutes: 5)));
}
