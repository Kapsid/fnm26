import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/manager/manager_skills.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/features/federation/investment_editor.dart'
    show formatEuros;
import 'package:fnm/features/manager/manager_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// The manager's own page: what he is good at, who he employs, and what the
/// side works on when there is no match to play.
///
/// The three sit together because they are one decision from the player's side
/// — how do I spend what I have got — and because the staff and the training
/// only mean anything alongside the skills that scale them.
class ManagerScreen extends ConsumerWidget {
  const ManagerScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(managerViewProvider(careerId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l.managerTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (view) => view == null
            ? const SizedBox.shrink()
            : ListView(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                children: [
                  _SkillsCard(careerId: careerId, view: view),
                  const SizedBox(height: AppSpacing.md),
                  _StaffCard(careerId: careerId, view: view),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
      ),
    );
  }
}

String _skillName(AppLocalizations l, ManagerSkill s) => switch (s) {
  ManagerSkill.manManagement => l.managerSkillManManagement,
  ManagerSkill.tactical => l.managerSkillTactical,
  ManagerSkill.youthDevelopment => l.managerSkillYouth,
  ManagerSkill.negotiation => l.managerSkillNegotiation,
};

String _skillBlurb(AppLocalizations l, ManagerSkill s) => switch (s) {
  ManagerSkill.manManagement => l.managerSkillManManagementBlurb,
  ManagerSkill.tactical => l.managerSkillTacticalBlurb,
  ManagerSkill.youthDevelopment => l.managerSkillYouthBlurb,
  ManagerSkill.negotiation => l.managerSkillNegotiationBlurb,
};

String _roleName(AppLocalizations l, StaffRole r) => switch (r) {
  StaffRole.assistant => l.managerRoleAssistant,
  StaffRole.scout => l.managerRoleScout,
  StaffRole.fitnessCoach => l.managerRoleFitness,
};

String _roleBlurb(AppLocalizations l, StaffRole r) => switch (r) {
  StaffRole.assistant => l.managerRoleAssistantBlurb,
  StaffRole.scout => l.managerRoleScoutBlurb,
  StaffRole.fitnessCoach => l.managerRoleFitnessBlurb,
};

String _tierName(AppLocalizations l, StaffTier t) => switch (t) {
  StaffTier.none => l.managerTierNone,
  StaffTier.basic => l.managerTierBasic,
  StaffTier.good => l.managerTierGood,
  StaffTier.elite => l.managerTierElite,
};



class _SkillsCard extends ConsumerWidget {
  const _SkillsCard({required this.careerId, required this.view});

  final int careerId;
  final ManagerView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.managerSkills,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.managerPointsAvailable(view.pointsAvailable),
            style: AppTypography.titleMedium.copyWith(
              color: view.pointsAvailable > 0
                  ? AppColors.positive
                  : AppColors.onSurfaceVariant,
            ),
          ),
          Text(
            l.managerPointsHow,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final skill in ManagerSkill.values) ...[
            _SkillRow(
              name: _skillName(l, skill),
              blurb: _skillBlurb(l, skill),
              level: view.skills[skill] ?? ManagerSkills.starting,
              canRaise: ManagerSkills.canRaise(
                skill: skill,
                earned: view.pointsEarned,
                levels: view.skills,
              ),
              onRaise: () =>
                  ref.read(managerServiceProvider).raise(careerId, skill),
            ),
            if (skill != ManagerSkill.values.last)
              const Divider(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({
    required this.name,
    required this.blurb,
    required this.level,
    required this.canRaise,
    required this.onRaise,
  });

  final String name;
  final String blurb;
  final int level;
  final bool canRaise;
  final VoidCallback onRaise;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: AppTypography.bodyMedium),
            Text(
              blurb,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            // The bar reads at a glance; the number is there because a
            // twenty-point scale is not readable from a bar alone.
            ClipRRect(
              borderRadius: AppRadii.smAll,
              child: LinearProgressIndicator(
                value: level / ManagerSkills.ceiling,
                minHeight: 6,
                backgroundColor: AppColors.surfaceContainerHighest,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: AppSpacing.md),
      SizedBox(
        width: 26,
        child: Text(
          '$level',
          textAlign: TextAlign.center,
          style: AppTypography.titleMedium,
        ),
      ),
      IconButton(
        onPressed: canRaise ? onRaise : null,
        icon: Icon(
          Icons.add_circle,
          color: canRaise ? AppColors.positive : AppColors.outlineVariant,
        ),
      ),
    ],
  );
}

class _StaffCard extends ConsumerWidget {
  const _StaffCard({required this.careerId, required this.view});

  final int careerId;
  final ManagerView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final career = view.career;
    final tiers = {
      StaffRole.assistant: career.staffAssistant,
      StaffRole.scout: career.staffScout,
      StaffRole.fitnessCoach: career.staffFitnessCoach,
    };
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
            l.managerStaffWages(formatEuros(view.staffWages)),
            style: AppTypography.labelSmall.copyWith(
              color: view.staffWages > career.budget
                  ? AppColors.warning
                  : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final role in StaffRole.values) ...[
            Text(_roleName(l, role), style: AppTypography.bodyMedium),
            Text(
              _roleBlurb(l, role),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            SegmentedButton<StaffTier>(
              showSelectedIcon: false,
              segments: [
                for (final tier in StaffTier.values)
                  ButtonSegment(
                    value: tier,
                    label: Text(
                      tier == StaffTier.none
                          ? _tierName(l, tier)
                          : '${_tierName(l, tier)}\n'
                                '${formatEuros(Staff.costPerCycle(tier))}',
                      textAlign: TextAlign.center,
                      style: AppTypography.labelSmall,
                    ),
                  ),
              ],
              selected: {tiers[role]!},
              onSelectionChanged: (s) => ref
                  .read(managerServiceProvider)
                  .hire(careerId, role, s.first),
            ),
            if (role != StaffRole.values.last)
              const Divider(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

