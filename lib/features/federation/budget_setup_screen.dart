import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The watched-draw key marking that the federation budget has been set for a
/// cycle. Until it is set, the budget-setup event is forced first on the hub.
const budgetSetupKind = 'budgetSet';

/// The war chest a career currently has to allocate.
final AutoDisposeFutureProviderFamily<Career?, int> _budgetCareerProvider =
    FutureProvider.autoDispose.family<Career?, int>((ref, careerId) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  return ref.watch(careerRepositoryProvider).byId(careerId);
});

/// The forced, first-of-the-cycle budget allocation. The manager must
/// distribute the federation's war chest across the departments before the
/// season can begin — youth, commercial, medical and naturalisation each shape
/// how the cycle plays out.
class BudgetSetupScreen extends ConsumerStatefulWidget {
  const BudgetSetupScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<BudgetSetupScreen> createState() => _BudgetSetupScreenState();
}

class _BudgetSetupScreenState extends ConsumerState<BudgetSetupScreen> {
  FederationInvestment? _alloc;
  bool _busy = false;

  static const int _step = 500000;

  Future<void> _confirm(Career career, FederationInvestment alloc) async {
    if (_busy) return;
    setState(() => _busy = true);
    final repo = ref.read(careerRepositoryProvider);
    final comp = ref.read(competitionRepositoryProvider);
    final spend = alloc.youth +
        alloc.commercial +
        alloc.medical +
        alloc.naturalization +
        alloc.boardRelations;
    // Charge the allocation to this cycle and lock the war chest in.
    await repo.setInvestment(widget.careerId, career.cyclePointer, alloc);
    await repo.setBudget(widget.careerId, career.budget - spend);
    await comp.markDrawWatched(
      widget.careerId,
      career.cyclePointer,
      budgetSetupKind,
    );
    // The naturalisation offer is no longer rolled here — it now arrives at a
    // random point in the cycle (see SeasonService._rollNaturalizationIfDue),
    // so an approach isn't always glued to setting the budget.
    if (!mounted) return;
    // Refresh the hub so the now-satisfied budget event clears and the season
    // moves on to its next step.
    ref
      ..invalidate(financeViewProvider(widget.careerId))
      ..invalidate(hubDataProvider(widget.careerId));
    context.go('${Routes.hub}?careerId=${widget.careerId}');
  }

  @override
  Widget build(BuildContext context) {
    final careerAsync = ref.watch(_budgetCareerProvider(widget.careerId));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'SET YOUR BUDGET',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: careerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load finances.\n$e')),
        data: (career) {
          if (career == null) {
            return const Center(child: Text('Save not found.'));
          }
          final available = career.budget;
          final alloc = _alloc ??
              const (
                youth: 0,
                commercial: 0,
                medical: 0,
                naturalization: 0,
                boardRelations: 0,
              );
          final allocated = alloc.youth +
              alloc.commercial +
              alloc.medical +
              alloc.naturalization +
              alloc.boardRelations;
          final ready = _alloc != null && available - allocated < _step;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  children: [
                    // A bright banner so the season-defining decision can't be
                    // breezed past.
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: AppRadii.baseAll,
                        border:
                            Border.all(color: AppColors.primary, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.account_balance_rounded,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'FEDERATION BUDGET',
                                style: AppTypography.labelMedium
                                    .copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Distribute ${formatEuros(available)} across the '
                            'departments to open the cycle. This is where the '
                            'season is won or lost — spend it wisely.',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppCard(
                      child: InvestmentEditor(
                        available: available,
                        initial: alloc,
                        onChanged: (a) => setState(() => _alloc = a),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!ready)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Text(
                            'Allocate the full budget to begin the cycle.',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      PrimaryButton(
                        label: _busy ? 'Confirming…' : 'Confirm budget',
                        icon: Icons.savings_rounded,
                        onPressed: (!ready || _busy)
                            ? null
                            : () => unawaited(_confirm(career, alloc)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
