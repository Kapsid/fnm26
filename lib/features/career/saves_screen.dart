import 'package:flutter/material.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fnm/features/career/career_transfer_providers.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Lists save games: continue, delete, or start a new one (subject to the
/// free/Pro slot limit).
class SavesScreen extends ConsumerWidget {
  const SavesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final savesAsync = ref.watch(savesProvider);
    const limit = kSaveSlots;
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
                          return SaveTile(
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
                            onShare: () => _shareCareer(context, ref, save.id),
                          );
                        },
                      ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PrimaryButton(
                        label: full ? l.careerSlotsFull : l.careerNewGame,
                        icon: Icons.add,
                        // Slots are the same for everyone now, so full is
                        // simply full: delete one to start another.
                        onPressed: full
                            ? null
                            : () => context.go(Routes.nations),
                      ),
                      // An imported career takes a slot like any other, so it
                      // is offered only while there is room for one.
                      if (!full)
                        TextButton.icon(
                          onPressed: () => _importCareer(context, ref),
                          icon: const Icon(
                            Icons.file_download_outlined,
                            size: 18,
                          ),
                          label: Text(l.careerImport),
                        ),
                    ],
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

/// How long ago, in one unit and as few characters as it takes.
///
/// "Last played 3 days ago" is a sentence, and this line shares a narrow row
/// with the share and delete buttons — so the sentence was the thing that got
/// cut, which left the manager reading "Last played 3 days…" and learning
/// nothing he could not already guess. A unit and a number always fit.
///
/// Deliberately coarse. Nobody picking a save needs the minute; they need to
/// know which of these they were playing yesterday.
String agoShort(DateTime at, {DateTime? now}) {
  final diff = (now ?? DateTime.now()).difference(at);
  if (diff.inMinutes < 60) return '${diff.inMinutes.clamp(1, 59)}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  if (diff.inDays < 7) return '${diff.inDays}d';
  if (diff.inDays < 365) return '${diff.inDays ~/ 7}w';
  return '${diff.inDays ~/ 365}y';
}

/// Writes one career to a file and hands it to the share sheet.
Future<void> _shareCareer(
  BuildContext context,
  WidgetRef ref,
  int careerId,
) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  try {
    final file = await ref.read(careerTransferServiceProvider).export(careerId);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], subject: l.careerShareSubject),
    );
  } on Object catch (e, stack) {
    AppLog.error('career-share', e, stack);
    messenger.showSnackBar(SnackBar(content: Text(l.careerShareFailed)));
  }
}

/// Adds a career from a file as a NEW save. Nothing already saved is touched.
Future<void> _importCareer(BuildContext context, WidgetRef ref) async {
  final l = AppLocalizations.of(context);
  final picked = await FilePicker.pickFiles();
  final path = picked?.files.single.path;
  if (path == null || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  final refusal = await ref.read(careerTransferServiceProvider).import(path);
  messenger.showSnackBar(
    SnackBar(
      content: Text(switch (refusal) {
        null => l.careerImported,
        BundleRejection.unreadable => l.careerImportFailedUnreadable,
        BundleRejection.fromANewerBuild => l.careerImportFailedNewer,
      }),
    ),
  );
}

/// One save in the list: who you are, where you are, and the three things you
/// can do with it.
class SaveTile extends StatelessWidget {
  const SaveTile({
    required this.save,
    required this.nation,
    required this.onContinue,
    required this.onDelete,
    required this.onShare,
    super.key,
  });

  final Career save;
  final Nation? nation;
  final VoidCallback onContinue;
  final VoidCallback onDelete;

  /// Writes this one career to a file and hands it to the share sheet.
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final date = AppDate.monthYear(context, save.inGameDate);
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
                // The two lines under the manager's name say WHEN you last
                // played and for how long. They used to carry "Road to the
                // 2034 World Cup", which is the same sentence on every save in
                // the list and tells you nothing about which of them to open.
                // What a saves list is for is telling them apart.
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
                        // Never cut, on top of being short: this line is the
                        // one thing telling two saves apart.
                        child: WholeText(
                          l.careerLastAgo(agoShort(save.lastPlayedAt!)),
                          maxLines: 1,
                          textAlign: TextAlign.start,
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
                // a row reading "0m" beside a clock looks like a bug.
                //
                // The verb went for width. "Odehráno 2 h 0 min" was cut on a
                // 320pt phone and the number went with it, which is the only
                // part of the line worth reading; the clock icon beside it
                // already says what the number counts.
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
            tooltip: l.careerShare,
            icon: const Icon(Icons.ios_share_rounded, color: AppColors.outline),
            onPressed: onShare,
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
