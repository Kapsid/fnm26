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

/// Builds a share card in the given format.
typedef ShareCardBuilder = Widget Function(ShareFormat format);

/// Keys for tests.
abstract final class ShareKeys {
  static const button = Key('share.button');
  static const sheet = Key('share.sheet');
  static Key format(ShareFormat f) => Key('share.format.${f.name}');
}

/// Asks for a format (square or story), renders the card in it at full
/// size, and hands the PNG to the platform's share sheet.
///
/// [origin] is the tapped button's rect, taken before any await (an iPad's
/// popover points at it).
Future<void> shareCard(
  BuildContext context, {
  required ShareCardBuilder card,
  required String fileStem,
  Iterable<String> flagCodes = const [],
  Rect? origin,
}) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.maybeOf(context);
  final sink = ProviderScope.containerOf(
    context,
    listen: false,
  ).read(shareImageSinkProvider);
  final format = await showAdaptiveSheet<ShareFormat>(
    context: context,
    builder: (sheetContext) => _FormatSheet(
      onPick: (f) => Navigator.of(sheetContext).pop(f),
    ),
  );
  if (format == null || !context.mounted) return;
  try {
    final png = await renderShareCard(
      context,
      card: card(format),
      format: format,
      flagCodes: flagCodes,
    );
    await sink(png, '$fileStem-${format.name}.png', origin);
  } on Object catch (e, st) {
    AppLog.error('share-card', e, st);
    messenger?.showSnackBar(SnackBar(content: Text(l.shareFailed)));
  }
}

class _FormatSheet extends StatelessWidget {
  const _FormatSheet({required this.onPick});

  final ValueChanged<ShareFormat> onPick;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      key: ShareKeys.sheet,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.shareSheetTitle,
              textAlign: TextAlign.center,
              style: AppTypography.titleMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                for (final f in ShareFormat.values) ...[
                  if (f != ShareFormat.values.first)
                    const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _FormatTile(
                      format: f,
                      label: f.isStory
                          ? l.shareFormatStory
                          : l.shareFormatSquare,
                      onTap: () => onPick(f),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One format: its shape drawn to scale, and its name.
class _FormatTile extends StatelessWidget {
  const _FormatTile({
    required this.format,
    required this.label,
    required this.onTap,
  });

  final ShareFormat format;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const h = 96.0;
    final w = h * format.size.width / format.size.height;
    return Material(
      color: AppColors.surfaceContainerHigh,
      borderRadius: AppRadii.mdAll,
      child: InkWell(
        key: ShareKeys.format(format),
        borderRadius: AppRadii.mdAll,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            children: [
              SizedBox(
                height: h,
                child: Center(
                  child: Container(
                    width: w,
                    height: format.isStory ? h : w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.primary, width: 1.5),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF2A2E33), Color(0xFF111316)],
                      ),
                    ),
                    child: const Icon(
                      Icons.emoji_events_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(label, style: AppTypography.labelLarge),
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
    this.compact = false,
    this.height = 48,
    super.key = ShareKeys.button,
  });

  final ShareCardBuilder card;
  final String fileStem;
  final Iterable<String> flagCodes;
  final bool compact;
  final double height;

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
          origin: shareOriginOf(button),
        );
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
