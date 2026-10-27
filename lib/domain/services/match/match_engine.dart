import 'dart:math';

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_conditions.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';
import 'package:fnm/domain/services/match/performance_mark.dart';
import 'package:fnm/domain/services/match/shape_profile.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';
import 'package:meta/meta.dart' show visibleForTesting;

/// A team as it lines up for a match: its starting XI and instructions.
class MatchTeam {
  const MatchTeam({
    required this.nationId,
    required this.xi,
    required this.instructions,
    this.formation = Formation.f433,
    this.roles = const {},
    this.penaltyTakerId,
    this.deadBallTakerId,
    this.conditionByPlayer = const {},
    this.traitsByPlayer = const {},
    this.ratingBonus = 0,
    this.fullBacks = FullBackPushes.neutral,
  });

  final int nationId;
  final List<Player> xi;
  final TacticalInstructions instructions;

  /// The full-backs' individual arrows (see [FullBackPushes] and
  /// [MatchEngine.fullBackLift]). The manager's side only; neutral for every
  /// AI side, which never sets them.
  final FullBackPushes fullBacks;

  /// A HIDDEN per-player rating shift from form, fatigue and morale (player id
  /// → points, positive or negative), applied to strength inside the engine
  /// only.
  ///
  /// It is deliberately not folded into the players' attributes: doing that
  /// made a tired player's `overall` read lower on the match screens than on
  /// the squad screen, so the same footballer appeared to have three different
  /// ratings depending on where you looked. The displayed rating is always the
  /// player's real overall; condition is what the engine quietly does with it.
  final Map<int, int> conditionByPlayer;

  /// A side-wide shift, in rating points, on every man the side fields
  /// (substitutes included), applied on the same seam as [conditionByPlayer].
  ///
  /// This is the scout's opponent dossier (`Staff.dossierBonus`): the
  /// manager's side only, zero for everybody else.
  final int ratingBonus;

  /// Each player's traits (player id → traits), from [PlayerTraits]. Traits are
  /// what make a squad memorable: a hothead collects cards, an iron man barely
  /// tires, a big-game player turns up in the knockouts. Supplied by the caller
  /// so the engine stays free of the save seed the derivation needs.
  final Map<int, List<PlayerTrait>> traitsByPlayer;

  /// Whether [playerId] carries [trait].
  bool hasTrait(int playerId, PlayerTrait trait) =>
      traitsByPlayer[playerId]?.contains(trait) ?? false;

  /// Per-player tactical roles, keyed by player id (absent = [PlayerRole.none]).
  /// Shapes who scores/creates and the set-piece threat; never raw strength.
  final Map<int, PlayerRole> roles;

  /// The manager's designated penalty taker / dead-ball (corner & free-kick)
  /// taker, or null to let the engine pick the best-suited player. Ignored if
  /// that player isn't on the pitch.
  final int? penaltyTakerId;
  final int? deadBallTakerId;

  /// The shape the XI lines up in; `xi[i]` occupies `formation.positions[i]`.
  /// Players fielded away from their natural position take a rating penalty.
  final Formation formation;
}

/// A timed substitution: at [minute], [on] replaces the player [offId] in the
/// XI of the team identified by [teamNationId]. Substitutions are part of the
/// engine input, so a match stays fully deterministic given the same teams,
/// substitutions, and [SeededRng].
class Substitution {
  const Substitution({
    required this.teamNationId,
    required this.minute,
    required this.offId,
    required this.on,
  });

  final int teamNationId;
  final int minute;
  final int offId;
  final Player on;
}

/// A timed live tactical change for one team: from [minute] onward the team
/// identified by [teamNationId] lines up as [xi] (slot order matching
/// [formation]) with [instructions]. This supersedes the team's starting setup
/// and any earlier change. Players in [xi] not already on the pitch come on as
/// substitutes; players dropped are subbed off. Like [Substitution] it is
/// engine input, so the match stays deterministic given the same changes.
class TacticalChange {
  const TacticalChange({
    required this.teamNationId,
    required this.minute,
    required this.formation,
    required this.instructions,
    required this.xi,
    this.slots,
    this.takers,
    this.fullBacks,
  });

  final int teamNationId;
  final int minute;
  final Formation formation;
  final TacticalInstructions instructions;
  final List<Player> xi;

  /// The full-backs' arrows from this minute on, or null to keep the side's
  /// current ones.
  final FullBackPushes? fullBacks;

  /// The place each man in [xi] plays, one per entry, or null to read them
  /// off [formation] in order.
  ///
  /// Reading them in order is right for a full eleven and wrong for a side a
  /// man short: [xi] holds only the men on the pitch, so a hole anywhere but
  /// the last slot shifted everybody after it up a place, and the side the
  /// engine played was not the one on the manager's pitch. A team-mate moved
  /// into a red card's hole lost the move altogether.
  final List<PlayerPosition>? slots;

  /// The place the [i]th man in [xi] plays: his entry in [slots] when given,
  /// otherwise the formation's [i]th place, otherwise his own position.
  PlayerPosition slotOf(int i) {
    final given = slots;
    if (given != null && i < given.length) return given[i];
    final positions = formation.positions;
    return i < positions.length ? positions[i] : xi[i].position;
  }

  /// New set-piece takers from this minute on, or null to leave the side's
  /// existing pair alone. Either id inside may itself be null, which hands that
  /// duty back to the engine's own pick.
  ///
  /// Carried on the CHANGE rather than swapped on the team because a match is
  /// re-simulated from the first minute every time the manager touches
  /// anything: setting the taker on the team would rewrite the penalty he has
  /// already watched being taken.
  final ({int? penalty, int? deadBall})? takers;
}

/// The tone a manager strikes in a team talk (at the interval). Each tone shifts
/// the side's attacking and defensive edge for the rest of the match — a lift
/// when it fits the game state, a smaller or riskier one when it doesn't.
enum TeamTalkTone {
  calm,
  encourage,
  demandMore,
  praise,
  believe,
  focus,
  urgency,
  reassure,
}

extension TeamTalkToneX on TeamTalkTone {
  // Display text (label/blurb) lives in the UI layer (l10n) so it can be
  // localised; the engine only owns the gameplay effect.

  /// The attack / defence rating swing the talk applies for the rest of the
  /// match, on the same scale as home advantage (+3 attack / +2 defence).
  (double attack, double defence) get effect => switch (this) {
    TeamTalkTone.calm => (1, 1),
    TeamTalkTone.encourage => (3, -1),
    TeamTalkTone.demandMore => (4, -2),
    TeamTalkTone.praise => (-1, 3),
    TeamTalkTone.believe => (2, 2),
    TeamTalkTone.focus => (0, 4),
    TeamTalkTone.urgency => (4, -3),
    TeamTalkTone.reassure => (0, 2),
  };
}

/// A timed team talk: at [minute] the manager of [teamNationId] strikes a [tone]
/// that shifts their side's edge for the rest of the match. Engine input, so the
/// match stays deterministic given the same talks and [SeededRng].
class TeamTalk {
  const TeamTalk({
    required this.teamNationId,
    required this.minute,
    required this.tone,
  });

  final int teamNationId;
  final int minute;
  final TeamTalkTone tone;
}

/// The kind of thing that happened in a match.
enum MatchEventType {
  goal,
  substitution,

  /// A caution. A player's second yellow is reported as a [redCard], not two
  /// yellows, so the discipline system treats it as a sending-off.
  yellowCard,

  /// A sending-off (a straight red or a second bookable offence). The player
  /// leaves the pitch and their team plays on a man down.
  redCard,

  /// A player picking up a knock. They leave the pitch — the side plays a man
  /// down unless a substitute comes on — and are sidelined for the games that
  /// follow.
  injury,
}

/// A timed match event.
class MatchEvent {
  const MatchEvent({
    required this.minute,
    required this.type,
    required this.teamNationId,
    required this.playerId,
    required this.playerName,
    this.secondaryName,
    this.assistPlayerId,
    this.assistName,
    this.penalty = false,
    this.secondYellow = false,
    this.stoppage = 0,
    this.setPiece = false,
  });

  final int minute;

  /// Second-half added time: 0 in normal play, or the "+X" of a 90+X event so
  /// a stoppage-time goal reads "90+3" rather than a plain "90". Regulation
  /// events (and extra time) carry 0.
  final int stoppage;
  final MatchEventType type;
  final int teamNationId;
  final int playerId;
  final String playerName;

  /// For a substitution, the name of the player going off (the [playerName] is
  /// the player coming on).
  final String? secondaryName;

  /// For a goal that was set up, the player who provided the assist (null for a
  /// solo goal or a non-goal event).
  final int? assistPlayerId;
  final String? assistName;

  /// Whether a goal was scored from the penalty spot (taken by the side's
  /// designated penalty taker; never assisted).
  final bool penalty;

  /// Whether a goal came from a set piece (a corner/free-kick delivery headed or
  /// bundled home) — the assist is the taker.
  final bool setPiece;

  /// For a [redCard], whether it was a second booking (a one-match ban) rather
  /// than a straight red (which can carry a heavier, severity-based ban).
  final bool secondYellow;
}

/// A single player's performance mark for one match (`3.0`–`10.0`), derived
/// from goals, assists, the result, clean sheets, and cards.
class PlayerRating {
  const PlayerRating({
    required this.playerId,
    required this.playerName,
    required this.teamNationId,
    required this.rating,
    this.position = PlayerPosition.cm,
  });

  final int playerId;
  final String playerName;
  final int teamNationId;
  final double rating;

  /// The player's position, so the ratings list can read top-down like a team
  /// sheet (GK → defence → midfield → attack) rather than by score.
  final PlayerPosition position;
}

/// A side's plan as it was actually fielded: a shape and its instructions.
typedef FieldedPlan = ({
  Formation formation,
  TacticalInstructions instructions,
});

/// The outcome of a simulated match.
class MatchResult {
  const MatchResult({
    required this.homeScore,
    required this.awayScore,
    required this.events,
    required this.homeShots,
    required this.awayShots,
    required this.homePossession,
    this.homeXg = 0,
    this.awayXg = 0,
    this.ratings = const [],
    this.energyByPlayer = const {},
    this.stoppage = 0,
    this.homeXgByMinute = const [],
    this.awayXgByMinute = const [],
    this.homeShotsByMinute = const [],
    this.awayShotsByMinute = const [],
    this.momentumByMinute = const [],
    this.homePlan,
    this.awayPlan,
    this.extraTime,
  });

  /// The score after ninety minutes and stoppage. Stays the regulation score
  /// even when extra time is played: every knockout path keys off "level after
  /// ninety", and the after-extra-time totals live in [extraTime].
  final int homeScore;
  final int awayScore;

  /// The totals after extra time (minutes 91-120), or null when none was
  /// played: only a level match asked for it (see
  /// [MatchEngine.play]'s `extraTimeIfLevel`). Extra-time events carry their
  /// real minutes 91-120, so they never mix with the ninety's.
  final ({int homeScore, int awayScore})? extraTime;

  final List<MatchEvent> events;
  final int homeShots;
  final int awayShots;

  /// Minutes of second-half added time played ("90+[stoppage]") — a few added
  /// minutes, longer the more the match was interrupted. Goals can be scored in
  /// this window (see the stoppage-tagged events).
  final int stoppage;

  /// Expected goals accumulated from the quality of each side's chances.
  final double homeXg;
  final double awayXg;

  /// Cumulative xG per minute (index 0 = kick-off = 0.0, index m = total xG
  /// after minute m), length 91 with any stoppage folded onto minute 90 — drives
  /// the live "xG race" line. Length 121 when [extraTime] was played (minutes
  /// 91-120 follow on). Empty when not recorded.
  final List<double> homeXgByMinute;
  final List<double> awayXgByMinute;

  /// Cumulative shots per minute, shaped exactly like the xG series (index 0 =
  /// kick-off = 0, index m = shots taken after minute m), length 91 with any
  /// stoppage folded onto minute 90 (121 with [extraTime]). Empty when not
  /// recorded. Lets the stats tab report the shot count as of the minute on
  /// the clock instead of making the manager wait for the whistle.
  final List<int> homeShotsByMinute;
  final List<int> awayShotsByMinute;

  /// Net in-match momentum per minute from the home side's view (positive = home
  /// pressing, negative = away), length 91 (121 with [extraTime]) like the xG
  /// series. Empty when not recorded. Drives the live momentum bar.
  final List<double> momentumByMinute;

  /// Each participating player's remaining energy (0–100) at the final whistle,
  /// keyed by player id — fresh subs stay high, a 90-minute man is spent.
  final Map<int, int> energyByPlayer;

  /// Home possession 0–100; away is `100 - homePossession`.
  final int homePossession;

  /// A performance mark for every player who took part, both teams.
  final List<PlayerRating> ratings;

  int get awayPossession => 100 - homePossession;

  /// The plan each side held for the most minutes of the ninety, live changes
  /// included: the shape and the instructions it was actually playing, not
  /// the ones on its team sheet. Two plans are the same when they share a
  /// formation and a [TeamChemistry.planKey], and a tie goes to the one held
  /// later (what the side finished on). Null when not recorded.
  ///
  /// This is what the opposition's video room sees of a match, so it is what
  /// the manager's drilling records: a decoy plan named on the sheet and
  /// switched away from at 1' is a minute of football, not the plan.
  final FieldedPlan? homePlan;
  final FieldedPlan? awayPlan;

  /// The best individual performance of the match, or null if nobody played.
  PlayerRating? get manOfTheMatch {
    if (ratings.isEmpty) return null;
    return ratings.reduce((a, b) => b.rating > a.rating ? b : a);
  }
}

/// Mutable per-team match state: the XI on the pitch right now (and its shape
/// and instructions), which change as substitutions and live tactical changes
/// are applied through the match.
class _Live {
  _Live(this.team)
    : xi = [...team.xi],
      slots = [...team.formation.positions],
      formation = team.formation,
      shape = ShapeProfile.of(team.formation.positions),
      instructions = team.instructions,
      fullBacks = team.fullBacks,
      penaltyTakerId = team.penaltyTakerId,
      deadBallTakerId = team.deadBallTakerId;

  final MatchTeam team;

  /// Who takes the side's penalties and dead balls RIGHT NOW. Seeded from the
  /// team sheet and reassignable mid-match, so a manager whose taker has gone
  /// off (or has just missed one) can hand the ball to somebody else.
  int? penaltyTakerId;
  int? deadBallTakerId;

  /// The players on the pitch right now (reassigned wholesale by a live
  /// tactical change; individual slots are edited by subs and sendings-off).
  List<Player> xi;

  /// The position each XI slot is meant to be — `xi[i]` occupies `slots[i]`.
  /// Stable across substitutions (a sub inherits the slot of the player they
  /// replace) and reset by a live change that reshapes the team.
  List<PlayerPosition> slots;

  /// The formation the side is set up in right now: the team sheet's, until
  /// a live change names another.
  Formation formation;

  /// Minutes played per plan (formation + [TeamChemistry.planKey]), with the
  /// instructions the plan was first held with and the last minute it was
  /// held: what [dominantPlan] reads.
  final Map<
    (Formation, int),
    ({int minutes, int last, TacticalInstructions instructions})
  >
  _planMinutes = {};

  /// Credits [minute] to the plan the side is playing now.
  void tallyPlan(int minute) {
    final key = (formation, TeamChemistry.planKey(instructions));
    final was = _planMinutes[key];
    _planMinutes[key] = (
      minutes: (was?.minutes ?? 0) + 1,
      last: minute,
      instructions: was?.instructions ?? instructions,
    );
  }

  /// The plan held for the most minutes; a tie goes to the one held later.
  FieldedPlan get dominantPlan {
    (Formation, int)? best;
    for (final e in _planMinutes.entries) {
      final b = best == null ? null : _planMinutes[best]!;
      if (b == null ||
          e.value.minutes > b.minutes ||
          (e.value.minutes == b.minutes && e.value.last > b.last)) {
        best = e.key;
      }
    }
    if (best == null) {
      return (formation: formation, instructions: instructions);
    }
    return (formation: best.$1, instructions: _planMinutes[best]!.instructions);
  }

  /// The formation's attacker / defender counts, fixed when the shape is set
  /// and refreshed by a formation change. Deliberately NOT recomputed from
  /// [slots] each minute: a sending-off removes a slot, and the man down is
  /// already paid for by the short-handed penalty, so counting him again as a
  /// lost defender or attacker would charge twice.
  ({double attackers, double defenders}) shape;

  /// The team's current instructions, changeable live during the match. For an
  /// AI-managed side this is recomputed each minute from [team] instructions by
  /// the score and clock (a trailing team commits forward, a leading one sits).
  TacticalInstructions instructions;

  /// The full-backs' arrows right now: the team sheet's, until a live change
  /// names others.
  FullBackPushes fullBacks;

  /// The net arrow (up +1, down -1 each) of the full-backs actually in the
  /// shape on the pitch: an arrow on a flank with no full-back counts nothing.
  int get fullBackNet => fullBacks.netFor(slots);

  /// A rating swing from the last team talk, added to the side's attack /
  /// defence for the rest of the match (0 until the manager gives a talk).
  double talkAttack = 0;
  double talkDefence = 0;

  /// Rolling in-match MOMENTUM. A goal lifts the scorer's [momentumAttack] and
  /// rocks the conceder's [momentumDefence] (negative = reeling); both fade back
  /// toward zero each minute (see [decayMomentum]). Added to the side's ratings,
  /// never to an RNG stream, so the three seeded streams stay byte-stable and a
  /// re-sim rebuilds momentum exactly from the same goal events.
  double momentumAttack = 0;
  double momentumDefence = 0;

  /// A settled, well-drilled side's tactical-familiarity multiplier (~1.0 for a
  /// new/rotating side, up to ~1.06 for a long-settled shape). Applied to attack
  /// and defence. Defaults to 1.0 (neutral) so it never shifts an unset match.
  double chemistry = 1.0;

  /// Whether this is a KNOCKOUT or finals tie — the occasion a big-game player
  /// rises to. Set once per match by the caller.
  bool bigMatch = false;

  /// How much faster than normal the side's legs go in the match's altitude
  /// and heat ([MatchConditions]); 1.0 at sea level in temperate weather,
  /// where multiplying by it changes nothing.
  double conditionsDrain = 1.0;

  /// Whether a LEADER other than [playerId] is on the pitch — a captain lifts
  /// those around them, never themselves.
  bool hasLeaderOtherThan(int playerId) {
    for (final p in xi) {
      if (p.id != playerId && team.hasTrait(p.id, PlayerTrait.leader)) {
        return true;
      }
    }
    return false;
  }

  /// Fades this minute's momentum a little, so a swing that isn't renewed by
  /// another goal decays back to neutral.
  void decayMomentum() {
    momentumAttack *= 0.90;
    momentumDefence *= 0.90;
  }

  /// Players sent off — they can never return, even if a later live change
  /// names them in the XI.
  final Set<int> sentOff = {};

  /// Live energy (0–100) per player id — everyone starts fresh and drains as
  /// they play; a fresh substitute comes on at 100. Low energy saps a player's
  /// effective rating (see [MatchEngine._mean]), so subbing a tired man matters.
  final Map<int, double> energy = {};

  double energyOf(int id) => energy[id] ?? 100.0;

  /// The tactical role assigned to [id], or [PlayerRole.none]. Fixed for the
  /// match (roles are set before kick-off and carried by player id).
  PlayerRole roleOf(int id) => team.roles[id] ?? PlayerRole.none;

  int get nationId => team.nationId;
}

/// Openness weights (see [MatchEngine.openness]). The three commitment weights
/// are per unit off neutral: a mentality or press at 100 is one unit, an extra
/// attacker off the 4-3-3 count is one unit.
///
/// [kOpenUp] is what the bolder side's full commitment adds to both chance
/// rates; [kOpenDown] what two fully cautious sides take off. Tuned on
/// 2026-10-16 (0.45 -> 0.42, 0.3 -> 0.6) with the max-and-mean combination in
/// [MatchEngine.openness]: one all-out side lifts the lab's total goals by
/// about 45%, an all-out mirror by about 80%, and parking the bus cuts them by
/// about a third. Closing needed the bigger weight because it is averaged over
/// both sides where opening is not.
const double kOpenMentality = 0.6;
const double kOpenPressing = 0.25;
const double kOpenAttackers = 0.25;
const double kOpenUp = 0.42;
const double kOpenDown = 0.6;

/// A deterministic, lightweight tactical match engine. It derives attack and
/// defence ratings from each team's XI and instructions, then plays out 90
/// minute-ticks: each tick either side may create a chance and score, with the
/// scorer chosen by finishing ability. Substitutions take effect from their
/// minute onward, changing the on-pitch XI and therefore the ratings for the
/// rest of the match. Same teams + same subs + same [SeededRng] → same match
/// (replay-safe and testable).
class MatchEngine {
  const MatchEngine();

  /// Per-team, per-minute booking probability (~1.3 yellows a team a game).
  static const double _yellowPerMinute = 0.015;

  /// Per-team, per-minute probability of a straight red. Deliberately well
  /// below the second-booking rate: violent conduct is the rare dismissal, a
  /// second caution the ordinary one.
  static const double _straightRedPerMinute = 0.00015;

  /// How often a foul by an already-booked player actually costs him the
  /// second card. The rest of the time the referee has a word instead.
  static const double _secondBookingChance = 0.45;

  /// Per-team, per-minute probability of a player picking up a knock.
  static const double injuryPerMinute = 0.0016;

  /// The extra-time scale on chance creation: open-play and set-piece chance
  /// rates in minutes 91-120 are multiplied by it. Regulation never reads it,
  /// so it moves nothing in the ninety. It is a calibration knob, not a
  /// fatigue model (fatigue already acts on the players): it is set so live
  /// extra time settles about as many level ties as the background
  /// `decideKnockout` draw (about half), which at regulation rates (1.0) it
  /// falls a little short of, and well short at the old 0.8.
  ///
  /// Calibrated 2026-10-20 by `extra_time_calibration_test.dart` (750 level
  /// ninety-minute ties per pair, neutral venue, the away AI managed and
  /// making its regulation subs plus one `planExtraTime` sub at 91). At 1.1
  /// extra time settles 51.2% of 80 v 80 ties (background 50.2%) and 51.2%
  /// of 84 v 76 ties (background 51.2%); the 84-rated side wins 57.0% of the
  /// ties extra time settles against 66.9% of decided ninety-minute games.
  /// Sweep: 0.8 gives 40.3% (80 v 80, fails the 0.06 band), 1.0 gives
  /// 46.7/49.5%, 1.05 48.4/50.1%, 1.15 53.1/52.4%.
  static const double extraTimeChanceFactor = 1.1;

  /// [injuryFactorByNation] scales a team's per-minute injury rate (1.0 = base;
  /// below 1.0 = a nation's medical/sports-science investment keeping players
  /// fit). Absent nations use the base rate. It only affects knock frequency,
  /// not the scoreline or discipline RNG.
  /// [neutralVenue] plays the match on neutral ground (a finals tournament),
  /// where NO side gets a home crowd — except [venueHostId], the tournament's
  /// host nation, who keeps the advantage when they're one of the two teams.
  /// Left as the default (`false`), the [home] team enjoys home advantage as in
  /// a qualifier or friendly.
  /// [atmosphere] scales whatever home advantage applies by how full and how
  /// loud the ground is (1.0 = a normal, well-filled house). A packed stadium
  /// is worth more than a half-empty one, and it is the only thing the crowd
  /// touches — a neutral or empty venue simply leaves the advantage at zero.
  /// [talks] are timed team talks that shift a side's edge for the rest of the
  /// match. [aiManagedNationIds] name the sides whose instructions the engine
  /// reactively manages by the scoreline and clock (typically the human's AI
  /// opponent) — a trailing side commits forward late, a leading side protects.
  /// [conditions] are the ground's altitude and heat: each side's energy
  /// drains faster by its share of them (see [MatchConditions]), so a side
  /// not used to thin air fades late. The default changes nothing.
  /// [extraTimeIfLevel] plays minutes 91-120 after the stoppage when the
  /// ninety ends level (a live knockout). Off by default, and every input to
  /// the ninety is untouched by it: extra time only draws on the RNG streams
  /// after regulation is over, so the regulation score and events are the
  /// same either way. Subs, changes and talks timed 91-120 fire on their
  /// minute; the result's [MatchResult.extraTime] holds the totals.
  MatchResult play({
    required MatchTeam home,
    required MatchTeam away,
    required SeededRng rng,
    List<Substitution> subs = const [],
    List<TacticalChange> changes = const [],
    List<TeamTalk> talks = const [],
    Set<int> aiManagedNationIds = const {},
    Map<int, double> injuryFactorByNation = const {},
    Map<int, double> chemistryByNation = const {},
    bool neutralVenue = false,
    int? venueHostId,
    bool bigMatch = false,
    double atmosphere = 1.0,
    bool extraTimeIfLevel = false,
    MatchConditions conditions = MatchConditions.none,
  }) {
    final liveHome = _Live(home)
      ..chemistry = chemistryByNation[home.nationId] ?? 1.0
      ..bigMatch = bigMatch
      ..conditionsDrain = conditions.homeDrain;
    final liveAway = _Live(away)
      ..chemistry = chemistryByNation[away.nationId] ?? 1.0
      ..bigMatch = bigMatch
      ..conditionsDrain = conditions.awayDrain;
    // Who, if anyone, plays in front of a home crowd this match.
    final homeAdvantage = !neutralVenue || home.nationId == venueHostId;
    final awayAdvantage = neutralVenue && away.nationId == venueHostId;

    // Substitutions grouped by the minute they happen on, applied in order.
    final byMinute = <int, List<Substitution>>{};
    for (final s in subs) {
      (byMinute[s.minute] ??= []).add(s);
    }
    // Live tactical changes grouped by minute, applied after the same subs.
    final changesByMinute = <int, List<TacticalChange>>{};
    for (final c in changes) {
      (changesByMinute[c.minute] ??= []).add(c);
    }
    // Team talks grouped by minute (the interval, and any later restart).
    final talksByMinute = <int, List<TeamTalk>>{};
    for (final t in talks) {
      (talksByMinute[t.minute] ??= []).add(t);
    }

    final events = <MatchEvent>[];
    // Players already on a yellow, so a second booking becomes a red.
    final booked = <int>{};
    // Everyone who takes part, for post-match ratings — starters plus anyone
    // who comes on. Keyed by id so a player is only rated once.
    final appeared = <int, Player>{
      for (final p in home.xi) p.id: p,
      for (final p in away.xi) p.id: p,
    };
    // Assist attribution runs on its own stream so it never disturbs the
    // scoring/discipline RNG — the exact scoreline and cards stay identical
    // whether or not assists are computed.
    final assistRng = SeededRng(rng.state ^ 0x5F356495);
    // Set pieces run on their OWN third stream, so adding this channel leaves
    // the open-play scoreline and cards byte-identical to before — the new goals
    // are strictly additive.
    final setPieceRng = SeededRng(rng.state ^ 0x2718C3D9);
    var homeScore = 0;
    var awayScore = 0;
    var homeShots = 0;
    var awayShots = 0;
    var homeXg = 0.0;
    var awayXg = 0.0;

    // One minute of play. [manageMinute] drives AI management and fatigue
    // (stoppage reuses 90); [stoppage] tags any event as second-half added time
    // (0 in normal play, 1..N for "90+X"). Scheduled subs / changes / talks fire
    // on their real minute only, never re-applied in added time. Minutes past
    // 90 are extra time, with chance rates scaled by [extraTimeChanceFactor];
    // in the ninety the factor is exactly 1.
    void playMinute(int manageMinute, int stoppage) {
      final legs = manageMinute > 90 ? extraTimeChanceFactor : 1.0;
      if (stoppage == 0) {
        for (final s in byMinute[manageMinute] ?? const <Substitution>[]) {
          final live = s.teamNationId == liveHome.nationId
              ? liveHome
              : liveAway;
          final event = _applySub(live, s, manageMinute);
          if (event != null) {
            events.add(event);
            appeared[s.on.id] = s.on;
          }
        }
        for (final c
            in changesByMinute[manageMinute] ?? const <TacticalChange>[]) {
          final live = c.teamNationId == liveHome.nationId
              ? liveHome
              : liveAway;
          _applyChange(live, c, manageMinute, events);
          for (final p in c.xi) {
            appeared[p.id] = p;
          }
        }
        for (final t in talksByMinute[manageMinute] ?? const <TeamTalk>[]) {
          final live = t.teamNationId == liveHome.nationId
              ? liveHome
              : liveAway;
          final (a, d) = t.tone.effect;
          live
            ..talkAttack = a
            ..talkDefence = d;
        }
      }

      // A reactively-managed AI side rethinks its approach by the scoreline and
      // the clock: chase the game when behind late, protect a lead when ahead.
      if (aiManagedNationIds.contains(liveHome.nationId)) {
        liveHome.instructions = _manage(
          liveHome.team.instructions,
          homeScore - awayScore,
          manageMinute,
        );
      }
      if (aiManagedNationIds.contains(liveAway.nationId)) {
        liveAway.instructions = _manage(
          liveAway.team.instructions,
          awayScore - homeScore,
          manageMinute,
        );
      }

      // Each minute of the ninety is credited to the plan each side is
      // playing in it (see [MatchResult.homePlan]). Extra time is not: the
      // plan read is the ninety's, flag or no flag.
      if (stoppage == 0 && manageMinute <= 90) {
        liveHome.tallyPlan(manageMinute);
        liveAway.tallyPlan(manageMinute);
      }

      // Players tire as the match wears on, weakening the side until fresh legs
      // come on — so a well-timed substitution genuinely helps.
      _deplete(liveHome);
      _deplete(liveAway);

      // Last minute's momentum fades a touch before this minute's ratings use it.
      liveHome.decayMomentum();
      liveAway.decayMomentum();

      // Home advantage (+3 attack / +2 defence) goes to the side actually
      // playing at home — nobody at a neutral finals unless it's the host — plus
      // any team-talk swing, plus the running MOMENTUM (a goal lifts a side and
      // rocks the other), plus the tactical MATCH-UP: how each side's plan and
      // its players' attributes fare against the other's (see [_matchup]).
      final homeAttack =
          _attack(liveHome) +
          (homeAdvantage ? 3 * atmosphere : 0) +
          liveHome.talkAttack +
          liveHome.momentumAttack +
          _matchup(liveHome, liveAway);
      final homeDefence =
          _defence(liveHome) +
          (homeAdvantage ? 2 * atmosphere : 0) +
          liveHome.talkDefence +
          liveHome.momentumDefence;
      final awayAttack =
          _attack(liveAway) +
          (awayAdvantage ? 3 * atmosphere : 0) +
          liveAway.talkAttack +
          liveAway.momentumAttack +
          _matchup(liveAway, liveHome);
      final awayDefence =
          _defence(liveAway) +
          (awayAdvantage ? 2 * atmosphere : 0) +
          liveAway.talkDefence +
          liveAway.momentumDefence;

      // Snapshot the score so a goal this minute can swing momentum afterwards.
      final homeBefore = homeScore;
      final awayBefore = awayScore;

      // Possession share: the side that keeps the ball more creates a little
      // more and lets the other have less — so a patient, passing side is
      // rewarded for controlling the game, not just its raw ratings.
      final homeControl = _control(liveHome);
      final awayControl = _control(liveAway);
      final controlTotal = homeControl + awayControl;
      final homeShare = controlTotal <= 0 ? 0.5 : homeControl / controlTotal;

      // How open the game is this minute, and how committed each side is: one
      // reading for both chance rolls (neither depends on the score).
      final homeCommit = _commitment(liveHome);
      final awayCommit = _commitment(liveAway);
      final open = opennessOf(homeCommit, awayCommit);
      // The full-backs' arrows: each side's chance rate answers its own
      // arrows (attack) and the other side's (exposure).
      final homeFlanks = fullBackLift(
        own: liveHome.fullBackNet,
        opponent: liveAway.fullBackNet,
      );
      final awayFlanks = fullBackLift(
        own: liveAway.fullBackNet,
        opponent: liveHome.fullBackNet,
      );

      if (_chance(
        rng,
        homeAttack,
        awayDefence,
        liveHome.instructions,
        homeShare,
        damping:
            legs *
            homeFlanks *
            _blowoutDamping(homeScore, awayScore) *
            _scorelineOpenness(
              open,
              homeScore - awayScore,
              own: homeCommit,
              opponent: awayCommit,
            ),
      )) {
        homeShots++;
        // The player taking the shot is chosen now, so their fatigue can affect
        // the finish — a spent striker underperforms the chance.
        final shooter = _pickScorer(liveHome, rng);
        final baseP = _goalProbability(homeAttack, awayDefence);
        homeXg += baseP; // xG is the CHANCE quality, before the finish
        final p =
            (baseP *
                    _finishingSharpness(liveHome.energyOf(shooter.id)) *
                    _finishTrait(liveHome, shooter.id))
                .clamp(0.04, 0.44);
        if (rng.chance(p)) {
          homeScore++;
          events.add(
            _goal(
              manageMinute,
              liveHome,
              shooter,
              assistRng,
              stoppage: stoppage,
            ),
          );
        }
      }
      if (_chance(
        rng,
        awayAttack,
        homeDefence,
        liveAway.instructions,
        1 - homeShare,
        damping:
            legs *
            awayFlanks *
            _blowoutDamping(awayScore, homeScore) *
            _scorelineOpenness(
              open,
              awayScore - homeScore,
              own: awayCommit,
              opponent: homeCommit,
            ),
      )) {
        awayShots++;
        final shooter = _pickScorer(liveAway, rng);
        final baseP = _goalProbability(awayAttack, homeDefence);
        awayXg += baseP;
        final p =
            (baseP *
                    _finishingSharpness(liveAway.energyOf(shooter.id)) *
                    _finishTrait(liveAway, shooter.id))
                .clamp(0.04, 0.44);
        if (rng.chance(p)) {
          awayScore++;
          events.add(
            _goal(
              manageMinute,
              liveAway,
              shooter,
              assistRng,
              stoppage: stoppage,
            ),
          );
        }
      }

      // Set pieces — a third, additive channel on its own RNG stream. Corners /
      // free-kicks reward aerial strength and a good delivery, so a physical,
      // set-piece-strong side scores goals open play alone wouldn't give it.
      final homeSp = _setPiece(
        liveHome,
        liveAway,
        manageMinute,
        setPieceRng,
        stoppage: stoppage,
        damping: legs * _blowoutDamping(homeScore, awayScore),
      );
      if (homeSp.shot) homeShots++;
      homeXg += homeSp.xg;
      if (homeSp.goal != null) {
        homeScore++;
        events.add(homeSp.goal!);
      }
      final awaySp = _setPiece(
        liveAway,
        liveHome,
        manageMinute,
        setPieceRng,
        stoppage: stoppage,
        damping: legs * _blowoutDamping(awayScore, homeScore),
      );
      if (awaySp.shot) awayShots++;
      awayXg += awaySp.xg;
      if (awaySp.goal != null) {
        awayScore++;
        events.add(awaySp.goal!);
      }

      // A goal swings momentum: the scorer's side presses on, the conceding side
      // reels. Deterministic — a pure function of the goals scored this minute.
      if (homeScore > homeBefore) {
        _swingMomentum(liveHome, liveAway, homeScore - homeBefore);
      }
      if (awayScore > awayBefore) {
        _swingMomentum(liveAway, liveHome, awayScore - awayBefore);
      }

      _discipline(
        liveHome,
        manageMinute,
        rng,
        events,
        booked,
        injuryFactorByNation[liveHome.nationId] ?? 1.0,
        stoppage: stoppage,
      );
      _discipline(
        liveAway,
        manageMinute,
        rng,
        events,
        booked,
        injuryFactorByNation[liveAway.nationId] ?? 1.0,
        stoppage: stoppage,
      );
    }

    // Cumulative xG snapshots per minute (index 0 = kick-off), for the race line.
    final homeXgByMinute = <double>[0];
    final awayXgByMinute = <double>[0];
    // The same snapshot for shots, so the box score can be read live.
    final homeShotsByMinute = <int>[0];
    final awayShotsByMinute = <int>[0];
    // Net momentum per minute from the home side's view (+ = home on top), for
    // the live momentum bar. Same length/shape as the xG series.
    final momentumByMinute = <double>[0];
    for (var minute = 1; minute <= 90; minute++) {
      playMinute(minute, 0);
      homeXgByMinute.add(homeXg);
      awayXgByMinute.add(awayXg);
      homeShotsByMinute.add(homeShots);
      awayShotsByMinute.add(awayShots);
      momentumByMinute.add(liveHome.momentumAttack - liveAway.momentumAttack);
    }
    // Second-half stoppage time ("90+X"): a deterministic few added minutes,
    // longer the more the match was interrupted (goals, subs, cards, knocks), in
    // which the same chance/discipline logic keeps running — so a winner can be
    // snatched in added time, and the clock reads 90+1, 90+2, …
    final stoppageMinutes = (1 + events.length * 0.35).round().clamp(1, 8);
    for (var s = 1; s <= stoppageMinutes; s++) {
      playMinute(90, s);
    }
    // Fold stoppage-time xG and shots onto the final (90') point of the series.
    homeXgByMinute[homeXgByMinute.length - 1] = homeXg;
    awayXgByMinute[awayXgByMinute.length - 1] = awayXg;
    homeShotsByMinute[homeShotsByMinute.length - 1] = homeShots;
    awayShotsByMinute[awayShotsByMinute.length - 1] = awayShots;
    momentumByMinute[momentumByMinute.length - 1] =
        liveHome.momentumAttack - liveAway.momentumAttack;

    // Extra time, asked for and earned by a level ninety: thirty more minutes
    // on the same streams, after everything regulation drew from them. The
    // regulation score is kept for [MatchResult.homeScore]; the running score
    // carries on into the totals.
    final regulationHome = homeScore;
    final regulationAway = awayScore;
    final playExtraTime = extraTimeIfLevel && homeScore == awayScore;
    if (playExtraTime) {
      for (var minute = 91; minute <= 120; minute++) {
        playMinute(minute, 0);
        homeXgByMinute.add(homeXg);
        awayXgByMinute.add(awayXg);
        homeShotsByMinute.add(homeShots);
        awayShotsByMinute.add(awayShots);
        momentumByMinute.add(liveHome.momentumAttack - liveAway.momentumAttack);
      }
    }

    final homeControl = _control(liveHome);
    final awayControl = _control(liveAway);
    final homePossession = (100 * homeControl / (homeControl + awayControl))
        .round();

    // Order by minute, then by added-time index so a 90+3 goal sits after the
    // 90' events rather than being scrambled among them.
    events.sort((a, b) {
      final byMin = a.minute.compareTo(b.minute);
      return byMin != 0 ? byMin : a.stoppage.compareTo(b.stoppage);
    });
    return MatchResult(
      homeScore: regulationHome,
      awayScore: regulationAway,
      extraTime: playExtraTime
          ? (homeScore: homeScore, awayScore: awayScore)
          : null,
      homePlan: liveHome.dominantPlan,
      awayPlan: liveAway.dominantPlan,
      events: events,
      homeShots: homeShots,
      awayShots: awayShots,
      homeXg: homeXg,
      awayXg: awayXg,
      homeXgByMinute: homeXgByMinute,
      awayXgByMinute: awayXgByMinute,
      homeShotsByMinute: homeShotsByMinute,
      awayShotsByMinute: awayShotsByMinute,
      momentumByMinute: momentumByMinute,
      stoppage: stoppageMinutes,
      homePossession: homePossession,
      ratings: _rate(
        appeared.values,
        events,
        homeNationId: home.nationId,
        homeScore: homeScore,
        awayScore: awayScore,
      ),
      energyByPlayer: {
        for (final e in liveHome.energy.entries) e.key: e.value.round(),
        for (final e in liveAway.energy.entries) e.key: e.value.round(),
      },
    );
  }

  /// Applies a momentum swing when [scoring] beats [conceding] for [n] goal(s)
  /// this minute: the scorers push on (attack up), the conceders reel (defence
  /// down). Clamped so momentum stays a nudge, not a runaway feedback loop.
  void _swingMomentum(_Live scoring, _Live conceding, int n) {
    scoring.momentumAttack = (scoring.momentumAttack + 1.4 * n).clamp(
      -2.5,
      2.5,
    );
    conceding.momentumDefence = (conceding.momentumDefence - 1.1 * n).clamp(
      -2.5,
      2.5,
    );
  }

  /// Turns the match into a performance mark for everyone who played. Pure and
  /// RNG-free: base 6.5, adjusted for goals, assists, the result, clean sheets,
  /// and cards, then clamped to a believable 3.0–10.0 range.
  List<PlayerRating> _rate(
    Iterable<Player> players,
    List<MatchEvent> events, {
    required int homeNationId,
    required int homeScore,
    required int awayScore,
  }) {
    final goals = <int, int>{};
    final assists = <int, int>{};
    final yellows = <int>{};
    final reds = <int>{};
    for (final e in events) {
      switch (e.type) {
        case MatchEventType.goal:
          goals.update(e.playerId, (v) => v + 1, ifAbsent: () => 1);
          final a = e.assistPlayerId;
          if (a != null) {
            assists.update(a, (v) => v + 1, ifAbsent: () => 1);
          }
        case MatchEventType.yellowCard:
          yellows.add(e.playerId);
        case MatchEventType.redCard:
          reds.add(e.playerId);
        case MatchEventType.substitution:
        case MatchEventType.injury:
          break;
      }
    }

    return [
      for (final p in players)
        PlayerRating(
          playerId: p.id,
          playerName: p.name,
          teamNationId: p.nationId,
          position: p.position,
          rating: _mark(
            p,
            goals: goals[p.id] ?? 0,
            assists: assists[p.id] ?? 0,
            booked: yellows.contains(p.id),
            sentOff: reds.contains(p.id),
            teamScore: p.nationId == homeNationId ? homeScore : awayScore,
            oppScore: p.nationId == homeNationId ? awayScore : homeScore,
          ),
        ),
    ];
  }

  /// Delegates to [PerformanceMark] so the manager's matches and the rest of
  /// the world's are marked on exactly the same scale — see that class.
  double _mark(
    Player p, {
    required int goals,
    required int assists,
    required bool booked,
    required bool sentOff,
    required int teamScore,
    required int oppScore,
  }) => PerformanceMark.forPlayer(
    category: p.category,
    goals: goals,
    assists: assists,
    booked: booked,
    sentOff: sentOff,
    teamScore: teamScore,
    oppScore: oppScore,
  );

  /// Swaps the incoming player in for the one going off on the pitch,
  /// returning a substitution event (or null if the player to come off isn't
  /// found).
  MatchEvent? _applySub(_Live live, Substitution s, int minute) {
    final idx = live.xi.indexWhere((p) => p.id == s.offId);
    if (idx == -1) return null;
    final off = live.xi[idx];
    live.xi[idx] = s.on;
    return MatchEvent(
      minute: minute,
      type: MatchEventType.substitution,
      teamNationId: live.nationId,
      playerId: s.on.id,
      playerName: s.on.name,
      secondaryName: off.name,
    );
  }

  /// Applies a live tactical change: reshapes the team, updates its
  /// instructions, and swaps the on-pitch XI to the newly chosen one (excluding
  /// anyone already sent off), emitting a substitution event for each player
  /// who comes on that wasn't on the pitch before.
  void _applyChange(
    _Live live,
    TacticalChange c,
    int minute,
    List<MatchEvent> events,
  ) {
    final before = live.xi.map((p) => p.id).toSet();
    final offNames = {for (final p in live.xi) p.id: p.name};

    // Rebuild the XI in the new formation's slot order, dropping anyone sent
    // off so a change can never field an ineligible player.
    final newXi = <Player>[];
    final newSlots = <PlayerPosition>[];
    for (var i = 0; i < c.xi.length; i++) {
      final p = c.xi[i];
      if (live.sentOff.contains(p.id)) continue;
      newXi.add(p);
      newSlots.add(c.slotOf(i));
    }

    // Timeline: pair each incoming player with a player who dropped off.
    final after = newXi.map((p) => p.id).toSet();
    final incoming = newXi.where((p) => !before.contains(p.id)).toList();
    final offIds = before.difference(after).toList();
    for (var k = 0; k < incoming.length; k++) {
      events.add(
        MatchEvent(
          minute: minute,
          type: MatchEventType.substitution,
          teamNationId: live.nationId,
          playerId: incoming[k].id,
          playerName: incoming[k].name,
          secondaryName: k < offIds.length ? offNames[offIds[k]] : null,
        ),
      );
    }

    live
      ..xi = newXi
      ..slots = newSlots
      ..formation = c.formation
      // From the formation, not [newSlots]: a man sent off is missing from
      // [newSlots], and he is already paid for by the short-handed penalty
      // (see [_Live.shape]). Counting the slots would charge him again the
      // moment the manager touched anything.
      ..shape = ShapeProfile.ofFormation(c.formation)
      ..instructions = c.instructions;
    if (c.fullBacks case final f?) live.fullBacks = f;
    if (c.takers case final t?) {
      live
        ..penaltyTakerId = t.penalty
        ..deadBallTakerId = t.deadBall;
    }
  }

  /// Rolls one minute of discipline for [live]: a possible booking (a second
  /// caution becomes a sending-off), a possible straight red, and a possible
  /// knock. A red removes the player from the pitch for the rest of the match.
  void _discipline(
    _Live live,
    int minute,
    SeededRng rng,
    List<MatchEvent> events,
    Set<int> booked,
    double injuryFactor, {
    int stoppage = 0,
  }) {
    if (live.xi.isEmpty) return;

    // A tired team commits more — legs gone, challenges mistimed. The per-minute
    // foul and knock rates rise with the side's collective fatigue, so cards and
    // injuries cluster late in the game and punish over-running a thin squad.
    final tiredness = _teamFatigue(live);

    if (rng.chance(_yellowPerMinute * tiredness)) {
      final culprit = _pickCulprit(live, rng, booked: booked);
      if (booked.contains(culprit.id)) {
        // Not every foul by a booked man is punished: a referee who has already
        // shown him a card often settles for a word instead of ending his
        // match. Without that leniency the culprit bias above would send
        // someone off in every other game.
        if (rng.chance(_secondBookingChance)) {
          // A second booking — a one-match ban, flagged so discipline doesn't
          // treat it as a violent-conduct straight red.
          events.add(
            _card(
              minute,
              live,
              culprit,
              MatchEventType.redCard,
              secondYellow: true,
              stoppage: stoppage,
            ),
          );
          _leaveField(live, culprit.id);
        }
      } else {
        booked.add(culprit.id);
        events.add(
          _card(
            minute,
            live,
            culprit,
            MatchEventType.yellowCard,
            stoppage: stoppage,
          ),
        );
      }
    } else if (rng.chance(_straightRedPerMinute)) {
      final culprit = _pickCulprit(live, rng);
      events.add(
        _card(
          minute,
          live,
          culprit,
          MatchEventType.redCard,
          stoppage: stoppage,
        ),
      );
      _leaveField(live, culprit.id);
    }

    if (live.xi.isNotEmpty &&
        rng.chance(injuryPerMinute * injuryFactor * tiredness)) {
      final hurt = _pickCulprit(live, rng, injury: true);
      events.add(
        _card(minute, live, hurt, MatchEventType.injury, stoppage: stoppage),
      );
      // A hurt player leaves the pitch, exactly as a sent-off one does. Only
      // the event used to be emitted, so he played the rest of the match at
      // full strength: the "injury" cost nothing until the *next* game, and
      // declining the substitution was free.
      //
      // The side plays a man down from here unless someone is brought on.
      _leaveField(live, hurt.id);
    }
  }

  MatchEvent _card(
    int minute,
    _Live live,
    Player p,
    MatchEventType type, {
    bool secondYellow = false,
    int stoppage = 0,
  }) => MatchEvent(
    minute: minute,
    stoppage: stoppage,
    type: type,
    teamNationId: live.nationId,
    playerId: p.id,
    playerName: p.name,
    secondYellow: secondYellow,
  );

  /// Removes [playerId] from the pitch — sent off or hurt — dropping their
  /// formation slot too, so the team plays on a man down for the rest of the
  /// match unless a substitute comes on.
  void _leaveField(_Live live, int playerId) {
    live.sentOff.add(playerId);
    final idx = live.xi.indexWhere((p) => p.id == playerId);
    if (idx == -1) return;
    live.xi.removeAt(idx);
    if (idx < live.slots.length) live.slots.removeAt(idx);
  }

  /// A side's collective fatigue as a rate multiplier: 1.0 with fresh legs,
  /// rising toward ~1.5 when the whole XI is spent — so the more a team has run
  /// itself into the ground, the more fouls and knocks it picks up.
  double _teamFatigue(_Live t) {
    if (t.xi.isEmpty) return 1.0;
    var sum = 0.0;
    for (final p in t.xi) {
      sum += t.energyOf(p.id);
    }
    final mean = sum / t.xi.length;
    return 1.0 + (100 - mean) / 100 * 0.5;
  }

  /// Picks the player at fault for a foul or knock, weighting harder-working
  /// defensive players (who make more challenges), the less composed, and — now
  /// — the more TIRED: a player running on empty mistimes challenges and pulls
  /// up hurt more often, so fatigue drives late fouls, cards and knocks.
  ///
  /// [booked] players are likelier to be the culprit again — a man on a yellow
  /// is the man mistiming the next challenge, and referees watch him. Without
  /// this the same player had to be drawn twice at random out of eleven, which
  /// is why second bookings effectively never happened.
  Player _pickCulprit(
    _Live live,
    SeededRng rng, {
    bool injury = false,
    Set<int> booked = const {},
  }) {
    double weight(Player p) {
      final positional = switch (p.category) {
        PositionCategory.defender => 3.0,
        PositionCategory.midfielder => 2.2,
        PositionCategory.forward => 1.2,
        PositionCategory.goalkeeper => 0.3,
      };
      final composure = (1.3 - p.attributes.technical / 100).clamp(0.4, 1.3);
      // 1.0 fresh → ~1.6 spent: tired legs are more likely to give it away.
      final fatigue = 1.0 + (100 - live.energyOf(p.id)) / 100 * 0.6;
      // Traits decide WHO it happens to, not how often it happens: a hothead
      // takes a bigger share of the side's cards, an iron man a smaller share
      // of its knocks. The team-level rates are untouched.
      var trait = 1.0;
      if (!injury && live.team.hasTrait(p.id, PlayerTrait.hothead)) {
        trait *= PlayerTraits.hotheadCardFactor;
      }
      if (injury && live.team.hasTrait(p.id, PlayerTrait.ironMan)) {
        trait *= PlayerTraits.ironManInjuryFactor;
      }
      final onAYellow = booked.contains(p.id) ? 3.0 : 1.0;
      return positional * composure * fatigue * trait * onAYellow;
    }

    final total = live.xi.fold<double>(0, (sum, p) => sum + weight(p));
    var roll = rng.nextDouble() * total;
    for (final p in live.xi) {
      roll -= weight(p);
      if (roll <= 0) return p;
    }
    return live.xi.last;
  }

  /// Midfield control, used to estimate possession. A quicker tempo helps hold
  /// the ball; playing more directly (long, early balls) cedes possession.
  double _control(_Live t) =>
      _mean(t, PositionCategory.midfielder) +
      (t.instructions.tempo - 50) * 0.05 -
      (t.instructions.directness - 50) * 0.06;

  /// [commitment] for a side as it stands this minute (live instructions and
  /// shape, so in-match changes count).
  double _commitment(_Live t) => commitment(t.instructions, t.shape.attackers);

  /// How far forward one side commits, -1..1: mentality, pressing and extra
  /// attackers off the 4-3-3, each weighted, the sum clamped. 0 is neutral.
  static double commitment(TacticalInstructions i, double attackers) =>
      ((i.mentality - 50) / 50 * kOpenMentality +
              (i.pressing - 50) / 50 * kOpenPressing +
              (attackers - ShapeProfile.neutralAttackers) * kOpenAttackers)
          .clamp(-1.0, 1.0);

  /// How much one full-back pushed on lifts his own side's OPEN-PLAY chance
  /// rate ([kFullBackAttack]) and the opponent's ([kFullBackExposure]); held
  /// back, the same amounts the other way.
  ///
  /// Deliberately slight, and the two equal: an arrow buys risk, not an edge.
  /// Set pieces are untouched, so 3.5% on open play is about 2.5% on all the
  /// chances a side makes: two arrows up is about +5% for and against, one
  /// about half that. Kept apart from every other tactical dial (and out of
  /// [RatingMatchSimulator]'s own tuning) so it can be retuned on its own;
  /// `full_back_push_test` holds the bands.
  static const double kFullBackAttack = 0.035;
  static const double kFullBackExposure = 0.035;

  /// The share of an engine side's chances that come from open play, the
  /// only ones the arrows touch. What the skip path scales by, so a skipped
  /// match moves its goals as much as a played one (see [fullBackOpenness]).
  static const double kOpenPlayShare = 0.72;

  /// The chance-rate multiplier for a side whose full-backs net [own] arrows,
  /// against an opponent netting [opponent] (see [FullBackPushes.netFor]):
  /// its own push adds attack, the opponent's push leaves the opponent open.
  /// 1.0 when neither side has touched an arrow.
  static double fullBackLift({required int own, required int opponent}) =>
      (1 + kFullBackAttack * own) * (1 + kFullBackExposure * opponent);

  /// [fullBackLift] for a match the world simulates rather than plays, as
  /// one openness on [RatingMatchSimulator] (which applies it to both sides'
  /// xG): exact here because an arrow lifts both ends by the same factor,
  /// with the geometric mean keeping it honest should the two weights ever be
  /// split. Scaled by [kOpenPlayShare], since the simulator's goals have no
  /// set pieces held apart.
  static double fullBackOpenness(int net) =>
      1 +
      kOpenPlayShare *
          (sqrt(
                fullBackLift(own: net, opponent: 0) *
                    fullBackLift(own: 0, opponent: net),
              ) -
              1);

  /// [openness] from the two sides' [commitment]s.
  static double opennessOf(double home, double away) {
    final opening = max(max(home, away), 0.0);
    final closing = (min(home, 0.0) + min(away, 0.0)) / 2;
    return 1 + opening * kOpenUp + closing * kOpenDown;
  }

  /// How open the game is, as a multiplier on BOTH sides' chance rate.
  ///
  /// A rating-based mentality penalty alone lets a bold side pay at the back
  /// but never makes the GAME wilder: two sides throwing men forward should
  /// trade chances, two sides sitting in should strangle each other. Each
  /// side's commitment (mentality, pressing, extra attackers off the 4-3-3)
  /// is clamped to +-1. Neutral against neutral is exactly 1.0.
  ///
  /// It takes ONE side to open a game and BOTH to shut it: the bolder side's
  /// forward commitment sets how open it is (the max), and the two sides'
  /// caution is averaged. Until 2026-10-16 both were averaged, and that made
  /// an all-out mirror pay twice: each side's flat attacking lift already
  /// meets the other's flat defensive hole, so a second bold side on top
  /// doubled the multiplier as well, and the mirror ran to 8 goals a game
  /// with one in seven a four-goal rout. With the max, a lone all-out side
  /// opens the game about as much as two do, and what the second adds is its
  /// own flat terms. A bold side against a cautious one is open by the bold
  /// side's commitment less half the cautious one's.
  ///
  /// The range is 1 - [kOpenDown] .. 1 + [kOpenUp] = 0.4 .. 1.42 by
  /// construction; the top needs one side at full commitment, the bottom
  /// both. In play the scoreline bends it further (see [_scorelineOpenness]).
  static double openness({
    required TacticalInstructions home,
    required TacticalInstructions away,
    required double homeAttackers,
    required double awayAttackers,
  }) => opennessOf(
    commitment(home, homeAttackers),
    commitment(away, awayAttackers),
  );

  /// [open] (see [openness]) as one side's chance-rate multiplier when it is
  /// [margin] goals up (negative: down), [own] and [opponent] being the two
  /// sides' [commitment]s.
  ///
  /// When BOTH sides have opened the game (each commitment above neutral)
  /// and the side in front is at least as committed as the side behind, the
  /// leader stops trading blows and sits on its lead (its rate falls to
  /// `1 / open`) and the side behind throws even more forward (`open`
  /// squared). That is what a wild game between two bold sides looks like:
  /// goals at both ends, the lead changing hands, not a 6-1. Without it an
  /// all-out mirror at 4.9 goals a game had one match in ten decided by four
  /// or more. With it, 5%.
  ///
  /// Otherwise nothing bends: both keep `open`. A lone bold side opened the
  /// game and pays for that at the back like anyone else, leading or
  /// trailing; and a side BEHIND that is bolder than the leader is chasing,
  /// which must not also make the leader sit. Until 2026-10-17 the bend
  /// applied whoever had opened the game, so a manager a goal down who went
  /// all-out got his own rate doubled and the leader's cut to 0.7 at the same
  /// time: the late chase cost nothing at the back and earned three times
  /// what it had before this build (`tactics_chase_test.dart`, against a
  /// neutral side and against committed favourites). Neither condition alone
  /// was enough: "leader at least as bold" alone charged a bold plan the
  /// bend when ahead of a neutral side and gave it none when behind, which
  /// broke the committed plans' guards; "both committed" alone switched the
  /// free chase back on against any committed leader (the dominant and
  /// gegenPress postures).
  ///
  /// A level game, or a closed one (`open` <= 1), is untouched, so a neutral
  /// match is exactly as before.
  static double _scorelineOpenness(
    double open,
    int margin, {
    required double own,
    required double opponent,
  }) {
    if (open <= 1 || margin == 0) return open;
    if (own <= 0 || opponent <= 0) return open;
    final leaderIsBold = margin > 0 ? own >= opponent : opponent >= own;
    if (!leaderIsBold) return open;
    return margin > 0 ? 1 / open : open * open;
  }

  bool _chance(
    SeededRng rng,
    double attack,
    double oppDefence,
    TacticalInstructions instr,
    double controlShare, {
    double damping = 1.0,
  }) {
    // Chance CREATION is where the strength gap tells hardest: a clearly better
    // side manufactures most of the openings, and that — not a freakish
    // conversion rate — is what makes the favourite win reliably. The rate is
    // tightly capped, so even a gross mismatch can't conjure an endless stream
    // of chances; that ceiling is what keeps 6-goal routs rare. A quick tempo
    // and a larger share of possession both lift it (0.5 share = neutral).
    //
    // The exponent is what decides how loudly a rating gap speaks. At 2.2 it
    // shouted: two good sides a dozen points apart (a Brazil against an
    // Ecuador) played out like a superpower against a minnow — 2.5-0.9 with a
    // 70% win rate and routs in a fifth of games. [_ratio] is already convex in
    // the gap (see there), so the extra amplification only had to be modest;
    // it is now sized so that comparable sides play tight games and the score
    // only runs away when the gulf is genuine.
    final edge = pow(_ratio(attack, oppDefence), 1.2).toDouble();
    final rate =
        (0.078 * edge * (0.85 + instr.tempo / 333) * (0.7 + 0.6 * controlShare))
            .clamp(0.010, 0.280);
    // The damping is applied AFTER the clamp: a side four up is meant to fall
    // below the floor the rate normally sits on, not be held up by it.
    return rng.chance(rate * damping);
  }

  /// Once a side is well clear it stops chasing goals — substitutions, a
  /// dropped tempo, and an opponent packing the box. Without this the
  /// per-minute model is memoryless and a hot seed runs away to 8-0 far more
  /// often than football does.
  double _blowoutDamping(int scored, int conceded) {
    final margin = scored - conceded;
    if (margin < 3) return 1.0;
    return 1.0 / (1.0 + (margin - 2) * 0.6);
  }

  /// The probability a created chance is finished. Deliberately FLAT: a good
  /// chance is a good chance whoever gets it, so the strength edge here is weak
  /// (exponent well below 1) and the ceiling low. The favourite outscores by
  /// taking more chances, not by converting each one at an absurd rate — this
  /// is what keeps scorelines realistic and makes >5-goal games rare.
  double _goalProbability(double attack, double oppDefence) =>
      (0.145 * pow(_ratio(attack, oppDefence), 0.25)).clamp(0.03, 0.20);

  /// The attack-to-defence strength ratio, measured ABOVE a replacement
  /// baseline rather than from zero. This makes a rating gap tell more sharply
  /// where it matters: two sides six points apart near the top (80 vs 74) are
  /// a meaningfully bigger mismatch than the raw 1.08 ratio implies, so a
  /// clearly better team wins more reliably — fewer flukey "upsets" — without
  /// needing an inflated scoreline to do it. Both sides are floored well above
  /// the baseline so a decimated team (red cards, deep fatigue) can never drive
  /// the ratio negative or to infinity. Callers raise this to their own
  /// exponent: a strong one for chance creation (the favourite makes more
  /// openings), a gentle one for conversion (a chance converts at a fairly
  /// steady rate) — so class tells through the VOLUME of chances, not by
  /// blowing up every result.
  double _ratio(double attack, double oppDefence) {
    const base = 26.0;
    final a = (attack - base).clamp(8.0, double.infinity);
    final d = (oppDefence - base).clamp(8.0, double.infinity);
    return a / d;
  }

  MatchEvent _goal(
    int minute,
    _Live team,
    Player scorer,
    SeededRng assistRng, {
    int stoppage = 0,
  }) {
    // [scorer] was chosen at shot time (so fatigue could dull the finish). The
    // penalty branch decides on the separate assist stream, so whether a goal
    // is a spot-kick never shifts the score.
    if (assistRng.chance(0.09)) {
      final taker = _penaltyTaker(team);
      return MatchEvent(
        minute: minute,
        stoppage: stoppage,
        type: MatchEventType.goal,
        teamNationId: team.nationId,
        playerId: taker.id,
        playerName: taker.name,
        penalty: true,
      );
    }
    final assister = _pickAssister(team, scorer, assistRng);
    return MatchEvent(
      minute: minute,
      stoppage: stoppage,
      type: MatchEventType.goal,
      teamNationId: team.nationId,
      playerId: scorer.id,
      playerName: scorer.name,
      assistPlayerId: assister?.id,
      assistName: assister?.name,
    );
  }

  /// The side's penalty taker: the manager's designated taker if they're on the
  /// pitch, else the outfield player with the best finishing; the first player
  /// when a team is somehow empty.
  Player _penaltyTaker(_Live team) {
    final chosen = _designated(team, team.penaltyTakerId);
    if (chosen != null) return chosen;
    final outfield = team.xi
        .where((p) => p.category != PositionCategory.goalkeeper)
        .toList();
    final pool = outfield.isEmpty ? team.xi : outfield;
    if (pool.isEmpty) return team.xi.first;
    return pool.reduce(
      (a, b) => b.attributes.technical > a.attributes.technical ? b : a,
    );
  }

  /// The player [id] if they're currently on the pitch for [team], else null —
  /// so a designated taker who's been subbed off or sent off falls back to auto.
  Player? _designated(_Live team, int? id) {
    if (id == null) return null;
    for (final p in team.xi) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// Picks the teammate who set up a goal, or null for a solo effort (~30% of
  /// goals). Assists weight creative, attacking players (passing + position),
  /// excluding the scorer and, in practice, the goalkeeper.
  Player? _pickAssister(_Live team, Player scorer, SeededRng rng) {
    if (rng.chance(0.30)) return null; // unassisted
    final candidates = team.xi
        .where((p) => p.id != scorer.id)
        .toList(growable: false);
    if (candidates.isEmpty) return null;

    double weight(Player p) {
      final positional = switch (p.category) {
        PositionCategory.midfielder => 10.0,
        PositionCategory.forward => 8.0,
        PositionCategory.defender => 3.0,
        PositionCategory.goalkeeper => 0.2,
      };
      return (p.attributes.technical + positional) *
          team.roleOf(p.id).assistWeight;
    }

    final total = candidates.fold<double>(0, (sum, p) => sum + weight(p));
    var roll = rng.nextDouble() * total;
    for (final p in candidates) {
      roll -= weight(p);
      if (roll <= 0) return p;
    }
    return candidates.last;
  }

  /// Picks a scorer, weighting outfield players by finishing and attacking
  /// position.
  Player _pickScorer(_Live team, SeededRng rng) {
    final candidates = team.xi
        .where((p) => p.category != PositionCategory.goalkeeper)
        .toList();
    if (candidates.isEmpty) return team.xi.first;

    // The line a player plays in is MULTIPLIED in, not added to his finishing.
    // Added, it barely separated anyone: a 70-technical centre-half weighed 71
    // against a striker's 95, so defenders took better than a third of every
    // side's goals. As a multiplier the line dominates and finishing then
    // separates players within it, which lands a 4-4-2 at roughly half the
    // goals to the forwards, a little under 40% to midfield and one in ten to
    // the back four — what a real season looks like.
    double weight(Player p) {
      final positional = switch (p.category) {
        PositionCategory.forward => 5.0,
        PositionCategory.midfielder => 2.0,
        PositionCategory.defender => 0.55,
        PositionCategory.goalkeeper => 0.0,
      };
      return (p.attributes.technical + 20) *
          positional *
          team.roleOf(p.id).scorerWeight;
    }

    final total = candidates.fold<double>(0, (sum, p) => sum + weight(p));
    var roll = rng.nextDouble() * total;
    for (final p in candidates) {
      roll -= weight(p);
      if (roll <= 0) return p;
    }
    return candidates.last;
  }

  /// Per-team, per-minute chance a set-piece situation (corner / dangerous
  /// free-kick) arises — ~3 a side a game.
  static const double _setPiecePerMinute = 0.035;

  /// Plays the set-piece channel for [atk] against [def] this minute on the
  /// independent [rng] stream. Returns whether an attempt happened ([shot]), its
  /// xG, and a goal event when it goes in. Purely additive to open play.
  ({MatchEvent? goal, double xg, bool shot}) _setPiece(
    _Live atk,
    _Live def,
    int minute,
    SeededRng rng, {
    int stoppage = 0,
    double damping = 1.0,
  }) {
    // A side well clear works its corners as lazily as it works open play, so
    // the same damping applies here — otherwise the set-piece channel alone
    // keeps the rout going.
    if (atk.xi.isEmpty || !rng.chance(_setPiecePerMinute * damping)) {
      return (goal: null, xg: 0, shot: false);
    }
    // Aerial duel in the box: the attackers' physicality (and defenders up for
    // it) against the defence and keeper.
    final threat = (_aerialAttack(atk) / _aerialDefence(def)).clamp(0.5, 2.0);
    // The scorer and the deliverer are settled BEFORE the roll, so a set-piece
    // specialist's better ball actually raises the chance of the goal rather
    // than only being named on one that was going in anyway.
    final scorer = _pickHeader(atk, rng);
    final taker = _setPieceTaker(atk, scorer);
    final delivery =
        taker != null && atk.team.hasTrait(taker.id, PlayerTrait.setPiece)
        ? PlayerTraits.setPieceFactor
        : 1.0;
    final p = (0.08 * pow(threat, 1.2) * delivery).toDouble().clamp(0.02, 0.30);
    final xg = p; // the chance's quality
    if (!rng.chance(p)) return (goal: null, xg: xg, shot: true);
    return (
      goal: MatchEvent(
        minute: minute,
        stoppage: stoppage,
        type: MatchEventType.goal,
        teamNationId: atk.nationId,
        playerId: scorer.id,
        playerName: scorer.name,
        assistPlayerId: taker?.id,
        assistName: taker?.name,
        setPiece: true,
      ),
      xg: xg,
      shot: true,
    );
  }

  /// The attacking side's aerial threat at a set piece: its forwards' and
  /// defenders' (who come up) strength.
  double _aerialAttack(_Live t) =>
      (_lineAttr(t, PositionCategory.forward, (a) => a.physical) +
          _lineAttr(t, PositionCategory.defender, (a) => a.physical)) /
      2;

  /// The defending side's ability to clear a set piece: its back line and keeper.
  double _aerialDefence(_Live t) =>
      _lineAttr(t, PositionCategory.defender, (a) => a.physical) * 0.7 +
      _lineAttr(t, PositionCategory.goalkeeper, (a) => a.physical) * 0.3;

  /// Picks the set-piece scorer: an outfield player who attacks the ball,
  /// weighted by strength (aerial power), forwards and defenders most likely.
  Player _pickHeader(_Live team, SeededRng rng) {
    final candidates = team.xi
        .where((p) => p.category != PositionCategory.goalkeeper)
        .toList();
    if (candidates.isEmpty) return team.xi.first;
    // As with open play, the line multiplies rather than adds — added, the four
    // centre-backs and full-backs took more of the side's set-piece goals than
    // its forwards did. Defenders are still a real aerial threat (a corner is
    // the one moment a back four is in the box), just the second one.
    double weight(Player p) {
      final positional = switch (p.category) {
        PositionCategory.forward => 3.5,
        PositionCategory.defender => 1.0,
        PositionCategory.midfielder => 0.9,
        PositionCategory.goalkeeper => 0.0,
      };
      return (p.attributes.physical + 20) *
          positional *
          team.roleOf(p.id).aerialWeight;
    }

    final total = candidates.fold<double>(0, (s, p) => s + weight(p));
    var roll = rng.nextDouble() * total;
    for (final p in candidates) {
      roll -= weight(p);
      if (roll <= 0) return p;
    }
    return candidates.last;
  }

  /// The set-piece taker (credited with the assist): the manager's designated
  /// dead-ball taker if on the pitch (and not the scorer), else the side's best
  /// passer. Null when nobody else is on the pitch.
  Player? _setPieceTaker(_Live team, Player scorer) {
    final chosen = _designated(team, team.deadBallTakerId);
    if (chosen != null && chosen.id != scorer.id) return chosen;
    final pool = team.xi.where((p) => p.id != scorer.id).toList();
    if (pool.isEmpty) return null;
    return pool.reduce(
      (a, b) => b.attributes.technical > a.attributes.technical ? b : a,
    );
  }

  /// The penalty for playing short-handed, in RATING POINTS off the side's
  /// attack (and, at [_shortHandedDefenceShare], off its defence).
  ///
  /// It used to be a multiplier (×0.72 per red), which scaled the whole rating
  /// and so flattened the sides together: a 28% cut costs a strong team far
  /// more absolute rating than a weak one, so a good side reduced to ten was
  /// pushed *below* a poor side with eleven and scoring became close to
  /// impossible. A flat deduction is just as big a blow at the top of the scale
  /// and leaves the gap between the two teams intact — being a man down should
  /// hurt, not erase the difference in quality.
  ///
  /// Each further sending-off costs more than the last (nine men is far worse
  /// than ten), and the ten who are left also cover more ground (see
  /// [_deplete]), so a red still compounds over what's left of the game.
  ///
  /// Sixteen points was too polite: measured over six thousand games between
  /// two equal sides, a red cost the offending team 0.44 goals of the final
  /// difference and about a sixth of a point, so a sending-off read as a
  /// caption rather than as the thing that decided the night. At 26 it costs
  /// 0.67 goals and a fifth of a point, which is nearer what an hour with ten
  /// men is actually worth.
  static const double shortHandedAttackPenalty = 26.0;
  static const double _shortHandedEscalation = 8.0;
  static const double _shortHandedDefenceShare = 0.85;

  double _shortHandedPenalty(_Live t) {
    final n = t.sentOff.length;
    if (n == 0) return 0;
    return n * shortHandedAttackPenalty +
        n * (n - 1) / 2 * _shortHandedEscalation;
  }

  /// Re-derives an AI side's instructions from its [base] setup by the game
  /// state: from the hour mark a trailing team pushes its mentality, tempo and
  /// line up (harder the bigger the deficit and the later it gets), while a
  /// leading team drops mentality and its line to see the game out. Level games
  /// and the first hour are left alone, so the AI plays its plan until it has a
  /// reason not to. Deterministic (score + minute only), so re-sims are stable.
  TacticalInstructions _manage(
    TacticalInstructions base,
    int scoreDiff,
    int minute,
  ) {
    if (minute < 60 || scoreDiff == 0) return base;
    final urgency = ((minute - 60) / 30).clamp(0.0, 1.0);
    final magnitude = scoreDiff.abs().clamp(1, 3);
    double shift(double base, double perUrgency) =>
        (base + perUrgency * urgency).clamp(0, 100);
    if (scoreDiff < 0) {
      // Chasing the game: throw caution to the wind, more so the further behind.
      final push = 8.0 + 6.0 * magnitude; // 1 down → 14, 3 down → 26 (at 90')
      return base.copyWith(
        mentality: shift(base.mentality.toDouble(), push).round(),
        tempo: shift(base.tempo.toDouble(), push * 0.6).round(),
        defensiveLine: shift(base.defensiveLine.toDouble(), push * 0.5).round(),
      );
    }
    // Protecting a lead: sit deeper and slow it down, more so with a slender one.
    final drop = 6.0 + 4.0 * (4 - magnitude); // narrow lead protected hardest
    return base.copyWith(
      mentality: shift(base.mentality.toDouble(), -drop).round(),
      defensiveLine: shift(base.defensiveLine.toDouble(), -drop * 0.7).round(),
    );
  }

  /// Mean of one attribute across the players fielded in a line — so a matchup
  /// can key on, say, the defenders' pace rather than only their overall.
  double _lineAttr(
    _Live t,
    PositionCategory category,
    int Function(PlayerAttributes) pick,
  ) {
    final values = <double>[];
    final n = t.xi.length;
    for (var i = 0; i < n; i++) {
      final slot = i < t.slots.length ? t.slots[i] : t.xi[i].position;
      if (slot.category != category) continue;
      values.add(pick(t.xi[i].attributes).toDouble());
    }
    if (values.isEmpty) return 55;
    return values.reduce((a, b) => a + b) / values.length;
  }

  /// The tactical MATCH-UP: an attack-rating swing for [atk] from how its plan
  /// and its players' attributes fare against [def]'s. Rock-paper-scissors
  /// counters, so a plan beats some setups and loses to others rather than being
  /// universally good:
  ///
  ///  1. DIRECT into a HIGH LINE (or a back three) opens space in behind — but
  ///     a deep block smothers it, and who wins the ball there is a PACE duel
  ///     between the attackers and the back line.
  ///  2. A HIGH PRESS strangles a slow, possession build-up (worse the poorer
  ///     the passers, and only as far as the pressers' STAMINA carries it) — but
  ///     a DIRECT team plays straight through it.
  ///  3. Attacking WIDE against a NARROW defence stretches it (and narrow
  ///     against a wide one overloads the middle).
  ///  4. A PATIENT build-up picks a DEEP block apart.
  double _matchup(_Live atk, _Live def) => matchupBonus(
    attacker: atk.instructions,
    defender: def.instructions,
    fwdPace: _lineAttr(atk, PositionCategory.forward, (x) => x.physical),
    defPace: _lineAttr(def, PositionCategory.defender, (x) => x.physical),
    midPass: _lineAttr(atk, PositionCategory.midfielder, (x) => x.technical),
    pressEngine: _lineAttr(
      def,
      PositionCategory.midfielder,
      (x) => x.stamina,
    ),
    backLine: def.shape.defenders,
  );

  /// The body of [_matchup], on the two plans and the four line attributes it
  /// reads, so the live engine and the skip path ([planEffect]) run the SAME
  /// arithmetic and can never drift apart. [_matchup] measures the lines off
  /// the pitch; [planEffect] has no players, so it passes
  /// [kNeutralLineAttribute] for all four, where every attribute term reads
  /// zero and only the plans speak. [backLine] is the defending side's
  /// defender count ([ShapeProfile]); both callers read it off the shape.
  static double matchupBonus({
    required TacticalInstructions attacker,
    required TacticalInstructions defender,
    required double fwdPace,
    required double defPace,
    required double midPass,
    required double pressEngine,
    double backLine = ShapeProfile.neutralDefenders,
  }) {
    double n(int v) => (v - 50) / 50.0;
    final a = attacker;
    final d = defender;

    // MAGNITUDE (2026-09): every coefficient below was tripled, and the clamp
    // widened with them. The shapes and signs are unchanged — what changed is
    // how much they are worth. Measured against an identical squad playing an
    // exploitable plan, the old numbers bought a well-judged manager 0.04 of a
    // goal a game: statistically real, humanly invisible, and the reason the
    // feedback was that the dials were not connected to anything. Tripled, the
    // same plan is worth about a sixth of a goal a game — a goal every six
    // games from out-thinking the opponent alone, on top of what drilling the
    // shape is worth. See test/unit/match/tactics_swing_test.dart, which pins
    // the band from both sides.
    //
    // 2026-10-16 (tactics impact): the whole bonus is now weighted by
    // [kMatchupWeight] after the clamp, and the terms below grew two
    // relations (the patient build-up, the back three in behind) and lost one
    // (the mentality clash). The owner's bar is that a well-judged plan
    // against a badly-judged one between equal squads is worth 0.3-0.5 of a
    // goal a game, and that every plan has a counter.
    var bonus = 0.0;

    // 1) DIRECT play into a high line finds space in behind (deep block smothers
    //    it); who wins that space is a pace duel. Possession play keys off
    //    control instead, so it takes nothing from this term.
    final directAttack = n(a.directness).clamp(0.0, 1.0);
    final paceDuel = ((fwdPace - defPace) / 40).clamp(-1.0, 1.0);
    //    The line is read with a [kNeutralExposure] offset: a MID line is still
    //    exposed, and only a genuinely deep one (about 35 or below) closes the
    //    space. Without it a neutral 50 reads as zero and is a safe harbour.
    //    A back THREE is exposed in the channels like a higher line, and a
    //    back five shuts them like a deeper one ([kBackLineExposure] per
    //    defender off the 4-3-3 count).
    final lineExposure =
        (n(d.defensiveLine) +
                kNeutralExposure +
                (ShapeProfile.neutralDefenders - backLine) * kBackLineExposure)
            .clamp(-1.0, 1.0);
    //    A deep block does not just deny the space, it SMOTHERS long balls
    //    into it ([kDeepLineSmother]): this is the counter-attacking side's
    //    weakness. Without it nothing beat a direct, deep-lying plan, which
    //    takes from every committed line and gives nothing back.
    final exposure = lineExposure < 0
        ? lineExposure * kDeepLineSmother
        : lineExposure;
    bonus += directAttack * exposure * (10.5 + 7.5 * paceDuel);

    // 2) Press vs build-up, bypassed by directness.
    final press = n(d.pressing).clamp(0.0, 1.0);
    // possession-minded; a neutral build-up still counts as part-slow, so a
    // press has something to bite on (see [kNeutralExposure]).
    final slow = (-n(a.directness) + kNeutralExposure).clamp(0.0, 1.0);
    final passRelief = ((midPass - 55) / 60).clamp(0.0, 0.6);
    final engine = ((pressEngine - 55) / 45).clamp(-0.4, 1.0);
    bonus -= press * slow * (7.5 + 6.0 * engine) * (1 - passRelief);

    //    SPACE BEHIND a press, and a direct side playing straight through it.
    //    The turnovers above are the presser's reward; this is its bill. A
    //    side that has thrown its midfield forward leaves the channels open,
    //    and the opponent's pace and willingness to go long decide how much
    //    it is punished. It scales with the press itself (so a half-hearted
    //    press risks little) and is signed by the pace duel: slow forwards
    //    against quick defenders find nothing, and the clamp below still
    //    bounds the total. This replaces the flat defensive gain pressing
    //    used to carry, which made it free.
    //
    //    The long ball is read with the [kNeutralExposure] offset, like the
    //    build-up above: a press bites a neutral build-up, so a neutral side
    //    also finds some of the space behind it. Without it a press against
    //    a neutral side conceded no more than not pressing (1.287 a game
    //    against 1.291), and "a gamble" was a free lunch. This term also
    //    absorbs the old separate "direct beats press" (7.5 at full
    //    directness), which paid a direct side twice for the same space.
    final longBall = (n(a.directness) + kNeutralExposure).clamp(0.0, 1.0);
    bonus +=
        press * (longBall * kPressSpaceDirect + paceDuel * kPressSpacePace);

    // 3) Width mismatch. BOTH cases are a gain for the attacker, and that is
    //    deliberate: stretching a narrow block and overloading the middle of a
    //    stretched one are both real ways to find a chance, so a width mismatch
    //    opens the game at BOTH ends rather than one side taking what the other
    //    loses. What it is not allowed to do is pay each side twice.
    //
    //    Until 2026-09 it did exactly that. `n(a) * -n(d)` and `-n(a) * n(d)`
    //    are the SAME expression — both are `-n(a) * n(d)` — so whenever the
    //    two widths straddled 50 the clamp let both through, in either
    //    direction, and every side collected 7.5 AND 6.0 of the same quantity.
    //    It cancelled out of goal difference, which is all the guards watched,
    //    but not out of the scoreline: at the tripled coefficients a 100-vs-0
    //    mismatch was adding +0.87 goals a game to a 2.52 baseline. The sign
    //    was never the problem — the two cases simply were not separated.
    //
    //    So each case is now gated on which side of 50 the ATTACKER is: a wide
    //    side gets the wide-vs-narrow term and nothing else, a narrow side the
    //    narrow-vs-wide term and nothing else. Two sides on the same side of 50
    //    still get neither, exactly as before. A neutral 50 attacker gets
    //    neither either (see [widthMatchup]).
    //    The wide reading is worth more because the attacker also pays for it:
    //    a stretched shape costs at the back (see [kWidthDefence] in
    //    [_defence]), where a narrow one is paid there instead.
    //
    //    A neutral 50 is EXPOSED, not a source of gain: it is exploited only
    //    by an attacker COMMITTED on width ([kNeutralExposure] is read off the
    //    defender's side only). Two neutral sides therefore get exactly
    //    nothing from this term, as before the offset existed.
    bonus += widthMatchup(attackerWidth: a.width, defenderWidth: d.width);

    // 4) PATIENCE against a deep block. A side that keeps the ball and works
    //    it short can pick a low block apart: it has the time to move the
    //    ball until a gap opens, where a long ball runs into a wall (see the
    //    smother in 1). The defence is read with the [kNeutralExposure]
    //    offset, so a mid line still gives a patient side something; the
    //    attacker must be committed (a neutral build-up gets nothing). This
    //    is what beats parking the bus and the counter-attacking plan, which
    //    until 2026-10-16 had no counter at all.
    final patient = (-n(a.directness)).clamp(0.0, 1.0);
    final deepBlock = (-n(d.defensiveLine) + kNeutralExposure).clamp(0.0, 1.0);
    bonus += patient * deepBlock * kPatience;

    //    There used to be a fifth term here, the MENTALITY CLASH: commitment
    //    paid extra against a committed side and less against a deep one.
    //    [openness] now carries "two bold sides open the game", so its upper
    //    half counted that twice, and its lower half made all-out attack a
    //    LOSS against a passive side, which the build's bar says it must not
    //    be. Removed on 2026-10-16.

    // The safety valve: a plan can win or lose a match, but it should never
    // replace a squad. The clamp is -18..+22 before [kMatchupWeight], so
    // -33.3..+40.7 rating points after it: since 2026-10-16 the valve scales
    // with the weight, and at the extremes it is no longer "well short of the
    // rating gulf that makes a rout". What it bounds now is a stack of every
    // term at once, attribute terms (pace duel, pass relief, press engine)
    // included. Between real squads those are small (the forward/defender
    // physical gap within a nation runs -5..0, about +-0.12 of the duel), so
    // in practice the bonus sits far inside the valve, and "squad still
    // decides" is guarded by the lab with both flat and real squads
    // (`tactics_lab_test.dart`) rather than promised by this clamp.
    return bonus.clamp(-18.0, 22.0) * kMatchupWeight;
  }

  /// The width part of [_matchup], split out so the "neutral gives nothing"
  /// guarantee can be tested directly. The attacker must be committed (a 50
  /// reads 0); the defender's neutral 50 counts as part-stretched on both
  /// readings, which is what makes a neutral shape counterable.
  @visibleForTesting
  static double widthMatchup({
    required int attackerWidth,
    required int defenderWidth,
  }) {
    double n(int v) => (v - 50) / 50.0;
    final wideAttack = n(attackerWidth).clamp(0.0, 1.0);
    final narrowAttack = (-n(attackerWidth)).clamp(0.0, 1.0);
    final narrowDef = (-n(defenderWidth) + kNeutralExposure).clamp(0.0, 1.0);
    final wideDef = (n(defenderWidth) + kNeutralExposure).clamp(0.0, 1.0);
    // wide vs narrow, then narrow vs wide
    return wideAttack * narrowDef * 7.5 + narrowAttack * wideDef * 6.0;
  }

  /// How much of a dial's neutral 50 still counts as "exposed" in [_matchup]
  /// (direct vs a mid line, a press vs a neutral build-up, width vs a neutral
  /// shape, a long ball behind a press, patience vs a mid line). It exists so
  /// there is no safe middle: a committed plan can always find the side that
  /// has committed to nothing. Kept at its Task 5 value of 0.3 on 2026-10-16:
  /// the counters that needed more reach got their own terms instead.
  static const double kNeutralExposure = 0.3;

  /// The 2026-10-16 weight on the whole [_matchup] bonus (applied after its
  /// clamp). At 1.0 the textbook counter-plan in `tactics_swing_test.dart`
  /// was worth 0.08 of a goal a game against the plan it is built to beat,
  /// with drilling set aside; the owner's bar is 0.3-0.5. At 1.85 it reads
  /// about 0.37, the strongest counter in the lab's plan grid about half a
  /// goal, and a 10-point-better squad on the plan most exposed to it still
  /// wins more than it loses (`tactics_lab_test.dart` guards both).
  static const double kMatchupWeight = 1.85;

  /// How much harder a DEEP line smothers a long ball than a high one invites
  /// it: the negative side of the line exposure in [_matchup] is multiplied by
  /// this. 3 is what gives the counter-attacking plan a counter (a back five
  /// sitting deep); much more and that one pairing turns 0-0 so often that a
  /// better squad stops beating it.
  static const double kDeepLineSmother = 3;

  /// How much a back line one defender short of the 4-3-3 count (or one over)
  /// reads like a line 10 points higher (or deeper) in the direct-ball term of
  /// [_matchup]. It is what a back three pays for its extra attacker, beyond
  /// the flat shape cost, and it gives the 3-4-3 a counter: the direct side
  /// that runs the channels behind it.
  static const double kBackLineExposure = 0.2;

  /// A fully patient build-up against a fully deep block, in raw [_matchup]
  /// points (before [kMatchupWeight]). Sized so possession is the bus's
  /// counter and the counter-attacking plan's (about +0.3 and +0.2 a game
  /// between equal squads) without making possession dominant: the press
  /// still beats it.
  static const double kPatience = 18;

  /// How far the mentality slider moves a side's attack, per point away from
  /// the neutral 50.
  ///
  /// Cut from 0.35 to 0.10 on 2026-10-16. Mentality's WILDNESS now lives in
  /// [openness], which lifts both ends at once; this flat term is only what a
  /// bolder side gains on the other. At 0.35 (with [kMentalityDefence] at
  /// 0.28) every all-out side's flat lift met the other's flat hole and the
  /// all-out mirror ran to 8 goals a game.
  static const double kMentalityAttack = 0.10;

  /// The other half of the same bargain: what committing forward costs at the
  /// back. It sits a little under [kMentalityAttack] (0.07 to 0.10), so all-out
  /// attack stays a slight net positive against a passive side and about break
  /// even against a neutral one: through [openness] it concedes nearly as many
  /// extra goals as it scores (`tactics_tradeoffs_test.dart`).
  static const double kMentalityDefence = 0.07;

  /// What a quick tempo is worth going forward, and what a high line is worth
  /// going forward (it wins the ball higher) and COSTS at the back (the space
  /// behind it), per point off the neutral 50.
  ///
  /// Until 2026-10-16 the line's defensive term was ADDED, so a high line made
  /// a side harder to score against, which contradicted every comment around
  /// it and made a high line a free lunch against anyone who did not go long.
  /// It is now a cost, and all three are smaller (0.08 / 0.10 / 0.12 ->
  /// 0.03 / 0.04 / 0.04): like mentality, what they add to the all-out plan
  /// stacks in a mirror.
  static const double kTempoAttack = 0.03;
  static const double kLineAttack = 0.04;
  static const double kLineDefence = 0.04;

  /// What a stretched, wide shape costs at the back, per point off the neutral
  /// 50. Pressing no longer has a flat term here: it wins the ball in
  /// [_matchup] and leaves space behind there, so it is a gamble, not a gift.
  /// Cut 0.06 -> 0.015 on 2026-10-16: at 0.06 width cost what its match-up
  /// against a neutral shape earned, so committing to it bought nothing.
  static const double kWidthDefence = 0.015;

  /// The space a press leaves behind, as an attack bonus for the pressed side
  /// in [_matchup], at a full press: for a fully direct long ball (read with
  /// the neutral offset), and for a pace duel won outright.
  static const double kPressSpaceDirect = 2.5;
  static const double kPressSpacePace = 4.5;

  /// Formation shape, in rating points per man off the 4-3-3 count (see
  /// [ShapeProfile]). Each extra attacker lifts the attack by [kShapeAttack]
  /// and thins the back by [kShapeAttackCost]; each extra defender does the
  /// reverse with [kShapeDefence] / [kShapeDefenceCost].
  ///
  /// Equal gain and cost since 2026-10-16 (was 4.0 gain / 2.5 cost): a shape
  /// is a TRADE, attack for defence, and what it changes most is how open the
  /// game is (extra attackers count in [openness]). With the gain bigger than
  /// the cost every extra man was a net plus, so the 4-2-4 beat the 4-3-3 for
  /// free and the 3-4-3 lost 0.26 a game to its missing defenders alone.
  static const double kShapeAttack = 1.25;
  static const double kShapeAttackCost = 1.25;
  static const double kShapeDefence = 1.25;
  static const double kShapeDefenceCost = 1.25;

  /// What a plan is worth to a side described by a SINGLE strength number, in
  /// rating points.
  ///
  /// The engine never needs this: it builds an attack and a defence and moves
  /// them separately. `RatingMatchSimulator` — which plays every match the
  /// manager does not watch — has one number per side, and the honest scalar
  /// reading of a plan that lifts the attack by one thing and the defence by
  /// another is the MEAN of the two, because that one number drives what the
  /// side scores and what it concedes symmetrically.
  ///
  /// Every coefficient is the engine's own, read from [_attack] and [_defence]
  /// above rather than restated, so the two can never drift apart. Directness
  /// and width carry no flat term in the attack for the same reason they carry
  /// none there: their value is decided by the match-up (see [_matchup]), which
  /// a scalar simulator has no shape to compare against.
  static double planRatingDelta(
    TacticalInstructions i, {
    Formation formation = Formation.f433,
  }) {
    final t = _planTerms(i, formation);
    return (t.attack + t.defence) / 2;
  }

  /// The flat attack and defence lifts behind [planRatingDelta], apart:
  /// [planEffect] needs them separately, because a plan that buys attack with
  /// defence opens a game the one-number mean cannot show.
  static ({double attack, double defence}) _planTerms(
    TacticalInstructions i,
    Formation formation,
  ) {
    double off(int v) => (v - 50).toDouble();
    final shape = ShapeProfile.of(formation.positions);
    final extraAttackers = shape.attackers - ShapeProfile.neutralAttackers;
    final extraDefenders = shape.defenders - ShapeProfile.neutralDefenders;
    final attack =
        off(i.mentality) * kMentalityAttack +
        off(i.tempo) * kTempoAttack +
        off(i.defensiveLine) * kLineAttack +
        extraAttackers * kShapeAttack -
        extraDefenders * kShapeDefenceCost;
    final defence =
        -off(i.mentality) * kMentalityDefence -
        off(i.defensiveLine) * kLineDefence -
        off(i.width) * kWidthDefence +
        extraDefenders * kShapeDefence -
        extraAttackers * kShapeAttackCost;
    return (attack: attack, defence: defence);
  }

  /// The line attribute [planEffect] feeds [matchupBonus] for every line: the
  /// value at which the pace duel, the passers' relief and the pressers'
  /// engine all read zero (and what [_lineAttr] returns for an empty line).
  /// The skip path has no players to measure, so the plans alone speak.
  static const double kNeutralLineAttribute = 55;

  /// What [plan] in [formation] is worth against [opponent] in
  /// [opponentFormation], for a match played out by `RatingMatchSimulator`
  /// (the manager's skipped matches): a rating delta for his side's single
  /// strength number, and how open the game is, as a multiplier on both
  /// sides' expected goals.
  ///
  /// It is the engine's own arithmetic, nothing restated:
  ///  * the FLAT terms ([planRatingDelta]'s) for both sides. In the engine
  ///    both sides' sliders and shapes move their own attack and defence; the
  ///    simulator's opponent strength carries none of that, so his side is
  ///    credited the difference.
  ///  * the MATCH-UP, [matchupBonus] both ways round at neutral attributes:
  ///    what his plan finds against theirs lifts his attack, what theirs finds
  ///    against his lifts theirs.
  ///
  /// That gives his side an attack lift and a defence lift, which the
  /// simulator cannot hold apart. Their MEAN is the rating delta; their
  /// DIFFERENCE is how much the plan opens the game (attack bought with
  /// defence puts goals in at both ends), so it goes into the openness on the
  /// simulator's own scale: a strength shift of x moves one side's xG by
  /// `exp(gapResponse * x)` and the other's by the inverse, so adding
  /// `exp(gapResponse * (attack - defence) / 2)` on both lands each side on
  /// exactly the xG its own lift alone would give it. On top of that sits
  /// [openness] itself, which the engine applies to both chance rates.
  ///
  /// Engine points are converted with [_skipPoints] first: the engine's goals
  /// answer a rating point less than the simulator's do, and not linearly.
  /// `test/unit/match/skip_parity_test.dart` holds the two paths to the same
  /// story.
  static ({double ratingDelta, double openness}) planEffect({
    required TacticalInstructions plan,
    required Formation formation,
    required TacticalInstructions opponent,
    required Formation opponentFormation,
  }) {
    double matchup(
      TacticalInstructions atk,
      TacticalInstructions def,
      Formation defFormation,
    ) => matchupBonus(
      attacker: atk,
      defender: def,
      backLine: ShapeProfile.ofFormation(defFormation).defenders,
      fwdPace: kNeutralLineAttribute,
      defPace: kNeutralLineAttribute,
      midPass: kNeutralLineAttribute,
      pressEngine: kNeutralLineAttribute,
    );
    final mine = _planTerms(plan, formation);
    final theirs = _planTerms(opponent, opponentFormation);
    final attack = _skipPoints(
      mine.attack - theirs.defence + matchup(plan, opponent, opponentFormation),
    );
    final defence = _skipPoints(
      mine.defence - theirs.attack - matchup(opponent, plan, formation),
    );
    final spread = exp(
      RatingMatchSimulator.gapResponse * (attack - defence) / 2,
    );
    return (
      ratingDelta: (attack + defence) / 2,
      openness:
          openness(
            home: plan,
            away: opponent,
            homeAttackers: ShapeProfile.ofFormation(formation).attackers,
            awayAttackers: ShapeProfile.ofFormation(
              opponentFormation,
            ).attackers,
          ) *
          spread,
    );
  }

  /// [enginePoints] of attack (or defence) lift as `RatingMatchSimulator`
  /// strength points.
  ///
  /// The engine's goals grow about as `(rating - 26)^1.45`: the chance rate
  /// to the 1.2 in [_chance] and the conversion to the 0.25 in
  /// [_goalProbability], both over [_ratio]'s replacement baseline. So a lift
  /// moves ln(goals) by `1.45 * ln(1 + points / headroom)`, which is CONCAVE:
  /// a big attacking lift earns less than its points, a big defensive hole
  /// costs more. The simulator moves ln(xG) by
  /// [RatingMatchSimulator.gapResponse] per point, so dividing by that lands
  /// the same goals on its scale. The floor mirrors [_ratio]'s 8-point floor.
  static double _skipPoints(double enginePoints) {
    final ratio = (1 + enginePoints / kSkipHeadroom).clamp(
      8 / kSkipHeadroom,
      double.infinity,
    );
    return _skipGoalExponent * log(ratio) / RatingMatchSimulator.gapResponse;
  }

  /// The chance-rate and conversion exponents of [_chance] and
  /// [_goalProbability], summed: how goals scale with the attack-to-defence
  /// ratio in the engine.
  static const double _skipGoalExponent = 1.2 + 0.25;

  /// A typical side's rating above [_ratio]'s replacement baseline of 26, the
  /// level [_skipPoints] reads its curve at: the skip path has one strength
  /// per side and no lines to measure. Raised 50 -> 65 on 2026-10-16 with the
  /// retuned plan terms: at 50 the curve was concave enough that a skipped
  /// bus lost 3pp more of its win rate than a played one; at 65 every lab
  /// plan's skipped effect is within 2pp of its played effect, at 75 and at
  /// 65 rated squads (`skip_parity_test.dart`). Its meaning is a fit, not a
  /// squad level: the engine's in-match scoreline effects have no skip
  /// counterpart, and this absorbs them.
  static const double kSkipHeadroom = 65;

  double _attack(_Live t) {
    final i = t.instructions;
    final base =
        _mean(t, PositionCategory.forward) * 0.55 +
        _mean(t, PositionCategory.midfielder) * 0.30 +
        _mean(t, PositionCategory.defender) * 0.15;
    // Attacking mentality, a quick tempo and a high defensive line (winning the
    // ball higher) lift the attacking threat. Since 2026-10-16 these flat
    // terms are deliberately modest (see [kMentalityAttack]): what mentality
    // mostly does now is open the game at BOTH ends ([openness]), so going
    // forward is visible in the scoreline rather than a quiet rating edge.
    //
    // Directness and width carry NO flat bonus here — their value is entirely
    // situational, decided by the match-up against the opponent's shape (see
    // [_matchup]), so a plan can be strong or weak depending on who it meets.
    final v =
        base +
        (i.mentality - 50) * kMentalityAttack +
        (i.tempo - 50) * kTempoAttack +
        (i.defensiveLine - 50) * kLineAttack +
        (t.shape.attackers - ShapeProfile.neutralAttackers) * kShapeAttack -
        (t.shape.defenders - ShapeProfile.neutralDefenders) *
            kShapeDefenceCost -
        _shortHandedPenalty(t);
    return v * t.chemistry;
  }

  double _defence(_Live t) {
    final i = t.instructions;
    final base =
        _mean(t, PositionCategory.defender) * 0.55 +
        _mean(t, PositionCategory.goalkeeper) * 0.25 +
        _mean(t, PositionCategory.midfielder) * 0.20;
    // Attacking mentality, a high line (space in behind) and a stretched, wide
    // shape all leave the defence more exposed. The line and width were
    // doubled here alongside their attacking counterparts, so the bargain each
    // slider offers keeps its shape: a high line is worth more going forward
    // AND costs more at the back, rather than quietly becoming a free lunch.
    // (Until 2026-10-16 the line was ADDED here, so it was exactly that free
    // lunch; see [kLineDefence].) Pressing has no flat term: see [_matchup].
    final v =
        base -
        (i.mentality - 50) * kMentalityDefence -
        (i.defensiveLine - 50) * kLineDefence -
        (i.width - 50) * kWidthDefence +
        (t.shape.defenders - ShapeProfile.neutralDefenders) * kShapeDefence -
        (t.shape.attackers - ShapeProfile.neutralAttackers) * kShapeAttackCost -
        _shortHandedPenalty(t) * _shortHandedDefenceShare;
    return v * t.chemistry;
  }

  /// Mean *effective* rating of the players assigned to a line, bucketed by the
  /// slot they are fielded in (not their natural position). A player out of
  /// position still counts toward the line they play in, but at a reduced
  /// rating — so an emergency centre-back is a weak defender, not a hole.
  double _mean(_Live t, PositionCategory category) {
    final values = <double>[];
    final n = t.xi.length;
    for (var i = 0; i < n; i++) {
      final slot = i < t.slots.length ? t.slots[i] : t.xi[i].position;
      if (slot.category != category) continue;
      final p = t.xi[i];
      // Condition (form, fatigue, morale) shifts the rating the ENGINE works
      // with; the player's displayed overall never moves. Traits shift it too:
      // a big-game player is worth more on the biggest night, and a leader
      // lifts everyone ELSE around them.
      var shift = (t.team.conditionByPlayer[p.id] ?? 0) + t.team.ratingBonus;
      if (t.bigMatch && t.team.hasTrait(p.id, PlayerTrait.bigGame)) {
        shift += PlayerTraits.bigGameBonus;
      }
      if (t.hasLeaderOtherThan(p.id)) shift += PlayerTraits.leaderTeamBonus;
      final rated = (p.overall + shift).clamp(1, 99);
      values.add(
        rated *
            PositionFit.factor(p.position, slot) *
            _energyFactor(t.energyOf(p.id)),
      );
    }
    if (values.isEmpty) return 55;
    return values.reduce((a, b) => a + b) / values.length;
  }

  /// A shooter's trait multiplier on an open-play finish: a wasteful forward
  /// puts good chances wide. Neutral (1.0) for everyone else.
  double _finishTrait(_Live t, int playerId) =>
      t.team.hasTrait(playerId, PlayerTrait.wasteful)
      ? PlayerTraits.wastefulFinishFactor
      : 1.0;

  /// How energy scales a player's effective rating.
  ///
  /// Deliberately a KINKED curve, not a straight line. A flat slope made
  /// fatigue something you could ignore: a spent player was still worth ~90% of
  /// himself, so there was never a moment where leaving him on visibly cost you
  /// the game. Now the first quarter of the tank is nearly free (a fit player
  /// coasts through the first hour), and everything below ~72% falls away
  /// steeply — a genuinely gassed man plays at barely half his rating, and
  /// taking him off is the obvious call rather than a marginal one.
  static double _energyFactor(double energy) {
    final e = (energy / 100).clamp(0.0, 1.0);
    if (e >= 0.72) return 1.0 - (1.0 - e) * 0.18; // 1.00 → 0.95
    return 0.95 - (0.72 - e) * 0.62; // 0.95 → ~0.51 when empty
  }

  /// How fatigue dulls an INDIVIDUAL'S finishing: a fresh player converts at
  /// full quality, a spent one underperforms the chance (its xG stays, the goal
  /// doesn't). This is the late-game "he should have buried that" when the legs
  /// have gone — on top of the team-level [_energyFactor] fade.
  static double _finishingSharpness(double energy) =>
      (0.74 + 0.26 * (energy / 100)).clamp(0.74, 1.0);

  /// Drains one minute of energy from everyone on the pitch. Higher-[stamina]
  /// players last longer, a high tempo / heavy press tires a team faster, older
  /// legs fade quicker, and a goalkeeper barely tires — so fatigue isn't a flat
  /// curve for the whole XI.
  void _deplete(_Live t) {
    final i = t.instructions;
    // A man down means the ten who are left cover the missing man's ground, so
    // a sending-off also burns the side out faster.
    final shortHanded = 1 + 0.30 * t.sentOff.length;
    // Pressing's share was /250, then /150 in the 2026-10-16 build (Task 4)
    // to make the press cost legs, and settled at /200 in its tuning: at /150
    // the drain alone ate most of what a press wins, so the textbook
    // counter-plan (which presses) read 0.2 of a goal instead of 0.33. A full
    // press still ends a match about 7 points of energy down on a neutral one
    // (`tactics_tradeoffs_test.dart`).
    final workload =
        (1 + (i.tempo - 50) / 250 + (i.pressing - 50) / 200) * shortHanded;
    for (final p in t.xi) {
      if (t.sentOff.contains(p.id)) continue;
      final stamina = p.attributes.stamina.clamp(20, 99);
      final base = p.position.category == PositionCategory.goalkeeper
          ? 0.12
          : 0.62;
      // Age: legs over 30 tire progressively faster (up to ~+30% at 37), the
      // under-24s a touch fresher — so an ageing star needs managing.
      final ageFactor = (1 + (p.age - 28) * 0.04).clamp(0.9, 1.35);
      final ironMan = t.team.hasTrait(p.id, PlayerTrait.ironMan)
          ? PlayerTraits.ironManStaminaFactor
          : 1.0;
      final drain =
          base *
          workload *
          (1.4 - stamina / 100) *
          ageFactor *
          ironMan *
          t.conditionsDrain;
      t.energy[p.id] = (t.energyOf(p.id) - drain).clamp(0.0, 100.0);
    }
  }
}
