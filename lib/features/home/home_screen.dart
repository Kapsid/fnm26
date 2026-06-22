import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The app's landing screen.
///
/// Still a placeholder for the real new-game / continue flows (M3), but now
/// dressed in the "Pro Pitch Executive" design system.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.marginMobile,
          ),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/fnm_logo.png',
                width: 168,
                height: 168,
                // Graceful fallback if the asset is missing in a bare test env.
                errorBuilder: (context, error, stack) => const Icon(
                  Icons.sports_soccer,
                  size: 112,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Football Nations\nManager',
                textAlign: TextAlign.center,
                style: text.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'LEAD YOUR NATION · FOUR-YEAR CYCLE',
                textAlign: TextAlign.center,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'New Game',
                icon: Icons.play_arrow_rounded,
                onPressed: () => _comingSoon(context, 'New Game'),
              ),
              const SizedBox(height: AppSpacing.sm + 4),
              PrimaryButton(
                label: 'Continue',
                icon: Icons.save_rounded,
                onPressed: () => _comingSoon(context, 'Continue'),
              ),
              if (kDebugMode) ...[
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => context.go(Routes.gallery),
                  child: const Text('Style gallery'),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$feature — coming soon')),
      );
  }
}
