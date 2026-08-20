import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/services/manager/manager_skills.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';

/// Everything the manager's own page shows: what he is good at, what he has
/// left to spend, who he employs and what the side is working on.
typedef ManagerView = ({
  Career career,
  Map<ManagerSkill, int> skills,
  int pointsEarned,
  int pointsAvailable,

  /// What the wage bill will cost at the next rollover.
  int staffWages,
});

/// How many points a career has earned: two per completed cycle, one per
/// trophy actually won by the nation the manager was in charge of.
final AutoDisposeFutureProviderFamily<ManagerView?, int> managerViewProvider =
    FutureProvider.autoDispose.family<ManagerView?, int>((ref, careerId) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;

      // Trophies the MANAGER won, not the nation's whole roll of honour: the
      // cabinet is seeded with real history, and being handed points for a cup
      // somebody else lifted in 1998 would make the very first screen a
      // shopping trip.
      final honours = await ref
          .watch(competitionRepositoryProvider)
          .honours(careerId);
      // cycle → the nation the manager was in charge of that cycle.
      final nationByCycle = await ref
          .watch(careerRepositoryProvider)
          .stints(careerId);
      var trophies = 0;
      for (final h in honours) {
        if (h.year < CareerService.cycleStart.year) continue;
        final cycle = ((h.year - CareerService.cycleStart.year) / 4).floor();
        if (h.championId == (nationByCycle[cycle] ?? career.nationId)) {
          trophies++;
        }
      }

      final skills = <ManagerSkill, int>{
        ManagerSkill.manManagement: career.skillManManagement,
        ManagerSkill.tactical: career.skillTactical,
        ManagerSkill.youthDevelopment: career.skillYouthDevelopment,
        ManagerSkill.negotiation: career.skillNegotiation,
      };
      final earned = ManagerSkills.pointsEarned(
        cyclesCompleted: career.cyclePointer,
        trophies: trophies,
      );
      return (
        career: career,
        skills: skills,
        pointsEarned: earned,
        pointsAvailable: ManagerSkills.pointsAvailable(
          earned: earned,
          levels: skills,
        ),
        staffWages: Staff.totalCost({
          StaffRole.assistant: career.staffAssistant,
          StaffRole.scout: career.staffScout,
          StaffRole.fitnessCoach: career.staffFitnessCoach,
        }),
      );
    });

/// Spending points, hiring people, and choosing what to work on.
class ManagerService {
  ManagerService(this._ref);

  final Ref _ref;

  /// Puts a point into [skill]. Refuses when there is none to spend or the
  /// skill is already at the ceiling — the button is disabled for both, and
  /// this is the check that actually holds.
  Future<bool> raise(int careerId, ManagerSkill skill) async {
    final view = await _ref.read(managerViewProvider(careerId).future);
    if (view == null) return false;
    if (!ManagerSkills.canRaise(
      skill: skill,
      earned: view.pointsEarned,
      levels: view.skills,
    )) {
      return false;
    }
    await _ref.read(careerRepositoryProvider).raiseSkill(careerId, skill);
    _invalidate(careerId);
    return true;
  }

  Future<void> hire(int careerId, StaffRole role, StaffTier tier) async {
    await _ref.read(careerRepositoryProvider).setStaff(careerId, role, tier);
    _invalidate(careerId);
  }



  /// Everything a manager change touches. The skills feed morale, the academy
  /// and the injury rate, none of which recompute on their own — see
  /// [[derived-providers-go-stale]] for the class of bug this avoids.
  void _invalidate(int careerId) => _ref
    ..invalidate(careerByIdProvider(careerId))
    ..invalidate(managerViewProvider(careerId))
    ..invalidate(moraleProvider(careerId))
    ..invalidate(savesProvider);
}

final Provider<ManagerService> managerServiceProvider =
    Provider<ManagerService>(
      ManagerService.new,
    );
