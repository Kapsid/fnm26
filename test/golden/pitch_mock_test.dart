import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/theme/kit_colors.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/match/pitch/formation_slots.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/stadium/away_fan_share.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/ground_look.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/domain/services/match/stadium/nation_latitudes.dart';
import 'package:fnm/domain/services/match/stadium/stadium_spec.dart';
import 'package:fnm/features/match/pitch/confetti_painter.dart';
import 'package:fnm/features/match/pitch/match_dressing.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';
import 'package:fnm/features/match/pitch/stadium_looks.dart';
import 'package:fnm/features/match/pitch/stadium_painter.dart';
import 'package:fnm/features/match/pitch/token_painter.dart';

import '../helpers/pump_app.dart';

/// The owner's sign-off mock for the Pitch view: the stadium baked in its
/// three looks, both sides lined up for kick-off in shirt tokens, two named,
/// the ball on the spot, and a minimal score strip above with the kick-off
/// time.
///
/// The players are placed and painted here with the real token painter; the
/// live actors painter comes with the live view.
void main() {
  for (final s in _scenes()) {
    testWidgets(s.name, (tester) async {
      final frames = s.frames;
      final width = s.tablet ? 1024.0 : 390.0;
      final pitch = Size(width, s.tablet ? 680 : 280);
      const dpr = 2.0;
      const gap = 12.0;
      final frame = Size(width, pitch.height + _stripHeight(s.tablet));
      final total = Size(
        frame.width * frames.length + gap * (frames.length - 1),
        frame.height,
      );
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = total * dpr;
      addTearDown(tester.view.reset);

      final home = _nation(s.home), away = _nation(s.away);
      final share = AwayFanShare.estimate(
        home: home,
        away: away,
        neutral: false,
        tournament: s.dressing.dressed,
        distanceKm: AwayFanShare.proxyDistanceKm(home, away),
      );
      var spec = StadiumSpec.from(
        (
          stadium: s.stadium,
          city: s.city,
          groundNationId: home.id,
          capacity: s.capacity,
          attendance: (s.capacity * 0.92).round(),
          soldOut: false,
        ),
        home,
        away,
        share,
        groundNationCode: home.code,
        groundConfederation: home.confederation,
      );
      spec = spec.withLook(mowing: s.mowing, goalStyle: s.goalStyle);
      final projection = PitchProjection(
        pitch,
        (centreX: s.centreX, zoom: s.zoom),
      );
      final kits = KitClash.resolve(home, away);
      final latitude = NationLatitudes.of(home);

      late final StadiumLooks looks;
      late final ui.Image? homeFlag;
      late final ui.Image? awayFlag;
      await tester.runAsync(() async {
        homeFlag = await StadiumPainter.rasterFlag(home.code);
        awayFlag = await StadiumPainter.rasterFlag(away.code);
        looks = await StadiumLooks.bake(
          spec,
          projection,
          pitch,
          flag: homeFlag,
          dressing: s.dressing,
          pixelRatio: dpr,
        );
      });

      Widget one(int minute) {
        final light =
            s.light ??
            Daylight.at(latitude, s.date!, s.kickOff, math.max(minute, 1));
        return SizedBox.fromSize(
          size: frame,
          child: Column(
            children: [
              _ScoreStrip(
                home: home,
                away: away,
                homeFlag: homeFlag,
                awayFlag: awayFlag,
                tablet: s.tablet,
                minute: minute,
                kickOff: s.kickOff,
              ),
              SizedBox.fromSize(
                size: pitch,
                child: _PitchMock(
                  looks: looks,
                  light: light,
                  projection: projection,
                  home: kits.home,
                  away: kits.away,
                  homeShape: s.homeShape,
                  awayShape: s.awayShape,
                  tags: s.tags,
                  tablet: s.tablet,
                  confetti: s.confetti,
                ),
              ),
            ],
          ),
        );
      }

      await tester.pumpApp(
        RepaintBoundary(
          key: const ValueKey('mock'),
          child: SizedBox.fromSize(
            size: total * dpr,
            child: FittedBox(
              child: SizedBox.fromSize(
                size: total,
                child: Material(
                  color: AppColors.surfaceContainerLowest,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < frames.length; i++) ...[
                        if (i > 0) const SizedBox(width: gap),
                        one(frames[i]),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byKey(const ValueKey('mock')),
        matchesGoldenFile('goldens/pitch_mock_${s.name}.png'),
      );
      looks.dispose();
    });
  }
}

double _stripHeight(bool tablet) => tablet ? 64 : 52;

/// The real nations' colours, straight from the game's data.
final Map<String, Map<String, Object?>> _nations = {
  for (final n
      in (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List)
          .cast<Map<String, Object?>>())
    n['code']! as String: n,
};

Nation _nation(String code) {
  final n = _nations[code]!;
  return Nation(
    id: n['id']! as int,
    name: n['name']! as String,
    code: code,
    confederation: Confederation.values.byName(n['confederation']! as String),
    ranking: n['ranking']! as int,
    primaryColor: n['primaryColor']! as String,
    secondaryColor: n['secondaryColor']! as String,
  );
}

class _Scene {
  const _Scene(
    this.name, {
    required this.home,
    required this.away,
    required this.capacity,
    required this.stadium,
    required this.city,
    this.tablet = false,
    this.light,
    this.date,
    this.kickOff = const KickOffTime(20, 45),
    this.frames = const [0],
    this.mowing,
    this.goalStyle,
    this.dressing = MatchDressing.none,
    this.homeShape = Formation.f442,
    this.awayShape = Formation.f433,
    this.tags = ('NOVAK', 'SILVA'),
    this.zoom = 0.94,
    this.centreX = 52.5,
    this.confetti = false,
  });

  final String name;
  final String home, away;
  final int capacity;
  final String stadium, city;
  final bool tablet;

  /// A fixed light; null works it out from [date], [kickOff] and the minute.
  final PitchLight? light;
  final DateTime? date;
  final KickOffTime kickOff;

  /// The match minutes shown side by side (0 = before kick-off).
  final List<int> frames;
  final MowingPattern? mowing;
  final GoalStyle? goalStyle;
  final MatchDressing dressing;
  final Formation homeShape, awayShape;
  final (String, String) tags;
  final double zoom, centreX;
  final bool confetti;
}

List<_Scene> _scenes() {
  _Scene small(bool tablet) => _Scene(
    tablet ? 'tablet_small' : 'phone_small',
    home: 'FRO',
    away: 'ISL',
    capacity: 8000,
    stadium: 'Mock Harbour Ground',
    city: 'Tórshavn',
    tablet: tablet,
    light: PitchLight.day,
    kickOff: const KickOffTime(16, 0),
    tags: ('JOENSEN', 'HALLDORSSON'),
  );
  _Scene mid(
    String name, {
    bool tablet = false,
    PitchLight? light,
    MowingPattern? mowing,
  }) => _Scene(
    name,
    home: 'CZE',
    away: 'POR',
    capacity: 30000,
    stadium: 'Mock Mid Arena',
    city: 'Brno',
    tablet: tablet,
    light: light,
    kickOff: light == PitchLight.night
        ? const KickOffTime(20, 45)
        : light == PitchLight.dusk
        ? const KickOffTime(18, 30)
        : const KickOffTime(15, 0),
    mowing: mowing,
    homeShape: Formation.f433,
    awayShape: Formation.f4231,
    tags: ('NOVOTNY', 'FERREIRA'),
  );
  _Scene big(bool tablet) => _Scene(
    tablet ? 'tablet_big' : 'phone_big',
    home: 'FRA',
    away: 'NED',
    capacity: 80000,
    stadium: 'Mock Grand Stade',
    city: 'Lyon',
    tablet: tablet,
    light: PitchLight.night,
    tags: ('BARRAULT', 'VERHOEF'),
  );
  return [
    small(false),
    mid('phone_mid', light: PitchLight.day),
    big(false),
    small(true),
    mid('tablet_mid', tablet: true, light: PitchLight.day),
    big(true),
    // The same ground in each light.
    mid('phone_mid_day', light: PitchLight.day),
    mid('phone_mid_dusk', light: PitchLight.dusk),
    mid('phone_mid_night', light: PitchLight.night),
    mid('tablet_mid_night', tablet: true, light: PitchLight.night),
    // Three of the mowing patterns.
    for (final m in [
      MowingPattern.checkerboard,
      MowingPattern.diagonal,
      MowingPattern.circles,
    ])
      mid('phone_mid_mow_${m.name}', light: PitchLight.day, mowing: m),
    // A match the sun sets in: minutes 1, 46 and 90 of a 17:45 kick-off in
    // Brno on 10 September, the sun going down at half-time.
    _Scene(
      'phone_mid_sunset_strip',
      home: 'CZE',
      away: 'POR',
      capacity: 30000,
      stadium: 'Mock Mid Arena',
      city: 'Brno',
      date: DateTime(2026, 9, 10),
      kickOff: const KickOffTime(17, 45),
      frames: const [1, 46, 90],
      homeShape: Formation.f433,
      awayShape: Formation.f4231,
      tags: ('NOVOTNY', 'FERREIRA'),
    ),
    // Landmarks and terrain.
    const _Scene(
      'phone_paris',
      home: 'FRA',
      away: 'GER',
      capacity: 40000,
      stadium: 'Mock Parc',
      city: 'Paris',
      light: PitchLight.dusk,
      kickOff: KickOffTime(21, 0),
      tags: ('BARRAULT', 'KESSLER'),
    ),
    const _Scene(
      'phone_la_paz',
      home: 'BOL',
      away: 'ARG',
      capacity: 42000,
      stadium: 'Mock Altiplano',
      city: 'La Paz',
      light: PitchLight.day,
      kickOff: KickOffTime(16, 0),
      tags: ('QUISPE', 'ROMERO'),
    ),
    const _Scene(
      'phone_coastal_small',
      home: 'MLT',
      away: 'LUX',
      capacity: 6000,
      stadium: 'Mock Seafront',
      city: 'Valletta',
      light: PitchLight.day,
      kickOff: KickOffTime(18, 0),
      tags: ('BORG', 'WEBER'),
    ),
    // A South American box net, close.
    const _Scene(
      'phone_box_net_close',
      home: 'ARG',
      away: 'BRA',
      capacity: 55000,
      stadium: 'Mock Monumental',
      city: 'Buenos Aires',
      light: PitchLight.day,
      kickOff: KickOffTime(17, 0),
      goalStyle: GoalStyle.boxNet,
      zoom: 4.2,
      centreX: 8,
      tags: ('ROMERO', 'SANTOS'),
    ),
    // Dressed for a finals tournament, then for its final.
    const _Scene(
      'phone_tournament_group',
      home: 'ESP',
      away: 'CRO',
      capacity: 50000,
      stadium: 'Mock Mestalla',
      city: 'Valencia',
      light: PitchLight.day,
      kickOff: KickOffTime(18, 0),
      dressing: MatchDressing.tournament(Color(0xFF3A86B4)),
      tags: ('MORENO', 'KOVAC'),
    ),
    const _Scene(
      'phone_final_night',
      home: 'ITA',
      away: 'BRA',
      capacity: 70000,
      stadium: 'Mock Olimpico',
      city: 'Rome',
      light: PitchLight.night,
      kickOff: KickOffTime(21, 0),
      dressing: MatchDressing.theFinal,
      confetti: true,
      tags: ('ROSSETTI', 'SANTOS'),
    ),
  ];
}

/// A minimal score strip: the two sides, the scoreline on its plate, the
/// minute and the local kick-off time.
class _ScoreStrip extends StatelessWidget {
  const _ScoreStrip({
    required this.home,
    required this.away,
    required this.homeFlag,
    required this.awayFlag,
    required this.tablet,
    required this.minute,
    required this.kickOff,
  });

  final Nation home, away;
  final ui.Image? homeFlag, awayFlag;
  final bool tablet;
  final int minute;
  final KickOffTime kickOff;

  @override
  Widget build(BuildContext context) {
    final nameStyle = AppTypography.labelLarge.copyWith(
      color: AppColors.onSurface,
      fontSize: tablet ? 16 : 14,
    );
    Widget side(Nation n, ui.Image? flag, {required bool right}) {
      final kids = [
        _Flag(flag, height: tablet ? 18 : 14),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            tablet ? n.name : n.code,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: nameStyle,
          ),
        ),
      ];
      return Expanded(
        child: Row(
          mainAxisAlignment: right
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: right ? kids.reversed.toList() : kids,
        ),
      );
    }

    final small = AppTypography.labelSmall.copyWith(
      fontSize: tablet ? 12 : 11,
      height: 1.1,
      letterSpacing: 0,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurfaceVariant,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return Container(
      height: _stripHeight(tablet),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          side(home, homeFlag, right: false),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 2,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    borderRadius: AppRadii.baseAll,
                  ),
                  child: Text(
                    '0 : 0',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: tablet ? 20 : 18,
                      height: 1.2,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (minute > 0) ...[
                      Text(
                        "$minute'",
                        style: small.copyWith(color: AppColors.onSurface),
                      ),
                      const SizedBox(width: 6),
                    ],
                    CustomPaint(
                      size: Size.square(tablet ? 11 : 10),
                      painter: _ClockGlyph(),
                    ),
                    const SizedBox(width: 3),
                    Text(kickOff.label, style: small),
                  ],
                ),
              ],
            ),
          ),
          side(away, awayFlag, right: true),
        ],
      ),
    );
  }
}

/// A small clock face before the kick-off time.
class _ClockGlyph extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 0.6;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round
      ..color = AppColors.onSurfaceVariant;
    canvas
      ..drawCircle(c, r, p)
      ..drawLine(c, c.translate(0, -r * 0.6), p)
      ..drawLine(c, c.translate(r * 0.45, 0), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Flag extends StatelessWidget {
  const _Flag(this.image, {required this.height});

  final ui.Image? image;
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: AppRadii.smAll,
    child: SizedBox(
      width: height * 1.5,
      height: height,
      child: image == null
          ? const ColoredBox(color: AppColors.surfaceContainerHighest)
          : RawImage(image: image, fit: BoxFit.cover),
    ),
  );
}

/// One player on the mock pitch, in pitch metres.
typedef _Man = ({
  double x,
  double y,
  int number,
  bool home,
  bool keeper,
  String? tag,
});

class _PitchMock extends StatelessWidget {
  const _PitchMock({
    required this.looks,
    required this.light,
    required this.projection,
    required this.home,
    required this.away,
    required this.homeShape,
    required this.awayShape,
    required this.tags,
    required this.tablet,
    required this.confetti,
  });

  final StadiumLooks looks;
  final PitchLight light;
  final PitchProjection projection;
  final KitPair home, away;
  final Formation homeShape, awayShape;
  final (String, String) tags;
  final bool tablet;
  final bool confetti;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      CustomPaint(
        painter: _ActorsMock(
          looks: looks,
          light: light,
          men: _kickOff(homeShape, awayShape, tags),
          projection: projection,
          home: home,
          away: away,
          r0: tablet ? 16.5 : 9.6,
          nameSize: tablet ? 11.5 : 9.5,
        ),
      ),
      if (confetti) CustomPaint(painter: ConfettiPainter(t: 3.2, seed: 7)),
    ],
  );
}

/// The ground in this moment's light, then the players and the ball.
class _ActorsMock extends CustomPainter {
  _ActorsMock({
    required this.looks,
    required this.light,
    required this.men,
    required this.projection,
    required this.home,
    required this.away,
    required this.r0,
    required this.nameSize,
  });

  final StadiumLooks looks;
  final PitchLight light;
  final List<_Man> men;
  final PitchProjection projection;
  final KitPair home, away;
  final double r0, nameSize;

  @override
  void paint(Canvas canvas, Size size) {
    looks.paint(canvas, Offset.zero & size, light);
    final shadows = TokenShadows.of(light);
    final towers = [
      for (final (x, y) in StadiumPainter.towers) projection.toScreenOpen(x, y),
    ];
    final ball = projection.toScreen(PitchDims.centre.x, PitchDims.centre.y);
    final sorted = [...men]..sort((a, b) => a.y.compareTo(b.y));
    for (final m in sorted) {
      final c = projection.toScreen(m.x, m.y);
      PlayerToken.paintShadow(
        canvas,
        c,
        r0 * projection.scaleAt(m.y),
        shadows,
        towers,
      );
    }
    _ball(canvas, ball, shadows);
    for (final m in sorted) {
      final kit = m.home ? home : away;
      final c = projection.toScreen(m.x, m.y);
      final r = r0 * projection.scaleAt(m.y);
      final fill = m.keeper
          ? (m.home ? PlayerToken.homeKeeper : PlayerToken.awayKeeper)
          : _shirt(kit.primary);
      final trim = m.keeper ? AppColors.surfaceContainerLowest : _trim(kit);
      final to = ball - c;
      PlayerToken.paintShirt(
        canvas,
        c,
        r,
        fill: fill,
        trim: trim,
        number: m.number,
        facing: math.atan2(to.dy, to.dx),
      );
    }
    for (final m in sorted) {
      final tag = m.tag;
      if (tag == null) continue;
      final kit = m.home ? home : away;
      PlayerToken.paintName(
        canvas,
        projection.toScreen(m.x, m.y),
        r0 * projection.scaleAt(m.y),
        tag,
        fontSize: nameSize,
        accent: KitColors.accent(_hex(kit.primary), _hex(kit.primary)),
      );
    }
  }

  static Color _shirt(Color c) {
    final h = HSLColor.fromColor(c);
    return h.withLightness(h.lightness.clamp(0.26, 0.90)).toColor();
  }

  static Color _trim(KitPair kit) {
    final s = _shirt(kit.secondary);
    return KitColors.tooClose(s, _shirt(kit.primary))
        ? KitColors.shade(_shirt(kit.primary), -0.25)
        : s;
  }

  void _ball(Canvas canvas, Offset c, TokenShadows shadows) {
    final r = r0 * 0.34 * projection.scaleAt(PitchDims.centre.y);
    final d = shadows.sunDirection;
    canvas
      ..drawOval(
        Rect.fromCenter(
          center: c + d * (r * 0.9 * shadows.sunLength.clamp(0.6, 2.0)),
          width: r * 2.4,
          height: r * 1.1,
        ),
        Paint()
          ..color = Colors.black.withValues(
            alpha: 0.2 + shadows.sunAlpha * 0.6,
          )
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.5),
      )
      ..drawCircle(
        c,
        r,
        Paint()
          ..shader = ui.Gradient.radial(
            c.translate(-r * 0.35, -r * 0.4),
            r * 1.4,
            const [Color(0xFFFFFFFF), Color(0xFFC9CED3)],
          ),
      )
      ..drawCircle(
        c,
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.6
          ..color = Colors.black.withValues(alpha: 0.35),
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String _hex(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

/// Both sides at kick-off: home kicks off attacking +x, the away side keeps
/// out of the centre circle. A rough stand-in for the story layer's own
/// kick-off, good enough to judge the look by.
List<_Man> _kickOff(
  Formation homeShape,
  Formation awayShape,
  (String, String) tags,
) {
  final out = <_Man>[];
  const homeNumbers = <Formation, List<int>>{
    Formation.f442: [1, 2, 5, 4, 3, 7, 8, 6, 11, 9, 10],
    Formation.f433: [1, 2, 5, 4, 3, 6, 8, 10, 7, 9, 11],
    Formation.f4231: [1, 2, 5, 4, 3, 6, 8, 10, 7, 11, 9],
  };
  for (final home in [true, false]) {
    final shape = home ? homeShape : awayShape;
    final dir = home ? 1 : -1;
    final layout = layoutOf(shape);
    final numbers = homeNumbers[shape]!;
    final kick = <int>[];
    for (var i = 0; i < 11; i++) {
      final (nx, ny) = layout[i];
      final keeper = shape.positions[i] == PlayerPosition.gk;
      var depth = keeper
          ? 5.0
          : 5 +
                math.pow(((0.9 - ny) / 0.77).clamp(0.0, 1.0), 0.75).toDouble() *
                    45;
      depth = math.min(depth, 50.0);
      final lateral = (nx - 0.5) * 50;
      var x = depthToX(depth, dir);
      final y = lateralToY(lateral, dir);
      if (!home) {
        const c = PitchDims.centre;
        final lat = (y - c.y).clamp(-9.0, 9.0);
        final need = math.sqrt(math.max(0, 10.5 * 10.5 - lat * lat));
        if (math.sqrt(math.pow(x - c.x, 2) + math.pow(y - c.y, 2)) < 10.5) {
          x = depthToX(52.5 - need, dir);
        }
      }
      if (shape.positions[i] == PlayerPosition.st) kick.add(out.length);
      out.add((
        x: x,
        y: y,
        number: numbers[i],
        home: home,
        keeper: keeper,
        tag: null,
      ));
    }
    if (home) {
      // The kicker on the ball, his partner a few yards off it.
      final k = kick.first;
      out[k] = (
        x: PitchDims.centre.x - 3.2,
        y: PitchDims.centre.y - 0.6,
        number: out[k].number,
        home: true,
        keeper: false,
        tag: tags.$1,
      );
      if (kick.length > 1) {
        final p = kick[1];
        out[p] = (
          x: PitchDims.centre.x - 1.4,
          y: PitchDims.centre.y + 7.5,
          number: out[p].number,
          home: true,
          keeper: false,
          tag: null,
        );
      }
    }
  }
  // Nobody stands on a team-mate: two men pushed to the same spot on the
  // circle's edge are eased apart sideways.
  for (var it = 0; it < 40; it++) {
    for (var i = 0; i < out.length; i++) {
      for (var j = i + 1; j < out.length; j++) {
        final a = out[i], b = out[j];
        final d = math.sqrt(math.pow(a.x - b.x, 2) + math.pow(a.y - b.y, 2));
        if (d >= 7 || a.tag != null || b.tag != null) continue;
        final push = (7 - d) / 2 + 0.05;
        final s = a.y <= b.y ? -1.0 : 1.0;
        out[i] = (
          x: a.x,
          y: a.y + s * push,
          number: a.number,
          home: a.home,
          keeper: a.keeper,
          tag: a.tag,
        );
        out[j] = (
          x: b.x,
          y: b.y - s * push,
          number: b.number,
          home: b.home,
          keeper: b.keeper,
          tag: b.tag,
        );
      }
    }
  }
  // ...and the side not kicking off is still outside the circle after it.
  for (var i = 0; i < out.length; i++) {
    final m = out[i];
    const c = PitchDims.centre;
    final d = math.sqrt(math.pow(m.x - c.x, 2) + math.pow(m.y - c.y, 2));
    if (m.home || d >= 10.5) continue;
    out[i] = (
      x: c.x + (m.x - c.x) / d * 10.6,
      y: c.y + (m.y - c.y) / d * 10.6,
      number: m.number,
      home: false,
      keeper: false,
      tag: m.tag,
    );
  }
  // The away right-back wears the second tag: clear air above him on every
  // shape here, so the tag covers nobody.
  final ten = out.indexWhere((m) => !m.home && m.number == 2);
  final m = out[ten];
  out[ten] = (
    x: m.x,
    y: m.y,
    number: m.number,
    home: false,
    keeper: false,
    tag: tags.$2,
  );
  return out;
}
