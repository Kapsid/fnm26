part of 'unemployed_start_screen.dart';

/// Out of work on a landscape tablet: the three offers side by side, each the
/// nation pick's preview of that federation (where it sits in the world, its
/// strength, its budget, its best player, the board's first demands) over its
/// own Take it. The offers are the screen State's draw ([offersOf] is
/// [_UnemployedStartScreenState._offers]), so a resize shows the same three.
class _UnemployedStartTabletLayout extends StatelessWidget {
  const _UnemployedStartTabletLayout({
    required this.nationsAsync,
    required this.offersOf,
  });

  final AsyncValue<List<Nation>> nationsAsync;
  final List<Nation> Function(List<Nation> all) offersOf;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      key: UnemployedStartScreen.tabletLayoutKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabletScreenHeader(
                title: l.bottomStartTitle,
                onBack: () => context.canPop()
                    ? context.pop()
                    : context.go(Routes.nations),
              ),
              Expanded(
                child: nationsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Text(l.nationsCouldNotLoadNations(e.toString())),
                  ),
                  data: (nations) {
                    final offers = offersOf(nations);
                    if (offers.isEmpty) {
                      return Center(child: Text(l.nationsNoMatch));
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l.bottomStartHeading,
                          style: AppTypography.headlineLargeMobile,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l.bottomStartBlurb,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final (i, nation) in offers.indexed) ...[
                                if (i > 0) const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: _OfferPanel(
                                    nation: nation,
                                    total: nations.length,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One federation's offer: the preview of the nation over the button that
/// takes the job (the phone's whole-card tap, as a button).
class _OfferPanel extends StatelessWidget {
  const _OfferPanel({required this.nation, required this.total});

  final Nation nation;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return PanelBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: NationPreview(
                nation: nation,
                caption: l.bottomStartRankOf(nation.ranking, total),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: PrimaryButton(
              key: UnemployedStartScreen.takeKey(nation.id),
              label: l.bottomStartAccept,
              icon: Icons.arrow_forward_rounded,
              onPressed: () =>
                  context.go('${Routes.newGame}?nationId=${nation.id}'),
            ),
          ),
        ],
      ),
    );
  }
}
