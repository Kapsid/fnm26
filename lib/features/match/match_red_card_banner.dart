part of 'match_screen.dart';

/// The key of the 2D TV's red card banner.
const Key matchRedCardBannerKey = Key('match.redCardBanner');

/// How long the red card banner is out: as long as the referee holds the
/// card up, and a little more. It never holds the clock: play goes on, a
/// man down, under it.
const Duration kRedCardBannerHold = Duration(milliseconds: 2400);

/// The red card's own red, on the banner's plate.
const Color _kRedCardRed = Color(0xFFD32029);

/// The red card on the 2D TV: a banner down from under the score, in the
/// style of the goal's (the side's colour and flag, a small red card, the
/// shout, the man sent off, the minute). It slides out, holds and goes
/// back in over [kRedCardBannerHold]; with reduced motion it is simply
/// there.
class _RedCardBanner extends StatelessWidget {
  const _RedCardBanner({
    required this.event,
    required this.code,
    required this.color,
    required this.still,
    super.key,
  });

  final MatchEvent event;

  /// The side of the man sent off, for its flag.
  final String code;
  final Color color;
  final bool still;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
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
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE8434A), _kRedCardRed, Color(0xFFA5151C)],
                ),
                border: _kSilverBevel,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The card itself, as the referee holds it up.
                  Transform.rotate(
                    angle: 0.12,
                    child: Container(
                      width: 8,
                      height: 11,
                      decoration: BoxDecoration(
                        color: _kRedCardRed,
                        borderRadius: BorderRadius.circular(1.5),
                        border: Border.all(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    l.matchRedCardShout,
                    maxLines: 1,
                    softWrap: false,
                    style: AppTypography.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    initialledName(event.playerName),
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
    final shown = KeyedSubtree(key: matchRedCardBannerKey, child: banner);
    if (still) return IgnorePointer(child: shown);
    final total = kRedCardBannerHold.inMicroseconds;
    final slide = kGoalBannerSlide.inMicroseconds / total;
    return IgnorePointer(
      child: ClipRect(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: kRedCardBannerHold,
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
