part of 'round_results_screen.dart';

/// Round results on a tablet: every group as one panel, scores beside the
/// table, two to a row. Same provider and rows as the phone.
class _RoundResultsTabletLayout extends ConsumerWidget {
  const _RoundResultsTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final viewAsync = ref.watch(roundResultsViewProvider(careerId));
    final friendlies =
        ref.watch(otherFriendliesProvider(careerId)).valueOrNull ?? const [];
    return Scaffold(
      key: RoundResultsScreen.tabletLayoutKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.resultsRoundResults,
                    style: TabletText.screenTitle,
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: PrimaryButton(
                    label: l.resultsContinue,
                    icon: Icons.check_rounded,
                    height: 44,
                    onPressed: () =>
                        context.go('${Routes.hub}?careerId=$careerId'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: viewAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text(l.resultsCouldNotLoad(e.toString()))),
                data: (view) => _body(l, view, friendlies),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(
    AppLocalizations l,
    RoundResultsView? view,
    List<FriendlyResult> friendlies,
  ) {
    if (view == null) return const SizedBox.shrink();
    final results = view.results;
    final hasContent =
        results != null &&
        (results.groups.isNotEmpty || results.knockoutFixtures.isNotEmpty);
    String code(int id) => view.nations[id]?.code ?? '??';
    String name(int id) => view.nations[id]?.name ?? l.hubUnknown;
    if (results == null || !hasContent) {
      // A friendly window: the other nations' friendlies, if any.
      if (friendlies.isEmpty) return const SizedBox.shrink();
      return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            child: Panel(
              title: l.resultsFriendlyInternationals,
              child: Column(
                children: [
                  for (final f in friendlies)
                    _FriendlyRow(result: f, code: code, name: name),
                ],
              ),
            ),
          ),
        ),
      );
    }
    final isKnockout = results.knockoutFixtures.isNotEmpty;
    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          competitionLabel(l, results.competition).toUpperCase(),
          style: TabletText.panelTitle.copyWith(color: AppColors.primary),
        ),
        Text(
          isKnockout
              ? (results.stage ?? l.resultsKnockout).toUpperCase()
              : l.resultsMatchday(results.matchday),
          style: AppTypography.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
    if (isKnockout) {
      return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            children: [
              heading,
              PanelBox(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      for (final f in results.knockoutFixtures)
                        MatchResultRow(
                          fixture: f,
                          code: code,
                          emphasiseNationId: view.playerNationId,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    final groups = results.groups;
    Widget panel(RoundResultGroup g) =>
        _GroupResultsPanel(group: g, view: view, code: code, name: name);
    return ListView(
      children: [
        heading,
        for (var i = 0; i < groups.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md - 4),
            // Plain Columns and Rows inside: IntrinsicHeight can measure them.
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: panel(groups[i])),
                  const SizedBox(width: AppSpacing.md - 4),
                  Expanded(
                    child: i + 1 < groups.length
                        ? panel(groups[i + 1])
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// One group: this matchday's scores on the left, the table on the right.
class _GroupResultsPanel extends StatelessWidget {
  const _GroupResultsPanel({
    required this.group,
    required this.view,
    required this.code,
    required this.name,
  });

  final RoundResultGroup group;
  final RoundResultsView view;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final relegateCount = view.noRelegationGroups.contains(group.name)
        ? 0
        : view.relegateCount;
    return Panel(
      title: l.resultsGroup(group.name),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                for (final f in group.fixtures)
                  MatchResultRow(
                    fixture: f,
                    code: code,
                    emphasiseNationId: view.playerNationId,
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              children: [
                for (var i = 0; i < group.standings.length; i++)
                  _StandingRow(
                    pos: i + 1,
                    standing: group.standings[i],
                    isPlayer:
                        group.standings[i].nationId == view.playerNationId,
                    directCount: view.directCount,
                    contentionPos: view.contentionPos,
                    relegated:
                        relegateCount > 0 &&
                        i + 1 > group.standings.length - relegateCount,
                    name: name,
                    code: code,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
