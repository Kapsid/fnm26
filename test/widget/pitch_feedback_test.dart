import 'dart:isolate';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/pitch/moment_staging.dart';
import 'package:fnm/domain/services/match/pitch/referee_card.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';
import 'package:fnm/features/match/match_feedback.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/penalty_order_sheet.dart';
import 'package:fnm/features/match/pitch/pitch_clock.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_mode_controller.dart';
import 'package:fnm/features/match/pitch/pitch_playback.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/features/match/pitch/referee_painter.dart';
import 'package:fnm/features/match/pitch/shootout_stage.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/primary_button.dart';
import 'package:fnm/shared/widgets/whole_text.dart' show initialledName;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fixtures.dart';
import '../helpers/pitch_view_fixture.dart' show pitchNation;
import '../helpers/seeded_save.dart' show enL;

/// What the 2D TV makes the phone do: a goal buzzes (as on the Timeline),
/// and a red card is a moment of its own (the referee and his card, a
/// banner under the score, a light buzz), with play going on under it.

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
MatchPreview _preview({String? round = 'FRIENDLY', int saveSeed = 42}) {
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

int _salt(MatchPreview p, bool Function(MatchResult r) wanted, {int from = 1}) {
  for (var salt = from; salt < 4000; salt++) {
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
  Size size = const Size(400, 2000),
  FormFactor? formFactor,
  bool haptics = true,
}) async {
  if (resetPrefs) SharedPreferences.setMockInitialValues(prefs);
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final c = ProviderContainer(
    overrides: [
      matchPreviewProvider(1).overrideWith((ref) async => preview),
      soundHapticsEnabledProvider.overrideWith((ref) => haptics),
      matchAttemptSaltProvider.overrideWithValue(() => salt),
      pitchStadiumBakerProvider.overrideWithValue(_InstantBaker(_image)),
      // Built in place: the isolate build is checked on its own
      // (script_build_cost_test); here it would need real time.
      pitchPlaybackBuilderProvider.overrideWithValue(
        builder ?? (b) async => b.run(),
      ),
      if (weather != null)
        pitchForcedWeatherProvider.overrideWithValue(weather),
      if (formFactor != null) formFactorProvider.overrideWithValue(formFactor),
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

/// Every haptic and system sound the screen asks the platform for.
final List<String> _feedback = [];

const String _heavy = 'HapticFeedback.vibrate HapticFeedbackType.heavyImpact';
const String _medium = 'HapticFeedback.vibrate HapticFeedbackType.mediumImpact';

/// `HapticFeedback.vibrate()`: on iOS the audio services' vibrate.
const String _buzz = 'HapticFeedback.vibrate null';

int _count(String kind) => _feedback.where((f) => f == kind).length;

const String _light = 'HapticFeedback.vibrate HapticFeedbackType.lightImpact';

/// Every cue [MatchFeedback] gave, by name.
final List<String> _cues = [];

/// A goal's tone (desktop only, but asked for on every platform).
const String _alert = 'SystemSound.play SystemSoundType.alert';

/// [goals] goals, felt: each one the heavy haptic tap and the long
/// `vibrate` buzz, with the goal tone right after them (the picture no
/// longer blinks, so the hand has to feel it).
Future<void> _expectGoalFelt(WidgetTester tester, int goals) async {
  // Nothing more is to come later: no delayed second tap.
  await tester.pump(const Duration(milliseconds: 200));
  expect(_count(_alert), goals, reason: 'one tone per goal');
  for (var i = 0; i < _feedback.length; i++) {
    if (_feedback[i] != _alert) continue;
    expect(i, greaterThan(0));
    expect(i, greaterThan(1));
    expect(_feedback[i - 2], _heavy, reason: 'a heavy tap first');
    expect(_feedback[i - 1], _buzz, reason: 'then the long buzz');
  }
  expect(_count(_heavy), goals, reason: 'one heavy tap per goal');
  expect(_count(_buzz), goals, reason: 'one buzz per goal');
}

bool _shout(WidgetTester tester) =>
    find.text(enL.matchGoalShout).evaluate().isNotEmpty;

/// The salt for a match whose first goal is in a minute [minutes] likes.
int _goalSalt(MatchPreview p, bool Function(int minute) minutes) =>
    _salt(p, (r) {
      final g = r.events.where((e) => e.type == MatchEventType.goal);
      return g.isNotEmpty && minutes(g.first.minute);
    });

/// A level semi-final that goes to penalties: from salt 300 on, the first
/// is one with a kick saved before the end (the sheet's own takers).
int _shootoutSalt(MatchPreview p, {int from = 300}) => _salt(p, (r) {
  final et = r.extraTime;
  return et != null &&
      et.homeScore == et.awayScore &&
      !r.events.any((e) => e.minute >= 119);
}, from: from);

/// The shootout strip's outcome and how many kicks it shows.
({KnockoutOutcome outcome, int revealed}) _strip(WidgetTester tester) {
  final w =
      tester.widget(
            find.byWidgetPredicate(
              (w) => w.runtimeType.toString() == '_ShootoutStrip',
            ),
          )
          as dynamic;
  return (outcome: w.outcome as KnockoutOutcome, revealed: w.revealed as int);
}

ShootoutStageController? _stage(WidgetTester tester) =>
    tester.widget<PitchMatchView>(find.byType(PitchMatchView)).shootout;

/// What each of [kicks] should be felt as: a scored kick a heavy tap, a
/// missed one a light tick, the last (the one that decides it) a goal's.
List<String> _shootoutCues(List<StagedShootoutKick> kicks) => [
  for (final (i, k) in kicks.indexed)
    if (i == kicks.length - 1)
      'shootoutWinner'
    else if (k.kick.result == KickResult.scored)
      'shootoutGoal'
    else
      'shootoutMiss',
];

/// The shootout cues given so far, in order.
List<String> get _kickCues => [
  for (final c in _cues)
    if (c.startsWith('shootout')) c,
];

/// Names the sheet's own takers.
Future<void> _takeThem(WidgetTester tester) async {
  // The sheet slides up first.
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(
    find.descendant(
      of: find.byType(PenaltyOrderSheet),
      matching: find.byType(PrimaryButton),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

/// On the 2D TV, plays a level semi-final through its intervals to the
/// taker sheet (the shootout's kicks still to come).
Future<void> _pitchToSheet(WidgetTester tester, {bool haptics = true}) async {
  final preview = _preview(round: 'SF');
  await _pump(
    tester,
    preview: preview,
    salt: _shootoutSalt(preview),
    prefs: {kMatchViewModePrefsKey: 'pitch'},
    haptics: haptics,
  );
  await _until(tester, () => _ready(tester) && _clock(tester).playing);
  final pb = _pb(tester);
  Future<void> through(Duration whistle, String heading) async {
    await _seek(tester, whistle - const Duration(milliseconds: 100));
    await _until(tester, () => find.text(heading).evaluate().isNotEmpty);
    await tester.tap(find.text(enL.matchContinue).last);
    await tester.pump();
    await _until(tester, () => _clock(tester).playing);
  }

  await through(pb.halfTime, enL.matchHalfTime);
  await through(pb.extraTimeStart!, enL.matchExtraTimeAhead);
  await through(pb.extraTimeHalf!, enL.matchExtraTimeHalf);
  await _seek(tester, pb.pacer.screenAt(120, 0, within: 0.5));
  await _until(
    tester,
    () => find.byType(PenaltyOrderSheet).evaluate().isNotEmpty,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    _image = await createTestImage(width: 4, height: 4);
  });

  setUp(() {
    _feedback.clear();
    _cues.clear();
    MatchFeedback.debugOnCue = _cues.add;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'HapticFeedback.vibrate' ||
              call.method == 'SystemSound.play') {
            _feedback.add('${call.method} ${call.arguments}');
          }
          return null;
        });
  });

  tearDown(() {
    MatchFeedback.debugOnCue = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  group('the goal buzz', () {
    testWidgets('Timeline: a goal buzzes as it flashes (unchanged)', (
      tester,
    ) async {
      final preview = _preview();
      final salt = _goalSalt(preview, (m) => m < 15);
      await _pump(
        tester,
        preview: preview,
        salt: salt,
        prefs: {kMatchViewModePrefsKey: 'timeline'},
      );
      await _until(tester, () => _shout(tester));
      await _expectGoalFelt(tester, 1);
    });

    testWidgets('2D TV: a goal buzzes as it goes in, once', (tester) async {
      final preview = _preview();
      final salt = _goalSalt(preview, (m) => m < 40);
      await _pump(
        tester,
        preview: preview,
        salt: salt,
        prefs: {kMatchViewModePrefsKey: 'pitch'},
      );
      await _until(tester, () => _ready(tester) && _clock(tester).playing);
      final r = _result(tester);
      final gi = r.events.indexWhere((e) => e.type == MatchEventType.goal);
      expect(
        _count(_buzz) + _count(_heavy) + _count(_alert),
        0,
        reason: 'no goal yet',
      );
      await _seek(tester, _secs(_pb(tester).revealAt(gi) - 0.3));
      await _until(tester, () => _shout(tester));
      await tester.pump(const Duration(milliseconds: 1));
      await _expectGoalFelt(tester, 1);
      // Held under the flash: no second buzz for the same goal.
      await tester.pump(const Duration(seconds: 1));
      expect((_count(_buzz), _count(_heavy), _count(_alert)), (1, 1, 1));
    });

    testWidgets('2D TV: played from kick-off at match pace, the first goal '
        'buzzes', (tester) async {
      final preview = _preview();
      final salt = _goalSalt(preview, (m) => m < 12);
      await _pump(
        tester,
        preview: preview,
        salt: salt,
        prefs: {kMatchViewModePrefsKey: 'pitch'},
      );
      await _until(tester, () => _ready(tester) && _clock(tester).playing);
      for (var i = 0; i < 20000 && !_shout(tester); i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(_shout(tester), isTrue);
      await tester.pump(const Duration(milliseconds: 1));
      await _expectGoalFelt(tester, 1);
    });

    testWidgets('2D TV built off the UI thread (as on a phone): the goal '
        'buzzes', (tester) async {
      final preview = _preview();
      final salt = _goalSalt(preview, (m) => m < 40);
      await _pump(
        tester,
        preview: preview,
        salt: salt,
        prefs: {kMatchViewModePrefsKey: 'pitch'},
        builder: (b) => Isolate.run(b.run),
      );
      for (
        var i = 0;
        i < 200 && !(_ready(tester) && _clock(tester).playing);
        i++
      ) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(_clock(tester).playing, isTrue);
      final r = _result(tester);
      final gi = r.events.indexWhere((e) => e.type == MatchEventType.goal);
      await _seek(tester, _secs(_pb(tester).revealAt(gi) - 0.3));
      await _until(tester, () => _shout(tester));
      await tester.pump(const Duration(milliseconds: 1));
      await _expectGoalFelt(tester, 1);
    });

    testWidgets('2D TV: the half-time whistle does not buzz like a goal', (
      tester,
    ) async {
      final preview = _preview();
      final salt = _salt(
        preview,
        (r) => !r.events.any(
          (e) => e.type == MatchEventType.goal && e.minute < 50,
        ),
      );
      await _pump(
        tester,
        preview: preview,
        salt: salt,
        prefs: {kMatchViewModePrefsKey: 'pitch'},
      );
      await _until(tester, () => _ready(tester) && _clock(tester).playing);
      final pb = _pb(tester);
      await _seek(tester, _secs(pb.halfTime.inMicroseconds / 1e6 - 0.5));
      await _until(tester, () => !_clock(tester).playing);
      await tester.pump(const Duration(seconds: 2));
      expect(_count(_buzz) + _count(_heavy) + _count(_alert), 0);
    });
  });

  group('the shootout', () {
    testWidgets('2D TV: each kick is felt once as its result lands, a goal '
        'heavy, a miss light, the deciding kick as a goal', (tester) async {
      await _pitchToSheet(tester);
      _feedback.clear();
      _cues.clear();
      await _takeThem(tester);
      await _until(tester, () => _stage(tester)?.running ?? false);
      final stage = _stage(tester)!;
      final kicks = stage.kicks;
      // Nothing before the first ball arrives.
      await tester.pump(const Duration(milliseconds: 2500));
      expect(_kickCues, isEmpty);
      await tester.pump(const Duration(milliseconds: 700));
      expect(_kickCues, _shootoutCues(kicks).take(1));
      for (var i = 0; i < 4000 && stage.running; i++) {
        await tester.pump(const Duration(milliseconds: 16));
        // Never ahead of the tally, never behind it.
        expect(_kickCues, hasLength(_strip(tester).revealed));
      }
      await tester.pump(const Duration(seconds: 1));
      final cues = _shootoutCues(kicks);
      expect(cues, contains('shootoutMiss'), reason: 'a miss to feel');
      expect(_kickCues, cues);
      // On the platform: one heavy tap per goal and for the winner, one
      // light tick per miss, and the long buzz and the tone for the
      // winner alone.
      expect(_count(_heavy), cues.where((c) => c != 'shootoutMiss').length);
      expect(_count(_light), cues.where((c) => c == 'shootoutMiss').length);
      expect((_count(_buzz), _count(_alert)), (1, 1));
    });

    testWidgets('a switch to the Timeline and back mid-shootout feels no '
        'kick twice and skips none', (tester) async {
      await _pitchToSheet(tester);
      await _takeThem(tester);
      await _until(tester, () => _stage(tester)?.running ?? false);
      final stage = _stage(tester)!;
      final kicks = stage.kicks;
      await _until(tester, () => _strip(tester).revealed >= 2);
      _screen(tester).switchMode();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      expect(_strip(tester).revealed, greaterThanOrEqualTo(3));
      expect(_kickCues, hasLength(_strip(tester).revealed));
      _screen(tester).switchMode();
      await tester.pump();
      await _until(tester, () => _ready(tester) && stage.running);
      // The kick restaged from its start is the next one, not the last.
      await tester.pump(const Duration(milliseconds: 1000));
      expect(_kickCues, hasLength(_strip(tester).revealed));
      await _until(
        tester,
        () => _strip(tester).revealed == kicks.length && !stage.running,
      );
      await tester.pump(const Duration(seconds: 1));
      expect(_kickCues, _shootoutCues(kicks));
    });

    testWidgets('Timeline: each kick the strip reveals is felt once', (
      tester,
    ) async {
      final preview = _preview(round: 'SF');
      await _pump(
        tester,
        preview: preview,
        salt: _shootoutSalt(preview),
        prefs: {kMatchViewModePrefsKey: 'timeline'},
      );
      for (
        var i = 0;
        i < 4000 && find.byType(PenaltyOrderSheet).evaluate().isEmpty;
        i++
      ) {
        await tester.pump(const Duration(milliseconds: 300));
        final prompt = find.byType(HalfTimePrompt);
        if (prompt.evaluate().isNotEmpty) {
          await tester.tap(
            find.descendant(of: prompt, matching: find.text(enL.matchContinue)),
          );
          await tester.pump();
        }
      }
      expect(find.byType(PenaltyOrderSheet), findsOneWidget);
      _feedback.clear();
      _cues.clear();
      await _takeThem(tester);
      final kicks = ShootoutStaging.order(_strip(tester).outcome);
      for (var i = 0; i < 400 && _strip(tester).revealed < kicks.length; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        expect(_kickCues, hasLength(_strip(tester).revealed));
      }
      await tester.pump(const Duration(seconds: 2));
      expect(_kickCues, _shootoutCues(kicks));
      expect((_count(_buzz), _count(_alert)), (1, 1));
    });

    testWidgets('with sound and haptics off, the kicks are not felt', (
      tester,
    ) async {
      await _pitchToSheet(tester, haptics: false);
      await _takeThem(tester);
      await _until(tester, () => _stage(tester)?.running ?? false);
      final stage = _stage(tester)!;
      await _until(tester, () => !stage.running);
      await tester.pump(const Duration(seconds: 1));
      expect(_strip(tester).revealed, stage.kicks.length);
      expect(_cues, isEmpty);
      // (The buttons' own clicks aside.)
      expect(_feedback.where((f) => f.startsWith('HapticFeedback')), isEmpty);
      expect(_count(_alert), 0);
    });
  });

  group('the red card', () {
    /// A match with a sending-off in open play, clear of goals and of
    /// half-time.
    int redSalt(MatchPreview p) => _salt(p, (r) {
      final red = r.events.where((e) => e.type == MatchEventType.redCard);
      if (red.isEmpty) return false;
      final m = red.first.minute;
      if (m < 5 || m > 80 || (m >= 42 && m <= 48)) return false;
      return !r.events.any(
        (e) => e.type == MatchEventType.goal && e.minute <= m + 3,
      );
    });

    testWidgets('2D TV: the referee shows the card, the banner comes down '
        'with the man, the minute and a light buzz, and play goes on', (
      tester,
    ) async {
      final preview = _preview();
      final salt = redSalt(preview);
      await _pump(
        tester,
        preview: preview,
        salt: salt,
        prefs: {kMatchViewModePrefsKey: 'pitch'},
      );
      await _until(tester, () => _ready(tester) && _clock(tester).playing);
      final r = _result(tester);
      final ri = r.events.indexWhere((e) => e.type == MatchEventType.redCard);
      final red = r.events[ri];
      final pb = _pb(tester);
      final referee =
          tester
                  .widget<CustomPaint>(
                    find.byWidgetPredicate(
                      (w) =>
                          w is CustomPaint &&
                          w.foregroundPainter is RefereePainter,
                    ),
                  )
                  .foregroundPainter!
              as RefereePainter;
      expect(referee.shows, isNotEmpty);
      final show = referee.shows.first;
      expect(show.playerId, red.playerId);
      expect(show.cardAt, closeTo(pb.revealAt(ri), 1e-6));

      final banner = find.byKey(matchRedCardBannerKey);
      expect(banner, findsNothing);
      await _seek(tester, _secs(pb.revealAt(ri) - 0.3));
      await _until(tester, () => banner.evaluate().isNotEmpty);
      await tester.pump(const Duration(milliseconds: 1));
      // The banner: the shout, the man, his minute.
      Finder inBanner(String s) =>
          find.descendant(of: banner, matching: find.text(s));
      expect(inBanner(enL.matchRedCardShout), findsOneWidget);
      expect(inBanner(initialledName(red.playerName)), findsOneWidget);
      expect(inBanner("${red.minute}'"), findsOneWidget);
      // The referee has the red up.
      final t = _clock(tester).value.inMicroseconds / 1e6;
      expect(referee.frameAt(t + RefereeCardShow.lift)?.card, RefereeCard.red);
      // A light buzz, not a goal's; and the clock never stopped for it.
      expect(_count(_medium), greaterThanOrEqualTo(2), reason: 'kick-off too');
      expect(_count(_buzz) + _count(_heavy) + _count(_alert), 0);
      expect(_clock(tester).playing, isTrue);
      expect(find.text(enL.matchGoalShout), findsNothing);
      // The man is on his way off while the card is still up.
      expect(
        pb.script.departures[red.playerId],
        lessThan(show.cardAt + RefereeCardShow.hold),
      );
      // Gone again once its time is up.
      await tester.pump(kRedCardBannerHold);
      await tester.pump(const Duration(milliseconds: 100));
      expect(banner, findsNothing);
    });

    testWidgets("Timeline: no red card banner, it is the 2D TV's own", (
      tester,
    ) async {
      final preview = _preview();
      final salt = redSalt(preview);
      await _pump(
        tester,
        preview: preview,
        salt: salt,
        prefs: {kMatchViewModePrefsKey: 'timeline'},
      );
      final red = _result(
        tester,
      ).events.firstWhere((e) => e.type == MatchEventType.redCard);
      await _until(tester, () => _screen(tester).shownEvents.contains(red));
      expect(find.byKey(matchRedCardBannerKey), findsNothing);
      expect(_count(_medium), 1, reason: 'the kick-off only');
    });
  });
}
