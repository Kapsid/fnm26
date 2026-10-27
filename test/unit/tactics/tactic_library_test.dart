import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/data/db/save_backup.dart';
import 'package:fnm/data/repositories/drift_tactic_library_repository.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/library_tactic.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tactics/player_roles_providers.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:fnm/features/tactics/tactic_library_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/seeded_save.dart' show realNations, realPlayers;
import '../../helpers/test_database.dart';

/// The tactics library: tactics kept outside any one career, loaded into
/// another with roles and set-piece takers re-attached by slot.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const gegen = TacticalInstructions(
    mentality: 75,
    pressing: 90,
    tempo: 80,
    width: 55,
    defensiveLine: 85,
    directness: 60,
  );

  group('the stored document', () {
    test('round-trips shape, style, dials, roles and takers', () {
      const t = LibraryTactic(
        name: 'High press',
        formation: Formation.f433,
        instructions: gegen,
        playstyle: Playstyle.gegenpress,
        rolesBySlot: {9: PlayerRole.poacher, 5: PlayerRole.playmaker},
        penaltySlot: 9,
        deadBallSlot: 5,
      );
      final back = LibraryTactic.fromData(
        id: 3,
        name: t.name,
        data: t.toData(),
      );
      expect(back.id, 3);
      expect(back.formation, Formation.f433);
      expect(back.instructions, gegen);
      expect(back.playstyle, Playstyle.gegenpress);
      expect(back.rolesBySlot, {
        9: PlayerRole.poacher,
        5: PlayerRole.playmaker,
      });
      expect(back.penaltySlot, 9);
      expect(back.deadBallSlot, 5);
    });

    test('a damaged document still loads as a neutral tactic', () {
      final back = LibraryTactic.fromData(name: 'Broken', data: 'not json');
      expect(back.name, 'Broken');
      expect(back.instructions, const TacticalInstructions());
      expect(back.rolesBySlot, isEmpty);
      expect(back.penaltySlot, isNull);
    });

    test('a style that no longer matches its dials is not claimed', () {
      final data = const LibraryTactic(
        name: 'x',
        formation: Formation.f442,
        instructions: TacticalInstructions(mentality: 51),
        playstyle: Playstyle.gegenpress,
      ).toData();
      expect(
        LibraryTactic.fromData(name: 'x', data: data).playstyle,
        Playstyle.custom,
      );
    });
  });

  group('capture and fit', () {
    Player p(int id, PlayerPosition pos) => player(
      id: id,
      nationId: 1,
      name: 'P$id',
      position: pos,
      attributes: flatAttributes(70),
    );

    test('capture keeps roles and takers by slot, never by player', () {
      const tactic = Tactic(
        formation: Formation.f433,
        lineup: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
      );
      final t = LibraryTactic.capture(
        name: 'Mine',
        tactic: tactic,
        roles: {
          11: PlayerRole.poacher,
          7: PlayerRole.playmaker,
          99: PlayerRole.targetMan,
        },
        penaltyTaker: 11,
        deadBallTaker: 42, // on the bench: no slot to remember
      );
      expect(t.rolesBySlot, {10: PlayerRole.poacher, 6: PlayerRole.playmaker});
      expect(t.penaltySlot, 10);
      expect(t.deadBallSlot, isNull);
      expect(t.toData(), isNot(contains('"99"')));
    });

    test('fit re-attaches by slot and skips what this squad cannot fill', () {
      const t = LibraryTactic(
        name: 'x',
        formation: Formation.f433,
        instructions: TacticalInstructions(),
        rolesBySlot: {
          10: PlayerRole.poacher, // a forward stands there: fits
          4: PlayerRole.ballPlayingDefender, // a forward stands there: no
          9: PlayerRole.targetMan, // nobody in the slot: no
        },
        penaltySlot: 10,
        deadBallSlot: 9, // empty slot: left automatic
      );
      final lineup = <int?>[1, 2, 3, 4, 20, 6, 7, 8, null, null, 30];
      final players = {
        for (final pl in [
          p(1, PlayerPosition.gk),
          p(2, PlayerPosition.cb),
          p(3, PlayerPosition.cb),
          p(4, PlayerPosition.cb),
          p(20, PlayerPosition.st),
          p(6, PlayerPosition.cm),
          p(7, PlayerPosition.cm),
          p(8, PlayerPosition.cm),
          p(30, PlayerPosition.st),
        ])
          pl.id: pl,
      };
      final fit = t.fit(lineup, players);
      expect(fit.roles[30], PlayerRole.poacher);
      expect(fit.roles[20], PlayerRole.none, reason: 'unsuitable role cleared');
      expect(fit.roles[6], PlayerRole.none, reason: 'others cleared');
      expect(fit.penaltyTaker, 30);
      expect(fit.deadBallTaker, isNull);
      expect(fit.skipped, 3, reason: 'one unsuitable, one empty, one taker');
    });
  });

  group('the library table', () {
    late AppDatabase db;
    late DriftTacticLibraryRepository repo;
    setUp(() {
      db = createTestDatabase();
      repo = DriftTacticLibraryRepository(db);
    });
    tearDown(() => db.close());

    LibraryTactic named(String name, {Formation f = Formation.f442}) =>
        LibraryTactic(
          name: name,
          formation: f,
          instructions: const TacticalInstructions(),
        );

    test('save lists alphabetically, re-saving a name updates it', () async {
      await repo.save(named('Zonal'));
      await repo.save(named('attack'));
      await repo.save(named('ZONAL', f: Formation.f352));
      final all = await repo.all();
      expect(all.map((t) => t.name), ['attack', 'ZONAL']);
      expect(all.last.formation, Formation.f352);
    });

    test(
      'rename refuses a name another entry has, and delete removes',
      () async {
        final a = await repo.save(named('A'));
        await repo.save(named('B'));
        expect(await repo.rename(a, 'b'), isFalse);
        expect(await repo.rename(a, 'C'), isTrue);
        expect((await repo.all()).map((t) => t.name), ['B', 'C']);
        await repo.delete(a);
        expect((await repo.all()).map((t) => t.name), ['B']);
      },
    );

    test('deleting a career leaves the library alone', () async {
      final career = await db
          .into(db.careers)
          .insert(
            CareersCompanion.insert(
              nationId: 1,
              managerName: 'M',
              createdAt: DateTime.utc(2030),
              inGameDate: DateTime.utc(2030),
              rngSeed: 1,
            ),
          );
      await repo.save(named('Kept'));
      await (db.delete(db.careers)..where((c) => c.id.equals(career))).go();
      expect((await repo.all()).single.name, 'Kept');
    });

    test('a career bundle does not carry the library', () async {
      final career = await db
          .into(db.careers)
          .insert(
            CareersCompanion.insert(
              nationId: 1,
              managerName: 'M',
              createdAt: DateTime.utc(2030),
              inGameDate: DateTime.utc(2030),
              rngSeed: 1,
            ),
          );
      await repo.save(named('Mine'));
      final bundle = await CareerBundle.export(db, career);
      expect('$bundle', isNot(contains('tactic_library')));
    });
  });

  test('the library survives a backup and restore', () async {
    final dir = await Directory.systemTemp.createTemp('fnm_library');
    addTearDown(() => dir.delete(recursive: true));
    final source = AppDatabase.forTesting(
      NativeDatabase(File('${dir.path}/a.sqlite')),
    );
    await DriftTacticLibraryRepository(source).save(
      const LibraryTactic(
        name: 'Travels',
        formation: Formation.f4231,
        instructions: gegen,
        playstyle: Playstyle.gegenpress,
        rolesBySlot: {10: PlayerRole.poacher},
        penaltySlot: 10,
      ),
    );
    final backup = await SaveBackup.writeSnapshot(
      source,
      '${dir.path}/out.${SaveBackup.extension}',
    );
    await source.close();

    // A different phone: an empty live database, replaced by the backup.
    final live = File('${dir.path}/live.sqlite');
    final fresh = AppDatabase.forTesting(NativeDatabase(live));
    expect(await DriftTacticLibraryRepository(fresh).all(), isEmpty);
    await fresh.close();
    expect(await SaveBackup.replaceLiveAt(backup.path, live), isNull);

    final restored = AppDatabase.forTesting(NativeDatabase(live));
    addTearDown(restored.close);
    final back = (await DriftTacticLibraryRepository(restored).all()).single;
    expect(back.name, 'Travels');
    expect(back.formation, Formation.f4231);
    expect(back.instructions, gegen);
    expect(back.rolesBySlot, {10: PlayerRole.poacher});
    expect(back.penaltySlot, 10);
  });

  group('across careers', () {
    late AppDatabase db;
    late ProviderContainer c;

    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      db = createTestDatabase();
      c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
          seedSourceProvider.overrideWithValue(
            InMemorySeedSource(
              nationList: realNations,
              playerList: realPlayers,
            ),
          ),
        ],
      );
      await c.read(seedLoaderProvider).ensureSeeded();
    });
    tearDown(() async {
      c.dispose();
      await db.close();
    });

    Future<int> careerFor(int nationId) async =>
        (await c
                .read(careerServiceProvider)
                .create(nationId: nationId, managerName: 'M', rngSeed: 7))
            .valueOrNull!
            .id;

    int nationNamed(String code) =>
        realNations.firstWhere((n) => n.code == code).id;

    test('saved in one career, loaded into a new one', () async {
      final a = await careerFor(nationNamed('ESP'));
      final tactics = c.read(tacticsRepositoryProvider);
      await c.read(tacticServiceProvider).setFormation(a, Formation.f433);
      await c.read(tacticServiceProvider).setPlaystyle(a, Playstyle.gegenpress);
      final ta = (await tactics.tacticForCareer(a))!;
      // Roles and takers on A's men in slots 9 (the striker) and 6.
      final striker = ta.lineup[9]!;
      final mid = ta.lineup[6]!;
      await c.read(playerRolesStoreProvider).setRoles(a, {
        striker: PlayerRole.poacher,
        mid: PlayerRole.playmaker,
      });
      await c
          .read(setPieceTakersStoreProvider)
          .setBoth(a, penalty: striker, deadBall: mid);

      expect(
        await c.read(tacticLibraryServiceProvider).saveCurrent(a, 'Mine'),
        isTrue,
      );
      expect(
        (await c.read(tacticLibraryProvider.future)).map((t) => t.name),
        ['Mine'],
      );

      final b = await careerFor(nationNamed('BRA'));
      final entry = (await c.read(tacticLibraryProvider.future)).single;
      final fit = (await c.read(tacticLibraryServiceProvider).apply(b, entry))!;

      final tb = (await tactics.tacticForCareer(b))!;
      expect(tb.formation, Formation.f433);
      expect(tb.instructions, Playstyle.gegenpress.instructions);
      expect(tb.playstyle, Playstyle.gegenpress);
      expect(tb.lineup, isNot(contains(striker)), reason: "B fields B's men");
      final rolesB = await c.read(playerRolesStoreProvider).load(b);
      final takersB = await c.read(setPieceTakersStoreProvider).load(b);
      expect(rolesB[tb.lineup[9]], PlayerRole.poacher);
      expect(rolesB[tb.lineup[6]], PlayerRole.playmaker);
      expect(takersB.penalty, tb.lineup[9]);
      expect(takersB.deadBall, tb.lineup[6]);
      expect(fit.skipped, 0);
      // A's own roles are untouched by loading into B.
      expect(
        (await c.read(playerRolesStoreProvider).load(a))[striker],
        PlayerRole.poacher,
      );
    });

    test('a preset can be copied into the library', () async {
      await c
          .read(tacticLibraryServiceProvider)
          .savePreset(
            const TacticPreset(
              name: 'Chase it',
              formation: Formation.f424,
              instructions: gegen,
            ),
            'Chase it',
          );
      final t = (await c.read(tacticLibraryProvider.future)).single;
      expect(t.formation, Formation.f424);
      expect(t.playstyle, Playstyle.gegenpress);
      expect(t.rolesBySlot, isEmpty);
    });

    test('rename and delete refresh the library', () async {
      final svc = c.read(tacticLibraryServiceProvider);
      await svc.savePreset(
        const TacticPreset(
          name: 'One',
          formation: Formation.f442,
          instructions: TacticalInstructions(),
        ),
        'One',
      );
      final id = (await c.read(tacticLibraryProvider.future)).single.id!;
      expect(await svc.rename(id, 'Two'), isTrue);
      expect((await c.read(tacticLibraryProvider.future)).single.name, 'Two');
      await svc.delete(id);
      expect(await c.read(tacticLibraryProvider.future), isEmpty);
    });
  });
}
