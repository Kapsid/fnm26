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
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
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

/// A penalty in the match on the 2D TV (owner 2026-11: "penalty animation
/// plays twice, the goal pops up after the 2D one only"): the close-up
/// shows the kick once, its goal flashes during it, and the pitch never
/// strikes it again. Harness as in `pitch_feedback_test.dart`.

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
  Size size = const Size(400, 2000),
  FormFactor? formFactor,
}) async {
  if (resetPrefs) SharedPreferences.setMockInitialValues(prefs);
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final c = ProviderContainer(
    overrides: [
      matchPreviewProvider(1).overrideWith((ref) async => preview),
      soundHapticsEnabledProvider.overrideWith((ref) => true),
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

const String _medium = 'HapticFeedback.vibrate HapticFeedbackType.mediumImpact';

int _count(String kind) => _feedback.where((f) => f == kind).length;

bool _shout(WidgetTester tester) =>
    find.text(enL.matchGoalShout).evaluate().isNotEmpty;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    _image = await createTestImage(width: 4, height: 4);
  });

  setUp(() {
    _feedback.clear();
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
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  testWidgets('2D TV: a penalty goal plays once, in the close-up, and the '
      'goal flashes and taps during it', (tester) async {
    final preview = _preview();
    final salt = _salt(preview, (r) {
      for (final m in r.moments) {
        if (m is ShotMoment &&
            m.origin == ShotOrigin.penalty &&
            m.outcome == ShotOutcome.goal &&
            m.minute > 3 &&
            m.minute < 40) {
          return !r.events.any(
            (e) =>
                e.type == MatchEventType.goal &&
                e.minute < m.minute + 2 &&
                e.minute >= m.minute - 2 &&
                e.minute != m.minute,
          );
        }
      }
      return false;
    });
    await _pump(
      tester,
      preview: preview,
      salt: salt,
      prefs: {kMatchViewModePrefsKey: 'pitch'},
    );
    await _until(tester, () => _ready(tester) && _clock(tester).playing);
    final view = tester.state<PitchMatchViewState>(find.byType(PitchMatchView));
    final penalty = view.debugPenalty!;
    final pen = penalty.penalties.first;
    // The kick the close-up shows is the one the pitch strikes.
    final shot = _pb(tester).script.windows
        .expand((w) => w.cues)
        .firstWhere(
          (c) =>
              c.kind == PitchCueKind.shot &&
              c.playerId == pen.kick.kick.takerId &&
              (c.t - pen.strike).abs() < 2,
        );
    expect(pen.strike, closeTo(shot.t, 1e-6));
    await _seek(tester, _secs(pen.from - 2));
    var closeUps = 0;
    var wasUp = false;
    var shoutInCloseUp = false;
    var shoutOnPitch = false;
    var tapsInCloseUp = 0;
    var wasShout = false;
    var t = 0.0;
    for (var i = 0; i < 1200 && t < pen.to + 4; i++) {
      await tester.pump(const Duration(milliseconds: 16));
      t = _clock(tester).value.inMicroseconds / 1e6;
      final up = penalty.active.value;
      if (up && !wasUp) closeUps++;
      wasUp = up;
      final shout = _shout(tester);
      if (shout && !wasShout) {
        if (up) {
          shoutInCloseUp = true;
          tapsInCloseUp = _count(_medium);
        } else {
          shoutOnPitch = true;
        }
      }
      wasShout = shout;
    }
    expect(t, greaterThan(pen.to + 1), reason: 'played past the kick');
    expect(closeUps, 1, reason: 'the close-up shows once');
    expect(shoutInCloseUp, isTrue, reason: 'the goal flashes in the close-up');
    expect(shoutOnPitch, isFalse, reason: 'no second goal on the pitch');
    expect(tapsInCloseUp, greaterThanOrEqualTo(2), reason: 'kick-off + goal');
    expect(_count('SystemSound.play SystemSoundType.alert'), 1);
  });
}
