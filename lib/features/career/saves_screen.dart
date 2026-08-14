import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/features/paywall/paywall_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Lists save games: continue, delete, or start a new one (subject to the
/// free/Pro slot limit).
class SavesScreen extends ConsumerWidget {
  const SavesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final savesAsync = ref.watch(savesProvider);
    final premium = ref.watch(premiumUnlockedProvider);
    final limit = maxSaveSlots(premiumUnlocked: premium);
    final nations = ref.watch(nationsProvider).valueOrNull ?? const <Nation>[];
    final nationsById = {for (final n in nations) n.id: n};

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(Routes.home),
        ),
        title: Text(
          l.careerSavesTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: savesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.careerCouldNotLoadSaves('$e'))),
        data: (saves) {
          final full = saves.length >= limit;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.careerSlotsCount(saves.length, limit),
                        style: AppTypography.labelMedium,
                      ),
                    ),
                    if (!premium)
                      TextButton(
                        onPressed: () => showPaywall(context),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        child: Text(l.careerProUpTo5),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: saves.isEmpty
                    ? _empty(context)
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.marginMobile,
                        ),
                        itemCount: saves.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, i) {
                          final save = saves[i];
                          return _SaveTile(
                            save: save,
                            nation: nationsById[save.nationId],
                            onContinue: () {
                              // Stamp the open before navigating so this save
                              // is top of the list next time.
                              ref
                                  .read(careerServiceProvider)
                                  .markPlayed(save.id);
                              context.go('${Routes.hub}?careerId=${save.id}');
                            },
                            onDelete: () => _confirmDelete(
                              context,
                              ref,
                              nationsById[save.nationId]?.name ??
                                  l.careerThisSave,
                              save.id,
                            ),
                          );
                        },
                      ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: PrimaryButton(
                    label: full
                        ? (premium ? l.careerSlotsFull : l.careerSlotsFullGoPro)
                        : l.careerNewGame,
                    icon: Icons.add,
                    // On the free tier, full slots open the paywall (Pro more
                    // than doubles them); with Pro, full really is full.
                    onPressed: full
                        ? (premium ? null : () => showPaywall(context))
                        : () => context.go(Routes.nations),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String label,
    int careerId,
  ) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        title: Text(l.careerDeleteSaveTitle),
        content: Text(l.careerDeleteSaveBody(label)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.careerCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.careerDelete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(careerServiceProvider).delete(careerId);
    }
  }

  Widget _empty(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Text(
        AppLocalizations.of(context).careerNoSavesYet,
        textAlign: TextAlign.center,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    ),
  );
}

/// A short, human "when" for a last-played timestamp — "just now", "3h ago",
/// "yesterday", then a plain date once it's more than a week old.
/// How long a save has been played, or null when there is nothing worth
/// saying yet.
///
/// Rounded to whole minutes and hours: a manager wants to know he has put
/// twenty hours into a career, never that he has put in 20:14:37.
String? playedLabel(AppLocalizations l, int seconds) {
  if (seconds < 60) return null;
  final minutes = seconds ~/ 60;
  if (minutes < 60) return l.careerPlayedMinutes(minutes);
  return l.careerPlayedHours(minutes ~/ 60, minutes % 60);
}

String _ago(AppLocalizations l, DateTime at) {
  final diff = DateTime.now().difference(at);
  if (diff.inMinutes < 2) return l.careerJustNow;
  if (diff.inMinutes < 60) return l.careerMinutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l.careerHoursAgo(diff.inHours);
  if (diff.inDays == 1) return l.careerYesterday;
  if (diff.inDays < 7) return l.careerDaysAgo(diff.inDays);
  return DateFormat('d MMM yyyy').format(at);
}

class _SaveTile extends StatelessWidget {
  const _SaveTile({
    required this.save,
    required this.nation,
    required this.onContinue,
    required this.onDelete,
  });

  final Career save;
  final Nation? nation;
  final VoidCallback onContinue;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final date = DateFormat('MMM yyyy').format(save.inGameDate);
    final wcYear = CareerService.worldCupYear(save.cyclePointer);
    return AppCard(
      onTap: onContinue,
      child: Row(
        children: [
          FlagDisc(nation?.code ?? '??', size: 48),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nation?.name ?? l.careerUnknownNation,
                  style: AppTypography.titleMedium,
                ),
                Text(
                  '${save.managerName} · $date',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.emoji_events_outlined,
                      size: 12,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l.careerRoadToWorldCup(wcYear),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                if (save.lastPlayedAt != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          l.careerLastPlayed(_ago(l, save.lastPlayedAt!)),
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                // How long this save has had of the manager's life. Hidden
                // under a minute: a save just started has nothing to say, and
                // "Played 0m" reads like a bug.
                if (playedLabel(l, save.playedSeconds) case final played?) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.timelapse_rounded,
                        size: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          played,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.outline),
            onPressed: onDelete,
          ),
          const Icon(Icons.chevron_right, color: AppColors.primary),
        ],
      ),
    );
  }
}
