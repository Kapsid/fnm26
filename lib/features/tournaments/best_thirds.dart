import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/cross_group.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Cross-group ranking of standings: points, then goal difference, then goals
/// scored (best first).
int rankStandings(GroupStanding a, GroupStanding b) => CrossGroup.rank(a, b);

/// Every team finishing at [index] (1 = runners-up, 2 = thirds) across
/// [groups], ranked best-first on COMPARABLE records — results against the
/// bottom side of any oversized group are stripped out first, so a ladder drawn
/// from groups of five and six is judged over the same number of games. See
/// [CrossGroup].
List<GroupStanding> crossGroupTier(
  List<List<GroupStanding>> groups,
  int index,
) => CrossGroup.tier(groups, index);

/// The cross-group ladder that decides the last places in the modern group
/// formats — the best third-placed teams (48-team World Cup, 24-team
/// continental cups), or the best runners-up where only some second places go
/// through: the [qualifyCount] highest-ranked advance (green), the rest are
/// out.
/// The heading for a cross-group ladder card, named for the position that is
/// actually being fought over — first place where a confederation has fewer
/// berths than groups, or a fourth place where the finals field reaches that
/// deep into a small confederation.
String contentionLadderTitle(AppLocalizations l, int position) =>
    switch (position) {
      1 => l.tourContBestWinners,
      2 => l.tourContBestRunnersUp,
      3 => l.tourContBestThirds,
      _ => l.tourContBestPlaced('$position'),
    };

class BestThirdsCard extends StatelessWidget {
  const BestThirdsCard({
    required this.thirds,
    required this.qualifyCount,
    required this.playerNationId,
    required this.code,
    required this.name,
    this.destination = 'the knockouts',
    this.title = 'BEST THIRD-PLACED',
    this.adjustedForGroupSize = false,
    super.key,
  });

  /// The tier's teams (thirds or runners-up), already ranked best-first.
  final List<GroupStanding> thirds;
  final int qualifyCount;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;

  /// Where the qualifying thirds advance to — 'the knockouts' for a finals
  /// group stage, 'the finals' for a qualifying group stage.
  final String destination;

  /// The card heading — override for a runners-up ladder.
  final String title;

  /// Whether the groups behind this ladder are of different sizes, so the
  /// totals shown are the reduced ones the comparison actually uses. Says so on
  /// the card, otherwise a team's points here wouldn't match its group table.
  final bool adjustedForGroupSize;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
          ),
          Text(
            AppLocalizations.of(
              context,
            ).tourThirdsAdvance(qualifyCount, destination),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (adjustedForGroupSize)
            Text(
              AppLocalizations.of(context).tourThirdsUneven,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.warning,
              ),
            ),
          const SizedBox(height: AppSpacing.xs),
          for (var i = 0; i < thirds.length; i++)
            _thirdRow(i + 1, thirds[i], advancing: i < qualifyCount),
        ],
      ),
    );
  }

  Widget _thirdRow(int pos, GroupStanding s, {required bool advancing}) {
    final isPlayer = s.nationId == playerNationId;
    final gd = s.goalDifference;
    return Container(
      decoration: BoxDecoration(
        color: isPlayer ? AppColors.surfaceContainerHigh : null,
        border: Border(
          left: BorderSide(
            color: advancing ? AppColors.positive : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            child: Text(
              '$pos',
              style: AppTypography.labelSmall.copyWith(
                color: advancing
                    ? AppColors.positive
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          FlagDisc(code(s.nationId), size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name(s.nationId),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: isPlayer ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            width: 34,
            child: Text(
              gd > 0 ? '+$gd' : '$gd',
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '${s.points}',
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
