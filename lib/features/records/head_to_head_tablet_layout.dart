part of 'head_to_head_screen.dart';

/// Head to head on a tablet: the two nations and the manager's own ledger
/// on the left; the picked pairing on the right, its record above every
/// meeting, newest first. The pair is the screen State's ([state]), so a
/// resize keeps it, and the slots open the phone's own picker.
class _HeadToHeadTabletLayout extends StatelessWidget {
  const _HeadToHeadTabletLayout({
    required this.state,
    required this.nationsAsync,
  });

  final _HeadToHeadScreenState state;
  final AsyncValue<List<Nation>> nationsAsync;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = state.widget.careerId;
    return TabletPage(
      scaffoldKey: HeadToHeadScreen.tabletLayoutKey,
      title: l.sideHeadToHead,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      child: nationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.recordsCouldNotLoadNations(e.toString()))),
        data: (nations) {
          final byId = {for (final n in nations) n.id: n};
          final a = byId[state._a];
          final b = byId[state._b];
          final same = a != null && b != null && a.id == b.id;
          return MasterDetail(
            initialFraction: 0.48,
            minFraction: 0.38,
            maxFraction: 0.58,
            minDetailWidth: 380,
            master: PanelBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: _NationSlot(
                            label: l.recordsHome,
                            nation: a,
                            onTap: () => state._pickA(nations),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                          ),
                          child: Text(
                            l.recordsVs,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _NationSlot(
                            label: l.recordsAway,
                            nation: b,
                            onTap: () => state._pickB(nations),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
                    child: Text(
                      l.recordsYourRecord,
                      style: TabletText.sectionLabel,
                    ),
                  ),
                  Expanded(
                    child: _LedgerGrid(
                      careerId: careerId,
                      picked: state._b,
                      onPick: state._chooseB,
                    ),
                  ),
                ],
              ),
            ),
            detail: PanelBox(
              child: a != null && b != null && !same
                  ? H2hMeetingsView(
                      // A new pairing is a new list: no scroll carried over.
                      key: ValueKey((a.id, b.id)),
                      careerId: careerId,
                      nationA: a.id,
                      nationB: b.id,
                      header: _Record(
                        careerId: careerId,
                        a: a,
                        b: b,
                        showAllMeetings: false,
                      ),
                    )
                  : MasterDetailPlaceholder(
                      text: same
                          ? l.recordsPickTwoDifferent
                          : l.h2hPickOpponent,
                    ),
            ),
          );
        },
      ),
    );
  }
}

/// The manager's own record against everyone his nation has met, as a
/// sortable table; a row picks that opponent as the away side.
class _LedgerGrid extends ConsumerWidget {
  const _LedgerGrid({
    required this.careerId,
    required this.picked,
    required this.onPick,
  });

  final int careerId;

  /// The away side's id, lit in the table when it is one of these lines.
  final int? picked;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(myHeadToHeadsProvider(careerId));
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l.recordsCouldNotLoadYourRecord(e.toString()))),
      data: (lines) {
        if (lines.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                l.recordsPlayToBuildRecord,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          );
        }
        return DataGrid<MyH2HLine>(
          rows: lines,
          columnSets: [_ledgerColumns(l)],
          selected: lines.where((x) => x.opponentId == picked).firstOrNull,
          onSelect: (x) => onPick(x.opponentId),
        );
      },
    );
  }
}

/// The ledger's one view: opponent, played, won, drawn, lost, goals.
GridColumnSet<MyH2HLine> _ledgerColumns(AppLocalizations l) {
  return GridColumnSet<MyH2HLine>(
    id: 'overview',
    label: l.gridViewOverview,
    columns: [
      GridColumn<MyH2HLine>(
        id: 'opponent',
        label: l.gridColOpponent,
        flex: 3,
        sortKey: (x) => x.opponentName,
        cell: (x) => Row(
          children: [
            FlagDisc(x.opponentCode, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                x.opponentName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      GridColumn<MyH2HLine>(
        id: 'played',
        label: l.careerStatPlayedShort,
        width: 40,
        numeric: true,
        sortKey: (x) => x.played,
        cell: (x) => Text('${x.played}'),
      ),
      GridColumn<MyH2HLine>(
        id: 'won',
        label: l.careerStatWonShort,
        width: 40,
        numeric: true,
        sortKey: (x) => x.wins,
        cell: (x) => Text(
          '${x.wins}',
          style: TabletText.cellNumeric.copyWith(color: AppColors.positive),
        ),
      ),
      GridColumn<MyH2HLine>(
        id: 'drawn',
        label: l.careerStatDrawnShort,
        width: 40,
        numeric: true,
        sortKey: (x) => x.draws,
        cell: (x) => Text(
          '${x.draws}',
          style: TabletText.cellNumeric.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
      GridColumn<MyH2HLine>(
        id: 'lost',
        label: l.careerStatLostShort,
        width: 40,
        numeric: true,
        sortKey: (x) => x.losses,
        cell: (x) => Text(
          '${x.losses}',
          style: TabletText.cellNumeric.copyWith(color: AppColors.error),
        ),
      ),
      GridColumn<MyH2HLine>(
        id: 'goals',
        label: l.recordsGoalsLabel,
        width: 64,
        numeric: true,
        sortKey: (x) => x.goalsFor - x.goalsAgainst,
        cell: (x) => Text('${x.goalsFor}–${x.goalsAgainst}'),
      ),
    ],
  );
}
