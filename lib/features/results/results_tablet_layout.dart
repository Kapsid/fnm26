part of 'results_screen.dart';

/// The manager's matches on a tablet: his cycles listed on the left, the
/// picked one's competitions on the right, each a panel of dense rows. The
/// phone's read and its folding, with the fold state kept by the screen.
class _ResultsTabletLayout extends ConsumerWidget {
  const _ResultsTabletLayout({
    required this.careerId,
    required this.picked,
    required this.onPick,
    required this.opened,
    required this.onToggleEarlier,
  });

  final int careerId;
  final int? picked;
  final ValueChanged<int> onPick;

  /// The campaigns whose earlier matches are open, keyed as the phone keys
  /// them (`cycle|section`), so both layouts agree.
  final Set<String> opened;
  final ValueChanged<String> onToggleEarlier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(resultsProvider(careerId));
    return Scaffold(
      key: ResultsScreen.tabletLayoutKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabletScreenHeader(title: l.resultsMyMatches),
            Expanded(
              child: dataAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text(l.resultsCouldNotLoad(e.toString()))),
                data: (data) {
                  if (data == null || data.fixtures.isEmpty) {
                    return Center(child: Text(l.resultsNoFixtures));
                  }
                  final cycles = ResultsScreen.cycles(l, data);
                  final shown =
                      cycles.where((c) => c.cycle == picked).firstOrNull ??
                      cycles
                          .where((c) => c.cycle == data.cyclePointer)
                          .firstOrNull ??
                      cycles.first;
                  String code(int id) => data.nations[id]?.code ?? '??';
                  return MasterDetail(
                    initialFraction: 0.32,
                    maxFraction: 0.45,
                    minDetailWidth: 480,
                    master: Panel(
                      title: l.resultsCyclesTitle,
                      expand: true,
                      padding: EdgeInsets.zero,
                      child: ListView(
                        children: [
                          for (final c in cycles)
                            _CycleListRow(
                              cycle: c,
                              selected: c.cycle == shown.cycle,
                              onTap: () => onPick(c.cycle),
                            ),
                        ],
                      ),
                    ),
                    detail: ListView(
                      children: [
                        for (final section in shown.sections)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: _section(
                              l,
                              section,
                              '${shown.cycle}|${section.key}',
                              code,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(
    AppLocalizations l,
    ResultSection section,
    String key,
    String Function(int) code,
  ) {
    final open = opened.contains(key);
    return Panel(
      title: section.key,
      action: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.sm),
        child: Text(
          '${section.current.length + section.older.length}',
          style: TabletText.barMeta,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final f in section.current)
            _TabletResultRow(
              fixture: f,
              code: code,
              careerId: careerId,
            ),
          if (section.older.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _EarlierHeader(
              count: section.older.length,
              open: open,
              onTap: () => onToggleEarlier(key),
            ),
            if (open)
              for (final f in section.older)
                _TabletResultRow(
                  fixture: f,
                  code: code,
                  careerId: careerId,
                ),
          ],
        ],
      ),
    );
  }
}

/// One cycle in the tablet list: the same four facts as the phone's fold.
class _CycleListRow extends StatelessWidget {
  const _CycleListRow({
    required this.cycle,
    required this.selected,
    required this.onTap,
  });

  final ResultsCycle cycle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final finish = cycle.finish;
    return Material(
      color: selected ? AppColors.surfaceContainerHighest : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.resultsCycleTitle(
                  cycle.year,
                  cycle.nation?.name ?? l.hubYourNation,
                ),
                maxLines: 2,
                style: TabletText.cell.copyWith(
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.primary : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l.resultsCycleRecord(
                  cycle.played,
                  cycle.won,
                  cycle.drawn,
                  cycle.lost,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TabletText.barMeta,
              ),
              Text(
                finish == null
                    ? l.resultsCycleUnderway
                    : l.resultsCycleFinish(cycleFinishLabel(l, finish)),
                maxLines: 2,
                style: TabletText.sectionLabel.copyWith(
                  color: finish == CycleFinish.champions
                      ? AppColors.primary
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One match as a table row: date, stage, home, score, away.
class _TabletResultRow extends StatelessWidget {
  const _TabletResultRow({
    required this.fixture,
    required this.code,
    required this.careerId,
  });

  final int careerId;
  final Fixture fixture;
  final String Function(int) code;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final f = fixture;
    return Container(
      height: DataGrid.rowHeight,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 104,
            child: Text(
              AppDate.dayMonthYear(context, f.date),
              maxLines: 1,
              style: TabletText.cellNumeric,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              MatchStage.stage(l, f.round),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TabletText.cell.copyWith(color: AppColors.primary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: NationTap(
                careerId: careerId,
                nationId: f.homeNationId,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(code(f.homeNationId), style: TabletText.cell),
                    const SizedBox(width: AppSpacing.sm),
                    FlagDisc(code(f.homeNationId), size: 20),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 64,
            child: Text(
              f.hasResult ? '${f.homeScore} - ${f.awayScore}' : l.resultsVs,
              textAlign: TextAlign.center,
              style: f.hasResult
                  ? TabletText.cellNumeric.copyWith(fontWeight: FontWeight.w700)
                  : TabletText.cell.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: NationTap(
                careerId: careerId,
                nationId: f.awayNationId,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FlagDisc(code(f.awayNationId), size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Text(code(f.awayNationId), style: TabletText.cell),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
