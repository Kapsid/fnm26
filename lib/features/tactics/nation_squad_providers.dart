import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';

/// One player of the nation, as the squad screen needs them: who they are, what
/// they have done for the country, and where they stand right now.
typedef NationSquadRow = ({
  Player player,

  /// International appearances for this nation in this save.
  int caps,

  /// International goals.
  int goals,

  /// Whether they are in the current call-up list.
  bool calledUp,

  /// Whether they are in the starting XI as it stands.
  bool starting,
  PlayerAbsence? absence,
  PlayerCondition? condition,
});

/// The whole national pool with its record, plus the summary figures that
/// describe it.
class NationSquadData {
  const NationSquadData({
    required this.rows,
    required this.calledUp,
    required this.saveSeed,
  });

  /// Every player eligible for the nation, best-rated first.
  final List<NationSquadRow> rows;

  /// How many of them are currently called up.
  final int calledUp;

  /// The save seed, so derived traits read the same as everywhere else.
  final int saveSeed;

  int get size => rows.length;

  double get averageAge => rows.isEmpty
      ? 0
      : rows.fold<int>(0, (s, r) => s + r.player.age) / rows.length;

  /// The most-capped player in the pool, or null before anyone has played.
  NationSquadRow? get mostCapped {
    NationSquadRow? best;
    for (final r in rows) {
      if (r.caps > 0 && (best == null || r.caps > best.caps)) best = r;
    }
    return best;
  }

  /// The leading scorer in the pool, or null before anyone has scored.
  NationSquadRow? get topScorer {
    NationSquadRow? best;
    for (final r in rows) {
      if (r.goals > 0 && (best == null || r.goals > best.goals)) best = r;
    }
    return best;
  }
}

/// Everyone eligible for the manager's nation — not just the named squad.
///
/// The squad tab used to list only the players already called up, which told
/// the manager what they had already decided. The question a squad screen has
/// to answer is who is OUT there: the whole pool, what each has done for the
/// country, and who is in the reckoning.
final AutoDisposeFutureProviderFamily<NationSquadData?, int>
nationSquadProvider =
    FutureProvider.autoDispose.family<NationSquadData?, int>((
  ref,
  careerId,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;

  final pool = [
    ...await ref.watch(playerRepositoryProvider).byNation(
          career.nationId,
          agingYears: CareerService.agingYears(career),
          saveSeed: career.rngSeed,
          youthBonusByCycle:
              await ref.watch(youthBonusByCycleProvider(careerId).future),
          careerStartsByPlayer:
              await ref.watch(careerDevBonusProvider(careerId).future),
        ),
    ...await naturalizedPlayersFor(ref, career),
  ]..sort((a, b) => b.overall.compareTo(a.overall));

  final comp = ref.watch(competitionRepositoryProvider);
  // The whole pool, not a top-N leaderboard — every player gets their own line,
  // so the limits are the pool size rather than a records-screen cut-off.
  final apps = await comp.nationTopAppearances(
    careerId,
    career.nationId,
    limit: pool.length + 50,
  );
  final scorers = await comp.nationTopScorers(
    careerId,
    career.nationId,
    limit: pool.length + 50,
  );
  final capsById = {for (final a in apps) a.playerId: a.games};
  final goalsById = {for (final s in scorers) s.playerId: s.goals};

  final calledUp = await ref.watch(squadRepositoryProvider).callUps(careerId);
  // No explicit selection yet means the whole pool is available (see
  // SquadRepository) — so nobody is singled out as "in the squad".
  final inSquad = calledUp.isEmpty ? const <int>{} : calledUp;
  final tactic = await ref
      .watch(tacticsRepositoryProvider)
      .tacticForCareer(careerId);
  final starting = (tactic?.lineup ?? const <int?>[]).whereType<int>().toSet();
  final absences =
      await ref.watch(absenceRepositoryProvider).forCareer(careerId);
  final conditions = await ref.watch(squadConditionProvider(careerId).future);

  return NationSquadData(
    rows: [
      for (final p in pool)
        (
          player: p,
          caps: capsById[p.id] ?? 0,
          goals: goalsById[p.id] ?? 0,
          calledUp: inSquad.contains(p.id),
          starting: starting.contains(p.id),
          absence: absences[p.id],
          condition: conditions[p.id],
        ),
    ],
    calledUp: inSquad.length,
    saveSeed: career.rngSeed,
  );
});
