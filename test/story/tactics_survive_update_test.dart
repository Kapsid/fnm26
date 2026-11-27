import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart'
    show kMatchViewModePrefsKey;
import 'package:fnm/features/tactics/player_roles_providers.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:fnm/features/tactics/tactic_preset_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/sqlite3.dart';

import '../helpers/save_fixtures.dart';
import 'driver.dart';

/// "It seems that the update has reset my tactics": a save's tactic opened
/// by a new build, and played on through its first hub steps and matches.
///
/// Opening (migrations, seed loader, the tactics providers) changes nothing;
/// save_upgrade_test pins that for every stored row. What did change the
/// tactic was the call-up: naming a window's squad without one of the XI
/// re-picked and re-placed the WHOLE eleven with the default pick, so every
/// man the manager had placed himself (and the men his new slot roles and
/// runs were drawn for) was gone after the next squad announcement. Only the
/// dropped men's slots may change; formation, instructions, roles, arrows,
/// full-backs, throw-ins, presets and takers never do.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test(
    'an old save keeps its tactic through the update and the hub after it',
    () async {
      final db = storyDb();
      var c = storyContainer(db);
      final d = await StoryDriver.start(c, 7);
      final id = d.careerId;
      // Past the opening call-up, as a save someone is playing would be.
      while ((await d.nextEvent()).kind != HubEventKind.match) {
        await d.step();
      }

      // What the old build stored: a shape, dials and an eleven of his own
      // (two pairs swapped, a squad man in on the left), arrows for the
      // full-backs, a throw-in style, legacy per-player roles, a preset and
      // named takers. No slotRole/slotArrow marks: it predates them.
      final data = (await c.read(tacticDataProvider(id).future))!;
      final xi = defaultEleven(Formation.f442, data.pool);
      final squadMan = data.pool.firstWhere(
        (p) =>
            !xi.contains(p.id) &&
            (p.position == PlayerPosition.lm ||
                p.position == PlayerPosition.cm),
      );
      final lineup = [
        xi[0],
        xi[1],
        xi[3],
        xi[2],
        xi[4],
        squadMan.id,
        xi[7],
        xi[6],
        ...xi.sublist(8),
      ];
      const dials = TacticalInstructions(
        mentality: 70,
        pressing: 80,
        tempo: 65,
        width: 30,
        defensiveLine: 75,
        directness: 20,
      );
      await c
          .read(tacticsRepositoryProvider)
          .saveTactic(
            id,
            Tactic(
              formation: Formation.f442,
              lineup: lineup,
              instructions: dials,
              fullBacks: const FullBackPushes(left: FullBackPush.up),
              throwInStyle: ThrowInStyle.long,
            ),
          );
      await c
          .read(playerRolesStoreProvider)
          .setRole(id, lineup[9]!, PlayerRole.targetMan);
      await c
          .read(tacticPresetStoreProvider)
          .save(
            id,
            const TacticPreset(
              name: 'Mine',
              formation: Formation.f442,
              instructions: dials,
            ),
          );
      await c
          .read(setPieceTakersStoreProvider)
          .set(id, penalty: true, playerId: lineup[10]);
      final stored = (await c
          .read(tacticsRepositoryProvider)
          .tacticForCareer(id))!;

      // The update: the app restarts on the same database and preferences.
      c.dispose();
      c = storyContainer(db);
      await c.read(seedLoaderProvider).ensureSeeded();
      final opened = (await c.read(tacticDataProvider(id).future))!.tactic;
      expect(opened, stored, reason: 'opening the save');
      expect(
        opened.effectiveRoleAt(
          9,
          await c.read(playerRolesStoreProvider).load(id),
        ),
        PlayerRole.targetMan,
      );

      // He tries the new roles and runs: the save now has cycle-0 marks too.
      final service = c.read(tacticServiceProvider);
      await service.setSlotRole(id, 0, PlayerRole.sweeperKeeper);
      await service.setSlotRole(id, 6, PlayerRole.boxToBox);
      await service.setSlotArrow(id, 7, MoveArrow.forward);
      final (callUps, refilled) = await playOn(c, id, matches: 4);
      expect(callUps, greaterThan(0), reason: 'a call-up moved the XI');
      expect(refilled, greaterThan(0));
      final presets = await c.read(tacticPresetStoreProvider).load(id);
      expect(presets.map((p) => p.name), ['Mine']);
      expect(
        (await c.read(setPieceTakersStoreProvider).load(id)).penalty,
        lineup[10],
      );
      c.dispose();
      await db.close();
    },
    timeout: const Timeout(Duration(minutes: 10)),
  );

  for (final build in ['v109', 'pre55']) {
    test(
      'a $build save with its own tactic, opened by this build, keeps it',
      () async {
        // The old build's file, its tactic set up as that build stored one:
        // the row, the slots, and the cycle-0 marks it knew (the full-back
        // arrows, a throw-in style). No slot role or arrow marks.
        final file = await unpackFixture(build, 'mid_cycle');
        final raw = sqlite3.open(file.path);
        const xi = [
          1401,
          1405,
          1404,
          1403,
          1414,
          1411,
          1408,
          1407,
          1406,
          1409,
          1410,
        ];
        raw
          ..execute(
            "UPDATE tactics SET formation = 'f442', playstyle = 'custom', "
            'mentality = 70, pressing = 80, tempo = 65, width = 30, '
            'defensive_line = 75, directness = 20 WHERE career_id = 1',
          )
          ..execute('DELETE FROM lineup_slots WHERE career_id = 1');
        for (var s = 0; s < 11; s++) {
          raw.execute('INSERT INTO lineup_slots VALUES (1, ?, ?)', [s, xi[s]]);
        }
        for (final kind in ['fullBack.left.up', 'throwIn.style.long']) {
          raw.execute('INSERT INTO draws_watched VALUES (1, 0, ?)', [kind]);
        }
        raw.dispose();
        // And what it kept beside the save, in the preferences.
        SharedPreferences.setMockInitialValues(<String, Object>{
          kMatchViewModePrefsKey: 'timeline',
          'tactic_presets_v2:1':
              '[{"name":"Mine","formation":"f442","mentality":70,'
              '"pressing":80,"tempo":65,"width":30,"defensiveLine":75,'
              '"directness":20}]',
          'set_piece_takers_v1:1': '{"penalty":1410,"deadBall":1406}',
          'player_roles_v1:1': '{"1409":"targetMan"}',
        });

        // Opened as the app opens it: migrated, seeded, the tactics read.
        final db = AppDatabase.forTesting(NativeDatabase(file));
        final c = storyContainer(db);
        await c.read(seedLoaderProvider).ensureSeeded();
        final data = (await c.read(tacticDataProvider(1).future))!;
        final t = data.tactic;
        expect(t.formation, Formation.f442);
        expect(t.lineup, xi);
        expect(
          t.instructions,
          const TacticalInstructions(
            mentality: 70,
            pressing: 80,
            tempo: 65,
            width: 30,
            defensiveLine: 75,
            directness: 20,
          ),
        );
        expect(t.fullBacks, const FullBackPushes(left: FullBackPush.up));
        expect(t.throwInStyle, ThrowInStyle.long);
        expect(t.roles, SlotRoles.none);
        expect(t.arrows, SlotArrows.none);
        // Every stored man is still a man of today's pool: no id moved.
        for (final pid in xi) {
          expect(data.byId.containsKey(pid), isTrue, reason: '$pid');
        }
        expect(
          (await c.read(tacticPresetStoreProvider).load(1)).single.formation,
          Formation.f442,
        );
        final takers = await c.read(setPieceTakersProvider(1).future);
        expect((takers.penalty, takers.deadBall), (1410, 1406));
        expect(
          t.effectiveRoleAt(
            9,
            await c.read(playerRolesStoreProvider).load(1),
          ),
          PlayerRole.targetMan,
        );

        // And played on: the hub's steps and matches change nothing but
        // the eleven, and that only where a call-up left a man out.
        await playOn(c, 1, matches: 2);
        c.dispose();
        await db.close();
      },
      timeout: const Timeout(Duration(minutes: 10)),
    );
  }

  group('refillEleven', () {
    Player man(int id, PlayerPosition pos, int overall) => Player(
      id: id,
      nationId: 1,
      name: 'P$id',
      age: 25,
      position: pos,
      attributes: PlayerAttributes(
        physical: overall,
        technical: overall,
        stamina: overall,
      ),
    );

    final pool = [
      for (final (i, pos) in Formation.f442.positions.indexed)
        man(i + 1, pos, 60),
      man(20, PlayerPosition.cm, 75),
      man(21, PlayerPosition.st, 80),
      man(22, PlayerPosition.cb, 70),
    ];

    test('keeps every named man in his slot and fills the empty ones', () {
      final lineup = <int?>[1, 2, 4, 3, 5, null, 8, 7, 9, 10, null];
      final out = refillEleven(Formation.f442, lineup, pool);
      for (var s = 0; s < 11; s++) {
        if (lineup[s] != null) expect(out[s], lineup[s]);
      }
      // The left midfield goes to the best midfielder left, the striker's
      // place to the best striker; nobody already in the eleven twice.
      expect(out[5], 20);
      expect(out[10], 21);
      expect(out.toSet().length, 11);
    });

    test('a full eleven comes back as it was', () {
      final lineup = <int?>[1, 2, 4, 3, 5, 6, 8, 7, 9, 11, 10];
      expect(refillEleven(Formation.f442, lineup, pool), lineup);
    });
  });
}

/// Plays [id] on through its hub events until [matches] matches are played,
/// answering the reshape step by filling only the slots it flags, and checks
/// after every other step that nothing but the eleven changed, and the
/// eleven only where a call-up left a man out. Returns how many call-ups
/// moved the eleven and how many slots they refilled.
Future<(int, int)> playOn(
  ProviderContainer c,
  int id, {
  required int matches,
}) async {
  final service = c.read(tacticServiceProvider);
  final repo = c.read(tacticsRepositoryProvider);
  var before = (await repo.tacticForCareer(id))!;
  final shape = before.copyWith(lineup: const []);

  final d2 = StoryDriver(c, id)..repickAtCallUp = false;
  var played = 0;
  var callUps = 0;
  var refilled = 0;
  for (var i = 0; i < 400 && played < matches; i++) {
    final e = await d2.nextEvent();
    if (e.kind == HubEventKind.callUp &&
        Uri.parse(e.route!).path == Routes.tactics) {
      // The reshape step, answered as a manager would: only the slots
      // flagged out (or empty) get a new man.
      final td = (await c.read(tacticDataProvider(id).future))!;
      final out = {for (final p in td.unavailableStarters) p.id};
      final free = [
        for (final p in td.pool)
          if (!td.tactic.lineup.contains(p.id)) p,
      ];
      for (var s = 0; s < 11; s++) {
        final pid = td.tactic.lineup[s];
        if (pid == null || out.contains(pid) || td.byId[pid] == null) {
          await service.setSlot(id, s, free.removeAt(0).id);
        }
      }
      before = (await repo.tacticForCareer(id))!;
      continue;
    }
    if (e.kind == HubEventKind.match) played++;
    await d2.step();
    final now = (await repo.tacticForCareer(id))!;
    expect(
      now.copyWith(lineup: const []),
      shape,
      reason: 'everything but the eleven, after ${e.kind} ${e.route}',
    );
    if (now.lineup.toString() != before.lineup.toString()) {
      // Only the call-up may move the eleven, and only where it left a
      // man out.
      expect(e.kind, HubEventKind.callUp, reason: '${e.route}');
      callUps++;
      final squad = await c.read(squadRepositoryProvider).callUps(id);
      for (var s = 0; s < 11; s++) {
        if (squad.contains(before.lineup[s])) {
          expect(now.lineup[s], before.lineup[s], reason: 'slot $s');
        } else {
          refilled++;
          expect(now.lineup[s], isNotNull, reason: 'slot $s refilled');
        }
      }
    }
    before = now;
  }
  expect(played, matches);
  return (callUps, refilled);
}
