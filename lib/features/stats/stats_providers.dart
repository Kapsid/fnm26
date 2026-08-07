import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/stats/career_stats.dart';

/// Finals-tournament rounds — played at a neutral venue. Qualifiers (round null
/// or `CQ`) and friendlies are home-and-away, so they don't appear here.
const _finalsRounds = {
  'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL', //
  'CGROUP', 'CR16', 'CQF', 'CSF', 'C3RD', 'CFINAL', //
  'NGROUP', 'NSF', 'NFINAL',
};

/// The manager's whole-career [CareerStatsSnapshot], built from every match any
/// of their nations played (a career can span several after job switches). The
/// heavy lifting is the pure [CareerStats.compute]; this just gathers the rows.
final AutoDisposeFutureProviderFamily<CareerStatsSnapshot, int>
    careerStatsProvider =
    FutureProvider.autoDispose.family<CareerStatsSnapshot, int>((
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
    final wonShootout = f.wentToShootout &&
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
  List<({int nationId, int minute})>? timeline, {
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
