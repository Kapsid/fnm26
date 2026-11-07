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
import 'package:fnm/features/match/pitch/shootout_stage.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/match/pitch/moment_staging.dart';
import 'package:fnm/shared/widgets/widgets.dart';
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

/// Pumps frames until [done] or a minute of fake time has gone.
Future<void> _until(WidgetTester tester, bool Function() done) async {
  for (var i = 0; i < 3600 && !done(); i++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
  expect(done(), isTrue, reason: 'never got there');
}

/// Moves the Pitch clock to screen time [t] and lets the screen catch up.
Future<void> _seek(WidgetTester tester, Duration t) async {
  _screen(tester).seekPitch(t);
  await tester.pump();
}

bool _ready(WidgetTester tester) {
  final v = find.byType(PitchMatchView);
  if (v.evaluate().isEmpty) return false;
  return tester.state<PitchMatchViewState>(v).ready.value;
}

/// The shootout strip's reveal count and the goals it shows, read off the
/// live widget (the strip is private to the screen).
({int revealed, int home, int away}) _strip(WidgetTester tester) {
  final w =
      tester.widget(
            find.byWidgetPredicate(
              (w) => w.runtimeType.toString() == '_ShootoutStrip',
            ),
          )
          as dynamic;
  final o = w.outcome as KnockoutOutcome;
  final revealed = w.revealed as int;
  final homeShown = ((revealed + 1) ~/ 2).clamp(0, o.homeKicks.length);
  final awayShown = (revealed ~/ 2).clamp(0, o.awayKicks.length);
  return (
    revealed: revealed,
    home: o.homeKicks.take(homeShown).where((s) => s).length,
    away: o.awayKicks.take(awayShown).where((s) => s).length,
  );
}

ShootoutStageController? _stage(WidgetTester tester) =>
    tester.widget<PitchMatchView>(find.byType(PitchMatchView)).shootout;

/// Plays to the final whistle of a level semi-final, names no takers (the
/// sheet's own order) and returns once the first kick is on the pitch.
Future<void> _toShootout(WidgetTester tester) async {
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
  // The pitch has not gone to the kicks while the manager is choosing.
  await tester.pump(const Duration(seconds: 1));
  expect(_strip(tester).revealed, 0);
  expect(_stage(tester), isNull);
  await tester.tap(
    find.descendant(
      of: find.byType(PenaltyOrderSheet),
      matching: find.byType(PrimaryButton),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await _until(tester, () => _stage(tester)?.running ?? false);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    _image = await createTestImage(width: 4, height: 4);
  });

  testWidgets('the shootout is staged kick by kick, four seconds each, and the '
      'strip moves with each result', (tester) async {
    await _toShootout(tester);
    final stage = _stage(tester)!;
    final o =
        (tester.widget(
                      find.byWidgetPredicate(
                        (w) => w.runtimeType.toString() == '_ShootoutStrip',
                      ),
                    )
                    as dynamic)
                .outcome
            as KnockoutOutcome;
    expect(stage.active.value, isTrue);
    expect(stage.kicks, hasLength(o.homeKicks.length + o.awayKicks.length));
    expect(stage.index, 0);
    expect(_strip(tester).revealed, 0);

    // Before its result lands a kick has not moved the tally.
    await tester.pump(const Duration(milliseconds: 2500));
    expect(stage.index, 0);
    expect(_strip(tester).revealed, 0);
    await tester.pump(const Duration(milliseconds: 700));
    expect(_strip(tester).revealed, 1, reason: 'the result of kick one');
    expect(stage.index, 0, reason: 'still on the first kick');
    // Four seconds after the first kick began, the second is up.
    await tester.pump(const Duration(milliseconds: 1000));
    expect(stage.index, 1);

    // Right through: each result lands exactly once and the tally the strip
    // shows is the staging's own.
    var last = 1;
    for (var i = 0; i < 4000 && stage.running; i++) {
      await tester.pump(const Duration(milliseconds: 16));
      final s = _strip(tester);
      expect(s.revealed, anyOf(last, last + 1));
      last = s.revealed;
      expect(
        (s.home, s.away),
        ShootoutStaging.tally(stage.kicks, s.revealed),
      );
    }
    expect(last, stage.kicks.length);
    expect(
      ShootoutStaging.tally(stage.kicks, last),
      (o.homePens, o.awayPens),
    );
  });

  testWidgets('the taker on show is the one the outcome names', (tester) async {
    await _toShootout(tester);
    final stage = _stage(tester)!;
    for (var k = 0; k < 3; k++) {
      await _until(tester, () => stage.index == k);
      final taker = stage.kicks[k].kick.takerId;
      expect(taker, isNonZero);
      await tester.pump(const Duration(milliseconds: 100));
      final name = _screen(tester).pitchMode.names[taker];
      expect(name, isNotNull);
    }
  });

  testWidgets('switching to the Timeline mid-shootout carries on with the '
      'same tally, and back again', (tester) async {
    await _toShootout(tester);
    final stage = _stage(tester)!;
    await _until(tester, () => _strip(tester).revealed >= 2);
    final at = _strip(tester);
    _screen(tester).switchMode();
    await tester.pump();
    await tester.pump();
    expect(find.byType(PitchMatchView), findsNothing);
    expect(stage.running, isFalse);
    expect(_strip(tester), at);
    // The strip's own 750 ms reveal takes over.
    await tester.pump(const Duration(milliseconds: 800));
    expect(_strip(tester).revealed, at.revealed + 1);
    // Back on the pitch, the next kick is staged from its start.
    _screen(tester).switchMode();
    await tester.pump();
    await _until(tester, () => _ready(tester) && stage.running);
    final back = _strip(tester);
    expect(stage.index, back.revealed);
    // And on to the end, the same shootout.
    await _until(
      tester,
      () => _strip(tester).revealed == stage.kicks.length && !stage.running,
    );
    final o =
        (tester.widget(
                      find.byWidgetPredicate(
                        (w) => w.runtimeType.toString() == '_ShootoutStrip',
                      ),
                    )
                    as dynamic)
                .outcome
            as KnockoutOutcome;
    final end = _strip(tester);
    expect((end.home, end.away), (o.homePens, o.awayPens));
  });
}
