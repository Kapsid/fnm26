import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Plays the player's next fixture with the tactical engine and shows the
/// detail (Overview / Stats / Lineups) before committing the result.
class MatchScreen extends ConsumerWidget {
  const MatchScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewAsync = ref.watch(matchPreviewProvider(careerId));

    return Scaffold(
      body: previewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load match.\n$e')),
        data: (preview) {
          if (preview == null) {
            return const Center(child: Text('No upcoming match.'));
          }
          final r = preview.result;
          String code(int id) => preview.nations[id]?.code ?? '??';
          String name(int id) => preview.nations[id]?.name ?? 'Unknown';
          final homeId = preview.homeTeam.nationId;
          final awayId = preview.awayTeam.nationId;

          return DefaultTabController(
            length: 3,
            child: SafeArea(
              child: Column(
                children: [
                  _TopBar(
                    onClose: () =>
                        context.go('${Routes.hub}?careerId=$careerId'),
                  ),
                  _Header(
                    homeCode: code(homeId),
                    awayCode: code(awayId),
                    homeName: name(homeId),
                    awayName: name(awayId),
                    result: r,
                    homeId: homeId,
                  ),
                  const TabBar(
                    labelColor: AppColors.onSurface,
                    unselectedLabelColor: AppColors.onSurfaceVariant,
                    indicatorColor: AppColors.primary,
                    tabs: [
                      Tab(text: 'OVERVIEW'),
                      Tab(text: 'STATS'),
                      Tab(text: 'LINEUPS'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _Timeline(result: r, code: code),
                        _Stats(
                          result: r,
                          homeCode: code(homeId),
                          awayCode: code(awayId),
                        ),
                        _Lineups(
                          home: preview.homeTeam,
                          away: preview.awayTeam,
                          homeCode: code(homeId),
                          awayCode: code(awayId),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.marginMobile),
                    child: PrimaryButton(
                      label: 'Continue',
                      icon: Icons.check_rounded,
                      onPressed: () async {
                        await ref
                            .read(seasonServiceProvider)
                            .playPlayerMatch(careerId, preview.fixture, r);
                        if (context.mounted) {
                          context.go('${Routes.hub}?careerId=$careerId');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.primary),
            onPressed: onClose,
          ),
          Text(
            'MATCH',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.homeCode,
    required this.awayCode,
    required this.homeName,
    required this.awayName,
    required this.result,
    required this.homeId,
  });

  final String homeCode;
  final String awayCode;
  final String homeName;
  final String awayName;
  final MatchResult result;
  final int homeId;

  @override
  Widget build(BuildContext context) {
    final homeGoals = result.events
        .where((e) => e.teamNationId == homeId)
        .toList();
    final awayGoals = result.events
        .where((e) => e.teamNationId != homeId)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      child: AppCard(
        child: Column(
          children: [
            const Text('FULL TIME', style: AppTypography.labelMedium),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _Side(code: homeCode, label: homeName),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  child: Text(
                    '${result.homeScore} : ${result.awayScore}',
                    style: AppTypography.displayLarge,
                  ),
                ),
                Expanded(
                  child: _Side(code: awayCode, label: awayName),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _Scorers(goals: homeGoals, alignEnd: true)),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _Scorers(goals: awayGoals, alignEnd: false)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({required this.code, required this.label});
  final String code;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlagDisc(code, size: 56),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.titleMedium,
        ),
      ],
    );
  }
}

class _Scorers extends StatelessWidget {
  const _Scorers({required this.goals, required this.alignEnd});
  final List<MatchEvent> goals;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        for (final g in goals)
          Text(
            "${g.minute}' ${g.playerName}",
            textAlign: alignEnd ? TextAlign.end : TextAlign.start,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.result, required this.code});
  final MatchResult result;
  final String Function(int) code;

  @override
  Widget build(BuildContext context) {
    if (result.events.isEmpty) {
      return Center(
        child: Text(
          'A goalless affair.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        for (final e in result.events)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text("${e.minute}'", style: AppTypography.labelMedium),
                ),
                const Icon(
                  Icons.sports_soccer,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Goal! ${e.playerName}',
                    style: AppTypography.bodyMedium,
                  ),
                ),
                Text(code(e.teamNationId), style: AppTypography.labelSmall),
              ],
            ),
          ),
      ],
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({
    required this.result,
    required this.homeCode,
    required this.awayCode,
  });
  final MatchResult result;
  final String homeCode;
  final String awayCode;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(homeCode, style: AppTypography.labelMedium),
            Text(awayCode, style: AppTypography.labelMedium),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _StatBar(
          label: 'Possession',
          home: result.homePossession,
          away: result.awayPossession,
          suffix: '%',
        ),
        _StatBar(
          label: 'Shots',
          home: result.homeShots,
          away: result.awayShots,
        ),
        _StatBar(
          label: 'Goals',
          home: result.homeScore,
          away: result.awayScore,
        ),
      ],
    );
  }
}

class _StatBar extends StatelessWidget {
  const _StatBar({
    required this.label,
    required this.home,
    required this.away,
    this.suffix = '',
  });

  final String label;
  final int home;
  final int away;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final total = (home + away) == 0 ? 1 : home + away;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$home$suffix', style: AppTypography.labelMedium),
              Text(
                label.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text('$away$suffix', style: AppTypography.labelMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: Row(
              children: [
                Expanded(
                  flex: (home / total * 1000).round().clamp(1, 1000),
                  child: Container(height: 6, color: AppColors.primary),
                ),
                Expanded(
                  flex: (away / total * 1000).round().clamp(1, 1000),
                  child: Container(
                    height: 6,
                    color: AppColors.outlineVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Lineups extends StatelessWidget {
  const _Lineups({
    required this.home,
    required this.away,
    required this.homeCode,
    required this.awayCode,
  });

  final MatchTeam home;
  final MatchTeam away;
  final String homeCode;
  final String awayCode;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        _xi(homeCode, home.xi),
        const SizedBox(height: AppSpacing.lg),
        _xi(awayCode, away.xi),
      ],
    );
  }

  Widget _xi(String teamCode, List<Player> xi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          teamCode,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final p in xi)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: TacticalChip(p.position.label),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(p.name, style: AppTypography.bodyMedium),
                ),
                Text('${p.overall}', style: AppTypography.labelMedium),
              ],
            ),
          ),
      ],
    );
  }
}
