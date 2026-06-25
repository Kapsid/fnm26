import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
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

/// The maximum substitutions a manager may make in a match.
const int kMaxSubs = 5;

/// Plays the player's next fixture as a *live* minute-by-minute simulation
/// (the deterministic engine result is replayed on a clock with play/pause,
/// speed, and skip controls). The manager can make substitutions live; the
/// rest of the match is re-simulated from the same seed with the new XI, so
/// the change actually affects the outcome. Commits the result on Continue.
class MatchScreen extends ConsumerStatefulWidget {
  const MatchScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> {
  static const _speeds = [1, 2, 4];
  static const _engine = MatchEngine();

  int _minute = 0;
  bool _playing = true;
  int _speedIdx = 0;
  bool _started = false;
  Timer? _timer;

  /// Live substitutions the manager has made, and the result recomputed with
  /// them applied (null until the first preview is loaded).
  final List<Substitution> _subs = [];
  MatchResult? _result;

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

  /// The player's on-pitch XI right now (starting XI with live subs applied).
  List<Player> _currentXi(MatchPreview preview) {
    final team = preview.playerIsHome ? preview.homeTeam : preview.awayTeam;
    final xi = [...team.xi];
    for (final s in _subs) {
      final idx = xi.indexWhere((p) => p.id == s.offId);
      if (idx != -1) xi[idx] = s.on;
    }
    return xi;
  }

  /// Substitutes still available (called-up bench minus players already on).
  List<Player> _availableBench(MatchPreview preview) {
    final on = _subs.map((s) => s.on.id).toSet();
    return preview.bench.where((p) => !on.contains(p.id)).toList();
  }

  void _applySub(MatchPreview preview, int offId, Player on) {
    final minute = _minute < 1 ? 1 : (_minute > 90 ? 90 : _minute);
    setState(() {
      _subs.add(
        Substitution(
          teamNationId: preview.playerNationId,
          minute: minute,
          offId: offId,
          on: on,
        ),
      );
      _result = _engine.play(
        home: preview.homeTeam,
        away: preview.awayTeam,
        rng: SeededRng.forFixture(preview.saveSeed, preview.fixture.id),
        subs: _subs,
      );
    });
  }

  Future<void> _openSubs(MatchPreview preview) async {
    final wasPlaying = _playing;
    if (_playing) _togglePlay();
    final xi = _currentXi(preview);
    final bench = _availableBench(preview);
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      isScrollControlled: true,
      builder: (_) => _SubSheet(
        onPitch: xi,
        bench: bench,
        onConfirm: (offId, on) {
          _applySub(preview, offId, on);
          Navigator.of(context).pop();
        },
      ),
    );
    if (wasPlaying && _minute < 90 && !_playing) _togglePlay();
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
          _result ??= preview.result;
          final r = _result!;
          if (!_started) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_started) _begin();
            });
          }

          final homeId = preview.homeTeam.nationId;
          final awayId = preview.awayTeam.nationId;
          String code(int id) => preview.nations[id]?.code ?? '??';
          String name(int id) => preview.nations[id]?.name ?? 'Unknown';

          final shown = r.events.where((e) => e.minute <= _minute).toList();
          final goals =
              shown.where((e) => e.type == MatchEventType.goal).toList();
          final homeScore =
              goals.where((e) => e.teamNationId == homeId).length;
          final awayScore = goals.length - homeScore;
          final ft = _minute >= 90;
          final subsLeft = kMaxSubs - _subs.length;

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
                  ),
                  if (!ft)
                    _Controls(
                      playing: _playing,
                      speed: _speeds[_speedIdx],
                      subsLeft: subsLeft,
                      onPlayPause: _togglePlay,
                      onSpeed: _cycleSpeed,
                      onSkip: _skip,
                      onSubs:
                          subsLeft > 0 && _availableBench(preview).isNotEmpty
                              ? () => _openSubs(preview)
                              : null,
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
                          home: preview.playerIsHome
                              ? _currentXi(preview)
                              : preview.homeTeam.xi,
                          away: preview.playerIsHome
                              ? preview.awayTeam.xi
                              : _currentXi(preview),
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
  });

  final String homeCode;
  final String awayCode;
  final String homeName;
  final String awayName;
  final int homeScore;
  final int awayScore;
  final String clock;
  final bool live;

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.playing,
    required this.speed,
    required this.subsLeft,
    required this.onPlayPause,
    required this.onSpeed,
    required this.onSkip,
    required this.onSubs,
  });

  final bool playing;
  final int speed;
  final int subsLeft;
  final VoidCallback onPlayPause;
  final VoidCallback onSpeed;
  final VoidCallback onSkip;
  final VoidCallback? onSubs;

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
          OutlinedButton.icon(
            onPressed: onSubs,
            icon: const Icon(Icons.swap_horiz, size: 18),
            label: Text('SUBS · $subsLeft', style: AppTypography.labelMedium),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.outlineVariant),
            ),
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
    required this.live,
    required this.homeId,
  });
  final List<MatchEvent> events;
  final bool live;
  final int homeId;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Text(
          live ? 'Kick-off!' : 'No events yet.',
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

/// One event on a two-sided timeline: home events sit on the left, away on the
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
            child: isHome ? _entry(alignEnd: true) : const SizedBox.shrink(),
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
            child: !isHome ? _entry(alignEnd: false) : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _entry({required bool alignEnd}) {
    final isGoal = event.type == MatchEventType.goal;
    final icon = Icon(
      isGoal ? Icons.sports_soccer : Icons.swap_horiz,
      size: 16,
      color: isGoal ? AppColors.primary : AppColors.onSurfaceVariant,
    );
    final label = isGoal
        ? event.playerName
        : '${event.playerName} ↔ ${event.secondaryName ?? ''}';
    final text = Flexible(
      child: Text(
        label,
        textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.bodyMedium.copyWith(
          color: isGoal ? AppColors.onSurface : AppColors.onSurfaceVariant,
        ),
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
            ? [text, const SizedBox(width: AppSpacing.sm), icon]
            : [icon, const SizedBox(width: AppSpacing.sm), text],
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

  final List<Player> home;
  final List<Player> away;
  final String homeCode;
  final String awayCode;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        _xi(homeCode, home),
        const SizedBox(height: AppSpacing.lg),
        _xi(awayCode, away),
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

/// Bottom sheet to make a substitution: pick the player coming off (from the
/// on-pitch XI), then the player coming on (from the bench).
class _SubSheet extends StatefulWidget {
  const _SubSheet({
    required this.onPitch,
    required this.bench,
    required this.onConfirm,
  });

  final List<Player> onPitch;
  final List<Player> bench;
  final void Function(int offId, Player on) onConfirm;

  @override
  State<_SubSheet> createState() => _SubSheetState();
}

class _SubSheetState extends State<_SubSheet> {
  int? _offId;

  @override
  Widget build(BuildContext context) {
    final off = _offId;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            off == null
                ? 'SUBSTITUTE — PLAYER OFF'
                : 'SUBSTITUTE — PLAYER ON',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Flexible(
            child: off == null
                ? ListView(
                    shrinkWrap: true,
                    children: [
                      for (final p in widget.onPitch)
                        _row(p, () => setState(() => _offId = p.id)),
                    ],
                  )
                : ListView(
                    shrinkWrap: true,
                    children: [
                      for (final p in widget.bench)
                        _row(p, () => widget.onConfirm(off, p)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _row(Player p, VoidCallback onTap) => ListTile(
        dense: true,
        onTap: onTap,
        leading: SizedBox(width: 40, child: TacticalChip(p.position.label)),
        title: Text(p.name, style: AppTypography.bodyMedium),
        subtitle: Text(
          p.position.roleName,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        trailing: Text('${p.overall}', style: AppTypography.labelMedium),
      );
}
