part of 'training_camp_screen.dart';

/// The base-camp decision on a tablet: the host card across the top, the
/// camps on offer under it in as many columns as fit. The phone's read and
/// the phone's cards; a tap chooses through [TrainingCampScreen._cardFor].
class _TrainingCampTabletLayout extends ConsumerWidget {
  const _TrainingCampTabletLayout({required this.screen});

  final TrainingCampScreen screen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final planAsync = ref.watch(trainingCampPlanProvider(screen.careerId));
    return TabletPage(
      scaffoldKey: TrainingCampScreen.tabletLayoutKey,
      title: l.campTitle,
      child: planAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.hubCouldNotLoad('$e'))),
        data: (plan) {
          if (plan == null) {
            // Nothing to decide (the tournament has started, or the nation
            // isn't in one): don't strand the manager on a blank page.
            return Center(
              child: SizedBox(
                width: 320,
                child: PrimaryButton(
                  label: l.hubContinue,
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => context.go(screen._exit()),
                ),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CampHeader(plan: plan),
                const SizedBox(height: AppSpacing.md),
                ColumnFlow(
                  minTileWidth: 300,
                  // Four camps read as a square; six (co-hosts) in threes.
                  maxColumns: plan.options.length <= 4 ? 2 : 3,
                  children: [
                    for (final option in plan.options)
                      screen._cardFor(context, ref, plan, option),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }
}
