part of 'finances_screen.dart';

/// The finances on a tablet: the balance beside the projected income, the
/// federation's buildings beside this cycle's locked-in investment, the note
/// on next cycle's budget under them. The phone's three reads, nothing more.
class _FinancesTabletLayout extends ConsumerWidget {
  const _FinancesTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final viewAsync = ref.watch(financeViewProvider(careerId));
    return TabletPage(
      scaffoldKey: FinancesScreen.tabletLayoutKey,
      title: l.sideFinances,
      trailing: _StadiumsButton(careerId: careerId),
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      child: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.federationCouldNotLoadFinances(e.toString()))),
        data: (view) {
          if (view == null) {
            return Center(child: Text(l.federationSaveNotFound));
          }
          final funds =
              ref.watch(federationFundsProvider(careerId)).valueOrNull ??
              (balance: view.budget, wages: 0, free: view.budget);
          final buildings = ref.watch(federationBuildingsProvider(careerId));
          final invested = _anyInvested(view.current);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Every tile must report an intrinsic height: no lists, no
                // LayoutBuilder, no WholeText (see DashboardGrid).
                DashboardGrid(
                  tiles: [
                    DashboardTile(
                      span: 5,
                      child: Panel(
                        title: l.federationBalance,
                        child: _BalanceBody(funds: funds),
                      ),
                    ),
                    DashboardTile(
                      span: 7,
                      child: Panel(
                        title: l.federationProjectedAtSeasonEnd,
                        child: _IncomeRows(income: view.projectedIncome),
                      ),
                    ),
                    DashboardTile(
                      span: invested ? 7 : 12,
                      child: Panel(
                        title: l.federationDevelopment,
                        child: buildings.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (_, _) => const SizedBox.shrink(),
                          data: (b) => _BuildingRows(buildings: b),
                        ),
                      ),
                    ),
                    if (invested)
                      DashboardTile(
                        span: 5,
                        child: Panel(
                          title: l.federationThisSeasonLocked,
                          child: _InvestmentRows(investment: view.current),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // The national stadiums, labelled, as on the phone.
                NationalStadiumsEntry(careerId: careerId),
                FanMoodLine(careerId: careerId),
                const SizedBox(height: AppSpacing.md),
                // The next cycle's allocation is not editable here, on
                // either layout (see the phone tree).
                Text(
                  l.federationNextCycleLocked,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
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
