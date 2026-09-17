import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/club/club_history.dart';
import 'package:fnm/domain/services/club/clubs.dart';
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
              for (var i = spells.length - 1; i >= 0; i--)
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
                              ? '${spells[i].fromYear}–'
                              : spells[i].fromYear == spells[i].toYear
                              ? '${spells[i].fromYear}'
                              : '${spells[i].fromYear}–${spells[i].toYear}',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      // Which of these rows is a TRANSFER, and which way it
                      // went. Every row but the first is a move, and the card
                      // used to draw them all identically — so the season he
                      // stepped up to a big league read exactly like the season
                      // he dropped out of one. The arrow is the whole point of
                      // keeping the history at all.
                      _MoveMark(
                        from: i == 0 ? null : spells[i - 1],
                        to: spells[i],
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      if (spells[i].country.isNotEmpty) ...[
                        FlagDisc(spells[i].country, size: 18),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Expanded(
                        child: Text(
                          spells[i].club,
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

/// The marker on one row of a club history: whether the player ARRIVED there by
/// transfer, and whether that move was a step up, a step down or a sideways one.
///
/// [from] is the spell before this one — null for the club he started at, which
/// is not a transfer and gets a quiet dot instead of an arrow.
class _MoveMark extends StatelessWidget {
  const _MoveMark({required this.from, required this.to});

  final ClubSpell? from;
  final ClubSpell to;

  @override
  Widget build(BuildContext context) {
    final previous = from;
    if (previous == null) {
      return const Icon(
        Icons.circle,
        size: 8,
        color: AppColors.outlineVariant,
      );
    }
    // League strength runs 1 (elite) … 5 (lower), so a SMALLER number is the
    // better league — a move to a lower number is a step up.
    final step =
        ClubService.tierOfCountry(previous.country) -
        ClubService.tierOfCountry(to.country);
    final (icon, color) = switch (step) {
      > 0 => (Icons.arrow_upward_rounded, AppColors.positive),
      < 0 => (Icons.arrow_downward_rounded, AppColors.warning),
      _ => (Icons.swap_horiz_rounded, AppColors.onSurfaceVariant),
    };
    return Icon(icon, size: 14, color: color);
  }
}
