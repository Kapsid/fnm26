part of 'cycle_rollover_screen.dart';

/// The end of a cycle on a landscape tablet, step by step as on the phone:
/// the champion beside the final's story; the board's verdict and graded
/// briefs beside the jobs on offer; the money banked beside the button that
/// rolls the save on. Every step, pick and button is the screen State's
/// ([_CycleRolloverScreenState._step], `_selected`, `_begin`), so a resize
/// keeps the step and the job picked, and the phone's way back to the saves
/// is on every step.
class _RolloverTabletLayout extends StatelessWidget {
  const _RolloverTabletLayout({required this.state, required this.viewAsync});

  final _CycleRolloverScreenState state;
  final AsyncValue<_RolloverView?> viewAsync;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      key: CycleRolloverScreen.tabletLayoutKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: viewAsync.when(
            loading: state._waiting,
            error: (e, _) => state._failed(l.hubCouldNotLoad('$e')),
            data: (view) => switch (state._step) {
              0 => _ChampionStepTablet(state: state, view: view),
              1 => _BoardStepTablet(state: state),
              _ => _IncomeStepTablet(state: state, view: view),
            },
          ),
        ),
      ),
    );
  }
}

/// Step 0: the trophy and the champion on the left; the final, the host and
/// the golden boot over Continue on the right.
class _ChampionStepTablet extends StatelessWidget {
  const _ChampionStepTablet({required this.state, required this.view});

  final _CycleRolloverScreenState state;
  final _RolloverView? view;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final wc = view?.worldCup;
    String name(int id) => view?.nations[id]?.name ?? l.hubUnknown;
    String code(int id) => view?.nations[id]?.code ?? '??';
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events,
                color: AppColors.primary,
                size: 96,
              ),
              const SizedBox(height: AppSpacing.md),
              if (wc != null) ...[
                Text(
                  l.hubWorldChampionsYear(wc.year),
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FlagDisc(code(wc.championId), size: 72, highlighted: true),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  name(wc.championId),
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineLargeMobile,
                ),
              ] else
                Text(
                  l.hubCycleComplete,
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineMedium,
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (wc != null) ...[
                    _SummaryCard(wc: wc, name: name, code: code),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  PrimaryButton(
                    label: l.hubContinue,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => state._goTo(1),
                  ),
                  state._backToSaves(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Step 1: the verdict and the graded briefs on the left; the job he has
/// and the jobs on offer over the button on the right.
class _BoardStepTablet extends ConsumerWidget {
  const _BoardStepTablet({required this.state});

  final _CycleRolloverScreenState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final careerId = state.widget.careerId;
    final verdictAsync = ref.watch(rolloverVerdictProvider(careerId));
    return verdictAsync.when(
      loading: state._waiting,
      error: (e, _) => state._failed(l.hubCouldNotLoad('$e')),
      data: (v) {
        if (v == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButton(
                  label: l.hubContinue,
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => state._goTo(2),
                ),
                state._backToSaves(),
              ],
            ),
          );
        }
        final canStay = !v.sacked;
        final ready = state._selected != null || canStay;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _VerdictCard(verdict: v),
                  const SizedBox(height: AppSpacing.md),
                  _ObjectivesSummary(careerId: careerId),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        if (canStay && v.currentNation != null) ...[
                          Text(
                            l.hubYourJob,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          _OfferTile(
                            nation: v.currentNation!,
                            subtitle: l.hubStayProject,
                            selected: state._selected == null,
                            onTap: () => state._pick(null),
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        Text(
                          v.sacked ? l.hubChooseNextJob : l.hubOffersOnTable,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        for (final o in v.offers)
                          _OfferTile(
                            nation: o.nation,
                            subtitle: l.hubOfferSubtitle(
                              offerTierLabel(l, o.tier),
                              o.position,
                            ),
                            selected: state._selected == o.nation.id,
                            onTap: () => state._pick(o.nation.id),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  PrimaryButton(
                    label: state._selected == null
                        ? l.hubContinueWith(
                            v.currentNation?.name ?? l.hubYourNation,
                          )
                        : l.hubTakeTheJob,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: !ready ? null : () => state._goTo(2),
                  ),
                  state._backToSaves(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Step 2: the money banked on the left; the roll (or, on a free save that
/// has had its cycle, the way past the wall) on the right.
class _IncomeStepTablet extends ConsumerWidget {
  const _IncomeStepTablet({required this.state, required this.view});

  final _CycleRolloverScreenState state;
  final _RolloverView? view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final careerId = state.widget.careerId;
    final incomeAsync = ref.watch(cycleIncomeProvider(careerId));
    final verdict = ref.watch(rolloverVerdictProvider(careerId)).valueOrNull;
    final blocked = trialExhausted(
      cyclePointer: view?.cyclePointer ?? 0,
      premiumUnlocked: ref.watch(premiumUnlockedProvider),
    );
    return incomeAsync.when(
      loading: state._waiting,
      error: (e, _) => state._failed(l.hubCouldNotLoadFinances('$e')),
      data: (income) => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                Text(
                  l.hubFederationFinances,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _IncomeCard(
                  income: income,
                  openingBalance: view?.budget ?? 0,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l.hubBudgetIntro,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryButton(
                      key: CycleRolloverScreen.beginKey,
                      label: state._busy
                          ? l.hubStarting
                          : (blocked
                                ? l.hubContinueCareer
                                : l.hubBeginNextCycle),
                      icon: blocked
                          ? Icons.lock_open_rounded
                          : Icons.skip_next_rounded,
                      onPressed: state._busy
                          ? null
                          : () => unawaited(state._begin(verdict)),
                    ),
                    state._backToSaves(),
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
