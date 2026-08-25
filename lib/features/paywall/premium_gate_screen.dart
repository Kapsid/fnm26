import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// How many four-year cycles a manager gets before the wall. One: a complete
/// campaign — qualifying, a continental championship and a World Cup — with
/// nothing held back, which is a far better advertisement than a nation list
/// with padlocks on it.
const int kFreeCycles = 1;

/// The wall at the end of the free cycle: what carrying on is worth, what it
/// costs, and the two things a manager can do about it.
///
/// Shown as a full page rather than a sheet on purpose. A sheet is something
/// you flick away; this is a decision point in the career, and it should read
/// as one.
///
/// NOT WIRED TO A STORE. "Buy" simply continues — the purchase flow, the
/// receipt and its verification are a separate job (see the monetisation
/// spec). What this settles is the shape of the gate and where it sits, which
/// is the part everything else hangs off.
class PremiumGateScreen extends ConsumerWidget {
  const PremiumGateScreen({super.key});

  /// Opens the gate over [context]. Resolves true when the manager chose to
  /// carry on, false when they left.
  static Future<bool> show(BuildContext context) async =>
      await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const PremiumGateScreen()),
      ) ??
      false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return PopScope(
      // The two buttons are the only ways out: a back-swipe that quietly
      // returned "not bought" would look like the gate had failed.
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Centred in the space left over rather than scrolled. The
                // page used to be a scroll view of a paragraph, five benefit
                // lines and a price — enough text that the decision was
                // buried in it, and on a small phone the price sat below the
                // fold on the one screen where the price is the point.
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.workspace_premium,
                          size: 56,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          l.gateTitle,
                          textAlign: TextAlign.center,
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l.gateLead,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // Three, not five. Ten save slots and "every future
                        // update included" are true and neither of them is why
                        // anybody pays: a list long enough to skim is a list
                        // nobody reads.
                        _Benefit(Icons.all_inclusive, l.gateBenefitEndless),
                        _Benefit(Icons.public, l.gateBenefitNations),
                        _Benefit(Icons.wifi_off_rounded, l.gateBenefitOffline),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          l.gatePriceLead,
                          textAlign: TextAlign.center,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          l.gatePrice,
                          textAlign: TextAlign.center,
                          style: AppTypography.displayLarge.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: l.gateBuy,
                  icon: Icons.lock_open_rounded,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l.gateNotChargedYet,
                  textAlign: TextAlign.center,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l.gateExit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    child: Row(
      children: [
        Icon(icon, size: 22, color: AppColors.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(text, style: AppTypography.bodyMedium)),
      ],
    ),
  );
}
