import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/ground_character.dart';
import 'package:fnm/domain/services/match/stadium/ground_sponsors.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/domain/services/match/stadium/scoreboard.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/pitch/ground_live.dart';
import 'package:fnm/features/match/pitch/net_ripple.dart';
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
    sponsors: stadium.sponsors,
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

/// [s] with the boards carrying a ground's pick of the game's brands.
PitchStadium _sponsored(PitchStadium s, {Sponsor? career}) => PitchStadium(
  key: s.key,
  spec: s.spec,
  kits: s.kits,
  latitude: s.latitude,
  date: s.date,
  kickOff: s.kickOff,
  dressing: s.dressing,
  sponsors: [
    for (final b in GroundSponsors.forGround(
      stadium: 'Mock Mid Arena',
      groundCode: 'CZE',
      career: career,
    ))
      b.id.toUpperCase(),
  ],
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

  group('sponsors', () {
    test('a ground always carries the same brands, the career first', () {
      List<String> ids(Sponsor? career) => [
        for (final b in GroundSponsors.forGround(
          stadium: 'Arena',
          groundCode: 'ESP',
          career: career,
        ))
          b.id,
      ];
      expect(ids(null), ids(null));
      expect(ids(null), hasLength(GroundSponsors.count));
      final mine = ids(SponsorBrand.milkwell);
      expect(mine.first, 'milkwell');
      expect(mine.toSet(), hasLength(mine.length));
      expect(
        ids(null),
        isNot(
          GroundSponsors.forGround(
            stadium: 'Other Ground',
            groundCode: 'ESP',
          ).map((b) => b.id).toList(),
        ),
      );
    });

    test('no dubious brand, and the Czech jokes only in Czechia', () {
      for (final code in ['ESP', 'CZE', 'BRA']) {
        for (var i = 0; i < 40; i++) {
          for (final b in GroundSponsors.forGround(
            stadium: 'Ground $i',
            groundCode: code,
          )) {
            expect(b.risky, isFalse);
            if (code != 'CZE') expect(b.czechOnly, isFalse);
          }
        }
      }
    });

    testWidgets('the boards carry them and the LEDs flash a goal', (
      tester,
    ) async {
      final m = pitchMatch(seed: 5);
      final stadium = _sponsored(
        pitchStadiumFor(m, capacity: 42000),
        career: SponsorBrand.velocell,
      );
      final live = GroundLive(kits: stadium.kits, sponsors: stadium.sponsors)
        ..setBoard(_board(home: 1), at: 0)
        ..tick(3);
      await _scene(tester, 'sponsors_led', stadium, live: live);
      live
        ..setBoard(_board(), at: 10)
        ..tick(11);
      expect(live.flashColours, isNotNull);
      await _scene(tester, 'sponsors_led_goal_flash', stadium, live: live);
      expect(live.anchors!.led, isNotEmpty);
      live.dispose();
    });
  });

  group('nets', () {
    test('every goal strikes the back netting once, in time order', () {
      for (final seed in [3, 5, 7, 11]) {
        final m = pitchMatch(seed: seed);
        final hits = NetRipples.of(m.script);
        final goals = m.script.result.events
            .where((e) => e.type == MatchEventType.goal)
            .length;
        expect(
          hits.where((h) => !h.side).length,
          goals,
          reason: 'seed $seed',
        );
        for (var i = 1; i < hits.length; i++) {
          expect(hits[i].t, greaterThanOrEqualTo(hits[i - 1].t));
        }
      }
    });

    test('a struck net bulges out, swings back and settles', () {
      expect(NetRipples.envelope(0), 0);
      expect(NetRipples.envelope(0.15), greaterThan(0.5));
      expect(NetRipples.envelope(0.6), lessThan(0));
      expect(NetRipples.envelope(NetRipples.duration), 0);
      const hit = NetHit(t: 10, left: true, y: 34, z: 1, side: false);
      expect(NetRipples.activeAt(const [hit], 9.9), isNull);
      expect(NetRipples.activeAt(const [hit], 10.5), hit);
      expect(NetRipples.activeAt(const [hit], 12.3), isNull);
    });

    testWidgets('a bulging net and a rippling side net paint', (
      tester,
    ) async {
      final m = pitchMatch(seed: 5);
      final stadium = pitchStadiumFor(m, capacity: 42000);
      final live = GroundLive(kits: stadium.kits)
        ..projection = PitchMatchView.projectionFor(const Size(1024, 680))
        ..goalStyle = stadium.spec.goalStyle
        ..nets = const [
          NetHit(t: 10, left: true, y: 33, z: 1.2, side: false),
          NetHit(t: 20, left: false, y: 37.66, z: 0.8, side: true),
        ]
        ..tick(10.14);
      expect(live.net, isNotNull);
      await _scene(tester, 'net_bulge', stadium, live: live);
      live.tick(20.12);
      expect(live.net!.side, isTrue);
      await _scene(tester, 'net_side_ripple', stadium, live: live);
      live.dispose();
    });
  });
}
