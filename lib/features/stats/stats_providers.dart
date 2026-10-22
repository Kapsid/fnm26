import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/stats/career_stats.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/career_pool.dart';
import 'package:fnm/features/federation/federation_providers.dart';

/// Finals-tournament rounds — played at a neutral venue. Qualifiers (round null
/// or `CQ`) and friendlies are home-and-away, so they don't appear here.
const _finalsRounds = {
  'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL', //
  'CGROUP', 'CR16', 'CQF', 'CSF', 'C3RD', 'CFINAL', //
  'NGROUP', 'NR16', 'NQF', 'NSF', 'NFINAL',
};

/// The manager's whole-career [CareerStatsSnapshot], built from every match any
/// of their nations played (a career can span several after job switches). The
/// heavy lifting is the pure [CareerStats.compute]; this just gathers the rows.
final AutoDisposeFutureProviderFamily<CareerStatsSnapshot, int>
careerStatsProvider = FutureProvider.autoDispose.family<CareerStatsSnapshot, int>((
  ref,
  careerId,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final careerRepo = ref.watch(careerRepositoryProvider);
  final career = await careerRepo.byId(careerId);
  if (career == null) return const CareerStatsSnapshot();
  final comp = ref.watch(competitionRepositoryProvider);

  // Every nation the manager has led (their current one plus any earlier
  // stints), so a match counts as theirs whichever nation they had at the time.
  final stints = await careerRepo.stints(careerId);
  final managed = {career.nationId, ...stints.values};

  // Goal-by-goal, so a win can be told apart from a win from behind.
  final timeline = await comp.goalTimeline(careerId);

  final matches = <ManagerMatch>[];
  for (final f in await comp.allFixtures(careerId)) {
    if (!f.hasResult) continue;
    final homeManaged = managed.contains(f.homeNationId);
    final awayManaged = managed.contains(f.awayNationId);
    if (!homeManaged && !awayManaged) continue;
    // If (rarely) the manager led both sides across different stints, take the
    // home view — the split still balances out across the career.
    final iAmHome = homeManaged;
    final my = iAmHome ? f.homeScore! : f.awayScore!;
    final opp = iAmHome ? f.awayScore! : f.homeScore!;
    final neutral = _finalsRounds.contains(f.round);
    final wonShootout =
        f.wentToShootout &&
        (iAmHome
            ? f.homePenalties! > f.awayPenalties!
            : f.awayPenalties! > f.homePenalties!);
    final lostShootout = f.wentToShootout && !wonShootout;

    matches.add((
      date: f.date,
      nationId: iAmHome ? f.homeNationId : f.awayNationId,
      goalsFor: my,
      goalsAgainst: opp,
      competitive: f.round != 'FRIENDLY',
      home: iAmHome && !neutral,
      neutral: neutral,
      wonShootout: wonShootout,
      lostShootout: lostShootout,
      trailed: _everTrailed(
        timeline[f.id],
        mineId: iAmHome ? f.homeNationId : f.awayNationId,
      ),
    ));
  }

  // Player feats come from the manager's own players' rating lines (rating rows
  // are only stored for the manager's matches, so filtering by their nations
  // gives their squad's feats).
  final lines = [
    for (final l in await comp.careerPlayerLines(careerId, managed))
      (
        playerId: l.playerId,
        goals: l.goals,
        assists: l.assists,
        rating: l.rating,
        motm: l.motm,
        yellows: l.yellows,
        reds: l.reds,
      ),
  ];

  return CareerStats.compute(matches, lines);
});

/// Whether the side [mineId] was behind at any point of a match, from its
/// goal [timeline].
///
/// Goals arrive minute-ordered, so this just replays the scoreboard. A match
/// with no recorded goals never trailed — which is right for a goalless draw
/// and safe for anything whose timeline was never captured: a comeback is
/// claimed only when the evidence for it exists.
bool _everTrailed(
  List<({int nationId, int playerId, int minute})>? timeline, {
  required int mineId,
}) {
  if (timeline == null || timeline.isEmpty) return false;
  var mine = 0;
  var theirs = 0;
  for (final g in timeline) {
    if (g.nationId == mineId) {
      mine++;
    } else {
      theirs++;
    }
    if (theirs > mine) return true;
  }
  return false;
}

/// One year of a nation's strength.
typedef TeamOverallPoint = ({int year, int overall});

/// How good the nation has been, year by year.
///
/// Derived, never stored: a player is a function of seed and year, so the whole
/// curve is recomputed from the pool as it stood each season. That is also why
/// it is honest — it is the same number the match preview shows, read back
/// through time rather than a running total somebody remembered to write down.
final AutoDisposeFutureProviderFamily<List<TeamOverallPoint>, int>
teamOverallHistoryProvider = FutureProvider.autoDispose
    .family<List<TeamOverallPoint>, int>((ref, careerId) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return const [];
      final repo = ref.watch(playerRepositoryProvider);
      final years = CareerService.agingYears(career);
      final youth = await ref.watch(youthBonusByCycleProvider(careerId).future);
      final starts = await ref.watch(careerDevBonusProvider(careerId).future);

      // A man naturalised away from the nation is not counted in its curve,
      // as he is in none of its pools (see `careerPoolOf`).
      final away = await naturalizedAwayIds(
        ref.watch(careerRepositoryProvider),
        careerId,
      );
      final out = <TeamOverallPoint>[];
      for (var y = 0; y <= years; y++) {
        final pool = dropNaturalizedAway(
          await repo.byNation(
            career.nationId,
            agingYears: y,
            saveSeed: career.rngSeed,
            careerId: career.id,
            youthBonusByCycle: youth,
            careerStartsByPlayer: starts,
          ),
          away,
        );
        if (pool.isEmpty) continue;
        out.add((
          year: CareerService.cycleStart.year + y,
          overall: squadOverall(pool),
        ));
      }
      return out;
    });

/// One player's line on a team leaderboard: who, and his tally.
typedef TeamStatEntry = ({int playerId, int value});

/// One player's line on the team's ratings board.
typedef TeamRatingEntry = ({
  int playerId,
  int apps,
  double meanRating,
  int motms,
});

/// The team records page's data: the manager's nation, its three all-time
/// boards, the name of everyone on them, and which of them still play.
typedef TeamStatsData = ({
  Nation? nation,
  List<TeamStatEntry> scorers,
  List<TeamStatEntry> appearances,
  List<TeamRatingEntry> ratings,
  Map<int, String> names,
  Set<int> active,
});

/// The team records (`/team-stats`) of the nation managed in career `careerId`.
///
/// Moved here from the screen, unchanged, so the sim's cascade can refresh
/// it (`SeasonService._invalidateTeamViews`): it reads the goals, the caps and
/// the ratings imperatively, and a tablet keeps the page on show while the
/// top bar's Continue runs a step.
final AutoDisposeFutureProviderFamily<TeamStatsData?, int> teamStatsProvider =
    FutureProvider.autoDispose.family<TeamStatsData?, int>((
      ref,
      careerId,
    ) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final comp = ref.watch(competitionRepositoryProvider);
      final nationId = career.nationId;

      final scorers = [
        for (final s in await comp.nationTopScorers(
          careerId,
          nationId,
          limit: 25,
        ))
          (playerId: s.playerId, value: s.goals),
      ];
      final appearances = [
        for (final a in await comp.nationTopAppearances(
          careerId,
          nationId,
          limit: 25,
        ))
          (playerId: a.playerId, value: a.games),
      ];
      // Best average match rating. Every match in the world is rated now, so
      // this is a full record rather than only the games the manager was in
      // charge for.
      final ratings = await comp.nationTopRatings(
        careerId,
        nationId,
        limit: 25,
      );

      final playerRepo = ref.watch(playerRepositoryProvider);
      final aging = CareerService.agingYears(career);
      final youth = await ref.watch(
        youthBonusByCycleProvider(careerId).future,
      );
      final careerDev = await ref.watch(
        careerDevBonusProvider(careerId).future,
      );
      final ids = {
        for (final s in [...scorers, ...appearances]) s.playerId,
        for (final r in ratings) r.playerId,
      };
      final names = <int, String>{};
      // Who on these all-time boards is still playing — the same rule the
      // pool retires on, so a chart-topper you could still pick stands apart
      // from the legends above and below him.
      final active = <int>{};
      for (final id in ids) {
        final p = await playerRepo.byId(
          id,
          agingYears: aging,
          saveSeed: career.rngSeed,
          careerId: career.id,
          youthBonusByCycle: youth,
          careerStartsByPlayer: careerDev,
        );
        names[id] = p?.name ?? 'Unknown';
        if (p != null && !PlayerLifecycle.hasRetiredAt(p.id, p.age, aging)) {
          active.add(id);
        }
      }

      final nations = await ref.watch(nationRepositoryProvider).all();
      return (
        nation: nations.where((n) => n.id == nationId).firstOrNull,
        scorers: scorers,
        appearances: appearances,
        ratings: ratings,
        names: names,
        active: active,
      );
    });
