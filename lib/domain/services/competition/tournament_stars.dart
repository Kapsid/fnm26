import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';

/// One player in the Team of the Tournament, with the numbers behind the pick.
class StarPlayer {
  const StarPlayer({
    required this.player,
    required this.goals,
    required this.score,
  });

  final Player player;
  final int goals;
  final double score;

  int get id => player.id;
  int get nationId => player.nationId;
  String get name => player.name;
  PlayerPosition get position => player.position;
  int get overall => player.overall;
}

/// Picks a "Team of the Tournament" — a best XI in a 4-3-3 — from everyone who
/// took part, rewarding scoring, individual quality, and how far the player's
/// nation went (a group-stage star counts for less than a finalist).
///
/// It's a pragmatic blend of the data a finished tournament actually has:
/// persisted goals, the squad's quality (`overall`), and each nation's run.
abstract final class TournamentStars {
  /// The shape of the team: goalkeepers, defenders, midfielders, forwards.
  static const Map<PositionCategory, int> _slots = {
    PositionCategory.goalkeeper: 1,
    PositionCategory.defender: 4,
    PositionCategory.midfielder: 3,
    PositionCategory.forward: 3,
  };

  /// The best XI from [candidates], best-fit first per line.
  ///
  /// [goalsByPlayer] maps a player id to goals scored in the tournament;
  /// [runByNation] maps a nation id to how many knockout rounds it reached
  /// (0 = group stage only); [champion] is the winning nation (a bonus).
  static List<StarPlayer> teamOfTournament({
    required List<Player> candidates,
    required Map<int, int> goalsByPlayer,
    required Map<int, int> runByNation,
    int? champion,
  }) {
    final scored = <StarPlayer>[];
    for (final p in candidates) {
      final goals = goalsByPlayer[p.id] ?? 0;
      final run = runByNation[p.nationId] ?? 0;
      final score = p.overall +
          goals * 6.0 +
          run * 3.0 +
          (p.nationId == champion ? 8.0 : 0.0);
      scored.add(StarPlayer(player: p, goals: goals, score: score));
    }
    scored.sort((a, b) => b.score.compareTo(a.score));

    final remaining = {..._slots};
    final xi = <StarPlayer>[];
    for (final s in scored) {
      final cat = s.position.category;
      final left = remaining[cat] ?? 0;
      if (left <= 0) continue;
      xi.add(s);
      remaining[cat] = left - 1;
      if (remaining.values.every((n) => n == 0)) break;
    }
    return xi;
  }

  /// The tournament's leading scorer (Golden Boot), or null if no goals.
  static StarPlayer? goldenBoot(List<StarPlayer> team) {
    StarPlayer? best;
    for (final s in team) {
      if (s.goals > 0 && (best == null || s.goals > best.goals)) best = s;
    }
    return best;
  }
}
