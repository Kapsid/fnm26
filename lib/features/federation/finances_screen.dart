import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/hub/hub_providers.dart';
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
  FederationInvestment? _alloc; // editor state (opening cycle only)
  bool _busy = false;

  Future<void> _commit(FinanceView view) async {
    final alloc = _alloc ?? view.planned;
    if (_busy) return;
    setState(() => _busy = true);
    final repo = ref.read(careerRepositoryProvider);
    // Refund the previously-planned spend and charge the new one (delta).
    final prevSpend = view.planned.youth +
        view.planned.commercial +
        view.planned.medical +
        view.planned.naturalization +
        view.planned.boardRelations;
    final newSpend = alloc.youth +
        alloc.commercial +
        alloc.medical +
        alloc.naturalization +
        alloc.boardRelations;
    final career = await repo.byId(widget.careerId);
    if (career == null) return;
    // Plan the NEXT cycle's investment (its effects — better prospects, fewer
    // injuries, commercial return — all land then).
    await repo.setInvestment(widget.careerId, view.cycle + 1, alloc);
    await repo.setBudget(
      widget.careerId,
      career.budget - (newSpend - prevSpend),
    );
    ref
      ..invalidate(financeViewProvider(widget.careerId))
      ..invalidate(youthBonusByCycleProvider(widget.careerId))
      ..invalidate(hubDataProvider);
    if (mounted) {
      setState(() {
        _busy = false;
        _alloc = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Investment updated.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewAsync = ref.watch(financeViewProvider(widget.careerId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('${Routes.hub}?careerId=${widget.careerId}'),
        ),
        title: Text(
          'FINANCES',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load finances.\n$e')),
        data: (view) {
          if (view == null) {
            return const Center(child: Text('Save not found.'));
          }
          final alloc = _alloc ?? view.planned;
          // Refundable: current balance plus whatever is already planned.
          final available = view.budget +
              view.planned.youth +
              view.planned.commercial +
              view.planned.medical +
              view.planned.naturalization +
              view.planned.boardRelations;
          final income = view.projectedIncome;
          final hasCurrent = view.current.youth +
                  view.current.commercial +
                  view.current.medical +
                  view.current.naturalization +
                  view.current.boardRelations >
              0;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              _BalanceCard(budget: view.budget),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FEDERATION DEVELOPMENT',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _BuildingsCard(careerId: widget.careerId),
              const SizedBox(height: AppSpacing.md),
              Text(
                'PROJECTED AT SEASON END',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(
                  children: [
                    _row('Central funding', income.grant),
                    _row('Prize money so far', income.prize),
                    if (income.commercial > 0)
                      _row('Commercial return', income.commercial),
                  ],
                ),
              ),
              if (hasCurrent) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  'THIS SEASON (LOCKED)',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _LockedInvestment(investment: view.current),
              ],
              const SizedBox(height: AppSpacing.md),
              Text(
                'INVEST FOR NEXT SEASON',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: InvestmentEditor(
                  available: available,
                  initial: alloc,
                  onChanged: (a) => setState(() => _alloc = a),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'NEXT SEASON IMPACT',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _ImpactCard(planned: alloc, current: view.current),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: _busy ? 'Saving…' : 'Confirm investment',
                icon: Icons.savings_rounded,
                onPressed: _busy ? null : () => unawaited(_commit(view)),
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
  const _BalanceCard({required this.budget});

  final int budget;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.account_balance, color: AppColors.primary, size: 32),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FEDERATION BALANCE',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(formatEuros(budget), style: AppTypography.headlineMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class _LockedInvestment extends StatelessWidget {
  const _LockedInvestment({required this.investment});

  final FederationInvestment investment;

  @override
  Widget build(BuildContext context) {
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
            'Invest for next season at the end-of-cycle ceremony.',
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
        'L$level',
        style: AppTypography.labelMedium.copyWith(
          color: maxed ? AppColors.onPrimary : AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// A live preview of what next season's planned investment actually buys, with
/// an arrow whenever it differs from this season's committed spend — so the
/// player can see the concrete effect of moving a slider before confirming.
class _ImpactCard extends StatelessWidget {
  const _ImpactCard({required this.planned, required this.current});

  final FederationInvestment planned;
  final FederationInvestment current;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          _ImpactRow(
            label: 'Academy prospects',
            planned: _youthOverall(planned.youth),
            current: _youthOverall(current.youth),
            format: (v) => '+$v overall',
            higherIsBetter: true,
          ),
          _ImpactRow(
            label: 'Injury risk',
            planned: (FederationFinance.injuryFactor(planned.medical) * 100)
                .round(),
            current: (FederationFinance.injuryFactor(current.medical) * 100)
                .round(),
            format: (v) => '×${(v / 100).toStringAsFixed(2)}',
            higherIsBetter: false,
          ),
          _ImpactRow(
            label: 'Naturalisation chance',
            planned: _natPct(planned.naturalization),
            current: _natPct(current.naturalization),
            format: (v) => '$v%',
            higherIsBetter: true,
          ),
          _ImpactRow(
            label: 'Commercial return',
            planned: FederationFinance.commercialReturn(planned.commercial),
            current: FederationFinance.commercialReturn(current.commercial),
            format: formatEuros,
            higherIsBetter: true,
          ),
          _ImpactRow(
            label: 'Board patience',
            planned: FederationFinance.boardTolerance(planned.boardRelations),
            current: FederationFinance.boardTolerance(current.boardRelations),
            format: (v) => '+$v',
            higherIsBetter: true,
          ),
        ],
      ),
    );
  }

  /// The youth talent bonus expressed as approximate overall points (~+12 at
  /// full investment), for a tangible read on what the academy buys.
  static int _youthOverall(int invested) =>
      (FederationFinance.youthTalentBonus(invested) / 0.18 * 12).round();

  static int _natPct(int invested) =>
      (FederationFinance.naturalizationChance(invested) * 100).round();
}

class _ImpactRow extends StatelessWidget {
  const _ImpactRow({
    required this.label,
    required this.planned,
    required this.current,
    required this.format,
    required this.higherIsBetter,
  });

  final String label;
  final int planned;
  final int current;
  final String Function(int) format;
  final bool higherIsBetter;

  @override
  Widget build(BuildContext context) {
    final changed = planned != current;
    final better = higherIsBetter ? planned > current : planned < current;
    final deltaColor = !changed
        ? AppColors.onSurfaceVariant
        : better
            ? AppColors.positive
            : AppColors.error;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            format(planned),
            style: AppTypography.bodyMedium.copyWith(
              color: changed ? deltaColor : AppColors.onSurface,
              fontWeight: changed ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          if (changed) ...[
            const SizedBox(width: 4),
            Icon(
              better
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              size: 14,
              color: deltaColor,
            ),
          ],
        ],
      ),
    );
  }
}
