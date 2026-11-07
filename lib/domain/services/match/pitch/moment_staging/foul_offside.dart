part of '../moment_staging.dart';

/// A foul worth a card: the fouled man on the ball, the fouler closing in
/// and bringing him down, play stopped, the card. The ball is left on the
/// spot when its free kick is staged next; otherwise the fouled side takes
/// it quickly.
class _FoulPlan extends _Plan {
  _FoulPlan(StagingContext c, this.m) : super(c, m.teamNationId) {
    final idx = m.cardEventIndex;
    if (idx != null && idx >= 0 && idx < c.events.length) {
      red = c.events[idx].type == MatchEventType.redCard;
    }
    final n = c.next;
    final nm = n == null || n.moments.isEmpty ? null : n.moments.first;
    leaveBall =
        n != null &&
        n.start <= end + 0.05 &&
        nm != null &&
        nm.teamNationId == side &&
        ((nm is SetPieceMoment && !nm.routine) ||
            (nm is ShotMoment && nm.origin == ShotOrigin.penalty));
    // A keeper's foul is out in front of his own goal, never upfield.
    spot = c.entry.keepers.contains(m.foulerId)
        ? at(_boxEdge + 2.5, latOf(foulSpot(m.zone, dir, 0)).clamp(-8.0, 8.0))
        : foulSpot(m.zone, dir, _spotKey(m.minute, m.stoppage, side));
    foulBy = start + (0.3 * len).clamp(0.2, 1.0);
    foulLatest = math.max(foulBy, start + room - math.max(0.9, 0.3 * len));
    if (resumed) {
      // Done already only when the ball is loose by him, play stopped, or
      // his side has it back after the whistle; then the whistle and the
      // card stand for this script too.
      final e = c.entry;
      final fp = e.players[m.fouledId];
      final loose =
          e.carrierId == null &&
          e.flight == null &&
          fp != null &&
          fp.distanceTo(e.ball) < 3.5;
      final car = e.carrierId;
      final back =
          car != null &&
          car != m.fouledId &&
          e.teams[car] == side &&
          e.t > start + 0.6 * len;
      if (loose || back) {
        fouled = true;
        foulAt = e.t;
        cue(e.t, PitchCueKind.foul, m.foulerId);
        _card(e.t);
      }
    }
  }

  final FoulMoment m;
  bool red = false;
  late final bool leaveBall;
  late final Offset2 spot;
  late final double foulBy;
  late final double foulLatest;
  bool fouled = false;
  bool lateCut = false;
  double foulAt = 0;
  double? gotAt;
  bool restarted = false;

  bool? cutWanted;

  @override
  BallAction? ball(double t, ScriptState now) {
    final car = now.carrierId;
    if (!fouled) {
      final fq = now.players[m.fouledId];
      final atFeet =
          car == m.fouledId ||
          (car == null &&
              now.flight == null &&
              fq != null &&
              fq.distanceTo(now.ball) < 1.3);
      final xq = now.players[m.foulerId];
      final onHim = xq != null && fq != null && xq.distanceTo(fq) < 1.5;
      if (t >= end - 0.7 && settledIn(t)) {
        // Out of time: the foul now, cutting to it if the ball is not his
        // or his man is not on him.
        if ((!atFeet || !onHim) && !lateCut) {
          lateCut = true;
          return cutToPhase(
            now,
            m.fouledId,
            spot,
            extra: {m.foulerId: spot + (goal - spot).unit * 1.2},
          );
        }
        if (atFeet && onHim) {
          fouled = true;
          foulAt = t;
          cue(t, PitchCueKind.foul, m.foulerId);
          _card(t);
          final ahead = now.ball + (goal - now.ball).unit * 1.4;
          return KickAction(
            to: ahead,
            arriveAt: t + 0.3,
            byPlayerId: car == null ? m.fouledId : null,
          );
        }
      }
      cutWanted ??= !resumed && _needCut(now);
      if (cutWanted! && !sceneCut && landing(now)) return null;
      if (cutWanted! && !sceneCut) {
        return cutToPhase(
          now,
          m.fouledId,
          spot,
          extra: {m.foulerId: spot + (goal - spot).unit * 1.2},
        );
      }
      if (car != m.fouledId) {
        // The ball to the man who is fouled; if it cannot reach him in
        // time, the foul is on him as it arrives.
        final a = fetch(m.fouledId, t, now);
        if (a != null) return a;
        return null;
      }
      final fp = now.players[m.fouledId]!;
      final xp = now.players[m.foulerId];
      final close = xp != null && xp.distanceTo(fp) < 1.4;
      gotAt ??= t;
      final settledOnIt = t >= gotAt! + 0.3;
      if (close && (settledOnIt || t >= foulLatest) && t >= foulBy) {
        fouled = true;
        foulAt = t;
        cue(t, PitchCueKind.foul, m.foulerId);
        _card(t);
        // The ball runs loose a yard or two.
        final ahead = now.ball + (now.ball - fp).unit * 1.4;
        final rest = leaveBall
            ? ahead
            : Offset2(
                ahead.x.clamp(1.0, PitchDims.length - 1),
                ahead.y.clamp(1.0, PitchDims.width - 1),
              );
        return KickAction(to: rest, arriveAt: t + 0.35, peak: 0);
      }
      return null;
    }
    if (now.flight != null) return null;
    if (leaveBall) {
      // Set down where the free kick is taken from.
      if (car == null && t >= foulAt + 0.4) {
        final target = _setSpot(now);
        if (now.ball.distanceTo(target) > 1e-6) {
          return place(t, now, target, speed: 6);
        }
      }
      return null;
    }
    if (restarted || car != null || t < end - 0.55) return null;
    // A quick free kick: the nearest of the fouled side takes the ball.
    restarted = true;
    final mates = available(now, side, except: {m.foulerId})
        .where((id) => !now.keepers.contains(id) || depthOf(now.ball) < 20)
        .toList();
    final to = nearest(now, mates, now.ball);
    if (to == null) return null;
    final d = now.players[to]!.distanceTo(now.ball);
    return KickAction(toPlayerId: to, arriveAt: t + math.max(d / 12, 0.2));
  }

  @override
  bool settled(double t, ScriptState now) =>
      fouled &&
      now.flight == null &&
      (leaveBall || now.carrierId != null || restarted);

  /// Whether the two men and the ball cannot meet in the time it has.
  bool _needCut(ScriptState now) {
    final fp = now.players[m.fouledId];
    final xp = now.players[m.foulerId];
    if (fp == null || xp == null) return false;
    // Where it happens matters too: the free kick is taken from there.
    final need =
        ballTo(now, m.fouledId) +
        xp.distanceTo(fp) / 9 +
        math.max(0.0, fp.distanceTo(spot) - 12) / 6 +
        0.3;
    return need > foulLatest - start;
  }

  /// The card, shown a beat after the whistle.
  void _card(double t) => cue(
    math.max(t, math.min(t + 0.6, end - 0.15)),
    red ? PitchCueKind.redCard : PitchCueKind.yellowCard,
    m.foulerId,
  );

  /// Where the next moment takes the ball from.
  Offset2 _setSpot(ScriptState now) {
    final n = c.next!.moments.first;
    if (n is SetPieceMoment) {
      final spot = deadBallSpot(n, dir);
      return now.ball.distanceTo(spot) < 6 ? now.ball : spot;
    }
    return at(PitchDims.penaltySpotDepth, 0);
  }

  @override
  PlayerDrive? steer(int id, double t, ScriptState now) {
    final car = now.carrierId;
    if (id == m.fouledId) {
      if (fouled) return (target: now.players[id]!, maxSpeed: 0);
      if (car == id) {
        // He takes his man on.
        final xp = now.players[m.foulerId];
        final fp = now.players[id]!;
        if (xp == null || xp.distanceTo(fp) < 3) {
          return (target: fp, maxSpeed: 1);
        }
        return (target: Offset2.lerp(fp, xp, 0.5), maxSpeed: 5);
      }
      if (now.flight?.toId == id) return null;
      return (target: now.players[id]!, maxSpeed: 0);
    }
    if (id == m.foulerId) {
      final fp = now.players[m.fouledId];
      final xp = now.players[id];
      if (fp == null || xp == null) return null;
      if (fouled) {
        // Back off a step for the card.
        final away = (xp - fp).unit;
        return (target: fp + away * 2.2, maxSpeed: 1.5);
      }
      return (target: fp + (xp - fp).unit * 1.0, maxSpeed: 7.5);
    }
    if (fouled) {
      // The free kick's taker comes for the ball; the opposition give it
      // room.
      if (now.teams[id] == opp) {
        final p = now.players[id]!;
        if (p.distanceTo(now.ball) < wallDistance + 0.5 && leaveBall) {
          return (
            target: now.ball + (p - now.ball).unit * (wallDistance + 1),
            maxSpeed: 4,
          );
        }
      }
      return null;
    }
    return react(id, now, skip: {m.fouledId, m.foulerId});
  }
}

/// An offside: the ball played through to the man beyond the second-last
/// defender, the flag, and the defending side's free kick from where he
/// was.
class _OffsidePlan extends _Plan {
  _OffsidePlan(StagingContext c, this.m) : super(c, m.teamNationId) {
    if (resumed) {
      final f = c.entry.flight;
      if (f != null && f.toId == m.playerId) played = true;
      if (c.entry.carrierId == m.playerId) played = true;
    }
  }

  @override
  bool settled(double t, ScriptState now) {
    final car = now.carrierId;
    return played && car != null && now.teams[car] == opp;
  }

  final OffsideMoment m;
  int? cutPasser;
  bool lateCut = false;
  bool played = false;
  bool flagged = false;
  Offset2? offence;
  int? taker;

  bool? cutWanted;

  /// The team-mate who plays the ball through: whoever has it, else the
  /// nearest man behind the one to be flagged.
  int? _passer(ScriptState now) {
    final car = now.carrierId;
    if (car != null &&
        car != m.playerId &&
        now.teams[car] == side &&
        !now.keepers.contains(car)) {
      return car;
    }
    final pp = now.players[m.playerId]!;
    final mates = available(now, side, except: {m.playerId})
        .where(
          (id) =>
              !now.keepers.contains(id) &&
              depthOf(now.players[id]!) < depthOf(pp) - 4,
        )
        .toList();
    return nearest(now, mates, pp);
  }

  bool _needCut(ScriptState now) {
    final pp = now.players[m.playerId];
    final passer = _passer(now);
    if (pp == null || passer == null) return pp != null;
    final pd = depthOf(pp);
    final line = math.max(offsideLine(now), depthOf(now.ball));
    var need = ballTo(now, passer);
    final want = math.max(line + 2.8, 55.0);
    if (pd <= math.max(line + 0.3, 52.8)) need += (want - pd).abs() / 6;
    need += now.players[passer]!.distanceTo(pp) / 20 + 0.6;
    return need > room - 0.3;
  }

  @override
  BallAction? ball(double t, ScriptState now) {
    final car = now.carrierId;
    final pid = m.playerId;
    // Out of time, the picture cuts to the ball about to be played through.
    final late = !played && t >= end - 0.45 && settledIn(t) && !lateCut;
    if (late) {
      lateCut = true;
      sceneCut = false;
      cutWanted = true;
    }
    if (!played && (!resumed || late)) {
      cutWanted ??= _needCut(now);
      if (cutWanted! && !sceneCut && landing(now) && !late) return null;
      if (cutWanted! && !sceneCut) {
        final pp = now.players[pid]!;
        final passer =
            _passer(now) ??
            nearest(
              now,
              available(
                now,
                side,
                except: {pid},
              ).where((id) => !now.keepers.contains(id)),
              pp,
            );
        if (passer != null) {
          cutPasser = passer;
          // The cut puts him beyond their line, the passer behind it.
          return cutToPhase(
            now,
            passer,
            at(73, latOf(now.players[passer]!).clamp(-16.0, 16.0)),
            offside: pid,
          );
        }
      }
    }
    if (!played) {
      if (car == pid) {
        // He has it already: it is laid back to a team-mate first.
        final mates = available(
          now,
          side,
          except: {pid},
        ).where((id) => onside(now, id) && !now.keepers.contains(id)).toList();
        final to = nearest(now, mates, now.players[pid]!);
        if (to == null) return null;
        return fetch(to, t, now);
      }
      final cp = cutPasser;
      // Only once the cut is made and the ball lies at his feet: a cut
      // asked for in the air waits for the ball to land, and a kick asked
      // for meanwhile (the ball flying past him) is never made.
      if (car == null &&
          now.flight == null &&
          cp != null &&
          now.players[cp] != null &&
          now.players[cp]!.distanceTo(now.ball) < 1.5) {
        // Played through straight from where the cut left it.
        final pp = now.players[pid]!;
        final d = now.ball.distanceTo(pp);
        played = true;
        offence = pp;
        flagged = true;
        final arrive = t + math.max(d / 28, 0.2);
        cue(arrive, PitchCueKind.offsideFlag, pid);
        return KickAction(
          toPlayerId: pid,
          byPlayerId: cp,
          arriveAt: arrive,
          pass: d >= 9,
        );
      }
      if (car == null || now.teams[car] != side) {
        final mates = available(
          now,
          side,
          except: {pid},
        ).where((id) => onside(now, id)).toList();
        final to = nearest(now, mates, now.ball);
        return to == null ? null : fetch(to, t, now);
      }
      final pp = now.players[pid];
      if (pp == null) return null;
      final beyond =
          depthOf(pp) > PitchDims.length / 2 &&
          depthOf(pp) > math.max(offsideLine(now), depthOf(now.ball)) + 0.3;
      if (!beyond && t < end - 0.6) return null;
      if (!beyond) return null;
      played = true;
      offence = pp;
      final d = now.ball.distanceTo(pp);
      final v = (14 + 0.4 * d).clamp(14.0, 26.0);
      // The flag goes up as it reaches him.
      flagged = true;
      cue(t + math.max(d / v, 0.25), PitchCueKind.offsideFlag, pid);
      return KickAction(
        toPlayerId: pid,
        arriveAt: t + math.max(d / v, 0.25),
        peak: d > 22 ? 2.5 : 0,
        pass: d >= 9,
      );
    }
    if (now.flight != null) return null;
    if (!flagged) {
      flagged = true;
      cue(t, PitchCueKind.offsideFlag, pid);
    }
    if (car == null || now.teams[car] == opp) return null;
    // The defending side takes the free kick where he was.
    final o = offence ?? now.players[pid]!;
    taker ??= nearest(
      now,
      available(
        now,
        opp,
      ).where((id) => !now.keepers.contains(id) || depthOf(o) > 88),
      o,
    );
    final tk = taker;
    if (tk == null) return null;
    if (t < end - 0.5 && now.players[tk]!.distanceTo(o) > 3) return null;
    final d = now.players[tk]!.distanceTo(now.ball);
    return KickAction(toPlayerId: tk, arriveAt: t + math.max(d / 12, 0.2));
  }

  @override
  PlayerDrive? steer(int id, double t, ScriptState now) {
    final pid = m.playerId;
    if (id == pid) {
      if (played) {
        if (now.flight?.toId == id) return null;
        return (target: now.players[id]!, maxSpeed: 0);
      }
      final line = math.max(offsideLine(now), depthOf(now.ball));
      final p = now.players[id]!;
      return (
        target: at((line + 2.5).clamp(55.0, 101.0), latOf(p)),
        maxSpeed: 7.5,
      );
    }
    if (played && id == taker) {
      final o = offence ?? now.players[pid]!;
      final p = now.players[pid]!;
      return (target: o + (now.players[id]! - p).unit * 1.5, maxSpeed: 6);
    }
    if (played) return null;
    // The defenders step up past him: the trap.
    if (now.teams[id] == opp) {
      final pp = now.players[pid];
      final q = now.players[id];
      if (pp == null || q == null || now.keepers.contains(id)) return null;
      final pd = depthOf(pp);
      if (depthOf(q) > pd - 1.5 && pd > PitchDims.length / 2 + 2) {
        return (target: at(pd - 3, latOf(q)), maxSpeed: 6);
      }
      return null;
    }
    return react(id, now, skip: {pid});
  }
}
