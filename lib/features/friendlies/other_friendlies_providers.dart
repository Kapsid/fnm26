import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';

/// One other nation's friendly result shown alongside the player's own.
typedef FriendlyResult = ({
  int homeId,
  int awayId,
  int homeScore,
  int awayScore,
});

/// The number of other friendlies to fill the international window with.
const _friendlyCount = 8;

/// Other nations' friendly results for the window the player just played their
/// friendly in — deterministically generated (never persisted) so the friendly
/// results screen isn't empty. Returns an empty list when the player's most
/// recent match wasn't a friendly.
final AutoDisposeFutureProviderFamily<List<FriendlyResult>, int>
    otherFriendliesProvider =
    FutureProvider.autoDispose.family<List<FriendlyResult>, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return const [];
  final comp = ref.watch(competitionRepositoryProvider);
  final fixtures = await comp.fixturesForNation(careerId, career.nationId);

  // The player's most recent played match must be a friendly.
  final played = fixtures.where((f) => f.hasResult).toList()
    ..sort((a, b) => b.date.compareTo(a.date));
  if (played.isEmpty || played.first.round != 'FRIENDLY') return const [];
  final last = played.first;
  final opponentId = last.homeNationId == career.nationId
      ? last.awayNationId
      : last.homeNationId;

  final nations = await ref.watch(nationRepositoryProvider).all();
  final eligible = [
    for (final n in nations)
      if (n.id != career.nationId && n.id != opponentId) n,
  ];
  if (eligible.length < 2) return const [];

  // Deterministic from the save seed and the window (year/month), so the same
  // set is shown every time this friendly's results are viewed.
  final windowKey = last.date.year * 13 + last.date.month;
  final rng = SeededRng(career.rngSeed ^ (windowKey * 0x9E3D));
  final pool = rng.shuffled(eligible);
  final pairs = (pool.length ~/ 2).clamp(0, _friendlyCount);

  const sim = RatingMatchSimulator();
  final results = <FriendlyResult>[];
  for (var i = 0; i < pairs; i++) {
    final home = pool[i * 2];
    final away = pool[i * 2 + 1];
    final matchRng = SeededRng(rng.nextInt(1 << 30) ^ (i * 0x51ED));
    final out = sim.simulate(
      homeStrength: RatingMatchSimulator.strengthOf(home),
      awayStrength: RatingMatchSimulator.strengthOf(away),
      rng: matchRng,
    );
    results.add((
      homeId: home.id,
      awayId: away.id,
      homeScore: out.homeScore,
      awayScore: out.awayScore,
    ));
  }
  return results;
});
