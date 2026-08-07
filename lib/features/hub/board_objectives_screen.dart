import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The board's expectations for the cycle, in full.
///
/// They used to be listed on the hub's board strip, where a two-line objective
/// ("African Cup of Nations: Reach the quarter-finals") had to be squeezed onto
/// one ellipsised row next to everything else. The hub now shows only the
/// confidence figure and a way in here, where each objective has the room to
/// state the competition, the target and how it was graded.
class BoardObjectivesScreen extends ConsumerWidget {
  const BoardObjectivesScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final value = ref.watch(satisfactionProvider(careerId)).valueOrNull;
    // Held as the AsyncValue rather than `.valueOrNull ?? []`: an objective
    // that failed to load is not an objective that doesn't exist, and reading
    // both as "empty" made a broken screen indistinguishable from a board with
    // nothing to say.
    final objectivesAsync = ref.watch(cycleObjectivesProvider(careerId));
    final objectives = objectivesAsync.valueOrNull ?? const <CycleObjective>[];
    final (color, verdict) = boardVerdict(l, value);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(l.boardObjectivesTitle, style: AppTypography.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          AppCard(
            child: Row(
              children: [
                Icon(Icons.gavel, color: color, size: 26),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.boardObjectivesConfidence,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        verdict,
                        style: AppTypography.titleMedium.copyWith(color: color),
                      ),
                    ],
                  ),
                ),
                Text(
                  value == null ? '—' : '$value%',
                  style: AppTypography.headlineMedium.copyWith(color: color),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (objectives.isEmpty)
            AppCard(
              child: switch (objectivesAsync) {
                AsyncLoading() => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: CircularProgressIndicator(),
                  ),
                ),
                AsyncError(:final error) => Text(
                  '$error',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
                _ => Text(
                  l.boardObjectivesEmpty,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              },
            )
          else
            for (final objective in objectives) ...[
              _ObjectiveCard(objective: objective),
              const SizedBox(height: AppSpacing.md),
            ],
        ],
      ),
    );
  }
}

/// The board's mood as a colour and a verdict, from a satisfaction percentage.
/// Shared with the hub strip so both read the same at a glance.
(Color, String) boardVerdict(AppLocalizations l, int? value) => switch (value) {
  null => (AppColors.onSurfaceVariant, '—'),
  >= 75 => (AppColors.positive, l.hubBoardDelighted),
  >= 55 => (AppColors.positive, l.hubBoardPleased),
  >= 40 => (AppColors.warning, l.hubBoardExpectingMore),
  >= 25 => (AppColors.warning, l.hubBoardConcerned),
  _ => (AppColors.error, l.hubBoardJobAtRisk),
};

class _ObjectiveCard extends StatelessWidget {
  const _ObjectiveCard({required this.objective});

  final CycleObjective objective;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final decided = objective.decided;
    final met = objective.met;
    final color = !decided
        ? AppColors.onSurfaceVariant
        : (met ? AppColors.positive : AppColors.error);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag_outlined, size: 18, color: color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  objective.competition,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(objective.label, style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppRadii.smAll,
            ),
            child: Text(
              // An objective can only be GRADED when its tournament is over,
              // but a brief that says nothing at all until then reads as one
              // that is never judged. While it's live, say how far the run has
              // got — the manager can see themselves closing on it.
              // Ordinals below 2 are not progress — they are "out of it" and
              // "bottom of the group", which read as an achievement if shown
              // as how far the run has got.
              !decided
                  ? (objective.actual >= 2
                        ? l.boardObjectiveSoFar(objective.resultLabel)
                        : l.boardObjectivesPending)
                  : met
                  ? l.hubObjectiveMet(objective.resultLabel)
                  : l.hubObjectiveMissed(objective.resultLabel),
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
