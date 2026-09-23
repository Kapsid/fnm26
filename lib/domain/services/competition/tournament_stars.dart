import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';

/// How a player actually performed across a tournament.
typedef TournamentForm = ({int apps, double meanRating, int motms});

/// One player in the Team of the Tournament, with the numbers behind the pick.
class StarPlayer {
  const StarPlayer({
    required this.player,
    required this.goals,
    required this.score,
    this.apps = 0,
    this.meanRating = 0,
    this.motms = 0,
  });

  final Player player;
  final int goals;
  final double score;

  /// Appearances in the tournament, and how they were marked. Zero when the
  /// tournament predates per-match ratings.
  final int apps;
  final double meanRating;
  final int motms;

  int get id => player.id;
  int get nationId => player.nationId;
  String get name => player.name;
  PlayerPosition get position => player.position;
  int get overall => player.overall;
}

/// Picks a "Team of the Tournament" — a best XI in a 4-3-3 — from everyone who
/// took part, on how they PLAYED: their match marks first, then goals, then
/// how far their nation went.
///
/// It used to be picked from squad `overall` plus goals, because per-match
/// ratings existed only for the manager's own fixtures. That made the award a
/// restatement of who was already famous and who scored — a centre-back could
/// never make it, and a player who had a poor tournament kept their place on
/// reputation. Every match in the world is rated now, so the XI can be earned.
abstract final class TournamentStars {
  /// The shape of the team: goalkeepers, defenders, midfielders, forwards.
  static const Map<PositionCategory, int> _slots = {
    PositionCategory.goalkeeper: 1,
    PositionCategory.defender: 4,
    PositionCategory.midfielder: 3,
    PositionCategory.forward: 3,
  };

  /// The fewest appearances a player needs before a strong average counts.
  /// One brilliant game in a group stage is not a tournament.
  static const int minApps = 2;

  /// Whether every fixture of a tournament has been played.
  ///
  /// No award is named before this is true. The final being decided is not
  /// enough: a third-place play-off still to come is a match that can change
  /// who had the best tournament, and an award handed out while any of it is
  /// unplayed is an award given on incomplete evidence.
  static bool isComplete(Iterable<Fixture> fixtures) {
    var any = false;
    for (final f in fixtures) {
      any = true;
      if (!f.hasResult) return false;
    }
    return any;
  }

  /// The best XI from [candidates], best-fit first per line.
  ///
  /// [goalsByPlayer] maps a player id to goals scored in the tournament;
  /// [runByNation] maps a nation id to how many knockout rounds it reached
  /// (0 = group stage only); [champion] is the winning nation (a bonus).
  ///
  /// [formByPlayer] is how each player actually performed. When it is empty the
  /// old reputation-and-goals scoring is used, so a tournament played before
  /// ratings existed still produces a team.
  static List<StarPlayer> teamOfTournament({
    required List<Player> candidates,
    required Map<int, int> goalsByPlayer,
    required Map<int, int> runByNation,
    int? champion,
    Map<int, TournamentForm> formByPlayer = const {},
  }) {
    final rated = formByPlayer.isNotEmpty;
    final scored = <StarPlayer>[];
    for (final p in candidates) {
      final goals = goalsByPlayer[p.id] ?? 0;
      final run = runByNation[p.nationId] ?? 0;
      final form = formByPlayer[p.id];
      // Somebody who never played cannot be in the team of the tournament,
      // however good they are — the old scoring could pick an unused
      // substitute purely on reputation.
      if (rated && (form == null || form.apps < minApps)) continue;

      final double score;
      if (form == null) {
        score =
            p.overall +
            goals * 6.0 +
            run * 3.0 +
            (p.nationId == champion ? 8.0 : 0.0);
      } else {
        // Performance dominates. A 7.6 average over a full run beats a 6.8 who
        // happened to score twice, and quality/run stay as tie-breakers rather
        // than the substance of the award.
        score =
            (form.meanRating - 6.0) * 26.0 +
            form.motms * 6.0 +
            goals * 4.0 +
            run * 2.5 +
            p.overall * 0.12 +
            (p.nationId == champion ? 4.0 : 0.0);
      }
      scored.add(
        StarPlayer(
          player: p,
          goals: goals,
          score: score,
          apps: form?.apps ?? 0,
          meanRating: form?.meanRating ?? 0,
          motms: form?.motms ?? 0,
        ),
      );
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

  /// The tournament's best goalkeeper, from the keepers who actually played.
  ///
  /// The Golden Glove used to go to "a goalkeeper of the nation that conceded
  /// fewest" — picked by squad order, so it could land on a third-choice keeper
  /// who never left the bench.
  static StarPlayer? goldenGlove({
    required List<Player> candidates,
    required Map<int, TournamentForm> formByPlayer,
    required Map<int, int> cleanSheetsByPlayer,
  }) {
    StarPlayer? best;
    for (final p in candidates) {
      if (p.category != PositionCategory.goalkeeper) continue;
      final form = formByPlayer[p.id];
      if (form == null || form.apps < minApps) continue;
      // A keeper is judged on their marks and the sheets they kept.
      final score =
          (form.meanRating - 6.0) * 20.0 +
          (cleanSheetsByPlayer[p.id] ?? 0) * 5.0;
      if (best == null || score > best.score) {
        best = StarPlayer(
          player: p,
          goals: 0,
          score: score,
          apps: form.apps,
          meanRating: form.meanRating,
          motms: form.motms,
        );
      }
    }
    return best;
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
