import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

typedef _RolloverView = ({
  Honour? worldCup,
  Map<int, Nation> nations,
  int nextYear,
  int budget,
});

final AutoDisposeFutureProviderFamily<_RolloverView?, int> _rolloverProvider =
    FutureProvider.autoDispose.family<_RolloverView?, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final honours =
      await ref.watch(competitionRepositoryProvider).honours(careerId);
  final wc = honours
      .where((h) => h.competition == 'World Championship')
      .toList()
    ..sort((a, b) => b.year.compareTo(a.year));
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  return (
    worldCup: wc.isEmpty ? null : wc.first,
    nations: nations,
    nextYear: SeasonService.finalsYear(career.cyclePointer + 1),
    budget: career.budget,
  );
});

/// The end-of-cycle event: crowns the World Cup winner, delivers the board's
/// verdict (with job offers or the sack), then rolls into the next cycle.
class CycleRolloverScreen extends ConsumerStatefulWidget {
  const CycleRolloverScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<CycleRolloverScreen> createState() =>
      _CycleRolloverScreenState();
}

class _CycleRolloverScreenState extends ConsumerState<CycleRolloverScreen> {
  int _step = 0; // 0 = champion, 1 = board verdict & offers, 2 = income
  int? _selected; // chosen offer nation id (null = stay)
  bool _busy = false;

  Future<void> _begin(RolloverVerdict? v) async {
    if (_busy) return;
    setState(() => _busy = true);
    // The rollover banks the finished cycle's income and advances; the new
    // cycle's budget is allocated in the forced budget-setup event that opens
    // it (see nextEventProvider).
    await ref.read(seasonServiceProvider).startNextCycle(
          widget.careerId,
          switchToNationId: _selected,
          boardTitle: v?.headline,
          boardBody: v?.detail,
        );
    if (mounted) {
      ref
        ..invalidate(messageInboxProvider(widget.careerId))
        ..invalidate(unreadMessagesProvider(widget.careerId));
      context.go('${Routes.hub}?careerId=${widget.careerId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewAsync = ref.watch(_rolloverProvider(widget.careerId));
    return Scaffold(
      body: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load.\n$e')),
        data: (view) => switch (_step) {
          0 => _championStep(view),
          1 => _boardStep(view),
          _ => _investStep(view),
        },
      ),
    );
  }

  Widget _championStep(_RolloverView? view) {
    final wc = view?.worldCup;
    String name(int id) => view?.nations[id]?.name ?? '—';
    String code(int id) => view?.nations[id]?.code ?? '??';
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.emoji_events, color: AppColors.primary, size: 64),
            const SizedBox(height: AppSpacing.md),
            if (wc != null) ...[
              Text(
                '${wc.year} WORLD CHAMPIONS',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlagDisc(code(wc.championId), size: 40, highlighted: true),
                  const SizedBox(width: AppSpacing.md),
                  Flexible(
                    child: Text(
                      name(wc.championId),
                      style: AppTypography.headlineLargeMobile,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _SummaryCard(wc: wc, name: name),
            ] else
              const Text(
                'The cycle is complete.',
                style: AppTypography.headlineMedium,
              ),
            const Spacer(),
            PrimaryButton(
              label: 'Continue',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => setState(() => _step = 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boardStep(_RolloverView? view) {
    final verdictAsync = ref.watch(rolloverVerdictProvider(widget.careerId));
    return SafeArea(
      child: verdictAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load.\n$e')),
        data: (v) {
          if (v == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: PrimaryButton(
                  label: 'Continue',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => setState(() => _step = 2),
                ),
              ),
            );
          }
          final canStay = !v.sacked;
          final ready = _selected != null || canStay;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  children: [
                    _VerdictCard(verdict: v),
                    const SizedBox(height: AppSpacing.md),
                    if (canStay && v.currentNation != null) ...[
                      Text(
                        'YOUR JOB',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      _OfferTile(
                        nation: v.currentNation!,
                        subtitle: 'Stay and continue your project',
                        selected: _selected == null,
                        onTap: () => setState(() => _selected = null),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    Text(
                      v.sacked ? 'CHOOSE YOUR NEXT JOB' : 'OFFERS ON THE TABLE',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    for (final o in v.offers)
                      _OfferTile(
                        nation: o.nation,
                        subtitle: '${o.tier} · world #${o.position}',
                        selected: _selected == o.nation.id,
                        onTap: () => setState(() => _selected = o.nation.id),
                      ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: PrimaryButton(
                    label: _selected == null
                        ? 'Continue with '
                            '${v.currentNation?.name ?? 'your nation'}'
                        : 'Take the job',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: !ready ? null : () => setState(() => _step = 2),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// The invest step: bank the cycle's income, then roll into the next cycle —
  /// where setting the federation budget is the forced first event.
  Widget _investStep(_RolloverView? view) {
    final incomeAsync = ref.watch(cycleIncomeProvider(widget.careerId));
    final verdict =
        ref.watch(rolloverVerdictProvider(widget.careerId)).valueOrNull;
    return SafeArea(
      child: incomeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load finances.\n$e')),
        data: (income) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  children: [
                    Text('FEDERATION FINANCES',
                        style: AppTypography.labelMedium
                            .copyWith(color: AppColors.primary)),
                    const SizedBox(height: AppSpacing.sm),
                    _IncomeCard(
                      income: income,
                      openingBalance: view?.budget ?? 0,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Your first job next cycle is to set the federation '
                      'budget — you’ll distribute this war chest across the '
                      'departments before anything else.',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: PrimaryButton(
                    label: _busy ? 'Starting…' : 'Begin next cycle',
                    icon: Icons.skip_next_rounded,
                    onPressed:
                        _busy ? null : () => unawaited(_begin(verdict)),
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

/// A breakdown of the income banked at a cycle's close.
class _IncomeCard extends StatelessWidget {
  const _IncomeCard({required this.income, required this.openingBalance});

  final IncomeBreakdown income;
  final int openingBalance;

  @override
  Widget build(BuildContext context) {
    final earned = income.grant + income.prize + income.commercial;
    return AppCard(
      child: Column(
        children: [
          _row('Opening balance', openingBalance),
          _row('Central funding', income.grant),
          _row('Prize money', income.prize),
          if (income.commercial > 0)
            _row('Commercial return', income.commercial),
          const Divider(),
          _row('Available to invest', openingBalance + earned, bold: true),
        ],
      ),
    );
  }

  Widget _row(String label, int euros, {bool bold = false}) {
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
          Text(
            formatEuros(euros),
            style: bold
                ? AppTypography.labelMedium.copyWith(color: AppColors.primary)
                : AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// The board's verdict on the cycle, with a form-rating bar.
class _VerdictCard extends StatelessWidget {
  const _VerdictCard({required this.verdict});

  final RolloverVerdict verdict;

  @override
  Widget build(BuildContext context) {
    final p = verdict.performance;
    final color = verdict.sacked
        ? AppColors.error
        : p >= 55
            ? AppColors.positive
            : AppColors.warning;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                verdict.sacked ? Icons.gavel : Icons.business_center,
                color: color,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(verdict.headline, style: AppTypography.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            verdict.detail,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: LinearProgressIndicator(
              value: (p / 100).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AppColors.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(
                Icons.emoji_events_outlined,
                size: 16,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Reputation: ${verdict.reputationLabel} '
                '(${verdict.reputation})',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              if (verdict.nationalHero) ...[
                const Spacer(),
                const Icon(
                  Icons.shield_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'National hero',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// A selectable job (current nation or an offer).
class _OfferTile extends StatelessWidget {
  const _OfferTile({
    required this.nation,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final Nation nation;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: onTap,
        color: selected ? AppColors.secondaryContainer : null,
        child: Row(
          children: [
            FlagDisc(nation.code, size: 30, highlighted: selected),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nation.name, style: AppTypography.titleMedium),
                  Text(
                    subtitle,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.wc, required this.name});

  final Honour wc;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    final score = (wc.finalHomeScore != null && wc.finalAwayScore != null)
        ? (wc.finalHomeScore == wc.finalAwayScore
            ? '${wc.finalHomeScore}–${wc.finalAwayScore} (pens)'
            : '${wc.finalHomeScore}–${wc.finalAwayScore}')
        : null;
    return AppCard(
      child: Column(
        children: [
          _row('Final', '${name(wc.championId)} $score ${name(wc.runnerUpId)}'),
          if (wc.hostId != null)
            _row('Host', name(wc.hostId!)),
          if (wc.topScorerName != null)
            _row(
              'Golden Boot',
              '${wc.topScorerName} · ${wc.topScorerGoals} goals',
            ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
