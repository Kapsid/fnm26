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
                      // Side by side only when the team records get room
                      // for their values whole; otherwise one over the
                      // other. The LayoutBuilder sits outside the grid:
                      // every tile must report an intrinsic height (no
                      // lists, no LayoutBuilder, no WholeText).
                      LayoutBuilder(
                        builder: (context, box) {
                          final span =
                              rivalry == null ||
                                  box.maxWidth < _sideBySideRecordsWidth
                              ? 12
                              : 6;
                          return DashboardGrid(
                            tiles: [
                              DashboardTile(
                                span: span,
                                child: Panel(
                                  title: l.careerTeamRecords,
                                  child: _TeamRecordTable(book: book),
                                ),
                              ),
                              if (rivalry != null)
                                DashboardTile(
                                  span: span,
                                  child: Panel(
                                    title: l.recordsFiercestRival,
                                    child: _RivalryLine(rivalry: rivalry),
                                  ),
                                ),
                            ],
                          );
                        },
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

/// The master column's least width for the team records and the rival side
/// by side: below it each half is too narrow for "2-0 v Argentina" whole.
const double _sideBySideRecordsWidth = 640;

/// The team's headline records on a tablet: the labels in one column, the
/// values in one column beside them, left-aligned so they read down as a
/// list; a nation's flag in a slot of its own between the two, so a value
/// with a flag starts where the others do. Nothing is cut: a long label or
/// value wraps to a second line.
class _TeamRecordTable extends StatelessWidget {
  const _TeamRecordTable({required this.book});

  final RecordBook book;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final win = book.biggestWin;
    final rows = <(String, String, String?)>[
      (l.recordsBestFinish, book.bestFinish, null),
      (
        l.recordsLongestUnbeaten,
        l.recordsMatchesCount(book.longestUnbeaten),
        null,
      ),
      if (win != null)
        (
          l.recordsBiggestWin,
          l.recordsBiggestWinValue(
            win.gf,
            win.ga,
            book.nations[win.oppId]?.name ?? 'Unknown',
          ),
          book.nations[win.oppId]?.code ?? '??',
        ),
    ];
    final flags = rows.any((r) => r.$3 != null);
    return Table(
      columnWidths: {
        // As wide as the longest label, but never more than 45%: a long
        // label wraps rather than starve the values.
        0: const MinColumnWidth(
          IntrinsicColumnWidth(),
          FractionColumnWidth(0.45),
        ),
        if (flags) 1: const FixedColumnWidth(26),
        (flags ? 2 : 1): const FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        for (final (label, value, code) in rows)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, AppSpacing.md, 5),
                child: Text(
                  label.toUpperCase(),
                  maxLines: 2,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              if (flags)
                Align(
                  alignment: Alignment.centerLeft,
                  child: code == null
                      ? const SizedBox.shrink()
                      : FlagDisc(code, size: 18),
                ),
              Text(value, maxLines: 2, style: AppTypography.bodyMedium),
            ],
          ),
      ],
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
      activeGridColumn<RecordLeader>(
        label: l.gridColActive,
        isActive: (r) => r.active,
      ),
    ],
  );
}
