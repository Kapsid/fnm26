import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/player/international_retirement.dart';
import 'package:fnm/domain/services/world_managers/manager_seeder.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/staff_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/manager/manager_providers.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart'
    show kMatchViewModePrefsKey;
import 'package:fnm/features/world_managers/world_manager_markers.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../story/driver.dart';

typedef _Save = ({
  AppDatabase db,
  ProviderContainer c,
  int careerId,
  List<Nation> nations,
  int playerNationId,
});

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUp(() => AppLog.debugUse(null));

  final opens1 = CareerService.cycleOpens(1);

  Future<_Save> start() async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      kMatchViewModePrefsKey: 'timeline',
    });
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final c = storyContainer(db, 0);
    addTearDown(() async {
      c.dispose();
      await db.close();
    });
    final d = await StoryDriver.start(c, 7);
    final career = (await c.read(careerRepositoryProvider).byId(d.careerId))!;
    return (
      db: db,
      c: c,
      careerId: d.careerId,
      nations: await c.read(nationRepositoryProvider).forCareer(d.careerId),
      playerNationId: career.nationId,
    );
  }

  Future<ManagerWorld> world(_Save s) =>
      s.c.read(worldManagerRepositoryProvider).load(s.careerId);

  Future<bool> marked(_Save s, int cycle, String kind) => s.c
      .read(competitionRepositoryProvider)
      .hasWatchedDraw(s.careerId, cycle, kind);

  Future<List<ManagerTie>> ties(_Save s) =>
      s.c.read(worldManagerRepositoryProvider).ties(s.careerId);

  /// Seeds the managers and marks cycle 1 as run by them.
  Future<void> ready(_Save s) async {
    await s.c.read(worldManagerServiceProvider).ensureSeeded(s.careerId);
    await s.c
        .read(competitionRepositoryProvider)
        .markDrawWatched(s.careerId, 1, worldManagersKind);
  }

  /// Retires [n] of the free pool, so the rollover has room to top it up.
  Future<void> drain(_Save s, int n) async {
    final w = await world(s);
    final free = w.free(opens1).take(n).toList();
    await s.c
        .read(worldManagerRepositoryProvider)
        .apply(
          s.careerId,
          ManagerChanges(
            updated: [
              for (final m in free) m.copyWith(retiredAt: DateTime(2029)),
            ],
          ),
        );
  }

  Future<StaffRoom> room(_Save s) async {
    s.c.invalidate(staffRoomProvider(s.careerId));
    final r = await s.c.read(staffRoomProvider(s.careerId).future);
    return r!;
  }

  test(
    'taking a job ends the incumbent replacedByPlayer with a grudge tie',
    () async {
      final s = await start();
      await ready(s);
      final to = s.nations.firstWhere((n) => n.id != s.playerNationId).id;
      final incumbent = (await world(s)).currentAt(to)!;

      final moves = await s.c
          .read(worldManagerServiceProvider)
          .playerMoved(
            s.careerId,
            from: s.playerNationId,
            to: to,
            date: opens1,
          );

      final w = await world(s);
      final ended = w.spells.firstWhere(
        (sp) => sp.spellNo == incumbent.spellNo,
      );
      expect(ended.endReason, SpellEnd.replacedByPlayer);
      expect(ended.toDate, opens1);
      expect(w.currentAt(to), isNull, reason: 'the player runs it now');
      expect(
        moves.where(
          (m) =>
              m.nationId == to &&
              m.outgoingId == incumbent.managerId &&
              m.why == SpellEnd.replacedByPlayer,
        ),
        isNotEmpty,
      );
      final grudge = (await ties(
        s,
      )).where((t) => t.managerId == incumbent.managerId).toList();
      expect(grudge, hasLength(1));
      expect(grudge.single.kind, TieKind.grudge);
      expect(grudge.single.delta, -25);
      expect(await marked(s, 1, mgrRolloverKind), isTrue);
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'the nation left names a successor in the same rollover with a successor tie',
    () async {
      final s = await start();
      await ready(s);
      final to = s.nations.firstWhere((n) => n.id != s.playerNationId).id;
      final moves = await s.c
          .read(worldManagerServiceProvider)
          .playerMoved(
            s.careerId,
            from: s.playerNationId,
            to: to,
            date: opens1,
          );

      final successor = (await world(s)).currentAt(s.playerNationId);
      expect(successor, isNotNull, reason: 'the nation left hires at once');
      expect(successor!.fromDate, opens1);
      expect(
        moves.firstWhere((m) => m.nationId == s.playerNationId).incomingId,
        successor.managerId,
      );
      final tie = (await ties(
        s,
      )).where((t) => t.kind == TieKind.successor).toList();
      expect(tie, hasLength(1));
      expect(tie.single.managerId, successor.managerId);
      expect(tie.single.delta, -25);
      // The pass ran once: a second call changes nothing.
      expect(
        await s.c
            .read(worldManagerServiceProvider)
            .playerMoved(
              s.careerId,
              from: s.playerNationId,
              to: to,
              date: opens1,
            ),
        isEmpty,
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'replacing the assistant puts him in the pool as protege',
    () async {
      final s = await start();
      final applicants = (await room(s)).applicants[StaffRole.assistant]!;
      final first = applicants[0];
      final second = applicants[1];
      final manager = s.c.read(managerServiceProvider);
      await manager.hire(s.careerId, StaffRole.assistant, first.id);
      expect(
        await s.c.read(worldManagerRepositoryProvider).hasManagers(s.careerId),
        isFalse,
        reason: 'a first hire replaces nobody',
      );
      // The name and flag the staff room shows him under while in post.
      final inPost = (await room(s)).hired[StaffRole.assistant]!;
      expect(inPost.id, first.id);
      await manager.hire(s.careerId, StaffRole.assistant, second.id);

      var w = await world(s);
      final left = w.managers
          .where((m) => m.origin == ManagerOrigin.exAssistant)
          .toList();
      expect(left, hasLength(1));
      expect(left.single.sourceId, first.id);
      expect(left.single.name, inPost.name);
      expect(left.single.nationality, inPost.country.toUpperCase());
      expect(w.free(DateTime(2027)), contains(left.single));
      final tie = (await ties(
        s,
      )).where((t) => t.managerId == left.single.managerId).single;
      expect(tie.kind, TieKind.protege);
      expect(tie.delta, 40);

      // Leaving the post empty lets the second one go too.
      await manager.hire(s.careerId, StaffRole.assistant, null);
      w = await world(s);
      expect(
        {
          for (final m in w.managers)
            if (m.origin == ManagerOrigin.exAssistant) m.sourceId,
        },
        {first.id, second.id},
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'a departed assistant from an earlier cycle enters the pool named',
    () async {
      final s = await start();
      final career = (await s.c
          .read(careerRepositoryProvider)
          .byId(s.careerId))!;
      // A man hired in cycle 0, still in the job once cycle 1 is current:
      // the staff room no longer knows his name.
      final pool = await staffNamePool(s.c.read, s.careerId);
      final hired = StaffMarket.forRole(
        saveSeed: career.rngSeed,
        cycle: 0,
        role: StaffRole.assistant,
        namePool: pool,
      )[2];
      await s.c
          .read(careerRepositoryProvider)
          .setStaff(s.careerId, StaffRole.assistant, hired.id);
      await s.db.customStatement(
        'UPDATE careers SET cycle_pointer = 1 WHERE id = ?',
        [s.careerId],
      );
      expect(
        (await room(s)).hired[StaffRole.assistant]!.name,
        isEmpty,
        reason: 'the room has lost his name',
      );
      expect(StaffMarket.cycleOf(hired.id), 0);

      await s.c
          .read(managerServiceProvider)
          .hire(s.careerId, StaffRole.assistant, null);

      final m = (await world(
        s,
      )).managers.singleWhere((m) => m.origin == ManagerOrigin.exAssistant);
      expect(m.sourceId, hired.id);
      expect(m.name, hired.name);
      expect(m.nationality, hired.country.toUpperCase());
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'the same assistant never enters twice',
    () async {
      final s = await start();
      final service = s.c.read(worldManagerServiceProvider);
      final a = (await room(s)).applicants[StaffRole.assistant]!.first;
      for (var i = 0; i < 2; i++) {
        await service.assistantLeft(
          s.careerId,
          candidateId: a.id,
          name: a.name,
          country: a.country,
          date: DateTime(2027, 3),
        );
      }
      final w = await world(s);
      expect(w.managers.where((m) => m.sourceId == a.id), hasLength(1));
      expect(
        (await ties(s)).where((t) => t.kind == TieKind.protege),
        hasLength(1),
      );

      // An unmarked cycle takes nobody in.
      final b = (await room(s)).applicants[StaffRole.assistant]!.last;
      await s.db.customStatement(
        'DELETE FROM draws_watched WHERE career_id = ? AND kind = ?',
        [s.careerId, worldManagersKind],
      );
      await service.assistantLeft(
        s.careerId,
        candidateId: b.id,
        name: b.name,
        country: b.country,
        date: DateTime(2027, 3),
      );
      expect(
        (await world(s)).managers.where((m) => m.sourceId == b.id),
        isEmpty,
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'an ex-international with 5 caps under you enters as former player',
    () async {
      final s = await start();
      await ready(s);
      await drain(s, 30);
      final career = (await s.c
          .read(careerRepositoryProvider)
          .byId(s.careerId))!;
      // His age on the rollover's aging year.
      const aging = 4;
      final players = s.c.read(playerRepositoryProvider);
      final veterans = <Player>[
        for (final p in await players.byNation(
          s.playerNationId,
          agingYears: aging,
          saveSeed: career.rngSeed,
          careerId: s.careerId,
          includeIntlRetired: true,
        ))
          if (p.age >= 36 && p.age <= 45) p,
      ];
      expect(veterans, isNotEmpty, reason: 'a veteran to retire');
      final capped = veterans.first;
      final uncapped = veterans.length > 1 ? veterans[1] : null;
      await s.c.read(internationalRetirementRepositoryProvider).addMarkers(
        s.careerId,
        0,
        [
          for (final p in [capped, ?uncapped])
            InternationalRetirement.retiredKind(
              p.id,
              2,
              DateTime(2028, 7, 20),
              nationId: s.playerNationId,
            ),
        ],
      );
      // Five games for the player's nation in cycle 0, his stint there.
      final games = [
        for (final f
            in await s.c
                .read(competitionRepositoryProvider)
                .allFixtures(s.careerId))
          if ((f.homeNationId == s.playerNationId ||
                  f.awayNationId == s.playerNationId) &&
              f.date.isBefore(opens1))
            f,
      ].take(5).toList();
      expect(games, hasLength(5));
      for (final f in games) {
        await s.db.customStatement(
          'INSERT INTO player_ratings (career_id, fixture_id, player_id, '
          'nation_id, rating) VALUES (?, ?, ?, ?, 7.0)',
          [s.careerId, f.id, capped.id, s.playerNationId],
        );
      }
      expect(
        await s.c
            .read(competitionRepositoryProvider)
            .capsUnder(
              s.careerId,
              capped.id,
              s.playerNationId,
              CareerService.cycleOpens(0),
              opens1,
            ),
        5,
      );

      await s.c
          .read(worldManagerServiceProvider)
          .atRollover(s.careerId, nextCycle: 1);

      final w = await world(s);
      final ex = w.managers.singleWhere((m) => m.sourceId == capped.id);
      expect(ex.origin, ManagerOrigin.exPlayer);
      expect(ex.name, capped.name);
      expect(ex.birthYear, opens1.year - capped.age);
      final code = s.nations.firstWhere((n) => n.id == s.playerNationId).code;
      expect(ex.nationality, code.toUpperCase());
      final allTies = await ties(s);
      final tie = allTies.where((t) => t.managerId == ex.managerId).single;
      expect(tie.kind, TieKind.formerPlayer);
      expect(tie.delta, 20);
      if (uncapped != null) {
        final other = w.managers
            .where((m) => m.sourceId == uncapped.id)
            .firstOrNull;
        if (other != null) {
          expect(allTies.where((t) => t.managerId == other.managerId), isEmpty);
        }
      }
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'the pool is back to 60 after a rollover',
    () async {
      final s = await start();
      await ready(s);
      await drain(s, 25);
      final before = await world(s);
      final employed = {
        for (final sp in before.spells)
          if (sp.current) sp.managerId,
      };
      expect(before.free(opens1).length, ManagerSeeder.freeCount - 25);

      final moves = await s.c
          .read(worldManagerServiceProvider)
          .atRollover(s.careerId, nextCycle: 1);

      final after = await world(s);
      expect(
        after.managers.length,
        greaterThan(before.managers.length),
        reason: 'entrants joined',
      );
      // The pool the hiring drew from: those still free, plus those hired
      // out of it (an employed man poached is not from the pool).
      final hiredFromPool = {
        for (final m in moves)
          if (m.incomingId != null && !employed.contains(m.incomingId))
            m.incomingId!,
      };
      expect(
        after.free(opens1).length + hiredFromPool.length,
        ManagerSeeder.freeCount,
      );
      final entrants = after.managers
          .where((m) => m.enteredAt == opens1)
          .toList();
      expect(entrants, isNotEmpty);
      for (final m in entrants) {
        expect(m.name.trim(), isNotEmpty);
        expect(m.origin, isNot(ManagerOrigin.exAssistant));
      }
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test(
    'a new job at the rollover replaces, names a successor and lets the '
    'assistant go, in one pass',
    () async {
      final s = await start();
      final careers = s.c.read(careerRepositoryProvider);
      final career = (await careers.byId(s.careerId))!;
      final pool = await staffNamePool(s.c.read, s.careerId);
      final assistant = StaffMarket.forRole(
        saveSeed: career.rngSeed,
        cycle: 0,
        role: StaffRole.assistant,
        namePool: pool,
      ).last;
      await careers.setStaff(s.careerId, StaffRole.assistant, assistant.id);
      final d = StoryDriver(s.c, s.careerId);
      while (await d.step(stopAtRollover: true)) {}
      final to = s.nations.firstWhere((n) => n.id != s.playerNationId).id;
      final incumbent = (await world(s)).currentAt(to);

      await s.c
          .read(seasonServiceProvider)
          .startNextCycle(s.careerId, switchToNationId: to);

      expect((await careers.byId(s.careerId))!.nationId, to);
      expect(await marked(s, 1, mgrRolloverKind), isTrue);
      final w = await world(s);
      expect(w.currentAt(to), isNull);
      if (incumbent != null) {
        expect(
          w.spells
              .firstWhere((sp) => sp.spellNo == incumbent.spellNo)
              .endReason,
          SpellEnd.replacedByPlayer,
        );
      }
      final successor = w.currentAt(s.playerNationId);
      expect(successor, isNotNull);
      expect(successor!.fromDate, opens1);
      final allTies = await ties(s);
      expect(
        allTies.where(
          (t) =>
              t.kind == TieKind.successor && t.managerId == successor.managerId,
        ),
        hasLength(1),
      );
      final left = w.managers.singleWhere(
        (m) => m.origin == ManagerOrigin.exAssistant,
      );
      expect(left.sourceId, assistant.id);
      expect(left.name, assistant.name);
      expect(left.enteredAt, opens1);
    },
    timeout: const Timeout(Duration(minutes: 15)),
  );
}
