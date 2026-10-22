import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/config/testing_flags.dart';
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

/// Extra time on the live screen is played by the match engine (minutes
/// 91-120), so what the manager does at the 90' huddle reaches it, he gets one
/// more substitution for it, and what is committed is exactly what was shown.
/// It used to be a second, separate draw (`decideKnockout`) that no tactic,
/// substitution or talk could touch.

/// The commit path, recorded: what the screen hands the season service at
/// Continue. It never completes, so the screen stays put and nothing past the
/// commit (achievements, the route change) needs standing up.
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

/// A semi-final between two even, rated sides, each with a bench (so the AI
/// has its extra-time change to make).
MatchPreview _semiFinal() {
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
      id: 7,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      date: DateTime(2026, 7, 7),
      homeNationId: 1,
      awayNationId: 2,
      round: 'SF',
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

/// The screen's re-sim, reproduced, only to pick the salts below. The tests
/// assert on what the SCREEN commits, so a drift here shows up as a salt that
/// no longer does what its name says (each test checks), not a false pass.
MatchResult _liveResim(
  MatchPreview p,
  int salt, {
  List<TacticalChange> changes = const [],
}) => playWithAiExtraTimeSub(
  play: (subs) => const MatchEngine().play(
    home: p.homeTeam,
    away: p.awayTeam,
    rng: SeededRng.forFixture(p.saveSeed ^ salt, p.fixture.id),
    subs: subs,
    changes: changes,
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

const _allOut = TacticPreset(
  name: 'All out',
  formation: Formation.f424,
  instructions: TacticalInstructions(mentality: 100),
);

/// The change the preset makes when applied at the huddle (lands at 91).
TacticalChange _allOutAt91(MatchPreview p) => TacticalChange(
  teamNationId: 1,
  minute: 91,
  formation: _allOut.formation,
  instructions: _allOut.instructions,
  xi: p.homeTeam.xi,
  slots: _allOut.formation.positions,
);

List<(int, int, MatchEventType, int, int)> _sig(
  Iterable<MatchEvent> events,
) => [
  for (final e in events)
    (e.minute, e.stoppage, e.type, e.teamNationId, e.playerId),
];

bool _sameEt(MatchResult a, MatchResult b) =>
    _sig(a.events.where((e) => e.minute > 90)).toString() ==
    _sig(b.events.where((e) => e.minute > 90)).toString();

/// The first salt whose match is level at ninety and whose extra time the
/// all-out preset at 91 changes.
int _etSalt(MatchPreview p) {
  for (var salt = 1; salt < 5000; salt++) {
    final r = _liveResim(p, salt);
    if (r.extraTime == null) continue;
    final changed = _liveResim(p, salt, changes: [_allOutAt91(p)]);
    if (!_sameEt(r, changed)) return salt;
  }
  throw StateError('no level salt found');
}

/// The first salt whose match is decided inside ninety minutes.
int _ninetySalt(MatchPreview p) {
  for (var salt = 1; salt < 5000; salt++) {
    final r = _liveResim(p, salt);
    if (r.homeScore != r.awayScore) return salt;
  }
  throw StateError('no decided salt found');
}

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

/// Plays the match out on the clock, through every interval, naming the
/// automatic takers if it comes to that, and presses Continue at full time.
/// [atHuddle] runs at the 90' extra-time break; the headings seen are
/// returned in order.
Future<List<String>> _playOut(
  WidgetTester tester, {
  Future<void> Function()? atHuddle,
}) async {
  final headings = <String>[];
  for (var i = 0; i < 4000; i++) {
    await tester.pump(const Duration(milliseconds: 300));
    // An injury to one of his own opens the squad and waits on him: he
    // closes it with nothing changed, and play resumes.
    if (find.text(enL.tacticsApply).evaluate().isNotEmpty) {
      await tester.tap(find.text(enL.tacticsApply));
      await tester.pumpAndSettle();
      continue;
    }
    final prompt = find.byType(HalfTimePrompt);
    if (prompt.evaluate().isNotEmpty) {
      final heading = tester.widget<HalfTimePrompt>(prompt).heading;
      headings.add(heading);
      if (heading == enL.matchExtraTimeAhead && atHuddle != null) {
        await atHuddle();
      }
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
      await tester.tap(find.widgetWithText(PrimaryButton, enL.matchContinue));
      await tester.pump();
      return headings;
    }
  }
  fail('the match never reached full time');
}

/// The knockout committed must be the engine's extra time: its after-extra-
/// time score, and a shootout only when that score is level.
void _expectCommitsEngineExtraTime(_RecordingSeason s) {
  final r = s.result!;
  final et = r.extraTime;
  expect(et, isNotNull, reason: 'a level knockout plays extra time');
  final k = s.knockout!;
  expect((k.homeScore, k.awayScore), (et!.homeScore, et.awayScore));
  expect(k.afterExtraTime, isTrue);
  expect(k.wentToShootout, et.homeScore == et.awayScore);
  final etGoals = r.events.where(
    (e) => e.type == MatchEventType.goal && e.minute > 90,
  );
  expect(
    etGoals.length,
    et.homeScore + et.awayScore - r.homeScore - r.awayScore,
    reason: 'every extra-time goal is a real engine event',
  );
}

/// Names on the pitch are drawn with zero-width spaces between their letters
/// so a long one can wrap inside the ball, so plain text never finds them.
Finder _onPitchName(String text) => find.byWidgetPredicate(
  (w) => w is Text && w.data?.replaceAll('\u200b', '') == text,
  description: 'pitch name "$text"',
);

/// Opens the slot picker on [starterName] and looks for [benchName] under
/// each of its tabs; returns whether he is offered (the picker is left open).
Future<bool> _offered(
  WidgetTester tester,
  String starterName,
  String benchName,
) async {
  await tester.tap(_onPitchName(starterName.toUpperCase()).last);
  await tester.pumpAndSettle();
  if (find.text(benchName).evaluate().isEmpty) {
    for (final tab in [enL.tacticsTabOnPitch, enL.tacticsTabOtherPositions]) {
      final chip = find.text(tab);
      if (chip.evaluate().isEmpty) continue;
      await tester.tap(chip.last);
      await tester.pumpAndSettle();
      if (find.text(benchName).evaluate().isNotEmpty) break;
    }
  }
  return find.text(benchName).evaluate().isNotEmpty;
}

/// Puts [benchName] into the slot [starterName] occupies, through the slot
/// picker (the same path as `in_match_sub_undo_test.dart`).
Future<void> _substitute(
  WidgetTester tester,
  String starterName,
  String benchName,
) async {
  expect(
    await _offered(tester, starterName, benchName),
    isTrue,
    reason: '$benchName is offered for $starterName',
  );
  final target = find.text(benchName).last;
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

InMatchTacticsResult? _sheetResult;

/// The real editor at the 90' huddle of a side that has already made five
/// changes: starters 1-11 in a 4-4-2, 7-11 replaced by 12-16, and 17 fresh on
/// the bench.
Future<void> _openSheet(WidgetTester tester, {required int maxSubs}) async {
  _sheetResult = null;
  const formation = Formation.f442;
  final pool = [
    for (var i = 0; i < 11; i++)
      player(
        id: i + 1,
        nationId: 1,
        name: 'Starter${i + 1}',
        position: formation.positions[i],
      ),
    for (var i = 12; i <= 17; i++) player(id: i, nationId: 1, name: 'Bench$i'),
  ];
  await tester.binding.setSurfaceSize(const Size(400, 1600));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        theme: AppTheme.theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (inner) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () async {
                  _sheetResult = await showInMatchTactics(
                    inner,
                    minute: 90,
                    formation: formation,
                    lineup: const [1, 2, 3, 4, 5, 6, 12, 13, 14, 15, 16],
                    instructions: const TacticalInstructions(),
                    pool: pool,
                    startingIds: {for (var i = 1; i <= 11; i++) i},
                    maxSubs: maxSubs,
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final preview = _semiFinal();

  testWidgets("tactics at the 90' huddle change extra time", (tester) async {
    final salt = _etSalt(preview);

    final plain = await _pump(tester, preview: preview, salt: salt);
    final plainHeadings = await _playOut(tester);
    expect(plainHeadings, contains(enL.matchExtraTimeAhead));
    expect(plainHeadings, contains(enL.matchExtraTimeHalf));
    _expectCommitsEngineExtraTime(plain);
    // The AI side makes its one extra-time change at 91.
    expect(
      plain.result!.events.any(
        (e) =>
            e.type == MatchEventType.substitution &&
            e.teamNationId == 2 &&
            e.minute == 91,
      ),
      isTrue,
    );

    await tester.pumpWidget(const SizedBox());
    final changed = await _pump(tester, preview: preview, salt: salt);
    await _playOut(
      tester,
      atHuddle: () async {
        final prompt = find.byType(HalfTimePrompt);
        await tester.tap(
          find.descendant(
            of: prompt,
            matching: find.text(enL.matchTacticsWithSubs(0, kMaxSubsExtraTime)),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(InMatchTacticsKeys.presetsButton));
        await tester.pumpAndSettle();
        await tester.tap(find.text(_allOut.name));
        await tester.pumpAndSettle();
        await tester.tap(find.text(enL.tacticsApply));
        await tester.pumpAndSettle();
      },
    );
    _expectCommitsEngineExtraTime(changed);

    final a = plain.result!;
    final b = changed.result!;
    expect(
      _sig(b.events.where((e) => e.minute <= 90)),
      _sig(a.events.where((e) => e.minute <= 90)),
      reason: 'a change at the huddle never rewrites the ninety',
    );
    expect((b.homeScore, b.awayScore), (a.homeScore, a.awayScore));
    expect(
      _sameEt(a, b),
      isFalse,
      reason: 'the change reaches extra time',
    );
  });

  testWidgets('after five subs, the extra-time editor accepts a sixth', (
    tester,
  ) async {
    // Five starters (7-11) already replaced by 12-16; 17 is still fresh.
    await _openSheet(tester, maxSubs: kMaxSubsExtraTime);
    expect(find.text(enL.tacticsSubsUsed(5, kMaxSubsExtraTime)), findsWidgets);

    await _substitute(tester, 'Starter2', 'Bench17');
    expect(find.text(enL.tacticsTooManySubs(kMaxSubsExtraTime)), findsNothing);
    expect(find.text(enL.tacticsSubsUsed(6, kMaxSubsExtraTime)), findsWidgets);

    await tester.tap(find.text(enL.tacticsApply));
    await tester.pumpAndSettle();
    final out = _sheetResult;
    expect(out, isNotNull, reason: 'Apply confirms the change');
    expect(out!.lineup, contains(17));
    expect(out.lineup, isNot(contains(2)));
  });

  testWidgets('in normal time the same sixth is refused', (tester) async {
    // The control: the sixth above goes through because of the extra-time
    // limit, not because the editor stopped counting.
    await _openSheet(tester, maxSubs: kMaxSubs);
    expect(find.text(enL.tacticsSubsUsed(5, kMaxSubs)), findsWidgets);
    expect(
      await _offered(tester, 'Starter2', 'Bench17'),
      isFalse,
      reason: 'with five made of five, no one is left to bring on',
    );
  });

  testWidgets('a substitution made at the huddle comes on at 91', (
    tester,
  ) async {
    final salt = _etSalt(preview);
    final season = await _pump(tester, preview: preview, salt: salt);
    await _playOut(
      tester,
      atHuddle: () async {
        await tester.tap(
          find.text(enL.matchTacticsWithSubs(0, kMaxSubsExtraTime)),
        );
        await tester.pumpAndSettle();
        expect(
          find.text(enL.tacticsSubsUsed(0, kMaxSubsExtraTime)),
          findsOneWidget,
          reason: 'the editor at the huddle counts against six',
        );
        await _substitute(tester, '104', 'Player 150');
        await tester.tap(find.text(enL.tacticsApply));
        await tester.pumpAndSettle();
      },
    );
    expect(
      season.result!.events.any(
        (e) =>
            e.type == MatchEventType.substitution &&
            e.teamNationId == 1 &&
            e.minute == 91 &&
            e.playerId == 150,
      ),
      isTrue,
      reason: 'the engine brings him on at the start of extra time',
    );
    expect(kMaxSubsExtraTime, kMaxSubs + 1);
  });

  testWidgets('a knockout settled in ninety plays no extra time', (
    tester,
  ) async {
    final salt = _ninetySalt(preview);
    final season = await _pump(tester, preview: preview, salt: salt);
    final headings = await _playOut(tester);
    expect(headings, isNot(contains(enL.matchExtraTimeAhead)));
    expect(season.result!.extraTime, isNull);
    expect(season.knockout, isNull);
    expect(season.result!.events.where((e) => e.minute > 90), isEmpty);
    // The whistle went at ninety plus stoppage: full time, not extra time.
    expect(find.text(enL.matchClockFullTime), findsWidgets);
    expect(find.text(enL.matchClockAfterExtraTime), findsNothing);
  });

  testWidgets(
    "skip to full time on a level knockout reveals the engine's extra time",
    (tester) async {
      final salt = _etSalt(preview);
      final season = await _pump(tester, preview: preview, salt: salt);
      await tester.tap(find.byIcon(Icons.skip_next_rounded));
      await tester.pumpAndSettle();
      if (find.byType(PenaltyOrderSheet).evaluate().isNotEmpty) {
        await tester.tap(find.text('Take them'));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.skip_next_rounded));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.widgetWithText(PrimaryButton, enL.matchContinue));
      await tester.pump();
      _expectCommitsEngineExtraTime(season);
      expect(
        find.text(
          season.knockout!.wentToShootout
              ? enL.matchClockFullTimePenalties
              : enL.matchClockAfterExtraTime,
        ),
        findsWidgets,
      );
    },
    skip: !kShowSkipMatch,
  );
}
