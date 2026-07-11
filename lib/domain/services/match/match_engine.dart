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

/// The kind of thing that happened in a match. (Goals and substitutions for
/// now; cards and injuries can be layered on later.)
enum MatchEventType { goal, substitution }

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

  /// Midfield control, used to estimate possession.
  double _control(_Live t) =>
      _mean(t, PositionCategory.midfielder) +
      (t.instructions.tempo - 50) * 0.05;

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
    final base =
        _mean(t, PositionCategory.forward) * 0.55 +
        _mean(t, PositionCategory.midfielder) * 0.30 +
        _mean(t, PositionCategory.defender) * 0.15;
    return base +
        (t.instructions.mentality - 50) * 0.12 +
        (t.instructions.tempo - 50) * 0.04;
  }

  double _defence(_Live t) {
    final base =
        _mean(t, PositionCategory.defender) * 0.55 +
        _mean(t, PositionCategory.goalkeeper) * 0.25 +
        _mean(t, PositionCategory.midfielder) * 0.20;
    return base -
        (t.instructions.mentality - 50) * 0.08 +
        (t.instructions.pressing - 50) * 0.03;
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
