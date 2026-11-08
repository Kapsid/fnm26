import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/moment_staging.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/penalty_order_sheet.dart';
import 'package:fnm/features/match/pitch/pitch_clock.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_mode_controller.dart';
import 'package:fnm/features/match/pitch/pitch_playback.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/seeded_save.dart';

/// The Pitch view, end to end, in a seeded career: a semi-final that is
/// level after 120 minutes is watched in Pitch mode at the fast speed,
/// through half-time, extra time and the shootout, to Continue; what the
/// screen showed is what the picture staged and what the save recorded.

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

/// The 3x step plays the fast pacing (`PitchPacer.fastBand`, read through
/// `pitchSpeedForStep`) at its own clock rate; the moments alone may
/// overrun the band by at most 15% (a test-side cap, as in
/// pitch_pacer_test).
const double _overrun = 1.15;
const int _fastStep = 2;

MatchPreview _asSemiFinal(MatchPreview p) => MatchPreview(
  fixture: p.fixture.copyWith(round: 'SF'),
  result: p.result,
  nations: p.nations,
  homeTeam: p.homeTeam,
  awayTeam: p.awayTeam,
  playerNationId: p.playerNationId,
  bench: p.bench,
  saveSeed: p.saveSeed,
  opponentBench: p.opponentBench,
  opponentSubs: p.opponentSubs,
  injuryFactorByNation: p.injuryFactorByNation,
  chemistryByNation: p.chemistryByNation,
  neutralVenue: p.neutralVenue,
  venueHostId: p.venueHostId,
  bigMatch: true,
  ground: p.ground,
  homeFans: p.homeFans,
);

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

/// A level semi-final with goals in it (so there is something to stage) and
/// nothing in the last minutes (the shootout follows the whistle cleanly).
int _salt(MatchPreview p) {
  for (var salt = 1; salt < 6000; salt++) {
    final r = _liveResim(p, salt);
    final et = r.extraTime;
    if (et != null &&
        et.homeScore == et.awayScore &&
        et.homeScore >= 1 &&
        !r.events.any((e) => e.minute >= 119)) {
      return salt;
    }
  }
  throw StateError('no salt found');
}

MatchScreenProbe _screen(WidgetTester tester) =>
    tester.state(find.byType(MatchScreen)) as MatchScreenProbe;
PitchClock _clock(WidgetTester tester) => _screen(tester).pitchMode.clock!;
PitchPlayback _pb(WidgetTester tester) => _screen(tester).pitchMode.playback!;

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

KnockoutOutcome _outcome(WidgetTester tester) =>
    (tester.widget(
                  find.byWidgetPredicate(
                    (w) => w.runtimeType.toString() == '_ShootoutStrip',
                  ),
                )
                as dynamic)
            .outcome
        as KnockoutOutcome;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ui.Image image;
  setUpAll(() async {
    image = await createTestImage(width: 4, height: 4);
  });

  testWidgets('a semi-final watched in Pitch mode at the fast speed, to the '
      'shootout and Continue', (tester) async {
    // The career's own next fixture, read once from a first copy of the
    // (deterministic) save, becomes the semi-final the second copy is
    // shown as.
    final first = await seedSave(tester);
    final real = await tester.runAsync(
      () => first.container.read(matchPreviewProvider(first.careerId).future),
    );
    final preview = _asSemiFinal(real!);
    final salt = _salt(preview);

    final save = await seedSave(
      tester,
      overrides: [
        matchPreviewProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => preview),
        matchAttemptSaltProvider.overrideWithValue(() => salt),
        matchSpeedProvider.overrideWith((ref) => _fastStep),
        pitchStadiumBakerProvider.overrideWithValue(_InstantBaker(image)),
        pitchPlaybackBuilderProvider.overrideWithValue((b) async => b.run()),
      ],
    );
    SharedPreferences.setMockInitialValues(<String, Object>{
      kMatchViewModePrefsKey: 'pitch',
    });
    await tester.runAsync(
      () => const MatchSpeedStore().save(save.careerId, _fastStep),
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.match}?careerId=${save.careerId}',
      size: const Size(400, 2000),
    );
    await _until(tester, () => _ready(tester) && _clock(tester).playing);

    // The fast speed: the pacer's table and the clock's rate.
    final pb = _pb(tester);
    final r = pb.result;
    final et = r.extraTime!;
    expect(r.extraTime, isNotNull);
    expect(_clock(tester).speed, pitchRateForStep(_fastStep));
    final scale = (90 + r.stoppage + 30) / 90;
    final per90 = pb.pacer.total.inMicroseconds / 1e6 / scale;
    final (lo, hi) = PitchPacer.bandOf(pitchSpeedForStep(_fastStep));
    expect(pitchSpeedForStep(_fastStep), PitchSpeed.fast);
    expect(per90, greaterThanOrEqualTo(lo - 0.5));
    expect(per90, lessThanOrEqualTo(hi * _overrun));

    // The picture keeps every invariant.
    expect(PitchScriptValidator.validate(pb.script), isEmpty);

    // Every goal of the match is staged: a goal cue in a window whose shot
    // is that goal's own event.
    final goals = [
      for (var i = 0; i < r.events.length; i++)
        if (r.events[i].type == MatchEventType.goal) i,
    ];
    expect(goals, isNotEmpty);
    final staged = <int>{};
    var goalCues = 0;
    for (final w in pb.script.windows) {
      final cues = w.cues.where((c) => c.kind == PitchCueKind.goal).length;
      goalCues += cues;
      for (final m in w.moments) {
        if (m is ShotMoment && m.goalEventIndex != null) {
          staged.add(m.goalEventIndex!);
          expect(cues, 1, reason: 'a goal window shows its goal once');
        }
      }
    }
    expect(staged, containsAll(goals));
    expect(goalCues, goals.length);

    // Through half-time and extra time to the shootout.
    Future<void> through(Duration whistle, String heading) async {
      _screen(tester).seekPitch(whistle - const Duration(milliseconds: 100));
      await tester.pump();
      await _until(tester, () => find.text(heading).evaluate().isNotEmpty);
      await tester.tap(find.text(enL.matchContinue).last);
      await tester.pump();
      await _until(tester, () => _clock(tester).playing);
    }

    await through(pb.halfTime, enL.matchHalfTime);
    await through(pb.extraTimeStart!, enL.matchExtraTimeAhead);
    await through(pb.extraTimeHalf!, enL.matchExtraTimeHalf);
    _screen(tester).seekPitch(pb.pacer.screenAt(120, 0, within: 0.5));
    await tester.pump();
    await _until(
      tester,
      () => find.byType(PenaltyOrderSheet).evaluate().isNotEmpty,
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(
      find.descendant(
        of: find.byType(PenaltyOrderSheet),
        matching: find.byType(PrimaryButton),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    final stage = tester
        .widget<PitchMatchView>(find.byType(PitchMatchView))
        .shootout!;
    await _until(tester, () => stage.running);

    // Every kick is four seconds; the shootout plays out whole.
    final outcome = _outcome(tester);
    expect(
      stage.kicks,
      hasLength(outcome.homeKicks.length + outcome.awayKicks.length),
    );
    // Each kick is four seconds: the time from one kick's start to the next
    // is measured per kick, to within a frame or so (0.1 s).
    var played = Duration.zero;
    // Kick 0 began before this loop did: back-date it by how far in it is.
    final startedAt = <int, Duration>{
      stage.index: -Duration(microseconds: (stage.seconds * 1e6).round()),
    };
    var lastIndex = stage.index;
    while (stage.running && played < const Duration(minutes: 3)) {
      await tester.pump(const Duration(milliseconds: 16));
      played += const Duration(milliseconds: 16);
      if (stage.index != lastIndex) {
        startedAt[stage.index] = played;
        lastIndex = stage.index;
      }
    }
    expect(stage.running, isFalse);
    expect(startedAt, hasLength(stage.kicks.length));
    for (var k = 1; k < stage.kicks.length; k++) {
      final secs = (startedAt[k]! - startedAt[k - 1]!).inMilliseconds / 1000;
      expect(
        secs,
        closeTo(ShootoutStaging.kickSeconds, 0.1),
        reason: 'kick ${k - 1}',
      );
    }
    await tester.pump();
    expect(
      tester.widget<MatchScoreboard>(find.byType(MatchScoreboard)).live,
      isFalse,
    );

    // The score on screen is the one about to be recorded: the bug's own
    // figures, and the shootout line.
    final homeWon = outcome.homeWon;
    final shownHome = et.homeScore + (homeWon ? 1 : 0);
    final shownAway = et.awayScore + (homeWon ? 0 : 1);
    final board = tester.widget<MatchScoreboard>(find.byType(MatchScoreboard));
    expect((board.homeScore, board.awayScore), (shownHome, shownAway));
    expect([
      for (final t in tester.widgetList<Text>(
        find.descendant(
          of: find.byType(MatchScoreboard),
          matching: find.byType(Text),
        ),
      ))
        t.data,
    ], containsAllInOrder(['$shownHome', '$shownAway']));
    expect(
      find.text(enL.matchShootoutScore(outcome.homePens, outcome.awayPens)),
      findsOneWidget,
    );

    // Continue records the match; the row is what was watched.
    await tester.tap(find.text(enL.matchContinue).last);
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 500)),
    );
    await tester.pump(const Duration(seconds: 1));
    final row = await tester.runAsync(() async {
      final fixtures = await save.container
          .read(competitionRepositoryProvider)
          .fixturesForNation(save.careerId, preview.playerNationId);
      return fixtures.firstWhere((f) => f.id == preview.fixture.id);
    });
    expect(row!.played, isTrue);
    // The shootout's winner is recorded one goal up on the level score.
    expect(
      (row.homeScore, row.awayScore),
      (
        et.homeScore + (outcome.homeWon ? 1 : 0),
        et.awayScore + (outcome.homeWon ? 0 : 1),
      ),
    );
    expect(row.afterExtraTime, isTrue);
    expect(
      (row.homePenalties, row.awayPenalties),
      (outcome.homePens, outcome.awayPens),
    );
    await tester.pumpWidget(const SizedBox());
  });
}
