import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/finals_participation.dart';
import 'package:fnm/domain/services/competition/rounds.dart';

/// One rated appearance in an award year, as the world's ratings record it.
typedef AwardAppearance = ({
  int fixtureId,
  int playerId,
  int nationId,
  double rating,
  int goals,
  int assists,
  bool cleanSheet,
  bool motm,
});

/// One played fixture of an award year: enough to tell a friendly from a
/// World Championship final, and who won it.
typedef AwardFixture = ({
  int id,
  int competitionId,
  CompetitionKind kind,
  Confederation confederation,
  String? round,
  DateTime date,
  int homeNationId,
  int awayNationId,
  int homeScore,
  int awayScore,
  int? homePenalties,
  int? awayPenalties,
});

/// The tournaments a team can win in a year.
enum TrophyFamily {
  /// The World Championship finals.
  worldChampionship,

  /// A confederation's championship finals.
  continental,

  /// A Nations Cup's finals (a Finals Four, or Africa's Finals Eight).
  nationsCup,

  /// The Continental Clash: a one-off between two continental champions.
  clash,
}

/// How a finals tournament that ENDED in the award year finished.
class TrophyResult {
  const TrophyResult({
    required this.competitionId,
    required this.family,
    required this.confederation,
    required this.champion,
    required this.runnerUp,
    required this.semiFinalists,
    required this.matchesByNation,
  });

  final int competitionId;
  final TrophyFamily family;
  final Confederation confederation;
  final int champion;
  final int runnerUp;

  /// The beaten semi-finalists (none for a cup without semi-finals).
  final List<int> semiFinalists;

  /// Fixtures each nation played in it this year: the denominator of a
  /// player's share.
  final Map<int, int> matchesByNation;

  /// Where [nationId] finished: 1 champion, 2 runner-up, 3 semi-final, or
  /// null for anybody else.
  int? placeOf(int nationId) {
    if (nationId == champion) return 1;
    if (nationId == runnerUp) return 2;
    if (semiFinalists.contains(nationId)) return 3;
    return null;
  }
}

/// One player's part in one competition this year.
class CompetitionLine {
  int apps = 0;
  double ratingSum = 0;
  int goals = 0;
  int assists = 0;
  int motms = 0;
  int cleanSheets = 0;

  /// The deepest knockout round he played in, 0 for none (see
  /// [AwardYear.knockoutDepth]).
  int depth = 0;

  double get meanRating => apps == 0 ? 0 : ratingSum / apps;
}

/// One player's whole year, raw and weighted.
class YearLine {
  YearLine(this.playerId, this.nationId);

  final int playerId;
  int nationId;

  int apps = 0;
  double ratingSum = 0;
  int goals = 0;
  int assists = 0;
  int motms = 0;
  int cleanSheets = 0;

  /// The same, each match weighted by how much it mattered (see
  /// [AwardYear.weightOf]).
  double weight = 0;
  double weightedRating = 0;
  double weightedGoals = 0;
  double weightedAssists = 0;
  double weightedMotms = 0;
  double weightedCleanSheets = 0;

  /// Appearances in a finals tournament (any round), and in its knockouts.
  int finalsApps = 0;
  int knockoutApps = 0;

  /// By competition id.
  final Map<int, CompetitionLine> competitions = {};

  double get meanRating => apps == 0 ? 0 : ratingSum / apps;

  /// Mean rating, each match weighted by its stage.
  double get weightedMean => weight == 0 ? 0 : weightedRating / weight;
}

/// The raw material of a year's vote: every player's line and every trophy
/// decided.
class AwardYear {
  AwardYear({
    required this.year,
    required this.lines,
    required this.trophies,
    required this.fixtures,
  });

  final int year;
  final Map<int, YearLine> lines;
  final List<TrophyResult> trophies;

  /// The year's fixtures by id.
  final Map<int, AwardFixture> fixtures;

  /// How much a match of [f] counts towards a year, against a qualifier's 1.
  ///
  /// A friendly is half a match, a World Championship knockout tie more than
  /// two. A continental championship weighs by its confederation's standing
  /// ([prestigeOf]): the European Championship is nearly a World Championship,
  /// the Oceania cup barely more than qualifying.
  static double weightOf(AwardFixture f) {
    final round = f.round;
    if (f.kind == CompetitionKind.friendly || round == Rounds.friendly) {
      return 0.5;
    }
    final ko = Rounds.isKnockout(round);
    switch (f.kind) {
      case CompetitionKind.worldCupFinals:
        return ko ? 2.3 : 1.7;
      case CompetitionKind.continentalFinals:
        final p = prestigeOf(f.confederation);
        return ko ? 1.0 + 1.0 * p : 1.0 + 0.5 * p;
      case CompetitionKind.nationsLeague:
        return FinalsRounds.nationsCup.contains(round) ? 1.5 : 1.0;
      case CompetitionKind.finalissima:
        return 1.6;
      case CompetitionKind.worldCupPlayoff:
        return 1.3;
      case CompetitionKind.worldCupQualifying:
      case CompetitionKind.continentalQualifying:
        return 1.0;
      case CompetitionKind.friendly:
        return 0.5;
    }
  }

  /// How much the opponent's standing adds to a match: a night against one
  /// of the world's best ten counts a quarter more, a stroll against a side
  /// outside the top hundred and ten counts less. Without it a striker who
  /// scored a hatful against minnows outvoted one who decided big games.
  static double opponentFactor(int rank) => rank <= 10
      ? 1.25
      : rank <= 25
      ? 1.12
      : rank <= 60
      ? 1.0
      : rank <= 110
      ? 0.85
      : 0.7;

  /// How much a confederation's championship is worth beside the European
  /// one, 0-1.
  static double prestigeOf(Confederation c) => switch (c) {
    Confederation.europe => 1.0,
    Confederation.southAmerica => 1.0,
    Confederation.africa => 0.75,
    Confederation.asia => 0.7,
    Confederation.northAmerica => 0.6,
    Confederation.oceania => 0.3,
  };

  /// Whether [f] is a finals tournament match (any stage).
  static bool isFinals(AwardFixture f) =>
      f.kind == CompetitionKind.worldCupFinals ||
      f.kind == CompetitionKind.continentalFinals ||
      f.kind == CompetitionKind.finalissima ||
      (f.kind == CompetitionKind.nationsLeague &&
          FinalsRounds.nationsCup.contains(f.round));

  /// How deep a knockout round is: 1 for the first knockout round of any
  /// size through 5 for the final.
  static int knockoutDepth(String? round) {
    if (round == null || !Rounds.isKnockout(round)) return 0;
    if (round.endsWith('FINAL')) return 5;
    if (round.endsWith('3RD') || round.endsWith('SF')) return 4;
    if (round.endsWith('QF')) return 3;
    if (round.endsWith('R16')) return 2;
    return 1;
  }

  /// The winner of a played tie: penalties when it went to them, else the
  /// score, the home side on a level score (as the season service crowns).
  static int winnerOf(AwardFixture f) {
    if (f.homeScore == f.awayScore &&
        f.homePenalties != null &&
        f.awayPenalties != null &&
        f.homePenalties != f.awayPenalties) {
      return f.homePenalties! > f.awayPenalties!
          ? f.homeNationId
          : f.awayNationId;
    }
    return f.homeScore >= f.awayScore ? f.homeNationId : f.awayNationId;
  }

  static int loserOf(AwardFixture f) =>
      winnerOf(f) == f.homeNationId ? f.awayNationId : f.homeNationId;

  /// Builds a year from its raw rows. Only fixtures dated in [year] count.
  static AwardYear build({
    required int year,
    required Iterable<AwardFixture> fixtures,
    required Iterable<AwardAppearance> appearances,
    int Function(int nationId)? rankOf,
  }) {
    final byId = <int, AwardFixture>{
      for (final f in fixtures)
        if (f.date.year == year) f.id: f,
    };
    final lines = <int, YearLine>{};
    for (final a in appearances) {
      final f = byId[a.fixtureId];
      if (f == null) continue;
      final l = lines.putIfAbsent(
        a.playerId,
        () => YearLine(a.playerId, a.nationId),
      )..nationId = a.nationId;
      final opponent = f.homeNationId == a.nationId
          ? f.awayNationId
          : f.homeNationId;
      final w =
          weightOf(f) *
          (rankOf == null ? 1.0 : opponentFactor(rankOf(opponent)));
      l
        ..apps += 1
        ..ratingSum += a.rating
        ..goals += a.goals
        ..assists += a.assists
        ..motms += a.motm ? 1 : 0
        ..cleanSheets += a.cleanSheet ? 1 : 0
        ..weight += w
        ..weightedRating += w * a.rating
        ..weightedGoals += w * a.goals
        ..weightedAssists += w * a.assists
        ..weightedMotms += a.motm ? w : 0
        ..weightedCleanSheets += a.cleanSheet ? w : 0;
      if (isFinals(f)) {
        l.finalsApps += 1;
        if (Rounds.isKnockout(f.round)) l.knockoutApps += 1;
      }
      final c = l.competitions.putIfAbsent(f.competitionId, CompetitionLine.new)
        ..apps += 1
        ..ratingSum += a.rating
        ..goals += a.goals
        ..assists += a.assists
        ..motms += a.motm ? 1 : 0
        ..cleanSheets += a.cleanSheet ? 1 : 0;
      final d = knockoutDepth(f.round);
      if (d > c.depth) c.depth = d;
    }
    return AwardYear(
      year: year,
      lines: lines,
      trophies: _trophies(byId.values),
      fixtures: byId,
    );
  }

  /// Every trophy whose final was played this year.
  static List<TrophyResult> _trophies(Iterable<AwardFixture> fixtures) {
    final byComp = <int, List<AwardFixture>>{};
    for (final f in fixtures) {
      (byComp[f.competitionId] ??= []).add(f);
    }
    final out = <TrophyResult>[];
    for (final entry in byComp.entries) {
      final fs = entry.value;
      final family = switch (fs.first.kind) {
        CompetitionKind.worldCupFinals => TrophyFamily.worldChampionship,
        CompetitionKind.continentalFinals => TrophyFamily.continental,
        CompetitionKind.nationsLeague => TrophyFamily.nationsCup,
        CompetitionKind.finalissima => TrophyFamily.clash,
        _ => null,
      };
      if (family == null) continue;
      final finals = fs
          .where((f) => f.round != null && f.round!.endsWith('FINAL'))
          .toList();
      if (finals.isEmpty) continue;
      // A Nations Cup's competition also holds its ladder: only its finals
      // rounds are the tournament.
      final relevant = family == TrophyFamily.nationsCup
          ? fs.where((f) => FinalsRounds.nationsCup.contains(f.round))
          : fs;
      final matches = <int, int>{};
      for (final f in fs) {
        // The share counts the whole competition this year, ladder included:
        // a man who carried a side through its group and its Finals Four
        // played more of its title than one who came on in the final.
        matches.update(f.homeNationId, (v) => v + 1, ifAbsent: () => 1);
        matches.update(f.awayNationId, (v) => v + 1, ifAbsent: () => 1);
      }
      final last = finals.first;
      out.add(
        TrophyResult(
          competitionId: entry.key,
          family: family,
          confederation: last.confederation,
          champion: winnerOf(last),
          runnerUp: loserOf(last),
          semiFinalists: [
            for (final f in relevant)
              if (f.round != null && f.round!.endsWith('SF')) loserOf(f),
          ],
          matchesByNation: matches,
        ),
      );
    }
    out.sort((a, b) => a.competitionId.compareTo(b.competitionId));
    return out;
  }
}
