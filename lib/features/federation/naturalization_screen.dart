import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The naturalisation decision: a foreign player has offered to switch
/// allegiance. Accepting adds them to the selectable squad; declining turns
/// them away. Either resolves the offer so the timeline event fires once.
class NaturalizationScreen extends ConsumerStatefulWidget {
  const NaturalizationScreen({required this.careerId, super.key});

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
    setState(() => _busy = true);
    final repo = ref.read(careerRepositoryProvider);
    final career = await repo.byId(widget.careerId);
    await repo.setNaturalizationStatus(
      widget.careerId,
      offer.player.id,
      accept ? 'accepted' : 'declined',
    );
    if (accept) {
      // The squad pool now includes the new player — refresh the caches.
      ref
        ..invalidate(squadDataProvider)
        ..invalidate(naturalizedCountProvider(widget.careerId));
      await ref.read(competitionRepositoryProvider).addMessage(
            careerId: widget.careerId,
            dedupKey: 'natzdone:${offer.player.id}',
            category: 'naturalize',
            title: '${offer.player.name} naturalised',
            body: '${offer.player.name} has completed the switch and is now '
                'eligible for ${offer.playerNation.name}. Call them up from '
                'your squad selection.',
            year: career?.inGameDate.year ?? 2026,
          );
    }
    if (mounted) {
      context.go('${Routes.hub}?careerId=${widget.careerId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(pendingNaturalizationProvider(widget.careerId));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'NATURALISATION',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load offer.\n$e')),
        data: (offer) {
          if (offer == null) {
            return Center(
              child: PrimaryButton(
                label: 'Continue',
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
                    const Icon(Icons.how_to_reg_rounded,
                        size: 44, color: AppColors.primary),
                    const SizedBox(height: AppSpacing.sm),
                    Center(
                      child: Text('AN OFFER TO SWITCH ALLEGIANCE',
                          style: AppTypography.labelSmall
                              .copyWith(color: AppColors.primary)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppCard(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              FlagDisc(offer.sourceNation.code, size: 40),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(p.name,
                                        style: AppTypography.titleMedium),
                                    Text(
                                      '${p.position.name} · age ${p.age} · '
                                      'from ${offer.sourceNation.name}',
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm),
                                child: Icon(Icons.arrow_forward_rounded,
                                    size: 18,
                                    color: AppColors.onSurfaceVariant),
                              ),
                              FlagDisc(offer.playerNation.code,
                                  size: 22, highlighted: true),
                              const SizedBox(width: AppSpacing.sm),
                              Text(offer.playerNation.name,
                                  style: AppTypography.labelMedium
                                      .copyWith(color: AppColors.primary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      '${p.name} has ties to ${offer.playerNation.name} and, '
                      'drawn by the federation’s growing reputation, is '
                      'willing to be naturalised. Accept and they become '
                      'eligible for selection; decline and they stay with '
                      '${offer.sourceNation.name}.',
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _busy
                              ? null
                              : () => unawaited(
                                    _resolve(offer, accept: false),
                                  ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                          ),
                          child: const Text('Decline'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Naturalise',
                          icon: Icons.how_to_reg_rounded,
                          onPressed: _busy
                              ? null
                              : () =>
                                  unawaited(_resolve(offer, accept: true)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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
