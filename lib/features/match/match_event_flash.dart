part of 'match_screen.dart';

/// How long a substitution's pop-up stays: out, held and gone again. Play never waits for it (only a goal holds the clock).
const Duration kEventFlashHold = Duration(milliseconds: 2600);

/// The key of the score bug's substitution banner.
const Key matchEventBannerKey = Key('match.eventBanner');

/// Whether [e] gets a pop-up of its own: a substitution only. A red card
/// has its own banner on the 2D TV (`_RedCardBanner`) and never comes here.
bool flashesAsEvent(MatchEvent e) => e.type == MatchEventType.substitution;

/// The key of the substitution's mark ([_SubMark]) on a banner.
const Key matchSubMarkKey = Key('match.subMark');

/// A substitution, said without a word: one arrow up in the game's green and
/// one down in its red, side by side. It stands where the shout used to on
/// the 2D TV's banners, so the two names get the room (a long shout such as
/// the Czech one left them almost none). Screen readers still hear the
/// shout.
class _SubMark extends StatelessWidget {
  const _SubMark({this.size = 14}) : super(key: matchSubMarkKey);

  final double size;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Semantics(
      label: l.matchSubShout,
      excludeSemantics: true,
      child: SizedBox(
        width: size * 1.25,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -size * 0.15,
              top: 0,
              child: Icon(
                Icons.arrow_upward_rounded,
                size: size,
                color: AppColors.positive,
              ),
            ),
            Positioned(
              right: -size * 0.15,
              top: 0,
              child: Icon(
                Icons.arrow_downward_rounded,
                size: size,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
            const Padding(
              padding: EdgeInsets.only(left: 2),
              child: Center(child: _SubMark()),
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
