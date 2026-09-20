import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  late AppDatabase db;
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

  setUp(() {
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
  });

  test('selectable drops a man injured for the next match', () {
    Player p(int id) => players.first.copyWith(id: id);
    final pool = [p(1), p(2), p(3)];
    const absences = {2: PlayerAbsence(playerId: 2, injuryMatches: 1)};
    expect(selectable(pool, absences).map((p) => p.id), [1, 3]);
  });

  test('a stored XI naming an injured man does not field him', () async {
    final c = open();
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;

    final squad = (await c.read(squadDataProvider(career.id).future))!;
    final named = squad.pool.take(kMaxSquadSize).map((p) => p.id).toSet();
    expect(
      await c.read(squadServiceProvider).setCallUps(career.id, named),
      isTrue,
    );
    c
      ..invalidate(squadDataProvider)
      ..invalidate(tacticDataProvider);

    final tactic = (await c.read(tacticDataProvider(career.id).future))!;
    final xi = tactic.tactic.lineup.whereType<int>().toList();
    expect(xi.length, 11, reason: 'a full XI must be named to start with');

    // He picks up a one-match knock AFTER the XI was saved.
    final hurt = xi.first;
    await c.read(absenceRepositoryProvider).replace(career.id, [
      PlayerAbsence(playerId: hurt, injuryMatches: 1),
    ]);
    c
      ..invalidate(squadDataProvider)
      ..invalidate(tacticDataProvider)
      ..invalidate(matchPreviewProvider);

    final preview = (await c.read(matchPreviewProvider(career.id).future))!;
    final mine = preview.playerIsHome ? preview.homeTeam : preview.awayTeam;
    expect(
      mine.xi.map((p) => p.id),
      isNot(contains(hurt)),
      reason: 'an injured man must not start',
    );
    expect(
      preview.bench.map((p) => p.id),
      isNot(contains(hurt)),
      reason: 'nor may he be brought on',
    );
  });

  test('a real run of matches never fields a man serving an absence', () async {
    final c = open();
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;
    final careerId = career.id;

    final comp = c.read(competitionRepositoryProvider);
    final absRepo = c.read(absenceRepositoryProvider);
    final season = c.read(seasonServiceProvider);
    final careers = c.read(careerRepositoryProvider);

    var played = 0;
    var absencesSeen = 0;
    for (var step = 0; step < 80 && played < 14; step++) {
      final now = (await careers.byId(careerId))!;
      final next = await comp.nextFixtureForNation(careerId, now.nationId);
      if (next == null) {
        await season.advance(careerId);
        c.invalidate(matchPreviewProvider);
        continue;
      }
      final before = await absRepo.forCareer(careerId);
      final out = {
        for (final e in before.entries)
          if (!e.value.isAvailable) e.key,
      };
      if (out.isNotEmpty) absencesSeen++;
      c.invalidate(matchPreviewProvider);
      final preview = await c.read(matchPreviewProvider(careerId).future);
      if (preview == null) break;
      final mine = preview.playerIsHome ? preview.homeTeam : preview.awayTeam;
      final fielded = mine.xi.map((p) => p.id).toSet();
      expect(
        fielded.intersection(out),
        isEmpty,
        reason:
            'match ${preview.fixture.id}: a banned/injured man was in the XI',
      );
      final featured = {
        for (final r in preview.result.ratings)
          if (r.teamNationId == now.nationId) r.playerId,
      };
      expect(
        featured.intersection(out),
        isEmpty,
        reason:
            'match ${preview.fixture.id}: a banned/injured man played a part',
      );
      await season.playPlayerMatch(careerId, preview.fixture, preview.result);
      played++;
    }
    expect(played, greaterThan(4), reason: 'the run must actually play out');
    expect(
      absencesSeen,
      greaterThan(0),
      reason: 'the run must actually produce a ban or a knock to test',
    );
  });

  /// The hole the bug report found.
  ///
  /// The manager's own fixtures are not always played out on the match screen:
  /// advancing the world plays them for him (see the hub's quick-sim), and that
  /// path builds its XI in [SeasonService], not from the tactics providers. It
  /// asked an in-memory absence cache that is only filled once a match has been
  /// played and its cards and knocks applied — so on the FIRST fixture any
  /// session simulated, the cache was empty, every absence read as "available",
  /// and a man carrying a one-match knock took the field in the very match he
  /// was missing.
  test('the first fixture a session simulates leaves the injured at home', () async {
    final setup = open();
    await setup.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await setup
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;
    final comp = setup.read(competitionRepositoryProvider);
    final due = await comp.unplayedDueBy(
      career.id,
      career.inGameDate.add(const Duration(days: 120)),
    );
    final first = due.first;
    final playerRepo = setup.read(playerRepositoryProvider);
    final hurt = <int>{};
    for (final n in [first.homeNationId, first.awayNationId]) {
      final pool = (await playerRepo.byNation(n, saveSeed: career.rngSeed))
        ..sort((a, b) => b.overall.compareTo(a.overall));
      // The eleven a best XI would certainly pick, all carrying a knock.
      hurt.addAll(pool.take(11).map((p) => p.id));
    }
    await setup.read(absenceRepositoryProvider).replace(career.id, [
      for (final id in hurt) PlayerAbsence(playerId: id, injuryMatches: 1),
    ]);

    // A FRESH session: nothing has been simulated yet, so nothing has had
    // occasion to load the absences.
    final fresh = open();
    await fresh.read(seasonServiceProvider).advance(career.id);

    final fielded = (await db.select(db.playerRatings).get())
        .where((r) => r.fixtureId == first.id && hurt.contains(r.playerId))
        .map((r) => r.playerId)
        .toSet();
    expect(
      fielded,
      isEmpty,
      reason: 'a man injured for this match may not play in it',
    );
  });
}
