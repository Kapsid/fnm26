import 'dart:math';

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';

/// A team as it lines up for a match: its starting XI and instructions.
class MatchTeam {
  const MatchTeam({
    required this.nationId,
    required this.xi,
    required this.instructions,
    this.formation = Formation.f433,
  });

  final int nationId;
  final List<Player> xi;
  final TacticalInstructions instructions;

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
  });

  final int minute;
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
}

/// A single player's performance mark for one match (`3.0`–`10.0`), derived
/// from goals, assists, the result, clean sheets, and cards.
class PlayerRating {
  const PlayerRating({
    required this.playerId,
    required this.playerName,
    required this.teamNationId,
    required this.rating,
  });

  final int playerId;
  final String playerName;
  final int teamNationId;
  final double rating;
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
    this.ratings = const [],
  });

  final int homeScore;
  final int awayScore;
  final List<MatchEvent> events;
  final int homeShots;
  final int awayShots;

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

  /// The team's current instructions, changeable live during the match.
  TacticalInstructions instructions;

  /// Players sent off — they can never return, even if a later live change
  /// names them in the XI.
  final Set<int> sentOff = {};

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
  MatchResult play({
    required MatchTeam home,
    required MatchTeam away,
    required SeededRng rng,
    List<Substitution> subs = const [],
    List<TacticalChange> changes = const [],
    Map<int, double> injuryFactorByNation = const {},
  }) {
    final liveHome = _Live(home);
    final liveAway = _Live(away);

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
    var homeScore = 0;
    var awayScore = 0;
    var homeShots = 0;
    var awayShots = 0;

    for (var minute = 1; minute <= 90; minute++) {
      for (final s in byMinute[minute] ?? const <Substitution>[]) {
        final live = s.teamNationId == liveHome.nationId ? liveHome : liveAway;
        final event = _applySub(live, s, minute);
        if (event != null) {
          events.add(event);
          appeared[s.on.id] = s.on;
        }
      }
      for (final c in changesByMinute[minute] ?? const <TacticalChange>[]) {
        final live = c.teamNationId == liveHome.nationId ? liveHome : liveAway;
        _applyChange(live, c, minute, events);
        for (final p in c.xi) {
          appeared[p.id] = p;
        }
      }

      final homeAttack = _attack(liveHome) + 3; // home advantage
      final homeDefence = _defence(liveHome) + 2;
      final awayAttack = _attack(liveAway);
      final awayDefence = _defence(liveAway);

      if (_chance(rng, homeAttack, awayDefence, liveHome.instructions)) {
        homeShots++;
        if (rng.chance(_goalProbability(homeAttack, awayDefence))) {
          homeScore++;
          events.add(_goal(minute, liveHome, rng, assistRng));
        }
      }
      if (_chance(rng, awayAttack, homeDefence, liveAway.instructions)) {
        awayShots++;
        if (rng.chance(_goalProbability(awayAttack, homeDefence))) {
          awayScore++;
          events.add(_goal(minute, liveAway, rng, assistRng));
        }
      }

      _discipline(
        liveHome,
        minute,
        rng,
        events,
        booked,
        injuryFactorByNation[liveHome.nationId] ?? 1.0,
      );
      _discipline(
        liveAway,
        minute,
        rng,
        events,
        booked,
        injuryFactorByNation[liveAway.nationId] ?? 1.0,
      );
    }

    final homeControl = _control(liveHome);
    final awayControl = _control(liveAway);
    final homePossession = (100 * homeControl / (homeControl + awayControl))
        .round();

    events.sort((a, b) => a.minute.compareTo(b.minute));
    return MatchResult(
      homeScore: homeScore,
      awayScore: awayScore,
      events: events,
      homeShots: homeShots,
      awayShots: awayShots,
      homePossession: homePossession,
      ratings: _rate(
        appeared.values,
        events,
        homeNationId: home.nationId,
        homeScore: homeScore,
        awayScore: awayScore,
      ),
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
    double injuryFactor,
  ) {
    if (live.xi.isEmpty) return;

    if (rng.chance(_yellowPerMinute)) {
      final culprit = _pickCulprit(live, rng);
      if (booked.contains(culprit.id)) {
        events.add(_card(minute, live, culprit, MatchEventType.redCard));
        _leaveField(live, culprit.id);
      } else {
        booked.add(culprit.id);
        events.add(_card(minute, live, culprit, MatchEventType.yellowCard));
      }
    } else if (rng.chance(_straightRedPerMinute)) {
      final culprit = _pickCulprit(live, rng);
      events.add(_card(minute, live, culprit, MatchEventType.redCard));
      _leaveField(live, culprit.id);
    }

    if (live.xi.isNotEmpty && rng.chance(_injuryPerMinute * injuryFactor)) {
      final hurt = _pickCulprit(live, rng);
      events.add(_card(minute, live, hurt, MatchEventType.injury));
      // A hurt player leaves the pitch, exactly as a sent-off one does. Only
      // the event used to be emitted, so he played the rest of the match at
      // full strength: the "injury" cost nothing until the *next* game, and
      // declining the substitution was free.
      //
      // The side plays a man down from here unless someone is brought on.
      _leaveField(live, hurt.id);
    }
  }

  MatchEvent _card(int minute, _Live live, Player p, MatchEventType type) =>
      MatchEvent(
        minute: minute,
        type: type,
        teamNationId: live.nationId,
        playerId: p.id,
        playerName: p.name,
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

  /// Picks the player at fault for a foul or knock, weighting harder-working
  /// defensive players (who make more challenges) and the less composed.
  Player _pickCulprit(_Live live, SeededRng rng) {
    double weight(Player p) {
      final positional = switch (p.category) {
        PositionCategory.defender => 3.0,
        PositionCategory.midfielder => 2.2,
        PositionCategory.forward => 1.2,
        PositionCategory.goalkeeper => 0.3,
      };
      return positional * (1.3 - p.attributes.composure / 100).clamp(0.4, 1.3);
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
  ) {
    // The same strength edge feeds shot creation and conversion below.
    final ratio = _edge(attack, oppDefence);
    final rate = (0.078 * ratio * (0.85 + instr.tempo / 333))
        .clamp(0.015, 0.21);
    return rng.chance(rate);
  }

  double _goalProbability(double attack, double oppDefence) =>
      (0.20 * _edge(attack, oppDefence)).clamp(0.05, 0.48);

  /// The attacking edge as a *lightly* compressed strength ratio. The exponent
  /// (below 1) still pulls extreme mismatches back so scorelines stay
  /// believable, but it keeps far more of a favourite's advantage than the old
  /// square root did — so the better side wins more reliably while upsets are
  /// still possible (a two-to-one strength gap becomes ~1.8×, not ~1.4×).
  double _edge(double attack, double oppDefence) =>
      pow(attack / (oppDefence <= 0 ? 1 : oppDefence), 0.95).toDouble();

  MatchEvent _goal(int minute, _Live team, SeededRng rng, SeededRng assistRng) {
    // Pick the open-play scorer first (always consumes the main RNG so the
    // scoreline stays identical); the penalty branch decides on the separate
    // assist stream, so whether a goal is a spot-kick never shifts the score.
    final scorer = _pickScorer(team, rng);
    if (assistRng.chance(0.09)) {
      final taker = _penaltyTaker(team);
      return MatchEvent(
        minute: minute,
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
      return p.attributes.passing + positional;
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
      return p.attributes.shooting + positional;
    }

    final total = candidates.fold<double>(0, (sum, p) => sum + weight(p));
    var roll = rng.nextDouble() * total;
    for (final p in candidates) {
      roll -= weight(p);
      if (roll <= 0) return p;
    }
    return candidates.last;
  }

  /// The penalty for playing short-handed — a mean of the remaining line barely
  /// moves when a body is lost, so each sending-off knocks ~14% off the team's
  /// whole effectiveness (both attack and defence) for the rest of the match.
  double _numbers(_Live t) => (1 - 0.14 * t.sentOff.length).clamp(0.45, 1.0);

  double _attack(_Live t) {
    final i = t.instructions;
    final base =
        _mean(t, PositionCategory.forward) * 0.55 +
        _mean(t, PositionCategory.midfielder) * 0.30 +
        _mean(t, PositionCategory.defender) * 0.15;
    // Attacking mentality, a quick tempo, a high defensive line (winning the
    // ball higher) and direct play all lift the attacking threat.
    final v = base +
        (i.mentality - 50) * 0.12 +
        (i.tempo - 50) * 0.04 +
        (i.defensiveLine - 50) * 0.05 +
        (i.directness - 50) * 0.04 +
        (i.width - 50) * 0.02;
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
      values.add(t.xi[i].overall * PositionFit.factor(t.xi[i].position, slot));
    }
    if (values.isEmpty) return 55;
    return values.reduce((a, b) => a + b) / values.length;
  }
}
