import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart' show settle;
import 'capture.dart';
import 'driver.dart';

/// WEBSITE SHOTS ONLY (not part of the suite): renders the site's carousel,
/// phone (shot-1 … shot-12) and tablet (ipad-1 … ipad-10), in one language,
/// from the saves `site_save_test` played. Each shot opens a fresh copy of its
/// save, so nothing one screen does reaches the next.
///
///   SITE_SAVES=<dir with meta.json> SITE_LANG=de SITE_RAW=<png dir>
///   ONLY=<substring> takes just the matching shots.
///
/// Phones are drawn at 402 x 874 points, 3x; tablets at 1366 x 1024, 2x.
const Size kSiteTablet = Size(1366, 1024);
const double kSiteTabletDpr = 2;

/// The faces `capture.dart` loads, in the order iOS would fall back to them.
const List<String> kSiteFallback = [
  'StorySF',
  'StoryJP',
  'StoryKR',
  'StoryTH',
  'StoryHI',
  'StorySymbols',
];

void main() {
  final savesEnv = Platform.environment['SITE_SAVES'];
  final lang = Platform.environment['SITE_LANG'] ?? 'en';
  final raw = Platform.environment['SITE_RAW'] ?? 'build/site_raw';
  final only = Platform.environment['ONLY'];
  // SKIP=shot-3,shot-5: names to leave out (the live match is slow).
  final skip = (Platform.environment['SKIP'] ?? '').split(',').toSet();
  // ONLY=shot-1,ipad-5: exact names; a single value also matches as a
  // substring, as before.
  final onlySet = only?.split(',').toSet();
  bool wanted(String name) =>
      only == null ||
      onlySet!.contains(name) ||
      (onlySet.length == 1 && name.contains(only));

  testWidgets(
    'website shots',
    (tester) async {
      await tester.runAsync(loadMaterialIcons);
      final dir = savesEnv!;
      final meta =
          jsonDecode(File('$dir/meta.json').readAsStringSync())
              as Map<String, Object?>;
      final id = meta['careerId']! as int;
      final nation = meta['nation']! as int;
      final saves = (meta['saves']! as List).cast<Map<String, Object?>>();
      Map<String, Object?>? named(String n) =>
          saves.where((s) => s['name'] == n).firstOrNull;

      // The match the story is told around: the deepest World Championship
      // knockout won with a goal, else the deepest finals match with a goal.
      // A nation that never reaches the World Championship finals tells its
      // story around its continental championship's finals (`cf_`) instead.
      final wcOnly = [
        for (final s in saves)
          if ((s['name']! as String).startsWith('wc_')) s,
      ];
      final wc = wcOnly.isNotEmpty
          ? wcOnly
          : [
              for (final s in saves)
                if ((s['name']! as String).startsWith('cf_')) s,
            ];
      final koEnv = Platform.environment['SITE_KO'];
      final ko = koEnv != null
          ? named(koEnv)!
          : wc.lastWhere(
              (s) =>
                  s['round'] != 'GROUP' &&
                  s['round'] != 'CGROUP' &&
                  (s['gf']! as int) > (s['ga']! as int) &&
                  (s['gf']! as int) > 0,
              orElse: () => wc.lastWhere(
                (s) => (s['gf']! as int) > 0,
                orElse: () => wc.last,
              ),
            );
      final draw = named('draw');
      final budget = named('budget');
      // ignore: avoid_print
      print('SITE ko ${ko['name']} ${ko['gf']}-${ko['ga']}');

      final tmp = Directory('$dir/tmp')..createSync(recursive: true);
      storyDb().close(); // resets the mock preferences
      await tester.runAsync(() async {
        final c = storyContainer();
        await StoryDriver(c, id).prepareMatch();
        c.dispose();
      });

      AppDatabase? db;
      ProviderContainer? ui0;
      var tablet = false;

      void setTablet() {
        tester.view
          ..physicalSize = kSiteTablet * kSiteTabletDpr
          ..devicePixelRatio = kSiteTabletDpr
          ..padding = FakeViewPadding.zero
          ..viewPadding = FakeViewPadding.zero;
        addTearDown(tester.view.reset);
      }

      Future<void> close() async {
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
          ui0?.dispose();
        } on StateError catch (e) {
          // ignore: avoid_print
          print('dispose: $e');
        }
        ui0 = null;
        final old = db;
        db = null;
        if (old != null) {
          unawaited(old.close());
          await tester.pump(const Duration(milliseconds: 100));
        }
      }

      Future<void> load(Map<String, Object?> s, String name) async {
        await close();
        final copy = '${tmp.path}/$name.db';
        // By name inside SITE_SAVES, so a save folder can be moved or renamed.
        File(
          '$dir/${(s['db']! as String).split('/').last}',
        ).copySync(copy);
        db = AppDatabase.forTesting(NativeDatabase(File(copy)));
        ui0 = storyContainer(db, 0, [
          if (tablet) formFactorProvider.overrideWithValue(FormFactor.tablet),
        ]);
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

      Future<void> shootAs(String name) async {
        // A button or bar that REPLACES the ambient text style drops the
        // fallback faces, and the test engine (unlike a phone) has no system
        // fallback, so its non-Latin label would draw as boxes. Hand every
        // paragraph without a fallback list the faces iOS would use.
        var patched = 0;
        for (final e in find.byType(RichText).evaluate()) {
          final ro = e.renderObject;
          if (ro is! RenderParagraph) continue;
          final t = ro.text;
          if (t is! TextSpan) continue;
          var changed = false;
          TextSpan fix(TextSpan s, {bool root = false}) {
            var style = s.style;
            final fb = style?.fontFamilyFallback;
            if ((style != null || root) && (fb == null || fb.isEmpty)) {
              style = (style ?? const TextStyle()).copyWith(
                fontFamilyFallback: kSiteFallback,
              );
              changed = true;
            }
            return TextSpan(
              text: s.text,
              children: [
                for (final c in s.children ?? const <InlineSpan>[])
                  c is TextSpan ? fix(c) : c,
              ],
              style: style,
              recognizer: s.recognizer,
              mouseCursor: s.mouseCursor,
              onEnter: s.onEnter,
              onExit: s.onExit,
              semanticsLabel: s.semanticsLabel,
              locale: s.locale,
              spellOut: s.spellOut,
            );
          }

          final fixed = fix(t, root: true);
          if (changed) {
            ro.text = fixed;
            patched++;
          }
        }
        if (patched > 0) await tester.pump();
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(kStoryRoot),
        );
        await tester.runAsync(() async {
          final image = await boundary.toImage(
            pixelRatio: tablet ? kSiteTabletDpr : kStoryDpr,
          );
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          final file = File('$raw/$name.png')..createSync(recursive: true);
          await file.writeAsBytes(data!.buffer.asUint8List());
          image.dispose();
        });
        // ignore: avoid_print
        print('SHOT $name');
      }

      // The player shown on the player screens: SITE_STAR names him (the
      // best called-up man, picked from the save by the caller), because
      // reading the squad provider from the test hangs on the fake clock.
      Future<int?> starPlayer() async =>
          int.tryParse(Platform.environment['SITE_STAR'] ?? '');

      Future<void> popTop() =>
          tester.state<NavigatorState>(find.byType(Navigator).last).maybePop();

      /// Plays the match screen: [goalName] on the first goal of ours,
      /// [htName] at the half-time talk, [atName] at minute [at].
      Future<void> live({
        String? goalName,
        String? htName,
        String? atName,
        int at = 0,
      }) async {
        final home = ko['home']! as bool;
        await settle(tester, allowSpinner: true);
        var ours = 0;
        var goalDone = goalName == null;
        var htDone = htName == null;
        var atDone = atName == null;
        var lastClock = '';
        var still = 0;
        for (var i = 0; i < 5000; i++) {
          if (goalDone && htDone && atDone) break;
          await tester.pump(const Duration(milliseconds: 120));
          if (i % 250 == 0) {
            final sbs = find.byType(MatchScoreboard).evaluate();
            // ignore: avoid_print
            print(
              'LIVE i=$i boards=${sbs.length} '
              'clock=$lastClock dialogs=${find.byType(Dialog).evaluate().length}',
            );
          }
          final ht = find.byType(HalfTimePrompt);
          if (ht.evaluate().isNotEmpty) {
            if (!htDone) {
              await tester.pump(const Duration(milliseconds: 600));
              await shootAs(htName!);
              htDone = true;
            }
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
          if (!atDone && m >= at) {
            await shootAs(atName!);
            atDone = true;
          }
          final g = home ? board.homeScore : board.awayScore;
          if (!goalDone && g > ours) {
            await tester.pump(const Duration(milliseconds: 400));
            await shootAs(goalName!);
            goalDone = true;
          }
          ours = g;
          if (!board.live && m >= 89) break;
        }
      }

      final hub = '${Routes.hub}?careerId=$id';
      final phone = <(String, Map<String, Object?>?, Future<void> Function())>[
        (
          'shot-1',
          ko,
          () async {
            await pumpApp(tester, ui0!, Routes.nations, locale: Locale(lang));
            await settleFor(2);
            await shootAs('shot-1');
          },
        ),
        (
          'shot-2',
          ko,
          () async {
            await pumpApp(
              tester,
              ui0!,
              '${Routes.tactics}?careerId=$id',
              locale: Locale(lang),
            );
            await settleFor(2);
            await shootAs('shot-2');
          },
        ),
        (
          'shot-3',
          ko,
          () async {
            await pumpApp(
              tester,
              ui0!,
              '${Routes.match}?careerId=$id',
              locale: Locale(lang),
            );
            await live(goalName: 'shot-3', htName: 'shot-4');
          },
        ),
        (
          'shot-5',
          draw,
          () async {
            await pumpApp(
              tester,
              ui0!,
              draw!['route']! as String,
              locale: Locale(lang),
            );
            await settleFor(1);
            final start = find.text(
              lookupAppLocalizations(Locale(lang)).tourDrawStart,
            );
            if (start.evaluate().isNotEmpty) {
              await tester.tap(start.first);
              await tester.pump();
            }
            for (final t in [4, 8, 14, 22]) {
              await settleFor(t == 4 ? 4 : t - 4);
              await shootAs('shot-5_t$t');
            }
          },
        ),
        (
          'shot-6',
          ko,
          () async {
            final p = await starPlayer();
            await pumpApp(
              tester,
              ui0!,
              '${Routes.player}?careerId=$id&playerId=$p',
              locale: Locale(lang),
            );
            await settleFor(2);
            await shootAs('shot-6');
          },
        ),
        for (final (n, route) in [
          ('shot-7', hub),
          ('shot-8', '${Routes.matchPreview}?careerId=$id'),
          ('shot-9', '${Routes.ranking}?careerId=$id'),
          ('shot-10', '${Routes.results}?careerId=$id'),
          ('shot-11', '${Routes.teamStats}?careerId=$id'),
          ('shot-12', '${Routes.youth}?careerId=$id'),
        ])
          (
            n,
            ko,
            () async {
              await pumpApp(tester, ui0!, route, locale: Locale(lang));
              await settleFor(3);
              if (n == 'shot-12') {
                final tab = find.text('U-17');
                if (tab.evaluate().isNotEmpty) {
                  // A long first tab ("Watched" in Greek) pushes U-17 off
                  // the scrolling tab bar; bring it in before tapping.
                  await tester.ensureVisible(tab.first);
                  await tester.pump(const Duration(milliseconds: 400));
                  await tester.tap(tab.first);
                  await settleFor(2);
                }
              }
              await shootAs(n);
            },
          ),
      ];

      final pad = <(String, Map<String, Object?>?, Future<void> Function())>[
        for (final (n, s, route) in [
          ('ipad-1', ko, hub),
          ('ipad-2', ko, Routes.nations),
          ('ipad-3', ko, '${Routes.tactics}?careerId=$id'),
          ('ipad-4', ko, '${Routes.matchPreview}?careerId=$id'),
          ('ipad-6', ko, '${Routes.ranking}?careerId=$id'),
          ('ipad-7', ko, '${Routes.tournaments}?careerId=$id'),
          ('ipad-8', ko, 'PLAYER'),
          ('ipad-9', budget, budget?['route'] as String? ?? ''),
          ('ipad-10', ko, '${Routes.results}?careerId=$id'),
        ])
          (
            n,
            s,
            () async {
              var r = route;
              if (r == 'PLAYER') {
                r = '${Routes.player}?careerId=$id&playerId=${await starPlayer()}';
              }
              await pumpApp(tester, ui0!, r, locale: Locale(lang));
              await settleFor(3);
              if (n == 'ipad-9') {
                // A manager mid-way through the split, not an untouched one.
                const share = [0.5, 0.3, 0.4, 0.2, 0.3];
                for (var i = 0; i < share.length; i++) {
                  final sliders = find.byType(Slider);
                  if (i >= sliders.evaluate().length) break;
                  final sl = tester.widget<Slider>(sliders.at(i));
                  sl.onChanged?.call((sl.max * share[i]).roundToDouble());
                  await tester.pump(const Duration(milliseconds: 200));
                }
                await settleFor(1);
              }
              await shootAs(n);
            },
          ),
        (
          'ipad-5',
          ko,
          () async {
            await pumpApp(
              tester,
              ui0!,
              '${Routes.match}?careerId=$id',
              locale: Locale(lang),
            );
            await live(atName: 'ipad-5', at: 12);
          },
        ),
      ];

      setPhone(tester);
      // SITE_PHONE=440x956: the larger iPhone frame instead (same shape), for
      // a screen whose copy in this language does not fit the 402pt phone.
      final phoneEnv = Platform.environment['SITE_PHONE'];
      if (phoneEnv != null) {
        final wh = phoneEnv.split('x').map(double.parse).toList();
        tester.view.physicalSize = Size(wh[0], wh[1]) * kStoryDpr;
      }
      for (final (name, s, run) in phone) {
        if (!wanted(name)) continue;
        if (skip.contains(name)) continue;
        if (s == null) {
          // ignore: avoid_print
          print('MISSING save for $name');
          continue;
        }
        await load(s, name);
        await run();
      }
      tablet = true;
      setTablet();
      for (final (name, s, run) in pad) {
        if (!wanted(name)) continue;
        if (skip.contains(name)) continue;
        if (s == null) {
          // ignore: avoid_print
          print('MISSING save for $name');
          continue;
        }
        await load(s, name);
        await run();
      }
      await close();
      tmp.deleteSync(recursive: true);
      // ignore: avoid_print
      print('SITE done $lang nation $nation');
    },
    skip: savesEnv == null, // set SITE_SAVES to render the site's shots
    timeout: const Timeout(Duration(minutes: 90)),
  );
}
