import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/moment_staging.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';

import '../../helpers/pitch_match_lab.dart';

Duration _at(double t) => Duration(microseconds: (t * 1e6).round());

/// Who stands where at a dead ball, as the side taking it attacks: per side
/// the outfield men inside the attacking third and outside it, and how far
/// out each keeper is.
typedef _Shape = ({
  int attackersIn,
  int attackersOut,
  int defendersIn,
  int defendersOut,
  double attackingKeeper,
  double defendingKeeper,
});

/// The kick of [sp] in its window: the taker's first ball off the spot.
FlightPhase? _kick(PitchScript s, StagedWindow w, SetPieceMoment sp) {
  final ti = s.actorIndexOf(sp.takerId);
  for (final p in s.ballPhases) {
    if (p is! FlightPhase || p.resting) continue;
    if (p.t0 < w.start - 1e-9 || p.t0 > w.end + 3) continue;
    if (p.fromActor != ti) continue;
    // A corner from the arc, never a ball lying out of play.
    final arc =
        (p.from.x < 1.5 || p.from.x > PitchDims.length - 1.5) &&
        (p.from.y < 1.5 || p.from.y > PitchDims.width - 1.5);
    if (sp.kind == SetPieceKind.corner && !arc) continue;
    final before = s.ballPhases[s.ballPhases.indexOf(p) - 1];
    final still =
        before is FlightPhase && before.toActor == null && before.to == p.from;
    final atCut = s.cuts.any((c) => (c - p.t0).abs() < 1e-6);
    if (still || atCut) return p;
  }
  return null;
}

_Shape _shape(PitchScript s, SetPieceMoment sp, double t) {
  final f = s.sample(_at(t + 2e-6));
  final m = s.pacer.matchAt(_at(t + 1e-4)).minute;
  final dir = attackDir(home: sp.teamNationId == s.homeNationId, minute: m);
  var ai = 0, ao = 0, di = 0, dO = 0;
  var ak = 0.0, dk = 0.0;
  f.players.forEach((id, p) {
    // A man walking off, or about to (a substitution due), is out of it.
    final dep = s.departures[id];
    if (dep != null && dep <= t + 10) return;
    final atk =
        s.actorList[s.actorIndexOf(id)!].teamNationId == sp.teamNationId;
    final depth = xToDepth(p.x, dir);
    if (f.keepers.contains(id)) {
      if (atk) {
        ak = depth;
      } else {
        dk = PitchDims.length - depth;
      }
      return;
    }
    if (id == sp.takerId) return;
    final inThird = depth > PitchDims.length * 2 / 3;
    if (atk) {
      inThird ? ai++ : ao++;
    } else {
      inThird ? di++ : dO++;
    }
  });
  return (
    attackersIn: ai,
    attackersOut: ao,
    defendersIn: di,
    defendersOut: dO,
    attackingKeeper: ak,
    defendingKeeper: dk,
  );
}

void main() {
  test(
    'at a corner both sides are in the attacking third, a few kept back',
    () {
      var corners = 0;
      for (var seed = 0; seed < 40; seed++) {
        final m = labMatch(seed);
        final speed = PitchSpeed.values[seed % PitchSpeed.values.length];
        final s = labScript(m, speed, seed: seed);
        for (final w in s.windows) {
          final sp = w.moments.firstOrNull;
          if (sp is! SetPieceMoment || sp.kind != SetPieceKind.corner) continue;
          final kick = _kick(s, w, sp);
          if (kick == null) continue;
          final at = _shape(s, sp, kick.t0);
          final where = 'match $seed ${s.minuteLabel(kick.t0)}: $at';
          corners++;
          // The attackers: all in or around the area but one to three left
          // back as cover.
          expect(at.attackersOut, inInclusiveRange(1, 3), reason: where);
          expect(at.attackersIn, greaterThanOrEqualTo(4), reason: where);
          // The defenders: in their area, at most one left up as an outlet.
          expect(at.defendersOut, lessThanOrEqualTo(2), reason: where);
          // The keepers stay home.
          expect(at.defendingKeeper, lessThan(6), reason: where);
          expect(
            at.attackingKeeper,
            lessThan(PitchDims.boxDepth),
            reason: where,
          );
        }
      }
      expect(corners, greaterThan(50));
    },
  );

  test('at a free kick near the area both sides come up for it', () {
    var kicks = 0;
    for (var seed = 0; seed < 40; seed++) {
      final m = labMatch(seed);
      final speed = PitchSpeed.values[seed % PitchSpeed.values.length];
      final s = labScript(m, speed, seed: seed);
      for (final w in s.windows) {
        final sp = w.moments.firstOrNull;
        if (sp is! SetPieceMoment || sp.kind != SetPieceKind.freeKick) continue;
        final kick = _kick(s, w, sp);
        if (kick == null) continue;
        final m = s.pacer.matchAt(_at(kick.t0 + 1e-4)).minute;
        final dir = attackDir(
          home: sp.teamNationId == s.homeNationId,
          minute: m,
        );
        if (xToDepth(kick.from.x, dir) < 75) continue;
        final at = _shape(s, sp, kick.t0);
        final where = 'match $seed ${s.minuteLabel(kick.t0)}: $at';
        kicks++;
        expect(at.attackersOut, inInclusiveRange(1, 3), reason: where);
        expect(at.defendersOut, lessThanOrEqualTo(2), reason: where);
        expect(at.attackingKeeper, lessThan(PitchDims.boxDepth), reason: where);
      }
    }
    expect(kicks, greaterThan(20));
    expect(wallDistance, 9.15);
  });
}
