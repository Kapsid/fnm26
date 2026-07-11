import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/competition/finals.dart';
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

  /// True while the full-time result is being committed and the world is being
  /// simulated forward. Debug builds can take several seconds here, so the
  /// button must show a busy state rather than looking dead.
  bool _committing = false;

  /// The goal currently flashed on the "GOAL!" overlay (null when hidden).
  MatchEvent? _goalFlash;
  Timer? _flashTimer;

  @override
  void initState() {
    super.initState();
    // Restore the playback speed chosen in a previous match this session.
    _speedIdx = ref.read(matchSpeedProvider);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _flashTimer?.cancel();
    super.dispose();
  }

  void _begin() {
    _started = true;
    _restartTimer();
  }

  /// The base tick length for the current speed.
  Duration get _tick =>
      Duration(milliseconds: (360 / _speeds[_speedIdx]).round());

  /// How long the clock lingers on a goal so its popup is always seen — even at
  /// the fastest speed several goals can't blur past unnoticed.
  static const _goalPause = Duration(milliseconds: 1100);

  void _restartTimer() {
    _timer?.cancel();
    if (!_playing || _minute >= 90) return;
    _scheduleTick(_tick);
  }

  void _scheduleTick(Duration delay) {
    _timer = Timer(delay, () {
      if (!mounted || !_playing) return;
      var scored = false;
      setState(() {
        _minute++;
        scored = _flashGoalAt(_minute);
        if (_minute >= 90) {
          _minute = 90;
          _playing = false;
        }
      });
      if (!_playing || _minute >= 90) return;
      // Pause a beat on goals so the popup is fully seen before play resumes.
      _scheduleTick(scored ? _tick + _goalPause : _tick);
    });
  }

  /// Flashes the "GOAL!" overlay for a goal scored on [minute]; returns whether
  /// one was shown so the clock can linger on it.
  bool _flashGoalAt(int minute) {
    final events = _result?.events;
    if (events == null) return false;
    for (final e in events) {
      if (e.type == MatchEventType.goal && e.minute == minute) {
        _goalFlash = e;
        _flashTimer?.cancel();
        _flashTimer = Timer(_goalPause + const Duration(milliseconds: 700), () {
          if (mounted) setState(() => _goalFlash = null);
        });
        return true;
      }
    }
    return false;
  }

  static const _knockoutSuffixes = ['R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'];

  bool _isKnockoutFixture(Fixture f) {
    final r = f.round;
    return r != null && _knockoutSuffixes.any(r.endsWith);
  }

  /// The result to show at full time: the engine's score, with a level knockout
  /// settled by the same seeded shootout the season service will apply, so the
  /// displayed and recorded results always match.
  (int, int) _finalScore(MatchPreview preview, MatchResult r) {
    if (_isKnockoutFixture(preview.fixture) && r.homeScore == r.awayScore) {
      return WorldCupFinals.resolveTie(
        r.homeScore,
        r.awayScore,
        SeededRng.forFixture(preview.saveSeed, preview.fixture.id ^ 0x7F),
      );
    }
    return (r.homeScore, r.awayScore);
  }

  /// Home-team momentum (0–100) at the current minute: a strength baseline that
  /// swings toward whichever side scored recently (decaying over ~20 minutes).
  double _homeMomentum(MatchPreview preview, int homeId) {
    double avg(List<Player> xi) => xi.isEmpty
        ? 60
        : xi.fold<int>(0, (s, p) => s + p.overall) / xi.length;
    var m = 50 + (avg(preview.homeTeam.xi) - avg(preview.awayTeam.xi)) * 1.1;
    for (final e in _result?.events ?? const <MatchEvent>[]) {
      if (e.type != MatchEventType.goal || e.minute > _minute) continue;
      final age = _minute - e.minute;
      if (age > 20) continue;
      final swing = (20 - age) / 20 * 20;
      m += e.teamNationId == homeId ? swing : -swing;
    }
    return m.clamp(10, 90);
  }

  void _togglePlay() {
    setState(() => _playing = !_playing);
    _restartTimer();
  }

  void _cycleSpeed() {
    setState(() => _speedIdx = (_speedIdx + 1) % _speeds.length);
    // Remember the choice for the next match this session.
    ref.read(matchSpeedProvider.notifier).state = _speedIdx;
    if (_playing) _restartTimer();
  }

  void _skip() {
    _timer?.cancel();
    setState(() {
      _minute = 90;
      _playing = false;
    });
  }

  /// Commits the full-time result, simulates the world forward, and returns to
  /// the hub. Any failure is surfaced instead of being silently swallowed by
  /// the async callback (which would make the Continue button appear dead).
  Future<void> _continue(MatchPreview preview, MatchResult r) async {
    if (_committing) return;
    setState(() => _committing = true);
    try {
      await ref
          .read(seasonServiceProvider)
          .playPlayerMatch(widget.careerId, preview.fixture, r);
      if (mounted) {
        // Show the round's other results (grouped) before returning to the hub.
        context.go('${Routes.roundResults}?careerId=${widget.careerId}');
      }
    } catch (e, st) {
      debugPrint('Continue failed: $e\n$st');
      if (mounted) {
        setState(() => _committing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not continue: $e')),
        );
      }
    }
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
          final ft = _minute >= 90;
          // While playing, the score is the running tally of shown goal events.
          // At full time it is the true recorded result (a level knockout is
          // settled by a shootout), so the screen can never disagree with what
          // gets saved.
          final (finalHome, finalAway) = _finalScore(preview, r);
          final liveHome = shown
              .where((e) => e.type == MatchEventType.goal)
              .where((e) => e.teamNationId == homeId)
              .length;
          final liveAway = shown
                  .where((e) => e.type == MatchEventType.goal)
                  .length -
              liveHome;
          final homeScore = ft ? finalHome : liveHome;
          final awayScore = ft ? finalAway : liveAway;
          final decidedByShootout = ft &&
              _isKnockoutFixture(preview.fixture) &&
              r.homeScore == r.awayScore;
          final subsLeft = kMaxSubs - _subs.length;

          return DefaultTabController(
            length: 3,
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
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
                    clock: ft
                        ? (decidedByShootout ? 'FULL TIME · PENS' : 'FULL TIME')
                        : "$_minute'",
                    live: !ft,
                  ),
                  if (!ft)
                    _MomentumBar(
                      homePercent: _homeMomentum(preview, homeId),
                      homeCode: code(homeId),
                      awayCode: code(awayId),
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
                ],
              ),
                  if (_goalFlash != null)
                    _GoalFlash(
                      event: _goalFlash!,
                      isHome: _goalFlash!.teamNationId == homeId,
                    ),
                ],
              ),
            ),
          );
        },
      ),
      // The action button is pinned to the bottom of the screen so it is
      // always visible — it used to sit at the end of the column and could
      // overflow off the bottom on shorter screens.
      bottomNavigationBar: previewAsync.whenOrNull(
        data: (preview) {
          if (preview == null) return null;
          final ft = _minute >= 90;
          final r = _result ?? preview.result;
          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              child: PrimaryButton(
                label: ft
                    ? (_committing ? 'Continuing…' : 'Continue')
                    : 'Skip to full time',
                icon: ft ? Icons.check_rounded : Icons.fast_forward,
                onPressed: _committing
                    ? null
                    : ft
                    ? () => _continue(preview, r)
                    : _skip,
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
    final iconData = switch (event.type) {
      MatchEventType.goal => Icons.sports_soccer,
      MatchEventType.substitution => Icons.swap_horiz,
      MatchEventType.yellowCard ||
      MatchEventType.redCard =>
        Icons.square_rounded,
      MatchEventType.injury => Icons.medical_services,
    };
    final iconColor = switch (event.type) {
      MatchEventType.goal => AppColors.primary,
      MatchEventType.yellowCard => const Color(0xFFEFC94C),
      MatchEventType.redCard => const Color(0xFFD64545),
      _ => AppColors.onSurfaceVariant,
    };
    final icon = Icon(iconData, size: 16, color: iconColor);
    final label = switch (event.type) {
      MatchEventType.substitution =>
        '${event.playerName} ↔ ${event.secondaryName ?? ''}',
      _ => event.playerName,
    };
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

/// A live momentum bar: the home share of the track (left, primary) grows and
/// shrinks as the game swings, animated between minutes.
class _MomentumBar extends StatelessWidget {
  const _MomentumBar({
    required this.homePercent,
    required this.homeCode,
    required this.awayCode,
  });

  final double homePercent; // 0..100
  final String homeCode;
  final String awayCode;

  @override
  Widget build(BuildContext context) {
    final h = (homePercent / 100).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.marginMobile,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(homeCode, style: AppTypography.labelSmall),
              const SizedBox(width: AppSpacing.xs),
              const Text(
                'MOMENTUM',
                style: AppTypography.labelSmall,
              ),
              const Spacer(),
              Text(awayCode, style: AppTypography.labelSmall),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: SizedBox(
              height: 6,
              child: Stack(
                children: [
                  Container(color: AppColors.surfaceContainerHighest),
                  AnimatedFractionallySizedBox(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    widthFactor: h,
                    alignment: Alignment.centerLeft,
                    child: Container(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The animated "GOAL!" overlay shown briefly when a goal is scored.
class _GoalFlash extends StatelessWidget {
  const _GoalFlash({required this.event, required this.isHome});

  final MatchEvent event;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: TweenAnimationBuilder<double>(
            key: ValueKey('${event.minute}-${event.playerId}'),
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 320),
            curve: Curves.elasticOut,
            builder: (context, t, child) => Transform.scale(
              scale: 0.6 + t * 0.4,
              child: Opacity(opacity: t.clamp(0.0, 1.0), child: child),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: AppRadii.lgAll,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'GOAL!',
                    style: AppTypography.headlineLargeMobile.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(event.playerName, style: AppTypography.titleMedium),
                  Text(
                    "${event.minute}'",
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
