import 'package:fnm/domain/entities/enums.dart';

/// One player's year, as the voters see it.
typedef AwardLine = ({
  int playerId,
  int nationId,
  String name,
  int age,
  int apps,
  int goals,
  int assists,
  double meanRating,
  int motms,
});

/// Who won an individual trophy.
typedef AwardWinner = ({
  int playerId,
  int nationId,
  String name,
  AwardKind kind,
});

/// The world's individual trophies.
///
/// The per-tournament awards have always been picked by [TournamentStars]; what
/// lives here is the pair that accumulate — Player of the Year and its under-21
/// twin. A tournament comes round every two years at best, so before these a
/// monumental career could collect three individual trophies and a quiet one
/// could collect none, and the two read the same on a player's card.
abstract final class Awards {
  /// Appearances below which a season is not a season.
  ///
  /// Without a floor the award goes to whoever played twice and was marked 8.5
  /// both times, which is not what anybody means by player of the year.
  static const int minApps = 6;

  /// The age at which a player stops being eligible for the young award — the
  /// same boundary the youth pyramid uses.
  static const int youngMaxAge = 20;

  /// The world's best over a year, or null if nobody played enough.
  static AwardWinner? playerOfYear(Iterable<AwardLine> lines) =>
      _best(lines, AwardKind.playerOfYear, (l) => true);

  /// The world's best under-21 over a year.
  static AwardWinner? youngPlayerOfYear(Iterable<AwardLine> lines) => _best(
    lines,
    AwardKind.youngPlayerOfYear,
    (l) => l.age <= youngMaxAge,
  );

  /// How good a year was.
  ///
  /// Mean rating carries it, because that is what the whole world's matches are
  /// marked on — but weighted by how much football he actually played, so a man
  /// with fifteen good games beats one with three great ones. Goals and
  /// man-of-the-match awards break the ties that rating alone leaves.
  static double score(AwardLine l) {
    if (l.apps < minApps) return 0;
    // Saturating, not linear: the difference between six games and twelve is
    // large, between thirty and thirty-six almost nothing.
    final volume = 1 + (l.apps - minApps) / (l.apps - minApps + 8.0);
    return l.meanRating * volume +
        l.goals * 0.18 +
        l.assists * 0.10 +
        l.motms * 0.35;
  }

  static AwardWinner? _best(
    Iterable<AwardLine> lines,
    AwardKind kind,
    bool Function(AwardLine) eligible,
  ) {
    AwardLine? best;
    var bestScore = 0.0;
    for (final l in lines) {
      if (l.apps < minApps || !eligible(l)) continue;
      final s = score(l);
      // Ties break on the player id, so two saves at the same year agree on
      // who won rather than on which row the database happened to return first.
      if (s > bestScore ||
          (s == bestScore && best != null && l.playerId < best.playerId)) {
        bestScore = s;
        best = l;
      }
    }
    if (best == null) return null;
    return (
      playerId: best.playerId,
      nationId: best.nationId,
      name: best.name,
      kind: kind,
    );
  }
}
