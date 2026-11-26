import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/ground_character.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/domain/services/match/stadium/scoreboard.dart';
import 'package:fnm/features/match/pitch/ground_live.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/features/match/pitch/stadium_painter.dart';

import '../../helpers/pitch_view_fixture.dart';

/// Where the screenshots go when `STADIUM_SHOTS` names a folder; without
/// it the scenes are painted and thrown away (a smoke test).
final String? _shots = Platform.environment['STADIUM_SHOTS'];

Future<void> _loadFonts() async {
  for (final (family, path) in const [
    ('Hanken Grotesk', 'assets/fonts/HankenGrotesk-Variable.ttf'),
    ('JetBrains Mono', 'assets/fonts/JetBrainsMono-Variable.ttf'),
  ]) {
    final bytes = File(path).readAsBytesSync();
    await (FontLoader(
      family,
    )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
  }
}

/// Paints [stadium] in [light] at [size] with the live layer [live] over it,
/// and writes it to `$_shots/$name.png` when screenshots are wanted.
Future<void> _scene(
  WidgetTester tester,
  String name,
  PitchStadium stadium, {
  required GroundLive live,
  PitchLight light = PitchLight.day,
  Size size = const Size(1024, 680),
  void Function(Canvas canvas, Size size)? extra,
}) async {
  final projection = PitchMatchView.projectionFor(size);
  final painter = StadiumPainter(
    stadium.spec,
    projection,
    light: light,
    dressing: stadium.dressing,
  );
  live.anchors = painter.anchors;
  const dpr = 2.0;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(dpr);
  painter.paint(canvas, size);
  LiveGroundPainter(live).paint(canvas, size);
  extra?.call(canvas, size);
  final picture = recorder.endRecording();
  final dir = _shots;
  if (dir == null) {
    picture.dispose();
    return;
  }
  await tester.runAsync(() async {
    final img = await picture.toImage(
      (size.width * dpr).round(),
      (size.height * dpr).round(),
    );
    final png = await img.toByteData(format: ui.ImageByteFormat.png);
    Directory(dir).createSync(recursive: true);
    File('$dir/$name.png').writeAsBytesSync(png!.buffer.asUint8List());
    img.dispose();
  });
  picture.dispose();
}

PitchScoreboard _board({int home = 2, int away = 1, String clock = '67'}) =>
    PitchScoreboard(
      homeCode: 'CZE',
      awayCode: 'POR',
      home: home,
      away: away,
      clock: clock,
      scorer: 'NOVOTNY',
      scorerHome: true,
    );

void main() {
  setUpAll(_loadFonts);

  group('scoreboard', () {
    test('the tier follows the ground size', () {
      expect(ScoreboardTier.of(GroundScale.old), ScoreboardTier.manual);
      expect(ScoreboardTier.of(GroundScale.compact), ScoreboardTier.digital);
      expect(ScoreboardTier.of(GroundScale.big), ScoreboardTier.video);
      expect(ScoreboardTier.forCapacity(5000), ScoreboardTier.manual);
      expect(ScoreboardTier.forCapacity(12000), ScoreboardTier.digital);
      expect(ScoreboardTier.forCapacity(60000), ScoreboardTier.video);
      expect(ScoreboardTier.video.showsScorer, isTrue);
      expect(ScoreboardTier.digital.showsScorer, isFalse);
      expect(ScoreboardTier.manual.showsCodes, isFalse);
    });

    test('the board writes the header clock as a board does', () {
      expect(_board(clock: '37').boardClock, "37'");
      expect(_board(clock: '90+2').boardClock, "90+2'");
      expect(_board(clock: 'ET 95').boardClock, "95'");
      expect(_board(clock: 'FULL TIME').boardClock, 'FULL TIME');
    });

    test('a goal is marked only when the score goes up', () {
      final m = pitchMatch(seed: 5);
      final live = GroundLive(kits: pitchStadiumFor(m).kits)
        ..setBoard(_board(home: 1, away: 0), at: 10);
      expect(live.goalAt, isNull, reason: 'the first board marks nothing');
      live
        ..setBoard(_board(home: 1, away: 0, clock: '12'), at: 20)
        ..tick(20);
      expect(live.goalAt, isNull);
      live
        ..setBoard(_board(home: 1, away: 1, clock: '13'), at: 30)
        ..tick(31);
      expect(live.goalAt, 30);
      expect(live.goalHome, isFalse);
      expect(live.flashColours, isNotNull);
      live.tick(30 + GroundLive.flashSeconds + 1);
      expect(live.flashColours, isNull);
      live.dispose();
    });

    test('the painter repaints only when what it shows changes', () {
      final m = pitchMatch(seed: 5);
      final live = GroundLive(kits: pitchStadiumFor(m).kits)
        ..setBoard(_board(), at: 0);
      var repaints = 0;
      live.addListener(() => repaints++);
      for (var t = 0.0; t < 3.9; t += 1 / 60) {
        live.tick(t);
      }
      expect(repaints, lessThanOrEqualTo(1));
      live.dispose();
    });

    testWidgets('each board paints, day and night', (tester) async {
      final m = pitchMatch(seed: 5);
      for (final (name, capacity) in const [
        ('board_manual', 5000),
        ('board_digital', 14000),
        ('board_video', 62000),
      ]) {
        final stadium = pitchStadiumFor(
          m,
          capacity: capacity,
          kickOff: const KickOffTime(20, 45),
        );
        final live = GroundLive(kits: stadium.kits)
          ..setBoard(_board(home: 1), at: 0)
          ..setBoard(_board(), at: 10)
          ..tick(12);
        await _scene(tester, '${name}_day', stadium, live: live);
        await _scene(
          tester,
          '${name}_night',
          stadium,
          live: live,
          light: PitchLight.night,
        );
        expect(live.anchors!.boards, isNotEmpty, reason: name);
        expect(
          live.anchors!.tier,
          ScoreboardTier.forCapacity(capacity),
          reason: name,
        );
        live.dispose();
      }
    });
  });
}
