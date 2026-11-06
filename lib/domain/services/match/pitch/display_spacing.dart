/// How much of the pitch a player's token covers on screen, so the story
/// layer can keep players visually apart and not only physically apart.
///
/// The Pitch view draws each man as a shirt token over a tilted, end-on
/// projection. On a phone one token covers about 5.8 m of pitch along its
/// length and 5.5 to 7.6 m across it, because depth is compressed by the
/// tilt, most of all at the far touchline. Two men 2 m apart therefore
/// stand on top of each other on screen. The figures come from
/// [PitchViewGeometry], the same constants the view's projection and its
/// token size read, for the phone pitch (the tightest case: a tablet draws
/// its tokens relatively smaller); `display_spacing_test.dart` checks them
/// against `PitchProjection` and `ActorsPainter` themselves. Pure Dart.
library;

import 'dart:math' as math;

import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/pitch_view_geometry.dart';

abstract final class DisplaySpacing {
  // The phone view the figures come from.
  static const double _viewW = PitchViewGeometry.phoneWidth;
  static const double _viewH = PitchViewGeometry.phoneHeight;
  static const double _tokenHalf = PitchViewGeometry.phoneToken;
  static const double _tilt = PitchViewGeometry.tilt;
  static const double _top = PitchViewGeometry.top;
  static const double _bottom = PitchViewGeometry.bottom;
  static const double _zoom = PitchViewGeometry.zoom;
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
/// - **Across the pitch only.** Nobody's depth ever changes for the
///   picture, so a drawn player is never behind his goal line when he is
///   not, and the drawn offside order is always the true one.
/// - **The ball's men are where they are.** The man on the ball is held
///   at it for his whole carry and let go over the first fifth of a second
///   of the ball leaving him; the man a ball is played to (a pass, a save,
///   a header) is held over the last fifth of a second of its flight. At
///   the strike, the arrival, the save and the header, he is drawn exactly
///   where he is.
/// - **Smooth.** No switching between ways out, and every hold and contact
///   fades in and out, so a token eases aside as a man comes near and back
///   as he leaves; it never jumps.
/// - **Contact.** Only men who touch may come closer ([contactRoom], at
///   least half a token apart): a challenge on the man with the ball (or
///   the man it is coming to, or leaving), a
///   shooter and the keeper, the two men of a foul, a blocked shot's or a
///   header's man and his marker, and a wall. Everybody else, the moment's
///   other men included, keeps [room].
///
/// Pure: the same frame always draws the same.
abstract final class Declutter {
  static const double room = 0.3;
  static const double contactRoom = 0.6;

  /// The furthest a token is drawn from its man, in tokens.
  static const double maxNudge = 0.55;

  /// How far the first pass moves toward clear; later passes move less
  /// and less.
  static const double _gain = 0.6;

  static const double _fade = 0.25;

  /// How sharply two men level across the pitch pick sides. Two crossing
  /// paths swap sides quickly here; [DeclutterEasing] spreads the swap
  /// over a few frames on screen.
  static const double _sideSlope = 12;

  static double _edge(double sinceStart, double untilEnd) =>
      (math.min(sinceStart, untilEnd) / _fade).clamp(0.0, 1.0);

  static int _phaseIndex(PitchScript s, double t) {
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
    return lo;
  }

  /// How firmly each man the ball concerns is held where he is at [t], 0
  /// to 1: the carrier through his carry, the passer letting go, the man
  /// it is played to taking hold.
  static Map<int, double> pins(PitchScript s, double t) {
    final i = _phaseIndex(s, t);
    final p = s.ballPhases[i];
    final out = <int, double>{};
    void hold(int? actor, double w) {
      if (actor == null || w <= 0) return;
      final id = s.actorList[actor].playerId;
      out[id] = math.max(out[id] ?? 0, w.clamp(0.0, 1.0));
    }

    switch (p) {
      case CarryPhase(:final carrier):
        // Held from the first touch when the ball was played to him (the
        // hold already came up over its flight); otherwise (a loose ball
        // picked up, a ball given to him after a cut) taking hold.
        final before = i > 0 ? s.ballPhases[i - 1] : null;
        final handed =
            (before is FlightPhase && before.toActor == carrier) ||
            (before is CarryPhase && before.carrier == carrier);
        hold(carrier, handed ? 1 : (t - p.t0) / _fade);
      case FlightPhase(:final fromActor, :final toActor):
        // A ball lying still is nobody's to hold.
        if (!p.resting) {
          hold(fromActor, 1 - (t - p.t0) / _fade);
          hold(toActor, 1 - (p.t1 - t) / _fade);
        }
    }
    // Whoever has the ball next, or strikes it (a dead ball's taker, a man
    // meeting a loose one), takes hold over the fifth of a second before.
    for (var j = i + 1; j < s.ballPhases.length; j++) {
      final next = s.ballPhases[j];
      if (next.t0 > t + _fade) break;
      final w = 1 - (next.t0 - t) / _fade;
      switch (next) {
        case CarryPhase(:final carrier):
          hold(carrier, w);
        case FlightPhase(:final fromActor):
          if (!next.resting) hold(fromActor, w);
      }
    }
    return out;
  }

  /// How far [a] and [b] are meant to be in touch in [f] at [t] of [s], 0
  /// to 1 (see the class comment), fading in and out over a fifth of a
  /// second at the edges of the carry or the moment.
  static double contactIn(
    PitchScript s,
    PitchFrame f,
    int a,
    int b,
    double t, {
    Map<int, double>? pins,
  }) {
    int team(int id) => s.actorList[s.actorIndexOf(id)!].teamNationId;
    final rivals = team(a) != team(b);
    var c = 0.0;
    if (rivals) {
      // A challenge: the man the ball is with (or coming to, or leaving)
      // and an opponent on him, as firmly as he is held at it.
      final held = pins ?? Declutter.pins(s, t);
      c = math.max(held[a] ?? 0, held[b] ?? 0);
    }
    final w = s.windowAt(t);
    if (w == null) return c;
    bool pair(int x, int y) => (a == x && b == y) || (a == y && b == x);
    var touch = w.formation.contains(a) && w.formation.contains(b);
    for (final m in w.moments) {
      switch (m) {
        case ShotMoment(:final shooterId, :final keeperId):
          if (keeperId != null && pair(shooterId, keeperId)) touch = true;
          // Blocked, or a header: the man and whoever marks him.
          final marked = m.outcome == ShotOutcome.blocked || m.header;
          if (marked && rivals && (a == shooterId || b == shooterId)) {
            touch = true;
          }
        case FoulMoment(:final foulerId, :final fouledId):
          if (pair(foulerId, fouledId)) touch = true;
        default:
          break;
      }
    }
    if (touch) c = math.max(c, _edge(t - w.start, w.end - t));
    return c;
  }

  /// Whether [a] and [b] are meant to be in touch at all.
  static bool inContact(PitchScript s, PitchFrame f, int a, int b, double t) =>
      contactIn(s, f, a, b, t) > 0;

  /// Where [f]'s men are drawn (see the class comment). A man just
  /// stepping on or about to leave the picture makes room only gradually,
  /// so his neighbours do not jump when he comes or goes.
  static Map<int, Offset2> frame(PitchScript s, PitchFrame f, double t) {
    final spans = _spans[s] ??= _presence(s);
    double present(int id) {
      final span = spans[id];
      if (span == null) return 1;
      return _edge(t - span.$1, span.$2 - t);
    }

    final held = pins(s, t);
    return of(
      f.players,
      pinned: held,
      contact: (a, b) => contactIn(s, f, a, b, t, pins: held),
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

  /// [at] eased apart across the pitch. [pinned] says how firmly a man is
  /// held where he is (1: not moved at all); [contact] how far two are in
  /// touch (1: they may overlap up to [contactRoom]); [presence] how far a
  /// man is in the picture yet (0 to 1).
  static Map<int, Offset2> of(
    Map<int, Offset2> at, {
    Map<int, double> pinned = const {},
    double Function(int a, int b)? contact,
    Map<int, double> presence = const {},
    int passes = 40,
  }) {
    final ids = at.keys.toList()..sort();
    final n = ids.length;
    final base = [for (final id in ids) at[id]!];
    final w = 2 * DisplaySpacing.halfLength;
    // Normalised: one token is 1 each way.
    final hs = [for (final p in base) 2 * DisplaySpacing.halfAcross(p.y)];
    final xs = [for (final p in base) p.x / w];
    final ys = [for (var i = 0; i < n; i++) base[i].y / hs[i]];
    final oy = List<double>.filled(n, 0);
    final free = [
      for (final id in ids) 1 - (pinned[id] ?? 0).clamp(0.0, 1.0),
    ];
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
      final k = v * _sideSlope;
      return k > 20 ? 1 : (k < -20 ? -1 : _tanh(k));
    }

    for (var pass = 0; pass < passes; pass++) {
      // Big steps first, then ever smaller ones, so a crowd settles on one
      // answer rather than rocking between two.
      final gain = _gain * (1 - pass / passes);
      final dy = List<double>.filled(n, 0);
      for (var i = 0; i < n; i++) {
        for (var j = i + 1; j < n; j++) {
          final mobile = free[i] + free[j];
          if (mobile <= 1e-9) continue;
          final gx = 1 - (xs[i] - xs[j]).abs();
          if (gx <= 0) continue;
          final ny = (ys[i] + oy[i]) - (ys[j] + oy[j]);
          final gy = 1 - ny.abs();
          if (gy <= 0) continue;
          final excess = gx * gy - allow[i][j];
          if (excess <= 0) continue;
          // Which side each goes is read off where the two really are,
          // never off the nudges so far: a crowd cannot talk itself into
          // one answer one frame and the opposite the next.
          final ry = ys[i] - ys[j];
          // Two men level across the pitch still part, by a fixed rule
          // (the lower id goes up), blended in smoothly as they level.
          final sg = smoothSign(ry);
          final side = sg + 0.1 * (1 - sg.abs());
          final k = excess * gain * side;
          dy[i] += k * free[i] / mobile;
          dy[j] -= k * free[j] / mobile;
        }
      }
      for (var i = 0; i < n; i++) {
        oy[i] = (oy[i] + dy[i]).clamp(-maxNudge, maxNudge);
      }
    }
    double drawnY(int i) {
      final y = base[i].y + oy[i] * hs[i];
      // A man on the pitch is drawn on it, or on the strip of grass just
      // past the touchline at most.
      final onPitch = base[i].y >= 0 && base[i].y <= PitchDims.width;
      return onPitch ? y.clamp(-1.5, PitchDims.width + 1.5) : y;
    }

    return {
      for (var i = 0; i < n; i++) ids[i]: Offset2(base[i].x, drawnY(i)),
    };
  }

  static double _tanh(double x) {
    final e = math.exp(2 * x);
    return (e - 1) / (e + 1);
  }
}

/// [Declutter] as played: each drawn token follows its nudge at a bounded
/// speed, so two men crossing paths, or a crowd settling the other way,
/// swap sides over a few frames rather than in one. A man held at the ball
/// is drawn exactly where Declutter has him (nothing is eased at a strike,
/// an arrival, a save or a header), and a jump in time (a seek, a cut, a
/// resume) starts afresh.
class DeclutterEasing {
  /// The fastest a nudge moves, in tokens per second.
  static const double rate = 4.5;

  final Map<int, double> _nudge = {};
  double? _t;

  Map<int, Offset2> frame(PitchScript s, PitchFrame f, double t) {
    final target = Declutter.frame(s, f, t);
    final last = _t;
    _t = t;
    final dt = last == null ? double.infinity : t - last;
    final fresh = dt <= 0 || dt > 0.1;
    final pins = Declutter.pins(s, t);
    final out = <int, Offset2>{};
    final seen = <int>{};
    target.forEach((id, p) {
      seen.add(id);
      final raw = f.players[id]!;
      final h = 2 * DisplaySpacing.halfAcross(raw.y);
      final want = (p.y - raw.y) / h;
      final had = _nudge[id];
      double now;
      if (fresh || had == null) {
        now = want;
      } else {
        // As the hold comes up the eased place gives way to the exact one:
        // fully held, he is exactly where Declutter has him.
        final pin = pins[id] ?? 0;
        final step = rate * dt;
        final eased = had + (want - had).clamp(-step, step);
        now = eased + (want - eased) * pin;
      }
      _nudge[id] = now;
      out[id] = Offset2(raw.x, raw.y + now * h);
    });
    _nudge.removeWhere((id, _) => !seen.contains(id));
    return out;
  }
}
