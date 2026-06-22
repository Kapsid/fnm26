import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/shared/widgets/primary_button.dart';

/// The app's landing screen.
///
/// This is an M0 placeholder that proves the app boots, themes render, and the
/// reusable widgets/router are wired up. The real new-game / continue flows
/// arrive in later milestones.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/fnm_logo.png',
                width: 180,
                height: 180,
                // Graceful fallback if the asset is missing in a bare test env.
                errorBuilder: (context, error, stack) => const Icon(
                  Icons.sports_soccer,
                  size: 120,
                  color: AppColors.pitchGreenBright,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Football Nations Manager',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lead your nation through a four-year cycle.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'New Game',
                icon: Icons.play_arrow_rounded,
                onPressed: () => _comingSoon(context, 'New Game'),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Continue',
                icon: Icons.save_rounded,
                onPressed: () => _comingSoon(context, 'Continue'),
              ),
              const SizedBox(height: 24),
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
