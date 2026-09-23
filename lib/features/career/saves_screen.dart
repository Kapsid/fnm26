import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fnm/features/career/career_transfer_providers.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/data/db/save_backup.dart';
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
import 'package:fnm/features/paywall/paywall_sheet.dart';
import 'package:fnm/features/settings/backup_restore_prompt.dart';
import 'package:fnm/features/settings/save_backup_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Lists save games: continue, delete, or start a new one (subject to the
/// free/Unlimited slot limit).
class SavesScreen extends ConsumerStatefulWidget {
  const SavesScreen({super.key});

  @override
  ConsumerState<SavesScreen> createState() => _SavesScreenState();
}

class _SavesScreenState extends ConsumerState<SavesScreen> {
  /// Whether one of the three file actions is running.
  ///
  /// Writing a career out, writing every save out, and reading one back all
  /// go to disk and can take seconds on a long save. Nothing said so: the
  /// manager pressed import, the share sheet did not appear yet, and the
  /// screen sat there looking exactly as it had before, so he pressed it
  /// again. One flag disables all three and puts a spinner on the one he
  /// pressed, because a control that is working has to look different from a
  /// control that ignored him.
  bool _busy = false;

  /// Runs a file action with the screen marked busy for its whole duration.
  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final savesAsync = ref.watch(savesProvider);
    final premium = ref.watch(premiumUnlockedProvider);
    // Null means no ceiling, which is what the purchase buys.
    final limit = saveSlotLimit(premiumUnlocked: premium);
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
          // Over the limit counts as full too. A manager can arrive here with
          // more saves than the free tier allows (they were made when it was
          // uncapped, or restored from a paid device); every one of them stays
          // in the list, playable and deletable. Only a NEW one is refused.
          final full = limit != null && saves.length >= limit;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        limit == null
                            ? l.careerSlotsUsed(saves.length)
                            : l.careerSlotsCount(saves.length, limit),
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
                            onShare: _busy
                                ? null
                                : () => _run(
                                    () => _shareCareer(
                                      context,
                                      ref,
                                      save.id,
                                    ),
                                  ),
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
                        label: full
                            ? (premium
                                  ? l.careerSlotsFull
                                  : l.careerSlotsUnlockMore)
                            : l.careerNewGame,
                        icon: full && !premium ? Icons.lock_open : Icons.add,
                        // A full free player is not sent to a dead button:
                        // more saves are exactly what the purchase sells, so
                        // the button becomes the door to it.
                        onPressed: !full
                            ? () => context.go(Routes.nations)
                            : premium
                            ? null
                            : () => unawaited(showPaywall(context)),
                      ),
                      if (full && !premium)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: Text(
                            l.careerSlotsKeepNote,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      // The way to the shop, open whether or not the slots are
                      // full.
                      //
                      // It used to appear only when they were, which made the
                      // offer a consequence of running out rather than
                      // something a manager could take up when he wanted it.
                      // He asked for it on this screen with room to spare, and
                      // he is right: what the purchase sells is endless
                      // cycles, and the second save is the smaller half of it.
                      // When the slots ARE full the primary button above is
                      // already that door, so this one stands down rather than
                      // print the same offer twice.
                      if (!premium && !full)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: TextButton.icon(
                            onPressed: () => unawaited(showPaywall(context)),
                            icon: const Icon(
                              Icons.lock_open_rounded,
                              size: 18,
                            ),
                            label: Text(l.paywallGoPro),
                          ),
                        ),
                      // An imported career takes a slot like any other, so it
                      // is offered only while there is room for one.
                      if (!full)
                        TextButton.icon(
                          onPressed: _busy
                              ? null
                              : () => _run(() => _importCareer(context, ref)),
                          icon: _busy
                              ? const _Spinner()
                              : const Icon(
                                  Icons.file_download_outlined,
                                  size: 18,
                                ),
                          label: Text(l.careerImport),
                        ),
                      // Every save at once, which is the backup that actually
                      // answers a lost phone. Exporting one career at a time
                      // from the tiles covers the save you remembered; this
                      // covers the ones you did not.
                      if (saves.isNotEmpty)
                        TextButton.icon(
                          onPressed: () => _backupAll(context, ref),
                          icon: const Icon(
                            Icons.backup_outlined,
                            size: 18,
                          ),
                          label: Text(l.careerBackupAll),
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
/// Writes EVERY save to one file and hands it to the share sheet.
///
/// The same export the settings screen offers, on the screen where a manager
/// is actually looking at what he would lose.
Future<void> _backupAll(BuildContext context, WidgetRef ref) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  try {
    final file = await ref.read(saveBackupServiceProvider).export();
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], subject: l.backupExportSubject),
    );
  } on Object catch (e, stack) {
    AppLog.error('saves-backup-all', e, stack);
    messenger.showSnackBar(SnackBar(content: Text(l.careerBackupAllFailed)));
  }
}

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
/// Takes in a file the manager picked, whichever of the two exports made it.
///
/// This screen offers both: a single career off a tile, and every save at once
/// from the button below. They are different formats — a career is gzipped
/// JSON, a backup is the whole SQLite database — and import used to accept
/// only the first. A manager who backed up all his saves and then pressed the
/// button directly underneath was told his own backup was "not an FNM career",
/// which is true, useless, and entirely our doing.
///
/// So the file decides. A career bundle is imported alongside the saves
/// already here; a whole-database backup goes to the shared restore prompt,
/// which asks first, because that one REPLACES everything.
Future<void> _importCareer(BuildContext context, WidgetRef ref) async {
  final l = AppLocalizations.of(context);
  final picked = await FilePicker.pickFiles();
  final path = picked?.files.single.path;
  if (path == null || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  final refusal = await ref.read(careerTransferServiceProvider).import(path);
  if (refusal == null) {
    messenger.showSnackBar(SnackBar(content: Text(l.careerImported)));
    return;
  }
  // Not a career. Before calling it rubbish, ask whether it is the OTHER
  // thing this screen writes.
  if (refusal == BundleRejection.unreadable) {
    final asBackup = SaveBackup.inspect(path);
    if (asBackup.rejection == null && context.mounted) {
      final refused = await BackupRestorePrompt.confirmAndRestore(
        context,
        ref,
        path,
      );
      // A successful restore tears the app down and rebuilds it, so there is
      // usually nobody left here to tell.
      if (refused != null && context.mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(BackupRestorePrompt.reason(l, refused))),
        );
      }
      return;
    }
    // A backup this build genuinely cannot take says so in its own words,
    // rather than hiding behind "not a career".
    if (asBackup.rejection case final r?
        when r != BackupRejection.notAFnmSave) {
      messenger.showSnackBar(
        SnackBar(content: Text(BackupRestorePrompt.reason(l, r))),
      );
      return;
    }
  }
  messenger.showSnackBar(
    SnackBar(
      content: Text(switch (refusal) {
        BundleRejection.unreadable => l.careerImportFailedUnreadable,
        BundleRejection.fromANewerBuild => l.careerImportFailedNewer,
      }),
    ),
  );
}

/// The icon-sized spinner a file action wears while it runs.
///
/// Exactly the size of the icon it stands in for, so a button does not change
/// width the moment it is pressed.
class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 18,
    height: 18,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      color: AppColors.primary,
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
  /// Null while another file action is already running, which disables the
  /// row's export button rather than queueing a second write behind the first.
  final VoidCallback? onShare;

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
                // What the share icon used to be, in words. The icon said
                // nothing to anybody who had not already guessed it, and this
                // is the control that gets a career off the phone.
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: onShare,
                    icon: onShare == null
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          )
                        : const Icon(Icons.ios_share_rounded, size: 16),
                    label: Text(
                      l.careerExportSave,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Export lives under the meta lines as a LABELLED row, so the
          // delete bin is the only icon left here. An icon and a button doing
          // the same thing in one card is a question, not a shortcut.
          IconButton(
            tooltip: l.careerDelete,
            icon: const Icon(Icons.delete_outline, color: AppColors.outline),
            onPressed: onDelete,
          ),
          const Icon(Icons.chevron_right, color: AppColors.primary),
        ],
      ),
    );
  }
}
