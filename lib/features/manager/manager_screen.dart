import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/manager/manager_skills.dart';
import 'package:fnm/features/federation/staff_card.dart';
import 'package:fnm/features/manager/manager_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'manager_tablet_layout.dart';

/// The manager's own page: what he is good at, who he employs, and what the
/// side works on when there is no match to play.
///
/// The three sit together because they are one decision from the player's side
/// — how do I spend what I have got — and because the staff and the training
/// only mean anything alongside the skills that scale them.
class ManagerScreen extends ConsumerWidget {
  const ManagerScreen({required this.careerId, super.key});

  final int careerId;

  static const Key tabletLayoutKey = Key('manager.tabletLayout');

  /// The skills card on the tablet page.
  static const Key skillsKey = Key('manager.skills');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (TabletShellScope.isActive(context)) {
      return _ManagerTabletLayout(careerId: careerId);
    }
    final l = AppLocalizations.of(context);
    final async = ref.watch(managerViewProvider(careerId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          // Back to whatever opened this, or to the hub when nothing did:
          // popping an empty stack leaves a black screen rather than a screen.
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('${Routes.hub}?careerId=$careerId'),
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
                  _NameCard(careerId: careerId, name: view.career.managerName),
                  const SizedBox(height: AppSpacing.md),
                  _SkillsCard(careerId: careerId, view: view),
                  const SizedBox(height: AppSpacing.md),
                  // Who is in each job, read-only. HIRING happens on the
                  // budget screen, where the wages can be weighed against the
                  // departments they are competing with — but that screen is
                  // reachable once a cycle, so without this the staff were
                  // named on the one page you could not get back to.
                  StaffCard(careerId: careerId, readOnly: true),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
      ),
    );
  }
}

/// The manager's name, with a pencil to change it.
class _NameCard extends ConsumerWidget {
  const _NameCard({required this.careerId, required this.name});

  final int careerId;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.person, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleMedium,
            ),
          ),
          IconButton(
            tooltip: l.managerRename,
            icon: const Icon(Icons.edit, color: AppColors.primary),
            onPressed: () => _rename(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _rename(BuildContext context, WidgetRef ref) async {
    final next = await showDialog<String>(
      context: context,
      builder: (_) => _RenameDialog(name: name),
    );
    if (next == null || next.trim() == name) return;
    await ref.read(managerServiceProvider).rename(careerId, next);
  }
}

/// The rename dialog. It owns its controller so the field outlives the
/// dialog's exit animation: disposing it as soon as `showDialog` returned
/// left the closing dialog rebuilding a dead controller.
class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.name});

  final String name;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.name,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.managerRename),
      content: AppTextField(
        label: l.careerManagerName,
        hint: l.careerManagerNameHint,
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (v) => Navigator.of(context).pop(v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.careerCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(l.managerRenameSave),
        ),
      ],
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
          // What the numbers on the bars MEAN. Four levels on a twenty-point
          // scale, all starting at five, is not readable from the bars alone —
          // and a manager deciding where to put a permanent point should be
          // told it is permanent before he taps.
          Text(
            l.managerSkillsScale,
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
            const SizedBox(height: 2),
            Text(
              blurb,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.3,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
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
