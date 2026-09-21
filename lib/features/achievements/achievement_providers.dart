import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/achievements/achievements.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/tournament_stars.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/stats/stats_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The localised (title, description) for an achievement, resolved from its
/// stable [AchievementDef.id]. Falls back to the catalogue's English if an id
/// isn't mapped, so a newly added achievement still shows text.
({String title, String description}) achievementText(
  AppLocalizations l,
  AchievementDef def,
) {
  final id = def.id;
  if (id.startsWith('wins_')) {
    final t = int.tryParse(id.substring(5)) ?? 0;
    return (title: l.achWins(t), description: l.achWinsDesc(t));
  }
  if (id.startsWith('matches_')) {
    final t = int.tryParse(id.substring(8)) ?? 0;
    return (title: l.achMatches(t), description: l.achMatchesDesc(t));
  }
  if (id.startsWith('goals_')) {
    final t = int.tryParse(id.substring(6)) ?? 0;
    return (title: l.achGoals(t), description: l.achGoalsDesc(t));
  }
  if (id.startsWith('cleansheets_')) {
    final t = int.tryParse(id.substring(12)) ?? 0;
    return (title: l.achCleanSheets(t), description: l.achCleanSheetsDesc(t));
  }
  return switch (id) {
    'streak_win_5' => (
      title: l.achStreakWin5,
      description: l.achStreakWin5Desc,
    ),
    'streak_win_10' => (
      title: l.achStreakWin10,
      description: l.achStreakWin10Desc,
    ),
    'streak_win_20' => (
      title: l.achStreakWin20,
      description: l.achStreakWin20Desc,
    ),
    'streak_unbeaten_15' => (
      title: l.achUnbeaten15,
      description: l.achUnbeaten15Desc,
    ),
    'streak_unbeaten_30' => (
      title: l.achUnbeaten30,
      description: l.achUnbeaten30Desc,
    ),
    'feat_hattrick' => (title: l.achHattrick, description: l.achHattrickDesc),
    'feat_motm_10' => (title: l.achMotm10, description: l.achMotm10Desc),
    'feat_motm_50' => (title: l.achMotm50, description: l.achMotm50Desc),
    'feat_perfect' => (title: l.achPerfect, description: l.achPerfectDesc),
    'feat_shootout' => (title: l.achShootout, description: l.achShootoutDesc),
    'feat_massacre' => (title: l.achMassacre, description: l.achMassacreDesc),
    'feat_annihilation' => (
      title: l.achAnnihilation,
      description: l.achAnnihilationDesc,
    ),
    'qual_wc' => (title: l.achQualWc, description: l.achQualWcDesc),
    'qual_cont' => (title: l.achQualCont, description: l.achQualContDesc),
    'title_wc' => (title: l.achTitleWc, description: l.achTitleWcDesc),
    'title_euro' => (title: l.achTitleEuro, description: l.achTitleEuroDesc),
    'title_copa' => (title: l.achTitleCopa, description: l.achTitleCopaDesc),
    'title_afcon' => (title: l.achTitleAfcon, description: l.achTitleAfconDesc),
    'title_asia' => (title: l.achTitleAsia, description: l.achTitleAsiaDesc),
    'title_concacaf' => (
      title: l.achTitleConcacaf,
      description: l.achTitleConcacafDesc,
    ),
    'title_ofc' => (title: l.achTitleOfc, description: l.achTitleOfcDesc),
    'title_nations_league' => (
      title: l.achTitleNations,
      description: l.achTitleNationsDesc,
    ),
    'title_finalissima' => (
      title: l.achTitleClash,
      description: l.achTitleClashDesc,
    ),
    'wc_marksman' => (title: l.achMarksman, description: l.achMarksmanDesc),
    'mega_sweep' => (title: l.achSweep, description: l.achSweepDesc),
    'mega_allstar' => (title: l.achAllstar, description: l.achAllstarDesc),
    'mega_goldenboot' => (
      title: l.achGoldenboot,
      description: l.achGoldenbootDesc,
    ),
    'mega_demolition' => (
      title: l.achDemolition,
      description: l.achDemolitionDesc,
    ),
    _ => (title: def.title, description: def.description),
  };
}

/// The localised heading for an achievement [c]ategory.
String achievementCategoryLabel(AppLocalizations l, AchievementCategory c) =>
    switch (c) {
      AchievementCategory.wins => l.achCatWins,
      AchievementCategory.goals => l.achCatGoals,
      AchievementCategory.matches => l.achCatMatches,
      AchievementCategory.streaks => l.achCatStreaks,
      AchievementCategory.qualifications => l.achCatQualifications,
      AchievementCategory.titles => l.achCatTitles,
      AchievementCategory.misc => l.achCatMisc,
      AchievementCategory.mega => l.achCatMega,
    };

/// The localised rarity label for an achievement [t]ier.
String achievementTierLabel(AppLocalizations l, AchievementTier t) =>
    switch (t) {
      AchievementTier.bronze => l.achTierBronze,
      AchievementTier.silver => l.achTierSilver,
      AchievementTier.gold => l.achTierGold,
      AchievementTier.platinum => l.achTierPlatinum,
    };

/// Board/fan satisfaction (0–100) for the save. Recent form nudges it match to
/// match; a tournament result is what actually moves it. See
/// [BoardSatisfaction] for the weights and why they are sized as they are.
final AutoDisposeFutureProviderFamily<int, int>
satisfactionProvider = FutureProvider.autoDispose.family<int, int>((
  ref,
  careerId,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return BoardSatisfaction.neutral;
  final comp = ref.watch(competitionRepositoryProvider);
  final fixtures = await comp.fixturesForNation(careerId, career.nationId);

  // Recent form, newest first.
  final played = fixtures.where((f) => f.hasResult).toList()
    ..sort((a, b) => b.date.compareTo(a.date));
  final recent = [
    for (final f in played.take(BoardSatisfaction.formWindow))
      () {
        final isHome = f.homeNationId == career.nationId;
        final mine = isHome ? f.homeScore! : f.awayScore!;
        final theirs = isHome ? f.awayScore! : f.homeScore!;
        if (mine > theirs) return MatchOutcome.win;
        if (mine == theirs) return MatchOutcome.draw;
        return MatchOutcome.loss;
      }(),
  ];

  final ranking = await ref.watch(worldRankingProvider(careerId).future);

  // Tournaments the nation placed in recently. The board's memory is short —
  // last cycle's trophy doesn't buy this cycle's goodwill.
  final nations = await ref.watch(nationRepositoryProvider).all();
  final conf = nations
      .where((n) => n.id == career.nationId)
      .map((n) => n.confederation)
      .firstOrNull;
  final continentalName = conf == null
      ? null
      : ContinentalCups.byConfederation[conf]?.name;

  final honours = <({TournamentTier tier, Placing placing})>[];
  for (final h in await comp.honours(careerId)) {
    if (h.year < career.inGameDate.year - 1) continue;
    final placing = h.championId == career.nationId
        ? Placing.champion
        : h.runnerUpId == career.nationId
        ? Placing.runnerUp
        : (h.thirdId == career.nationId || h.thirdId2 == career.nationId)
        ? Placing.third
        : null;
    if (placing == null) continue;
    final tier = switch (h.competition) {
      'World Championship' => TournamentTier.world,
      'Nations Cup' => TournamentTier.nationsCup,
      'Continental Clash' => TournamentTier.clash,
      final name when name == continentalName => TournamentTier.continental,
      // Another confederation's cup can't be won by this nation, so anything
      // left is a competition the board doesn't weigh.
      _ => null,
    };
    if (tier == null) continue;
    honours.add((tier: tier, placing: placing));
  }

  // The cycle's stated objectives, once each is settled — the biggest thing
  // the gauge answers to. Without them the board's mood was legible only to
  // the code: a manager could hit the brief and still be "concerned", or miss
  // it and be "pleased", purely on friendly form.
  final objectives = await ref.watch(cycleObjectivesProvider(careerId).future);
  final settled = [
    for (final o in objectives)
      if (o.decided) (tier: o.tier, target: o.target, actual: o.actual),
  ];

  // What the manager has said in public this cycle. Small next to results, but
  // it is the one thing that moves the board between matches.
  final press = await ref.watch(pressEffectProvider(careerId).future);

  final base =
      (BoardSatisfaction.compute(
                recent: recent,
                honours: honours,
                worldRank: ranking?.position[career.nationId],
                objectives: settled,
                // The board reads the room. A neutral public contributes
                // exactly nothing, so the gauge only moves once the country
                // has an opinion.
                publicMood: await ref.watch(
                  publicMoodProvider(careerId).future,
                ),
                // A reputation is worth a little rope, and only a little.
                previousCycle: career.lastCycleBoard,
              ) +
              press.board)
          .clamp(0, 100);

  // Board promise kept: once EVERY settled objective has been met, the board
  // stays onside — individual results still nudge satisfaction, but it can
  // never sink below the neutral (job-safe) mark for the rest of the cycle.
  final allMet =
      settled.isNotEmpty &&
      objectives.where((o) => o.decided).every((o) => o.met);
  if (allMet && base < BoardSatisfaction.neutral) {
    return BoardSatisfaction.neutral;
  }
  return base;
});

/// Gathers, evaluates and persists a save's achievements. The sole writer of
/// the achievements table.
class AchievementService {
  AchievementService(this._ref);

  final Ref _ref;

  /// Deepest knockout round each nation reached (0 = group only) — mirrors the
  /// cup-detail screen so the World Cup Team of the Tournament matches.
  static const _roundDepth = {
    'R32': 1,
    'R16': 2,
    'QF': 3,
    'SF': 4,
    '3RD': 5,
    'FINAL': 5,
  };

  /// Re-evaluates every achievement, records any newly unlocked ones, and
  /// returns those newly unlocked (for the after-match popup). Newly-unlocked
  /// order follows the catalogue.
  Future<List<AchievementDef>> checkAndRecord(int careerId) async {
    final comp = _ref.read(competitionRepositoryProvider);
    final stats = await computeStats(careerId);
    if (stats == null) return const [];
    final earned = AchievementCatalog.earnedIds(stats);
    final stored = await comp.earnedAchievements(careerId);
    final fresh = earned.difference(stored);
    if (fresh.isEmpty) return const [];

    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    final year = career?.inGameDate.year ?? 0;
    final newly = <AchievementDef>[];
    for (final a in AchievementCatalog.all) {
      if (fresh.contains(a.id)) {
        await comp.recordAchievement(careerId, a.id, year);
        newly.add(a);
      }
    }
    return newly;
  }

  /// Builds the achievement stat snapshot for [careerId], or null if the save
  /// is gone.
  Future<AchievementStats?> computeStats(int careerId) async {
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return null;
    final nationId = career.nationId;
    final comp = _ref.read(competitionRepositoryProvider);
    final nations = {
      for (final n in await _ref.read(nationRepositoryProvider).all()) n.id: n,
    };

    final fixtures = await comp.fixturesForNation(careerId, nationId);
    var matches = 0;
    var wins = 0;
    var biggestMargin = 0;
    var reachedWc = false;
    var reachedCont = false;
    for (final f in fixtures) {
      if (f.round == 'GROUP') reachedWc = true;
      if (f.round == 'CGROUP') reachedCont = true;
      if (!f.hasResult) continue;
      final isHome = f.homeNationId == nationId;
      final my = isHome ? f.homeScore! : f.awayScore!;
      final other = isHome ? f.awayScore! : f.homeScore!;
      matches++;
      if (my > other) {
        wins++;
        if (my - other > biggestMargin) biggestMargin = my - other;
      }
    }

    // Titles: honour rows won by the player's nation DURING this career — the
    // pre-seeded real-world history (earlier years) must never count, or a
    // nation that won a real Euro/World Cup would unlock the title instantly.
    final honours = (await comp.honours(
      careerId,
    )).where((h) => CareerService.isOwnHonourYear(h.year)).toList();
    final titlesWon = {
      for (final h in honours)
        if (h.championId == nationId) h.competition,
    };
    // The manager's own confederation — every continent's cup is a competition
    // of the same kind, so anything read off "the continental finals" has to
    // name theirs or it answers for somebody else's tournament.
    final playerConfederation = nations[nationId]?.confederation;
    final ownContinental =
        ContinentalCups.byConfederation[playerConfederation]?.name;
    final wonWcAndCont =
        titlesWon.contains(worldCupHonourName) &&
        ownContinental != null &&
        titlesWon.contains(ownContinental);

    // World Cup marksman / golden boot (from the finals scorer charts).
    final wcScorers = await comp.topScorers(
      careerId,
      kind: CompetitionKind.worldCupFinals,
      limit: 500,
    );
    var wcMarksmanGoals = 0;
    for (final s in wcScorers) {
      if (s.nationId == nationId && s.goals > wcMarksmanGoals) {
        wcMarksmanGoals = s.goals;
      }
    }
    final contScorers = await comp.topScorers(
      careerId,
      kind: CompetitionKind.continentalFinals,
      confederation: playerConfederation,
      limit: 1,
    );
    // Only a FINISHED tournament crowns a top scorer — otherwise a mid-cup
    // scoring lead (e.g. after the group stage) would award the Golden Boot
    // prematurely. Gate each branch on its tournament being decided.
    final wcDecided = await comp.worldChampion(careerId) != null;
    final contDecided = await comp.allPlayedForKind(
      careerId,
      CompetitionKind.continentalFinals,
      confederation: playerConfederation,
    );
    final goldenBoot =
        (wcDecided &&
            wcScorers.isNotEmpty &&
            wcScorers.first.nationId == nationId) ||
        (contDecided &&
            contScorers.isNotEmpty &&
            contScorers.first.nationId == nationId);

    final allStar = await _playerInWorldAllStars(careerId, nationId, fixtures);
    final satisfaction = await _ref.read(satisfactionProvider(careerId).future);

    // The deeper record aggregates (streaks, clean sheets, player feats) come
    // from the shared career-stats snapshot — the same numbers the stats screen
    // shows, so an achievement can never disagree with the stat that earned it.
    final cs = await _ref.read(careerStatsProvider(careerId).future);

    return AchievementStats(
      matchesPlayed: matches,
      wins: wins,
      reachedWorldCup: reachedWc,
      reachedContinental: reachedCont,
      titlesWon: titlesWon,
      biggestWinMargin: cs.biggestWinMargin > biggestMargin
          ? cs.biggestWinMargin
          : biggestMargin,
      wcMarksmanGoals: wcMarksmanGoals,
      hasChampionshipGoldenBoot: goldenBoot,
      playerInAllStars: allStar,
      wonWorldCupAndContinental: wonWcAndCont,
      satisfaction: satisfaction,
      cleanSheets: cs.cleanSheets,
      totalGoals: cs.goalsFor,
      longestWinStreak: cs.longestWinStreak,
      longestUnbeatenRun: cs.longestUnbeatenRun,
      hatTricks: cs.hatTricks,
      playerMotms: cs.playerMotms,
      shootoutsWon: cs.shootoutsWon,
      bestPlayerRating: cs.bestPlayerRating,
    );
  }

  /// Whether a player of [nationId] is in the current World Cup finals Team of
  /// the Tournament. Only computed once a champion exists and the nation went
  /// deep (reached the quarter-finals) — both to bound the squad loads and
  /// because a shallow run almost never places a player in the XI.
  Future<bool> _playerInWorldAllStars(
    int careerId,
    int nationId,
    List<Fixture> playerFixtures,
  ) async {
    final comp = _ref.read(competitionRepositoryProvider);
    final champion = await comp.worldChampion(careerId);
    if (champion == null) return false;
    const deep = {'QF', 'SF', '3RD', 'FINAL'};
    final reachedQf = playerFixtures.any(
      (f) => f.hasResult && deep.contains(f.round),
    );
    if (!reachedQf) return false;

    final knockout = await comp.finalsKnockoutFixtures(careerId);
    if (knockout.isEmpty) return false;
    final runByNation = <int, int>{};
    for (final f in knockout) {
      final d = _roundDepth[f.round] ?? 0;
      for (final nid in [f.homeNationId, f.awayNationId]) {
        if (d > (runByNation[nid] ?? 0)) runByNation[nid] = d;
      }
    }
    final scorers = await comp.topScorers(
      careerId,
      kind: CompetitionKind.worldCupFinals,
      limit: 500,
    );
    final goalsByPlayer = {for (final s in scorers) s.playerId: s.goals};
    final candidateNations = <int>{
      for (final n in runByNation.keys) n,
      for (final s in scorers) s.nationId,
    };
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    final playerRepo = _ref.read(playerRepositoryProvider);
    final candidates = <Player>[];
    for (final nid in candidateNations) {
      final squad = await playerRepo.byNation(
        nid,
        agingYears: career == null ? 0 : CareerService.agingYears(career),
        saveSeed: career?.rngSeed ?? 0,
      );
      candidates.addAll(squad.take(16));
    }
    final team = TournamentStars.teamOfTournament(
      candidates: candidates,
      goalsByPlayer: goalsByPlayer,
      runByNation: runByNation,
      champion: champion,
    );
    return team.any((s) => s.nationId == nationId);
  }
}

final Provider<AchievementService> achievementServiceProvider =
    Provider<AchievementService>(AchievementService.new);

/// One row on the achievements screen: the definition, whether it's unlocked,
/// and its progress (for tally achievements).
typedef AchievementView = ({
  AchievementDef def,
  bool earned,
  int? current,
  int? target,
});

/// The full achievements list for the screen, grouped by category, reconciling
/// (and persisting) any newly-earned achievements when opened. Earned status is
/// the sticky union of stored unlocks and what the current stats satisfy.
final AutoDisposeFutureProviderFamily<List<AchievementView>, int>
achievementsViewProvider = FutureProvider.autoDispose
    .family<List<AchievementView>, int>((
      ref,
      careerId,
    ) async {
      final service = ref.watch(achievementServiceProvider);
      await service.checkAndRecord(careerId); // reconcile + persist
      final stats = await service.computeStats(careerId);
      final stored = await ref
          .watch(competitionRepositoryProvider)
          .earnedAchievements(careerId);
      return [
        for (final a in AchievementCatalog.all)
          () {
            final earned =
                stored.contains(a.id) || (stats != null && a.isEarned(stats));
            final p = stats == null ? null : a.progressOf?.call(stats);
            return (
              def: a,
              earned: earned,
              current: p?.$1,
              target: p?.$2,
            );
          }(),
      ];
    });
