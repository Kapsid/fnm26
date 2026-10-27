import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/federation/stadium_map/nation_geo.dart';

/// One ground on the map.
@immutable
class StadiumPin {
  const StadiumPin({
    required this.index,
    required this.city,
    required this.capacity,
    required this.level,
    this.building = false,
  });

  /// Its place in the screen's stadium list.
  final int index;
  final String city;
  final int capacity;
  final int level;

  /// Ordered but not open yet: drawn as a hollow ring.
  final bool building;
}

/// A level's colour on the map: the medal ramp, bronze to platinum, above a
/// plain steel level 1.
Color stadiumLevelColor(int level) => switch (level) {
  <= 1 => AppColors.outline,
  2 => AppColors.medalBronze,
  3 => AppColors.medalSilver,
  4 => AppColors.medalGold,
  _ => AppColors.medalPlatinum,
};

/// A marker's radius in logical pixels: by capacity, 6 for a village ground
/// up to 14 for a 90,000 bowl.
double stadiumPinRadius(int capacity) =>
    6 + 8 * math.sqrt((capacity / 90000).clamp(0.0, 1.0));

/// A nation's outline with its stadiums pinned on it: pinch to zoom, drag to
/// pan, and it opens fitted to the country. Tap a marker for [onPin].
///
/// While [picking], the cities in [candidates] that have no ground show as
/// faint dots, and those that do get a halo; tapping either calls
/// [onCandidate].
class StadiumMap extends StatefulWidget {
  const StadiumMap({
    required this.geo,
    required this.pins,
    required this.onPin,
    this.candidates = const [],
    this.picking = false,
    this.onCandidate,
    this.fitTooltip,
    super.key,
  });

  static Key pinKey(int index) => Key('stadiumMap.pin.$index');
  static Key candidateKey(String city) => Key('stadiumMap.city.$city');
  static const Key fitKey = Key('stadiumMap.fit');
  static const Key canvasKey = Key('stadiumMap.canvas');

  final NationGeo geo;
  final List<StadiumPin> pins;
  final ValueChanged<StadiumPin> onPin;
  final List<String> candidates;
  final bool picking;
  final ValueChanged<String>? onCandidate;

  /// The tooltip of the button that fits the whole country back in.
  final String? fitTooltip;

  @override
  State<StadiumMap> createState() => _StadiumMapState();
}

/// The pin's spot in the plane: a city with two or three grounds fans them
/// out round it so each stays tappable.
Map<int, Offset> _pinOffsets(List<StadiumPin> pins) {
  final byCity = <String, List<StadiumPin>>{};
  for (final p in pins) {
    byCity.putIfAbsent(p.city, () => []).add(p);
  }
  final out = <int, Offset>{};
  for (final group in byCity.values) {
    if (group.length == 1) {
      out[group.first.index] = Offset.zero;
      continue;
    }
    final spread =
        group.map((p) => stadiumPinRadius(p.capacity)).reduce(math.max) * 0.9;
    for (var i = 0; i < group.length; i++) {
      final a = -math.pi / 2 + i * 2 * math.pi / group.length;
      out[group[i].index] = Offset(math.cos(a), math.sin(a)) * spread;
    }
  }
  return out;
}

class _StadiumMapState extends State<StadiumMap> {
  final TransformationController _zoom = TransformationController();

  @override
  void dispose() {
    _zoom.dispose();
    super.dispose();
  }

  void _fit() => _zoom.value = Matrix4.identity();

  @override
  void didUpdateWidget(StadiumMap old) {
    super.didUpdateWidget(old);
    if (!identical(old.geo, widget.geo)) _fit();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final size = Size(box.maxWidth, box.maxHeight);
        final fit = _Fit.of(widget.geo.view, size, 20);
        final textScaler = MediaQuery.textScalerOf(
          context,
        ).clamp(maxScaleFactor: 1.3);
        final offsets = _pinOffsets(widget.pins);
        final candidates = widget.picking
            ? [
                for (final c in widget.candidates)
                  if (widget.geo.boxOf(c) == -1) c,
              ]
            : const <String>[];
        final pinned = {for (final p in widget.pins) p.city};
        final mainPins = [
          for (final p in widget.pins)
            if (widget.geo.boxOf(p.city) == -1) p,
        ]..sort((a, b) => b.capacity.compareTo(a.capacity));

        return ClipRect(
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      radius: 1.1,
                      colors: [
                        AppColors.surfaceContainerLow,
                        AppColors.surfaceContainerLowest,
                      ],
                    ),
                  ),
                  child: InteractiveViewer(
                    key: StadiumMap.canvasKey,
                    transformationController: _zoom,
                    maxScale: 10,
                    boundaryMargin: EdgeInsets.all(size.shortestSide / 3),
                    child: SizedBox.fromSize(
                      size: size,
                      child: CustomPaint(
                        painter: _LandPainter(
                          geo: widget.geo,
                          fit: fit,
                          zoom: _zoom,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Markers and labels ride above the zoom at a constant size.
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _PinPainter(
                      geo: widget.geo,
                      fit: fit,
                      zoom: _zoom,
                      pins: mainPins,
                      offsets: offsets,
                      candidates: candidates,
                      haloCities: candidates.where(pinned.contains).toSet(),
                      picking: widget.picking,
                      textScaler: textScaler,
                    ),
                  ),
                ),
              ),
              ListenableBuilder(
                listenable: _zoom,
                builder: (context, _) => Stack(
                  children: [
                    for (final c in candidates)
                      if (!pinned.contains(c))
                        _target(
                          key: StadiumMap.candidateKey(c),
                          at: _screen(fit, widget.geo.cities[c]!),
                          size: size,
                          extent: 36,
                          label: c,
                          onTap: () => widget.onCandidate?.call(c),
                        ),
                    // Smallest last, so it sits on top and stays tappable
                    // beside a big neighbour.
                    for (final p in mainPins.reversed)
                      _target(
                        key: StadiumMap.pinKey(p.index),
                        at:
                            _screen(fit, widget.geo.cities[p.city]!) +
                            offsets[p.index]!,
                        size: size,
                        extent: math.max(
                          AppSpacing.minHitArea,
                          stadiumPinRadius(p.capacity) * 2 + 8,
                        ),
                        label: p.city,
                        onTap: () {
                          if (!widget.picking) {
                            widget.onPin(p);
                          } else if (candidates.contains(p.city)) {
                            widget.onCandidate?.call(p.city);
                          }
                        },
                      ),
                  ],
                ),
              ),
              if (widget.geo.insets.isNotEmpty)
                Positioned(
                  left: AppSpacing.sm,
                  bottom: AppSpacing.sm,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < widget.geo.insets.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: _Inset(
                            geo: widget.geo,
                            index: i,
                            side: (size.shortestSide * 0.3).clamp(72.0, 150.0),
                            pins: [
                              for (final p in widget.pins)
                                if (widget.geo.boxOf(p.city) == i) p,
                            ],
                            candidates: widget.picking
                                ? [
                                    for (final c in widget.candidates)
                                      if (widget.geo.boxOf(c) == i) c,
                                  ]
                                : const [],
                            picking: widget.picking,
                            onPin: widget.onPin,
                            onCandidate: widget.onCandidate,
                          ),
                        ),
                    ],
                  ),
                ),
              Positioned(
                right: AppSpacing.xs,
                top: AppSpacing.xs,
                child: ListenableBuilder(
                  listenable: _zoom,
                  builder: (context, _) => AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: _zoom.value.isIdentity() ? 0.45 : 1,
                    child: IconButton(
                      key: StadiumMap.fitKey,
                      tooltip: widget.fitTooltip,
                      onPressed: _fit,
                      icon: const Icon(
                        Icons.fit_screen_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Where a plane point lands on screen, after the fit and the zoom.
  Offset _screen(_Fit fit, Offset plane) =>
      MatrixUtils.transformPoint(_zoom.value, fit.apply(plane));

  Widget _target({
    required Key key,
    required Offset at,
    required Size size,
    required double extent,
    required String label,
    required VoidCallback onTap,
  }) {
    // Off screen: no target (and nothing for a finder to hit by mistake).
    if (at.dx < -extent ||
        at.dy < -extent ||
        at.dx > size.width + extent ||
        at.dy > size.height + extent) {
      return const SizedBox.shrink();
    }
    return Positioned(
      left: at.dx - extent / 2,
      top: at.dy - extent / 2,
      width: extent,
      height: extent,
      child: Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          key: key,
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
        ),
      ),
    );
  }
}

/// How the plane maps onto a box: a uniform scale and an offset that centre
/// the view in it with a margin.
@immutable
class _Fit {
  const _Fit(this.scale, this.offset);

  factory _Fit.of(Rect view, Size size, double margin) {
    final w = math.max<double>(1, size.width - 2 * margin);
    final h = math.max<double>(1, size.height - 2 * margin);
    final scale = math.min(
      w / math.max(view.width, 1e-9),
      h / math.max(view.height, 1e-9),
    );
    final offset = Offset(
      (size.width - view.width * scale) / 2 - view.left * scale,
      (size.height - view.height * scale) / 2 - view.top * scale,
    );
    return _Fit(scale, offset);
  }

  final double scale;
  final Offset offset;

  Offset apply(Offset p) => p * scale + offset;

  @override
  bool operator ==(Object other) =>
      other is _Fit && other.scale == scale && other.offset == offset;

  @override
  int get hashCode => Object.hash(scale, offset);
}

/// The land: a faint graticule, then the outline with a soft glow, a steel
/// gradient fill and a fine silver edge. Line widths hold steady as it zooms.
class _LandPainter extends CustomPainter {
  _LandPainter({required this.geo, required this.fit, this.zoom})
    : super(repaint: zoom);

  final NationGeo geo;
  final _Fit fit;

  /// The map's zoom; null for a fixed inset.
  final TransformationController? zoom;

  @override
  void paint(Canvas canvas, Size size) {
    final z = zoom?.value.getMaxScaleOnAxis() ?? 1;
    _graticule(canvas, size, z);
    canvas
      ..save()
      ..translate(fit.offset.dx, fit.offset.dy)
      ..scale(fit.scale);
    final px = 1 / (fit.scale * z);
    final path = geo.path;
    final bounds = path.getBounds();
    canvas
      ..drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8 * px
          ..color = AppColors.primary.withValues(alpha: 0.2)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 * px),
      )
      ..drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(
                AppColors.surfaceContainerHighest,
                AppColors.primary,
                0.08,
              )!,
              AppColors.surfaceContainerHigh,
            ],
          ).createShader(bounds),
      )
      ..drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.1 * px
          ..strokeJoin = StrokeJoin.round
          ..color = AppColors.primary.withValues(alpha: 0.7),
      )
      ..restore();
  }

  /// Parallels and meridians at a round step, about six across the view.
  void _graticule(Canvas canvas, Size size, double z) {
    final degreesTall = geo.view.height;
    const steps = [0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1.0, 2.0, 5.0, 10.0];
    final step = steps.firstWhere(
      (s) => degreesTall / s <= 7,
      orElse: () => 10,
    );
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.06)
      ..strokeWidth = 1 / z;
    final top = -fit.offset.dy / fit.scale;
    final bottom = (size.height - fit.offset.dy) / fit.scale;
    final left = -fit.offset.dx / fit.scale;
    final right = (size.width - fit.offset.dx) / fit.scale;
    // Latitudes: plane y = north - lat.
    for (
      var lat = ((geo.north - bottom) / step).floor() * step;
      lat <= geo.north - top;
      lat += step
    ) {
      final y = fit.apply(Offset(0, geo.north - lat)).dy;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    final lonStep = step / geo.k;
    final west = geo.west + left / geo.k;
    final east = geo.west + right / geo.k;
    for (
      var lon = (west / lonStep).floor() * lonStep;
      lon <= east;
      lon += lonStep
    ) {
      final x = fit.apply(Offset((lon - geo.west) * geo.k, 0)).dx;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_LandPainter old) =>
      !identical(old.geo, geo) || old.fit != fit;
}

/// Markers (by capacity and level), build candidates and the labels that
/// fit, drawn at screen size over the zoomed land.
class _PinPainter extends CustomPainter {
  _PinPainter({
    required this.geo,
    required this.fit,
    required this.pins,
    required this.offsets,
    required this.candidates,
    required this.haloCities,
    required this.picking,
    required this.textScaler,
    this.zoom,
  }) : super(repaint: zoom);

  final NationGeo geo;
  final _Fit fit;

  /// The map's zoom; null for a fixed inset.
  final TransformationController? zoom;

  /// Biggest first: they claim their labels first.
  final List<StadiumPin> pins;
  final Map<int, Offset> offsets;
  final List<String> candidates;
  final Set<String> haloCities;
  final bool picking;
  final TextScaler textScaler;

  Offset _at(Offset plane) {
    final z = zoom;
    final p = fit.apply(plane);
    return z == null ? p : MatrixUtils.transformPoint(z.value, p);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final taken = <Rect>[];
    final screen = Offset.zero & size;

    // Candidate cities without a ground: faint dots.
    for (final c in candidates) {
      if (haloCities.contains(c)) continue;
      final at = _at(geo.cities[c]!);
      if (!screen.inflate(8).contains(at)) continue;
      canvas
        ..drawCircle(
          at,
          5,
          Paint()..color = AppColors.positive.withValues(alpha: 0.22),
        )
        ..drawCircle(
          at,
          5,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2
            ..color = AppColors.positive.withValues(alpha: 0.85),
        );
      taken.add(Rect.fromCircle(center: at, radius: 6));
    }

    final spots = <StadiumPin, Offset>{};
    for (final p in pins) {
      spots[p] = _at(geo.cities[p.city]!) + offsets[p.index]!;
    }
    // Smallest last, on top.
    for (final p in pins) {
      final at = spots[p]!;
      final r = stadiumPinRadius(p.capacity);
      if (!screen.inflate(r * 2).contains(at)) continue;
      final color = stadiumLevelColor(p.level);
      final dim = picking && !haloCities.contains(p.city);
      final alpha = dim ? 0.35 : 1.0;
      if (picking && haloCities.contains(p.city)) {
        canvas.drawCircle(
          at,
          r + 5,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..color = AppColors.positive,
        );
      }
      // A soft glow, a dark rim to lift it off the land, then the disc.
      canvas
        ..drawCircle(
          at,
          r + 2,
          Paint()
            ..color = color.withValues(alpha: 0.35 * alpha)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        )
        ..drawCircle(
          at,
          r + 1.2,
          Paint()
            ..color = AppColors.surfaceContainerLowest.withValues(
              alpha: alpha,
            ),
        );
      if (p.building) {
        canvas.drawCircle(
          at,
          r - 1,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = color.withValues(alpha: alpha),
        );
      } else {
        canvas
          ..drawCircle(
            at,
            r,
            Paint()
              ..shader = RadialGradient(
                center: const Alignment(-0.35, -0.35),
                colors: [
                  Color.lerp(color, Colors.white, 0.35)!.withValues(
                    alpha: alpha,
                  ),
                  color.withValues(alpha: alpha),
                ],
              ).createShader(Rect.fromCircle(center: at, radius: r)),
          )
          ..drawCircle(
            at,
            r * 0.32,
            Paint()
              ..color = AppColors.surfaceContainerLowest.withValues(
                alpha: 0.55 * alpha,
              ),
          );
      }
      taken.add(Rect.fromCircle(center: at, radius: r + 1));
    }

    // Labels where they fit: biggest grounds first, a city once, right of
    // the marker or else left of it, never over another label or marker.
    final labelled = <String>{};
    for (final p in pins) {
      if (labelled.contains(p.city)) continue;
      final at = _at(geo.cities[p.city]!);
      final r = pins
          .where((o) => o.city == p.city)
          .map((o) => stadiumPinRadius(o.capacity) + offsets[o.index]!.distance)
          .reduce(math.max);
      if (_label(canvas, p.city, at, r, taken, screen)) labelled.add(p.city);
    }
    if (picking) {
      for (final c in candidates) {
        if (labelled.contains(c) || haloCities.contains(c)) continue;
        _label(
          canvas,
          c,
          _at(geo.cities[c]!),
          5,
          taken,
          screen,
          color: AppColors.positive,
        );
      }
    }
  }

  bool _label(
    Canvas canvas,
    String text,
    Offset at,
    double r,
    List<Rect> taken,
    Rect screen, {
    Color color = AppColors.onSurface,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          shadows: const [
            Shadow(color: AppColors.surfaceContainerLowest, blurRadius: 3),
            Shadow(color: AppColors.surfaceContainerLowest, blurRadius: 6),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
      maxLines: 1,
    )..layout();
    for (final right in [true, false]) {
      final dx = right ? at.dx + r + 4 : at.dx - r - 4 - tp.width;
      final rect = Rect.fromLTWH(
        dx,
        at.dy - tp.height / 2,
        tp.width,
        tp.height,
      );
      if (!screen.deflate(2).contains(rect.topLeft) ||
          !screen.deflate(2).contains(rect.bottomRight)) {
        continue;
      }
      if (taken.any((t) => t.overlaps(rect.inflate(1)))) continue;
      tp.paint(canvas, rect.topLeft);
      taken.add(rect);
      return true;
    }
    return false;
  }

  @override
  bool shouldRepaint(_PinPainter old) => true;
}

/// A far outpost (Madeira for Portugal) in a small fixed frame of its own.
class _Inset extends StatelessWidget {
  const _Inset({
    required this.geo,
    required this.index,
    required this.side,
    required this.pins,
    required this.candidates,
    required this.picking,
    required this.onPin,
    required this.onCandidate,
  });

  final NationGeo geo;
  final int index;
  final double side;
  final List<StadiumPin> pins;
  final List<String> candidates;
  final bool picking;
  final ValueChanged<StadiumPin> onPin;
  final ValueChanged<String>? onCandidate;

  @override
  Widget build(BuildContext context) {
    final box = geo.insets[index];
    final aspect = box.width / math.max(box.height, 1e-9);
    final size = aspect >= 1
        ? Size(side, side / aspect.clamp(1, 2.5))
        : Size(side * aspect.clamp(0.5, 1), side);
    final fit = _Fit.of(box, size, 8);
    final pinned = {for (final p in pins) p.city};
    final offsets = _pinOffsets(pins);
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: AppRadii.smAll,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _LandPainter(geo: geo, fit: fit),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _PinPainter(
                geo: geo,
                fit: fit,
                pins: pins,
                offsets: offsets,
                candidates: candidates,
                haloCities: candidates.where(pinned.contains).toSet(),
                picking: picking,
                textScaler: TextScaler.noScaling,
              ),
            ),
          ),
          for (final c in candidates)
            if (!pinned.contains(c))
              _InsetTarget(
                key: StadiumMap.candidateKey(c),
                at: fit.apply(geo.cities[c]!),
                label: c,
                onTap: () => onCandidate?.call(c),
              ),
          for (final p in pins)
            _InsetTarget(
              key: StadiumMap.pinKey(p.index),
              at: fit.apply(geo.cities[p.city]!) + offsets[p.index]!,
              label: p.city,
              onTap: () {
                if (!picking) {
                  onPin(p);
                } else if (candidates.contains(p.city)) {
                  onCandidate?.call(p.city);
                }
              },
            ),
        ],
      ),
    );
  }
}

class _InsetTarget extends StatelessWidget {
  const _InsetTarget({
    required this.at,
    required this.label,
    required this.onTap,
    super.key,
  });

  final Offset at;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const extent = 36.0;
    return Positioned(
      left: at.dx - extent / 2,
      top: at.dy - extent / 2,
      width: extent,
      height: extent,
      child: Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
        ),
      ),
    );
  }
}
