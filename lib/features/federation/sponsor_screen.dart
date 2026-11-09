import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/federation_label.dart';
import 'package:fnm/core/util/sponsor_label.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/federation/sponsor_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// One thing a deal does, as its card prints it.
typedef SponsorEffect = ({String label, bool good});

/// Arrows for a swing of [points]: one to three, up or down.
String _arrows(int points) =>
    (points > 0 ? '\u25B2' : '\u25BC') * points.abs().clamp(1, 3);

/// Everything [o] does, good and bad, in the order a manager weighs it: the
/// money, the board, the dressing room, the press.
List<SponsorEffect> sponsorEffects(AppLocalizations l, SponsorOffer o) => [
  if (o.euros > 0) (label: '+${formatEuros(o.euros)}', good: true),
  if (o.levels > 0)
    (
      label: l.sponsorPerkMarketing(
        formatEuros(o.marketingEuros),
        departmentLabel(l, Department.commercial),
      ),
      good: true,
    ),
  if (o.board != 0)
    (label: '${l.sponsorEffectBoard} ${_arrows(o.board)}', good: o.board > 0),
  if (o.morale != 0)
    (
      label: '${l.sponsorEffectMorale} ${_arrows(o.morale)}',
      good: o.morale > 0,
    ),
  if (o.risky) (label: l.sponsorEffectPress, good: false),
];

/// An offer's effects as a row of chips that wraps.
class SponsorEffectChips extends StatelessWidget {
  const SponsorEffectChips({required this.offer, super.key});

  final SponsorOffer offer;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final e in sponsorEffects(l, offer))
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: (e.good ? AppColors.positive : AppColors.error).withValues(
                alpha: 0.12,
              ),
              borderRadius: BorderRadius.circular(AppRadii.sm),
            ),
            child: Text(
              e.label,
              style: AppTypography.labelSmall.copyWith(
                color: e.good ? AppColors.positive : AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

/// The cycle's general sponsor offers: three deals, each with a price.
/// Sign one, or none. Reached from the hub before the budget (see
/// [sponsorRoundProvider]); the warm-up offer screen's shape.
class SponsorScreen extends ConsumerStatefulWidget {
  const SponsorScreen({required this.careerId, super.key});

  /// The tablet layout's scaffold, for tests.
  static const Key tabletLayoutKey = Key('sponsor.tabletLayout');

  /// The way out without a sponsor, for tests.
  static const Key declineKey = Key('sponsor.decline');

  /// The sign button of the offer at [index], for tests.
  static Key signKey(int index) => Key('sponsor.sign.$index');

  /// The tablet's offer tiles, side by side, for tests.
  static const Key tilesKey = Key('sponsor.tiles');

  final int careerId;

  @override
  ConsumerState<SponsorScreen> createState() => _SponsorScreenState();
}

class _SponsorScreenState extends ConsumerState<SponsorScreen> {
  bool _busy = false;

  Future<void> _answer(SponsorOffer? offer) async {
    if (_busy) return;
    setState(() => _busy = true);
    // Read before the first await: a manager who leaves meanwhile must still
    // see the hub and the money move on.
    final container = ProviderScope.containerOf(context, listen: false);
    final router = GoRouter.of(context);
    final id = widget.careerId;
    final service = container.read(sponsorServiceProvider);
    try {
      if (offer == null) {
        await service.decline(id);
      } else {
        await service.sign(id, offer);
      }
    } finally {
      // A failed write must not leave every answer dead.
      if (mounted) setState(() => _busy = false);
    }
    // Derived providers never notice a write they did not make: the money,
    // the projected return and the press effect are told.
    container
      ..invalidate(sponsorRoundProvider(id))
      ..invalidate(federationFundsProvider(id))
      ..invalidate(financeViewProvider(id))
      ..invalidate(cycleIncomeProvider(id))
      ..invalidate(pressEffectProvider(id))
      ..invalidate(nextEventProvider(id))
      ..invalidate(hubDataProvider(id));
    if (router.state.uri.path == Routes.sponsor) {
      router.go('${Routes.hub}?careerId=$id');
    }
  }

  void _leave() {
    final id = widget.careerId;
    ref
      ..invalidate(nextEventProvider(id))
      ..invalidate(hubDataProvider(id));
    context.go('${Routes.hub}?careerId=$id');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final round = ref.watch(sponsorRoundProvider(widget.careerId));
    final content = switch (round) {
      AsyncData(value: final r?) when !r.decided => _body(l, r),
      // Answered meanwhile, or no round at all: nothing to decide, so the way
      // out is always on screen.
      // A round that could not be read (its world, say): the app's error
      // state with a retry, and the way out.
      AsyncError() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppErrorState(
            onRetry: () =>
                ref.invalidate(sponsorRoundProvider(widget.careerId)),
          ),
          SizedBox(
            width: 320,
            child: PrimaryButton(
              label: l.federationContinue,
              icon: Icons.check_rounded,
              onPressed: _leave,
            ),
          ),
        ],
      ),
      AsyncData() => Center(
        child: SizedBox(
          width: 320,
          child: PrimaryButton(
            label: l.federationContinue,
            icon: Icons.check_rounded,
            onPressed: _leave,
          ),
        ),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
    if (TabletShellScope.isActive(context)) {
      return TabletPage(
        scaffoldKey: SponsorScreen.tabletLayoutKey,
        title: l.sponsorTitle,
        child: Center(
          child: ConstrainedBox(
            // The offers side by side: room for three tiles.
            constraints: const BoxConstraints(maxWidth: 1080),
            child: content,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: _leave,
        ),
        title: Text(l.sponsorTitle, style: AppTypography.labelMedium),
        centerTitle: true,
      ),
      body: content,
    );
  }

  Widget _body(AppLocalizations l, SponsorRound r) {
    if (TabletShellScope.isActive(context)) return _tabletBody(l, r);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text(
                    l.sponsorIntroCycle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  for (final o in r.offers) ...[
                    SponsorOfferCard(
                      offer: o,
                      busy: _busy,
                      onSign: () => unawaited(_answer(o)),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              key: SponsorScreen.declineKey,
              onPressed: _busy ? null : () => unawaited(_answer(null)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(l.sponsorDeclineCycle, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  /// On a tablet: the offers as tiles side by side, as tall as the tallest,
  /// each with its Sign at its foot; the way out without one under them.
  Widget _tabletBody(AppLocalizations l, SponsorRound r) {
    return ListView(
      key: SponsorScreen.tilesKey,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      children: [
        Text(
          l.sponsorIntroCycle,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (i, o) in r.offers.indexed) ...[
                if (i > 0) const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: SponsorOfferCard(
                    offer: o,
                    busy: _busy,
                    tile: true,
                    onSign: () => unawaited(_answer(o)),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: OutlinedButton(
            key: SponsorScreen.declineKey,
            onPressed: _busy ? null : () => unawaited(_answer(null)),
            style: OutlinedButton.styleFrom(minimumSize: const Size(320, 48)),
            child: Text(l.sponsorDeclineCycle, textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}

/// One offer: the brand and its trade, what it gives, the small print, and
/// the button that signs it. The risky one is marked and outlined in the
/// warning colour.
class SponsorOfferCard extends StatelessWidget {
  const SponsorOfferCard({
    required this.offer,
    required this.onSign,
    this.busy = false,
    this.tile = false,
    super.key,
  });

  final SponsorOffer offer;
  final VoidCallback onSign;
  final bool busy;

  /// A tile in the tablet's row: the Sign button held at the foot and wide
  /// across it, so the buttons of the row's tiles sit level.
  final bool tile;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = AppTypography.bodySmall.copyWith(
      color: offer.risky ? AppColors.warning : AppColors.onSurfaceVariant,
    );
    return AppCard(
      border: offer.risky ? Border.all(color: AppColors.warning) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sponsorBrandName(l, offer.brand),
                      style: AppTypography.titleMedium,
                    ),
                    // An added brand of an industry this build does not
                    // know has none to show.
                    if (sponsorIndustryLabel(l, offer.brand) case final industry
                        when industry.isNotEmpty)
                      Text(
                        industry,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (offer.risky) ...[
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                    ),
                    child: Text(
                      l.sponsorRiskyLabel,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            sponsorFlavour(l, offer.brand),
            style: AppTypography.bodySmall.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SponsorEffectChips(offer: offer),
          if (offer.levels > 0) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              l.sponsorPerkMarketingNote(
                formatEuros(
                  FederationFinance.commercialReturn(offer.marketingEuros),
                ),
              ),
              style: muted,
            ),
          ],
          if (offer.risky) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(l.sponsorRiskyWarning, style: muted),
          ],
          const SizedBox(height: AppSpacing.sm),
          if (tile) ...[
            const Spacer(),
            FilledButton.tonal(
              key: SponsorScreen.signKey(offer.index),
              onPressed: busy ? null : onSign,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
              ),
              child: Text(l.sponsorSign),
            ),
          ] else
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.tonal(
                key: SponsorScreen.signKey(offer.index),
                onPressed: busy ? null : onSign,
                child: Text(l.sponsorSign),
              ),
            ),
        ],
      ),
    );
  }
}
