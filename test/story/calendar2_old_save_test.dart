@Tags(['slow'])
library;

import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart'
    show kMatchViewModePrefsKey;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/save_fixtures.dart';
import 'driver.dart';

/// A save from before calendar2 (1.1.0 (37), schema 54) finishes its cycle on
/// the calendar it was built with, and switches at its rollover.
///
/// Owner rule: never break saves. The mid-cycle save keeps every fixture it
/// holds where it was, draws its World Championship qualifying in January as
/// before (March to November, CONMEBOL to March), and gains no second Nations
/// Cup; the late one rolls into a cycle on the new rhythm.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const build = 'v110_37';

  Future<(AppDatabase, ProviderContainer)> open(File file) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      kMatchViewModePrefsKey: 'timeline',
    });
    final db = AppDatabase.forTesting(NativeDatabase(file));
    final c = storyContainer(db);
    await c.read(seedLoaderProvider).ensureSeeded();
    return (db, c);
  }

  /// Every fixture of [careerId] as (id, date, home, away, round).
  Future<Map<int, String>> fixtureKeys(AppDatabase db, int careerId) async {
    final rows = await (db.select(
      db.fixtures,
    )..where((t) => t.careerId.equals(careerId))).get();
    return {
      for (final f in rows)
        f.id:
            '${f.date.toIso8601String()}|${f.homeNationId}|'
            '${f.awayNationId}|${f.round}|${f.competitionId}',
    };
  }

  Future<List<FixtureRow>> fixturesOf(
    AppDatabase db,
    int careerId,
    int cycle,
    CompetitionKind kind,
    Confederation conf,
  ) async {
    final comps =
        await (db.select(db.competitions)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  t.cycle.equals(cycle) &
                  t.kind.equalsValue(kind) &
                  t.confederation.equalsValue(conf),
            ))
            .get();
    if (comps.isEmpty) return const [];
    return (db.select(db.fixtures)
          ..where((t) => t.competitionId.isIn([for (final r in comps) r.id]))
          ..orderBy([(t) => OrderingTerm(expression: t.date)]))
        .get();
  }

  test(
    'a pre-calendar2 save mid-cycle keeps its fixtures and dates',
    () async {
      final file = await unpackFixture(build, 'mid_cycle');
      final manifest = readManifest(build, 'mid_cycle');
      final id = manifest.careerId;
      final (db, c) = await open(file);
      addTearDown(() async {
        c.dispose();
        await db.close();
      });
      final comp = c.read(competitionRepositoryProvider);
      final cycle = manifest.cyclePointer;
      expect(await comp.hasWatchedDraw(id, cycle, calendar2Kind), isFalse);
      final before = await fixtureKeys(db, id);
      expect(before, isNotEmpty);

      // Play on into the qualifying year: the Nations Cup autumn, the
      // January qualifying draw and the first qualifying window.
      final d = StoryDriver(c, id);
      for (var i = 0; i < 3000; i++) {
        final at =
            (await c.read(careerRepositoryProvider).byId(id))!.inGameDate;
        if (!at.isBefore(DateTime(2029, 3, 15))) break;
        if (!await d.step(stopAtRollover: true)) break;
      }
      expect(
        (await c.read(careerRepositoryProvider).byId(id))!.inGameDate.isBefore(
          DateTime(2029, 3, 15),
        ),
        isFalse,
        reason: 'played into the qualifying year',
      );

      // Not one fixture the save held moved, changed sides or vanished.
      final after = await fixtureKeys(db, id);
      for (final e in before.entries) {
        expect(after[e.key], e.value, reason: 'fixture ${e.key}');
      }

      // Still unmarked, one Nations Cup a confederation, nothing of the new
      // rhythm drawn.
      expect(await comp.hasWatchedDraw(id, cycle, calendar2Kind), isFalse);
      final editions =
          await (db.select(db.competitions)..where(
                (t) => t.careerId.equals(id) & t.edition.equals(0).not(),
              ))
              .get();
      expect(editions, isEmpty);
      for (final kind in const [
        'cal2:euroQual',
        'cal2:wcqSouthAmerica',
        'cal2:wcq',
        'ncLadder:e0',
      ]) {
        expect(await comp.hasWatchedDraw(id, cycle, kind), isFalse);
      }

      // World Championship qualifying on the old dates: drawn in January,
      // March to November 2029, CONMEBOL running into March 2030.
      final europe = await fixturesOf(
        db,
        id,
        cycle,
        CompetitionKind.worldCupQualifying,
        Confederation.europe,
      );
      expect(europe, isNotEmpty);
      expect(europe.first.date.isBefore(DateTime(2029, 3)), isFalse);
      expect(europe.last.date.isAfter(DateTime(2029, 11, 30)), isFalse);
      final sa = await fixturesOf(
        db,
        id,
        cycle,
        CompetitionKind.worldCupQualifying,
        Confederation.southAmerica,
      );
      expect(sa, isNotEmpty);
      expect(sa.first.date.isBefore(DateTime(2029, 3)), isFalse);
      expect(sa.last.date.year, 2030, reason: 'CONMEBOL ends in March 2030');
      // Europe's only Nations Cup: the autumn of 2028.
      final nc = await fixturesOf(
        db,
        id,
        cycle,
        CompetitionKind.nationsLeague,
        Confederation.europe,
      );
      for (final f in nc.where((f) => f.round == 'NGROUP')) {
        expect(f.date.year, 2028, reason: '${f.date}');
      }
    },
    timeout: const Timeout(Duration(minutes: 30)),
  );

  test(
    'a pre-calendar2 save switches to calendar2 at its rollover',
    () async {
      final file = await unpackFixture(build, 'late_cycle');
      final manifest = readManifest(build, 'late_cycle');
      final id = manifest.careerId;
      final (db, c) = await open(file);
      addTearDown(() async {
        c.dispose();
        await db.close();
      });
      final comp = c.read(competitionRepositoryProvider);
      final from = manifest.cyclePointer;
      final d = StoryDriver(c, id);
      expect((await d.nextEvent()).kind, HubEventKind.cycleRollover);
      expect(await comp.hasWatchedDraw(id, from, calendar2Kind), isFalse);
      await d.step();
      final next = from + 1;
      expect(
        (await c.read(careerRepositoryProvider).byId(id))!.cyclePointer,
        next,
      );
      expect(await comp.hasWatchedDraw(id, from, calendar2Kind), isFalse);
      expect(await comp.hasWatchedDraw(id, next, calendar2Kind), isTrue);

      final opens = CareerService.cycleOpens(next).year;
      // Europe's first Nations Cup opens the new cycle; its qualifying for
      // the continental finals is not drawn yet.
      final nc = await fixturesOf(
        db,
        id,
        next,
        CompetitionKind.nationsLeague,
        Confederation.europe,
      );
      expect(nc, isNotEmpty);
      for (final f in nc) {
        expect(f.date.year, opens, reason: '${f.date}');
        expect(f.date.month >= 9 && f.date.month <= 11, isTrue);
      }
      expect(
        await fixturesOf(
          db,
          id,
          next,
          CompetitionKind.continentalQualifying,
          Confederation.europe,
        ),
        isEmpty,
      );
      // North America keeps its one cup in the old slot.
      for (final f in await fixturesOf(
        db,
        id,
        next,
        CompetitionKind.nationsLeague,
        Confederation.northAmerica,
      )) {
        expect(f.date.year, opens + 2, reason: '${f.date}');
      }
    },
    timeout: const Timeout(Duration(minutes: 10)),
  );
}
