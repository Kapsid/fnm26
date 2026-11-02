import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/finals_participation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'driver.dart';

/// WEBSITE SHOTS ONLY (not part of the suite): plays a career for one nation
/// on the app's own asset seed (as a real install has it) and saves copies of
/// the database at the moments the site's screenshots are taken from:
/// the second cycle's budget, its World Championship finals draw, and every
/// World Championship finals match before it is played. `site_shots_test`
/// renders them. Runs only when SITE_SAVE_OUT names the output folder.
///
///   SITE_SAVE_OUT=<dir> SITE_NATION=20 STORY_SEED=1 SEED_COUNT=6 CYCLES=2
///
/// Tries seeds from STORY_SEED on and keeps the first whose run reaches a
/// World Championship semi-final or final, wins it with a goal, and has the
/// board pleased (75% or more) at that moment: a hub that reads "job at risk"
/// undersells the game. The kept save is in `<dir>/seed<N>`.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final out = Platform.environment['SITE_SAVE_OUT'];
  final nation = int.parse(Platform.environment['SITE_NATION'] ?? '$england');
  final seedFrom = int.parse(Platform.environment['STORY_SEED'] ?? '1');
  final seedCount = int.parse(Platform.environment['SEED_COUNT'] ?? '1');
  final cycles = int.parse(Platform.environment['CYCLES'] ?? '2');
  // The board mood the kept run must reach (75 reads "delighted", 55
  // "pleased"). Favourites like Spain are judged harder; 55 is still green.
  final minBoard = int.parse(Platform.environment['SITE_MIN_BOARD'] ?? '75');
  // The knockout rounds a kept run must win one of.
  final rounds = (Platform.environment['SITE_ROUNDS'] ?? 'SF,FINAL').split(',');

  /// Plays [seed] into [dir]; returns whether the run is good enough.
  Future<bool> build(int seed, String dir) async {
    Directory(dir).createSync(recursive: true);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        matchAttemptSaltProvider.overrideWithValue(() => 0),
        seedSourceProvider.overrideWithValue(AssetSeedSource(rootBundle)),
        formFactorProvider.overrideWithValue(FormFactor.phone),
      ],
    );
    final d = await StoryDriver.start(c, seed, nationId: nation);
    final id = d.careerId;
    final meta = <String, Object?>{'careerId': id, 'nation': nation};
    final saves = <Map<String, Object?>>[];
    var cycle = 1;
    var n = 0;

    Future<void> readAll() async {
      await c.read(messageServiceProvider).sync(id);
      await c.read(competitionRepositoryProvider).markMessagesRead(id);
    }

    Future<void> save(String name, Map<String, Object?> x) async {
      final path = '$dir/$name.db';
      final f = File(path);
      if (f.existsSync()) f.deleteSync();
      await db.customStatement("VACUUM INTO '$path'");
      saves.add({'name': name, 'db': path, 'cycle': cycle, ...x});
      // ignore: avoid_print
      print('SNAP $name cycle $cycle $x');
    }

    d.beforeEvent = (e) async {
      if (cycle < cycles) return;
      final route = e.route;
      final path = route == null ? null : Uri.parse(route).path;
      switch (e.kind) {
        case HubEventKind.draw:
          if (path == Routes.finalsDraw) {
            await readAll();
            await save('draw', {'route': route});
          }
        case HubEventKind.budget
            when route?.startsWith(Routes.budgetSetup) ?? false:
          await readAll();
          await save('budget', {'route': route});
        default:
          break;
      }
    };

    d.beforeMatch = (p) async {
      if (cycle < cycles) return;
      final f = p.fixture;
      // World Championship finals, and (for a nation that may not get there)
      // its continental championship's finals too, kept as `cf_`.
      final wcRound = FinalsRounds.worldChampionship.contains(f.round);
      if (!wcRound && !FinalsRounds.continental.contains(f.round)) return;
      final home = f.homeNationId == nation;
      final gf = home ? p.result.homeScore : p.result.awayScore;
      final ga = home ? p.result.awayScore : p.result.homeScore;
      await readAll();
      final sub = c.listen(satisfactionProvider(id).future, (_, _) {});
      final board = await sub.read();
      sub.close();
      final tag = wcRound ? 'wc' : 'cf';
      await save('${tag}_${(++n).toString().padLeft(2, '0')}_${f.round}', {
        'round': f.round,
        'gf': gf,
        'ga': ga,
        'home': home,
        'board': board,
        'goalMinutes': [
          for (final e in p.result.events)
            if (e.type == MatchEventType.goal && e.teamNationId == nation)
              e.minute,
        ],
      });
    };
    d.afterMatch = (Fixture played) async {};

    for (var cy = 0; cy < cycles; cy++) {
      var steps = 0;
      while (await d.step(stopAtRollover: true)) {
        if (++steps > 6000) throw StateError('runaway');
      }
      if (cy + 1 < cycles) {
        await d.step(); // the rollover
        cycle++;
      }
    }
    meta['saves'] = saves;
    File(
      '$dir/meta.json',
    ).writeAsStringSync(const JsonEncoder.withIndent(' ').convert(meta));
    // ignore: avoid_print
    print('DONE nation $nation seed $seed saves ${saves.length}');
    c.dispose();
    await db.close();
    return saves.any(
      (s) =>
          rounds.contains(s['round']) &&
          (s['gf']! as int) > (s['ga']! as int) &&
          (s['board']! as int) >= minBoard,
    );
  }

  test(
    'build the website save',
    () async {
      for (var s = seedFrom; s < seedFrom + seedCount; s++) {
        final dir = '${out!}/seed$s';
        if (await build(s, dir)) {
          // ignore: avoid_print
          print('GOOD nation $nation seed $s');
          return;
        }
        // SITE_KEEP=1 keeps every seed's run, to choose from by hand.
        if (Platform.environment['SITE_KEEP'] == null) {
          Directory(dir).deleteSync(recursive: true);
        }
      }
      // ignore: avoid_print
      print('NONE nation $nation');
    },
    skip: out == null ? 'set SITE_SAVE_OUT to build the website save' : null,
    timeout: const Timeout(Duration(minutes: 120)),
  );
}
