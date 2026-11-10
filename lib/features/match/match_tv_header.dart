part of 'match_screen.dart';

/// The key of the tablet 2D TV's broadcast header.
const Key matchTvHeaderKey = Key('match.tvHeader');

/// The key of the header's moment strip (a goal, a card, a substitution, an
/// injury, a missed penalty), which stands in for the figures while it is on.
const Key matchTvEventStripKey = Key('match.tvEventStrip');

/// How long a moment other than a goal holds the header's strip. A goal
/// holds it for the goal's own pause ([kGoalFlashHold]).
const Duration kTvEventHold = Duration(milliseconds: 2400);

/// The most moments waiting their turn on the strip; older ones give way.
const int kTvEventQueueMax = 3;

/// A per-minute series read as of [minute]: the full-match [total] once the
/// whistle has gone, and [zero] for a result that never recorded it (as the
/// box score reads it).
T _seriesAsOf<T extends num>(
  List<T> series,
  T total,
  T zero, {
  required int minute,
  required bool fullTime,
}) {
  if (fullTime) return total;
  if (series.isEmpty) return zero;
  return series[minute.clamp(0, series.length - 1)];
}

/// The live figures the broadcast header reads, as of the clock.
typedef TvStats = ({
  (int, int) shots,
  (double, double) xg,
  (int, int) yellows,
  (int, int) reds,

  /// The share of the ball, stated only at the whistle (it is a whole-match
  /// figure).
  (int, int)? possession,

  /// The last goal so far, for the scorer's segment.
  MatchEvent? lastGoal,
});

/// The header's figures from [r] as of [minute]: shots and xG off the
/// per-minute series, cards and the last goal off the [events] the clock has
/// reached (as the box score reads them).
TvStats tvStatsOf(
  MatchResult r, {
  required int homeNationId,
  required List<MatchEvent> events,
  required int minute,
  required bool fullTime,
}) {
  (int, int) count(MatchEventType t) {
    var h = 0;
    var a = 0;
    for (final e in events) {
      if (e.type != t) continue;
      if (e.teamNationId == homeNationId) {
        h++;
      } else {
        a++;
      }
    }
    return (h, a);
  }

  MatchEvent? lastGoal;
  for (final e in events) {
    if (e.type == MatchEventType.goal) lastGoal = e;
  }
  return (
    shots: (
      _seriesAsOf(
        r.homeShotsByMinute,
        r.homeShots,
        0,
        minute: minute,
        fullTime: fullTime,
      ),
      _seriesAsOf(
        r.awayShotsByMinute,
        r.awayShots,
        0,
        minute: minute,
        fullTime: fullTime,
      ),
    ),
    xg: (
      _seriesAsOf<double>(
        r.homeXgByMinute,
        r.homeXg,
        0,
        minute: minute,
        fullTime: fullTime,
      ),
      _seriesAsOf<double>(
        r.awayXgByMinute,
        r.awayXg,
        0,
        minute: minute,
        fullTime: fullTime,
      ),
    ),
    yellows: count(MatchEventType.yellowCard),
    reds: count(MatchEventType.redCard),
    possession: fullTime ? (r.homePossession, r.awayPossession) : null,
    lastGoal: lastGoal,
  );
}

/// The tablet 2D TV's broadcast header, over the picture and as wide as it:
/// the ground on a line of its own, the score bug (the phone's bar, drawn
/// larger) across the full width, and a strip of live figures under it.
///
/// Nothing is drawn over the picture: while a moment is on (a goal, a card,
/// a substitution, an injury, a missed penalty) the stat strip turns into
/// that moment's strip for a few seconds, then back. A goal comes first and
/// holds it for the goal's pause; the rest queue, each in its turn.
class MatchTvHeader extends StatefulWidget {
  const MatchTvHeader({
    required this.homeCode,
    required this.awayCode,
    required this.homeScore,
    required this.awayScore,
    required this.clock,
    required this.live,
    required this.stats,
    required this.homeNationId,
    this.homeColor,
    this.awayColor,
    this.goal,
    this.goalForHome = false,
    this.theme,
    this.ground,
    this.moments = const [],
    this.homeName,
    this.awayName,
    this.homeReds = 0,
    this.awayReds = 0,
    super.key,
  });

  /// Each side's red cards so far, marked on the bar beside its name.
  final int homeReds;
  final int awayReds;

  final String homeCode;
  final String awayCode;

  /// The nations' full names: the bar prints each in place of its code
  /// wherever it fits (see [_BugSide]).
  final String? homeName;
  final String? awayName;
  final int homeScore;
  final int awayScore;
  final String clock;
  final bool live;
  final TvStats stats;
  final int homeNationId;
  final Color? homeColor;
  final Color? awayColor;

  /// The goal being celebrated: its scorer's figure pulses, and the strip
  /// is its own for as long.
  final MatchEvent? goal;
  final bool goalForHome;
  final ScoreBugTheme? theme;

  /// The ground's line over the bug (see [GroundStrip]); null leaves the
  /// line empty.
  final Widget? ground;

  /// Every moment the clock has reached, in match order. Those already past
  /// when the header comes on screen are not replayed.
  final List<TvMoment> moments;

  static const double _pad = AppSpacing.sm + 2;
  static const double _groundHeight = 16;
  static const double _bugHeight = 40;
  static const double _stripHeight = 34;

  /// The header's height.
  static const double height =
      _pad * 2 +
      _groundHeight +
      AppSpacing.sm +
      _bugHeight +
      AppSpacing.sm +
      _stripHeight;

  @override
  State<MatchTvHeader> createState() => _MatchTvHeaderState();
}

class _MatchTvHeaderState extends State<MatchTvHeader> {
  final Set<Object> _seen = {};
  final List<TvMoment> _queue = [];
  TvMoment? _current;
  Timer? _timer;

  /// Goals have the strip through [MatchTvHeader.goal]; the queue is the
  /// rest.
  static bool _queued(TvMoment m) => m.event?.type != MatchEventType.goal;

  @override
  void initState() {
    super.initState();
    for (final m in widget.moments) {
      _seen.add(m.id);
    }
  }

  @override
  void didUpdateWidget(MatchTvHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (final m in widget.moments) {
      if (!_seen.add(m.id) || !_queued(m)) continue;
      _queue.add(m);
      while (_queue.length > kTvEventQueueMax) {
        _queue.removeAt(0);
      }
    }
    _advance();
  }

  /// Puts the next moment on the strip when it is free. A goal holds the
  /// queue, and the moment it interrupted starts its time again after.
  void _advance() {
    if (widget.goal != null) {
      _timer?.cancel();
      _timer = null;
      return;
    }
    if (_timer != null) return;
    if (_current == null) {
      if (_queue.isEmpty) return;
      _current = _queue.removeAt(0);
    }
    _timer = Timer(kTvEventHold, () {
      if (!mounted) return;
      setState(() {
        _current = null;
        _timer = null;
        _advance();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color _sideColor(int nationId) => nationId == widget.homeNationId
      ? widget.homeColor ?? AppColors.primary
      : widget.awayColor ?? AppColors.secondary;

  String _sideCode(int nationId) =>
      nationId == widget.homeNationId ? widget.homeCode : widget.awayCode;

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final goal = w.goal;
    final goalId = goal == null
        ? null
        : (
            goal.minute,
            goal.stoppage,
            goal.playerId,
            w.homeScore + w.awayScore,
          );
    // The phone's bar, laid out at its own height and scaled up to the
    // header's: the same bug, every detail in proportion, across the
    // header's full width (its sides take the room, the score and the clock
    // keep their size).
    Widget bug(double width) {
      const scale = MatchTvHeader._bugHeight / _ScoreBug.barHeight;
      return SizedBox(
        width: width,
        height: MatchTvHeader._bugHeight,
        child: FittedBox(
          child: SizedBox(
            width: width / scale,
            height: _ScoreBug.barHeight,
            child: _ScoreBugBar(
              homeCode: w.homeCode,
              awayCode: w.awayCode,
              homeName: w.homeName,
              awayName: w.awayName,
              homeScore: w.homeScore,
              awayScore: w.awayScore,
              clock: w.clock,
              live: w.live,
              still: still,
              homeColor: w.homeColor,
              awayColor: w.awayColor,
              goal: goal,
              goalForHome: w.goalForHome,
              goalId: goalId,
              theme: w.theme,
              homeReds: w.homeReds,
              awayReds: w.awayReds,
              // The minute alone needs little; the whistle's wording more.
              clockMaxWidth: w.live ? 52 : 80,
            ),
          ),
        ),
      );
    }

    final current = _current;
    final Object stripId;
    final Widget strip;
    if (goal != null) {
      stripId = ('goal', goalId);
      strip = _TvEventStrip(
        moment: TvMoment.event(goal),
        code: _sideCode(goal.teamNationId),
        color: _sideColor(goal.teamNationId),
        theme: w.theme,
      );
    } else if (current != null) {
      stripId = current.id;
      strip = _TvEventStrip(
        moment: current,
        code: _sideCode(current.teamNationId),
        color: _sideColor(current.teamNationId),
        theme: w.theme,
      );
    } else {
      stripId = 'stats';
      strip = LayoutBuilder(
        builder: (context, c) =>
            _TvStatStrip(stats: w.stats, width: c.maxWidth),
      );
    }
    return KeyedSubtree(
      key: matchTvHeaderKey,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E2022), Color(0xFF121416)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(MatchTvHeader._pad),
          child: LayoutBuilder(
            builder: (context, c) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: MatchTvHeader._groundHeight, child: w.ground),
                const SizedBox(height: AppSpacing.sm),
                bug(c.maxWidth),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: MatchTvHeader._stripHeight,
                  child: AnimatedSwitcher(
                    duration: still
                        ? Duration.zero
                        : const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    layoutBuilder: (shown, gone) => Stack(
                      fit: StackFit.expand,
                      children: [...gone, ?shown],
                    ),
                    child: KeyedSubtree(key: ValueKey(stripId), child: strip),
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

/// The box the header's strip sits in, figures or a moment alike.
BoxDecoration _tvStripBox() => BoxDecoration(
  color: const Color(0xB30C0E10),
  borderRadius: const BorderRadius.all(Radius.circular(7)),
  border: Border.all(color: const Color(0xFF33363A)),
);

/// A moment on the header's strip, in the bug's dress: the side's kit on
/// the edge, its flag, then what happened (a goal's shout or a sub's on the
/// silver plate; a card's colour; an injury's or a missed penalty's mark),
/// who, how a goal came, and the minute.
class _TvEventStrip extends StatelessWidget {
  const _TvEventStrip({
    required this.moment,
    required this.code,
    required this.color,
    this.theme,
  });

  final TvMoment moment;
  final String code;
  final Color color;
  final ScoreBugTheme? theme;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final theme = this.theme;
    final strong = AppTypography.labelLarge.copyWith(
      color: AppColors.onSurface,
      fontSize: 15,
      fontWeight: FontWeight.w800,
      height: 1,
      letterSpacing: 0,
    );
    final muted = AppTypography.labelSmall.copyWith(
      fontFamily: AppFonts.mono,
      fontSize: 10,
      height: 1,
      letterSpacing: 0.6,
      color: AppColors.onSurfaceVariant,
    );
    Widget plate(String shout) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: theme == null
          ? const BoxDecoration(gradient: _kSilverPlate, border: _kSilverBevel)
          : BoxDecoration(gradient: _scoreBlock(theme), border: _kSilverBevel),
      child: Text(
        shout,
        maxLines: 1,
        softWrap: false,
        style: AppTypography.titleMedium.copyWith(
          fontFamily: AppFonts.mono,
          color: theme?.scoreText ?? AppColors.onPrimaryFixed,
          fontSize: 15,
          height: 1,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
    Widget mark(Widget m) => SizedBox(width: 34, child: Center(child: m));
    Widget who(String name, {String? how}) => Row(
      children: [
        Flexible(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: strong,
          ),
        ),
        if (how != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              how,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: muted,
            ),
          ),
        ],
      ],
    );
    final e = moment.event;
    final p = moment.penalty;
    final Widget lead;
    final Widget body;
    final String when;
    if (e == null) {
      final taker = p!.takerName;
      lead = mark(
        Semantics(
          label: l.matchShootoutKickMissed(taker),
          child: const ExcludeSemantics(child: MissedPenaltyMark()),
        ),
      );
      body = who(taker);
      when = p.stoppage > 0 ? '90+${p.stoppage}' : "${p.minute}'";
    } else {
      when = _eventClock(e);
      switch (e.type) {
        case MatchEventType.goal:
          final assist = e.assistName;
          final how = e.penalty
              ? l.matchPenalty
              : e.longThrow
              ? l.matchGoalLongThrow
              : assist != null && assist.isNotEmpty
              ? capsFor(l.matchGoalAssist(_abbrevName(assist)), lang)
              : null;
          lead = plate(l.matchGoalShout);
          body = who(initialledName(e.playerName), how: how);
        case MatchEventType.yellowCard:
          lead = mark(const CardMark(MatchCard.yellow, size: 16));
          body = who(e.playerName);
        case MatchEventType.redCard:
          lead = mark(
            CardMark(
              e.secondYellow ? MatchCard.secondYellow : MatchCard.red,
              size: 16,
            ),
          );
          body = who(initialledName(e.playerName));
        case MatchEventType.injury:
          lead = mark(
            const Icon(
              Icons.medical_services,
              size: 16,
              color: AppColors.error,
            ),
          );
          body = who(e.playerName);
        case MatchEventType.substitution:
          lead = mark(const _SubMark(size: 16));
          body = _EventLine(event: e, style: strong);
      }
    }
    return Container(
      key: matchTvEventStripKey,
      decoration: _tvStripBox(),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: color),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(child: _BugFlag(code, width: 24, height: 16)),
            ),
            lead,
            const SizedBox(width: AppSpacing.md - 4),
            Expanded(
              child: Align(alignment: Alignment.centerLeft, child: body),
            ),
            const SizedBox(width: AppSpacing.sm),
            Center(
              child: Text(
                when,
                maxLines: 1,
                softWrap: false,
                style: AppTypography.labelLarge.copyWith(
                  fontFamily: AppFonts.mono,
                  fontSize: 14,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                  color: theme?.clockText ?? AppColors.onSurface,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md - 4),
          ],
        ),
      ),
    );
  }
}

/// The header's live figures, a segment each: shots, xG, cards (reds only
/// once there is one), the possession at the whistle, and, while there is
/// room, the last goal's scorer and minute.
class _TvStatStrip extends StatelessWidget {
  const _TvStatStrip({required this.stats, required this.width});

  final TvStats stats;
  final double width;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    String pair(num a, num b) => '$a · $b';
    String xg(double v) => v.toStringAsFixed(1);
    final (hs, as_) = stats.shots;
    final (hx, ax) = stats.xg;
    final (hy, ay) = stats.yellows;
    final (hr, ar) = stats.reds;
    final segments = <(String, String)>[
      if (stats.possession case (final hp, final ap))
        (capsFor(l.tacticsInstrPossession, lang), pair(hp, ap)),
      (capsFor(l.matchStatShots, lang), pair(hs, as_)),
      ('XG', '${xg(hx)} · ${xg(ax)}'),
      (capsFor(l.matchStatYellowCards, lang), pair(hy, ay)),
      if (hr + ar > 0) (capsFor(l.matchStatRedCards, lang), pair(hr, ar)),
    ];
    final goal = stats.lastGoal;
    // The scorer drops first when the strip runs out of room.
    final scorer = goal != null && width >= 380 + 70.0 * (segments.length - 3);
    final children = <Widget>[];
    for (final (k, v) in segments) {
      if (children.isNotEmpty) children.add(const _TvSegmentRule());
      children.add(
        Expanded(
          child: _TvSegment(label: k, value: v),
        ),
      );
    }
    if (scorer) {
      children
        ..add(const _TvSegmentRule())
        ..add(
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.sports_soccer,
                    size: 14,
                    color: AppColors.onSurface,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      '${surnameOf(goal.playerName)} ${_eventClock(goal)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    }
    return Container(
      decoration: _tvStripBox(),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

/// The hairline between two of the strip's segments.
class _TvSegmentRule extends StatelessWidget {
  const _TvSegmentRule();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, color: const Color(0xFF33363A));
}

/// One figure on the strip: its name small and muted, the two sides' values
/// beside it. A long name in a long language scales down, never cut.
class _TvSegment extends StatelessWidget {
  const _TvSegment({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                maxLines: 1,
                softWrap: false,
                style: AppTypography.labelSmall.copyWith(
                  fontFamily: AppFonts.mono,
                  fontSize: 10,
                  height: 1,
                  letterSpacing: 0.6,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                value,
                maxLines: 1,
                softWrap: false,
                style: AppTypography.labelLarge.copyWith(
                  fontSize: 15,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                  color: AppColors.onSurface,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One key moment for the tablet 2D TV's header strip: a goal, a card, a
/// substitution, an injury, or a penalty that did not go in.
@immutable
class TvMoment {
  const TvMoment.event(MatchEvent this.event) : penalty = null;
  const TvMoment.missedPenalty(InPlayPenalty this.penalty) : event = null;

  final MatchEvent? event;
  final InPlayPenalty? penalty;

  int get minute => event?.minute ?? penalty!.minute;
  int get stoppage => event?.stoppage ?? penalty!.stoppage;
  int get teamNationId => event?.teamNationId ?? penalty!.teamNationId;

  /// The moment's identity: the same moment read again (another build, a
  /// re-sim that left the past alone) is the same entry.
  Object get id {
    final e = event;
    if (e != null) {
      return (e.type, e.minute, e.stoppage, e.playerId, e.teamNationId);
    }
    final p = penalty!;
    return ('pen', p.minute, p.stoppage, p.teamNationId, p.takerName);
  }

  /// The moments the clock has reached, in match order.
  static List<TvMoment> of(
    List<MatchEvent> events,
    List<InPlayPenalty> penalties,
  ) {
    final all = <TvMoment>[
      for (final e in events) TvMoment.event(e),
      for (final p in penalties)
        if (!p.scored) TvMoment.missedPenalty(p),
    ];
    final indexed = [for (var i = 0; i < all.length; i++) (i, all[i])]
      ..sort((a, b) {
        final m = a.$2.minute.compareTo(b.$2.minute);
        if (m != 0) return m;
        final s = a.$2.stoppage.compareTo(b.$2.stoppage);
        return s != 0 ? s : a.$1.compareTo(b.$1);
      });
    return [for (final (_, m) in indexed) m];
  }
}
