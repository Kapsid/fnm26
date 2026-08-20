import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/club/club_history.dart';
import 'package:fnm/features/player/club_history_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Where a player has played, season by season, collapsed into spells.
///
/// Clubs follow a player's rating, so this is the transfer record the save has
/// been writing all along without ever showing it: the move up after a good
/// cycle, the drop down as he fades, the years he stayed put.
class ClubHistoryCard extends ConsumerWidget {
  const ClubHistoryCard({
    required this.careerId,
    required this.playerId,
    super.key,
  });

  final int careerId;
  final int playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final spells =
        ref
            .watch(
              clubHistoryProvider((
                careerId: careerId,
                playerId: playerId,
              )),
            )
            .valueOrNull ??
        const <ClubSpell>[];
    // Nothing derived at all — a newgen who has not come through yet.
    //
    // A SINGLE spell used to be hidden too, on the reasoning that it merely
    // repeats the club named at the top of the card. On the device that read
    // as a player whose transfers the game would not show: the section was
    // simply absent, with nothing to say it was absent on purpose. A one-club
    // career is a career, and saying so is the answer to "has he ever moved?".
    if (spells.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text(
          l.playerClubHistory,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              // Newest first — where he is now, then how he got here.
              for (final s in spells.reversed)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 74,
                        child: Text(
                          spells.length == 1
                              // He is still there, so the span is open.
                              ? '${s.fromYear}–'
                              : s.fromYear == s.toYear
                              ? '${s.fromYear}'
                              : '${s.fromYear}–${s.toYear}',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (s.country.isNotEmpty) ...[
                        FlagDisc(s.country, size: 18),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Expanded(
                        child: Text(
                          s.club,
                          style: AppTypography.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
