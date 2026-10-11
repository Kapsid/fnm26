part of 'record_book_screen.dart';

/// The record book on a tablet: the way to the legends, the world's records
/// and head to head in a strip at the top; the team's headline records
/// beside the fiercest rival; the three leaderboards as tabs over sortable
/// grids; the picked player's card in the pane beside them. The phone's two
/// reads, nothing more.
class _RecordBookTabletLayout extends ConsumerStatefulWidget {
  const _RecordBookTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_RecordBookTabletLayout> createState() =>
      _RecordBookTabletLayoutState();
}

class _RecordBookTabletLayoutState
    extends ConsumerState<_RecordBookTabletLayout> {
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
    final async = ref.watch(recordBookProvider(careerId));
    return TabletPage(
      scaffoldKey: RecordBookScreen.tabletLayoutKey,
      title: l.sideRecords,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.recordsCouldNotLoadRecords(e.toString()))),
        data: (book) {
          if (book == null) return Center(child: Text(l.recordsSaveNotFound));
          if (!_hasRecords(book)) {
            return _NoHistoryYet(nationName: book.nationName);
          }
          final rivalry = ref.watch(rivalryProvider(careerId)).valueOrNull;
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
                  initialFraction: 0.6,
                  minFraction: 0.45,
                  maxFraction: 0.7,
                  minDetailWidth: 320,
                  master: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LegacyTiles(careerId: careerId, dense: true),
                      const SizedBox(height: AppSpacing.md),
                      // Every tile must report an intrinsic height: no
                      // lists, no LayoutBuilder, no WholeText.
                      DashboardGrid(
                        tiles: [
                          DashboardTile(
                            span: rivalry == null ? 12 : 6,
                            child: Panel(
                              title: l.careerTeamRecords,
                              child: _TeamRecordRows(book: book),
                            ),
                          ),
                          if (rivalry != null)
                            DashboardTile(
                              span: 6,
                              child: Panel(
                                title: l.recordsFiercestRival,
                                child: _RivalryLine(rivalry: rivalry),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Expanded(
                        child: PanelBox(
                          child: DefaultTabController(
                            length: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TabletTabBar(
                                  tabs: [
                                    Tab(text: l.recordsMostCaps),
                                    Tab(text: l.recordsTopScorers),
                                    Tab(text: l.recordsMostAssists),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      _LeaderGrid(
                                        leaders: book.mostCaps,
                                        valueLabel: l.playerStatCaps,
                                        careerId: careerId,
                                        selectedId: selectedId,
                                      ),
                                      _LeaderGrid(
                                        leaders: book.topScorers,
                                        valueLabel: l.playerStatGoals,
                                        careerId: careerId,
                                        selectedId: selectedId,
                                      ),
                                      _LeaderGrid(
                                        leaders: book.topAssists,
                                        valueLabel: l.playerStatAssists,
                                        careerId: careerId,
                                        selectedId: selectedId,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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

/// One leaderboard as a table, in the record book's order until the manager
/// sorts it. Still-active players wear the badge every all-time chart uses.
class _LeaderGrid extends StatelessWidget {
  const _LeaderGrid({
    required this.leaders,
    required this.valueLabel,
    required this.careerId,
    required this.selectedId,
  });

  final List<RecordLeader> leaders;

  /// The tally's column heading (Caps, Goals, Assists).
  final String valueLabel;
  final int careerId;
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (leaders.isEmpty) {
      return Center(
        child: Text(
          l.recordsNoMatches,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }
    return DataGrid<RecordLeader>(
      rows: leaders,
      columnSets: [_leaderColumns(l, leaders, valueLabel)],
      selected: leaders.where((r) => r.playerId == selectedId).firstOrNull,
      onSelect: (r) =>
          openPlayer(context, careerId: careerId, playerId: r.playerId),
    );
  }
}

/// A leaderboard's one view: place, player, tally, still playing. The place
/// is the book's, so it stays put when the manager sorts by name.
GridColumnSet<RecordLeader> _leaderColumns(
  AppLocalizations l,
  List<RecordLeader> leaders,
  String valueLabel,
) {
  return GridColumnSet<RecordLeader>(
    id: 'overview',
    label: l.gridViewOverview,
    columns: [
      GridColumn<RecordLeader>(
        id: 'rank',
        label: l.gridColRank,
        width: 64,
        sortKey: (r) => leaders.indexOf(r),
        cell: (r) => Text(
          '${leaders.indexOf(r) + 1}',
          style: TabletText.cellNumeric,
        ),
      ),
      GridColumn<RecordLeader>(
        id: 'player',
        label: l.gridColPlayer,
        flex: 3,
        sortKey: (r) => r.name,
        cell: (r) => Text(r.name),
      ),
      GridColumn<RecordLeader>(
        id: 'value',
        label: valueLabel,
        width: 80,
        numeric: true,
        sortKey: (r) => r.value,
        cell: (r) => Text('${r.value}'),
      ),
      GridColumn<RecordLeader>(
        id: 'active',
        label: l.gridColActive,
        width: 84,
        sortKey: (r) => r.active ? 1 : 0,
        cell: (r) => r.active ? const ActiveBadge() : const SizedBox.shrink(),
      ),
    ],
  );
}
