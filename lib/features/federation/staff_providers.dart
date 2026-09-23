import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

/// Who is in each of the three jobs, and who is applying for them this cycle.
typedef StaffRoom = ({
  Map<StaffRole, StaffCandidate?> hired,
  Map<StaffRole, List<StaffCandidate>> applicants,
  int wagesPerCycle,
});

/// The staff room for a save.
///
/// Nothing here is stored but the id of each person hired: the applicants are
/// derived from `(saveSeed, cycle, role)`, and a hired man is rebuilt by
/// finding his id among the applicants of the cycle he was hired in — or, if
/// that cycle has rolled past, from his id alone, which carries his tier and
/// his job.
final AutoDisposeFutureProviderFamily<StaffRoom?, int> staffRoomProvider =
    FutureProvider.autoDispose.family<StaffRoom?, int>((ref, careerId) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final squad = await ref.watch(squadDataProvider(careerId).future);
      final nations = await ref.watch(nationRepositoryProvider).all();
      final me = nations.where((n) => n.id == career.nationId).firstOrNull;
      final home = me?.code.toLowerCase() ?? '';

      // Where the candidates come from: home, plus a handful of the game's
      // strongest football nations. Coaching is an international trade, so a
      // staff room drawn entirely from one country reads like a village.
      final playerRepo = ref.watch(playerRepositoryProvider);
      final sources = <int>{
        career.nationId,
        // Deterministic per save and per cycle, so the room is stable while
        // the manager looks at it and different next time round.
        for (final n
            in (nations.toList()
              ..sort((a, b) => a.ranking.compareTo(b.ranking))).take(20))
          n.id,
      }.take(8).toList();

      final namePool = <String, List<String>>{};
      for (final id in sources) {
        final nation = nations.where((n) => n.id == id).firstOrNull;
        if (nation == null) continue;
        final code = nation.code.toLowerCase();
        if (id == career.nationId) {
          namePool[code] = [
            for (final p in squad?.pool ?? const <Player>[]) p.name,
          ];
          continue;
        }
        final pool = await playerRepo.byNation(id);
        namePool[code] = [for (final p in pool) p.name];
      }
      namePool.removeWhere((_, names) => names.isEmpty);

      final applicants = {
        for (final role in StaffRole.values)
          role: StaffMarket.forRole(
            saveSeed: career.rngSeed,
            cycle: career.cyclePointer,
            role: role,
            namePool: namePool,
          ),
      };
      final ids = {
        StaffRole.assistant: career.staffAssistantId,
        StaffRole.scout: career.staffScoutId,
        StaffRole.fitnessCoach: career.staffFitnessCoachId,
      };
      final tiers = {
        StaffRole.assistant: career.staffAssistant,
        StaffRole.scout: career.staffScout,
        StaffRole.fitnessCoach: career.staffFitnessCoach,
      };

      final hired = <StaffRole, StaffCandidate?>{};
      for (final role in StaffRole.values) {
        final id = ids[role];
        if (id == null) {
          hired[role] = null;
          continue;
        }
        // He may still be among this cycle's applicants, in which case his name
        // is right there. Hired in an earlier cycle, the id alone still knows
        // his tier and his job — so the post reads as filled by somebody of
        // that standing rather than going mysteriously empty.
        hired[role] = applicants[role]!
            .where((c) => c.id == id)
            .firstOrNull ??
            (
              id: id,
              name: '',
              country: home,
              role: role,
              tier: StaffMarket.tierOf(id),
            );
      }
      return (
        hired: hired,
        applicants: applicants,
        wagesPerCycle: Staff.totalCost(tiers),
      );
    });
