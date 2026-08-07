import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The press conference: one question, a handful of answers, each with a cost.
///
/// Deliberately a single question and no follow-ups. A manager should feel the
/// choice, not work through an interview — so the trade-off is stated plainly
/// on every option and the sheet is done in one tap.
class PressSheet extends ConsumerWidget {
  const PressSheet({
    required this.careerId,
    required this.question,
    required this.opponentName,
    super.key,
  });

  final int careerId;
  final PressQuestion question;

  /// The other nation, when the question is about a specific match.
  final String? opponentName;

  /// The seed every wording on this sheet is drawn from: the question's own
  /// key, so a given question always reads the same but two questions on the
  /// same topic are put differently. Each topic carries EIGHT wordings and each
  /// stance six, because three of each was not enough over a long career: the
  /// press had a short script and a manager heard it back inside two cycles.
  int get _seed => varietySeed('pressq:${question.key}');

  String _prompt(AppLocalizations l) {
    final who = opponentName ?? l.pressTheOpposition;
    final options = switch (question.topic) {
      PressTopic.heavyDefeat => [
        l.pressAskHeavyDefeat(who),
        l.pressAskHeavyDefeat2(who),
        l.pressAskHeavyDefeat3(who),
        l.pressAskHeavyDefeat4(who),
        l.pressAskHeavyDefeat5(who),
        l.pressAskHeavyDefeat6(who),
        l.pressAskHeavyDefeat7(who),
        l.pressAskHeavyDefeat8(who),
      ],
      PressTopic.elimination => [
        l.pressAskElimination(who),
        l.pressAskElimination2(who),
        l.pressAskElimination3(who),
        l.pressAskElimination4(who),
        l.pressAskElimination5(who),
        l.pressAskElimination6(who),
        l.pressAskElimination7(who),
        l.pressAskElimination8(who),
      ],
      PressTopic.underPressure => [
        l.pressAskUnderPressure,
        l.pressAskUnderPressure2,
        l.pressAskUnderPressure3,
        l.pressAskUnderPressure4,
        l.pressAskUnderPressure5,
        l.pressAskUnderPressure6,
        l.pressAskUnderPressure7,
        l.pressAskUnderPressure8,
      ],
      PressTopic.tournamentPreview => [
        l.pressAskPreview,
        l.pressAskPreview2,
        l.pressAskPreview3,
        l.pressAskPreview4,
        l.pressAskPreview5,
        l.pressAskPreview6,
        l.pressAskPreview7,
        l.pressAskPreview8,
      ],
      PressTopic.tournamentOpening => [
        l.pressAskOpening(who),
        l.pressAskOpening2(who),
        l.pressAskOpening3(who),
        l.pressAskOpening4(who),
        l.pressAskOpening5(who),
        l.pressAskOpening6(who),
        l.pressAskOpening7(who),
        l.pressAskOpening8(who),
      ],
      PressTopic.triumph => [
        l.pressAskTriumph,
        l.pressAskTriumph2,
        l.pressAskTriumph3,
        l.pressAskTriumph4,
        l.pressAskTriumph5,
        l.pressAskTriumph6,
        l.pressAskTriumph7,
        l.pressAskTriumph8,
      ],
      PressTopic.bigWin => [
        l.pressAskBigWin(who),
        l.pressAskBigWin2(who),
        l.pressAskBigWin3(who),
        l.pressAskBigWin4(who),
        l.pressAskBigWin5(who),
        l.pressAskBigWin6(who),
        l.pressAskBigWin7(who),
        l.pressAskBigWin8(who),
      ],
      PressTopic.qualified => [
        l.pressAskQualified,
        l.pressAskQualified2,
        l.pressAskQualified3,
        l.pressAskQualified4,
        l.pressAskQualified5,
        l.pressAskQualified6,
        l.pressAskQualified7,
        l.pressAskQualified8,
      ],
      PressTopic.missedOut => [
        l.pressAskMissedOut,
        l.pressAskMissedOut2,
        l.pressAskMissedOut3,
        l.pressAskMissedOut4,
        l.pressAskMissedOut5,
        l.pressAskMissedOut6,
        l.pressAskMissedOut7,
        l.pressAskMissedOut8,
      ],
      PressTopic.unbeatenRun => [
        l.pressAskUnbeaten,
        l.pressAskUnbeaten2,
        l.pressAskUnbeaten3,
        l.pressAskUnbeaten4,
        l.pressAskUnbeaten5,
        l.pressAskUnbeaten6,
        l.pressAskUnbeaten7,
        l.pressAskUnbeaten8,
      ],
      PressTopic.newJob => [
        l.pressAskNewJob,
        l.pressAskNewJob2,
        l.pressAskNewJob3,
        l.pressAskNewJob4,
        l.pressAskNewJob5,
        l.pressAskNewJob6,
        l.pressAskNewJob7,
        l.pressAskNewJob8,
      ],
      PressTopic.rankingPeak => [
        l.pressAskRankingPeak,
        l.pressAskRankingPeak2,
        l.pressAskRankingPeak3,
        l.pressAskRankingPeak4,
        l.pressAskRankingPeak5,
        l.pressAskRankingPeak6,
        l.pressAskRankingPeak7,
        l.pressAskRankingPeak8,
      ],
    };
    return pickVariant(options, _seed);
  }

  /// The answers are phrased six ways — the same stance, said differently — so
  /// a manager who always backs the players isn't reading one stock line for a
  /// whole career. The tone (and what it costs) is unchanged.
  String _answer(AppLocalizations l, PressTone tone) {
    final options = switch (tone) {
      PressTone.backThePlayers => [
        l.pressAnswerBackPlayers,
        l.pressAnswerBackPlayers2,
        l.pressAnswerBackPlayers3,
        l.pressAnswerBackPlayers4,
        l.pressAnswerBackPlayers5,
        l.pressAnswerBackPlayers6,
      ],
      PressTone.takeTheBlame => [
        l.pressAnswerTakeBlame,
        l.pressAnswerTakeBlame2,
        l.pressAnswerTakeBlame3,
        l.pressAnswerTakeBlame4,
        l.pressAnswerTakeBlame5,
        l.pressAnswerTakeBlame6,
      ],
      PressTone.demandMore => [
        l.pressAnswerDemandMore,
        l.pressAnswerDemandMore2,
        l.pressAnswerDemandMore3,
        l.pressAnswerDemandMore4,
        l.pressAnswerDemandMore5,
        l.pressAnswerDemandMore6,
      ],
      PressTone.raiseTheBar => [
        l.pressAnswerRaiseBar,
        l.pressAnswerRaiseBar2,
        l.pressAnswerRaiseBar3,
        l.pressAnswerRaiseBar4,
        l.pressAnswerRaiseBar5,
        l.pressAnswerRaiseBar6,
      ],
      PressTone.playItDown => [
        l.pressAnswerPlayDown,
        l.pressAnswerPlayDown2,
        l.pressAnswerPlayDown3,
        l.pressAnswerPlayDown4,
        l.pressAnswerPlayDown5,
        l.pressAnswerPlayDown6,
      ],
    };
    // Offset per tone so one sheet doesn't read as three variants of the same
    // sentence structure.
    return pickVariant(options, _seed + tone.index * 7);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.marginMobile,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(Icons.mic_rounded, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Text(l.pressTitle, style: AppTypography.headlineMedium),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(_prompt(l), style: AppTypography.bodyMedium),
              const SizedBox(height: AppSpacing.lg),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final tone in question.options)
                        _AnswerTile(
                          label: _answer(l, tone),
                          effect: Press.effectOf(tone),
                          onTap: () async {
                            await ref
                                .read(pressServiceProvider)
                                .answer(careerId, question, tone);
                            if (context.mounted) Navigator.of(context).pop();
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

/// One answer, with what it does to the dressing room and the board shown up
/// front — the choice is the trade-off, so hiding it would only make it a
/// guess.
class _AnswerTile extends StatelessWidget {
  const _AnswerTile({
    required this.label,
    required this.effect,
    required this.onTap,
  });

  final String label;
  final PressEffect effect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadii.baseAll,
        child: InkWell(
          borderRadius: AppRadii.baseAll,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('“$label”', style: AppTypography.bodyMedium),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _Swing(label: l.pressSquad, value: effect.morale),
                    const SizedBox(width: AppSpacing.md),
                    _Swing(label: l.pressBoard, value: effect.board),
                    if (effect.morale == 0 && effect.board == 0)
                      Text(
                        l.pressNoEffect,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Swing extends StatelessWidget {
  const _Swing({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    if (value == 0) return const SizedBox.shrink();
    final up = value > 0;
    final color = up ? AppColors.positive : AppColors.error;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
          size: 13,
          color: color,
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
