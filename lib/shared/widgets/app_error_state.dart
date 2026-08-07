import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The app-standard placeholder for a failed load: a muted icon, a short
/// human-readable message, and an optional retry action.
///
/// Replaces the bare `Center(child: Text('$e'))` that screens used to show — a
/// pattern that gave no way to recover and leaked the raw exception string. Pass
/// a screen-specific [message]; if omitted, a generic one is shown. Wire
/// [onRetry] to `ref.invalidate(theProvider)` so the user can try again.
class AppErrorState extends StatelessWidget {
  const AppErrorState({this.message, this.onRetry, super.key});

  /// The user-facing message. When null, a generic "something went wrong" line
  /// is shown — never the raw exception.
  final String? message;

  /// Called when the user taps Retry. When null, no retry button is shown.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 40,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message ?? l.commonSomethingWentWrong,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(l.commonRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
