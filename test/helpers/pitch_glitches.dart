/// The glitch hunt: one match's picture read back for the things a viewer
/// calls "odd" that the validator's hard invariants let through. Each kind
/// is counted, with the worst example kept, so a lab run says how often a
/// match shows it and where to look.
///
/// - **pass to nobody**: a pass lands more than 2.5 m from its receiver.
/// - **shot from nowhere**: a shot struck from further than 40 m out.
/// - **ball off the pitch**: the ball more than 2 m outside the lines in
///   open play (a restart, a goal and a staged moment apart).
/// - **ball through a man**: a ground pass that runs within 0.45 m of an
///   opponent's feet and on past him.
/// - **sprinting backwards**: a man running over 5.5 m/s for half a second
///   or more with his back to where he runs.
/// - **keeper off his area**: a keeper over 18 m out in open play.
/// - **frozen in an attack**: an outfield man who stands stock still (under
///   0.2 m/s) for 3 s or more of open play.
library;

import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';

Duration _at(double t) => Duration(microseconds: (t * 1e6).round());

/// The glitches of one script.
class PitchGlitches {
  PitchGlitches(this.s, this.label);

  final PitchScript s;
  final String label;
  final Map<String, int> counts = {};
  final Map<String, List<String>> examples = {};

  void _hit(String kind, double t, String what) {
    counts[kind] = (counts[kind] ?? 0) + 1;
    final ex = examples.putIfAbsent(kind, () => []);
    if (ex.length < 3) {
      ex.add('$label ${s.minuteLabel(t)} (t ${t.toStringAsFixed(2)}): $what');
    }
  }

  bool _staged(double t) => s.windowAt(t) != null;

  bool _nearCut(double t, [double within = 0.3]) =>
      [...s.cuts, ...s.resets].any((c) => (c - t).abs() < within);

  bool _nearRestart(double t) =>
      s.restarts.any((r) => t >= r.out - 1.0 && t <= r.taken + 1.0);

  int _dir(int nation, double t) => attackDir(
    home: nation == s.homeNationId,
    minute: s.pacer.matchAt(_at(t + 1e-4)).minute,
  );

  void run() {
    _passes();
    _ballOut();
    _running();
  }

  void _passes() {
    for (final p in s.ballPhases) {
      if (p is! FlightPhase || p.resting) continue;
      final to = p.toActor;
      if (to != null && p.pass) {
        final (at, _) = s.actorAt(to, p.t1);
        final d = at.distanceTo(p.to);
        if (d > 2.5 && !_nearCut(p.t1)) {
          _hit(
            'pass to nobody',
            p.t1,
            'pass lands ${d.toStringAsFixed(1)} m from its man',
          );
        }
        // Through a man: a ground pass running over an opponent's feet.
        if (p.peak < 0.5 && p.fromHeight < 0.5) {
          final from = p.fromActor;
          final side = s.actorList[from ?? to].teamNationId;
          for (var k = 1; k < 10; k++) {
            final u = k / 10;
            final t = p.t0 + (p.t1 - p.t0) * u;
            final b = Offset2.lerp(p.from, p.to, u);
            for (var i = 0; i < s.actorList.length; i++) {
              if (s.actorList[i].teamNationId == side) continue;
              final kf = s.keyframes[_frame(t)];
              if (!kf.present(i)) continue;
              final (q, _) = s.actorAt(i, t);
              if (q.distanceTo(b) < 0.45 && b.distanceTo(p.to) > 3) {
                final lost = s.actorList[to].teamNationId != side
                    ? ' (turnover)'
                    : '';
                _hit(
                  _staged(p.t0)
                      ? 'ball through a man (staged)$lost'
                      : 'ball through a man$lost',
                  t,
                  'past ${s.actorList[i].playerId} '
                  '${s.windowAt(p.t0)?.moments.firstOrNull.runtimeType}',
                );
                k = 10;
                break;
              }
            }
          }
        }
      }
      // A shot: no receiver (or the keeper), struck at a goal.
      final shot =
          !p.pass &&
          p.fromActor != null &&
          (p.to.x < 1.5 || p.to.x > PitchDims.length - 1.5) &&
          (p.to.y - PitchDims.width / 2).abs() < 12;
      if (shot) {
        final goalX = p.to.x < 1.5 ? 0.0 : PitchDims.length;
        final d = p.from.distanceTo(Offset2(goalX, PitchDims.width / 2));
        if (d > 40) {
          final w = s.windowAt(p.t0 + 1e-6);
          _hit(
            'shot from nowhere',
            p.t0,
            'struck ${d.toStringAsFixed(0)} m out by '
                '${s.actorList[p.fromActor!].playerId} to ${p.to} '
                'in ${w?.moments.firstOrNull}',
          );
        }
      }
    }
  }

  int _frame(double t) {
    var lo = 0;
    var hi = s.keyframes.length - 1;
    while (lo < hi) {
      final mid = (lo + hi + 1) ~/ 2;
      if (s.keyframes[mid].t <= t) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }
    return lo;
  }

  void _ballOut() {
    var was = false;
    for (var t = s.start; t < s.totalSeconds; t += 0.1) {
      final (b, _) = s.ballAt(t);
      final out =
          b.x < -2 ||
          b.x > PitchDims.length + 2 ||
          b.y < -2 ||
          b.y > PitchDims.width + 2;
      final excused =
          _staged(t) || _nearRestart(t) || _nearCut(t, 1.5) || _afterGoal(t);
      if (out && !excused && !was) {
        _hit(
          'ball off the pitch',
          t,
          'ball at (${b.x.toStringAsFixed(1)}, ${b.y.toStringAsFixed(1)})',
        );
      }
      was = out;
    }
  }

  bool _afterGoal(double t) {
    for (final w in s.windows) {
      if (t >= w.start && t < w.end + 4) {
        for (final c in w.cues) {
          if (c.kind == PitchCueKind.goal) return true;
        }
      }
    }
    return false;
  }

  void _running() {
    final n = s.actorList.length;
    final back = List<double>.filled(n, 0);
    final still = List<double>.filled(n, 0);
    final frames = s.keyframes;
    for (var k = 0; k + 1 < frames.length; k++) {
      final a = frames[k];
      final b = frames[k + 1];
      final dt = b.t - a.t;
      if (dt <= 1e-9) {
        back.fillRange(0, n, 0);
        still.fillRange(0, n, 0);
        continue;
      }
      final staged = _staged(a.t);
      for (var i = 0; i < n; i++) {
        if (!a.present(i) || !b.present(i)) {
          back[i] = 0;
          still[i] = 0;
          continue;
        }
        final id = s.actorList[i].playerId;
        final dep = s.departures[id];
        if (dep != null && dep <= a.t) continue;
        final v = (b.at(i) - a.at(i)) * (1 / dt);
        final speed = v.length;
        if (speed > 5.5) {
          final face = Offset2.fromAngle(a.facing[i], 1);
          final cos = (v.x * face.x + v.y * face.y) / speed;
          back[i] = cos < -0.5 ? back[i] + dt : 0;
          if (back[i] >= 0.5 && back[i] < 0.5 + dt + 1e-9) {
            _hit('sprinting backwards', a.t, 'player $id');
          }
        } else {
          back[i] = 0;
        }
        // Keeper off his area in open play.
        if (a.keeper(i) && !staged) {
          final dir = _dir(s.actorList[i].teamNationId, a.t);
          final d = xToDepth(a.xs[i], dir);
          if (d > 18 && !_nearCut(a.t, 1)) {
            _hit('keeper off his area', a.t, '$id ${d.toStringAsFixed(1)} m');
          }
        }
        if (!a.keeper(i) && !staged && speed < 0.2) {
          still[i] += dt;
          if (still[i] >= 3 && still[i] < 3 + dt + 1e-9) {
            _hit('frozen in open play', a.t, 'player $id');
          }
        } else {
          still[i] = 0;
        }
      }
    }
  }
}

/// [what] summed over [all], each with its first example.
String glitchReport(List<PitchGlitches> all) {
  final sum = <String, int>{};
  final ex = <String, List<String>>{};
  final matches = <String, int>{};
  for (final g in all) {
    g.counts.forEach((k, v) {
      sum[k] = (sum[k] ?? 0) + v;
      matches[k] = (matches[k] ?? 0) + 1;
    });
    g.examples.forEach((k, v) {
      final l = ex.putIfAbsent(k, () => []);
      for (final e in v) {
        if (l.length < 6) l.add(e);
      }
    });
  }
  final keys = sum.keys.toList()..sort();
  return [
    'glitches over ${all.length} matches:',
    for (final k in keys)
      '  $k: ${sum[k]} (in ${matches[k]} matches)\n    ${ex[k]!.join('\n    ')}',
    if (keys.isEmpty) '  none',
  ].join('\n');
}
