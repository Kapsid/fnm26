/// How much of the pitch a player's token covers on screen, so the story
/// layer can keep players visually apart and not only physically apart.
///
/// The Pitch view draws each man as a shirt token about 20 px wide on a
/// 390 px phone pitch, over a tilted, end-on projection. One token covers
/// about 5.8 m of pitch along its length and 5.5 to 7.6 m across it,
/// because depth is compressed by the tilt, most of all at the far
/// touchline. Two men 2 m apart therefore stand on top of each other on
/// screen. These figures mirror the view's projection (`PitchProjection`,
/// tilt 0.75, far line at 0.30 and near line at 0.95 of the height, camera
/// zoom 0.94) and its phone token (half-width 10.2 px on 390 x 280), the
/// tightest case; a tablet draws its tokens relatively smaller. A
/// renderer test pins the two together. Pure Dart.
library;

import 'dart:math' as math;

import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';

abstract final class DisplaySpacing {
  // The phone view the figures come from.
  static const double _viewW = 390, _viewH = 280;
  static const double _tokenHalf = 10.2;
  static const double _tilt = 0.75, _top = 0.30, _bottom = 0.95;
  static const double _zoom = 0.94;
  static const double _far = 1 - 0.5 * _tilt;

  /// Half a token along the pitch's length, in metres (the same at every
  /// depth: the token and the pitch both shrink with distance).
  static const double halfLength =
      _tokenHalf * (PitchDims.length / _zoom) / _viewW;

  /// Half a token across the pitch at pitch [y] (0 = the far touchline),
  /// in metres.
  static double halfAcross(double y) {
    final v = (y / PitchDims.width).clamp(0.0, 1.0);
    final s = _far + (1 - _far) * v;
    final pxPerMetre =
        _viewH *
        (_bottom - _top) /
        PitchDims.width *
        (_far + 2 * (1 - _far) * v);
    return _tokenHalf * s / pxPerMetre;
  }

  /// How much two tokens at [a] and [b] overlap on screen: 0 apart, 1 one
  /// on top of the other (the shared share of one token's box).
  static double overlap(Offset2 a, Offset2 b) {
    final w = 2 * halfLength;
    final h = 2 * halfAcross((a.y + b.y) / 2);
    final ox = 1 - (a.x - b.x).abs() / w;
    final oy = 1 - (a.y - b.y).abs() / h;
    if (ox <= 0 || oy <= 0) return 0;
    return ox * oy;
  }

  /// The shortest move that takes a token at [a] off one at [b] until
  /// they overlap no more than [target]: along the pitch or across it,
  /// whichever is less, away from [b]. Zero when they already are. [tie]
  /// picks the side when the two stand exactly level.
  static Offset2 separation(
    Offset2 a,
    Offset2 b, {
    double target = 0.3,
    int tie = 1,
    bool acrossOnly = false,
  }) {
    final w = 2 * halfLength;
    final h = 2 * halfAcross((a.y + b.y) / 2);
    final dx = a.x - b.x;
    final dy = a.y - b.y;
    final ox = 1 - dx.abs() / w;
    final oy = 1 - dy.abs() / h;
    if (ox <= 0 || oy <= 0 || ox * oy <= target) return Offset2.zero;
    final sx = target >= oy ? 0.0 : w * (1 - target / oy) - dx.abs();
    final sy = target >= ox ? 0.0 : h * (1 - target / ox) - dy.abs();
    double sign(double d) => d.abs() > 1e-9 ? d.sign : tie.toDouble();
    // Across the pitch (a step to the side on screen is a short one in
    // pitch metres only far off) or along it, whichever is shorter.
    if (acrossOnly)
      return target >= ox ? Offset2.zero : Offset2(0, sign(dy) * sy);
    if (sx <= sy) return Offset2(sign(dx) * sx, 0);
    return Offset2(0, sign(dy) * sy);
  }

  /// [points] eased apart until no two overlap more than [target] on
  /// screen (across the pitch only, with [acrossOnly], which never changes
  /// how deep anybody stands), moving only the [movable] ones (a fixed man's neighbours make
  /// all the room). A few even passes, each moving a man at most [maxStep]
  /// metres; deterministic for the same input. Stays on the pitch.
  static Map<int, Offset2> spread(
    Map<int, Offset2> points,
    Set<int> movable, {
    double target = 0.3,
    int passes = 4,
    double maxStep = 2.5,
    double margin = 0.5,
    bool acrossOnly = false,
  }) {
    final ids = points.keys.toList()..sort();
    final at = {for (final id in ids) id: points[id]!};
    for (var pass = 0; pass < passes; pass++) {
      final push = <int, Offset2>{};
      var any = false;
      for (var i = 0; i < ids.length; i++) {
        for (var j = i + 1; j < ids.length; j++) {
          final a = ids[i], b = ids[j];
          final ma = movable.contains(a), mb = movable.contains(b);
          if (!ma && !mb) continue;
          final sep = separation(
            at[a]!,
            at[b]!,
            target: target,
            tie: -1,
            acrossOnly: acrossOnly,
          );
          if (sep == Offset2.zero) continue;
          any = true;
          final share = ma && mb ? 0.5 : 1.0;
          if (ma) push[a] = (push[a] ?? Offset2.zero) + sep * share;
          if (mb) push[b] = (push[b] ?? Offset2.zero) - sep * share;
        }
      }
      if (!any) break;
      for (final e in push.entries) {
        final p = at[e.key]! + e.value.capped(maxStep);
        at[e.key] = Offset2(
          p.x.clamp(margin, PitchDims.length - margin),
          p.y.clamp(margin, PitchDims.width - margin),
        );
      }
    }
    return at;
  }
}

/// The last word on screen: where each token is drawn so that no two read
/// as one, nudged from where the script has the man by at most a fraction
/// of a token.
///
/// Smooth in its input (no switching between ways out), so a token eases
/// aside as a man comes near and back as he leaves; it never jumps. Men
/// [pinned] (the man on the ball, whose feet the ball is at) are drawn
/// where they are; pairs [contact] (a challenge, a moment's own men, a
/// wall) may overlap up to [contactRoom], everybody else up to [room].
/// Pure: the same frame always draws the same.
abstract final class Declutter {
  static const double room = 0.3;
  static const double contactRoom = 0.6;

  /// The furthest a token is drawn from its man, in tokens.
  static const double maxNudge = 0.55;

  /// How far one pass moves toward clear: gently, so a crowd settles
  /// instead of rocking between two answers from frame to frame.
  static const double _gain = 0.2;

  /// How far [a] and [b] are meant to be close in [f] at screen second
  /// [t] of [s], 0 to 1: a challenge on the man with the ball, two of a
  /// moment's own men (a foul, a block, a save, a header), or a wall. It
  /// fades in and out over a fifth of a second at the edges of the carry
  /// or the moment, so nothing drawn jumps when it starts or ends.
  static double contactIn(
    PitchScript s,
    PitchFrame f,
    int a,
    int b,
    double t,
  ) {
    int team(int id) => s.actorList[s.actorIndexOf(id)!].teamNationId;
    var c = 0.0;
    if ((f.ballCarrierId == a || f.ballCarrierId == b) && team(a) != team(b)) {
      c = carryWeight(s, t);
    }
    final w = s.windowAt(t);
    if (w != null) {
      final both =
          (w.actors.contains(a) && w.actors.contains(b)) ||
          (w.formation.contains(a) && w.formation.contains(b));
      if (both) c = math.max(c, _edge(t - w.start, w.end - t));
    }
    return c;
  }

  /// Whether [a] and [b] are meant to be close at all (see [contactIn]).
  static bool inContact(PitchScript s, PitchFrame f, int a, int b, double t) =>
      contactIn(s, f, a, b, t) > 0;

  /// How firmly the man on the ball is held at it, 0 to 1: fading in and
  /// out at the ends of his carry.
  static double carryWeight(PitchScript s, double t) {
    final ps = s.ballPhases;
    var lo = 0;
    var hi = ps.length - 1;
    while (lo < hi) {
      final mid = (lo + hi + 1) ~/ 2;
      if (ps[mid].t0 <= t) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }
    final p = ps[lo];
    if (p is! CarryPhase) return 0;
    return _edge(t - p.t0, p.t1 - t);
  }

  static double _edge(double sinceStart, double untilEnd) =>
      (math.min(sinceStart, untilEnd) / _fade).clamp(0.0, 1.0);

  static const double _fade = 0.2;

  /// Where [f]'s men are drawn (see [of]): the man on the ball held at it.
  /// A man just stepping on or about to leave the picture makes room only
  /// gradually, so his neighbours do not jump when he comes or goes.
  static Map<int, Offset2> frame(PitchScript s, PitchFrame f, double t) {
    final carrier = f.ballCarrierId;
    final spans = _spans[s] ??= _presence(s);
    double present(int id) {
      final span = spans[id];
      if (span == null) return 1;
      return _edge(t - span.$1, span.$2 - t);
    }

    return of(
      f.players,
      pinned: {if (carrier != null) carrier: carryWeight(s, t)},
      contact: (a, b) => contactIn(s, f, a, b, t),
      presence: {for (final id in f.players.keys) id: present(id)},
    );
  }

  static final Expando<Map<int, (double, double)>> _spans = Expando();

  /// Each man's first and last keyframe on the pitch, where it is not the
  /// script's own start or end.
  static Map<int, (double, double)> _presence(PitchScript s) {
    final out = <int, (double, double)>{};
    final frames = s.keyframes;
    for (var i = 0; i < s.actorList.length; i++) {
      double? first;
      double? last;
      for (final k in frames) {
        if (!k.present(i)) continue;
        first ??= k.t;
        last = k.t;
      }
      if (first == null || last == null) continue;
      final from = first <= s.start + 1e-9 ? double.negativeInfinity : first;
      final to = last >= s.totalSeconds - 1e-9 ? double.infinity : last;
      if (from.isInfinite && to.isInfinite) continue;
      out[s.actorList[i].playerId] = (from, to);
    }
    return out;
  }

  /// [at] eased apart. [pinned] says how firmly a man is held where he
  /// is (1 not moved at all); [contact] how far two are meant to be close
  /// (1: they may overlap up to [contactRoom]); [presence] how far a man
  /// is in the picture yet (0 to 1).
  static Map<int, Offset2> of(
    Map<int, Offset2> at, {
    Map<int, double> pinned = const {},
    double Function(int a, int b)? contact,
    Map<int, double> presence = const {},
    int passes = 16,
  }) {
    final ids = at.keys.toList()..sort();
    final n = ids.length;
    final base = [for (final id in ids) at[id]!];
    final w = 2 * DisplaySpacing.halfLength;
    // Normalised: one token is 1 each way.
    final hs = [for (final p in base) 2 * DisplaySpacing.halfAcross(p.y)];
    final xs = [for (final p in base) p.x / w];
    final ys = [for (var i = 0; i < n; i++) base[i].y / hs[i]];
    final ox = List<double>.filled(n, 0);
    final oy = List<double>.filled(n, 0);
    final free = [for (final id in ids) 1 - (pinned[id] ?? 0).clamp(0.0, 1.0)];
    final allow = List<List<double>>.generate(
      n,
      (i) => List<double>.generate(n, (j) {
        if (j <= i) return room;
        final base = contact == null
            ? room
            : room + (contactRoom - room) * contact(ids[i], ids[j]);
        // Somebody barely in the picture (stepping on, leaving) is room
        // for anybody.
        final p = math.min(presence[ids[i]] ?? 1, presence[ids[j]] ?? 1);
        return base + (1 - base) * (1 - p);
      }),
    );
    double smoothSign(double v) {
      final k = v * 6;
      return k > 20 ? 1 : (k < -20 ? -1 : (_tanh(k)));
    }

    for (var pass = 0; pass < passes; pass++) {
      final dx = List<double>.filled(n, 0);
      final dy = List<double>.filled(n, 0);
      for (var i = 0; i < n; i++) {
        for (var j = i + 1; j < n; j++) {
          final mobile = free[i] + free[j];
          if (mobile <= 1e-9) continue;
          final nx = (xs[i] + ox[i]) - (xs[j] + ox[j]);
          final ny = (ys[i] + oy[i]) - (ys[j] + oy[j]);
          final gx = 1 - nx.abs(), gy = 1 - ny.abs();
          if (gx <= 0 || gy <= 0) continue;
          final ov = gx * gy;
          final excess = ov - allow[i][j];
          if (excess <= 0) continue;
          // Which way out is read off where the two men really are, never
          // off the nudges so far: a crowd cannot talk itself into one
          // answer one frame and the opposite the next. Mostly along
          // whichever axis is nearer clear, smoothly.
          final rx = xs[i] - xs[j];
          final ry = ys[i] - ys[j];
          final px = smoothSign(rx) * (1 - ry.abs()).clamp(0.0, 1.0);
          final py =
              smoothSign(ry) * (1 - rx.abs()).clamp(0.0, 1.0) +
              (rx.abs() + ry.abs() < 1e-6 ? 0.1 : 0);
          final k = excess * _gain;
          final shareI = free[i] / mobile;
          final shareJ = free[j] / mobile;
          dx[i] += px * k * shareI;
          dy[i] += py * k * shareI;
          dx[j] -= px * k * shareJ;
          dy[j] -= py * k * shareJ;
        }
      }
      for (var i = 0; i < n; i++) {
        ox[i] = (ox[i] + dx[i]).clamp(-maxNudge, maxNudge);
        oy[i] = (oy[i] + dy[i]).clamp(-maxNudge, maxNudge);
      }
    }
    return {
      for (var i = 0; i < n; i++)
        ids[i]: Offset2(base[i].x + ox[i] * w, base[i].y + oy[i] * hs[i]),
    };
  }

  static double _tanh(double x) {
    final e = math.exp(2 * x);
    return (e - 1) / (e + 1);
  }
}
