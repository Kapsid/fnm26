/// The penalty shootout on the pitch: the clock that runs it and the
/// painter that draws it over the baked ground.
///
/// The shootout itself is the match screen's (the manager names the takers
/// on the taker sheet, and the kicks are drawn from that order); this only
/// stages those kicks, one every [ShootoutStaging.kickSeconds] seconds at
/// any speed, and says when each result lands so the screen can move its
/// tally. See [ShootoutStaging] for what a kick looks like.
library;

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/match/pitch/moment_staging.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/features/match/pitch/actors_painter.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';
import 'package:fnm/core/theme/kit_colors.dart';
import 'package:fnm/features/match/pitch/stadium_looks.dart';
import 'package:fnm/features/match/pitch/stadium_painter.dart';
import 'package:fnm/features/match/pitch/token_painter.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';

/// Runs a shootout's kicks on a ticker. Repaints its listeners every frame.
class ShootoutStageController extends ChangeNotifier {
  ShootoutStageController({
    required TickerProvider vsync,
    required this.kicks,
    required this.cast,
    required this.onResult,
  }) {
    _ticker = vsync.createTicker(_tick);
  }

  final List<StagedShootoutKick> kicks;
  final ShootoutCast cast;

  /// A kick's result has landed (the ball is in, saved, wide or off the
  /// woodwork): the kick's index. Called once per kick played.
  final void Function(int index) onResult;

  late final Ticker _ticker;

  /// Whether the stage is up: the camera is on the goal and the kicks are
  /// drawn in place of the match.
  final ValueNotifier<bool> active = ValueNotifier(false);

  int _index = 0;
  double _seconds = 0;
  Duration _from = Duration.zero;
  bool _resulted = false;
  bool _disposed = false;

  /// The kick on show, and how far into it (seconds).
  int get index => _index;
  double get seconds => _seconds;
  StagedShootoutKick? get kick => _index < kicks.length ? kicks[_index] : null;
  bool get running => _ticker.isActive;

  /// Plays the kicks from [index] on, each from its start.
  void start(int index) {
    if (_disposed || kicks.isEmpty) return;
    _index = index.clamp(0, kicks.length - 1);
    _seconds = 0;
    _resulted = false;
    active.value = true;
    _from = Duration.zero;
    if (_ticker.isActive) _ticker.stop();
    _ticker.start();
    notifyListeners();
  }

  /// Shows kick [index] [seconds] in, with no clock running (for tests).
  @visibleForTesting
  void debugShow(int index, double seconds) {
    stop();
    _index = index;
    _seconds = seconds;
    active.value = true;
    notifyListeners();
  }

  /// Holds the picture where it is.
  void stop() {
    if (_ticker.isActive) _ticker.stop();
  }

  /// Everything is over at once: the last kick's picture, held.
  void settle() {
    if (_disposed || kicks.isEmpty || !active.value) return;
    stop();
    _index = kicks.length - 1;
    _seconds = ShootoutStaging.kickSeconds;
    notifyListeners();
  }

  void _tick(Duration elapsed) {
    if (_disposed) return;
    _seconds = (elapsed - _from).inMicroseconds / 1e6;
    if (!_resulted && _seconds >= ShootoutStaging.resultAt) {
      _resulted = true;
      onResult(_index);
      if (_disposed) return;
    }
    if (_seconds >= ShootoutStaging.kickSeconds) {
      if (_index + 1 < kicks.length) {
        _index++;
        _seconds = 0;
        _resulted = false;
        _from = elapsed;
      } else {
        _seconds = ShootoutStaging.kickSeconds;
        stop();
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _ticker.dispose();
    active.dispose();
    super.dispose();
  }
}

/// How far in the camera goes on the goal, and where on the view the spot
/// and the goal sit: see [ShootoutCamera.matrix].
abstract final class ShootoutCamera {
  static const double zoom = 2.0;

  /// The view point the middle of the penalty spot and the goal moves to.
  static const Offset focus = Offset(0.64, 0.6);

  /// The transform that has the camera [k] (0 to 1) of the way in on the
  /// goal of [projection], never showing past the baked image.
  static Matrix4 matrix(PitchProjection projection, double k) {
    final size = projection.viewport;
    final goal = projection.toScreenOpen(
      ShootoutStaging.goalX,
      ShootoutStaging.goalY,
    );
    final spot = projection.toScreenOpen(
      ShootoutStaging.spotX,
      ShootoutStaging.goalY,
    );
    final mid = Offset.lerp(goal, spot, 0.5)!;
    final scale = 1 + (zoom - 1) * k;
    double axis(double want, double span, double at) {
      final t = k * (want - zoom * at);
      // Edge of the image never inside the view.
      return t.clamp(span * (1 - scale), 0.0);
    }

    return Matrix4.identity()
      ..translateByDouble(
        axis(size.width * focus.dx, size.width, mid.dx),
        axis(size.height * focus.dy, size.height, mid.dy),
        0,
        1,
      )
      ..scaleByDouble(scale, scale, 1, 1);
  }
}

/// A shootout kick drawn over the baked ground: the taker, the keeper in
/// goal, the ball and the taker's name, in their kits.
class ShootoutPainter extends CustomPainter {
  ShootoutPainter({
    required this.stage,
    required this.projection,
    required this.kits,
    required this.names,
    required this.lightAt,
    required this.minute,
  }) : r0 = ActorsPainter.tokenRadiusFor(projection.viewport),
       super(repaint: stage) {
    _towers = [
      for (final (x, y) in StadiumPainter.towers) projection.toScreenOpen(x, y),
    ];
    _home = ActorsPainter.dressOf(kits.home);
    _away = ActorsPainter.dressOf(kits.away);
  }

  final ShootoutStageController stage;
  final PitchProjection projection;
  final ({KitPair home, KitPair away}) kits;
  final Map<int, String> names;
  final PitchLight Function(int minute, {int stoppage}) lightAt;

  /// The match minute whose light the kicks are taken in.
  final int minute;
  final double r0;

  late final List<Offset> _towers;
  late final ActorDress _home;
  late final ActorDress _away;

  /// The name drawn in the last frame (for tests).
  String? lastName;

  @override
  void paint(Canvas canvas, Size size) {
    lastName = null;
    final kick = stage.kick;
    if (kick == null) return;
    final cast = stage.cast;
    final f = ShootoutStaging.frameAt(kick, stage.seconds);
    final shadows = TokenShadows.of(lightAt(minute));
    final takerId = kick.kick.takerId;
    final dress = kick.home ? _home : _away;
    final keeperId = cast.keeperFacing(home: kick.home);
    final keeperColour = kick.home
        ? PlayerToken.awayKeeper
        : PlayerToken.homeKeeper;

    Offset at(Offset2 p, [double z = 0]) =>
        projection.toScreenOpen(p.x, p.y, z);
    double radius(Offset2 p) => r0 * projection.scaleAt(p.y);

    final takerC = at(f.taker);
    final takerR = radius(f.taker);
    final keeperC = at(f.keeper, f.keeperHeight);
    final keeperGround = at(f.keeper);
    final keeperR = radius(f.keeper);
    final ballC = at(f.ball, f.ballHeight);
    final ballGround = at(f.ball);
    final ballR = r0 * 0.34 * projection.scaleAt(f.ball.y);

    PlayerToken.paintShadow(canvas, takerC, takerR, shadows, _towers);
    PlayerToken.paintShadow(canvas, keeperGround, keeperR, shadows, _towers);
    ActorsPainter.ballShadow(canvas, ballGround, ballR, f.ballHeight, shadows);

    // Whoever is further from the camera first; the ball over both.
    final men = [
      (y: f.taker.y, taker: true),
      (y: f.keeper.y, taker: false),
    ]..sort((a, b) => a.y.compareTo(b.y));
    for (final m in men) {
      if (m.taker) {
        PlayerToken.paintShirt(
          canvas,
          takerC,
          takerR,
          fill: dress.fill,
          trim: dress.trim,
          number: cast.shirts[takerId] ?? 0,
          facing: _screenFacing(f.taker, f.takerFacing),
          cachedNumber: true,
        );
      } else {
        PlayerToken.paintShirt(
          canvas,
          keeperC,
          keeperR,
          fill: keeperColour,
          trim: AppColors.surfaceContainerLowest,
          number: cast.shirts[keeperId] ?? 1,
          facing: math.pi,
          cachedNumber: true,
        );
      }
    }
    ActorsPainter.drawBall(canvas, ballC, ballR);

    final name = names[takerId];
    if (name != null) {
      final label = name.toUpperCase();
      PlayerToken.paintName(
        canvas,
        takerC,
        takerR,
        label,
        fontSize: ActorsPainter.nameSizeFor(projection.viewport),
        accent: dress.accent,
        avoid: [
          PlayerToken.box(keeperC, keeperR),
          Rect.fromCircle(center: ballC, radius: ballR + 1),
        ],
        own: PlayerToken.box(takerC, takerR),
        bounds: Offset.zero & projection.viewport,
      );
      lastName = label;
    }
  }

  double _screenFacing(Offset2 p, double facing) {
    final c = projection.toScreenOpen(p.x, p.y);
    final ahead = projection.toScreenOpen(
      p.x + math.cos(facing),
      p.y + math.sin(facing),
    );
    return math.atan2(ahead.dy - c.dy, ahead.dx - c.dx);
  }

  @override
  bool shouldRepaint(covariant ShootoutPainter old) =>
      !identical(old.stage, stage) ||
      old.projection.viewport != projection.viewport ||
      !mapEquals(old.names, names) ||
      old.kits != kits ||
      old.minute != minute;
}
