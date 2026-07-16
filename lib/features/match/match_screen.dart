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
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/achievements/achievement_popup.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
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
  static const _speeds = [1, 2, 3];
  static const _engine = MatchEngine();

  int _minute = 0;
  bool _playing = true;
  int _speedIdx = 0;
  bool _started = false;
  Timer? _timer;

  /// Live tactical changes the manager has made (shape / XI / instructions),
  /// each taking effect from its minute, and the result recomputed with them
  /// applied (null until the first preview is loaded).
  final List<TacticalChange> _changes = [];
  MatchResult? _result;

  /// The player's current tactical setup on the pitch, edited live and seeded
  /// from the preview's starting setup on first build ([_liveReady] guards the
  /// one-time seed).
  bool _liveReady = false;
  late Formation _liveFormation;
  late List<int?> _liveLineup;
  late TacticalInstructions _liveInstructions;

  /// True while the full-time result is being committed and the world is being
  /// simulated forward. Debug builds can take several seconds here, so the
  /// button must show a busy state rather than looking dead.
  bool _committing = false;

  /// The goal currently flashed on the "GOAL!" overlay (null when hidden).
  MatchEvent? _goalFlash;
  Timer? _flashTimer;

  /// The player's nation id (seeded with the live setup), used to spot an
  /// injury to one of the manager's own players as the clock reaches it.
  int? _playerNationId;

  /// An injury to one of the manager's players that has just occurred and is
  /// awaiting the manager's decision (substitute or play on). Playback pauses
  /// while this is set and an interactive overlay is shown. Cleared once
  /// handled; [_injuriesPrompted] remembers which injuries were offered so a
  /// paused-and-resumed clock never re-prompts the same one.
  MatchEvent? _pendingInjury;
  final Set<int> _injuriesPrompted = {};

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
      // An injury to one of the manager's players pauses play for a decision.
      if (_checkInjuryAt(_minute)) return;
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

  /// Pauses playback and raises the injury overlay if one of the manager's own
  /// players is hurt on [minute] (once each). Returns whether play paused.
  bool _checkInjuryAt(int minute) {
    if (_pendingInjury != null || _playerNationId == null) return false;
    final events = _result?.events;
    if (events == null) return false;
    for (final e in events) {
      if (e.type == MatchEventType.injury &&
          e.minute == minute &&
          e.teamNationId == _playerNationId &&
          !_injuriesPrompted.contains(e.playerId)) {
        _injuriesPrompted.add(e.playerId);
        _timer?.cancel();
        setState(() {
          _playing = false;
          _pendingInjury = e;
        });
        return true;
      }
    }
    return false;
  }

  /// Dismisses the injury overlay and resumes play, leaving the XI unchanged
  /// (the manager chose to play on with the hurt player).
  void _playOnInjured() {
    setState(() {
      _pendingInjury = null;
      _playing = true;
    });
    _restartTimer();
  }

  /// Dismisses the injury overlay and opens the tactics editor so the manager
  /// can bring on a replacement; play stays paused until they close it.
  Future<void> _substituteInjured(MatchPreview preview) async {
    setState(() => _pendingInjury = null);
    await _openTactics(preview);
    // If the manager left the match paused, resume it for them.
    if (mounted && !_playing && _minute < 90) _togglePlay();
  }

  bool _isKnockoutFixture(Fixture f) => Rounds.isKnockout(f.round);

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

  /// Home-team momentum (0–100) at the current minute: a strength baseline over
  /// which pressure *builds toward* the side about to score in the minutes
  /// before the goal, peaks as it goes in, then fades away afterwards — the way
  /// a real momentum needle leans into a goal rather than jumping after it.
  double _homeMomentum(MatchPreview preview, int homeId) {
    double avg(List<Player> xi) => xi.isEmpty
        ? 60
        : xi.fold<int>(0, (s, p) => s + p.overall) / xi.length;
    var m = 50 + (avg(preview.homeTeam.xi) - avg(preview.awayTeam.xi)) * 1.1;
    const build = 6.0; // minutes of pressure rising before the goal
    const fade = 16.0; // minutes it fades over afterwards
    const peak = 22.0;
    for (final e in _result?.events ?? const <MatchEvent>[]) {
      if (e.type != MatchEventType.goal) continue;
      final g = e.minute;
      if (_minute < g - build || _minute > g + fade) continue;
      final swing = _minute <= g
          ? (build - (g - _minute)) / build * peak // 0 → peak approaching goal
          : (fade - (_minute - g)) / fade * peak; // peak → 0 after the goal
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
      // Celebrate any achievements this match just unlocked before moving on.
      final unlocked = await ref
          .read(achievementServiceProvider)
          .checkAndRecord(widget.careerId);
      if (mounted) await showAchievementsUnlocked(context, unlocked);
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

  /// The player's team as it started (the fixed engine input; live edits are
  /// carried by [_changes], not by mutating this).
  MatchTeam _playerTeam(MatchPreview preview) =>
      preview.playerIsHome ? preview.homeTeam : preview.awayTeam;

  /// Every player the manager can field: the starting XI plus the bench.
  List<Player> _playerPool(MatchPreview preview) =>
      [..._playerTeam(preview).xi, ...preview.bench];

  /// Seeds the live tactical setup from the preview's starting setup, once.
  void _ensureLiveSetup(MatchPreview preview) {
    if (_liveReady) return;
    final team = _playerTeam(preview);
    _liveFormation = team.formation;
    _liveLineup = team.xi.map((p) => p.id as int?).toList();
    _liveInstructions = team.instructions;
    _playerNationId = preview.playerNationId;
    _liveReady = true;
  }

  /// The player's on-pitch XI now (their live lineup resolved to players).
  List<Player> _currentXi(MatchPreview preview) {
    final byId = {for (final p in _playerPool(preview)) p.id: p};
    return _liveLineup
        .whereType<int>()
        .map((id) => byId[id])
        .whereType<Player>()
        .toList();
  }

  /// How many substitutions the live lineup has spent (starters no longer on).
  int _subsUsed(MatchPreview preview) {
    final on = _liveLineup.whereType<int>().toSet();
    return _playerTeam(preview).xi.where((p) => !on.contains(p.id)).length;
  }

  /// Opens the full in-match tactics editor and, if the manager confirms,
  /// records the change and re-simulates the rest of the match with it applied.
  Future<void> _openTactics(MatchPreview preview) async {
    final wasPlaying = _playing;
    if (_playing) _togglePlay();
    final team = _playerTeam(preview);
    final result = await showInMatchTactics(
      context,
      minute: _minute.clamp(1, 90),
      formation: _liveFormation,
      lineup: _liveLineup,
      instructions: _liveInstructions,
      pool: _playerPool(preview),
      startingIds: team.xi.map((p) => p.id).toSet(),
      maxSubs: kMaxSubs,
    );
    if (result != null && mounted) _applyTactics(preview, result);
    if (wasPlaying && _minute < 90 && !_playing) _togglePlay();
  }

  void _applyTactics(MatchPreview preview, InMatchTacticsResult r) {
    final byId = {for (final p in _playerPool(preview)) p.id: p};
    final xi = r.lineup
        .whereType<int>()
        .map((id) => byId[id])
        .whereType<Player>()
        .toList();
    final minute = _minute.clamp(1, 90);
    setState(() {
      _liveFormation = r.formation;
      _liveLineup = r.lineup;
      _liveInstructions = r.instructions;
      _changes.add(
        TacticalChange(
          teamNationId: preview.playerNationId,
          minute: minute,
          formation: r.formation,
          instructions: r.instructions,
          xi: xi,
        ),
      );
      _result = _engine.play(
        home: preview.homeTeam,
        away: preview.awayTeam,
        rng: SeededRng.forFixture(preview.saveSeed, preview.fixture.id),
        subs: preview.opponentSubs,
        changes: _changes,
        injuryFactorByNation: preview.injuryFactorByNation,
      );
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
          _result ??= preview.result;
          _ensureLiveSetup(preview);
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

          return DefaultTabController(
            length: 3,
            // Jump to the Stats tab (player ratings, MOTM) at full time; the
            // key recreates the controller so the switch takes effect.
            initialIndex: ft ? 1 : 0,
            key: ValueKey(ft),
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
                            homeNationId: homeId,
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
                          homeSubs: shown
                              .where(
                                (e) =>
                                    e.type == MatchEventType.substitution &&
                                    e.teamNationId == homeId,
                              )
                              .toList(),
                          awaySubs: shown
                              .where(
                                (e) =>
                                    e.type == MatchEventType.substitution &&
                                    e.teamNationId == awayId,
                              )
                              .toList(),
                          ratings: ft
                              ? {
                                  for (final x in r.ratings)
                                    x.playerId: x.rating,
                                }
                              : const {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
                  if (_goalFlash != null)
                    _GoalFlash(
                      event: _goalFlash!,
                      flagCode: code(_goalFlash!.teamNationId),
                    ),
                  if (_pendingInjury != null)
                    _InjuryPrompt(
                      event: _pendingInjury!,
                      subsUsed: _subsUsed(preview),
                      onSubstitute: () => _substituteInjured(preview),
                      onPlayOn: _playOnInjured,
                    ),
                ],
              ),
            ),
          );
        },
      ),
      // A single pinned bottom bar: the live transport/tactics controls while
      // the match plays, and the full-time Continue action once it ends. Pinned
      // here so it is always visible and never overflows on shorter screens.
      bottomNavigationBar: previewAsync.whenOrNull(
        data: (preview) {
          if (preview == null) return null;
          final ft = _minute >= 90;
          final r = _result ?? preview.result;
          final bar = ft
              ? Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: PrimaryButton(
                    label: _committing ? 'Continuing…' : 'Continue',
                    icon: Icons.check_rounded,
                    onPressed:
                        _committing ? null : () => _continue(preview, r),
                  ),
                )
              : _MatchControlBar(
                  playing: _playing,
                  speed: _speeds[_speedIdx],
                  subsUsed: _subsUsed(preview),
                  onPlayPause: _togglePlay,
                  onSpeed: _cycleSpeed,
                  onSkip: _skip,
                  onTactics: () => _openTactics(preview),
                );
          return DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              border: Border(
                top: BorderSide(color: AppColors.outlineVariant),
              ),
            ),
            child: SafeArea(top: false, child: bar),
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

/// The live match control bar pinned to the bottom of the screen: a prominent
/// play/pause transport on the left, then speed, tactics (with the subs count)
/// and skip-to-full-time as matching pill buttons.
class _MatchControlBar extends StatelessWidget {
  const _MatchControlBar({
    required this.playing,
    required this.speed,
    required this.subsUsed,
    required this.onPlayPause,
    required this.onSpeed,
    required this.onSkip,
    required this.onTactics,
  });

  final bool playing;
  final int speed;
  final int subsUsed;
  final VoidCallback onPlayPause;
  final VoidCallback onSpeed;
  final VoidCallback onSkip;
  final VoidCallback onTactics;

  static const double _height = 52;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.marginMobile,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // The primary transport control, sized and coloured to stand out.
          SizedBox(
            width: _height,
            height: _height,
            child: IconButton.filled(
              iconSize: 30,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
              ),
              icon: Icon(
                playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
              onPressed: onPlayPause,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _PillButton(
            onTap: onSpeed,
            child: Text(
              '$speed×',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _PillButton(
            expand: true,
            onTap: onTactics,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.tune, size: 18, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    'TACTICS · $subsUsed/$kMaxSubs',
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _PillButton(
            onTap: onSkip,
            tooltip: 'Skip to full time',
            child: const Icon(
              Icons.skip_next_rounded,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// A rounded, outlined pill button used across the match control bar so every
/// secondary control shares one look and tap-target height.
class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.onTap,
    required this.child,
    this.expand = false,
    this.tooltip,
  });

  final VoidCallback onTap;
  final Widget child;
  final bool expand;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    Widget button = Material(
      color: AppColors.surfaceContainerHighest,
      borderRadius: AppRadii.mdAll,
      child: InkWell(
        borderRadius: AppRadii.mdAll,
        onTap: onTap,
        child: Container(
          height: _MatchControlBar._height,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppRadii.mdAll,
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: child,
        ),
      ),
    );
    final tip = tooltip;
    if (tip != null) button = Tooltip(message: tip, child: button);
    return expand ? Expanded(child: button) : button;
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
    // Substitutions are shown on the Lineups tab, not in the event feed.
    final visible = events
        .where((e) => e.type != MatchEventType.substitution)
        .toList();
    if (visible.isEmpty) {
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
    final reversed = visible.reversed.toList();
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
        '${_abbrevName(event.playerName)} ↔ '
            '${_abbrevName(event.secondaryName ?? '')}',
      MatchEventType.goal when event.penalty =>
        '${_abbrevName(event.playerName)} (pen)',
      _ => _abbrevName(event.playerName),
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

/// "Adam Test" → "A. Test" for the compact match timeline; single names and
/// blanks pass through unchanged.
String _abbrevName(String full) {
  final parts = full.trim().split(RegExp(r'\s+'));
  if (parts.length < 2 || parts.first.isEmpty) return full;
  return '${parts.first[0]}. ${parts.last}';
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
    required this.homeNationId,
  });
  final MatchResult result;
  final String homeCode;
  final String awayCode;
  final int homeNationId;

  @override
  Widget build(BuildContext context) {
    final motm = result.manOfTheMatch;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        if (motm != null) ...[
          _MotmCard(
            name: motm.playerName,
            rating: motm.rating,
            teamCode:
                motm.teamNationId == homeNationId ? homeCode : awayCode,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
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
        if (result.ratings.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            'PLAYER RATINGS',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ratingsBlock(homeCode, homeNationId),
          const SizedBox(height: AppSpacing.md),
          _ratingsBlock(awayCode, null),
        ],
      ],
    );
  }

  /// A team's players and their match marks, best first. [teamId] is the home
  /// nation id for the home block, or null for the away block.
  Widget _ratingsBlock(String teamCode, int? teamId) {
    final players = [
      for (final r in result.ratings)
        if ((r.teamNationId == homeNationId) == (teamId != null)) r,
    ]..sort((a, b) => b.rating.compareTo(a.rating));
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            teamCode,
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final r in players)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      r.playerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                  _RatingPill(r.rating),
                ],
              ),
            ),
        ],
      ),
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
    this.homeSubs = const [],
    this.awaySubs = const [],
    this.ratings = const {},
  });

  final List<Player> home;
  final List<Player> away;
  final String homeCode;
  final String awayCode;

  /// Substitutions made by each side (off ↔ on), shown under its XI.
  final List<MatchEvent> homeSubs;
  final List<MatchEvent> awaySubs;

  /// Per-player match ratings, keyed by player id. Empty until full time.
  final Map<int, double> ratings;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        _xi(homeCode, home, homeSubs),
        const SizedBox(height: AppSpacing.lg),
        _xi(awayCode, away, awaySubs),
      ],
    );
  }

  Widget _xi(String teamCode, List<Player> xi, List<MatchEvent> subs) {
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
                if (ratings[p.id] case final r?) ...[
                  _RatingPill(r),
                  const SizedBox(width: AppSpacing.sm),
                ],
                SizedBox(
                  width: 20,
                  child: Text(
                    '${p.overall}',
                    textAlign: TextAlign.end,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (subs.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            'SUBSTITUTIONS',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final s in subs)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(
                      "${s.minute}'",
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.swap_horiz,
                    size: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // playerName is the player coming on, secondaryName the one
                  // going off (see MatchEvent docs).
                  Expanded(
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: AppTypography.bodySmall,
                        children: [
                          const TextSpan(
                            text: '▲ ',
                            style: TextStyle(color: AppColors.positive),
                          ),
                          TextSpan(text: s.playerName),
                          const TextSpan(text: '   '),
                          const TextSpan(
                            text: '▼ ',
                            style: TextStyle(color: AppColors.error),
                          ),
                          TextSpan(
                            text: s.secondaryName ?? '—',
                            style: const TextStyle(
                              color: AppColors.onSurfaceVariant,
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
      ],
    );
  }
}

/// A coloured match-rating badge: green for a strong game, red for a poor one.
class _RatingPill extends StatelessWidget {
  const _RatingPill(this.rating);

  final double rating;

  static Color colorFor(double r) {
    if (r >= 7.5) return const Color(0xFF2E9E5B);
    if (r >= 6.5) return const Color(0xFF4C86C6);
    if (r >= 5.5) return AppColors.onSurfaceVariant;
    return const Color(0xFFD64545);
  }

  @override
  Widget build(BuildContext context) {
    final color = colorFor(rating);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: AppRadii.smAll,
      ),
      child: Text(
        rating.toStringAsFixed(1),
        style: AppTypography.labelMedium.copyWith(
          color: color,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

/// A "player of the match" highlight card shown on the full-time stats tab.
class _MotmCard extends StatelessWidget {
  const _MotmCard({
    required this.name,
    required this.rating,
    required this.teamCode,
  });

  final String name;
  final double rating;
  final String teamCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: AppRadii.mdAll,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: AppColors.primary, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PLAYER OF THE MATCH',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$name · $teamCode',
                  style: AppTypography.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _RatingPill(rating),
        ],
      ),
    );
  }
}

/// A live momentum bar: a bold two-sided track where the home share (left,
/// primary) pushes against the away share (right, positive). The split, the
/// percentages and the pointer at the boundary all glide as the game swings.
class _MomentumBar extends StatelessWidget {
  const _MomentumBar({
    required this.homePercent,
    required this.homeCode,
    required this.awayCode,
  });

  final double homePercent; // 0..100
  final String homeCode;
  final String awayCode;

  static const Color _homeColor = AppColors.primary;
  static const Color _awayColor = AppColors.positive;
  static const _duration = Duration(milliseconds: 450);
  static const Curve _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final h = (homePercent / 100).clamp(0.0, 1.0);
    final homePct = homePercent.round();
    final leaningHome = h >= 0.5;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.marginMobile,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                homeCode,
                style: AppTypography.labelMedium.copyWith(color: _homeColor),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '$homePct%',
                style: AppTypography.labelMedium.copyWith(
                  color: leaningHome ? _homeColor : AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              const Text('MOMENTUM', style: AppTypography.labelSmall),
              const Spacer(),
              Text(
                '${100 - homePct}%',
                style: AppTypography.labelMedium.copyWith(
                  color: leaningHome ? AppColors.onSurfaceVariant : _awayColor,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                awayCode,
                style: AppTypography.labelMedium.copyWith(color: _awayColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: SizedBox(
              height: 16,
              child: Stack(
                children: [
                  // Away side fills the whole track; the home fill overlays it
                  // from the left, so the boundary is where momentum sits.
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0x33000000), _awayColor],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: AnimatedFractionallySizedBox(
                      duration: _duration,
                      curve: _curve,
                      widthFactor: h,
                      alignment: Alignment.centerLeft,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_homeColor, Color(0x33000000)],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // A bright pointer that rides the boundary between the sides.
                  Positioned.fill(
                    child: AnimatedAlign(
                      duration: _duration,
                      curve: _curve,
                      alignment: Alignment(h * 2 - 1, 0),
                      child: Container(
                        width: 3,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.onSurface,
                          borderRadius: AppRadii.smAll,
                          boxShadow: [
                            BoxShadow(
                              color: (leaningHome ? _homeColor : _awayColor)
                                  .withValues(alpha: 0.8),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
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
  const _GoalFlash({required this.event, required this.flagCode});

  final MatchEvent event;

  /// FIFA code of the team that scored, so the popup shows their flag.
  final String flagCode;

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
                  FlagDisc(flagCode, size: 44),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'GOAL!',
                    style: AppTypography.headlineLargeMobile.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(event.playerName, style: AppTypography.titleMedium),
                  Text(
                    event.penalty
                        ? "PENALTY · ${event.minute}'"
                        : "${event.minute}'",
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

/// A blocking overlay shown when one of the manager's players is injured: the
/// clock is paused and the manager must decide whether to bring on a
/// replacement or play on. Dimmed scrim intercepts taps behind it.
class _InjuryPrompt extends StatelessWidget {
  const _InjuryPrompt({
    required this.event,
    required this.subsUsed,
    required this.onSubstitute,
    required this.onPlayOn,
  });

  final MatchEvent event;
  final int subsUsed;
  final VoidCallback onSubstitute;
  final VoidCallback onPlayOn;

  @override
  Widget build(BuildContext context) {
    final subsLeft = kMaxSubs - subsUsed;
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black54,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.xl),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: AppRadii.lgAll,
              border: Border.all(color: AppColors.warning, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.medical_services_rounded,
                  color: AppColors.warning,
                  size: 40,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'INJURY',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(event.playerName, style: AppTypography.titleMedium),
                Text(
                  "is down injured · ${event.minute}'",
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (subsLeft > 0)
                  PrimaryButton(
                    label: 'Substitute',
                    icon: Icons.swap_horiz_rounded,
                    onPressed: onSubstitute,
                  )
                else
                  Text(
                    'No substitutions remaining',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: onPlayOn,
                  child: Text(
                    'Play on',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
