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
import 'package:in_app_purchase/in_app_purchase.dart';

/// The two halves of the wall that must never differ between the places it is
/// shown: what the unlock is worth, and how it is bought.
///
/// There are two entry points into the same purchase. `PremiumGateScreen` is
/// the wall a blocked manager meets at the end of the free cycle; the sheet
/// from the settings page is the one somebody opens on purpose, usually to
/// restore a purchase made on another phone. Two walls written twice drift
/// apart, and the half that drifts is always the half with the price in it, so
/// both of them build the benefits and the buttons from here.

/// What carrying on is worth, said in three lines.
///
/// Three, not five. Ten save slots and "every future update included" are true
/// and neither of them is why anybody pays: a list long enough to skim is a
/// list nobody reads.
class PaywallBenefits extends StatelessWidget {
  const PaywallBenefits({this.iconSize = 20, super.key});

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _row(Icons.all_inclusive, l.paywallBenefitEndless),
        _row(Icons.save_rounded, l.paywallBenefitSaves),
        _row(Icons.bookmark_rounded, l.paywallBenefitCarryOn),
        _row(Icons.wifi_off_rounded, l.paywallBenefitOffline),
      ],
    );
  }

  Widget _row(IconData icon, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    child: Row(
      children: [
        Icon(icon, size: iconSize, color: AppColors.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(text, style: AppTypography.bodyMedium)),
      ],
    ),
  );
}

/// The purchase itself: the store's own price, the buy button, the restore
/// path, and every state a real store can leave them in.
///
/// The price is never copy. It is [ProductDetails.price] as the platform
/// formats it, in the currency of the account actually being charged, which is
/// the only number that is true for everybody.
class PaywallActions extends ConsumerStatefulWidget {
  const PaywallActions({this.prominentPrice = false, super.key});

  /// The full page prints the price large, above the buttons, because on that
  /// screen the price is the point. The sheet has no room for that and folds
  /// it into the button label instead.
  final bool prominentPrice;

  @override
  ConsumerState<PaywallActions> createState() => _PaywallActionsState();
}

class _PaywallActionsState extends ConsumerState<PaywallActions> {
  String? _price;
  bool _loadingProduct = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadProduct());
  }

  /// Asks the store what this costs. A null product means the store could not
  /// be reached or the listing is not live yet; either way there is nothing to
  /// sell, and the button says so rather than pretending.
  Future<void> _loadProduct() async {
    if (!_loadingProduct) setState(() => _loadingProduct = true);
    ProductDetails? details;
    try {
      details = await ref.read(entitlementServiceProvider).product();
    } on Object {
      // A store that throws is a store that is not there. Same outcome.
      details = null;
    }
    if (!mounted) return;
    setState(() {
      _price = details?.price;
      _loadingProduct = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final premium = ref.watch(premiumUnlockedProvider);
    final flow = ref.watch(purchaseFlowProvider);
    final service = ref.read(entitlementServiceProvider);

    if (premium) {
      return Text(
        l.paywallUnlocked,
        textAlign: TextAlign.center,
        style: AppTypography.titleMedium.copyWith(color: AppColors.positive),
      );
    }

    final busy =
        _loadingProduct ||
        flow == PurchaseFlowState.loading ||
        flow == PurchaseFlowState.pending;
    // Nothing to sell: no listing came back. A dead Buy button that reports
    // the same failure on every tap is worse than one that is plainly off.
    final nothingToSell = !_loadingProduct && _price == null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.prominentPrice && _price != null) ...[
          Text(
            l.gatePriceLead,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          // A store price can be anything from "\u20ac12.99" to
          // "Rp 199.000,00", and this is the biggest type on the page, so it
          // is allowed to shrink rather than break.
          WholeText(
            _price!,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: AppTypography.displayLarge.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        PrimaryButton(
          label: busy
              ? l.paywallContactingStore
              : nothingToSell
              ? l.paywallStoreUnavailable
              : widget.prominentPrice
              ? l.gateBuy
              : l.paywallUnlockProPriced(_price!),
          icon: Icons.lock_open_rounded,
          onPressed: busy || nothingToSell ? null : service.buy,
        ),
        if (nothingToSell) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.paywallStoreUnavailableNote,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          TextButton(
            onPressed: _loadProduct,
            child: Text(l.paywallTryAgain),
          ),
        ],
        const SizedBox(height: AppSpacing.xs),
        // Not optional. A non-consumable has to be restorable from wherever
        // it is sold, and this is the screen a blocked manager actually sees.
        TextButton(
          onPressed: busy ? null : service.restore,
          child: Text(l.paywallRestorePurchases),
        ),
        if (flow == PurchaseFlowState.error && service.lastError != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            service.lastError!,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}
