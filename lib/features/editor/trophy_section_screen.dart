import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/editor_ui.dart';
import 'package:fnm/features/editor/players/players_ui.dart';
import 'package:fnm/features/editor/trophy_crop_screen.dart';
import 'package:fnm/features/world_pack/trophy_image.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'trophy_section_tablet_layout.dart';

/// The Trophies section of a database: the nine trophies with the picture
/// each will show (the database's own or the game's), and for the picked
/// one a way to choose a picture from the device (framed, previewed and
/// stored by [TrophyCropScreen]) or to go back to the game's.
///
/// The picked trophy opens in a sheet on the phone, beside the grid on a
/// tablet.
class TrophySectionScreen extends ConsumerStatefulWidget {
  const TrophySectionScreen({required this.packId, super.key});

  static const Key tabletLayoutKey = Key('editorTrophies.tabletLayout');
  static const Key chooseKey = Key('editorTrophies.choose');
  static const Key resetKey = Key('editorTrophies.reset');
  static const Key resetConfirmKey = Key('editorTrophies.resetConfirm');

  static Key tileKey(String key) => Key('editorTrophies.tile.$key');

  /// The tile's picture when it is the database's own.
  static Key customKey(String key) => Key('editorTrophies.custom.$key');

  /// The tile's picture when it is the game's.
  static Key defaultKey(String key) => Key('editorTrophies.default.$key');

  /// The tile's "shows as a rectangle" mark.
  static Key warningKey(String key) => Key('editorTrophies.warning.$key');

  /// Every trophy key, in the cabinet's order.
  static List<String> get keys => [for (final t in Trophies.cabinet) t.key];

  /// The extensions the picker offers: [TrophyNormaliser] takes PNG and JPEG
  /// only.
  static const List<String> extensions = ['png', 'jpg', 'jpeg'];

  final int packId;

  @override
  ConsumerState<TrophySectionScreen> createState() =>
      _TrophySectionScreenState();
}

/// One trophy as the section shows it.
typedef _Trophy = ({String key, String label, Uint8List? png});

class _TrophySectionScreenState extends ConsumerState<TrophySectionScreen> {
  /// The trophy shown beside the grid (tablet).
  String? _picked;

  /// Whether a picked file is being read.
  bool _opening = false;

  int get _id => widget.packId;

  void _back() => context.go(editorPackLocation(_id));

  void _say(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  List<_Trophy> _trophies(AppLocalizations l, WorldPack pack) {
    final editor = ref.read(packEditorProvider(_id).notifier);
    return [
      for (final t in Trophies.cabinet)
        (
          key: t.key,
          // The database's own name for the competition, else the game's
          // in the player's language.
          label: pack.competitions[t.label] ?? competitionLabel(l, t.label),
          png: editor.trophy(t.key),
        ),
    ];
  }

  void _open(_Trophy t, {required bool tablet}) {
    if (tablet) {
      setState(() => _picked = t.key);
      return;
    }
    unawaited(
      showAdaptiveSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (sheet) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.marginMobile,
              AppSpacing.sm,
              AppSpacing.marginMobile,
              AppSpacing.lg,
            ),
            // Rebuilt from the pack, so the sheet never shows a picture
            // that has just been replaced.
            child: Consumer(
              builder: (context, ref, _) {
                final pack = ref.watch(packEditorProvider(_id)).valueOrNull;
                if (pack == null) return const SizedBox.shrink();
                final now = _trophies(
                  AppLocalizations.of(context),
                  pack,
                ).firstWhere((x) => x.key == t.key);
                return _TrophyDetail(
                  trophy: now,
                  // Close the sheet first: what follows opens pages and
                  // dialogs of its own.
                  onChoose: () {
                    Navigator.of(sheet).pop();
                    unawaited(_choose(now));
                  },
                  onReset: () {
                    Navigator.of(sheet).pop();
                    unawaited(_reset(now));
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Picks a picture for [t], has it framed and previewed, and stores it.
  Future<void> _choose(_Trophy t) async {
    final l = AppLocalizations.of(context);
    final pick = ref.read(editorFilePickerProvider);
    final String? path;
    try {
      path = await pick(extensions: TrophySectionScreen.extensions);
    } on Object catch (e, st) {
      AppLog.error('editor-trophy-pick', e, st);
      if (mounted) _say(l.editorPickFailed);
      return;
    }
    if (path == null || !mounted) return;

    setState(() => _opening = true);
    Uint8List? bytes;
    ui.Size? size;
    try {
      final file = File(path);
      // Too big is refused before anything is read into memory.
      if (await file.length() <= TrophyNormaliser.maxBytes) {
        bytes = await file.readAsBytes();
        size = await TrophyNormaliser.measure(bytes);
      }
    } on Object catch (e, st) {
      AppLog.error('editor-trophy-read', e, st);
    }
    if (!mounted) return;
    setState(() => _opening = false);
    if (bytes == null || size == null) {
      _say(l.editorTrophyUnusable);
      return;
    }

    final png = await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<Uint8List>(
        fullscreenDialog: true,
        builder: (_) => TrophyCropScreen(
          trophyKey: t.key,
          trophyName: t.label,
          source: bytes!,
          sourceSize: size!,
        ),
      ),
    );
    if (png == null || !mounted) return;
    final saved = await ref
        .read(packEditorProvider(_id).notifier)
        .setTrophy(t.key, png);
    if (mounted) _say(saved ? l.editorTrophySaved : l.editorTrophySaveFailed);
  }

  /// Gives [t] the game's picture again, once the player confirms: pictures
  /// are not in the undo history.
  Future<void> _reset(_Trophy t) async {
    final l = AppLocalizations.of(context);
    final sure = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        title: Text(l.editorTrophyResetTitle),
        content: Text(l.editorTrophyResetBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialog).pop(false),
            child: Text(l.editorCancel),
          ),
          TextButton(
            key: TrophySectionScreen.resetConfirmKey,
            onPressed: () => Navigator.of(dialog).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l.editorTrophyResetConfirm),
          ),
        ],
      ),
    );
    if (!(sure ?? false) || !mounted) return;
    final done = await ref
        .read(packEditorProvider(_id).notifier)
        .setTrophy(t.key, null);
    if (mounted) {
      _say(done ? l.editorTrophyRemoved : l.editorTrophySaveFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(packEditorProvider(_id));
    final tablet = useTabletLayout(context, ref);
    final title = sectionTitle(l, EditorSection.trophies);
    final pack = async.valueOrNull;

    if (pack == null) {
      return EditorFrame(
        tablet: tablet,
        tabletKey: TrophySectionScreen.tabletLayoutKey,
        title: title,
        onBack: _back,
        body: async.hasError
            ? AppErrorState(message: l.editorPackMissing)
            : const Center(child: CircularProgressIndicator()),
      );
    }

    final trophies = _trophies(l, pack);
    if (tablet) {
      return _TrophySectionTabletLayout(
        state: this,
        title: title,
        trophies: trophies,
        picked: trophies.where((t) => t.key == _picked).firstOrNull,
      );
    }
    return EditorFrame(
      tablet: false,
      tabletKey: TrophySectionScreen.tabletLayoutKey,
      title: title,
      onBack: _back,
      body: _Opening(
        opening: _opening,
        child: _TrophyGrid(
          trophies: trophies,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.sm,
            AppSpacing.marginMobile,
            AppSpacing.lg,
          ),
          onTap: (t) => _open(t, tablet: false),
        ),
      ),
    );
  }
}

/// [child] under a "reading the picture" veil while [opening].
class _Opening extends StatelessWidget {
  const _Opening({required this.opening, required this.child});

  final bool opening;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(child: child),
      if (opening) ...[
        const Positioned.fill(
          child: ModalBarrier(dismissible: false, color: Colors.black54),
        ),
        Center(
          child: _Working(AppLocalizations.of(context).editorTrophyOpening),
        ),
      ],
    ],
  );
}

/// A spinner with a line saying what it waits for.
class _Working extends StatelessWidget {
  const _Working(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: AppSpacing.md),
        Text(text, style: AppTypography.bodyMedium),
      ],
    ),
  );
}

/// The intro line and every trophy's tile.
class _TrophyGrid extends StatelessWidget {
  const _TrophyGrid({
    required this.trophies,
    required this.padding,
    required this.onTap,
    this.picked,
  });

  final List<_Trophy> trophies;
  final EdgeInsets padding;
  final void Function(_Trophy) onTap;

  /// The trophy shown beside the grid (tablet).
  final String? picked;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            padding.left,
            padding.top,
            padding.right,
            AppSpacing.md,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    l.editorTrophiesIntro,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            padding.left,
            0,
            padding.right,
            padding.bottom,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 170,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 0.62,
            ),
            itemCount: trophies.length,
            itemBuilder: (context, i) => _TrophyTile(
              trophy: trophies[i],
              picked: trophies[i].key == picked,
              onTap: () => onTap(trophies[i]),
            ),
          ),
        ),
      ],
    );
  }
}

/// A trophy's picture: the database's own (the trophy's `png`) or the
/// game's.
class _TrophyPicture extends StatelessWidget {
  const _TrophyPicture({required this.trophy, this.keyed = false});

  final _Trophy trophy;

  /// Whether the picture carries the tile keys tests look for.
  final bool keyed;

  @override
  Widget build(BuildContext context) {
    final png = trophy.png;
    Widget broken(BuildContext _, Object _, StackTrace? _) => const Icon(
      Icons.emoji_events_outlined,
      size: 40,
      color: AppColors.onSurfaceVariant,
    );
    if (png != null) {
      return Image.memory(
        png,
        key: keyed ? TrophySectionScreen.customKey(trophy.key) : null,
        fit: BoxFit.contain,
        gaplessPlayback: true,
        errorBuilder: broken,
      );
    }
    return Image.asset(
      Trophies.assetForKey(trophy.key) ?? Trophies.worldCup,
      key: keyed ? TrophySectionScreen.defaultKey(trophy.key) : null,
      fit: BoxFit.contain,
      errorBuilder: broken,
    );
  }
}

class _TrophyTile extends StatelessWidget {
  const _TrophyTile({
    required this.trophy,
    required this.picked,
    required this.onTap,
  });

  final _Trophy trophy;
  final bool picked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final custom = trophy.png != null;
    return AppCard(
      key: TrophySectionScreen.tileKey(trophy.key),
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.sm),
      border: picked ? Border.all(color: AppColors.primary, width: 2) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    child: _TrophyPicture(trophy: trophy, keyed: true),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: _RectangleCheck(
                    png: trophy.png,
                    child: Tooltip(
                      message: l.editorTrophyRectangleShort,
                      child: Icon(
                        Icons.crop_square,
                        key: TrophySectionScreen.warningKey(trophy.key),
                        size: 20,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            trophy.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            custom ? l.editorTrophyCustom : l.editorTrophyDefault,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              color: custom ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// The picked trophy: its picture large, what it is stored at, and the
/// choose and back-to-default actions.
class _TrophyDetail extends StatelessWidget {
  const _TrophyDetail({
    required this.trophy,
    required this.onChoose,
    required this.onReset,
    super.key,
  });

  final _Trophy trophy;
  final VoidCallback onChoose;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final custom = trophy.png != null;
    final size = TrophyNormaliser.sizeFor(trophy.key);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          trophy.label,
          textAlign: TextAlign.center,
          style: AppTypography.titleMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          custom ? l.editorTrophyCustom : l.editorTrophyDefault,
          textAlign: TextAlign.center,
          style: AppTypography.labelSmall.copyWith(
            color: custom ? AppColors.primary : AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(height: 220, child: _TrophyPicture(trophy: trophy)),
        const SizedBox(height: AppSpacing.md),
        Text(
          l.editorTrophySize(size.width.round(), size.height.round()),
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        _RectangleCheck(
          png: trophy.png,
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: RectangleWarning(text: l.editorTrophyRectangle),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          key: TrophySectionScreen.chooseKey,
          label: custom ? l.editorTrophyReplace : l.editorTrophyChoose,
          icon: Icons.add_photo_alternate_outlined,
          onPressed: onChoose,
        ),
        if (custom) ...[
          const SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            key: TrophySectionScreen.resetKey,
            onPressed: onReset,
            icon: const Icon(Icons.restore),
            label: Text(l.editorTrophyReset),
          ),
        ],
      ],
    );
  }
}

/// [child] when [png] will show as a rectangle
/// ([TrophyNormaliser.showsAsRectangle]), else nothing: also until that is
/// known, and for the game's own picture (null).
class _RectangleCheck extends StatefulWidget {
  const _RectangleCheck({required this.png, required this.child});

  final Uint8List? png;
  final Widget child;

  @override
  State<_RectangleCheck> createState() => _RectangleCheckState();
}

class _RectangleCheckState extends State<_RectangleCheck> {
  /// Answers already worked out, by picture. Values, not futures: a future
  /// is bound to the zone it was made in.
  static final Expando<bool> _known = Expando('trophyRectangle');

  bool _rectangle = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  @override
  void didUpdateWidget(_RectangleCheck old) {
    super.didUpdateWidget(old);
    if (!identical(old.png, widget.png)) _check();
  }

  void _check() {
    final png = widget.png;
    if (png == null) {
      _rectangle = false;
      return;
    }
    final known = _known[png];
    if (known != null) {
      _rectangle = known;
      return;
    }
    _rectangle = false;
    unawaited(
      TrophyNormaliser.showsAsRectangle(png).then((v) {
        _known[png] = v;
        if (mounted && identical(widget.png, png)) {
          setState(() => _rectangle = v);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) =>
      _rectangle ? widget.child : const SizedBox.shrink();
}
