part of 'world_ranking_screen.dart';

/// The world ranking on a tablet: every nation in a sortable table, the
/// picked one's record in the pane beside it (the manager's own until he
/// picks another). The phone's two reads, nothing more.
class _WorldRankingTabletLayout extends ConsumerStatefulWidget {
  const _WorldRankingTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_WorldRankingTabletLayout> createState() =>
      _WorldRankingTabletLayoutState();
}

class _WorldRankingTabletLayoutState
    extends ConsumerState<_WorldRankingTabletLayout> {
  final DetailPaneController _pane = DetailPaneController();
  final ScrollController _grid = ScrollController();

  /// The (region, row) the table was last centred on, so a filter change or a
  /// new release re-centres on the manager's nation, and nothing else does.
  ({Confederation? region, int index})? _centredOn;

  @override
  void dispose() {
    _pane.dispose();
    _grid.dispose();
    super.dispose();
  }

  // The grid caches its sort against list identity, and the pane rebuilds
  // this on every pick: keep the same lists until their inputs change.
  RankingData? _rowsData;
  Confederation? _rowsRegion;
  List<Nation> _rows = const [];

  List<Nation> _rowsFor(RankingData data, Confederation? region) {
    if (!identical(_rowsData, data) || _rowsRegion != region) {
      _rowsData = data;
      _rowsRegion = region;
      _rows = [
        for (final n in data.nations)
          if (region == null || n.confederation == region) n,
      ];
    }
    return _rows;
  }

  AppLocalizations? _setsL;
  RankingData? _setsData;
  List<GridColumnSet<Nation>> _sets = const [];

  List<GridColumnSet<Nation>> _setsFor(AppLocalizations l, RankingData data) {
    if (_setsL != l || !identical(_setsData, data)) {
      _setsL = l;
      _setsData = data;
      _sets = rankingColumnSets(l, data);
    }
    return _sets;
  }

  void _centre(int index, {bool animate = false}) {
    if (!mounted || !_grid.hasClients || index < 0) return;
    final viewport = _grid.position.viewportDimension;
    final target =
        (index * DataGrid.rowHeight + DataGrid.rowHeight / 2 - viewport / 2)
            .clamp(0.0, _grid.position.maxScrollExtent);
    if (animate) {
      _grid.animateTo(
        target,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _grid.jumpTo(target);
    }
  }

  void _focus(Confederation? region, int index) {
    if (index < 0) return;
    if (_centredOn?.region == region && _centredOn?.index == index) return;
    _centredOn = (region: region, index: index);
    WidgetsBinding.instance.addPostFrameCallback((_) => _centre(index));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = widget.careerId;
    final dataAsync = ref.watch(worldRankingProvider(careerId));
    final region = ref.watch(selectedRankRegionProvider);
    return Scaffold(
      key: WorldRankingScreen.tabletLayoutKey,
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorState(
          message: l.rankingCouldNotLoad('').trim(),
          onRetry: () => ref.invalidate(worldRankingProvider(careerId)),
        ),
        data: (data) {
          if (data == null) return Center(child: Text(l.rankingNoRanking));
          final rows = _rowsFor(data, region);
          final sets = _setsFor(l, data);
          final playerIndex = rows.indexWhere(
            (n) => n.id == data.playerNationId,
          );
          _focus(region, playerIndex);
          final now = data.position[data.playerNationId];
          return DetailPaneScope(
            controller: _pane,
            child: ListenableBuilder(
              listenable: _pane,
              builder: (context, _) {
                final target = _pane.value ?? NationTarget(data.playerNationId);
                final selectedId = switch (target) {
                  NationTarget(:final nationId) => nationId,
                  _ => null,
                };
                final selected = rows
                    .where((n) => n.id == selectedId)
                    .firstOrNull;
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: MasterDetail(
                    initialFraction: 0.58,
                    minFraction: 0.45,
                    maxFraction: 0.7,
                    minDetailWidth: 320,
                    master: PanelBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
                            child: TabletScreenHeader(
                              title: l.tourSharedWorldRankingTitle,
                              trailing: IconButton(
                                tooltip: l.rankingCentreOnMe,
                                icon: const Icon(
                                  Icons.my_location_rounded,
                                  color: AppColors.primary,
                                ),
                                onPressed: () =>
                                    _centre(playerIndex, animate: true),
                              ),
                            ),
                          ),
                          RankMovementHeader(
                            baseline: data.baseline,
                            from: now == null
                                ? null
                                : now +
                                      (data.movement[data.playerNationId] ?? 0),
                            now: now,
                          ),
                          _RegionFilter(
                            selected: region,
                            onSelect: (r) =>
                                ref
                                        .read(
                                          selectedRankRegionProvider.notifier,
                                        )
                                        .state =
                                    r,
                          ),
                          Expanded(
                            child: DataGrid<Nation>(
                              rows: rows,
                              columnSets: sets,
                              selected: selected,
                              controller: _grid,
                              onSelect: (n) => openNation(
                                context,
                                careerId: careerId,
                                nationId: n.id,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    detail: PanelBox(
                      child: DetailPaneHost(
                        careerId: careerId,
                        target: target,
                        placeholder: l.panePickNation,
                      ),
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

/// The ranking table's one view: place, movement, nation, region, points.
/// Rank sorts best first on the first tap; movement and points biggest first.
List<GridColumnSet<Nation>> rankingColumnSets(
  AppLocalizations l,
  RankingData data,
) {
  return [
    GridColumnSet<Nation>(
      id: 'overview',
      label: l.gridViewOverview,
      columns: [
        GridColumn<Nation>(
          id: 'rank',
          label: l.gridColRank,
          width: 64,
          sortKey: (n) => data.position[n.id] ?? 1 << 20,
          cell: (n) => Text(
            '${data.position[n.id] ?? ''}',
            style: TabletText.cellNumeric,
          ),
        ),
        GridColumn<Nation>(
          id: 'move',
          label: l.gridColMove,
          width: 72,
          numeric: true,
          sortKey: (n) => data.movement[n.id] ?? 0,
          cell: (n) => RankMovement(data.movement[n.id] ?? 0),
        ),
        GridColumn<Nation>(
          id: 'nation',
          label: l.gridColNation,
          flex: 3,
          sortKey: (n) => n.name,
          cell: (n) {
            final mine = n.id == data.playerNationId;
            return Row(
              children: [
                FlagDisc(n.code, size: 22, highlighted: mine),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    n.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: mine
                        ? TabletText.cell.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
        GridColumn<Nation>(
          id: 'region',
          label: l.gridColRegion,
          flex: 2,
          sortKey: (n) => n.confederation.index,
          cell: (n) => Text(confederationLabel(l, n.confederation)),
        ),
        GridColumn<Nation>(
          id: 'points',
          label: l.gridColPoints,
          width: 80,
          numeric: true,
          sortKey: (n) => data.points[n.id] ?? 0,
          cell: (n) => Text('${data.points[n.id] ?? 0}'),
        ),
      ],
    ),
  ];
}
