import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/squad/youth_watch_providers.dart';

/// A nation's youth pyramid: who is at each level, and who left this year.
typedef YouthPyramid = ({
  Map<YouthLevel, List<Prospect>> byLevel,
  Map<YouthLevel, List<String>> releasedByLevel,

  /// The save's aging year, so a boy marked from this screen is marked with the
  /// year his rating was read in.
  int years,
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
    years: 0,
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
      scout: career.staffScout,
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
  return (
    byLevel: byLevel,
    releasedByLevel: releasedByLevel,
    years: years,
  );
});

/// What has become of a boy the manager marked.
///
/// The pyramid is DERIVED, not stored, so a marked boy can simply stop being in
/// it — let go at fourteen, or twenty-one and a senior. A watchlist that let him
/// vanish without a word would be worse than not having him on it.
enum WatchedStatus {
  /// Still in the pyramid, still developing.
  following,

  /// Out of the top of the pyramid and into the senior pool.
  senior,

  /// Let go by the academy.
  released,

  /// Gone for neither reason: retired early, or a save that no longer derives
  /// him at all.
  gone,
}

/// One line of the shortlist: the mark, and the boy as he is now.
typedef WatchedBoy = ({
  YouthMark mark,
  WatchedStatus status,

  /// Him as he is TODAY, or null when he can no longer be found.
  Player? player,

  /// International caps so far, 0 for a boy nobody has seen.
  int caps,

  /// The scouting read on his ceiling, or 0 when he cannot be found.
  int stars,

  /// Whether that read is the truth rather than an estimate.
  bool certain,
});

/// The boys this save is following, resolved against today's pools.
///
/// Ordered as a manager reads them: the ones still coming through (best first),
/// then the one who has made it to the seniors, then the ones who are gone.
final AutoDisposeFutureProviderFamily<List<WatchedBoy>, int>
youthShortlistProvider = FutureProvider.autoDispose
    .family<List<WatchedBoy>, int>((
      ref,
      careerId,
    ) async {
      final marks = await ref.watch(youthMarksProvider(careerId).future);
      if (marks.isEmpty) return const [];
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return const [];
      final years = CareerService.agingYears(career);
      final pyramid = await ref.watch(youthPyramidProvider(careerId).future);
      final inPyramid = <int, Prospect>{
        for (final level in pyramid.byLevel.values)
          for (final p in level) p.player.id: p,
      };

      // Only load the senior pool if somebody has actually aged out of the
      // pyramid — most watchlists never need it, and it is the heaviest read
      // on the screen.
      final grownUp = marks.any(
        (m) =>
            !inPyramid.containsKey(m.playerId) &&
            m.age + (years - m.year) > YouthLevel.u21.maxAge,
      );
      final seniors = <int, Player>{};
      var capsById = const <int, int>{};
      if (grownUp) {
        final repo = ref.watch(playerRepositoryProvider);
        for (final p in await repo.byNation(
          career.nationId,
          agingYears: years,
          saveSeed: career.rngSeed,
          youthBonusByCycle: await ref.watch(
            youthBonusByCycleProvider(careerId).future,
          ),
          careerStartsByPlayer: await ref.watch(
            careerDevBonusProvider(careerId).future,
          ),
        )) {
          seniors[p.id] = p;
        }
        capsById = {
          for (final c
              in await ref
                  .watch(competitionRepositoryProvider)
                  .nationTopAppearances(careerId, career.nationId, limit: 500))
            c.playerId: c.games,
        };
      }

      final out = <WatchedBoy>[];
      for (final m in marks) {
        final prospect = inPyramid[m.playerId];
        if (prospect != null) {
          out.add((
            mark: m,
            status: WatchedStatus.following,
            player: prospect.player,
            caps: prospect.caps,
            stars: prospect.stars,
            certain: prospect.certain,
          ));
          continue;
        }
        final ageNow = m.age + (years - m.year);
        final senior = seniors[m.playerId];
        if (senior != null) {
          final caps = capsById[m.playerId] ?? 0;
          final read = Prospects.read(
            senior.id,
            age: senior.age,
            caps: caps,
            scout: career.staffScout,
          );
          out.add((
            mark: m,
            status: WatchedStatus.senior,
            player: senior,
            caps: caps,
            stars: read.stars,
            certain: read.certain,
          ));
          continue;
        }
        out.add((
          mark: m,
          status: PlayerLifecycle.isReleasedBy(m.playerId, ageNow)
              ? WatchedStatus.released
              : WatchedStatus.gone,
          player: null,
          caps: 0,
          stars: 0,
          certain: false,
        ));
      }
      out.sort((a, b) {
        final byStatus = a.status.index.compareTo(b.status.index);
        if (byStatus != 0) return byStatus;
        return (b.player?.overall ?? 0).compareTo(a.player?.overall ?? 0);
      });
      return out;
    });
