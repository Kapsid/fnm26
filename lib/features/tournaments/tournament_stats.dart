import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart'
    show AllTimeScorer, CupPlayerRecord;
import 'package:fnm/features/tournaments/tournament_history.dart'
    show TournamentSoon;
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// A cup's all-time records: the nation honours (most titles, most finals
/// reached, biggest final win) as headline cards, then a tabbed top-ten
/// leaderboard of the players — most games, most cups (editions) played, and
/// top scorers.
class TournamentStatsTab extends StatelessWidget {
  const TournamentStatsTab({
    required this.honours,
    required this.allTimeScorers,
    required this.code,
    required this.name,
    this.topGames = const [],
    this.topCups = const [],
    this.highlightNations = const {},
    super.key,
  });

  final List<Honour> honours;
  final List<AllTimeScorer> allTimeScorers;
  final String Function(int) code;
  final String Function(int) name;

  /// All-time player leaderboards, most first: matches played, and cup editions
  /// attended.
  final List<CupPlayerRecord> topGames;
  final List<CupPlayerRecord> topCups;

  /// The nations the manager has led (current and past) — their players are
  /// highlighted in the leaderboards, so "my" record-holders stand out.
  final Set<int> highlightNations;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (honours.isEmpty && allTimeScorers.isEmpty && topGames.isEmpty) {
      return TournamentSoon(message: l.tourSharedStatsEmpty);
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

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        // Nation honours — the headline records.
        if (topTitles != null)
          _RecordCard(
            icon: Icons.emoji_events_rounded,
            label: l.tourSharedMostTitles,
            headline: name(topTitles.$1),
            code: code(topTitles.$1),
            detail: l.tourStatsTitles(topTitles.$2),
          ),
        if (topFinals != null)
          _RecordCard(
            icon: Icons.workspace_premium_rounded,
            label: l.tourSharedMostFinals,
            headline: name(topFinals.$1),
            code: code(topFinals.$1),
            detail: l.tourStatsFinalsContested(topFinals.$2),
          ),
        if (bigFinal != null)
          _RecordCard(
            icon: Icons.whatshot_rounded,
            label: l.tourSharedBiggestFinalWin,
            headline:
                '${name(bigFinal.championId)} '
                '${_winScore(bigFinal)}',
            code: code(bigFinal.championId),
            detail:
                '${l.recordsVs} ${name(bigFinal.runnerUpId)} · '
                '${bigFinal.year}',
          ),
        // Player leaderboards. Games and scorers show from the first edition;
        // "cups played" only tells a story once there are at least two editions
        // (before that, everyone has played exactly one).
        _Leaderboard(
          topGames: topGames,
          topCups: topCups,
          scorers: allTimeScorers,
          editions: honours.length,
          code: code,
          highlightNations: highlightNations,
        ),
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

/// One row of a leaderboard: a nation (for the flag), a holder name, a count,
/// and whether the holder is still playing — an all-time chart otherwise reads
/// the same whether a man retired last cycle or is in this week's squad. All
/// three boards carry it: they sit behind one switch, and a badge on one
/// segment only would read as a bug rather than as a fact about that board.
typedef _LbRow = ({int nationId, String name, int count, bool active});

/// The all-time player leaderboard: a segmented switch between Games, Cups and
/// Scorers, each a top-ten table. The Cups board is offered only from the
/// second edition on. Renders nothing when there's no player data at all.
class _Leaderboard extends StatefulWidget {
  const _Leaderboard({
    required this.topGames,
    required this.topCups,
    required this.scorers,
    required this.editions,
    required this.code,
    required this.highlightNations,
  });

  final List<CupPlayerRecord> topGames;
  final List<CupPlayerRecord> topCups;
  final List<AllTimeScorer> scorers;
  final int editions;
  final String Function(int) code;
  final Set<int> highlightNations;

  @override
  State<_Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<_Leaderboard> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final boards = <({String label, List<_LbRow> rows})>[
      if (widget.topGames.isNotEmpty)
        (
          label: l.tourStatsTabGames,
          rows: [
            for (final r in widget.topGames)
              (
                nationId: r.nationId,
                name: r.name,
                count: r.count,
                active: r.active,
              ),
          ],
        ),
      // "Cups played" is meaningless in edition one (everyone's on one), so it
      // only appears from the second edition.
      if (widget.editions >= 2 && widget.topCups.isNotEmpty)
        (
          label: l.tourStatsTabCups,
          rows: [
            for (final r in widget.topCups)
              (
                nationId: r.nationId,
                name: r.name,
                count: r.count,
                active: r.active,
              ),
          ],
        ),
      if (widget.scorers.isNotEmpty)
        (
          label: l.tourStatsTabScorers,
          rows: [
            for (final s in widget.scorers.take(10))
              (
                nationId: s.nationId,
                name: s.name,
                count: s.goals,
                active: s.active,
              ),
          ],
        ),
    ];
    if (boards.isEmpty) return const SizedBox.shrink();
    final tab = _tab.clamp(0, boards.length - 1);
    final rows = boards[tab].rows;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.sm),
        Text(
          l.tourStatsLeaders,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (boards.length > 1)
          SegmentedButton<int>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
            segments: [
              for (var i = 0; i < boards.length; i++)
                ButtonSegment(value: i, label: Text(boards[i].label)),
            ],
            selected: {tab},
            onSelectionChanged: (s) => setState(() => _tab = s.first),
          ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++)
                LeaderRow(
                  rank: i + 1,
                  name: rows[i].name,
                  flagCode: widget.code(rows[i].nationId),
                  value: '${rows[i].count}',
                  // Still playing: the same badge every all-time list uses.
                  trailing: rows[i].active ? const ActiveBadge() : null,
                  // A player of one of the manager's nations, now or in the
                  // past, so his own records stand out of a world chart.
                  highlighted: widget.highlightNations.contains(
                    rows[i].nationId,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
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
