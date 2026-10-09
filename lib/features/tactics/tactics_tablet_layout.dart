part of 'tactics_screen.dart';

/// Tactics on a tablet: the pitch and the bench on the left, the shape and
/// instructions, roles and set pieces, and the opposition on the right.
/// Every control is the phone's, calling the same screen methods.
class _TacticsTabletLayout extends ConsumerWidget {
  const _TacticsTabletLayout({required this.screen});

  static const double _pitchColumnWidth = 452;

  final TacticsScreen screen;

  int get careerId => screen.careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(tacticDataProvider(careerId));
    final service = ref.read(tacticServiceProvider);
    final career = ref.watch(careerByIdProvider(careerId)).valueOrNull;
    final nation = career == null
        ? null
        : ref.watch(nationByIdProvider(career.nationId)).valueOrNull;
    final teamColors = nation == null
        ? null
        : KitColors.discFill(nation.primaryColor, nation.secondaryColor);
    final outlooks =
        ref.watch(absenceOutlookProvider(careerId)).valueOrNull ??
        const <int, AbsenceOutlook>{};
    final drilling =
        ref.watch(shapeDrillingProvider(careerId)).valueOrNull ??
        const <Formation, double>{};
    return Scaffold(
      key: TacticsScreen.tabletLayoutKey,
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.tacticsCouldNotLoadSquad(e.toString()))),
        data: (data) {
          if (data == null) return Center(child: Text(l.tacticsNoTacticSet));
          final tactic = data.tactic;
          final roles =
              ref.watch(playerRolesProvider(careerId)).valueOrNull ??
              const <int, PlayerRole>{};
          final takers = ref
              .watch(setPieceTakersProvider(careerId))
              .valueOrNull;
          final absentIds = {for (final p in data.unavailable) p.id};
          final injuredIds = {
            for (final p in data.unavailable)
              if ((data.absences[p.id]?.injuryMatches ?? 0) > 0) p.id,
          };
          final t = _resolveTakers(ref, careerId, data, takers);
          final bench = [
            for (final p in data.pool)
              if (!tactic.lineup.contains(p.id)) p,
          ]..sort((a, b) => b.overall.compareTo(a.overall));
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: _pitchColumnWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          // Pushed from the match preview: the way back to it.
                          if (context.canPop())
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.primary,
                              ),
                              onPressed: () => context.pop(),
                            ),
                          Text(l.sideTactics, style: TabletText.screenTitle),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              l.tacticsTapOrDrag,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: TabletText.barMeta,
                            ),
                          ),
                        ],
                      ),
                      if (data.unavailableStarters.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        screen._outStartersCard(l, data, outlooks),
                      ],
                      const SizedBox(height: AppSpacing.sm),
                      Expanded(
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 3 / 4,
                            child: screen._pitch(
                              context,
                              ref,
                              data,
                              service: service,
                              teamColors: teamColors,
                              absentIds: absentIds,
                              injuredIds: injuredIds,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Panel(
                        title: l.tacticsTabBench,
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        // A fixed height: before a squad is named the whole
                        // pool sits here, and the pitch must keep its room.
                        child: SizedBox(
                          height: 88,
                          child: bench.isEmpty
                              ? Text(l.tacticsNoSubs, style: TabletText.barMeta)
                              : SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: [
                                      for (final p in bench)
                                        BenchChip(
                                          player: p,
                                          onTap: () => context.push(
                                            '${Routes.player}'
                                            '?careerId=$careerId'
                                            '&playerId=${p.id}',
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md - 4),
                Expanded(
                  child: PanelBox(
                    child: DefaultTabController(
                      length: 3,
                      // The phone's tabs are line-up, instructions, roles and
                      // set pieces: the first two are this Formation tab.
                      initialIndex: screen.initialTab == 2 ? 1 : 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Material(
                            color: AppColors.surfaceContainer,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TabBar(
                                    isScrollable: true,
                                    tabAlignment: TabAlignment.start,
                                    labelColor: AppColors.onSurface,
                                    unselectedLabelColor:
                                        AppColors.onSurfaceVariant,
                                    indicatorColor: AppColors.primary,
                                    tabs: [
                                      Tab(text: l.tacticsFormation),
                                      Tab(text: l.tacticsTabRolesSetPieces),
                                      Tab(text: l.matchDossierTitle),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.bookmark_border,
                                    color: AppColors.primary,
                                  ),
                                  tooltip: l.tacticsTooltipPresets,
                                  onPressed: () => screen._openPresets(
                                    context,
                                    ref,
                                    tactic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        AppSpacing.lg,
                                        AppSpacing.md,
                                        AppSpacing.lg,
                                        0,
                                      ),
                                      child: FormationField(
                                        key: TourKeys.tacticsFormation,
                                        selected: tactic.formation,
                                        drilling: drilling,
                                        onSelected: (f) =>
                                            service.setFormation(careerId, f),
                                      ),
                                    ),
                                    Expanded(
                                      // The playstyle opens the instructions;
                                      // the tour lights the whole block.
                                      child: KeyedSubtree(
                                        key: TourKeys.tacticsPlaystyle,
                                        child: _InstructionsTab(
                                          careerId: careerId,
                                          tactic: tactic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ListView(
                                  padding: const EdgeInsets.all(
                                    AppSpacing.marginMobile,
                                  ),
                                  children: screen._rolesChildren(
                                    context,
                                    ref,
                                    l,
                                    data,
                                    t,
                                    roles,
                                  ),
                                ),
                                _OppositionTab(careerId: careerId),
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
          );
        },
      ),
    );
  }
}

/// The next opponent's briefing, once his draw has been watched. Before then
/// it says so and nothing more: no name, no flag, no danger men.
class _OppositionTab extends ConsumerWidget {
  const _OppositionTab({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final hub = ref.watch(hubDataProvider(careerId)).valueOrNull;
    if (hub == null) return const Center(child: CircularProgressIndicator());
    final next = hub.next;
    if (next == null) {
      return Center(child: Text(l.hubNoMoreFixtures, style: TabletText.cell));
    }
    if (!hub.nextDrawWatched) {
      return Center(child: Text(l.topBarDrawPending, style: TabletText.cell));
    }
    final me = hub.career.nationId;
    final opp = next.homeNationId == me ? next.awayNationId : next.homeNationId;
    final keyMen =
        ref
            .watch(opponentKeyMenProvider((careerId: careerId, nationId: opp)))
            .valueOrNull ??
        const <Player>[];
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        OpponentBriefing(
          careerId: careerId,
          myNationId: me,
          oppNationId: opp,
          oppName: hub.nations[opp]?.name ?? l.hubUnknown,
          oppCode: hub.nations[opp]?.code ?? '??',
          keyMen: keyMen,
          saveSeed: hub.career.rngSeed,
        ),
      ],
    );
  }
}
