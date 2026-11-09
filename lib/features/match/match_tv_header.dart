part of 'match_screen.dart';

/// The key of the tablet 2D TV's broadcast header.
const Key matchTvHeaderKey = Key('match.tvHeader');

/// The key of the tablet 2D TV's centred goal banner.
const Key matchTvGoalBannerKey = Key('match.tvGoalBanner');

/// The key of the tablet 2D TV's moment feed down the pitch's right edge.
const Key matchMomentFeedKey = Key('match.momentFeed');

/// How long a moment stays in the feed: in, held, faded out.
const Duration kMomentFeedLife = Duration(milliseconds: 7000);

/// The most moments the feed shows at once.
const int kMomentFeedMax = 4;

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

/// The tablet 2D TV's broadcast header, across the top of the picture: the
/// score bug (the phone's bar, drawn larger), a strip of live figures under
/// it and a hairline of momentum under both.
class MatchTvHeader extends StatelessWidget {
  const MatchTvHeader({
    required this.homeCode,
    required this.awayCode,
    required this.homeScore,
    required this.awayScore,
    required this.clock,
    required this.live,
    required this.stats,
    this.homeColor,
    this.awayColor,
    this.goal,
    this.goalForHome = false,
    this.theme,
    this.momentum,
    super.key,
  });

  final String homeCode;
  final String awayCode;
  final int homeScore;
  final int awayScore;
  final String clock;
  final bool live;
  final TvStats stats;
  final Color? homeColor;
  final Color? awayColor;

  /// The goal being celebrated (its scorer's figure pulses).
  final MatchEvent? goal;
  final bool goalForHome;
  final ScoreBugTheme? theme;

  /// The home side's share of the momentum, 0 to 100; null once it no longer
  /// moves (full time, a shootout).
  final double? momentum;

  static const double _pad = AppSpacing.sm + 2;
  static const double _bugHeight = 40;
  static const double _stripHeight = 34;
  static const double _hairline = 4;

  /// The header's height.
  static const double height =
      _pad * 2 + _bugHeight + AppSpacing.sm + _stripHeight + _hairline;

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final goal = this.goal;
    final goalId = goal == null
        ? null
        : (goal.minute, goal.stoppage, goal.playerId, homeScore + awayScore);
    // The phone's bar, laid out at its own height and scaled up to the
    // header's: the same bug, every detail in proportion.
    Widget bug(double width) {
      const scale = _bugHeight / _ScoreBug.barHeight;
      return SizedBox(
        width: width,
        height: _bugHeight,
        child: FittedBox(
          child: SizedBox(
            width: width / scale,
            height: _ScoreBug.barHeight,
            child: _ScoreBugBar(
              homeCode: homeCode,
              awayCode: awayCode,
              homeScore: homeScore,
              awayScore: awayScore,
              clock: clock,
              live: live,
              still: still,
              homeColor: homeColor,
              awayColor: awayColor,
              goal: goal,
              goalForHome: goalForHome,
              goalId: goalId,
              theme: theme,
              // The minute alone needs little; the whistle's wording more.
              clockMaxWidth: live ? 52 : 80,
            ),
          ),
        ),
      );
    }

    return KeyedSubtree(
      key: matchTvHeaderKey,
      child: LayoutBuilder(
        builder: (context, c) {
          final inner = c.maxWidth - _pad * 2;
          // The bug over the strip: the column is narrower than the
          // broadcast's full width, and two rows keep every figure legible.
          final body = Column(
            children: [
              bug(math.min(inner, 440)),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: inner,
                height: _stripHeight,
                child: _TvStatStrip(stats: stats, width: inner),
              ),
            ],
          );
          return DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1E2022), Color(0xFF121416)],
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(_pad),
                    child: Center(child: body),
                  ),
                ),
                SizedBox(
                  height: _hairline,
                  child: _TvMomentumLine(
                    homePercent: momentum,
                    homeColor: homeColor ?? AppColors.primary,
                    awayColor: awayColor ?? AppColors.secondary,
                    still: still,
                  ),
                ),
              ],
            ),
          );
        },
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
      decoration: BoxDecoration(
        color: const Color(0xB30C0E10),
        borderRadius: const BorderRadius.all(Radius.circular(7)),
        border: Border.all(color: const Color(0xFF33363A)),
      ),
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

/// The momentum as a hairline under the header: the home side's colour from
/// the left for its share, the away side's for the rest. Once the momentum
/// stops moving it is a plain rule.
class _TvMomentumLine extends StatelessWidget {
  const _TvMomentumLine({
    required this.homePercent,
    required this.homeColor,
    required this.awayColor,
    required this.still,
  });

  final double? homePercent;
  final Color homeColor;
  final Color awayColor;
  final bool still;

  @override
  Widget build(BuildContext context) {
    final p = homePercent;
    if (p == null) return const ColoredBox(color: Color(0xFF2A2D31));
    final share = (p / 100).clamp(0.0, 1.0);
    return ColoredBox(
      color: awayColor,
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedFractionallySizedBox(
          duration: still ? Duration.zero : const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
          widthFactor: share,
          heightFactor: 1,
          child: ColoredBox(color: homeColor),
        ),
      ),
    );
  }
}

/// The tablet 2D TV's goal: a banner centred at the top of the picture, in
/// the bug's dress (the scorer's kit on the edge, the flag, the shout on
/// silver, the scorer with how it came, the minute). It drops in, holds for
/// the goal's flash and lifts away; with reduced motion it is simply there
/// for as long.
class MatchTvGoalBanner extends StatelessWidget {
  const MatchTvGoalBanner({
    required this.event,
    required this.code,
    required this.color,
    required this.goalNumber,
    this.theme,
    super.key,
  });

  final MatchEvent event;

  /// The scoring side's code, for its flag.
  final String code;
  final Color color;

  /// Goals so far: tells two goals by one player in one minute apart.
  final int goalNumber;
  final ScoreBugTheme? theme;

  /// The banner's height.
  static const double height = 46;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final theme = this.theme;
    final e = event;
    final assist = e.assistName;
    final how = e.penalty
        ? l.matchPenalty
        : e.longThrow
        ? l.matchGoalLongThrow
        : assist != null && assist.isNotEmpty
        ? capsFor(l.matchGoalAssist(_abbrevName(assist)), lang)
        : null;
    const dark = BoxDecoration(gradient: _kBugBody);
    final banner = Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: AppRadii.smAll,
        border: Border.all(color: theme?.rim ?? const Color(0xFF5C6670)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x99000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(AppRadii.sm - 1)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 6, color: color),
            DecoratedBox(
              decoration: theme == null
                  ? dark
                  : BoxDecoration(gradient: _plates(theme)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(child: _BugFlag(code, width: 28, height: 19)),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: theme == null
                  ? const BoxDecoration(
                      gradient: _kSilverPlate,
                      border: _kSilverBevel,
                    )
                  : BoxDecoration(
                      gradient: _scoreBlock(theme),
                      border: _kSilverBevel,
                    ),
              child: Text(
                l.matchGoalShout,
                maxLines: 1,
                softWrap: false,
                style: AppTypography.titleMedium.copyWith(
                  fontFamily: AppFonts.mono,
                  color: theme?.scoreText ?? AppColors.onPrimaryFixed,
                  fontSize: 19,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Flexible(
              child: DecoratedBox(
                decoration: theme == null
                    ? dark
                    : BoxDecoration(gradient: _plates(theme)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.playerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.onSurface,
                          fontSize: 17,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (how != null)
                        Text(
                          how,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelSmall.copyWith(
                            fontFamily: AppFonts.mono,
                            fontSize: 10,
                            height: 1.3,
                            letterSpacing: 0.4,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF3B3E42), Color(0xFF25282B)],
                ),
              ),
              child: Text(
                _eventClock(e),
                maxLines: 1,
                softWrap: false,
                style: AppTypography.labelLarge.copyWith(
                  fontFamily: AppFonts.mono,
                  fontSize: 15,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                  color: theme?.clockText ?? AppColors.onSurface,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    final shown = KeyedSubtree(key: matchTvGoalBannerKey, child: banner);
    if (still) return IgnorePointer(child: shown);
    final total = kGoalFlashHold.inMicroseconds;
    final slide = kGoalBannerSlide.inMicroseconds / total;
    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        key: ValueKey(('tvGoal', e.minute, e.stoppage, e.playerId, goalNumber)),
        tween: Tween(begin: 0, end: 1),
        duration: kGoalFlashHold,
        builder: (context, u, child) {
          final out = u < slide
              ? Curves.easeOutBack.transform(u / slide)
              : u > 1 - slide
              ? Curves.easeInCubic.transform((1 - u) / slide)
              : 1.0;
          return Opacity(
            opacity: out.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, (out - 1) * 24),
              child: child,
            ),
          );
        },
        child: shown,
      ),
    );
  }
}

/// One key moment for the tablet 2D TV's feed: a goal, a card, a
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

/// The tablet 2D TV's moment feed down the right edge of the picture: each
/// moment slides in as the clock reaches it, newest on top, and fades away
/// a few seconds later; at most [kMomentFeedMax] at a time. Moments already
/// past when the feed comes on screen are not replayed.
class MatchMomentFeed extends StatefulWidget {
  const MatchMomentFeed({
    required this.moments,
    required this.homeNationId,
    required this.homeCode,
    required this.awayCode,
    required this.homeColor,
    required this.awayColor,
    super.key,
  });

  /// Every moment reached so far, in match order.
  final List<TvMoment> moments;
  final int homeNationId;
  final String homeCode;
  final String awayCode;
  final Color homeColor;
  final Color awayColor;

  @override
  State<MatchMomentFeed> createState() => _MatchMomentFeedState();
}

class _MatchMomentFeedState extends State<MatchMomentFeed> {
  /// Every moment seen, shown or not.
  final Set<Object> _seen = {};

  /// The moments in the feed now, by id, with the timer that takes each
  /// one out.
  final Map<Object, Timer> _alive = {};

  @override
  void initState() {
    super.initState();
    for (final m in widget.moments) {
      _seen.add(m.id);
    }
  }

  @override
  void didUpdateWidget(MatchMomentFeed oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (final m in widget.moments) {
      final id = m.id;
      if (!_seen.add(id)) continue;
      _alive[id] = Timer(kMomentFeedLife, () {
        if (mounted) setState(() => _alive.remove(id));
      });
    }
  }

  @override
  void dispose() {
    for (final t in _alive.values) {
      t.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final showing = [
      for (final m in widget.moments.reversed)
        if (_alive.containsKey(m.id)) m,
    ].take(kMomentFeedMax).toList();
    if (showing.isEmpty) return const SizedBox.shrink();
    return IgnorePointer(
      child: Column(
        key: matchMomentFeedKey,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final m in showing)
            Padding(
              key: ValueKey(m.id),
              padding: const EdgeInsets.only(bottom: 6),
              child: _MomentToast(
                moment: m,
                code: m.teamNationId == widget.homeNationId
                    ? widget.homeCode
                    : widget.awayCode,
                color: m.teamNationId == widget.homeNationId
                    ? widget.homeColor
                    : widget.awayColor,
                still: still,
              ),
            ),
        ],
      ),
    );
  }
}

/// One moment in the feed: the side's kit as an edge, what happened as a
/// mark, who, and the minute.
class _MomentToast extends StatelessWidget {
  const _MomentToast({
    required this.moment,
    required this.code,
    required this.color,
    required this.still,
  });

  final TvMoment moment;
  final String code;
  final Color color;
  final bool still;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final strong = AppTypography.labelMedium.copyWith(
      color: AppColors.onSurface,
      fontWeight: FontWeight.w700,
      height: 1.1,
    );
    final muted = strong.copyWith(
      color: AppColors.onSurfaceVariant,
      fontWeight: FontWeight.w500,
    );
    Widget name(String n, {String? tag}) => Text.rich(
      TextSpan(
        children: [
          TextSpan(text: surnameOf(n), style: strong),
          if (tag != null) TextSpan(text: '  $tag', style: muted),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    final e = moment.event;
    final p = moment.penalty;
    final Widget mark;
    final Widget what;
    final String when;
    if (e == null) {
      final taker = p!.takerName;
      mark = Semantics(
        label: l.matchShootoutKickMissed(taker),
        child: const ExcludeSemantics(child: MissedPenaltyMark()),
      );
      what = name(taker);
      when = p.stoppage > 0 ? '90+${p.stoppage}' : "${p.minute}'";
    } else {
      when = _eventClock(e);
      switch (e.type) {
        case MatchEventType.goal:
          mark = const Icon(
            Icons.sports_soccer,
            size: 16,
            color: AppColors.onSurface,
          );
          what = name(e.playerName, tag: e.penalty ? l.matchGoalPenalty : null);
        case MatchEventType.yellowCard:
          mark = const CardMark(MatchCard.yellow, size: 14);
          what = name(e.playerName);
        case MatchEventType.redCard:
          mark = CardMark(
            e.secondYellow ? MatchCard.secondYellow : MatchCard.red,
            size: 14,
          );
          what = name(e.playerName);
        case MatchEventType.injury:
          mark = const Icon(
            Icons.medical_services,
            size: 15,
            color: AppColors.error,
          );
          what = name(e.playerName);
        case MatchEventType.substitution:
          mark = const Icon(
            Icons.swap_vert_rounded,
            size: 16,
            color: AppColors.positive,
          );
          what = _EventLine(event: e, style: strong);
      }
    }
    final goal = e?.type == MatchEventType.goal;
    final toast = Container(
      height: 30,
      decoration: BoxDecoration(
        color: goal ? const Color(0xE6202326) : const Color(0xD10E1012),
        borderRadius: AppRadii.smAll,
        border: Border.all(
          color: goal ? const Color(0xFF6E7883) : const Color(0xFF3A3F45),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(AppRadii.sm - 1)),
        child: Row(
          children: [
            Container(width: 3, color: color),
            const SizedBox(width: 6),
            _BugFlag(code, width: 15, height: 10),
            const SizedBox(width: 6),
            SizedBox(width: 22, child: Center(child: mark)),
            const SizedBox(width: 4),
            Expanded(child: what),
            const SizedBox(width: 6),
            Text(
              when,
              maxLines: 1,
              softWrap: false,
              style: AppTypography.labelSmall.copyWith(
                fontFamily: AppFonts.mono,
                letterSpacing: 0,
                height: 1,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceVariant,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ),
      ),
    );
    if (still) return toast;
    // In from the edge, held, then faded as it ages.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: kMomentFeedLife,
      builder: (context, u, child) {
        final inT = Curves.easeOutCubic.transform((u / 0.05).clamp(0.0, 1.0));
        final fade = u < 0.6 ? 1.0 : (1 - (u - 0.6) / 0.4).clamp(0.0, 1.0);
        return Opacity(
          opacity: (inT * fade).clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset((1 - inT) * 24, 0),
            child: child,
          ),
        );
      },
      child: toast,
    );
  }
}
