import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/library_tactic.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/tactic_library_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';

/// Keys the tactics library's widgets carry, for tests.
abstract final class TacticLibraryKeys {
  static const Key saveButton = Key('tacticLibrary.save');
  static const Key loadButton = Key('tacticLibrary.load');
  static const Key nameField = Key('tacticLibrary.nameField');
  static Key tile(int id) => Key('tacticLibrary.tile.$id');
  static Key menu(int id) => Key('tacticLibrary.menu.$id');
}

/// The name a tactic is offered under when it is saved to the library: its
/// shape and, when it has one, its style ("4-3-3 Gegenpress").
String defaultLibraryName(
  Formation formation,
  Playstyle playstyle,
  String Function(Playstyle) styleLabel,
) => playstyle == Playstyle.custom
    ? formation.label
    : '${formation.label} ${styleLabel(playstyle)}';

/// Asks for a name (offering [defaultName]) and saves [careerId]'s current
/// tactic to the library under it.
Future<void> saveTacticToLibrary(
  BuildContext context,
  WidgetRef ref, {
  required int careerId,
  required String defaultName,
}) async {
  final name = await showDialog<String>(
    context: context,
    builder: (_) => TacticNameDialog(initial: defaultName),
  );
  if (name == null || name.trim().isEmpty) return;
  final saved = await ref
      .read(tacticLibraryServiceProvider)
      .saveCurrent(careerId, name.trim());
  if (saved && context.mounted) {
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l.tacticsLibrarySaved(name.trim()))));
  }
}

/// Copies one save's [preset] into the library, under a name the manager
/// confirms (its own name to start with).
Future<void> savePresetToLibrary(
  BuildContext context,
  WidgetRef ref,
  TacticPreset preset,
) async {
  final name = await showDialog<String>(
    context: context,
    builder: (_) => TacticNameDialog(initial: preset.name),
  );
  if (name == null || name.trim().isEmpty) return;
  await ref.read(tacticLibraryServiceProvider).savePreset(preset, name.trim());
  if (context.mounted) {
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l.tacticsLibrarySaved(name.trim()))));
  }
}

/// Opens the library to load a tactic into [careerId], or rename or delete
/// one. [styleLabel] names a playing style for each row's subtitle. Completes
/// with whether a tactic was loaded.
Future<bool> showTacticLibrary(
  BuildContext context, {
  required int careerId,
  required String Function(Playstyle) styleLabel,
}) async =>
    await showAdaptiveSheet<bool>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      isScrollControlled: true,
      builder: (_) =>
          TacticLibrarySheet(careerId: careerId, styleLabel: styleLabel),
    ) ??
    false;

/// The tactics library: every tactic the manager keeps across saves. A tap
/// loads one into this save; each row's menu renames or deletes it.
class TacticLibrarySheet extends ConsumerStatefulWidget {
  const TacticLibrarySheet({
    required this.careerId,
    required this.styleLabel,
    super.key,
  });

  final int careerId;
  final String Function(Playstyle) styleLabel;

  @override
  ConsumerState<TacticLibrarySheet> createState() => _TacticLibrarySheetState();
}

enum _RowAction { rename, delete }

class _TacticLibrarySheetState extends ConsumerState<TacticLibrarySheet> {
  Future<void> _load(LibraryTactic tactic) async {
    final fit = await ref
        .read(tacticLibraryServiceProvider)
        .apply(widget.careerId, tactic);
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop(fit != null);
    if (fit == null) return;
    final loaded = l.tacticsLibraryLoaded(tactic.name);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          fit.skipped == 0
              ? loaded
              : '$loaded\n${l.tacticsLibraryNotFitted(fit.skipped)}',
        ),
      ),
    );
  }

  Future<void> _rename(LibraryTactic tactic) async {
    final l = AppLocalizations.of(context);
    final name = await showDialog<String>(
      context: context,
      builder: (_) => TacticNameDialog(
        initial: tactic.name,
        title: l.tacticsLibraryRenameTitle,
      ),
    );
    final trimmed = name?.trim() ?? '';
    final id = tactic.id;
    if (trimmed.isEmpty || trimmed == tactic.name || id == null) return;
    final ok = await ref.read(tacticLibraryServiceProvider).rename(id, trimmed);
    if (!ok && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.tacticsLibraryNameTaken)));
    }
  }

  Future<void> _delete(LibraryTactic tactic) async {
    final l = AppLocalizations.of(context);
    final id = tactic.id;
    if (id == null) return;
    final sure = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.tacticsLibraryDeleteTitle(tactic.name)),
        content: Text(l.tacticsLibraryDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.tacticsCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.tacticsLibraryDelete),
          ),
        ],
      ),
    );
    if (sure ?? false) {
      await ref.read(tacticLibraryServiceProvider).delete(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final library = ref.watch(tacticLibraryProvider);
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: const BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: AppRadii.smAll,
                ),
              ),
            ),
            Text(
              l.tacticsLibraryTitle,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l.tacticsLibraryBlurb,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Flexible(
              child: library.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Text(l.tacticsLibraryCouldNotLoad(e.toString())),
                data: (tactics) {
                  if (tactics.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                      child: Text(
                        l.tacticsLibraryEmpty,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: tactics.length,
                    itemBuilder: (context, i) => _row(l, tactics[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(AppLocalizations l, LibraryTactic t) {
    final id = t.id ?? -1;
    final style = t.playstyle == Playstyle.custom
        ? null
        : widget.styleLabel(t.playstyle);
    return ListTile(
      key: TacticLibraryKeys.tile(id),
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.collections_bookmark, color: AppColors.primary),
      title: Text(t.name, style: AppTypography.bodyMedium),
      subtitle: Text(
        style == null ? t.formation.label : '${t.formation.label} · $style',
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      trailing: PopupMenuButton<_RowAction>(
        key: TacticLibraryKeys.menu(id),
        icon: const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
        onSelected: (action) => switch (action) {
          _RowAction.rename => _rename(t),
          _RowAction.delete => _delete(t),
        },
        itemBuilder: (_) => [
          PopupMenuItem(
            value: _RowAction.rename,
            child: Text(l.tacticsLibraryRename),
          ),
          PopupMenuItem(
            value: _RowAction.delete,
            child: Text(l.tacticsLibraryDelete),
          ),
        ],
      ),
      onTap: () => _load(t),
    );
  }
}

/// A small dialog to name (or rename) a library tactic, starting from
/// [initial] with the text selected so typing replaces it.
class TacticNameDialog extends StatefulWidget {
  const TacticNameDialog({required this.initial, super.key, this.title});

  final String initial;

  /// Defaults to "Name this tactic".
  final String? title;

  @override
  State<TacticNameDialog> createState() => _TacticNameDialogState();
}

class _TacticNameDialogState extends State<TacticNameDialog> {
  late final TextEditingController _controller =
      TextEditingController(
          text: widget.initial,
        )
        ..selection = TextSelection(
          baseOffset: 0,
          extentOffset: widget.initial.length,
        );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title ?? l.tacticsNameThisTactic),
      content: TextField(
        key: TacticLibraryKeys.nameField,
        controller: _controller,
        autofocus: true,
        maxLength: 40,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(hintText: l.tacticsNameHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.tacticsCancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l.tacticsSave)),
      ],
    );
  }
}
