import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';

/// The board's expectation for the current cycle, and — once the World Cup is
/// decided — whether it was met. Fully DERIVED (no storage): the target comes
/// from the nation's world rank, the outcome from this cycle's World Cup finish.
typedef CycleObjective = ({
  /// e.g. "Reach the quarter-finals".
  String label,

  /// Ordinal target (2 qualify … 7 win it), for comparison.
  int target,

  /// Whether this cycle's World Cup has finished (so the objective is graded).
  bool decided,

  /// Whether the nation met (or beat) the target — only meaningful once decided.
  bool met,

  /// The nation's actual finish, e.g. "Quarter-finals" / "Did not qualify".
  String resultLabel,
});

/// The board objective for [careerId]'s current cycle.
final AutoDisposeFutureProviderFamily<CycleObjective?, int>
    cycleObjectiveProvider =
    FutureProvider.autoDispose.family<CycleObjective?, int>(
        (ref, careerId) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  final ranking = await ref.watch(worldRankingProvider(careerId).future);
  final rank = ranking?.position[career.nationId] ?? 50;
  final target = _targetOrdinal(rank);

  final fixtures = await comp.fixturesForNation(careerId, career.nationId);
  final champion = await comp.worldChampion(careerId);
  final actual = _wcFinishOrdinal(fixtures, champion, career.nationId);

  return (
    label: _labelFor(target),
    target: target,
    decided: champion != null,
    met: champion != null && actual >= target,
    resultLabel: _resultLabel(actual),
  );
});

/// What the board demands, by world rank — a heavyweight is told to win it, a
/// minnow just to be there.
int _targetOrdinal(int rank) {
  if (rank <= 2) return 7; // win it
  if (rank <= 6) return 6; // reach the final
  if (rank <= 12) return 5; // semi-finals
  if (rank <= 20) return 4; // quarter-finals
  if (rank <= 32) return 3; // knockouts
  return 2; // qualify
}

String _labelFor(int target) => switch (target) {
      7 => 'Win the World Cup',
      6 => 'Reach the World Cup final',
      5 => 'Reach the semi-finals',
      4 => 'Reach the quarter-finals',
      3 => 'Reach the knockout rounds',
      _ => 'Qualify for the World Cup',
    };

/// The nation's deepest World Cup finish this cycle as an ordinal (0 = did not
/// qualify, 2 = group stage … 7 = champions).
int _wcFinishOrdinal(List<Fixture> fixtures, int? champion, int nationId) {
  if (champion == nationId) return 7;
  var best = 0;
  for (final f in fixtures) {
    if (!f.hasResult) continue;
    final ord = switch (f.round) {
      'FINAL' => 6,
      '3RD' || 'SF' => 5,
      'QF' => 4,
      'R16' || 'R32' => 3,
      'GROUP' => 2,
      _ => 0,
    };
    if (ord > best) best = ord;
  }
  return best;
}

String _resultLabel(int ordinal) => switch (ordinal) {
      7 => 'Champions',
      6 => 'Runners-up',
      5 => 'Semi-finals',
      4 => 'Quarter-finals',
      3 => 'Round of 16',
      2 => 'Group stage',
      _ => 'Did not qualify',
    };
