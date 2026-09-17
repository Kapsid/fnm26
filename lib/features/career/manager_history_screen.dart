import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/features/career/manager_history_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// The manager's whole journey: every cycle they've managed (nation, balance,
/// tournament finishes) plus the career totals across all of them.
class ManagerHistoryScreen extends ConsumerWidget {
  const ManagerHistoryScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(managerHistoryProvider(careerId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.careers}?careerId=$careerId'),
        ),
        title: Text(
          l.careerManagerCareerTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.careerCouldNotLoad('$e'))),
        data: (h) {
          if (h == null) return Center(child: Text(l.careerNoCareer));
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              _OverallCard(history: h),
              const SizedBox(height: AppSpacing.md),
              Text(
                l.careerCycleByCycle,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              for (final c in h.cycles) _CycleCard(cycle: c),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

class _OverallCard extends StatelessWidget {
  const _OverallCard({required this.history});

  final ManagerHistory history;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final h = history;
    final gd = h.goalDifference;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(h.managerName, style: AppTypography.headlineMedium),
          Text(
            l.careerCyclesNationsLed(h.cycles.length, h.nationsLed),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Five equal columns, not five natural widths laid side by side.
          // "TITULY ODEHRANÉ VÝHRY REMÍZY PROHRY" is half again as wide as
          // "TITLES PLAYED WON DRAWN LOST", and a spaceBetween Row has no
          // spare space to give back once its children have asked for more
          // than the card holds — so the strip ran off the right of the
          // manager's career screen in Czech.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Stat(
                  label: l.careerStatTitles,
                  value: '${h.titles}',
                  highlight: true,
                ),
              ),
              Expanded(
                child: _Stat(label: l.careerStatPlayed, value: '${h.played}'),
              ),
              Expanded(
                child: _Stat(label: l.careerStatWon, value: '${h.won}'),
              ),
              Expanded(
                child: _Stat(label: l.careerStatDrawn, value: '${h.drawn}'),
              ),
              Expanded(
                child: _Stat(label: l.careerStatLost, value: '${h.lost}'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.careerGoalsWinRate(
              h.goalsFor,
              h.goalsAgainst,
              '${gd >= 0 ? '+' : ''}$gd',
              h.winRate,
            ),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (h.biggestWin != null || h.biggestLoss != null) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),
            Text(
              l.careerRecordResults,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            if (h.biggestWin != null)
              _RecordResult(label: l.careerBestWin, result: h.biggestWin!),
            if (h.biggestLoss != null)
              _RecordResult(label: l.careerWorstDefeat, result: h.biggestLoss!),
          ],
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),
          Text(
            l.careerTrophyCabinet,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _TrophyCabinet(counts: h.trophyCounts),
        ],
      ),
    );
  }
}

/// One record result: the label, the scoreline (manager's team first) and the
/// opponent, plus the month it happened.
///
/// Two lines, and it used to be one. The label sat in a box 82 pixels wide with
/// the scoreline and the opponent laid out beside it — three pieces of text
/// across the width of a phone, none of which knew how long the other two were.
/// "Nejhorší porážka" is half again as long as "Worst defeat", and at any font
/// size above the default the row ran off its card. Nothing here is measured in
/// pixels now: the label and the score share the first line, the opponent has
/// the second to itself, and the row is as tall as it needs to be.
class _RecordResult extends StatelessWidget {
  const _RecordResult({required this.label, required this.result});

  final String label;
  final ManagerResult result;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final win = result.scoreFor > result.scoreAgainst;
    final accent = win ? AppColors.positive : AppColors.error;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${result.code} ${result.scoreFor}–${result.scoreAgainst} '
                '${result.opponentCode}',
                style: AppTypography.bodyMedium.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            l.careerVsOpponentDate(
              result.opponentName,
              DateFormat('MMM yyyy').format(result.date),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Every trophy the game offers, each with the manager's win count — earned
/// ones in full colour, the rest greyed out, so the cabinet shows the full set
/// of goals as well as what's been won.
class _TrophyCabinet extends StatelessWidget {
  const _TrophyCabinet({required this.counts});

  final Map<String, int> counts;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        for (final t in Trophies.cabinet)
          _TrophySlot(
            asset: t.asset,
            // The cabinet holds the competitions' canonical stored names, so
            // they go through the same translator every other competition
            // name does. Printed raw, this was the one shelf in the game
            // still labelled in English.
            label: competitionLabel(AppLocalizations.of(context), t.label),
            count: counts[t.key] ?? 0,
          ),
      ],
    );
  }
}

class _TrophySlot extends StatelessWidget {
  const _TrophySlot({
    required this.asset,
    required this.label,
    required this.count,
  });

  final String asset;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final won = count > 0;
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              () {
                final image = Image.asset(
                  asset,
                  height: 56,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.emoji_events,
                    color: won ? AppColors.primary : AppColors.onSurfaceVariant,
                  ),
                );
                if (won) return image;
                // Unearned: desaturate and dim so the goal is visible but clean.
                return Opacity(
                  opacity: 0.4,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      0.2126, 0.7152, 0.0722, 0, 0, //
                      0.2126, 0.7152, 0.0722, 0, 0, //
                      0.2126, 0.7152, 0.0722, 0, 0, //
                      0, 0, 0, 1, 0,
                    ]),
                    child: image,
                  ),
                );
              }(),
              if (count > 1)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$count',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),
          SizedBox(
            height: 30,
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 9.5,
                height: 1.1,
                color: won ? AppColors.onSurface : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            won ? '×$count' : '—',
            style: AppTypography.labelSmall.copyWith(
              color: won ? AppColors.primary : AppColors.onSurfaceVariant,
              fontWeight: won ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _CycleCard extends StatelessWidget {
  const _CycleCard({required this.cycle});

  final ManagerCycle cycle;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = cycle;
    final gd = c.goalDifference;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FlagDisc(c.nation?.code ?? '??', size: 26),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    c.nation?.name ?? l.careerUnknownNation,
                    style: AppTypography.titleMedium,
                  ),
                ),
                Text(
                  '${c.year}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l.careerCycleRecordLine(
                c.won,
                c.drawn,
                c.lost,
                c.goalsFor,
                c.goalsAgainst,
                '${gd >= 0 ? '+' : ''}$gd',
              ),
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: _Finish(
                    label: l.careerWorldCupLabel,
                    placement: c.worldCup,
                  ),
                ),
                Expanded(
                  child: _Finish(
                    label: l.careerContinentalLabel,
                    placement: c.continental,
                  ),
                ),
              ],
            ),
            if (c.nationsCup.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              _Finish(
                label: l.careerNationsCupLabel,
                placement: c.nationsCup,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Finish extends StatelessWidget {
  const _Finish({required this.label, required this.placement});

  final String label;
  final String placement;

  @override
  Widget build(BuildContext context) {
    final gold = placement == 'Champions';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Row(
          children: [
            if (gold)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.emoji_events,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
            Flexible(
              child: Text(
                placement,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium.copyWith(
                  color: gold ? AppColors.primary : AppColors.onSurface,
                  fontWeight: gold ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WholeText(
          value,
          maxLines: 1,
          // A stat tile, so it is centred under its own heading rather than
          // ranged left like a list row.
          textAlign: TextAlign.center,
          style: AppTypography.titleMedium.copyWith(
            color: highlight ? AppColors.primary : AppColors.onSurface,
          ),
        ),
        // Scales into its fifth of the card rather than demanding the width a
        // long word wants — see [WholeText].
        WholeText(
          label.toUpperCase(),
          maxLines: 1,
          textAlign: TextAlign.center,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
