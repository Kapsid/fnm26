part of 'budget_setup_screen.dart';

/// The budget on a tablet: the banner and the sliders on the left; on the
/// right the staff (wages come off the top, so they are hired here), what
/// the allocation buys department by department, and the Confirm bar. Every
/// figure comes from the screen State's [_Budget]; Confirm is its
/// [_BudgetSetupScreenState._confirm].
class _BudgetSetupTabletLayout extends StatelessWidget {
  const _BudgetSetupTabletLayout({
    required this.state,
    required this.career,
    required this.budget,
  });

  final _BudgetSetupScreenState state;
  final Career career;
  final _Budget budget;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = state.widget.careerId;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 7,
          child: Panel(
            key: TourKeys.budgetDepartments,
            title: l.federationBudgetHeading,
            expand: true,
            padding: EdgeInsets.zero,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.federationDistributeBudget(
                      formatEuros(budget.available),
                    ),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  InvestmentEditor(
                    available: budget.available,
                    initial: budget.alloc,
                    onChanged: state._onAllocated,
                    // Said once, on the right.
                    showEffects: false,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StaffCard(key: TourKeys.budgetStaff, careerId: careerId),
                      const SizedBox(height: AppSpacing.md),
                      Panel(
                        key: BudgetSetupScreen.effectsKey,
                        title: l.budgetEffectsTitle,
                        child: _EffectsList(alloc: budget.alloc),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              state._confirmBar(l, career, budget),
            ],
          ),
        ),
      ],
    );
  }
}

/// What each department's money buys this cycle, live as the sliders move:
/// the same words the phone prints under each slider.
class _EffectsList extends StatelessWidget {
  const _EffectsList({required this.alloc});

  final FederationInvestment alloc;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final d in Department.values)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    departmentLabel(l, d),
                    style: AppTypography.bodyMedium,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _line(l, d, investmentIn(alloc, d))),
              ],
            ),
          ),
      ],
    );
  }

  Widget _line(AppLocalizations l, Department d, int euros) => Text(
    euros <= 0 ? l.deptEffectNone : DepartmentEffect.describe(l, d, euros),
    key: ValueKey('budget.effect.${d.name}'),
    style: AppTypography.labelSmall.copyWith(
      color: euros > 0 ? AppColors.positive : AppColors.onSurfaceVariant,
      fontWeight: euros > 0 ? FontWeight.w700 : null,
    ),
  );
}
