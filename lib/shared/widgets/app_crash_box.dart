import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// What replaces a widget subtree that failed to build.
///
/// Flutter's default is the grey-on-red exception dump, which tells a player
/// nothing and looks like the app has broken beyond repair. This says the same
/// thing calmly and points at Settings → Diagnostics, where the error has
/// already been recorded by `AppLog`.
///
/// Unlike `AppErrorState`, this cannot assume anything about its context: an
/// `ErrorWidget` is inserted wherever the failure happened, which may be above
/// `MaterialApp` — so there may be no `Localizations`, no `Directionality` and
/// no `Material` ancestor. Everything it needs is supplied here, and the
/// localised message is looked up defensively with an English fallback.
class AppCrashBox extends StatelessWidget {
  const AppCrashBox({super.key});

  @override
  Widget build(BuildContext context) {
    final l = Localizations.of<AppLocalizations>(context, AppLocalizations);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: AppColors.surface,
        padding: const EdgeInsets.all(AppSpacing.lg),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 32,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l?.commonCrashBox ??
                  'Something went wrong here.\n'
                      'Settings → Diagnostics has the details.',
              textAlign: TextAlign.center,
              // Not AppTypography: that resolves fonts through a theme this
              // widget may not have. A plain style always renders.
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
