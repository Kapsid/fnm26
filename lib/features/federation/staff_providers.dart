import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/features/career/career_providers.dart';
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
      final nation = await ref
          .watch(nationRepositoryProvider)
          .byId(career.nationId);
      final names = <String>[for (final p in squad?.pool ?? const <Player>[]) p.name];
      final country = nation?.code.toLowerCase() ?? '';

      final applicants = {
        for (final role in StaffRole.values)
          role: StaffMarket.forRole(
            saveSeed: career.rngSeed,
            cycle: career.cyclePointer,
            role: role,
            namePool: names,
            country: country,
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
              country: country,
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
