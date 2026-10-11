part of 'all_time_records_screen.dart';

/// The world's all-time records on a tablet: the search over the four boards
/// as tabs of sortable grids, the picked player's card in the pane beside
/// them. The search is the screen State's ([search], [query]), so a resize
/// keeps it. The phone's one read, nothing more.
class _AllTimeTabletLayout extends ConsumerStatefulWidget {
  const _AllTimeTabletLayout({
    required this.careerId,
    required this.query,
    required this.search,
    required this.onQuery,
  });

  final int careerId;
  final String query;
  final TextEditingController search;
  final ValueChanged<String> onQuery;

  @override
  ConsumerState<_AllTimeTabletLayout> createState() =>
      _AllTimeTabletLayoutState();
}

class _AllTimeTabletLayoutState extends ConsumerState<_AllTimeTabletLayout> {
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
    final async = ref.watch(allTimeRecordsProvider(careerId));
    return TabletPage(
      scaffoldKey: AllTimeRecordsScreen.tabletLayoutKey,
      title: l.allTimeRecordsTitle,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.records}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.recordsCouldNotLoadRecords(e.toString()))),
        data: (records) {
          if (records == null) {
            return Center(child: Text(l.recordsSaveNotFound));
          }
          if (records.topScorers.isEmpty && records.mostCaps.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  l.recordsNoWorldHistory,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          final boards = [
            (
              label: l.recordsAllTimeTopScorers,
              value: l.playerStatGoals,
              all: records.topScorers,
            ),
            (
              label: l.recordsMostCapped,
              value: l.playerStatCaps,
              all: records.mostCaps,
            ),
            (
              label: l.recordsMostWcStarts,
              value: l.gridColStarts,
              all: records.mostWcStarts,
            ),
            (
              label: l.recordsMostTournaments,
              value: l.gridColTournaments,
              all: records.mostCupsAttended,
            ),
          ];
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
                  master: PanelBox(
                    child: DefaultTabController(
                      length: boards.length,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: _SearchField(
                              controller: widget.search,
                              onChanged: widget.onQuery,
                            ),
                          ),
                          TabletTabBar(
                            tabs: [for (final b in boards) Tab(text: b.label)],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                for (final b in boards)
                                  _AllTimeGrid(
                                    board: b.all,
                                    shown: _filtered(b.all, widget.query),
                                    valueLabel: b.value,
                                    careerId: careerId,
                                    myNations: records.myNationIds,
                                    selectedId: selectedId,
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

/// One world board as a table: the rows the search leaves ([shown]), each
/// still at its place on the whole board. The manager's own nations stand
/// out, as they do on the phone.
class _AllTimeGrid extends StatelessWidget {
  const _AllTimeGrid({
    required this.board,
    required this.shown,
    required this.valueLabel,
    required this.careerId,
    required this.myNations,
    required this.selectedId,
  });

  final List<AllTimeLeader> board;
  final List<AllTimeLeader> shown;
  final String valueLabel;
  final int careerId;
  final Set<int> myNations;
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (shown.isEmpty) {
      return Center(
        child: Text(
          l.recordsNoMatches,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }
    return DataGrid<AllTimeLeader>(
      rows: shown,
      columnSets: [_allTimeColumns(l, board, valueLabel, myNations)],
      selected: shown.where((r) => r.playerId == selectedId).firstOrNull,
      onSelect: (r) =>
          openPlayer(context, careerId: careerId, playerId: r.playerId),
    );
  }
}

/// A world board's one view: place on the board, player, nation, tally,
/// still playing.
GridColumnSet<AllTimeLeader> _allTimeColumns(
  AppLocalizations l,
  List<AllTimeLeader> board,
  String valueLabel,
  Set<int> myNations,
) {
  return GridColumnSet<AllTimeLeader>(
    id: 'overview',
    label: l.gridViewOverview,
    columns: [
      GridColumn<AllTimeLeader>(
        id: 'rank',
        label: l.gridColRank,
        width: 56,
        sortKey: (r) => board.indexOf(r),
        cell: (r) =>
            Text('${board.indexOf(r) + 1}', style: TabletText.cellNumeric),
      ),
      GridColumn<AllTimeLeader>(
        id: 'player',
        label: l.gridColPlayer,
        flex: 3,
        sortKey: (r) => r.name,
        cell: (r) => Text(
          r.name,
          style: myNations.contains(r.nationId)
              ? TabletText.cell.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                )
              : null,
        ),
      ),
      GridColumn<AllTimeLeader>(
        id: 'nation',
        label: l.gridColNation,
        flex: 2,
        sortKey: (r) => r.nationName,
        cell: (r) => Row(
          children: [
            FlagDisc(
              r.nationCode,
              size: 20,
              highlighted: myNations.contains(r.nationId),
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                r.nationName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      GridColumn<AllTimeLeader>(
        id: 'value',
        label: valueLabel,
        width: 72,
        numeric: true,
        sortKey: (r) => r.value,
        cell: (r) => Text('${r.value}'),
      ),
      activeGridColumn<AllTimeLeader>(
        label: l.gridColActive,
        isActive: (r) => r.active,
      ),
    ],
  );
}
