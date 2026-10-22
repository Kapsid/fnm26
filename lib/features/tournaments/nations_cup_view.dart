part of 'nations_cup_screen.dart';

/// A Nations Cup's tabs and bodies for a tablet: the tab bar across the top
/// of the area it is given, group tables in columns. [confederation]'s cup,
/// or the manager's own when null, exactly as the route reads it.
class NationsCupView extends ConsumerStatefulWidget {
  const NationsCupView({required this.careerId, this.confederation, super.key});

  final int careerId;
  final Confederation? confederation;

  @override
  ConsumerState<NationsCupView> createState() => _NationsCupViewState();
}

class _NationsCupViewState extends ConsumerState<NationsCupView>
    with _NationsCupBodies<NationsCupView> {
  @override
  bool get grid => true;

  @override
  int get careerId => widget.careerId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(
      nationsCupProvider((
        careerId: widget.careerId,
        confederation: widget.confederation,
      )),
    );
    final view = async.valueOrNull;
    final liveTab = _ncLiveTab(view);
    final zones = view?.format == NationsCupFormat.zones;
    return DefaultTabController(
      // See CupDetailScreen: initialIndex is read once, before the data lands.
      key: ValueKey((liveTab, zones)),
      length: 4,
      initialIndex: liveTab,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabletTabBar(tabs: _tabs(l, zones: zones)),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text(l.tourContCouldNotLoad(e.toString()))),
              data: (v) {
                if (v == null) {
                  return Center(child: Text(l.tourContNoSaveFound));
                }
                return TabBarView(children: _tabViews(v));
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A Nations Cup's page on a tablet: the cup's name over [NationsCupView].
class _NationsCupTabletLayout extends ConsumerWidget {
  const _NationsCupTabletLayout({
    required this.careerId,
    required this.confederation,
  });

  final int careerId;
  final Confederation? confederation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final view = ref
        .watch(
          nationsCupProvider((
            careerId: careerId,
            confederation: confederation,
          )),
        )
        .valueOrNull;
    // Europe's cup keeps the title it always had; the others are named.
    final title = view == null || view.cupName == NationsCups.europe
        ? l.tourContNationsCup
        : competitionLabel(l, view.cupName).capsIn(l.localeName);
    return TabletDetailPage(
      scaffoldKey: NationsCupScreen.tabletLayoutKey,
      title: title,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.tournaments}?careerId=$careerId'),
      child: NationsCupView(careerId: careerId, confederation: confederation),
    );
  }
}
