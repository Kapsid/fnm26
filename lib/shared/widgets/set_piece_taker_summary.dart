import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Names the two men who will step up, above the list that changes them.
///
/// The slots used to sit blank until the manager named somebody, which read as
/// "nobody is taking these" when in fact the engine had already picked the best
/// technical man in the side. Shared so the tactics screen and the in-match
/// editor cannot drift apart on who that is.
class SetPieceTakerSummary extends StatelessWidget {
  const SetPieceTakerSummary({
    required this.penaltyName,
    required this.penaltyIsAuto,
    required this.deadBallName,
    required this.deadBallIsAuto,
    this.onQuickPick,
    super.key,
  });

  /// The man on penalties, or null when the side is empty.
  final String? penaltyName;

  /// True when nobody has been named and this is the engine's own pick.
  final bool penaltyIsAuto;

  final String? deadBallName;
  final bool deadBallIsAuto;

  /// Takes the men named above and makes them the manager's own, in one tap.
  ///
  /// The automatic pick was already correct and already on screen, which is
  /// exactly why it read as inert: there was nothing to press. This is the
  /// press. Null on a screen that offers no such button.
  final VoidCallback? onQuickPick;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _line(
          icon: Icons.sports_soccer,
          label: l.tacticsPenalties,
          name: penaltyName,
          isAuto: penaltyIsAuto,
          auto: l.tacticsTakerAuto,
        ),
        const SizedBox(height: AppSpacing.sm),
        _line(
          icon: Icons.flag_rounded,
          label: l.tacticsCornersFreeKicks,
          name: deadBallName,
          isAuto: deadBallIsAuto,
          auto: l.tacticsTakerAuto,
        ),
        // Only while something is still automatic, and only when there is a
        // man to name: the button vanishing is how the manager sees that both
        // duties are now his, and a tap that changed nothing visible is the
        // complaint this whole thing answers.
        if (onQuickPick != null &&
            (penaltyIsAuto || deadBallIsAuto) &&
            (penaltyName != null || deadBallName != null)) ...[
          const SizedBox(height: AppSpacing.md),
          _QuickPickButton(
            label: l.tacticsTakerQuickPick,
            onTap: onQuickPick!,
          ),
        ],
      ],
    );
  }

  /// One set piece: what it is (with the automatic marker when nobody has been
  /// named) over the name itself. Stacked rather than side by side because a
  /// name and a label sharing one line on a 360px phone is how a taker's name
  /// ends up ellipsised, which is the one thing this row exists to show.
  Widget _line({
    required IconData icon,
    required String label,
    required String? name,
    required bool isAuto,
    required String auto,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAuto ? '$label  ·  $auto' : label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              if (name != null)
                Text(
                  name,
                  // Two lines, not one: a real surname wants more than the
                  // ~300px a card leaves on a 360px phone, and a taker's name
                  // clipped to "Vondráčkovs…" is the guessing this row exists
                  // to end. It wraps rather than shrinks.
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The one-tap accept: a bordered pill with the bolt and the label.
///
/// A PrimaryButton would have been the obvious reach, and it holds its label
/// to one line with no wrapping — which is how a Czech label on a 360px phone
/// loses its tail. This one lets the text wrap instead: two short lines are
/// read, half a label is guessed at.
class _QuickPickButton extends StatelessWidget {
  const _QuickPickButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.mdAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.mdAll,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: AppSpacing.minHitArea,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadii.mdAll,
              color: AppColors.primary.withValues(alpha: 0.12),
              border: Border.all(color: AppColors.primary),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.bolt_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 2,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
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
