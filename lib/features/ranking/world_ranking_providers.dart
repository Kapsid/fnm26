import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/seed_ranking_repository.dart';
import 'package:fnm/domain/services/ranking/elo.dart';

/// World ranking data: nations ordered by their live points, each nation's
/// current points and world position, and how far it has moved from where the
/// static seed ranking started it.
class RankingData {
  const RankingData({
    required this.nations,
    required this.points,
    required this.position,
    required this.movement,
    required this.playerNationId,
    required this.baseline,
  });

  /// Nations ordered by live points (strongest first).
  final List<Nation> nations;

  /// Live points, keyed by nation id.
  final Map<int, int> points;

  /// Live world position (1 = top), keyed by nation id.
  final Map<int, int> position;

  /// Positions climbed since [baseline] was frozen (negative = dropped).
  final Map<int, int> movement;

  final int playerNationId;

  /// Which freeze [movement] is measured from, so the screen can say so.
  final RankBaseline baseline;
}

/// Which stored ranking freeze the movement arrows are measured from.
enum RankBaseline {
  /// The live ranking snapshotted when the last World Championship finals draw
  /// was made: the freeze a tournament's swing is visible against.
  worldChampionshipDraw,

  /// The cycle's starting positions, before any World Championship draw of
  /// this career has been made.
  cycleStart,
}

/// Selected confederation filter (null = all).
final selectedRankRegionProvider = StateProvider<Confederation?>((_) => null);

/// Argument for [seedRankByIdProvider]: the save and the cycle being drawn.
typedef SeedRankArg = ({int careerId, int cycle});

/// Per-draw seeding-snapshot slots. Each cup's draw freezes the LIVE world
/// ranking at the moment it is generated (so its pots reflect current form —
/// e.g. a World Cup finals draw pots by the ranking after qualifying), stored
/// under a synthetic cycle key kept clear of real cycle numbers so it never
/// collides with the cycle-start baseline the ranking-movement arrows use.
const int drawSlotWorldCupFinals = 0;
const int drawSlotContinentalFinals = 1;

/// World Cup QUALIFYING is drawn two years into the cycle, long after the
/// cycle-start baseline was frozen. Seeding it from that baseline meant a side
/// that had climbed to the top of the world since could still be drawn out of
/// pot 2 — so it snapshots the live ranking at the moment the draw is made,
/// exactly as the finals draws do.
const int drawSlotWorldCupQualifying = 2;

/// The intercontinental play-off's seeding, frozen when the play-off starts so
/// the bracket cannot reseed itself between the manager's semi and his final.
const int drawSlotWorldCupPlayoff = 3;

/// The synthetic "cycle" a draw's own live-ranking snapshot is stored under.
int drawSeedCycle(int cycle, int slot) => 900000 + cycle * 10 + slot;

/// The ranking a cycle's draws seed from: the positions frozen at the cycle's
/// start, or — for cycle 0 or any legacy save with no snapshot — the static
/// seed ranking. Every draw and its ceremony read this so they always agree.
final AutoDisposeFutureProviderFamily<Map<int, int>, SeedRankArg>
seedRankByIdProvider = FutureProvider.autoDispose
    .family<Map<int, int>, SeedRankArg>((
      ref,
      arg,
    ) async {
      final snap = await ref
          .watch(seedRankingRepositoryProvider)
          .forCycle(arg.careerId, arg.cycle);
      if (snap.isNotEmpty) return snap;
      final nations = await ref.watch(nationRepositoryProvider).all();
      return {for (final n in nations) n.id: n.ranking};
    });

/// Argument for [drawRankByIdProvider]: the save, the cycle, and which draw.
typedef DrawSeedArg = ({int careerId, int cycle, int slot});

/// The ranking ONE PARTICULAR draw seeded from: the live standings snapshotted
/// when that draw was made, falling back to the cycle baseline for a draw made
/// before the slot existed (or a legacy save).
final AutoDisposeFutureProviderFamily<Map<int, int>, DrawSeedArg>
drawRankByIdProvider = FutureProvider.autoDispose
    .family<Map<int, int>, DrawSeedArg>((
      ref,
      arg,
    ) async {
      final snap = await ref
          .watch(seedRankingRepositoryProvider)
          .forCycle(arg.careerId, drawSeedCycle(arg.cycle, arg.slot));
      if (snap.isNotEmpty) return snap;
      return ref.watch(
        seedRankByIdProvider((careerId: arg.careerId, cycle: arg.cycle)).future,
      );
    });

/// One point on the nation's ranking timeline (its world position at a moment).
typedef RankHistoryPoint = ({DateTime date, int rank});

/// How many recent ranking releases the chart shows.
const int kRankHistoryPoints = 6;

/// The nation's recent world-ranking history for the chart: the last few
/// published releases plus its live position now.
///
/// Releases are published roughly monthly (see the season service), so this
/// tracks the real rise and fall through a campaign. The old chart plotted one
/// point per four-year cycle, so a young career had just two points — a single
/// flat line.
final AutoDisposeFutureProviderFamily<List<RankHistoryPoint>, int>
rankHistoryProvider = FutureProvider.autoDispose
    .family<List<RankHistoryPoint>, int>((
      ref,
      careerId,
    ) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return const [];
      final nationId = career.nationId;

      final releases = await ref
          .watch(rankingReleaseRepositoryProvider)
          .all(careerId);
      final out = <RankHistoryPoint>[
        // Only this nation's releases — a change of job starts a fresh line.
        for (final r in releases)
          if (r.nationId == nationId) (date: r.publishedOn, rank: r.playerRank),
      ];

      // The live position now, so the line runs right up to the present (and gives
      // a second point when only one release exists yet).
      final live = await ref.watch(worldRankingProvider(careerId).future);
      final now = live?.position[nationId];
      if (now != null && (out.isEmpty || out.last.date != career.inGameDate)) {
        out.add((date: career.inGameDate, rank: now));
      }

      // Keep the most recent handful.
      if (out.length > kRankHistoryPoints) {
        return out.sublist(out.length - kRankHistoryPoints);
      }
      return out;
    });

/// The best and worst world position the manager's nation has EVER held, over
/// every ranking release of the career plus where it stands right now.
///
/// The chart beside it plots only the last [kRankHistoryPoints] releases — a
/// few months — so reading the extremes off those points described the recent
/// wobble, not the career. Null until the nation has been ranked at all.
final AutoDisposeFutureProviderFamily<({int best, int worst})?, int>
rankExtremesProvider = FutureProvider.autoDispose
    .family<({int best, int worst})?, int>((
      ref,
      careerId,
    ) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final nationId = career.nationId;

      final releases = await ref
          .watch(rankingReleaseRepositoryProvider)
          .all(careerId);
      final ranks = <int>[
        // Only this nation's releases — a change of job starts a fresh record.
        for (final r in releases)
          if (r.nationId == nationId) r.playerRank,
      ];
      final live = await ref.watch(worldRankingProvider(careerId).future);
      final now = live?.position[nationId];
      if (now != null) ranks.add(now);
      if (ranks.isEmpty) return null;
      return (
        best: ranks.reduce((a, b) => a < b ? a : b),
        worst: ranks.reduce((a, b) => a > b ? a : b),
      );
    });

/// The ranking freeze that movement during [cycle] is measured from: the world
/// as it was frozen for the World Championship draw that ENDED the cycle
/// before, so the swing that championship produced is what the movement shows.
///
/// Shared by the ranking screen's arrows and the inbox's release messages,
/// which have to answer the same question with the same number: the two have
/// disagreed before and it read as a bug in both.
///
/// The cycle's own starting positions stand in when no championship has been
/// drawn yet, and an empty map means even that is missing (cycle 0, or a
/// legacy save) — callers fall back to the static seed ranking there.
///
/// The cycle's OWN draw snapshot is deliberately not used: it is frozen three
/// and a half years in, so an earlier release of the same cycle would be
/// measured against a table from its own future.
Future<({Map<int, int> rankById, RankBaseline kind})> movementBaselineFor(
  SeedRankingRepository repo,
  int careerId,
  int cycle,
) async {
  if (cycle > 0) {
    final drawn = await repo.forCycle(
      careerId,
      drawSeedCycle(cycle - 1, drawSlotWorldCupFinals),
    );
    if (drawn.isNotEmpty) {
      return (rankById: drawn, kind: RankBaseline.worldChampionshipDraw);
    }
  }
  return (
    rankById: await repo.forCycle(careerId, cycle),
    kind: RankBaseline.cycleStart,
  );
}

/// [movementBaselineFor] the save's current cycle, with the static seed
/// ranking filled in when nothing is stored.
final AutoDisposeFutureProviderFamily<
  ({Map<int, int> rankById, RankBaseline kind}),
  int
>
movementBaselineProvider = FutureProvider.autoDispose
    .family<({Map<int, int> rankById, RankBaseline kind}), int>((
      ref,
      careerId,
    ) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      final cycle = career?.cyclePointer ?? 0;
      final found = await movementBaselineFor(
        ref.watch(seedRankingRepositoryProvider),
        careerId,
        cycle,
      );
      if (found.rankById.isNotEmpty) return found;
      final nations = await ref.watch(nationRepositoryProvider).all();
      return (
        rankById: {for (final n in nations) n.id: n.ranking},
        kind: RankBaseline.cycleStart,
      );
    });

final AutoDisposeFutureProviderFamily<RankingData?, int> worldRankingProvider =
    FutureProvider.autoDispose.family<RankingData?, int>((ref, careerId) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      final nations = await ref.watch(nationRepositoryProvider).all();

      final seed = {
        for (final n in nations) n.id: Elo.seedFromRanking(n.ranking),
      };
      final points = await ref
          .watch(rankingRepositoryProvider)
          .pointsFor(careerId, seed);

      // Baseline: the last time the world ranking was FROZEN for a World
      // Championship draw, falling back to the cycle's starting positions.
      //
      // The cycle baseline alone could not show a tournament at all: it is
      // re-frozen at the rollover that follows the final, from the standings
      // the final itself produced, so the moment the new cycle began every
      // arrow on the screen read zero and the biggest swing in the game was
      // gone before the manager could look at it.
      final baseline = await ref.watch(
        movementBaselineProvider(careerId).future,
      );

      final ordered = [...nations]
        ..sort((a, b) {
          final byPoints = (points[b.id] ?? Elo.base).compareTo(
            points[a.id] ?? Elo.base,
          );
          return byPoints != 0 ? byPoints : a.ranking.compareTo(b.ranking);
        });

      final position = <int, int>{};
      final movement = <int, int>{};
      for (var i = 0; i < ordered.length; i++) {
        final n = ordered[i];
        final rank = i + 1;
        position[n.id] = rank;
        // + = climbed since the baseline was frozen.
        movement[n.id] = (baseline.rankById[n.id] ?? n.ranking) - rank;
      }

      return RankingData(
        nations: ordered,
        points: points,
        position: position,
        movement: movement,
        playerNationId: career?.nationId ?? -1,
        baseline: baseline.kind,
      );
    });

/// Where the manager's own nation stands in the world right now, and how far
/// it has moved since the freeze the ranking screen measures from.
///
/// Derived from [worldRankingProvider] rather than computed again, so the
/// dashboard and the ranking screen can never quote two different numbers for
/// the same nation on the same day. Null before the save has a nation at all.
final AutoDisposeFutureProviderFamily<({int rank, int movement})?, int>
playerRankProvider = FutureProvider.autoDispose
    .family<({int rank, int movement})?, int>((ref, careerId) async {
      final data = await ref.watch(worldRankingProvider(careerId).future);
      if (data == null) return null;
      final rank = data.position[data.playerNationId];
      if (rank == null) return null;
      return (rank: rank, movement: data.movement[data.playerNationId] ?? 0);
    });
