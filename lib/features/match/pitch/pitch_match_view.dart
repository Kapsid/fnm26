import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/pitch_view_geometry.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/features/match/pitch/actors_painter.dart';
import 'package:fnm/features/match/pitch/confetti_painter.dart';
import 'package:fnm/features/match/pitch/pitch_clock.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/features/match/pitch/stadium_looks.dart';
import 'package:fnm/features/match/pitch/weather_painter.dart';

/// The live Pitch view: the match's ground, baked once, and over it the
/// players and the ball as [clock] runs through [script].
///
/// Layers, back to front:
/// 1. the stadium, a cached image per key light (day, dusk, night),
///    cross-faded for the light of the minute on the clock. It repaints
///    only when that light moves (once a match minute) or a look arrives;
/// 2. the fans' show (scarves, flares, drums, a final's tifo), one more
///    cached image, faded out as the match gets going;
/// 3. the actors ([ActorsPainter]), repainted every tick;
/// 4. the weather falling ([WeatherOverlay]): a cached tile, scrolled;
/// 5. a final's gold confetti after the whistle.
///
/// **Camera.** The view keeps the camera centred at [cameraZoom] and does
/// not follow the script's camera pan. The ground is baked for a centred
/// camera; at this zoom the whole pitch, its run-off and both end stands
/// are in frame, so no pan is needed to follow play and no unbaked edge can
/// ever show.
///
/// **Bake.** Before kick-off the ground is baked once per size: the flag,
/// then the look the kick-off's light needs, a frame let through, then the
/// other two. A small spinner shows until the first look is in (about
/// 0.1 s on a desktop for a big ground); the others follow without holding
/// a frame up for long. A missing look is stood in for by the nearest.
class PitchMatchView extends ConsumerStatefulWidget {
  const PitchMatchView({
    required this.script,
    required this.stadium,
    required this.clock,
    this.names = const {},
    this.onReady,
    super.key,
  });

  final PitchScript script;
  final PitchStadium stadium;
  final PitchClock clock;

  /// Display names by player id, for the name labels.
  final Map<int, String> names;

  /// Called when all three looks of the ground are baked (see
  /// [PitchMatchViewState.ready]): the match screen starts its clock then.
  final VoidCallback? onReady;

  /// How far in the camera sits: a touch wide of the pitch, so the near
  /// corners and both end stands keep clear of the frame's edges.
  static const double cameraZoom = PitchViewGeometry.zoom;

  /// The projection the view draws (and bakes) at [size]: always centred.
  static PitchProjection projectionFor(Size size) => PitchProjection(size, (
    centreX: PitchDims.length / 2,
    zoom: cameraZoom,
  ));

  @override
  ConsumerState<PitchMatchView> createState() => PitchMatchViewState();
}

class PitchMatchViewState extends ConsumerState<PitchMatchView>
    with SingleTickerProviderStateMixin {
  StadiumLooks? _looks;
  ({Size size, double dpr, PitchStadium stadium})? _bakedFor;
  int _bakeGeneration = 0;
  Completer<void> _baked = Completer<void>();
  final _looksArrived = ValueNotifier<int>(0);
  late final Listenable _stadiumRepaint = Listenable.merge([
    _light,
    _looksArrived,
  ]);
  final _ready = ValueNotifier<bool>(false);

  /// A new bake (another size, another ground) asked for while the clock
  /// runs: it waits for the next pause, and the old images are drawn
  /// scaled until then.
  bool _rebakeWaiting = false;

  /// True once all three looks of the current ground are baked. The match
  /// screen holds the clock until it is: the bake runs before kick-off (or
  /// in a pause), never in live play.
  ValueListenable<bool> get ready => _ready;

  late final ValueNotifier<PitchLight> _light;
  (int, int)? _lightKey;

  late final Ticker _confettiTicker;
  final _confetti = ValueNotifier<double?>(null);
  double _confettiFrom = 0;

  ActorsPainter? _actors;
  Rect? _stadiumRect;

  /// The fans' show, baked with the looks, and how much of it is up.
  ui.Image? _show;
  final _showOpacity = ValueNotifier<double>(0);
  WeatherOverlay? _weather;

  /// Completes once all three looks are baked (for tests).
  @visibleForTesting
  Future<void> get debugBaked => _baked.future;

  @visibleForTesting
  bool get debugLooksComplete => _looks?.complete ?? false;

  /// The names the last frame drew (for tests).
  @visibleForTesting
  List<String> get debugLastNames => _actors?.lastNames ?? const [];

  /// Where the last frame drew the stadium image (for tests).
  @visibleForTesting
  Rect? get debugStadiumRect => _stadiumRect;

  /// How long the bake took, per look, recording on the UI thread and in
  /// all (for the bake-cost report).
  @visibleForTesting
  final List<({double recordMs, double totalMs})> debugBakeTimes = [];

  @override
  void initState() {
    super.initState();
    _light = ValueNotifier(_lightNow());
    _confettiTicker = createTicker((elapsed) {
      final t = _confettiFrom + elapsed.inMicroseconds / 1e6;
      _confetti.value = t;
      if (t > 14) _confettiTicker.stop();
    });
    widget.clock.addListener(_onClock);
    _onClock();
  }

  @override
  void didUpdateWidget(PitchMatchView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final old = oldWidget;
    if (!identical(old.clock, widget.clock)) {
      old.clock.removeListener(_onClock);
      widget.clock.addListener(_onClock);
    }
    if (!identical(old.script, widget.script) ||
        !identical(old.stadium, widget.stadium)) {
      _lightKey = null;
      _onClock();
    }
  }

  @override
  void dispose() {
    widget.clock.removeListener(_onClock);
    _bakeGeneration++;
    _confettiTicker.dispose();
    _confetti.dispose();
    _light.dispose();
    _looksArrived.dispose();
    _ready.dispose();
    _looks?.dispose();
    _show?.dispose();
    _showOpacity.dispose();
    _weather?.dispose();
    super.dispose();
  }

  PitchLight _lightNow() {
    final m = widget.script.pacer.matchAt(widget.clock.value);
    return widget.stadium.lightAt(m.minute, stoppage: m.stoppage);
  }

  void _onClock() {
    if (_rebakeWaiting && !widget.clock.playing && mounted) {
      _rebakeWaiting = false;
      setState(() {});
    }
    final m = widget.script.pacer.matchAt(widget.clock.value);
    final key = (m.minute, m.stoppage);
    if (key != _lightKey) {
      _lightKey = key;
      _light.value = widget.stadium.lightAt(m.minute, stoppage: m.stoppage);
      _showOpacity.value = widget.stadium.showOpacityAt(m.minute);
    }
    final at = widget.script.confettiAt;
    final t = widget.clock.value.inMicroseconds / 1e6;
    if (at != null && t >= at - 1e-6) {
      if (_confetti.value == null && !_confettiTicker.isActive) {
        _confettiFrom = t - at;
        _confetti.value = _confettiFrom;
        _confettiTicker.start();
      }
    } else if (_confetti.value != null) {
      _confettiTicker.stop();
      _confetti.value = null;
    }
  }

  /// Starts a bake for [size] if the ground is not baked for it yet.
  /// Returns false when one is needed but must wait for a pause.
  bool _ensureBaked(Size size, double dpr) {
    final want = (size: size, dpr: dpr, stadium: widget.stadium);
    final had = _bakedFor;
    if (had != null &&
        had.size == size &&
        had.dpr == dpr &&
        had.stadium == widget.stadium) {
      return true;
    }
    if (_looks != null && widget.clock.playing) {
      // Never in live play: the old images carry on, scaled, until the
      // clock stops.
      _rebakeWaiting = true;
      return false;
    }
    _bakedFor = want;
    final generation = ++_bakeGeneration;
    if (_baked.isCompleted) _baked = Completer<void>();
    if (_ready.value) _ready.value = false;
    // After this frame, so the spinner is on screen first.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted && generation == _bakeGeneration) {
        unawaited(_bake(want, generation));
      }
    });
    return true;
  }

  Future<void> _bake(
    ({Size size, double dpr, PitchStadium stadium}) want,
    int generation,
  ) async {
    final baker = ref.read(pitchStadiumBakerProvider);
    final projection = PitchMatchView.projectionFor(want.size);
    final flag = await baker.flag(want.stadium.spec.flagCode);
    final looks = StadiumLooks(want.size);
    bool stale() => !mounted || generation != _bakeGeneration;
    if (stale()) {
      flag?.dispose();
      return;
    }
    debugBakeTimes.clear();
    var first = true;
    // One look at a time: each is rasterised off the UI thread and awaited,
    // so frames run between two looks.
    for (final mode in PitchStadiumBaker.order(_lightNow())) {
      final sw = Stopwatch()..start();
      final img = await baker.look(
        want.stadium,
        projection,
        want.size,
        StadiumLooks.keyLight(mode),
        flag: flag,
        pixelRatio: want.dpr,
      );
      debugBakeTimes.add((
        recordMs: baker.lastRecordMs,
        totalMs: sw.elapsedMicroseconds / 1000,
      ));
      if (stale()) {
        img.dispose();
        break;
      }
      looks.add(mode, img);
      if (first) {
        first = false;
        final old = _looks;
        setState(() => _looks = looks);
        old?.dispose();
      } else {
        _looksArrived.value++;
      }
    }
    flag?.dispose();
    if (stale()) {
      if (!identical(_looks, looks)) looks.dispose();
      return;
    }
    final show = await baker.show(
      want.stadium,
      projection,
      want.size,
      _lightNow(),
      pixelRatio: want.dpr,
    );
    if (stale()) {
      show?.dispose();
      if (!identical(_looks, looks)) looks.dispose();
      return;
    }
    final oldShow = _show;
    setState(() => _show = show);
    oldShow?.dispose();
    if (!_baked.isCompleted) _baked.complete();
    _ready.value = true;
    widget.onReady?.call();
  }

  ActorsPainter _actorsFor(Size size) {
    final a = _actors;
    if (a != null &&
        identical(a.script, widget.script) &&
        identical(a.clock, widget.clock) &&
        mapEquals(a.names, widget.names) &&
        a.kits == widget.stadium.kits &&
        a.projection.viewport == size) {
      return a;
    }
    return _actors = ActorsPainter(
      script: widget.script,
      clock: widget.clock,
      projection: PitchMatchView.projectionFor(size),
      kits: widget.stadium.kits,
      names: widget.names,
      lightAt: widget.stadium.lightAt,
      isPlaying: () => widget.clock.playing,
    );
  }

  WeatherOverlay _weatherFor() {
    final w = _weather;
    final kind = widget.stadium.weather;
    if (w != null && w.kind == kind) return w;
    w?.dispose();
    return _weather = WeatherOverlay(
      kind,
      // Stable across runs: the same match always rains the same way.
      seed: varietySeed(
        '${widget.stadium.spec.flagCode}:${widget.stadium.date}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        if (!size.isFinite || size.isEmpty) return const SizedBox.shrink();
        final current = _ensureBaked(size, dpr);
        final looks = _looks;
        // Waiting to re-bake: the picture as baked, scaled to the new size.
        final drawSize = current || looks == null ? size : looks.size;
        return ColoredBox(
          color: AppColors.surfaceContainerLowest,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (looks == null || looks.isEmpty)
                const Center(
                  child: SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                _scaled(
                  size,
                  drawSize,
                  Stack(
                    fit: StackFit.expand,
                    children: [
                      RepaintBoundary(
                        child: CustomPaint(
                          painter: _StadiumLayer(
                            looks,
                            _light,
                            _stadiumRepaint,
                            (r) => _stadiumRect = r,
                          ),
                        ),
                      ),
                      if (_show != null)
                        RepaintBoundary(
                          child: CustomPaint(
                            painter: _ShowLayer(_show!, _showOpacity),
                          ),
                        ),
                      RepaintBoundary(
                        child: CustomPaint(painter: _actorsFor(drawSize)),
                      ),
                      if (_weatherFor().falls)
                        IgnorePointer(
                          child: RepaintBoundary(
                            child: CustomPaint(
                              painter: _WeatherLayer(
                                _weatherFor(),
                                widget.clock,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ValueListenableBuilder<double?>(
                valueListenable: _confetti,
                builder: (context, t, _) => t == null
                    ? const SizedBox.shrink()
                    : IgnorePointer(
                        child: RepaintBoundary(
                          child: CustomPaint(
                            painter: ConfettiPainter(
                              t: t,
                              seed:
                                  widget.script.homeNationId * 31 +
                                  widget.script.pacer.total.inSeconds,
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
}

/// [child] laid out at [drawn] and stretched to [size] when the two differ
/// (a re-bake waiting for a pause).
Widget _scaled(Size size, Size drawn, Widget child) => size == drawn
    ? child
    : FittedBox(
        fit: BoxFit.fill,
        child: SizedBox.fromSize(size: drawn, child: child),
      );

/// The baked ground in the light of the minute on the clock.
class _StadiumLayer extends CustomPainter {
  _StadiumLayer(this.looks, this.light, Listenable repaint, this.onPaint)
    : super(repaint: repaint);

  final StadiumLooks looks;
  final ValueListenable<PitchLight> light;
  final void Function(Rect) onPaint;

  @override
  void paint(Canvas canvas, Size size) {
    final dst = Offset.zero & size;
    looks.paint(canvas, dst, light.value);
    onPaint(dst);
  }

  @override
  bool shouldRepaint(covariant _StadiumLayer old) =>
      !identical(old.looks, looks) || !identical(old.light, light);
}

/// The fans' show, faded with the match minute.
class _ShowLayer extends CustomPainter {
  _ShowLayer(this.image, this.opacity) : super(repaint: opacity);

  final ui.Image image;
  final ValueListenable<double> opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final a = opacity.value;
    if (a <= 0) return;
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Offset.zero & size,
      Paint()
        ..filterQuality = FilterQuality.medium
        ..color = Color.fromRGBO(255, 255, 255, a),
    );
  }

  @override
  bool shouldRepaint(covariant _ShowLayer old) =>
      !identical(old.image, image) || !identical(old.opacity, opacity);
}

/// The weather falling, scrolled with the clock: it stops when play does.
class _WeatherLayer extends CustomPainter {
  _WeatherLayer(this.weather, this.clock) : super(repaint: clock);

  final WeatherOverlay weather;
  final PitchClock clock;

  @override
  void paint(Canvas canvas, Size size) =>
      weather.paint(canvas, size, clock.value.inMicroseconds / 1e6);

  @override
  bool shouldRepaint(covariant _WeatherLayer old) =>
      !identical(old.weather, weather) || !identical(old.clock, clock);
}
