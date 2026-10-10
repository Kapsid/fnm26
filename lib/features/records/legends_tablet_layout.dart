part of 'legends_screen.dart';

/// The legends on a tablet: the hall of fame and the all-time XI as tabs of
/// sortable grids, the picked legend's card in the pane beside them. The
/// phone's one read, nothing more.
class _LegendsTabletLayout extends ConsumerStatefulWidget {
  const _LegendsTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_LegendsTabletLayout> createState() =>
      _LegendsTabletLayoutState();
}

class _LegendsTabletLayoutState extends ConsumerState<_LegendsTabletLayout> {
  final DetailPaneController _pane = DetailPaneController();

  @override
  void dispose() {
    _pane.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = widget.careerId;
    final async = ref.watch(legendsProvider(careerId));
    return TabletPage(
      scaffoldKey: LegendsScreen.tabletLayoutKey,
      title: l.sideLegends,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.recordsCouldNotLoadLegends(e.toString()))),
        data: (view) {
          if (view == null) return Center(child: Text(l.recordsSaveNotFound));
          if (view.hallOfFame.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  l.recordsNoLegends(view.nationName),
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          return DetailPaneScope(
            controller: _pane,
            child: ListenableBuilder(
              listenable: _pane,
              builder: (context, _) {
                final selectedId = switch (_pane.value) {
                  PlayerTarget(:final playerId) => playerId,
                  _ => null,
                };
                return MasterDetail(
                  initialFraction: 0.62,
                  minFraction: 0.45,
                  maxFraction: 0.72,
                  minDetailWidth: 300,
                  master: PanelBox(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TabletTabBar(
                            tabs: [
                              Tab(text: l.recordsHallOfFame),
                              Tab(text: l.recordsAllTimeXi),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                _LegendGrid(
                                  legends: view.hallOfFame,
                                  ranked: true,
                                  careerId: careerId,
                                  selectedId: selectedId,
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        12,
                                        10,
                                        12,
                                        6,
                                      ),
                                      child: Text(
                                        l.recordsGreatestSide(view.nationName),
                                        style: AppTypography.bodySmall.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: _LegendGrid(
                                        legends: view.allTimeXi,
                                        ranked: false,
                                        careerId: careerId,
                                        selectedId: selectedId,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  detail: PanelBox(
                    child: DetailPaneHost(
                      careerId: careerId,
                      target: _pane.value,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Legends as a table, in their ranked (or XI) order until the manager
/// sorts it.
class _LegendGrid extends StatelessWidget {
  const _LegendGrid({
    required this.legends,
    required this.ranked,
    required this.careerId,
    required this.selectedId,
  });

  final List<RankedLegend> legends;

  /// Whether the place in the hall of fame is shown (the XI has none).
  final bool ranked;
  final int careerId;
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DataGrid<RankedLegend>(
      rows: legends,
      columnSets: [_legendColumns(l, legends, ranked: ranked)],
      selected: legends.where((r) => r.playerId == selectedId).firstOrNull,
      onSelect: (r) =>
          openPlayer(context, careerId: careerId, playerId: r.playerId),
    );
  }
}

/// A legend's line: place, position, name and the record the ranking is
/// built from.
GridColumnSet<RankedLegend> _legendColumns(
  AppLocalizations l,
  List<RankedLegend> legends, {
  required bool ranked,
}) {
  return GridColumnSet<RankedLegend>(
    id: 'overview',
    label: l.gridViewOverview,
    columns: [
      if (ranked)
        GridColumn<RankedLegend>(
          id: 'rank',
          label: l.gridColRank,
          width: 56,
          sortKey: (r) => legends.indexOf(r),
          cell: (r) =>
              Text('${legends.indexOf(r) + 1}', style: TabletText.cellNumeric),
        ),
      GridColumn<RankedLegend>(
        id: 'pos',
        label: l.gridColPos,
        width: 64,
        sortKey: (r) => r.position.index,
        cell: (r) => TacticalChip(r.position.label),
      ),
      GridColumn<RankedLegend>(
        id: 'player',
        label: l.gridColPlayer,
        flex: 3,
        sortKey: (r) => r.name,
        cell: (r) => Text(r.name),
      ),
      GridColumn<RankedLegend>(
        id: 'caps',
        label: l.playerStatCaps,
        width: 64,
        numeric: true,
        sortKey: (r) => r.caps,
        cell: (r) => Text('${r.caps}'),
      ),
      GridColumn<RankedLegend>(
        id: 'goals',
        label: l.playerStatGoals,
        width: 64,
        numeric: true,
        sortKey: (r) => r.goals,
        cell: (r) => Text('${r.goals}'),
      ),
      GridColumn<RankedLegend>(
        id: 'assists',
        label: l.playerStatAssists,
        width: 72,
        numeric: true,
        sortKey: (r) => r.assists,
        cell: (r) => Text('${r.assists}'),
      ),
      GridColumn<RankedLegend>(
        id: 'motm',
        label: l.gridColMotm,
        width: 64,
        numeric: true,
        sortKey: (r) => r.motm,
        cell: (r) => Text('${r.motm}'),
      ),
      GridColumn<RankedLegend>(
        id: 'avg',
        label: l.gridColAvg,
        width: 64,
        numeric: true,
        sortKey: (r) => r.avgRating,
        cell: (r) => Text(r.avgRating.toStringAsFixed(2)),
      ),
    ],
  );
}
