import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Where the match is played and who turned up: the ground, its city, and the
/// crowd against the stadium's capacity.
///
/// The crowd is not decoration — how full the ground is scales whatever home
/// advantage applies (see [Attendance.atmosphere]), so a sell-out is worth
/// something and a half-empty friendly is not.
class GroundCard extends StatelessWidget {
  const GroundCard({
    required this.ground,
    this.compact = false,
    this.neutral = false,
    this.groundNationCode,
    super.key,
  });

  final MatchGround ground;

  /// A single line, for the pre-match preview where space is tight.
  final bool compact;

  /// Whether the tie is played on neutral ground (a finals match at the
  /// tournament host). Worth stating: it is the difference between a home
  /// crowd behind the side and a stadium that belongs to neither team.
  final bool neutral;

  /// The country the ground is in, for its flag — the tournament host at a
  /// neutral finals, the home nation otherwise.
  final String? groundNationCode;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fill = ground.capacity <= 0
        ? 0.0
        : (ground.attendance / ground.capacity).clamp(0.0, 1.0);
    final code = groundNationCode;
    final crowd = Row(
      children: [
        if (code != null)
          FlagDisc(code, size: 16)
        else
          const Icon(
            Icons.stadium_outlined,
            size: 16,
            color: AppColors.onSurfaceVariant,
          ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            '${ground.stadium} · ${ground.city}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelMedium,
          ),
        ),
        if (neutral) ...[
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: AppRadii.smAll,
            ),
            child: Text(
              l.matchNeutralGround,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 9,
              ),
            ),
          ),
        ],
        const SizedBox(width: AppSpacing.sm),
        Text(
          _thousands(ground.attendance),
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (ground.soldOut) ...[
          const SizedBox(width: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.positive.withValues(alpha: 0.15),
              borderRadius: AppRadii.smAll,
            ),
            child: Text(
              l.matchSoldOut,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.positive,
                fontWeight: FontWeight.w700,
                fontSize: 9,
              ),
            ),
          ),
        ],
      ],
    );
    if (compact) return crowd;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          crowd,
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: LinearProgressIndicator(
              value: fill,
              minHeight: 5,
              backgroundColor: AppColors.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                fill >= 0.95 ? AppColors.positive : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.matchAttendanceOf(
              _thousands(ground.attendance),
              _thousands(ground.capacity),
            ),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// `62431` → `62,431`.
  static String _thousands(int v) {
    final s = '$v';
    final out = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) out.write(',');
      out.write(s[i]);
    }
    return out.toString();
  }
}
