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
///
/// ## Shape over the match
///
/// A side lines up in its team-sheet formation, slot switches and
/// instructions, and the manager's live changes ([LineupChange]) reshape it
/// at their minute. A side with no live changes (the AI opponent) plays the
/// plan the engine says it fielded for most of the match ([TeamSide.plan]).
/// The AI's minute-by-minute nudges to its instructions are not followed:
/// they are small, and redrawing the shape every minute would read as
/// jitter.
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
import 'package:fnm/domain/services/match/pitch/moment_staging.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/switched_layout.dart';

/// A side's plan: its shape and instructions.
typedef MatchPlan = FieldedPlan;

/// One of a side's starting eleven. In `TeamSide.xi` the list order is the
/// formation's slot order: `xi[i]` plays slot `i` of the formation.
typedef LineupPlayer = ({int playerId, PlayerPosition slot, int shirt});

/// One side as the Pitch view lines it up.
typedef TeamSide = ({
  int nationId,
  Formation formation,
  SlotSwitches switches,
  List<LineupPlayer> xi,
  List<int> bench,
  TacticalInstructions instructions,
  MatchPlan plan,
});

/// A live tactical change as the Pitch view needs it: from [minute] the side
/// lines up in [formation] with [switches] and [instructions], [xi][k]
/// playing formation slot [slotOf][k].
typedef LineupChange = ({
  int teamNationId,
  int minute,
  Formation formation,
  SlotSwitches switches,
  TacticalInstructions instructions,
  List<int> xi,
  List<int> slotOf,
});

/// Both sides' line-ups, and the live changes made to them.
typedef MatchLineups = ({
  TeamSide home,
  TeamSide away,
  List<LineupChange> changes,
});

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
    switches: team.switches,
    xi: xi,
    bench: bench,
    instructions: team.instructions,
    plan: plan ?? (formation: team.formation, instructions: team.instructions),
  );
}

/// [c] as the Pitch view needs it: each man's formation slot index. A man
/// whose place the change names takes the first free slot playing that
/// place; otherwise his index in the eleven is his slot, as the engine reads
/// it.
LineupChange lineupChangeOf(TacticalChange c) {
  final positions = c.switches.apply(c.formation);
  final used = <int>{};
  final slots = <int>[];
  for (var i = 0; i < c.xi.length; i++) {
    int? slot;
    if (c.slots == null && i < positions.length) {
      slot = i;
    } else {
      final want = c.slotOf(i);
      for (var j = 0; j < positions.length; j++) {
        if (!used.contains(j) && positions[j] == want) {
          slot = j;
          break;
        }
      }
    }
    if (slot == null || used.contains(slot)) {
      slot = null;
      for (var j = 0; j < positions.length; j++) {
        if (!used.contains(j)) {
          slot = j;
          break;
        }
      }
    }
    slots.add(slot ?? -1);
    if (slot != null) used.add(slot);
  }
  return (
    teamNationId: c.teamNationId,
    minute: c.minute,
    formation: c.formation,
    switches: c.switches,
    instructions: c.instructions,
    xi: [for (final p in c.xi) p.id],
    slotOf: slots,
  );
}

/// Both sides' line-ups for a match between [home] and [away]: each side's
/// [MatchPlan] is the one [result] says it fielded, when known, and
/// [changes] are the live tactical changes the match was played with.
MatchLineups matchLineupsOf({
  required MatchTeam home,
  required MatchTeam away,
  List<int> homeBench = const [],
  List<int> awayBench = const [],
  MatchResult? result,
  List<TacticalChange> changes = const [],
}) => (
  home: teamSideOf(home, bench: homeBench, plan: result?.homePlan),
  away: teamSideOf(away, bench: awayBench, plan: result?.awayPlan),
  changes: [for (final c in changes) lineupChangeOf(c)],
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

/// Cut the picture (see `PitchScript.cuts`) to a moment ready to happen:
/// the men in [positions] stand there and the ball lies at [ballAt].
///
/// A set-piece cut ([PitchCutKind.setPiece]) leaves everybody else where he
/// is, stepping aside if a man placed lands on him. A phase cut
/// ([PitchCutKind.phase], open play: a shot, foul or offside that cannot be
/// reached from where play is) lines everybody else up in his side's shape
/// around the ball, [possession] on it, as the story layer would have them
/// there; then [offside] (a man to be flagged) is put beyond the line and
/// every man in [onside] behind it. Keepers keep goal and men walking off
/// are never moved.
final class CutAction extends BallAction {
  const CutAction({
    required this.ballAt,
    required this.positions,
    this.kind = PitchCutKind.setPiece,
    this.possession,
    this.offside,
    this.onside = const {},
  });

  final Offset2 ballAt;
  final Map<int, Offset2> positions;
  final PitchCutKind kind;

  /// For a phase cut: the side on the ball.
  final int? possession;
  final int? offside;
  final Set<int> onside;
}

/// Kick (or head, or throw) the ball from wherever it is (at its carrier's
/// feet, or lying still) either to the point [to], where it then lies, or
/// to [toPlayerId]'s feet, arriving at screen second [arriveAt] at the
/// earliest. It leaves at [fromHeight] and arrives at [toHeight], rising
/// [peak] metres more halfway.
///
/// Not a pass: a shot, a header, a clearance, a deflection, a ball set
/// down for a dead-ball kick, a loose ball collected. [byPlayerId] names
/// who kicks a ball lying still (the corner taker); a carried ball is
/// kicked by its carrier.
final class KickAction extends BallAction {
  const KickAction({
    required this.arriveAt,
    this.to,
    this.toPlayerId,
    this.byPlayerId,
    this.peak = 0,
    this.fromHeight = 0,
    this.toHeight = 0,
    this.pass = false,
    this.shot = false,
  }) : assert((to == null) != (toPlayerId == null), 'a point or a player');

  final Offset2? to;
  final int? toPlayerId;
  final int? byPlayerId;
  final double arriveAt;
  final double peak;
  final double fromHeight;
  final double toHeight;

  /// Whether it counts as a pass (a free kick played to a team-mate).
  final bool pass;

  /// Whether it is a moment's shot: never cut short in the air.
  final bool shot;
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
    this.homePossessionShare = 0.5,
    this.next,
    this.ahead = const [],
    this.events = const [],
    this.resuming = false,
    this.hardEnd = double.infinity,
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

  /// The home side's possession share (0-1) the ball time aims at.
  final double homePossessionShare;

  /// The window after this one, when there is one: a stager may leave the
  /// ball where the next moment wants it (a foul's free kick) and send its
  /// taker on his way.
  final StagedWindow? next;

  /// The windows that open within a few seconds of this one closing, in
  /// order ([next] first): their men can be on their way.
  final List<StagedWindow> ahead;

  /// The match's events, for what a moment points at (a foul's card).
  final List<MatchEvent> events;

  /// Whether [entry] is where a resumed script starts: the picture there
  /// is what was already shown, so the plan carries on from it (it never
  /// cuts on that frame).
  final bool resuming;

  /// When the moment must be over by: an interval's kick-off or the final
  /// whistle soon after the window, else infinity.
  final double hardEnd;

  /// Screen seconds of ball time side [nationId] is owed as the window opens
  /// (negative when it has had more than its share). A stager that can
  /// choose who ends the moment on the ball should favour the side owed.
  ///
  /// Measured at [at] (a state the stager is handed during the window), or
  /// at the window's entry.
  double owedTo(int nationId, [ScriptState? at]) {
    final state = at ?? entry;
    final played = state.homeBallTime + state.awayBallTime;
    final home = nationId == lineups.home.nationId;
    final share = home ? homePossessionShare : 1 - homePossessionShare;
    final had = home ? state.homeBallTime : state.awayBallTime;
    return share * played - had;
  }
}

/// Fills a staged-moment window. The story layer asks once per window and
/// then, every step, where each player heads and what the ball does; it
/// still applies every speed and spacing rule itself, so a stager only
/// choreographs.
///
/// Inside a window a keeper may leave his area only when the window's
/// moment names him (`StagedWindow.actors`): a save, a claim, a
/// distribution. A keeper the stager gives no drive is never left standing
/// away from goal: the story layer walks him to his place in the shape.
/// Every other man the stager gives no drive stands still.
///
/// The stager may be asked to stage a window from part-way through it (a
/// resume after a re-simulation hands it the state at the playhead as its
/// entry), so a plan reads the state it is handed and carries on from
/// there rather than replaying the window from its start.
///
/// The default, [MomentStaging], stages every real moment from its data.
abstract interface class MomentStager {
  StagedPlan stage(StagingContext context);
}

/// One window's choreography.
abstract interface class StagedPlan {
  /// Where [playerId] heads at screen second [t]; null holds him still.
  PlayerDrive? drive(int playerId, double t, ScriptState now);

  /// A ball action to start at screen second [t]; null leaves the ball be.
  BallAction? ball(double t, ScriptState now);

  /// Whether the moment has played out (its shot struck and the ball with
  /// somebody, its set piece taken...). A plan not settled as its window
  /// ends plays on into the quiet time after it, for a moment, when
  /// nothing else is due.
  bool settled(double t, ScriptState now);
}

/// The placeholder stager: everyone holds still. It does only what a
/// moment cannot do without, with the ball:
///
/// - as the window opens, when the ball is not with the side the moment
///   belongs to, it is passed straight to that side's nearest man;
/// - as the window closes, when the side on the ball has had more than its
///   possession share ([StagingContext.owedTo]), it is played to the other
///   side's nearest man, as a moment's aftermath usually hands it over.
///
/// Keeps every invariant, so the story layer stands on its own until the
/// real stagers exist.
class NeutralHold implements MomentStager {
  const NeutralHold();

  @override
  StagedPlan stage(StagingContext context) => _Hold(context);
}

class _Hold implements StagedPlan {
  _Hold(this.context);

  final StagingContext context;
  bool _opened = false;
  bool _closed = false;

  @override
  PlayerDrive? drive(int playerId, double t, ScriptState now) => null;

  @override
  bool settled(double t, ScriptState now) => true;

  @override
  BallAction? ball(double t, ScriptState now) {
    final w = context.window;
    final carrier = now.carrierId;
    if (!_opened) {
      _opened = true;
      if (w.moments.isEmpty || carrier == null) return null;
      final m = w.moments.first;
      if (m is SubMoment || now.teams[carrier] == m.teamNationId) return null;
      return _passTo(m.teamNationId, t, now);
    }
    if (_closed || carrier == null || t < w.end - 0.9) return null;
    final side = now.teams[carrier];
    if (side == null || context.owedTo(side, now) > -0.3) {
      _closed = true;
      return null;
    }
    final other = side == context.lineups.home.nationId
        ? context.lineups.away.nationId
        : context.lineups.home.nationId;
    final pass = _passTo(other, t, now);
    if (pass != null) _closed = true;
    return pass;
  }

  /// A pass from the carrier to [side]'s nearest man at least 8 m away,
  /// landing inside the window.
  PassAction? _passTo(int side, double t, ScriptState now) {
    final w = context.window;
    int? best;
    var bestD = double.infinity;
    now.players.forEach((id, p) {
      if (now.teams[id] != side ||
          context.departing.contains(id) ||
          now.walking.contains(id)) {
        return;
      }
      final d = p.distanceTo(now.ball);
      if (d >= 8 && d < bestD) {
        bestD = d;
        best = id;
      }
    });
    final to = best;
    if (to == null) return null;
    final arrive = t + math.max(bestD / 28, 0.3);
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
  ///
  /// With [resumeFrom] (a state captured by `PitchScript.stateAt` from the
  /// script shown so far), the script starts at that state's match minute
  /// instead of the kick-off, with everybody exactly where the state has
  /// them: a re-simulated result picks up from the playhead with no jump.
  static PitchScript build({
    required MatchResult result,
    required MatchLineups lineups,
    required PitchPacer pacer,
    required int seed,
    MomentStager stager = const MomentStaging(),
    ScriptState? resumeFrom,
  }) => _Builder(result, lineups, pacer, seed, stager).run(resumeFrom);
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

/// The slot coordinates [formation] with [switches] is drawn with, once
/// [instructions] have moved the lines: the tactics board's own arithmetic.
List<(double, double)> slotLayout(
  Formation formation,
  SlotSwitches switches,
  TacticalInstructions instructions,
) {
  final base = switchedLayoutOf(formation, switches);
  final positions = switches.apply(formation);
  return [
    for (var i = 0; i < base.length; i++)
      (
        base[i].$1,
        adjustedSlotY(base[i].$2, positions[i].category, instructions),
      ),
  ];
}

// ---------------------------------------------------------------------------

const double _hardSpeed = 8.8;
const double _walkCap = 2.2;
const double _accel = 9;
const double _turnRate = 7;
const double _safeGap = 0.9;
const double _leadIn = 3.5;

/// How long before a moment the men it needs set off for where it needs
/// them (a set piece's taker for the ball, a shooter for where he shoots
/// from). A man far away needs most of it.
const double _takerLead = 10;

/// The longest a moment's plan plays on past its window.
const double _spill = 3;

/// How long before a foul its two men close on each other.
const double _foulLead = 8;

/// How long before a moment the side it belongs to keeps the ball it has.
const double _handover = 1.3;

/// How long before a moment the ball changes hands, at the latest, when it
/// has to and the side on it is owed ball time.
const double _lateHandover = 0.75;
const double _keeperMaxDepth = 24.5;

/// Where a man walking off leaves the picture: this far inside the line.
const double _edge = 0.5;

/// How deep a keeper's area reaches.
const double _area = 16.5;

class _Agent {
  _Agent(this.index, this.id, this.side);
  final int index;
  final int id;
  final int side;
  bool present = false;
  Offset2 pos = Offset2.zero;
  Offset2 vel = Offset2.zero;
  double facing = 0;
  int? slot;
  double? walkStart;
  Offset2? walkTarget;

  /// Whether he walks off over a goal line (else a touchline).
  bool walkToGoalLine = false;

  /// A keeper on his way in while a stand-in minds goal.
  bool headingInGoal = false;

  /// Whether he is named for the keeper's slot when he steps on.
  bool namedKeeper = false;

  /// Whether he has ever been on the pitch.
  bool appeared = false;

  /// Whether he has left it for good.
  bool gone = false;

  /// The slot he left, kept for the man who replaces him.
  int? vacatedSlot;
  double phaseA = 0;
  double phaseB = 0;
}

class _Side {
  _Side(this.team, {required this.home});

  final TeamSide team;
  final bool home;
  late Formation formation;
  late SlotSwitches switches;
  late TacticalInstructions instr;
  late List<(double, double)> layout;
  late List<(double, double)> effective;
  late List<int?> owner;
  late List<bool> pending;

  /// Slots emptied with nobody named to fill them, latest last.
  final List<int> vacated = [];

  /// An outfielder minding goal until the keeper on his way arrives, and
  /// the slot he goes back to.
  ({int agent, int back})? standIn;
  double backLine = 30;

  int get nationId => team.nationId;
  int get gkSlot {
    final i = formation.positions.indexOf(PlayerPosition.gk);
    return i < 0 ? 0 : i;
  }

  void reshape(Formation f, SlotSwitches sw, TacticalInstructions i) {
    formation = f;
    switches = sw;
    instr = i;
    layout = slotLayout(f, sw, i);
    owner = List<int?>.filled(layout.length, null);
    pending = List<bool>.filled(layout.length, false);
    vacated.clear();
    standIn = null;
    effective = [...layout];
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

/// Something the builder does at a screen second: a departure, an arrival
/// joining the queue, a live change.
class _Change {
  _Change(this.t, this.order, this.apply);
  final double t;
  final int order;
  final void Function(double t, {required bool atBreak}) apply;
}

/// A substitute waiting to come on.
class _Arrival {
  _Arrival(this.on, this.side, this.offIndex, this.earliest);
  final _Agent on;
  final int side;
  final int? offIndex;
  final double earliest;
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
    this.pass = true,
    this.fromHeight = 0,
    this.toHeight = 0,
    this.shot = false,
  });
  final double t0;
  final double t1;
  final Offset2 from;

  /// Whether this is a moment's shot.
  final bool shot;

  /// Who kicked it, when anybody did.
  final int? fromActor;

  /// Who it is for; null for a ball kicked to a point ([lead]), where it
  /// lies on landing.
  final int? toActor;
  final double peak;
  final Offset2 lead;
  final bool pass;
  final double fromHeight;
  final double toHeight;
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
  final List<int> shirts = [];
  final Map<int, int> indexOf = {};
  final List<ScriptKeyframe> keyframes = [];
  final List<BallPhase> phases = [];
  final List<StagedWindow> windows = [];
  final List<double> resets = [];
  final Set<double> resetDone = {};
  final Map<int, double> departures = {};
  final Map<int, double> arrivals = {};
  final List<_Change> changes = [];
  final List<_Arrival> queue = [];

  /// Slots live changes hold for substitutes not yet on, by agent index.
  final Map<int, int> arrivalSlot = {};

  /// Agents due to walk off, by agent index: when.
  final Map<int, double> leaving = {};

  /// Substitutes the events bring on, by agent index: the man each replaces
  /// (agent index, or null) and his side.
  final Map<int, (int?, int)> planned = {};

  /// A screen second the ball logic wants a step to end at.
  double wakeAt = double.infinity;

  /// A cut waiting for the ball in the air to land, and whose it is.
  CutAction? pendingCut;
  StagedPlan? pendingPlan;

  /// Whether the last [_drive] came from the stager.
  bool stagedDrive = false;

  /// Where a resumed script starts.
  double? resumeAt;
  int ci = 0;

  late double total;

  // Ball state.
  int? carrier;
  _Flight? flight;

  /// The ball lying still (in the net, out of play, on a dead-ball spot)
  /// while nobody has it and it is not in the air, and its height.
  Offset2? restAt;
  double restHeight = 0;

  /// The last man to touch the ball, by agent index.
  int? lastTouch;

  /// Kick-offs after goals: screen second -> the side kicking off.
  final Map<double, int> goalRestarts = {};

  /// Every screen second the picture cuts at (see `PitchScript.cuts`), and
  /// what kind of cut it is.
  final Map<double, PitchCutKind> cuts = {};
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

  PitchScript run(ScriptState? resume) {
    total = pacer.total.inMicroseconds / 1e6;
    sides = [
      _Side(lineups.home, home: true),
      _Side(lineups.away, home: false),
    ];
    _registerActors();
    _lineUp();
    _buildWindows();
    _scheduleChanges();
    for (final m in [
      46,
      if (result.extraTime != null) ...[91, 106],
    ]) {
      resets.add(_secs(pacer.screenAt(m, 0)));
    }
    _scheduleGoalRestarts();

    var t = 0.0;
    if (resume != null) {
      t = _resumeFrom(resume);
      resumeAt = t;
    } else {
      _applyDue(0, atBreak: true);
      _processArrivals(0);
      _reseed(0);
      _kickoff(0, 0);
      _record(0);
    }
    final start = t;

    final specials = <double>{
      for (final w in windows) ...[w.start, w.end],
      ...resets,
      ...goalRestarts.keys,
      for (final c in changes) c.t,
      total,
    }.toList()..sort();
    var sp = 0;
    var wi = 0;
    // Windows that began before the start were opened by the resume (the
    // one spanning it) or are over.
    while (wi < windows.length && windows[wi].start < t - 1e-9) {
      wi++;
    }
    while (t < total - 1e-9) {
      // Windows closing: when their moment has played out, or (a moment
      // that needs a little longer, its ball still on its way) as soon as
      // anything else is due.
      if (activeWindow != null &&
          t >= activeWindow!.end - 1e-9 &&
          !_spills(activeWindow!, activePlan, t)) {
        activeWindow!.exit = _state(t);
        activeWindow = null;
        activePlan = null;
        spellEnd = t + _spellLength(possession);
        nextAction = math.max(nextAction, t + 0.15);
      }
      // A kick-off after a goal: the picture cuts from the celebration to
      // the sides lined up, the conceding side on the ball.
      for (final e in goalRestarts.entries) {
        if (!resetDone.contains(e.key) && (e.key - t).abs() < 1e-9) {
          resetDone.add(e.key);
          _processArrivals(t);
          // At the loop's own time, which may round a hair past it.
          _kickoff(t, e.value);
          _record(t);
          cuts[t] = PitchCutKind.kickOff;
        }
      }
      // Kick-offs, with whatever the interval brought.
      for (final r in resets) {
        if (!resetDone.contains(r) && (r - t).abs() < 1e-9) {
          resetDone.add(r);
          for (final a in agents) {
            if (a.walkStart != null) _endWalk(a);
          }
          _applyDue(t, atBreak: true);
          _processArrivals(t);
          final m = pacer.matchAt(_dur(r)).minute;
          // The side that did not kick off the half before kicks off this
          // one: away at 46', home at 91', away at 106'.
          _kickoff(r, m == 91 ? 0 : 1);
          _record(r);
        }
      }
      _applyDue(t, atBreak: false);
      _processArrivals(t);
      // Windows opening.
      while (wi < windows.length && windows[wi].start <= t + 1e-9) {
        final w = windows[wi];
        wi++;
        if (w.end <= t + 1e-9) continue;
        _openWindow(w, t, wi);
      }
      _reseed(t);
      final inAir = flight;
      final bound = inAir?.toActor;
      if (bound != null) {
        final to = agents[bound];
        if (!to.present || to.walkStart != null) _redirect(t);
      }
      final c = carrier;
      if (c != null && agents[c].walkStart != null) _forcePass(agents[c], t);
      if (activeWindow == null) {
        if (restAt != null) {
          _collectLoose(t);
        } else {
          _decide(t);
        }
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
      if (wakeAt > t + 1e-9) next = math.min(next, wakeAt);
      _step(t, next);
      if (possession == 0) {
        homeBallTime += next - t;
      } else {
        awayBallTime += next - t;
      }
      t = next;
      if (f != null && t >= f.t1 - 1e-9) _land(t);
      _record(t);
      // A cut waiting on the ball, now down: made on this frame.
      if (pendingCut != null && flight == null) _cutOnLanding(t);
      // A man walking off who has reached the boundary leaves the picture.
      for (final a in agents) {
        if (a.walkStart != null && _toBoundary(a.pos) <= _edge + 0.3) {
          _endWalk(a);
        }
      }
      // A keeper coming on takes over once he reaches his area.
      for (final a in agents) {
        if (a.headingInGoal) _takeOverGoal(a, t);
      }
    }
    if (activeWindow != null) activeWindow!.exit = _state(total);
    // Anybody due off at the final whistle starts to leave there.
    leaving.forEach((i, at) {
      if (at >= total - 1e-9) departures.putIfAbsent(agents[i].id, () => at);
    });
    _cutFlight(total);
    _closePhase(total);

    return PitchScript(
      cuts: cuts.keys.toList()..sort(),
      cutKinds: Map.of(cuts),
      actorList: [
        for (final a in agents)
          (
            playerId: a.id,
            teamNationId: sides[a.side].nationId,
            shirt: shirts[a.index],
            keeper: a.namedKeeper,
          ),
      ],
      keyframes: keyframes,
      ballPhases: phases,
      resets: resets,
      windows: windows,
      departures: departures,
      arrivals: arrivals,
      pacer: pacer,
      result: result,
      homeNationId: lineups.home.nationId,
      start: start,
    );
  }

  void _openWindow(StagedWindow w, double t, int index) {
    // A substitute the moment names steps on before it plays, even when his
    // own change is staged after it in the same minute.
    final actors = w.actors;
    for (final id in actors) {
      final i = indexOf[id];
      if (i == null || agents[i].appeared) continue;
      final plan = planned[i];
      if (plan == null || queue.any((q) => q.on.index == i)) continue;
      queue.add(_Arrival(agents[i], plan.$2, plan.$1, t));
    }
    for (final q in [...queue]) {
      if (!actors.contains(q.on.id)) continue;
      final off = q.offIndex == null ? null : agents[q.offIndex!];
      if (off != null && off.present && off.walkStart == null) {
        leaving[off.index] = t;
        _startWalk(off, t, replaced: true);
      }
      // Still never a twelfth man: he steps on only once the man he
      // replaces has started to go.
      if (_arrive(q, t)) queue.remove(q);
    }
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
        seed: (seed ^ ((index + 1) * 0x9E3779B1)) & 0xFFFFFFFF,
        homePossessionShare: _share(0),
        next: index < windows.length ? windows[index] : null,
        ahead: [
          for (var k = index; k < windows.length; k++)
            if (windows[k].start - w.end <= _takerLead) windows[k],
        ],
        events: result.events,
        resuming: resumeAt != null && (t - resumeAt!).abs() < 1e-9,
        hardEnd: [
          for (final r in [...resets, total])
            if (r >= w.end - 1e-9 && r <= w.end + _spill) r,
        ].fold(double.infinity, math.min),
      ),
    );
  }

  /// Whether [w]'s plan plays on past its end into the quiet time after
  /// it: only while its moment has not played out, for at most [_spill],
  /// and never into another moment, an interval or a kick-off.
  bool _spills(StagedWindow w, StagedPlan? plan, double t) {
    if (plan == null || t >= w.end + _spill - 1e-9) return false;
    if (goalRestarts.containsKey(w.end)) return false;
    for (final o in windows) {
      if (o.start > w.start + 1e-9 && o.start < t + 0.3) return false;
    }
    for (final r in resets) {
      if (r > t - 1e-9 && r < t + 0.3) return false;
    }
    return !plan.settled(t, _state(t));
  }

  /// A goal's window ends with a kick-off: the picture cuts there, the
  /// conceding side on the ball. Not when the window ends the match, or at
  /// an interval (whose own kick-off stands).
  void _scheduleGoalRestarts() {
    for (final w in windows) {
      ShotMoment? goal;
      for (final m in w.moments) {
        if (m is ShotMoment && m.outcome == ShotOutcome.goal) goal = m;
      }
      if (goal == null) continue;
      final at = w.end;
      if (at >= total - 1e-6) continue;
      if (resets.any((r) => (r - at).abs() < 1e-6)) continue;
      goalRestarts[at] = goal.teamNationId == lineups.home.nationId ? 1 : 0;
    }
  }

  // --- set-up --------------------------------------------------------------

  void _registerActors() {
    void add(int id, int side, int shirt) {
      if (indexOf.containsKey(id)) return;
      final a = _Agent(agents.length, id, side);
      final r = SeededRng((seed ^ (id * 0x85EBCA6B)) & 0xFFFFFFFF);
      a.phaseA = r.nextDouble() * 2 * math.pi;
      a.phaseB = r.nextDouble() * 2 * math.pi;
      indexOf[id] = a.index;
      agents.add(a);
      shirts.add(shirt);
    }

    int sideOf(int nation) => nation == lineups.home.nationId ? 0 : 1;
    for (var s = 0; s < 2; s++) {
      for (final p in sides[s].team.xi) {
        add(p.playerId, s, p.shirt);
      }
    }
    int benchShirt(int s, int id) {
      final bench = sides[s].team.bench;
      final b = bench.indexOf(id);
      return b >= 0 ? 12 + b : 12 + bench.length + agents.length;
    }

    for (final e in result.events) {
      if (e.type != MatchEventType.substitution) continue;
      final s = sideOf(e.teamNationId);
      add(e.playerId, s, benchShirt(s, e.playerId));
    }
    for (final c in lineups.changes) {
      final s = sideOf(c.teamNationId);
      for (final id in c.xi) {
        add(id, s, benchShirt(s, id));
      }
    }
  }

  /// Each side's opening shape: its team sheet, or, for a side with no live
  /// changes, the plan it fielded for most of the match, with every man in
  /// the plan's slot nearest the one he was named in.
  void _lineUp() {
    final changed = {for (final c in lineups.changes) c.teamNationId};
    for (var s = 0; s < 2; s++) {
      final side = sides[s];
      final team = side.team;
      final usePlan = !changed.contains(team.nationId);
      final List<int> slots;
      if (usePlan && team.plan.formation != team.formation) {
        final before = slotLayout(
          team.formation,
          team.switches,
          team.instructions,
        );
        final oldGk = team.formation.positions.indexOf(PlayerPosition.gk);
        side.reshape(
          team.plan.formation,
          SlotSwitches.none,
          team.plan.instructions,
        );
        slots = _nearestSlots(before, side.layout, oldGk, side.gkSlot);
      } else {
        side.reshape(
          team.formation,
          team.switches,
          usePlan ? team.plan.instructions : team.instructions,
        );
        slots = [for (var i = 0; i < team.xi.length; i++) i];
      }
      for (var i = 0; i < team.xi.length; i++) {
        final slot = slots[i];
        if (slot < 0 || slot >= side.owner.length) continue;
        final a = agents[indexOf[team.xi[i].playerId]!];
        a
          ..present = true
          ..appeared = true
          ..namedKeeper = slot == side.gkSlot
          ..slot = slot;
        side.owner[slot] = a.index;
      }
      side.reform();
    }
  }

  /// Each of [from]'s slots matched to the nearest free slot of [to], the
  /// closest pairs first; the keeper's to the keeper's.
  static List<int> _nearestSlots(
    List<(double, double)> from,
    List<(double, double)> to,
    int fromGk,
    int toGk,
  ) {
    final out = List<int>.filled(from.length, -1);
    final used = <int>{};
    if (fromGk >= 0 && fromGk < from.length) {
      out[fromGk] = toGk;
      used.add(toGk);
    }
    final pairs = <(double, int, int)>[];
    for (var i = 0; i < from.length; i++) {
      if (i == fromGk) continue;
      for (var j = 0; j < to.length; j++) {
        if (j == toGk) continue;
        final dx = from[i].$1 - to[j].$1;
        final dy = from[i].$2 - to[j].$2;
        pairs.add((dx * dx + dy * dy, i, j));
      }
    }
    pairs.sort((a, b) {
      final c = a.$1.compareTo(b.$1);
      if (c != 0) return c;
      final d = a.$2.compareTo(b.$2);
      return d != 0 ? d : a.$3.compareTo(b.$3);
    });
    for (final (_, i, j) in pairs) {
      if (out[i] >= 0 || used.contains(j)) continue;
      out[i] = j;
      used.add(j);
    }
    return out;
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
      ..sort(
        (a, b) => _slotIndex(a.$1, a.$2).compareTo(_slotIndex(b.$1, b.$2)),
      );
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

  /// When each change happens. Live tactical changes reshape a side at the
  /// start of their minute. From the events: a red card leaves as its
  /// foul's window closes, an injury as its own window closes, a sub as its
  /// moment's window closes; a substitute joins the queue then and steps on
  /// once his side is down to ten on the pitch (the man he replaces has
  /// reached the touchline). Subs made at an interval happen in it.
  void _scheduleChanges() {
    int sideOf(int nation) => nation == lineups.home.nationId ? 0 : 1;
    var order = 0;
    for (final c in lineups.changes) {
      final at = _secs(pacer.screenAt(math.max(1, c.minute), 0));
      changes.add(
        _Change(
          at,
          order++,
          (t, {required atBreak}) => _applyLineupChange(c, t),
        ),
      );
    }
    final breakMinutes = {
      46,
      if (result.extraTime != null) ...[91, 106],
    };
    for (var idx = 0; idx < result.events.length; idx++) {
      final e = result.events[idx];
      final s = sideOf(e.teamNationId);
      var at = _secs(pacer.screenAt(e.minute, e.stoppage));
      switch (e.type) {
        case MatchEventType.redCard:
          for (final w in windows) {
            final m = w.moments.isEmpty ? null : w.moments.first;
            if (m is FoulMoment && m.cardEventIndex == idx) at = w.end;
          }
          _scheduleDeparture(e.playerId, at, order++);
        case MatchEventType.injury:
          for (final w in windows) {
            if (identical(w.injury, e)) at = w.end;
          }
          _scheduleDeparture(e.playerId, at, order++);
        case MatchEventType.substitution:
          final atBreak = e.stoppage == 0 && breakMinutes.contains(e.minute);
          if (!atBreak) {
            for (final w in windows) {
              final m = w.moments.isEmpty ? null : w.moments.first;
              if (m is SubMoment && m.eventIndex == idx) at = w.end;
            }
          }
          final off = e.secondaryPlayerId;
          if (off != null && indexOf.containsKey(off)) {
            _scheduleDeparture(off, at, order++, replaced: true);
          }
          final onIndex = indexOf[e.playerId];
          if (onIndex == null) break;
          final offIndex = off == null ? null : indexOf[off];
          planned[onIndex] = (offIndex, s);
          final when = math.min(at, total);
          changes.add(
            _Change(when, order++, (t, {required atBreak}) {
              if (!queue.any((q) => q.on.index == onIndex)) {
                queue.add(_Arrival(agents[onIndex], s, offIndex, t));
              }
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
    double at,
    int order, {
    bool replaced = false,
  }) {
    final i = indexOf[id];
    if (i == null || leaving.containsKey(i)) return;
    final start = math.min(at, total);
    leaving[i] = start;
    final a = agents[i];
    changes.add(
      _Change(start, order, (t, {required atBreak}) {
        _startWalk(a, t, replaced: replaced);
        // At an interval he is simply gone by the restart.
        if (atBreak) _endWalk(a);
      }),
    );
  }

  /// Applies every change due by [t].
  void _applyDue(double t, {required bool atBreak}) {
    while (ci < changes.length && changes[ci].t <= t + 1e-9) {
      changes[ci].apply(t, atBreak: atBreak);
      ci++;
    }
  }

  // --- live changes --------------------------------------------------------

  void _applyLineupChange(LineupChange c, double t) {
    final s = c.teamNationId == lineups.home.nationId ? 0 : 1;
    final side = sides[s]..reshape(c.formation, c.switches, c.instructions);
    for (final a in agents) {
      if (a.side == s) a.slot = null;
    }
    final named = <int>{};
    for (var k = 0; k < c.xi.length; k++) {
      final i = indexOf[c.xi[k]];
      final slot = c.slotOf[k];
      if (i == null || slot < 0 || slot >= side.owner.length) continue;
      named.add(i);
      final a = agents[i];
      if (a.present && a.walkStart == null) {
        side.owner[slot] = i;
        a.slot = slot;
      } else if (!a.appeared) {
        side.pending[slot] = true;
        arrivalSlot[i] = slot;
      }
    }
    // A man the change takes off plays on in a newcomer's place until his
    // own departure; anybody it leaves out that no event takes off walks off
    // now.
    final waiting = [
      for (var i = 0; i < side.owner.length; i++)
        if (side.pending[i] && side.owner[i] == null) i,
    ];
    for (final a in agents) {
      if (a.side != s || !a.present || a.walkStart != null) continue;
      if (named.contains(a.index)) continue;
      if (leaving.containsKey(a.index) && waiting.isNotEmpty) {
        final slot = waiting.removeAt(0);
        side.owner[slot] = a.index;
        a.slot = slot;
        continue;
      }
      leaving[a.index] = t;
      _startWalk(a, t, replaced: false);
    }
    _ensureKeeper(side, coming: side.pending[side.gkSlot]);
    side.reform();
  }

  // --- departures and arrivals --------------------------------------------

  void _startWalk(_Agent a, double t, {required bool replaced}) {
    if (!a.present && !a.appeared) {
      // Leaving before he ever came on: he never will.
      departures[a.id] = t;
      a.gone = true;
      queue.removeWhere((q) => q.on == a);
      return;
    }
    if (!a.present || a.walkStart != null) return;
    departures[a.id] = t;
    if (carrier == a.index) _forcePass(a, t);
    a
      ..walkStart = t
      ..headingInGoal = false;
    _aimOff(a);
    final side = sides[a.side];
    final slot = a.slot;
    a
      ..slot = null
      ..vacatedSlot = slot;
    final stand = side.standIn;
    if (stand != null && stand.agent == a.index) {
      // The man minding goal is leaving: his own place will not be kept.
      side
        ..pending[stand.back] = false
        ..vacated.add(stand.back)
        ..standIn = null;
    }
    if (slot != null && side.owner[slot] == a.index) {
      side.owner[slot] = null;
      if (replaced) {
        side.pending[slot] = true;
      } else if (slot != side.gkSlot) {
        side.vacated.add(slot);
      }
    }
    _ensureKeeper(side, coming: side.pending[side.gkSlot]);
    side.reform();
  }

  /// Somebody always keeps goal: an empty keeper's slot is filled by the
  /// man in the nearest slot, for good when no keeper is [coming], or until
  /// the one on his way steps on.
  void _ensureKeeper(_Side side, {required bool coming}) {
    final gk = side.gkSlot;
    if (side.owner[gk] != null) return;
    int? best;
    var bestD = double.infinity;
    for (var i = 0; i < side.owner.length; i++) {
      final o = side.owner[i];
      if (i == gk || o == null || agents[o].walkStart != null) continue;
      final d =
          (side.layout[i].$1 - side.layout[gk].$1).abs() +
          (side.layout[i].$2 - side.layout[gk].$2).abs();
      if (d < bestD) {
        bestD = d;
        best = i;
      }
    }
    if (best == null) return;
    final mover = agents[side.owner[best]!];
    side.owner[gk] = mover.index;
    side.owner[best] = null;
    mover.slot = gk;
    if (coming) {
      side
        ..pending[best] = true
        ..standIn = (agent: mover.index, back: best);
    } else {
      side.vacated.add(best);
    }
  }

  void _endWalk(_Agent a) {
    a
      ..present = false
      ..gone = true
      ..walkStart = null
      ..walkTarget = null
      ..headingInGoal = false
      ..vel = Offset2.zero;
  }

  /// Sends a man walking off to the nearest point of the pitch's boundary,
  /// touchline or goal line (IFAB Law 3).
  void _aimOff(_Agent a) {
    final p = a.pos;
    final toTop = p.y;
    final toBottom = PitchDims.width - p.y;
    final toLeft = p.x;
    final toRight = PitchDims.length - p.x;
    final nearest = [toTop, toBottom, toLeft, toRight].reduce(math.min);
    if (nearest == toTop || nearest == toBottom) {
      a
        ..walkToGoalLine = false
        ..walkTarget = Offset2(
          p.x,
          nearest == toTop ? _edge : PitchDims.width - _edge,
        );
    } else {
      a
        ..walkToGoalLine = true
        ..walkTarget = Offset2(
          nearest == toLeft ? _edge : PitchDims.length - _edge,
          p.y,
        );
    }
  }

  /// How far [p] is from the nearest boundary line.
  static double _toBoundary(Offset2 p) => [
    p.x,
    PitchDims.length - p.x,
    p.y,
    PitchDims.width - p.y,
  ].reduce(math.min);

  void _processArrivals(double t) {
    for (var k = 0; k < queue.length;) {
      final q = queue[k];
      if (q.earliest <= t + 1e-9 && _arrive(q, t)) {
        queue.removeAt(k);
      } else {
        k++;
      }
    }
  }

  /// Steps [q]'s man on, if his side has room: never a twelfth man, so he
  /// waits while the man he replaces is still walking off. False to try
  /// again later.
  bool _arrive(_Arrival q, double t, {bool force = false}) {
    final on = q.on;
    if (on.present || on.gone) return true;
    final side = sides[q.side];
    if (!force) {
      // Men walking off are not counted: the newcomer steps on as soon as
      // the man he replaces has started to go.
      var count = 0;
      for (final a in agents) {
        if (a.present && a.side == q.side && a.walkStart == null) count++;
      }
      if (count >= 11) return false;
    }
    bool reservedElse(int slot) =>
        arrivalSlot.entries.any((e) => e.key != on.index && e.value == slot);
    bool free(int slot) =>
        !reservedElse(slot) &&
        (side.owner[slot] == null ||
            (slot == side.gkSlot && side.standIn != null));
    int? slot;
    final hint = arrivalSlot[on.index];
    if (hint != null && free(hint)) slot = hint;
    final off = q.offIndex;
    if (slot == null && off != null) {
      final v = agents[off].vacatedSlot;
      if (v != null && side.pending[v] && free(v)) slot = v;
    }
    if (slot == null) {
      for (var k = side.vacated.length - 1; k >= 0; k--) {
        if (free(side.vacated[k])) {
          slot = side.vacated[k];
          break;
        }
      }
    }
    if (slot == null) {
      for (var i = 0; i < side.owner.length; i++) {
        if (side.owner[i] == null && !side.pending[i] && !reservedElse(i)) {
          slot = i;
          break;
        }
      }
    }
    if (slot == null) return false;
    side.vacated.remove(slot);
    arrivalSlot.remove(on.index);
    on.namedKeeper = slot == side.gkSlot;
    if (slot == side.gkSlot && side.standIn != null) {
      // The stand-in minds goal until the keeper reaches his area.
      on
        ..slot = null
        ..headingInGoal = true;
    } else {
      side
        ..pending[slot] = false
        ..owner[slot] = on.index;
      on.slot = slot;
    }
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
    on
      ..present = true
      ..appeared = true
      ..pos = spot
      ..vel = Offset2.zero
      ..facing = -math.pi / 2;
    arrivals[on.id] = t;
    side.reform();
    return true;
  }

  /// [a], a keeper on his way in, takes the keeper's slot once he is in his
  /// area; the stand-in goes back to his own place.
  void _takeOverGoal(_Agent a, double t) {
    if (!a.present) {
      a.headingInGoal = false;
      return;
    }
    final side = sides[a.side];
    final dir = _dir(a.side, pacer.matchAt(_dur(t)).minute);
    if (xToDepth(a.pos.x, dir) > _area) return;
    final stand = side.standIn;
    a.headingInGoal = false;
    if (stand != null) {
      final mover = agents[stand.agent];
      final back = side.owner[stand.back] == null
          ? stand.back
          : side.owner.indexOf(null);
      side.standIn = null;
      if (back >= 0 && back != side.gkSlot) {
        side
          ..owner[back] = mover.index
          ..pending[back] = false;
        mover.slot = back;
      } else {
        mover.slot = null;
      }
    }
    side
      ..owner[side.gkSlot] = a.index
      ..pending[side.gkSlot] = false;
    a.slot = side.gkSlot;
    side.reform();
  }

  /// The ball's receiver has gone: it carries on along its line to where
  /// it is now, and from there to the nearest team-mate of the passer.
  void _redirect(double t) {
    final f = flight!;
    final here = _ballNow(t);
    final height = _heightNow(t);
    // A receiver gone the instant the ball leaves adds no flight at all.
    if (t > f.t0 + 1e-9) {
      phases.add(
        FlightPhase(
          f.t0,
          t,
          from: f.from,
          to: here,
          peak: f.peak,
          fromActor: f.fromActor,
          pass: false,
          fromHeight: f.fromHeight,
          toHeight: height,
        ),
      );
    }
    final kicker = f.fromActor ?? f.toActor!;
    final side = agents[kicker].side;
    _Agent? best;
    var bestD = double.infinity;
    for (final o in agents) {
      if (!o.present || o.side != side || o.walkStart != null) continue;
      final d = o.pos.distanceTo(here);
      final score = d < PitchScriptValidator.minPass ? d + 1000 : d;
      if (score < bestD) {
        bestD = score;
        best = o;
      }
    }
    if (best == null) {
      flight = null;
      restAt = here;
      restHeight = 0;
      phaseStart = t;
      return;
    }
    final d = best.pos.distanceTo(here);
    flight = _Flight(
      t0: t,
      t1: t + math.max(0.3, d / 18),
      from: here,
      fromActor: f.fromActor,
      toActor: best.index,
      peak: 0,
      lead: best.pos,
      pass: false,
      fromHeight: height,
    );
  }

  /// A carrier who has to leave plays the ball off first: to the nearest
  /// team-mate a pass's length away, or failing that the furthest one.
  void _forcePass(_Agent a, double t) {
    _Agent? near;
    _Agent? far;
    var nearD = double.infinity;
    var farD = -1.0;
    for (final o in agents) {
      if (!o.present || o.side != a.side || o == a || o.walkStart != null) {
        continue;
      }
      final d = o.pos.distanceTo(a.pos);
      if (d >= 8 && d < nearD) {
        nearD = d;
        near = o;
      }
      if (d > farD) {
        farD = d;
        far = o;
      }
    }
    final to = near ?? far;
    if (to != null) _startFlight(t, a, to, intercept: false);
  }

  bool _departsWithin(_Agent a, double t, double within) {
    final d = leaving[a.index];
    return d != null && d >= t - 1e-9 && d <= t + within;
  }

  // --- resuming ------------------------------------------------------------

  /// Sets everything up from [state] and returns the screen second the new
  /// script starts at.
  double _resumeFrom(ScriptState state) {
    var t0 = _secs(
      pacer.screenAt(state.minute, state.stoppage, within: state.within),
    );
    // A resume on a kick-off (or a cut) is exactly on it, whatever the
    // rounding of the match position.
    for (final r in [...resets, ...goalRestarts.keys]) {
      if ((r - t0).abs() < 1e-4) t0 = r;
    }
    // Everything due before the resume point has happened: replay it, then
    // put everybody exactly where the state has them.
    // On an interval's kick-off the state already shows what the interval
    // brought.
    final onBreak = resets.any((r) => (r - t0).abs() < 1e-9);
    while (ci < changes.length &&
        (changes[ci].t < t0 - 1e-9 ||
            (onBreak && changes[ci].t <= t0 + 1e-9))) {
      final at = changes[ci].t;
      changes[ci].apply(at, atBreak: onBreak && (at - t0).abs() < 1e-9);
      ci++;
      for (final q in [...queue]) {
        if (state.players.containsKey(q.on.id) && _arrive(q, t0, force: true)) {
          queue.remove(q);
        }
      }
    }
    for (final r in [...resets, ...goalRestarts.keys]) {
      // A resume landing exactly on a kick-off starts from the kick-off the
      // state already shows.
      if (r < t0 + 1e-9) resetDone.add(r);
    }
    for (final a in agents) {
      final p = state.players[a.id];
      if (p == null) {
        if (a.present) _endWalk(a);
        continue;
      }
      a
        ..present = true
        ..appeared = true
        ..pos = p
        ..facing = state.facing[a.id] ?? 0
        ..vel = state.velocity[a.id] ?? Offset2.zero;
      if (state.walking.contains(a.id)) {
        // Wherever the replay left him, he heads for the boundary nearest
        // where he actually is.
        a.walkStart ??= departures[a.id] ?? t0;
        _aimOff(a);
        departures[a.id] ??= t0;
      } else if (a.walkStart != null) {
        a
          ..walkStart = null
          ..walkTarget = null;
      }
    }
    final f = state.flight;
    final dt = t0 - state.t;
    carrier = state.carrierId == null ? null : indexOf[state.carrierId];
    final toIndex = f?.toId == null ? null : indexOf[f!.toId];
    if (f != null && (f.toId == null || toIndex != null)) {
      // The rest of its flight, from exactly where it is: the remainder of
      // an arc is an arc too.
      final len = f.t1 - f.t0;
      final k = len <= 0 ? 1.0 : ((state.t - f.t0) / len).clamp(0.0, 1.0);
      final here = Offset2.lerp(f.from, f.lead, k);
      final h =
          f.fromHeight +
          (f.toHeight - f.fromHeight) * k +
          4 * f.peak * k * (1 - k);
      flight = _Flight(
        t0: t0,
        t1: math.max(f.t1 + dt, t0 + 0.05),
        from: here,
        fromActor: f.fromId == null ? null : indexOf[f.fromId],
        toActor: toIndex,
        peak: f.peak * (1 - k) * (1 - k),
        lead: f.lead,
        pass: false,
        fromHeight: h,
        toHeight: f.toHeight,
      );
      carrier = null;
    }
    if (carrier == null && flight == null) {
      // Nobody has it and it is not in the air: it lies where it is.
      restAt = state.ball;
      restHeight = 0;
    }
    lastTouch = carrier ?? flight?.fromActor;
    phaseStart = t0;
    possession = state.possessionNationId == lineups.home.nationId ? 0 : 1;
    homeBallTime = state.homeBallTime;
    awayBallTime = state.awayBallTime;
    cameraX = state.cameraX;
    _reseed(t0);
    final minute = pacer.matchAt(_dur(t0)).minute;
    spellStart = t0;
    spellEnd = t0 + _spellLength(possession);
    spellDepth = _depthTarget(possession, minute);
    nextAction = t0 + 0.3;
    _record(t0);
    for (final w in windows) {
      if (w.start < t0 - 1e-9 && w.end > t0 + 1e-9) {
        _openWindow(w, t0, windows.indexOf(w) + 1);
      } else if (w.end <= t0 + 1e-9) {
        // Played before this script began: the resume state stands in for
        // both ends.
        final here = _state(t0);
        w
          ..entry = here
          ..exit = here;
      }
    }
    return t0;
  }

  // --- kick-off ------------------------------------------------------------

  void _kickoff(double t, int kicking) {
    _cutFlight(t);
    _closePhase(t);
    restAt = null;
    restHeight = 0;
    final minute = pacer.matchAt(_dur(t)).minute;
    const centre = PitchDims.centre;
    possession = kicking;
    _updateBackLines(minute, centre);
    for (var s = 0; s < 2; s++) {
      final dir = _dir(s, minute);
      final targets = _anchors(s, minute, t, centre, s == kicking);
      for (final a in agents) {
        // A man walking off walks on through the cut.
        if (!a.present || a.side != s || a.walkStart != null) continue;
        var p = targets[a.index] ?? a.pos;
        var depth = xToDepth(p.x, dir).clamp(1.0, 50.5);
        if (a.slot == sides[s].gkSlot) depth = 5;
        p = Offset2(depthToX(depth, dir), p.y);
        if (s != kicking && p.distanceTo(centre) < 10.5) {
          final lat = (p.y - centre.y).clamp(-9.0, 9.0);
          final need = math.sqrt(math.max(0, 10.5 * 10.5 - lat * lat));
          p = Offset2(depthToX(52.5 - need, dir), p.y);
        }
        a
          ..pos = p
          ..vel = Offset2.zero
          ..facing = dir > 0 ? 0 : math.pi;
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
    lastTouch = kicker.index;
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
    final latest = stop - _lateHandover;
    final handoverDue = handover && (t >= latest - 1e-9 || ahead > 0);
    if (handover && !handoverDue) wakeAt = latest;
    if (t < nextAction - 1e-9 && !handoverDue) return;
    // The side the next moment belongs to keeps the ball into it, unless it
    // is well ahead of its share and there is time to lose it and win it
    // back first.
    final keep =
        leadSide == a.side &&
        stop - t <= _handover &&
        !(ahead > 0.5 && stop - t >= 1.2);
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
    final limit = handover && !handoverDue ? latest : stop - 0.05;
    if (t + plan.$2 > limit) {
      nextAction = handover && !handoverDue
          ? math.min(t + 0.25, latest)
          : t + 0.25;
      return;
    }
    _startFlight(t, a, target, intercept: intercept, quick: intercept && quick);
  }

  /// How many screen seconds more than its possession share side [s] has
  /// had the ball for so far, staged moments included (negative when it is
  /// owed time).
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
    if (plan == null) return;
    final inAir = flight != null;
    if (!inAir && c == null && restAt == null) return;
    final action = plan.ball(t, _state(t));
    // While the ball is in the air only a cut may interrupt it, and only
    // a pass between team-mates still well short of its man: anything else
    // (a shot, a save, a clearance) comes down first, the cut on landing.
    if (inAir && action is! CutAction) return;
    if (inAir && action is CutAction && !_mayCutFlight(t)) {
      pendingCut = action;
      pendingPlan = plan;
      return;
    }
    switch (action) {
      case PassAction(:final toPlayerId, :final arriveAt, :final peak):
        if (c == null) return;
        final to = indexOf[toPlayerId];
        if (to == null || to == c) return;
        final target = agents[to];
        if (!target.present || target.walkStart != null) return;
        _startFlight(
          t,
          agents[c],
          target,
          intercept: target.side != agents[c].side,
          arriveAt: arriveAt,
          peak: peak,
        );
      case final KickAction k:
        _kick(t, k);
      case final CutAction k:
        _cut(t, k);
        // The moment goes on at once from what the cut shows.
        final next = plan.ball(t, _state(t));
        switch (next) {
          case final KickAction n:
            _kick(t, n);
          case PassAction(:final toPlayerId, :final arriveAt, :final peak):
            final cc = carrier;
            final to = indexOf[toPlayerId];
            if (cc == null || to == null || to == cc) break;
            final target = agents[to];
            if (!target.present || target.walkStart != null) break;
            _startFlight(
              t,
              agents[cc],
              target,
              intercept: target.side != agents[cc].side,
              arriveAt: arriveAt,
              peak: peak,
            );
          case CutAction() || null:
            break;
        }
      case null:
        break;
    }
  }

  /// Whether the ball in the air may be cut short. A shot never is (its
  /// outcome is the record's), and a ball about to land comes down first;
  /// anything else with a while still to go may be.
  bool _mayCutFlight(double t) {
    final f = flight;
    if (f == null) return true;
    if (f.shot) return false;
    return f.t1 - t >= 0.6;
  }

  /// A cut asked for while the ball was in the air, made as it lands.
  void _cutOnLanding(double t) {
    final k = pendingCut;
    final plan = pendingPlan;
    pendingCut = null;
    pendingPlan = null;
    if (k == null || plan == null || !identical(plan, activePlan)) return;
    // Whatever is due now happens first (a man starting his walk off).
    _applyDue(t, atBreak: false);
    _processArrivals(t);
    _cut(t, k);
    final next = plan.ball(t, _state(t));
    if (next is KickAction) _kick(t, next);
  }

  /// The picture cuts to [k]'s set piece, ready.
  void _cut(double t, CutAction k) {
    _cutFlight(t);
    _closePhase(t);
    // The picture just before the cut, as it stands now.
    _record(t);
    final minute = pacer.matchAt(_dur(t)).minute;
    final poss = k.possession;
    if (poss != null) {
      // A new phase: both sides in their shapes around the ball, as the
      // story layer would have them there.
      final s = poss == lineups.home.nationId ? 0 : 1;
      possession = s;
      _updateBackLines(minute, k.ballAt);
      final shape = <int, Offset2>{
        ..._anchors(0, minute, t, k.ballAt, s == 0),
        ..._anchors(1, minute, t, k.ballAt, s == 1),
      };
      shape.forEach((i, p) {
        final a = agents[i];
        if (!a.present || a.walkStart != null) return;
        a
          ..pos = _clampPitch(p)
          ..vel = Offset2.zero;
      });
    }
    final placed = <int>{};
    k.positions.forEach((id, p) {
      final i = indexOf[id];
      if (i == null) return;
      final a = agents[i];
      if (!a.present || a.walkStart != null) return;
      var q = _clampPitch(p);
      if (a.slot == sides[a.side].gkSlot) {
        // A keeper stays within reach of his goal, whatever is asked.
        final dir = _dir(a.side, minute);
        final d = xToDepth(q.x, dir);
        if (d > _keeperMaxDepth)
          q = Offset2(depthToX(_keeperMaxDepth, dir), q.y);
      }
      a
        ..pos = q
        ..vel = Offset2.zero;
      placed.add(i);
    });
    // The man to be flagged beyond the line; the men who must be onside
    // behind it.
    final off = k.offside == null ? null : indexOf[k.offside];
    if (off != null && agents[off].present && agents[off].walkStart == null) {
      final a = agents[off];
      final dir = _dir(a.side, minute);
      final line = math.max(
        _secondLastDepth(a.side, dir),
        xToDepth(k.ballAt.x, dir),
      );
      final d = (line + 2.5).clamp(55.0, 100.0);
      a.pos = _clampPitch(Offset2(depthToX(d, dir), a.pos.y));
      placed.add(off);
    }
    for (final id in k.onside) {
      final i = indexOf[id];
      if (i == null) continue;
      final a = agents[i];
      if (!a.present || a.walkStart != null) continue;
      final dir = _dir(a.side, minute);
      final line = math.max(
        _secondLastDepth(a.side, dir),
        xToDepth(k.ballAt.x, dir),
      );
      final d = xToDepth(a.pos.x, dir);
      if (d > PitchDims.length / 2 && d > line - 1.0) {
        final to = math.max(line - 1.0, PitchDims.length / 2);
        a.pos = _clampPitch(Offset2(depthToX(to, dir), a.pos.y));
      }
      placed.add(i);
    }
    // Nobody left standing on anybody: those not placed step aside first.
    for (var it = 0; it < 80; it++) {
      var moved = false;
      for (final a in agents) {
        if (!a.present) continue;
        for (final b in agents) {
          if (b.index <= a.index || !b.present) continue;
          final d = a.pos.distanceTo(b.pos);
          if (d >= 1.05) continue;
          moved = true;
          final away = d < 1e-6 ? const Offset2(0, 1) : (a.pos - b.pos).unit;
          final push = (1.05 - d) / 2 + 0.02;
          // A man walking off never moves; a man placed moves only for
          // another placed man.
          final walkA = a.walkStart != null;
          final walkB = b.walkStart != null;
          final fixA = placed.contains(a.index) || walkA;
          final fixB = placed.contains(b.index) || walkB;
          final moveA = !walkA && (!fixA || fixB);
          final moveB = !walkB && (!fixB || fixA);
          final both = moveA && moveB;
          if (moveA)
            a.pos = _clampPitch(a.pos + away * (both ? push : push * 2));
          if (moveB)
            b.pos = _clampPitch(b.pos - away * (both ? push : push * 2));
        }
      }
      if (!moved) break;
    }
    // Anybody still too close (pinned against a line) finds the nearest
    // free spot.
    for (final a in agents) {
      if (!a.present || placed.contains(a.index) || a.walkStart != null) {
        continue;
      }
      bool clear(Offset2 p) => agents.every(
        (o) => o == a || !o.present || o.pos.distanceTo(p) >= 1.05,
      );
      if (clear(a.pos)) continue;
      for (var k = 1; k < 200; k++) {
        final ring = 1.1 * (1 + k ~/ 8);
        final p = _clampPitch(
          a.pos + Offset2.fromAngle(k * math.pi / 4 + ring, ring),
        );
        if (clear(p)) {
          a.pos = p;
          break;
        }
      }
    }
    // Everybody faces the ball.
    for (final a in agents) {
      if (!a.present || a.walkStart != null) continue;
      final to = k.ballAt - a.pos;
      if (to.length > 0.3) a.facing = to.angle;
    }
    carrier = null;
    flight = null;
    restAt = k.ballAt;
    restHeight = 0;
    phaseStart = t;
    _record(t);
    cuts[t] = k.kind;
  }

  /// Starts [k]: the ball leaves its carrier's feet, or the spot it lies
  /// on, for a point or a man.
  void _kick(double t, KickAction k) {
    final int? to;
    if (k.toPlayerId != null) {
      to = indexOf[k.toPlayerId];
      if (to == null) return;
      final target = agents[to];
      if (!target.present || target.walkStart != null || to == carrier) {
        return;
      }
    } else {
      to = null;
    }
    final c = carrier;
    final Offset2 from;
    final int? by;
    if (c != null) {
      from = _ballPoint(agents[c]);
      by = c;
    } else {
      from = restAt!;
      final named = k.byPlayerId == null ? null : indexOf[k.byPlayerId];
      by = named ?? lastTouch;
    }
    final lead = to != null ? _ballPoint(agents[to]) : k.to!;
    // A man it is played to may move a little before it lands: room under
    // the cap.
    final fastest = t + from.distanceTo(lead) / (to != null ? 26 : 34);
    _closePhase(t);
    flight = _Flight(
      t0: t,
      t1: math.max(math.max(k.arriveAt, fastest), t + 0.05),
      from: from,
      fromActor: by,
      toActor: to,
      peak: k.peak,
      lead: lead,
      pass: k.pass,
      fromHeight: c != null ? k.fromHeight : math.max(k.fromHeight, restHeight),
      toHeight: k.toHeight,
      shot: k.shot,
    );
    carrier = null;
    restAt = null;
    restHeight = 0;
    if (by != null) lastTouch = by;
  }

  /// Outside a moment, a ball lying loose (one a moment left out of play,
  /// or in the open) goes to whoever is nearest: a ball behind a goal line
  /// to the keeper there, for his goal kick.
  void _collectLoose(double t) {
    final at = restAt!;
    final minute = pacer.matchAt(_dur(t)).minute;
    _Agent? best;
    var bestD = double.infinity;
    final behindHome = at.x < 0;
    final behindFar = at.x > PitchDims.length;
    for (final a in agents) {
      if (!a.present || a.walkStart != null) continue;
      if (_departsWithin(a, t, 6)) continue;
      var d = a.pos.distanceTo(at);
      if (behindHome || behindFar) {
        final dir = _dir(a.side, minute);
        final defends = (dir > 0) == behindHome;
        final keeper = a.slot == sides[a.side].gkSlot;
        if (!(defends && keeper)) d += 1000;
      }
      if (d < bestD) {
        bestD = d;
        best = a;
      }
    }
    if (best == null) return;
    final v = (8 + 0.6 * bestD).clamp(8.0, 24.0);
    _kick(
      t,
      KickAction(
        toPlayerId: best.id,
        arriveAt: t + math.max(0.15, best.pos.distanceTo(at) / v),
      ),
    );
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
      final dir = _dir(s, m.minute);
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
    restAt = null;
    lastTouch = from.index;
  }

  void _land(double t) {
    final f = flight!;
    final toIndex = f.toActor;
    if (toIndex == null) {
      // Kicked to a point: it lies there.
      if (t > f.t0 + 1e-9) {
        phases.add(
          FlightPhase(
            f.t0,
            t,
            from: f.from,
            to: f.lead,
            peak: f.peak,
            fromActor: f.fromActor,
            pass: f.pass,
            fromHeight: f.fromHeight,
            toHeight: f.toHeight,
          ),
        );
      }
      flight = null;
      restAt = f.lead;
      restHeight = f.toHeight;
      phaseStart = t;
      return;
    }
    final to = agents[toIndex];
    if (!to.present && t < total - 1e-9) {
      _redirect(t);
      return;
    }
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
        pass: f.pass,
        fromHeight: f.fromHeight,
        toHeight: f.toHeight,
      ),
    );
    flight = null;
    carrier = to.index;
    lastTouch = to.index;
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

  /// A ball still in the air when play stops (an interval, a kick-off, the
  /// final whistle) stops where it is: its flight so far, then it lies.
  void _cutFlight(double t) {
    final f = flight;
    if (f == null) return;
    if (t >= f.t1 - 1e-9) {
      _land(t);
      return;
    }
    final here = _ballNow(t);
    final height = _heightNow(t);
    if (t > f.t0 + 1e-9) {
      final k = (t - f.t0) / (f.t1 - f.t0);
      phases.add(
        FlightPhase(
          f.t0,
          t,
          from: f.from,
          to: here,
          // The same arc, cut short: a parabola's first part is one too.
          peak: f.peak * k * k,
          fromActor: f.fromActor,
          // Still the man it was played to, though it never reached him.
          toActor: f.toActor,
          pass: false,
          fromHeight: f.fromHeight,
          toHeight: height,
        ),
      );
    }
    flight = null;
    restAt = here;
    restHeight = height;
    phaseStart = t;
  }

  void _closePhase(double t) {
    final c = carrier;
    final rest = restAt;
    if (c != null && t > phaseStart + 1e-9) {
      phases.add(CarryPhase(phaseStart, t, c));
    } else if (rest != null && t > phaseStart + 1e-9) {
      phases.add(
        FlightPhase(
          phaseStart,
          t,
          from: rest,
          to: rest,
          peak: 0,
          fromActor: lastTouch,
          pass: false,
          fromHeight: restHeight,
          toHeight: restHeight,
        ),
      );
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
    // The moments ahead: the man the next one turns on is looked for; the
    // men due elsewhere (a set piece's taker on his way, a man about to be
    // flagged offside) are not.
    final next = _upcoming(t, _leadIn);
    final wanted = next.isEmpty ? null : _wantedOnBall(next.first);
    final avoid = _busyAhead(t);
    // Nobody is found in an offside position.
    final onsideUpTo = math.max(_secondLastDepth(s, dir), ballDepth);
    _Agent? best;
    var bestScore = -double.infinity;
    for (final m in agents) {
      if (!m.present || m.side != s || m == a || m.walkStart != null) continue;
      if (_departsWithin(m, t, 6)) continue;
      if (avoid.contains(m.id)) continue;
      final depth = xToDepth(m.pos.x, dir);
      if (depth > PitchDims.length / 2 && depth > onsideUpTo) continue;
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
      if (m.id == wanted) score += 2.5;
      if (score > bestScore) {
        bestScore = score;
        best = m;
      }
    }
    return best;
  }

  /// The windows opening after [t] and within [horizon] of it, in order.
  List<StagedWindow> _upcoming(double t, double horizon) => [
    for (final w in windows)
      if (w.start > t + 1e-9 && w.start - t <= horizon) w,
  ];

  /// Who the build-up looks for before window [w]: the man its moment
  /// starts with (the assister of a goal, else the shooter; the man to be
  /// fouled).
  static int? _wantedOnBall(StagedWindow w) {
    if (w.moments.isEmpty) return null;
    return switch (w.moments.first) {
      ShotMoment(
        :final shooterId,
        :final assistId,
        :final outcome,
        :final origin,
      ) =>
        origin == ShotOrigin.penalty
            ? null
            : outcome == ShotOutcome.goal && assistId != null
            ? assistId
            : shooterId,
      FoulMoment(:final fouledId) => fouledId,
      _ => null,
    };
  }

  /// Men the build-up leaves off the ball before the moments ahead: a set
  /// piece's taker on his way to the ball, a penalty's taker, a man about
  /// to be flagged offside.
  Set<int> _busyAhead(double t) => {
    for (final w in _upcoming(t, _takerLead))
      if (w.moments.isNotEmpty)
        ...switch (w.moments.first) {
          SetPieceMoment(:final takerId) => [takerId],
          ShotMoment(:final shooterId, :final origin)
              when origin == ShotOrigin.penalty =>
            [shooterId],
          OffsideMoment(:final playerId) when w.start - t <= _leadIn => [
            playerId,
          ],
          _ => const <int>[],
        },
  };

  /// How far up the pitch, for side [s] attacking [dir], the second-last
  /// opponent stands: the offside line (the keeper counts).
  double _secondLastDepth(int s, int dir) {
    var first = -1.0;
    var second = -1.0;
    for (final o in agents) {
      if (!o.present || o.side == s || o.walkStart != null) continue;
      final d = xToDepth(o.pos.x, dir);
      if (d > first) {
        second = first;
        first = d;
      } else if (d > second) {
        second = d;
      }
    }
    return second < 0 ? PitchDims.length : second;
  }

  /// What [a] does in the seconds before a moment that needs him somewhere:
  /// a set piece's taker heads for the ball, a penalty's taker for the
  /// edge of the box, a man to be flagged offside drifts beyond the line,
  /// the man who commits the foul closes in on its victim.
  (Offset2, double, int)? _leadRole(_Agent a, double t, int minute) {
    if (carrier == a.index) return null;
    final ball = _ballNow(t);
    for (final w in _upcoming(t, _takerLead)) {
      if (w.moments.isEmpty) continue;
      final m = w.moments.first;
      final side = m.teamNationId == lineups.home.nationId ? 0 : 1;
      final dir = _dir(side, m.minute);
      switch (m) {
        case SetPieceMoment(:final takerId) when takerId == a.id:
          return (deadBallSpot(m, dir), 7.0, 2);
        case ShotMoment(:final shooterId, :final origin)
            when origin == ShotOrigin.penalty && shooterId == a.id:
          final at = Offset2(depthToX(86, dir), a.pos.y.clamp(20.0, 48.0));
          return (at, 6.5, 2);
        case ShotMoment(:final shooterId, :final zone)
            when shooterId == a.id && a.side == side && w.start - t <= 6:
          // The shooter gets up toward where he shoots from, onside.
          final want = zonePoint(zone, dir);
          final line = math.max(
            _secondLastDepth(a.side, dir),
            xToDepth(ball.x, dir),
          );
          var depth = xToDepth(want.x, dir);
          if (depth > PitchDims.length / 2) {
            depth = math.min(depth, math.max(line - 0.8, PitchDims.length / 2));
          }
          return (Offset2(depthToX(depth, dir), want.y), 7.0, 2);
        case OffsideMoment(:final playerId)
            when playerId == a.id && w.start - t <= _leadIn:
          final line = math.max(
            _secondLastDepth(a.side, dir),
            xToDepth(ball.x, dir),
          );
          final depth = (line + 2.5).clamp(55.0, 100.0);
          return (Offset2(depthToX(depth, dir), a.pos.y), 6.5, 2);
        case FoulMoment(:final foulerId, :final fouledId)
            when foulerId == a.id && w.start - t <= _foulLead:
          final victim = indexOf[fouledId];
          if (victim == null || !agents[victim].present) return null;
          final v = agents[victim].pos;
          final ownDir = _dir(a.side, minute);
          final goal = Offset2(depthToX(0, ownDir), PitchDims.width / 2);
          return (v + (goal - v).unit * 1.8, 6.5, 2);
        default:
          break;
      }
    }
    return null;
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
      // Keep a little room around everybody. A stager spaces the places it
      // sends men to itself (a wall stands shoulder to shoulder), so its
      // men keep only a little.
      final room = stagedDrive && dist < 1.5 ? 1.2 : 2.0;
      final heading = desired.unit;
      for (final o in present) {
        if (o == a) continue;
        final d = a.pos.distanceTo(o.pos);
        if (d < room) {
          final away = d < 1e-6 ? const Offset2(0, 1) : (a.pos - o.pos).unit;
          v = v + away * ((room - d) * 1.5);
          // Somebody standing in the way: step round him.
          final rel = o.pos - a.pos;
          final ahead = rel.x * heading.x + rel.y * heading.y;
          final side = rel.x * heading.y - rel.y * heading.x;
          if (dist > 1.0 && ahead > 0 && side.abs() < 1.0) {
            final perp = Offset2(heading.y, -heading.x);
            v = v + perp * (side >= 0 ? -2.0 : 2.0);
          }
        }
      }
      final walker = a.walkStart != null;
      v = v.capped(math.max(maxSpeed, maxSpeed > 0 && !walker ? 2.0 : 0.0));
      final dv = (v - a.vel).capped(_accel * dt);
      var nv = (a.vel + dv).capped(walker ? _walkCap : _hardSpeed);
      if (maxSpeed <= 0 && !walker) nv = Offset2.zero;
      var p = _clampPitch(a.pos + nv * dt);
      if (a.slot == sides[a.side].gkSlot &&
          (!inWindow || !activeWindow!.actors.contains(a.id))) {
        // No snapping back: a keeper beyond his reach (back from a moment,
        // or a man just sent in goal) is only kept from going further.
        final dir = _dir(a.side, minute);
        final limit = math.max(_keeperMaxDepth, xToDepth(a.pos.x, dir));
        if (xToDepth(p.x, dir) > limit) p = Offset2(depthToX(limit, dir), p.y);
      }
      proposed[a.index] = p;
    }

    _resolve(present, proposed, priority);

    for (final a in present) {
      final p = proposed[a.index]!;
      a
        ..vel = (p - a.pos) * (1 / dt)
        ..pos = p;
    }
    // Facing: the carrier where he runs (or the goal he attacks), a man
    // walking off where he walks, everyone else toward the ball.
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
    stagedDrive = false;
    if (a.walkStart != null) return (_walkTarget(a), PitchScript.walkSpeed, 3);
    final side = sides[a.side];
    final dir = _dir(a.side, minute);
    final isKeeper = a.slot == side.gkSlot;
    final anchor = anchors[a.index] ?? a.pos;
    if (a.headingInGoal) {
      // Into his area beside the stand-in, then he takes over.
      final spot = Offset2(depthToX(_area - 4, dir), PitchDims.width / 2 + 6);
      return (spot, 6, 2);
    }
    if (inWindow) {
      final d = plan == null || state == null
          ? null
          : plan.drive(a.id, t, state);
      if (d != null) {
        stagedDrive = true;
        final actor = activeWindow!.actors.contains(a.id);
        return (d.target, d.maxSpeed.clamp(0.0, _hardSpeed), actor ? 3 : 2);
      }
      // A keeper the stager leaves alone is never held away from goal: he
      // takes up his place in the shape.
      if (isKeeper) return (anchor, 5.5, 2);
      final f = flight;
      if (f != null && f.toActor == a.index) {
        // A man a pass is for meets it, as in open play.
        final left = math.max(0.15, f.t1 - t);
        return (f.lead, math.min(8, a.pos.distanceTo(f.lead) / left + 1), 2);
      }
      return (a.pos, 0, 2);
    }
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
    final role = _leadRole(a, t, minute);
    if (role != null) return role;
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

  /// Where a man walking off heads now: straight for the touchline, stepping
  /// round anybody standing in his way (play goes on around him, and in a
  /// staged moment the others may be standing still).
  Offset2 _walkTarget(_Agent a) {
    final goal = a.walkTarget!;
    final along = a.walkToGoalLine
        ? Offset2(goal.x >= a.pos.x ? 1 : -1, 0)
        : Offset2(0, goal.y >= a.pos.y ? 1 : -1);
    final across = Offset2(along.y.abs(), along.x.abs());
    var step = 0.0;
    for (final o in agents) {
      if (o == a || !o.present) continue;
      final rel = o.pos - a.pos;
      final ahead = rel.x * along.x + rel.y * along.y;
      final side = rel.x * across.x + rel.y * across.y;
      if (ahead > 0 && ahead < 2.5 && side.abs() < 1.3) {
        step += side >= 0 ? -2.0 : 2.0;
      }
    }
    return a.walkToGoalLine
        ? Offset2(goal.x, (a.pos.y + step).clamp(1.0, PitchDims.width - 1))
        : Offset2((a.pos.x + step).clamp(1.0, PitchDims.length - 1), goal.y);
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
    bool clash(int i, int j) {
      final reach =
          (prop[i] - old[i]).length * f[i] +
          (prop[j] - old[j]).length * f[j] +
          _safeGap;
      final d0 = old[i].distanceTo(old[j]);
      if (d0 > reach) return false;
      // Two men already nearer than the gap may still move apart: only
      // coming any closer is a clash.
      final floor = math.min(_safeGap, d0 - 1e-6);
      return PitchScriptValidator.closestApproach(
            old[i],
            at(i),
            old[j],
            at(j),
          ) <
          floor;
    }

    for (var round = 0; round < 40; round++) {
      var conflict = false;
      for (var i = 0; i < n; i++) {
        for (var j = i + 1; j < n; j++) {
          if (!clash(i, j)) continue;
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
    // The last word: anyone still clashing stands still. Each pass stops at
    // least one more man, and two men standing still never clash.
    var changed = true;
    while (changed) {
      changed = false;
      for (var i = 0; i < n; i++) {
        for (var j = i + 1; j < n; j++) {
          if (!clash(i, j)) continue;
          if (f[i] > 0) {
            f[i] = 0;
            changed = true;
          }
          if (f[j] > 0) {
            f[j] = 0;
            changed = true;
          }
        }
      }
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
    if (c != null) return _ballPoint(agents[c]);
    return restAt ?? PitchDims.centre;
  }

  double _heightNow(double t) {
    final f = flight;
    if (f == null) return carrier == null ? restHeight : 0;
    final u = f.t1 <= f.t0 ? 1.0 : ((t - f.t0) / (f.t1 - f.t0)).clamp(0.0, 1.0);
    return f.fromHeight +
        (f.toHeight - f.fromHeight) * u +
        4 * f.peak * u * (1 - u);
  }

  ScriptState _state(double t) {
    final f = flight;
    final m = pacer.matchAt(_dur(t));
    return ScriptState(
      t: t,
      players: {
        for (final a in agents)
          if (a.present) a.id: a.pos,
      },
      ball: _ballNow(t),
      carrierId: carrier == null ? null : agents[carrier!].id,
      possessionNationId: sides[possession].nationId,
      teams: {
        for (final a in agents)
          if (a.present) a.id: sides[a.side].nationId,
      },
      facing: {
        for (final a in agents)
          if (a.present) a.id: a.facing,
      },
      velocity: {
        for (final a in agents)
          if (a.present) a.id: a.vel,
      },
      walking: {
        for (final a in agents)
          if (a.present && a.walkStart != null) a.id,
      },
      keepers: {
        for (final a in agents)
          if (a.present && a.slot == sides[a.side].gkSlot) a.id,
      },
      flight: f == null
          ? null
          : (
              fromId: f.fromActor == null ? null : agents[f.fromActor!].id,
              toId: f.toActor == null ? null : agents[f.toActor!].id,
              from: f.from,
              lead: f.lead,
              t0: f.t0,
              t1: f.t1,
              peak: f.peak,
              pass: f.pass,
              fromHeight: f.fromHeight,
              toHeight: f.toHeight,
            ),
      homeBallTime: homeBallTime,
      awayBallTime: awayBallTime,
      cameraX: cameraX,
      minute: m.minute,
      stoppage: m.stoppage,
      within: m.within,
    );
  }

  void _record(double t) {
    final n = agents.length;
    final xs = Float64List(n);
    final ys = Float64List(n);
    final face = Float64List(n);
    final keepers = Uint8List(n);
    for (var i = 0; i < n; i++) {
      final a = agents[i];
      xs[i] = a.present ? a.pos.x : double.nan;
      ys[i] = a.present ? a.pos.y : double.nan;
      face[i] = a.facing;
      keepers[i] = a.present && a.slot == sides[a.side].gkSlot ? 1 : 0;
    }
    keyframes.add(
      ScriptKeyframe(
        t: t,
        xs: xs,
        ys: ys,
        facing: face,
        keepers: keepers,
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
