part of 'match_screen.dart';

/// The key of the score bug's goal banner.
const Key matchGoalBannerKey = Key('match.goalBanner');

/// The key of the sheen that sweeps the score plate on a goal.
const Key matchScoreSheenKey = Key('match.scoreSheen');

/// How long the goal banner takes to slide out of the stripe, and back in.
const Duration kGoalBannerSlide = Duration(milliseconds: 280);

/// How long the screen's goal flash holds the clock, so a goal is always
/// seen, even at the fastest speed (1.1 s of pause and 0.7 s more, as it
/// always was). The banner's whole life: out, held, back in.
const Duration kGoalFlashHold = Duration(milliseconds: 1800);
const Duration _kGoalPulse = Duration(milliseconds: 700);

/// How long the silver plate's sheen takes to sweep across it on a goal.
const Duration _kGoalSheen = Duration(milliseconds: 900);

/// The brushed silver of the score plate (and the banner's shout): a bright
/// top, a crisp horizon a little under the middle, as light catches turned
/// metal, and a darker foot.
const LinearGradient _kSilverPlate = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFF2F6FA),
    Color(0xFFDCE4ED),
    Color(0xFFB8C2CD),
    Color(0xFFC9D2DC),
    Color(0xFFA6B0BB),
  ],
  stops: [0, 0.46, 0.54, 0.84, 1],
);

/// The dark body of the bug and its banner: a lift at the top edge,
/// falling to near black.
const LinearGradient _kBugBody = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF2E3135), Color(0xFF17191C), Color(0xFF0E1012)],
  stops: [0, 0.55, 1],
);

/// The bevel round a silver plate: a bright lip on top, shade on the
/// bottom and the sides.
const Border _kSilverBevel = Border(
  top: BorderSide(color: Color(0xCCFFFFFF), width: 0.75),
  bottom: BorderSide(color: Color(0xFF6E7883), width: 0.75),
  left: BorderSide(color: Color(0xFF5C6670), width: 0.75),
  right: BorderSide(color: Color(0xFF5C6670), width: 0.75),
);

/// The phone's Pitch mode score: one dark bar with a silver edge, as a
/// broadcast puts in the corner of the picture. Each side's kit as a thin
/// accent on the outside, then its flag and its code gathered against the
/// two numbers, which sit on a brushed silver plate in the middle; the clock
/// in a segment on the end (stoppage time as a "+N" tab beside it).
///
/// On a goal a banner slides out from under the bar (the scoring side's
/// colour and flag, the scorer, the minute), the scorer's number pulses and
/// a sheen sweeps the silver. All of it runs off the screen's goal flash, so
/// it never touches the clock's timing, and none of it moves when the
/// platform asks for reduced motion.
class _ScoreBug extends StatelessWidget {
  const _ScoreBug({
    required this.homeCode,
    required this.awayCode,
    required this.homeScore,
    required this.awayScore,
    required this.clock,
    required this.live,
    this.homeColor,
    this.awayColor,
    this.goal,
    this.goalForHome = false,
  });

  final String homeCode;
  final String awayCode;
  final int homeScore;
  final int awayScore;
  final String clock;
  final bool live;
  final Color? homeColor;
  final Color? awayColor;
  final MatchEvent? goal;
  final bool goalForHome;

  /// The stripe's height: one line.
  static const double barHeight = 28;

  @override
  Widget build(BuildContext context) {
    final goal = this.goal;
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    // The score tells two goals by one player in one minute apart: each
    // gets its own banner and sweep.
    final goalId = goal == null
        ? null
        : (goal.minute, goal.stoppage, goal.playerId, homeScore + awayScore);
    final bar = Container(
      height: barHeight,
      decoration: BoxDecoration(
        gradient: _kBugBody,
        borderRadius: AppRadii.smAll,
        border: Border.all(
          color: AppColors.primaryContainer.withValues(alpha: 0.6),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x99000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(AppRadii.sm - 1)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _BugSide(
                code: homeCode,
                color: homeColor,
                alignEnd: true,
              ),
            ),
            _BugScore(
              home: homeScore,
              away: awayScore,
              pulse: goal == null ? null : (goal, goalForHome),
              sheen: goalId,
              still: still,
            ),
            Expanded(
              child: _BugSide(code: awayCode, color: awayColor),
            ),
            _BugClock(clock: clock, live: live),
          ],
        ),
      ),
    );
    return Padding(
      // Two px above and below: stripe and margin together stay the 32 px
      // the Pitch layout below was measured for.
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.marginMobile,
        vertical: 2,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          bar,
          if (goal != null)
            Positioned(
              top: barHeight,
              left: AppSpacing.sm,
              right: AppSpacing.sm,
              child: _GoalBanner(
                key: ValueKey(('banner', goalId)),
                event: goal,
                code: goalForHome ? homeCode : awayCode,
                color:
                    (goalForHome ? homeColor : awayColor) ?? AppColors.primary,
                still: still,
              ),
            ),
        ],
      ),
    );
  }
}

/// A small rectangular flag for the stripe and its banner: the app's own
/// flag art, cut to a soft-cornered card with a hairline edge.
class _BugFlag extends StatelessWidget {
  const _BugFlag(this.code, {this.width = 20, this.height = 14});

  final String code;
  final double width;
  final double height;

  static const _radius = BorderRadius.all(Radius.circular(2));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        borderRadius: _radius,
        boxShadow: [BoxShadow(color: Color(0x80000000), blurRadius: 2)],
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: _radius,
        border: Border.all(color: const Color(0x4DFFFFFF), width: 0.5),
      ),
      child: ClipRRect(borderRadius: _radius, child: CountryFlag(code)),
    );
  }
}

/// One side of the bug: the kit accent on the outside, then the flag and
/// the code, gathered against the score.
class _BugSide extends StatelessWidget {
  const _BugSide({required this.code, this.color, this.alignEnd = false});

  final String code;
  final Color? color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final accent = Container(width: 3, color: color ?? AppColors.primary);
    final flag = _BugFlag(code);
    // The code scales down before it is ever cut: a long one still fits.
    final text = Flexible(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          code,
          maxLines: 1,
          softWrap: false,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.onSurface,
            fontSize: 13,
            height: 1,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ),
    );
    const gap = SizedBox(width: 6);
    final cluster = Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: alignEnd
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: alignEnd ? [flag, gap, text] : [text, gap, flag],
      ),
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: alignEnd
          ? [accent, Expanded(child: cluster)]
          : [Expanded(child: cluster), accent],
    );
  }
}

/// The two numbers on the bug's brushed silver plate; [pulse] is the goal
/// being celebrated and whether it is the home side's, whose number pulses,
/// and [sheen] the goal's identity, for the sweep of light across the plate.
class _BugScore extends StatelessWidget {
  /// Each figure's width: two tabular digits at the stripe's size.
  static const double _figureWidth = 22;

  const _BugScore({
    required this.home,
    required this.away,
    required this.pulse,
    required this.sheen,
    required this.still,
  });

  final int home;
  final int away;
  final (MatchEvent, bool)? pulse;
  final Object? sheen;
  final bool still;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.labelLarge.copyWith(
      color: AppColors.onPrimaryFixed,
      fontSize: 16,
      height: 1,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
      fontFeatures: const [FontFeature.tabularFigures()],
      // Pressed into the metal: a hairline of light under each figure.
      shadows: const [
        Shadow(color: Color(0x80FFFFFF), offset: Offset(0, 0.75)),
      ],
    );
    Widget figure(int n, {required bool isHome}) {
      // Room for two tabular digits; anything wider scales down, never
      // clipped.
      final text = FittedBox(
        fit: BoxFit.scaleDown,
        child: Text('$n', maxLines: 1, softWrap: false, style: style),
      );
      final p = pulse;
      if (p == null || p.$2 != isHome || still) return text;
      final (e, _) = p;
      return TweenAnimationBuilder<double>(
        key: ValueKey(('pulse', e.minute, e.stoppage, e.playerId, home + away)),
        tween: Tween(begin: 0, end: 1),
        duration: _kGoalPulse,
        builder: (context, t, child) => Transform.scale(
          scale: 1 + 0.4 * math.sin(math.pi * t),
          child: child,
        ),
        child: text,
      );
    }

    final numbers = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _figureWidth,
          child: Center(child: figure(home, isHome: true)),
        ),
        Container(
          width: 1,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          color: AppColors.onPrimaryContainer.withValues(alpha: 0.55),
        ),
        SizedBox(
          width: _figureWidth,
          child: Center(child: figure(away, isHome: false)),
        ),
      ],
    );
    final sheen = this.sheen;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: const BoxDecoration(
        gradient: _kSilverPlate,
        border: _kSilverBevel,
      ),
      alignment: Alignment.center,
      child: sheen == null || still
          ? numbers
          : Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                numbers,
                Positioned(
                  key: matchScoreSheenKey,
                  top: 0,
                  bottom: 0,
                  left: -AppSpacing.sm,
                  right: -AppSpacing.sm,
                  child: IgnorePointer(
                    child: TweenAnimationBuilder<double>(
                      key: ValueKey(('sheen', sheen)),
                      tween: Tween(begin: 0, end: 1),
                      duration: _kGoalSheen,
                      curve: Curves.easeInOut,
                      builder: (context, t, _) {
                        // A soft diagonal band of light, from off the left
                        // edge to off the right, then gone.
                        final x = -2.4 + 4.8 * t;
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(x - 0.8, -1),
                              end: Alignment(x + 0.8, 1),
                              colors: const [
                                Color(0x00FFFFFF),
                                Color(0xB3FFFFFF),
                                Color(0x00FFFFFF),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

/// The clock's segment on the end of the bug: the minute, and stoppage time
/// as a "+N" tab set apart beside it.
class _BugClock extends StatelessWidget {
  const _BugClock({required this.clock, required this.live});

  final String clock;
  final bool live;

  @override
  Widget build(BuildContext context) {
    final plus = clock.indexOf('+');
    final main = plus < 0 ? clock : clock.substring(0, plus);
    final added = plus < 0 ? null : clock.substring(plus);
    final style = AppTypography.labelMedium.copyWith(
      fontFamily: AppFonts.mono,
      letterSpacing: 0,
      fontSize: 13,
      height: 1,
      fontWeight: FontWeight.w700,
      fontFeatures: const [FontFeature.tabularFigures()],
      color: live ? AppColors.onSurface : AppColors.onSurfaceVariant,
    );
    return Container(
      constraints: const BoxConstraints(minWidth: 44, maxWidth: 88),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3B3E42), Color(0xFF25282B)],
        ),
        border: Border(left: BorderSide(color: AppColors.primaryContainer)),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(main, maxLines: 1, softWrap: false, style: style),
            if (added != null) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
                child: Text(
                  added,
                  maxLines: 1,
                  softWrap: false,
                  style: style.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.surfaceContainerLowest,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The banner that slides out from under the bug on a goal: the scoring
/// side's colour and flag, the shout on silver, the scorer and the minute.
/// Shown at once, without the slide, when the platform asks for reduced
/// motion.
class _GoalBanner extends StatelessWidget {
  const _GoalBanner({
    required this.event,
    required this.code,
    required this.color,
    required this.still,
    super.key,
  });

  final MatchEvent event;

  /// The scoring side's code, for its flag.
  final String code;
  final Color color;
  final bool still;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final when = event.penalty
        ? '${l.matchPenalty} · ${_eventClock(event)}'
        : _eventClock(event);
    const radius = BorderRadius.vertical(bottom: Radius.circular(AppRadii.sm));
    final banner = Container(
      height: 24,
      decoration: BoxDecoration(
        gradient: _kBugBody,
        borderRadius: radius,
        border: Border.all(
          color: AppColors.primaryContainer.withValues(alpha: 0.6),
        ),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: color),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Center(child: _BugFlag(code, width: 18, height: 12)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: _kSilverPlate,
                border: _kSilverBevel,
              ),
              child: Text(
                l.matchGoalShout,
                maxLines: 1,
                softWrap: false,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.onPrimaryFixed,
                  fontWeight: FontWeight.w800,
                  height: 1,
                  letterSpacing: 1,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    event.playerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Center(
                child: Text(
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
              ),
            ),
          ],
        ),
      ),
    );
    final shown = KeyedSubtree(key: matchGoalBannerKey, child: banner);
    // Reduced motion: simply there, for as long as the flash holds.
    if (still) return IgnorePointer(child: shown);
    // Out from under the stripe, held, and back in as the flash ends.
    final total = kGoalFlashHold.inMicroseconds;
    final slide = kGoalBannerSlide.inMicroseconds / total;
    return IgnorePointer(
      child: ClipRect(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: kGoalFlashHold,
          builder: (context, u, child) {
            final out = u < slide
                ? Curves.easeOutCubic.transform(u / slide)
                : u > 1 - slide
                ? Curves.easeInCubic.transform((1 - u) / slide)
                : 1.0;
            return FractionalTranslation(
              translation: Offset(0, out - 1),
              child: child,
            );
          },
          child: shown,
        ),
      ),
    );
  }
}
