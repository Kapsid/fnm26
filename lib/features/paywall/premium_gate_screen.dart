import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/paywall/paywall_parts.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The wall at the end of the free cycle: what carrying on is worth, what it
/// costs, and the two things a manager can do about it.
///
/// Shown as a full page rather than a sheet on purpose. A sheet is something
/// you flick away; this is a decision point in the career, and it should read
/// as one.
///
/// The purchase runs through the same [PaywallActions] as the settings sheet,
/// so the store's own localised price is what is printed here and the restore
/// path is on the screen a blocked manager actually reaches.
class PremiumGateScreen extends ConsumerWidget {
  const PremiumGateScreen({this.fromSave = false, this.onResult, super.key});

  /// Whether the manager arrived by opening a Pro-locked save (see
  /// `save_lock.dart`), rather than at the end of the free cycle: the title
  /// and lead then speak about the save.
  final bool fromSave;

  /// Called with the outcome (true: Pro is owned now) instead of popping.
  /// Set when the gate is a route of its own rather than a pushed page.
  final ValueChanged<bool>? onResult;

  static const Key exitKey = Key('premiumGate.exit');

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
    // The purchase arrives on the store's stream, not from the button, so the
    // page closes on the entitlement rather than on the tap that asked for it.
    // That covers a purchase confirmed minutes later, and a restore.
    void finish({required bool bought}) {
      if (!context.mounted) return;
      if (onResult case final done?) {
        done(bought);
      } else {
        Navigator.of(context).pop(bought);
      }
    }

    ref.listen(premiumUnlockedProvider, (was, now) {
      if (now) finish(bought: true);
    });
    return PopScope(
      // The two buttons are the only ways out: a back-swipe that quietly
      // returned "not bought" would look like the gate had failed.
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: _widthCap(
            context,
            Padding(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Centred in the space left over. The page used to be a
                  // scroll view of a paragraph, five benefit lines and a price
                  // — enough text that the decision was buried in it, and on a
                  // small phone the price sat below the fold on the one screen
                  // where the price is the point. It still scrolls, but only
                  // once the words genuinely do not fit: a long language on a
                  // short phone must not cost anybody the buttons.
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, box) => SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: box.maxHeight),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Icon(
                                Icons.sports_soccer,
                                size: 56,
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                fromSave ? l.gateSaveTitle : l.gateTitle,
                                textAlign: TextAlign.center,
                                style: AppTypography.headlineMedium.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                fromSave ? l.gateSaveLead : l.gateLead,
                                textAlign: TextAlign.center,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              const PaywallBenefits(iconSize: 22),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const PaywallActions(prominentPrice: true),
                  TextButton(
                    key: exitKey,
                    onPressed: () => finish(bought: false),
                    child: Text(l.gateExit),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// On a wide tablet window the wall is the same page held to 560 in the
  /// middle: stretched across a landscape iPad it was a phone page over a
  /// thousand wide. A phone gets [body] exactly as it was.
  static Widget _widthCap(BuildContext context, Widget body) =>
      context.isWideTabletWindow
      ? Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: body,
          ),
        )
      : body;
}
