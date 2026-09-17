import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/entitlement/entitlement_service.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

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

/// The one-time premium unlock: benefits, the store's localised price, and
/// buy/restore actions driven by the EntitlementService.
class PaywallSheet extends ConsumerStatefulWidget {
  const PaywallSheet({super.key});

  @override
  ConsumerState<PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends ConsumerState<PaywallSheet> {
  String? _price;

  @override
  void initState() {
    super.initState();
    // Show the store's localised price once it loads; the button works
    // without it (buy() re-queries).
    unawaited(
      ref.read(entitlementServiceProvider).product().then((p) {
        if (mounted) setState(() => _price = p?.price);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final premium = ref.watch(premiumUnlockedProvider);
    final flow = ref.watch(purchaseFlowProvider);
    final service = ref.read(entitlementServiceProvider);
    final busy =
        flow == PurchaseFlowState.loading || flow == PurchaseFlowState.pending;

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
          const Icon(
            Icons.sports_soccer,
            size: 44,
            color: AppColors.primary,
          ),
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
          _benefit(Icons.public, l.paywallBenefitEveryNation),
          _benefit(Icons.save, l.paywallBenefitSaveSlots),
          _benefit(Icons.all_inclusive, l.paywallBenefitEndless),
          const SizedBox(height: AppSpacing.lg),
          if (premium)
            Text(
              l.paywallUnlocked,
              textAlign: TextAlign.center,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.positive,
              ),
            )
          else ...[
            PrimaryButton(
              label: busy
                  ? l.paywallContactingStore
                  : (_price == null
                        ? l.paywallUnlockPro
                        : l.paywallUnlockProPriced(_price!)),
              icon: Icons.lock_open_rounded,
              onPressed: busy ? null : service.buy,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: busy ? null : service.restore,
              child: Text(l.paywallRestorePurchases),
            ),
            if (flow == PurchaseFlowState.error &&
                service.lastError != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                service.lastError!,
                textAlign: TextAlign.center,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _benefit(IconData icon, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    child: Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(text, style: AppTypography.bodyMedium)),
      ],
    ),
  );
}
