part of 'career_summary_screen.dart';

/// The career summary on a tablet: the header, the record, the numbers and
/// the trophy cabinet in a column on the left; every tournament, newest
/// first, in a panel on the right. The phone's sections and reads, laid side
/// by side.
class _CareerSummaryTabletLayout extends ConsumerWidget {
  const _CareerSummaryTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(careerSummaryProvider(careerId));
    return TabletPage(
      scaffoldKey: CareerSummaryScreen.tabletLayoutKey,
      title: l.careerSummaryTitle,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.careers}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.careerCouldNotLoadCareer('$e'))),
        data: (s) {
          if (s == null) return Center(child: Text(l.careerNoCareer));
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: ListView(
                  children: [
                    _Header(s),
                    const SizedBox(height: AppSpacing.sm),
                    _RecordCard(s),
                    _CareerStatsSection(careerId),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l.careerTrophyCabinet,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _TrophyCabinet(s),
                    if (s.titles.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _TitlesList(s.titles),
                    ],
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 6,
                child: Panel(
                  title: l.careerTournamentHistory,
                  expand: true,
                  padding: EdgeInsets.zero,
                  child: s.runs.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(l.careerNoTournamentsYet),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(12),
                          children: [
                            for (final r in s.runs)
                              _RunRow(r, showNation: s.spansNations),
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
