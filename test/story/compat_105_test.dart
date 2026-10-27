import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/host_bid_providers.dart';
import 'package:fnm/features/federation/national_stadium_providers.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'driver.dart';

/// Opens saves written by 1.0.5 (see the worktree's make_saves_test) with this
/// code and plays on. Not part of the suite: it needs those files.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const dir =
      '/Users/martinurbanczyk/Documents/Work/fnm26/.superpowers/saves105';

  AppDatabase open(String name) {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final copy =
        '/private/tmp/claude-501/-Users-martinurbanczyk-Documents-Work-fnm26/6c95b6fb-6898-4eef-9a2a-c9c308e15f0f/scratchpad/compat_$name';
    File('$dir/$name').copySync(copy);
    return AppDatabase.forTesting(NativeDatabase(File(copy)));
  }

  test('a 1.0.5 save mid-cycle keeps its briefs and plays on', () async {
    final db = open('mid_cycle.db');
    final c = storyContainer(db);
    addTearDown(c.dispose);
    final d = StoryDriver(c, 1);
    final before = await c.read(cycleObjectiveOutcomesProvider(1).future);
    final world = before.singleWhere((o) => o.tier == TournamentTier.world);
    // ignore: avoid_print
    print(
      'MID briefs: ${[for (final o in before) '${o.tier.name}:${o.target}']}',
    );
    // Asia's 7th is outside the world's top fifty: 1.0.5 asked for the top half.
    expect(world.target, 1, reason: 'the brief it opened with');

    var steps = 0;
    while (await d.step(stopAtRollover: true)) {
      if (++steps > 4000) fail('runaway');
    }
    await c.read(satisfactionProvider(1).future);
    await d.step(); // the rollover, by this version
    expect(
      await c
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(1, 1, briefRulesV2Kind),
      isTrue,
    );
    c.invalidate(cycleObjectiveOutcomesProvider);
    final next = await c.read(cycleObjectiveOutcomesProvider(1).future);
    // ignore: avoid_print
    print(
      'NEXT briefs: ${[for (final o in next) '${o.tier.name}:${o.target}']}',
    );
    for (var i = 0; i < 60; i++) {
      await d.step(stopAtRollover: true);
    }
  }, timeout: const Timeout(Duration(minutes: 15)));

  test('a 1.0.5 save that already moved is healed on reading', () async {
    final db = open('moved.db');
    final c = storyContainer(db);
    addTearDown(c.dispose);
    final repo = c.read(careerRepositoryProvider);
    final career = (await repo.byId(1))!;
    expect(career.lastCycleBoard, 0, reason: 'the old bug, as stored');
    final sat = await c.read(satisfactionProvider(1).future);
    // ignore: avoid_print
    print('MOVED satisfaction now $sat');
    expect(sat, greaterThanOrEqualTo(BoardSatisfaction.neutral - 5));
    final squad = (await c.read(squadDataProvider(1).future))!;
    expect(squad.pool.map((p) => p.id), isNot(contains(707)));
    expect(await c.read(naturalizedCountProvider(1).future), 0);
    expect(await c.read(pendingNaturalizationProvider(1).future), isNull);
    expect(await repo.pendingNaturalization(1), isNull);

    final d = StoryDriver(c, 1);
    for (var i = 0; i < 80; i++) {
      await d.step(stopAtRollover: true);
    }
  }, timeout: const Timeout(Duration(minutes: 15)));

  test('1.0.5 saves carry no campaign markers and are all listed', () async {
    for (final name in ['mid_cycle.db', 'moved.db']) {
      final db = open(name);
      final c = storyContainer(db);
      addTearDown(c.dispose);
      final comp = c.read(competitionRepositoryProvider);
      expect(
        await comp.watchedKindsWithPrefix('campaign:'),
        isEmpty,
        reason: name,
      );
      final all = await c.read(careerRepositoryProvider).all();
      final listed = await c.read(savesProvider.future);
      expect(
        listed.map((e) => e.id).toSet(),
        all.map((e) => e.id).toSet(),
        reason: name,
      );
      expect(listed, isNotEmpty, reason: name);
    }
  });

  test('1.0.5 saves have no stadium works: the static grounds, their small '
      'income, and works on offer at the next opening', () async {
    for (final name in ['mid_cycle.db', 'moved.db']) {
      final db = open(name);
      final c = storyContainer(db);
      addTearDown(c.dispose);
      final comp = c.read(competitionRepositoryProvider);
      expect(await stadiumWorks(comp, 1), isEmpty, reason: name);
      final career = (await c.read(careerRepositoryProvider).byId(1))!;
      final cities = await c.read(countryCitiesProvider.future);
      final grounds = await c.read(
        nationStadiumsProvider((careerId: 1, nationId: career.nationId)).future,
      );
      expect(
        grounds,
        seedStadiums(career.nationId, cities),
        reason: name,
      );
      final NationalStadiumsView? view = await c.read(
        nationalStadiumsViewProvider(1).future,
      );
      expect(view!.stadiums, isNotEmpty, reason: name);
      // Every ground earns its small income from the start, worked on or not
      // (hosting v2): exactly what the untouched grounds earn, held to the
      // grant cap, and the same figure the screen shows.
      final paid = await c
          .read(nationalStadiumServiceProvider)
          .incomeAt(1, career.nationId, career.cyclePointer + 1);
      expect(paid, view.income, reason: name);
      expect(paid, greaterThan(0), reason: name);
      expect(
        paid,
        lessThanOrEqualTo(
          NationalStadiums.incomeOf(view.stadiums, career.nationId),
        ),
        reason: name,
      );
      // No hosting bid of the first builds' kind is pending in a 1.0.5 save.
      final kinds = await hostBidKinds(comp, 1);
      expect(kinds, isEmpty, reason: name);
      expect(view.reputation, 0, reason: name);
    }
  });
}
