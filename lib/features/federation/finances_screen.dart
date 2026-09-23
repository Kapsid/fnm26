import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The federation finances screen: the cash balance, this cycle's department
/// investments and the income projected at the season's close. The opening
/// cycle (before any rollover) can be set up here; later cycles are locked in
/// at the end-of-cycle invest step and shown read-only.
class FinancesScreen extends ConsumerStatefulWidget {
  const FinancesScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<FinancesScreen> createState() => _FinancesScreenState();
}

class _FinancesScreenState extends ConsumerState<FinancesScreen> {
  @override
  Widget build(BuildContext context) {
    final viewAsync = ref.watch(financeViewProvider(widget.careerId));
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('${Routes.hub}?careerId=${widget.careerId}'),
        ),
        title: Text(
          l.federationFinances,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.federationCouldNotLoadFinances(e.toString()))),
        data: (view) {
          if (view == null) {
            return Center(child: Text(l.federationSaveNotFound));
          }
          final income = view.projectedIncome;
          final hasCurrent =
              view.current.youth +
                  view.current.commercial +
                  view.current.medical +
                  view.current.naturalization +
                  view.current.boardRelations >
              0;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              // The balance is NOT all spendable, and one number said it
              // was — see [federationFundsProvider], which is the single
              // answer the hub and the budget screen read too.
              _BalanceCard(
                funds:
                    ref
                        .watch(federationFundsProvider(widget.careerId))
                        .valueOrNull ??
                    (balance: view.budget, wages: 0, free: view.budget),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l.federationDevelopment,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _BuildingsCard(careerId: widget.careerId),
              const SizedBox(height: AppSpacing.md),
              Text(
                l.federationProjectedAtSeasonEnd,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(
                  children: [
                    _row(l.federationCentralFunding, income.grant),
                    _row(l.federationPrizeMoneySoFar, income.prize),
                    if (income.commercial > 0)
                      _row(l.federationCommercialReturn, income.commercial),
                  ],
                ),
              ),
              if (hasCurrent) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  l.federationThisSeasonLocked,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _LockedInvestment(investment: view.current),
              ],
              // The next cycle's allocation is NOT editable here.
              //
              // A budget is decided once, at the start of its cycle, on the
              // screen that forces the decision — that is what makes it a
              // decision. Leaving a planner open here meant the same money
              // could be re-cut at any moment, including money for a cycle
              // that had not begun, so nothing was ever actually committed to
              // and the forced allocation was theatre. What this screen shows
              // now is where the money went and what came back.
              const SizedBox(height: AppSpacing.md),
              Text(
                l.federationNextCycleLocked,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }

  Widget _row(String label, int euros) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(formatEuros(euros), style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.funds});

  /// What the federation holds, what is owed to the staff, and what is left.
  final FederationFunds funds;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final budget = funds.balance;
    final wages = funds.wages;
    final free = funds.free;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance,
                color: AppColors.primary,
                size: 32,
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.federationBalance,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    formatEuros(budget),
                    style: AppTypography.headlineMedium,
                  ),
                ],
              ),
            ],
          ),
          // Only worth breaking down when somebody is actually employed: with
          // no staff the balance IS the free money, and a second line saying
          // so twice is noise.
          if (wages > 0) ...[
            const Divider(height: AppSpacing.lg),
            _Split(
              label: l.federationCommittedToStaff,
              amount: wages,
              color: AppColors.warning,
            ),
            const SizedBox(height: AppSpacing.xs),
            _Split(
              label: l.federationFreeToSpend,
              amount: free,
              color: free > 0 ? AppColors.positive : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l.federationWagesNote,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// One line of the balance breakdown: what it is, and how much of it.
class _Split extends StatelessWidget {
  const _Split({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final int amount;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: AppSpacing.sm),
      Text(
        label.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      const Spacer(),
      Text(
        formatEuros(amount),
        style: AppTypography.bodyMedium.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _LockedInvestment extends StatelessWidget {
  const _LockedInvestment({required this.investment});

  final FederationInvestment investment;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        children: [
          for (final d in Department.values)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: Text(d.label, style: AppTypography.bodyMedium),
                  ),
                  Text(
                    formatEuros(switch (d) {
                      Department.youth => investment.youth,
                      Department.commercial => investment.commercial,
                      Department.medical => investment.medical,
                      Department.naturalization => investment.naturalization,
                      Department.boardRelations => investment.boardRelations,
                    }),
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.federationInvestAtCeremony,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// The federation's four buildings, each with a level that grows from the total
/// invested in that department across the whole save — the long-term picture the
/// per-cycle sliders can't convey.
class _BuildingsCard extends ConsumerWidget {
  const _BuildingsCard({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(federationBuildingsProvider(careerId));
    return async.when(
      loading: () => const AppCard(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (buildings) => AppCard(
        child: Column(
          children: [
            for (final b in buildings)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    SizedBox(
                      width: 34,
                      child: _LevelBadge(level: b.level),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${FederationBuildings.nameFor(b.department)}'
                            '  ·  ${b.department.label}',
                            style: AppTypography.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: b.progress,
                              minHeight: 5,
                              backgroundColor: AppColors.surfaceContainerHigh,
                              valueColor: const AlwaysStoppedAnimation(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      formatEuros(b.cumulativeEuros),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final maxed = level >= FederationBuildings.maxLevel;
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: maxed ? AppColors.primary : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: maxed ? AppColors.primary : AppColors.outlineVariant,
        ),
      ),
      child: Text(
        l.federationLevelBadge(level),
        style: AppTypography.labelMedium.copyWith(
          color: maxed ? AppColors.onPrimary : AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
