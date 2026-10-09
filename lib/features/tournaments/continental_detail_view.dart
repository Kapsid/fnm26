part of 'continental_detail_screen.dart';

/// A continental championship's tabs and bodies for a tablet, the tab bar
/// across the top of the area it is given. Always [confederation]'s cup:
/// the Tournaments pane opens other confederations' cups with this.
class ContinentalDetailView extends ConsumerWidget {
  const ContinentalDetailView({
    required this.careerId,
    required this.confederation,
    super.key,
  });

  final int careerId;
  final Confederation confederation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(
      continentalDetailProvider((
        careerId: careerId,
        confederation: confederation,
      )),
    );
    final liveTab = ContinentalDetailScreen._liveTabFor(
      confederation,
      dataAsync.valueOrNull,
    );
    return DefaultTabController(
      // See ContinentalDetailScreen: initialIndex is read once.
      key: ValueKey(liveTab),
      length: ContinentalDetailScreen._hasQualifyingFor(confederation) ? 8 : 7,
      initialIndex: liveTab,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: AppColors.surfaceContainer,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              tabs: _continentalTabs(l, confederation),
            ),
          ),
          Expanded(
            child: dataAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text(l.tourContCouldNotLoadCup(e.toString()))),
              data: (data) {
                if (data == null) {
                  return Center(child: Text(l.tourContNoCupData));
                }
                String code(int id) => data.nations[id]?.code ?? '??';
                String name(int id) =>
                    data.nations[id]?.name ?? l.tourContUnknown;
                return Column(
                  children: [
                    TournamentHoldersRow(
                      holders: data.holders,
                      code: code,
                      name: name,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: _continentalTabViews(
                          context,
                          data,
                          confederation: confederation,
                          grid: true,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A continental championship's page on a tablet: its name over
/// [ContinentalDetailView] in one panel.
class _ContinentalDetailTabletLayout extends ConsumerWidget {
  const _ContinentalDetailTabletLayout({
    required this.careerId,
    required this.confederation,
  });

  final int careerId;
  final Confederation confederation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final data = ref
        .watch(
          continentalDetailProvider((
            careerId: careerId,
            confederation: confederation,
          )),
        )
        .valueOrNull;
    return Scaffold(
      key: ContinentalDetailScreen.tabletLayoutKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabletScreenHeader(
              title: data == null
                  ? l.tourContChampionship
                  : competitionLabel(l, data.name).toUpperCase(),
              onBack: () =>
                  context.go('${Routes.tournaments}?careerId=$careerId'),
            ),
            Expanded(
              child: PanelBox(
                child: ContinentalDetailView(
                  careerId: careerId,
                  confederation: confederation,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
