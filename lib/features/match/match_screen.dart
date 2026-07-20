import 'dart:async';
import 'dart:math' as math;

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
import 'package:fnm/features/match/match_feedback.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart' show energyColor;
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The maximum substitutions a manager may make in a match.
const int kMaxSubs = 5;

/// The localised button label for a team-talk [tone]. The engine owns the tone's
/// gameplay effect; its display text lives here so it can be translated.
String teamTalkLabel(AppLocalizations l10n, TeamTalkTone tone) => switch (tone) {
      TeamTalkTone.calm => l10n.teamTalkCalmLabel,
      TeamTalkTone.encourage => l10n.teamTalkEncourageLabel,
      TeamTalkTone.demandMore => l10n.teamTalkDemandMoreLabel,
      TeamTalkTone.praise => l10n.teamTalkPraiseLabel,
    };

/// The localised one-line description of what a team-talk [tone] asks for.
String teamTalkBlurb(AppLocalizations l10n, TeamTalkTone tone) => switch (tone) {
      TeamTalkTone.calm => l10n.teamTalkCalmBlurb,
      TeamTalkTone.encourage => l10n.teamTalkEncourageBlurb,
      TeamTalkTone.demandMore => l10n.teamTalkDemandMoreBlurb,
      TeamTalkTone.praise => l10n.teamTalkPraiseBlurb,
    };

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

  /// Team talks the manager has given (at the interval), each shifting the
  /// side's edge for the rest of the match; folded into every re-sim.
  final List<TeamTalk> _talks = [];

  /// The tone chosen at the interval, so the half-time card can show it as
  /// selected once given (a talk is a one-shot per interval).
  TeamTalkTone? _halfTimeTalk;
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

  /// The manager's players who have been hurt this match and not yet replaced.
  /// Play does NOT stop for an injury — instead the hurt player is flagged in
  /// the squad (a quick toast points it out) so the manager subs them when they
  /// choose. [_injuriesPrompted] remembers which we've already toasted so a
  /// paused-and-resumed clock never re-notifies the same one.
  final Set<int> _injuredIds = {};
  final Set<int> _injuriesPrompted = {};

  /// The latest loaded preview, stashed so timer callbacks (e.g. an injury
  /// opening the squad) can reach it without a build context.
  MatchPreview? _livePreview;

  /// Whether play is paused at the half-time interval, awaiting the manager's
  /// "continue" (they may reshape the side before the second half). Shown once
  /// per match ([_halfTimeTaken] guards a paused-and-resumed clock).
  bool _atHalfTime = false;
  bool _halfTimeTaken = false;

  // --- Live extra time / penalties -----------------------------------------
  // A level knockout plays on: the clock runs to 120 (extra time) and, if still
  // level, a shootout is revealed kick by kick — rather than the result just
  // popping up at 90'.

  /// The minute the clock runs to: 90 normally, 120 for a level knockout.
  int _fullTimeMinute = 90;

  /// Second-half stoppage time (added minutes after 90), from the engine result.
  /// The clock plays these out as "90+1", "90+2", … before full time or extra
  /// time, so a goal snatched in added time is seen going in.
  int _stoppage = 0;

  /// How many stoppage minutes have been revealed so far (0.._stoppage). Only
  /// meaningful while the clock sits at 90.
  int _added = 0;

  /// The precomputed extra-time / shootout outcome for a level knockout.
  KnockoutOutcome? _koOutcome;

  /// Guards the one-time knockout setup.
  bool _koSetup = false;

  /// Synthesised extra-time goals (minute, scoring nation) so the score builds
  /// across 91–120 rather than jumping.
  List<(int, int)> _etGoals = const [];

  /// The same extra-time goals as timeline events (with a plausible scorer) so
  /// they show in the TIMELINE, not only on the scoreboard.
  List<MatchEvent> _etEvents = const [];

  /// How many shootout kicks have been revealed so far.
  int _penRevealed = 0;
  Timer? _penTimer;

  bool get _isShootout => _koOutcome?.wentToShootout ?? false;
  int get _penTotal =>
      (_koOutcome?.homeKicks.length ?? 0) + (_koOutcome?.awayKicks.length ?? 0);

  /// The knockout finish (ET/shootout) is fully played out.
  bool get _knockoutDone => !_isShootout || _penRevealed >= _penTotal;

  /// The playing clock has run out: past the last minute, and — while still in
  /// regulation (minute 90) — through all the stoppage minutes too. Extra time
  /// (minute > 90) carries no added time here, so it ends at [_fullTimeMinute].
  bool get _clockDone =>
      _minute >= _fullTimeMinute && (_minute > 90 || _added >= _stoppage);

  /// True once the match is truly over (regulation + stoppage, extra time, or
  /// the shootout reveal has finished) — drives the full-time UI.
  bool get _fullTime => _clockDone && _knockoutDone;

  /// Whether an event has been reached by the current clock position, honouring
  /// added time: a 90+3 event only shows once the stoppage clock passes +3.
  bool _reached(MatchEvent e) {
    if (e.minute != _minute) return e.minute < _minute;
    return e.stoppage <= _added; // same minute — gate stoppage by +X revealed
  }

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
    _penTimer?.cancel();
    super.dispose();
  }

  /// Prepares the extra-time / shootout sequence for a level knockout. The 90'
  /// result can still change with live tactics, so this recomputes each build
  /// through regulation and LOCKS once the clock reaches 90' (from then on the
  /// ET/shootout is fixed and plays out).
  void _ensureKnockoutSetup(MatchPreview preview, MatchResult r) {
    if (_minute >= 90 && _koSetup) return; // locked once ET/shootout begins
    _koSetup = true;
    final level =
        _isKnockoutFixture(preview.fixture) && r.homeScore == r.awayScore;
    if (!level) {
      _fullTimeMinute = 90;
      _koOutcome = null;
      _etGoals = const [];
      _etEvents = const [];
      return;
    }
    final o = _knockoutOutcome(preview, r);
    if (o == null) {
      _fullTimeMinute = 90;
      _koOutcome = null;
      _etGoals = const [];
      _etEvents = const [];
      return;
    }
    _koOutcome = o;
    _fullTimeMinute = 120;
    final etHome = o.homeScore - r.homeScore;
    final etAway = o.awayScore - r.awayScore;
    const homeMins = [96, 105, 113, 119];
    const awayMins = [100, 108, 116, 120];
    _etGoals = <(int, int)>[
      for (var i = 0; i < etHome && i < homeMins.length; i++)
        (homeMins[i], preview.homeTeam.nationId),
      for (var i = 0; i < etAway && i < awayMins.length; i++)
        (awayMins[i], preview.awayTeam.nationId),
    ]..sort((a, b) => a.$1.compareTo(b.$1));

    // Attribute each ET goal to a plausible scorer (the side's sharpest
    // finishers, rotating) so it appears in the timeline like any other goal.
    List<Player> finishers(List<Player> xi) => [
          for (final p in xi)
            if (p.position.category != PositionCategory.goalkeeper) p,
        ]..sort((a, b) => b.attributes.shooting.compareTo(a.attributes.shooting));
    final homeFin = finishers(
      preview.playerIsHome ? _currentXi(preview) : preview.homeTeam.xi,
    );
    final awayFin = finishers(
      preview.playerIsHome ? preview.awayTeam.xi : _currentXi(preview),
    );
    var hi = 0;
    var ai = 0;
    _etEvents = [
      for (final g in _etGoals)
        () {
          final home = g.$2 == preview.homeTeam.nationId;
          final pool = home ? homeFin : awayFin;
          final scorer = pool.isEmpty
              ? null
              : pool[(home ? hi++ : ai++) % pool.length];
          return MatchEvent(
            minute: g.$1,
            type: MatchEventType.goal,
            teamNationId: g.$2,
            playerId: scorer?.id ?? 0,
            playerName: scorer?.name ?? '',
          );
        }(),
    ];
  }

  /// Starts revealing the shootout kicks one at a time.
  void _startShootout() {
    if (_penTimer != null) return;
    _penTimer = Timer.periodic(const Duration(milliseconds: 750), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _penRevealed++);
      if (_penRevealed >= _penTotal) t.cancel();
    });
  }

  void _begin() {
    _started = true;
    MatchFeedback.kickoff(ref.read(soundHapticsEnabledProvider));
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
    if (!_playing || _clockDone) return;
    _scheduleTick(_tick);
  }

  void _scheduleTick(Duration delay) {
    _timer = Timer(delay, () {
      if (!mounted || !_playing) return;
      var scored = false;
      var tickStoppage = 0;
      setState(() {
        if (_minute < 90) {
          // Normal play.
          _minute++;
          scored = _flashGoalAt(_minute, 0);
        } else if (_added < _stoppage) {
          // Second-half stoppage: the clock holds at 90 and counts +1, +2, …
          _added++;
          tickStoppage = _added;
          scored = _flashGoalAt(90, _added);
        } else if (_minute < _fullTimeMinute) {
          // Extra time (a level knockout) resumes after stoppage.
          _minute++;
          scored = _flashGoalAt(_minute, 0);
        }
        if (_clockDone) {
          _playing = false;
          MatchFeedback.fullTime(ref.read(soundHapticsEnabledProvider));
          // A level knockout that reached the shootout now reveals its kicks.
          if (_isShootout) _startShootout();
        }
      });
      // An injury opens the squad (paused) with the hurt player flagged — play
      // resumes when the manager is done, whether or not they made a sub.
      _checkInjuryAt(_minute, tickStoppage);
      // Half-time: the whistle stops play until the manager continues.
      if (_checkHalfTime()) return;
      if (!_playing || _clockDone) return;
      // A goal genuinely pauses the clock: the flash timer resumes play once
      // the popup has cleared, so the game never ticks on under the overlay.
      if (scored) return;
      _scheduleTick(_tick);
    });
  }

  /// Flashes the "GOAL!" overlay for a goal scored on [minute] and pauses the
  /// clock until it clears; returns whether one was shown so the tick loop
  /// hands the resume to the flash timer.
  bool _flashGoalAt(int minute, int stoppage) {
    // Include the synthesised extra-time goals so an ET goal flashes "GOAL!" and
    // pauses the clock just like a regulation one — otherwise ET ticks by
    // silently and looks like nothing is happening. Stoppage goals (90+X) match
    // on the added-time index too, so they flash on their exact "90+X" tick.
    final events = [...?_result?.events, ..._etEvents];
    for (final e in events) {
      if (e.type == MatchEventType.goal &&
          e.minute == minute &&
          e.stoppage == stoppage) {
        _goalFlash = e;
        MatchFeedback.goal(ref.read(soundHapticsEnabledProvider));
        _flashTimer?.cancel();
        _flashTimer = Timer(_goalPause + const Duration(milliseconds: 700), () {
          if (!mounted) return;
          setState(() => _goalFlash = null);
          // Resume only if nothing else has taken over the clock (half-time in
          // the same minute, a manual pause, or full time) — those paths own
          // their own resume. Injuries no longer pause play.
          if (_playing && !_clockDone && !_atHalfTime) {
            _restartTimer();
          }
        });
        return true;
      }
    }
    return false;
  }

  /// Pauses playback and raises the injury overlay if one of the manager's own
  /// players is hurt on [minute] (once each). Returns whether play paused.
  void _checkInjuryAt(int minute, int stoppage) {
    if (_playerNationId == null) return;
    final events = _result?.events;
    if (events == null) return;
    for (final e in events) {
      if (e.type == MatchEventType.injury &&
          e.minute == minute &&
          e.stoppage == stoppage &&
          e.teamNationId == _playerNationId &&
          !_injuriesPrompted.contains(e.playerId)) {
        _injuriesPrompted.add(e.playerId);
        _timer?.cancel();
        // No pop-up: pause and open the squad straight away, with the hurt
        // player flagged on the pitch so the manager sees exactly who to replace.
        setState(() {
          _injuredIds.add(e.playerId);
          _playing = false;
        });
        final preview = _livePreview;
        if (preview != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _handleInjury(preview);
          });
        }
        return; // one injury at a time
      }
    }
  }

  /// Opens the squad on an injury (already paused) and resumes play once the
  /// manager is done — whether they made the sub or not.
  Future<void> _handleInjury(MatchPreview preview) async {
    await _openTactics(preview);
    if (mounted && !_playing && !_clockDone && !_atHalfTime) {
      _togglePlay();
    }
  }

  /// Pauses at the half-time whistle (once per match). Returns whether play
  /// paused. Guarded so a paused-and-resumed clock never re-triggers, and keyed
  /// on `>= 45` so a tick that jumps past the 45th minute still catches it.
  bool _checkHalfTime() {
    if (_halfTimeTaken || _minute < 45 || _minute >= 90) return false;
    _halfTimeTaken = true;
    _timer?.cancel();
    setState(() {
      _playing = false;
      _atHalfTime = true;
    });
    return true;
  }

  /// Dismisses the half-time overlay and kicks off the second half.
  void _resumeFromHalfTime() {
    setState(() {
      _atHalfTime = false;
      _playing = true;
    });
    _restartTimer();
  }

  /// Dismisses the injury overlay and resumes play a man down (only offered
  /// when no substitution can be made — subs spent or an empty bench).
  bool _isKnockoutFixture(Fixture f) => Rounds.isKnockout(f.round);

  /// The extra-time-and-shootout outcome of a level knockout, or null when the
  /// tie was decided in 90 minutes (or isn't a knockout). Built from the same
  /// seed the season service uses, so the drama shown here and the stored
  /// result never disagree.
  KnockoutOutcome? _knockoutOutcome(MatchPreview preview, MatchResult r) {
    if (!_isKnockoutFixture(preview.fixture) || r.homeScore != r.awayScore) {
      return null;
    }
    return WorldCupFinals.decideKnockout(
      r.homeScore,
      r.awayScore,
      SeededRng.forFixture(preview.saveSeed, preview.fixture.id ^ 0x7F),
    );
  }

  /// The result to show at full time: the engine's score, with a level knockout
  /// settled by extra time / a shootout — matching what the season service
  /// records (see [WorldCupFinals.resolveTie]).
  (int, int) _finalScore(MatchPreview preview, MatchResult r) {
    final o = _knockoutOutcome(preview, r);
    if (o == null) return (r.homeScore, r.awayScore);
    if (!o.wentToShootout) return (o.homeScore, o.awayScore);
    return o.homeWon
        ? (o.homeScore + 1, o.awayScore)
        : (o.homeScore, o.awayScore + 1);
  }

  /// Home-team momentum (0–100) at the current minute: a strength baseline over
  /// which pressure *builds toward* the side about to score in the minutes
  /// before the goal, peaks as it goes in, then fades away afterwards — the way
  /// a real momentum needle leans into a goal rather than jumping after it.
  double _homeMomentum(MatchPreview preview, int homeId) {
    double avg(List<Player> xi) => xi.isEmpty
        ? 60
        : xi.fold<int>(0, (s, p) => s + p.overall) / xi.length;
    final baseline =
        50 + (avg(preview.homeTeam.xi) - avg(preview.awayTeam.xi)) * 1.1;
    var m = baseline;
    // A gentle ebb and flow so the needle always breathes through a goalless
    // spell rather than freezing on the baseline. Deterministic on the minute
    // (two out-of-phase waves) so it's stable across rebuilds, and it leans
    // toward whichever side is stronger.
    final lean = (baseline - 50) / 40; // −1…1, the stronger side's tilt
    final wobble = 9 * math.sin(_minute * 0.5 + homeId % 5) +
        5 * math.sin(_minute * 0.23 + 1.7) +
        6 * lean * math.sin(_minute * 0.11);
    m += wobble;
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
    return m.clamp(8, 92);
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
    _penTimer?.cancel();
    setState(() {
      // Jump straight to the result, revealing any stoppage / extra time /
      // shootout at once rather than playing the drama out.
      _minute = _fullTimeMinute;
      _added = _stoppage;
      _playing = false;
      _penRevealed = _penTotal;
    });
    MatchFeedback.fullTime(ref.read(soundHapticsEnabledProvider));
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
    // Interpolated live energy (fresh 100 at kick-off → the final value by 90')
    // so the manager can see who's tiring when choosing a substitution.
    final base = (_result ?? preview.result).energyByPlayer;
    final energyNow = {
      for (final e in base.entries)
        e.key:
            (100 - (100 - e.value) * (_minute.clamp(0, 90) / 90)).round(),
    };
    final result = await showInMatchTactics(
      context,
      minute: _minute.clamp(1, 90),
      formation: _liveFormation,
      lineup: _liveLineup,
      instructions: _liveInstructions,
      pool: _playerPool(preview),
      startingIds: team.xi.map((p) => p.id).toSet(),
      maxSubs: kMaxSubs,
      injuredIds: _injuredIds,
      energyByPlayer: energyNow,
    );
    if (result != null && mounted) _applyTactics(preview, result);
    if (wasPlaying && _minute < 90 && !_playing) _togglePlay();
  }

  /// The nation the manager is NOT controlling in this fixture — the side whose
  /// tactics the engine reactively manages by the scoreline.
  int _opponentNationId(MatchPreview preview) =>
      preview.homeTeam.nationId == preview.playerNationId
          ? preview.awayTeam.nationId
          : preview.homeTeam.nationId;

  /// Re-runs the whole match from its seed with every change and team talk the
  /// manager has made applied, and the AI opponent reactively managed. Shared by
  /// the tactics editor and the interval team talk so both stay deterministic.
  MatchResult _resim(MatchPreview preview) => _engine.play(
        home: preview.homeTeam,
        away: preview.awayTeam,
        rng: SeededRng.forFixture(preview.saveSeed, preview.fixture.id),
        subs: preview.opponentSubs,
        changes: _changes,
        talks: _talks,
        aiManagedNationIds: {_opponentNationId(preview)},
        injuryFactorByNation: preview.injuryFactorByNation,
        neutralVenue: preview.neutralVenue,
        venueHostId: preview.venueHostId,
      );

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
      // Any hurt player taken off is no longer flagged as an unaddressed injury.
      _injuredIds.removeWhere((id) => !r.lineup.contains(id));
      _changes.add(
        TacticalChange(
          teamNationId: preview.playerNationId,
          minute: minute,
          formation: r.formation,
          instructions: r.instructions,
          xi: xi,
        ),
      );
      _result = _resim(preview);
    });
  }

  /// Applies the manager's interval team talk: it lifts (or steadies) the side
  /// from the second-half restart, and the match is re-simulated so the rest of
  /// the game reflects it.
  void _applyTeamTalk(MatchPreview preview, TeamTalkTone tone) {
    setState(() {
      _halfTimeTalk = tone;
      // Effective from the second-half kick-off (minute 46), so the first half
      // the manager already watched is untouched.
      _talks
        ..removeWhere((t) => t.minute == 46)
        ..add(
          TeamTalk(
            teamNationId: preview.playerNationId,
            minute: 46,
            tone: tone,
          ),
        );
      _result = _resim(preview);
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
          _livePreview = preview;
          _ensureLiveSetup(preview);
          final r = _result!;
          _stoppage = r.stoppage;
          _ensureKnockoutSetup(preview, r);
          if (!_started) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_started) _begin();
            });
          }

          final homeId = preview.homeTeam.nationId;
          final awayId = preview.awayTeam.nationId;
          String code(int id) => preview.nations[id]?.code ?? '??';
          String name(int id) => preview.nations[id]?.name ?? 'Unknown';

          final shown = r.events.where(_reached).toList();
          // The event feed also shows extra-time goals (kept OUT of `shown` so
          // the score isn't double-counted — it adds ET via _etGoals below).
          final timelineEvents = [
            ...shown,
            ..._etEvents.where(_reached),
          ]..sort((a, b) {
              final byMin = a.minute.compareTo(b.minute);
              return byMin != 0 ? byMin : a.stoppage.compareTo(b.stoppage);
            });
          final ft = _fullTime;
          final inExtraTime = _minute > 90 && _minute < _fullTimeMinute;
          final inStoppage = _minute == 90 && _added > 0 && !ft;
          // While playing, the score is the running tally of shown goal events.
          // In extra time it adds the synthesised ET goals up to the minute; at
          // full time it is the true recorded result (a level knockout settled
          // by a shootout), so the screen never disagrees with what gets saved.
          final (finalHome, finalAway) = _finalScore(preview, r);
          final liveHome = shown
              .where((e) => e.type == MatchEventType.goal)
              .where((e) => e.teamNationId == homeId)
              .length;
          final liveAway = shown
                  .where((e) => e.type == MatchEventType.goal)
                  .length -
              liveHome;
          // Extra-time score: the 90' tally plus revealed ET goals.
          final etHome =
              _etGoals.where((g) => g.$1 <= _minute && g.$2 == homeId).length;
          final etAway =
              _etGoals.where((g) => g.$1 <= _minute && g.$2 == awayId).length;
          final int homeScore;
          final int awayScore;
          if (ft) {
            homeScore = finalHome;
            awayScore = finalAway;
          } else if (_koOutcome != null && _minute > 90) {
            homeScore = liveHome + etHome;
            awayScore = liveAway + etAway;
          } else {
            homeScore = liveHome;
            awayScore = liveAway;
          }
          final knockout = _koOutcome;
          // Reveal the shootout as it plays out (or in full once decided).
          final showingShootout = _isShootout && _minute >= _fullTimeMinute;
          final decidedByShootout = ft && (knockout?.wentToShootout ?? false);

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
                        ? (decidedByShootout
                            ? 'FULL TIME · PENALTIES'
                            : knockout != null
                                ? 'AFTER EXTRA TIME'
                                : 'FULL TIME')
                        : showingShootout
                            ? 'PENALTIES'
                            : inExtraTime
                                // No trailing apostrophe: it adds right-side
                                // width that pushes the digits left of the
                                // plate's centre. The bare number reads as the
                                // minute and sits dead-centre.
                                ? 'ET $_minute'
                                : inStoppage
                                    ? '90+$_added'
                                    : '$_minute',
                    live: !ft,
                  ),
                  if (!ft && !showingShootout)
                    _MomentumBar(
                      homePercent: _homeMomentum(preview, homeId),
                      homeCode: code(homeId),
                      awayCode: code(awayId),
                    ),
                  if (!ft && !showingShootout && r.homeXgByMinute.isNotEmpty)
                    _XgRaceLine(
                      home: r.homeXgByMinute,
                      away: r.awayXgByMinute,
                      minute: _minute.clamp(0, 90),
                      homeCode: code(homeId),
                      awayCode: code(awayId),
                    ),
                  if (showingShootout || decidedByShootout)
                    _ShootoutStrip(
                      outcome: knockout!,
                      homeCode: code(homeId),
                      awayCode: code(awayId),
                      revealed: showingShootout ? _penRevealed : _penTotal,
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
                          events: timelineEvents,
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
                          // Live energy: the engine only reports each player's
                          // final energy, so before full time we interpolate it
                          // from a fresh 100 at kick-off down to that final value
                          // by the current minute — everyone reads ~100 pre-match
                          // and drains believably as the game runs.
                          energy: ft
                              ? r.energyByPlayer
                              : {
                                  for (final e in r.energyByPlayer.entries)
                                    e.key: (100 -
                                            (100 - e.value) *
                                                (_minute.clamp(0, 90) / 90))
                                        .round(),
                                },
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
                  // Half-time interval — play only resumes on Continue (the
                  // manager may reshape the side first).
                  if (_atHalfTime)
                    _HalfTimePrompt(
                      homeCode: code(homeId),
                      awayCode: code(awayId),
                      homeScore: homeScore,
                      awayScore: awayScore,
                      playerIsHome: preview.playerIsHome,
                      possession: preview.playerIsHome
                          ? r.homePossession
                          : 100 - r.homePossession,
                      subsUsed: _subsUsed(preview),
                      selectedTalk: _halfTimeTalk,
                      onTalk: (tone) => _applyTeamTalk(preview, tone),
                      onTactics: () => _openTactics(preview),
                      onContinue: _resumeFromHalfTime,
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
          final ft = _fullTime;
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
            // A clean broadcast-style clock chip — a dark rounded plate with a
            // monospace, tabular time, as on a real match graphic (no red dot).
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: AppRadii.baseAll,
                ),
                // Monospace tabular figures give the even, broadcast look with
                // no letter-spacing — the latter adds a trailing gap after the
                // last digit that pushes the time off-centre in the plate.
                child: Text(
                  clock,
                  textAlign: TextAlign.center,
                  style: AppTypography.labelMedium.copyWith(
                    fontFamily: AppFonts.mono,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    color:
                        live ? AppColors.onSurface : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
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
            child: Text(_eventClock(event), style: AppTypography.labelSmall),
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
      MatchEventType.goal when event.setPiece =>
        '${_abbrevName(event.playerName)} (set piece)',
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

/// The clock label for an event: a stoppage-time event reads "90+3", everything
/// else its plain minute with an apostrophe ("67'").
String _eventClock(MatchEvent e) =>
    e.stoppage > 0 ? '90+${e.stoppage}' : "${e.minute}'";

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
        _XgBar(home: result.homeXg, away: result.awayXg),
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
    // Read top-down like a team sheet: goalkeeper, defence, midfield, attack
    // (then rating within a line), rather than purely by score.
    final players = [
      for (final r in result.ratings)
        if ((r.teamNationId == homeNationId) == (teamId != null)) r,
    ]..sort((a, b) {
        final byLine =
            a.position.category.index.compareTo(b.position.category.index);
        if (byLine != 0) return byLine;
        final byPos = a.position.index.compareTo(b.position.index);
        if (byPos != 0) return byPos;
        return b.rating.compareTo(a.rating);
      });
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
                  // Lead with the position so the marks read like a team sheet,
                  // not just a flat list of names.
                  SizedBox(
                    width: 36,
                    child: TacticalChip(r.position.label),
                  ),
                  const SizedBox(width: AppSpacing.sm),
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

/// A live "xG race" line: cumulative expected goals for each side over the 90
/// minutes, revealed up to the current [minute] so the two lines climb as the
/// game plays. A step up is a big chance created.
class _XgRaceLine extends StatelessWidget {
  const _XgRaceLine({
    required this.home,
    required this.away,
    required this.minute,
    required this.homeCode,
    required this.awayCode,
  });

  final List<double> home;
  final List<double> away;
  final int minute;
  final String homeCode;
  final String awayCode;

  @override
  Widget build(BuildContext context) {
    final m = minute.clamp(0, home.length - 1);
    final h = home[m];
    final a = away[m];
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        0,
        AppSpacing.marginMobile,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$homeCode ${h.toStringAsFixed(1)}',
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.primary)),
              Text('xG',
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.onSurfaceVariant)),
              Text('${a.toStringAsFixed(1)} $awayCode',
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: CustomPaint(
              painter: _XgRacePainter(home: home, away: away, upto: m),
            ),
          ),
        ],
      ),
    );
  }
}

class _XgRacePainter extends CustomPainter {
  _XgRacePainter({required this.home, required this.away, required this.upto});

  final List<double> home;
  final List<double> away;
  final int upto;

  @override
  void paint(Canvas canvas, Size size) {
    if (upto <= 0) return;
    // Scale to the larger of the two revealed totals (min 1.0 headroom) so the
    // final magnitude never leaks before it's reached.
    final maxXg = [home[upto], away[upto], 1.0].reduce((x, y) => x > y ? x : y);
    final lastIndex = home.length - 1;
    Path pathFor(List<double> series) {
      final p = Path();
      for (var i = 0; i <= upto; i++) {
        final x = size.width * (i / lastIndex);
        final y = size.height - (series[i] / maxXg) * size.height;
        i == 0 ? p.moveTo(x, y) : p.lineTo(x, y);
      }
      return p;
    }

    final baseline = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.4)
      ..strokeWidth = 1;
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), baseline);

    final homePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round;
    final awayPaint = Paint()
      ..color = AppColors.onSurfaceVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(pathFor(away), awayPaint);
    canvas.drawPath(pathFor(home), homePaint);
  }

  @override
  bool shouldRepaint(_XgRacePainter old) =>
      old.upto != upto || old.home != home || old.away != away;
}

/// The expected-goals stat row: fractional values (one decimal) with a bar
/// split by each side's xG share.
class _XgBar extends StatelessWidget {
  const _XgBar({required this.home, required this.away});

  final double home;
  final double away;

  @override
  Widget build(BuildContext context) {
    final total = (home + away) == 0 ? 1.0 : home + away;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(home.toStringAsFixed(1), style: AppTypography.labelMedium),
              Text(
                'XG',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(away.toStringAsFixed(1), style: AppTypography.labelMedium),
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
    this.energy = const {},
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

  /// Per-player remaining energy (0–100) at full time, keyed by player id.
  final Map<int, int> energy;

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
                if (energy[p.id] case final e?) ...[
                  _EnergyPip(e),
                  const SizedBox(width: AppSpacing.sm),
                ],
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
/// A compact battery-style energy pip: green when fresh, amber tiring, red when
/// spent — a cue that a player is ready to be subbed.
class _EnergyPip extends StatelessWidget {
  const _EnergyPip(this.energy);

  final int energy;

  @override
  Widget build(BuildContext context) {
    final color = energyColor(energy);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.battery_charging_full, size: 12, color: color),
        const SizedBox(width: 2),
        Text(
          '$energy%',
          style: AppTypography.labelSmall.copyWith(
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

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
                        ? 'PENALTY · ${_eventClock(event)}'
                        : event.setPiece
                            ? 'SET PIECE · ${_eventClock(event)}'
                            : _eventClock(event),
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
/// A compact penalty-shootout summary shown under the score at full time: the
/// running pen tally and a row of scored/missed dots per side.
class _ShootoutStrip extends StatelessWidget {
  const _ShootoutStrip({
    required this.outcome,
    required this.homeCode,
    required this.awayCode,
    this.revealed = 1 << 30,
  });

  final KnockoutOutcome outcome;
  final String homeCode;
  final String awayCode;

  /// How many kicks (across both teams, home-first) have been taken so far —
  /// the strip reveals them one at a time as the shootout plays out live.
  final int revealed;

  @override
  Widget build(BuildContext context) {
    // Kicks alternate home-first: for `revealed` total, home has taken the
    // ceiling and away the floor of half.
    final homeShown = ((revealed + 1) ~/ 2).clamp(0, outcome.homeKicks.length);
    final awayShown = (revealed ~/ 2).clamp(0, outcome.awayKicks.length);
    final homeKicks = outcome.homeKicks.take(homeShown).toList();
    final awayKicks = outcome.awayKicks.take(awayShown).toList();
    final homePens = homeKicks.where((s) => s).length;
    final awayPens = awayKicks.where((s) => s).length;
    return Container(
      width: double.infinity,
      color: AppColors.surfaceContainerHigh,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        children: [
          Text(
            'SHOOTOUT $homePens–$awayPens',
            style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          _kicks(homeCode, homeKicks),
          const SizedBox(height: 2),
          _kicks(awayCode, awayKicks),
        ],
      ),
    );
  }

  Widget _kicks(String code, List<bool> kicks) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 34,
            child: Text(
              code,
              style: AppTypography.labelSmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          for (final scored in kicks)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Icon(
                scored ? Icons.circle : Icons.circle_outlined,
                size: 12,
                color: scored ? AppColors.positive : AppColors.error,
              ),
            ),
        ],
      );
}

/// The half-time interval overlay: the score, a read of the first half, and the
/// team talk — each tone shown with what it does and a recommendation for the
/// current game state. The manager can reshape the side (Tactics) too.
class _HalfTimePrompt extends StatelessWidget {
  const _HalfTimePrompt({
    required this.homeCode,
    required this.awayCode,
    required this.homeScore,
    required this.awayScore,
    required this.playerIsHome,
    required this.possession,
    required this.subsUsed,
    required this.selectedTalk,
    required this.onTalk,
    required this.onTactics,
    required this.onContinue,
  });

  final String homeCode;
  final String awayCode;
  final int homeScore;
  final int awayScore;
  final bool playerIsHome;
  final int possession;
  final int subsUsed;
  final TeamTalkTone? selectedTalk;
  final ValueChanged<TeamTalkTone> onTalk;
  final VoidCallback onTactics;
  final VoidCallback onContinue;

  /// The team talk that best fits the scoreline: protect a lead, chase a
  /// deficit, or push on when level.
  TeamTalkTone get _recommended {
    final diff =
        playerIsHome ? homeScore - awayScore : awayScore - homeScore;
    if (diff > 0) return TeamTalkTone.praise;
    if (diff < 0) return TeamTalkTone.demandMore;
    return TeamTalkTone.encourage;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final diff = playerIsHome ? homeScore - awayScore : awayScore - homeScore;
    final state = diff > 0
        ? 'You lead by ${diff == 1 ? 'a goal' : '$diff goals'}'
        : diff < 0
            ? 'You trail by ${-diff == 1 ? 'a goal' : '${-diff} goals'}'
            : 'It\'s all square';
    final stateColor = diff > 0
        ? AppColors.positive
        : diff < 0
            ? AppColors.error
            : AppColors.onSurface;
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black54,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.lg),
              constraints: const BoxConstraints(maxWidth: 420),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: AppRadii.lgAll,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.matchHalfTime,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlagDisc(homeCode, size: 28),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '$homeScore – $awayScore',
                        style: AppTypography.headlineMedium,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      FlagDisc(awayCode, size: 28),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '$state · $possession% possession',
                    style: AppTypography.bodySmall.copyWith(color: stateColor),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.teamTalkHeading,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  for (final tone in TeamTalkTone.values)
                    _TalkOption(
                      label: teamTalkLabel(l10n, tone),
                      blurb: teamTalkBlurb(l10n, tone),
                      effect: tone.effect,
                      selected: selectedTalk == tone,
                      recommended: _recommended == tone,
                      onTap: () => onTalk(tone),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onTactics,
                          icon: const Icon(Icons.tune, size: 18),
                          label: Text(
                            l10n.matchTacticsWithSubs(subsUsed, kMaxSubs),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(
                              color: AppColors.outlineVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  PrimaryButton(
                    label: l10n.matchContinue,
                    icon: Icons.play_arrow_rounded,
                    onPressed: onContinue,
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

/// One team-talk option in the half-time card: its label, what it asks for, the
/// attack/defence swing it applies, and a "suggested" flag for the game state.
class _TalkOption extends StatelessWidget {
  const _TalkOption({
    required this.label,
    required this.blurb,
    required this.effect,
    required this.selected,
    required this.recommended,
    required this.onTap,
  });

  final String label;
  final String blurb;
  final (double, double) effect;
  final bool selected;
  final bool recommended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (atk, def) = effect;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.16)
            : AppColors.surfaceContainerHighest,
        borderRadius: AppRadii.baseAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.baseAll,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadii.baseAll,
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 18,
                  color: selected
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(label, style: AppTypography.bodyMedium),
                          if (recommended) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            Text(
                              'SUGGESTED',
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 8,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        blurb,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Effect shown as arrows, not numbers: green up for a lift, red
                // down for a cost — two arrows when the swing is bigger.
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _SwingArrows(label: 'ATK', value: atk),
                    const SizedBox(height: 2),
                    _SwingArrows(label: 'DEF', value: def),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A team-talk effect shown as arrows instead of a number: one green up arrow
/// for a small lift, two for a bigger one; red down arrow(s) for a cost. A
/// neutral (zero) swing shows a single muted dash.
class _SwingArrows extends StatelessWidget {
  const _SwingArrows({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final magnitude = value.abs().round();
    final count = magnitude >= 3 ? 2 : 1;
    final up = value > 0;
    final color = magnitude == 0
        ? AppColors.onSurfaceVariant
        : up
            ? AppColors.positive
            : AppColors.error;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 4),
        if (magnitude == 0)
          Icon(Icons.remove_rounded, size: 14, color: color)
        else
          for (var i = 0; i < count; i++)
            Icon(
              up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              size: 14,
              color: color,
            ),
      ],
    );
  }
}

