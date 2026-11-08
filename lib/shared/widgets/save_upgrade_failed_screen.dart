import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// What the app shows instead of itself when the save database will not open,
/// which in practice means an upgrade's migration failed.
///
/// The alternative is the saves list with nothing on it, which reads as "your
/// careers are gone" when they are not: the file is untouched, and the copy
/// taken before the upgrade (`SaveBackup.writePreUpgradeCopy`) is in the
/// safety folder. This says so, and offers to try again.
///
/// It stands in for the whole app, so it brings its own [MaterialApp]: there
/// is no router or provider behind it worth trusting.
class SaveUpgradeFailedScreen extends StatelessWidget {
  const SaveUpgradeFailedScreen({required this.onRetry, super.key});

  /// Tears the app down and opens the database again.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) {
        final l = AppLocalizations.of(context);
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
                        l.saveUpgradeFailedTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l.saveUpgradeFailedBody,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      FilledButton(
                        onPressed: onRetry,
                        child: Text(l.commonRetry),
                      ),
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
