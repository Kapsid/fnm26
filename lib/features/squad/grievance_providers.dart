import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/squad/grievances.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';

/// The prefix a walkout message is keyed with. The ANNOUNCEMENT IS THE RECORD:
/// a permanent retirement needs a persisted fact, and a new table would cost
/// the player their save, so the inbox row that tells them it happened is what
/// the game reads back.
const String walkoutKeyPrefix = 'walkout:';

/// Players who have walked away from international football in this career.
///
/// Read from the inbox rather than a table of its own — see [walkoutKeyPrefix].
final AutoDisposeFutureProviderFamily<Set<int>, int> walkoutsProvider =
    FutureProvider.autoDispose.family<Set<int>, int>((ref, careerId) async {
      final keys = await ref
          .watch(competitionRepositoryProvider)
          .messageKeys(
            careerId,
          );
      return {
        for (final k in keys)
          if (k.startsWith(walkoutKeyPrefix))
            int.tryParse(k.substring(walkoutKeyPrefix.length)) ?? -1,
      }..remove(-1);
    });

/// How each squad member stands: whether he is picked, and whether he plays.
typedef _Standing = ({
  List<SquadStanding> standings,
  Map<int, int> poolRank,
  Map<int, int> longAbsence,
  int year,
  bool squadNamed,
});

final AutoDisposeFutureProviderFamily<_Standing?, int>
_standingProvider = FutureProvider.autoDispose.family<_Standing?, int>((
  ref,
  careerId,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);

  final pool =
      await ref
            .watch(playerRepositoryProvider)
            .byNation(
              career.nationId,
              agingYears: CareerService.agingYears(career),
              saveSeed: career.rngSeed,
              youthBonusByCycle: await ref.watch(
                youthBonusByCycleProvider(careerId).future,
              ),
              careerStartsByPlayer: await ref.watch(
                careerDevBonusProvider(careerId).future,
              ),
            )
        ..sort((a, b) => b.overall.compareTo(a.overall));
  if (pool.isEmpty) return null;

  final callUps = await ref.watch(squadRepositoryProvider).callUps(careerId);
  final caps = {
    for (final c in await comp.nationTopAppearances(
      careerId,
      career.nationId,
      limit: 500,
    ))
      c.playerId: c.games,
  };

  // The nation's most recent played matches, and who turned out in them.
  final fixtures = await comp.fixturesForNation(careerId, career.nationId);
  final played = [
    for (final f in fixtures)
      if (f.hasResult) f,
  ]..sort((a, b) => b.date.compareTo(a.date));
  final recentDates = {
    for (final f in played.take(Grievances.recentWindow)) f.date,
  };
  // Twice the window: a man missing from THIS many is not being rotated, he is
  // being ignored, and that is what turns a grievance into a walkout.
  final longDates = {
    for (final f in played.take(Grievances.recentWindow * 2)) f.date,
  };
  final ratings = await comp.recentRatingsByNation(careerId, career.nationId);
  int appearances(int playerId, Set<DateTime> within) =>
      (ratings[playerId] ?? const [])
          .where((r) => within.contains(r.date))
          .length;

  final rank = <int, int>{};
  for (var i = 0; i < pool.length; i++) {
    rank[pool[i].id] = i + 1;
  }
  final walked = await ref.watch(walkoutsProvider(careerId).future);

  return (
    standings: [
      for (final p in pool)
        if (!walked.contains(p.id))
          (
            playerId: p.id,
            playerName: p.name,
            age: p.age,
            caps: caps[p.id] ?? 0,
            overall: p.overall,
            calledUp: callUps.contains(p.id),
            recentAppearances: appearances(p.id, recentDates),
          ),
    ],
    poolRank: rank,
    longAbsence: {
      for (final p in pool) p.id: appearances(p.id, longDates),
    },
    year: career.inGameDate.year,
    // Before the manager has ever named a squad, an empty call-up list reads
    // as everybody having been dropped — and the entire country turns up at
    // the office on day one. Nobody may resent a team that does not exist yet.
    squadNamed: callUps.isNotEmpty,
  );
});

/// Players who want a word — at most two, most senior first.
final AutoDisposeFutureProviderFamily<List<Grievance>, int>
grievanceProvider = FutureProvider.autoDispose.family<List<Grievance>, int>((
  ref,
  careerId,
) async {
  final standing = await ref.watch(_standingProvider(careerId).future);
  if (standing == null) return const [];
  final answered = {
    for (final a
        in await ref.watch(careerRepositoryProvider).pressAnswers(careerId))
      a.questionKey,
  };
  // How many have already had their word this year — a season gets a couple of
  // these, not one every window.
  final thisYear = answered
      .where((k) => k.startsWith('grv:') && k.endsWith(':${standing.year}'))
      .length;
  return Grievances.raise(
    standing.standings,
    poolRank: standing.poolRank,
    year: standing.year,
    squadNamed: standing.squadNamed,
    raisedThisYear: thisYear,
    alreadyRaised: answered,
  );
});

/// What the dressing room loses to men who have been left to stew.
final AutoDisposeFutureProviderFamily<int, int> grievanceMoraleProvider =
    FutureProvider.autoDispose.family<int, int>((ref, careerId) async {
      final open = await ref.watch(grievanceProvider(careerId).future);
      return open.length * Grievances.ignoredMoraleCost;
    });

/// Answers a player, and settles anybody who has been ignored too long.
class GrievanceService {
  GrievanceService(this._ref);

  final Ref _ref;

  /// Records the manager's answer. Stored in the press-answer table under the
  /// grievance's own key, so nothing new is persisted and no save is wiped.
  Future<void> answer(
    int careerId,
    Grievance grievance,
    GrievanceTone tone,
  ) async {
    final repo = _ref.read(careerRepositoryProvider);
    final career = await repo.byId(careerId);
    if (career == null) return;
    final effect = Grievances.effectOf(tone);
    await repo.recordPressAnswer(
      careerId: careerId,
      cycle: career.cyclePointer,
      questionKey: grievance.key,
      tone: tone.name,
      moraleDelta: effect.morale,
      boardDelta: effect.board,
      answeredAt: career.inGameDate,
    );
    _ref
      ..invalidate(grievanceProvider)
      ..invalidate(grievanceMoraleProvider);
  }

  /// Lets go of anybody who has been ignored past his patience.
  ///
  /// Writes the inbox message that announces it — which is also the record the
  /// game reads back, so a walkout survives a reload without a new table.
  Future<void> settleWalkouts(int careerId) async {
    final standing = await _ref.read(_standingProvider(careerId).future);
    if (standing == null) return;
    final open = await _ref.read(grievanceProvider(careerId).future);
    if (open.isEmpty) return;
    final comp = _ref.read(competitionRepositoryProvider);
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return;

    for (final g in open) {
      final ignoredLong = (standing.longAbsence[g.playerId] ?? 1) == 0;
      if (!ignoredLong) continue;
      if (!Grievances.walksOut(
        age: g.age,
        windows: Grievances.walkoutPatience,
      )) {
        continue;
      }
      await comp.addMessage(
        careerId: careerId,
        dedupKey: '$walkoutKeyPrefix${g.playerId}',
        category: 'retirement',
        title: '${g.playerName} walks away',
        body:
            '${g.playerName} has retired from international football at '
            '${g.age}, with ${g.caps} caps. He asked to be told where he '
            'stood and was not, and he is not waiting any longer.',
        year: career.inGameDate.year,
      );
    }
    _ref
      ..invalidate(walkoutsProvider)
      ..invalidate(grievanceProvider);
  }
}

final Provider<GrievanceService> grievanceServiceProvider = Provider(
  GrievanceService.new,
);
