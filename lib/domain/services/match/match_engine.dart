import 'dart:math';

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';

/// A team as it lines up for a match: its starting XI and instructions.
class MatchTeam {
  const MatchTeam({
    required this.nationId,
    required this.xi,
    required this.instructions,
    this.formation = Formation.f433,
    this.roles = const {},
  });

  final int nationId;
  final List<Player> xi;
  final TacticalInstructions instructions;

  /// Per-player tactical roles, keyed by player id (absent = [PlayerRole.none]).
  /// Shapes who scores/creates and the set-piece threat; never raw strength.
  final Map<int, PlayerRole> roles;

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
  });

  final int teamNationId;
  final int minute;
  final Formation formation;
  final TacticalInstructions instructions;
  final List<Player> xi;
}

/// The tone a manager strikes in a team talk (at the interval). Each tone shifts
/// the side's attacking and defensive edge for the rest of the match — a lift
/// when it fits the game state, a smaller or riskier one when it doesn't.
enum TeamTalkTone { calm, encourage, demandMore, praise }

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
  });

  final int homeScore;
  final int awayScore;
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
  /// the live "xG race" line. Empty when not recorded.
  final List<double> homeXgByMinute;
  final List<double> awayXgByMinute;

  /// Each participating player's remaining energy (0–100) at the final whistle,
  /// keyed by player id — fresh subs stay high, a 90-minute man is spent.
  final Map<int, int> energyByPlayer;

  /// Home possession 0–100; away is `100 - homePossession`.
  final int homePossession;

  /// A performance mark for every player who took part, both teams.
  final List<PlayerRating> ratings;

  int get awayPossession => 100 - homePossession;

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
        instructions = team.instructions;

  final MatchTeam team;

  /// The players on the pitch right now (reassigned wholesale by a live
  /// tactical change; individual slots are edited by subs and sendings-off).
  List<Player> xi;

  /// The position each XI slot is meant to be — `xi[i]` occupies `slots[i]`.
  /// Stable across substitutions (a sub inherits the slot of the player they
  /// replace) and reset by a live change that reshapes the team.
  List<PlayerPosition> slots;

  /// The team's current instructions, changeable live during the match. For an
  /// AI-managed side this is recomputed each minute from [team] instructions by
  /// the score and clock (a trailing team commits forward, a leading one sits).
  TacticalInstructions instructions;

  /// A rating swing from the last team talk, added to the side's attack /
  /// defence for the rest of the match (0 until the manager gives a talk).
  double talkAttack = 0;
  double talkDefence = 0;

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

/// A deterministic, lightweight tactical match engine. It derives attack and
/// defence ratings from each team's XI and instructions, then plays out 90
/// minute-ticks: each tick either side may create a chance and score, with the
/// scorer chosen by finishing ability. Substitutions take effect from their
/// minute onward, changing the on-pitch XI and therefore the ratings for the
/// rest of the match. Same teams + same subs + same [SeededRng] → same match
/// (replay-safe and testable).
class MatchEngine {
  const MatchEngine();

  /// Per-team, per-minute booking probability (~1.8 yellows a team a game).
  static const double _yellowPerMinute = 0.020;

  /// Per-team, per-minute probability of a straight red (~1 in 20 games).
  static const double _straightRedPerMinute = 0.0006;

  /// Per-team, per-minute probability of a player picking up a knock.
  static const double _injuryPerMinute = 0.0016;

  /// [injuryFactorByNation] scales a team's per-minute injury rate (1.0 = base;
  /// below 1.0 = a nation's medical/sports-science investment keeping players
  /// fit). Absent nations use the base rate. It only affects knock frequency,
  /// not the scoreline or discipline RNG.
  /// [neutralVenue] plays the match on neutral ground (a finals tournament),
  /// where NO side gets a home crowd — except [venueHostId], the tournament's
  /// host nation, who keeps the advantage when they're one of the two teams.
  /// Left as the default (`false`), the [home] team enjoys home advantage as in
  /// a qualifier or friendly.
  /// [talks] are timed team talks that shift a side's edge for the rest of the
  /// match. [aiManagedNationIds] name the sides whose instructions the engine
  /// reactively manages by the scoreline and clock (typically the human's AI
  /// opponent) — a trailing side commits forward late, a leading side protects.
  MatchResult play({
    required MatchTeam home,
    required MatchTeam away,
    required SeededRng rng,
    List<Substitution> subs = const [],
    List<TacticalChange> changes = const [],
    List<TeamTalk> talks = const [],
    Set<int> aiManagedNationIds = const {},
    Map<int, double> injuryFactorByNation = const {},
    bool neutralVenue = false,
    int? venueHostId,
  }) {
    final liveHome = _Live(home);
    final liveAway = _Live(away);
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
    // on their real minute only, never re-applied in added time.
    void playMinute(int manageMinute, int stoppage) {
      if (stoppage == 0) {
        for (final s in byMinute[manageMinute] ?? const <Substitution>[]) {
          final live =
              s.teamNationId == liveHome.nationId ? liveHome : liveAway;
          final event = _applySub(live, s, manageMinute);
          if (event != null) {
            events.add(event);
            appeared[s.on.id] = s.on;
          }
        }
        for (final c
            in changesByMinute[manageMinute] ?? const <TacticalChange>[]) {
          final live =
              c.teamNationId == liveHome.nationId ? liveHome : liveAway;
          _applyChange(live, c, manageMinute, events);
          for (final p in c.xi) {
            appeared[p.id] = p;
          }
        }
        for (final t in talksByMinute[manageMinute] ?? const <TeamTalk>[]) {
          final live =
              t.teamNationId == liveHome.nationId ? liveHome : liveAway;
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
            liveHome.team.instructions, homeScore - awayScore, manageMinute);
      }
      if (aiManagedNationIds.contains(liveAway.nationId)) {
        liveAway.instructions = _manage(
            liveAway.team.instructions, awayScore - homeScore, manageMinute);
      }

      // Players tire as the match wears on, weakening the side until fresh legs
      // come on — so a well-timed substitution genuinely helps.
      _deplete(liveHome);
      _deplete(liveAway);

      // Home advantage (+3 attack / +2 defence) goes to the side actually
      // playing at home — nobody at a neutral finals unless it's the host — plus
      // any team-talk swing, plus the tactical MATCH-UP: how each side's plan and
      // its players' attributes fare against the other's (see [_matchup]).
      final homeAttack = _attack(liveHome) +
          (homeAdvantage ? 3 : 0) +
          liveHome.talkAttack +
          _matchup(liveHome, liveAway);
      final homeDefence =
          _defence(liveHome) + (homeAdvantage ? 2 : 0) + liveHome.talkDefence;
      final awayAttack = _attack(liveAway) +
          (awayAdvantage ? 3 : 0) +
          liveAway.talkAttack +
          _matchup(liveAway, liveHome);
      final awayDefence =
          _defence(liveAway) + (awayAdvantage ? 2 : 0) + liveAway.talkDefence;

      // Possession share: the side that keeps the ball more creates a little
      // more and lets the other have less — so a patient, passing side is
      // rewarded for controlling the game, not just its raw ratings.
      final homeControl = _control(liveHome);
      final awayControl = _control(liveAway);
      final controlTotal = homeControl + awayControl;
      final homeShare = controlTotal <= 0 ? 0.5 : homeControl / controlTotal;

      if (_chance(rng, homeAttack, awayDefence, liveHome.instructions,
          homeShare)) {
        homeShots++;
        // The player taking the shot is chosen now, so their fatigue can affect
        // the finish — a spent striker underperforms the chance.
        final shooter = _pickScorer(liveHome, rng);
        final baseP = _goalProbability(homeAttack, awayDefence);
        homeXg += baseP; // xG is the CHANCE quality, before the finish
        final p = (baseP * _finishingSharpness(liveHome.energyOf(shooter.id)))
            .clamp(0.05, 0.48);
        if (rng.chance(p)) {
          homeScore++;
          events.add(_goal(manageMinute, liveHome, shooter, assistRng,
              stoppage: stoppage));
        }
      }
      if (_chance(rng, awayAttack, homeDefence, liveAway.instructions,
          1 - homeShare)) {
        awayShots++;
        final shooter = _pickScorer(liveAway, rng);
        final baseP = _goalProbability(awayAttack, homeDefence);
        awayXg += baseP;
        final p = (baseP * _finishingSharpness(liveAway.energyOf(shooter.id)))
            .clamp(0.05, 0.48);
        if (rng.chance(p)) {
          awayScore++;
          events.add(_goal(manageMinute, liveAway, shooter, assistRng,
              stoppage: stoppage));
        }
      }

      // Set pieces — a third, additive channel on its own RNG stream. Corners /
      // free-kicks reward aerial strength and a good delivery, so a physical,
      // set-piece-strong side scores goals open play alone wouldn't give it.
      final homeSp = _setPiece(liveHome, liveAway, manageMinute, setPieceRng,
          stoppage: stoppage);
      if (homeSp.shot) homeShots++;
      homeXg += homeSp.xg;
      if (homeSp.goal != null) {
        homeScore++;
        events.add(homeSp.goal!);
      }
      final awaySp = _setPiece(liveAway, liveHome, manageMinute, setPieceRng,
          stoppage: stoppage);
      if (awaySp.shot) awayShots++;
      awayXg += awaySp.xg;
      if (awaySp.goal != null) {
        awayScore++;
        events.add(awaySp.goal!);
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
    for (var minute = 1; minute <= 90; minute++) {
      playMinute(minute, 0);
      homeXgByMinute.add(homeXg);
      awayXgByMinute.add(awayXg);
    }
    // Second-half stoppage time ("90+X"): a deterministic few added minutes,
    // longer the more the match was interrupted (goals, subs, cards, knocks), in
    // which the same chance/discipline logic keeps running — so a winner can be
    // snatched in added time, and the clock reads 90+1, 90+2, …
    final stoppageMinutes = (1 + events.length * 0.35).round().clamp(1, 8);
    for (var s = 1; s <= stoppageMinutes; s++) {
      playMinute(90, s);
    }
    // Fold stoppage-time xG onto the final (90') point of the series.
    homeXgByMinute[homeXgByMinute.length - 1] = homeXg;
    awayXgByMinute[awayXgByMinute.length - 1] = awayXg;

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
      homeScore: homeScore,
      awayScore: awayScore,
      events: events,
      homeShots: homeShots,
      awayShots: awayShots,
      homeXg: homeXg,
      awayXg: awayXg,
      homeXgByMinute: homeXgByMinute,
      awayXgByMinute: awayXgByMinute,
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

  double _mark(
    Player p, {
    required int goals,
    required int assists,
    required bool booked,
    required bool sentOff,
    required int teamScore,
    required int oppScore,
  }) {
    var r = 6.5;
    r += goals * 1.0 + assists * 0.6;
    if (teamScore > oppScore) {
      r += 0.4;
    } else if (teamScore < oppScore) {
      r -= 0.3;
    }
    final defensive = p.category == PositionCategory.defender ||
        p.category == PositionCategory.goalkeeper;
    if (defensive) {
      r += oppScore == 0 ? 0.5 : -0.15 * oppScore;
    }
    if (booked) r -= 0.3;
    if (sentOff) r -= 1.2;
    return (r.clamp(3.0, 10.0) * 10).roundToDouble() / 10;
  }

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
    final positions = c.formation.positions;
    final newXi = <Player>[];
    final newSlots = <PlayerPosition>[];
    for (var i = 0; i < c.xi.length; i++) {
      final p = c.xi[i];
      if (live.sentOff.contains(p.id)) continue;
      newXi.add(p);
      newSlots.add(i < positions.length ? positions[i] : p.position);
    }

    // Timeline: pair each incoming player with a player who dropped off.
    final after = newXi.map((p) => p.id).toSet();
    final incoming = newXi.where((p) => !before.contains(p.id)).toList();
    final offIds = before.difference(after).toList();
    for (var k = 0; k < incoming.length; k++) {
      events.add(MatchEvent(
        minute: minute,
        type: MatchEventType.substitution,
        teamNationId: live.nationId,
        playerId: incoming[k].id,
        playerName: incoming[k].name,
        secondaryName: k < offIds.length ? offNames[offIds[k]] : null,
      ));
    }

    live
      ..xi = newXi
      ..slots = newSlots
      ..instructions = c.instructions;
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
      final culprit = _pickCulprit(live, rng);
      if (booked.contains(culprit.id)) {
        // A second booking — a one-match ban, flagged so discipline doesn't
        // treat it as a violent-conduct straight red.
        events.add(
          _card(minute, live, culprit, MatchEventType.redCard,
              secondYellow: true, stoppage: stoppage),
        );
        _leaveField(live, culprit.id);
      } else {
        booked.add(culprit.id);
        events.add(_card(minute, live, culprit, MatchEventType.yellowCard,
            stoppage: stoppage));
      }
    } else if (rng.chance(_straightRedPerMinute)) {
      final culprit = _pickCulprit(live, rng);
      events.add(_card(minute, live, culprit, MatchEventType.redCard,
          stoppage: stoppage));
      _leaveField(live, culprit.id);
    }

    if (live.xi.isNotEmpty &&
        rng.chance(_injuryPerMinute * injuryFactor * tiredness)) {
      final hurt = _pickCulprit(live, rng);
      events.add(_card(minute, live, hurt, MatchEventType.injury,
          stoppage: stoppage));
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
  }) =>
      MatchEvent(
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
  Player _pickCulprit(_Live live, SeededRng rng) {
    double weight(Player p) {
      final positional = switch (p.category) {
        PositionCategory.defender => 3.0,
        PositionCategory.midfielder => 2.2,
        PositionCategory.forward => 1.2,
        PositionCategory.goalkeeper => 0.3,
      };
      final composure =
          (1.3 - p.attributes.composure / 100).clamp(0.4, 1.3);
      // 1.0 fresh → ~1.6 spent: tired legs are more likely to give it away.
      final fatigue = 1.0 + (100 - live.energyOf(p.id)) / 100 * 0.6;
      return positional * composure * fatigue;
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

  bool _chance(
    SeededRng rng,
    double attack,
    double oppDefence,
    TacticalInstructions instr,
    double controlShare,
  ) {
    // The same strength edge feeds shot creation and conversion below. A quick
    // tempo and, now, a larger share of possession both lift the chance rate —
    // controlling the ball turns into more openings (0.5 share = neutral).
    final ratio = _edge(attack, oppDefence);
    final rate = (0.078 *
            ratio *
            (0.85 + instr.tempo / 333) *
            (0.7 + 0.6 * controlShare))
        .clamp(0.015, 0.21);
    return rng.chance(rate);
  }

  double _goalProbability(double attack, double oppDefence) =>
      (0.20 * _edge(attack, oppDefence)).clamp(0.05, 0.48);

  /// The attacking edge as a strength ratio, *amplified* by an exponent above 1
  /// so a favourite keeps — and slightly magnifies — its advantage. This makes
  /// the better side win more reliably and by bigger margins (upsets still
  /// happen, but they're the exception), matching a more FIFA-like feel where
  /// class usually tells.
  double _edge(double attack, double oppDefence) =>
      pow(attack / (oppDefence <= 0 ? 1 : oppDefence), 1.25).toDouble();

  MatchEvent _goal(int minute, _Live team, Player scorer, SeededRng assistRng,
      {int stoppage = 0}) {
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

  /// The side's penalty taker: the outfield player with the best finishing,
  /// falling back to the first player when a team is somehow empty.
  Player _penaltyTaker(_Live team) {
    final outfield = team.xi
        .where((p) => p.category != PositionCategory.goalkeeper)
        .toList();
    final pool = outfield.isEmpty ? team.xi : outfield;
    if (pool.isEmpty) return team.xi.first;
    return pool.reduce(
      (a, b) => b.attributes.shooting > a.attributes.shooting ? b : a,
    );
  }

  /// Picks the teammate who set up a goal, or null for a solo effort (~30% of
  /// goals). Assists weight creative, attacking players (passing + position),
  /// excluding the scorer and, in practice, the goalkeeper.
  Player? _pickAssister(_Live team, Player scorer, SeededRng rng) {
    if (rng.chance(0.30)) return null; // unassisted
    final candidates =
        team.xi.where((p) => p.id != scorer.id).toList(growable: false);
    if (candidates.isEmpty) return null;

    double weight(Player p) {
      final positional = switch (p.category) {
        PositionCategory.midfielder => 10.0,
        PositionCategory.forward => 8.0,
        PositionCategory.defender => 3.0,
        PositionCategory.goalkeeper => 0.2,
      };
      return (p.attributes.passing + positional) * team.roleOf(p.id).assistWeight;
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

    double weight(Player p) {
      final positional = switch (p.category) {
        PositionCategory.forward => 25.0,
        PositionCategory.midfielder => 8.0,
        _ => 1.0,
      };
      return (p.attributes.shooting + positional) * team.roleOf(p.id).scorerWeight;
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
  }) {
    if (atk.xi.isEmpty || !rng.chance(_setPiecePerMinute)) {
      return (goal: null, xg: 0, shot: false);
    }
    // Aerial duel in the box: the attackers' physicality (and defenders up for
    // it) against the defence and keeper.
    final threat = (_aerialAttack(atk) / _aerialDefence(def)).clamp(0.5, 2.0);
    final p = (0.08 * pow(threat, 1.2)).toDouble().clamp(0.02, 0.26);
    final xg = p; // the chance's quality
    if (!rng.chance(p)) return (goal: null, xg: xg, shot: true);
    final scorer = _pickHeader(atk, rng);
    final taker = _setPieceTaker(atk, scorer);
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
      (_lineAttr(t, PositionCategory.forward, (a) => a.strength) +
              _lineAttr(t, PositionCategory.defender, (a) => a.strength)) /
          2;

  /// The defending side's ability to clear a set piece: its back line and keeper.
  double _aerialDefence(_Live t) =>
      _lineAttr(t, PositionCategory.defender, (a) => a.strength) * 0.7 +
      _lineAttr(t, PositionCategory.goalkeeper, (a) => a.strength) * 0.3;

  /// Picks the set-piece scorer: an outfield player who attacks the ball,
  /// weighted by strength (aerial power), forwards and defenders most likely.
  Player _pickHeader(_Live team, SeededRng rng) {
    final candidates = team.xi
        .where((p) => p.category != PositionCategory.goalkeeper)
        .toList();
    if (candidates.isEmpty) return team.xi.first;
    double weight(Player p) {
      final positional = switch (p.category) {
        PositionCategory.forward => 30.0,
        PositionCategory.defender => 26.0,
        PositionCategory.midfielder => 14.0,
        PositionCategory.goalkeeper => 0.0,
      };
      return (p.attributes.strength + positional) * team.roleOf(p.id).aerialWeight;
    }

    final total = candidates.fold<double>(0, (s, p) => s + weight(p));
    var roll = rng.nextDouble() * total;
    for (final p in candidates) {
      roll -= weight(p);
      if (roll <= 0) return p;
    }
    return candidates.last;
  }

  /// The set-piece taker (credited with the assist): the side's best passer,
  /// excluding the scorer. Null when nobody else is on the pitch.
  Player? _setPieceTaker(_Live team, Player scorer) {
    final pool = team.xi.where((p) => p.id != scorer.id).toList();
    if (pool.isEmpty) return null;
    return pool
        .reduce((a, b) => b.attributes.passing > a.attributes.passing ? b : a);
  }

  /// The penalty for playing short-handed. A mean of the remaining line barely
  /// moves when a body is lost, so a red card is applied here as a heavy blow —
  /// each sending-off knocks ~22% off the team's whole effectiveness (both
  /// attack and defence) for the rest of the match, as playing a man down
  /// really should.
  double _numbers(_Live t) => (1 - 0.22 * t.sentOff.length).clamp(0.35, 1.0);

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
  /// and its players' attributes fare against [def]'s. Three rock-paper-scissors
  /// counters, so a plan beats some setups and loses to others rather than being
  /// universally good:
  ///
  ///  1. DIRECT into a HIGH LINE opens space in behind — but a deep block
  ///     smothers it, and who wins the ball there is a PACE duel between the
  ///     attackers and the back line.
  ///  2. A HIGH PRESS strangles a slow, possession build-up (worse the poorer
  ///     the passers, and only as far as the pressers' STAMINA carries it) — but
  ///     a DIRECT team plays straight through it.
  ///  3. Attacking WIDE against a NARROW defence stretches it (and narrow
  ///     against a wide one overloads the middle).
  double _matchup(_Live atk, _Live def) {
    double n(int v) => (v - 50) / 50.0;
    final a = atk.instructions;
    final d = def.instructions;

    final fwdPace = _lineAttr(atk, PositionCategory.forward, (x) => x.pace);
    final defPace = _lineAttr(def, PositionCategory.defender, (x) => x.pace);
    final midPass =
        _lineAttr(atk, PositionCategory.midfielder, (x) => x.passing);
    final pressEngine =
        _lineAttr(def, PositionCategory.midfielder, (x) => x.stamina);

    var bonus = 0.0;

    // 1) DIRECT play into a high line finds space in behind (deep block smothers
    //    it); who wins that space is a pace duel. Possession play keys off
    //    control instead, so it takes nothing from this term.
    final directAttack = n(a.directness).clamp(0.0, 1.0);
    final paceDuel = ((fwdPace - defPace) / 40).clamp(-1.0, 1.0);
    bonus += directAttack * n(d.defensiveLine) * (3.5 + 2.5 * paceDuel);

    // 2) Press vs build-up, bypassed by directness.
    final press = n(d.pressing).clamp(0.0, 1.0);
    final slow = (-n(a.directness)).clamp(0.0, 1.0); // possession-minded
    final passRelief = ((midPass - 55) / 60).clamp(0.0, 0.6);
    final engine = ((pressEngine - 55) / 45).clamp(-0.4, 1.0);
    bonus -= press * slow * (2.5 + 2.0 * engine) * (1 - passRelief);
    bonus += press * n(a.directness).clamp(0.0, 1.0) * 2.5; // direct beats press

    // 3) Width mismatch.
    bonus += (n(a.width) * -n(d.width)).clamp(0.0, 1.0) * 2.5; // wide vs narrow
    bonus += (-n(a.width) * n(d.width)).clamp(0.0, 1.0) * 2.0; // narrow vs wide

    return bonus.clamp(-8.0, 10.0);
  }

  double _attack(_Live t) {
    final i = t.instructions;
    final base =
        _mean(t, PositionCategory.forward) * 0.55 +
        _mean(t, PositionCategory.midfielder) * 0.30 +
        _mean(t, PositionCategory.defender) * 0.15;
    // Attacking mentality, a quick tempo and a high defensive line (winning the
    // ball higher) lift the attacking threat. Mentality is by far the biggest
    // dial. Directness and width carry NO flat bonus here — their value is
    // entirely situational, decided by the match-up against the opponent's shape
    // (see [_matchup]), so a plan can be strong or weak depending on who it meets.
    final v = base +
        (i.mentality - 50) * 0.20 +
        (i.tempo - 50) * 0.04 +
        (i.defensiveLine - 50) * 0.05;
    return v * _numbers(t);
  }

  double _defence(_Live t) {
    final i = t.instructions;
    final base =
        _mean(t, PositionCategory.defender) * 0.55 +
        _mean(t, PositionCategory.goalkeeper) * 0.25 +
        _mean(t, PositionCategory.midfielder) * 0.20;
    // Attacking mentality, a high line (space in behind) and a stretched, wide
    // shape all leave the defence more exposed; heavy pressing wins it back.
    final v = base -
        (i.mentality - 50) * 0.08 +
        (i.pressing - 50) * 0.03 -
        (i.defensiveLine - 50) * 0.06 -
        (i.width - 50) * 0.03;
    return v * _numbers(t);
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
      values.add(
        p.overall *
            PositionFit.factor(p.position, slot) *
            _energyFactor(t.energyOf(p.id)),
      );
    }
    if (values.isEmpty) return 55;
    return values.reduce((a, b) => a + b) / values.length;
  }

  /// How energy scales a player's effective rating: full at 100, down to ~72%
  /// when spent, so a tired side fades and fresh legs off the bench matter.
  static double _energyFactor(double energy) => 0.72 + 0.28 * (energy / 100);

  /// How fatigue dulls an INDIVIDUAL'S finishing: a fresh player converts at
  /// full quality, a spent one underperforms the chance (its xG stays, the goal
  /// doesn't). This is the late-game "he should have buried that" when the legs
  /// have gone — on top of the team-level [_energyFactor] fade.
  static double _finishingSharpness(double energy) =>
      (0.82 + 0.18 * (energy / 100)).clamp(0.82, 1.0);

  /// Drains one minute of energy from everyone on the pitch. Higher-[stamina]
  /// players last longer, a high tempo / heavy press tires a team faster, older
  /// legs fade quicker, and a goalkeeper barely tires — so fatigue isn't a flat
  /// curve for the whole XI.
  void _deplete(_Live t) {
    final i = t.instructions;
    final workload = 1 + (i.tempo - 50) / 250 + (i.pressing - 50) / 250;
    for (final p in t.xi) {
      if (t.sentOff.contains(p.id)) continue;
      final stamina = p.attributes.stamina.clamp(20, 99);
      final base = p.position.category == PositionCategory.goalkeeper
          ? 0.12
          : 0.50;
      // Age: legs over 30 tire progressively faster (up to ~+30% at 37), the
      // under-24s a touch fresher — so an ageing star needs managing.
      final ageFactor = (1 + (p.age - 28) * 0.04).clamp(0.9, 1.35);
      final drain = base * workload * (1.4 - stamina / 100) * ageFactor;
      t.energy[p.id] = (t.energyOf(p.id) - drain).clamp(0.0, 100.0);
    }
  }
}
