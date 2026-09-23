import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/federation/staff_effect.dart';
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
  const StaffCard({
    required this.careerId,
    this.readOnly = false,
    super.key,
  });

  final int careerId;

  /// Shows who is in each job without offering to change it.
  ///
  /// Hiring happens once a cycle, on the budget screen, where the wages can be
  /// weighed against the departments they compete with. That left the staff
  /// invisible for the rest of the cycle — the one screen that named them was
  /// the one screen you could not get back to — so the manager's own page
  /// carries this, read-only.
  final bool readOnly;

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
                  // A person, so the concession is his forename and not his
                  // size: an applicant list is read to tell one man from
                  // another, and "J. Vondrackovsky" still does that where a
                  // name scaled to half its height does not.
                  title: WholeText(
                    c.name,
                    maxLines: 1,
                    shortText: initialledName(c.name),
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WholeText(
                        '${tierName(l, c.tier)} · '
                        '${formatEuros(Staff.costPerCycle(c.tier))}',
                        maxLines: 1,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      // The price is only half the decision. What THIS man at
                      // THIS tier buys goes beside it, so the spend is weighed
                      // where it is made.
                      _RoleEffect(role: role, hired: c.tier),
                    ],
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
    ref
      ..invalidate(staffRoomProvider(careerId))
      // Hiring changes the wage bill, and the wage bill is what the budget
      // screen allocates against and what the hub reports as free.
      ..invalidate(federationFundsProvider(careerId));
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
              onTap: readOnly ? null : () => _pick(context, ref, role, room),
              title: WholeText(
                roleName(l, role),
                maxLines: 1,
                style: AppTypography.bodyMedium,
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  switch (room.hired[role]) {
                    null => Text(
                      l.staffVacant,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                    final hired => WholeText(
                      hired.name.isEmpty
                          // Hired in an earlier cycle, so his name is no longer
                          // in this cycle's applicant list — his standing is.
                          ? tierName(l, hired.tier)
                          : '${hired.name} · ${tierName(l, hired.tier)}',
                      shortText: hired.name.isEmpty
                          ? null
                          : '${initialledName(hired.name)} · '
                                '${tierName(l, hired.tier)}',
                      maxLines: 1,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  },
                  _RoleEffect(role: role, hired: room.hired[role]?.tier),
                ],
              ),
              trailing: readOnly
                  ? (room.hired[role] == null
                        ? null
                        : FlagDisc(room.hired[role]!.country, size: 20))
                  : const Icon(
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

/// What the person in this job is worth, stated in the unit his effect is
/// applied in.
///
/// The manager's report was that hiring changed nothing he could see. It very
/// nearly does not: see [StaffEffect] for which seam each role reaches and
/// which reaches none. This line says the true figure and, where the answer is
/// nothing, says that instead of a sentence that sounds like something.
class _RoleEffect extends StatelessWidget {
  const _RoleEffect({required this.role, required this.hired});

  final StaffRole role;

  /// How good the man in the job is, or null when nobody is in it.
  final StaffTier? hired;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lines = hired == null
        ? StaffEffect.describeHiring(l, role)
        : StaffEffect.describe(l, role, hired!);
    final style = AppTypography.labelSmall.copyWith(
      color: lines.isEmpty ? AppColors.onSurfaceVariant : AppColors.positive,
      fontWeight: lines.isEmpty ? null : FontWeight.w700,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A role wired to nothing gets the plain truth rather than a blank,
          // so a manager can stop paying for it.
          if (lines.isEmpty)
            WholeText(l.staffEffectNone, maxLines: 1, style: style)
          else
            // One effect to a line. Run together they ran off a 360px phone in
            // both languages, and a figure that has been scaled down to fit is
            // a figure the manager has to squint at.
            for (final line in lines) WholeText(line, style: style),
        ],
      ),
    );
  }
}
