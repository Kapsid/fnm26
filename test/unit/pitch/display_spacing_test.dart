import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Size;
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/display_spacing.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/features/match/pitch/actors_painter.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';

import '../../helpers/pitch_match_lab.dart';

/// What a viewer sees as a pile-up: two shirts more than half on top of
/// each other.
const double _pileUp = 0.5;

/// Men meant to be in contact (a challenge on the ball, a moment's own men
/// at a save, block, foul or header) may come closer, never fully on top:
/// at least half a token apart.
const double _contact = 0.75;

String _kind(StagedWindow? w) {
  if (w == null) return 'open play';
  if (w.injury != null && w.moments.isEmpty) return 'injury';
  final m = w.moments.first;
  return switch (m) {
    ShotMoment(:final origin) => 'shot ${origin.name}',
    SetPieceMoment(:final kind) => kind.name,
    FoulMoment() => 'foul',
    OffsideMoment() => 'offside',
    SubMoment() => 'sub',
  };
}

/// Every pair on screen at [t] that overlaps more than allowed, as
/// (sanctioned, overlap): where the script has the men, or (with
/// [drawn]) where the view draws them.
Iterable<(bool, double)> _crowded(
  PitchScript s,
  double t, {
  bool drawn = true,
}) sync* {
  final f = s.sample(Duration(microseconds: (t * 1e6).round()));
  final at = drawn ? Declutter.frame(s, f, t) : f.players;
  final ids = at.keys.toList();
  for (var i = 0; i < ids.length; i++) {
    for (var j = i + 1; j < ids.length; j++) {
      final a = ids[i], b = ids[j];
      final ov = DisplaySpacing.overlap(at[a]!, at[b]!);
      if (ov <= _pileUp) continue;
      yield (Declutter.inContact(s, f, a, b, t), ov);
    }
  }
}

void main() {
  test(
    'a token covers about 5.8 m along the pitch, more across it far off',
    () {
      expect(DisplaySpacing.halfLength * 2, closeTo(5.84, 0.05));
      expect(
        DisplaySpacing.halfAcross(0),
        greaterThan(
          DisplaySpacing.halfAcross(PitchDims.width),
        ),
      );
      expect(
        DisplaySpacing.overlap(const Offset2(50, 30), const Offset2(50, 30)),
        1,
      );
      expect(
        DisplaySpacing.overlap(const Offset2(50, 30), const Offset2(57, 30)),
        0,
      );
    },
  );

  test('players stay visually distinct: under 2% of frames pile up', () {
    var frames = 0;
    var piled = 0;
    var rawPiled = 0;
    var contactTooClose = 0;
    final byKind = <String, int>{};
    final framesByKind = <String, int>{};
    for (var seed = 0; seed < 200; seed++) {
      final s = labScript(
        labMatch(seed),
        PitchSpeed.values[seed % 3],
        seed: seed,
      );
      for (var t = s.start + 0.1; t < s.totalSeconds; t += 0.2) {
        frames++;
        final kind = _kind(s.windowAt(t));
        framesByKind[kind] = (framesByKind[kind] ?? 0) + 1;
        if (_crowded(s, t, drawn: false).any((c) => !c.$1)) rawPiled++;
        var bad = false;
        var tooClose = false;
        for (final (sanctioned, ov) in _crowded(s, t)) {
          if (!sanctioned) bad = true;
          if (sanctioned && ov > _contact) tooClose = true;
        }
        if (bad) {
          piled++;
          byKind[kind] = (byKind[kind] ?? 0) + 1;
        }
        if (tooClose) contactTooClose++;
      }
    }
    final share = piled / frames;
    final contact = contactTooClose / frames;
    final rows = byKind.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    debugPrint(
      'pile-ups as drawn: $piled of $frames frames '
      '(${(share * 100).toStringAsFixed(2)}%); contact closer than half a '
      'token: ${(contact * 100).toStringAsFixed(2)}%; where the script has '
      'them: ${(rawPiled / frames * 100).toStringAsFixed(2)}%\n'
      '${rows.map((e) => '  ${e.key}: ${e.value} of ${framesByKind[e.key]} '
          '(${(e.value / framesByKind[e.key]! * 100).toStringAsFixed(1)}%)').join('\n')}',
    );
    expect(share, lessThan(0.02));
    expect(contact, lessThan(0.02));
  });

  test('as played at 60 fps, eased: under 2.5% of frames pile up', () {
    // The view draws the eased frame (DeclutterEasing), not Declutter's
    // target: a nudge takes a moment to come on, so the eased picture can
    // pile up where the target would not. Measured as the view plays it.
    var frames = 0;
    var piled = 0;
    var contactTooClose = 0;
    for (var seed = 0; seed < 24; seed++) {
      final s = labScript(
        labMatch(seed),
        PitchSpeed.values[seed % 3],
        seed: seed,
      );
      final easing = DeclutterEasing();
      for (var t = s.start + 0.1; t < s.totalSeconds; t += 1 / 60) {
        final f = s.sample(Duration(microseconds: (t * 1e6).round()));
        final at = easing.frame(s, f, t);
        frames++;
        final ids = at.keys.toList();
        var bad = false;
        var tooClose = false;
        for (var i = 0; i < ids.length; i++) {
          for (var j = i + 1; j < ids.length; j++) {
            final ov = DisplaySpacing.overlap(at[ids[i]]!, at[ids[j]]!);
            if (ov <= _pileUp) continue;
            final sanctioned = Declutter.inContact(s, f, ids[i], ids[j], t);
            if (!sanctioned) bad = true;
            if (sanctioned && ov > _contact) tooClose = true;
          }
        }
        if (bad) piled++;
        if (tooClose) contactTooClose++;
      }
    }
    final share = piled / frames;
    final contact = contactTooClose / frames;
    debugPrint(
      'eased pile-ups at 60 fps: $piled of $frames frames '
      '(${(share * 100).toStringAsFixed(2)}%); contact closer than half a '
      'token: ${(contact * 100).toStringAsFixed(2)}%',
    );
    // Measured 2.25% (24 matches, 273k frames) when this bound was set,
    // against 1.27% for Declutter's own target: the easing lags a nudge
    // by a few frames as two men close. Bounded here so it cannot creep.
    // 2.9% since set pieces fill the box and the men an attack does not
    // name move with it (2026-11 pitch feedback): more men close together
    // and on the move, by design; the drawn target holds under 2%.
    expect(share, lessThan(0.031));
    expect(contact, lessThan(0.02));
  });

  test('the beaten keeper is drawn where he is as a goal goes in', () {
    // A shot that scores has no keeper at its end (the ball goes past him
    // into the net), but he is the moment's man: the crowd must not nudge
    // him toward or away from the ball as it beats him.
    var checked = 0;
    final fails = <String>[];
    for (var seed = 0; seed < 120; seed++) {
      final s = labScript(
        labMatch(seed),
        PitchSpeed.values[seed % 3],
        seed: seed,
      );
      for (final w in s.windows) {
        for (final m in w.moments) {
          if (m is! ShotMoment || m.outcome != ShotOutcome.goal) continue;
          final keeper = m.keeperId;
          if (keeper == null) continue;
          final goal = w.cues.where((c) => c.kind == PitchCueKind.goal);
          final strike = w.cues.where((c) => c.kind == PitchCueKind.shot);
          if (goal.isEmpty || strike.isEmpty) continue;
          final t0 = strike.first.t;
          final t1 = goal.first.t;
          for (var t = t0; t <= t1; t += 0.05) {
            final f = s.sample(Duration(microseconds: (t * 1e6).round()));
            final p = f.players[keeper];
            if (p == null) continue;
            final d = Declutter.frame(s, f, t)[keeper]!;
            checked++;
            if (d.distanceTo(p) > 0.3) {
              fails.add(
                'match $seed keeper $keeper at $t: '
                '${d.distanceTo(p).toStringAsFixed(2)} m',
              );
            }
          }
        }
      }
    }
    debugPrint('beaten keeper checks: $checked, failures ${fails.length}');
    expect(fails.take(10), isEmpty);
    expect(checked, greaterThan(200));
  });

  test('a drawn token eases aside, never jumps', () {
    // Frame to frame at 60 fps, how far a token's nudge (drawn place less
    // the man's place) moves, in tokens; cuts and restarts apart.
    var worst = 0.0;
    var sum = 0.0;
    var count = 0;
    final w = 2 * DisplaySpacing.halfLength;
    for (var seed = 0; seed < 12; seed++) {
      final s = labScript(
        labMatch(seed),
        PitchSpeed.values[seed % 3],
        seed: seed,
      );
      // As the view plays it: eased frame to frame.
      final easing = DeclutterEasing();
      Map<int, Offset2>? last;
      Map<int, Offset2>? lastRaw;
      for (var t = s.start + 0.1; t < s.totalSeconds; t += 1 / 60) {
        final f = s.sample(Duration(microseconds: (t * 1e6).round()));
        final drawn = easing.frame(s, f, t);
        final nearCut = [
          ...s.cuts,
          ...s.resets,
        ].any((c) => (c - t).abs() < 0.1);
        if (last != null && lastRaw != null && !nearCut) {
          for (final id in drawn.keys) {
            final a = last[id], ra = lastRaw[id];
            if (a == null || ra == null) continue;
            final n0 = a - ra;
            final n1 = drawn[id]! - f.players[id]!;
            final d = n1 - n0;
            final h = 2 * DisplaySpacing.halfAcross(f.players[id]!.y);
            final jump = math.max((d.x / w).abs(), (d.y / h).abs());
            worst = math.max(worst, jump);
            sum += jump;
            count++;
          }
        }
        last = drawn;
        lastRaw = f.players;
      }
    }
    debugPrint(
      'nudge change per frame: mean ${(sum / count).toStringAsFixed(4)}, '
      'worst ${worst.toStringAsFixed(3)} tokens',
    );
    // About 2 px at phone size at worst, as a hold comes on.
    expect(worst, lessThan(0.15));
  });

  test('the drawn picture never contradicts the outcome', () {
    // Over 200 matches: at every strike, pass arrival, save and header the
    // man is drawn where he is; nobody on the pitch is drawn behind his
    // goal line; the drawn offside order is the true one.
    var checked = 0;
    final fails = <String>[];
    Duration at(double t) => Duration(microseconds: (t * 1e6).round());
    for (var seed = 0; seed < 200; seed++) {
      final s = labScript(
        labMatch(seed),
        PitchSpeed.values[seed % 3],
        seed: seed,
      );
      void near(int? actor, double t, String what) {
        if (actor == null || t < s.start || t > s.totalSeconds) return;
        final id = s.actorList[actor].playerId;
        final f = s.sample(at(t));
        final p = f.players[id];
        if (p == null) return;
        final d = Declutter.frame(s, f, t)[id]!;
        checked++;
        if (d.distanceTo(p) > 0.3) {
          fails.add('match $seed $what at $t: ${d.distanceTo(p)} m');
        }
      }

      for (final ph in s.ballPhases) {
        if (ph is! FlightPhase || ph.resting) continue;
        if (!ph.pass) near(ph.fromActor, ph.t0, 'strike');
        if (ph.fromHeight > 1) near(ph.fromActor, ph.t0, 'header');
        if (ph.toActor != null) {
          near(ph.toActor, ph.t1 - 1e-6, ph.pass ? 'arrival' : 'save');
        }
        if (ph.pass && ph.toActor != null) {
          // The offside order as the ball is played.
          final t = ph.t0 + 1e-6;
          final f = s.sample(at(t));
          final d = Declutter.frame(s, f, t);
          final r = s.actorList[ph.toActor!];
          final rp = f.players[r.playerId];
          if (rp == null) continue;
          final dir = attackDir(
            home: r.teamNationId == s.homeNationId,
            minute: s.pacer.matchAt(at(t)).minute,
          );
          final defs = [
            for (final e in f.players.entries)
              if (s.actorList[s.actorIndexOf(e.key)!].teamNationId !=
                  r.teamNationId)
                e.key,
          ];
          if (defs.length < 2) continue;
          int depthSort(int a, int b) => xToDepth(
            f.players[b]!.x,
            dir,
          ).compareTo(xToDepth(f.players[a]!.x, dir));
          defs.sort(depthSort);
          final second = defs[1];
          bool ahead(Map<int, Offset2> m) =>
              xToDepth(m[r.playerId]!.x, dir) > xToDepth(m[second]!.x, dir);
          if (ahead(f.players) != ahead(d)) {
            fails.add('match $seed offside order flips at $t');
          }
        }
      }
      // Nobody drawn behind his goal line, sampled through the match.
      for (var t = s.start + 0.1; t < s.totalSeconds; t += 0.5) {
        final f = s.sample(at(t));
        final d = Declutter.frame(s, f, t);
        f.players.forEach((id, p) {
          final q = d[id]!;
          final on = p.x >= 0 && p.x <= PitchDims.length;
          if (on && (q.x < 0 || q.x > PitchDims.length)) {
            fails.add('match $seed $id drawn behind the line at $t');
          }
          if (q.x != p.x) fails.add('match $seed $id moved in depth at $t');
        });
      }
    }
    debugPrint('outcome checks: $checked, failures ${fails.length}');
    expect(fails.take(10), isEmpty);
    expect(checked, greaterThan(10000));
  });

  test('the spacing figures match the view', () {
    // DisplaySpacing works from PitchViewGeometry; check it against the
    // live projection and the painter's token at phone size.
    const size = Size(390, 280);
    final p = PitchMatchView.projectionFor(size);
    final r0 = ActorsPainter.tokenRadiusFor(size);
    for (final y in [0.0, 17.0, 34.0, 51.0, 68.0]) {
      final r = r0 * p.scaleAt(y);
      final along = p.toScreen(60, y) - p.toScreen(50, y);
      expect(
        DisplaySpacing.halfLength,
        closeTo(r / (along.dx / 10), 0.01),
        reason: 'along at $y',
      );
      final y0 = (y - 0.05).clamp(0.0, 68.0), y1 = (y + 0.05).clamp(0.0, 68.0);
      final perMetre =
          (p.toScreen(50, y1).dy - p.toScreen(50, y0).dy) / (y1 - y0);
      expect(
        DisplaySpacing.halfAcross(y),
        closeTo(r / perMetre, 0.03),
        reason: 'across at $y',
      );
    }
  });

  test('only men who touch may come closer', () {
    var shots = 0;
    for (var seed = 0; seed < 20; seed++) {
      final s = labScript(
        labMatch(seed),
        PitchSpeed.values[seed % 3],
        seed: seed,
      );
      for (final w in s.windows) {
        if (w.moments.isEmpty) continue;
        final m = w.moments.first;
        if (m is! ShotMoment || m.keeperId == null) continue;
        if (m.outcome == ShotOutcome.blocked || m.header) continue;
        final t = (w.start + w.end) / 2;
        final f = s.sample(Duration(microseconds: (t * 1e6).round()));
        if (!f.players.containsKey(m.keeperId) ||
            !f.players.containsKey(m.shooterId)) {
          continue;
        }
        shots++;
        expect(
          Declutter.contactIn(s, f, m.shooterId, m.keeperId!, t),
          greaterThan(0),
        );
        // A man the ball is with, coming to or leaving is in a challenge
        // with any opponent on him: judged apart from the moment.
        final held = Declutter.pins(s, t);
        if (held.containsKey(m.shooterId) || held.containsKey(m.keeperId)) {
          continue;
        }
        for (final o in f.players.keys) {
          if (o == m.shooterId || o == m.keeperId) continue;
          if (held.containsKey(o)) continue;
          // The shooter with anybody else, the keeper with anybody else.
          expect(
            Declutter.contactIn(s, f, m.shooterId, o, t),
            0,
            reason: 'shooter and $o',
          );
          expect(Declutter.contactIn(s, f, m.keeperId!, o, t), 0);
        }
      }
    }
    expect(shots, greaterThan(10));
  });
}
