import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_player_repository.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

/// A generated player is not a database row: he is reconstructed from his id
/// by [PlayerLifecycle.newgenById], and that reconstruction can only reach an
/// intake year that is not in the future. Ask for him with the default
/// `agingYears: 0` and every newgen who came in after the save opened is
/// outside the window, so the lookup returns null and the screen prints
/// "Unknown".
///
/// Which is exactly what the top-scorer lists of a late World Championship
/// were doing: by then most of the scorers are newgens.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const saveSeed = 4242;

  /// Three cycles in — far enough that most of the pool came through the
  /// youth intakes rather than off the seed.
  const agingYears = 12;

  late AppDatabase db;
  late DriftPlayerRepository repo;

  setUp(() async {
    db = createTestDatabase();
    await SeedLoader(
      db,
      InMemorySeedSource(
        nationList: [nation(id: 1)],
        playerList: [
          player(
            id: 101,
            nationId: 1,
            position: PlayerPosition.st,
            attributes: flatAttributes(78),
          ),
          player(
            id: 102,
            nationId: 1,
            position: PlayerPosition.cb,
            attributes: flatAttributes(82),
          ),
          player(
            id: 103,
            nationId: 1,
            position: PlayerPosition.cm,
            attributes: flatAttributes(74),
          ),
          player(
            id: 104,
            nationId: 1,
            position: PlayerPosition.gk,
            attributes: flatAttributes(76),
          ),
        ],
      ),
    ).ensureSeeded();
    repo = DriftPlayerRepository(db);
  });

  tearDown(() => db.close());

  /// The ids a late tournament's scorer list would be holding: everyone in the
  /// nation's pool twelve years in.
  Future<List<Player>> poolNow() =>
      repo.byNation(1, agingYears: agingYears, saveSeed: saveSeed);

  test('every player in a late pool resolves to a name by id', () async {
    final pool = await poolNow();
    expect(
      pool.where((p) => PlayerLifecycle.isNewgenId(p.id)),
      isNotEmpty,
      reason: 'twelve years in, the pool should carry generated players',
    );

    for (final p in pool) {
      final resolved = await repo.byId(
        p.id,
        agingYears: agingYears,
        saveSeed: saveSeed,
      );
      expect(resolved, isNotNull, reason: 'scorer ${p.id} has no name');
      expect(resolved!.name, p.name, reason: 'scorer ${p.id} renamed');
    }
  });

  test('without agingYears a late newgen cannot be reconstructed', () async {
    // The diagnosis, pinned: this is not a broken lookup, it is a lookup asked
    // the wrong question. An id whose intake year is after the save opened is
    // simply not in the world `agingYears: 0` describes.
    final newgens = [
      for (final p in await poolNow())
        if (PlayerLifecycle.isNewgenId(p.id)) p,
    ];
    final missing = <int>[];
    for (final p in newgens) {
      if (await repo.byId(p.id, saveSeed: saveSeed) == null) missing.add(p.id);
    }
    expect(
      missing,
      isNotEmpty,
      reason: 'the default agingYears must lose the later intakes',
    );
  });

  test('a newgen scorer on the World Championship screen has a name', () async {
    // The covering test: it drives `cupDetailProvider` itself, over a real
    // save with a real stored goal, and fails the moment that provider stops
    // telling `byId` which year it is asking about.
    final db = createTestDatabase();
    addTearDown(db.close);
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final nationId = nations.first.id;

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(
            nationList: nations,
            // A nation's newgens are generated FROM its seeded squad (names,
            // clubs, quality), so the source needs real players in it or the
            // intakes come out empty.
            playerList: [
              for (var i = 0; i < 12; i++)
                player(
                  id: 900 + i,
                  nationId: nationId,
                  age: 24 + i % 6,
                  position: PlayerPosition.values[i % PlayerPosition.values.length],
                  attributes: flatAttributes(70 + i % 12),
                ),
            ],
          ),
        ),
        // The screen names its venues from an asset; the scorer chart does not
        // care, and loading it would only slow the test down.
        countryCitiesProvider.overrideWith(
          (ref) async => const <int, List<String>>{},
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(seedLoaderProvider).ensureSeeded();

    final created = (await container
            .read(careerServiceProvider)
            .create(nationId: nationId, managerName: 'M', rngSeed: saveSeed))
        .valueOrNull!;
    // Four cycles on — the save is in 2042 and sixteen intakes deep.
    final careers = container.read(careerRepositoryProvider);
    await careers.advanceCycle(created.id, 3, DateTime(2042, 12));
    final career = (await careers.byId(created.id))!;
    final aging = CareerService.agingYears(career);

    // A scorer who came through AFTER the save opened: the one kind of id
    // that only resolves when the lookup is told which year it is.
    final players = container.read(playerRepositoryProvider);
    final pool = await players.byNation(
      nationId,
      agingYears: aging,
      saveSeed: career.rngSeed,
    );
    int? lateNewgen;
    for (final p in pool) {
      if (!PlayerLifecycle.isNewgenId(p.id)) continue;
      if (await players.byId(p.id, saveSeed: career.rngSeed) == null) {
        lateNewgen = p.id;
        break;
      }
    }
    expect(lateNewgen, isNotNull, reason: 'no post-start intake in the pool');

    // One stored goal in this cycle's finals, scored by him.
    final competitionId = await db
        .into(db.competitions)
        .insert(
          CompetitionsCompanion.insert(
            careerId: career.id,
            name: 'World Championship',
            kind: const Value(CompetitionKind.worldCupFinals),
            confederation: Confederation.europe,
            cycle: Value(career.cyclePointer),
          ),
        );
    final fixtureId = await db
        .into(db.fixtures)
        .insert(
          FixturesCompanion.insert(
            careerId: career.id,
            competitionId: competitionId,
            matchday: 1,
            date: DateTime.utc(2042, 6, 20),
            homeNationId: nationId,
            awayNationId: nations[1].id,
          ),
        );
    await db
        .into(db.goalEvents)
        .insert(
          GoalEventsCompanion.insert(
            careerId: career.id,
            competitionId: competitionId,
            fixtureId: fixtureId,
            nationId: nationId,
            playerId: lateNewgen!,
            minute: 55,
          ),
        );

    final data = await container.read(cupDetailProvider(career.id).future);
    expect(data, isNotNull);
    expect(
      data!.scorersFinals.map((s) => s.playerId),
      contains(lateNewgen),
      reason: 'the goal should be on the chart',
    );
    expect(
      data.playerNames[lateNewgen],
      isNotNull,
      reason: 'scorer $lateNewgen would print as "Unknown"',
    );
  });

  test('every screen that resolves a player by id passes agingYears', () {
    // The guard on the fix. `byId` defaults `agingYears` to 0, which is the
    // right default for the world's opening day and wrong for every screen
    // that reads a save.
    //
    // `saveSeed:` is the tell that it is the PLAYER repository being asked
    // (no other `byId` takes it), so the rule reads: a player lookup that
    // knows which save it is in must also say which year. The argument list
    // is found by balancing brackets rather than by looking for a `);`
    // terminator: the two highest-stakes call sites in the codebase write the
    // result straight into an expression — `(await ….byId(…))?.name` — and a
    // terminator pattern is blind to exactly those.
    //
    // It checks that the argument is PRESENT, not what it is worth: an
    // explicit `agingYears: 0` would pass. Nothing writes that today, and a
    // guard that tried to judge the value would have to evaluate the call.
    final offenders = <String>[];
    for (final file in Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      final source = file.readAsStringSync();
      for (final m in RegExp(r'\.byId\(').allMatches(source)) {
        final args = _argsOf(source, m.end - 1);
        if (args.contains('saveSeed:') && !args.contains('agingYears:')) {
          offenders.add('${file.path}: .byId($args)');
        }
      }
    }
    expect(offenders, isEmpty);
  });
}

/// The argument list of the call whose opening `(` is at [open], by balancing
/// brackets — so the scan is blind to how the call is written and to how its
/// statement ends (a closure argument carrying its own `;` included).
String _argsOf(String source, int open) {
  var depth = 0;
  for (var i = open; i < source.length; i++) {
    switch (source[i]) {
      case '(' || '[' || '{':
        depth++;
      case ')' || ']' || '}':
        depth--;
        if (depth == 0) return source.substring(open + 1, i);
    }
  }
  return source.substring(open + 1);
}
