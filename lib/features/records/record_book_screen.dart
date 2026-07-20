import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/records/record_book_providers.dart';
import 'package:fnm/features/records/rivalry_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The nation's all-time record book: leaderboards for caps, goals and assists,
/// plus headline team records. Builds a sense of legacy across endless cycles.
class RecordBookScreen extends ConsumerWidget {
  const RecordBookScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          'RECORD BOOK',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load records.\n$e')),
        data: (book) {
          if (book == null) {
            return const Center(child: Text('Save not found.'));
          }
          final hasData = book.mostCaps.isNotEmpty ||
              book.topScorers.isNotEmpty ||
              book.longestUnbeaten > 0;
          if (!hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'Play some matches to start writing '
                  '${book.nationName}’s history.',
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
              _LegendsLink(careerId: careerId),
              const SizedBox(height: AppSpacing.sm),
              _NavLink(
                icon: Icons.public,
                title: 'ALL-TIME WORLD',
                subtitle: 'Global scorers & most-capped, every nation',
                onTap: () => context
                    .push('${Routes.allTimeRecords}?careerId=$careerId'),
              ),
              const SizedBox(height: AppSpacing.sm),
              _NavLink(
                icon: Icons.compare_arrows,
                title: 'HEAD TO HEAD',
                subtitle: 'Compare any two nations’ all-time record',
                onTap: () =>
                    context.push('${Routes.headToHead}?careerId=$careerId'),
              ),
              const SizedBox(height: AppSpacing.md),
              _RivalryCard(careerId: careerId),
              _TeamRecords(
                bestFinish: book.bestFinish,
                longestUnbeaten: book.longestUnbeaten,
                biggestWin: book.biggestWin == null
                    ? null
                    : '${book.biggestWin!.gf}–${book.biggestWin!.ga} '
                        'v ${nation(book.biggestWin!.oppId)}',
                biggestWinCode: book.biggestWin == null
                    ? null
                    : code(book.biggestWin!.oppId),
              ),
              const SizedBox(height: AppSpacing.md),
              _Leaderboard(
                title: 'MOST CAPS',
                unit: '',
                leaders: book.mostCaps,
                careerId: careerId,
              ),
              const SizedBox(height: AppSpacing.md),
              _Leaderboard(
                title: 'TOP SCORERS',
                unit: 'goals',
                leaders: book.topScorers,
                careerId: careerId,
              ),
              const SizedBox(height: AppSpacing.md),
              _Leaderboard(
                title: 'MOST ASSISTS',
                unit: 'assists',
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

/// A tappable banner into the Legends screen (all-time XI + hall of fame).
class _LegendsLink extends StatelessWidget {
  const _LegendsLink({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.push('${Routes.legends}?careerId=$careerId'),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium,
              size: 22, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LEGENDS',
                    style: AppTypography.labelMedium
                        .copyWith(color: AppColors.primary)),
                Text(
                  'All-time XI & hall of fame',
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}

/// A simple tappable navigation card (icon, title, subtitle, chevron).
class _NavLink extends StatelessWidget {
  const _NavLink({
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
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTypography.labelMedium
                        .copyWith(color: AppColors.primary)),
                Text(
                  subtitle,
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
        ],
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
    final r = ref.watch(rivalryProvider(careerId)).valueOrNull;
    if (r == null) return const SizedBox.shrink();
    final record = '${r.wins}W ${r.draws}D ${r.losses}L';
    final edge = r.wins > r.losses
        ? 'You hold the upper hand'
        : r.wins < r.losses
            ? 'They have your number'
            : 'Honours even';
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
                  'FIERCEST RIVAL',
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
                        '${r.played} meetings · $record · $edge',
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
    return AppCard(
      child: Column(
        children: [
          _row('Best finish', bestFinish, null),
          _row('Longest unbeaten', '$longestUnbeaten matches', null),
          if (biggestWin != null)
            _row('Biggest win', biggestWin!, biggestWinCode),
        ],
      ),
    );
  }

  Widget _row(String label, String value, String? code) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
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
                InkWell(
                  onTap: () => context.push(
                    '${Routes.player}?careerId=$careerId'
                    '&playerId=${leaders[i].playerId}',
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          child: Text(
                            '${i + 1}',
                            style: AppTypography.labelMedium.copyWith(
                              color: i == 0
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            leaders[i].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight:
                                  i == 0 ? FontWeight.w700 : FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          unit.isEmpty
                              ? '${leaders[i].value}'
                              : '${leaders[i].value} $unit',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
