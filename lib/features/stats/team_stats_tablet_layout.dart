part of 'team_stats_screen.dart';

/// The team records on a tablet: the way to the record book, the legends,
/// the world's records and head to head in a strip at the top; the team, the
/// manager's record with it and its strength curve under that; the four
/// boards (scorers, most games, ratings, the manager's career) as tabs over
/// sortable grids; the picked player's card in the pane beside them. The
/// phone's reads and sections, laid out as the record book is.
class _TeamStatsTabletLayout extends ConsumerStatefulWidget {
  const _TeamStatsTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_TeamStatsTabletLayout> createState() =>
      _TeamStatsTabletLayoutState();
}

class _TeamStatsTabletLayoutState
    extends ConsumerState<_TeamStatsTabletLayout> {
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
    final async = ref.watch(teamStatsProvider(careerId));
    return TabletPage(
      scaffoldKey: TeamStatsScreen.tabletLayoutKey,
      title: l.careerTeamRecords,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.careers}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.statsCouldNotLoadStats(e.toString()))),
        data: (view) {
          if (view == null) return Center(child: Text(l.statsNoData));
          final history =
              ref.watch(teamOverallHistoryProvider(careerId)).valueOrNull ??
              const <TeamOverallPoint>[];
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
                      LegacyTiles(
                        careerId: careerId,
                        includeRecordBook: true,
                        dense: true,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Side by side only when each card gets 320; a master
                      // narrower than that (the divider dragged left, a
                      // smaller window) puts the curve under the header.
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final header = _TeamHeader(
                            careerId: careerId,
                            nation: view.nation,
                          );
                          // One year is not a curve: the card draws nothing
                          // until there are two.
                          final curve = history.length > 1
                              ? TeamOverallHistoryCard(
                                  key: const Key('team-overall-history'),
                                  history: history,
                                )
                              : null;
                          if (curve == null) return header;
                          // Side by side only when each card gets 364: the
                          // record values ("160-70-60") must fit unclipped.
                          if (constraints.maxWidth >= 2 * 364 + AppSpacing.md) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: header),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(child: curve),
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              header,
                              const SizedBox(height: AppSpacing.sm),
                              curve,
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Expanded(
                        child: PanelBox(
                          child: DefaultTabController(
                            length: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TabletTabBar(
                                  tabs: [
                                    Tab(text: l.statsTopScorersShort),
                                    Tab(text: l.statsMostGames),
                                    Tab(text: l.statsBestRated),
                                    Tab(text: l.statsMyCareer),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      _BoardGrid(
                                        rows: view.scorers,
                                        view: view,
                                        valueLabel: l.playerStatGoals,
                                        careerId: careerId,
                                        selectedId: selectedId,
                                      ),
                                      _BoardGrid(
                                        rows: view.appearances,
                                        view: view,
                                        valueLabel: l.playerStatCaps,
                                        careerId: careerId,
                                        selectedId: selectedId,
                                      ),
                                      _RatingsGrid(
                                        view: view,
                                        careerId: careerId,
                                        selectedId: selectedId,
                                      ),
                                      _CareerRecord(careerId: careerId),
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

/// A scorers or most-games board as a table, in the records' order until
/// the manager sorts it. Still-active players wear the badge every all-time
/// chart uses. Empty, it says what the phone's list says.
class _BoardGrid extends StatelessWidget {
  const _BoardGrid({
    required this.rows,
    required this.view,
    required this.valueLabel,
    required this.careerId,
    required this.selectedId,
  });

  final List<TeamStatEntry> rows;
  final TeamStatsData view;

  /// The tally's column heading (Goals, Caps).
  final String valueLabel;
  final int careerId;
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (rows.isEmpty) {
      return Center(
        child: Text(
          l.statsNoGoalsRecorded,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }
    return DataGrid<TeamStatEntry>(
      rows: rows,
      columnSets: [
        GridColumnSet<TeamStatEntry>(
          id: 'overview',
          label: l.gridViewOverview,
          columns: [
            GridColumn<TeamStatEntry>(
              id: 'rank',
              label: l.gridColRank,
              width: 64,
              sortKey: rows.indexOf,
              cell: (r) => Text(
                '${rows.indexOf(r) + 1}',
                style: TabletText.cellNumeric,
              ),
            ),
            GridColumn<TeamStatEntry>(
              id: 'player',
              label: l.gridColPlayer,
              flex: 3,
              sortKey: (r) => view.names[r.playerId] ?? '',
              cell: (r) => Text(view.names[r.playerId] ?? l.statsUnknown),
            ),
            GridColumn<TeamStatEntry>(
              id: 'value',
              label: valueLabel,
              width: 80,
              numeric: true,
              sortKey: (r) => r.value,
              cell: (r) => Text('${r.value}'),
            ),
            activeGridColumn<TeamStatEntry>(
              label: l.gridColActive,
              isActive: (r) => view.active.contains(r.playerId),
            ),
          ],
        ),
      ],
      selected: rows.where((r) => r.playerId == selectedId).firstOrNull,
      onSelect: (r) =>
          openPlayer(context, careerId: careerId, playerId: r.playerId),
    );
  }
}

/// The ratings board as a table: caps, man-of-the-match awards and the
/// average rating, in the board's colours.
class _RatingsGrid extends StatelessWidget {
  const _RatingsGrid({
    required this.view,
    required this.careerId,
    required this.selectedId,
  });

  final TeamStatsData view;
  final int careerId;
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final rows = view.ratings;
    if (rows.isEmpty) {
      return Center(
        child: Text(
          l.statsNoRatingsRecorded,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }
    return DataGrid<TeamRatingEntry>(
      rows: rows,
      columnSets: [
        GridColumnSet<TeamRatingEntry>(
          id: 'overview',
          label: l.gridViewOverview,
          columns: [
            GridColumn<TeamRatingEntry>(
              id: 'rank',
              label: l.gridColRank,
              width: 64,
              sortKey: rows.indexOf,
              cell: (r) => Text(
                '${rows.indexOf(r) + 1}',
                style: TabletText.cellNumeric,
              ),
            ),
            GridColumn<TeamRatingEntry>(
              id: 'player',
              label: l.gridColPlayer,
              flex: 3,
              sortKey: (r) => view.names[r.playerId] ?? '',
              cell: (r) => Text(view.names[r.playerId] ?? l.statsUnknown),
            ),
            GridColumn<TeamRatingEntry>(
              id: 'caps',
              label: l.playerStatCaps,
              width: 72,
              numeric: true,
              sortKey: (r) => r.apps,
              cell: (r) => Text('${r.apps}'),
            ),
            GridColumn<TeamRatingEntry>(
              id: 'motm',
              label: l.gridColMotm,
              width: 72,
              numeric: true,
              sortKey: (r) => r.motms,
              cell: (r) => Text('${r.motms}'),
            ),
            GridColumn<TeamRatingEntry>(
              id: 'avg',
              label: l.gridColAvg,
              width: 72,
              numeric: true,
              sortKey: (r) => r.meanRating,
              cell: (r) => Text(
                r.meanRating.toStringAsFixed(2),
                style: TabletText.cellNumeric.copyWith(
                  color: AppColors.ratingColor(r.meanRating),
                ),
              ),
            ),
          ],
        ),
      ],
      selected: rows.where((r) => r.playerId == selectedId).firstOrNull,
      onSelect: (r) =>
          openPlayer(context, careerId: careerId, playerId: r.playerId),
    );
  }
}
