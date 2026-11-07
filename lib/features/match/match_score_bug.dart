part of 'match_screen.dart';

/// The key of the score bug's goal banner.
const Key matchGoalBannerKey = Key('match.goalBanner');

/// How long the goal banner takes to slide out of the stripe, and back in.
const Duration kGoalBannerSlide = Duration(milliseconds: 280);

/// How long the screen's goal flash holds the clock, so a goal is always
/// seen, even at the fastest speed (1.1 s of pause and 0.7 s more, as it
/// always was). The banner's whole life: out, held, back in.
const Duration kGoalFlashHold = Duration(milliseconds: 1800);
const Duration _kGoalPulse = Duration(milliseconds: 700);

/// The phone's Pitch mode score: one dark bar with a silver edge, as a
/// broadcast puts in the corner of the picture. A kit chip and the code of
/// each side, the two numbers on a silver plate between them, and the
/// clock in a tab on the end (stoppage time as a "+N" beside it).
///
/// On a goal a banner slides out from under the bar (the scoring side's
/// colour, the scorer, the minute) and the scorer's number pulses. Both run
/// off the screen's goal flash, so they never touch the clock's timing.
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
  static const double barHeight = 24;

  @override
  Widget build(BuildContext context) {
    final goal = this.goal;
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final bar = Container(
      height: barHeight,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppRadii.smAll,
        border: Border.all(color: AppColors.primaryContainer),
      ),
      child: ClipRRect(
        borderRadius: AppRadii.smAll,
        child: Row(
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.marginMobile,
        vertical: 4,
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
                // The score tells two goals by one player in one minute
                // apart: each gets its own banner.
                key: ValueKey((
                  'banner',
                  goal.minute,
                  goal.stoppage,
                  goal.playerId,
                  homeScore + awayScore,
                )),
                event: goal,
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

/// One side of the bug: its kit chip and code, the chip on the outside.
class _BugSide extends StatelessWidget {
  const _BugSide({required this.code, this.color, this.alignEnd = false});

  final String code;
  final Color? color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      width: 4,
      color: color ?? AppColors.primary,
    );
    final text = Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            code,
            maxLines: 1,
            softWrap: false,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.onSurface,
              fontSize: 12,
              height: 1,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: alignEnd ? [chip, text] : [text, chip],
    );
  }
}

/// The two numbers on the bug's silver plate; [pulse] is the goal being
/// celebrated and whether it is the home side's, whose number pulses.
class _BugScore extends StatelessWidget {
  /// Each figure's width: two tabular digits at the stripe's size.
  static const double _figureWidth = 20;

  const _BugScore({
    required this.home,
    required this.away,
    required this.pulse,
    required this.still,
  });

  final int home;
  final int away;
  final (MatchEvent, bool)? pulse;
  final bool still;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.labelLarge.copyWith(
      color: AppColors.onPrimary,
      fontSize: 14,
      height: 1,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
      fontFeatures: const [FontFeature.tabularFigures()],
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryFixed, AppColors.primaryContainer],
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _figureWidth,
            child: Center(child: figure(home, isHome: true)),
          ),
          Container(
            width: 1,
            height: 11,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: AppColors.onPrimaryContainer,
          ),
          SizedBox(
            width: _figureWidth,
            child: Center(child: figure(away, isHome: false)),
          ),
        ],
      ),
    );
  }
}

/// The clock's tab on the end of the bug: the minute, and stoppage time as
/// "+N" set apart beside it.
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
      fontSize: 12,
      height: 1,
      fontWeight: FontWeight.w700,
      fontFeatures: const [FontFeature.tabularFigures()],
      color: live ? AppColors.onSurface : AppColors.onSurfaceVariant,
    );
    return Container(
      constraints: const BoxConstraints(minWidth: 40, maxWidth: 80),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerHighest,
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
              const SizedBox(width: 3),
              Text(
                added,
                maxLines: 1,
                softWrap: false,
                style: style.copyWith(
                  fontSize: 10,
                  color: AppColors.warning,
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
/// side's colour, the shout, the scorer and the minute. Shown at once,
/// without the slide, when the platform asks for reduced motion.
class _GoalBanner extends StatelessWidget {
  const _GoalBanner({
    required this.event,
    required this.color,
    required this.still,
    super.key,
  });

  final MatchEvent event;
  final Color color;
  final bool still;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final when = event.penalty
        ? '${l.matchPenalty} · ${_eventClock(event)}'
        : _eventClock(event);
    final banner = Container(
      height: 22,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppRadii.sm),
        ),
        border: Border.all(color: AppColors.primaryContainer),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(width: 6, color: color),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primaryFixed, AppColors.primaryContainer],
              ),
            ),
            child: Text(
              l.matchGoalShout,
              maxLines: 1,
              softWrap: false,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w800,
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
                  color: AppColors.onSurfaceVariant,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
        ],
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
