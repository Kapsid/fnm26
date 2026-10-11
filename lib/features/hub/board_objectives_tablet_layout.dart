part of 'board_objectives_screen.dart';

/// The board's brief on a tablet: the confidence panel first, then one panel
/// per objective, three to a row, each headed by its competition. The
/// phone's two reads, nothing more.
class _BoardObjectivesTabletLayout extends ConsumerWidget {
  const _BoardObjectivesTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final value = ref.watch(satisfactionProvider(careerId)).valueOrNull;
    final objectivesAsync = ref.watch(cycleObjectivesProvider(careerId));
    final objectives = objectivesAsync.valueOrNull ?? const <CycleObjective>[];
    return TabletPage(
      scaffoldKey: BoardObjectivesScreen.tabletLayoutKey,
      title: l.boardObjectivesTitle,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      child: SingleChildScrollView(
        // Every tile must report an intrinsic height (see DashboardGrid).
        child: DashboardGrid(
          tiles: [
            DashboardTile(
              span: 4,
              child: Panel(
                title: l.boardObjectivesConfidence,
                child: _ConfidenceRow(value: value),
              ),
            ),
            if (objectives.isEmpty)
              DashboardTile(
                span: 8,
                child: Panel(
                  title: l.boardObjectivesTitle,
                  child: _ObjectivesState(async: objectivesAsync),
                ),
              )
            else
              for (final objective in objectives)
                DashboardTile(
                  span: 4,
                  child: Panel(
                    title: objective.competition,
                    child: _ObjectiveBody(
                      objective: objective,
                      showCompetition: false,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
