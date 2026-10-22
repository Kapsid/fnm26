import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/career_pool.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/nations/nation_now_providers.dart';
import 'package:fnm/features/tactics/nation_squad_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

const int _italy = 26;
const int _sanMarino = 45;

/// A Ref to hand the career-pool helpers, which take one like a provider does.
final Provider<Ref> _refProvider = Provider<Ref>((ref) => ref);

/// "A naturalised player plays for one nation only, everywhere."
///
/// The naturalisation used to be read only by the manager's own pools: the
/// player was added to the nation that naturalised him and never taken out of
/// the one he left. So Italy's best man played for San Marino in the
/// manager's matches and for Italy in the rest of the world, the background
/// simulation and the match preview against Italy included.
void main() {
  late AppDatabase db;
  late ProviderContainer c;
  late Career career;
  late Player star;

  Future<Career> reload() async =>
      (await c.read(careerRepositoryProvider).byId(career.id))!;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = createTestDatabase();
    addTearDown(db.close);
    List<T> load<T>(String f, T Function(Map<String, Object?>) from) =>
        (jsonDecode(File('assets/data/$f').readAsStringSync()) as List)
            .map((e) => from(e as Map<String, Object?>))
            .toList();
    c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(
            nationList: load('nations.json', Nation.fromJson),
            playerList: load('players.json', Player.fromJson),
          ),
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: _sanMarino, managerName: 'M', rngSeed: 7))
            .valueOrNull!;
  });

  Future<void> naturaliseItalysBest() async {
    star =
        (await c
                .read(playerRepositoryProvider)
                .byNation(
                  _italy,
                  agingYears: CareerService.agingYears(career),
                  saveSeed: career.rngSeed,
                  careerId: career.id,
                ))
            .first;
    final repo = c.read(careerRepositoryProvider);
    await repo.addNaturalizationOffer(
      careerId: career.id,
      playerId: star.id,
      sourceNationId: _italy,
      cycle: 0,
    );
    await repo.setNaturalizationStatus(career.id, star.id, 'accepted');
  }

  /// Puts a friendly against Italy ahead of everything else on San Marino's
  /// calendar, so the next match (previewed or skipped) is against Italy.
  Future<void> italyNext() async {
    final comp = c.read(competitionRepositoryProvider);
    final first = (await comp.nextFixtureForNation(career.id, _sanMarino))!;
    await comp.saveFriendlies(
      careerId: career.id,
      nationId: _sanMarino,
      cycle: career.cyclePointer,
      friendlies: [
        (
          date: first.date.subtract(const Duration(days: 2)),
          opponentId: _italy,
          home: true,
        ),
      ],
    );
    final next = (await comp.nextFixtureForNation(career.id, _sanMarino))!;
    expect(next.awayNationId, _italy, reason: 'the friendly must come first');
  }

  test('a naturalised player leaves the pool of the nation he left', () async {
    await naturaliseItalysBest();
    final ref = c.read(_refProvider);

    final italy = await careerPoolOf(ref, career, _italy);
    expect(italy.map((p) => p.id), isNot(contains(star.id)));

    final sanMarino = await careerPoolOf(ref, career, _sanMarino);
    final him = sanMarino.where((p) => p.id == star.id).toList();
    expect(him, hasLength(1), reason: 'he joins the nation he switched to');
    expect(him.single.nationId, _sanMarino);
    for (var i = 1; i < sanMarino.length; i++) {
      expect(
        sanMarino[i - 1].overall,
        greaterThanOrEqualTo(sanMarino[i].overall),
        reason: 'the pool stays ordered best first',
      );
    }

    // The manager's own pools: his naturalised man, re-homed.
    final mine = await naturalizedPlayersFor(ref, career);
    expect(mine.map((p) => (p.id, p.nationId)), [(star.id, _sanMarino)]);
    expect(
      await naturalizedAwayIds(
        c.read(careerRepositoryProvider),
        career.id,
      ),
      {star.id},
    );
    final squad = (await c.read(nationSquadProvider(career.id).future))!;
    expect(squad.rows.map((r) => r.player.id), contains(star.id));
  });

  test(
    'he stays with the nation that naturalised him after the manager moves',
    () async {
      await naturaliseItalysBest();
      final repo = c.read(careerRepositoryProvider);
      // The manager takes the Italy job for the next cycle.
      await repo.switchNation(career.id, _italy);
      await repo.recordStint(career.id, 1, _italy);
      career = await reload();
      final ref = c.read(_refProvider);

      expect(
        (await careerPoolOf(ref, career, _sanMarino)).map((p) => p.id),
        contains(star.id),
      );
      expect(
        (await careerPoolOf(ref, career, _italy)).map((p) => p.id),
        isNot(contains(star.id)),
      );
      // Not even on Italy's own squad screen, now that Italy is his.
      expect(await naturalizedPlayersFor(ref, career), isEmpty);
      final squad = (await c.read(nationSquadProvider(career.id).future))!;
      expect(squad.rows.map((r) => r.player.id), isNot(contains(star.id)));
    },
  );

  test("a team page shows him for his new nation, not his old one", () async {
    await naturaliseItalysBest();
    Future<List<int>> topOf(int nationId) async => [
      for (final p in (await c.read(
        nationNowProvider((careerId: career.id, nationId: nationId)).future,
      ))!.topPlayers)
        p.id,
    ];
    // Italy's page, read as another nation's: without the man it lost.
    expect(await topOf(_italy), isNot(contains(star.id)));

    // And once the manager has moved on, San Marino's page, read as another
    // nation's, still has him.
    final repo = c.read(careerRepositoryProvider);
    await repo.switchNation(career.id, _italy);
    await repo.recordStint(career.id, 1, _italy);
    career = await reload();
    expect(await topOf(_sanMarino), contains(star.id));
  });

  test('the match preview against Italy fields Italy without him', () async {
    await naturaliseItalysBest();
    await italyNext();
    final preview = (await c.read(matchPreviewProvider(career.id).future))!;
    final italySide = preview.homeTeam.nationId == _italy
        ? preview.homeTeam
        : preview.awayTeam;
    final mySide = identical(italySide, preview.homeTeam)
        ? preview.awayTeam
        : preview.homeTeam;
    expect(italySide.nationId, _italy);
    expect(italySide.xi.map((p) => p.id), isNot(contains(star.id)));
    expect(preview.opponentBench.map((p) => p.id), isNot(contains(star.id)));
    expect(
      [...mySide.xi, ...preview.bench].map((p) => p.id),
      contains(star.id),
      reason: "he is San Marino's best player now",
    );
  });

  test(
    'the background simulation fields him for San Marino, never Italy',
    () async {
      await naturaliseItalysBest();
      await italyNext();
      final comp = c.read(competitionRepositoryProvider);
      final next = (await comp.nextFixtureForNation(career.id, _sanMarino))!;
      // Skipped: the world, his own fixture included, is quick-simmed.
      await c.read(seasonServiceProvider).advance(career.id);
      final played = (await db.select(db.fixtures).get()).firstWhere(
        (f) => f.id == next.id,
      );
      expect(played.played, isTrue);
      final rows = await (db.select(
        db.appearances,
      )..where((t) => t.playerId.equals(star.id))).get();
      expect(rows.map((r) => r.nationId), [_sanMarino]);
    },
  );

  test(
    'a career with no naturalisations sees exactly the seeded pools',
    () async {
      final ref = c.read(_refProvider);
      final players = c.read(playerRepositoryProvider);
      for (final id in [_italy, _sanMarino, 14, 20]) {
        final seeded = await players.byNation(
          id,
          agingYears: CareerService.agingYears(career),
          saveSeed: career.rngSeed,
          careerId: career.id,
        );
        final pool = await careerPoolOf(ref, career, id);
        expect(
          pool.map((p) => (p.id, p.nationId, p.overall)).toList(),
          seeded.map((p) => (p.id, p.nationId, p.overall)).toList(),
        );
      }
    },
  );
}
