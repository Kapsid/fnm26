import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'naturalization_tablet_layout.dart';

/// The naturalisation decision: a foreign player has offered to switch
/// allegiance. Accepting adds them to the selectable squad; declining turns
/// them away. Either resolves the offer so the timeline event fires once.
class NaturalizationScreen extends ConsumerStatefulWidget {
  const NaturalizationScreen({required this.careerId, super.key});

  static const Key tabletLayoutKey = Key('naturalization.tabletLayout');

  final int careerId;

  @override
  ConsumerState<NaturalizationScreen> createState() =>
      _NaturalizationScreenState();
}

class _NaturalizationScreenState extends ConsumerState<NaturalizationScreen> {
  bool _busy = false;

  Future<void> _resolve(
    NaturalizationOffer offer, {
    required bool accept,
  }) async {
    if (_busy) return;
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    // Read before the first await: a resize across 1000 while the decision
    // is saving swaps the tablet and phone layouts and can unmount this
    // State, and the decision must still be filed and the manager taken on
    // to the hub.
    final container = ProviderScope.containerOf(context, listen: false);
    final router = GoRouter.of(context);
    final repo = container.read(careerRepositoryProvider);
    final messages = container.read(competitionRepositoryProvider);
    final careerId = widget.careerId;
    final career = await repo.byId(careerId);
    await repo.setNaturalizationStatus(
      careerId,
      offer.player.id,
      accept ? 'accepted' : 'declined',
    );
    if (accept) {
      // The squad pool now includes the new player — refresh the caches.
      container
        ..invalidate(squadDataProvider)
        ..invalidate(naturalizedCountProvider(careerId));
      await messages.addTextMessage(
        l: l,
        careerId: careerId,
        dedupKey: 'natzdone:${offer.player.id}',
        category: 'naturalize',
        title: MsgText(MsgKey.federationNaturalisedTitle, [
          offer.player.name,
        ]),
        body: MsgText(MsgKey.federationNaturalisedBody, [
          offer.player.name,
          offer.playerNation.name,
        ]),
        year: career?.inGameDate.year ?? 2026,
      );
    }
    // Once every write has landed: the hub's next event reads the offer
    // straight from the save. A tablet keeps the hub's data (and the top
    // bar's Continue with it) alive across this screen, so without this the
    // bar would go on offering the decision just taken.
    container
      ..invalidate(pendingNaturalizationProvider(careerId))
      ..invalidate(hubDataProvider(careerId));
    // Only if the manager is still on this decision: a layout swap mid-save
    // leaves him here, but if he has gone elsewhere he is not pulled back.
    if (mounted ||
        router.routeInformationProvider.value.uri.path ==
            Routes.naturalization) {
      router.go('${Routes.hub}?careerId=$careerId');
    }
  }

  /// Decline and naturalise, side by side. Both settle the offer, once.
  Widget _decision(AppLocalizations l, NaturalizationOffer offer) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _busy
                ? null
                : () => unawaited(_resolve(offer, accept: false)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: Text(l.federationDecline),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: PrimaryButton(
            label: l.federationNaturalise,
            icon: Icons.how_to_reg_rounded,
            onPressed: _busy
                ? null
                : () => unawaited(_resolve(offer, accept: true)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(pendingNaturalizationProvider(widget.careerId));
    final l = AppLocalizations.of(context);
    if (TabletShellScope.isActive(context)) {
      return _NaturalizationTabletLayout(state: this, async: async);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l.federationNaturalisation,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.federationCouldNotLoadOffer(e.toString()))),
        data: (offer) {
          if (offer == null) {
            return Center(
              child: PrimaryButton(
                label: l.federationContinue,
                icon: Icons.check_rounded,
                onPressed: () =>
                    context.go('${Routes.hub}?careerId=${widget.careerId}'),
              ),
            );
          }
          final p = offer.player;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  children: [
                    const Icon(
                      Icons.how_to_reg_rounded,
                      size: 44,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Center(
                      child: Text(
                        l.federationOfferToSwitchAllegiance,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _OfferCard(offer: offer),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l.federationNaturalisationBlurb(
                        p.name,
                        offer.playerNation.name,
                        offer.sourceNation.name,
                      ),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: _decision(l, offer),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Who is asking: his flag, name and age, where he plays now, his rating,
/// and the switch from his nation to the manager's.
class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.offer});

  final NaturalizationOffer offer;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = offer.player;
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              FlagDisc(offer.sourceNation.code, size: 40),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name, style: AppTypography.titleMedium),
                    Text(
                      l.federationPlayerMeta(
                        p.position.name,
                        p.age,
                        offer.sourceNation.name,
                      ),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _RatingBadge(overall: p.overall),
            ],
          ),
          const Divider(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlagDisc(offer.sourceNation.code, size: 22),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              FlagDisc(offer.playerNation.code, size: 22, highlighted: true),
              const SizedBox(width: AppSpacing.sm),
              Text(
                offer.playerNation.name,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.overall});

  final int overall;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: AppRadii.smAll,
        border: Border.all(color: AppColors.primary),
      ),
      child: Text(
        '$overall',
        style: AppTypography.titleMedium.copyWith(color: AppColors.primary),
      ),
    );
  }
}
