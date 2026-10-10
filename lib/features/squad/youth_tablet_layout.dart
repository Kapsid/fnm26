part of 'youth_screen.dart';

/// The youth pyramid on a tablet: the manager's watchlist and the five levels
/// as tabs over sortable grids, the picked boy's card in the pane beside
/// them, the way to the U-21 call-ups in the heading. The phone's three
/// reads, nothing more.
class _YouthTabletLayout extends ConsumerStatefulWidget {
  const _YouthTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_YouthTabletLayout> createState() => _YouthTabletLayoutState();
}

class _YouthTabletLayoutState extends ConsumerState<_YouthTabletLayout> {
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
    final async = ref.watch(youthPyramidProvider(careerId));
    final marked = {
      for (final m
          in ref.watch(youthMarksProvider(careerId)).valueOrNull ??
              const <YouthMark>[])
        m.playerId,
    };
    return DefaultTabController(
      length: YouthLevel.values.length + 1,
      child: TabletPage(
        scaffoldKey: YouthScreen.tabletLayoutKey,
        title: l.youthTitle,
        onBack: () => context.canPop()
            ? context.pop()
            : context.go('${Routes.hub}?careerId=$careerId'),
        trailing: OutlinedButton.icon(
          onPressed: () => context.go('${Routes.callUps}?careerId=$careerId'),
          icon: const Icon(Icons.how_to_reg_rounded, size: 18),
          label: Text(l.u21CallUps),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.outlineVariant),
          ),
        ),
        child: DetailPaneScope(
          controller: _pane,
          child: ListenableBuilder(
            listenable: _pane,
            builder: (context, _) {
              final selectedId = switch (_pane.value) {
                PlayerTarget(:final playerId) => playerId,
                _ => null,
              };
              return MasterDetail(
                initialFraction: 0.64,
                minFraction: 0.5,
                maxFraction: 0.72,
                minDetailWidth: 300,
                master: PanelBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TabletTabBar(
                        tabs: [
                          Tab(text: l.youthWatching),
                          for (final level in YouthLevel.values)
                            Tab(text: level.label),
                        ],
                      ),
                      Expanded(
                        child: async.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('$e')),
                          data: (pyramid) => TabBarView(
                            children: [
                              _WatchGrid(
                                careerId: careerId,
                                years: pyramid.years,
                                selectedId: selectedId,
                              ),
                              for (final level in YouthLevel.values)
                                _LevelGrid(
                                  prospects: pyramid.byLevel[level] ?? const [],
                                  released:
                                      pyramid.releasedByLevel[level] ??
                                      const [],
                                  careerId: careerId,
                                  years: pyramid.years,
                                  marked: marked,
                                  selectedId: selectedId,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
        ),
      ),
    );
  }
}

/// One level's squad as a table, best prospect first until the manager
/// sorts it, with the boys who left the level this year under it.
class _LevelGrid extends StatelessWidget {
  const _LevelGrid({
    required this.prospects,
    required this.released,
    required this.careerId,
    required this.years,
    required this.marked,
    required this.selectedId,
  });

  final List<Prospect> prospects;
  final List<String> released;
  final int careerId;
  final int years;
  final Set<int> marked;
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (prospects.isEmpty && released.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            l.youthEmptyLevel,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      );
    }
    final selected = prospects
        .where((p) => p.player.id == selectedId)
        .firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: DataGrid<Prospect>(
            rows: prospects,
            columnSets: [_columns(l)],
            selected: selected,
            onSelect: (p) =>
                openPlayer(context, careerId: careerId, playerId: p.player.id),
          ),
        ),
        // Boys who were here last year and have been let go. Shown, because
        // a career that ends at fifteen still happened.
        if (released.isNotEmpty)
          Container(
            color: AppColors.surfaceContainer,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.youthReleased.toUpperCase(),
                  style: TabletText.sectionLabel,
                ),
                const SizedBox(height: 2),
                Text(
                  released.join(' · '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TabletText.cell.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  GridColumnSet<Prospect> _columns(AppLocalizations l) =>
      GridColumnSet<Prospect>(
        id: 'level',
        label: l.gridViewOverview,
        columns: [
          GridColumn<Prospect>(
            id: 'pos',
            label: l.squadDevPosition,
            width: 48,
            sortKey: (p) => p.player.position.index,
            cell: (p) => TacticalChip(p.player.position.label),
          ),
          GridColumn<Prospect>(
            id: 'name',
            label: l.squadSortName,
            flex: 3,
            sortKey: (p) => p.player.name,
            cell: (p) => Row(
              children: [
                Flexible(
                  child: Text(
                    p.player.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (p.yearGain >= 3) ...[
                  const SizedBox(width: AppSpacing.xs),
                  _Tag(
                    label: l.u21Breakout(p.yearGain),
                    color: AppColors.positive,
                  ),
                ],
              ],
            ),
          ),
          GridColumn<Prospect>(
            id: 'age',
            label: l.playerAge,
            width: 44,
            numeric: true,
            sortKey: (p) => p.player.age,
            cell: (p) => Text('${p.player.age}'),
          ),
          GridColumn<Prospect>(
            id: 'caps',
            label: l.playerStatCaps,
            width: 52,
            numeric: true,
            sortKey: (p) => p.caps,
            cell: (p) => Text('${p.caps}'),
          ),
          GridColumn<Prospect>(
            id: 'gain',
            label: l.gridColYearGain,
            width: 56,
            numeric: true,
            sortKey: (p) => p.yearGain,
            cell: (p) => Text(
              p.yearGain > 0 ? '+${p.yearGain}' : '${p.yearGain}',
              style: TabletText.cellNumeric.copyWith(
                color: p.yearGain > 0
                    ? AppColors.positive
                    : p.yearGain < 0
                    ? AppColors.error
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          GridColumn<Prospect>(
            id: 'ovr',
            label: l.teamOverall,
            width: 56,
            numeric: true,
            sortKey: (p) => p.player.overall,
            cell: (p) => Text(
              '${p.player.overall}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          GridColumn<Prospect>(
            id: 'ceiling',
            label: l.gridColCeiling,
            width: 80,
            numeric: true,
            sortKey: (p) => p.stars,
            cell: (p) => _Stars(stars: p.stars, certain: p.certain),
          ),
          GridColumn<Prospect>(
            id: 'watch',
            label: '',
            width: 44,
            cell: (p) => _WatchButton(
              careerId: careerId,
              playerId: p.player.id,
              player: p.player,
              years: years,
              marked: marked.contains(p.player.id),
            ),
          ),
        ],
      );
}

/// The manager's shortlist as a table: what each boy was when he was marked,
/// what he is now, and the difference, which is the whole point of a
/// watchlist.
class _WatchGrid extends ConsumerWidget {
  const _WatchGrid({
    required this.careerId,
    required this.years,
    required this.selectedId,
  });

  final int careerId;
  final int years;
  final int? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(youthShortlistProvider(careerId));
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (boys) {
        if (boys.isEmpty) return const _WatchEmpty();
        final selected = boys
            .where((b) => b.player != null && b.player!.id == selectedId)
            .firstOrNull;
        return DataGrid<WatchedBoy>(
          rows: boys,
          columnSets: [_columns(l)],
          selected: selected,
          onSelect: (b) {
            final p = b.player;
            if (p == null) return;
            openPlayer(context, careerId: careerId, playerId: p.id);
          },
        );
      },
    );
  }

  GridColumnSet<WatchedBoy> _columns(AppLocalizations l) =>
      GridColumnSet<WatchedBoy>(
        id: 'watching',
        label: l.gridViewOverview,
        columns: [
          GridColumn<WatchedBoy>(
            id: 'pos',
            label: l.squadDevPosition,
            width: 48,
            sortKey: (b) => b.player?.position.index ?? 1 << 20,
            cell: (b) => b.player == null
                ? const SizedBox.shrink()
                : TacticalChip(b.player!.position.label),
          ),
          GridColumn<WatchedBoy>(
            id: 'name',
            label: l.squadSortName,
            flex: 3,
            sortKey: (b) => b.player?.name ?? b.mark.name,
            cell: (b) => Text(
              b.player?.name ?? b.mark.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GridColumn<WatchedBoy>(
            id: 'marked',
            label: l.gridColMarkedAt,
            width: 92,
            numeric: true,
            sortKey: (b) => b.mark.rating,
            cell: (b) => Text('${b.mark.rating}'),
          ),
          GridColumn<WatchedBoy>(
            id: 'ovr',
            label: l.teamOverall,
            width: 56,
            numeric: true,
            sortKey: (b) => b.player?.overall ?? -1,
            cell: (b) => Text(
              b.player == null ? '' : '${b.player!.overall}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          GridColumn<WatchedBoy>(
            id: 'move',
            label: l.gridColMove,
            width: 56,
            numeric: true,
            sortKey: (b) =>
                b.player == null ? -1 << 20 : b.player!.overall - b.mark.rating,
            cell: (b) {
              final p = b.player;
              if (p == null) return const SizedBox.shrink();
              final move = p.overall - b.mark.rating;
              return _Tag(
                label: move > 0 ? '+$move' : '$move',
                color: move > 0
                    ? AppColors.positive
                    : move < 0
                    ? AppColors.error
                    : AppColors.onSurfaceVariant,
              );
            },
          ),
          GridColumn<WatchedBoy>(
            id: 'status',
            label: l.gridColStatus,
            flex: 2,
            sortKey: (b) => b.status.index,
            cell: (b) => Text(
              _watchStatus(l, b),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GridColumn<WatchedBoy>(
            id: 'ceiling',
            label: l.gridColCeiling,
            width: 80,
            numeric: true,
            sortKey: (b) => b.stars,
            cell: (b) => b.player == null
                ? const SizedBox.shrink()
                : _Stars(stars: b.stars, certain: b.certain),
          ),
          GridColumn<WatchedBoy>(
            id: 'watch',
            label: '',
            width: 44,
            cell: (b) => _WatchButton(
              careerId: careerId,
              playerId: b.mark.playerId,
              player: b.player,
              years: years,
              marked: true,
            ),
          ),
        ],
      );
}
