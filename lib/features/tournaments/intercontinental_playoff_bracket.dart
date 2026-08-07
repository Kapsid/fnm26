import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/features/tournaments/tournament_bracket.dart'
    show bracketName;
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// A two-round bracket for the intercontinental play-off: the semi-finals on the
/// left feed the two path finals on the right, each final's winner taking one of
/// the last two World Cup places (marked with a trophy).
///
/// The two top-ranked entrants get a bye straight to a path final, so in the
/// finals column their side carries a "seeded — bye" tag: without it those two
/// nations looked as if they appeared from nowhere. The columns are laid out as
/// an aligned ladder — equal height, ties spaced evenly — so each final sits
/// between/across from its feeding semi, the same idiom the World Cup bracket
/// uses.
///
/// Shared by the one-shot event screen and the World Cup detail's play-off tab.
class IntercontinentalPlayoffBracket extends StatelessWidget {
  const IntercontinentalPlayoffBracket({
    required this.ties,
    required this.code,
    required this.name,
    required this.playerNationId,
    super.key,
  });

  final List<PlayoffTie> ties;
  final String Function(int) code;
  final String Function(int) name;
  final int playerNationId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final semis = [
      for (final t in ties)
        if (!t.isFinal) t,
    ];
    final finals = [
      for (final t in ties)
        if (t.isFinal) t,
    ];
    // Tall enough for the busier column; even spacing then lands each final
    // across from its feeding semi. A little extra per tie for the seed tag.
    final rows = semis.length > finals.length ? semis.length : finals.length;
    final height = (rows * 112.0).clamp(224.0, 4000.0);
    // Horizontally scrollable so the two columns never overflow a narrow phone.
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _column(l.tourContSemiFinals, semis),
            const SizedBox(width: AppSpacing.md),
            _column(l.tourContPlayoffFinals, finals, decisive: true),
          ],
        ),
      ),
    );
  }

  Widget _column(String label, List<PlayoffTie> col, {bool decisive = false}) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: decisive ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Even vertical spacing aligns each round's ties with the next.
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final t in col) _tieCard(t, decisive: decisive),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tieCard(PlayoffTie t, {required bool decisive}) {
    // The manager's own tie is lifted whole, not just by a ringed flag.
    final mine = t.home == playerNationId || t.away == playerNationId;
    return Container(
      decoration: BoxDecoration(
        color:
            mine ? AppColors.surfaceContainerHigh : AppColors.surfaceContainer,
        borderRadius: AppRadii.baseAll,
        border: Border.all(
          color: mine ? AppColors.primary : AppColors.outlineVariant,
          width: mine ? 1.5 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // In a path final the home side is the top-ranked team that byed
          // straight in — tag it so it doesn't read as coming from nowhere.
          _sideRow(t, t.home, t.homeScore,
              decisive: decisive, top: true, seeded: decisive),
          const Divider(height: 1, color: AppColors.outlineVariant),
          _sideRow(t, t.away, t.awayScore,
              decisive: decisive, top: false, seeded: false),
        ],
      ),
    );
  }

  Widget _sideRow(
    PlayoffTie t,
    int id,
    int score, {
    required bool decisive,
    required bool top,
    required bool seeded,
  }) {
    final won = t.winner == id;
    final isPlayer = id == playerNationId;
    final color = won
        ? AppColors.positive
        : isPlayer
            ? AppColors.primary
            : AppColors.onSurfaceVariant;
    return Builder(
      builder: (context) {
        final l = AppLocalizations.of(context);
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            // Tint the advancing side green so the winner reads at a glance.
            color: won ? AppColors.positive.withValues(alpha: 0.10) : null,
            borderRadius: BorderRadius.vertical(
              top: top ? const Radius.circular(AppRadii.base) : Radius.zero,
              bottom: top ? Radius.zero : const Radius.circular(AppRadii.base),
            ),
          ),
          child: Row(
            children: [
              FlagDisc(code(id), size: 18, highlighted: isPlayer),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bracketName(name(id), code(id)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSmall.copyWith(
                        color: color,
                        fontWeight: won ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                    if (seeded)
                      Text(
                        l.tourContPlayoffSeeded,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 9,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              // The winner of a play-off final books a World Cup place.
              if (won && decisive) ...[
                const Icon(
                  Icons.emoji_events_rounded,
                  size: 13,
                  color: AppColors.positive,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                '$score',
                style: AppTypography.labelMedium.copyWith(
                  color: color,
                  fontWeight: won ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
