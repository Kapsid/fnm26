/// Where shots and goals come from: what the engine records (a shot's
/// [PitchZone]) and what the Pitch view draws (where the shooter strikes
/// the ball), against real football's mix: most goals from inside the box,
/// a good share from close in, the odd one from distance, and a striker
/// through on goal finishing mostly from inside the box.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';

import '../../helpers/pitch_match_lab.dart';

Duration _at(double t) => Duration(microseconds: (t * 1e6).round());

/// A spot's band, in its attacking frame (depth toward goal, lateral).
String _band(double depth, double lat) {
  if (depth >= PitchDims.length - 5.5 && lat.abs() <= 9.16) return 'six';
  if (depth >= PitchDims.length - 16.5 && lat.abs() <= 20.16) return 'box';
  return 'out';
}

String _zoneBand(PitchZone z) => switch (z) {
  PitchZone.sixYard => 'six',
  PitchZone.boxCentre || PitchZone.boxLeft || PitchZone.boxRight => 'box',
  _ => 'out',
};

class _Tally {
  final shots = <String, int>{};
  final goals = <String, int>{};
  void add(String band, {required bool goal}) {
    shots[band] = (shots[band] ?? 0) + 1;
    if (goal) goals[band] = (goals[band] ?? 0) + 1;
  }

  int get nShots => shots.values.fold(0, (a, b) => a + b);
  int get nGoals => goals.values.fold(0, (a, b) => a + b);
  double shotShare(String b) => (shots[b] ?? 0) / nShots;
  double goalShare(String b) => (goals[b] ?? 0) / nGoals;
  double conv(String b) => (goals[b] ?? 0) / ((shots[b] ?? 0) + 1e-9);

  @override
  String toString() => ['six', 'box', 'out'].map(_row).join(' | ');

  String _row(String b) {
    String pc(double v) => '${(v * 100).toStringAsFixed(1)}%';
    return '$b: shots ${pc(shotShare(b))} goals ${pc(goalShare(b))} '
        'conv ${pc(conv(b))}';
  }
}

/// The strike in window [w]: the shooter's ball to nobody or to one of
/// theirs. Null when the picture never shows it (cut straight past).
FlightPhase? _strike(PitchScript s, StagedWindow w, ShotMoment m) {
  final si = s.actorIndexOf(m.shooterId);
  for (final p in s.ballPhases) {
    if (p is! FlightPhase || p.resting) continue;
    if (p.t0 < w.start - 1e-9 || p.t0 > w.end + 1) continue;
    final to = p.toActor;
    final theirs = to == null || s.actorList[to].teamNationId != m.teamNationId;
    if (p.fromActor == si && !p.pass && theirs) return p;
  }
  return null;
}

void main() {
  test('the engine records most open-play goals in the box', () {
    final open = _Tally();
    final all = _Tally();
    final origins = <String, int>{};
    final originGoals = <String, int>{};
    var matches = 0;
    var goals = 0;
    for (var seed = 0; seed < 2000; seed++) {
      final m = labMatch(seed);
      matches++;
      for (final s in m.result.moments.whereType<ShotMoment>()) {
        final g = s.outcome == ShotOutcome.goal;
        if (g) goals++;
        final b = _zoneBand(s.zone);
        all.add(b, goal: g);
        if (s.origin == ShotOrigin.openPlay && !s.header) open.add(b, goal: g);
        final o = s.header ? '${s.origin.name}/header' : s.origin.name;
        origins[o] = (origins[o] ?? 0) + 1;
        if (g) originGoals[o] = (originGoals[o] ?? 0) + 1;
      }
    }
    // The measured mix, for the record of a run.
    // ignore: avoid_print
    print(
      'engine, $matches matches, ${(goals / matches).toStringAsFixed(2)} '
      'goals a match\n  open play (feet): $open\n  all shots: $all\n'
      '  shots by origin $origins\n  goals by origin $originGoals',
    );
    // Real football: about 80-85% of goals from inside the box, a good
    // share of them from close in, the rest from distance. Measured
    // 2026-11-12, before the fix: 47.5% of all goals and 66% of open-play
    // ones from outside the box, every zone converting alike (about 14%).
    expect(all.goalShare('out'), inInclusiveRange(0.10, 0.25), reason: '$all');
    expect(all.goalShare('six'), inInclusiveRange(0.12, 0.40), reason: '$all');
    expect(open.goalShare('out'), inInclusiveRange(0.10, 0.28));
    // Shots from distance stay a real part of the game.
    expect(open.shotShare('out'), inInclusiveRange(0.30, 0.55));
    // Closer in converts better.
    expect(open.conv('six'), greaterThan(open.conv('box')));
    expect(open.conv('box'), greaterThan(1.8 * open.conv('out')));
  });

  test('the Pitch view draws most goals in the box, breakaways finished '
      'close in', () {
    final drawn = _Tally();
    final through = _Tally();
    final alone = _Tally();
    var missing = 0;
    for (var seed = 0; seed < 160; seed++) {
      final m = labMatch(seed);
      final speed = PitchSpeed.values[seed % PitchSpeed.values.length];
      final s = labScript(m, speed, seed: seed);
      for (final w in s.windows) {
        final first = w.moments.whereType<ShotMoment>().firstOrNull;
        if (first == null ||
            first.origin != ShotOrigin.openPlay ||
            first.header) {
          continue;
        }
        final strike = _strike(s, w, first);
        if (strike == null) {
          missing++;
          continue;
        }
        final dir = attackDir(
          home: first.teamNationId == s.homeNationId,
          minute: s.pacer.matchAt(_at(w.start + 1e-4)).minute,
        );
        double depth(Offset2 p) => xToDepth(p.x, dir);
        double lat(Offset2 p) => (p.y - PitchDims.width / 2) * dir;
        final d = depth(strike.from);
        final b = _band(d, lat(strike.from));
        final g = first.outcome == ShotOutcome.goal;
        drawn.add(b, goal: g);
        // Through on goal: no outfielder of theirs between him and goal.
        var ahead = 0;
        for (var i = 0; i < s.actorList.length; i++) {
          final a = s.actorList[i];
          if (a.teamNationId == first.teamNationId || a.keeper) continue;
          final (pos, _) = s.actorAt(i, strike.t0);
          if (depth(pos) > d + 0.5) ahead++;
        }
        if (ahead == 0) alone.add(b, goal: g);
        // A ball played in behind for him to run onto.
        final si = s.actorIndexOf(first.shooterId);
        final last = s.ballPhases
            .whereType<FlightPhase>()
            .where(
              (p) =>
                  p.toActor == si &&
                  p.pass &&
                  p.t0 >= w.start - 1e-9 &&
                  p.t1 <= strike.t0 + 1e-9,
            )
            .lastOrNull;
        // Into the space ahead of him, forward, and he runs on to meet it
        // (as attack_variety_test reads a through ball).
        final runFrom = last == null ? null : s.actorAt(si!, last.t0).$1;
        if (last != null &&
            depth(last.to) - depth(last.from) >= 8 &&
            depth(last.to) - depth(runFrom!) >= 3) {
          through.add(b, goal: g);
        }
      }
    }
    // The measured mix, for the record of a run.
    // ignore: avoid_print
    print(
      'drawn open play (feet), ${drawn.nShots} shots, $missing not shown\n'
      '  all: $drawn\n  through balls (${through.nShots}): $through\n'
      '  alone on goal (${alone.nShots}): $alone',
    );
    // Measured 2026-11-12, before the fix: 72% of the goals drawn from
    // outside the box, 4.5% from the six-yard area, 74% of the through
    // balls and 48% of the men alone on goal shooting from outside it.
    expect(
      drawn.goalShare('out'),
      inInclusiveRange(0.10, 0.32),
      reason: '$drawn',
    );
    expect(drawn.goalShare('six'), greaterThan(0.08), reason: '$drawn');
    expect(drawn.shotShare('out'), inInclusiveRange(0.30, 0.60));
    // Put through or alone on goal, he mostly finishes it in the box, but
    // not always: the odd one is still struck from distance.
    expect(through.shotShare('out'), inInclusiveRange(0.03, 0.35));
    expect(alone.shotShare('out'), inInclusiveRange(0.03, 0.30));
    expect(alone.goalShare('out'), lessThan(0.25), reason: '$alone');
  }, tags: 'slow');
}
