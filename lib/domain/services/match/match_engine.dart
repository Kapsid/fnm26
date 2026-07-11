import 'dart:math';

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';

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

  /// A player picking up a knock. They stay on for the rest of this match but
  /// are sidelined for the games that follow.
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
  });

  final int minute;
  final MatchEventType type;
  final int teamNationId;
  final int playerId;
  final String playerName;

  /// For a substitution, the name of the player going off (the [playerName] is
  /// the player coming on).
  final String? secondaryName;
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
  });

  final int homeScore;
  final int awayScore;
  final List<MatchEvent> events;
  final int homeShots;
  final int awayShots;

  /// Home possession 0–100; away is `100 - homePossession`.
  final int homePossession;

  int get awayPossession => 100 - homePossession;
}

/// Mutable per-team match state: the XI on the pitch right now, which changes
/// as substitutions are applied through the match.
class _Live {
  _Live(this.team)
      : xi = [...team.xi],
        slots = [...team.formation.positions];

  final MatchTeam team;
  final List<Player> xi;

  /// The position each XI slot is meant to be — stable across substitutions
  /// (a sub inherits the slot of the player they replace).
  final List<PlayerPosition> slots;

  int get nationId => team.nationId;
  TacticalInstructions get instructions => team.instructions;
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

  MatchResult play({
    required MatchTeam home,
    required MatchTeam away,
    required SeededRng rng,
    List<Substitution> subs = const [],
  }) {
    final liveHome = _Live(home);
    final liveAway = _Live(away);

    // Substitutions grouped by the minute they happen on, applied in order.
    final byMinute = <int, List<Substitution>>{};
    for (final s in subs) {
      (byMinute[s.minute] ??= []).add(s);
    }

    final events = <MatchEvent>[];
    // Players already on a yellow, so a second booking becomes a red.
    final booked = <int>{};
    var homeScore = 0;
    var awayScore = 0;
    var homeShots = 0;
    var awayShots = 0;

    for (var minute = 1; minute <= 90; minute++) {
      for (final s in byMinute[minute] ?? const <Substitution>[]) {
        final live = s.teamNationId == liveHome.nationId ? liveHome : liveAway;
        final event = _applySub(live, s, minute);
        if (event != null) events.add(event);
      }

      final homeAttack = _attack(liveHome) + 3; // home advantage
      final homeDefence = _defence(liveHome) + 2;
      final awayAttack = _attack(liveAway);
      final awayDefence = _defence(liveAway);

      if (_chance(rng, homeAttack, awayDefence, liveHome.instructions)) {
        homeShots++;
        if (rng.chance(_goalProbability(homeAttack, awayDefence))) {
          homeScore++;
          events.add(_goal(minute, liveHome, rng));
        }
      }
      if (_chance(rng, awayAttack, homeDefence, liveAway.instructions)) {
        awayShots++;
        if (rng.chance(_goalProbability(awayAttack, homeDefence))) {
          awayScore++;
          events.add(_goal(minute, liveAway, rng));
        }
      }

      _discipline(liveHome, minute, rng, events, booked);
      _discipline(liveAway, minute, rng, events, booked);
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
    );
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

  /// Rolls one minute of discipline for [live]: a possible booking (a second
  /// caution becomes a sending-off), a possible straight red, and a possible
  /// knock. A red removes the player from the pitch for the rest of the match.
  void _discipline(
    _Live live,
    int minute,
    SeededRng rng,
    List<MatchEvent> events,
    Set<int> booked,
  ) {
    if (live.xi.isEmpty) return;

    if (rng.chance(_yellowPerMinute)) {
      final culprit = _pickCulprit(live, rng);
      if (booked.contains(culprit.id)) {
        events.add(_card(minute, live, culprit, MatchEventType.redCard));
        _sendOff(live, culprit.id);
      } else {
        booked.add(culprit.id);
        events.add(_card(minute, live, culprit, MatchEventType.yellowCard));
      }
    } else if (rng.chance(_straightRedPerMinute)) {
      final culprit = _pickCulprit(live, rng);
      events.add(_card(minute, live, culprit, MatchEventType.redCard));
      _sendOff(live, culprit.id);
    }

    if (live.xi.isNotEmpty && rng.chance(_injuryPerMinute)) {
      final hurt = _pickCulprit(live, rng);
      events.add(_card(minute, live, hurt, MatchEventType.injury));
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

  /// Removes [playerId] from the pitch, dropping their formation slot too so
  /// the team plays on a man down for the rest of the match.
  void _sendOff(_Live live, int playerId) {
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
    // Compress the strength ratio so mismatches don't compound into blowouts
    // (the same damped ratio also feeds conversion below).
    final ratio = _edge(attack, oppDefence);
    final rate = (0.075 * ratio * (0.85 + instr.tempo / 333)).clamp(0.02, 0.18);
    return rng.chance(rate);
  }

  double _goalProbability(double attack, double oppDefence) =>
      (0.20 * _edge(attack, oppDefence)).clamp(0.07, 0.42);

  /// The attacking edge as a *compressed* strength ratio: the square root pulls
  /// extreme mismatches back toward parity so scorelines stay believable (a
  /// two-to-one strength gap becomes ~1.4×, not 2×).
  double _edge(double attack, double oppDefence) =>
      sqrt(attack / (oppDefence <= 0 ? 1 : oppDefence));

  MatchEvent _goal(int minute, _Live team, SeededRng rng) {
    final scorer = _pickScorer(team, rng);
    return MatchEvent(
      minute: minute,
      type: MatchEventType.goal,
      teamNationId: team.nationId,
      playerId: scorer.id,
      playerName: scorer.name,
    );
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

  double _attack(_Live t) {
    final i = t.instructions;
    final base =
        _mean(t, PositionCategory.forward) * 0.55 +
        _mean(t, PositionCategory.midfielder) * 0.30 +
        _mean(t, PositionCategory.defender) * 0.15;
    // Attacking mentality, a quick tempo, a high defensive line (winning the
    // ball higher) and direct play all lift the attacking threat.
    return base +
        (i.mentality - 50) * 0.12 +
        (i.tempo - 50) * 0.04 +
        (i.defensiveLine - 50) * 0.05 +
        (i.directness - 50) * 0.04 +
        (i.width - 50) * 0.02;
  }

  double _defence(_Live t) {
    final i = t.instructions;
    final base =
        _mean(t, PositionCategory.defender) * 0.55 +
        _mean(t, PositionCategory.goalkeeper) * 0.25 +
        _mean(t, PositionCategory.midfielder) * 0.20;
    // Attacking mentality, a high line (space in behind) and a stretched, wide
    // shape all leave the defence more exposed; heavy pressing wins it back.
    return base -
        (i.mentality - 50) * 0.08 +
        (i.pressing - 50) * 0.03 -
        (i.defensiveLine - 50) * 0.06 -
        (i.width - 50) * 0.03;
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
      values.add(t.xi[i].overall * _positionFactor(t.xi[i].position, slot));
    }
    if (values.isEmpty) return 55;
    return values.reduce((a, b) => a + b) / values.length;
  }

  /// How well a player performs in a given slot: 1.0 at their natural position,
  /// tapering as the slot moves further from it. Same line is barely a dent;
  /// crossing lines (or into/out of goal) hurts progressively more.
  static double _positionFactor(PlayerPosition natural, PlayerPosition slot) {
    if (natural == slot) return 1;
    if (natural.category == slot.category) return 0.96;
    int line(PositionCategory c) => switch (c) {
      PositionCategory.goalkeeper => 0,
      PositionCategory.defender => 1,
      PositionCategory.midfielder => 2,
      PositionCategory.forward => 3,
    };
    final gap = (line(natural.category) - line(slot.category)).abs();
    final involvesKeeper = natural.category == PositionCategory.goalkeeper ||
        slot.category == PositionCategory.goalkeeper;
    if (involvesKeeper) return gap <= 1 ? 0.70 : 0.55;
    return gap <= 1 ? 0.86 : 0.74;
  }
}
