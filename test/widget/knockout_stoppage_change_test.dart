import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/penalty_order_sheet.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/features/tactics/tactic_preset_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fixtures.dart';
import '../helpers/seeded_save.dart' show enL;

/// A player report from 1.0.5: "I won 1-0 and the match went straight to
/// penalties" in a continental-finals (Asian Cup) knockout.
///
/// The suspected mechanism: a tactical change made in regulation stoppage
/// (90+X) re-simulates the match, so the score at the whistle could move while
/// an extra-time / shootout outcome fixed earlier stays as it was. These tests
/// make that change in stoppage and pin the invariants the report says broke:
/// a knockout that is not level after ninety minutes and stoppage never goes
/// to extra time or penalties, a level one always does, the ninety the manager
/// watched is never rewritten, and what is committed is what the scoreboard
/// showed at the final whistle.

/// The commit path, recorded. It never completes, so the screen stays put.
class _RecordingSeason implements SeasonService {
  MatchResult? result;
  KnockoutOutcome? knockout;

  @override
  Future<void> playPlayerMatch(
    int careerId,
    Fixture fixture,
    MatchResult result, {
    KnockoutOutcome? knockout,
  }) {
    this.result = result;
    this.knockout = knockout;
    return Completer<void>().future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _saveSeed = 42;

/// An Asian Cup quarter-final: a continental finals knockout ('CQF').
MatchPreview _asianCupQuarterFinal() {
  final home = ratedTeam(1, 78);
  final away = ratedTeam(2, 78);
  List<Player> bench(int nationId) => [
    for (var i = 0; i < 7; i++)
      player(
        id: nationId * 100 + 50 + i,
        nationId: nationId,
        position: i.isEven ? PlayerPosition.cm : PlayerPosition.st,
        attributes: flatAttributes(76),
      ),
  ];
  return MatchPreview(
    fixture: Fixture(
      id: 11,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      date: DateTime(2027, 1, 30),
      homeNationId: 1,
      awayNationId: 2,
      round: 'CQF',
    ),
    // Unused: every test plays from a non-zero salt, so the screen re-sims.
    result: const MatchResult(
      homeScore: 0,
      awayScore: 0,
      events: [],
      homeShots: 0,
      awayShots: 0,
      homePossession: 50,
    ),
    nations: {1: nation(id: 1), 2: nation(id: 2)},
    homeTeam: home,
    awayTeam: away,
    playerNationId: 1,
    bench: bench(1),
    opponentBench: bench(2),
    saveSeed: _saveSeed,
    ground: (
      stadium: 'Test Park',
      city: 'Testville',
      groundNationId: 1,
      capacity: 40000,
      attendance: 30000,
      soldOut: false,
    ),
  );
}

/// The screen's re-sim, reproduced, only to pick salts. The tests assert on
/// what the SCREEN shows and commits.
MatchResult _liveResim(MatchPreview p, int salt) => playWithAiExtraTimeSub(
  play: (subs) => const MatchEngine().play(
    home: p.homeTeam,
    away: p.awayTeam,
    rng: SeededRng.forFixture(p.saveSeed ^ salt, p.fixture.id),
    subs: subs,
    aiManagedNationIds: {p.awayTeam.nationId},
    atmosphere: Attendance.atmosphere(p.ground),
    extraTimeIfLevel: true,
  ),
  aiSubs: p.opponentSubs,
  aiTeam: p.awayTeam,
  aiBench: p.opponentBench,
  saveSeed: p.saveSeed,
  fixtureId: p.fixture.id,
);

bool _hasStoppageGoal(MatchResult r) => r.events.any(
  (e) => e.type == MatchEventType.goal && e.minute == 90 && e.stoppage >= 2,
);

/// The first salt whose match is decided by one goal, with a goal scored late
/// in stoppage (90+2 or later), so a change at 90+1 lands before it.
int _oneGoalWithStoppageGoalSalt(MatchPreview p) {
  for (var salt = 1; salt < 20000; salt++) {
    final r = _liveResim(p, salt);
    if ((r.homeScore - r.awayScore).abs() == 1 && _hasStoppageGoal(r)) {
      return salt;
    }
  }
  throw StateError('no one-goal salt with a stoppage goal');
}

/// The first salt whose match is level after the ninety, made level by a goal
/// late in stoppage (an equaliser at 90+2 or later).
int _levelByStoppageGoalSalt(MatchPreview p) {
  for (var salt = 1; salt < 20000; salt++) {
    final r = _liveResim(p, salt);
    if (r.homeScore == r.awayScore && _hasStoppageGoal(r)) return salt;
  }
  throw StateError('no level salt with a stoppage goal');
}

const _allOut = TacticPreset(
  name: 'All out',
  formation: Formation.f424,
  instructions: TacticalInstructions(mentality: 100),
);

List<(int, int, MatchEventType, int, int)> _sig(
  Iterable<MatchEvent> events,
) => [
  for (final e in events)
    (e.minute, e.stoppage, e.type, e.teamNationId, e.playerId),
];

Future<_RecordingSeason> _pump(
  WidgetTester tester, {
  required MatchPreview preview,
  required int salt,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  tester.view
    ..physicalSize = const Size(400, 2600)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final season = _RecordingSeason();
  final c = ProviderContainer(
    overrides: [
      matchPreviewProvider(1).overrideWith((ref) async => preview),
      soundHapticsEnabledProvider.overrideWith((ref) => false),
      matchAttemptSaltProvider.overrideWithValue(() => salt),
      seasonServiceProvider.overrideWith((ref) => season),
    ],
  );
  addTearDown(c.dispose);
  await c.read(tacticPresetStoreProvider).save(1, _allOut);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        theme: AppTheme.theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MatchScreen(careerId: 1),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
  return season;
}

/// What the screen showed at the final whistle.
typedef _Shown = ({int home, int away, String clock, List<String> headings});

/// Plays the match out. With [changeInStoppage], the first time the clock
/// reads "90+1" the manager opens the tactics editor and applies the all-out
/// preset (it lands at 91). Returns what the scoreboard read at full time,
/// read just before Continue.
Future<_Shown> _playOut(
  WidgetTester tester, {
  required bool changeInStoppage,
}) async {
  final headings = <String>[];
  var changed = false;
  for (var i = 0; i < 4000; i++) {
    await tester.pump(const Duration(milliseconds: 300));
    if (find.text(enL.tacticsApply).evaluate().isNotEmpty) {
      // An injury pause: close the editor with nothing changed.
      await tester.tap(find.text(enL.tacticsApply));
      await tester.pumpAndSettle();
      continue;
    }
    final board = find.byType(MatchScoreboard);
    if (changeInStoppage &&
        !changed &&
        board.evaluate().isNotEmpty &&
        tester.widget<MatchScoreboard>(board).clock == '90+1') {
      changed = true;
      final bar = find.byType(MatchControlBar);
      expect(bar, findsOneWidget);
      tester.widget<MatchControlBar>(bar).onTactics();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(InMatchTacticsKeys.presetsButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text(_allOut.name));
      await tester.pumpAndSettle();
      await tester.tap(find.text(enL.tacticsApply));
      await tester.pumpAndSettle();
      // Resume if the editor left the clock stopped.
      final again = find.byType(MatchControlBar);
      if (again.evaluate().isNotEmpty &&
          !tester.widget<MatchControlBar>(again).playing) {
        tester.widget<MatchControlBar>(again).onPlayPause();
        await tester.pump();
      }
      continue;
    }
    final prompt = find.byType(HalfTimePrompt);
    if (prompt.evaluate().isNotEmpty) {
      headings.add(tester.widget<HalfTimePrompt>(prompt).heading);
      await tester.tap(
        find.descendant(of: prompt, matching: find.text(enL.matchContinue)),
      );
      await tester.pump();
      continue;
    }
    if (find.byType(PenaltyOrderSheet).evaluate().isNotEmpty) {
      await tester.tap(find.text('Take them'));
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
      continue;
    }
    if (find.byType(MatchControlBar).evaluate().isEmpty &&
        find
            .widgetWithText(PrimaryButton, enL.matchContinue)
            .evaluate()
            .isNotEmpty) {
      final sb = tester.widget<MatchScoreboard>(board);
      final shown = (
        home: sb.homeScore,
        away: sb.awayScore,
        clock: sb.clock,
        headings: headings,
      );
      await tester.tap(find.widgetWithText(PrimaryButton, enL.matchContinue));
      await tester.pump();
      expect(
        !changeInStoppage || changed,
        isTrue,
        reason: 'the change in stoppage was made',
      );
      return shown;
    }
  }
  fail('the match never reached full time');
}

/// The score the season service stores from what the screen committed (the
/// same arithmetic as `_playPlayerMatch`: a shootout win is +1 to the winner).
(int, int) _stored(_RecordingSeason s) {
  final r = s.result!;
  final ko = s.knockout;
  if (ko == null) return (r.homeScore, r.awayScore);
  if (!ko.wentToShootout) return (ko.homeScore, ko.awayScore);
  return ko.homeWon
      ? (ko.homeScore + 1, ko.awayScore)
      : (ko.homeScore, ko.awayScore + 1);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final preview = _asianCupQuarterFinal();

  testWidgets(
    'a one-goal knockout with a change made in stoppage never goes to '
    'extra time or penalties',
    (tester) async {
      final salt = _oneGoalWithStoppageGoalSalt(preview);

      final plain = await _pump(tester, preview: preview, salt: salt);
      await _playOut(tester, changeInStoppage: false);

      await tester.pumpWidget(const SizedBox());
      final season = await _pump(tester, preview: preview, salt: salt);
      final shown = await _playOut(tester, changeInStoppage: true);

      final r = season.result!;
      expect((r.homeScore - r.awayScore).abs(), 1);
      expect(
        _sig(r.events.where((e) => e.minute <= 90)),
        _sig(plain.result!.events.where((e) => e.minute <= 90)),
        reason:
            'a change at 90+1 never rewrites the ninety, stoppage goal '
            'included',
      );
      expect(season.knockout, isNull, reason: 'not level: no extra time');
      expect(r.extraTime, isNull);
      expect(shown.headings, isNot(contains(enL.matchExtraTimeAhead)));
      expect(shown.clock, enL.matchClockFullTime);
      expect((shown.home, shown.away), (r.homeScore, r.awayScore));
      expect((shown.home, shown.away), _stored(season));
    },
  );

  testWidgets(
    'a knockout levelled in stoppage, with a change made in stoppage, plays '
    'extra time and commits what was shown',
    (tester) async {
      final salt = _levelByStoppageGoalSalt(preview);

      final plain = await _pump(tester, preview: preview, salt: salt);
      await _playOut(tester, changeInStoppage: false);

      await tester.pumpWidget(const SizedBox());
      final season = await _pump(tester, preview: preview, salt: salt);
      final shown = await _playOut(tester, changeInStoppage: true);

      final r = season.result!;
      expect(r.homeScore, r.awayScore);
      expect(
        _sig(r.events.where((e) => e.minute <= 90)),
        _sig(plain.result!.events.where((e) => e.minute <= 90)),
        reason: 'a change at 90+1 never rewrites the ninety',
      );
      expect(shown.headings, contains(enL.matchExtraTimeAhead));
      final et = r.extraTime!;
      final ko = season.knockout!;
      expect((ko.homeScore, ko.awayScore), (et.homeScore, et.awayScore));
      expect(ko.wentToShootout, et.homeScore == et.awayScore);
      expect(
        shown.clock,
        ko.wentToShootout
            ? enL.matchClockFullTimePenalties
            : enL.matchClockAfterExtraTime,
      );
      expect((shown.home, shown.away), _stored(season));
    },
  );
}
