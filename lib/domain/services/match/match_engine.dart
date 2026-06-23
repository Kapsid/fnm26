import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';

/// A team as it lines up for a match: its starting XI and instructions.
class MatchTeam {
  const MatchTeam({
    required this.nationId,
    required this.xi,
    required this.instructions,
  });

  final int nationId;
  final List<Player> xi;
  final TacticalInstructions instructions;
}

/// The kind of thing that happened in a match. (Goals only for now; cards and
/// injuries can be layered on later.)
enum MatchEventType { goal }

/// A timed match event.
class MatchEvent {
  const MatchEvent({
    required this.minute,
    required this.type,
    required this.teamNationId,
    required this.playerId,
    required this.playerName,
  });

  final int minute;
  final MatchEventType type;
  final int teamNationId;
  final int playerId;
  final String playerName;
}

/// The outcome of a simulated match.
class MatchResult {
  const MatchResult({
    required this.homeScore,
    required this.awayScore,
    required this.events,
  });

  final int homeScore;
  final int awayScore;
  final List<MatchEvent> events;
}

/// A deterministic, lightweight tactical match engine. It derives attack and
/// defence ratings from each team's XI and instructions, then plays out 90
/// minute-ticks: each tick either side may create a chance and score, with the
/// scorer chosen by finishing ability. Same teams + same [SeededRng] → same
/// match (replay-safe and testable).
class MatchEngine {
  const MatchEngine();

  MatchResult play({
    required MatchTeam home,
    required MatchTeam away,
    required SeededRng rng,
  }) {
    final homeAttack = _attack(home) + 3; // home advantage
    final homeDefence = _defence(home) + 2;
    final awayAttack = _attack(away);
    final awayDefence = _defence(away);

    final events = <MatchEvent>[];
    var homeScore = 0;
    var awayScore = 0;

    for (var minute = 1; minute <= 90; minute++) {
      if (_chance(rng, homeAttack, awayDefence, home.instructions)) {
        if (rng.chance(_goalProbability(homeAttack, awayDefence))) {
          homeScore++;
          events.add(_goal(minute, home, rng));
        }
      }
      if (_chance(rng, awayAttack, homeDefence, away.instructions)) {
        if (rng.chance(_goalProbability(awayAttack, homeDefence))) {
          awayScore++;
          events.add(_goal(minute, away, rng));
        }
      }
    }

    events.sort((a, b) => a.minute.compareTo(b.minute));
    return MatchResult(
      homeScore: homeScore,
      awayScore: awayScore,
      events: events,
    );
  }

  bool _chance(
    SeededRng rng,
    double attack,
    double oppDefence,
    TacticalInstructions instr,
  ) {
    final ratio = attack / (oppDefence <= 0 ? 1 : oppDefence);
    final rate = (0.085 * ratio * (0.85 + instr.tempo / 333)).clamp(0.02, 0.25);
    return rng.chance(rate);
  }

  double _goalProbability(double attack, double oppDefence) =>
      (0.28 * attack / (oppDefence <= 0 ? 1 : oppDefence)).clamp(0.08, 0.6);

  MatchEvent _goal(int minute, MatchTeam team, SeededRng rng) {
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
  Player _pickScorer(MatchTeam team, SeededRng rng) {
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

  double _attack(MatchTeam t) {
    final base =
        _mean(t.xi, PositionCategory.forward) * 0.55 +
        _mean(t.xi, PositionCategory.midfielder) * 0.30 +
        _mean(t.xi, PositionCategory.defender) * 0.15;
    return base +
        (t.instructions.mentality - 50) * 0.12 +
        (t.instructions.tempo - 50) * 0.04;
  }

  double _defence(MatchTeam t) {
    final base =
        _mean(t.xi, PositionCategory.defender) * 0.55 +
        _mean(t.xi, PositionCategory.goalkeeper) * 0.25 +
        _mean(t.xi, PositionCategory.midfielder) * 0.20;
    return base -
        (t.instructions.mentality - 50) * 0.08 +
        (t.instructions.pressing - 50) * 0.03;
  }

  double _mean(List<Player> xi, PositionCategory category) {
    final ratings = xi
        .where((p) => p.category == category)
        .map((p) => p.overall)
        .toList();
    if (ratings.isEmpty) return 55;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }
}
