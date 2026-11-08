import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// What the app shows instead of itself when the save database will not open,
/// which in practice means an upgrade's migration failed.
///
/// The alternative is the saves list with nothing on it, which reads as "your
/// careers are gone" when they are not. With a copy from before the upgrade
/// ([onRestore] given) it says so and offers to put it back; otherwise it
/// says only that the saves would not open. Either way it offers to try again.
///
/// It stands in for the whole app, so it brings its own [MaterialApp]: there
/// is no router or provider behind it worth trusting.
class SaveUpgradeFailedScreen extends StatefulWidget {
  const SaveUpgradeFailedScreen({
    required this.onRetry,
    this.onRestore,
    this.locale,
    super.key,
  });

  /// Tears the app down and opens the database again.
  final VoidCallback onRetry;

  /// Puts the copy from before the upgrade back, then retries; resolves to
  /// false when it could not, and the screen says so. Null when there is no
  /// such copy, which also picks the neutral wording.
  final Future<bool> Function()? onRestore;

  /// The language chosen in Settings; null follows the device.
  final Locale? locale;

  @override
  State<SaveUpgradeFailedScreen> createState() =>
      _SaveUpgradeFailedScreenState();
}

class _SaveUpgradeFailedScreenState extends State<SaveUpgradeFailedScreen> {
  bool _busy = false;

  /// The last restore did not happen.
  bool _restoreFailed = false;

  Future<void> _restore() async {
    setState(() {
      _busy = true;
      _restoreFailed = false;
    });
    var ok = false;
    try {
      ok = await widget.onRestore!();
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _restoreFailed = !ok;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    locale: widget.locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) {
        final l = AppLocalizations.of(context);
        final hasCopy = widget.onRestore != null;
        final retry = Text(l.commonRetry);
        final onRetry = _busy ? null : widget.onRetry;
        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 40,
                        color: AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        hasCopy
                            ? l.saveUpgradeFailedTitle
                            : l.saveOpenFailedTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        hasCopy
                            ? l.saveUpgradeFailedBody
                            : l.saveOpenFailedBody,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (_restoreFailed) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          l.saveUpgradeRestoreFailed,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      if (hasCopy) ...[
                        FilledButton(
                          onPressed: _busy ? null : _restore,
                          child: Text(
                            l.saveUpgradeRestoreButton,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        OutlinedButton(onPressed: onRetry, child: retry),
                      ] else
                        FilledButton(onPressed: onRetry, child: retry),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
