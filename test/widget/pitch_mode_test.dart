import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/penalty_order_sheet.dart';
import 'package:fnm/features/match/pitch/pitch_clock.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_mode_controller.dart';
import 'package:fnm/features/match/pitch/pitch_playback.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fixtures.dart';
import '../helpers/pitch_view_fixture.dart' show pitchNation;
import '../helpers/seeded_save.dart' show enL;

/// The phone match screen in Pitch mode: the Pitch view's clock runs the
/// match, and everything the screen shows (minute, score, events, the
/// pauses) stays exactly what the Timeline shows.

/// Bakes every look as a copy of one small image, at once: the bake is not
/// what is under test, and a real one needs real time.
class _InstantBaker extends PitchStadiumBaker {
  _InstantBaker(this.image);
  final ui.Image image;

  @override
  Future<ui.Image?> flag(String code) => Future.value();

  @override
  Future<ui.Image> look(
    PitchStadium stadium,
    PitchProjection projection,
    Size size,
    PitchLight light, {
    ui.Image? flag,
    double pixelRatio = 1,
  }) => Future.value(image.clone());

  @override
  Future<ui.Image?> show(
    PitchStadium stadium,
    PitchProjection projection,
    Size size,
    PitchLight light, {
    double pixelRatio = 1,
  }) => Future.value();
}

const List<String> _surnames = [
  'Novak', 'Kral', 'Dvorak', 'Havel', 'Soukup', 'Benes', 'Marek', //
  'Fiala', 'Kucera', 'Horak', 'Pinto', 'Ferreira', 'Santos', 'Costa',
  'Mendes', 'Lopes', 'Ribeiro', 'Martins', 'Sousa', 'Gomes', 'Moreira',
  'Teixeira', 'Rocha', 'Vieira', 'Bartos', 'Cerny', 'Zeman', 'Vesely',
  'Pokorny', 'Ruzicka', 'Simek', 'Holub', 'Nemec', 'Urban', 'Kopecky',
];

/// A real match between the Czech Republic (the manager's) and Portugal, in
/// [round], with a bench each and a name for everybody.
MatchPreview _preview({String round = 'FRIENDLY', int saveSeed = 42}) {
  final home = pitchNation('CZE');
  final away = pitchNation('POR');
  var k = 0;
  Player p(Nation n, int id, PlayerPosition pos, int rating) => player(
    id: id,
    nationId: n.id,
    name: 'Jan ${_surnames[k++ % _surnames.length]}',
    position: pos,
    attributes: flatAttributes(rating),
  );
  MatchTeam team(Nation n, int rating) => MatchTeam(
    nationId: n.id,
    formation: Formation.f433,
    instructions: const TacticalInstructions(),
    xi: [
      for (var i = 0; i < 11; i++)
        p(n, n.id * 100 + i, Formation.f433.positions[i], rating),
    ],
  );
  List<Player> bench(Nation n) => [
    for (var i = 0; i < 6; i++)
      p(
        n,
        n.id * 100 + 50 + i,
        i == 5 ? PlayerPosition.gk : PlayerPosition.cm,
        76,
      ),
  ];
  return MatchPreview(
    fixture: Fixture(
      id: 9,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      date: DateTime(2026, 9, 10),
      homeNationId: home.id,
      awayNationId: away.id,
      round: round,
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
    nations: {home.id: home, away.id: away},
    homeTeam: team(home, 78),
    awayTeam: team(away, 78),
    playerNationId: home.id,
    bench: bench(home),
    opponentBench: bench(away),
    saveSeed: saveSeed,
    ground: (
      stadium: 'Test Park',
      city: 'Brno',
      groundNationId: home.id,
      capacity: 30000,
      attendance: 27000,
      soldOut: false,
    ),
  );
}

/// The screen's re-sim with no changes, reproduced only to pick salts; each
/// test checks the screen's own result has what its salt was picked for.
MatchResult _liveResim(MatchPreview p, int salt) => playWithAiExtraTimeSub(
  play: (subs) => const MatchEngine().play(
    home: p.homeTeam,
    away: p.awayTeam,
    rng: SeededRng.forFixture(p.saveSeed ^ salt, p.fixture.id),
    subs: subs,
    aiManagedNationIds: {p.awayTeam.nationId},
    atmosphere: Attendance.atmosphere(p.ground),
    extraTimeIfLevel: Rounds.isKnockout(p.fixture.round),
    bigMatch: p.bigMatch,
    conditions: p.conditions,
  ),
  aiSubs: p.opponentSubs,
  aiTeam: p.awayTeam,
  aiBench: p.opponentBench,
  saveSeed: p.saveSeed,
  fixtureId: p.fixture.id,
);

int _salt(MatchPreview p, bool Function(MatchResult r) wanted) {
  for (var salt = 1; salt < 4000; salt++) {
    if (wanted(_liveResim(p, salt))) return salt;
  }
  throw StateError('no salt found');
}

late ui.Image _image;

Future<ProviderContainer> _pump(
  WidgetTester tester, {
  required MatchPreview preview,
  required int salt,
  Map<String, Object> prefs = const {},
  bool resetPrefs = true,
  PitchPlaybackBuilder? builder,
  PitchPlaybackInPlace? inPlace,
  WeatherKind? weather,
}) async {
  if (resetPrefs) SharedPreferences.setMockInitialValues(prefs);
  tester.view
    ..physicalSize = const Size(400, 2000)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final c = ProviderContainer(
    overrides: [
      matchPreviewProvider(1).overrideWith((ref) async => preview),
      soundHapticsEnabledProvider.overrideWith((ref) => false),
      matchAttemptSaltProvider.overrideWithValue(() => salt),
      pitchStadiumBakerProvider.overrideWithValue(_InstantBaker(_image)),
      // Built in place: the isolate build is checked on its own
      // (script_build_cost_test); here it would need real time.
      pitchPlaybackBuilderProvider.overrideWithValue(
        builder ?? (b) async => b.run(),
      ),
      if (weather != null)
        pitchForcedWeatherProvider.overrideWithValue(weather),
      if (inPlace != null)
        pitchPlaybackInPlaceProvider.overrideWithValue(inPlace),
    ],
  );
  addTearDown(c.dispose);
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
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
  return c;
}

MatchScreenProbe _screen(WidgetTester tester) =>
    tester.state(find.byType(MatchScreen)) as MatchScreenProbe;

PitchClock _clock(WidgetTester tester) => _screen(tester).pitchMode.clock!;

PitchPlayback _pb(WidgetTester tester) => _screen(tester).pitchMode.playback!;

MatchResult _result(WidgetTester tester) => _screen(tester).result!;

/// What the manager can read: the clock, the score and the events shown.
({String clock, int home, int away, String events}) _seen(
  WidgetTester tester,
) {
  final s = tester.widget<MatchScoreboard>(find.byType(MatchScoreboard));
  final shown = _screen(tester).shownEvents;
  return (
    clock: s.clock,
    home: s.homeScore,
    away: s.awayScore,
    events: [
      for (final e in shown)
        '${e.type.name} ${e.minute}+${e.stoppage} ${e.playerId}',
    ].join(' | '),
  );
}

Future<void> _switch(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('match.viewSwitch')));
  await tester.pump();
  await tester.pump();
}

/// The header switch's action at an interval, whose card covers the header.
Future<void> _switchUnder(WidgetTester tester) async {
  _screen(tester).switchMode();
  await tester.pump();
  await tester.pump();
}

/// Moves the Pitch clock to screen time [t] and lets the screen catch up.
Future<void> _seek(WidgetTester tester, Duration t) async {
  _screen(tester).seekPitch(t);
  await tester.pump();
}

Duration _secs(double s) => Duration(microseconds: (s * 1e6).round());

/// Pumps frames until [done] or a minute of fake time has gone.
Future<void> _until(WidgetTester tester, bool Function() done) async {
  for (var i = 0; i < 3600 && !done(); i++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
  expect(done(), isTrue, reason: 'never got there');
}

bool _ready(WidgetTester tester) {
  final v = find.byType(PitchMatchView);
  if (v.evaluate().isEmpty) return false;
  return tester.state<PitchMatchViewState>(v).ready.value;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    _image = await createTestImage(width: 4, height: 4);
  });

  testWidgets('choose Pitch before kick-off and the pitch shows', (
    tester,
  ) async {
    await _pump(tester, preview: _preview(), salt: 7);
    // Never having chosen, the manager is asked where the Timeline goes, and
    // the match waits for him.
    expect(find.byType(MatchViewChooser), findsOneWidget);
    expect(find.byType(PitchMatchView), findsNothing);
    await tester.pump(const Duration(seconds: 2));
    expect(_seen(tester).clock, '0');

    await tester.tap(find.byKey(MatchViewChooser.pitchKey));
    await tester.pump();
    await tester.pump();
    expect(find.byType(MatchViewChooser), findsNothing);
    expect(find.byType(PitchMatchView), findsOneWidget);
    expect(find.byType(PitchCommentaryLine), findsOneWidget);
    // Pitch mode drops the Timeline tab: the pitch and its line stand in.
    expect(find.text(enL.matchTabTimeline), findsNothing);
    expect(find.text(enL.matchTabStats), findsOneWidget);

    // The clock waits for the ground to be baked, then runs the match.
    await _until(tester, () => _ready(tester));
    await _until(tester, () => _clock(tester).playing);
    await _until(tester, () => _seen(tester).clock != '0');
    expect(int.parse(_seen(tester).clock), greaterThan(0));
  });

  testWidgets('a failing off-thread build falls back to an in-place one', (
    tester,
  ) async {
    var calls = 0;
    await _pump(
      tester,
      preview: _preview(),
      salt: 7,
      builder: (b) async {
        calls++;
        throw StateError('the isolate died');
      },
    );
    await tester.tap(find.byKey(MatchViewChooser.pitchKey));
    await tester.pump();
    await tester.pump();
    // The worker threw, yet the picture is built and the match plays on.
    await _until(tester, () => _screen(tester).pitchMode.playback != null);
    expect(calls, greaterThan(0));
    expect(_screen(tester).pitchMode.building, isFalse);
    await _until(tester, () => _ready(tester));
    await _until(tester, () => _clock(tester).playing);
    await _until(tester, () => _seen(tester).clock != '0');
  });

  testWidgets('when the in-place build fails too, the pitch shows an error '
      'and the way to the Timeline, never an endless spinner', (tester) async {
    await _pump(
      tester,
      preview: _preview(),
      salt: 7,
      builder: (b) async => throw StateError('the isolate died'),
      inPlace: (b) => throw StateError('and so did the fallback'),
    );
    await tester.tap(find.byKey(MatchViewChooser.pitchKey));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    final pc = _screen(tester).pitchMode;
    expect(pc.building, isFalse);
    expect(pc.failed, isTrue);
    expect(find.byKey(const Key('match.pitchFailed')), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    // The Timeline plays the match on.
    await tester.tap(find.byKey(const Key('match.pitchFailedTimeline')));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(const Key('match.pitchFailed')), findsNothing);
    expect(find.byType(PitchMatchView), findsNothing);
    await tester.pump(const Duration(seconds: 3));
    expect(int.parse(_seen(tester).clock), greaterThan(0));
  });

  testWidgets('the choice is remembered', (tester) async {
    await _pump(tester, preview: _preview(), salt: 7);
    await tester.tap(find.byKey(MatchViewChooser.pitchKey));
    await tester.pump();
    await tester.pump();
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(kMatchViewModePrefsKey), 'pitch');

    // The next match opens straight on the pitch: no question asked.
    await tester.pumpWidget(const SizedBox());
    await _pump(tester, preview: _preview(), salt: 8, resetPrefs: false);
    expect(find.byType(MatchViewChooser), findsNothing);
    expect(find.byType(PitchMatchView), findsOneWidget);

    // The header switch is remembered too.
    await _switch(tester);
    expect(find.byType(PitchMatchView), findsNothing);
    await tester.pump();
    expect(prefs.getString(kMatchViewModePrefsKey), 'timeline');
    await tester.pumpWidget(const SizedBox());
    await _pump(tester, preview: _preview(), salt: 9, resetPrefs: false);
    expect(find.byType(PitchMatchView), findsNothing);
    expect(find.byType(MatchViewChooser), findsNothing);
    expect(_screen(tester).mode, MatchViewMode.timeline);
  });

  testWidgets('switching mid-match keeps minute, score and visible events '
      'identical', (tester) async {
    final preview = _preview();
    final salt = _salt(
      preview,
      (r) =>
          r.events.where((e) => e.type == MatchEventType.goal).length >= 2 &&
          r.events.any((e) => e.type == MatchEventType.goal && e.minute < 44),
    );
    await _pump(
      tester,
      preview: preview,
      salt: salt,
      prefs: {kMatchViewModePrefsKey: 'pitch'},
    );
    await _until(tester, () => _ready(tester) && _clock(tester).playing);
    final r = _result(tester);
    final goalIndex = r.events.indexWhere(
      (e) => e.type == MatchEventType.goal && e.minute < 44,
    );
    final goal = r.events[goalIndex];
    var pb = _pb(tester);
    final from = pb.pacer.screenAt(goal.minute, goal.stoppage);
    final at = pb.revealAt(goalIndex);
    expect(
      at,
      greaterThan(from.inMicroseconds / 1e6 + 0.05),
      reason: 'the goal goes in part-way through its minute',
    );

    // 1. Mid-moment: the goal's minute is on the clock, the ball not in yet.
    await _seek(tester, _secs(at - 0.05));
    final before = _seen(tester);
    expect(before.clock, '${goal.minute}');
    expect(
      before.events,
      isNot(contains('goal ${goal.minute}+0 ${goal.playerId}')),
      reason: 'the score never runs ahead of the picture',
    );
    await _switch(tester);
    expect(find.byType(PitchMatchView), findsNothing);
    expect(_seen(tester), before);
    // The Timeline's next tick plays the rest of that minute (the goal, with
    // its flash) before it moves on.
    await tester.pump(const Duration(milliseconds: 400));
    final after = _seen(tester);
    expect(after.clock, '${goal.minute}');
    expect(after.events, contains('goal ${goal.minute}+0 ${goal.playerId}'));
    expect(find.text(enL.matchGoalShout), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));

    // 2. Back on the pitch: the clock goes on from the Timeline's minute,
    // nothing shown twice, nothing lost.
    final timeline = _seen(tester);
    await _switch(tester);
    expect(find.byType(PitchMatchView), findsOneWidget);
    expect(_seen(tester), timeline);
    expect(find.text(enL.matchGoalShout), findsNothing);
    pb = _pb(tester);
    final pos = pb.positionAt(_clock(tester).value);
    expect('${pos.minute}', timeline.clock);

    // 3. At half time, on the pitch, then the Timeline, then back.
    await _until(tester, () => _ready(tester));
    await _seek(tester, pb.halfTime - const Duration(milliseconds: 300));
    await _until(
      tester,
      () => find.byType(HalfTimePrompt).evaluate().isNotEmpty,
    );
    final half = _seen(tester);
    expect(half.clock, '45');
    expect(_clock(tester).playing, isFalse);
    await _switchUnder(tester);
    expect(find.byType(PitchMatchView), findsNothing);
    expect(_seen(tester), half);
    expect(find.byType(HalfTimePrompt), findsOneWidget);
    await _switchUnder(tester);
    expect(find.byType(PitchMatchView), findsOneWidget);
    expect(_seen(tester), half);
    expect(find.byType(HalfTimePrompt), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(HalfTimePrompt),
        matching: find.text(enL.matchContinue),
      ),
    );
    await tester.pump();
    await _until(tester, () => _seen(tester).clock == '46');
    expect(_seen(tester).events, half.events);
  });

  testWidgets('switching keeps the match identical in extra time', (
    tester,
  ) async {
    final preview = _preview(round: 'SF');
    final salt = _salt(preview, (r) => r.extraTime != null);
    await _pump(
      tester,
      preview: preview,
      salt: salt,
      prefs: {kMatchViewModePrefsKey: 'pitch'},
    );
    await _until(tester, () => _ready(tester) && _clock(tester).playing);
    expect(_result(tester).extraTime, isNotNull);
    final pb = _pb(tester);

    // Through half time.
    await _seek(tester, pb.halfTime - const Duration(milliseconds: 100));
    await _until(
      tester,
      () => find.byType(HalfTimePrompt).evaluate().isNotEmpty,
    );
    await tester.tap(find.text(enL.matchContinue).last);
    await tester.pump();

    // The huddle before extra time: the same on both.
    await _seek(tester, pb.extraTimeStart! - const Duration(milliseconds: 100));
    await _until(
      tester,
      () => find.text(enL.matchExtraTimeAhead).evaluate().isNotEmpty,
    );
    final huddle = _seen(tester);
    await _switchUnder(tester);
    expect(find.byType(PitchMatchView), findsNothing);
    expect(_seen(tester), huddle);
    await _switchUnder(tester);
    expect(find.byType(PitchMatchView), findsOneWidget);
    expect(_seen(tester), huddle);
    await tester.tap(find.text(enL.matchContinue).last);
    await tester.pump();

    // Part-way through extra time.
    await _until(tester, () => _ready(tester));
    await _seek(tester, _pb(tester).pacer.screenAt(98, 0, within: 0.5));
    final et = _seen(tester);
    expect(et.clock, 'ET 98');
    await _switch(tester);
    expect(_seen(tester), et);
    await _switch(tester);
    expect(_seen(tester), et);
  });

  testWidgets('a sub mid-match rebuilds the script at the current minute', (
    tester,
  ) async {
    final preview = _preview();
    final salt = _salt(
      preview,
      (r) =>
          r.events.any((e) => e.type == MatchEventType.goal && e.minute < 30) &&
          !r.events.any(
            (e) =>
                e.minute <= 31 &&
                e.teamNationId == preview.homeTeam.nationId &&
                (e.type == MatchEventType.injury ||
                    e.type == MatchEventType.redCard),
          ),
    );
    await _pump(
      tester,
      preview: preview,
      salt: salt,
      prefs: {kMatchViewModePrefsKey: 'pitch'},
    );
    await _until(tester, () => _ready(tester) && _clock(tester).playing);
    final old = _pb(tester);
    await _seek(tester, old.pacer.screenAt(30, 0, within: 0.5));
    await tester.pump(const Duration(seconds: 3)); // any goal flash clears
    final clockBefore = _clock(tester).value;
    final posBefore = old.positionAt(clockBefore);
    final seen = _seen(tester);
    expect(seen.home + seen.away, greaterThan(0));

    // The manager takes his number 10 off for the first man on the bench.
    final off = preview.homeTeam.xi[10];
    final on = preview.bench.first;
    await tester.tap(find.byType(MatchTacticsPillContent));
    await tester.pumpAndSettle();
    final offLabel = off.name.split(' ').last.toUpperCase();
    await tester.tap(
      find
          .byWidgetPredicate(
            (w) => w is Text && w.data?.replaceAll('​', '') == offLabel,
          )
          .last,
    );
    await tester.pumpAndSettle();
    final onRow = find.text(on.name).last;
    await tester.ensureVisible(onRow);
    await tester.pumpAndSettle();
    await tester.tap(onRow);
    await tester.pumpAndSettle();
    await tester.tap(find.text(enL.tacticsApply));
    await tester.pump();
    await _until(tester, () => !_screen(tester).pitchMode.building);

    // A new picture, of the re-simulated match, picked up where the old one
    // stood: the same minute, never back, the score untouched.
    final pb = _pb(tester);
    expect(identical(pb, old), isFalse);
    expect(identical(pb.result, _result(tester)), isTrue);
    expect(pb.script.start, greaterThan(0));
    final clockAfter = _clock(tester).value;
    expect(clockAfter, pb.start);
    final posAfter = pb.positionAt(clockAfter);
    expect(posAfter, posBefore);
    final now = _seen(tester);
    expect((now.clock, now.home, now.away), (seen.clock, seen.home, seen.away));
    expect(now.events, seen.events);
    // The new XI is the one on the pitch from the next minute.
    final later = [
      for (final a in pb.script.actors(posBefore.minute + 2)) a.playerId,
    ];
    expect(later, contains(on.id));
    expect(later, isNot(contains(off.id)));
    final earlier = [
      for (final a in old.script.actors(posBefore.minute + 2)) a.playerId,
    ];
    expect(earlier, contains(off.id));

    // And play goes on from there.
    await _until(tester, () => _clock(tester).playing);
    // The ticker's first frame starts it; the next ones move it.
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(seconds: 1));
    expect(_clock(tester).value, greaterThan(clockAfter));
  });

  testWidgets('goal flash and injury pause still fire in Pitch mode', (
    tester,
  ) async {
    final preview = _preview();
    final home = preview.homeTeam.nationId;
    final salt = _salt(preview, (r) {
      final goal = r.events.indexWhere((e) => e.type == MatchEventType.goal);
      final injury = r.events.indexWhere(
        (e) => e.type == MatchEventType.injury && e.teamNationId == home,
      );
      return goal >= 0 &&
          injury >= 0 &&
          r.events[goal].minute < r.events[injury].minute &&
          r.events[injury].minute < 89;
    });
    await _pump(
      tester,
      preview: preview,
      salt: salt,
      prefs: {kMatchViewModePrefsKey: 'pitch'},
    );
    await _until(tester, () => _ready(tester) && _clock(tester).playing);
    final r = _result(tester);
    final pb = _pb(tester);

    // The goal: flashed as the ball goes in, the clock held under it, then
    // on again.
    final gi = r.events.indexWhere((e) => e.type == MatchEventType.goal);
    final goal = r.events[gi];
    await _seek(tester, _secs(pb.revealAt(gi) - 0.2));
    await _until(
      tester,
      () => find.text(enL.matchGoalShout).evaluate().isNotEmpty,
    );
    final clock = _clock(tester);
    expect(clock.playing, isFalse);
    expect(clock.value.inMicroseconds / 1e6, closeTo(pb.revealAt(gi), 0.05));
    expect(
      _seen(tester).events,
      contains(
        'goal ${goal.minute}+${goal.stoppage} ${goal.playerId}',
      ),
    );
    final held = clock.value;
    await tester.pump(const Duration(seconds: 1));
    expect(clock.value, held, reason: 'no play under the flash');
    await _until(
      tester,
      () => find.text(enL.matchGoalShout).evaluate().isEmpty && clock.playing,
    );

    // The injury: play stops and the squad opens, with the minute on the
    // clock; closing it plays on.
    final ii = r.events.indexWhere(
      (e) => e.type == MatchEventType.injury && e.teamNationId == home,
    );
    final injury = r.events[ii];
    await _seek(tester, _secs(pb.revealAt(ii) - 0.2));
    await _until(
      tester,
      () => find.text(enL.tacticsApply).evaluate().isNotEmpty,
    );
    expect(clock.playing, isFalse);
    expect(_seen(tester).clock, '${injury.minute}');
    await tester.pumpAndSettle();
    await tester.tap(find.text(enL.tacticsApply));
    await tester.pump();
    await tester.pump();
    await _until(tester, () => _clock(tester).playing);
  });

  testWidgets('a user pause survives the ground being baked again', (
    tester,
  ) async {
    await _pump(
      tester,
      preview: _preview(),
      salt: 7,
      prefs: {kMatchViewModePrefsKey: 'pitch'},
    );
    await _until(tester, () => _ready(tester) && _clock(tester).playing);
    await tester.tap(find.byIcon(Icons.pause_rounded).first);
    await tester.pump();
    expect(_clock(tester).playing, isFalse);
    // Another size: the view bakes again and says it is ready again.
    tester.view.physicalSize = const Size(360, 2000);
    await tester.pump();
    await _until(tester, () => _ready(tester));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(_clock(tester).playing, isFalse, reason: 'his pause, not ours');
  });

  // --- Fix round 1 ------------------------------------------------------------

  testWidgets('a switch to the Timeline in minute 45 stops for half time '
      'before anything of the second half', (tester) async {
    final preview = _preview();
    final salt = _salt(
      preview,
      (r) =>
          !r.events.any((e) => e.minute >= 44 && e.minute <= 47) &&
          r.events.any((e) => e.type == MatchEventType.goal && e.minute < 44),
    );
    await _pump(
      tester,
      preview: preview,
      salt: salt,
      prefs: {kMatchViewModePrefsKey: 'pitch'},
    );
    await _until(tester, () => _ready(tester) && _clock(tester).playing);
    await _seek(tester, _pb(tester).pacer.screenAt(45, 0, within: 0.5));
    await tester.pump(const Duration(seconds: 3)); // any flash clears
    final before = _seen(tester);
    expect(before.clock, '45');
    await _switch(tester);
    // Minute 45 is over as the Pitch view hands it over: the whistle, not
    // a 46th minute first.
    expect(find.byType(HalfTimePrompt), findsOneWidget);
    expect(_seen(tester), before);
    await tester.pump(const Duration(seconds: 2));
    expect(_seen(tester), before);
    // The talk lands at 46: nothing watched is played again.
    final shown = _screen(tester).shownEvents;
    final tone = tester
        .widget<HalfTimePrompt>(find.byType(HalfTimePrompt))
        .options
        .first;
    await tester.tap(find.text(teamTalkLabel(enL, tone)).first);
    await tester.pump();
    final after = _screen(tester).shownEvents;
    expect(
      [for (final e in after) '${e.type.name} ${e.minute} ${e.playerId}'],
      [for (final e in shown) '${e.type.name} ${e.minute} ${e.playerId}'],
    );
    expect(_seen(tester).clock, '45');
  });

  testWidgets('a switch to the Timeline in the last minute blows the whistle '
      'and the shootout starts', (tester) async {
    final preview = _preview(round: 'SF');
    final salt = _salt(preview, (r) {
      final et = r.extraTime;
      return et != null &&
          et.homeScore == et.awayScore &&
          !r.events.any((e) => e.minute >= 119);
    });
    await _pump(
      tester,
      preview: preview,
      salt: salt,
      prefs: {kMatchViewModePrefsKey: 'pitch'},
    );
    await _until(tester, () => _ready(tester) && _clock(tester).playing);
    final pb = _pb(tester);
    Future<void> through(Duration whistle, String heading) async {
      await _seek(tester, whistle - const Duration(milliseconds: 100));
      await _until(
        tester,
        () => find.text(heading).evaluate().isNotEmpty,
      );
      await tester.tap(find.text(enL.matchContinue).last);
      await tester.pump();
      await _until(tester, () => _clock(tester).playing);
    }

    await through(pb.halfTime, enL.matchHalfTime);
    await through(pb.extraTimeStart!, enL.matchExtraTimeAhead);
    await through(pb.extraTimeHalf!, enL.matchExtraTimeHalf);
    await _seek(tester, pb.pacer.screenAt(120, 0, within: 0.5));
    expect(_seen(tester).clock, 'ET 120');
    await _switch(tester);
    // Full time as the minute is handed over: the takers are asked for.
    await _until(
      tester,
      () => find.byType(PenaltyOrderSheet).evaluate().isNotEmpty,
    );
  });

  testWidgets('a switch to the Timeline under a goal flash does not tick on '
      'under it', (tester) async {
    final preview = _preview();
    final salt = _salt(
      preview,
      (r) =>
          r.events.any((e) => e.type == MatchEventType.goal && e.minute < 40),
    );
    await _pump(
      tester,
      preview: preview,
      salt: salt,
      prefs: {kMatchViewModePrefsKey: 'pitch'},
    );
    await _until(tester, () => _ready(tester) && _clock(tester).playing);
    final r = _result(tester);
    final gi = r.events.indexWhere((e) => e.type == MatchEventType.goal);
    await _seek(tester, _secs(_pb(tester).revealAt(gi) - 0.2));
    await _until(
      tester,
      () => find.text(enL.matchGoalShout).evaluate().isNotEmpty,
    );
    final at = _seen(tester).clock;
    await _switch(tester);
    await tester.pump(const Duration(milliseconds: 1500));
    expect(find.text(enL.matchGoalShout), findsOneWidget);
    expect(_seen(tester).clock, at, reason: 'no minute under the flash');
    await tester.pump(const Duration(seconds: 2));
    expect(find.text(enL.matchGoalShout), findsNothing);
  });

  testWidgets('back on the pitch with a goal still to come, it is played '
      'out, not jumped past', (tester) async {
    final preview = _preview();
    final salt = _salt(
      preview,
      (r) =>
          r.events.any((e) => e.type == MatchEventType.goal && e.minute < 40),
    );
    await _pump(
      tester,
      preview: preview,
      salt: salt,
      prefs: {kMatchViewModePrefsKey: 'pitch'},
    );
    await _until(tester, () => _ready(tester) && _clock(tester).playing);
    final r = _result(tester);
    final gi = r.events.indexWhere((e) => e.type == MatchEventType.goal);
    final goal = r.events[gi];
    final reveal = _pb(tester).revealAt(gi);
    await _seek(tester, _secs(reveal - 0.4));
    await tester.tap(find.byIcon(Icons.pause_rounded).first);
    await tester.pump();
    final held = _clock(tester).value;
    await _switch(tester);
    await _switch(tester);
    expect(_clock(tester).value, held);
    expect(find.text(enL.matchGoalShout), findsNothing);
    expect(
      _seen(tester).events,
      isNot(contains('goal ${goal.minute}+0 ${goal.playerId}')),
    );
    await tester.tap(find.byIcon(Icons.play_arrow_rounded).first);
    await tester.pump();
    await _until(tester, () => _ready(tester));
    await _until(
      tester,
      () => find.text(enL.matchGoalShout).evaluate().isNotEmpty,
    );
    expect(
      _clock(tester).value.inMicroseconds / 1e6,
      closeTo(reveal, 0.02),
    );
  });

  testWidgets('a long frame still stops on the goal, not past it', (
    tester,
  ) async {
    final preview = _preview();
    final salt = _salt(
      preview,
      (r) =>
          r.events.any((e) => e.type == MatchEventType.goal && e.minute < 40),
    );
    await _pump(
      tester,
      preview: preview,
      salt: salt,
      prefs: {kMatchViewModePrefsKey: 'pitch'},
    );
    await _until(tester, () => _ready(tester) && _clock(tester).playing);
    final r = _result(tester);
    final gi = r.events.indexWhere((e) => e.type == MatchEventType.goal);
    final reveal = _pb(tester).revealAt(gi);
    await _seek(tester, _secs(reveal - 0.3));
    await tester.pump(const Duration(milliseconds: 16));
    // A janky frame: 900 ms in one go, across the goal.
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.text(enL.matchGoalShout), findsOneWidget);
    expect(
      _clock(tester).value.inMicroseconds / 1e6,
      closeTo(reveal, 0.001),
    );
  });

  testWidgets('the weather is cosmetic: the match plays the same in any '
      'weather', (tester) async {
    final preview = _preview();
    String? first;
    for (final w in WeatherKind.values) {
      // A fresh screen each time, so it reads its weather anew.
      await tester.pumpWidget(const SizedBox.shrink());
      await _pump(
        tester,
        preview: preview,
        salt: 7,
        prefs: {kMatchViewModePrefsKey: 'pitch'},
        weather: w,
      );
      await _until(tester, () => _ready(tester) && _clock(tester).playing);
      expect(_screen(tester).pitchMode.stadium!.weather, w);
      final r = _result(tester);
      final pb = _pb(tester);
      await _seek(tester, pb.pacer.total * 0.6);
      final seen = _seen(tester);
      final fingerprint = [
        '${r.homeScore}:${r.awayScore}',
        '${r.homeShots}/${r.awayShots} ${r.homePossession}',
        for (final e in r.events)
          '${e.type.name} ${e.minute}+${e.stoppage} ${e.playerId}',
        'moments ${r.moments.length}',
        'screen ${pb.pacer.total.inMilliseconds}',
        'seen ${seen.clock} ${seen.home}-${seen.away} ${seen.events}',
      ].join('\n');
      first ??= fingerprint;
      expect(fingerprint, first, reason: w.name);
    }
  });
}
