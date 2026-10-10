import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/federation_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/federation/department_effect.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/federation/staff_card.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'budget_setup_tablet_layout.dart';

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

  static const Key tabletLayoutKey = Key('budgetSetup.tabletLayout');

  /// The tablet's "What this budget buys" panel.
  static const Key effectsKey = Key('budgetSetup.effects');

  @override
  ConsumerState<BudgetSetupScreen> createState() => _BudgetSetupScreenState();
}

/// Whether this cycle's budget has already been distributed.
final AutoDisposeFutureProviderFamily<bool, int> budgetSettledProvider =
    FutureProvider.autoDispose.family<bool, int>((ref, careerId) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return false;
      return ref
          .watch(competitionRepositoryProvider)
          .hasWatchedDraw(careerId, career.cyclePointer, budgetSetupKind);
    });

/// The smallest slice of the budget a department can be given.
const int kBudgetStep = 500000;

/// Whether an allocation of [allocated] out of [available] may be confirmed.
///
/// BOTH ends matter, and only one of them used to. The rule was "the remainder
/// is smaller than one step", which is true of every NEGATIVE remainder too —
/// so an over-committed budget read as a finished one and could be confirmed,
/// spending money the federation does not have.
///
/// Over-committing is reachable without touching a slider: staff are hired on
/// this same screen and their wages come off the top, so allocating everything
/// and then hiring an elite assistant moves the ceiling down underneath an
/// allocation that was legal when it was made.
bool budgetReady({required int available, required int allocated}) {
  final remaining = available - allocated;
  return remaining >= 0 && remaining < kBudgetStep;
}

/// Everything both layouts read off the allocation in progress, worked out
/// once (see [_BudgetSetupScreenState._budgetFor]).
typedef _Budget = ({
  int available,
  FederationInvestment alloc,
  int allocated,
  bool overCommitted,
  bool ready,
  bool settled,
});

class _BudgetSetupScreenState extends ConsumerState<BudgetSetupScreen> {
  FederationInvestment? _alloc;
  bool _busy = false;

  Future<void> _confirm(Career career, FederationInvestment alloc) async {
    if (_busy) return;
    setState(() => _busy = true);
    // Read before the first await: the manager may leave (or a resize across
    // 1000 swap layouts) while the budget is saving, and the hub must still
    // be refreshed and only a manager still here taken on to it.
    final container = ProviderScope.containerOf(context, listen: false);
    final router = GoRouter.of(context);
    final careerId = widget.careerId;
    final repo = ref.read(careerRepositoryProvider);
    final comp = ref.read(competitionRepositoryProvider);
    final spend =
        alloc.youth +
        alloc.commercial +
        alloc.medical +
        alloc.naturalization +
        alloc.boardRelations;
    // Charge the allocation to this cycle and lock the war chest in.
    //
    // Refuse rather than go negative. The button is disabled unless
    // [budgetReady] says so, and this is the belt to that pair of braces: a
    // federation cannot spend money it does not have, and a negative balance
    // would be carried into the rollover and compound there.
    if (spend > career.budget) return;
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
    //
    // Refresh the hub so the now-satisfied budget event clears and the season
    // moves on to its next step. Through the captured container, so it
    // happens even when this page is gone (the tablet top bar reads it).
    container
      ..invalidate(financeViewProvider(careerId))
      // The balance has just changed, and the money indicator on the hub reads
      // it through here — a derived provider never notices a write it did not
      // make, so it is told.
      ..invalidate(federationFundsProvider(careerId))
      ..invalidate(hubDataProvider(careerId));
    // `router.state` is the top-most route, a pushed one included: a manager
    // who went elsewhere meanwhile is left there.
    if (router.state.uri.path == Routes.budgetSetup) {
      router.go('${Routes.hub}?careerId=$careerId');
    }
  }

  /// The money there is, the split so far, and whether it may be confirmed.
  /// Both layouts read these and nothing else, so the rules live here once.
  _Budget _budgetFor(Career career) {
    // The wage bill comes off the top. Staff are a standing cost the
    // federation pays at the rollover, so money already promised to
    // people is not money there is to hand to a department — showing it
    // any other way is how a budget ends up overspent by exactly the
    // amount of an elite scout.
    final available =
        ref.watch(federationFundsProvider(widget.careerId)).valueOrNull?.free ??
        career.budget;
    final alloc =
        _alloc ??
        const (
          youth: 0,
          commercial: 0,
          medical: 0,
          naturalization: 0,
          boardRelations: 0,
        );
    final allocated =
        alloc.youth +
        alloc.commercial +
        alloc.medical +
        alloc.naturalization +
        alloc.boardRelations;
    // Already distributed this cycle? Then this screen is a record, not
    // an editor. The hub only offers the event while it is unset, but
    // the guided tour visits this route directly and a re-cut here would
    // undo a decision the manager has already lived with.
    final settled =
        ref.watch(budgetSettledProvider(widget.careerId)).valueOrNull ?? false;
    return (
      available: available,
      alloc: alloc,
      allocated: allocated,
      overCommitted: allocated > available,
      ready:
          _alloc != null &&
          budgetReady(available: available, allocated: allocated),
      settled: settled,
    );
  }

  void _onAllocated(FederationInvestment a) => setState(() => _alloc = a);

  /// What is still to do (or what is over), and the button that commits it.
  Widget _confirmBar(AppLocalizations l, Career career, _Budget b) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!b.ready)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              // Over-committed says something different from
              // "not finished yet": the manager has promised
              // money that is not there, usually by hiring staff
              // after allocating, and needs to take some back.
              b.overCommitted
                  ? l.federationOverBudget(
                      formatEuros(b.allocated - b.available),
                    )
                  : l.federationAllocateFullBudget,
              style: AppTypography.labelSmall.copyWith(
                color: b.overCommitted
                    ? AppColors.error
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
        PrimaryButton(
          label: b.settled
              ? l.federationBudgetAlreadySet
              : _busy
              ? l.federationConfirming
              : l.federationConfirmBudget,
          icon: Icons.savings_rounded,
          onPressed: (!b.ready || _busy || b.settled)
              ? null
              : () => unawaited(_confirm(career, b.alloc)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final careerAsync = ref.watch(_budgetCareerProvider(widget.careerId));
    final l = AppLocalizations.of(context);
    if (TabletShellScope.isActive(context)) {
      return TabletPage(
        scaffoldKey: BudgetSetupScreen.tabletLayoutKey,
        title: l.budgetSetupTitle,
        // A way out, as on the phone: forced is not the same as a trap.
        onBack: () => context.go('${Routes.hub}?careerId=${widget.careerId}'),
        backTooltip: l.federationBudgetLater,
        child: careerAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(l.federationCouldNotLoadFinances(e.toString())),
          ),
          data: (career) => career == null
              ? Center(child: Text(l.federationSaveNotFound))
              : _BudgetSetupTabletLayout(
                  state: this,
                  career: career,
                  budget: _budgetFor(career),
                ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        // A way out. The budget is a FORCED event and stays one — the hub
        // presents it again and again until it is actually distributed, since
        // the event clears on the allocation being confirmed and on nothing
        // else. What it must not be is a TRAP: this screen replaces the stack,
        // so with no leading control and no swipe back, a manager who opened
        // it to look at the numbers could not leave without spending the
        // money. Forced and inescapable are different things.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          tooltip: l.federationBudgetLater,
          onPressed: () =>
              context.go('${Routes.hub}?careerId=${widget.careerId}'),
        ),
        title: Text(
          l.federationSetYourBudget,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: careerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.federationCouldNotLoadFinances(e.toString()))),
        data: (career) {
          if (career == null) {
            return Center(child: Text(l.federationSaveNotFound));
          }
          final b = _budgetFor(career);
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  children: [
                    // A bright banner so the season-defining decision can't be
                    // breezed past.
                    _BudgetBanner(available: b.available),
                    const SizedBox(height: AppSpacing.md),
                    StaffCard(
                      key: TourKeys.budgetStaff,
                      careerId: widget.careerId,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppCard(
                      key: TourKeys.budgetDepartments,
                      child: InvestmentEditor(
                        available: b.available,
                        initial: b.alloc,
                        onChanged: _onAllocated,
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
                  child: _confirmBar(l, career, b),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// The bright banner over the budget, so the season-defining decision can't
/// be breezed past.
class _BudgetBanner extends StatelessWidget {
  const _BudgetBanner({required this.available});

  final int available;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: AppRadii.baseAll,
        border: Border.all(color: AppColors.primary, width: 1.5),
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
                l.federationBudgetHeading,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.federationDistributeBudget(formatEuros(available)),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
