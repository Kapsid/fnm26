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
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/round_popup.dart';
import 'package:fnm/features/messages/message_popup.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// In-game home ("National Hub"): continue/play, calendar, next match, squad
/// status, and the group table, with the in-game bottom navigation.
class HubScreen extends ConsumerStatefulWidget {
  const HubScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends ConsumerState<HubScreen> {
  /// Guards against a second run while a sheet is already up — the hub rebuilds
  /// often, and each rebuild would otherwise stack another popup.
  bool _popping = false;

  int get careerId => widget.careerId;

  /// Pops any unread news over the hub. Driven from here rather than from each
  /// action because everything returns to the hub — a match, a draw, a stepped
  /// tournament round — so this catches them all in one place.
  Future<void> _popMessages() async {
    // Wait if an action is already showing its own popup: stepping a final
    // fires the champion news and the final's result together, and racing them
    // buries one behind the other. That path pops the news itself when done.
    if (_popping || appPopupBusy) return;
    _popping = true;
    try {
      if (mounted) await showUnreadMessagePopups(context, ref, careerId);
    } finally {
      _popping = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(hubDataProvider(careerId));
    final unread =
        ref.watch(unreadMessagesProvider(careerId)).valueOrNull ?? 0;

    // Surface news the moment it lands, rather than leaving it to be found.
    if (unread > 0 && !_popping) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _popMessages());
    }

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
            tooltip: 'Messages',
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.mail_outline, color: AppColors.primary),
            ),
            onPressed: () =>
                context.go('${Routes.messages}?careerId=$careerId'),
          ),
        ],
      ),
      bottomNavigationBar:
          AppBottomNav(careerId: careerId, current: AppTab.hub),
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
          // Hide the opponent and group table until the draw has been watched.
          final drawWatched = hub.nextDrawWatched;

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
              _BoardFinanceCard(
                careerId: careerId,
                budget: hub.career.budget,
                onFinances: () =>
                    context.go('${Routes.finances}?careerId=$careerId'),
              ),
              const SizedBox(height: AppSpacing.md),
              // The primary action is whatever the next timeline event is
              // (a draw, the next match, a tournament to follow, or rollover).
              _EventButton(careerId: careerId),
              if (hub.championNationId == null && drawWatched) ...[
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
              const SizedBox(height: AppSpacing.md),
              _SquadStatus(
                rating: hub.squadRating,
                size: hub.squadSize,
                morale: ref.watch(moraleProvider(careerId)).valueOrNull ?? 50,
                onManage: () =>
                    context.go('${Routes.tactics}?careerId=$careerId'),
              ),
              const SizedBox(height: AppSpacing.md),
              // Always show the next group — but only reveal the table once its
              // own draw has been watched; before then it's "to be drawn".
              if (hub.group != null)
                if (hub.groupDrawWatched)
                  _GroupTable(
                    group: hub.group!,
                    playerNationId: hub.career.nationId,
                    directCount: hub.groupDirectCount,
                    contentionPos: hub.groupContentionPos,
                    relegateCount: hub.groupRelegateCount,
                    caption: hub.groupCaption,
                    code: code,
                    name: name,
                    // Open the right competition detail: the Nations Cup, the
                    // World Cup for its qualifiers/finals, else the player's
                    // continental cup.
                    onTap: () {
                      final comp = hub.group!.competition;
                      final conf =
                          hub.nations[hub.career.nationId]?.confederation;
                      if (comp.startsWith('Nations Cup')) {
                        context.go(
                          '${Routes.nationsCup}?careerId=$careerId',
                        );
                        return;
                      }
                      final isWc = comp == 'World Cup Qualifiers' ||
                          comp == 'World Championship';
                      context.go(
                        isWc || conf == null
                            ? '${Routes.cup}?careerId=$careerId'
                            : '${Routes.continental}?careerId=$careerId'
                                '&conf=${conf.name}',
                      );
                    },
                  )
                else
                  _GroupPlaceholder(competition: hub.group!.competition),
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

/// A single compact strip: board confidence (shown immediately, colour-coded)
/// on the left, and the federation funds as a button through to the finances
/// screen on the right.
class _BoardFinanceCard extends ConsumerWidget {
  const _BoardFinanceCard({
    required this.careerId,
    required this.budget,
    required this.onFinances,
  });

  final int careerId;
  final int budget;
  final VoidCallback onFinances;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(satisfactionProvider(careerId)).valueOrNull;
    final (color, verdict) = switch (value) {
      null => (AppColors.onSurfaceVariant, '—'),
      >= 75 => (AppColors.positive, 'Delighted'),
      >= 55 => (AppColors.positive, 'Pleased'),
      >= 40 => (AppColors.warning, 'Expecting more'),
      >= 25 => (AppColors.warning, 'Concerned'),
      _ => (AppColors.error, 'Job at risk'),
    };
    return AppCard(
      child: Row(
        children: [
          Icon(Icons.gavel, color: color, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    value == null ? 'BOARD' : '$value%',
                    style: AppTypography.titleMedium.copyWith(color: color),
                  ),
                ],
              ),
              Text(
                verdict,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: onFinances,
            icon: const Icon(Icons.account_balance, size: 16),
            label: Text(formatEuros(budget)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.outlineVariant),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            ),
          ),
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
      case HubEventKind.watchTournament:
        // Sim the next round, then pop up its results (with a link to the full
        // bracket); group-stage rounds fall through to the bracket directly.
        final route = event.route;
        unawaited(
          // Guarded from before the first await: advancing invalidates the hub,
          // which would otherwise let its automatic news popup race this one —
          // and the round that generates news is the final, the one round the
          // player most wants to see.
          withAppPopupGuard(() async {
            await season.advance(careerId);
            if (context.mounted) {
              await showRoundPopup(context, ref, careerId, route: route);
            }
            // Then the news, in order, rather than on top.
            if (context.mounted) {
              await showUnreadMessagePopups(context, ref, careerId);
            }
          }),
        );
      case HubEventKind.advance:
        unawaited(season.advance(careerId));
      case HubEventKind.cycleRollover:
      case HubEventKind.draw:
      case HubEventKind.callUp:
      case HubEventKind.naturalization:
      case HubEventKind.friendlies:
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
      'NL' => 'NATIONS CUP',
      'NGROUP' => 'NATIONS CUP · GROUP',
      'NSF' => 'NATIONS CUP · SEMI-FINAL',
      'NFINAL' => 'NATIONS CUP · FINAL',
      'FFINAL' => 'CONTINENTAL CLASH',
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
    required this.morale,
    required this.onManage,
  });

  final int rating;
  final int size;
  final int morale;
  final VoidCallback onManage;

  Color get _moraleColor => morale >= 60
      ? AppColors.positive
      : morale >= 42
          ? AppColors.primary
          : morale >= 25
              ? AppColors.warning
              : AppColors.error;

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
          Row(
            children: [
              Text(
                'Morale',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                Condition.moraleLabel(morale),
                style: AppTypography.labelMedium.copyWith(color: _moraleColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: Stack(
              children: [
                Container(height: 6, color: AppColors.surfaceContainerHighest),
                FractionallySizedBox(
                  widthFactor: (morale / 100).clamp(0.0, 1.0),
                  child: Container(height: 6, color: _moraleColor),
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

/// Stand-in for the group table before its draw ceremony has been watched —
/// the competition is known, the groups are not yet revealed.
class _GroupPlaceholder extends StatelessWidget {
  const _GroupPlaceholder({required this.competition});

  final String competition;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.casino, color: AppColors.primary, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  competition.toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Groups to be drawn — watch the draw to reveal them.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
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

class _GroupTable extends StatelessWidget {
  const _GroupTable({
    required this.group,
    required this.playerNationId,
    required this.directCount,
    required this.contentionPos,
    required this.code,
    required this.name,
    this.relegateCount = 0,
    this.caption = '',
    this.onTap,
  });

  final GroupTable group;
  final int playerNationId;

  /// Positions that advance outright (green) and the single "in contention"
  /// (amber) position, matching the tournament detail screens.
  final int directCount;
  final int? contentionPos;

  /// How many bottom places go down (red) — the Nations Cup relegates each
  /// group's last side.
  final int relegateCount;

  /// A plain-English note on what the zones mean.
  final String caption;
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
          if (caption.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              caption,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _standingRow(int pos, GroupStanding s) {
    final isPlayer = s.nationId == playerNationId;
    // Greens the outright qualifiers, ambers the single "in contention" spot
    // (best runner-up / best third / play-off) and reds the relegation places,
    // using the same format the tournament detail screens compute, so the two
    // never disagree.
    final direct = pos <= directCount;
    final inContention = pos == contentionPos;
    final relegated =
        relegateCount > 0 && pos > group.standings.length - relegateCount;
    final zoneColor = direct
        ? AppColors.positive
        : inContention
            ? AppColors.warning
            : relegated
                ? AppColors.error
                : null;
    final gd = s.goalDifference;
    return Container(
      decoration: BoxDecoration(
        color: isPlayer ? AppColors.surfaceContainerHigh : null,
        border: Border(
          left: BorderSide(
            color: zoneColor ?? Colors.transparent,
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
                color: zoneColor ??
                    (isPlayer
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant),
                fontWeight: direct ? FontWeight.w700 : FontWeight.w500,
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
