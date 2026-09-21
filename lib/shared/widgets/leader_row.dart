import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/shared/widgets/flag_disc.dart';
import 'package:fnm/shared/widgets/whole_text.dart';

/// One line of a leaderboard: where they rank, who they are, and the number
/// that put them there.
///
/// Five screens had grown their own copy of this row — the record book, the
/// all-time world records, the team-records tabs (twice) and a tournament's
/// records — each with slightly different padding, a flag or no flag, and its
/// own idea of when to bolden the leader. They are one row now, so a
/// leaderboard reads the same wherever the manager finds it.
class LeaderRow extends StatelessWidget {
  const LeaderRow({
    required this.rank,
    required this.name,
    required this.value,
    this.flagCode,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.highlighted = false,
    super.key,
  });

  /// 1-based position in the chart.
  final int rank;

  final String name;

  /// The tally, already formatted with its unit ("12 goals", "76 caps", "7.4").
  final String value;

  /// The nation to fly beside the name, where the chart spans nations. Omitted
  /// on a chart that is about one nation already.
  final String? flagCode;

  /// A second line under the name — appearances behind an average, say.
  final String? subtitle;

  /// An extra mark after the value, such as the still-active dot.
  final Widget? trailing;

  final VoidCallback? onTap;

  /// Draws attention to this line — a player of the manager's own nation in a
  /// chart that spans the world. Tints the row as well as the name, so it is
  /// findable at a glance rather than only on reading.
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    // The leader is the only line worth emboldening, but the top three carry
    // a chart between them and are marked rather than left to be counted down
    // to — the team-records chart already did this, and it is the better of
    // the two behaviours the copies had.
    final isLeader = rank == 1;
    final podium = rank <= 3;
    final row = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text(
              '$rank',
              style: AppTypography.labelMedium.copyWith(
                color: podium ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          if (flagCode case final code?) ...[
            FlagDisc(code, size: 20, highlighted: highlighted),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Every leaderboard in the game draws its holders through
                // here, and a holder is a NAME: the row shares its width with
                // a rank, a flag, a badge and the number itself, so an
                // ellipsis here reads "Bartholomew Vanderb..." on a 400pt
                // phone. It gives up the forename first, its size after.
                WholeText(
                  name,
                  maxLines: 1,
                  shortText: initialledName(name),
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: isLeader ? FontWeight.w700 : FontWeight.w400,
                    color: highlighted ? AppColors.primary : null,
                  ),
                ),
                if (subtitle case final sub?)
                  Text(
                    sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            value,
            maxLines: 1,
            softWrap: false,
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          if (trailing case final mark?) ...[
            const SizedBox(width: AppSpacing.xs),
            mark,
          ],
        ],
      ),
    );
    final marked = highlighted
        ? DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: AppRadii.smAll,
            ),
            child: row,
          )
        : row;
    return onTap == null ? marked : InkWell(onTap: onTap, child: marked);
  }
}
