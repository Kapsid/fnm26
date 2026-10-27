import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'board_objectives_tablet_layout.dart';

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

  static const Key tabletLayoutKey = Key('boardObjectives.tabletLayout');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (TabletShellScope.isActive(context)) {
      return _BoardObjectivesTabletLayout(careerId: careerId);
    }
    final l = AppLocalizations.of(context);
    final value = ref.watch(satisfactionProvider(careerId)).valueOrNull;
    // Held as the AsyncValue rather than `.valueOrNull ?? []`: an objective
    // that failed to load is not an objective that doesn't exist, and reading
    // both as "empty" made a broken screen indistinguishable from a board with
    // nothing to say.
    final objectivesAsync = ref.watch(cycleObjectivesProvider(careerId));
    final objectives = objectivesAsync.valueOrNull ?? const <CycleObjective>[];
    final gaps =
        ref.watch(cycleObjectiveGapsProvider(careerId)).valueOrNull ??
        const <ObjectiveGap>[];

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
          AppCard(child: _ConfidenceRow(value: value)),
          const SizedBox(height: AppSpacing.md),
          if (objectives.isEmpty && gaps.isEmpty)
            AppCard(
              child: _ObjectivesState(async: objectivesAsync),
            )
          else
            for (final row in objectiveRows(objectives, gaps)) ...[
              AppCard(
                child: switch (row) {
                  (objective: final o?, gap: _) => _ObjectiveBody(objective: o),
                  (objective: _, gap: final g?) => ObjectiveGapBody(gap: g),
                  _ => const SizedBox.shrink(),
                },
              ),
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

/// The colour an objective's status is written in: grey while it is still
/// open, green once met, gold once beaten outright, red missed. Beating a
/// brief by rounds is its own colour: a cycle carried three rounds past what
/// was asked should not look like one that scraped it.
///
/// A finals brief already reached while the tournament is still running is
/// answered (the board credits it then, see [BoardSatisfaction.lockedIn]), so
/// it reads green or gold too rather than the grey of an open one.
Color objectiveStatusColor(CycleObjective o) {
  final gap = o.actual - o.target;
  final answered = o.decided
      ? o.met
      : BoardSatisfaction.lockedIn((
          tier: o.tier,
          target: o.target,
          actual: o.actual,
        ));
  if (!answered) {
    return o.decided ? AppColors.error : AppColors.onSurfaceVariant;
  }
  return gap > 0 ? AppColors.medalGold : AppColors.positive;
}

/// An objective's status line: how far the run has got while it is live,
/// and once graded, by how much it was met, beaten or missed.
String objectiveStatusLabel(AppLocalizations l, CycleObjective o) => !o.decided
    ? (o.actual >= 2
          ? l.boardObjectiveSoFar(o.resultLabel)
          : l.boardObjectivesPending)
    : switch (o.actual - o.target) {
        0 => l.hubObjectiveMet(o.resultLabel),
        final gap when gap > 0 => l.boardObjectiveBeatenBy(o.resultLabel, gap),
        final gap => l.boardObjectiveShortBy(o.resultLabel, -gap),
      };

/// The board's confidence: the gavel, the verdict and the figure, in the
/// verdict's colour.
class _ConfidenceRow extends StatelessWidget {
  const _ConfidenceRow({required this.value});

  final int? value;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (color, verdict) = boardVerdict(l, value);
    return Row(
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
    );
  }
}

/// What stands in for the objectives when there are none to list: still
/// loading, failed (said, not hidden), or a board with nothing to ask.
class _ObjectivesState extends StatelessWidget {
  const _ObjectivesState({required this.async});

  final AsyncValue<List<CycleObjective>> async;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return switch (async) {
      AsyncLoading() => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: CircularProgressIndicator(),
        ),
      ),
      AsyncError(:final error) => Text(
        '$error',
        style: AppTypography.bodySmall.copyWith(color: AppColors.error),
      ),
      _ => Text(
        l.boardObjectivesEmpty,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    };
  }
}

/// One objective: its competition (unless a panel header already names it),
/// what the board asks, and how the run is going or how it was graded.
class _ObjectiveBody extends StatelessWidget {
  const _ObjectiveBody({required this.objective, this.showCompetition = true});

  final CycleObjective objective;

  /// False inside a tablet panel, whose header is the competition.
  final bool showCompetition;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final color = objectiveStatusColor(objective);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showCompetition) ...[
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
        ],
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
            // Once graded, say by HOW MUCH. Met/missed alone read the same
            // whether a side scraped the brief or was carried three rounds
            // past it, and the two are not the same cycle.
            objectiveStatusLabel(l, objective),
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

/// The objectives and the competitions without one, in the board's order:
/// the continental championship, the Nations Cup, the World Championship.
/// Exactly one of each row's fields is set.
List<({CycleObjective? objective, ObjectiveGap? gap})> objectiveRows(
  List<CycleObjective> objectives,
  List<ObjectiveGap> gaps,
) {
  int order(TournamentTier t) => switch (t) {
    TournamentTier.continental => 0,
    TournamentTier.nationsCup => 1,
    TournamentTier.world => 2,
    TournamentTier.clash => 3,
  };
  final rows = <({CycleObjective? objective, ObjectiveGap? gap})>[
    for (final o in objectives) (objective: o, gap: null),
    for (final g in gaps) (objective: null, gap: g),
  ];
  // A stable sort: two rows of one tier keep the order they came in.
  final indexed = rows.indexed.toList()
    ..sort((a, b) {
      final ta = (a.$2.objective?.tier ?? a.$2.gap!.tier);
      final tb = (b.$2.objective?.tier ?? b.$2.gap!.tier);
      final byTier = order(ta).compareTo(order(tb));
      return byTier != 0 ? byTier : a.$1.compareTo(b.$1);
    });
  return [for (final r in indexed) r.$2];
}

/// A competition the board set no objective for: its name (unless a tablet
/// panel header already says it), that there is no target, and why.
class ObjectiveGapBody extends StatelessWidget {
  const ObjectiveGapBody({
    required this.gap,
    this.showCompetition = true,
    super.key,
  });

  final ObjectiveGap gap;

  /// False inside a tablet panel, whose header is the competition.
  final bool showCompetition;

  static Key keyFor(TournamentTier tier) => Key('boardObjectives.gap.$tier');

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final awaiting = gap.reason == ObjectiveGapReason.awaitingDraw;
    return Column(
      key: keyFor(gap.tier),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showCompetition) ...[
          Row(
            children: [
              const Icon(
                Icons.flag_outlined,
                size: 18,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  gap.competition,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        Text(
          awaiting ? l.boardObjectiveAwaitingDraw : l.boardObjectiveNoBrief,
          style: AppTypography.titleMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          awaiting
              ? l.boardObjectiveAwaitingDrawBody
              : l.boardObjectiveNoBriefBody,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
