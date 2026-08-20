import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/federation/staff_providers.dart';
import 'package:fnm/features/manager/manager_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

String roleName(AppLocalizations l, StaffRole role) => switch (role) {
  StaffRole.assistant => l.managerRoleAssistant,
  StaffRole.scout => l.managerRoleScout,
  StaffRole.fitnessCoach => l.managerRoleFitness,
};

String roleBlurb(AppLocalizations l, StaffRole role) => switch (role) {
  StaffRole.assistant => l.managerRoleAssistantBlurb,
  StaffRole.scout => l.managerRoleScoutBlurb,
  StaffRole.fitnessCoach => l.managerRoleFitnessBlurb,
};

String tierName(AppLocalizations l, StaffTier tier) => switch (tier) {
  StaffTier.none => l.managerTierNone,
  StaffTier.basic => l.managerTierBasic,
  StaffTier.good => l.managerTierGood,
  StaffTier.elite => l.managerTierElite,
};

/// Hiring, on the screen where the money is.
///
/// Staff used to be picked on the manager's own screen, which had no budget on
/// it — so a standing cost per cycle was chosen somewhere it could not be
/// weighed against anything. Here it sits directly above the departments it
/// competes with, and the wage bill comes off the top of what there is to
/// spend.
class StaffCard extends ConsumerWidget {
  const StaffCard({required this.careerId, super.key});

  final int careerId;

  Future<void> _pick(
    BuildContext context,
    WidgetRef ref,
    StaffRole role,
    StaffRoom room,
  ) async {
    final l = AppLocalizations.of(context);
    final picked = await showModalBottomSheet<int?>(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                roleName(l, role).toUpperCase(),
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                roleBlurb(l, role),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              for (final c in room.applicants[role] ?? const <StaffCandidate>[])
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: FlagDisc(c.country, size: 22),
                  title: WholeText(c.name, maxLines: 1),
                  subtitle: Text(
                    '${tierName(l, c.tier)} · '
                    '${formatEuros(Staff.costPerCycle(c.tier))}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  trailing: room.hired[role]?.id == c.id
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.positive,
                          size: 18,
                        )
                      : null,
                  onTap: () => Navigator.of(sheetContext).pop(c.id),
                ),
              // Nobody is always an option, and it is the option a save that
              // has never hired anyone is already on.
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.person_off_outlined,
                  color: AppColors.onSurfaceVariant,
                ),
                title: Text(l.staffLeaveVacant),
                onTap: () => Navigator.of(sheetContext).pop(-1),
              ),
            ],
          ),
        ),
      ),
    );
    if (picked == null) return;
    await ref
        .read(managerServiceProvider)
        .hire(careerId, role, picked == -1 ? null : picked);
    ref.invalidate(staffRoomProvider(careerId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final room = ref.watch(staffRoomProvider(careerId)).valueOrNull;
    if (room == null) return const SizedBox.shrink();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.managerStaff,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.managerStaffWages(formatEuros(room.wagesPerCycle)),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final role in StaffRole.values)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              onTap: () => _pick(context, ref, role, room),
              title: Text(roleName(l, role), style: AppTypography.bodyMedium),
              subtitle: switch (room.hired[role]) {
                null => Text(
                  l.staffVacant,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.warning,
                  ),
                ),
                final hired => Text(
                  hired.name.isEmpty
                      // Hired in an earlier cycle, so his name is no longer in
                      // this cycle's applicant list — his standing still is.
                      ? tierName(l, hired.tier)
                      : '${hired.name} · ${tierName(l, hired.tier)}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              },
              trailing: const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
