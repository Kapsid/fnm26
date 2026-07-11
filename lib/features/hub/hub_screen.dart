import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// In-game home ("National Hub"): continue/play, calendar, next match, squad
/// status, and the group table, with the in-game bottom navigation.
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
            icon: const Icon(Icons.account_circle, color: AppColors.primary),
            onPressed: () => _soon(context),
          ),
        ],
      ),
      bottomNavigationBar: _HubBottomNav(careerId: careerId),
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
              Row(
                children: [
                  FlagDisc(nation?.code ?? '??', size: 44),
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
              const SizedBox(height: AppSpacing.md),
              if (hub.championNationId != null) ...[
                _ChampionBanner(
                  name: name(hub.championNationId!),
                  code: code(hub.championNationId!),
                  onView: () => context.go('${Routes.cup}?careerId=$careerId'),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              // The primary action is whatever the next timeline event is
              // (a draw, the next match, a tournament to follow, or rollover).
              _EventButton(careerId: careerId),
              if (hub.championNationId == null) ...[
                const SizedBox(height: AppSpacing.md),
                _NextMatch(next: hub.next, code: code),
              ],
              if (hub.hasFinals && hub.championNationId == null) ...[
                const SizedBox(height: AppSpacing.md),
                _FinalsFollowCard(
                  playerInFinals: hub.fixtures.any(
                    (f) => const {
                      'GROUP',
                      'R32',
                      'R16',
                      'QF',
                      'SF',
                      '3RD',
                      'FINAL',
                    }.contains(f.round),
                  ),
                  onSkipToFinal: () async {
                    await ref
                        .read(seasonServiceProvider)
                        .skipToChampion(careerId);
                    if (context.mounted) {
                      context.go('${Routes.cup}?careerId=$careerId');
                    }
                  },
                  onFollow: () =>
                      context.go('${Routes.cup}?careerId=$careerId'),
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () =>
                        context.go('${Routes.teamStats}?careerId=$careerId'),
                    child: const Text('Team records ›'),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.go('${Routes.results}?careerId=$careerId'),
                    child: const Text('My matches ›'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _SquadStatus(
                rating: hub.squadRating,
                size: hub.squadSize,
                onManage: () =>
                    context.go('${Routes.tactics}?careerId=$careerId'),
              ),
              const SizedBox(height: AppSpacing.md),
              if (hub.group != null)
                _GroupTable(
                  group: hub.group!,
                  playerNationId: hub.career.nationId,
                  code: code,
                  name: name,
                  onTap: () => context.go('${Routes.cup}?careerId=$careerId'),
                ),
              const SizedBox(height: AppSpacing.lg),
              if (hub.next != null)
                Center(
                  child: TextButton(
                    onPressed: () =>
                        ref.read(seasonServiceProvider).advance(careerId),
                    child: const Text('Quick sim (skip)'),
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
            ],
          );
        },
      ),
    );
  }

  void _soon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Coming soon')));
  }
}

class _ChampionBanner extends StatelessWidget {
  const _ChampionBanner({
    required this.name,
    required this.code,
    required this.onView,
  });

  final String name;
  final String code;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const Icon(Icons.emoji_events, color: AppColors.primary, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'WORLD CHAMPIONS',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlagDisc(code, size: 28),
              const SizedBox(width: AppSpacing.sm),
              Text(name, style: AppTypography.headlineMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(onPressed: onView, child: const Text('View bracket ›')),
        ],
      ),
    );
  }
}

/// The hub's primary action, driven by the next timeline event: watch a draw,
/// play the next match, step a live tournament, or roll into the next cycle.
class _EventButton extends ConsumerWidget {
  const _EventButton({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(nextEventProvider(careerId)).valueOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(
          label: event?.label ?? 'Continue',
          icon: event?.icon ?? Icons.play_arrow_rounded,
          onPressed:
              event == null ? null : () => _dispatch(context, ref, event),
        ),
        if (event?.subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            event!.subtitle!,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  void _dispatch(BuildContext context, WidgetRef ref, HubEvent event) {
    final season = ref.read(seasonServiceProvider);
    switch (event.kind) {
      case HubEventKind.advance:
      case HubEventKind.watchTournament:
        unawaited(season.advance(careerId));
      case HubEventKind.cycleRollover:
      case HubEventKind.draw:
      case HubEventKind.callUp:
      case HubEventKind.match:
        if (event.route != null) context.go(event.route!);
    }
  }
}

/// Surfaces the ongoing World Cup finals on the hub so the player can follow
/// the tournament — especially when their nation didn't qualify and would
/// otherwise have no visible "next step".
class _FinalsFollowCard extends StatelessWidget {
  const _FinalsFollowCard({
    required this.playerInFinals,
    required this.onSkipToFinal,
    required this.onFollow,
  });

  final bool playerInFinals;
  final VoidCallback onSkipToFinal;
  final VoidCallback onFollow;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onFollow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emoji_events, color: AppColors.primary, size: 18),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'WORLD CUP FINALS',
                  style: AppTypography.labelMedium,
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            playerInFinals
                ? 'The finals are under way — follow the bracket.'
                : "You didn't qualify — follow the finals to the end.",
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onFollow,
                  icon: const Icon(Icons.table_rows_rounded, size: 16),
                  label: const Text('Follow'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.outlineVariant),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onSkipToFinal,
                  icon: const Icon(Icons.fast_forward_rounded, size: 16),
                  label: const Text('Skip to final'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.outlineVariant),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Human-readable stage for a fixture (distinguishes qualifiers from finals).
String matchStageLabel(Fixture f) => switch (f.round) {
      null => 'QUALIFYING · MD ${f.matchday}',
      'FRIENDLY' => 'FRIENDLY',
      'NL' => 'NATIONS LEAGUE',
      'GROUP' => 'WC FINALS · GROUP',
      'R32' => 'WC FINALS · ROUND OF 32',
      'R16' => 'WC FINALS · ROUND OF 16',
      'QF' => 'WC FINALS · QUARTER-FINAL',
      'SF' => 'WC FINALS · SEMI-FINAL',
      '3RD' => 'WC FINALS · THIRD PLACE',
      'FINAL' => 'WC FINALS · FINAL',
      'CR16' => 'CONTINENTAL · ROUND OF 16',
      'CQF' => 'CONTINENTAL · QUARTER-FINAL',
      'CSF' => 'CONTINENTAL · SEMI-FINAL',
      'C3RD' => 'CONTINENTAL · THIRD PLACE',
      'CFINAL' => 'CONTINENTAL · FINAL',
      _ => f.round!,
    };

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
          Row(
            children: [
              const Text('NEXT MATCH', style: AppTypography.labelMedium),
              const Spacer(),
              Flexible(
                child: Text(
                  matchStageLabel(f),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall.copyWith(
                    color: f.round == null
                        ? AppColors.onSurfaceVariant
                        : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Side(code: code(f.homeNationId)),
              Column(
                children: [
                  const Text('VS', style: AppTypography.labelLarge),
                  const SizedBox(height: 2),
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
        FlagDisc(code, size: 40),
        const SizedBox(height: AppSpacing.xs),
        Text(code, style: AppTypography.labelMedium),
      ],
    );
  }
}

class _SquadStatus extends StatelessWidget {
  const _SquadStatus({
    required this.rating,
    required this.size,
    required this.onManage,
  });

  final int rating;
  final int size;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('SQUAD STATUS', style: AppTypography.labelMedium),
              const Spacer(),
              Text(
                '$size players',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(
                'Avg rating',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text('$rating', style: AppTypography.labelMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: Stack(
              children: [
                Container(height: 6, color: AppColors.surfaceContainerHighest),
                FractionallySizedBox(
                  widthFactor: (rating / 99).clamp(0.0, 1.0),
                  child: Container(height: 6, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
            label: 'Manage Team',
            icon: Icons.groups,
            onPressed: onManage,
          ),
        ],
      ),
    );
  }
}

class _GroupTable extends StatelessWidget {
  const _GroupTable({
    required this.group,
    required this.playerNationId,
    required this.code,
    required this.name,
    this.onTap,
  });

  final GroupTable group;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  group.competition.toUpperCase(),
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.primary),
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.onSurfaceVariant,
                ),
            ],
          ),
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
    final advancing = pos <= 2;
    final gd = s.goalDifference;
    return Container(
      decoration: BoxDecoration(
        color: isPlayer ? AppColors.surfaceContainerHigh : null,
        border: Border(
          left: BorderSide(
            color: advancing ? AppColors.positive : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              '$pos',
              style: AppTypography.labelSmall.copyWith(
                color: advancing
                    ? AppColors.positive
                    : (isPlayer
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant),
                fontWeight: advancing ? FontWeight.w700 : FontWeight.w500,
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
    return Padding(
      padding: const EdgeInsets.only(left: 7),
      child: Row(
        children: [
          SizedBox(width: 20, child: Text(a, style: style)),
          const SizedBox(width: 22 + AppSpacing.sm),
          Expanded(child: Text(b, style: style)),
          _cell(c, header: true),
          _cell(d, header: true),
          _cell(e, header: true),
        ],
      ),
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

class _HubBottomNav extends StatelessWidget {
  const _HubBottomNav({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const _NavItem(
                icon: Icons.grid_view,
                label: 'Hub',
                active: true,
              ),
              _NavItem(
                icon: Icons.groups,
                label: 'Squad',
                onTap: () => context.go('${Routes.tactics}?careerId=$careerId'),
              ),
              _NavItem(
                icon: Icons.sports_soccer,
                label: 'Matches',
                onTap: () => context.go('${Routes.results}?careerId=$careerId'),
              ),
              _NavItem(
                icon: Icons.emoji_events,
                label: 'Trophy',
                onTap: () =>
                    context.go('${Routes.tournaments}?careerId=$careerId'),
              ),
              _NavItem(
                icon: Icons.more_horiz,
                label: 'More',
                onTap: () => context.go('${Routes.ranking}?careerId=$careerId'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? AppColors.onSecondaryContainer
        : AppColors.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.xlAll,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.secondaryContainer : Colors.transparent,
          borderRadius: AppRadii.xlAll,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: AppTypography.labelSmall.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
