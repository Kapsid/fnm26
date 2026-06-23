import 'dart:async';

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

/// Plays the player's next fixture as a *live* minute-by-minute simulation
/// (the deterministic engine result is replayed on a clock with play/pause,
/// speed, and skip controls), then commits it on Continue.
class MatchScreen extends ConsumerStatefulWidget {
  const MatchScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> {
  static const _speeds = [1, 2, 4];

  int _minute = 0;
  bool _playing = true;
  int _speedIdx = 0;
  bool _started = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _begin() {
    _started = true;
    _restartTimer();
  }

  void _restartTimer() {
    _timer?.cancel();
    if (!_playing || _minute >= 90) return;
    final interval = Duration(milliseconds: (360 / _speeds[_speedIdx]).round());
    _timer = Timer.periodic(interval, (_) {
      setState(() {
        _minute++;
        if (_minute >= 90) {
          _minute = 90;
          _playing = false;
          _timer?.cancel();
        }
      });
    });
  }

  void _togglePlay() {
    setState(() => _playing = !_playing);
    _restartTimer();
  }

  void _cycleSpeed() {
    setState(() => _speedIdx = (_speedIdx + 1) % _speeds.length);
    if (_playing) _restartTimer();
  }

  void _skip() {
    _timer?.cancel();
    setState(() {
      _minute = 90;
      _playing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final previewAsync = ref.watch(matchPreviewProvider(widget.careerId));

    return Scaffold(
      body: previewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load match.\n$e')),
        data: (preview) {
          if (preview == null) {
            return const Center(child: Text('No upcoming match.'));
          }
          if (!_started) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_started) _begin();
            });
          }

          final r = preview.result;
          final homeId = preview.homeTeam.nationId;
          final awayId = preview.awayTeam.nationId;
          String code(int id) => preview.nations[id]?.code ?? '??';
          String name(int id) => preview.nations[id]?.name ?? 'Unknown';

          final shown = r.events.where((e) => e.minute <= _minute).toList();
          final homeScore = shown.where((e) => e.teamNationId == homeId).length;
          final awayScore = shown.length - homeScore;
          final ft = _minute >= 90;

          return DefaultTabController(
            length: 3,
            child: SafeArea(
              child: Column(
                children: [
                  _TopBar(
                    onClose: () =>
                        context.go('${Routes.hub}?careerId=${widget.careerId}'),
                  ),
                  _Header(
                    homeCode: code(homeId),
                    awayCode: code(awayId),
                    homeName: name(homeId),
                    awayName: name(awayId),
                    homeScore: homeScore,
                    awayScore: awayScore,
                    clock: ft ? 'FULL TIME' : "$_minute'",
                    live: !ft,
                    events: shown,
                    homeId: homeId,
                  ),
                  if (!ft)
                    _Controls(
                      playing: _playing,
                      speed: _speeds[_speedIdx],
                      onPlayPause: _togglePlay,
                      onSpeed: _cycleSpeed,
                      onSkip: _skip,
                    ),
                  const TabBar(
                    labelColor: AppColors.onSurface,
                    unselectedLabelColor: AppColors.onSurfaceVariant,
                    indicatorColor: AppColors.primary,
                    tabs: [
                      Tab(text: 'TIMELINE'),
                      Tab(text: 'STATS'),
                      Tab(text: 'LINEUPS'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _Timeline(
                          events: shown,
                          code: code,
                          live: !ft,
                          homeId: homeId,
                        ),
                        if (ft)
                          _Stats(
                            result: r,
                            homeCode: code(homeId),
                            awayCode: code(awayId),
                          )
                        else
                          const _StatsLocked(),
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
                      label: ft ? 'Continue' : 'Skip to full time',
                      icon: ft ? Icons.check_rounded : Icons.fast_forward,
                      onPressed: ft
                          ? () async {
                              await ref
                                  .read(seasonServiceProvider)
                                  .playPlayerMatch(
                                    widget.careerId,
                                    preview.fixture,
                                    r,
                                  );
                              if (context.mounted) {
                                context.go(
                                  '${Routes.hub}?careerId=${widget.careerId}',
                                );
                              }
                            }
                          : _skip,
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
    required this.homeScore,
    required this.awayScore,
    required this.clock,
    required this.live,
    required this.events,
    required this.homeId,
  });

  final String homeCode;
  final String awayCode;
  final String homeName;
  final String awayName;
  final int homeScore;
  final int awayScore;
  final String clock;
  final bool live;
  final List<MatchEvent> events;
  final int homeId;

  @override
  Widget build(BuildContext context) {
    final homeGoals = events.where((e) => e.teamNationId == homeId).toList();
    final awayGoals = events.where((e) => e.teamNationId != homeId).toList();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      child: AppCard(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (live)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: AppSpacing.sm),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.error,
                    ),
                  ),
                Text(
                  clock,
                  style: AppTypography.labelMedium.copyWith(
                    color: live ? AppColors.error : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _Side(code: homeCode, label: homeName)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  child: Text(
                    '$homeScore : $awayScore',
                    style: AppTypography.displayLarge,
                  ),
                ),
                Expanded(child: _Side(code: awayCode, label: awayName)),
              ],
            ),
            if (homeGoals.isNotEmpty || awayGoals.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _ScorerList(goals: homeGoals, alignEnd: true),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _ScorerList(goals: awayGoals, alignEnd: false),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ScorerList extends StatelessWidget {
  const _ScorerList({required this.goals, required this.alignEnd});
  final List<MatchEvent> goals;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.bodySmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    const ball = Icon(Icons.sports_soccer, size: 12, color: AppColors.primary);
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        for (final g in goals)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: alignEnd
                  ? [
                      Flexible(
                        child: Text(
                          "${g.playerName} ${g.minute}'",
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: style,
                        ),
                      ),
                      const SizedBox(width: 4),
                      ball,
                    ]
                  : [
                      ball,
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          "${g.minute}' ${g.playerName}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: style,
                        ),
                      ),
                    ],
            ),
          ),
      ],
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.playing,
    required this.speed,
    required this.onPlayPause,
    required this.onSpeed,
    required this.onSkip,
  });

  final bool playing;
  final int speed;
  final VoidCallback onPlayPause;
  final VoidCallback onSpeed;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton.filledTonal(
            icon: Icon(playing ? Icons.pause : Icons.play_arrow),
            onPressed: onPlayPause,
          ),
          const SizedBox(width: AppSpacing.md),
          OutlinedButton(
            onPressed: onSpeed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.outlineVariant),
            ),
            child: Text('${speed}x', style: AppTypography.labelMedium),
          ),
          const SizedBox(width: AppSpacing.md),
          IconButton.filledTonal(
            icon: const Icon(Icons.skip_next),
            tooltip: 'Skip to full time',
            onPressed: onSkip,
          ),
        ],
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

class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.events,
    required this.code,
    required this.live,
    required this.homeId,
  });
  final List<MatchEvent> events;
  final String Function(int) code;
  final bool live;
  final int homeId;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Text(
          live ? 'Kick-off!' : 'No goals yet.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }
    // Most recent at the top.
    final reversed = events.reversed.toList();
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        for (final e in reversed)
          _TimelineRow(event: e, isHome: e.teamNationId == homeId),
      ],
    );
  }
}

/// One goal on a two-sided timeline: home goals sit on the left, away on the
/// right, with the minute down the centre spine.
class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.event, required this.isHome});

  final MatchEvent event;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: isHome
                ? _goal(alignEnd: true)
                : const SizedBox.shrink(),
          ),
          Container(
            width: 34,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: AppRadii.smAll,
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Text("${event.minute}'", style: AppTypography.labelSmall),
          ),
          Expanded(
            child: !isHome
                ? _goal(alignEnd: false)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _goal({required bool alignEnd}) {
    const ball = Icon(
      Icons.sports_soccer,
      size: 16,
      color: AppColors.primary,
    );
    final name = Flexible(
      child: Text(
        event.playerName,
        textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.bodyMedium,
      ),
    );
    return Padding(
      padding: EdgeInsets.only(
        left: alignEnd ? 0 : AppSpacing.sm,
        right: alignEnd ? AppSpacing.sm : 0,
      ),
      child: Row(
        mainAxisAlignment:
            alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: alignEnd
            ? [name, const SizedBox(width: AppSpacing.sm), ball]
            : [ball, const SizedBox(width: AppSpacing.sm), name],
      ),
    );
  }
}

class _StatsLocked extends StatelessWidget {
  const _StatsLocked();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Stats available at full time.',
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
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
                  child: Container(height: 6, color: AppColors.outlineVariant),
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
                SizedBox(width: 36, child: TacticalChip(p.position.label)),
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
