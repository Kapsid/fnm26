import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/features/match/match_screen.dart';

import '../helpers/seeded_save.dart' show settle;
import 'capture.dart';
import 'driver.dart';

/// Marketing, pass two of "Can Türkiye be world champion?": takes every shot
/// `turkiye_plan_test.dart` planned, each from a fresh copy of the save it
/// was planned on, so nothing a screen does can change the story.
/// ONLY=`substring` takes just the matching shots. Runs only when TK_WORK
/// names the plan's folder; shots go to STORY_OUT.
void main() {
  final workEnv = Platform.environment['TK_WORK'];
  final work = workEnv ?? 'build/turkiye_work';
  final only = Platform.environment['ONLY'];
  final onlyType = Platform.environment['ONLY_TYPE'];

  testWidgets(
    'türkiye story',
    (tester) async {
      await tester.runAsync(loadMaterialIcons);
      setPhone(tester);
      final manifest =
          jsonDecode(File('$work/manifest.json').readAsStringSync())
              as Map<String, Object?>;
      final id = manifest['careerId']! as int;
      final shots = (manifest['shots']! as List).cast<Map<String, Object?>>();
      final tmp = Directory('$work/tmp')..createSync(recursive: true);
      storyDb().close(); // resets the mock preferences
      // Set pieces left to the coach, as the plan played: a preference, not
      // part of the save, so set once for the career id every copy shares.
      await tester.runAsync(() async {
        final c = storyContainer();
        await StoryDriver(c, id).prepareMatch();
        c.dispose();
      });

      AppDatabase? db;
      ProviderContainer? ui;

      Future<void> close() async {
        // Close any popups first, so the sequence that opened them finishes:
        // the app counts open popups globally, and one abandoned mid-way
        // silences every later one.
        for (var i = 0; i < 30; i++) {
          final dialogs = find.byType(Dialog);
          if (dialogs.evaluate().isEmpty) break;
          Navigator.of(tester.element(dialogs.last)).pop();
          await tester.pump(const Duration(milliseconds: 300));
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 20)),
          );
          await tester.pump(const Duration(milliseconds: 300));
        }
        await tester.pumpWidget(const SizedBox());
        try {
          ui?.dispose();
        } on StateError catch (e) {
          // Riverpod completes a FutureProvider's handle again on dispose when
          // its future settled on the fake clock (the Y feed does): the screen
          // is already shot, so only the throwaway container is left half
          // disposed.
          // ignore: avoid_print
          print('dispose: $e');
        }
        ui = null;
        final old = db;
        db = null;
        // Closed on the fake clock it was opened on; from real time it hangs.
        if (old != null) {
          unawaited(old.close());
          await tester.pump(const Duration(milliseconds: 100));
        }
      }

      /// A fresh copy of [path] for the screen.
      Future<void> load(String path, String name) async {
        await close();
        final copy = '${tmp.path}/$name.db';
        File(path).copySync(copy);
        db = AppDatabase.forTesting(NativeDatabase(File(copy)));
        ui = storyContainer(db);
      }

      Future<void> settleFor(int seconds) async {
        await settle(tester, allowSpinner: true);
        for (var t = 0; t < seconds * 4; t++) {
          await tester.pump(const Duration(milliseconds: 250));
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 5)),
          );
        }
      }

      Future<void> popTop() =>
          tester.state<NavigatorState>(find.byType(Navigator).last).maybePop();

      /// Plays the match screen, shooting at [at] minutes, at half time, on
      /// Türkiye's goals and at full time. No change is made, so it plays the
      /// very match the plan committed.
      Future<void> live(
        String name, {
        required List<int> at,
        required bool halfTime,
        required bool goals,
        bool stopAtExtraTime = false,
        String? expect,
      }) async {
        await settle(tester, allowSpinner: true);
        final taken = <int>{};
        var htDone = false;
        var lastClock = '';
        var still = 0;
        var engGoals = 0;
        var maxMinute = 0;
        for (var i = 0; i < 4000; i++) {
          await tester.pump(const Duration(milliseconds: 120));
          final ht = find.byType(HalfTimePrompt);
          if (ht.evaluate().isNotEmpty) {
            if (stopAtExtraTime && maxMinute >= 90) {
              final b = tester.widget<MatchScoreboard>(
                find.byType(MatchScoreboard).first,
              );
              final sc = '${b.homeScore}-${b.awayScore}';
              // ignore: avoid_print
              print(
                sc == expect
                    ? 'MATCHOK $name $sc'
                    : 'MISMATCH $name live $sc plan $expect',
              );
              await tester.pump(const Duration(milliseconds: 600));
              await shoot(tester, '${name}_extratime');
              break;
            }
            if (halfTime && !htDone) {
              await tester.pump(const Duration(milliseconds: 600));
              await shoot(tester, '${name}_halftime');
            }
            htDone = true;
            tester.widget<HalfTimePrompt>(ht.first).onContinue();
            continue;
          }
          final sb = find.byType(MatchScoreboard);
          if (sb.evaluate().isEmpty) {
            if (++still > 40) {
              await popTop();
              still = 0;
            }
            continue;
          }
          final board = tester.widget<MatchScoreboard>(sb.first);
          if (board.clock == lastClock) {
            if (++still > 80) {
              // An injury opens the squad over the match: close it unchanged.
              await popTop();
              still = 0;
            }
          } else {
            still = 0;
            lastClock = board.clock;
          }
          final m =
              int.tryParse(
                RegExp(r'\d+').firstMatch(board.clock)?.group(0) ?? '',
              ) ??
              0;
          if (m > maxMinute) maxMinute = m;
          for (final t in at) {
            if (m >= t && taken.add(t)) await shoot(tester, '${name}_${t}min');
          }
          final eng = board.homeCode == 'TUR'
              ? board.homeScore
              : board.awayScore;
          if (goals && eng > engGoals) {
            await tester.pump(const Duration(milliseconds: 400));
            await shoot(tester, '${name}_goal$eng');
          }
          engGoals = eng;
          final score = '${board.homeScore}-${board.awayScore}';
          if (expect != null &&
              maxMinute >= 89 &&
              (ht.evaluate().isNotEmpty || !board.live)) {
            // ignore: avoid_print
            print(
              score == expect
                  ? 'MATCHOK $name $score'
                  : 'MISMATCH $name live $score plan $expect',
            );
          }
          if (!board.live && maxMinute >= 89) {
            await tester.pump(const Duration(seconds: 2));
            await shoot(tester, '${name}_fulltime');
            break;
          }
        }
      }

      var n = 0;
      for (final s in shots) {
        n++;
        final name = '${n.toString().padLeft(3, '0')}_${s['name']}';
        if (only != null && !name.contains(only)) continue;
        if (onlyType != null && s['type'] != onlyType) continue;
        final type = s['type'];
        await load(s['db']! as String, name);
        final route = s['route'] as String?;
        switch (type) {
          case 'snap':
            await pumpApp(tester, ui!, route!);
            await settleFor((s['extra'] as int?) ?? 2);
            final tap = s['tap'] as String?;
            if (tap != null && find.text(tap).evaluate().isNotEmpty) {
              await tester.tap(find.text(tap).first);
              await settleFor(2);
            }
            await shoot(tester, name);
          case 'live':
            await pumpApp(tester, ui!, '${Routes.match}?careerId=$id');
            await live(
              name,
              at: (s['at']! as List).cast<int>(),
              halfTime: s['halfTime']! as bool,
              goals: s['goals']! as bool,
              stopAtExtraTime: (s['stopAtExtraTime'] as bool?) ?? false,
              expect: s['expect'] as String?,
            );
          case 'search':
            await pumpApp(tester, ui!, route!);
            await settleFor(1);
            await tester.enterText(
              find.byType(TextField).first,
              s['text']! as String,
            );
            await settleFor(2);
            FocusManager.instance.primaryFocus?.unfocus();
            await settleFor(1);
            await shoot(tester, name);
          case 'press':
            await pumpApp(tester, ui!, route!);
            await settleFor(2);
            final btn = find.text(s['label']! as String);
            if (btn.evaluate().isNotEmpty) {
              await tester.tap(btn.first);
              await settleFor(2);
              await shoot(tester, name);
            }
        }
      }
      await close();
      tmp.deleteSync(recursive: true);
    },
    skip: workEnv == null, // set TK_WORK to take the planned shots
    timeout: const Timeout(Duration(minutes: 120)),
  );
}
