import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/pack_issue_text.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';

/// One database as the world pickers (New Game's chip, the Settings default)
/// list it.
@immutable
class WorldChoice {
  const WorldChoice({
    required this.id,
    required this.uuid,
    required this.name,
    required this.status,
    this.reason,
  });

  final int id;

  /// The pack's uuid ('' for one that cannot be read).
  final String uuid;
  final String name;
  final PackStatus status;

  /// Why it cannot start a career, in words: its first missing thing
  /// ("Czechia: 2 goalkeepers needed"), or "Needs attention". Null when it
  /// can.
  final String? reason;

  /// Whether a career can start on it: complete and compatible.
  bool get selectable => status == PackStatus.ready;
}

/// Every database on the device as the world pickers list it, by name, each
/// checked ([assessPack]) against the nations a career created now starts
/// with. Follows [worldPacksProvider], which every pack write invalidates.
final FutureProvider<List<WorldChoice>> worldChoicesProvider =
    FutureProvider<List<WorldChoice>>((ref) async {
      final summaries = await ref.watch(worldPacksProvider.future);
      final world = await ref.watch(nationsProvider.future);
      final l = ref.watch(appLocalizationsProvider);
      final repo = ref.watch(worldPackRepositoryProvider);
      final byId = {for (final n in world) n.id: n};
      final out = <WorldChoice>[];
      for (final s in summaries) {
        WorldPack? pack;
        try {
          pack = await repo.load(s.id);
        } on FormatException {
          pack = null;
        }
        final a = assessPack(pack, world);
        String? reason;
        switch (a.status) {
          case PackStatus.ready:
            reason = null;
          case PackStatus.needsAttention:
            reason = l.editorStatusAttention;
          case PackStatus.unreadable:
            reason = l.editorStatusUnreadable;
          case PackStatus.missing:
            final t = describePackIssue(l, a.issues.first, pack!, byId);
            reason = '${t.title}: ${t.detail}';
        }
        out.add(
          WorldChoice(
            id: s.id,
            uuid: pack?.uuid ?? '',
            name: s.name,
            status: a.status,
            reason: reason,
          ),
        );
      }
      return out;
    });

/// The world the career being started in New Game takes: a pack id, or
/// null for the game's own world. Starts from the Settings default
/// ([seedNewGameWorld]); the chip changes it for this one career, and it
/// goes back to the default once the career is made ([resetNewGameWorld]).
final newGameWorldProvider = StateProvider<int?>((ref) => null);

/// Whether [newGameWorldProvider] has been set for the career being started,
/// by the Settings default or by the chip.
final _newGameWorldSetProvider = StateProvider<bool>((ref) => false);

/// Sets the world of the career being started to pack [id] (null: Default).
void chooseNewGameWorld(ProviderContainer c, int? id) {
  c.read(newGameWorldProvider.notifier).state = id;
  c.read(_newGameWorldSetProvider.notifier).state = true;
}

/// The next career starts from the Settings default again.
void resetNewGameWorld(ProviderContainer c) {
  c
    ..invalidate(newGameWorldProvider)
    ..invalidate(_newGameWorldSetProvider);
}

/// The id of the pack the Settings default names, if it can start a career
/// now (on the device, complete and compatible); null for Default.
Future<int?> resolveDefaultWorld(ProviderContainer c) async {
  final uuid = await c.read(defaultWorldProvider.notifier).read();
  if (uuid == null) return null;
  final choices = await c.read(worldChoicesProvider.future);
  return choices.firstWhereOrNull((w) => w.uuid == uuid && w.selectable)?.id;
}

/// Puts New Game on the Settings default world, unless the world of the
/// career being started is already set (the chip was used). A default that
/// cannot start a career is Default, silently.
Future<void> seedNewGameWorld(ProviderContainer c) async {
  if (c.read(_newGameWorldSetProvider)) return;
  final id = await resolveDefaultWorld(c);
  // The chip may have spoken while the default was read.
  if (c.read(_newGameWorldSetProvider)) return;
  chooseNewGameWorld(c, id);
}

/// What a world sheet returns: the world picked (`choice` null: Default).
typedef WorldPick = ({WorldChoice? choice});

/// The world sheet: Default and every database, those that cannot start a
/// career greyed out with the reason. [selected] says which row is ticked
/// (null: Default). Null when it is closed without a pick.
Future<WorldPick?> showWorldChoiceSheet(
  BuildContext context, {
  required bool Function(WorldChoice? choice) selected,
}) => showAdaptiveSheet<WorldPick>(
  context: context,
  isScrollControlled: true,
  builder: (ctx) => WorldChoiceSheet(selected: selected),
);

/// The body of [showWorldChoiceSheet].
class WorldChoiceSheet extends ConsumerWidget {
  const WorldChoiceSheet({required this.selected, super.key});

  static const Key defaultKey = Key('worldSheet.default');
  static const Key closeKey = Key('worldSheet.close');

  /// The row of pack [id].
  static Key packKey(int id) => Key('worldSheet.pack.$id');

  final bool Function(WorldChoice? choice) selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final choices = ref.watch(worldChoicesProvider);
    Widget tick({required bool on}) => on
        ? const Icon(Icons.check_rounded, color: AppColors.primary)
        : const SizedBox(width: 24);
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.xs,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l.worldSheetTitle,
                      style: AppTypography.titleMedium,
                    ),
                  ),
                  IconButton(
                    key: closeKey,
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                    icon: const Icon(Icons.close, color: AppColors.primary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Text(
                l.worldSheetBlurb,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    key: defaultKey,
                    leading: const Icon(
                      Icons.public_rounded,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      l.worldDefault,
                      style: AppTypography.bodyMedium,
                    ),
                    subtitle: Text(
                      l.worldDefaultAbout,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    trailing: tick(on: selected(null)),
                    onTap: () =>
                        Navigator.of(context).pop<WorldPick>((choice: null)),
                  ),
                  for (final c in choices.valueOrNull ?? const <WorldChoice>[])
                    KeyedSubtree(
                      key: packKey(c.id),
                      child: ListTile(
                        enabled: c.selectable,
                        leading: Icon(
                          c.selectable
                              ? Icons.dataset_outlined
                              : Icons.block_rounded,
                          color: c.selectable
                              ? AppColors.primary
                              : AppColors.outline,
                        ),
                        title: Text(
                          c.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodyMedium,
                        ),
                        subtitle: Text(
                          c.reason ?? l.editorStatusReady,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelSmall.copyWith(
                            color: c.selectable
                                ? AppColors.positive
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                        trailing: tick(on: c.selectable && selected(c)),
                        onTap: () =>
                            Navigator.of(context).pop<WorldPick>((choice: c)),
                      ),
                    ),
                  if (choices.valueOrNull == null && choices.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

/// "World: Default ▾" on the nation pick: the world the career being started
/// takes. Opens the world sheet; a pick changes this one career only.
class WorldChip extends ConsumerStatefulWidget {
  const WorldChip({super.key});

  static const Key chipKey = Key('worldChip');

  @override
  ConsumerState<WorldChip> createState() => _WorldChipState();
}

class _WorldChipState extends ConsumerState<WorldChip> {
  @override
  void initState() {
    super.initState();
    // The container, not the ref: the default may land after this chip is
    // gone (the manager went on to New Game), and must land all the same.
    final c = ProviderScope.containerOf(context, listen: false);
    unawaited(Future.microtask(() => seedNewGameWorld(c)));
  }

  Future<void> _pick() async {
    final c = ProviderScope.containerOf(context, listen: false);
    final current = ref.read(newGameWorldProvider);
    final pick = await showWorldChoiceSheet(
      context,
      selected: (w) => w?.id == current,
    );
    if (pick == null) return;
    chooseNewGameWorld(c, pick.choice?.id);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final id = ref.watch(newGameWorldProvider);
    final choices = ref.watch(worldChoicesProvider).valueOrNull;
    final chosen = id == null
        ? null
        : choices?.firstWhereOrNull((c) => c.id == id);
    // A pick that has since gone stale (the database deleted, or no longer
    // complete and compatible) is not passed off as ready: gone, it reads
    // Default; still there, it is named in the warning colour with the
    // reason as its tooltip, and Start refuses it.
    final stale = chosen != null && !chosen.selectable;
    final color = stale ? AppColors.error : AppColors.primary;
    final chip = ActionChip(
      key: WorldChip.chipKey,
      onPressed: _pick,
      avatar: Icon(
        stale ? Icons.error_outline_rounded : Icons.public_rounded,
        size: 16,
        color: color,
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              l.worldChip(chosen?.name ?? l.worldDefault),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMedium.copyWith(color: color),
            ),
          ),
          Icon(Icons.arrow_drop_down_rounded, size: 18, color: color),
        ],
      ),
      backgroundColor: AppColors.surfaceContainer,
      side: BorderSide(
        color: stale ? AppColors.error : AppColors.outlineVariant,
      ),
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.xlAll),
      visualDensity: VisualDensity.compact,
    );
    final reason = chosen?.reason;
    return stale && reason != null
        ? Tooltip(message: reason, child: chip)
        : chip;
  }
}
