import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/finals_participation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/messages/message_providers.dart';

import 'driver.dart';

/// Marketing, pass one: plays the England career exactly as the finder does
/// and, at every story moment, saves a copy of the save and notes the shots
/// to take from it. `england_story_test.dart` takes them. Rendering never
/// touches this run, so the story is the one the finder found.
/// Marks all news read, generating what the inbox makes lazily first, so the
/// next hub shows only what happens after this.
Future<void> readAll(ProviderContainer c) async {
  final id = (await c.read(careerRepositoryProvider).all()).first.id;
  await c.read(messageServiceProvider).sync(id);
  await c.read(competitionRepositoryProvider).markMessagesRead(id);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // Runs only when STORY_SEED is set: it deletes and rewrites STORY_WORK, so
  // in the full suite it pulled the folder from under england_story_test.
  final seedEnv = Platform.environment['STORY_SEED'];
  final seed = int.parse(seedEnv ?? '1');
  final cycles = int.parse(Platform.environment['CYCLES'] ?? '3');
  final work = Platform.environment['STORY_WORK'] ?? 'build/story_work';

  test(
    'plan the england story',
    () async {
      if (Directory(work).existsSync())
        Directory(work).deleteSync(recursive: true);
      Directory('$work/snaps').createSync(recursive: true);
      final c = storyContainer();
      addTearDown(c.dispose);
      final d = await StoryDriver.start(c, seed);
      final id = d.careerId;
      final shots = <Map<String, Object?>>[];
      final log = StringBuffer();
      var snaps = 0;
      var cycle = 1;
      var rivalShots = 0;
      var upsets = 0;
      final firsts = <String>{};

      Future<String> save() async {
        final path = '$work/snaps/${(++snaps).toString().padLeft(3, '0')}.db';
        await c
            .read(appDatabaseProvider)
            .customStatement("VACUUM INTO '$path'");
        return path;
      }

      /// A copy of [src] changed by [edit] over its own connection; the career
      /// itself never sees the change.
      Future<String> editedCopy(
        String src,
        Future<void> Function(StoryDriver d) edit,
      ) async {
        final path = src.replaceFirst('.db', '_edit.db');
        File(src).copySync(path);
        final side = AppDatabase.forTesting(NativeDatabase(File(path)));
        final sc = storyContainer(side);
        await edit(StoryDriver(sc, id));
        sc.dispose();
        await side.close();
        return path;
      }

      void shot(
        String db,
        String type,
        String name, [
        Map<String, Object?>? x,
      ]) => shots.add({'db': db, 'type': type, 'name': name, ...?x});

      String hub() => '${Routes.hub}?careerId=$id';

      // Day one, with the welcome news still unread.
      var db = await save();
      shot(db, 'snap', 'day_one_hub', {'route': hub(), 'extra': 3});
      await readAll(c);
      db = await save();
      shot(db, 'snap', 'day_one_board_objectives', {
        'route': '${Routes.boardObjectives}?careerId=$id',
      });

      d.beforeEvent = (e) async {
        final route = e.route;
        final path = route == null ? null : Uri.parse(route).path;
        switch (e.kind) {
          case HubEventKind.draw:
            if (path == Routes.finalsDraw ||
                path == Routes.continentalDraw ||
                firsts.add('draw:$path')) {
              shot(
                await save(),
                'snap',
                'c${cycle}_draw_${path!.substring(1)}',
                {'route': route, 'extra': 40},
              );
            }
          case HubEventKind.tournamentKickoff:
            shot(await save(), 'snap', 'c${cycle}_kickoff', {
              'route': route,
              'extra': 12,
            });
          case HubEventKind.trainingCamp:
            shot(await save(), 'snap', 'c${cycle}_base_camp', {'route': route});
          case HubEventKind.friendlies:
            if (firsts.add('friendlies')) {
              shot(await save(), 'snap', 'friendlies', {'route': route});
            }
          case HubEventKind.budget:
            if (firsts.add('budget')) {
              shot(await save(), 'snap', 'budget', {'route': route});
            }
          case HubEventKind.press:
            if (upsets > 0 && firsts.add('press_after_upset')) {
              final db = await editedCopy(await save(), (d) => readAll(d.c));
              shot(db, 'press', 'c${cycle}_press_after_upset', {
                'route': hub(),
                'label': e.label,
              });
            }
          case HubEventKind.cycleRollover:
            shot(await save(), 'snap', 'c${cycle}_rollover', {
              'route': route,
              'extra': 4,
            });
          default:
            break;
        }
      };

      // Set per match in beforeMatch, read in afterMatch.
      var key = false;
      var slug = '';
      var isFinal = false;
      var rival = false;
      var upset = false;
      d.beforeMatch = (p) async {
        final f = p.fixture;
        final home = f.homeNationId == england;
        final opp = nationById[home ? f.awayNationId : f.homeNationId]!;
        final gf = home ? p.result.homeScore : p.result.awayScore;
        final ga = home ? p.result.awayScore : p.result.homeScore;
        final wc = FinalsRounds.worldChampionship.contains(f.round);
        final cont = FinalsRounds.continental.contains(f.round);
        final ko =
            f.round != null &&
            !{'GROUP', 'CGROUP', 'CQ', 'NGROUP', 'FRIENDLY'}.contains(f.round);
        isFinal = {'FINAL', 'CFINAL', 'FFINAL', 'NFINAL'}.contains(f.round);
        upset = gf < ga && opp.ranking > 25;
        rival = rivalIds.contains(opp.id) && rivalShots < 6;
        key = upset || rival || wc || cont || isFinal;
        slug = 'c${cycle}_${opp.code.toLowerCase()}_${f.round ?? 'wcq'}';
        if (!key) return;
        await readAll(c);
        final db = await save();
        // The armband is lent for the photo only: the story was played
        // without one, and it moves results.
        final lent = await editedCopy(db, (d) async => d.lendArmband());
        shot(lent, 'snap', '${slug}_preview', {
          'route': '${Routes.matchPreview}?careerId=$id',
        });
        // Level after ninety: the screen plays extra time its own way, so it
        // is photographed up to the huddle before it and no further.
        shot(db, 'live', slug, {
          'at': upset ? [70, 88] : (isFinal ? [1, 60] : <int>[]),
          'halfTime': upset || isFinal,
          'goals': isFinal || (wc && ko),
          'stopAtExtraTime': ko && gf == ga,
          'expect': '${p.result.homeScore}-${p.result.awayScore}',
        });
      };
      d.afterMatch = (Fixture played) async {
        log.writeln(describe(played));
        if (!key) return;
        if (rival) rivalShots++;
        if (upset) upsets++;
        final db = await save();
        shot(db, 'snap', '${slug}_results', {
          'route': '${Routes.roundResults}?careerId=$id',
        });
        shot(db, 'snap', '${slug}_news', {'route': hub(), 'extra': 3});
        final bracket = switch (played.round) {
          'FINAL' => ('${Routes.cup}?careerId=$id', 'wc_bracket'),
          'FFINAL' => ('${Routes.continentalClash}?careerId=$id', 'clash'),
          'NFINAL' => ('${Routes.nationsCup}?careerId=$id', 'nations_cup'),
          'CFINAL' => ('${Routes.continental}?careerId=$id', 'euro_bracket'),
          _ => null,
        };
        if (bracket != null) {
          shot(db, 'snap', 'c${cycle}_${bracket.$2}', {'route': bracket.$1});
        }
      };

      for (var cy = 0; cy < cycles; cy++) {
        var steps = 0;
        while (await d.step(stopAtRollover: true)) {
          if (++steps > 4000) throw StateError('runaway');
        }
        if (cy + 1 < cycles) {
          await d.step(); // the rollover (beforeEvent shoots it)
          cycle++;
        }
      }
      final last = await d.nextEvent();
      if (last.kind == HubEventKind.cycleRollover) {
        shot(await save(), 'snap', 'c${cycle}_rollover', {
          'route': last.route,
          'extra': 4,
        });
      }

      db = await save();
      for (final (r, name) in [
        ('${Routes.ranking}?careerId=$id', 'end_ranking'),
        ('${Routes.records}?careerId=$id', 'end_records'),
        ('${Routes.legends}?careerId=$id', 'end_legends'),
        ('${Routes.achievements}?careerId=$id', 'end_achievements'),
        ('${Routes.careerSummary}?careerId=$id', 'end_career_summary'),
        ('${Routes.managerHistory}?careerId=$id', 'end_manager_history'),
        (
          '${Routes.nationVitrine}?careerId=$id&nationId=$england',
          'end_vitrine',
        ),
        ('${Routes.teamStats}?careerId=$id', 'end_team_stats'),
        (
          '${Routes.h2hMeetings}?careerId=$id&a=$england&b=46',
          'end_h2h_scotland',
        ),
        (
          '${Routes.h2hMeetings}?careerId=$id&a=$england&b=20',
          'end_h2h_germany',
        ),
        (
          '${Routes.h2hMeetings}?careerId=$id&a=$england&b=56',
          'end_h2h_argentina',
        ),
        (
          '${Routes.h2hMeetings}?careerId=$id&a=$england&b=13',
          'end_h2h_denmark',
        ),
        (
          '${Routes.h2hMeetings}?careerId=$id&a=$england&b=31',
          'end_h2h_lithuania',
        ),
        (
          '${Routes.h2hMeetings}?careerId=$id&a=$england&b=10',
          'end_h2h_croatia',
        ),
        ('${Routes.headToHead}?careerId=$id', 'end_head_to_head'),
        (hub(), 'end_hub'),
      ]) {
        shot(db, 'snap', name, {'route': r});
      }
      File('$work/manifest.json').writeAsStringSync(
        const JsonEncoder.withIndent(
          ' ',
        ).convert({'careerId': id, 'shots': shots}),
      );
      File('$work/log.txt').writeAsStringSync(log.toString());
    },
    skip: seedEnv == null ? 'set STORY_SEED to plan the story' : null,
    timeout: const Timeout(Duration(minutes: 60)),
  );
}
