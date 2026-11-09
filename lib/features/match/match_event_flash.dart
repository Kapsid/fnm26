part of 'match_screen.dart';

/// How long a substitution's pop-up stays: out, held and gone again. Play never waits for it (only a goal holds the clock).
const Duration kEventFlashHold = Duration(milliseconds: 2600);

/// The key of the score bug's substitution banner.
const Key matchEventBannerKey = Key('match.eventBanner');

/// The key of the Timeline's (and the tablet's) substitution pop-up.
const Key matchEventFlashKey = Key('match.eventFlash');

/// Whether [e] gets a pop-up of its own: a substitution only. A red card
/// has its own banner on the 2D TV (`_RedCardBanner`) and never comes here.
bool flashesAsEvent(MatchEvent e) => e.type == MatchEventType.substitution;

/// Who went off and who came on: one line for the score bug's banner, the arrows in the game's red and green.
class _EventLine extends StatelessWidget {
  const _EventLine({required this.event, required this.style});

  final MatchEvent event;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final e = event;
    Widget name(String n) => Flexible(
      child: Text(
        n,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );
    final off = e.secondaryName;
    return Row(
      children: [
        if (off != null) ...[
          Semantics(
            label: l.matchSubOff(off),
            excludeSemantics: true,
            child: const Icon(
              Icons.arrow_downward_rounded,
              size: 14,
              color: AppColors.error,
            ),
          ),
          name(surnameOf(off)),
          const SizedBox(width: AppSpacing.sm),
        ],
        Semantics(
          label: l.matchSubOn(e.playerName),
          excludeSemantics: true,
          child: const Icon(
            Icons.arrow_upward_rounded,
            size: 14,
            color: AppColors.positive,
          ),
        ),
        name(surnameOf(e.playerName)),
      ],
    );
  }
}

/// The 2D TV's banner for a substitution: out from under the score bug as
/// the goal's banner comes, in the same dress (the side's kit on the edge,
/// its flag, a plate with the shout, then who and when).
class _EventBanner extends StatelessWidget {
  const _EventBanner({
    required this.event,
    required this.code,
    required this.color,
    required this.still,
    this.theme,
    super.key,
  });

  final MatchEvent event;
  final String code;
  final Color color;
  final bool still;
  final ScoreBugTheme? theme;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const radius = BorderRadius.vertical(bottom: Radius.circular(AppRadii.sm));
    final theme = this.theme;
    final banner = Container(
      height: 24,
      decoration: BoxDecoration(
        gradient: theme == null ? _kBugBody : _plates(theme),
        borderRadius: radius,
        border: Border.all(
          color:
              theme?.rim ?? AppColors.primaryContainer.withValues(alpha: 0.6),
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
                l.matchSubShout,
                maxLines: 1,
                softWrap: false,
                style: AppTypography.labelMedium.copyWith(
                  color: theme?.scoreText ?? AppColors.onPrimaryFixed,
                  fontWeight: FontWeight.w800,
                  height: 1,
                  letterSpacing: 1,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Center(
                  child: _EventLine(
                    event: event,
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
                  _eventClock(event),
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
    final shown = KeyedSubtree(key: matchEventBannerKey, child: banner);
    if (still) return IgnorePointer(child: shown);
    final total = kEventFlashHold.inMicroseconds;
    final slide = kGoalBannerSlide.inMicroseconds / total;
    return IgnorePointer(
      child: ClipRect(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: kEventFlashHold,
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

/// The Timeline's (and the tablet's) pop-up for a substitution, dressed as
/// the goal's: a card with the side's flag, the shout,
/// who and when. It pops in, holds and fades; play goes on under it.
class _EventFlash extends StatelessWidget {
  const _EventFlash({required this.event, required this.flagCode});

  final MatchEvent event;
  final String flagCode;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final e = event;
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    const accent = AppColors.primary;
    Widget row(IconData icon, Color c, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: c),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.titleMedium,
          ),
        ),
      ],
    );
    final off = e.secondaryName;
    final card = Container(
      key: matchEventFlashKey,
      constraints: const BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadii.lgAll,
        border: Border.all(color: accent, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlagDisc(flagCode, size: 36),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.matchSubShout,
            textAlign: TextAlign.center,
            style: AppTypography.headlineMedium.copyWith(color: accent),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (off != null)
            Semantics(
              label: l.matchSubOff(off),
              excludeSemantics: true,
              child: row(
                Icons.arrow_downward_rounded,
                AppColors.error,
                surnameOf(off),
              ),
            ),
          Semantics(
            label: l.matchSubOn(e.playerName),
            excludeSemantics: true,
            child: row(
              Icons.arrow_upward_rounded,
              AppColors.positive,
              surnameOf(e.playerName),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _eventClock(e),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: still
              ? card
              : TweenAnimationBuilder<double>(
                  key: ValueKey((e.minute, e.stoppage, e.playerId, e.type)),
                  tween: Tween(begin: 0, end: 1),
                  duration: kEventFlashHold,
                  builder: (context, u, child) {
                    // In with a spring, as the goal's comes; out with a fade.
                    final pop = Curves.easeOutBack.transform(
                      (u / 0.12).clamp(0.0, 1.0),
                    );
                    final fade = u > 0.85 ? (1 - u) / 0.15 : 1.0;
                    return Opacity(
                      opacity: (pop * fade).clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: 0.7 + 0.3 * pop,
                        child: child,
                      ),
                    );
                  },
                  child: card,
                ),
        ),
      ),
    );
  }
}
