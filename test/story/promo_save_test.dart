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
import 'package:fnm/features/federation/host_bid_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart'
    show kMatchViewModePrefsKey;

import 'driver.dart';

/// PROMO VIDEO ONLY (not part of the suite): plays an England career on the
/// app's own asset seed (the deep pool, as a real install has it) and saves
/// copies of the database at the moments the promo clips are recorded from.
/// Runs only when PROMO_OUT names the output folder.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final out = Platform.environment['PROMO_OUT'];
  final seedFrom = int.parse(Platform.environment['STORY_SEED'] ?? '1');
  final seedCount = int.parse(Platform.environment['SEED_COUNT'] ?? '1');
  final cycles = int.parse(Platform.environment['CYCLES'] ?? '3');
  // SEARCH=1: no snapshots, just one summary line per seed.
  final search = Platform.environment['SEARCH'] == '1';

  /// Plays one career into [out]; returns how many trophies England won.
  Future<int> build(int seed, String out) async {
      Directory(out).createSync(recursive: true);
      // Matches on the Timeline, as before the Pitch view: no Pitch or
      // Timeline question before kick-off.
      SharedPreferences.setMockInitialValues(<String, Object>{
        kMatchViewModePrefsKey: 'timeline',
      });
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
      final d = await StoryDriver.start(c, seed);
      final id = d.careerId;
      final meta = <String, Object?>{'careerId': id};
      final log = StringBuffer();
      var cycle = 1;
      var presses = 0;

      Future<void> readAll() async {
        await c.read(messageServiceProvider).sync(id);
        await c.read(competitionRepositoryProvider).markMessagesRead(id);
      }

      Future<void> save(String name, [Map<String, Object?>? x]) async {
        if (search) return;
        final path = '$out/$name.db';
        final f = File(path);
        if (f.existsSync()) f.deleteSync();
        await db.customStatement("VACUUM INTO '$path'");
        meta[name] = {'cycle': cycle, ...?x};
        // ignore: avoid_print
        print('SNAP $name cycle $cycle ${x ?? ''}');
      }

      d.beforeEvent = (e) async {
        final route = e.route;
        final path = route == null ? null : Uri.parse(route).path;
        if (cycle < 2 && e.kind != HubEventKind.awardsCeremony) return;
        switch (e.kind) {
          case HubEventKind.draw:
            if (path == Routes.finalsDraw || path == Routes.continentalDraw) {
              await save('draw', {'route': route});
            }
          case HubEventKind.callUp:
            if (path == Routes.callUps) await save('callup', {'route': route});
          case HubEventKind.press:
            await save('press', {'route': route, 'label': e.label});
            if (cycle == cycles) {
              await save('press_c${cycle}_${++presses}', {'label': e.label});
            }
          case HubEventKind.awardsCeremony:
            await save('awards', {'route': route});
          case HubEventKind.budget
              when route?.startsWith(Routes.budgetSetup) ?? false:
            await save('cycle_start', {'route': route});
          case HubEventKind.tournamentKickoff:
            await save('kickoff', {'route': route});
          default:
            break;
        }
      };

      final wcRun = <int, String>{};
      var wasFinal = false;
      d.beforeMatch = (p) async {
        final f = p.fixture;
        final home = f.homeNationId == england;
        final gf = home ? p.result.homeScore : p.result.awayScore;
        final ga = home ? p.result.awayScore : p.result.homeScore;
        final finals =
            FinalsRounds.worldChampionship.contains(f.round) ||
            FinalsRounds.continental.contains(f.round);
        wasFinal = {'FINAL', 'CFINAL'}.contains(f.round);
        final wcKo =
            FinalsRounds.worldChampionship.contains(f.round) &&
            f.round != 'GROUP';
        if (wcKo && gf > ga && cycle == cycles) {
          await readAll();
          await save('ko_${f.round}', {
            'score': '${p.result.homeScore}-${p.result.awayScore}',
            'home': home,
            'englandGoals': [
              for (final e in p.result.events)
                if (e.type == MatchEventType.goal && e.teamNationId == england)
                  e.minute,
            ],
          });
        }
        if (cycle >= 2 && gf >= 2 && gf > ga) {
          await readAll();
          await save(finals ? 'match_finals' : 'match', {
            'round': f.round,
            'score': '${p.result.homeScore}-${p.result.awayScore}',
            'home': home,
          });
        }
      };
      d.afterMatch = (Fixture played) async {
        log.writeln('c$cycle ${describe(played)}');
        if (FinalsRounds.worldChampionship.contains(played.round)) {
          final home = played.homeNationId == england;
          final gf = home ? played.homeScore! : played.awayScore!;
          final ga = home ? played.awayScore! : played.homeScore!;
          final pens = played.wentToShootout
              ? ((home ? played.homePenalties! : played.awayPenalties!) >
                        (home ? played.awayPenalties! : played.homePenalties!)
                    ? 'W'
                    : 'L')
              : null;
          wcRun[cycle] =
              '${played.round}:${pens ?? (gf > ga ? 'W' : gf < ga ? 'L' : 'D')}';
        }
        if (wasFinal) {
          await save(played.round == 'FINAL' ? 'bracket_wc' : 'bracket_cont', {
            'round': played.round,
          });
        }
      };

      for (var cy = 0; cy < cycles; cy++) {
        var steps = 0;
        while (await d.step(stopAtRollover: true)) {
          if (++steps > 6000) throw StateError('runaway');
        }
        await readAll();
        final offers = await c.read(
          hostBidOffersProvider((careerId: id, nationId: null)).future,
        );
        await save('rollover_c$cycle', {
          'hostOffers': [for (final o in offers) o.comp.code],
        });
        if (cy + 1 < cycles) {
          await d.step(); // the rollover
          cycle++;
        }
      }
      if (!search && Platform.environment['NEXT_AWARDS'] == '1') {
        // Into the next cycle, up to the first Player of the Year vote after
        // the last championship.
        await d.step(); // the rollover
        cycle++;
        var awarded = false;
        var postPress = 0;
        for (var i = 0; i < 4000; i++) {
          final e = await d.nextEvent();
          if (e.kind == HubEventKind.awardsCeremony && !awarded) {
            await readAll();
            await save('awards_post', {'route': e.route});
            awarded = true;
          }
          if (e.kind == HubEventKind.press) {
            await readAll();
            await save('press_post_${++postPress}', {'label': e.label});
          }
          if (awarded && postPress >= 2) break;
          if (e.kind == HubEventKind.cycleRollover) break;
          await d.step(stopAtRollover: true);
        }
      }
      var won = 0;
      for (final h in await c
          .read(competitionRepositoryProvider)
          .honours(id)) {
        if (h.championId == england && h.year >= 2026) {
          won++;
          log.writeln('HONOUR ${h.year} ${h.competition}');
        }
      }
      meta['trophies'] = won;
      meta['wcRun'] = {for (final e in wcRun.entries) '${e.key}': e.value};
      final honours = [
        for (final h in await c.read(competitionRepositoryProvider).honours(id))
          if (h.championId == england && h.year >= 2026)
            '${h.year} ${h.competition}',
      ];
      // ignore: avoid_print
      print('SUMMARY seed $seed trophies $won wc $wcRun honours $honours');
      meta['seed'] = seed;
      File(
        '$out/meta.json',
      ).writeAsStringSync(const JsonEncoder.withIndent(' ').convert(meta));
      File('$out/log.txt').writeAsStringSync(log.toString());
      c.dispose();
      await db.close();
      return won;
  }

  test(
    'build the promo save',
    () async {
      for (var s = seedFrom; s < seedFrom + seedCount; s++) {
        final won = await build(s, '${out!}/seed$s');
        // ignore: avoid_print
        print('SEED $s trophies $won');
        if (!search && won >= 2) break;
      }
    },
    skip: out == null ? 'set PROMO_OUT to build the promo save' : null,
    timeout: const Timeout(Duration(minutes: 120)),
  );
}
