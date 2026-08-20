import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The press conference: a room of named reporters, three questions, and a
/// back page written from what was said.
///
/// It used to be ONE anonymous question with a stance to pick, which read as a
/// form rather than a room: nobody ever came back at an answer, so a manager
/// could back his players in every conference of a twenty-year career and
/// never once be asked what that was supposed to mean. Now the opening
/// question is about the story, the second is a reporter reacting to the
/// stance just taken, and the third is whoever is asking riding their own
/// hobby-horse — and the morning's headline is the sum of all three.
class PressSheet extends ConsumerStatefulWidget {
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

  @override
  ConsumerState<PressSheet> createState() => _PressSheetState();
}

class _PressSheetState extends ConsumerState<PressSheet> {
  /// The seed every wording on this sheet is drawn from: the question's own
  /// key, so a given conference always reads the same but two conferences on
  /// the same topic are put differently.
  late final int _seed = varietySeed('pressq:${widget.question.key}');

  /// Who is in the room, in the order they get the microphone. Drawn from the
  /// question's key rather than at random so reopening the sheet is the same
  /// conference, not a new one.
  late final List<PressReporter> _room = Press.roomFor(
    _seed,
  ).take(Press.conferenceLength).toList();

  /// The exchanges asked so far, and what was said to each. The list grows as
  /// the manager answers: a follow-up cannot exist until there is a stance for
  /// it to react to.
  late final List<PressExchange> _asked = [
    Press.openingExchange(widget.question, _room.first),
  ];
  final List<PressTone> _said = [];

  /// Everything this conference has cost so far.
  PressEffect _total = (morale: 0, board: 0);

  bool get _over => _said.length >= Press.conferenceLength;
  PressExchange get _current => _asked.last;

  Future<void> _answer(PressTone tone) async {
    final effect = await ref
        .read(pressServiceProvider)
        .answerExchange(widget.careerId, _current, tone);
    if (!mounted) return;
    setState(() {
      _said.add(tone);
      if (effect != null) {
        _total = (
          morale: _total.morale + effect.morale,
          board: _total.board + effect.board,
        );
      }
      if (!_over) {
        _asked.add(
          Press.followUp(
            widget.question,
            _room[_said.length],
            tone,
            index: _said.length,
          ),
        );
      }
    });
  }

  void _leave() {
    ref.read(pressServiceProvider).refresh();
    Navigator.of(context).pop();
  }

  /// The question in front of the manager right now.
  String _prompt(AppLocalizations l) {
    final exchange = _current;
    // A follow-up is keyed by what it presses on; only the OPENING question is
    // about the situation, and it keeps the wordings it always had.
    if (exchange.probe case final probe?) {
      return pickVariant(
        _probeWordings(l, probe),
        _seed + probe.index * 13 + _said.length,
      );
    }
    return _openingPrompt(l);
  }

  String _openingPrompt(AppLocalizations l) {
    final who = widget.opponentName ?? l.pressTheOpposition;
    final options = switch (widget.question.topic) {
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

  static List<String> _probeWordings(AppLocalizations l, PressProbe probe) =>
      switch (probe) {
        PressProbe.accountability => [
          l.pressProbeAccountability1,
          l.pressProbeAccountability2,
          l.pressProbeAccountability3,
          l.pressProbeAccountability4,
        ],
        PressProbe.yourFuture => [
          l.pressProbeYourFuture1,
          l.pressProbeYourFuture2,
          l.pressProbeYourFuture3,
          l.pressProbeYourFuture4,
        ],
        PressProbe.dressingRoom => [
          l.pressProbeDressingRoom1,
          l.pressProbeDressingRoom2,
          l.pressProbeDressingRoom3,
          l.pressProbeDressingRoom4,
        ],
        PressProbe.expectation => [
          l.pressProbeExpectation1,
          l.pressProbeExpectation2,
          l.pressProbeExpectation3,
          l.pressProbeExpectation4,
        ],
        PressProbe.substance => [
          l.pressProbeSubstance1,
          l.pressProbeSubstance2,
          l.pressProbeSubstance3,
          l.pressProbeSubstance4,
        ],
        PressProbe.selection => [
          l.pressProbeSelection1,
          l.pressProbeSelection2,
          l.pressProbeSelection3,
          l.pressProbeSelection4,
        ],
        PressProbe.theFans => [
          l.pressProbeTheFans1,
          l.pressProbeTheFans2,
          l.pressProbeTheFans3,
          l.pressProbeTheFans4,
        ],
        PressProbe.bigPicture => [
          l.pressProbeBigPicture1,
          l.pressProbeBigPicture2,
          l.pressProbeBigPicture3,
          l.pressProbeBigPicture4,
        ],
      };

  /// The stances are phrased six ways — the same answer, said differently — so
  /// a manager who always backs the players isn't reading one stock line for a
  /// whole career.
  String _answerText(AppLocalizations l, PressTone tone) {
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
    // Offset per tone and per question so one sheet doesn't read as three
    // variants of the same sentence structure.
    return pickVariant(
      options,
      _seed + tone.index * 7 + _asked.length * 3,
    );
  }

  /// The line a reporter throws in when the manager keeps saying the same
  /// thing. Null when they have nothing to needle him about yet.
  String? _needle(AppLocalizations l, Map<PressTone, int> habits) {
    if (_current.probe == null)
      return null; // the opening question is asked straight
    final tone = _said.isEmpty ? null : _said.last;
    if (tone == null) return null;
    if ((habits[tone] ?? 0) < pressNeedleThreshold) return null;
    return switch (tone) {
      PressTone.backThePlayers => l.pressNeedleBackPlayers,
      PressTone.takeTheBlame => l.pressNeedleTakeBlame,
      PressTone.demandMore => l.pressNeedleDemandMore,
      PressTone.raiseTheBar => l.pressNeedleRaiseBar,
      PressTone.playItDown => l.pressNeedlePlayDown,
    };
  }

  String _headline(AppLocalizations l) {
    final options = switch (Press.verdictOf(_total)) {
      PressVerdict.went => [
        l.pressHeadlineWent1,
        l.pressHeadlineWent2,
        l.pressHeadlineWent3,
      ],
      PressVerdict.mixed => [
        l.pressHeadlineMixed1,
        l.pressHeadlineMixed2,
        l.pressHeadlineMixed3,
      ],
      PressVerdict.badly => [
        l.pressHeadlineBadly1,
        l.pressHeadlineBadly2,
        l.pressHeadlineBadly3,
      ],
      PressVerdict.flat => [
        l.pressHeadlineFlat1,
        l.pressHeadlineFlat2,
        l.pressHeadlineFlat3,
      ],
    };
    return pickVariant(options, _seed);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final habits =
        ref.watch(pressToneHistoryProvider(widget.careerId)).valueOrNull ??
        const <PressTone, int>{};
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
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
                  Expanded(
                    child: Text(
                      l.pressConferenceTitle,
                      style: AppTypography.headlineMedium,
                    ),
                  ),
                  Text(
                    l.pressQuestionOf(
                      (_said.length + 1).clamp(1, Press.conferenceLength),
                      Press.conferenceLength,
                    ),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Flexible(
                child: SingleChildScrollView(
                  child: _over
                      ? _Verdict(
                          headline: _headline(l),
                          total: _total,
                          onLeave: _leave,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Byline(
                              reporter: _current.reporter,
                              aside: _needle(l, habits),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(_prompt(l), style: AppTypography.bodyMedium),
                            const SizedBox(height: AppSpacing.lg),
                            for (final tone in _current.options)
                              _AnswerTile(
                                label: _answerText(l, tone),
                                effect: Press.effectOfExchange(_current, tone),
                                onTap: () => _answer(tone),
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

/// Who is asking: a name, an outlet, and a colour for the kind of question
/// they are about to put. The manager learns to brace for some of them.
class _Byline extends StatelessWidget {
  const _Byline({required this.reporter, this.aside});

  final PressReporter reporter;

  /// The reporter's needle, when the manager has been saying the same thing
  /// for years and somebody in the room has finally said so.
  final String? aside;

  @override
  Widget build(BuildContext context) {
    final color = switch (reporter.angle) {
      PressAngle.tabloid => AppColors.error,
      PressAngle.broadsheet => AppColors.primary,
      PressAngle.analyst => AppColors.positive,
      PressAngle.local => AppColors.warning,
      PressAngle.foreign => AppColors.onSurfaceVariant,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 3, height: 26, color: color),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reporter.name,
                    style: AppTypography.labelMedium.copyWith(color: color),
                  ),
                  Text(
                    reporter.outlet,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (aside case final line?) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            line,
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

/// How the whole thing read: tomorrow's back page, and the two numbers the
/// manager actually has to live with.
class _Verdict extends StatelessWidget {
  const _Verdict({
    required this.headline,
    required this.total,
    required this.onLeave,
  });

  final String headline;
  final PressEffect total;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.pressTomorrowsHeadline,
          style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: AppRadii.baseAll,
            border: Border(
              left: BorderSide(color: AppColors.primary, width: 3),
            ),
          ),
          child: Text(headline, style: AppTypography.headlineMedium),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            _Swing(label: l.pressRoomVerdictSquad, value: total.morale),
            const SizedBox(width: AppSpacing.lg),
            _Swing(label: l.pressRoomVerdictBoard, value: total.board),
            if (total.morale == 0 && total.board == 0)
              Text(
                l.pressNoEffect,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onLeave,
            child: Text(l.pressLeaveRoom),
          ),
        ),
      ],
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
          '$label ${value.abs()}',
          style: AppTypography.labelSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
