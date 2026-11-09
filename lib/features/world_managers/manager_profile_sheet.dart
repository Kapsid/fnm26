import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/features/world_managers/manager_row.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/adaptive_sheet.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Opens [ManagerProfileSheet] as a bottom sheet on a phone and a dialog on
/// a tablet.
Future<void> showManagerProfile(
  BuildContext context, {
  required int careerId,
  required int managerId,
}) => showAdaptiveSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: AppColors.surface,
  builder: (_) => ManagerProfileSheet(careerId: careerId, managerId: managerId),
);

/// One world manager: his spells, how your sides fared against his, and the
/// tie between you.
class ManagerProfileSheet extends ConsumerWidget {
  const ManagerProfileSheet({
    required this.careerId,
    required this.managerId,
    super.key,
  });

  final int careerId;
  final int managerId;

  static const Key spellsKey = Key('managerProfile.spells');
  static const Key recordKey = Key('managerProfile.record');
  static const Key tieKey = Key('managerProfile.tie');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final key = (careerId: careerId, managerId: managerId);
    final async = ref.watch(managerProfileProvider(key));
    final p = async.valueOrNull;
    if (p == null) {
      if (async.hasError) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l.commonSomethingWentWrong),
                const SizedBox(height: AppSpacing.md),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
        );
      }
      return const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final nations =
        ref.watch(managerNationsProvider(careerId)).valueOrNull ?? const {};
    final label = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    final muted = AppTypography.bodyMedium.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    String date(DateTime d) => AppDate.dayMonthYear(context, d);
    final spells = [...p.spells]
      ..sort((a, b) => b.fromDate.compareTo(a.fromDate));
    final r = p.relation;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FlagDisc(p.m.nationality, size: 32),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(p.m.name, style: AppTypography.headlineMedium),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.sm,
              children: [
                _Fact(l.mgrProfileAge, '${p.age}'),
                _Fact(l.mgrProfileStyle, managerStyleText(l, p.m.style)),
                _Fact(l.mgrProfileReputation, '${p.reputation}'),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l.mgrProfileSpells, style: label),
            const SizedBox(height: AppSpacing.xs),
            Column(
              key: spellsKey,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final s in spells)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      s.toDate == null
                          ? l.mgrProfileSpellNow(
                              nations[s.nationId]?.name ?? '',
                              date(s.fromDate),
                            )
                          : l.mgrProfileSpellEnded(
                              l.mgrProfileSpellRange(
                                nations[s.nationId]?.name ?? '',
                                date(s.fromDate),
                                date(s.toDate!),
                              ),
                              s.endReason == null
                                  ? ''
                                  : spellEndText(l, s.endReason!),
                            ),
                      style: AppTypography.bodyMedium,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l.mgrProfileRecordVsYou, style: label),
            const SizedBox(height: AppSpacing.xs),
            Text(
              r.meetings == 0
                  ? l.mgrProfileNoMeetings
                  : managerRecordText(l, r.won, r.drawn, r.lost),
              key: recordKey,
              style: r.meetings == 0 ? muted : AppTypography.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l.mgrProfileTie, style: label),
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerLeft,
              child: KeyedSubtree(key: tieKey, child: TieChip(r.label)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      Text(value, style: AppTypography.titleMedium),
    ],
  );
}
