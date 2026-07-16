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
        view.planned.naturalization;
    final newSpend = alloc.youth +
        alloc.commercial +
        alloc.medical +
        alloc.naturalization;
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
              view.planned.naturalization;
          final income = view.projectedIncome;
          final hasCurrent = view.current.youth +
                  view.current.commercial +
                  view.current.medical +
                  view.current.naturalization >
              0;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              _BalanceCard(budget: view.budget),
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
