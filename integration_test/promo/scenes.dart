// PROMO VIDEO HARNESS: the scripted scenes. See promo_main.dart.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/federation/host_bid_screen.dart';
import 'package:fnm/features/federation/national_stadiums_screen.dart';
import 'package:fnm/features/federation/stadium_map/stadium_map.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/press/press_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'promo_main.dart';

const int englandId = 14;

int? stadiumPin;

/// The save the ranking clip is recorded from (the one with the best rank).
String rankingSave = 'rollover_c1';

/// Per-clip save overrides, `--dart-define=SAVES=07_board=rollover_c2,...`.
const String _saves = String.fromEnvironment('SAVES');

/// The save [clip] is recorded from: an override, or [fallback].
String saveFor(String clip, String fallback) {
  for (final pair in _saves.split(',')) {
    final kv = pair.split('=');
    if (kv.length == 2 && kv[0] == clip) return kv[1];
  }
  return fallback;
}

Future<void> runScenes(Promo p) async {
  final id = p.careerId;
  final sfx = p.tablet ? '_tablet' : '';
  String r(String route, [String extra = '']) => '$route?careerId=$id$extra';

  Future<void> open(String save, String route) async {
    await p.load(save);
    p.go(route);
    await p.wait(2.5);
    await p.settle();
    await p.clearDialogs();
    await p.wait(0.5);
  }

  MatchScoreboard? board() {
    final f = find.byType(MatchScoreboard);
    if (f.evaluate().isEmpty) return null;
    return p.ctl.widget<MatchScoreboard>(f.first);
  }

  int minute() {
    final b = board();
    if (b == null) return -1;
    final m = RegExp(r'\d+').firstMatch(b.clock);
    return m == null ? 0 : int.parse(m.group(0)!);
  }

  Future<void> kickOff({required int speed}) async {
    await p.acceptAutoSetPieces();
    await open(saveFor('02_match', 'ko_SF'), r(Routes.matchPreview));
  }

  Future<void> startMatch(int speed) async {
    await p.tap(p.text('Kick off'), after: 0.6);
    // A setup warning may stand between the preview and the pitch.
    if (board() == null) {
      for (final label in ['Play anyway', 'Kick off anyway', 'Continue']) {
        if (await p.tap(p.text(label), warn: false, after: 0.6)) break;
      }
    }
    await p.waitFor(find.byType(MatchScoreboard));
    for (var i = 0; i < 3 && p.text('$speed×').evaluate().isEmpty; i++) {
      await p.tap(p.textHas('×'), after: 0.3);
    }
  }

  // 01 Hub overview.
  await p.clip(
    '01_hub$sfx',
    setup: () => open(saveFor('01_hub', 'ko_SF'), r(Routes.hub)),
    body: () async {
      await p.wait(2.5);
      if (p.tablet) {
        await p.flick(260, after: 2);
        await p.flick(-260, after: 2);
        await p.tap(p.text('Squad'), after: 2.5, warn: false);
        await p.tap(p.text('Hub'), after: 2, warn: false);
      } else {
        await p.flick(260, after: 2.2);
        await p.flick(260, after: 2.2);
        await p.flick(-700, after: 2);
      }
    },
  );

  // 02 Live match: kick-off to England's first goal and its celebration.
  await p.clip(
    '02_match$sfx',
    setup: () => kickOff(speed: 2),
    body: () async {
      await p.wait(1.5);
      await startMatch(2);
      // Play through: Continue at half time, stop a few seconds after the
      // second goal, at full time, or at the length limit.
      final start = DateTime.now();
      var goals = 0;
      DateTime? last;
      while (DateTime.now().difference(start).inMilliseconds < 17500) {
        if (p.text('HALF TIME').evaluate().isNotEmpty) {
          await p.wait(1.6);
          await p.tap(p.text('Continue'), after: 0.2);
        }
        final b = board();
        if (b != null && b.homeScore + b.awayScore > goals) {
          goals = b.homeScore + b.awayScore;
          last = DateTime.now();
        }
        if (goals >= 2 &&
            last != null &&
            DateTime.now().difference(last).inMilliseconds > 3500) {
          break;
        }
        if (p.text('Full time').evaluate().isNotEmpty ||
            p.text('FULL TIME').evaluate().isNotEmpty) {
          await p.wait(2.5);
          break;
        }
        await p.wait(0.1);
      }
    },
  );

  // 03 Half-time team talk.
  await p.clip(
    '03_halftime$sfx',
    setup: () async {
      await kickOff(speed: 3);
      await startMatch(3);
      while (minute() < 31 && minute() != -1) {
        await p.wait(0.05);
      }
      // Pause off camera; play resumes on camera.
      await p.tap(find.byIcon(Icons.pause_rounded), after: 0.2, warn: false);
    },
    body: () async {
      await p.wait(0.8);
      await p.tap(find.byIcon(Icons.play_arrow_rounded), after: 0.2);
      await p.waitFor(p.text('HALF TIME'), timeout: 15);
      await p.wait(2.2);
      final talks = p.type('_TalkOption');
      if (talks.evaluate().length > 1) {
        await p.tap(talks.at(1), after: 2.2);
      }
      await p.tap(p.text('Continue'), after: 3.5);
    },
  );

  // 04 Tactics: formation, a drag, the full-back arrows.
  await p.clip(
    '04_tactics$sfx',
    setup: () => open('match_finals', r(Routes.tactics)),
    body: () async {
      if (!p.tablet) await p.flick(-500, after: 1.2);
      await p.wait(1.2);
      final field = find.byKey(TourKeys.tacticsFormation);
      if (await p.tap(field, after: 1.6)) {
        for (final f in ['4-2-3-1', '4-3-3', '4-4-2']) {
          final t = p.text(f);
          if (t.evaluate().length == 1 ||
              (t.evaluate().isNotEmpty && f != '4-3-3')) {
            if (await p.tap(t.last, after: 1.8, warn: false)) break;
          }
        }
      }
      if (!p.tablet) await p.flick(-500, after: 1.2);
      // Hold one man and drag him onto another, both on screen.
      final discs = find.byWidgetPredicate(
        (w) =>
            w.key is ValueKey<String> &&
            (w.key! as ValueKey<String>).value.startsWith('pitchDisc'),
      );
      final seen = <Offset>[
        for (var i = 0; i < discs.evaluate().length; i++)
          if (p.center(discs.at(i)).dy > 180 &&
              p.center(discs.at(i)).dy < p.screen.height * 0.6)
            p.center(discs.at(i)),
      ]..sort((a, b) => a.dy.compareTo(b.dy));
      log('discs on screen ${seen.length}');
      if (seen.length >= 4) {
        // The striker onto a winger.
        await p.holdDrag(seen[0], seen[1]);
        await p.wait(1.2);
      }
      final arrows = find.byWidgetPredicate(
        (w) =>
            w.key is ValueKey<String> &&
            (w.key! as ValueKey<String>).value.startsWith('pitchFullBack'),
      );
      for (var i = 0; i < arrows.evaluate().length && i < 2; i++) {
        await p.tap(arrows.at(i), after: 1);
        await p.tap(arrows.at(i), after: 1.2);
      }
      await p.wait(1);
    },
  );

  // 05 Call-ups and squad selection.
  await p.clip(
    '05_callups$sfx',
    setup: () =>
        open('callup', (p.info('callup')['route'] as String?) ?? r(Routes.callUps)),
    body: () async {
      await p.wait(2);
      await p.tap(p.text('Best quality'), after: 2.2);
      await p.flick(320, after: 1.8);
      await p.flick(320, after: 1.8);
      final more = p.type('_PlayerToggle');
      if (more.evaluate().length > 3) {
        await p.tap(more.at(3), after: 1.2);
        await p.tap(more.at(3), after: 1.2);
      }
      await p.flick(-700, after: 1.5);
    },
  );

  // 06 World ranking and the ranking history graph.
  await p.clip(
    '06_ranking$sfx',
    setup: () => open(saveFor('06_ranking', 'awards_post'), r(Routes.ranking)),
    body: () async {
      await p.wait(3);
      await p.flick(380, after: 1.6);
      await p.flick(380, after: 1.6);
      await p.flick(-450, after: 1.6);
      await p.tap(p.text('EUROPE'), after: 2.2, warn: false);
      await p.tap(p.text('SOUTH AMERICA'), after: 2.2, warn: false);
      await p.tap(p.text('ALL'), after: 1.5, warn: false);
    },
  );

  // 07 Board objectives.
  await p.clip(
    '07_board$sfx',
    setup: () =>
        open(saveFor('07_board', 'awards_post'), r(Routes.boardObjectives)),
    body: () async {
      await p.wait(3);
      await p.flick(300, after: 2.2);
      await p.flick(300, after: 2.2);
      await p.flick(-600, after: 1.5);
    },
  );

  // 08 Player of the Year ceremony, 5th to 1st.
  await p.clip(
    '08_poty$sfx',
    setup: () async {
      await p.load(saveFor('08_poty', 'awards_post'));
      p.go(r(Routes.hub));
      await p.wait(2);
      await p.settle();
      await p.clearDialogs();
      await p.wait(1);
      await p.clearDialogs();
    },
    body: () async {
      await p.wait(0.6);
      final save = saveFor('08_poty', 'awards_post');
      final route = (p.info(save)['route'] as String?)!;
      p.go('$route&watch=1');
      await p.wait(0.3);
      // Watch, if the screen asks.
      await p.wait(1.2);
      await p.waitFor(find.byKey(const Key('poty.ceremony')), timeout: 3);
      await p.wait(17.8);
    },
  );

  // 09 National stadiums and an upgrade.
  await p.clip(
    '09_stadiums$sfx',
    setup: () async {
      await open('cycle_start', r(Routes.stadiums));
      // Find a ground that can still be upgraded, off camera.
      for (var i = 0; i < 12; i++) {
        final pin = find.byKey(StadiumMap.pinKey(i));
        if (pin.evaluate().isEmpty) break;
        await p.tap(pin, after: 1.2, warn: false);
        final up = find.byKey(NationalStadiumsScreen.upgradeKey(i));
        final ok =
            up.evaluate().isNotEmpty &&
            p.ctl.widget<OutlinedButton>(up.first).onPressed != null;
        await p.popSheet();
        if (ok) {
          stadiumPin = i;
          break;
        }
      }
      log('stadium pin $stadiumPin');
    },
    body: () async {
      await p.wait(3);
      final i = stadiumPin;
      if (i == null) {
        await p.tap(p.text('List'), after: 2.5);
        await p.flick(300, after: 2);
        return;
      }
      await p.tap(find.byKey(StadiumMap.pinKey(i)), after: 2.2);
      await p.tap(find.byKey(NationalStadiumsScreen.upgradeKey(i)), after: 1.8);
      await p.tap(p.text('Confirm'), after: 3);
      await p.tap(find.byKey(StadiumMap.pinKey(i)), after: 2.5);
      await p.popSheet();
      await p.wait(1);
    },
  );

  // 10 World Championship host bid.
  await p.clip(
    '10_host_bid$sfx',
    setup: () async {
      await open('rollover_c3', r(Routes.cycleRollover));
      p.push(r(Routes.hostBid, '&comp=wc&nation=$englandId'));
      await p.wait(2);
    },
    body: () async {
      await p.wait(3);
      final slider = find.byKey(HostBidForm.sliderKey);
      if (slider.evaluate().isNotEmpty) {
        final rect = p.ctl.getRect(slider.first);
        final from = Offset(rect.left + 24, rect.center.dy);
        final to = Offset(rect.left + rect.width * 0.62, rect.center.dy);
        final g = await p.ctl.startGesture(from);
        for (var i = 1; i <= 24; i++) {
          await p.wait(0.04);
          await g.moveTo(Offset.lerp(from, to, i / 24)!);
        }
        await g.up();
        await p.wait(2);
      }
      await p.tap(p.text('Submit bid'), after: 4.5);
    },
  );

  // 11 Draw ceremony.
  await p.clip(
    '11_draw$sfx',
    setup: () =>
        open('draw', (p.info('draw')['route'] as String?) ?? r(Routes.finalsDraw)),
    body: () async {
      await p.wait(2);
      await p.tap(p.type('PrimaryButton'), after: 1);
      await p.wait(13);
      await p.tap(p.text('Skip'), after: 2.5, warn: false);
    },
  );

  // 12 Tournament bracket.
  await p.clip(
    '12_bracket$sfx',
    setup: () => open(saveFor('12_bracket', 'rollover_c2'), r(Routes.cup)),
    body: () async {
      await p.wait(2.5);
      // The final's card, one round back, then the whole bracket.
      final prev = find.byIcon(Icons.chevron_left_rounded);
      if (await p.tap(prev, after: 2, warn: false)) {
        await p.tap(find.byIcon(Icons.chevron_right_rounded), after: 1.8);
      }
      await p.tap(p.text('Bracket'), after: 3);
      await p.flick(300, after: 2.2);
    },
  );

  // 13 Trophy cabinet, records, player history.
  await p.clip(
    '13a_trophy_cabinet$sfx',
    setup: () =>
        open(saveFor('13a_trophy_cabinet', 'awards_post'), r(Routes.careerSummary)),
    body: () async {
      await p.wait(3);
      await p.flick(300, after: 2.2);
      await p.flick(300, after: 2.2);
      await p.flick(300, after: 2);
    },
  );
  await p.clip(
    '13b_records$sfx',
    setup: () => open(saveFor('13b_records', 'awards_post'), r(Routes.records)),
    body: () async {
      await p.wait(3);
      await p.flick(320, after: 2);
      await p.flick(320, after: 2);
      await p.flick(320, after: 2);
    },
  );
  await p.clip(
    '13c_player_history$sfx',
    setup: () =>
        open(saveFor('13c_player_history', 'awards_post'), r(Routes.teamStats)),
    body: () async {
      await p.wait(2.5);
      // Open the top scorer.
      if (await p.tap(p.type('LeaderRow'), after: 2.8)) {
        await p.flick(300, after: 2);
        await p.flick(300, after: 2);
      }
    },
  );

  // 14 Press conference.
  await p.clip(
    '14_press$sfx',
    setup: () => open(saveFor('14_press', 'press_c2_5'), r(Routes.hub)),
    body: () async {
      await p.wait(2);
      await p.tap(p.text('Face the press'), after: 2.5);
      for (var q = 0; q < 2; q++) {
        final answers = find.byType(AnswerTile);
        if (answers.evaluate().isEmpty) break;
        await p.wait(1.5);
        await p.tap(answers.first, after: 2.5);
      }
      await p.wait(1.5);
    },
  );
  await p.clip(
    '14b_y_feed$sfx',
    setup: () => open(saveFor('14b_y_feed', 'rollover_c2'), r(Routes.y)),
    body: () async {
      await p.wait(2.5);
      await p.flick(380, after: 1.8);
      await p.flick(380, after: 1.8);
      await p.flick(380, after: 1.8);
      await p.flick(380, after: 1.8);
    },
  );

  // 15 Campaigns: the list and Greenland's brief.
  await p.clip(
    '15_campaigns$sfx',
    setup: () => open('rollover_c3', Routes.campaigns),
    body: () async {
      await p.wait(2.5);
      await p.flick(250, after: 1.6);
      await p.flick(-250, after: 1.2);
      await p.flick(500, after: 1.5);
      await p.tap(find.byKey(const Key('campaign.tile.greenland')), after: 1);
      final at = p.c.read(routerProvider).routeInformationProvider.value.uri;
      if (at.path != Routes.campaignBrief) {
        log('campaign tap did not open the brief ($at)');
        p.go('${Routes.campaignBrief}?id=greenland');
      }
      await p.wait(5);
    },
  );

  // 16 Languages.
  await p.clip(
    '16_languages$sfx',
    setup: () => open('match_finals', Routes.settings),
    body: () async {
      await p.wait(2);
      for (final lang in ['Deutsch', 'Español', 'Français', 'Português']) {
        await p.tap(find.byKey(const Key('settings-language-tile')), after: 1.2);
        await p.tap(p.text(lang).last, after: 2);
      }
      for (final code in ['ja', 'ko']) {
        p.setLocale(code);
        await p.wait(1.8);
      }
    },
  );
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('settings.locale');
  p.setLocale(null);
}
