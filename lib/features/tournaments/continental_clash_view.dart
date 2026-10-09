part of 'continental_clash_screen.dart';

/// The Clash's tabs and bodies for a tablet, the tab bar across the top of
/// the area it is given.
class ContinentalClashView extends ConsumerWidget {
  const ContinentalClashView({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(continentalClashProvider(careerId));
    return DefaultTabController(
      length: 2,
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
              tabs: _clashTabs(l),
            ),
          ),
          Expanded(
            child: dataAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(l.tourContCouldNotLoadClash(e.toString())),
              ),
              data: (data) {
                if (data == null) {
                  return Center(child: Text(l.tourContNoSaveFound));
                }
                return TabBarView(
                  children: _clashTabViews(context, data, wide: true),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// The Clash's page on a tablet: its name over [ContinentalClashView].
class _ContinentalClashTabletLayout extends StatelessWidget {
  const _ContinentalClashTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      key: ContinentalClashScreen.tabletLayoutKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabletScreenHeader(
              title: l.tourContContinentalClash,
              onBack: () =>
                  context.go('${Routes.tournaments}?careerId=$careerId'),
            ),
            Expanded(
              child: PanelBox(
                child: ContinentalClashView(careerId: careerId),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
