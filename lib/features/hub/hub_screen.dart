import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// In-game home ("National Hub"): next match, group table, recent results, and
/// the Advance control that simulates forward to the next fixture.
class HubScreen extends ConsumerWidget {
  const HubScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(hubDataProvider(careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(Routes.home),
        ),
        title: Text(
          'NATIONAL HUB',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.dashboard_customize_outlined,
              color: AppColors.primary,
            ),
            tooltip: 'Squad & Tactics',
            onPressed: () => context.go('${Routes.tactics}?careerId=$careerId'),
          ),
        ],
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load save.\n$e')),
        data: (hub) {
          if (hub == null) {
            return const Center(child: Text('Save not found.'));
          }
          final nation = hub.nations[hub.career.nationId];
          final date = DateFormat('d MMM yyyy').format(hub.career.inGameDate);

          String code(int id) => hub.nations[id]?.code ?? '??';
          String name(int id) => hub.nations[id]?.name ?? 'Unknown';

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              AppCard(
                child: Row(
                  children: [
                    FlagDisc(nation?.code ?? '??'),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nation?.name ?? '…',
                            style: AppTypography.headlineMedium,
                          ),
                          Text(
                            '${hub.career.managerName} · $date',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _NextMatch(next: hub.next, code: code),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: hub.next == null ? 'Qualifying complete' : 'Play Match',
                icon: Icons.sports_soccer,
                onPressed: hub.next == null
                    ? null
                    : () => context.go('${Routes.match}?careerId=$careerId'),
              ),
              if (hub.next != null) ...[
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () =>
                      ref.read(seasonServiceProvider).advance(careerId),
                  child: const Text('Quick sim (skip)'),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              if (hub.group != null)
                _GroupTable(
                  group: hub.group!,
                  playerNationId: hub.career.nationId,
                  code: code,
                  name: name,
                ),
              const SizedBox(height: AppSpacing.lg),
              _RecentResults(
                results: hub.recentResults,
                code: code,
                onSeeAll: () =>
                    context.go('${Routes.results}?careerId=$careerId'),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

class _NextMatch extends StatelessWidget {
  const _NextMatch({required this.next, required this.code});

  final Fixture? next;
  final String Function(int) code;

  @override
  Widget build(BuildContext context) {
    final f = next;
    if (f == null) {
      return const AppCard(
        child: Center(child: Text('No more fixtures this cycle.')),
      );
    }
    final date = DateFormat('EEE d MMM').format(f.date).toUpperCase();
    return AppCard(
      child: Column(
        children: [
          const Text('NEXT MATCH', style: AppTypography.labelMedium),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Side(code: code(f.homeNationId)),
              Column(
                children: [
                  Text('MD${f.matchday}', style: AppTypography.labelSmall),
                  const SizedBox(height: 4),
                  const Text('VS', style: AppTypography.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              _Side(code: code(f.awayNationId)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlagDisc(code, size: 56),
        const SizedBox(height: AppSpacing.xs),
        Text(code, style: AppTypography.labelSmall),
      ],
    );
  }
}

class _GroupTable extends StatelessWidget {
  const _GroupTable({
    required this.group,
    required this.playerNationId,
    required this.code,
    required this.name,
  });

  final GroupTable group;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('GROUP ${group.name}', style: AppTypography.labelMedium),
          const SizedBox(height: AppSpacing.sm),
          _row('#', 'TEAM', 'P', 'GD', 'PTS', header: true),
          const Divider(),
          for (var i = 0; i < group.standings.length; i++)
            _standingRow(i + 1, group.standings[i]),
        ],
      ),
    );
  }

  Widget _standingRow(int pos, GroupStanding s) {
    final isPlayer = s.nationId == playerNationId;
    final gd = s.goalDifference;
    return Container(
      color: isPlayer ? AppColors.surfaceContainerHigh : null,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              '$pos',
              style: AppTypography.labelSmall.copyWith(
                color: isPlayer
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          FlagDisc(code(s.nationId), size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name(s.nationId),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: isPlayer ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          _cell('${s.played}'),
          _cell(gd > 0 ? '+$gd' : '$gd'),
          _cell('${s.points}', emphasize: true),
        ],
      ),
    );
  }

  Widget _row(
    String a,
    String b,
    String c,
    String d,
    String e, {
    bool header = false,
  }) {
    final style = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return Row(
      children: [
        SizedBox(width: 20, child: Text(a, style: style)),
        const SizedBox(width: 22 + AppSpacing.sm),
        Expanded(child: Text(b, style: style)),
        _cell(c, header: true),
        _cell(d, header: true),
        _cell(e, header: true),
      ],
    );
  }

  Widget _cell(String text, {bool header = false, bool emphasize = false}) {
    return SizedBox(
      width: 34,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTypography.labelSmall.copyWith(
          color: header
              ? AppColors.onSurfaceVariant
              : (emphasize ? AppColors.primary : AppColors.onSurface),
          fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _RecentResults extends StatelessWidget {
  const _RecentResults({
    required this.results,
    required this.code,
    required this.onSeeAll,
  });

  final List<Fixture> results;
  final String Function(int) code;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return AppCard(
        onTap: onSeeAll,
        child: Row(
          children: [
            const Text('RESULTS', style: AppTypography.labelMedium),
            const Spacer(),
            Text(
              'See all ›',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    return AppCard(
      onTap: onSeeAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('RECENT RESULTS', style: AppTypography.labelMedium),
              const Spacer(),
              Text(
                'See all ›',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final f in results.take(6))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          code(f.homeNationId),
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        FlagDisc(code(f.homeNationId), size: 22),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      '${f.homeScore} - ${f.awayScore}',
                      style: AppTypography.labelMedium,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        FlagDisc(code(f.awayNationId), size: 22),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          code(f.awayNationId),
                          style: AppTypography.bodySmall,
                        ),
                      ],
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
