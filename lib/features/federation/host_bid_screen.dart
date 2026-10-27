import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/features/federation/host_bid_providers.dart';
import 'package:fnm/features/federation/investment_editor.dart'
    show formatEuros;
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// A bid to host the coming cycle's World Championship or continental
/// championship: what it is, how much to put in, and the chance that buys,
/// live on a coloured bar. Submitting pledges the money, paid by the
/// rollover win or lose; "Not this time" turns the offer down for good.
/// Either way the manager goes back to the rollover screen, which is where
/// the offer is made (see [HostBidStatusCard]).
///
/// On a tablet it fills the shell's content area, with the form held to a
/// readable column in the middle.
class HostBidScreen extends ConsumerStatefulWidget {
  const HostBidScreen({
    required this.careerId,
    required this.comp,
    this.nationId,
    super.key,
  });

  static const Key tabletLayoutKey = Key('hostBid.tabletLayout');

  final int careerId;
  final HostBidComp comp;

  /// The nation bidding: the one the manager takes into the new cycle (an
  /// offer picked at the rollover), or null for his current one.
  final int? nationId;

  @override
  ConsumerState<HostBidScreen> createState() => _HostBidScreenState();
}

class _HostBidScreenState extends ConsumerState<HostBidScreen> {
  bool _busy = false;

  Future<void> _settle(HostBidOffer offer, int? levels) async {
    if (_busy) return;
    setState(() => _busy = true);
    // Captured before the first await, as the naturalisation screen does: a
    // layout swap mid-save can unmount this State.
    final container = ProviderScope.containerOf(context, listen: false);
    final router = GoRouter.of(context);
    final service = container.read(hostBidServiceProvider);
    if (levels == null) {
      await service.decline(offer);
    } else {
      await service.place(offer, levels);
    }
    container.invalidate(hubDataProvider(widget.careerId));
    if (router.state.uri.path == Routes.hostBid) _leave(router);
  }

  /// Back to where the bid was opened from: the rollover screen, which
  /// pushed it, or (opened any other way) the rollover route itself.
  void _leave(GoRouter router) {
    if (router.canPop()) {
      router.pop();
    } else {
      router.go('${Routes.cycleRollover}?careerId=${widget.careerId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(
      hostBidOfferProvider((
        careerId: widget.careerId,
        nationId: widget.nationId,
        comp: widget.comp,
      )),
    );
    final body = async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l.hostBidUnavailable)),
      data: (offer) => _content(l, offer),
    );
    if (TabletShellScope.isActive(context)) {
      return TabletPage(
        scaffoldKey: HostBidScreen.tabletLayoutKey,
        title: l.hostBidScreenTitle,
        onBack: () => _leave(GoRouter.of(context)),
        child: body,
      );
    }
    return Scaffold(
      appBar: AppBar(
        // Leaving decides nothing: the offer stays on the rollover screen
        // until it is submitted or turned down.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => _leave(GoRouter.of(context)),
        ),
        title: Text(
          l.hostBidScreenTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: body,
    );
  }

  Widget _content(AppLocalizations l, HostBidOffer? offer) {
    if (offer == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.hostBidUnavailable,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: l.federationContinue,
                icon: Icons.check_rounded,
                onPressed: () => _leave(GoRouter.of(context)),
              ),
            ],
          ),
        ),
      );
    }
    // One short form: on a tablet it keeps a readable column in the
    // middle of the content area rather than stretching across it.
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: HostBidForm(
          offer: offer,
          busy: _busy,
          onSubmit: (levels) => unawaited(_settle(offer, levels)),
          onDecline: () => unawaited(_settle(offer, null)),
        ),
      ),
    );
  }
}

/// The bid itself: heading, how it works, the investment selector, the chance
/// bar and the two decisions. Pure presentation over [offer], so it can be
/// pumped on its own.
class HostBidForm extends StatefulWidget {
  const HostBidForm({
    required this.offer,
    required this.onSubmit,
    required this.onDecline,
    this.busy = false,
    super.key,
  });

  static const Key sliderKey = Key('hostBid.slider');
  static const Key totalKey = Key('hostBid.total');
  static const Key barKey = Key('hostBid.bar');
  static const Key investKey = Key('hostBid.invest');

  final HostBidOffer offer;
  final ValueChanged<int> onSubmit;
  final VoidCallback onDecline;
  final bool busy;

  @override
  State<HostBidForm> createState() => _HostBidFormState();
}

class _HostBidFormState extends State<HostBidForm> {
  /// Three levels to start, or what the funds allow.
  late int _levels = widget.offer.maxLevels < 3 ? widget.offer.maxLevels : 3;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final offer = widget.offer;
    final max = offer.maxLevels;
    final quote = offer.quote(_levels);
    final comp = hostBidCompLabel(l, offer);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            // One short form: built whole, so the bar and the slider are both
            // always there to read.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.stadium_rounded,
                  size: 44,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l.hostBidHeading(comp, offer.year),
                  textAlign: TextAlign.center,
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l.hostBidBlurb,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              l.hostBidChance,
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                          Text(
                            _pct(quote.total),
                            key: HostBidForm.totalKey,
                            style: AppTypography.headlineMedium.copyWith(
                              color: chanceColor(quote.total),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      HostBidChanceBar(key: HostBidForm.barKey, quote: quote),
                      const SizedBox(height: AppSpacing.sm),
                      _part(
                        l.hostBidBaseLabel,
                        _pct(quote.base),
                        AppColors.onSurfaceVariant,
                      ),
                      _part(
                        l.hostBidInvestLabel,
                        '+${_pct(quote.invest)}',
                        AppColors.positive,
                        valueKey: HostBidForm.investKey,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l.hostBidCeiling(offer.nation.name, _pct(quote.cap)),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        l.hostBidInvestment,
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                    Text(
                      formatEuros(_levels * HostBidOdds.levelPrice),
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Slider(
                  key: HostBidForm.sliderKey,
                  value: _levels.toDouble(),
                  max: max.toDouble(),
                  divisions: max,
                  label: formatEuros(_levels * HostBidOdds.levelPrice),
                  onChanged: widget.busy
                      ? null
                      : (v) => setState(() => _levels = v.round()),
                ),
                Text(
                  l.hostBidFreeFunds(formatEuros(offer.freeFunds)),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l.hostBidPrize(
                    formatEuros(
                      HostBidOdds.bonusFor(_levels < 1 ? 1 : _levels),
                    ),
                  ),
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l.hostBidDecidedAtRollover,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PrimaryButton(
                  label: l.hostBidSubmit,
                  icon: Icons.how_to_vote_rounded,
                  onPressed: widget.busy || _levels < 1
                      ? null
                      : () => widget.onSubmit(_levels),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton(
                  onPressed: widget.busy ? null : widget.onDecline,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(l.hostBidDecline, textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _part(String label, String value, Color color, {Key? valueKey}) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            key: valueKey,
            style: AppTypography.labelMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// A chance as a whole percentage.
String _pct(double p) => '${(p * 100).round()}%';

/// Red under 15%, amber under 35%, green above: the bar's three bands.
Color chanceColor(double p) => p < HostBidChanceBar.amberFrom
    ? AppColors.ratingPoor
    : p < HostBidChanceBar.greenFrom
    ? AppColors.warning
    : AppColors.ratingGreat;

/// The colourful chance bar: a red-amber-green track, filled up to the total
/// chance; the base part (stadiums and standing) is drawn darker than the
/// part the money adds, and a tick marks the nation's ceiling.
class HostBidChanceBar extends StatelessWidget {
  const HostBidChanceBar({required this.quote, super.key});

  /// Where the bands change.
  static const double amberFrom = 0.15;
  static const double greenFrom = 0.35;

  static const double _height = 18;

  final HostBidQuote quote;

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [
        AppColors.ratingPoor,
        AppColors.warning,
        AppColors.playoff,
        AppColors.ratingGreat,
      ],
      stops: [0, amberFrom, greenFrom - 0.05, greenFrom + 0.15],
    );
    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        double x(double p) => (p.clamp(0.0, 1.0)) * w;
        return SizedBox(
          height: _height,
          width: w,
          child: Stack(
            children: [
              // The whole scale, faint.
              const Positioned.fill(
                child: Opacity(
                  opacity: 0.18,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: AppRadii.smAll,
                    ),
                  ),
                ),
              ),
              // Filled to the total, in the colours of the scale beneath.
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: x(quote.total),
                child: ClipRRect(
                  borderRadius: AppRadii.smAll,
                  child: OverflowBox(
                    alignment: Alignment.centerLeft,
                    maxWidth: w,
                    minWidth: w,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(gradient: gradient),
                      child: SizedBox.expand(),
                    ),
                  ),
                ),
              ),
              // The base part, shaded.
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: x(quote.base),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: AppRadii.smAll,
                  ),
                ),
              ),
              // The ceiling.
              Positioned(
                left: (x(quote.cap) - 1).clamp(0.0, w - 2),
                top: -2,
                bottom: -2,
                width: 2,
                child: const ColoredBox(color: AppColors.onSurface),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Where the manager's hosting bids stand, as one card.
///
/// On the rollover screen ([interactive]) it is where a bid is made: each
/// open offer is a row that opens the bid screen. On the budget screen it
/// sits under the department sliders and says, for the bids that open at the
/// end of the cycle, whether the nation may bid and exactly what stops it:
/// the stadiums still missing (the stadiums entry is right under it), or the
/// rotation rule. Nothing at all in a campaign run or a free save that
/// cannot roll on.
class HostBidStatusCard extends ConsumerWidget {
  const HostBidStatusCard({
    required this.careerId,
    this.nationId,
    this.interactive = false,
    super.key,
  });

  static const Key cardKey = Key('hostBid.card');
  static Key entryKey(HostBidComp comp) => Key('hostBid.entry.${comp.code}');

  final int careerId;

  /// The nation that would bid; null for the one managed now.
  final int? nationId;

  /// Offers open the bid screen (the rollover screen).
  final bool interactive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statuses =
        ref
            .watch(
              hostBidStatusProvider((careerId: careerId, nationId: nationId)),
            )
            .valueOrNull ??
        const <HostBidStatus>[];
    if (statuses.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final seats = NumberFormat.decimalPattern(l.localeName);
    return Padding(
      key: cardKey,
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadii.baseAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.stadium_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        l.hostBidSectionTitle,
                        style: AppTypography.labelLarge,
                      ),
                    ),
                  ],
                ),
              ),
              for (final s in statuses)
                _StatusRow(
                  status: s,
                  seats: seats,
                  onTap: interactive && s.offer != null
                      ? () => unawaited(context.push(hostBidRoute(s.offer!)))
                      : null,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One tournament in [HostBidStatusCard].
class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.status, required this.seats, this.onTap});

  final HostBidStatus status;
  final NumberFormat seats;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = status;
    final comp = switch (s.comp) {
      HostBidComp.worldChampionship => l.compWorldCup,
      HostBidComp.continental => continentalCupLabel(
        l,
        s.nation.confederation,
      ),
    };
    final req = s.requirement;
    final lines = <(String, Color)>[];
    const muted = AppColors.onSurfaceVariant;
    if (s.lodged) {
      lines.add((l.hostBidLodged, AppColors.positive));
    } else if (s.declined) {
      lines.add((l.hostBidDeclinedNote, muted));
    } else if (s.eligible) {
      if (s.offer != null) {
        lines.add((l.hostBidOpenSub, muted));
      } else if (s.windowOpen) {
        lines.add((l.hostBidNoFunds, AppColors.warning));
      } else {
        lines.add((l.hostBidOpensLater, AppColors.positive));
      }
    } else {
      if (s.barredConfederation != null) {
        lines.add((
          l.hostBidBarredConf(confederationLabel(l, s.barredConfederation!)),
          AppColors.warning,
        ));
      }
      if (s.recentHost) lines.add((l.hostBidRecentHost, AppColors.warning));
      if (s.shortfall.bigGrounds > 0) {
        lines.add((
          l.hostBidNeedStadiums(
            s.shortfall.bigGrounds,
            seats.format(req.bigSeats),
          ),
          AppColors.warning,
        ));
      }
      if (s.shortfall.grounds > 0) {
        lines.add((
          l.hostBidNeedStadiums(
            s.shortfall.grounds,
            seats.format(req.minSeats),
          ),
          AppColors.warning,
        ));
      }
    }
    final body = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.hostBidHeading(comp, s.year),
                  style: AppTypography.labelMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  l.hostBidRequirement(
                    req.grounds,
                    seats.format(req.minSeats),
                    req.bigGrounds,
                    seats.format(req.bigSeats),
                  ),
                  style: AppTypography.labelSmall.copyWith(color: muted),
                ),
                for (final (text, color) in lines)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      text,
                      style: AppTypography.labelSmall.copyWith(color: color),
                    ),
                  ),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(Icons.chevron_right_rounded, color: muted),
        ],
      ),
    );
    if (onTap == null) return body;
    return InkWell(
      key: HostBidStatusCard.entryKey(s.comp),
      onTap: onTap,
      child: body,
    );
  }
}
