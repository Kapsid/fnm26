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
import 'package:fnm/domain/services/match/stadium/stadium_spec.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';
import 'package:fnm/features/match/pitch/stadium_painter.dart';

import '../helpers/pump_app.dart';

/// The owner's sign-off mock for the Pitch view: the static stadium, both
/// sides lined up for kick-off, two name tags, the ball on the spot and a
/// minimal score strip above, at phone and tablet width, for a small, a
/// mid-sized and a big ground.
///
/// The players here are placed and painted by the test, in the app's disc
/// style; the real actors painter comes with the live view.
void main() {
  for (final c in _cases) {
    for (final tablet in [false, true]) {
      final name = 'pitch_mock_${tablet ? 'tablet' : 'phone'}_${c.name}';
      testWidgets(name, (tester) async {
        final width = tablet ? 1024.0 : 390.0;
        final pitch = Size(width, tablet ? 680 : 280);
        const dpr = 2.0;
        final total = Size(width, pitch.height + _stripHeight(tablet));
        // Captured at twice the size, as a phone's screen would draw it.
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = total * dpr;
        addTearDown(tester.view.reset);

        final share = AwayFanShare.estimate(
          home: c.home,
          away: c.away,
          neutral: false,
          tournament: false,
          distanceKm: AwayFanShare.proxyDistanceKm(c.home, c.away),
        );
        final spec = StadiumSpec.from(
          (
            stadium: 'Mock',
            city: 'Mock',
            groundNationId: c.home.id,
            capacity: c.capacity,
            attendance: c.attendance,
            soldOut: false,
          ),
          c.home,
          c.away,
          share,
          groundNationCode: c.home.code,
        );
        final projection = PitchProjection(
          pitch,
          (centreX: 52.5, zoom: _zoom),
        );
        final kits = KitClash.resolve(c.home, c.away);

        late final ui.Image stadium;
        late final ui.Image? homeFlag;
        late final ui.Image? awayFlag;
        await tester.runAsync(() async {
          final flag = await StadiumPainter.rasterFlag(c.home.code);
          homeFlag = await StadiumPainter.rasterFlag(c.home.code);
          awayFlag = await StadiumPainter.rasterFlag(c.away.code);
          stadium = await StadiumPainter(
            spec,
            projection,
            flag: flag,
          ).bake(pitch, pixelRatio: dpr);
        });

        await tester.pumpApp(
          RepaintBoundary(
            key: const ValueKey('mock'),
            child: SizedBox.fromSize(
              size: total * dpr,
              child: FittedBox(
                child: SizedBox.fromSize(
                  size: total,
                  child: Material(
                    color: AppColors.surface,
                    child: ColoredBox(
                      color: AppColors.surface,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ScoreStrip(
                            home: c.home,
                            away: c.away,
                            homeFlag: homeFlag,
                            awayFlag: awayFlag,
                            tablet: tablet,
                          ),
                          SizedBox.fromSize(
                            size: pitch,
                            child: _PitchMock(
                              stadium: stadium,
                              projection: projection,
                              home: kits.home,
                              away: kits.away,
                              homeShape: c.homeShape,
                              awayShape: c.awayShape,
                              tags: c.tags,
                              tablet: tablet,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await expectLater(
          find.byKey(const ValueKey('mock')),
          matchesGoldenFile('goldens/$name.png'),
        );
      });
    }
  }
}

/// A touch wider than the pitch, so the near corners and the end stands have
/// some room at the screen's edges.
const double _zoom = 0.94;

double _stripHeight(bool tablet) => tablet ? 64 : 52;

Nation _nation(int id, String name, String code, String a, String b) => Nation(
  id: id,
  name: name,
  code: code,
  confederation: Confederation.europe,
  ranking: 30,
  primaryColor: a,
  secondaryColor: b,
);

typedef _Case = ({
  String name,
  Nation home,
  Nation away,
  int capacity,
  int attendance,
  Formation homeShape,
  Formation awayShape,
  (String, String) tags,
});

final List<_Case> _cases = [
  (
    name: 'small',
    home: _nation(1, 'Faroe Islands', 'FRO', '#FFFFFF', '#0065BD'),
    away: _nation(2, 'Iceland', 'ISL', '#0055A4', '#DC1E35'),
    capacity: 8000,
    attendance: 6400,
    homeShape: Formation.f442,
    awayShape: Formation.f433,
    tags: ('JOENSEN', 'HALLDORSSON'),
  ),
  (
    name: 'mid',
    home: _nation(3, 'Czechia', 'CZE', '#D7141A', '#11457E'),
    away: _nation(4, 'Portugal', 'POR', '#C8102E', '#006600'),
    capacity: 30000,
    attendance: 27500,
    homeShape: Formation.f433,
    awayShape: Formation.f4231,
    tags: ('NOVOTNY', 'FERREIRA'),
  ),
  (
    name: 'big',
    home: _nation(5, 'France', 'FRA', '#002395', '#FFFFFF'),
    away: _nation(6, 'Netherlands', 'NED', '#FF6C00', '#FFFFFF'),
    capacity: 80000,
    attendance: 78000,
    homeShape: Formation.f442,
    awayShape: Formation.f433,
    tags: ('BARRAULT', 'VERHOEF'),
  ),
];

/// A minimal score strip in the scoreboard's style: the two sides, the
/// scoreline on its plate and the clock.
class _ScoreStrip extends StatelessWidget {
  const _ScoreStrip({
    required this.home,
    required this.away,
    required this.homeFlag,
    required this.awayFlag,
    required this.tablet,
  });

  final Nation home, away;
  final ui.Image? homeFlag, awayFlag;
  final bool tablet;

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
                const SizedBox(height: 2),
                Text(
                  "0'",
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: tablet ? 12 : 11,
                    height: 1.1,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                  ),
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
    required this.stadium,
    required this.projection,
    required this.home,
    required this.away,
    required this.homeShape,
    required this.awayShape,
    required this.tags,
    required this.tablet,
  });

  final ui.Image stadium;
  final PitchProjection projection;
  final KitPair home, away;
  final Formation homeShape, awayShape;
  final (String, String) tags;
  final bool tablet;

  @override
  Widget build(BuildContext context) {
    final men = _kickOff(homeShape, awayShape, tags);
    final r0 = tablet ? 16.0 : 8.8;
    return Stack(
      fit: StackFit.expand,
      children: [
        RawImage(image: stadium, scale: 2, fit: BoxFit.fill),
        CustomPaint(
          painter: _ActorsMock(
            men: men,
            projection: projection,
            home: home,
            away: away,
            r0: r0,
          ),
        ),
        for (final m in men)
          if (m.tag case final tag?)
            _tagFor(m, tag, r0, m.home ? home.primary : away.primary),
      ],
    );
  }

  Widget _tagFor(_Man m, String tag, double r0, Color kit) {
    final c = projection.toScreen(m.x, m.y);
    final r = r0 * projection.scaleAt(m.y);
    final fontSize = tablet ? 11.0 : 9.0;
    final h = fontSize + 7;
    return Positioned(
      left: c.dx - 80,
      width: 160,
      top: c.dy - r - h - 3,
      height: h,
      child: Center(
        child: Container(
          padding: const EdgeInsets.only(left: 2, right: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh.withValues(alpha: 0.94),
            borderRadius: AppRadii.smAll,
            border: Border.all(color: AppColors.outlineVariant, width: 0.6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 2.5,
                height: h - 7,
                decoration: BoxDecoration(
                  color: KitColors.accent(_hex(kit), _hex(kit)),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                tag,
                style: AppTypography.labelSmall.copyWith(
                  fontSize: fontSize,
                  height: 1,
                  letterSpacing: 0.4,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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

/// The players and the ball, in the tactics board's disc style: a kit
/// gradient, a rim and the shirt number in the board's type.
class _ActorsMock extends CustomPainter {
  _ActorsMock({
    required this.men,
    required this.projection,
    required this.home,
    required this.away,
    required this.r0,
  });

  final List<_Man> men;
  final PitchProjection projection;
  final KitPair home, away;
  final double r0;

  static const _homeKeeper = Color(0xFF3D454E);
  static const _awayKeeper = Color(0xFF7A8C3E);

  @override
  void paint(Canvas canvas, Size size) {
    _ball(canvas);
    final sorted = [...men]..sort((a, b) => a.y.compareTo(b.y));
    for (final m in sorted) {
      final kit = m.home ? home : away;
      final fill = m.keeper
          ? (m.home ? _homeKeeper : _awayKeeper)
          : _shirt(kit.primary);
      final rim = m.keeper ? AppColors.surfaceContainerLowest : _rim(kit);
      _disc(canvas, m, fill, rim);
    }
  }

  static Color _shirt(Color c) {
    final h = HSLColor.fromColor(c);
    return h.withLightness(h.lightness.clamp(0.26, 0.90)).toColor();
  }

  static Color _rim(KitPair kit) {
    final s = _shirt(kit.secondary);
    return KitColors.tooClose(s, _shirt(kit.primary))
        ? KitColors.shade(_shirt(kit.primary), -0.25)
        : s;
  }

  void _disc(Canvas canvas, _Man m, Color fill, Color rim) {
    final k = projection.scaleAt(m.y);
    final c = projection.toScreen(m.x, m.y);
    final r = r0 * k;
    canvas
      ..drawOval(
        Rect.fromCenter(
          center: c.translate(r * 0.18, r * 0.62),
          width: r * 2.1,
          height: r * 0.9,
        ),
        Paint()
          ..color = Colors.black.withValues(alpha: 0.38)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.28),
      )
      ..drawCircle(
        c,
        r,
        Paint()
          ..shader = ui.Gradient.linear(
            c.translate(0, -r),
            c.translate(0, r),
            [fill, KitColors.shade(fill, -0.14)],
          ),
      )
      ..drawCircle(
        c,
        r - math.max(0.6, r * 0.08),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.2, r * 0.16)
          ..color = rim,
      );
    final on = fill.computeLuminance() > 0.55 ? Colors.black : Colors.white;
    final tp = TextPainter(
      text: TextSpan(
        text: '${m.number}',
        style: AppTypography.titleMedium.copyWith(
          fontSize: r * 1.02,
          height: 1,
          fontWeight: FontWeight.w700,
          color: on,
          letterSpacing: -0.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2 - r * 0.02));
  }

  void _ball(Canvas canvas) {
    final c = projection.toScreen(PitchDims.centre.x, PitchDims.centre.y);
    final r = r0 * 0.36 * projection.scaleAt(PitchDims.centre.y);
    canvas
      ..drawOval(
        Rect.fromCenter(
          center: c.translate(r * 0.4, r * 0.7),
          width: r * 2.4,
          height: r * 1.1,
        ),
        Paint()
          ..color = Colors.black.withValues(alpha: 0.45)
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
