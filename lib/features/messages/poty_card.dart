import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// One winner of a year's individual award.
///
/// Everything the card prints, resolved at the moment the award was handed
/// out. The message body is stored text, so the card cannot go back and ask
/// the database what a player's rating was three seasons ago — the year has
/// moved on and the answer would be a different number.
typedef PotyRow = ({
  /// Whether this is the under-21 award rather than the main one.
  bool young,
  String name,

  /// FIFA code of his nation, for the flag.
  String nationCode,
  String nationName,
  int age,

  /// How good he is, 1-99.
  int overall,

  /// The year he was voted for: appearances, goals, assists, the mean mark he
  /// was given and how often he was the best man on the pitch.
  int apps,
  int goals,
  int assists,
  double meanRating,
  int motms,
});

/// Marks a message body as an encoded player-of-the-year card.
///
/// Versioned like the squad-development and transfer reports, and for the same
/// reason: a plain-text award written by an older build is sitting in people's
/// saves and must keep opening. It simply decodes to null and is shown as the
/// sentence it always was.
const String _potyTagV1 = '#poty/v1';

/// Encodes the year's winners as a message body.
String encodePotyReport(List<PotyRow> rows) => [
  _potyTagV1,
  for (final r in rows)
    [
      if (r.young) 'young' else 'best',
      r.name.replaceAll('|', ' '),
      r.nationCode,
      r.nationName.replaceAll('|', ' '),
      '${r.age}',
      '${r.overall}',
      '${r.apps}',
      '${r.goals}',
      '${r.assists}',
      r.meanRating.toStringAsFixed(2),
      '${r.motms}',
    ].join('|'),
].join('\n');

/// Decodes a body written by [encodePotyReport], or null if it is not one.
List<PotyRow>? decodePotyReport(String body) {
  final lines = body.split('\n');
  if (lines.first.trim() != _potyTagV1) return null;
  final out = <PotyRow>[];
  for (final line in lines.skip(1)) {
    if (line.trim().isEmpty) continue;
    final f = line.split('|');
    if (f.length < 11) continue;
    out.add((
      young: f[0] == 'young',
      name: f[1],
      nationCode: f[2],
      nationName: f[3],
      age: int.tryParse(f[4]) ?? 0,
      overall: int.tryParse(f[5]) ?? 0,
      apps: int.tryParse(f[6]) ?? 0,
      goals: int.tryParse(f[7]) ?? 0,
      assists: int.tryParse(f[8]) ?? 0,
      meanRating: double.tryParse(f[9]) ?? 0,
      motms: int.tryParse(f[10]) ?? 0,
    ));
  }
  return out;
}

/// The year's individual awards, one card per winner.
///
/// The announcement used to be a sentence with a name in it, which is the one
/// thing about a player of the year that nobody needs telling twice. What the
/// manager actually wants to know is where he is from, what he did over the
/// year and how good he is — so the card carries his flag, his tally and his
/// rating, and the name is only the top line of it.
class PotyCard extends StatelessWidget {
  const PotyCard({required this.rows, super.key});

  final List<PotyRow> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final r in rows) ...[
          if (r != rows.first) const SizedBox(height: AppSpacing.sm),
          _WinnerCard(row: r),
        ],
      ],
    );
  }
}

/// One winner: who he is, then what he did.
///
/// TWO LINES, never one. A flag, an award name, a footballer's name, his
/// country and five numbers do not fit across a popup at 360 points in any
/// language — squeezed onto one row the numbers were the half that lost, which
/// is the half this card was added for.
class _WinnerCard extends StatelessWidget {
  const _WinnerCard({required this.row});

  final PotyRow row;

  /// Diameter of the winner's flag. Large enough to read a flag by at a glance
  /// and small enough to leave the name its width.
  static const double _flagSize = 34;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FlagDisc(row.nationCode, size: _flagSize),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TWO LINES, both here and on the country below. A
                    // bounded label is what stops a row growing taller than
                    // the box it sits in, but bounded to ONE line "Young
                    // Player of the Year" and "Bosnia and Herzegovina" are
                    // simply cut — and an award nobody can read the name of
                    // is the bug this card was written to fix. They wrap
                    // instead; the card is a little taller and says what it
                    // means.
                    Text(
                      row.young ? l.potyLabelYoung : l.potyLabelBest,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // A [WholeText], and the only one on the card. There is no
                    // layout that prints a twenty-six letter name beside a
                    // flag inside a popup, so the question is what it gives
                    // up: the forename, which does not identify a footballer,
                    // rather than the ending, which does.
                    WholeText(
                      row.name,
                      shortText: initialledName(row.name),
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: AppTypography.titleMedium,
                    ),
                    Text(
                      row.nationName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // A WRAP, not a Row. Five labelled numbers in two languages will not
          // sit on one line on every phone, and a Row would answer that by
          // cutting the last of them off; a Wrap puts the overflow on a second
          // line and every figure stays readable.
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _Stat(
                l.potyOverallValue(row.overall),
                color: AppColors.primary,
                strong: true,
              ),
              // His age belongs with the figures, not tacked onto the
              // country: "Czech Republic · 27" on one line is two facts
              // fighting over the same width, and the country lost.
              _Stat(l.squadAgeShort(row.age)),
              _Stat(l.msgTallyCaps(row.apps)),
              _Stat(l.msgTallyGoals(row.goals)),
              if (row.assists > 0) _Stat(l.potyTallyAssists(row.assists)),
              _Stat(
                l.potyRatingValue(row.meanRating.toStringAsFixed(2)),
                color: AppColors.ratingColor(row.meanRating),
                strong: true,
              ),
              if (row.motms > 0) _Stat(l.statsMotmShort(row.motms)),
            ],
          ),
        ],
      ),
    );
  }
}

/// One figure off the winner's year.
///
/// A plain [Text], deliberately: a [WholeText] scales itself down to fit and
/// never reports a cut, so a stat that had quietly lost a digit would sail
/// past the width guard. This one complains.
class _Stat extends StatelessWidget {
  const _Stat(this.text, {this.color, this.strong = false});

  final String text;
  final Color? color;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: const BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: AppRadii.smAll,
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.labelSmall.copyWith(
          color: color ?? AppColors.onSurfaceVariant,
          fontWeight: strong ? FontWeight.w800 : null,
        ),
      ),
    );
  }
}
