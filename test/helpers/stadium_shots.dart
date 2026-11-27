import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/stadium_spec.dart';
import 'package:fnm/features/match/pitch/ground_live.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/features/match/pitch/stadium_painter.dart';

/// Where the stadium screenshots go when `STADIUM_SHOTS` names a folder;
/// without it the scenes are painted and thrown away (a smoke test).
final String? stadiumShotsDir = Platform.environment['STADIUM_SHOTS'];

/// The app's own faces, for the boards' letters in a screenshot.
Future<void> loadShotFonts() async {
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

/// Paints [stadium] in [light] at [size] with the live layer [live] over it
/// (and [extra] over that), and writes it to `$stadiumShotsDir/$name.png`
/// when screenshots are wanted.
Future<void> stadiumShot(
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
    sponsors: stadium.sponsors,
  );
  live
    ..projection = projection
    ..anchors = painter.anchors;
  const dpr = 2.0;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(dpr);
  painter.paint(canvas, size);
  LiveGroundPainter(live).paint(canvas, size);
  extra?.call(canvas, size);
  final picture = recorder.endRecording();
  final dir = stadiumShotsDir;
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

/// A board at [home]-[away] in minute [clock], NOVOTNY the last scorer.
PitchScoreboard shotBoard({int home = 2, int away = 1, String clock = '67'}) =>
    PitchScoreboard(
      homeCode: 'CZE',
      awayCode: 'POR',
      home: home,
      away: away,
      clock: clock,
      scorer: 'NOVOTNY',
      scorerHome: true,
    );

/// [s] with its look swapped for [spec].
PitchStadium withSpec(PitchStadium s, StadiumSpec spec) => PitchStadium(
  key: Object(),
  spec: spec,
  kits: s.kits,
  latitude: s.latitude,
  date: s.date,
  kickOff: s.kickOff,
  dressing: s.dressing,
  sponsors: s.sponsors,
);
