import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/records/record_book_providers.dart';
import 'package:fnm/features/records/rivalry_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The nation's all-time record book: leaderboards for caps, goals and assists,
/// plus headline team records. Builds a sense of legacy across endless cycles.
class RecordBookScreen extends ConsumerWidget {
  const RecordBookScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(recordBookProvider(careerId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          l.recordsRecordBook,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.recordsCouldNotLoadRecords(e.toString()))),
        data: (book) {
          if (book == null) {
            return Center(child: Text(l.recordsSaveNotFound));
          }
          final hasData =
              book.mostCaps.isNotEmpty ||
              book.topScorers.isNotEmpty ||
              book.longestUnbeaten > 0;
          if (!hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  l.recordsPlayToWriteHistory(book.nationName),
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          String nation(int id) => book.nations[id]?.name ?? 'Unknown';
          String code(int id) => book.nations[id]?.code ?? '??';
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              LegacyTiles(careerId: careerId),
              const SizedBox(height: AppSpacing.md),
              _RivalryCard(careerId: careerId),
              _TeamRecords(
                bestFinish: book.bestFinish,
                longestUnbeaten: book.longestUnbeaten,
                biggestWin: book.biggestWin == null
                    ? null
                    : l.recordsBiggestWinValue(
                        book.biggestWin!.gf,
                        book.biggestWin!.ga,
                        nation(book.biggestWin!.oppId),
                      ),
                biggestWinCode: book.biggestWin == null
                    ? null
                    : code(book.biggestWin!.oppId),
              ),
              const SizedBox(height: AppSpacing.md),
              _Leaderboard(
                title: l.recordsMostCaps,
                unit: '',
                leaders: book.mostCaps,
                careerId: careerId,
              ),
              const SizedBox(height: AppSpacing.md),
              _Leaderboard(
                title: l.recordsTopScorers,
                unit: l.recordsUnitGoals,
                leaders: book.topScorers,
                careerId: careerId,
              ),
              const SizedBox(height: AppSpacing.md),
              _Leaderboard(
                title: l.recordsMostAssists,
                unit: l.recordsUnitAssists,
                leaders: book.topAssists,
                careerId: careerId,
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

/// The nation's legacy sections, as a grid of tiles.
///
/// They used to be a stack of full-width rows at the top of the record book,
/// reachable only from an unlabelled icon on the team-records screen — so the
/// all-time XI, the world records and the head-to-head archive were the three
/// most interesting screens in the game and also the three hardest to find.
/// Shown as tiles they read as destinations rather than as a menu, and the same
/// grid is used everywhere they are offered.
class LegacyTiles extends StatelessWidget {
  const LegacyTiles({
    required this.careerId,
    this.includeRecordBook = false,
    this.dense = false,
    super.key,
  });

  final int careerId;

  /// Whether to offer the record book itself — set on screens that are not the
  /// record book.
  final bool includeRecordBook;

  /// A single scrolling row of small pills instead of a grid of cards. Used
  /// where the destinations are a way OUT of the screen rather than the point
  /// of it: on the team-records hub the four cards took up half the first
  /// screenful before a single record was visible.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final entries =
        <({IconData icon, String title, String subtitle, VoidCallback onTap})>[
          if (includeRecordBook)
            (
              icon: Icons.auto_stories,
              title: l.recordsRecordBook,
              subtitle: l.recordsRecordBookSubtitle,
              onTap: () => context.push('${Routes.records}?careerId=$careerId'),
            ),
          (
            icon: Icons.workspace_premium,
            title: l.recordsLegends,
            subtitle: l.recordsLegendsSubtitle,
            onTap: () => context.push('${Routes.legends}?careerId=$careerId'),
          ),
          (
            icon: Icons.public,
            title: l.recordsAllTimeWorld,
            subtitle: l.recordsAllTimeWorldSubtitle,
            onTap: () =>
                context.push('${Routes.allTimeRecords}?careerId=$careerId'),
          ),
          (
            icon: Icons.compare_arrows,
            title: l.recordsHeadToHead,
            subtitle: l.recordsHeadToHeadSubtitle,
            onTap: () =>
                context.push('${Routes.headToHead}?careerId=$careerId'),
          ),
        ];

    if (dense) {
      return SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: entries.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
          itemBuilder: (context, i) => _LegacyPill(
            icon: entries[i].icon,
            title: entries[i].title,
            onTap: entries[i].onTap,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Two to a row, and the row's own width decides the tile width — so it
        // holds up on a narrow phone and on a tablet alike.
        const gap = AppSpacing.sm;
        final width = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final e in entries)
              SizedBox(
                width: width,
                child: _LegacyTile(
                  icon: e.icon,
                  title: e.title,
                  subtitle: e.subtitle,
                  onTap: e.onTap,
                ),
              ),
          ],
        );
      },
    );
  }
}

/// The dense form of a legacy destination: an icon and its name, on one line.
class _LegacyPill extends StatelessWidget {
  const _LegacyPill({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerHigh,
      borderRadius: AppRadii.smAll,
      child: InkWell(
        borderRadius: AppRadii.smAll,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 6,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One legacy destination: an icon, what it is, and a word on what's inside.
class _LegacyTile extends StatelessWidget {
  const _LegacyTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: SizedBox(
        height: 96,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: AppColors.primary),
            const Spacer(),
            Text(
              title.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The nation's fiercest rivalry with the head-to-head record — hidden until a
/// genuine rivalry has formed (3+ competitive meetings).
class _RivalryCard extends ConsumerWidget {
  const _RivalryCard({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final r = ref.watch(rivalryProvider(careerId)).valueOrNull;
    if (r == null) return const SizedBox.shrink();
    final record = l.recordsWdl(r.wins, r.draws, r.losses);
    final edge = r.wins > r.losses
        ? l.recordsEdgeUpperHand
        : r.wins < r.losses
        ? l.recordsEdgeTheirNumber
        : l.recordsEdgeEven;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: AppColors.warning,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  l.recordsFiercestRival,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                FlagDisc(r.rival.code, size: 32),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.rival.name, style: AppTypography.titleMedium),
                      Text(
                        l.recordsRivalLine(r.played, record, edge),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${r.goalsFor}–${r.goalsAgainst}',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamRecords extends StatelessWidget {
  const _TeamRecords({
    required this.bestFinish,
    required this.longestUnbeaten,
    required this.biggestWin,
    required this.biggestWinCode,
  });

  final String bestFinish;
  final int longestUnbeaten;
  final String? biggestWin;
  final String? biggestWinCode;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        children: [
          _row(l.recordsBestFinish, bestFinish, null),
          _row(
            l.recordsLongestUnbeaten,
            l.recordsMatchesCount(longestUnbeaten),
            null,
          ),
          if (biggestWin != null)
            _row(l.recordsBiggestWin, biggestWin!, biggestWinCode),
        ],
      ),
    );
  }

  Widget _row(String label, String value, String? code) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Flexible, because a Row hands a plain Text every pixel it asks for
          // and the label is the piece nobody thinks about: "NEJVĚTŠÍ VÍTĚZSTVÍ"
          // is nearly twice "BIGGEST WIN", and a Spacer has nothing to give
          // back once the label has taken the row.
          Flexible(
            child: Text(
              label.toUpperCase(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const Spacer(),
          if (code != null) ...[
            FlagDisc(code, size: 18),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _Leaderboard extends StatelessWidget {
  const _Leaderboard({
    required this.title,
    required this.unit,
    required this.leaders,
    required this.careerId,
  });

  final String title;
  final String unit;
  final List<RecordLeader> leaders;
  final int careerId;

  @override
  Widget build(BuildContext context) {
    if (leaders.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < leaders.length; i++)
                LeaderRow(
                  rank: i + 1,
                  name: leaders[i].name,
                  value: unit.isEmpty
                      ? '${leaders[i].value}'
                      : '${leaders[i].value} $unit',
                  // Still playing: the badge every all-time chart uses.
                  trailing: leaders[i].active ? const ActiveBadge() : null,
                  onTap: () => context.push(
                    '${Routes.player}?careerId=$careerId'
                    '&playerId=${leaders[i].playerId}',
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
