import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// A one-line strip naming who walks into this edition holding the trophy,
/// and the year they won it.
///
/// Renders nothing at all when [holders] is null — a competition nobody has
/// ever won says nothing rather than showing an empty placeholder.
class TournamentHoldersRow extends StatelessWidget {
  const TournamentHoldersRow({
    required this.holders,
    required this.code,
    required this.name,
    super.key,
  });

  /// The holding nation and the year of the edition they won, or null.
  final ({int nationId, int year})? holders;

  /// Nation id to flag code, and to display name.
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    final h = holders;
    if (h == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.sm,
        AppSpacing.marginMobile,
        0,
      ),
      child: AppCard(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        child: Row(
          children: [
            Text(
              l.tourHolders,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            FlagDisc(code(h.nationId), size: 20),
            const SizedBox(width: AppSpacing.sm),
            // The nation's name is the part that can run long (Czech names
            // longest of all), so it is the part that gives way first — the
            // year beside it stays whole at 360px in either language.
            Expanded(
              child: Text(
                name(h.nationId),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              l.tourHoldersSince(h.year),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
