import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/tournament_stars.dart';
import 'package:fnm/features/tournaments/tournament_history.dart'
    show TournamentSoon;
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// A tournament's individual honours in one place — the Golden Ball (best
/// player), Golden Boot (top scorer), Golden Glove (best keeper) and the Team of
/// the Tournament. Shared by the World Cup and the continental cups. Empty until
/// the tournament has been played out.
class TournamentAwardsTab extends StatelessWidget {
  const TournamentAwardsTab({
    required this.team,
    required this.goldenGlove,
    required this.code,
    required this.name,
    super.key,
  });

  final List<StarPlayer> team;
  final ({int nationId, String name})? goldenGlove;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (team.isEmpty && goldenGlove == null) {
      return TournamentSoon(
        message: l.tourSharedAwardsEmpty,
      );
    }
    final goldenBall = team.isEmpty ? null : team.first;
    final goldenBoot = TournamentStars.goldenBoot(team);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        if (goldenBall != null)
          _AwardHero(
            award: 'GOLDEN BALL',
            sub: 'Player of the Tournament',
            icon: Icons.emoji_events_rounded,
            playerName: goldenBall.name,
            nationName: name(goldenBall.nationId),
            code: code(goldenBall.nationId),
          ),
        if (goldenBoot != null)
          _AwardHero(
            award: 'GOLDEN BOOT',
            sub: '${goldenBoot.goals} '
                '${goldenBoot.goals == 1 ? 'goal' : 'goals'}',
            icon: Icons.sports_soccer_rounded,
            playerName: goldenBoot.name,
            nationName: name(goldenBoot.nationId),
            code: code(goldenBoot.nationId),
          ),
        if (goldenGlove != null)
          GoldenGloveCard(
            name: goldenGlove!.name,
            nation: name(goldenGlove!.nationId),
            code: code(goldenGlove!.nationId),
          ),
        if (team.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          TeamOfTournamentCard(stars: team, code: code, name: name),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

/// A headline individual award: the trophy, the winner and their nation.
class _AwardHero extends StatelessWidget {
  const _AwardHero({
    required this.award,
    required this.sub,
    required this.icon,
    required this.playerName,
    required this.nationName,
    required this.code,
  });

  final String award;
  final String sub;
  final IconData icon;
  final String playerName;
  final String nationName;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 30),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    award,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(playerName, style: AppTypography.titleMedium),
                  Text(
                    '$nationName · $sub',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            FlagDisc(code, size: 26),
          ],
        ),
      ),
    );
  }
}

/// The Golden Glove award: the finals' best goalkeeper.
class GoldenGloveCard extends StatelessWidget {
  const GoldenGloveCard({
    required this.name,
    required this.nation,
    required this.code,
    super.key,
  });

  final String name;
  final String nation;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: AppCard(
        child: Row(
          children: [
            const Icon(Icons.sports_mma, color: AppColors.primary, size: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GOLDEN GLOVE',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(name, style: AppTypography.bodyLarge),
                ],
              ),
            ),
            FlagDisc(code, size: 22),
            const SizedBox(width: AppSpacing.sm),
            Text(
              nation,
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

/// The Team of the Tournament: the best XI, grouped by line.
class TeamOfTournamentCard extends StatelessWidget {
  const TeamOfTournamentCard({
    required this.stars,
    required this.code,
    required this.name,
    super.key,
  });

  final List<StarPlayer> stars;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    List<StarPlayer> line(PositionCategory c) =>
        stars.where((s) => s.position.category == c).toList();
    const order = [
      PositionCategory.goalkeeper,
      PositionCategory.defender,
      PositionCategory.midfielder,
      PositionCategory.forward,
    ];
    return AppCard(
      color: AppColors.secondaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_rounded, color: AppColors.primary, size: 18),
              const SizedBox(width: AppSpacing.sm),
              // Flexible: the heading is a long line of capitals and ran off
              // the card on a narrow phone.
              Flexible(
                child: Text(
                  'TEAM OF THE TOURNAMENT',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final cat in order)
            for (final s in line(cat)) _row(s),
        ],
      ),
    );
  }

  Widget _row(StarPlayer s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 34, child: TacticalChip(s.position.label)),
          const SizedBox(width: AppSpacing.sm),
          FlagDisc(code(s.nationId), size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              s.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall,
            ),
          ),
          if (s.goals > 0) ...[
            const Icon(Icons.sports_soccer, size: 12, color: AppColors.primary),
            const SizedBox(width: 2),
            Text('${s.goals}', style: AppTypography.labelSmall),
            const SizedBox(width: AppSpacing.sm),
          ],
          // The mark that earned the place. Shown instead of leaving the XI
          // looking like a list of the most famous names available.
          if (s.apps > 0) ...[
            Text(
              s.meanRating.toStringAsFixed(2),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.ratingColor(s.meanRating),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            '${s.overall}',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
