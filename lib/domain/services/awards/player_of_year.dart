import 'dart:math' as math;

import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/awards/award_year.dart';
import 'package:fnm/domain/services/awards/awards.dart';

/// Who a voter is looking at: resolved from the pool, because the ratings
/// table knows what happened and not who it happened to.
typedef VoterProfile = ({
  String name,
  int age,
  PlayerPosition position,
  int overall,
});

/// A tournament's individual honour, as the vote counts it.
typedef VoteHonour = ({AwardKind kind, TrophyFamily family, double prestige});

/// One place in a year's vote.
class PotyEntry {
  const PotyEntry({
    required this.playerId,
    required this.nationId,
    required this.profile,
    required this.line,
    required this.individual,
    required this.team,
    required this.honours,
  });

  final int playerId;
  final int nationId;
  final VoterProfile profile;
  final YearLine line;

  /// The three parts of the score: his own year, what his nation won with
  /// him in it, and the tournament honours he collected.
  final double individual;
  final double team;
  final double honours;

  double get total => individual + team + honours;

  PositionCategory get category => profile.position.category;
}

/// The Player of the Year vote, Ballon d'Or style.
///
/// It used to be the mean mark weighted by appearances, plus goals: an
/// individual award decided by a striker's tally in qualifiers. A fan expects
/// more of it. The vote now has three parts:
///  * **his year** (about half of a winner's score): his marks, measured
///    against his own position so a great keeper is not beaten by an average
///    striker, each match weighted by its stage and its opponent (a World
///    Championship knockout tie against one of the best ten counts nearly
///    three times a qualifier, a friendly half), plus goals, assists, the
///    man-of-the-match awards and, at the back, clean sheets;
///  * **his nation's trophies** (about a third): a World Championship, a
///    continental title, a Nations Cup or the Continental Clash won that
///    year, scaled by how much of it he played and how well;
///  * **his tournament honours**: the Golden Ball, Golden Boot, Golden Glove
///    and the Team of the Tournament.
///
/// Calibrated over many simulated world-years (see the calibration test):
/// the World Champion's best man is almost always in the top five, keepers
/// and defenders win now and then, and a man whose nation won nothing can
/// reach the top five but rarely wins.
abstract final class PlayerOfYear {
  /// The position each category's marks are measured from, and how widely
  /// they spread. A forward's marks run higher than a keeper's in the world's
  /// ratings, so a raw mean was a forwards' award.
  static const Map<PositionCategory, double> _base = {
    PositionCategory.goalkeeper: 6.53,
    PositionCategory.defender: 6.58,
    PositionCategory.midfielder: 6.64,
    PositionCategory.forward: 6.82,
  };
  static const Map<PositionCategory, double> _spread = {
    PositionCategory.goalkeeper: 0.38,
    PositionCategory.defender: 0.40,
    PositionCategory.midfielder: 0.32,
    PositionCategory.forward: 0.46,
  };

  /// Points per spread above his position's norm, at full volume.
  static const double _formPoints = 12;

  /// Weighted matches at which volume is half way to full.
  static const double _volumeHalf = 6;

  /// Points per (weighted) goal, by position: a defender's goal is rarer.
  static const Map<PositionCategory, double> _goalPoints = {
    PositionCategory.goalkeeper: 2.0,
    PositionCategory.defender: 1.6,
    PositionCategory.midfielder: 1.5,
    PositionCategory.forward: 1.2,
  };
  static const double _assistPoints = 0.6;
  static const double _motmPoints = 1.5;

  /// Points per (weighted) clean sheet, by position.
  static const Map<PositionCategory, double> _cleanSheetPoints = {
    PositionCategory.goalkeeper: 1.4,
    PositionCategory.defender: 0.7,
    PositionCategory.midfielder: 0.3,
    PositionCategory.forward: 0,
  };

  /// A World Championship: winner, runner-up, beaten semi-finalist.
  static const List<double> worldChampionship = [30, 20, 12];

  /// A continental championship: winner, runner-up (times its prestige).
  static const List<double> continental = [20, 9];

  /// A Nations Cup won (times its confederation's prestige).
  static const double nationsCup = 8;

  /// The Continental Clash won.
  static const double clash = 4;

  /// Honours at a World Championship and at a continental championship (the
  /// latter times its prestige).
  static const Map<AwardKind, List<double>> _honourPoints = {
    AwardKind.goldenBall: [12, 8],
    AwardKind.goldenBoot: [5, 3.5],
    AwardKind.goldenGlove: [5, 3.5],
    AwardKind.teamOfTournament: [2.5, 1.5],
  };

  /// The appearance floors a thin year may fall back to, highest first: the
  /// usual [Awards.minApps], then lower, never under 3.
  static const List<int> floors = [Awards.minApps, 5, 4, 3];

  /// The candidates the main award needs before its floor stops falling.
  static const int bestField = 5;

  /// The candidates the young award needs.
  static const int youngField = 3;

  /// The year's appearance floor: [Awards.minApps], lowered a step at a time
  /// (5, 4, 3) until at least [need] of [lines] reach it, and never under 3.
  ///
  /// A ceremony happens every year, and some years are thin: the one after a
  /// World Championship can have barely a window of football, and with a
  /// fixed six nobody qualified at all. The volume term in [individual] still
  /// rewards whoever played most.
  static int floorFor(Iterable<YearLine> lines, {required int need}) {
    for (final floor in floors) {
      if (lines.where((l) => l.apps >= floor).length >= need) return floor;
    }
    return floors.last;
  }

  /// His own year under a given position. Zero below [minApps].
  static double individual(
    YearLine l,
    PositionCategory cat, {
    int minApps = Awards.minApps,
  }) {
    if (l.apps < minApps || l.weight <= 0) return 0;
    final z = (l.weightedMean - _base[cat]!) / _spread[cat]!;
    final volume = l.weight / (l.weight + _volumeHalf);
    // In a thin year (a floor under six) a clean sheet is worth less: over
    // three or four games a keeper's few shut-outs outweighed everything a
    // striker did, and the award tipped towards the back.
    final thin = math.pow(math.min(1.0, minApps / Awards.minApps), 2);
    return math.max(0.0, z) * _formPoints * volume +
        l.weightedGoals * _goalPoints[cat]! +
        l.weightedAssists * _assistPoints +
        l.weightedMotms * _motmPoints +
        l.weightedCleanSheets * _cleanSheetPoints[cat]! * thin;
  }

  /// What his nation won with him in it.
  ///
  /// Each title is scaled by his SHARE of it (his appearances against his
  /// nation's matches in that competition, two at least, or one for a
  /// one-match cup) and by how well he played in it, so the squad man who
  /// came on twice gets little of a title his captain carried.
  static double team(YearLine l, List<TrophyResult> trophies) {
    var total = 0.0;
    for (final t in trophies) {
      final c = l.competitions[t.competitionId];
      if (c == null) continue;
      final matches = t.matchesByNation[l.nationId] ?? 0;
      if (matches == 0 || c.apps < math.min(2, matches)) continue;
      final place = t.placeOf(l.nationId);
      if (place == null) continue;
      final base = trophyPoints(t, place);
      if (base <= 0) continue;
      final share = math.min(1.0, c.apps / matches);
      final form = (0.6 + 0.5 * (c.meanRating - 6.4)).clamp(0.5, 1.3);
      total += base * share * form;
    }
    return total;
  }

  /// A finish's full value, before his share.
  static double trophyPoints(TrophyResult t, int place) => switch (t.family) {
    TrophyFamily.worldChampionship => worldChampionship[place - 1],
    TrophyFamily.continental =>
      place <= 2
          ? continental[place - 1] * AwardYear.prestigeOf(t.confederation)
          : 0,
    TrophyFamily.nationsCup =>
      place == 1 ? nationsCup * AwardYear.prestigeOf(t.confederation) : 0,
    TrophyFamily.clash => place == 1 ? clash : 0,
  };

  /// The honours' points.
  static double honours(List<VoteHonour> hs) {
    var total = 0.0;
    for (final h in hs) {
      final pts = _honourPoints[h.kind];
      if (pts == null) continue;
      total += h.family == TrophyFamily.worldChampionship
          ? pts[0]
          : pts[1] * h.prestige;
    }
    return total;
  }

  /// The most a line could score whatever his position, before honours: the
  /// shortlist is drawn on this before anybody's position is known, so a
  /// great keeper is never cut for lack of goals.
  static double ceiling(
    YearLine l,
    List<TrophyResult> trophies, {
    int minApps = Awards.minApps,
  }) {
    if (l.apps < minApps) return 0;
    var best = 0.0;
    for (final cat in PositionCategory.values) {
      best = math.max(best, individual(l, cat, minApps: minApps));
    }
    return best + team(l, trophies);
  }

  /// The individual honours of every World Championship and continental
  /// championship decided this year, over the players in [profiles].
  ///
  /// THE APP DOES NOT USE THIS: it reads the honours stored for the year
  /// (see `TournamentHonourService`), the very picks the tournament screens
  /// show. This is the calibration lab's stand-in, for packed world-years
  /// that carry no stored honours. It follows the picks [TournamentStars]
  /// makes: the
  /// best XI on marks, goals, run and rating; its best man is the Golden
  /// Ball, its leading scorer the Golden Boot; the Golden Glove is the best
  /// keeper on marks and clean sheets.
  static Map<int, List<VoteHonour>> tournamentHonours(
    AwardYear year,
    Map<int, VoterProfile> profiles,
  ) {
    final out = <int, List<VoteHonour>>{};
    void add(int id, AwardKind kind, TrophyResult t) => (out[id] ??= []).add((
      kind: kind,
      family: t.family,
      prestige: t.family == TrophyFamily.worldChampionship
          ? 1.0
          : AwardYear.prestigeOf(t.confederation),
    ));
    for (final t in year.trophies) {
      if (t.family != TrophyFamily.worldChampionship &&
          t.family != TrophyFamily.continental) {
        continue;
      }
      final run = <int, int>{};
      for (final f in year.fixtures.values) {
        if (f.competitionId != t.competitionId) continue;
        final d = AwardYear.knockoutDepth(f.round);
        for (final n in [f.homeNationId, f.awayNationId]) {
          if (d > (run[n] ?? 0)) run[n] = d;
        }
      }
      final cands =
          <({int id, double score, CompetitionLine c, VoterProfile p})>[];
      for (final l in year.lines.values) {
        final c = l.competitions[t.competitionId];
        final p = profiles[l.playerId];
        if (c == null || p == null || c.apps < 2) continue;
        final score =
            (c.meanRating - 6.0) * 26.0 +
            c.motms * 6.0 +
            c.goals * 4.0 +
            (run[l.nationId] ?? 0) * 2.5 +
            p.overall * 0.12 +
            (l.nationId == t.champion ? 4.0 : 0.0);
        cands.add((id: l.playerId, score: score, c: c, p: p));
      }
      cands.sort((a, b) {
        final s = b.score.compareTo(a.score);
        return s != 0 ? s : a.id.compareTo(b.id);
      });
      final slots = {
        PositionCategory.goalkeeper: 1,
        PositionCategory.defender: 4,
        PositionCategory.midfielder: 3,
        PositionCategory.forward: 3,
      };
      final xi =
          <({int id, double score, CompetitionLine c, VoterProfile p})>[];
      for (final x in cands) {
        final cat = x.p.position.category;
        if (slots[cat]! <= 0) continue;
        slots[cat] = slots[cat]! - 1;
        xi.add(x);
        if (slots.values.every((n) => n == 0)) break;
      }
      if (xi.isNotEmpty) {
        add(xi.first.id, AwardKind.goldenBall, t);
        ({int id, double score, CompetitionLine c, VoterProfile p})? boot;
        for (final x in xi) {
          if (x.c.goals > 0 && (boot == null || x.c.goals > boot.c.goals)) {
            boot = x;
          }
        }
        if (boot != null) add(boot.id, AwardKind.goldenBoot, t);
        for (final x in xi) {
          add(x.id, AwardKind.teamOfTournament, t);
        }
      }
      int? glove;
      var gloveScore = double.negativeInfinity;
      for (final x in cands) {
        if (x.p.position.category != PositionCategory.goalkeeper) continue;
        final s = (x.c.meanRating - 6.0) * 20.0 + x.c.cleanSheets * 5.0;
        if (s > gloveScore) {
          gloveScore = s;
          glove = x.id;
        }
      }
      if (glove != null) add(glove, AwardKind.goldenGlove, t);
    }
    return out;
  }

  /// The vote: everyone in [profiles] scored, best first, ties on player id.
  /// [eligible] narrows it (the young award).
  ///
  /// [minApps] is the year's floor; left out, it is [floorFor] over the
  /// field in [profiles] ([bestField] candidates for the main award,
  /// [youngField] when [eligible] narrows it).
  static List<PotyEntry> rank(
    AwardYear year,
    Map<int, VoterProfile> profiles, {
    bool Function(VoterProfile p)? eligible,
    Map<int, List<VoteHonour>>? honours,
    int limit = 5,
    int? minApps,
  }) {
    final hs = honours ?? tournamentHonours(year, profiles);
    final field = [
      for (final e in profiles.entries)
        if (year.lines[e.key] case final l?)
          if (eligible == null || eligible(e.value)) (l, e.value),
    ];
    final floor =
        minApps ??
        floorFor(
          field.map((f) => f.$1),
          need: eligible == null ? bestField : youngField,
        );
    final out = <PotyEntry>[];
    for (final (l, p) in field) {
      if (l.apps < floor) continue;
      out.add(
        PotyEntry(
          playerId: l.playerId,
          nationId: l.nationId,
          profile: p,
          line: l,
          individual: individual(l, p.position.category, minApps: floor),
          team: team(l, year.trophies),
          honours: PlayerOfYear.honours(hs[l.playerId] ?? const []),
        ),
      );
    }
    out.sort((a, b) {
      final s = b.total.compareTo(a.total);
      return s != 0 ? s : a.playerId.compareTo(b.playerId);
    });
    return out.take(limit).toList();
  }

  /// The young award's field: aged [Awards.youngMaxAge] or under.
  static bool young(VoterProfile p) => p.age <= Awards.youngMaxAge;
}
