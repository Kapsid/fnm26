import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart' show AllTimeScorer;
import 'package:fnm/features/tournaments/tournament_history.dart' show TournamentSoon;
import 'package:fnm/shared/widgets/widgets.dart';

/// A cup's all-time historical records, built from its full roll of honour and
/// its all-time scorer chart: the record scorer, the most-decorated nations, the
/// most frequent finalists, and the biggest win in a final. (More player records
/// — caps, goals in a single match, a nation's biggest haul in one edition —
/// will be layered on as the stat store grows.)
class TournamentStatsTab extends StatelessWidget {
  const TournamentStatsTab({
    required this.honours,
    required this.allTimeScorers,
    required this.code,
    required this.name,
    super.key,
  });

  final List<Honour> honours;
  final List<AllTimeScorer> allTimeScorers;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    if (honours.isEmpty && allTimeScorers.isEmpty) {
      return const TournamentSoon(
        message: 'Records appear once the competition has some history.',
      );
    }

    // Most titles, and most finals reached (champion or runner-up), by nation.
    final titles = <int, int>{};
    final finals = <int, int>{};
    for (final h in honours) {
      titles.update(h.championId, (v) => v + 1, ifAbsent: () => 1);
      finals
        ..update(h.championId, (v) => v + 1, ifAbsent: () => 1)
        ..update(h.runnerUpId, (v) => v + 1, ifAbsent: () => 1);
    }
    final topTitles = _top(titles);
    final topFinals = _top(finals);

    // The biggest winning margin in a final on record.
    Honour? bigFinal;
    var bigMargin = -1;
    for (final h in honours) {
      final a = h.finalHomeScore;
      final b = h.finalAwayScore;
      if (a == null || b == null) continue;
      final m = (a - b).abs();
      if (m > bigMargin) {
        bigMargin = m;
        bigFinal = h;
      }
    }

    final topScorer = allTimeScorers.isEmpty ? null : allTimeScorers.first;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        if (topScorer != null)
          _RecordCard(
            icon: Icons.sports_soccer_rounded,
            label: 'RECORD SCORER',
            headline: topScorer.name,
            code: code(topScorer.nationId),
            detail: '${topScorer.goals} goals · ${name(topScorer.nationId)}'
                '${topScorer.active ? ' · still active' : ''}',
          ),
        if (topTitles != null)
          _RecordCard(
            icon: Icons.emoji_events_rounded,
            label: 'MOST TITLES',
            headline: name(topTitles.$1),
            code: code(topTitles.$1),
            detail: '${topTitles.$2} '
                '${topTitles.$2 == 1 ? 'title' : 'titles'}',
          ),
        if (topFinals != null)
          _RecordCard(
            icon: Icons.workspace_premium_rounded,
            label: 'MOST FINALS',
            headline: name(topFinals.$1),
            code: code(topFinals.$1),
            detail: '${topFinals.$2} '
                '${topFinals.$2 == 1 ? 'final' : 'finals'} contested',
          ),
        if (bigFinal != null)
          _RecordCard(
            icon: Icons.whatshot_rounded,
            label: 'BIGGEST FINAL WIN',
            headline: '${name(bigFinal.championId)} '
                '${_winScore(bigFinal)}',
            code: code(bigFinal.championId),
            detail: 'v ${name(bigFinal.runnerUpId)} · ${bigFinal.year}',
          ),
        if (allTimeScorers.length > 1) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            'ALL-TIME SCORERS',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            child: Column(
              children: [
                for (final s in allTimeScorers.take(10))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        FlagDisc(code(s.nationId), size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            s.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall,
                          ),
                        ),
                        Text(
                          '${s.goals}',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  /// The winner's score first in a final's scoreline.
  String _winScore(Honour h) {
    final a = h.finalHomeScore!;
    final b = h.finalAwayScore!;
    final hi = a >= b ? a : b;
    final lo = a >= b ? b : a;
    return '$hi–$lo';
  }

  /// The highest-count entry of a nation→count tally, or null when empty.
  (int, int)? _top(Map<int, int> tally) {
    if (tally.isEmpty) return null;
    var bestId = -1;
    var best = -1;
    tally.forEach((id, n) {
      if (n > best) {
        best = n;
        bestId = id;
      }
    });
    return (bestId, best);
  }
}

/// A single headline record card: an icon, the record label, the holder and a
/// one-line detail.
class _RecordCard extends StatelessWidget {
  const _RecordCard({
    required this.icon,
    required this.label,
    required this.headline,
    required this.code,
    required this.detail,
  });

  final IconData icon;
  final String label;
  final String headline;
  final String code;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(headline, style: AppTypography.titleMedium),
                  Text(
                    detail,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            FlagDisc(code, size: 24),
          ],
        ),
      ),
    );
  }
}
