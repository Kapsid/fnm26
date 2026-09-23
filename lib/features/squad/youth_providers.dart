import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';

/// A nation's youth pyramid: who is at each level, and who left this year.
typedef YouthPyramid = ({
  Map<YouthLevel, List<Prospect>> byLevel,
  Map<YouthLevel, List<String>> releasedByLevel,
});

/// The five youth levels, each ranked by promise, plus the boys released out of
/// each level this year — so a departure is seen rather than silent.
final AutoDisposeFutureProviderFamily<YouthPyramid, int>
youthPyramidProvider = FutureProvider.autoDispose.family<YouthPyramid, int>((
  ref,
  careerId,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  final empty = (
    byLevel: <YouthLevel, List<Prospect>>{},
    releasedByLevel: <YouthLevel, List<String>>{},
  );
  if (career == null) return empty;
  final repo = ref.watch(playerRepositoryProvider);
  final years = CareerService.agingYears(career);
  final youth = await ref.watch(youthBonusByCycleProvider(careerId).future);
  final starts = await ref.watch(careerDevBonusProvider(careerId).future);

  Future<List<Player>> pyramidAt(int at) => repo.youthByNation(
    career.nationId,
    agingYears: at,
    saveSeed: career.rngSeed,
    youthBonusByCycle: youth,
    careerStartsByPlayer: starts,
  );

  final now = await pyramidAt(years);
  final before = years <= 0 ? const <Player>[] : await pyramidAt(years - 1);
  final caps = {
    for (final c
        in await ref
            .watch(competitionRepositoryProvider)
            .nationTopAppearances(careerId, career.nationId, limit: 500))
      c.playerId: c.games,
  };

  final byLevel = <YouthLevel, List<Prospect>>{};
  for (final level in YouthLevel.values) {
    final atLevel = [
      for (final p in now)
        if (YouthLevel.forAge(p.age) == level) p,
    ];
    byLevel[level] = Prospects.watchlist(
      atLevel,
      previousPool: before,
      capsByPlayer: caps,
    );
  }

  // Released this year: in last year's pyramid, gone from this one, and gone
  // because he was let go rather than because he turned twenty-one.
  final present = {for (final p in now) p.id};
  final releasedByLevel = <YouthLevel, List<String>>{};
  for (final p in before) {
    if (present.contains(p.id)) continue;
    if (!PlayerLifecycle.isReleasedBy(p.id, p.age + 1)) continue;
    final level = YouthLevel.forAge(p.age);
    if (level == null) continue;
    (releasedByLevel[level] ??= []).add(p.name);
  }
  return (byLevel: byLevel, releasedByLevel: releasedByLevel);
});
