part of 'cup_detail_screen.dart';

/// The World Championship's tabs and their bodies for a tablet: the tab bar
/// across the top of whatever area it is given, the host strip and the
/// holders under it, then the tab on show. Group tables come in columns and
/// the bracket opens full width. The tablet page and the Tournaments
/// screen's right-hand pane both show this.
class CupDetailView extends ConsumerWidget {
  const CupDetailView({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(cupDetailProvider(careerId));
    final liveTab = CupDetailScreen._liveTab(dataAsync.valueOrNull);
    // Once the opening ceremony has run, the WC takes on the host's colours.
    final host = ref.watch(wcHostThemeProvider(careerId)).valueOrNull;
    final themed = host?.active ?? false;
    final accent = themed ? host!.accent : AppColors.primary;
    return DefaultTabController(
      // See CupDetailScreen: initialIndex is read once, before the data lands.
      key: ValueKey(liveTab),
      length: 9,
      initialIndex: liveTab,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: AppColors.surfaceContainer,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: themed ? accent : AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: accent,
              tabs: _cupTabs(l),
            ),
          ),
          Expanded(
            child: dataAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text(l.tourCupLoadError(e.toString()))),
              data: (data) {
                if (data == null) return Center(child: Text(l.tourCupNoData));
                String code(int id) => data.nations[id]?.code ?? '??';
                String name(int id) =>
                    data.nations[id]?.name ?? l.tourCupUnknown;
                return Column(
                  children: [
                    if (themed && host != null)
                      WcHostBanner(theme: host, code: code),
                    TournamentHoldersRow(
                      holders: data.holders,
                      code: code,
                      name: name,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: _cupTabViews(
                          context,
                          data,
                          careerId: careerId,
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

/// The World Championship page on a tablet: its heading over [CupDetailView]
/// in one panel filling the content area.
class _CupDetailTabletLayout extends ConsumerWidget {
  const _CupDetailTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final host = ref.watch(wcHostThemeProvider(careerId)).valueOrNull;
    final accent = (host?.active ?? false) ? host!.accent : null;
    return Scaffold(
      key: CupDetailScreen.tabletLayoutKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabletScreenHeader(
              title: l.tourCupTitle,
              accent: accent,
              onBack: () =>
                  context.go('${Routes.tournaments}?careerId=$careerId'),
            ),
            Expanded(
              child: PanelBox(child: CupDetailView(careerId: careerId)),
            ),
          ],
        ),
      ),
    );
  }
}
