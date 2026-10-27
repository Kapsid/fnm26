import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/services/match/opponent_scouting.dart';
import 'package:fnm/features/match/scout_report_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The scout's "how they play" lines for [r], as sentences.
///
/// Every sentence stands on its own with "they" for the subject: the
/// dossier names the side once in its header, so no nation name is ever
/// declined inside a sentence. [seed] picks between the formation line's
/// phrasings, so two opponents do not read word for word alike.
List<String> scoutReportLines(AppLocalizations l, ScoutReport r, int seed) {
  if (r.depth == ScoutDepth.glimpse) {
    return [
      switch (r.leaning ?? ScoutLeaning.unclear) {
        ScoutLeaning.attacking => l.matchScoutLeaningAttacking,
        ScoutLeaning.cautious => l.matchScoutLeaningCautious,
        ScoutLeaning.unclear => l.matchScoutLeaningUnclear,
      },
    ];
  }
  return [
    if (r.formation case final f?)
      pickVariant<String Function(String)>([
        l.matchScoutFormation1,
        l.matchScoutFormation2,
        l.matchScoutFormation3,
      ], seed)(f.label),
    if (r.strengths.isEmpty) l.matchScoutStrengthNone,
    for (final s in r.strengths) _strength(l, s),
    if (r.weakness case final w?) _weakness(l, w),
    if (r.approach case final a?)
      switch (a) {
        ScoutApproach.takeTheGame => l.matchScoutApproachTakeTheGame,
        ScoutApproach.even => l.matchScoutApproachEven,
        ScoutApproach.sitDeep => l.matchScoutApproachSitDeep,
      },
  ];
}

String _strength(AppLocalizations l, ScoutStrength s) => switch (s) {
  ScoutStrength.pressing => l.matchScoutStrengthPressing,
  ScoutStrength.direct => l.matchScoutStrengthDirect,
  ScoutStrength.possession => l.matchScoutStrengthPossession,
  ScoutStrength.counter => l.matchScoutStrengthCounter,
  ScoutStrength.deepDefence => l.matchScoutStrengthDeepDefence,
  ScoutStrength.wide => l.matchScoutStrengthWide,
  ScoutStrength.attacking => l.matchScoutStrengthAttacking,
  ScoutStrength.quickForwards => l.matchScoutStrengthQuickForwards,
  ScoutStrength.passingMidfield => l.matchScoutStrengthPassingMidfield,
  ScoutStrength.hardRunning => l.matchScoutStrengthHardRunning,
  ScoutStrength.setPieces => l.matchScoutStrengthSetPieces,
  ScoutStrength.quickDefence => l.matchScoutStrengthQuickDefence,
};

String _weakness(AppLocalizations l, ScoutWeakness w) => switch (w) {
  ScoutWeakness.spaceBehind => l.matchScoutWeakSpaceBehind,
  ScoutWeakness.pressedBuildUp => l.matchScoutWeakPressedBuildUp,
  ScoutWeakness.deepBlock => l.matchScoutWeakDeepBlock,
  ScoutWeakness.longBall => l.matchScoutWeakLongBall,
  ScoutWeakness.slowDefence => l.matchScoutWeakSlowDefence,
  ScoutWeakness.aerial => l.matchScoutWeakAerial,
  ScoutWeakness.poorPassing => l.matchScoutWeakPoorPassing,
  ScoutWeakness.tiringMidfield => l.matchScoutWeakTiringMidfield,
  ScoutWeakness.bluntAttack => l.matchScoutWeakBluntAttack,
};

/// The dossier's world ranking and "how they play" section for one
/// opponent, from [scoutReportProvider]. Draws nothing until the report is
/// read, and wraps every line rather than cutting it short.
class ScoutReportSection extends ConsumerWidget {
  const ScoutReportSection({
    required this.careerId,
    required this.nationId,
    required this.seed,
    super.key,
  });

  final int careerId;
  final int nationId;

  /// Picks the phrasing (see [scoutReportLines]).
  final int seed;

  static const Key rankingKey = Key('scoutReport.ranking');
  static const Key linesKey = Key('scoutReport.lines');
  static const Key hireHintKey = Key('scoutReport.hireHint');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref
        .watch(scoutReportProvider((careerId: careerId, nationId: nationId)))
        .valueOrNull;
    if (report == null) return const SizedBox.shrink();
    return ScoutReportBody(report: report, seed: seed);
  }
}

/// [ScoutReportSection]'s drawing, on a report already read.
class ScoutReportBody extends StatelessWidget {
  const ScoutReportBody({required this.report, required this.seed, super.key});

  final ScoutReport report;
  final int seed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final label = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
      letterSpacing: 1,
    );
    final lines = scoutReportLines(
      l,
      report,
      varietySeed('scout:$seed'),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (report.worldRank case final rank?)
          Row(
            key: ScoutReportSection.rankingKey,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(l.hubWorldRankLabel.capsIn(lang), style: label),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l.hubWorldRank(rank),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        const SizedBox(height: AppSpacing.md),
        Text(l.matchDossierHowTheyPlay, style: label),
        const SizedBox(height: AppSpacing.xs),
        Text(
          lines.join(' '),
          key: ScoutReportSection.linesKey,
          style: AppTypography.bodyMedium,
        ),
        if (report.depth == ScoutDepth.glimpse) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.matchScoutHireHint,
            key: ScoutReportSection.hireHintKey,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}
