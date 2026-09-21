import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/paywall/paywall_parts.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Opens the premium paywall as a bottom sheet. Resolves once the sheet is
/// dismissed; check [premiumUnlockedProvider] afterwards for the outcome.
Future<void> showPaywall(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surfaceContainer,
    isScrollControlled: true,
    builder: (_) => const PaywallSheet(),
  );
}

/// The settings entry into the same purchase the gate sells.
///
/// It exists for one thing the gate cannot do: reach somebody who has NOT
/// finished a cycle. A manager restoring a purchase made on an old phone, or
/// simply deciding early, must not have to play out four years to find a
/// Restore button. The wall itself — the benefits, the price, the buttons and
/// every store state behind them — is [PaywallBenefits] and [PaywallActions],
/// the same widgets the gate page builds, so there is one wall with two
/// doors rather than two walls telling different stories.
class PaywallSheet extends ConsumerWidget {
  const PaywallSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    // Close on success so the newly unlocked screen is what the player sees.
    ref.listen(premiumUnlockedProvider, (was, now) {
      if (now && context.mounted) Navigator.of(context).pop();
    });

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.lg,
        AppSpacing.marginMobile,
        AppSpacing.marginMobile + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.sports_soccer, size: 44, color: AppColors.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.paywallGoPro,
            textAlign: TextAlign.center,
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.paywallOneTimeUnlock,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const PaywallBenefits(),
          const SizedBox(height: AppSpacing.lg),
          const PaywallActions(),
        ],
      ),
    );
  }
}
