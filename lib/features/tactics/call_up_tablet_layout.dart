part of 'call_up_screen.dart';

/// Call-ups on a tablet: the pool as a table and the squad being named with
/// its summary and the confirm button. A name opens the player's own page,
/// and back returns here. All state is the screen's own (selection, draft,
/// line filter).
class _CallUpTabletLayout extends StatelessWidget {
  const _CallUpTabletLayout({
    required this.state,
    required this.data,
    required this.selected,
    required this.window,
    required this.locked,
    required this.coverage,
    required this.formation,
    required this.condition,
  });

  // The squad panel takes a share of the width, so its names read whole;
  // the pool takes the rest. At the narrowest tablet content width (about
  // 800 inside the padding) the pool keeps about 480, room for its columns.
  static const double _squadShare = 0.4;
  static const double _squadMinWidth = 300;
  static const double _squadMaxWidth = 440;

  final _CallUpScreenState state;
  final SquadData data;
  final Set<int> selected;
  final NominationWindow? window;
  final bool locked;
  final int coverage;
  final Formation formation;
  final Map<int, PlayerCondition> condition;

  int get careerId => state.widget.careerId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final rows = [
      for (final p in data.pool)
        if (state._tabletLine == null || p.category == state._tabletLine) p,
    ]..sort((a, b) => b.overall.compareTo(a.overall));
    final status = state._squadStatus(selected, data, coverage);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: LayoutBuilder(
        builder: (context, box) {
          const gap = AppSpacing.md - 4;
          final squadWidth = (box.maxWidth * _squadShare).clamp(
            _squadMinWidth,
            _squadMaxWidth,
          );
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Panel(
                  title: l.squadStatPool,
                  expand: true,
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _lineChips(context, l),
                      Expanded(
                        child: DataGrid<Player>(
                          rows: rows,
                          columnSets: [_columns(context, l)],
                          onSelect: (p) => _openPlayer(context, p),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: gap),
              SizedBox(
                width: squadWidth,
                child: _squadPanel(context, l, status),
              ),
            ],
          );
        },
      ),
    );
  }

  /// His own page, pushed over the call-ups: back pops to this screen with
  /// its State, so the squad being named is exactly as it was (and drafted
  /// besides).
  void _openPlayer(BuildContext context, Player p) => unawaited(
    context.push('${Routes.player}?careerId=$careerId&playerId=${p.id}'),
  );

  int _named(PositionCategory c) =>
      data.pool.where((p) => p.category == c && selected.contains(p.id)).length;

  Widget _lineChips(BuildContext context, AppLocalizations l) {
    Widget chip(String label, PositionCategory? line) => Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs),
      child: ChoiceChip(
        label: Text(label),
        visualDensity: VisualDensity.compact,
        selected: state._tabletLine == line,
        onSelected: (_) => state._setTabletLine(line),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Wrap(
        children: [
          chip(l.squadLineAll.capsIn(l.localeName), null),
          for (final c in _CallUpScreenState._order)
            chip(
              '${state._shortHeading(l, c)} '
              '${_named(c)}',
              c,
            ),
        ],
      ),
    );
  }

  GridColumnSet<Player> _columns(BuildContext context, AppLocalizations l) =>
      GridColumnSet<Player>(
        id: 'pool',
        label: l.squadStatPool,
        columns: [
          GridColumn<Player>(
            id: 'pick',
            label: '',
            width: 40,
            cell: (p) => Checkbox(
              value: selected.contains(p.id),
              visualDensity: VisualDensity.compact,
              onChanged: locked
                  ? null
                  : (on) => state._toggle(
                      context,
                      p,
                      on ?? false,
                      selected: selected,
                      absences: data.absences,
                      coverage: coverage,
                    ),
            ),
          ),
          GridColumn<Player>(
            id: 'pos',
            label: l.squadDevPosition.capsIn(l.localeName),
            width: 48,
            sortKey: (p) => p.position.index,
            cell: (p) => TacticalChip(p.position.label),
          ),
          GridColumn<Player>(
            id: 'name',
            label: l.squadSortName.capsIn(l.localeName),
            flex: 3,
            sortKey: (p) => p.name,
            cell: (p) => Row(
              key: const ValueKey('callUps.name'),
              children: [
                if (!(data.absences[p.id]?.isAvailable ?? true))
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      (data.absences[p.id]?.injuryMatches ?? 0) > 0
                          ? Icons.personal_injury
                          : Icons.gavel_rounded,
                      size: 13,
                      color: (data.absences[p.id]?.injuryMatches ?? 0) > 0
                          ? AppColors.warning
                          : AppColors.error,
                    ),
                  ),
                Flexible(child: Text(p.name)),
              ],
            ),
          ),
          GridColumn<Player>(
            id: 'age',
            label: l.playerAge.capsIn(l.localeName),
            width: 44,
            numeric: true,
            sortKey: (p) => p.age,
            cell: (p) => Text('${p.age}'),
          ),
          GridColumn<Player>(
            id: 'ovr',
            label: l.teamOverall.capsIn(l.localeName),
            width: 64,
            numeric: true,
            sortKey: (p) => p.overall,
            cell: (p) => Text(
              '${p.overall}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          GridColumn<Player>(
            id: 'form',
            label: l.playerStatForm.capsIn(l.localeName),
            width: 48,
            numeric: true,
            sortKey: (p) => condition[p.id]?.formRating ?? 0,
            cell: (p) => _FormDot(
              form: condition[p.id]?.form ?? PlayerForm.steady,
            ),
          ),
        ],
      );

  Widget _squadPanel(
    BuildContext context,
    AppLocalizations l,
    ({int count, int fit, bool ok}) status,
  ) {
    final named = [
      for (final p in data.pool)
        if (selected.contains(p.id)) p,
    ]..sort((a, b) => b.overall.compareTo(a.overall));
    return Panel(
      title: l.tacticsSquad,
      expand: true,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KeyedSubtree(
            key: TourKeys.callUpCount,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.tacticsSquadCount(status.count, kMaxSquadSize),
                    style: AppTypography.labelMedium.copyWith(
                      color: status.ok ? AppColors.onSurface : AppColors.error,
                    ),
                  ),
                  Text(
                    status.count >= kMinSquadSize &&
                            status.count <= kMaxSquadSize &&
                            status.fit < kMinFitPlayers
                        ? l.tacticsNeedFitPlayers(kMinFitPlayers, status.fit)
                        : l.tacticsMinMax(kMinSquadSize, kMaxSquadSize),
                    style: AppTypography.labelSmall.copyWith(
                      color: status.ok
                          ? AppColors.onSurfaceVariant
                          : AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (window != null && window!.matches.isNotEmpty)
            _CoverageBanner(window: window!, locked: locked),
          if (!locked)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          state._pickBest(data, coverage, formation),
                      child: Text(
                        l.tacticsBestQuality,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: !data.hasPreviousSquad
                          ? null
                          : () => state._pickPrevious(data, coverage),
                      child: Text(
                        l.tacticsPreviousSquad,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: [
                for (final c in _CallUpScreenState._order)
                  if (named.any((p) => p.category == c)) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 2),
                      child: Text(
                        state._shortHeading(l, c).capsIn(l.localeName),
                        style: TabletText.sectionLabel,
                      ),
                    ),
                    for (final p in named.where((p) => p.category == c))
                      ListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        leading: TacticalChip(p.position.label),
                        title: Text(
                          p.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${p.overall}',
                              style: TabletText.cellNumeric,
                            ),
                            if (!locked)
                              IconButton(
                                icon: const Icon(Icons.close, size: 16),
                                visualDensity: VisualDensity.compact,
                                onPressed: () => state._toggle(
                                  context,
                                  p,
                                  false,
                                  selected: selected,
                                  absences: data.absences,
                                  coverage: coverage,
                                ),
                              ),
                          ],
                        ),
                        onTap: () => _openPlayer(context, p),
                      ),
                  ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: locked
                ? OutlinedButton.icon(
                    onPressed: () => context.go(state._exitRoute),
                    icon: const Icon(Icons.lock_outline, size: 18),
                    label: Text(l.tacticsSquadLockedBack),
                  )
                : PrimaryButton(
                    label: l.tacticsConfirmSquad,
                    icon: Icons.check_rounded,
                    onPressed: status.ok
                        ? () => state._confirm(selected)
                        : null,
                  ),
          ),
        ],
      ),
    );
  }
}
