import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/stadium/choreo.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/features/match/pitch/ground_live.dart';
import 'package:fnm/features/match/pitch/match_dressing.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/stadium_painter.dart';

import '../../helpers/pitch_view_fixture.dart';
import '../../helpers/stadium_shots.dart';

void main() {
  setUpAll(loadShotFonts);

  group('choreo', () {
    test('a big nation stages one at a knockout tie or a derby', () {
      bool stages(
        String? round,
        String home,
        String away,
        int rank, {
        bool neutral = false,
      }) => Choreo.stages(
        round: round,
        homeCode: home,
        awayCode: away,
        homeRank: rank,
        neutral: neutral,
      );
      expect(stages('QF', 'FRA', 'POR', 2), isTrue);
      expect(stages('FINAL', 'FRA', 'POR', 2), isTrue);
      // A derby, even in a group.
      expect(stages('GROUP', 'ENG', 'SCO', 4), isTrue);
      expect(stages(null, 'NED', 'GER', 7), isTrue);
      // An ordinary group game, a small nation, a neutral ground: none.
      expect(stages('GROUP', 'FRA', 'POR', 2), isFalse);
      expect(stages('QF', 'MLT', 'POR', 160), isFalse);
      expect(stages('QF', 'FRA', 'POR', 2, neutral: true), isFalse);
      expect(Choreo.isDerby('SCO', 'ENG'), isTrue);
      expect(Choreo.isDerby('FRA', 'BRA'), isFalse);
    });

    test('the mosaic before kick-off, the flag through the first half', () {
      expect(Choreo.mosaicAt(0), 1);
      expect(Choreo.mosaicAt(1), 1);
      expect(Choreo.mosaicAt(5), 0);
      expect(Choreo.flagAt(0), 0);
      expect(Choreo.flagAt(20), 1);
      expect(Choreo.flagAt(44), 1);
      expect(Choreo.flagAt(46), 0);
      expect(Choreo.flagAt(80), 0);
    });
  });

  group('the crowd', () {
    PitchScoreboard board(int home, int away) => PitchScoreboard(
      homeCode: 'CZE',
      awayCode: 'POR',
      home: home,
      away: away,
      clock: '70',
    );

    test('a wave when the home side is comfortably ahead', () {
      final m = pitchMatch(seed: 5);
      final live = GroundLive(kits: pitchStadiumFor(m).kits)
        ..setBoard(board(1, 0), at: 0)
        ..minute = 75
        ..tick(GroundLive.waveEvery * 2 + 3);
      expect(live.waveAt, isNull, reason: 'one goal is not comfortable');
      live.setBoard(board(3, 0), at: 100);
      live.tick(GroundLive.waveEvery * 2 + 3);
      expect(live.waveAt, isNotNull);
      // Not in the seconds after a goal, and only part of each minute.
      live.tick(100.5);
      expect(live.waveAt, isNull);
      live.tick(GroundLive.waveEvery * 2 + GroundLive.waveFor + 2);
      expect(live.waveAt, isNull);
      live.dispose();
    });

    test('torches at an evening match late in a home win, or a shootout', () {
      final m = pitchMatch(seed: 5);
      final live = GroundLive(kits: pitchStadiumFor(m).kits)
        ..setBoard(board(1, 0), at: 0)
        ..minute = 85;
      expect(live.torches, 0, reason: 'by day');
      live.flood = 1;
      expect(live.torches, 1);
      live.minute = 60;
      expect(live.torches, 0);
      live.shootout = true;
      expect(live.torches, 1);
      live
        ..shootout = false
        ..setBoard(board(0, 1), at: 10)
        ..minute = 88;
      expect(live.torches, 0, reason: 'not in a defeat');
      live.dispose();
    });

    testWidgets('every moment paints, and the live layer stays cheap', (
      tester,
    ) async {
      final m = pitchMatch(seed: 5);
      final fra = (await tester.runAsync(
        () => StadiumPainter.rasterFlag('FRA', size: const Size(60, 40)),
      ))!;
      final base = pitchStadiumFor(
        m,
        capacity: 62000,
        kickOff: const KickOffTime(20, 45),
        dressing: MatchDressing.theFinal,
      );
      final live = GroundLive(kits: base.kits)
        ..choreoFlag = fra
        ..setBoard(board(0, 0), at: 0)
        ..minute = 0
        ..tick(0);
      await stadiumShot(tester, 'choreo_card_mosaic', base, live: live);
      live
        ..minute = 20
        ..tick(30);
      await stadiumShot(tester, 'choreo_giant_flag', base, live: live);
      live
        ..minute = 50
        ..setBoard(board(1, 0), at: 40)
        ..tick(41.2);
      await stadiumShot(tester, 'crowd_goal_celebration', base, live: live);
      live
        ..setBoard(board(3, 0), at: 60)
        ..minute = 72
        ..tick(140 + 6);
      await stadiumShot(tester, 'crowd_mexican_wave', base, live: live);
      live
        ..flood = 1
        ..minute = 86
        ..tick(400);
      await stadiumShot(
        tester,
        'crowd_phone_torches_night',
        base,
        live: live,
        light: PitchLight.night,
      );

      // The live layer's cost with everything on at once: the torches, a
      // wave, a celebration, a net and the boards.
      const size = Size(1024, 680);
      final painter = LiveGroundPainter(live);
      live.projection = PitchMatchView.projectionFor(size);
      double run(int frames) {
        final sw = Stopwatch();
        for (var i = 0; i < frames; i++) {
          live
            ..goalAt = 400.0 + i * 0.016 - 1
            ..tick(400.0 + i * 0.016);
          sw.start();
          final r = ui.PictureRecorder();
          painter.paint(Canvas(r), size);
          final p = r.endRecording();
          sw.stop();
          p.dispose();
        }
        return sw.elapsedMicroseconds / frames / 1000;
      }

      run(60);
      final ms = run(300);
      debugPrint('live layer: ${ms.toStringAsFixed(3)} ms per frame');
      expect(ms, lessThanOrEqualTo(2));
      live.dispose();
      fra.dispose();
    });
  });
}
