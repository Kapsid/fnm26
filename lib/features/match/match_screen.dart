import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/config/testing_flags.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/theme/kit_colors.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/core/util/nation_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/card_status.dart';
import 'package:fnm/domain/services/match/live_rating.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/penalty_takers.dart';
import 'package:fnm/domain/services/match/pitch/moment_staging.dart'
    show ShootoutCast, ShootoutStaging;
import 'package:fnm/domain/services/press/fan_mood.dart';
import 'package:fnm/features/achievements/achievement_popup.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_feedback.dart';
import 'package:fnm/features/match/ground_card.dart';
import 'package:fnm/features/match/penalty_order_sheet.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/pitch/pitch_clock.dart';
import 'package:fnm/features/match/pitch/pitch_mode_controller.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_playback.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/features/match/pitch/shootout_stage.dart';
import 'package:fnm/features/match/score_bug_theme.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:fnm/features/tactics/tactic_preset_providers.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart'
    show energyColor, surnameOf, TacticsPitch;
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/share/match_share_card.dart';
import 'package:fnm/features/share/share_data.dart';
import 'package:fnm/features/share/share_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'match_frame.dart';
part 'match_panels.dart';
part 'match_event_flash.dart';
part 'match_score_bug.dart';
part 'match_tablet_layout.dart';
part 'match_red_card_banner.dart';
part 'match_tv_header.dart';

/// The maximum substitutions a manager may make in a match.
const int kMaxSubs = 5;

/// The substitutions allowed once a level knockout reaches extra time: one
/// more than [kMaxSubs], as the laws allow, for the extra thirty minutes.
const int kMaxSubsExtraTime = 6;

/// The substitutions the manager may make: the whole bench in a [friendly],
/// else [kMaxSubs], or [kMaxSubsExtraTime] once [extraTime] is being played.
int maxSubsAllowed({
  required bool friendly,
  required int benchSize,
  required bool extraTime,
}) {
  if (friendly) return benchSize;
  return extraTime ? kMaxSubsExtraTime : kMaxSubs;
}

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

  static const Key tabletLayoutKey = Key('match.tabletLayout');

  @override
  ConsumerState<MatchScreen> createState() => _MatchScreenState();
}

/// What a test reads off and does to the live match screen (its state
/// implements it): `tester.state(find.byType(MatchScreen)) as
/// MatchScreenProbe`.
@visibleForTesting
abstract interface class MatchScreenProbe {
  PitchModeController get pitchMode;
  MatchResult? get result;
  MatchViewMode? get mode;

  /// The events on show (the score, the Timeline and the stats read these).
  List<MatchEvent> get shownEvents;

  /// The header switch's action (a test at an interval, whose card covers
  /// the header, uses it).
  void switchMode();

  /// Moves the Pitch clock to [t] as a jump (not play) and reads the match
  /// off it.
  void seekPitch(Duration t);
}

class _MatchScreenState extends ConsumerState<MatchScreen>
    with TickerProviderStateMixin
    implements MatchScreenProbe {
  static const _speeds = [1, 2, 3];
  static const _engine = MatchEngine();

  /// This attempt's salt on the fixture seed (see [matchAttemptSaltProvider]).
  /// Held by the screen, not the preview, so a rebuilt preview can never swap
  /// the dice under a match already in play.
  late final int _attemptSalt = ref.read(matchAttemptSaltProvider)();

  /// The seed this attempt plays from: the match itself and its extra time.
  int _seed(MatchPreview preview) => preview.saveSeed ^ _attemptSalt;

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
  late FullBackPushes _liveFullBacks;

  /// The places changed within [_liveFormation] (see [SlotSwitches]).
  SlotSwitches _liveSwitches = SlotSwitches.none;

  /// True while the full-time result is being committed and the world is being
  /// simulated forward. Debug builds can take several seconds here, so the
  /// button must show a busy state rather than looking dead.
  bool _committing = false;

  /// The goal currently flashed on the "GOAL!" overlay (null when hidden).
  MatchEvent? _goalFlash;
  Timer? _flashTimer;

  /// The substitution on its pop-up (null when hidden). Play never waits
  /// for it. A red card never comes here: it has its own banner.
  MatchEvent? _eventFlash;
  Timer? _eventTimer;

  /// The 2D TV's red card banner: the sending-off on show (null when
  /// hidden). It never holds the clock.
  MatchEvent? _redFlash;
  Timer? _redTimer;

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

  /// The throw-in style and thrower as they stand right now, seeded from the
  /// team sheet the same way as [_takers].
  ({ThrowInStyle style, int? taker})? _throwIn;

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

  /// The talk given before extra time. It is a [TeamTalk] at 91' in [_talks],
  /// so the engine plays the extra period with it; held here to show it as
  /// chosen on the huddle card.
  TeamTalkTone? _extraTimeTalk;

  /// Whether the clock is stopped at any interval — half time or either
  /// extra-time break. Anything that would otherwise restart play (a goal
  /// flash clearing, an injury sub being made) has to respect all three.
  bool get _atInterval => _atHalfTime || _atExtraTimeStart || _atExtraTimeHalf;

  /// The talk given at the extra-time turnaround. It is a [TeamTalk] at 106'
  /// for the second period, and it also steadies the takers: it moves the
  /// shootout as well as the last fifteen minutes.
  TeamTalkTone? _extraTimeHalfTalk;

  // --- Live extra time / penalties -----------------------------------------
  // A level knockout plays on: the engine plays minutes 91-120 (its extra-time
  // events are revealed by the clock like any other), and, if still level, a
  // shootout is revealed kick by kick, rather than the result just popping up
  // at 90'.

  /// The minute the clock runs to: 90 normally, 120 for a level knockout.
  int _fullTimeMinute = 90;

  /// Second-half stoppage time (added minutes after 90), from the engine result.
  /// The clock plays these out as "90+1", "90+2", … before full time or extra
  /// time, so a goal snatched in added time is seen going in.
  int _stoppage = 0;

  /// How many stoppage minutes have been revealed so far (0.._stoppage). Only
  /// meaningful while the clock sits at 90.
  int _added = 0;

  // --- Pitch mode ------------------------------------------------------------
  // In Pitch mode the Pitch view's clock runs the match: the screen reads
  // its minute and added minute off it (see [PitchPlayback.positionAt]) in
  // place of the 360 ms tick, which the Timeline keeps. Every pause is the
  // screen's as before; the clock is only ever told to play or stop.

  /// How this match is being watched: null until the remembered choice has
  /// loaded or, when there is none, until the manager picks one before
  /// kick-off. A tablet watches the Timeline (its Pitch view is still to
  /// come).
  MatchViewMode? _mode;

  bool get _onPitch => _mode == MatchViewMode.pitch;

  /// The picture, its clock and its building (see [PitchModeController]).
  /// Made in [initState], so [dispose] never has to reach for `ref`.
  late final PitchModeController _pc;

  /// Watches the app going to the background and back (see [_inForeground]).
  late final AppLifecycleListener _lifecycle;

  /// Whether the app is in front of the manager. Away (the phone locked, the
  /// app switched), the Pitch clock is held where it stands and played on
  /// from there when he is back: nothing is skipped while he is not looking.
  bool _inForeground = true;
  PitchPlayback? get _pitch => _pc.playback;
  PitchClock? get _pitchClock => _pc.clock;
  final _pitchViewKey = GlobalKey<PitchMatchViewState>();

  /// Events of the minute on the clock that the picture has not shown yet:
  /// a goal still on its way in. Hidden from the score, the Timeline and
  /// the stats until it is. Switched to the Timeline part-way through a
  /// minute, its next tick shows them before moving on.
  Set<MatchEventKey> _held = const {};

  /// The final whistle has gone (its sound, the shootout's taker sheet).
  bool _whistled = false;

  // --- MatchScreenProbe (tests) ---------------------------------------------

  @override
  PitchModeController get pitchMode => _pc;
  @override
  MatchResult? get result => _result;
  @override
  MatchViewMode? get mode => _mode;
  @override
  List<MatchEvent> get shownEvents => [
    for (final e in _result?.events ?? const <MatchEvent>[])
      if (_reached(e)) e,
  ];
  @override
  void switchMode() => _chooseMode(
    _livePreview!,
    _onPitch ? MatchViewMode.timeline : MatchViewMode.pitch,
  );
  @override
  void seekPitch(Duration t) {
    _pc.jump(t);
    _onPitchClock();
  }

  /// The extra-time / shootout outcome for a level knockout.
  KnockoutOutcome? _koOutcome;

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
  bool get _knockoutDone =>
      !_isShootout ||
      (_penRevealed >= _penTotal &&
          // On the pitch, the last kick is still being played out until the
          // stage is idle.
          !(_onPitch && (_stage?.running ?? false)));

  /// The playing clock has run out: past the last minute, and — while still in
  /// regulation (minute 90) — through all the stoppage minutes too. Extra time
  /// (minute > 90) carries no added time here, so it ends at [_fullTimeMinute].
  ///
  /// In Pitch mode the last minute is on the clock while it is still being
  /// played, so there it is over once the Pitch clock has run out.
  ///
  /// Once the final whistle HAS gone ([_whistled]), on either view, the
  /// match is over whatever any Pitch clock says. A clock is only a picture
  /// of the match: a fresh one (built after the whistle) starts at nought,
  /// and one left from an earlier spell on the 2D TV stands wherever it was
  /// put down. Asked of either, "over?" said no for a match the Timeline
  /// had already whistled, the picture was placed short of the whistle and
  /// never run again, and full time (its Continue) never came back.
  bool get _clockDone {
    final reached =
        _minute >= _fullTimeMinute &&
        (_minute > 90 || _added >= _stoppage) &&
        _held.isEmpty;
    if (!reached || !_onPitch || _whistled) return reached;
    return _pitchClock?.finished ?? true;
  }

  /// True once the match is truly over (regulation + stoppage, extra time, or
  /// the shootout reveal has finished) — drives the full-time UI.
  bool get _fullTime => _clockDone && _knockoutDone;

  /// Whether an event has been reached by the current clock position, honouring
  /// added time: a 90+3 event only shows once the stoppage clock passes +3.
  ///
  /// In the minute on the clock, an event the Pitch view has not shown yet
  /// ([_held]) has not been reached.
  bool _reached(MatchEvent e) {
    if (e.minute != _minute) return e.minute < _minute;
    // same minute — gate stoppage by +X revealed
    return e.stoppage <= _added &&
        (_held.isEmpty || !_held.contains(_keyOf(e)));
  }

  /// [e]'s key (see [MatchEventKey]): among the picture's events when it is
  /// one of them, otherwise the result's.
  MatchEventKey _keyOf(MatchEvent e) {
    final pitch = _pitch?.result.events;
    return (pitch == null ? null : matchEventKeyIn(pitch, e)) ??
        matchEventKey(_result?.events ?? const [], e);
  }

  @override
  void initState() {
    super.initState();
    _pc = PitchModeController(
      vsync: this,
      builder: ref.read(pitchPlaybackBuilderProvider),
      inPlace: ref.read(pitchPlaybackInPlaceProvider),
      onTick: _onPitchClock,
    );
    _lifecycle = AppLifecycleListener(onStateChange: _onAppState);
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

  void _onAppState(AppLifecycleState state) {
    final front = state == AppLifecycleState.resumed;
    if (front == _inForeground) return;
    _inForeground = front;
    _syncPitchClock();
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _timer?.cancel();
    _flashTimer?.cancel();
    _eventTimer?.cancel();
    _penTimer?.cancel();
    _redTimer?.cancel();
    _stage?.dispose();
    _pc.dispose();
    super.dispose();
  }

  /// Prepares the extra-time / shootout sequence for a level knockout, from
  /// the current result. Recomputed on every build: the ninety can still
  /// change with live tactics, and from the huddle on so can extra time,
  /// because the engine plays it. What has already been shown never moves (a
  /// change lands on the minute after the clock), so nothing has to be locked.
  void _ensureKnockoutSetup(MatchPreview preview, MatchResult r) {
    final o = _knockoutOutcome(preview, r);
    _koOutcome = o;
    _fullTimeMinute = o == null ? 90 : 120;
  }

  /// Names the five takers before the shootout, then reveals it. Dismissing
  /// the sheet keeps the automatic order — the shootout always goes ahead.
  Future<void> _askPenaltyOrder(MatchPreview preview) async {
    final r = _result;
    final chosen = await showAdaptiveSheet<List<Player>>(
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

  /// Starts revealing the shootout kicks one at a time: on the Timeline a
  /// strip ticking every 750 ms, on the pitch each kick staged in full.
  void _startShootout() {
    _shootoutStarted = true;
    _driveShootout();
  }

  /// Whether the shootout has begun (the takers are named): from here the
  /// kicks run, on whichever view the manager is on.
  bool _shootoutStarted = false;

  /// The shootout on the pitch, made when the first kick is staged.
  ShootoutStageController? _stage;

  /// Runs the rest of the shootout on the view the manager is on now. It is
  /// the one place that starts or stops either reveal, so a switch between
  /// the Timeline and the pitch mid-shootout carries on from the same tally.
  void _driveShootout() {
    final r = _penRevealed;
    if (!_shootoutStarted || r >= _penTotal) {
      _penTimer?.cancel();
      _stage?.stop();
      return;
    }
    if (_onPitch) {
      final script = _pitch?.script;
      final o = _koOutcome;
      // Waits for the picture (a bake, a build): onReady drives it again.
      if (script == null ||
          o == null ||
          !(_pitchViewKey.currentState?.ready.value ?? false)) {
        return;
      }
      _penTimer?.cancel();
      _penTimer = null;
      final stage = _stage ??= ShootoutStageController(
        vsync: this,
        kicks: ShootoutStaging.order(o),
        cast: ShootoutCast.of(script),
        onResult: _onShootoutResult,
        onDone: () {
          if (mounted) setState(() {});
        },
      );
      if (!stage.running) stage.start(r);
      return;
    }
    _stage?.stop();
    if (_penTimer?.isActive ?? false) return;
    _penTimer = Timer.periodic(const Duration(milliseconds: 750), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _penRevealed++);
      if (_penRevealed >= _penTotal) t.cancel();
    });
  }

  /// A staged kick's result has landed: the tally moves with it.
  void _onShootoutResult(int index) {
    if (!mounted) return;
    setState(() => _penRevealed = math.max(_penRevealed, index + 1));
  }

  void _begin() {
    _started = true;
    MatchFeedback.kickoff(ref.read(soundHapticsEnabledProvider));
    _restartTimer();
  }

  /// The base tick length for the current speed.
  Duration get _tick =>
      Duration(milliseconds: (360 / _speeds[_speedIdx]).round());

  /// Sets the match clock going again, or keeps it stopped, as things stand:
  /// the 360 ms tick in Timeline mode, the Pitch clock in Pitch mode.
  void _restartTimer() {
    _timer?.cancel();
    if (_onPitch) {
      _syncPitchClock();
      return;
    }
    // Never under a goal flash: its timer restarts play when it clears.
    if (!_playing || _clockDone || _goalFlash != null) return;
    _scheduleTick(_tick);
  }

  /// Stops whichever clock is running.
  void _stopClock() {
    _timer?.cancel();
    _pitchClock?.pause();
  }

  void _scheduleTick(Duration delay) {
    _timer = Timer(delay, () {
      if (!mounted || !_playing) return;
      var scored = false;
      var tickStoppage = 0;
      setState(() {
        if (_held.isNotEmpty) {
          // Back from the Pitch view part-way through a minute: the rest of
          // that minute first, flashed as it would have been.
          final held = _held;
          _held = const {};
          tickStoppage = _minute == 90 ? _added : 0;
          for (final e in _result?.events ?? const <MatchEvent>[]) {
            if (e.type == MatchEventType.goal && held.contains(_keyOf(e))) {
              _flashGoal(e);
              scored = true;
            }
          }
        } else if (_minute < 90) {
          // Normal play.
          _minute++;
          _flashEventsAt(_minute, 0);
          scored = _flashGoalAt(_minute, 0);
        } else if (_added < _stoppage) {
          // Second-half stoppage: the clock holds at 90 and counts +1, +2, …
          _added++;
          tickStoppage = _added;
          _flashEventsAt(90, _added);
          scored = _flashGoalAt(90, _added);
        } else if (_minute < _fullTimeMinute) {
          // Extra time (a level knockout) resumes after stoppage.
          _minute++;
          _flashEventsAt(_minute, 0);
          scored = _flashGoalAt(_minute, 0);
        }
        if (_clockDone) _whistleFullTime();
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

  /// The final whistle: the clock stops for good, and a level knockout that
  /// reached the shootout asks for the takers. Call inside `setState`.
  void _whistleFullTime() {
    _whistled = true;
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

  /// Flashes the "GOAL!" overlay for a goal scored on [minute] and pauses the
  /// clock until it clears; returns whether one was shown so the tick loop
  /// hands the resume to the flash timer.
  bool _flashGoalAt(int minute, int stoppage) {
    // Extra-time goals are engine events with their real minutes, so they
    // flash and pause the clock like any other. Stoppage goals (90+X) match on
    // the added-time index too, so they flash on their exact "90+X" tick.
    for (final e in _result?.events ?? const <MatchEvent>[]) {
      if (e.type == MatchEventType.goal &&
          e.minute == minute &&
          e.stoppage == stoppage) {
        _flashGoal(e);
        return true;
      }
    }
    return false;
  }

  /// The pop-up for a substitution [e]: shown a moment, as
  /// the goal's is, while play goes on. Call inside `setState`.
  void _flashEvent(MatchEvent e) {
    _eventFlash = e;
    _eventTimer?.cancel();
    _eventTimer = Timer(kEventFlashHold, () {
      if (mounted) setState(() => _eventFlash = null);
    });
  }

  /// The pop-ups for the substitutions of [minute] (+ [stoppage]) on the
  /// Timeline's tick: the last of them shows.
  void _flashEventsAt(int minute, int stoppage) {
    MatchEvent? last;
    for (final e in _result?.events ?? const <MatchEvent>[]) {
      if (flashesAsEvent(e) && e.minute == minute && e.stoppage == stoppage) {
        last = e;
      }
    }
    if (last != null) _flashEvent(last);
  }

  /// Flashes the "GOAL!" overlay for [e] and holds the clock until it
  /// clears. Call inside `setState`.
  void _flashGoal(MatchEvent e) {
    _goalFlash = e;
    MatchFeedback.goal(ref.read(soundHapticsEnabledProvider));
    _pitchClock?.pause();
    _flashTimer?.cancel();
    _flashTimer = Timer(kGoalFlashHold, () {
      if (!mounted) return;
      setState(() => _goalFlash = null);
      // Resume only if nothing else has taken over the clock (half-time in
      // the same minute, a manual pause, or full time) — those paths own
      // their own resume. Injuries no longer pause play.
      if (_playing && !_clockDone && !_atInterval) {
        _restartTimer();
      }
    });
  }

  /// The manager's own players sent off so far in this match.
  ///
  /// A red card ends that player's game: he leaves the pitch for good, can't be
  /// replaced, and must not appear among the substitutes. Derived from the
  /// event list rather than accumulated, so it stays correct across the
  /// re-simulations a tactical change triggers.
  Set<int> _sentOffIds() => {
    for (final e in _cardsNow().entries)
      if (e.value.sentOff) e.key,
  };

  /// The card each of the manager's own players is carrying right now.
  ///
  /// The one source the pitch, the substitution lists and [_sentOffIds] all
  /// read, so a booked man wears his card everywhere a substitution is made
  /// from, not only on the formation, and a second booking turns his yellow
  /// into the red that took him off in all of them at once.
  Map<int, MatchCard> _cardsNow() {
    final events = _result?.events;
    final nation = _playerNationId;
    if (events == null || nation == null) return const {};
    return cardStatusFor(events, nationId: nation, upToMinute: _minute);
  }

  /// Pauses playback and raises the injury overlay if one of the manager's own
  /// players is hurt on [minute] (once each). Returns whether play paused.
  void _checkInjuryAt(int minute, int stoppage) {
    final events = _result?.events;
    if (events == null) return;
    for (final e in events) {
      if (e.minute == minute && e.stoppage == stoppage && _checkInjury(e)) {
        return; // one injury at a time
      }
    }
  }

  /// Pauses and opens the squad if [e] is an injury to one of the manager's
  /// own players not yet dealt with. Returns whether it did.
  bool _checkInjury(MatchEvent e) {
    if (_playerNationId == null) return false;
    if (e.type != MatchEventType.injury ||
        e.teamNationId != _playerNationId ||
        _injuriesPrompted.contains(e.playerId)) {
      return false;
    }
    _injuriesPrompted.add(e.playerId);
    _stopClock();
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
    return true;
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
    _stopClock();
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
      _stopClock();
      setState(() {
        _playing = false;
        _atExtraTimeStart = true;
      });
      return true;
    }
    if (!_extraTimeHalfTaken && _minute >= 105) {
      _extraTimeHalfTaken = true;
      _stopClock();
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
    // A talk for the period about to start: 91' at the huddle, 106' at the
    // turnaround. The engine plays it from that minute, so the extra time
    // already watched cannot move; the turnaround talk also steadies the
    // takers ([_shootoutComposure]), read when the kicks are drawn.
    final minute = atStart ? 91 : 106;
    setState(() {
      if (atStart) {
        _extraTimeTalk = tone;
      } else {
        _extraTimeHalfTalk = tone;
      }
      _talks
        ..removeWhere((t) => t.minute == minute)
        ..add(
          TeamTalk(
            teamNationId: preview.playerNationId,
            minute: minute,
            tone: tone,
          ),
        );
      _result = _resim(preview);
      _ensureKnockoutSetup(preview, _result!);
    });
    _afterPitchChange(preview);
  }

  /// Dismisses the injury overlay and resumes play a man down (only offered
  /// when no substitution can be made — subs spent or an empty bench).
  bool _isKnockoutFixture(Fixture f) => Rounds.isKnockout(f.round);

  /// The extra-time-and-shootout outcome of a level knockout, or null when the
  /// tie was decided in 90 minutes (or isn't a knockout). Extra time is the
  /// engine's ([MatchResult.extraTime]); only a shootout is drawn here, and it
  /// is handed to the season service as is, so the drama shown and the stored
  /// result never disagree.
  KnockoutOutcome? _knockoutOutcome(MatchPreview preview, MatchResult r) {
    if (!_isKnockoutFixture(preview.fixture) || r.homeScore != r.awayScore) {
      return null;
    }
    // A level ninety without engine extra time is only a hand-built result
    // (the screen always asks for it): read it as extra time that changed
    // nothing, so the tie still goes to penalties rather than nowhere.
    final et = r.extraTime ?? (homeScore: r.homeScore, awayScore: r.awayScore);
    if (et.homeScore != et.awayScore) {
      return KnockoutOutcome(
        homeScore: et.homeScore,
        awayScore: et.awayScore,
        afterExtraTime: true,
        homeKicks: const [],
        awayKicks: const [],
      );
    }
    // Who takes them decides them. The kicks have a stream of their own, so
    // naming takers changes the kicks and never the extra time the manager
    // just watched.
    final composure = _shootoutComposure();
    final myTakers = _penTakers(preview);
    final mySkill = [
      for (final s in PenaltyTakers.skillOrder(
        myTakers,
        traitsByPlayer: _playerTeam(preview).traitsByPlayer,
      ))
        s * composure,
    ];
    final oppTeam = _opponentTeam(preview);
    final oppTakers = PenaltyTakers.autoOrder(
      _opponentOnPitch(preview, r),
      unavailable: _sentOff(r, oppTeam.nationId),
      traitsByPlayer: oppTeam.traitsByPlayer,
    );
    final oppSkill = PenaltyTakers.skillOrder(
      oppTakers,
      traitsByPlayer: oppTeam.traitsByPlayer,
    );
    return WorldCupFinals.decideShootout(
      et.homeScore,
      et.awayScore,
      SeededRng.forFixture(_seed(preview), preview.fixture.id ^ 0x7F),
      homeTakerSkill: preview.playerIsHome ? mySkill : oppSkill,
      awayTakerSkill: preview.playerIsHome ? oppSkill : mySkill,
      homeTakerIds: [
        for (final p in preview.playerIsHome ? myTakers : oppTakers) p.id,
      ],
      awayTakerIds: [
        for (final p in preview.playerIsHome ? oppTakers : myTakers) p.id,
      ],
    );
  }

  /// The opposition, as fielded (the manager's own side is [_playerTeam]).
  MatchTeam _opponentTeam(MatchPreview preview) =>
      preview.playerIsHome ? preview.awayTeam : preview.homeTeam;

  /// Who the opposition has on the pitch at full time (see
  /// [sideOnPitchAtEnd]); only they can take a kick, as with the manager's own
  /// side.
  List<Player> _opponentOnPitch(MatchPreview preview, MatchResult r) =>
      sideOnPitchAtEnd(
        team: _opponentTeam(preview),
        bench: preview.opponentBench,
        plannedSubs: preview.opponentSubs,
        events: r.events,
      );

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

  /// Full time's Share: the result as an image (square or story). The card
  /// shows a shootout's LEVEL score with the kicks beside it, not the extra
  /// goal [_finalScore] credits the winner with.
  Widget _shareButton(MatchPreview preview, MatchResult r) {
    final data = matchShareData(
      context,
      fixture: preview.fixture,
      nations: preview.nations,
      result: r,
      ground: preview.ground,
      confederation: preview.nations[preview.playerNationId]?.confederation,
      world: ref.watch(localizedWorldProvider),
      outcome: _knockoutOutcome(preview, r),
    );
    final f = preview.fixture;
    return ShareCardButton(
      fileStem:
          'fnm-${preview.nations[f.homeNationId]?.code ?? 'home'}-'
          '${preview.nations[f.awayNationId]?.code ?? 'away'}',
      flagCodes: matchShareFlags(data),
      images: matchShareImages(data),
      height: 52,
      card: (format) => MatchShareCard(data: data, format: format),
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

  // --- Pitch mode ------------------------------------------------------------

  /// Builds the picture for the current result and speed (off the UI
  /// thread), unless it is already on show. With [resume] (a re-sim or a new
  /// speed while it is on show) it is told from where the old one stands and
  /// the clock goes there: the same match position, never back; the old
  /// picture stays, held, until it is in. Otherwise it is told from kick-off
  /// and the clock goes to the end of the minute the screen is on.
  Future<void> _rebuildPitch(
    MatchPreview preview, {
    bool resume = false,
  }) async {
    final r = _result;
    if (r == null || _pc.isCurrentFor(r, _speedIdx)) return;
    final stadium = _pc.stadium ??= pitchStadiumForPreview(
      preview,
      weather: ref.read(pitchForcedWeatherProvider),
    );
    if (_pc.names.isEmpty) _pc.names = pitchNamesForPreview(preview);
    final clock = _pitchClock;
    final fromHere =
        resume &&
        clock != null &&
        clock.value > Duration.zero &&
        !clock.finished &&
        !_clockDone;
    // Whether the match is over, read before the controller swaps its clock
    // (see [_clockDone]: after the whistle it is the match's state, not the
    // clock's, that answers).
    final over = _clockDone;
    final built = _pc.build(
      result: r,
      lineups: matchLineupsFromPreview(preview, result: r, changes: _changes),
      speedStep: _speedIdx,
      seed: _seed(preview),
      isFinal: stadium.dressing.isFinal,
      resume: fromHere,
      place: (pb) => over ? pb.pacer.total : pb.endOf(_minute, _added),
    );
    if (mounted) setState(() {});
    final shown = await built;
    if (!mounted) return;
    // A failed build shows its error state in place of the spinner.
    setState(() {});
    if (!shown) return;
    if (!_onPitch) return;
    _syncPitchState(announce: true);
    _restartTimer();
  }

  /// After the result or the speed changed: the Pitch view, when it is on
  /// show, picks the new match up where it stands.
  void _afterPitchChange(MatchPreview preview) {
    if (!_onPitch || !mounted) return;
    unawaited(_rebuildPitch(preview, resume: true));
  }

  /// Watches the match as [mode] from here on: the Pitch view's clock is
  /// put on the minute the Timeline reached, or the Timeline picks up the
  /// minute the Pitch view is in (with whatever of it is still to show).
  void _applyMode(MatchPreview preview, MatchViewMode mode) {
    if (_mode == mode || !mounted) return;
    _stopClock();
    setState(() => _mode = mode);
    if (mode == MatchViewMode.pitch) {
      final r = _result;
      // Past the last minute the speed paces nothing: a picture of this
      // match at another speed still serves the shootout.
      if (r != null &&
          (_pc.isCurrentFor(r, _speedIdx) ||
              (_clockDone && _pc.isCurrentFor(r, null)))) {
        // The picture is still this match's. Part-way through a minute
        // with something of it still to show (paused, then the Timeline
        // and back without a tick): it is played out from where it stood.
        if (_held.isEmpty) {
          _pc.jump(
            _clockDone ? _pitch!.pacer.total : _pitch!.endOf(_minute, _added),
          );
        }
        _syncPitchState(announce: true);
      } else {
        unawaited(_rebuildPitch(preview));
      }
    } else if (_started && _held.isEmpty && !_atInterval) {
      // The Pitch view hands over the minute it was in with all of it shown:
      // that minute is over. Its whistle goes before the Timeline plays
      // another (a talk at 46, 91 or 106 must not re-play a minute already
      // watched), and so does full time.
      if (_checkHalfTime() || _checkExtraTimeBreaks()) return;
      if (_clockDone && !_whistled) {
        setState(_whistleFullTime);
        return;
      }
    }
    if (_started) _restartTimer();
    // A shootout under way carries on from the same tally on the other view.
    if (_shootoutStarted) _driveShootout();
  }

  /// The manager's choice, before kick-off or from the header: watched that
  /// way now, and remembered for the next match.
  void _chooseMode(MatchPreview preview, MatchViewMode mode) {
    unawaited(ref.read(matchViewModeProvider.notifier).choose(mode));
    if (_firstAsk) {
      // A new career's first match: asked once, never again.
      _firstAsk = false;
      unawaited(
        ref
            .read(matchViewModeStoreProvider)
            .clearFirstMatchAsk(widget.careerId)
            .then((_) {
              if (mounted) {
                ref.invalidate(firstMatchViewAskProvider(widget.careerId));
              }
            }),
      );
    }
    _applyMode(preview, mode);
  }

  /// Whether this match is a new career's first and asks how to watch
  /// before kick-off, whatever the device remembers (read once).
  bool _firstAsk = false;
  bool _firstAskRead = false;

  /// Plays the Pitch clock when the match should be running, its picture is
  /// in and the ground is baked, and holds it otherwise. A bake finishing
  /// never starts a clock the manager stopped: [_playing] is his.
  void _syncPitchClock() {
    // The ground has just been baked (or the picture came back): a
    // shootout waiting for it can begin.
    if (_shootoutStarted) _driveShootout();
    final c = _pitchClock;
    if (c == null) return;
    final ready = _pitchViewKey.currentState?.ready.value ?? false;
    final go =
        _onPitch &&
        _started &&
        _playing &&
        ready &&
        _pitch != null &&
        _inForeground &&
        !_pc.building &&
        _goalFlash == null &&
        !_atInterval &&
        !_clockDone;
    if (go) {
      c.play();
    } else {
      c.pause();
    }
  }

  /// Every tick of the Pitch clock.
  void _onPitchClock() {
    if (!mounted || !_onPitch) return;
    final pb = _pitch;
    final clock = _pitchClock;
    if (pb == null || clock == null || _pc.building) return;
    // An interval stops play on its whistle, not a frame past it.
    final extra = _fullTimeMinute > 90;
    final whistle = PitchModeController.dueWhistle(clock.value, [
      (pb.halfTime, _halfTimeTaken),
      (extra ? pb.extraTimeStart : null, _extraTimeStartTaken),
      (extra ? pb.extraTimeHalf : null, _extraTimeHalfTaken),
    ]);
    if (whistle != null) {
      clock.pause();
      _pc.jump(whistle - const Duration(microseconds: 1));
    } else {
      // So does a goal or an injury to one of his own, which pause play
      // as they show: on its own minute, never a frame into the next, however
      // long the frame.
      final stop = _pc.dueStop(
        clock.value,
        (e) =>
            !_reached(e) &&
            (e.type == MatchEventType.goal ||
                (e.type == MatchEventType.injury &&
                    e.teamNationId == _playerNationId &&
                    !_injuriesPrompted.contains(e.playerId))),
      );
      if (stop != null) _pc.jump(stop);
    }
    _pc.markRead();
    _syncPitchState(announce: true);
    if (whistle != null && !_checkHalfTime()) _checkExtraTimeBreaks();
    if (clock.finished && !_whistled) setState(_whistleFullTime);
  }

  /// Reads the minute, the added minute and what is still to show off the
  /// Pitch clock. With [announce], what has just come into view is played
  /// as the Timeline plays it: a goal flashes, an injury to one of the
  /// manager's own opens the squad.
  void _syncPitchState({required bool announce}) {
    if (_pitch == null || _pitchClock == null || _pc.building) return;
    final events = _pitch!.result.events;
    final before = announce
        ? {
            for (final e in events)
              if (_reached(e)) _keyOf(e),
          }
        : null;
    final now = _pc.read(minute: _minute, added: _added, held: _held);
    final changed =
        now.minute != _minute ||
        now.added != _added ||
        now.held.length != _held.length ||
        !now.held.every(_held.contains);
    if (!changed) return;
    final arrived = <MatchEvent>[];
    setState(() {
      _minute = now.minute;
      _added = now.added;
      _held = now.held;
      if (before == null) return;
      MatchEvent? goal;
      MatchEvent? notice;
      MatchEvent? red;
      for (final e in events) {
        if (!_reached(e) || before.contains(_keyOf(e))) continue;
        if (e.type == MatchEventType.goal) goal = e;
        if (flashesAsEvent(e)) notice = e;
        if (e.type == MatchEventType.redCard) red = e;
        arrived.add(e);
      }
      if (notice != null) _flashEvent(notice);
      if (goal != null) _flashGoal(goal);
      if (red != null) _showRedCard(red);
    });
    for (final e in arrived) {
      if (_checkInjury(e)) break;
    }
  }

  /// The 2D TV's red card banner for [e], shown as the referee raises the
  /// card, and a light buzz. Play goes on under it. Call inside `setState`.
  void _showRedCard(MatchEvent e) {
    _redFlash = e;
    MatchFeedback.redCard(ref.read(soundHapticsEnabledProvider));
    _redTimer?.cancel();
    _redTimer = Timer(kRedCardBannerHold, () {
      if (mounted) setState(() => _redFlash = null);
    });
  }

  void _cycleSpeed() {
    setState(() => _speedIdx = (_speedIdx + 1) % _speeds.length);
    // The Pitch view paces the match for the speed: its picture is told
    // again from where it stands, at the new pace. Past the last minute
    // (the shootout) there is nothing left to pace, and a rebuild would hide
    // the kicks behind its spinner: the picture stays.
    final preview = _livePreview;
    if (_onPitch && preview != null && !_clockDone) {
      _afterPitchChange(preview);
    }
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
    _stopClock();
    final clock = _pitchClock;
    if (clock != null) _pc.jump(clock.total);
    final askPreview = _isShootout && !_penOrderAsked ? _livePreview : null;
    setState(() {
      _minute = _fullTimeMinute;
      _added = _stoppage;
      _held = const {};
      _whistled = true;
      _playing = false;
      // A skip taken AT an interval must not leave its panel sitting over the
      // finished match: the whistle those breaks were waiting for has gone.
      _atHalfTime = false;
      _atExtraTimeStart = false;
      _atExtraTimeHalf = false;
      if (askPreview != null) {
        // The sheet is about to open: it draws the kicks and reveals them.
        _penOrderAsked = true;
      } else {
        // Nothing left to ask — no shootout, or the takers are already named —
        // so every remaining kick lands now.
        _penTimer?.cancel();
        _penTimer = null;
        _penRevealed = _penTotal;
        _stage?.settle();
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
    // Read before any await: the tablet's unlocked card is a compact one.
    // (useTabletLayout's own test, with a read: this is not a build.)
    final compactUnlocked =
        ref.read(formFactorProvider) == FormFactor.tablet &&
        context.isWideTabletWindow;
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
      if (mounted) {
        await showAchievementsUnlocked(
          context,
          unlocked,
          compact: compactUnlocked,
        );
      }
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
    _liveFullBacks = team.fullBacks;
    _liveSwitches = team.switches;
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
  /// player's energy at the final whistle, so before then we walk it from a
  /// fresh 100 at kick-off down to that final value by the last minute played:
  /// 90', or 120' when there is extra time (otherwise the huddle would already
  /// show the legs the side has left after 120).
  Map<int, int> _liveEnergy(MatchResult r) {
    if (_fullTime) return r.energyByPlayer;
    final last = r.extraTime == null ? 90 : 120;
    final t = _minute.clamp(0, last) / last;
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

  /// When each man came on and when each went off, read back off the changes
  /// the manager has already made in this match.
  ///
  /// The tactics sheet sees one moment of the game, so on its own it could say
  /// no more about a substitute than "he is not a starter" — which is the half
  /// of the answer the manager already had. Walking the changes in order gives
  /// it the other half: the minute.
  ({Map<int, int> on, Map<int, int> off}) _subMinutes(MatchPreview preview) {
    final on = <int, int>{};
    final off = <int, int>{};
    var current = _playerTeam(preview).xi.map((p) => p.id).toSet();
    for (final c in _changes) {
      if (c.teamNationId != preview.playerNationId) continue;
      final next = c.xi.map((p) => p.id).toSet();
      for (final id in next.difference(current)) {
        on[id] = c.minute;
      }
      for (final id in current.difference(next)) {
        off[id] = c.minute;
      }
      current = next;
    }
    // A man sent off did not go off at the minute the manager next opened this
    // sheet; he went off when the referee sent him. Read from the events, the
    // same place [_sentOffIds] reads, so the two always agree.
    for (final e in _result?.events ?? const <MatchEvent>[]) {
      if (e.type == MatchEventType.redCard &&
          e.teamNationId == _playerNationId &&
          e.minute <= _minute) {
        off[e.playerId] = e.minute;
      }
    }
    return (on: on, off: off);
  }

  /// Opens the full in-match tactics editor and, if the manager confirms,
  /// records the change and re-simulates the rest of the match with it applied.
  Future<void> _openTactics(MatchPreview preview) async {
    final wasPlaying = _playing;
    if (_playing) _togglePlay();
    final team = _playerTeam(preview);
    // So the manager can see who's tiring when choosing a substitution.
    final energyNow = _liveEnergy(_result ?? preview.result);
    final minutes = _subMinutes(preview);
    // The save's named presets, so a style is one tap away mid-match and at
    // every break; whatever is picked comes back as an ordinary change.
    // A failed read must never stop the editor opening (the injury pause
    // depends on it): fall back to no presets.
    final List<TacticPreset> presets = await ref
        .read(tacticPresetsProvider(widget.careerId).future)
        .catchError((Object _) => const <TacticPreset>[]);
    if (!mounted) return;
    final result = await showInMatchTactics(
      context,
      presets: presets,
      minute: _minute.clamp(1, _fullTimeMinute),
      formation: _liveFormation,
      lineup: _liveLineup,
      instructions: _liveInstructions,
      fullBacks: _liveFullBacks,
      switches: _liveSwitches,
      pool: _playerPool(preview),
      startingIds: team.xi.map((p) => p.id).toSet(),
      maxSubs: _maxSubsFor(preview),
      takers: _takers ??= (
        penalty: team.penaltyTakerId,
        deadBall: team.deadBallTakerId,
      ),
      throwIn: _throwIn ??= (
        style: team.throwInStyle,
        taker: team.throwInTakerId,
      ),
      injuredIds: _injuredIds,
      sentOffIds: _sentOffIds(),
      cardsByPlayer: _cardsNow(),
      energyByPlayer: energyNow,
      // So the squad list can say who started and who came on when, rather
      // than leaving the manager to work it out from the discs on the pitch.
      cameOnAt: minutes.on,
      wentOffAt: minutes.off,
      // Your kit on your players' discs — the same identity the pre-match
      // tactics pitch shows, rather than a neutral grey mid-game.
      teamColors: () {
        final n = preview.nations[preview.playerNationId];
        return n == null
            ? null
            : KitColors.discFill(n.primaryColor, n.secondaryColor);
      }(),
      tabletLayout: useTabletLayout(context, ref),
    );
    if (result != null && mounted) await _applyTactics(preview, result);
    if (wasPlaying && !_clockDone && !_atInterval && !_playing) _togglePlay();
  }

  /// The substitutions allowed right now. A friendly has no cap but the bench
  /// (nobody comes back on, so the bench is the natural limit); otherwise one
  /// more once a level knockout is through the ninety. Its regulation is
  /// settled by then (a change made at 90 or in stoppage lands at 91), so the
  /// sixth can only touch extra time.
  int _maxSubsFor(MatchPreview preview) => maxSubsAllowed(
    friendly: preview.fixture.round == Rounds.friendly,
    benchSize: preview.bench.length,
    extraTime: _fullTimeMinute > 90 && _minute >= 90,
  );

  /// The nation the manager is NOT controlling in this fixture — the side whose
  /// tactics the engine reactively manages by the scoreline.
  int _opponentNationId(MatchPreview preview) =>
      preview.homeTeam.nationId == preview.playerNationId
      ? preview.awayTeam.nationId
      : preview.homeTeam.nationId;

  /// Re-runs the whole match from its seed with every change and team talk the
  /// manager has made applied, and the AI opponent reactively managed. Shared by
  /// the tactics editor and the interval team talk so both stay deterministic.
  ///
  /// A level knockout plays on through extra time in the engine, with the AI
  /// side's one extra-time change folded in, exactly as the preview did.
  MatchResult _resim(MatchPreview preview) => playWithAiExtraTimeSub(
    play: (subs) => _engine.play(
      home: preview.homeTeam,
      away: preview.awayTeam,
      rng: SeededRng.forFixture(_seed(preview), preview.fixture.id),
      subs: subs,
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
      extraTimeIfLevel: _isKnockoutFixture(preview.fixture),
      conditions: preview.conditions,
    ),
    aiSubs: preview.opponentSubs,
    aiTeam: _opponentTeam(preview),
    aiBench: preview.opponentBench,
    saveSeed: preview.saveSeed,
    fixtureId: preview.fixture.id,
  );

  Future<void> _applyTactics(
    MatchPreview preview,
    InMatchTacticsResult r,
  ) async {
    final byId = {for (final p in _playerPool(preview)) p.id: p};
    // Each man with the place he was put in, so a hole a red card left stays
    // where the manager moved it rather than sliding to the last slot.
    final xi = <Player>[];
    final slots = <PlayerPosition>[];
    for (var i = 0; i < r.lineup.length; i++) {
      final p = byId[r.lineup[i]];
      if (p == null) continue;
      xi.add(p);
      slots.add(r.positions[i]);
    }
    // Take effect from the NEXT minute, never the one just played. A change
    // stamped on the current minute made the re-sim replay that minute with the
    // new XI — so a goal the manager had already watched go in (popup and all)
    // could vanish from the rebuilt event list, leaving a "GOAL!" flash with no
    // goal on the scoreboard. Past minutes are now always replayed identically.
    //
    // At 90 (stoppage included) this lands on 91: a level knockout's extra
    // time plays it, and the ninety already watched is never rewritten. In a
    // match with no extra time it lands past the last minute and is inert,
    // updating the lineups display only.
    final minute = _minute + 1;
    final takersChanged = r.takers != _takers;
    final throwInChanged = r.throwIn != _throwIn;
    final throwerChanged = r.throwIn.taker != _throwIn?.taker;
    setState(() {
      _liveFormation = r.formation;
      _liveLineup = r.lineup;
      _liveInstructions = r.instructions;
      _liveFullBacks = r.fullBacks;
      _liveSwitches = r.switches;
      _takers = r.takers;
      _throwIn = r.throwIn;
      // Any hurt player taken off is no longer flagged as an unaddressed injury.
      _injuredIds.removeWhere((id) => !r.lineup.contains(id));
      _changes.add(
        TacticalChange(
          teamNationId: preview.playerNationId,
          minute: minute,
          formation: r.formation,
          instructions: r.instructions,
          fullBacks: r.fullBacks,
          switches: r.switches,
          xi: xi,
          slots: slots,
          // From this minute on, never retroactively: the penalty already
          // taken stays taken by whoever took it.
          takers: takersChanged ? r.takers : null,
          throwIn: throwInChanged ? r.throwIn : null,
        ),
      );
      _result = _resim(preview);
    });
    _afterPitchChange(preview);
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
    // The thrower outlives the match like the other takers. The STYLE does
    // not: like the dials and the full-backs' arrows, it is a call for this
    // match, and the team sheet keeps its own.
    if (throwerChanged) {
      await ref
          .read(throwInTakerStoreProvider)
          .set(widget.careerId, r.throwIn.taker);
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
    _afterPitchChange(preview);
  }

  /// The manager's side as it stands on the pitch right now, with each man's
  /// energy: the centre of the tablet match. Read only; a tap anywhere on it
  /// opens the tactics editor, where changes are made.
  Widget _livePitch(MatchPreview preview, MatchResult r) {
    final byId = {for (final p in _playerPool(preview)) p.id: p};
    final n = preview.nations[preview.playerNationId];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _fullTime ? null : () => _openTactics(preview),
      child: IgnorePointer(
        child: Center(
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: TacticsPitch(
              formation: _liveFormation,
              instructions: _liveInstructions,
              fullBacks: _liveFullBacks,
              switches: _liveSwitches,
              lineup: _liveLineup,
              byId: byId,
              teamColors: n == null
                  ? null
                  : KitColors.discFill(n.primaryColor, n.secondaryColor),
              energyByPlayer: _liveEnergy(r),
              cardsByPlayer: _cardsNow(),
              absentIds: {..._injuredIds, ..._sentOffIds()},
              injuredIds: _injuredIds,
              onTapSlot: (_) {},
              onSwap: (_, _) {},
              onBenchIn: (_, _) {},
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tablet = useTabletLayout(context, ref);
    // How this device watches matches: null while loading, or when the
    // manager has never chosen (he is asked before kick-off).
    final remembered = ref.watch(matchViewModeProvider);
    // A new career's first match asks, once, even on a device that has
    // chosen before (see MatchViewModeStore.markFirstMatchAsk).
    final firstAsk = ref.watch(firstMatchViewAskProvider(widget.careerId));
    if (!_firstAskRead && firstAsk.hasValue) {
      _firstAskRead = true;
      _firstAsk = firstAsk.value! && !_started;
    }
    final asking = !_firstAskRead || _firstAsk;
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
          // Never kick off from a preview being worked out again: during a
          // refresh the provider goes on handing out the previous one, and
          // whatever this screen is handed first it plays to the end. Back
          // from tactics with Kick off pressed quickly, that was the old XI,
          // the old shape and the old plan.
          skipLoadingOnRefresh: false,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l.matchCouldNotLoad('$e'))),
          data: (preview) {
            if (preview == null) {
              return Center(child: Text(l.matchNoUpcoming));
            }
            // Played from this attempt's own seed. The preview's result is
            // the bare fixture seed's match, so it only stands at salt 0.
            _result ??= _attemptSalt == 0 ? preview.result : _resim(preview);
            _livePreview = preview;
            _ensureLiveSetup(preview);
            final r = _result!;
            _stoppage = r.stoppage;
            _ensureKnockoutSetup(preview, r);
            // The tablet watches the Timeline for now; a phone the way the
            // manager last chose, or, never having chosen, the way he picks
            // before kick-off.
            // Never having chosen, the manager is asked before kick-off, on
            // a tablet as on a phone; the match waits for him.
            final wanted = remembered.valueOrNull;
            if (wanted != null && _mode == null && !asking) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _applyMode(preview, wanted);
              });
            }
            final choosing =
                _mode == null &&
                !remembered.isLoading &&
                _firstAskRead &&
                (_firstAsk || wanted == null);
            if (!_started && _mode != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_started) _begin();
              });
            }

            final homeId = preview.homeTeam.nationId;
            final awayId = preview.awayTeam.nationId;
            String code(int id) => preview.nations[id]?.code ?? '??';
            String name(int id) => preview.nations[id]?.name ?? 'Unknown';

            // Extra-time events are the engine's own, minutes 91-120, so the
            // clock reveals them like the ninety's.
            final shown = r.events.where(_reached).toList();
            final timelineEvents = [...shown]
              ..sort((a, b) {
                final byMin = a.minute.compareTo(b.minute);
                return byMin != 0 ? byMin : a.stoppage.compareTo(b.stoppage);
              });
            final ft = _fullTime;
            // Penalties given in play, for the Timeline and the stats. A
            // scored one comes in with its goal; a saved or missed one is
            // no event, so it comes in by its minute: the Timeline shows
            // the minute on the clock whole, the 2D TV may not have staged
            // it yet, so there it waits for the next.
            final penalties = inPlayPenalties(
              r,
              names: {
                for (final p in [
                  ...preview.homeTeam.xi,
                  ...preview.awayTeam.xi,
                  ...preview.bench,
                  ...preview.opponentBench,
                ])
                  p.id: p.name,
              },
              eventReached: _reached,
              momentReached: (minute, stoppage) {
                if (ft) return true;
                if (minute != _minute) return minute < _minute;
                return _onPitch ? stoppage < _added : stoppage <= _added;
              },
            );
            // (The Pitch view plays the 120th while it is on the clock.)
            final inExtraTime = _minute > 90 && !_clockDone;
            final inStoppage = _minute == 90 && _added > 0 && !ft;
            // While playing, the score is the running tally of shown goals,
            // extra time included; at full time it is the true recorded result
            // (a level knockout settled by a shootout), so the screen never
            // disagrees with what gets saved.
            final (finalHome, finalAway) = _finalScore(preview, r);
            final liveHome = shown
                .where((e) => e.type == MatchEventType.goal)
                .where((e) => e.teamNationId == homeId)
                .length;
            final liveAway =
                shown.where((e) => e.type == MatchEventType.goal).length -
                liveHome;
            final homeScore = ft ? finalHome : liveHome;
            final awayScore = ft ? finalAway : liveAway;
            final knockout = _koOutcome;
            // Reveal the shootout as it plays out (or in full once decided).
            final showingShootout = _isShootout && _clockDone;
            final decidedByShootout = ft && (knockout?.wentToShootout ?? false);

            // At a tournament's finals the header strip (and on the phone's
            // 2D TV the score bug) wears its colours; elsewhere both stay
            // plain.
            final finalsTheme = ScoreBugTheme.forRound(
              preview.fixture.round,
              preview.nations[preview.playerNationId]?.confederation,
            );
            final topBar = _TopBar(
              theme: finalsTheme,
              occasion: MatchStage.label(l, preview.fixture),
            );
            // The colours each side is WEARING on the pitch: the bar reads the
            // same clash decision the 2D view dresses the players from, so it
            // never shows one side blue while both run out in red.
            final homeNation = preview.nations[homeId];
            final awayNation = preview.nations[awayId];
            final (homeC, awayC) = homeNation != null && awayNation != null
                ? KitClash.barColours(homeNation, awayNation)
                : (AppColors.primary, AppColors.secondary);
            // The phone's Pitch mode: the score as a broadcast bug, whose
            // banner stands for the goal flash's card over the picture.
            final bug = !tablet && _onPitch;
            final bugTheme = bug ? finalsTheme : null;
            final clockLabel = ft
                ? (decidedByShootout
                      ? l.matchClockFullTimePenalties
                      : knockout != null
                      ? l.matchClockAfterExtraTime
                      : l.matchClockFullTime)
                : showingShootout
                ? l.matchClockPenalties
                : inExtraTime
                // No trailing apostrophe: it adds right-side width that
                // pushes the digits left of the plate's centre. The bare
                // number reads as the minute and sits dead-centre.
                ? 'ET $_minute'
                : inStoppage
                ? '90+$_added'
                : '$_minute';
            final scoreboard = MatchScoreboard(
              homeCode: code(homeId),
              awayCode: code(awayId),
              homeName: name(homeId),
              awayName: name(awayId),
              homeScore: homeScore,
              awayScore: awayScore,
              clock: clockLabel,
              live: !ft,
              halfTime: _minute > 45 || ft
                  ? l.matchHalfTimeScore(
                      shown
                          .where((e) => e.type == MatchEventType.goal)
                          .where((e) => e.minute <= 45)
                          .where((e) => e.teamNationId == homeId)
                          .length,
                      shown
                          .where((e) => e.type == MatchEventType.goal)
                          .where((e) => e.minute <= 45)
                          .where((e) => e.teamNationId != homeId)
                          .length,
                    )
                  : null,
              wholeNames: tablet,
              compact: bug,
              homeColor: homeC,
              awayColor: awayC,
              goal: bug ? _goalFlash : null,
              goalForHome: _goalFlash?.teamNationId == homeId,
              notice: bug && _redFlash == null ? _eventFlash : null,
              noticeForHome: _eventFlash?.teamNationId == homeId,
              bugTheme: bugTheme,
            );
            final Widget? momentum = !ft && !showingShootout
                ? _MomentumBar(
                    homePercent: _homeMomentum(preview, homeId),
                    homeCode: code(homeId),
                    awayCode: code(awayId),
                    homeColor: homeC,
                    awayColor: awayC,
                  )
                : null;
            final Widget? shootout = showingShootout || decidedByShootout
                ? _ShootoutStrip(
                    outcome: knockout!,
                    homeCode: code(homeId),
                    awayCode: code(awayId),
                    revealed: showingShootout ? _penRevealed : _penTotal,
                    homeTakers: preview.playerIsHome
                        ? _takerNames(preview)
                        : const [],
                    awayTakers: preview.playerIsHome
                        ? const []
                        : _takerNames(preview),
                  )
                : null;
            final timeline = MatchTimeline(
              events: timelineEvents,
              penalties: penalties,
              live: !ft,
              homeId: homeId,
            );
            final conditionsShown = matchConditionsShown(
              preview,
              weather: ref.read(pitchForcedWeatherProvider),
            );
            final stats = MatchStatsPanel(
              result: r,
              homeCode: code(homeId),
              awayCode: code(awayId),
              homeNationId: homeId,
              ground: preview.ground,
              neutral: preview.neutralVenue,
              groundCode: code(preview.ground.groundNationId),
              homeFans: preview.homeFans,
              // The 2D TV's own kick-off and weather, whichever view.
              kickOff: conditionsShown.kickOff,
              weather: conditionsShown.weather,
              // Read as of the clock, exactly like the timeline beside it, so
              // the box score moves through the match instead of arriving
              // whole at the whistle.
              minute: _minute,
              fullTime: ft,
              events: timelineEvents,
              penalties: penalties,
              // The tablet's 2D TV has the ground in its header band.
              showGround: !(tablet && _onPitch),
            );
            List<MatchEvent> subsOf(int nationId) => shown
                .where(
                  (e) =>
                      e.type == MatchEventType.substitution &&
                      e.teamNationId == nationId,
                )
                .toList();
            // The ratings: the stored marks at the whistle, and before it a
            // running mark built from the clock's events alone, so the tab
            // never shows a mark the match has not earned yet.
            final Map<int, double> lineupRatings;
            if (ft) {
              lineupRatings = {for (final x in r.ratings) x.playerId: x.rating};
            } else {
              final candidates = <int, Player>{
                for (final p in [
                  ...preview.homeTeam.xi,
                  ...preview.awayTeam.xi,
                  ...preview.bench,
                  ...preview.opponentBench,
                  ..._currentXi(preview),
                ])
                  p.id: p,
              };
              lineupRatings = LiveRatings.asOf(
                players: [
                  for (final p in candidates.values)
                    (id: p.id, nationId: p.nationId, category: p.category),
                ],
                starterIds: {
                  for (final p in preview.homeTeam.xi) p.id,
                  for (final p in preview.awayTeam.xi) p.id,
                },
                events: shown,
                moments: r.moments,
                homeNationId: homeId,
                minute: _minute,
                added: _added,
              );
            }
            final lineupList = MatchLineups(
              home: preview.playerIsHome
                  ? _currentXi(preview)
                  : preview.homeTeam.xi,
              away: preview.playerIsHome
                  ? preview.awayTeam.xi
                  : _currentXi(preview),
              homeCode: code(homeId),
              awayCode: code(awayId),
              homeSubs: subsOf(homeId),
              awaySubs: subsOf(awayId),
              homeBench: preview.playerIsHome
                  ? preview.bench
                  : preview.opponentBench,
              awayBench: preview.playerIsHome
                  ? preview.opponentBench
                  : preview.bench,
              ratings: lineupRatings,
              energy: _liveEnergy(r),
              events: timelineEvents,
              motmId: ft ? r.manOfTheMatch?.playerId : null,
              live: !ft,
            );
            // After the whistle: each side on the pitch with its marks, the
            // list a toggle away.
            FullTimeSide side(MatchTeam team, List<Player> bench) {
              final n = preview.nations[team.nationId];
              final byId = {for (final p in bench) p.id: p};
              return (
                nationId: team.nationId,
                code: code(team.nationId),
                team: team,
                cameOn: [
                  for (final e in subsOf(team.nationId)) ?byId[e.playerId],
                ],
                kit: n == null
                    ? null
                    : KitColors.discFill(n.primaryColor, n.secondaryColor),
                cards: cardStatusFor(
                  r.events,
                  nationId: team.nationId,
                  upToMinute: 200,
                ),
              );
            }

            final Widget lineups = ft
                ? MatchFullTimeLineups(
                    home: side(
                      preview.homeTeam,
                      preview.playerIsHome
                          ? preview.bench
                          : preview.opponentBench,
                    ),
                    away: side(
                      preview.awayTeam,
                      preview.playerIsHome
                          ? preview.opponentBench
                          : preview.bench,
                    ),
                    ratings: lineupRatings,
                    motmId: r.manOfTheMatch?.playerId,
                    playerNationId: preview.playerNationId,
                    list: lineupList,
                  )
                : lineupList;
            // The tablet's 2D TV: its goal and every other moment take the
            // header's strip in turn, never the picture (see [MatchTvHeader]).
            final tabletTv = tablet && _onPitch;
            final overlays = <Widget>[
              // A substitution pops up on the 2D TV only: the phone shows it
              // as the banner under the score bug, the tablet on its TV
              // header's strip. The Timeline never pops it up.
              if (_goalFlash != null && !bug && !tabletTv)
                _GoalFlash(
                  event: _goalFlash!,
                  flagCode: code(_goalFlash!.teamNationId),
                  goalNumber: homeScore + awayScore,
                ),
              // Half-time interval: play only resumes on Continue (the
              // manager may reshape the side first).
              if (_atHalfTime)
                HalfTimePrompt(
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
              // The two extra-time intervals of a level knockout: the huddle
              // before the first period, and the turnaround at 105'.
              if (_atExtraTimeStart || _atExtraTimeHalf)
                HalfTimePrompt(
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
                  maxSubs: _maxSubsFor(preview),
                  selectedTalk: _atExtraTimeStart
                      ? _extraTimeTalk
                      : _extraTimeHalfTalk,
                  // A different salt per interval, so the huddle and the
                  // turnaround don't offer the identical three lines.
                  options: offeredTalkTones(
                    preview.saveSeed,
                    preview.fixture.id ^ (_atExtraTimeStart ? 0x0E71 : 0x0E72),
                  ),
                  onTalk: (tone) => _applyExtraTimeTalk(
                    preview,
                    tone,
                    atStart: _atExtraTimeStart,
                  ),
                  onTactics: () => _openTactics(preview),
                  onContinue: _resumeFromExtraTimeBreak,
                ),
            ];

            final pb = _pitch;
            final clock = _pitchClock;
            final stadium = _pc.stadium;
            // While a picture told from kick-off is built (the first, or
            // back from the Timeline after a change), the old one belongs to
            // another moment: a spinner holds its place.
            final picture =
                pb != null &&
                clock != null &&
                stadium != null &&
                !_pc.buildingFresh;
            // The picture itself, or what stands in for it: the same on a
            // phone and on a tablet.
            final red = _redFlash;
            final Widget pitchSurface = picture
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      PitchMatchView(
                        key: _pitchViewKey,
                        script: pb.script,
                        stadium: stadium,
                        clock: clock,
                        names: _pc.names,
                        onReady: _syncPitchClock,
                        shootout: _stage,
                      ),
                      // A sending-off: its banner down from under the
                      // score, unless a goal's is out.
                      // (The tablet's TV has it on its header's strip.)
                      if (red != null && _goalFlash == null && !tablet)
                        Positioned(
                          top: 0,
                          left: AppSpacing.marginMobile + AppSpacing.sm,
                          right: AppSpacing.marginMobile + AppSpacing.sm,
                          child: _RedCardBanner(
                            key: ValueKey(('red', red.minute, red.playerId)),
                            event: red,
                            code: code(red.teamNationId),
                            color: red.teamNationId == homeId ? homeC : awayC,
                            still:
                                MediaQuery.maybeDisableAnimationsOf(context) ??
                                false,
                          ),
                        ),
                    ],
                  )
                : _pc.failed
                ? _PitchFailed(
                    onTimeline: () =>
                        _applyMode(preview, MatchViewMode.timeline),
                  )
                : const ColoredBox(
                    color: AppColors.surfaceContainerLowest,
                    child: Center(
                      child: SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
            if (tablet) {
              return _MatchTabletLayout(
                ft: ft,
                topBar: topBar,
                scoreboard: scoreboard,
                momentum: momentum,
                shootout: shootout,
                // Before kick-off, never having chosen: Pitch or Timeline,
                // here where the Timeline goes.
                timeline: choosing
                    ? MatchViewChooser(
                        onChoose: (m) => _chooseMode(preview, m),
                      )
                    : timeline,
                stats: stats,
                lineups: lineups,
                pitch: _livePitch(preview, r),
                pitchView: _onPitch ? pitchSurface : null,
                feed: _onPitch && picture
                    ? PitchCommentaryFeed(
                        clock: clock,
                        countAt: pb.lineCountAt,
                        linesAt: (t) =>
                            pb.linesUpTo(l, t, _pc.names, _seed(preview)),
                      )
                    : null,
                overlays: overlays,
                tvHeader: tabletTv
                    ? MatchTvHeader(
                        homeCode: code(homeId),
                        awayCode: code(awayId),
                        homeName: name(homeId),
                        awayName: name(awayId),
                        homeScore: homeScore,
                        awayScore: awayScore,
                        clock: clockLabel,
                        live: !ft,
                        homeColor: homeC,
                        awayColor: awayC,
                        goal: _goalFlash,
                        goalForHome: _goalFlash?.teamNationId == homeId,
                        theme: finalsTheme,
                        homeNationId: homeId,
                        ground: GroundStrip(
                          ground: preview.ground,
                          neutral: preview.neutralVenue,
                          groundNationCode: code(
                            preview.ground.groundNationId,
                          ),
                          fans: preview.homeFans,
                          kickOff: conditionsShown.kickOff,
                          weather: conditionsShown.weather,
                        ),
                        moments: TvMoment.of(timelineEvents, penalties),
                        stats: tvStatsOf(
                          r,
                          homeNationId: homeId,
                          events: timelineEvents,
                          minute: _minute,
                          fullTime: ft,
                        ),
                      )
                    : null,
              );
            }
            if (_onPitch) {
              // Pitch mode: the match on the pitch under the score, one line
              // of commentary under it, then the momentum and the details.
              return DefaultTabController(
                length: 2,
                // Stats (ratings, MOTM) is the first tab here already.
                key: ValueKey(('pitch', ft)),
                child: SafeArea(
                  child: Stack(
                    children: [
                      PitchModeColumn(
                        head: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [topBar, scoreboard],
                        ),
                        pitch: pitchSurface,
                        under: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (picture)
                              PitchCommentaryLine(
                                clock: clock,
                                countAt: pb.lineCountAt,
                                lineAt: (t) =>
                                    pb.lineAt(l, t, _pc.names, _seed(preview)),
                              )
                            else
                              const SizedBox(height: kPitchCommentaryHeight),
                            ?momentum,
                            ?shootout,
                          ],
                        ),
                        tabBar: const MatchDetailTabs(withTimeline: false),
                        tabs: TabBarView(children: [stats, lineups]),
                      ),
                      ...overlays,
                    ],
                  ),
                ),
              );
            }
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
                        topBar,
                        scoreboard,
                        ?momentum,
                        ?shootout,
                        const MatchDetailTabs(),
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Before kick-off, never having chosen: Pitch
                              // or Timeline, here where the Timeline goes.
                              if (choosing)
                                MatchViewChooser(
                                  onChoose: (m) => _chooseMode(preview, m),
                                )
                              else
                                timeline,
                              stats,
                              lineups,
                            ],
                          ),
                        ),
                      ],
                    ),
                    ...overlays,
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
          // In step with the body: no bar until the body has set the match
          // up, or the bar reads a lineup the body never built.
          skipLoadingOnRefresh: false,
          data: (preview) {
            if (preview == null) return null;
            final ft = _fullTime;
            final r = _result ?? preview.result;
            // Pitch or Timeline from the bar, once chosen: the one control
            // for it, on a phone (compact) as on a tablet.
            final mode = _mode;
            final Widget? toggle = mode != null
                ? MatchViewToggle(
                    current: mode,
                    compact: !tablet,
                    onChoose: (m) => _chooseMode(preview, m),
                  )
                : null;
            final bar = ft
                ? Row(
                    children: [
                      // Engraved into the silver, like the bar's other keys.
                      Theme(
                        data: Theme.of(context).copyWith(
                          outlinedButtonTheme: OutlinedButtonThemeData(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: SilverInk.active,
                              backgroundColor: const Color(0x66FFFFFF),
                              side: const BorderSide(color: SilverInk.idle),
                              shape: const StadiumBorder(),
                            ),
                          ),
                        ),
                        child: _shareButton(preview, r),
                      ),
                      if (toggle != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        toggle,
                      ],
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: PrimaryButton(
                          label: _committing
                              ? AppLocalizations.of(context).matchContinuing
                              : AppLocalizations.of(context).matchContinue,
                          icon: Icons.check_rounded,
                          height: 52,
                          onSilver: true,
                          onPressed: _committing
                              ? null
                              : () => _continue(preview, r),
                        ),
                      ),
                    ],
                  )
                : MatchControlBar(
                    playing: _playing,
                    speed: _speeds[_speedIdx],
                    subsUsed: _subsUsed(preview),
                    maxSubs: _maxSubsFor(preview),
                    spent: _spentCount(preview, r),
                    onPlayPause: _togglePlay,
                    onSpeed: _cycleSpeed,
                    onTactics: () => _openTactics(preview),
                    // The only wiring of the skip aid: off here is off
                    // everywhere, and the pill is absent rather than dead.
                    onSkip: kShowSkipMatch ? _skip : null,
                    viewToggle: toggle,
                  );
            return MatchBarDock(maxWidth: tablet ? 900 : null, child: bar);
          },
        ),
      ),
    );
  }
}

/// The pitch could not be built for this match: an error mark and the way
/// on to the Timeline, which plays the same match (never a spinner).
class _PitchFailed extends StatelessWidget {
  const _PitchFailed({required this.onTimeline});

  final VoidCallback onTimeline;

  static const Key failedKey = Key('match.pitchFailed');

  @override
  Widget build(BuildContext context) => ColoredBox(
    key: failedKey,
    color: AppColors.surfaceContainerLowest,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppColors.outline),
          const SizedBox(height: 8),
          TextButton(
            key: const Key('match.pitchFailedTimeline'),
            onPressed: onTimeline,
            child: Text(AppLocalizations.of(context).matchViewTimeline),
          ),
        ],
      ),
    ),
  );
}
