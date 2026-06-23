import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// World Championship detail: the qualifying group stage for every
/// confederation (your region first), plus knockout/stats/history tabs that
/// arrive with the finals.
class CupDetailScreen extends ConsumerWidget {
  const CupDetailScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(cupDetailProvider(careerId));

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () =>
                context.go('${Routes.tournaments}?careerId=$careerId'),
          ),
          title: Text(
            'WORLD CHAMPIONSHIP',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: AppColors.onSurface,
            unselectedLabelColor: AppColors.onSurfaceVariant,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'QUALIFYING'),
              Tab(text: 'KNOCKOUT'),
              Tab(text: 'STATS'),
              Tab(text: 'HISTORY'),
            ],
          ),
        ),
        body: dataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Could not load cup.\n$e')),
          data: (data) {
            if (data == null) return const Center(child: Text('No cup data.'));
            String code(int id) => data.nations[id]?.code ?? '??';
            String name(int id) => data.nations[id]?.name ?? 'Unknown';

            return TabBarView(
              children: [
                _Qualifying(
                  groups: data.groups,
                  playerConfederation: data.playerConfederation,
                  playerNationId: data.playerNationId,
                  code: code,
                  name: name,
                ),
                const _Soon(
                  message: 'The knockout bracket arrives with the finals.',
                ),
                const _Soon(message: 'Tournament statistics coming soon.'),
                const _Soon(message: 'Roll of honour coming soon.'),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Qualifying extends StatelessWidget {
  const _Qualifying({
    required this.groups,
    required this.playerConfederation,
    required this.playerNationId,
    required this.code,
    required this.name,
  });

  final List<ConfederationGroupTable> groups;
  final Confederation? playerConfederation;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const Center(child: Text('No groups drawn.'));
    }
    final byConf = <Confederation, List<ConfederationGroupTable>>{};
    for (final g in groups) {
      (byConf[g.confederation] ??= []).add(g);
    }
    final confs = byConf.keys.toList()
      ..sort((a, b) {
        if (a == playerConfederation) return -1;
        if (b == playerConfederation) return 1;
        return a.index.compareTo(b.index);
      });

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        for (final conf in confs) ...[
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              bottom: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Text(
                  conf.label.toUpperCase(),
                  style: AppTypography.labelMedium
                      .copyWith(color: AppColors.primary),
                ),
                if (conf == playerConfederation) ...[
                  const SizedBox(width: AppSpacing.sm),
                  const TacticalChip('YOUR REGION', emphasized: true),
                ],
              ],
            ),
          ),
          for (final g in byConf[conf]!) ...[
            _GroupCard(
              group: g,
              playerNationId: playerNationId,
              code: code,
              name: name,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.group,
    required this.playerNationId,
    required this.code,
    required this.name,
  });

  final ConfederationGroupTable group;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GROUP ${group.groupName}',
            style: AppTypography.labelSmall
                .copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < group.standings.length; i++)
            _row(i + 1, group.standings[i]),
        ],
      ),
    );
  }

  Widget _row(int pos, GroupStanding s) {
    final isPlayer = s.nationId == playerNationId;
    final gd = s.goalDifference;
    return Container(
      color: isPlayer ? AppColors.surfaceContainerHigh : null,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: Text(
              '$pos',
              style: AppTypography.labelSmall.copyWith(
                color:
                    isPlayer ? AppColors.primary : AppColors.onSurfaceVariant,
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

  Widget _cell(String text, {bool emphasize = false}) => SizedBox(
        width: 30,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTypography.labelSmall.copyWith(
            color: emphasize ? AppColors.primary : AppColors.onSurface,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      );
}

class _Soon extends StatelessWidget {
  const _Soon({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_empty, color: AppColors.outline),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
