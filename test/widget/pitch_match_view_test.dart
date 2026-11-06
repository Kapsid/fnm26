import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/features/match/pitch/actors_painter.dart';
import 'package:fnm/features/match/pitch/confetti_painter.dart';
import 'package:fnm/features/match/pitch/match_dressing.dart';
import 'package:fnm/features/match/pitch/pitch_clock.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';

import '../helpers/pitch_view_fixture.dart';
import '../helpers/pump_app.dart';

/// Counts every stadium look it bakes, and bakes them for real.
class _CountingBaker extends PitchStadiumBaker {
  int looks = 0;
  int flags = 0;

  @override
  Future<ui.Image?> flag(String code) {
    flags++;
    return super.flag(code);
  }

  @override
  Future<ui.Image> look(
    PitchStadium stadium,
    PitchProjection projection,
    Size size,
    PitchLight light, {
    ui.Image? flag,
    double pixelRatio = 1,
  }) {
    looks++;
    return super.look(
      stadium,
      projection,
      size,
      light,
      flag: flag,
      pixelRatio: pixelRatio,
    );
  }
}

Future<PitchMatchViewState> _pump(
  WidgetTester tester, {
  required PitchMatchFixture m,
  required PitchClock clock,
  _CountingBaker? baker,
  PitchStadium? stadium,
  Key? key,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 280);
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    PitchMatchView(
      key: key,
      script: m.script,
      stadium: stadium ?? pitchStadiumFor(m),
      clock: clock,
      names: m.names,
    ),
    overrides: [
      if (baker != null) pitchStadiumBakerProvider.overrideWithValue(baker),
    ],
  );
  final state = tester.state<PitchMatchViewState>(find.byType(PitchMatchView));
  // The bake runs on real async (rasterising), started from the view's
  // post-frame callback: let real time pass and pump until it is in.
  for (var i = 0; i < 400 && !state.debugLooksComplete; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();
  }
  expect(state.debugLooksComplete, isTrue, reason: 'the bake never finished');
  await tester.pump();
  return state;
}

void main() {
  late PitchMatchFixture m;
  setUpAll(() => m = pitchMatch());

  testWidgets('renders a frame for every second of a match without '
      'exceptions', (tester) async {
    final clock = PitchClock(vsync: const TestVSync(), pacer: m.script.pacer);
    addTearDown(clock.dispose);
    final state = await _pump(tester, m: m, clock: clock);
    expect(state.debugLooksComplete, isTrue);
    final total = m.script.totalSeconds;
    var frames = 0;
    for (var s = 0.0; s <= total; s += 1) {
      clock.seek(Duration(microseconds: (s * 1e6).round()));
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'at ${s}s');
      frames++;
    }
    clock.seek(m.script.pacer.total);
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(frames, greaterThan(60));
    // And played, not only sought: three seconds on the ticker.
    clock
      ..seek(const Duration(seconds: 20))
      ..play();
    for (var i = 0; i < 180; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(tester.takeException(), isNull);
    expect(clock.value.inMilliseconds, closeTo(20000 + 180 * 16, 40));
    clock.pause();
  });

  testWidgets('tagged players show their names', (tester) async {
    final clock = PitchClock(vsync: const TestVSync(), pacer: m.script.pacer);
    addTearDown(clock.dispose);
    final state = await _pump(tester, m: m, clock: clock);
    // A staged moment names its men: they wear their tags all through it.
    final w = m.script.windows.firstWhere(
      (w) => w.actors.length >= 2 && w.end - w.start > 2,
    );
    final t = (w.start + w.end) / 2;
    clock.seek(Duration(microseconds: (t * 1e6).round()));
    await tester.pump();
    final frame = m.script.sample(clock.value);
    final expected = {
      for (final id in frame.tagged)
        if (m.names[id] != null) m.names[id]!.toUpperCase(),
    };
    expect(expected, isNotEmpty);
    expect(state.debugLastNames.toSet(), expected);
    // In open play the man on the ball is named.
    for (var s = 5.0; s < 60; s += 0.5) {
      final f = m.script.sample(Duration(milliseconds: (s * 1000).round()));
      if (m.script.windowAt(s) != null || f.ballCarrierId == null) continue;
      clock.seek(Duration(milliseconds: (s * 1000).round()));
      await tester.pump();
      expect(state.debugLastNames, contains(m.names[f.ballCarrierId]));
      return;
    }
    fail('no open-play carrier found');
  });

  testWidgets('stadium image is built once', (tester) async {
    final baker = _CountingBaker();
    final clock = PitchClock(vsync: const TestVSync(), pacer: m.script.pacer);
    addTearDown(clock.dispose);
    final stadium = pitchStadiumFor(m);
    await _pump(tester, m: m, clock: clock, baker: baker, stadium: stadium);
    // One bake per key look: day, dusk and night, once each.
    expect(baker.looks, 3);
    expect(baker.flags, 1);
    // Play through the match, sun going down and all: no re-bake.
    for (var s = 0.0; s <= m.script.totalSeconds; s += 4) {
      clock.seek(Duration(microseconds: (s * 1e6).round()));
      await tester.pump();
    }
    // Rebuilt by its parent with the same stadium: no re-bake either.
    await tester.pumpApp(
      PitchMatchView(
        script: m.script,
        stadium: stadium,
        clock: clock,
        names: m.names,
      ),
      overrides: [pitchStadiumBakerProvider.overrideWithValue(baker)],
    );
    await tester.pump();
    expect(baker.looks, 3);
    expect(baker.flags, 1);
  });

  testWidgets('the first look baked is the one the kick-off needs', (
    tester,
  ) async {
    final clock = PitchClock(vsync: const TestVSync(), pacer: m.script.pacer);
    addTearDown(clock.dispose);
    // 21:00 in Brno in November: night from the first whistle.
    final night = pitchStadiumFor(
      m,
      date: DateTime(2026, 11, 12),
      kickOff: const KickOffTime(21, 0),
    );
    expect(night.lightAt(1).mode, LightMode.night);
    expect(PitchStadiumBaker.order(night.lightAt(1)).first, LightMode.night);
    final day = pitchStadiumFor(
      m,
      date: DateTime(2026, 6, 12),
      kickOff: const KickOffTime(15, 0),
    );
    expect(PitchStadiumBaker.order(day.lightAt(1)).first, LightMode.day);
  });

  testWidgets('the camera stays centred, so no unbaked edge ever shows', (
    tester,
  ) async {
    const size = Size(390, 280);
    final projection = PitchMatchView.projectionFor(size);
    expect(projection.cam.centreX, PitchDims.length / 2);
    expect(projection.cam.zoom, PitchMatchView.cameraZoom);
    // The script's camera pans after the ball; the view never follows it.
    final pans = <double>{};
    for (var s = 0.0; s < m.script.totalSeconds; s += 0.5) {
      final f = m.script.sample(Duration(milliseconds: (s * 1000).round()));
      pans.add(f.camera.centreX.roundToDouble());
      // Every man on the pitch is drawn inside the baked frame.
      for (final p in f.players.values) {
        final c = projection.toScreenOpen(p.x, p.y);
        expect(
          (Offset.zero & size).contains(c),
          isTrue,
          reason: 'a player at (${p.x}, ${p.y}) off the frame at ${s}s',
        );
      }
    }
    expect(pans.length, greaterThan(1));
    // The near corners keep clear of the frame's edges.
    final nearLeft = projection.toScreen(0, PitchDims.width);
    final nearRight = projection.toScreen(PitchDims.length, PitchDims.width);
    expect(nearLeft.dx, greaterThan(4));
    expect(nearRight.dx, lessThan(size.width - 4));

    // And the view paints the baked image over the whole frame.
    final clock = PitchClock(vsync: const TestVSync(), pacer: m.script.pacer);
    addTearDown(clock.dispose);
    final state = await _pump(tester, m: m, clock: clock);
    expect(state.debugStadiumRect, Offset.zero & size);
  });

  testWidgets('a final rains gold confetti after the whistle', (tester) async {
    final f = pitchMatch(isFinal: true);
    expect(f.script.confettiAt, isNotNull);
    final clock = PitchClock(vsync: const TestVSync(), pacer: f.script.pacer);
    addTearDown(clock.dispose);
    await _pump(
      tester,
      m: f,
      clock: clock,
      stadium: pitchStadiumFor(f, dressing: MatchDressing.theFinal),
    );
    Iterable<CustomPaint> confetti() => tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .where((c) => c.painter is ConfettiPainter);
    clock.seek(f.script.pacer.total - const Duration(seconds: 1));
    await tester.pump();
    expect(confetti(), isEmpty);
    clock.seek(f.script.pacer.total);
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    final painter = confetti().single.painter! as ConfettiPainter;
    expect(painter.t, greaterThan(1.5));
    // A plain match has none.
    expect(m.script.confettiAt, isNull);
  });

  testWidgets('a cut is a quick fade, never a slide', (tester) async {
    final s = m.script;
    expect(s.cuts, isNotEmpty);
    for (final c in s.cuts.take(40)) {
      for (final dt in [-0.1, -0.05, -0.01, 0.0, 0.01, 0.05, 0.1]) {
        final tr = CutTransition.at(s, c + dt);
        expect(tr, isNotNull, reason: 'at cut $c ${dt}s');
        // Each layer shows one side of the cut only.
        for (final layer in tr!.layers) {
          final on = layer.t;
          expect(
            (on < c) == (dt < 0) || layer.alpha < 1,
            isTrue,
            reason: 'cut $c, dt $dt',
          );
          expect(
            on < c - 1e-9 || on >= c,
            isTrue,
          );
        }
        final sum = tr.layers.fold<double>(0, (a, l) => a + l.alpha);
        expect(sum, lessThanOrEqualTo(1.0 + 1e-9));
      }
      // Well away from it (and from any other cut), no transition.
      final away = c + 0.4;
      final clear = [
        ...s.cuts,
        ...s.resets,
      ].every((o) => (o - away).abs() > CutTransition.length / 2);
      if (clear) expect(CutTransition.at(s, away), isNull);
    }
    // The frame just before and just after a set-piece or phase cut differ,
    // and neither is a blend of the two.
    final c = s.cuts.firstWhere(
      (c) => s.cutKinds[c] != PitchCutKind.kickOff,
      orElse: () => s.cuts.first,
    );
    final before = s.sample(Duration(microseconds: (c * 1e6).round() - 1));
    final after = s.sample(Duration(microseconds: (c * 1e6).round()));
    expect(
      before.ball == after.ball && before.players == after.players,
      isFalse,
    );
  });

  test('the clock runs, pauses, seeks to a minute and scales by speed', () {
    final clock = PitchClock(vsync: const TestVSync(), pacer: m.script.pacer)
      ..seekToMatch(60, 0);
    expect(clock.value, m.script.pacer.screenAt(60, 0));
    expect(clock.match.minute, 60);
    clock.speed = 2;
    expect(clock.speed, 2);
    clock.seek(const Duration(days: 1));
    expect(clock.value, m.script.pacer.total);
    expect(clock.finished, isTrue);
    clock.seek(-const Duration(seconds: 3));
    expect(clock.value, Duration.zero);
    clock.dispose();
  });
}
