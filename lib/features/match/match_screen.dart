import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/config/testing_flags.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/theme/kit_colors.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/penalty_takers.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/features/achievements/achievement_popup.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_feedback.dart';
import 'package:fnm/features/match/ground_card.dart';
import 'package:fnm/features/match/penalty_order_sheet.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart' show energyColor;
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'match_frame.dart';
part 'match_panels.dart';

/// The maximum substitutions a manager may make in a match.
const int kMaxSubs = 5;

/// The localised button label for a team-talk [tone]. The engine owns the tone's
/// gameplay effect; its display text lives here so it can be translated.
String teamTalkLabel(AppLocalizations l10n, TeamTalkTone tone) =>
    switch (tone) {
      TeamTalkTone.calm => l10n.teamTalkCalmLabel,
      TeamTalkTone.encourage => l10n.teamTalkEncourageLabel,
      TeamTalkTone.demandMore => l10n.teamTalkDemandMoreLabel,
      TeamTalkTone.praise => l10n.teamTalkPraiseLabel,
      TeamTalkTone.believe => l10n.teamTalkBelieveLabel,
      TeamTalkTone.focus => l10n.teamTalkFocusLabel,
      TeamTalkTone.urgency => l10n.teamTalkUrgencyLabel,
      TeamTalkTone.reassure => l10n.teamTalkReassureLabel,
    };

/// The localised one-line description of what a team-talk [tone] asks for.
String teamTalkBlurb(AppLocalizations l10n, TeamTalkTone tone) =>
    switch (tone) {
      TeamTalkTone.calm => l10n.teamTalkCalmBlurb,
      TeamTalkTone.encourage => l10n.teamTalkEncourageBlurb,
      TeamTalkTone.demandMore => l10n.teamTalkDemandMoreBlurb,
      TeamTalkTone.praise => l10n.teamTalkPraiseBlurb,
      TeamTalkTone.believe => l10n.teamTalkBelieveBlurb,
      TeamTalkTone.focus => l10n.teamTalkFocusBlurb,
      TeamTalkTone.urgency => l10n.teamTalkUrgencyBlurb,
      TeamTalkTone.reassure => l10n.teamTalkReassureBlurb,
    };

/// The team-talk tones offered at this match's interval: a seeded subset of the
/// full set, so the choices vary from match to match (no fixed list with an
/// obvious "right answer") while staying stable across re-sims of the SAME
/// fixture — the salt keeps it independent of the match-result rng stream.
List<TeamTalkTone> offeredTalkTones(int saveSeed, int fixtureId) {
  final rng = SeededRng(saveSeed ^ (fixtureId * 0x9E37) ^ 0x7A1C);
  final tones = [...TeamTalkTone.values];
  // Fisher–Yates shuffle on the seeded stream, then take a handful.
  for (var i = tones.length - 1; i > 0; i--) {
    final j = rng.nextInt(i + 1);
    final t = tones[i];
    tones[i] = tones[j];
    tones[j] = t;
  }
  return tones.take(5).toList();
}

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

  /// The set-piece takers as they stand RIGHT NOW, seeded from the team sheet
  /// and changeable from the in-match editor. Held here rather than read back
  /// off the provider each time so a change takes effect on the very next
  /// re-sim rather than a frame later.
  ({int? penalty, int? deadBall})? _takers;

  /// The latest loaded preview, stashed so timer callbacks (e.g. an injury
  /// opening the squad) can reach it without a build context.
  MatchPreview? _livePreview;

  /// Whether play is paused at the half-time interval, awaiting the manager's
  /// "continue" (they may reshape the side before the second half). Shown once
  /// per match ([_halfTimeTaken] guards a paused-and-resumed clock).
  bool _atHalfTime = false;
  bool _halfTimeTaken = false;

  /// The two extra-time intervals: the huddle on the pitch at the end of 90
  /// minutes, and the turnaround at 105'. Both stop the clock for a talk, like
  /// half time — a knockout used to slide straight from full time into extra
  /// time and on to penalties with the manager never saying a word, which is
  /// the one stretch of a tournament where what is said matters most.
  bool _atExtraTimeStart = false;
  bool _extraTimeStartTaken = false;
  bool _atExtraTimeHalf = false;
  bool _extraTimeHalfTaken = false;

  /// The talk given before extra time — it tilts the extra period itself.
  TeamTalkTone? _extraTimeTalk;

  /// Whether the clock is stopped at any interval — half time or either
  /// extra-time break. Anything that would otherwise restart play (a goal
  /// flash clearing, an injury sub being made) has to respect all three.
  bool get _atInterval => _atHalfTime || _atExtraTimeStart || _atExtraTimeHalf;

  /// The talk given at the extra-time turnaround. Extra time is already drawn
  /// by then (its goals have been shown), so this one steadies the takers
  /// instead: it moves the shootout, not the score.
  TeamTalkTone? _extraTimeHalfTalk;

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

  /// The five takers the manager has named, in the order they step up. Null
  /// until they choose, or until they dismiss the sheet, which takes the
  /// automatic order. Sudden death cycles back through the same list.
  List<Player>? _penOrder;

  /// Whether the taker sheet has already been offered this match, so it is
  /// asked exactly once.
  bool _penOrderAsked = false;

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
    // Restore the playback speed chosen in a previous match this session...
    _speedIdx = ref.read(matchSpeedProvider);
    // ...and, if this is the first match of the session, the one this CAREER
    // was last watched at. Async, so the match starts at the session speed and
    // corrects itself a frame later rather than waiting on a disk read.
    unawaited(
      ref
          .read(matchSpeedStoreProvider)
          .load(widget.careerId, stepCount: _speeds.length)
          .then((saved) {
            if (!mounted || saved == _speedIdx) return;
            setState(() => _speedIdx = saved);
            ref.read(matchSpeedProvider.notifier).state = saved;
          }),
    );
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
    ]..sort((a, b) => b.attributes.technical.compareTo(a.attributes.technical));
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

  /// Names the five takers before the shootout, then reveals it. Dismissing
  /// the sheet keeps the automatic order — the shootout always goes ahead.
  Future<void> _askPenaltyOrder(MatchPreview preview) async {
    final r = _result;
    final chosen = await showModalBottomSheet<List<Player>>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => PenaltyOrderSheet(
        squad: [
          for (final p in _currentXi(preview))
            if (r == null || !_sentOff(r, _playerNationId ?? -1).contains(p.id))
              p,
        ],
        initialOrder: _penTakers(preview),
        traitsByPlayer: _playerTeam(preview).traitsByPlayer,
      ),
    );
    if (!mounted) return;
    setState(() {
      if (chosen != null && chosen.isNotEmpty) _penOrder = chosen;
      // The kicks follow from who is taking them, so they are drawn now.
      final res = _result;
      if (res != null) _koOutcome = _knockoutOutcome(preview, res);
      _penRevealed = 0;
    });
    _startShootout();
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
          // A level knockout that reached the shootout: name the takers first,
          // then reveal the kicks. The order is asked once, and only of a
          // manager who is actually in the tie.
          if (_isShootout) {
            if (_penOrderAsked) {
              _startShootout();
            } else {
              _penOrderAsked = true;
              final preview = _livePreview;
              if (preview != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _askPenaltyOrder(preview);
                });
              }
            }
          }
        }
      });
      // An injury opens the squad (paused) with the hurt player flagged — play
      // resumes when the manager is done, whether or not they made a sub.
      _checkInjuryAt(_minute, tickStoppage);
      // Half-time: the whistle stops play until the manager continues.
      if (_checkHalfTime()) return;
      // The extra-time intervals do the same at 90' and 105'.
      if (_checkExtraTimeBreaks()) return;
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
          if (_playing && !_clockDone && !_atInterval) {
            _restartTimer();
          }
        });
        return true;
      }
    }
    return false;
  }

  /// The manager's own players sent off so far in this match.
  ///
  /// A red card ends that player's game: he leaves the pitch for good, can't be
  /// replaced, and must not appear among the substitutes. Derived from the
  /// event list rather than accumulated, so it stays correct across the
  /// re-simulations a tactical change triggers.
  Set<int> _sentOffIds() {
    final events = _result?.events;
    final nation = _playerNationId;
    if (events == null || nation == null) return const {};
    return {
      for (final e in events)
        if (e.type == MatchEventType.redCard &&
            e.teamNationId == nation &&
            e.minute <= _minute)
          e.playerId,
    };
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
    if (mounted && !_playing && !_clockDone && !_atInterval) {
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

  /// Stops the clock at the two extra-time intervals of a level knockout: the
  /// huddle at the end of 90 minutes (before the first period) and the
  /// turnaround at 105'. Each fires once; a match settled inside 90 minutes
  /// never sees either.
  bool _checkExtraTimeBreaks() {
    if (_fullTimeMinute <= 90) return false;
    // The end of regulation, stoppage played out — the players are on the grass
    // and the manager has the huddle.
    if (!_extraTimeStartTaken && _minute >= 90 && _added >= _stoppage) {
      _extraTimeStartTaken = true;
      _timer?.cancel();
      setState(() {
        _playing = false;
        _atExtraTimeStart = true;
      });
      return true;
    }
    if (!_extraTimeHalfTaken && _minute >= 105) {
      _extraTimeHalfTaken = true;
      _timer?.cancel();
      setState(() {
        _playing = false;
        _atExtraTimeHalf = true;
      });
      return true;
    }
    return false;
  }

  /// Dismisses an extra-time interval overlay and restarts the clock.
  void _resumeFromExtraTimeBreak() {
    setState(() {
      _atExtraTimeStart = false;
      _atExtraTimeHalf = false;
      _playing = true;
    });
    _restartTimer();
  }

  /// How much the pre-extra-time talk tilts the extra period, as the strength
  /// pair `decideKnockout` weights its half-chances by.
  ///
  /// A talk here is worth a real edge but not the tie: at its strongest it
  /// moves a level pair to roughly 57/43, which decides some of them and none
  /// of them on its own.
  (double, double) _extraTimeStrengths(MatchPreview preview) {
    final tone = _extraTimeTalk;
    if (tone == null) return (1, 1);
    final (atk, def) = tone.effect;
    final edge = 1 + ((atk + def) / 2) * 0.06;
    return preview.playerIsHome ? (edge, 1.0) : (1.0, edge);
  }

  /// How much the extra-time turnaround talk steadies the manager's takers, as
  /// a multiplier on their per-kick conversion.
  double _shootoutComposure() {
    final tone = _extraTimeHalfTalk;
    if (tone == null) return 1;
    // Composure, not aggression: settling the side is worth more from the spot
    // than demanding more of it.
    final (atk, def) = tone.effect;
    return (1 + (def - atk * 0.5) * 0.02).clamp(0.94, 1.08);
  }

  /// Applies a talk given at one of the extra-time intervals.
  void _applyExtraTimeTalk(
    MatchPreview preview,
    TeamTalkTone tone, {
    required bool atStart,
  }) {
    setState(() {
      if (atStart) {
        _extraTimeTalk = tone;
        // Extra time has not been played yet, so it can be redrawn wholesale
        // with the new edge applied. Unlocking the one-time setup is what lets
        // the recomputed goals reach the clock and the timeline.
        _koSetup = false;
        final r = _result ?? preview.result;
        _ensureKnockoutSetup(preview, r);
      } else {
        _extraTimeHalfTalk = tone;
        // Only the shootout is still open — `decideKnockout` draws extra time
        // from the stream BEFORE the kicks, so the score the manager has just
        // watched cannot move under them.
        final r = _result ?? preview.result;
        _koOutcome = _knockoutOutcome(preview, r);
      }
    });
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
    // Who takes them decides them. Extra time is drawn from the same stream
    // BEFORE the shootout, so naming takers changes the kicks and never the
    // extra-time score — the tie the manager just watched stays as it was.
    final composure = _shootoutComposure();
    final mySkill = [
      for (final s in PenaltyTakers.skillOrder(
        _penTakers(preview),
        traitsByPlayer: _playerTeam(preview).traitsByPlayer,
      ))
        s * composure,
    ];
    final oppTeam = _opponentTeam(preview);
    final oppSkill = PenaltyTakers.skillOrder(
      PenaltyTakers.autoOrder(
        oppTeam.xi,
        unavailable: _sentOff(r, oppTeam.nationId),
        traitsByPlayer: oppTeam.traitsByPlayer,
      ),
      traitsByPlayer: oppTeam.traitsByPlayer,
    );
    final (homeStrength, awayStrength) = _extraTimeStrengths(preview);
    return WorldCupFinals.decideKnockout(
      r.homeScore,
      r.awayScore,
      SeededRng.forFixture(preview.saveSeed, preview.fixture.id ^ 0x7F),
      homeStrength: homeStrength,
      awayStrength: awayStrength,
      homeTakerSkill: preview.playerIsHome ? mySkill : oppSkill,
      awayTakerSkill: preview.playerIsHome ? oppSkill : mySkill,
    );
  }

  /// The opposition, as fielded (the manager's own side is [_playerTeam]).
  MatchTeam _opponentTeam(MatchPreview preview) =>
      preview.playerIsHome ? preview.awayTeam : preview.homeTeam;

  /// Players sent off — they cannot take a kick.
  Set<int> _sentOff(MatchResult r, int nationId) => {
    for (final e in r.events)
      if (e.type == MatchEventType.redCard && e.teamNationId == nationId)
        e.playerId,
  };

  /// The manager's takers by name, for the shootout strip.
  List<String> _takerNames(MatchPreview preview) => [
    for (final p in _penTakers(preview)) p.name,
  ];

  /// The manager's takers: their named order, or the automatic one until they
  /// name it.
  List<Player> _penTakers(MatchPreview preview) {
    final named = _penOrder;
    if (named != null && named.isNotEmpty) return named;
    final r = _result;
    return PenaltyTakers.autoOrder(
      _currentXi(preview),
      unavailable: r == null ? const {} : _sentOff(r, _playerNationId ?? -1),
      traitsByPlayer: _playerTeam(preview).traitsByPlayer,
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
    double avg(List<Player> xi) =>
        xi.isEmpty ? 60 : xi.fold<int>(0, (s, p) => s + p.overall) / xi.length;
    final baseline =
        50 + (avg(preview.homeTeam.xi) - avg(preview.awayTeam.xi)) * 1.1;
    var m = baseline;
    // A gentle ebb and flow so the needle always breathes through a goalless
    // spell rather than freezing on the baseline. Deterministic on the minute
    // (two out-of-phase waves) so it's stable across rebuilds, and it leans
    // toward whichever side is stronger.
    final lean = (baseline - 50) / 40; // −1…1, the stronger side's tilt
    // Three incommensurate waves, wide enough that the needle reaches its
    // extremes on its own. It used to breathe in a narrow band and only ever
    // hit the ends when a goal was on the way, which turned the bar into a
    // countdown: the manager learned that 8% meant a goal inside two minutes.
    final wobble =
        12 * math.sin(_minute * 0.37 + homeId % 7) +
        7 * math.sin(_minute * 0.13 + 1.7) +
        5 * math.sin(_minute * 0.71 + homeId % 3) +
        6 * lean * math.sin(_minute * 0.11);
    m += wobble;
    // A goal is FELT after it goes in, not announced beforehand. There is still
    // a lean into it — pressure does tell — but it is a hint the size of the
    // ordinary ebb and flow, not a spike that pins the bar to its clamp.
    const build = 3.0; // minutes of pressure rising before the goal
    const fade = 18.0; // minutes it fades over afterwards
    const prePeak = 6.0; // the most a coming goal shows in advance
    const postPeak = 24.0; // the swing the goal itself produces
    for (final e in _result?.events ?? const <MatchEvent>[]) {
      if (e.type != MatchEventType.goal) continue;
      final g = e.minute;
      if (_minute < g - build || _minute > g + fade) continue;
      final swing = _minute < g
          ? (build - (g - _minute)) / build * prePeak
          : (fade - (_minute - g)) / fade * postPeak; // peak → 0 after the goal
      m += e.teamNationId == homeId ? swing : -swing;
    }
    // Fold in the engine's REAL momentum swing (the mechanic that actually
    // shifted the play) so the needle reflects it, not just this cosmetic model.
    // momentumByMinute is net home−away; homeId may be the away side on the
    // pitch, so orient it to the home team of this bar.
    final real = _result?.momentumByMinute;
    if (real != null && _minute > 0 && _minute < real.length) {
      final net = real[_minute]; // + = engine's home side pressing
      final forThisHome = homeId == preview.fixture.homeNationId ? net : -net;
      m += forThisHome * 2.4;
    }
    // A wider band than the swing can reach on its own, so touching the end of
    // the bar is a genuinely extreme spell rather than the routine sign that a
    // goal is coming.
    return m.clamp(4, 96);
  }

  void _togglePlay() {
    setState(() => _playing = !_playing);
    _restartTimer();
  }

  void _cycleSpeed() {
    setState(() => _speedIdx = (_speedIdx + 1) % _speeds.length);
    // Remember the choice for the next match this session.
    ref.read(matchSpeedProvider.notifier).state = _speedIdx;
    // Remembered for the next time this career is opened, not just the next
    // match of this session.
    unawaited(
      ref.read(matchSpeedStoreProvider).save(widget.careerId, _speedIdx),
    );
    if (_playing) _restartTimer();
  }

  /// Jumps the clock to the final whistle, revealing the stoppage minutes and
  /// any extra time at once rather than playing the drama out.
  ///
  /// A TESTING AID, on the bar only while [kShowSkipMatch] is true, so a match
  /// can be moved through quickly instead of watched.
  ///
  /// A shootout is the one thing it does NOT jump: those kicks are the
  /// manager's to order. If the taker sheet has not been offered yet this
  /// match, skipping takes the clock to full time and then opens it, exactly as
  /// the clock running out does — so skipping can never answer for him, which
  /// is precisely what the control used to do (it pre-set [_penOrderAsked] and
  /// revealed every kick, silently accepting the automatic order). Once the
  /// kicks are revealing, a second tap lands the rest of them at once; the
  /// sheet has been offered, and nothing offers it again.
  void _skip() {
    _timer?.cancel();
    final askPreview = _isShootout && !_penOrderAsked ? _livePreview : null;
    setState(() {
      _minute = _fullTimeMinute;
      _added = _stoppage;
      _playing = false;
      if (askPreview != null) {
        // The sheet is about to open: it draws the kicks and reveals them.
        _penOrderAsked = true;
      } else {
        // Nothing left to ask — no shootout, or the takers are already named —
        // so every remaining kick lands now.
        _penTimer?.cancel();
        _penTimer = null;
        _penRevealed = _penTotal;
      }
    });
    MatchFeedback.fullTime(ref.read(soundHapticsEnabledProvider));
    if (askPreview != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_askPenaltyOrder(askPreview));
      });
    }
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
          .playPlayerMatch(
            widget.careerId,
            preview.fixture,
            r,
            // The extra time and shootout the manager just watched — with the
            // takers they named and the talks they gave folded in. The season
            // service used to redraw it from the raw seed, so the stored
            // result could disagree with the one on screen.
            knockout: _knockoutOutcome(preview, r),
          );
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
          SnackBar(
            content: Text(
              AppLocalizations.of(context).matchCouldNotContinue('$e'),
            ),
          ),
        );
      }
    }
  }

  /// The player's team as it started (the fixed engine input; live edits are
  /// carried by [_changes], not by mutating this).
  MatchTeam _playerTeam(MatchPreview preview) =>
      preview.playerIsHome ? preview.homeTeam : preview.awayTeam;

  /// Every player the manager can field: the starting XI plus the bench.
  List<Player> _playerPool(MatchPreview preview) => [
    ..._playerTeam(preview).xi,
    ...preview.bench,
  ];

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

  /// Interpolated live energy per player (0–100). The engine only reports each
  /// player's energy at full time, so before then we walk it from a fresh 100 at
  /// kick-off down to that final value by 90' — everyone reads ~100 pre-match
  /// and drains believably as the game runs.
  Map<int, int> _liveEnergy(MatchResult r) {
    if (_fullTime) return r.energyByPlayer;
    final t = _minute.clamp(0, 90) / 90;
    return {
      for (final e in r.energyByPlayer.entries)
        e.key: (100 - (100 - e.value) * t).round(),
    };
  }

  /// How many of the manager's own players on the pitch are running on empty
  /// (below the red band). Drives the alert on the tactics button — legs go
  /// quietly, and a manager watching the ball shouldn't have to open the squad
  /// on spec to find out someone has nothing left.
  int _spentCount(MatchPreview preview, MatchResult r) {
    if (_fullTime) return 0;
    final energy = _liveEnergy(r);
    final sentOff = _sentOffIds();
    var n = 0;
    for (final p in _currentXi(preview)) {
      if (sentOff.contains(p.id)) continue;
      if ((energy[p.id] ?? 100) < 50) n++;
    }
    return n;
  }

  /// Opens the full in-match tactics editor and, if the manager confirms,
  /// records the change and re-simulates the rest of the match with it applied.
  Future<void> _openTactics(MatchPreview preview) async {
    final wasPlaying = _playing;
    if (_playing) _togglePlay();
    final team = _playerTeam(preview);
    // So the manager can see who's tiring when choosing a substitution.
    final energyNow = _liveEnergy(_result ?? preview.result);
    final result = await showInMatchTactics(
      context,
      minute: _minute.clamp(1, 90),
      formation: _liveFormation,
      lineup: _liveLineup,
      instructions: _liveInstructions,
      pool: _playerPool(preview),
      startingIds: team.xi.map((p) => p.id).toSet(),
      maxSubs: kMaxSubs,
      takers: _takers ??= (
        penalty: team.penaltyTakerId,
        deadBall: team.deadBallTakerId,
      ),
      injuredIds: _injuredIds,
      sentOffIds: _sentOffIds(),
      energyByPlayer: energyNow,
      // Your kit on your players' discs — the same identity the pre-match
      // tactics pitch shows, rather than a neutral grey mid-game.
      teamColors: () {
        final n = preview.nations[preview.playerNationId];
        return n == null
            ? null
            : KitColors.discFill(n.primaryColor, n.secondaryColor);
      }(),
    );
    if (result != null && mounted) await _applyTactics(preview, result);
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
    chemistryByNation: preview.chemistryByNation,
    neutralVenue: preview.neutralVenue,
    venueHostId: preview.venueHostId,
    // Carried through so a re-sim after a substitution or team talk keeps
    // the big-game trait and the crowd applied exactly as the first
    // simulation did.
    bigMatch: preview.bigMatch,
    atmosphere: Attendance.atmosphere(preview.ground),
  );

  Future<void> _applyTactics(
    MatchPreview preview,
    InMatchTacticsResult r,
  ) async {
    final byId = {for (final p in _playerPool(preview)) p.id: p};
    final xi = r.lineup
        .whereType<int>()
        .map((id) => byId[id])
        .whereType<Player>()
        .toList();
    // Take effect from the NEXT minute, never the one just played. A change
    // stamped on the current minute made the re-sim replay that minute with the
    // new XI — so a goal the manager had already watched go in (popup and all)
    // could vanish from the rebuilt event list, leaving a "GOAL!" flash with no
    // goal on the scoreboard. Past minutes are now always replayed identically.
    //
    // Beyond 90 this lands past the regulation loop and is simply inert: the
    // engine only applies changes on minutes 1–90 in normal time, so a sub made
    // during stoppage updates the lineups display without rewriting the match.
    final minute = _minute + 1;
    final takersChanged = r.takers != _takers;
    setState(() {
      _liveFormation = r.formation;
      _liveLineup = r.lineup;
      _liveInstructions = r.instructions;
      _takers = r.takers;
      // Any hurt player taken off is no longer flagged as an unaddressed injury.
      _injuredIds.removeWhere((id) => !r.lineup.contains(id));
      _changes.add(
        TacticalChange(
          teamNationId: preview.playerNationId,
          minute: minute,
          formation: r.formation,
          instructions: r.instructions,
          xi: xi,
          // From this minute on, never retroactively: the penalty already
          // taken stays taken by whoever took it.
          takers: takersChanged ? r.takers : null,
        ),
      );
      _result = _resim(preview);
    });
    // The choice outlives the match: a taker named at 70 minutes is the taker
    // the next team sheet opens with, exactly as if it had been set before
    // kick-off. Fire and forget; nothing on this screen reads it back.
    if (takersChanged) {
      await ref
          .read(setPieceTakersStoreProvider)
          .setBoth(
            widget.careerId,
            penalty: r.takers.penalty,
            deadBall: r.takers.deadBall,
          );
    }
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
    final l = AppLocalizations.of(context);
    // A match is played from the teamsheet it kicked off with. Once the preview
    // has landed it is PINNED — the screen stops watching the provider — so the
    // world moving underneath can never repaint this match with another
    // fixture. It moves at exactly the wrong moment: committing the result
    // (Continue) refreshes "the player's next fixture" while this screen is
    // still up, leaving through its route transition, with the final score in
    // its own state. Redrawn from a fresher preview, it would put the NEXT
    // opponent's flags, names and ratings either side of the score of the match
    // just finished — for as long as the transition lasts.
    final pinned = _livePreview;
    final previewAsync = pinned != null
        ? AsyncValue<MatchPreview?>.data(pinned)
        : ref.watch(matchPreviewProvider(widget.careerId));

    return PopScope(
      // A match in progress cannot be backed out of: leaving early would drop
      // the result on the floor. Full time's Continue is the only exit.
      canPop: false,
      child: Scaffold(
        body: previewAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l.matchCouldNotLoad('$e'))),
          data: (preview) {
            if (preview == null) {
              return Center(child: Text(l.matchNoUpcoming));
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
            final timelineEvents =
                [
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
            final liveAway =
                shown.where((e) => e.type == MatchEventType.goal).length -
                liveHome;
            // Extra-time score: the 90' tally plus revealed ET goals.
            final etHome = _etGoals
                .where((g) => g.$1 <= _minute && g.$2 == homeId)
                .length;
            final etAway = _etGoals
                .where((g) => g.$1 <= _minute && g.$2 == awayId)
                .length;
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
                        const _TopBar(),
                        _Header(
                          homeCode: code(homeId),
                          awayCode: code(awayId),
                          homeName: name(homeId),
                          awayName: name(awayId),
                          // The manager's own side is rated off the XI actually
                          // on the pitch, so the number moves with his changes;
                          // the opponent's off the team they named.
                          homeOverall: squadOverall(
                            preview.playerIsHome
                                ? _currentXi(preview)
                                : preview.homeTeam.xi,
                          ),
                          awayOverall: squadOverall(
                            preview.playerIsHome
                                ? preview.awayTeam.xi
                                : _currentXi(preview),
                          ),
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
                          () {
                            // The two nations' own colours, pushed apart from
                            // each other when the kits are too alike to tell
                            // which end of the bar is whose.
                            final (homeC, awayC) = KitColors.opposed(
                              (
                                preview.nations[homeId]?.primaryColor ?? '',
                                preview.nations[homeId]?.secondaryColor ?? '',
                              ),
                              (
                                preview.nations[awayId]?.primaryColor ?? '',
                                preview.nations[awayId]?.secondaryColor ?? '',
                              ),
                            );
                            return _MomentumBar(
                              homePercent: _homeMomentum(preview, homeId),
                              homeCode: code(homeId),
                              awayCode: code(awayId),
                              homeColor: homeC,
                              awayColor: awayC,
                            );
                          }(),
                        if (showingShootout || decidedByShootout)
                          _ShootoutStrip(
                            outcome: knockout!,
                            homeCode: code(homeId),
                            awayCode: code(awayId),
                            revealed: showingShootout
                                ? _penRevealed
                                : _penTotal,
                            homeTakers: preview.playerIsHome
                                ? _takerNames(preview)
                                : const [],
                            awayTakers: preview.playerIsHome
                                ? const []
                                : _takerNames(preview),
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
                                  ground: preview.ground,
                                  neutral: preview.neutralVenue,
                                  groundCode: code(
                                    preview.ground.groundNationId,
                                  ),
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
                                          e.type ==
                                              MatchEventType.substitution &&
                                          e.teamNationId == homeId,
                                    )
                                    .toList(),
                                awaySubs: shown
                                    .where(
                                      (e) =>
                                          e.type ==
                                              MatchEventType.substitution &&
                                          e.teamNationId == awayId,
                                    )
                                    .toList(),
                                homeBench: preview.playerIsHome
                                    ? preview.bench
                                    : preview.opponentBench,
                                awayBench: preview.playerIsHome
                                    ? preview.opponentBench
                                    : preview.bench,
                                ratings: ft
                                    ? {
                                        for (final x in r.ratings)
                                          x.playerId: x.rating,
                                      }
                                    : const {},
                                energy: _liveEnergy(r),
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
                        heading: l.matchHalfTime,
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
                        options: offeredTalkTones(
                          preview.saveSeed,
                          preview.fixture.id,
                        ),
                        onTalk: (tone) => _applyTeamTalk(preview, tone),
                        onTactics: () => _openTactics(preview),
                        onContinue: _resumeFromHalfTime,
                      ),
                    // The two extra-time intervals of a level knockout: the
                    // huddle before the first period, and the turnaround at 105'.
                    if (_atExtraTimeStart || _atExtraTimeHalf)
                      _HalfTimePrompt(
                        heading: _atExtraTimeStart
                            ? l.matchExtraTimeAhead
                            : l.matchExtraTimeHalf,
                        homeCode: code(homeId),
                        awayCode: code(awayId),
                        homeScore: homeScore,
                        awayScore: awayScore,
                        playerIsHome: preview.playerIsHome,
                        possession: preview.playerIsHome
                            ? r.homePossession
                            : 100 - r.homePossession,
                        subsUsed: _subsUsed(preview),
                        selectedTalk: _atExtraTimeStart
                            ? _extraTimeTalk
                            : _extraTimeHalfTalk,
                        // A different salt per interval, so the huddle and the
                        // turnaround don't offer the identical three lines.
                        options: offeredTalkTones(
                          preview.saveSeed,
                          preview.fixture.id ^
                              (_atExtraTimeStart ? 0x0E71 : 0x0E72),
                        ),
                        onTalk: (tone) => _applyExtraTimeTalk(
                          preview,
                          tone,
                          atStart: _atExtraTimeStart,
                        ),
                        onTactics: () => _openTactics(preview),
                        onContinue: _resumeFromExtraTimeBreak,
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
                      onPressed: _committing
                          ? null
                          : () => _continue(preview, r),
                    ),
                  )
                : MatchControlBar(
                    playing: _playing,
                    speed: _speeds[_speedIdx],
                    subsUsed: _subsUsed(preview),
                    spent: _spentCount(preview, r),
                    onPlayPause: _togglePlay,
                    onSpeed: _cycleSpeed,
                    onTactics: () => _openTactics(preview),
                    // The only wiring of the skip aid: off here is off
                    // everywhere, and the pill is absent rather than dead.
                    onSkip: kShowSkipMatch ? _skip : null,
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
      ),
    );
  }
}
