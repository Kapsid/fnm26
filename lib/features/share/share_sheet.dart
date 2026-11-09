import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/share_origin.dart';
import 'package:fnm/features/share/share_capture.dart';
import 'package:fnm/features/share/share_card_kit.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/adaptive_sheet.dart';
import 'package:fnm/shared/widgets/primary_button.dart';

/// Builds a share card in the given format.
typedef ShareCardBuilder = Widget Function(ShareFormat format);

/// What to do with the image: the OS share sheet, or straight into the
/// phone's photos.
enum ShareAction { share, save }

/// Keys for tests.
abstract final class ShareKeys {
  static const button = Key('share.button');
  static const sheet = Key('share.sheet');
  static Key format(ShareFormat f) => Key('share.format.${f.name}');
  static Key action(ShareAction a) => Key('share.action.${a.name}');
  static Key preview(ShareFormat f) => Key('share.preview.${f.name}');
}

/// Asks for a format (square or story) and what to do with it (share, or
/// save to photos), renders the card at full size, and hands the PNG on.
///
/// [origin] is the tapped button's rect, taken before any await (an iPad's
/// popover points at it).
Future<void> shareCard(
  BuildContext context, {
  required ShareCardBuilder card,
  required String fileStem,
  Iterable<String> flagCodes = const [],
  Iterable<Uint8List> images = const [],
  Rect? origin,
}) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.maybeOf(context);
  final container = ProviderScope.containerOf(context, listen: false);
  final sink = container.read(shareImageSinkProvider);
  final saver = container.read(shareImageSaverProvider);
  final choice = await showAdaptiveSheet<(ShareFormat, ShareAction)>(
    context: context,
    // As tall as the preview needs, up to the screen: the sheet scrolls the
    // rest and keeps its buttons pinned.
    isScrollControlled: true,
    builder: (sheetContext) => _FormatSheet(
      card: card,
      flagCodes: flagCodes,
      images: images,
      onPick: (f, a) => Navigator.of(sheetContext).pop((f, a)),
    ),
  );
  if (choice == null || !context.mounted) return;
  final (format, action) = choice;
  void say(String text) =>
      messenger?.showSnackBar(SnackBar(content: Text(text)));
  try {
    final png = await renderShareCard(
      context,
      card: card(format),
      format: format,
      flagCodes: flagCodes,
      images: images,
    );
    final name = '$fileStem-${format.name}';
    switch (action) {
      case ShareAction.share:
        await sink(png, '$name.png', origin);
      case ShareAction.save:
        switch (await saver(png, name)) {
          case ShareSaveResult.saved:
            say(l.shareSavedToPhotos);
          case ShareSaveResult.denied:
            say(l.sharePhotosDenied);
          case ShareSaveResult.failed:
            say(l.shareFailed);
        }
    }
  } on Object catch (e, st) {
    AppLog.error('share-card', e, st);
    say(l.shareFailed);
  }
}

/// The format to draw (square selected to begin with), a preview of the very
/// image that will go out, and the two things to do with it.
///
/// The preview is the card itself, scaled down, so what the manager sees is
/// what he shares. It waits behind a placeholder for the same warm-up the
/// capture waits for, so it never shows a card with its flags missing.
///
/// The title, the formats and the preview scroll; the two buttons stay
/// pinned under them, so they are in reach on the smallest phone.
class _FormatSheet extends StatefulWidget {
  const _FormatSheet({
    required this.card,
    required this.flagCodes,
    required this.images,
    required this.onPick,
  });

  final ShareCardBuilder card;
  final Iterable<String> flagCodes;
  final Iterable<Uint8List> images;
  final void Function(ShareFormat format, ShareAction action) onPick;

  @override
  State<_FormatSheet> createState() => _FormatSheetState();
}

class _FormatSheetState extends State<_FormatSheet> {
  ShareFormat _format = ShareFormat.square;
  bool _warm = false;
  bool _warming = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Once, here rather than in initState: precaching reads the context's
    // MediaQuery.
    if (_warming) return;
    _warming = true;
    unawaited(
      warmShareArt(
        context,
        flagCodes: widget.flagCodes,
        images: widget.images,
      ).then((_) {
        if (mounted) setState(() => _warm = true);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      key: ShareKeys.sheet,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l.shareSheetTitle,
                      textAlign: TextAlign.center,
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        for (final f in ShareFormat.values) ...[
                          if (f != ShareFormat.values.first)
                            const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _FormatTile(
                              format: f,
                              selected: f == _format,
                              label: f.isStory
                                  ? l.shareFormatStory
                                  : l.shareFormatSquare,
                              onTap: () => setState(() => _format = f),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _Preview(
                      format: _format,
                      card: _warm ? widget.card(_format) : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      key: ShareKeys.action(ShareAction.save),
                      onPressed: () => widget.onPick(_format, ShareAction.save),
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(l.shareSaveToPhotos, maxLines: 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton.icon(
                      key: ShareKeys.action(ShareAction.share),
                      onPressed: () =>
                          widget.onPick(_format, ShareAction.share),
                      icon: const Icon(Icons.ios_share, size: 18),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(l.shareButton, maxLines: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The card in [format], scaled to fit: never wider than the sheet, and
/// never taller than a share of the screen (a story is tall), its aspect
/// kept. A spinner in the same frame until [card] is ready (null).
class _Preview extends StatelessWidget {
  const _Preview({required this.format, required this.card});

  final ShareFormat format;
  final Widget? card;

  /// The tallest the preview may stand, as a share of the screen's height.
  static double heightShare(ShareFormat f) => f.isStory ? 0.46 : 0.36;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context).height;
    final aspect = format.size.width / format.size.height;
    return LayoutBuilder(
      builder: (context, c) {
        final maxH = screen * heightShare(format);
        final w = math.min(c.maxWidth, maxH * aspect);
        final h = w / aspect;
        final card = this.card;
        return Center(
          child: Container(
            key: ShareKeys.preview(format),
            width: w,
            height: h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x73000000),
                  blurRadius: 24,
                  offset: Offset(0, 3),
                ),
              ],
              color: AppColors.surfaceContainerLowest,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: card == null
                  ? const Center(
                      child: SizedBox.square(
                        dimension: 28,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    )
                  // The card at its own 1080-wide size, scaled down whole:
                  // the preview is the image, not a lookalike.
                  : FittedBox(
                      child: SizedBox.fromSize(
                        size: format.size,
                        child: card,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

/// One format: its shape drawn to scale beside its name; ringed when chosen.
class _FormatTile extends StatelessWidget {
  const _FormatTile({
    required this.format,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final ShareFormat format;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const h = 36.0;
    final w = h * format.size.width / format.size.height;
    return Material(
      color: selected
          ? AppColors.surfaceContainerHighest
          : AppColors.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.mdAll,
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.outlineVariant,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        key: ShareKeys.format(format),
        borderRadius: AppRadii.mdAll,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: w,
                height: format.isStory ? h : w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.outline,
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Shrinks rather than cuts: a 320-wide phone and a long
              // language must still read the whole word.
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: AppTypography.labelLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A Share action: opens the format sheet and shares the card. [compact]
/// draws it as an icon button (in a card's header); else an outlined button
/// with its label (beside the full-time Continue).
class ShareCardButton extends StatelessWidget {
  const ShareCardButton({
    required this.card,
    required this.fileStem,
    this.flagCodes = const [],
    this.images = const [],
    this.compact = false,
    this.height = 48,
    this.bigLabel,
    super.key = ShareKeys.button,
  });

  final ShareCardBuilder card;
  final String fileStem;
  final Iterable<String> flagCodes;

  /// A custom world's trophy pictures on the card, warmed before capture.
  final Iterable<Uint8List> images;
  final bool compact;
  final double height;

  /// When set, a full-width silver call-to-action with this label instead
  /// of the icon or the outlined button (the My Career tab's big one).
  final String? bigLabel;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Builder(
      builder: (button) {
        void tap() => shareCard(
          context,
          card: card,
          fileStem: fileStem,
          flagCodes: flagCodes,
          images: images,
          origin: shareOriginOf(button),
        );
        final big = bigLabel;
        if (big != null) {
          return PrimaryButton(
            label: big,
            icon: Icons.ios_share,
            onPressed: tap,
          );
        }
        if (compact) {
          return IconButton(
            tooltip: l.shareButton,
            onPressed: tap,
            icon: const Icon(Icons.ios_share, color: AppColors.primary),
          );
        }
        return SizedBox(
          height: height,
          child: OutlinedButton.icon(
            onPressed: tap,
            icon: const Icon(Icons.ios_share, size: 18),
            label: Text(l.shareButton),
          ),
        );
      },
    );
  }
}
