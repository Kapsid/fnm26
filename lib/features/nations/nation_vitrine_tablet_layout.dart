part of 'nation_vitrine_screen.dart';

/// A nation's page on a tablet: who it is, its honours and how its standing
/// has moved on the left; its record scorers and titles on the right. The
/// phone's sections and read (`nationVitrineProvider`), side by side; the
/// ranking's detail pane keeps the one-column [NationView].
class _NationVitrineTabletLayout extends ConsumerWidget {
  const _NationVitrineTabletLayout({
    required this.careerId,
    required this.nationId,
  });

  final int careerId;
  final int nationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(
      nationVitrineProvider((careerId: careerId, nationId: nationId)),
    );
    return TabletPage(
      scaffoldKey: NationVitrineScreen.tabletLayoutKey,
      title: l.nationPageTitle,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.ranking}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.nationsCouldNotLoad(e.toString()))),
        data: (v) {
          if (v == null) return Center(child: Text(l.nationsNoNation));
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _Header(v),
                    const SizedBox(height: AppSpacing.md),
                    NationNowCard(careerId: careerId, nationId: nationId),
                    const SizedBox(height: AppSpacing.md),
                    _sectionLabel(l.nationsHonours),
                    const SizedBox(height: AppSpacing.sm),
                    _HonoursCard(v),
                    const SizedBox(height: AppSpacing.md),
                    _sectionLabel(l.nationsRankingHistory),
                    const SizedBox(height: AppSpacing.sm),
                    _RankingHistoryCard(v),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ListView(
                  children: [
                    _sectionLabel(l.nationsTopScorers),
                    const SizedBox(height: AppSpacing.sm),
                    _TopScorersCard(v),
                    if (v.titles.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      _sectionLabel(l.nationsTitles),
                      const SizedBox(height: AppSpacing.sm),
                      _TitlesCard(v),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
