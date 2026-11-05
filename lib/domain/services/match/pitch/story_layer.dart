/// The story layer: believable football between a match's real moments.
///
/// Between the staged moments the Pitch view shows build-up the engine never
/// decided: passes, carries, switches of play, pressing and recovery, with
/// each side holding the shape of its formation and tactics. It never
/// creates an outcome. It leads into each real moment (the right side on the
/// ball, roughly where the moment happens) and picks up from wherever the
/// moment leaves the players. Pure Dart: no Flutter.
///
/// ## Speed mapping
///
/// The pacer compresses a quiet match minute into about one to two screen
/// seconds, so the match clock runs some 30-70 times faster than the
/// picture. The picture does not try to keep up: motion is shown at real
/// football speeds in SCREEN seconds (a jog of 3-6 m/s, a sprint never above
/// 8.8 m/s, a pass at 11-26 m/s), as if one screen second were one second of
/// play, and every cap is enforced in screen seconds. What the compression
/// changes is the choice of football, never the running speed: the more
/// match time a quiet slot covers (`c` = match seconds per screen second),
/// the longer the passes the carriers look for (preferred length
/// `12 + 0.2c` m, 18-26 m at the three speeds) and the more ground each
/// possession covers, so heavy compression reads as fewer, longer passes
/// rather than faster running.
library;

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/formation_slots.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';

/// A side's plan: its shape and instructions.
typedef MatchPlan = FieldedPlan;

/// One of a side's starting eleven. In `TeamSide.xi` the list order is the
/// formation's slot order: `xi[i]` plays slot `i` of the formation.
typedef LineupPlayer = ({int playerId, PlayerPosition slot, int shirt});

/// One side as the Pitch view lines it up.
typedef TeamSide = ({
  int nationId,
  Formation formation,
  List<LineupPlayer> xi,
  List<int> bench,
  TacticalInstructions instructions,
  MatchPlan plan,
});

/// Both sides' line-ups.
typedef MatchLineups = ({TeamSide home, TeamSide away});

/// [team] as the Pitch view lines it up. The game has no squad numbers, so
/// shirts are dealt deterministically: the keeper wears 1, the rest of the
/// eleven 2-11 in slot order, and the bench 12 upward in its order.
TeamSide teamSideOf(
  MatchTeam team, {
  List<int> bench = const [],
  MatchPlan? plan,
}) {
  final positions = team.positions;
  final xi = <LineupPlayer>[];
  var next = 2;
  for (var i = 0; i < team.xi.length && i < positions.length; i++) {
    final gk = team.formation.positions[i] == PlayerPosition.gk;
    xi.add((
      playerId: team.xi[i].id,
      slot: positions[i],
      shirt: gk ? 1 : next++,
    ));
  }
  return (
    nationId: team.nationId,
    formation: team.formation,
    xi: xi,
    bench: bench,
    instructions: team.instructions,
    plan: plan ?? (formation: team.formation, instructions: team.instructions),
  );
}

/// Both sides' line-ups for a match between [home] and [away]; each side's
/// [MatchPlan] is the one [result] says it fielded, when known.
MatchLineups matchLineupsOf({
  required MatchTeam home,
  required MatchTeam away,
  List<int> homeBench = const [],
  List<int> awayBench = const [],
  MatchResult? result,
}) => (
  home: teamSideOf(home, bench: homeBench, plan: result?.homePlan),
  away: teamSideOf(away, bench: awayBench, plan: result?.awayPlan),
);

/// Where a stager sends a player, and how fast he may go (screen m/s).
typedef PlayerDrive = ({Offset2 target, double maxSpeed});

/// Something a stager does with the ball.
sealed class BallAction {
  const BallAction();
}

/// Pass the ball from its carrier to [toPlayerId], arriving at screen
/// second [arriveAt], lofted to [peak] metres.
final class PassAction extends BallAction {
  const PassAction({
    required this.toPlayerId,
    required this.arriveAt,
    this.peak = 0,
  });

  final int toPlayerId;
  final double arriveAt;
  final double peak;
}

/// What a stager is told about the window it fills.
class StagingContext {
  const StagingContext({
    required this.window,
    required this.entry,
    required this.lineups,
    required this.homeDir,
    required this.departing,
    required this.seed,
  });

  /// The window: its start and end (screen seconds) and its moments.
  final StagedWindow window;

  /// Who is where and who has the ball as the window opens.
  final ScriptState entry;
  final MatchLineups lineups;

  /// Which way the home side attacks in this period (+1 = toward x 105).
  final int homeDir;

  /// Players walking off or due to: the story layer moves them, and a stager
  /// must leave them be.
  final Set<int> departing;

  /// The seed for this window's own randomness (the match seed mixed with
  /// the moment's index), never an engine stream.
  final int seed;
}

/// Fills a staged-moment window. The story layer asks once per window and
/// then, every step, where each player heads and what the ball does; it
/// still applies every speed and spacing rule itself, so a stager only
/// choreographs.
abstract interface class MomentStager {
  StagedPlan stage(StagingContext context);
}

/// One window's choreography.
abstract interface class StagedPlan {
  /// Where [playerId] heads at screen second [t]; null holds him still.
  PlayerDrive? drive(int playerId, double t, ScriptState now);

  /// A ball action to start at screen second [t]; null leaves the ball be.
  BallAction? ball(double t, ScriptState now);
}

/// The placeholder stager: everyone holds still. The only thing it does is
/// the one thing a moment cannot open without: when the ball is not with
/// the side the moment belongs to, it is passed straight to that side's
/// nearest man, so the next quiet spell starts from the moment's side as a
/// real staging would. Keeps every invariant, so the story layer stands on
/// its own until the real stagers exist.
class NeutralHold implements MomentStager {
  const NeutralHold();

  @override
  StagedPlan stage(StagingContext context) => _Hold(context);
}

class _Hold implements StagedPlan {
  _Hold(this.context);

  final StagingContext context;
  bool _done = false;

  @override
  PlayerDrive? drive(int playerId, double t, ScriptState now) => null;

  @override
  BallAction? ball(double t, ScriptState now) {
    if (_done) return null;
    _done = true;
    final w = context.window;
    final carrier = now.carrierId;
    if (w.moments.isEmpty || carrier == null) return null;
    final m = w.moments.first;
    if (m is SubMoment) return null;
    final home = context.lineups.home;
    final homeIds = {
      for (final p in home.xi) p.playerId,
      ...home.bench,
    };
    final side = m.teamNationId == home.nationId;
    if (homeIds.contains(carrier) == side) return null;
    int? best;
    var bestD = double.infinity;
    now.players.forEach((id, p) {
      if (homeIds.contains(id) != side || context.departing.contains(id)) {
        return;
      }
      final d = p.distanceTo(now.ball);
      if (d >= 7 && d < bestD) {
        bestD = d;
        best = id;
      }
    });
    final to = best;
    if (to == null) return null;
    final arrive = t + math.max(bestD / 24, 0.3);
    if (arrive > w.end - 0.05) return null;
    return PassAction(toPlayerId: to, arriveAt: arrive);
  }
}

/// Builds a match's [PitchScript].
abstract final class StoryLayer {
  /// The keyframe spacing, in screen seconds.
  static const double step = 0.25;

  /// The whole match's picture: quiet time told by the story layer, each
  /// staged moment's window filled by [stager].
  static PitchScript build({
    required MatchResult result,
    required MatchLineups lineups,
    required PitchPacer pacer,
    required int seed,
    MomentStager stager = const NeutralHold(),
  }) => _Builder(result, lineups, pacer, seed, stager).run();
}

// ---------------------------------------------------------------------------

const double _hardSpeed = 8.8;
const double _accel = 9;
const double _turnRate = 7;
const double _safeGap = 0.9;
const double _leadIn = 3.5;

/// How long before a moment the ball changes hands when it has to.
const double _handover = 1.3;
const double _keeperMaxDepth = 24.5;

class _Agent {
  _Agent(this.index, this.id, this.side, {required this.keeper});
  final int index;
  final int id;
  final int side;
  final bool keeper;
  bool present = false;
  Offset2 pos = Offset2.zero;
  Offset2 vel = Offset2.zero;
  double facing = 0;
  int? slot;
  double? walkStart;
  Offset2? walkTarget;

  /// The slot he left, kept for the man who replaces him.
  int? vacatedSlot;
  double phaseA = 0;
  double phaseB = 0;
}

class _Side {
  _Side(this.team, {required this.home})
    : layout = [
        for (var i = 0; i < team.formation.positions.length; i++)
          (
            layoutOf(team.formation)[i].$1,
            adjustedSlotY(
              layoutOf(team.formation)[i].$2,
              team.formation.positions[i].category,
              team.instructions,
            ),
          ),
      ],
      owner = List<int?>.filled(team.formation.positions.length, null),
      pending = List<bool>.filled(team.formation.positions.length, false) {
    effective = [...layout];
  }

  final TeamSide team;
  final bool home;
  final List<(double, double)> layout;
  late List<(double, double)> effective;
  final List<int?> owner;
  final List<bool> pending;

  /// Slots emptied with nobody named to fill them, latest last.
  final List<int> vacated = [];
  double backLine = 30;

  int get nationId => team.nationId;
  TacticalInstructions get instr => team.instructions;
  int get gkSlot {
    final i = team.formation.positions.indexOf(PlayerPosition.gk);
    return i < 0 ? 0 : i;
  }

  /// Re-forms the shape for the men left: a line that lost somebody spreads
  /// its remaining men evenly across the width it covered.
  void reform() {
    effective = reformedSlots(layout, gkSlot, {
      for (var i = 0; i < layout.length; i++)
        if (owner[i] != null || pending[i]) i,
    });
  }
}

/// A shape re-formed for the men left: [layout]'s slots with only [filled]
/// manned. A line (slots at about the same height) that lost somebody
/// spreads its remaining men evenly across the width it covered, so a back
/// four down to three still covers both flanks; a line down to one man
/// holds the middle. Slots outside [filled] keep their place (nobody uses
/// them). The keeper's slot [gkSlot] never moves.
List<(double, double)> reformedSlots(
  List<(double, double)> layout,
  int gkSlot,
  Set<int> filled,
) {
  final eff = [...layout];
  final outfield = [
    for (var i = 0; i < layout.length; i++)
      if (i != gkSlot) i,
  ]..sort((a, b) => layout[a].$2.compareTo(layout[b].$2));
  final lines = <List<int>>[];
  for (final i in outfield) {
    if (lines.isNotEmpty &&
        (layout[i].$2 - layout[lines.last.first].$2).abs() <= 0.07) {
      lines.last.add(i);
    } else {
      lines.add([i]);
    }
  }
  for (final line in lines) {
    final manned = [
      for (final i in line)
        if (filled.contains(i)) i,
    ]..sort((a, b) => layout[a].$1.compareTo(layout[b].$1));
    if (manned.length == line.length || manned.isEmpty) continue;
    final xs = [for (final i in line) layout[i].$1];
    final lo = xs.reduce(math.min);
    final hi = xs.reduce(math.max);
    for (var k = 0; k < manned.length; k++) {
      final x = manned.length == 1
          ? 0.5
          : lo + (hi - lo) * k / (manned.length - 1);
      eff[manned[k]] = (x, layout[manned[k]].$2);
    }
  }
  return eff;
}

/// A departure or arrival the builder applies at a screen second.
class _Change {
  _Change(this.t, this.order, this.apply);
  final double t;
  final int order;
  final void Function() apply;
}

class _Flight {
  _Flight({
    required this.t0,
    required this.t1,
    required this.from,
    required this.fromActor,
    required this.toActor,
    required this.peak,
    required this.lead,
  });
  final double t0;
  final double t1;
  final Offset2 from;
  final int fromActor;
  final int toActor;
  final double peak;
  final Offset2 lead;
}

class _Builder {
  _Builder(this.result, this.lineups, this.pacer, this.seed, this.stager);

  final MatchResult result;
  final MatchLineups lineups;
  final PitchPacer pacer;
  final int seed;
  final MomentStager stager;

  late final List<_Side> sides;
  final List<_Agent> agents = [];
  final List<PitchActor> actorList = [];
  final Map<int, int> indexOf = {};
  final List<ScriptKeyframe> keyframes = [];
  final List<BallPhase> phases = [];
  final List<StagedWindow> windows = [];
  final List<double> resets = [];
  final Map<int, double> departures = {};
  final Map<int, double> arrivals = {};
  final List<_Change> changes = [];

  late double total;

  // Ball state.
  int? carrier;
  _Flight? flight;
  double phaseStart = 0;
  int possession = 0;
  double nextAction = 0;
  double spellEnd = 0;
  double spellStart = 0;
  double spellDepth = 0;
  double homeBallTime = 0;
  double awayBallTime = 0;
  double cameraX = PitchDims.length / 2;

  SeededRng rng = SeededRng(0);
  int rngSlot = -1;

  StagedWindow? activeWindow;
  StagedPlan? activePlan;

  PitchScript run() {
    total = pacer.total.inMicroseconds / 1e6;
    sides = [_Side(lineups.home, home: true), _Side(lineups.away, home: false)];
    _registerActors();
    _buildWindows();
    _scheduleChanges();
    for (final m in [46, if (result.extraTime != null) 91]) {
      resets.add(_secs(pacer.screenAt(m, 0)));
    }

    // Kick-off.
    for (var s = 0; s < 2; s++) {
      final side = sides[s];
      for (var i = 0; i < side.team.xi.length; i++) {
        final a = agents[indexOf[side.team.xi[i].playerId]!];
        a.present = true;
        a.slot = i;
        side.owner[i] = a.index;
      }
    }
    _reseed(0);
    _kickoff(0, 0);
    _record(0);

    final specials = <double>{
      for (final w in windows) ...[w.start, w.end],
      ...resets,
      for (final c in changes) c.t,
      total,
    }.toList()..sort();
    var sp = 0;
    var ci = 0;
    var wi = 0;
    var t = 0.0;
    final resetDone = <double>{};
    while (t < total - 1e-9) {
      // Windows closing.
      if (activeWindow != null && t >= activeWindow!.end - 1e-9) {
        activeWindow!.exit = _state(t);
        activeWindow = null;
        activePlan = null;
        spellEnd = t + _spellLength(possession);
        nextAction = math.max(nextAction, t + 0.15);
      }
      // Kick-offs.
      for (final r in resets) {
        if (!resetDone.contains(r) && (r - t).abs() < 1e-9) {
          resetDone.add(r);
          final m = pacer.matchAt(_dur(r)).minute;
          _kickoff(r, m > 90 ? 0 : 1);
          _record(r);
        }
      }
      // Departures and arrivals.
      while (ci < changes.length && changes[ci].t <= t + 1e-9) {
        changes[ci].apply();
        ci++;
      }
      // Windows opening.
      while (wi < windows.length && windows[wi].start <= t + 1e-9) {
        final w = windows[wi];
        wi++;
        if (w.end <= t + 1e-9) continue;
        w.entry = _state(t);
        activeWindow = w;
        final m = pacer.matchAt(_dur(t)).minute;
        activePlan = stager.stage(
          StagingContext(
            window: w,
            entry: w.entry,
            lineups: lineups,
            homeDir: attackDir(home: true, minute: m),
            departing: {
              for (final a in agents)
                if (a.walkStart != null || _departsWithin(a, t, 10)) a.id,
            },
            seed: (seed ^ ((wi + 1) * 0x9E3779B1)) & 0xFFFFFFFF,
          ),
        );
      }
      _reseed(t);
      final c = carrier;
      if (c != null && agents[c].walkStart != null) _forcePass(agents[c], t);
      if (activeWindow == null) {
        _decide(t);
      } else {
        _stagedBall(t);
      }

      while (sp < specials.length && specials[sp] <= t + 1e-9) {
        sp++;
      }
      var next = math.min(t + StoryLayer.step, total);
      if (sp < specials.length) next = math.min(next, specials[sp]);
      final f = flight;
      if (f != null && f.t1 > t + 1e-9) next = math.min(next, f.t1);
      _step(t, next);
      if (activeWindow == null) {
        if (possession == 0) {
          homeBallTime += next - t;
        } else {
          awayBallTime += next - t;
        }
      }
      t = next;
      if (f != null && t >= f.t1 - 1e-9) _land(t);
      _record(t);
    }
    if (activeWindow != null) activeWindow!.exit = _state(total);
    if (flight != null) _land(total);
    _closePhase(total);

    return PitchScript(
      actorList: actorList,
      keyframes: keyframes,
      ballPhases: phases,
      resets: resets,
      windows: windows,
      departures: departures,
      arrivals: arrivals,
      pacer: pacer,
      result: result,
      homeNationId: lineups.home.nationId,
    );
  }

  // --- set-up --------------------------------------------------------------

  void _registerActors() {
    // Who plays in goal: whoever holds the keeper's slot when he steps on.
    final keepers = <int>{};
    for (final side in [lineups.home, lineups.away]) {
      final slotOf = <int, int>{};
      final gk = side.formation.positions.indexOf(PlayerPosition.gk);
      for (var i = 0; i < side.xi.length; i++) {
        slotOf[side.xi[i].playerId] = i;
        if (i == gk) keepers.add(side.xi[i].playerId);
      }
      for (final e in result.events) {
        if (e.teamNationId != side.nationId) continue;
        if (e.type == MatchEventType.substitution) {
          final off = e.secondaryPlayerId;
          final s = off == null ? null : slotOf[off];
          if (s != null) {
            slotOf[e.playerId] = s;
            if (s == gk) keepers.add(e.playerId);
          }
        }
      }
    }
    void add(int id, int side, int shirt) {
      if (indexOf.containsKey(id)) return;
      final a = _Agent(agents.length, id, side, keeper: keepers.contains(id));
      final r = SeededRng((seed ^ (id * 0x85EBCA6B)) & 0xFFFFFFFF);
      a.phaseA = r.nextDouble() * 2 * math.pi;
      a.phaseB = r.nextDouble() * 2 * math.pi;
      indexOf[id] = a.index;
      agents.add(a);
      actorList.add((
        playerId: id,
        teamNationId: sides[side].nationId,
        shirt: shirt,
        keeper: a.keeper,
      ));
    }

    for (var s = 0; s < 2; s++) {
      final team = sides[s].team;
      for (final p in team.xi) {
        add(p.playerId, s, p.shirt);
      }
    }
    for (final e in result.events) {
      if (e.type != MatchEventType.substitution) continue;
      final s = e.teamNationId == lineups.home.nationId ? 0 : 1;
      final bench = sides[s].team.bench;
      final b = bench.indexOf(e.playerId);
      add(e.playerId, s, b >= 0 ? 12 + b : 12 + bench.length + agents.length);
    }
  }

  void _buildWindows() {
    final bySlot = <(int, int), List<MatchMoment>>{};
    for (final m in result.moments) {
      (bySlot[(m.minute, m.stoppage)] ??= []).add(m);
    }
    final injuriesBySlot = <(int, int), List<MatchEvent>>{};
    for (final e in result.events) {
      if (e.type == MatchEventType.injury) {
        (injuriesBySlot[(e.minute, e.stoppage)] ??= []).add(e);
      }
    }
    final keys = {...bySlot.keys, ...injuriesBySlot.keys}.toList()
      ..sort((a, b) {
        final c = _slotIndex(a.$1, a.$2).compareTo(_slotIndex(b.$1, b.$2));
        return c;
      });
    for (final key in keys) {
      final moments = [...?bySlot[key]]..sort((a, b) => a.seq.compareTo(b.seq));
      var cur = _secs(pacer.screenAt(key.$1, key.$2));
      final end = _secs(pacer.screenAt(key.$1, key.$2, within: 1));
      StagedWindow? last;
      for (final m in moments) {
        final len = _secs(pacer.momentLength(m));
        if (len > 0) {
          last = StagedWindow(start: cur, end: cur + len, moments: [m]);
          windows.add(last);
          cur += len;
        } else if (last != null &&
            m is ShotMoment &&
            last.moments.first is SetPieceMoment &&
            last.moments.length == 1) {
          last.moments.add(m);
        }
      }
      final injuries = injuriesBySlot[key] ?? const [];
      for (var k = 0; k < injuries.length; k++) {
        final len = (end - cur) / (injuries.length - k);
        if (len <= 1e-6) break;
        windows.add(
          StagedWindow(
            start: cur,
            end: cur + len,
            moments: const [],
            injury: injuries[k],
          ),
        );
        cur += len;
      }
    }
  }

  /// When each departure and arrival happens, from the events: a red card
  /// as its foul's window closes, an injury as its own window closes, a sub
  /// as its moment's window closes. The man coming on steps on once the man
  /// he replaces is gone, so a side never shows twelve.
  void _scheduleChanges() {
    var order = 0;
    for (var idx = 0; idx < result.events.length; idx++) {
      final e = result.events[idx];
      final s = e.teamNationId == lineups.home.nationId ? 0 : 1;
      var at = _secs(pacer.screenAt(e.minute, e.stoppage));
      switch (e.type) {
        case MatchEventType.redCard:
          for (final w in windows) {
            final m = w.moments.isEmpty ? null : w.moments.first;
            if (m is FoulMoment && m.cardEventIndex == idx) at = w.end;
          }
          _scheduleDeparture(e.playerId, s, at, order++);
        case MatchEventType.injury:
          for (final w in windows) {
            if (identical(w.injury, e)) at = w.end;
          }
          _scheduleDeparture(e.playerId, s, at, order++);
        case MatchEventType.substitution:
          for (final w in windows) {
            final m = w.moments.isEmpty ? null : w.moments.first;
            if (m is SubMoment && m.eventIndex == idx) at = w.end;
          }
          final off = e.secondaryPlayerId;
          var enter = at;
          if (off != null && indexOf.containsKey(off)) {
            _scheduleDeparture(off, s, at, order++, replaced: true);
            enter = at + PitchScript.walkOffSeconds;
          }
          final onIndex = indexOf[e.playerId];
          if (onIndex == null) break;
          final onAgent = agents[onIndex];
          final offIndex = off == null ? null : indexOf[off];
          arrivals[e.playerId] = math.min(enter, total);
          changes.add(
            _Change(math.min(enter, total), order++, () {
              _arrive(onAgent, s, offIndex);
            }),
          );
        case MatchEventType.goal || MatchEventType.yellowCard:
          break;
      }
    }
    changes.sort((a, b) {
      final c = a.t.compareTo(b.t);
      return c != 0 ? c : a.order.compareTo(b.order);
    });
  }

  void _scheduleDeparture(
    int id,
    int s,
    double at,
    int order, {
    bool replaced = false,
  }) {
    final i = indexOf[id];
    if (i == null || departures.containsKey(id)) return;
    final start = math.min(at, total);
    departures[id] = start;
    final a = agents[i];
    changes.add(
      _Change(start, order, () => _startWalk(a, start, replaced: replaced)),
    );
    final end = start + PitchScript.walkOffSeconds;
    if (end < total) {
      changes.add(_Change(end, order, () => _endWalk(a)));
    }
  }

  // --- departures and arrivals --------------------------------------------

  void _startWalk(_Agent a, double t, {required bool replaced}) {
    if (!a.present || a.walkStart != null) return;
    if (carrier == a.index) _forcePass(a, t);
    a.walkStart = t;
    final ty = a.pos.y < PitchDims.width / 2 ? 0.6 : PitchDims.width - 0.6;
    a.walkTarget = Offset2(a.pos.x, ty);
    final side = sides[a.side];
    final slot = a.slot;
    a.slot = null;
    a.vacatedSlot = slot;
    if (slot == null) return;
    side.owner[slot] = null;
    if (replaced) {
      side.pending[slot] = true;
    } else if (slot != side.gkSlot) {
      side.vacated.add(slot);
    } else {
      // Somebody has to go in goal: the man in the nearest slot.
      int? best;
      var bestD = double.infinity;
      for (var i = 0; i < side.owner.length; i++) {
        if (i == slot || side.owner[i] == null) continue;
        final d =
            (side.layout[i].$1 - side.layout[slot].$1).abs() +
            (side.layout[i].$2 - side.layout[slot].$2).abs();
        if (d < bestD) {
          bestD = d;
          best = i;
        }
      }
      if (best != null) {
        final mover = agents[side.owner[best]!];
        side.owner[slot] = mover.index;
        side.owner[best] = null;
        mover.slot = slot;
        side.vacated.add(best);
      } else {
        side.vacated.add(slot);
      }
    }
    side.reform();
  }

  void _endWalk(_Agent a) {
    a.present = false;
    a.walkStart = null;
    a.vel = Offset2.zero;
  }

  void _arrive(_Agent on, int s, int? offIndex) {
    if (on.present) return;
    final side = sides[s];
    int? slot;
    if (offIndex != null) {
      final v = agents[offIndex].vacatedSlot;
      if (v != null && side.pending[v] && side.owner[v] == null) slot = v;
    }
    // Otherwise the nearest empty place: the one emptied most recently.
    while (slot == null && side.vacated.isNotEmpty) {
      final v = side.vacated.removeLast();
      if (side.owner[v] == null) slot = v;
    }
    if (slot == null) {
      for (var i = 0; i < side.owner.length; i++) {
        if (side.owner[i] == null && !side.pending[i]) {
          slot = i;
          break;
        }
      }
    }
    if (slot == null) return;
    var count = 0;
    for (final a in agents) {
      if (a.present && a.side == s) count++;
    }
    if (count >= 11) return;
    side.pending[slot] = false;
    side.owner[slot] = on.index;
    on.slot = slot;
    // In from the halfway line on the benches' side.
    var spot = const Offset2(PitchDims.length / 2, PitchDims.width - 0.6);
    for (var k = 0; k < 40; k++) {
      final dx = (k.isEven ? 1 : -1) * ((k + 1) ~/ 2) * 1.2;
      final c = Offset2(PitchDims.length / 2 + dx, PitchDims.width - 0.6);
      if (agents.every((o) => !o.present || o.pos.distanceTo(c) >= 1.2)) {
        spot = c;
        break;
      }
    }
    on.present = true;
    on.pos = spot;
    on.vel = Offset2.zero;
    on.facing = -math.pi / 2;
    side.reform();
  }

  /// A carrier who has to leave plays the ball to the nearest team-mate
  /// at least a pass's length away first.
  void _forcePass(_Agent a, double t) {
    _Agent? best;
    var bestD = double.infinity;
    for (final o in agents) {
      if (!o.present || o.side != a.side || o == a || o.walkStart != null) {
        continue;
      }
      final d = o.pos.distanceTo(a.pos);
      if (d >= 8 && d < bestD) {
        bestD = d;
        best = o;
      }
    }
    if (best != null) _startFlight(t, a, best, intercept: false);
  }

  bool _departsWithin(_Agent a, double t, double within) {
    final d = departures[a.id];
    return d != null && d >= t - 1e-9 && d <= t + within;
  }

  // --- kick-off ------------------------------------------------------------

  void _kickoff(double t, int kicking) {
    if (flight != null) _land(t);
    _closePhase(t);
    for (final a in agents) {
      if (a.walkStart != null) _endWalk(a);
    }
    final minute = pacer.matchAt(_dur(t)).minute;
    const centre = PitchDims.centre;
    possession = kicking;
    _updateBackLines(minute, centre);
    for (var s = 0; s < 2; s++) {
      final dir = _dir(s, minute);
      final targets = _anchors(s, minute, t, centre, s == kicking);
      for (final a in agents) {
        if (!a.present || a.side != s) continue;
        var p = targets[a.index] ?? a.pos;
        var depth = xToDepth(p.x, dir).clamp(1.0, 50.5);
        if (a.slot == sides[s].gkSlot) depth = 5;
        p = Offset2(depthToX(depth, dir), p.y);
        if (s != kicking && p.distanceTo(centre) < 10.5) {
          final lat = (p.y - centre.y).clamp(-9.0, 9.0);
          final need = math.sqrt(math.max(0, 10.5 * 10.5 - lat * lat));
          p = Offset2(depthToX(52.5 - need, dir), p.y);
        }
        a.pos = p;
        a.vel = Offset2.zero;
        a.facing = dir > 0 ? 0 : math.pi;
      }
    }
    // The kicker: the kicking side's most advanced man, on the ball.
    final kdir = _dir(kicking, minute);
    _Agent? kicker;
    for (final a in agents) {
      if (!a.present || a.side != kicking || a.slot == sides[kicking].gkSlot) {
        continue;
      }
      if (kicker == null ||
          xToDepth(a.pos.x, kdir) > xToDepth(kicker.pos.x, kdir)) {
        kicker = a;
      }
    }
    kicker!.pos = Offset2(centre.x - kdir * ballLead, centre.y);
    // Spread anybody standing too close.
    for (var it = 0; it < 60; it++) {
      var moved = false;
      for (final a in agents) {
        if (!a.present) continue;
        for (final b in agents) {
          if (b.index <= a.index || !b.present) continue;
          final d = a.pos.distanceTo(b.pos);
          if (d >= 1.4) continue;
          moved = true;
          final away = d < 1e-6 ? const Offset2(0, 1) : (a.pos - b.pos).unit;
          final push = (1.4 - d) / 2 + 0.01;
          if (a != kicker) a.pos = _clampPitch(a.pos + away * push);
          if (b != kicker) b.pos = _clampPitch(b.pos - away * push);
        }
      }
      if (!moved) break;
    }
    carrier = kicker.index;
    phaseStart = t;
    possession = kicking;
    spellStart = t;
    nextAction = t + 0.6;
    spellEnd = t + _spellLength(kicking);
    spellDepth = _depthTarget(kicking, minute);
    cameraX = centre.x;
  }

  // --- the ball ------------------------------------------------------------

  void _reseed(double t) {
    final m = pacer.matchAt(_dur(t));
    final slot = _slotIndex(m.minute, m.stoppage);
    if (slot == rngSlot) return;
    rngSlot = slot;
    rng = SeededRng((seed ^ ((slot + 1) * 0x9E3779B1)) & 0xFFFFFFFF);
  }

  /// Quiet time: when the carrier has had the ball long enough, he passes it
  /// on, to a team-mate or (at the end of his side's spell, or to hand the
  /// ball to the side the next moment belongs to) into an opponent's path.
  void _decide(double t) {
    final c = carrier;
    if (c == null) return;
    final a = agents[c];
    final stop = _nextStop(t);
    final lead = _leadFor(t);
    final leadSide = lead?.$1;
    final ahead = _ahead(a.side);
    // The ball has to be with the side the next moment belongs to as it
    // opens. When it is not, it changes hands now if the side on it has had
    // more than its share, else at the last moment.
    final handover = leadSide != null && leadSide != a.side;
    final handoverDue = handover && (stop - t <= _handover || ahead > 0);
    if (t < nextAction - 1e-9 && !handoverDue) return;
    final keep = leadSide == a.side && stop - t <= _handover;
    final _Agent? target;
    var intercept = false;
    // In a short quiet spell the ball changes hands quickly or not at all.
    final quick = handoverDue || stop - t < 1.5;
    if (handoverDue || (!keep && !handover && _spellOver(t, ahead))) {
      target = _pickInterceptor(a, t, short: quick);
      intercept = true;
    } else {
      final minute = pacer.matchAt(_dur(t)).minute;
      target = _pickReceiver(a, t, minute, lead?.$2);
    }
    if (target == null) {
      nextAction = t + 0.25;
      return;
    }
    final plan = _planFlight(
      t,
      a,
      target,
      intercept: intercept,
      quick: intercept && quick,
    );
    final limit = handover && !handoverDue ? stop - _handover : stop - 0.05;
    if (t + plan.$2 > limit) {
      nextAction = handover && !handoverDue
          ? math.min(t + 0.25, stop - _handover)
          : t + 0.25;
      return;
    }
    _startFlight(t, a, target, intercept: intercept, quick: intercept && quick);
  }

  /// How many screen seconds more than its possession share side [s] has
  /// had the ball for so far (negative when it is owed time).
  double _ahead(int s) {
    final played = homeBallTime + awayBallTime;
    final had = s == 0 ? homeBallTime : awayBallTime;
    return had - _share(s) * played;
  }

  /// Whether the side on the ball gives it up now: its spell has run its
  /// length and it is not owed time, or it is well ahead of its share.
  bool _spellOver(double t, double ahead) {
    if (ahead > 0.15 && t - spellStart > 0.3) return true;
    return t >= spellEnd && ahead > -0.3;
  }

  void _stagedBall(double t) {
    final plan = activePlan;
    final c = carrier;
    if (plan == null || c == null) return;
    final action = plan.ball(t, _state(t));
    switch (action) {
      case PassAction(:final toPlayerId, :final arriveAt, :final peak):
        final to = indexOf[toPlayerId];
        if (to == null || !agents[to].present || to == c) return;
        _startFlight(
          t,
          agents[c],
          agents[to],
          intercept: agents[to].side != agents[c].side,
          arriveAt: arriveAt,
          peak: peak,
        );
      case null:
        break;
    }
  }

  double _nextStop(double t) {
    var stop = total;
    for (final w in windows) {
      if (w.start > t + 1e-9) {
        stop = math.min(stop, w.start);
        break;
      }
    }
    for (final r in resets) {
      if (r > t + 1e-9) stop = math.min(stop, r);
    }
    return stop;
  }

  /// The side the next moment belongs to, and where it happens, when it is
  /// close enough for the build-up to lead into it.
  (int, Offset2)? _leadFor(double t) {
    for (final w in windows) {
      if (w.start <= t + 1e-9) continue;
      if (w.start - t > _leadIn || w.moments.isEmpty) return null;
      final m = w.moments.first;
      if (m is SubMoment) return null;
      final s = m.teamNationId == lineups.home.nationId ? 0 : 1;
      final minute = m.minute;
      final dir = _dir(s, minute);
      final p = switch (m) {
        ShotMoment(:final zone) => zonePoint(zone, dir),
        SetPieceMoment(:final zone, :final left) => zonePoint(
          zone,
          dir,
          left: left,
        ),
        FoulMoment(:final zone) => zonePoint(zone, dir),
        OffsideMoment() => Offset2(depthToX(72, dir), PitchDims.width / 2),
        SubMoment() => PitchDims.centre,
      };
      return (s, p);
    }
    return null;
  }

  (Offset2, double, double, Offset2) _planFlight(
    double t,
    _Agent from,
    _Agent to, {
    required bool intercept,
    bool quick = false,
  }) {
    final start = _ballPoint(from);
    final away = (to.pos - start).unit;
    final dir = _dir(to.side, pacer.matchAt(_dur(t)).minute);
    var lead = intercept
        ? to.pos - away * 0.6
        : to.pos + away * 1.2 + Offset2(dir * 0.6, 0);
    lead = _clampPitch(lead, margin: 1.5);
    final dist = lead.distanceTo(start);
    final lofted = dist > 26;
    final v = quick
        ? (18 + 0.4 * dist).clamp(18.0, 28.0)
        : (lofted ? 15 + 0.2 * dist : 11 + 0.4 * dist).clamp(11.0, 26.0);
    final dur = math.max(quick ? 0.25 : 0.4, dist / v);
    final peak = lofted ? math.min(1.5 + 0.12 * dist, 7).toDouble() : 0.0;
    return (start, dur, peak, lead);
  }

  void _startFlight(
    double t,
    _Agent from,
    _Agent to, {
    required bool intercept,
    double? arriveAt,
    double? peak,
    bool quick = false,
  }) {
    final plan = _planFlight(t, from, to, intercept: intercept, quick: quick);
    final fastest = t + plan.$1.distanceTo(plan.$4) / 30;
    final t1 = arriveAt != null ? math.max(arriveAt, fastest) : t + plan.$2;
    _closePhase(t);
    flight = _Flight(
      t0: t,
      t1: t1,
      from: plan.$1,
      fromActor: from.index,
      toActor: to.index,
      peak: peak ?? plan.$3,
      lead: plan.$4,
    );
    carrier = null;
  }

  void _land(double t) {
    final f = flight!;
    final to = agents[f.toActor];
    final point = _ballPoint(to);
    phases.add(
      FlightPhase(
        f.t0,
        t,
        from: f.from,
        to: point,
        peak: f.peak,
        fromActor: f.fromActor,
        toActor: f.toActor,
      ),
    );
    flight = null;
    carrier = to.index;
    phaseStart = t;
    if (to.side != possession) {
      possession = to.side;
      spellStart = t;
      spellEnd = t + _spellLength(possession);
      spellDepth = _depthTarget(possession, pacer.matchAt(_dur(t)).minute);
    }
    final tempo = sides[to.side].instr.tempo;
    nextAction = t + (0.55 + rng.nextDouble() * 0.8) * (1.15 - tempo / 250);
  }

  void _closePhase(double t) {
    final c = carrier;
    if (c != null && t > phaseStart + 1e-9) {
      phases.add(CarryPhase(phaseStart, t, c));
    }
    phaseStart = t;
  }

  _Agent? _pickReceiver(_Agent a, double t, int minute, Offset2? leadPoint) {
    final s = a.side;
    final side = sides[s];
    final dir = _dir(s, minute);
    final ball = _ballPoint(a);
    final ballDepth = xToDepth(ball.x, dir);
    final quiet = _quietSlotSeconds(t);
    final c = 60 / quiet;
    final lStar = (12 + 0.2 * c + (side.instr.directness - 50) * 0.12).clamp(
      12.0,
      32.0,
    );
    var target = spellDepth;
    double? lateralTarget;
    if (leadPoint != null) {
      target = math.min(xToDepth(leadPoint.x, dir), 86);
      lateralTarget = (leadPoint.y - PitchDims.width / 2) * dir;
    }
    final want = (target - ballDepth).clamp(-12.0, 20.0);
    _Agent? best;
    var bestScore = -double.infinity;
    for (final m in agents) {
      if (!m.present || m.side != s || m == a || m.walkStart != null) continue;
      if (_departsWithin(m, t, 6)) continue;
      final d = m.pos.distanceTo(ball);
      if (d < 8 || d > 42) continue;
      final keeper = m.slot == side.gkSlot;
      if (keeper && ballDepth > 35) continue;
      final gain = xToDepth(m.pos.x, dir) - ballDepth;
      var open = 8.0;
      var lane = 4.0;
      for (final o in agents) {
        if (!o.present || o.side == s) continue;
        open = math.min(open, o.pos.distanceTo(m.pos));
        lane = math.min(lane, _distToSegment(o.pos, ball, m.pos));
      }
      var score =
          -(d - lStar).abs() / 8 -
          (gain - want).abs() / 7 +
          open / 4 +
          (lane < 1.8 ? -2 : 0) +
          rng.nextDouble() * 1.2;
      if (lateralTarget != null) {
        final lat = (m.pos.y - PitchDims.width / 2) * dir;
        score -= (lat - lateralTarget).abs() / 12;
      }
      if (keeper) score -= 1.5;
      if (score > bestScore) {
        bestScore = score;
        best = m;
      }
    }
    return best;
  }

  _Agent? _pickInterceptor(_Agent a, double t, {bool short = false}) {
    final s = a.side;
    final minute = pacer.matchAt(_dur(t)).minute;
    final dir = _dir(s, minute);
    final ball = _ballPoint(a);
    final ballDepth = xToDepth(ball.x, dir);
    _Agent? best;
    var bestScore = -double.infinity;
    for (final o in agents) {
      if (!o.present || o.side == s || o.walkStart != null) continue;
      if (_departsWithin(o, t, 6)) continue;
      final d = o.pos.distanceTo(ball);
      if (d < 9 || d > 32) continue;
      if (o.slot == sides[o.side].gkSlot && ballDepth < 75) continue;
      final ahead = xToDepth(o.pos.x, dir) - ballDepth;
      if (short && d > 16) continue;
      final score =
          -(d - (short ? 10 : 14)).abs() / 6 +
          (ahead > 0 ? 1 : 0) +
          rng.nextDouble();
      if (score > bestScore) {
        bestScore = score;
        best = o;
      }
    }
    return best;
  }

  double _share(int s) =>
      s == 0 ? result.homePossession / 100 : 1 - result.homePossession / 100;

  /// How long side [s] keeps the ball before giving it up, in screen
  /// seconds: its possession share of a typical spell, corrected by how far
  /// the ball time so far has strayed from that share.
  double _spellLength(int s) {
    final share = _share(s);
    final played = homeBallTime + awayBallTime;
    final h = played < 1
        ? share
        : (s == 0 ? homeBallTime : awayBallTime) / played;
    final corr = (1 + 6 * (share - h)).clamp(0.3, 3.0);
    final base = 1.6 + 1.6 * rng.nextDouble();
    return (base * share / 0.5 * corr).clamp(0.8, 10.0);
  }

  double _momentumFor(int s, int minute) {
    final series = result.momentumByMinute;
    if (series.isEmpty) return 0;
    final m = series[minute.clamp(0, series.length - 1)];
    return s == 0 ? m : -m;
  }

  double _depthTarget(int s, int minute) {
    final instr = sides[s].instr;
    final mom = _tanh(_momentumFor(s, minute) / 3);
    return (58 +
            16 * mom +
            (instr.mentality - 50) * 0.15 +
            (rng.nextDouble() - 0.5) * 16)
        .clamp(35.0, 86.0);
  }

  // --- movement ------------------------------------------------------------

  /// Where every man of side [s] belongs right now: his slot in the shape,
  /// moved up or down the pitch with the ball, squeezed or stretched by
  /// possession and the instructions, shifted toward the ball's side.
  Map<int, Offset2> _anchors(
    int s,
    int minute,
    double t,
    Offset2 ball,
    bool inPossession,
  ) {
    final side = sides[s];
    final instr = side.instr;
    final dir = _dir(s, minute);
    final ballDepth = xToDepth(ball.x, dir);
    final ballLat = (ball.y - PitchDims.width / 2) * dir;
    final opp = sides[1 - s];
    final lineAdj = (instr.defensiveLine - 50) / 50 * 6;
    final length = inPossession
        ? 38 + instr.mentality * 0.08
        : 26 + (100 - instr.pressing) * 0.04;
    final width = ((inPossession ? 60 : 44) * (0.85 + 0.3 * instr.width / 100))
        .clamp(30.0, 64.0);
    final shift = inPossession ? 0.2 : 0.35;
    final offsideLine = PitchDims.length - opp.backLine + 1.0;
    final out = <int, Offset2>{};
    for (var i = 0; i < side.owner.length; i++) {
      final idx = side.owner[i];
      if (idx == null) continue;
      final a = agents[idx];
      final (lx, ly) = side.effective[i];
      if (i == side.gkSlot) {
        final depth = (4 + 0.12 * ballDepth + lineAdj * 0.3).clamp(3.0, 17.0);
        final lat = (ballLat * 0.15).clamp(-6.0, 6.0);
        out[idx] = Offset2(depthToX(depth, dir), lateralToY(lat, dir));
        continue;
      }
      final d = ((0.80 - ly) / 0.69).clamp(0.0, 1.0);
      var depth =
          side.backLine + d * length + math.sin(0.6 * t + a.phaseA) * 1.3;
      depth = math.min(depth, math.max(offsideLine, side.backLine + 4));
      depth = depth.clamp(3.0, 99.0);
      final lat =
          ((lx - 0.5) * width +
                  ballLat * shift +
                  math.sin(0.45 * t + a.phaseB) * 1.1)
              .clamp(-32.0, 32.0);
      out[idx] = Offset2(depthToX(depth, dir), lateralToY(lat, dir));
    }
    return out;
  }

  void _updateBackLines(int minute, Offset2 ball) {
    for (var s = 0; s < 2; s++) {
      final side = sides[s];
      final dir = _dir(s, minute);
      final ballDepth = xToDepth(ball.x, dir);
      final lineAdj = (side.instr.defensiveLine - 50) / 50 * 6;
      side.backLine =
          (8 + 0.48 * ballDepth + lineAdj + (possession == s ? 5 : -1)).clamp(
            9.0,
            54.0,
          );
    }
  }

  void _step(double t0, double t1) {
    final dt = t1 - t0;
    if (dt <= 1e-9) return;
    final minute = pacer.matchAt(_dur(t0)).minute;
    final ball = _ballNow(t0);
    _updateBackLines(minute, ball);
    final inWindow = activeWindow != null;
    final plan = activePlan;
    final state = inWindow && plan is! _Hold ? _state(t0) : null;

    final anchors = <int, Offset2>{
      ..._anchors(0, minute, t0, ball, possession == 0),
      ..._anchors(1, minute, t0, ball, possession == 1),
    };

    // Who presses: the nearest one or two of the side without the ball.
    final pressers = <int>{};
    if (!inWindow) {
      final def = 1 - possession;
      final n = sides[def].instr.pressing >= 65 ? 2 : 1;
      final cand =
          [
            for (final a in agents)
              if (a.present &&
                  a.side == def &&
                  a.walkStart == null &&
                  a.slot != null &&
                  a.slot != sides[def].gkSlot)
                a,
          ]..sort(
            (x, y) => x.pos.distanceTo(ball).compareTo(y.pos.distanceTo(ball)),
          );
      for (final a in cand.take(n)) {
        pressers.add(a.index);
      }
    }

    final present = [
      for (final a in agents)
        if (a.present) a,
    ];
    final proposed = <int, Offset2>{};
    final priority = <int, int>{};
    for (final a in present) {
      final (target, maxSpeed, prio) = _drive(
        a,
        t0,
        minute,
        ball,
        anchors,
        pressers,
        inWindow,
        plan,
        state,
      );
      priority[a.index] = prio;
      final desired = target - a.pos;
      final dist = desired.length;
      var v = desired.unit * math.min(maxSpeed, dist / 0.5);
      // Keep a little room around everybody.
      for (final o in present) {
        if (o == a) continue;
        final d = a.pos.distanceTo(o.pos);
        if (d < 2.0) {
          final away = d < 1e-6 ? const Offset2(0, 1) : (a.pos - o.pos).unit;
          v = v + away * ((2.0 - d) * 1.5);
        }
      }
      v = v.capped(math.max(maxSpeed, maxSpeed > 0 ? 2.0 : 0.0));
      final dv = (v - a.vel).capped(_accel * dt);
      var nv = (a.vel + dv).capped(_hardSpeed);
      if (maxSpeed <= 0 && a.walkStart == null) nv = Offset2.zero;
      var p = _clampPitch(a.pos + nv * dt);
      if (!inWindow && (a.slot == sides[a.side].gkSlot || a.keeper)) {
        final dir = _dir(a.side, minute);
        final depth = xToDepth(p.x, dir);
        if (depth > _keeperMaxDepth) {
          p = Offset2(depthToX(_keeperMaxDepth, dir), p.y);
        }
      }
      proposed[a.index] = p;
    }

    _resolve(present, proposed, priority);

    for (final a in present) {
      final p = proposed[a.index]!;
      a.vel = (p - a.pos) * (1 / dt);
      a.pos = p;
    }
    // Facing: the carrier where he runs (or the goal he attacks), everyone
    // else toward the ball.
    final ballAfter = _ballNow(t1);
    for (final a in present) {
      double want;
      if (a.walkStart != null) {
        want = a.vel.length > 0.3 ? a.vel.angle : a.facing;
      } else if (carrier == a.index) {
        final dir = _dir(a.side, minute);
        want = a.vel.length > 0.8 ? a.vel.angle : (dir > 0 ? 0 : math.pi);
      } else {
        final to = ballAfter - a.pos;
        want = to.length < 0.3 ? a.facing : to.angle;
      }
      a.facing = _turn(a.facing, want, _turnRate * dt);
    }
    // Camera: after the ball, gently.
    final camTarget = ballAfter.x.clamp(30.0, 75.0);
    cameraX += (camTarget - cameraX).clamp(-10 * dt, 10 * dt);
  }

  (Offset2, double, int) _drive(
    _Agent a,
    double t,
    int minute,
    Offset2 ball,
    Map<int, Offset2> anchors,
    Set<int> pressers,
    bool inWindow,
    StagedPlan? plan,
    ScriptState? state,
  ) {
    if (a.walkStart != null) return (a.walkTarget!, 3.5, 3);
    final side = sides[a.side];
    final dir = _dir(a.side, minute);
    final isKeeper = a.slot == side.gkSlot;
    if (inWindow) {
      final d = plan == null || state == null
          ? null
          : plan.drive(a.id, t, state);
      if (d != null) return (d.target, d.maxSpeed.clamp(0.0, _hardSpeed), 2);
      return (a.pos, 0, 2);
    }
    final anchor = anchors[a.index] ?? a.pos;
    if (carrier == a.index) {
      final depth = xToDepth(a.pos.x, dir);
      final lead = _leadFor(t);
      final targetDepth = lead != null && lead.$1 == a.side
          ? math.min(xToDepth(lead.$2.x, dir), 86)
          : spellDepth;
      final fwd = depth < targetDepth - 4 ? 6.0 : 1.5;
      final lat = (a.pos.y - PitchDims.width / 2) * dir;
      final latWant = (lat * 0.85).clamp(-28.0, 28.0);
      final tgt = Offset2(
        depthToX(math.min(depth + fwd, 86), dir),
        lateralToY(latWant, dir),
      );
      return (tgt, 4.5 + side.instr.tempo * 0.012, 2);
    }
    final f = flight;
    if (f != null && f.toActor == a.index) {
      final left = math.max(0.15, f.t1 - t);
      final need = a.pos.distanceTo(f.lead) / left;
      return (f.lead, math.min(8, need + 1), 2);
    }
    if (isKeeper) return (anchor, 5.5, 2);
    if (pressers.contains(a.index)) {
      final ownGoal = Offset2(depthToX(0, dir), PitchDims.width / 2);
      final spot = ball + (ownGoal - ball).unit * 2.2;
      return (spot, 5 + side.instr.pressing * 0.025, 1);
    }
    final dist = a.pos.distanceTo(anchor);
    final speed = (2.5 + dist * 0.5 + side.instr.tempo * 0.008).clamp(
      2.5,
      6.5,
    );
    return (anchor, speed, 1);
  }

  /// Nobody walks through anybody: any two whose straight-line paths over
  /// the step would bring them closer than [_safeGap] are slowed, the less
  /// important first, down to standing still (which is always safe, as the
  /// last step ended with everyone apart).
  void _resolve(
    List<_Agent> present,
    Map<int, Offset2> proposed,
    Map<int, int> priority,
  ) {
    final n = present.length;
    final f = List<double>.filled(n, 1);
    final old = [for (final a in present) a.pos];
    final prop = [for (final a in present) proposed[a.index]!];
    Offset2 at(int i) => Offset2.lerp(old[i], prop[i], f[i]);
    for (var round = 0; round < 40; round++) {
      var conflict = false;
      for (var i = 0; i < n; i++) {
        for (var j = i + 1; j < n; j++) {
          final reach =
              (prop[i] - old[i]).length + (prop[j] - old[j]).length + _safeGap;
          if (old[i].distanceTo(old[j]) > reach) continue;
          final d = PitchScriptValidator.closestApproach(
            old[i],
            at(i),
            old[j],
            at(j),
          );
          if (d >= _safeGap) continue;
          conflict = true;
          final pi = priority[present[i].index]!;
          final pj = priority[present[j].index]!;
          var k = pi <= pj ? i : j;
          if (f[k] == 0) k = k == i ? j : i;
          f[k] = (round < 20 && f[k] > 0.3) ? f[k] * 0.5 : 0;
        }
      }
      if (!conflict) break;
    }
    for (var i = 0; i < n; i++) {
      proposed[present[i].index] = at(i);
    }
  }

  // --- helpers -------------------------------------------------------------

  Offset2 _ballPoint(_Agent a) => a.pos + Offset2.fromAngle(a.facing, ballLead);

  Offset2 _ballNow(double t) {
    final f = flight;
    if (f != null) {
      final u = f.t1 <= f.t0
          ? 1.0
          : ((t - f.t0) / (f.t1 - f.t0)).clamp(0.0, 1.0);
      return Offset2.lerp(f.from, f.lead, u);
    }
    final c = carrier;
    return c == null ? PitchDims.centre : _ballPoint(agents[c]);
  }

  ScriptState _state(double t) => ScriptState(
    t: t,
    players: {
      for (final a in agents)
        if (a.present) a.id: a.pos,
    },
    ball: _ballNow(t),
    carrierId: carrier == null ? null : agents[carrier!].id,
    possessionNationId: sides[possession].nationId,
  );

  void _record(double t) {
    final n = agents.length;
    final xs = Float64List(n);
    final ys = Float64List(n);
    final face = Float64List(n);
    for (var i = 0; i < n; i++) {
      final a = agents[i];
      xs[i] = a.present ? a.pos.x : double.nan;
      ys[i] = a.present ? a.pos.y : double.nan;
      face[i] = a.facing;
    }
    keyframes.add(
      ScriptKeyframe(
        t: t,
        xs: xs,
        ys: ys,
        facing: face,
        cameraX: cameraX,
        zoom: 1,
      ),
    );
  }

  int _dir(int s, int minute) => attackDir(home: s == 0, minute: minute);

  double _quietSlotSeconds(double t) {
    final m = pacer.matchAt(_dur(t));
    final len =
        _secs(pacer.screenAt(m.minute, m.stoppage, within: 1)) -
        _secs(pacer.screenAt(m.minute, m.stoppage));
    return math.max(len, PitchPacer.minQuietSeconds);
  }

  int _slotIndex(int minute, int stoppage) {
    if (minute > 90) return 90 + result.stoppage + (minute - 91);
    if (stoppage > 0) return 90 + stoppage - 1;
    return minute - 1;
  }

  static Offset2 _clampPitch(Offset2 p, {double margin = 0.5}) => Offset2(
    p.x.clamp(margin, PitchDims.length - margin),
    p.y.clamp(margin, PitchDims.width - margin),
  );

  static double _distToSegment(Offset2 p, Offset2 a, Offset2 b) {
    final ab = b - a;
    final l2 = ab.x * ab.x + ab.y * ab.y;
    if (l2 < 1e-9) return p.distanceTo(a);
    final u = (((p.x - a.x) * ab.x + (p.y - a.y) * ab.y) / l2).clamp(0.0, 1.0);
    return p.distanceTo(a + ab * u);
  }

  static double _turn(double from, double to, double maxStep) {
    var d = (to - from) % (2 * math.pi);
    if (d > math.pi) d -= 2 * math.pi;
    if (d < -math.pi) d += 2 * math.pi;
    return from + d.clamp(-maxStep, maxStep);
  }

  static double _tanh(double x) {
    final e = math.exp(2 * x);
    return (e - 1) / (e + 1);
  }

  static double _secs(Duration d) => d.inMicroseconds / 1e6;
  static Duration _dur(double s) => Duration(microseconds: (s * 1e6).round());
}
