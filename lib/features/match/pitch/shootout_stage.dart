/// The penalty shootout on the pitch: the clock that runs it and the
/// painter that draws it.
///
/// The shootout itself is the match screen's (the manager names the takers
/// on the taker sheet, and the kicks are drawn from that order); this only
/// stages those kicks, one every [ShootoutStaging.kickSeconds] seconds at
/// any speed, and says when each result lands so the screen can move its
/// tally. The kicks are seen from behind the taker, the goal mouth large and
/// face-on, all six lanes marked: see [ShootoutPainter].
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

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

/// What the shootout's close-up draws: one kick, how far into it, and its
/// men. A shootout's own kicks ([ShootoutStageController]) and a penalty in
/// the match ([PenaltyCloseUp]) are both shown through it.
abstract interface class ShootoutView implements Listenable {
  /// The kick on show; null shows nothing.
  StagedShootoutKick? get kick;

  /// How far into [kick], in seconds (see [ShootoutStaging.frameAt]).
  double get seconds;

  /// The two sides' keepers and every shirt number.
  ShootoutCast get cast;
}

/// Runs a shootout's kicks on a ticker. Repaints its listeners every frame.
class ShootoutStageController extends ChangeNotifier implements ShootoutView {
  ShootoutStageController({
    required TickerProvider vsync,
    required this.kicks,
    required this.cast,
    required this.onResult,
    this.onDone,
  }) {
    _ticker = vsync.createTicker(_tick);
  }

  final List<StagedShootoutKick> kicks;
  @override
  final ShootoutCast cast;

  /// A kick's result has landed (the ball is in, saved, wide or off the
  /// woodwork): the kick's index. Called once per kick played.
  final void Function(int index) onResult;

  /// The last kick has played out (the picture is held on it).
  final VoidCallback? onDone;

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
  @override
  double get seconds => _seconds;
  @override
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
        notifyListeners();
        onDone?.call();
        return;
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

/// A penalty given in the match, shown in the shootout's close-up while
/// the clock is on it ([InMatchPenalty.from] to [InMatchPenalty.to]); the
/// pitch is drawn again either side of it. Follows the clock, so a pause,
/// a seek or a goal's held flash hold the close-up where it is.
class PenaltyCloseUp extends ChangeNotifier implements ShootoutView {
  PenaltyCloseUp(this.penalties);

  /// The match's penalties, from [InMatchPenalty.of].
  final List<InMatchPenalty> penalties;

  /// Whether the close-up is up: the clock is on one of the [penalties].
  final ValueNotifier<bool> active = ValueNotifier(false);

  InMatchPenalty? _on;
  double _seconds = 0;

  /// The penalty on show.
  InMatchPenalty? get on => _on;

  @override
  StagedShootoutKick? get kick => _on?.kick;

  @override
  double get seconds => _seconds;

  @override
  ShootoutCast get cast => (_on ?? penalties.first).cast;

  /// The clock is at screen second [t].
  void update(double t) {
    InMatchPenalty? on;
    for (final p in penalties) {
      if (t >= p.from - 1e-9 && t < p.to) {
        on = p;
        break;
      }
    }
    final was = _on;
    _on = on;
    _seconds = on == null ? 0 : on.secondsAt(t);
    active.value = on != null;
    if (on != null || was != null) notifyListeners();
  }

  @override
  void dispose() {
    active.dispose();
    super.dispose();
  }
}

/// A shootout kick seen from behind the taker: the goal mouth large and
/// face-on with its net, the six lanes (left, centre, right, low and high)
/// faintly marked and the one the ball goes to lit, the keeper diving into
/// his lane, the net rippling on a goal, a parried save, and the taker's
/// back and name. Drawn whole, over the ground the view has baked.
class ShootoutPainter extends CustomPainter {
  ShootoutPainter({
    required this.stage,
    required this.kits,
    required this.names,
    required this.lightAt,
    required this.minute,
  }) : super(repaint: stage) {
    _home = ActorsPainter.dressOf(kits.home);
    _away = ActorsPainter.dressOf(kits.away);
  }

  final ShootoutView stage;
  final ({KitPair home, KitPair away}) kits;
  final Map<int, String> names;
  final PitchLight Function(int minute, {int stoppage}) lightAt;

  /// The match minute whose light the kicks are taken in.
  final int minute;

  late final ActorDress _home;
  late final ActorDress _away;

  /// The name drawn in the last frame (for tests).
  String? lastName;

  /// The camera stands this far behind the penalty spot, in metres; the
  /// goal is then 25 m from it.
  static const double _back = 14;
  static const double _camX = ShootoutStaging.spotX - _back;
  static const double _goalDist = ShootoutStaging.goalX - _camX;

  @override
  void paint(Canvas canvas, Size size) {
    lastName = null;
    final kick = stage.kick;
    if (kick == null) return;
    final cast = stage.cast;
    final k = kick.kick;
    final s = stage.seconds;
    final f = ShootoutStaging.frameAt(kick, s);
    final light = lightAt(minute);
    final night = light.flood;
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // The camera: pixels per metre at a distance, and where the grass is.
    final goalPx = w * 0.62 / (2 * PitchDims.goalHalfWidth);
    final hy = h * 0.38;
    final baseY = h * 0.62;
    final camH = (baseY - hy) / goalPx;
    double px(double d) => goalPx * _goalDist / d;
    double ground(double d) => hy + camH * px(d);
    double dist(double x) => x - _camX;
    final gp = goalPx;
    final goalTop = baseY - PitchDims.crossbarHeight * gp;
    final left = cx - PitchDims.goalHalfWidth * gp;
    final right = cx + PitchDims.goalHalfWidth * gp;

    _backdrop(canvas, size, night, ground, px);
    final net = Rect.fromLTRB(left, goalTop, right, baseY);

    // The net, rippling from where a goal went in.
    final scored = k.result == KickResult.scored;
    final since = math.max(0.0, s - ShootoutStaging.resultAt);
    final hit = Offset(
      cx + (ShootoutStaging.laneY(k.lane) - ShootoutStaging.goalY) * gp,
      baseY - ShootoutStaging.laneHeight(k.lane) * gp,
    );
    _net(canvas, net, scored ? hit : null, since, night);

    // The posts and the bar, in front of the net.
    final post = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.5, gp * 0.16)
      ..strokeCap = StrokeCap.square;
    canvas.drawPath(
      Path()
        ..moveTo(left, baseY)
        ..lineTo(left, goalTop)
        ..lineTo(right, goalTop)
        ..lineTo(right, baseY),
      post,
    );

    // The keeper, diving into his lane.
    final keeperId = cast.keeperFacing(home: kick.home);
    final kd = dist(f.keeper.x);
    final lat = f.keeper.y - ShootoutStaging.goalY;
    final kr = 0.62 * px(kd);
    final kc = Offset(
      cx + lat * px(kd),
      ground(kd) - (0.55 + f.keeperHeight) * px(kd),
    );
    final tilt = (lat / 2.5).clamp(-1.0, 1.0) * 1.05;
    canvas
      ..save()
      ..translate(kc.dx, kc.dy)
      ..rotate(tilt);
    PlayerToken.paintShirt(
      canvas,
      Offset.zero,
      kr,
      fill: kick.home ? PlayerToken.awayKeeper : PlayerToken.homeKeeper,
      trim: AppColors.surfaceContainerLowest,
      number: cast.shirts[keeperId] ?? 1,
      facing: math.pi / 2 * 3,
      chevron: false,
    );
    canvas.restore();

    // The taker, from behind: in from the left, behind the ball, the run-up.
    final takerId = k.takerId;
    final dress = kick.home ? _home : _away;
    final walkU = (s / ShootoutStaging.walkEnd).clamp(0.0, 1.0);
    final entering = s < ShootoutStaging.walkEnd;
    final td = math.max(dist(f.taker.x), 6.0);
    final takerLat = entering
        ? -9 + (f.taker.y - ShootoutStaging.goalY + 9) * walkU * walkU
        : f.taker.y - ShootoutStaging.goalY;
    final tdist = entering ? 9.8 : td;
    final tr = 0.4 * px(tdist);
    final tc = Offset(
      cx + takerLat * px(tdist),
      ground(tdist) - 0.95 * px(tdist),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(tc.dx, ground(tdist)),
        width: tr * 2.2,
        height: tr * 0.5,
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.28),
    );
    PlayerToken.paintShirt(
      canvas,
      tc,
      tr,
      fill: dress.fill,
      trim: dress.trim,
      number: cast.shirts[takerId] ?? 0,
      facing: math.pi / 2 * 3,
      chevron: false,
      cachedNumber: true,
    );

    // The ball, over everybody.
    final bd = dist(f.ball.x);
    final bpx = px(bd);
    final bc = Offset(
      cx + (f.ball.y - ShootoutStaging.goalY) * bpx,
      ground(bd) - f.ballHeight * bpx,
    );
    final br = math.max(2.5, 0.2 * bpx);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(bc.dx, ground(bd)),
        width: br * 2.2,
        height: br * 0.8,
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.3),
    );
    ActorsPainter.drawBall(canvas, bc, br);

    // The taker's name, over the stand.
    final name = names[takerId];
    if (name != null) {
      final label = name.toUpperCase();
      final tp = PlayerToken.namePainter(
        label,
        ActorsPainter.nameSizeFor(size) * 1.25,
      );
      final at = Offset(cx - tp.width / 2, h * 0.05);
      tp.paint(canvas, at);
      canvas.drawLine(
        Offset(cx - tp.width * 0.3, at.dy + tp.height + 2),
        Offset(cx + tp.width * 0.3, at.dy + tp.height + 2),
        Paint()
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..color = dress.accent,
      );
      lastName = label;
    }
  }

  /// The stand, the boards and the grass with its stripes, the goal line,
  /// the six-yard box and the spot, in the light of the match.
  void _backdrop(
    Canvas canvas,
    Size size,
    double night,
    double Function(double) ground,
    double Function(double) px,
  ) {
    final w = size.width;
    final h = size.height;
    Color mix(Color day, Color dark) => Color.lerp(day, dark, night)!;
    final boardsY = ground(31);
    final standBottom = boardsY - h * 0.06;
    canvas.drawRect(
      Rect.fromLTRB(0, 0, w, standBottom),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(0, standBottom),
          [
            mix(const Color(0xFF262F40), const Color(0xFF0C1018)),
            mix(const Color(0xFF3A4459), const Color(0xFF1A2130)),
          ],
        ),
    );
    final rng = math.Random(7);
    for (var i = 0; i < 520; i++) {
      final x = rng.nextDouble() * w;
      final y = rng.nextDouble() * standBottom;
      final c = Color.lerp(
        const [
          Color(0xFFB04A4A),
          Color(0xFFD9D9D9),
          Color(0xFF4A78B0),
          Color(0xFFE0B84A),
        ][rng.nextInt(4)],
        const Color(0xFF000000),
        0.35 + 0.4 * night,
      )!;
      canvas.drawCircle(
        Offset(x, y),
        1.3,
        Paint()..color = c.withValues(alpha: 0.55),
      );
    }
    // The advertising boards.
    final boards = Rect.fromLTRB(0, standBottom, w, boardsY);
    canvas.drawRect(
      boards,
      Paint()..color = mix(const Color(0xFF1D2A44), const Color(0xFF0A101C)),
    );
    const tints = [
      Color(0xFFE53935),
      Color(0xFFFDD835),
      Color(0xFF1E88E5),
      Color(0xFFFFFFFF),
    ];
    for (var i = 0; i < 8; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          i * w / 8 + 4,
          boards.top + 3,
          w / 8 - 8,
          boards.height - 6,
        ),
        Paint()
          ..color = mix(
            tints[i % 4],
            const Color(0xFF000000),
          ).withValues(alpha: 0.75),
      );
    }
    // The grass, striped every 5.5 m back from the boards.
    final light = mix(const Color(0xFF3C8A47), const Color(0xFF1F5129));
    final dark = mix(const Color(0xFF347A3E), const Color(0xFF1A4524));
    canvas.drawRect(Rect.fromLTRB(0, boardsY, w, h), Paint()..color = light);
    var top = boardsY;
    for (var i = 0; i < 12; i++) {
      final d = 31 - 5.5 * (i + 1);
      if (d <= 1) break;
      final y = math.min(ground(d), h);
      if (i.isEven) {
        canvas.drawRect(Rect.fromLTRB(0, top, w, y), Paint()..color = dark);
      }
      top = y;
      if (y >= h) break;
    }
    // The goal line, the six-yard box and the spot.
    final line = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 1.6;
    final gy = ground(_goalDist);
    canvas.drawLine(Offset(0, gy), Offset(w, gy), line);
    final boxD = _goalDist - 5.5;
    final by = ground(boxD);
    final cx = w / 2;
    canvas
      ..drawLine(
        Offset(cx - 9.16 * px(_goalDist), gy),
        Offset(cx - 9.16 * px(boxD), by),
        line,
      )
      ..drawLine(
        Offset(cx + 9.16 * px(_goalDist), gy),
        Offset(cx + 9.16 * px(boxD), by),
        line,
      )
      ..drawLine(
        Offset(cx - 9.16 * px(boxD), by),
        Offset(cx + 9.16 * px(boxD), by),
        line,
      );
    final spotD = _back;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, ground(spotD)),
        width: 0.5 * px(spotD),
        height: 0.2 * px(spotD),
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );
  }

  /// The net: a grid across the mouth, pulled back in a wave from [hit] for a
  /// moment after a goal.
  void _net(Canvas canvas, Rect net, Offset? hit, double since, double night) {
    const cols = 18;
    const rows = 8;
    final amp = hit == null ? 0.0 : 11 * math.exp(-since * 2.2);
    Offset node(int i, int j) {
      final p = Offset(
        net.left + net.width * i / cols,
        net.top + net.height * j / rows,
      );
      if (hit == null || since <= 0 || amp < 0.2) return p;
      final d = (p - hit).distance;
      final wave =
          math.cos(since * 16 - d / 14) *
          math.exp(-d * d / (net.width * net.width * 0.18));
      return p +
          Offset(0, -amp * wave * 0.5) +
          Offset((p.dx - hit.dx) * 0.02 * amp * wave, 0);
    }

    // The back of the goal, a shade dark, then the mesh.
    canvas.drawRect(
      net,
      Paint()..color = Colors.black.withValues(alpha: 0.28 + 0.15 * night),
    );
    final mesh = Paint()
      ..color = Colors.white.withValues(alpha: 0.38)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    for (var j = 0; j <= rows; j++) {
      final path = Path()..moveTo(node(0, j).dx, node(0, j).dy);
      for (var i = 1; i <= cols; i++) {
        path.lineTo(node(i, j).dx, node(i, j).dy);
      }
      canvas.drawPath(path, mesh);
    }
    for (var i = 0; i <= cols; i++) {
      final path = Path()..moveTo(node(i, 0).dx, node(i, 0).dy);
      for (var j = 1; j <= rows; j++) {
        path.lineTo(node(i, j).dx, node(i, j).dy);
      }
      canvas.drawPath(path, mesh);
    }
  }

  @override
  bool shouldRepaint(covariant ShootoutPainter old) =>
      !identical(old.stage, stage) ||
      !mapEquals(old.names, names) ||
      old.kits != kits ||
      old.minute != minute;
}
