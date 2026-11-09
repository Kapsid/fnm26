part of '../moment_staging.dart';

/// One kick of a penalty shootout, in the order the kicks are taken: home
/// first, then alternating. [kick] is the outcome's own [ShootoutKick]; the
/// staging only draws it and never decides anything.
class StagedShootoutKick {
  const StagedShootoutKick({
    required this.index,
    required this.home,
    required this.sideIndex,
    required this.kick,
  });

  /// 0-based, across both sides.
  final int index;
  final bool home;

  /// Which of his side's kicks this is (0-based).
  final int sideIndex;
  final ShootoutKick kick;

  bool get scored => kick.result == KickResult.scored;
}

/// Where everybody is, and what the ball is doing, [ShootoutStaging.frameAt]
/// a moment into a kick. The camera is on the goal at x = 105.
class ShootoutFrame {
  const ShootoutFrame({
    required this.taker,
    required this.takerFacing,
    required this.ball,
    required this.ballHeight,
    required this.keeper,
    required this.keeperHeight,
    required this.struck,
    required this.resultShown,
  });

  final Offset2 taker;
  final double takerFacing;
  final Offset2 ball;
  final double ballHeight;
  final Offset2 keeper;

  /// How far the keeper is off the grass in his dive, in metres.
  final double keeperHeight;

  /// The ball has been struck.
  final bool struck;

  /// The kick has reached its result (the ball is in, saved, wide or off
  /// the woodwork).
  final bool resultShown;
}

/// The men of a shootout, taken from the script of the match it follows:
/// each side's keeper at the final whistle and every shirt number.
class ShootoutCast {
  const ShootoutCast({
    required this.homeNationId,
    required this.homeKeeperId,
    required this.awayKeeperId,
    required this.shirts,
    required this.teams,
  });

  /// From [script]: whoever kept goal for each side when the match ended.
  factory ShootoutCast.of(PitchScript script) {
    final end = Duration(microseconds: (script.totalSeconds * 1e6).round());
    final keepers = script.sample(end).keepers;
    var home = 0;
    var away = 0;
    for (final a in script.actorList) {
      if (!keepers.contains(a.playerId)) continue;
      if (a.teamNationId == script.homeNationId) {
        home = a.playerId;
      } else {
        away = a.playerId;
      }
    }
    return ShootoutCast(
      homeNationId: script.homeNationId,
      homeKeeperId: home,
      awayKeeperId: away,
      shirts: {for (final a in script.actorList) a.playerId: a.shirt},
      teams: {for (final a in script.actorList) a.playerId: a.teamNationId},
    );
  }

  final int homeNationId;
  final int homeKeeperId;
  final int awayKeeperId;

  /// Shirt number by player id.
  final Map<int, int> shirts;

  /// Side (nation id) by player id.
  final Map<int, int> teams;

  /// The keeper who faces a kick by the [home] side.
  int keeperFacing({required bool home}) => home ? awayKeeperId : homeKeeperId;
}

/// Stages a penalty shootout kick by kick from its [KnockoutOutcome]: the
/// camera on one goal, the taker walking from the centre circle, his
/// run-up, the ball into the lane, the keeper's dive into `diveLane` and
/// the result. Every kick is [kickSeconds] long at every speed.
///
/// The outcome is the record's: the taker, the lane, the dive and whether it
/// went in are the ones [WorldCupFinals.decideShootout] drew. Nothing here
/// rolls a die.
abstract final class ShootoutStaging {
  /// How long one kick takes on screen, at any speed.
  static const double kickSeconds = 4;

  /// The taker walks in until [walkEnd], waits, runs up from [runUpAt],
  /// strikes at [strikeAt]; the ball arrives (and the result is shown) at
  /// [resultAt].
  static const double walkEnd = 1.8, runUpAt = 2.3, strikeAt = 2.65;
  static const double flight = 0.4;
  static const double resultAt = strikeAt + flight;

  /// The one goal the camera is on.
  static const double goalX = PitchDims.length;
  static const double goalY = PitchDims.width / 2;
  static const double spotX = PitchDims.penaltySpotDepth;

  /// The kicks in the order they are taken (home first, alternating, as the
  /// shootout strip counts them). A side with no kick left gives way to the
  /// other, so a malformed outcome still lists every kick once.
  static List<StagedShootoutKick> order(KnockoutOutcome o) {
    final out = <StagedShootoutKick>[];
    var h = 0;
    var a = 0;
    final total = o.homeKicks.length + o.awayKicks.length;
    while (out.length < total) {
      var home = out.length.isEven;
      if (home && h >= o.homeKicks.length) home = false;
      if (!home && a >= o.awayKicks.length) home = true;
      final side = home ? h++ : a++;
      out.add(
        StagedShootoutKick(
          index: out.length,
          home: home,
          sideIndex: side,
          kick: _kickOf(o, home, side),
        ),
      );
    }
    return out;
  }

  /// The outcome's detail for a kick; for an outcome built without any (the
  /// two lists are empty), a plain kick consistent with the bool.
  static ShootoutKick _kickOf(KnockoutOutcome o, bool home, int i) {
    final detail = home ? o.homeDetail : o.awayDetail;
    if (i < detail.length) return detail[i];
    final scored = (home ? o.homeKicks : o.awayKicks)[i];
    final lane = (i * 2 + (home ? 0 : 1)) % 6;
    return ShootoutKick(
      takerId: 0,
      result: scored ? KickResult.scored : KickResult.saved,
      lane: lane,
      diveLane: scored ? (lane + 3) % 6 : lane,
    );
  }

  /// The tally after the first [revealed] kicks: (home, away) goals.
  static (int, int) tally(List<StagedShootoutKick> kicks, int revealed) {
    var h = 0;
    var a = 0;
    for (final k in kicks.take(revealed)) {
      if (!k.scored) continue;
      if (k.home) {
        h++;
      } else {
        a++;
      }
    }
    return (h, a);
  }

  /// The pitch y of goal column [lane] % 3 (0 left, 1 centre, 2 right as the
  /// taker faces the goal).
  static double laneY(int lane) => goalY + (lane % 3 - 1) * 2.5;

  /// The height of goal row [lane] ~/ 3 (low, then high).
  static double laneHeight(int lane) => lane ~/ 3 == 0 ? 0.45 : 1.85;

  /// Where the ball is when the kick is settled: the net, the keeper's
  /// hands, outside the post, or off the woodwork and back out.
  static ({Offset2 at, double height}) restOf(ShootoutKick k) {
    final y = laneY(k.lane);
    final z = laneHeight(k.lane);
    final sign = k.lane % 3 == 0 ? -1.0 : 1.0;
    switch (k.result) {
      case KickResult.scored:
        return (at: Offset2(goalX + 1.3, y), height: 0.15);
      case KickResult.saved:
        // Parried: pushed out in front of his goal, away from the middle.
        return (
          at: Offset2(goalX - 4.0, goalY + sign * ((y - goalY).abs() + 1.0)),
          height: 0.15,
        );
      case KickResult.wide:
        return (
          at: Offset2(
            goalX + 2.6,
            goalY + sign * (PitchDims.goalHalfWidth + 2),
          ),
          height: 0.15,
        );
      case KickResult.post:
        return (
          at: Offset2(
            goalX - 3.2,
            goalY + sign * (PitchDims.goalHalfWidth + 3),
          ),
          height: 0.15,
        );
    }
  }

  /// The point the ball reaches at [resultAt]: on the line (the post, the
  /// gap beside it, the lane) or, for a save, the keeper's hands.
  static ({Offset2 at, double height}) arrivalOf(ShootoutKick k) {
    final y = laneY(k.lane);
    final z = laneHeight(k.lane);
    final sign = k.lane % 3 == 0 ? -1.0 : 1.0;
    switch (k.result) {
      case KickResult.scored:
        return (at: Offset2(goalX, y), height: z);
      case KickResult.saved:
        return (at: Offset2(goalX - 0.7, y), height: z);
      case KickResult.wide:
        return (
          at: Offset2(goalX, goalY + sign * (PitchDims.goalHalfWidth + 1.3)),
          height: z,
        );
      case KickResult.post:
        return (
          at: Offset2(goalX, goalY + sign * PitchDims.goalHalfWidth),
          height: z,
        );
    }
  }

  /// The keeper's dive: where he ends up (his lane's column and row).
  static ({Offset2 at, double height}) diveOf(ShootoutKick k) {
    if (k.result == KickResult.saved) {
      // He gets to the ball: his hands are where it arrives.
      final a = arrivalOf(k);
      return (at: a.at, height: a.height);
    }
    return (
      at: Offset2(goalX - 0.4, laneY(k.diveLane)),
      height: laneHeight(k.diveLane) * 0.8,
    );
  }

  static double _ease(double u) {
    final c = u.clamp(0.0, 1.0);
    return c * c * (3 - 2 * c);
  }

  static Offset2 _lerp(Offset2 a, Offset2 b, double u) => Offset2.lerp(a, b, u);

  /// The picture [seconds] into [kick] (0 to [kickSeconds]).
  static ShootoutFrame frameAt(StagedShootoutKick kick, double seconds) {
    final k = kick.kick;
    final s = seconds.clamp(0.0, kickSeconds);
    const spot = Offset2(spotX, goalY);

    // The taker: from the centre circle to a few steps behind the ball,
    // a pause, the run-up, the strike and a step through it.
    const circle = Offset2(PitchDims.length / 2 + 9.15, goalY);
    const behind = Offset2(spotX - 4.2, goalY + 2.2);
    const plant = Offset2(spotX - 0.9, goalY + 1.1);
    const through = Offset2(spotX + 0.4, goalY + 0.5);
    final Offset2 taker;
    if (s < walkEnd) {
      taker = _lerp(circle, behind, _ease(s / walkEnd));
    } else if (s < runUpAt) {
      taker = behind;
    } else if (s < strikeAt) {
      taker = _lerp(behind, plant, (s - runUpAt) / (strikeAt - runUpAt));
    } else {
      taker = _lerp(plant, through, _ease((s - strikeAt) / 0.5));
    }
    final facing = (spot - taker).angle;

    // The keeper: on his line, then a dive that starts as the ball is
    // struck.
    const line = Offset2(goalX - 0.4, goalY);
    final dive = diveOf(k);
    final diveU = _ease((s - (strikeAt - 0.03)) / (flight + 0.03));
    final keeper = _lerp(line, dive.at, diveU);
    final keeperHeight = dive.height * diveU;

    // The ball: on the mark, struck for the lane, then settled.
    final arrive = arrivalOf(k);
    final rest = restOf(k);
    final Offset2 ball;
    final double height;
    if (s < strikeAt) {
      ball = spot;
      height = 0;
    } else if (s < resultAt) {
      final u = (s - strikeAt) / flight;
      ball = _lerp(spot, arrive.at, u);
      height = 0.11 + (arrive.height - 0.11) * u;
    } else {
      final u = _ease((s - resultAt) / 0.45);
      ball = _lerp(arrive.at, rest.at, u);
      // A rebound off the post or a parry lifts a little on the way.
      final lift = k.result == KickResult.post || k.result == KickResult.saved
          ? 0.6 * 4 * u * (1 - u)
          : 0.0;
      height = arrive.height + (rest.height - arrive.height) * u + lift;
    }
    return ShootoutFrame(
      taker: taker,
      takerFacing: facing,
      ball: ball,
      ballHeight: height,
      keeper: keeper,
      keeperHeight: keeperHeight,
      struck: s >= strikeAt,
      resultShown: s >= resultAt,
    );
  }
}

/// A penalty given in the match itself (normal or extra time), shown in
/// the shootout's close-up: the camera behind the taker, the goal face-on,
/// taker against keeper. The kick is the script's own, read off the ball
/// it strikes: where it goes, where the keeper dives and how it ends are
/// what the match decided. The close-up takes over from [from] to [to]
/// (screen seconds) and the pitch picks up again after it.
class InMatchPenalty {
  const InMatchPenalty({
    required this.strike,
    required this.kick,
    required this.cast,
  });

  /// The screen second the ball is struck from the spot.
  final double strike;
  final StagedShootoutKick kick;

  /// The taker's side and the keeper he faces, with every shirt number.
  final ShootoutCast cast;

  /// How far into a shootout kick the close-up opens: the taker nearly
  /// set behind the ball, the run-up still to come.
  static const double opensAt = 1.0;

  /// The close-up's own seconds (as [ShootoutStaging.frameAt] takes them)
  /// at screen second [t].
  double secondsAt(double t) => t - strike + ShootoutStaging.strikeAt;

  /// The screen seconds the close-up is up between.
  double get from => strike - ShootoutStaging.strikeAt + opensAt;
  double get to =>
      strike - ShootoutStaging.strikeAt + ShootoutStaging.kickSeconds;

  /// Every penalty [s] plays in the match, in order, each with the kick it
  /// shows. A penalty struck before the script starts (a resume after it)
  /// is left out.
  static List<InMatchPenalty> of(PitchScript s) {
    final out = <InMatchPenalty>[];
    for (final w in s.windows) {
      for (final m in w.moments) {
        if (m is! ShotMoment || m.origin != ShotOrigin.penalty) continue;
        final p = _read(s, w, m);
        if (p != null) out.add(p);
      }
    }
    return out;
  }

  static InMatchPenalty? _read(PitchScript s, StagedWindow w, ShotMoment m) {
    final shooter = s.actorIndexOf(m.shooterId);
    if (shooter == null) return null;
    // The kick itself: the flight struck at the window's shot cue. Not
    // just the taker's first touch in the window: he may play the ball
    // onto the mark first, and a close-up keyed to that showed the kick
    // early, then the real one again on the pitch, its goal after it.
    double? cue;
    for (final c in w.cues) {
      if (c.kind == PitchCueKind.shot && c.playerId == m.shooterId) {
        cue = c.t;
        break;
      }
    }
    FlightPhase? kick;
    for (final p in s.ballPhases) {
      if (p is! FlightPhase || p.pass || p.resting) continue;
      if (p.fromActor != shooter) continue;
      if (p.t0 < w.start - 1e-6 || p.t0 > w.end + 3) continue;
      final struck = cue != null
          ? (p.t0 - cue).abs() < 1e-3
          // No cue (a resumed window): the ball struck from the mark.
          : xToDepth(p.from.x, p.to.x >= PitchDims.length / 2 ? 1 : -1) >
                    PitchDims.penaltySpotDepth - 1 &&
                (p.to.x < 3 || p.to.x > PitchDims.length - 3);
      if (!struck) continue;
      kick = p;
      break;
    }
    if (kick == null || kick.t0 < s.start) return null;
    // Which goal: the one the ball is struck at. Lateral as the taker faces
    // it (negative to his left), as a shootout's lanes are.
    final dir = kick.to.x >= PitchDims.length / 2 ? 1 : -1;
    double lat(Offset2 q) => (q.y - PitchDims.width / 2) * dir;
    int column(double l) => l < -1.25 ? 0 : (l > 1.25 ? 2 : 1);
    final result = switch (m.outcome) {
      ShotOutcome.goal => KickResult.scored,
      ShotOutcome.saved || ShotOutcome.blocked => KickResult.saved,
      ShotOutcome.wide => KickResult.wide,
      ShotOutcome.woodwork => KickResult.post,
    };
    final l = lat(kick.to);
    var col = column(l);
    // Wide of the goal or off a post: always one side or the other.
    if (result == KickResult.wide || result == KickResult.post) {
      col = l < 0 ? 0 : 2;
    }
    final row = kick.toHeight > 1.15 ? 1 : 0;
    final lane = row * 3 + col;
    // The keeper the kick is taken against, and where his dive took him.
    final home = s.actorList[shooter].teamNationId == s.homeNationId;
    var keeperId = m.keeperId;
    if (keeperId == null || s.actorIndexOf(keeperId) == null) {
      for (final id in s.keepersAt(kick.t0)) {
        final i = s.actorIndexOf(id)!;
        if ((s.actorList[i].teamNationId == s.homeNationId) != home) {
          keeperId = id;
        }
      }
    }
    // Low, in the middle, when there is no keeper to read.
    var dive = 1;
    final ki = keeperId == null ? null : s.actorIndexOf(keeperId);
    if (ki != null) {
      final (at, _) = s.actorAt(ki, kick.t1 + 0.25);
      dive = column(lat(at));
    }
    var diveLane = dive;
    if (result == KickResult.saved) {
      diveLane = lane;
    } else if (diveLane == lane) {
      // A goal (or a miss) past a keeper who went the right way: he got
      // nowhere near it, so he is drawn standing in the middle.
      diveLane = col == 1 ? (l < 0 ? 2 : 0) : 1;
    }
    final kid = keeperId ?? 0;
    return InMatchPenalty(
      strike: kick.t0,
      kick: StagedShootoutKick(
        index: 0,
        home: home,
        sideIndex: 0,
        kick: ShootoutKick(
          takerId: m.shooterId,
          result: result,
          lane: lane,
          diveLane: diveLane,
        ),
      ),
      cast: ShootoutCast(
        homeNationId: s.homeNationId,
        homeKeeperId: home ? 0 : kid,
        awayKeeperId: home ? kid : 0,
        shirts: {for (final a in s.actorList) a.playerId: a.shirt},
        teams: {for (final a in s.actorList) a.playerId: a.teamNationId},
      ),
    );
  }
}
