part of 'manager_history_screen.dart';

/// The manager's career on a tablet: his totals, record results and cabinet
/// with the strength curve under them on the left; every cycle he has
/// managed, newest first, in a panel on the right. The phone's cards and
/// reads, laid side by side.
class _ManagerHistoryTabletLayout extends ConsumerWidget {
  const _ManagerHistoryTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(managerHistoryProvider(careerId));
    return TabletPage(
      scaffoldKey: ManagerHistoryScreen.tabletLayoutKey,
      title: l.careerManagerCareer,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.careers}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.careerCouldNotLoad('$e'))),
        data: (h) {
          if (h == null) return Center(child: Text(l.careerNoCareer));
          final strength =
              ref.watch(teamOverallHistoryProvider(careerId)).valueOrNull ??
              const <TeamOverallPoint>[];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: ListView(
                  children: [
                    _OverallCard(history: h),
                    // One year is not a curve, and a career can be one year
                    // old.
                    if (strength.length > 1) ...[
                      const SizedBox(height: AppSpacing.md),
                      TeamOverallHistoryCard(
                        key: const Key('career-team-strength'),
                        history: strength,
                        nationName: h.cycles.isEmpty
                            ? null
                            : h.cycles.first.nation?.name,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 6,
                child: Panel(
                  title: l.careerCycleByCycle,
                  expand: true,
                  padding: EdgeInsets.zero,
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [for (final c in h.cycles) _CycleCard(cycle: c)],
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
