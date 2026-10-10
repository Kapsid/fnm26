import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/util/squad_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/federation/investment_editor.dart'
    show formatEuros;
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Five bars, [tier] of them lit: a nation's strength out of five.
class StrengthMeter extends StatelessWidget {
  const StrengthMeter({required this.tier, this.barHeight = 10, super.key});

  final int tier;
  final double barHeight;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Semantics(
      label: '${l.nationsStrength} ${l.nationsStrengthOf(tier)}',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 1; i <= 5; i++) ...[
              if (i > 1) const SizedBox(width: 2),
              Container(
                width: 4,
                height: barHeight,
                decoration: BoxDecoration(
                  color: i <= tier
                      ? AppColors.primary
                      : AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Everything a manager can know about [nation] before taking it on, and
/// nothing he could not: its flag and confederation, its world rank, its
/// strength and squad overall, the budget a save opens with, its best player
/// (position, age and rating; never a name, see [NationStrength]) and what
/// the board will demand in the first cycle (see [openingObjectiveTargets]).
/// The tablet's nation pick, new game and out-of-work offers all show it.
///
/// A column at its natural height; give it a scroll view when it may not fit.
/// The strengths load once for the whole world; until they have, the facts
/// they feed are blank rather than a spinner.
class NationPreview extends ConsumerWidget {
  const NationPreview({required this.nation, this.caption, super.key});

  static const Key factsKey = Key('nationPreview.facts');
  static const Key rankKey = Key('nationPreview.rank');
  static const Key strengthKey = Key('nationPreview.strength');
  static const Key overallKey = Key('nationPreview.overall');
  static const Key budgetKey = Key('nationPreview.budget');
  static const Key bestKey = Key('nationPreview.best');
  static const Key briefKey = Key('nationPreview.brief');

  final Nation nation;

  /// A line under the confederation (the out-of-work offers' "141 of 209 in
  /// the world").
  final String? caption;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final nations = ref.watch(nationsProvider).valueOrNull ?? const <Nation>[];
    final strength = ref.watch(nationStrengthsProvider).valueOrNull?[nation.id];
    final targets = nations.isEmpty
        ? null
        : openingObjectiveTargets(nation, nations);
    // Looked up by the nation's OWN confederation, never "the" continental cup.
    final cup = ContinentalCups.byConfederation[nation.confederation];
    final continental = targets?.continental;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            FlagDisc(nation.code, size: 76),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nation.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    confederationLabel(l, nation.confederation).toUpperCase(),
                    style: TabletText.sectionLabel,
                  ),
                  if (caption case final line?) ...[
                    const SizedBox(height: 2),
                    Text(
                      line,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ClipRRect(
          key: factsKey,
          borderRadius: AppRadii.baseAll,
          child: ColoredBox(
            color: AppColors.surfaceContainerHigh,
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _Fact(
                          key: rankKey,
                          label: l.hubWorldRankLabel,
                          value: '#${nation.ranking}',
                        ),
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: _Fact(
                          key: strengthKey,
                          label: l.nationsStrength,
                          value: strength == null
                              ? ''
                              : l.nationsStrengthOf(strength.tier),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Row(
                    children: [
                      Expanded(
                        child: _Fact(
                          key: overallKey,
                          label: l.nationsSquadOverall,
                          value: strength == null ? '' : '${strength.overall}',
                        ),
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: _Fact(
                          key: budgetKey,
                          label: l.nationsOpeningBudget,
                          value: formatEuros(
                            FederationFinance.initialBudget(nation.ranking),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (strength != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l.nationsStarPlayer.toUpperCase(),
            style: TabletText.sectionLabel,
          ),
          const SizedBox(height: 6),
          _BestPlayer(key: bestKey, player: strength.best),
        ],
        if (targets != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l.nationsBoardExpects.toUpperCase(),
            style: TabletText.sectionLabel,
          ),
          const SizedBox(height: 6),
          Column(
            key: briefKey,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Brief(
                competition: l.objectiveWorldCup,
                demand: objectiveDemandText(
                  l,
                  TournamentTier.world,
                  targets.world,
                ),
              ),
              if (cup != null && continental != null)
                _Brief(
                  competition: competitionLabel(l, cup.name),
                  demand: objectiveDemandText(
                    l,
                    TournamentTier.continental,
                    continental,
                    competition: cup.name,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// One cell of the facts grid: a small label over a number.
class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainer,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TabletText.sectionLabel,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.titleMedium.copyWith(
              fontFamily: AppFonts.mono,
            ),
          ),
        ],
      ),
    );
  }
}

/// The nation's best player: position, age and rating.
class _BestPlayer extends StatelessWidget {
  const _BestPlayer({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: AppRadii.baseAll,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: AppRadii.smAll,
            ),
            child: Text(
              player.position.label,
              style: TabletText.cellNumeric.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  positionName(l, player.position),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMedium,
                ),
                Text(
                  l.nationsStarAge(player.age),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${player.overall}',
            style: AppTypography.headlineMedium.copyWith(
              fontFamily: AppFonts.mono,
              color: AppColors.medalGold,
            ),
          ),
        ],
      ),
    );
  }
}

/// One of the board's first demands: the competition over what it asks.
class _Brief extends StatelessWidget {
  const _Brief({required this.competition, required this.demand});

  final String competition;
  final String demand;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            competition,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(demand, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
