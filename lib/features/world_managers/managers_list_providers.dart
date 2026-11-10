import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/world_managers/manager_reputation.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
import 'package:fnm/features/world_managers/world_manager_service.dart';

/// One line of the Current tab: the man, where he is in charge, his
/// reputation today and the spell he is in.
typedef ManagerListRow = ({
  WorldManager m,
  int nationId,
  Confederation conf,
  int reputation,
  ManagerSpell spell,
});

/// Every AI nation's manager today, with his reputation. The whole manager
/// world is read once and every reputation computed from it, not one query
/// per row. An open screen seeds lazily like the nation page, in a save from
/// before world managers too (see [WorldManagerService.managersVisible]).
final AutoDisposeFutureProviderFamily<List<ManagerListRow>, int>
managersListProvider = FutureProvider.autoDispose
    .family<List<ManagerListRow>, int>((ref, careerId) async {
      final career = await ref.read(careerRepositoryProvider).byId(careerId);
      if (career == null) return const [];
      final service = ref.read(worldManagerServiceProvider);
      if (!await service.seedForDisplay(careerId)) return const [];
      final world = await ref
          .read(worldManagerRepositoryProvider)
          .load(careerId);
      final nations = {
        for (final n
            in await ref.read(nationRepositoryProvider).forCareer(careerId))
          n.id: n,
      };
      final rank = {for (final n in nations.values) n.id: n.ranking};
      final honours = WorldManagerService.honoursByManager(
        await ref.read(competitionRepositoryProvider).honours(careerId),
        world,
      );
      final byId = {for (final m in world.managers) m.managerId: m};
      final rows = <ManagerListRow>[];
      for (final s in world.spells) {
        if (!s.current || s.nationId == career.nationId) continue;
        final m = byId[s.managerId];
        final n = nations[s.nationId];
        if (m == null || n == null) continue;
        rows.add((
          m: m,
          nationId: s.nationId,
          conf: n.confederation,
          reputation: ManagerReputation.of(
            m.managerId,
            world,
            rank,
            honours,
            asOf: career.inGameDate,
          ),
          spell: s,
        ));
      }
      return rows;
    });

/// The moves of the last two years, newest first: a spell that ended (with
/// the man who took over the same day, if any) or a vacancy filled later.
/// A nation's very first spell is the world's starting point, not a move.
final AutoDisposeFutureProviderFamily<List<ManagerMove>, int>
recentMovesProvider = FutureProvider.autoDispose.family<List<ManagerMove>, int>(
  (ref, careerId) async {
    final career = await ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return const [];
    final service = ref.read(worldManagerServiceProvider);
    if (!await service.seedForDisplay(careerId)) return const [];
    final today = career.inGameDate;
    final since = DateTime(today.year - 2, today.month, today.day);
    final repo = ref.read(worldManagerRepositoryProvider);
    final spells = await repo.movesSince(careerId, since);
    final world = await repo.load(careerId);
    return recentMovesOf(spells, world.spells, since);
  },
);

/// [recent] (the spells opened or closed since [since]) as moves, using
/// [all] to tell a first spell from a replacement.
List<ManagerMove> recentMovesOf(
  List<ManagerSpell> recent,
  List<ManagerSpell> all,
  DateTime since,
) {
  bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
  final taken = <int>{};
  final moves = <ManagerMove>[];
  for (final out in recent) {
    final end = out.toDate;
    if (end == null || end.isBefore(since)) continue;
    final inc = recent
        .where(
          (s) =>
              s.nationId == out.nationId &&
              s.spellNo != out.spellNo &&
              sameDay(s.fromDate, end),
        )
        .firstOrNull;
    if (inc != null) taken.add(inc.spellNo);
    moves.add((
      nationId: out.nationId,
      outgoingId: out.managerId,
      why: out.endReason,
      incomingId: inc?.managerId,
      date: end,
    ));
  }
  for (final s in recent) {
    if (taken.contains(s.spellNo) || s.fromDate.isBefore(since)) continue;
    final hadBefore = all.any(
      (o) =>
          o.nationId == s.nationId &&
          o.spellNo != s.spellNo &&
          o.toDate != null &&
          !o.toDate!.isAfter(s.fromDate),
    );
    if (!hadBefore) continue;
    moves.add((
      nationId: s.nationId,
      outgoingId: null,
      why: null,
      incomingId: s.managerId,
      date: s.fromDate,
    ));
  }
  moves.sort((a, b) => b.date.compareTo(a.date));
  return moves;
}

/// The managers named by [recentMovesProvider]'s moves, by id.
final AutoDisposeFutureProviderFamily<Map<int, WorldManager>, int>
recentMoveManagersProvider = FutureProvider.autoDispose
    .family<Map<int, WorldManager>, int>((ref, careerId) async {
      final moves = await ref.watch(recentMovesProvider(careerId).future);
      if (moves.isEmpty) return const {};
      // One read of the whole world, not one query per name.
      final world = await ref
          .read(worldManagerRepositoryProvider)
          .load(careerId);
      final named = {
        for (final mv in moves) ...[?mv.outgoingId, ?mv.incomingId],
      };
      return {
        for (final m in world.managers)
          if (named.contains(m.managerId)) m.managerId: m,
      };
    });
