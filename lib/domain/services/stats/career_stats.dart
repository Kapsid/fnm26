/// The manager's career statistics engine. Pure and unit-testable: the feature
/// layer (`stats_providers.dart`) gathers the raw match rows from the database
/// and hands them here; everything below is deterministic arithmetic so the
/// aggregates, records, streaks and player feats are trivial to test and reuse.
///
/// This one snapshot feeds the stats screens, the achievements catalogue and
/// the career-spanning challenges, so they all agree on the same numbers rather
/// than each re-deriving them.
library;

/// One match seen from the manager's side — the atom every aggregate is built
/// from. The feature layer normalises a stored fixture into this (resolving
/// which side the manager was, whether it was a neutral finals venue, and
/// whether they trailed at any point).
typedef ManagerMatch = ({
  DateTime date,

  /// The nation the manager led in this match (a career can span several).
  int nationId,
  int goalsFor,
  int goalsAgainst,

  /// A competitive fixture (qualifier, finals, Nations Cup) — not a friendly.
  bool competitive,

  /// Played in front of the manager's own crowd (false for away and neutral).
  bool home,

  /// A neutral-venue finals match (no home crowd for either side).
  bool neutral,

  /// A level knockout settled on penalties, in the manager's favour / against.
  bool wonShootout,
  bool lostShootout,

  /// Whether the manager's side was behind at any point (for comeback records).
  bool trailed,
});

/// One player's stat line from a manager match (both teams are recorded, but
/// the feature layer passes only the manager's own players here, so the feats
/// are the manager's).
typedef PlayerMatchLine = ({
  int playerId,
  int goals,
  int assists,
  double rating,
  bool motm,
  int yellows,
  int reds,
});

enum MatchResult { win, draw, loss }

/// The manager's whole-career statistics, aggregated across every nation and
/// cycle. Counts are lifetime unless named otherwise.
class CareerStatsSnapshot {
  const CareerStatsSnapshot({
    this.played = 0,
    this.wins = 0,
    this.draws = 0,
    this.losses = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
    this.cleanSheets = 0,
    this.failedToScore = 0,
    this.biggestWinMargin = 0,
    this.heaviestDefeatMargin = 0,
    this.mostGoalsInAGame = 0,
    this.longestWinStreak = 0,
    this.longestUnbeatenRun = 0,
    this.longestCleanSheetStreak = 0,
    this.longestScoringStreak = 0,
    this.longestWinlessRun = 0,
    this.currentWinStreak = 0,
    this.currentUnbeatenRun = 0,
    this.shootoutsWon = 0,
    this.shootoutsLost = 0,
    this.comebackWins = 0,
    this.homeWins = 0,
    this.homeDraws = 0,
    this.homeLosses = 0,
    this.awayWins = 0,
    this.awayDraws = 0,
    this.awayLosses = 0,
    this.neutralWins = 0,
    this.neutralDraws = 0,
    this.neutralLosses = 0,
    this.competitivePlayed = 0,
    this.friendlyPlayed = 0,
    this.hatTricks = 0,
    this.braces = 0,
    this.playerMotms = 0,
    this.playerAssists = 0,
    this.playerYellows = 0,
    this.playerReds = 0,
    this.bestPlayerRating = 0,
  });

  final int played, wins, draws, losses;
  final int goalsFor, goalsAgainst;
  final int cleanSheets, failedToScore;

  /// Largest winning / losing margins, and the most goals the manager's side
  /// has ever scored in a single game.
  final int biggestWinMargin, heaviestDefeatMargin, mostGoalsInAGame;

  /// Longest lifetime runs (consecutive matches, chronological).
  final int longestWinStreak,
      longestUnbeatenRun,
      longestCleanSheetStreak,
      longestScoringStreak,
      longestWinlessRun;

  /// The run the manager is on right now (up to the latest match).
  final int currentWinStreak, currentUnbeatenRun;

  final int shootoutsWon, shootoutsLost, comebackWins;

  final int homeWins, homeDraws, homeLosses;
  final int awayWins, awayDraws, awayLosses;
  final int neutralWins, neutralDraws, neutralLosses;

  final int competitivePlayed, friendlyPlayed;

  /// Feats by the manager's own players, across their matches.
  final int hatTricks, braces, playerMotms, playerAssists;
  final int playerYellows, playerReds;
  final double bestPlayerRating;

  int get goalDifference => goalsFor - goalsAgainst;

  /// Win rate 0–1 (0 when no matches have been played).
  double get winRate => played == 0 ? 0 : wins / played;

  /// Goals scored per game (0 when no matches).
  double get goalsPerGame => played == 0 ? 0 : goalsFor / played;
}

abstract final class CareerStats {
  static MatchResult resultOf(ManagerMatch m) {
    if (m.goalsFor > m.goalsAgainst || m.wonShootout) return MatchResult.win;
    if (m.goalsFor < m.goalsAgainst || m.lostShootout) return MatchResult.loss;
    return MatchResult.draw;
  }

  /// Builds the whole-career snapshot from the manager's [matches] (any order —
  /// sorted here) and their players' [lines].
  static CareerStatsSnapshot compute(
    List<ManagerMatch> matches,
    List<PlayerMatchLine> lines,
  ) {
    final sorted = [...matches]..sort((a, b) => a.date.compareTo(b.date));

    var wins = 0, draws = 0, losses = 0;
    var goalsFor = 0, goalsAgainst = 0;
    var cleanSheets = 0, failedToScore = 0;
    var biggestWin = 0, heaviestDefeat = 0, mostGoals = 0;
    var shootoutsWon = 0, shootoutsLost = 0, comebackWins = 0;
    var competitive = 0, friendly = 0;
    var hW = 0, hD = 0, hL = 0, aW = 0, aD = 0, aL = 0, nW = 0, nD = 0, nL = 0;

    // Streak accumulators. "current" runs count backwards from the last match,
    // so they only stay live while the tail of the timeline keeps them going.
    var winStreak = 0, unbeaten = 0, cleanRun = 0, scoreRun = 0, winless = 0;
    var bestWinStreak = 0,
        bestUnbeaten = 0,
        bestClean = 0,
        bestScore = 0,
        bestWinless = 0;

    for (final m in sorted) {
      final r = resultOf(m);
      goalsFor += m.goalsFor;
      goalsAgainst += m.goalsAgainst;
      if (m.goalsAgainst == 0) cleanSheets++;
      if (m.goalsFor == 0) failedToScore++;
      if (m.competitive) {
        competitive++;
      } else {
        friendly++;
      }

      final margin = m.goalsFor - m.goalsAgainst;
      if (margin > biggestWin) biggestWin = margin;
      if (-margin > heaviestDefeat) heaviestDefeat = -margin;
      if (m.goalsFor > mostGoals) mostGoals = m.goalsFor;

      if (m.wonShootout) shootoutsWon++;
      if (m.lostShootout) shootoutsLost++;
      if (m.trailed && r == MatchResult.win) comebackWins++;

      switch (r) {
        case MatchResult.win:
          wins++;
          if (m.neutral) {
            nW++;
          } else if (m.home) {
            hW++;
          } else {
            aW++;
          }
        case MatchResult.draw:
          draws++;
          if (m.neutral) {
            nD++;
          } else if (m.home) {
            hD++;
          } else {
            aD++;
          }
        case MatchResult.loss:
          losses++;
          if (m.neutral) {
            nL++;
          } else if (m.home) {
            hL++;
          } else {
            aL++;
          }
      }

      // Streaks.
      winStreak = r == MatchResult.win ? winStreak + 1 : 0;
      unbeaten = r == MatchResult.loss ? 0 : unbeaten + 1;
      winless = r == MatchResult.win ? 0 : winless + 1;
      cleanRun = m.goalsAgainst == 0 ? cleanRun + 1 : 0;
      scoreRun = m.goalsFor > 0 ? scoreRun + 1 : 0;
      if (winStreak > bestWinStreak) bestWinStreak = winStreak;
      if (unbeaten > bestUnbeaten) bestUnbeaten = unbeaten;
      if (winless > bestWinless) bestWinless = winless;
      if (cleanRun > bestClean) bestClean = cleanRun;
      if (scoreRun > bestScore) bestScore = scoreRun;
    }

    // Player feats.
    var hatTricks = 0,
        braces = 0,
        motms = 0,
        assists = 0,
        yellows = 0,
        reds = 0;
    var bestRating = 0.0;
    for (final l in lines) {
      if (l.goals >= 3) {
        hatTricks++;
      } else if (l.goals == 2) {
        braces++;
      }
      if (l.motm) motms++;
      assists += l.assists;
      yellows += l.yellows;
      reds += l.reds;
      if (l.rating > bestRating) bestRating = l.rating;
    }

    return CareerStatsSnapshot(
      played: sorted.length,
      wins: wins,
      draws: draws,
      losses: losses,
      goalsFor: goalsFor,
      goalsAgainst: goalsAgainst,
      cleanSheets: cleanSheets,
      failedToScore: failedToScore,
      biggestWinMargin: biggestWin,
      heaviestDefeatMargin: heaviestDefeat,
      mostGoalsInAGame: mostGoals,
      longestWinStreak: bestWinStreak,
      longestUnbeatenRun: bestUnbeaten,
      longestCleanSheetStreak: bestClean,
      longestScoringStreak: bestScore,
      longestWinlessRun: bestWinless,
      currentWinStreak: winStreak,
      currentUnbeatenRun: unbeaten,
      shootoutsWon: shootoutsWon,
      shootoutsLost: shootoutsLost,
      comebackWins: comebackWins,
      homeWins: hW,
      homeDraws: hD,
      homeLosses: hL,
      awayWins: aW,
      awayDraws: aD,
      awayLosses: aL,
      neutralWins: nW,
      neutralDraws: nD,
      neutralLosses: nL,
      competitivePlayed: competitive,
      friendlyPlayed: friendly,
      hatTricks: hatTricks,
      braces: braces,
      playerMotms: motms,
      playerAssists: assists,
      playerYellows: yellows,
      playerReds: reds,
      bestPlayerRating: bestRating,
    );
  }
}
