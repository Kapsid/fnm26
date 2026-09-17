part of 'match_screen.dart';

/// The frame around the pitch: the bar the manager reads the clock and the
/// score off, and the controls he changes the game with.
///
/// A part rather than its own library so these stay private to the match
/// screen — they are its furniture, not widgets anything else should build.
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // No way out of here: once the whistle has gone the only exit is
          // Continue at full time, so the result is always committed rather
          // than a half-played match being abandoned back to the hub.
          Text(
            AppLocalizations.of(context).matchTopBarTitle,
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
    required this.homeOverall,
    required this.awayOverall,
    required this.homeScore,
    required this.awayScore,
    required this.clock,
    required this.live,
  });

  final String homeCode;
  final String awayCode;
  final String homeName;
  final String awayName;

  /// Each side's team overall — the same number the pre-match screen shows
  /// either side of the "VS", carried into the live game so the manager can
  /// still see what he is up against once the whistle has gone.
  final int homeOverall;
  final int awayOverall;
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
                decoration: const BoxDecoration(
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
                    color: live
                        ? AppColors.onSurface
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Side(
                    code: homeCode,
                    label: homeName,
                    overall: homeOverall,
                  ),
                ),
                // The scoreline is allowed to shrink rather than shove the two
                // sides out of the card: a long name next to a 4:3 used to run
                // the row off the edge of a narrow screen.
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: FittedBox(
                      child: Text(
                        '$homeScore : $awayScore',
                        maxLines: 1,
                        style: AppTypography.displayLarge,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _Side(
                    code: awayCode,
                    label: awayName,
                    overall: awayOverall,
                  ),
                ),
              ],
            ),
            // Nothing under the scoreline: who scored is already told twice
            // over — the goal flashes as it goes in, and the timeline tab
            // keeps the full list — so a goal-count pill here was one place
            // too many.
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
    required this.spent,
    required this.onPlayPause,
    required this.onSpeed,
    required this.onSkip,
    required this.onTactics,
  });

  final bool playing;
  final int speed;
  final int subsUsed;

  /// How many of the manager's players on the pitch are running on empty.
  final int spent;
  final VoidCallback onPlayPause;
  final VoidCallback onSpeed;
  final VoidCallback onSkip;
  final VoidCallback onTactics;

  static const double _height = 52;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // Spent legs call attention to themselves: the tactics pill turns amber
    // and counts the players who have nothing left, so a fading side is
    // something the manager sees rather than something they only notice in
    // the full-time ratings.
    final tired = spent > 0 && subsUsed < kMaxSubs;
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
            accent: tired ? AppColors.warning : null,
            child: MatchTacticsPillContent(subsUsed: subsUsed, spent: spent),
          ),
          const SizedBox(width: AppSpacing.sm),
          _PillButton(
            onTap: onSkip,
            tooltip: l.matchSkipToFullTime,
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

/// The content of the live match control bar's tactics pill: an icon, an
/// ellipsizing tired/tactics label, and the substitution count.
///
/// Extracted out of [_MatchControlBar] so the count can be a fixed-width
/// sibling of the label rather than folded into one ellipsized string — on a
/// narrow screen the label gives way first, never the count, which is the
/// number the manager is actually reading. The extraction also lets a widget
/// test pump this content directly without reaching into the private
/// [_MatchControlBar].
@visibleForTesting
class MatchTacticsPillContent extends StatelessWidget {
  const MatchTacticsPillContent({
    super.key,
    required this.subsUsed,
    required this.spent,
  });

  final int subsUsed;

  /// How many of the manager's players on the pitch are running on empty.
  final int spent;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tired = spent > 0 && subsUsed < kMaxSubs;
    final tone = tired ? AppColors.warning : AppColors.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          tired ? Icons.battery_alert_rounded : Icons.tune,
          size: 18,
          color: tone,
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            tired ? l.matchTiredCount(spent) : l.matchTacticsLabel,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: AppTypography.labelMedium.copyWith(color: tone),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        // Never Flexible: the count is the number the manager is actually
        // reading, so the label gives way to it rather than the other way
        // round.
        Text(
          '$subsUsed/$kMaxSubs',
          style: AppTypography.labelMedium.copyWith(color: tone),
        ),
      ],
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
    this.accent,
  });

  final VoidCallback onTap;
  final Widget child;
  final bool expand;
  final String? tooltip;

  /// An alert colour for the pill's fill and border (null = the neutral look).
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final accent = this.accent;
    Widget button = Material(
      color: accent == null
          ? AppColors.surfaceContainerHighest
          : accent.withValues(alpha: 0.16),
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
            border: Border.all(
              color: accent ?? AppColors.outlineVariant,
            ),
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
  const _Side({
    required this.code,
    required this.label,
    required this.overall,
  });
  final String code;
  final String label;

  /// The side's team overall, shown under the name. Zero hides it — a side
  /// whose XI isn't known yet has no honest number to print.
  final int overall;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
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
        if (overall > 0)
          Text(
            '${l.teamOverall} $overall',
            maxLines: 1,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
