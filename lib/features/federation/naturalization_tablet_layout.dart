part of 'naturalization_screen.dart';

/// The naturalisation decision on a tablet: the offer and the two answers on
/// the left, the player's full card on the right, so his attributes and
/// record are read before he is taken on. The phone State's read, card and
/// buttons; the answers are its [_NaturalizationScreenState._resolve].
class _NaturalizationTabletLayout extends StatelessWidget {
  const _NaturalizationTabletLayout({required this.state, required this.async});

  final _NaturalizationScreenState state;
  final AsyncValue<NaturalizationOffer?> async;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = state.widget.careerId;
    return TabletPage(
      scaffoldKey: NaturalizationScreen.tabletLayoutKey,
      title: l.naturalisationTitle,
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.federationCouldNotLoadOffer(e.toString()))),
        data: (offer) {
          if (offer == null) {
            return Center(
              child: SizedBox(
                width: 320,
                child: PrimaryButton(
                  label: l.federationContinue,
                  icon: Icons.check_rounded,
                  onPressed: () =>
                      context.go('${Routes.hub}?careerId=$careerId'),
                ),
              ),
            );
          }
          final p = offer.player;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l.federationOfferToSwitchAllegiance,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
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
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    state._decision(l, offer),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 6,
                child: PanelBox(
                  child: DetailPaneHost(
                    careerId: careerId,
                    target: PlayerTarget(p.id),
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
