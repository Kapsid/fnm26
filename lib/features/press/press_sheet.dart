import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/features/press/press_copy.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The press conference: a room of named reporters, two or three questions,
/// and a back page written from what was said.
///
/// The opening question is about the story the season called the room for;
/// the second reacts to the answer just given (and may name a player); the
/// third, when there is one, throws an old statement back at him.
class PressSheet extends ConsumerStatefulWidget {
  const PressSheet({
    required this.careerId,
    required this.conference,
    required this.playerNames,
    required this.opponentName,
    super.key,
  });

  final int careerId;
  final PendingConference conference;

  /// Player id to name, for the ids the conference can mention.
  final Map<int, String> playerNames;
  final String opponentName;

  @override
  ConsumerState<PressSheet> createState() => _PressSheetState();
}

class _PressSheetState extends ConsumerState<PressSheet> {
  PendingConference get _c => widget.conference;

  late final int _seed = varietySeed('conf:${_c.row.id}');
  late final List<PressReporter> _room = Press.roomFor(_seed);
  late final Beat? _throwback = ConferenceBuilder.throwback(_c.facts);

  /// Fixed up front: two questions, or three when an old statement is due.
  late final int _length = _throwback == null ? 2 : 3;

  late final List<Beat> _beats = [ConferenceBuilder.opening(_c.facts)];
  final List<AnswerKind> _said = [];
  PressEffect _total = (morale: 0, board: 0);
  bool _busy = false;
  bool _leaving = false;
  bool _finished = false;

  bool get _over => _said.length >= _length;
  Beat get _beat => _beats.last;

  String? _nameOf(Beat beat) =>
      beat.playerId == null ? null : widget.playerNames[beat.playerId];

  Future<void> _answer(AnswerKind a) async {
    if (_busy) return;
    _busy = true;
    try {
      final effect = await ref
          .read(conferenceServiceProvider)
          .answer(widget.careerId, _c, _said.length, _beat, a);
      if (!mounted) return;
      setState(() {
        _said.add(a);
        _total = (
          morale: _total.morale + effect.morale,
          board: _total.board + effect.board,
        );
        if (_said.length == 1) {
          _beats.add(ConferenceBuilder.reaction(_c.facts, a));
        } else if (_said.length == 2 && _throwback != null) {
          _beats.add(_throwback);
        }
      });
    } finally {
      _busy = false;
    }
  }

  Future<void> _leave() async {
    if (_leaving) return;
    _leaving = true;
    final navigator = Navigator.of(context);
    try {
      await ref
          .read(conferenceServiceProvider)
          .finish(widget.careerId, _c.row.id);
    } on Object catch (e, st) {
      // Never trap him here: the conference stays pending and comes back, and
      // its answers are idempotent.
      AppLog.error('press-finish', e, st);
    }
    _leaving = false;
    if (!mounted) return;
    setState(() => _finished = true);
    navigator.pop();
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
    final index = _said.length;
    final beat = _beat;
    final playerName = _nameOf(beat);
    return PopScope(
      canPop: _finished,
      child: SafeArea(
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
                      l.pressQuestionOf((index + 1).clamp(1, _length), _length),
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
                              _Byline(reporter: _room[index % _room.length]),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                beatQuestion(
                                  l,
                                  beat,
                                  _c,
                                  playerName: playerName,
                                  opponentName: widget.opponentName,
                                  seed: _seed + index,
                                ),
                                style: AppTypography.bodyMedium,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              for (final a in beat.answers)
                                AnswerTile(
                                  label: answerLabel(
                                    l,
                                    a,
                                    playerName: playerName,
                                    seed: _seed + a.index * 7 + index * 3,
                                  ),
                                  effect: ConferenceBuilder.effectOf(
                                    a,
                                    _c.credibility,
                                  ),
                                  note: onRecordLine(
                                    l,
                                    a,
                                    playerName: playerName,
                                  ),
                                  onTap: () => _answer(a),
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
      ),
    );
  }
}

/// Who is asking: a name, an outlet, and a colour for the kind of question
/// they are about to put. The manager learns to brace for some of them.
class _Byline extends StatelessWidget {
  const _Byline({required this.reporter});

  final PressReporter reporter;

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
      ],
    );
  }
}

/// One answer, with what it does to the dressing room and the board shown up
/// front — the choice is the trade-off, so hiding it would only make it a
/// guess.
class AnswerTile extends StatelessWidget {
  const AnswerTile({
    required this.label,
    required this.effect,
    required this.onTap,
    this.note,
    super.key,
  });

  final String label;
  final PressEffect effect;

  /// What putting this on the record means ("On the record: ..."), if it does.
  final String? note;
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
                if (note case final line?) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    line,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
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
    final arrows = Press.arrowsFor(value);
    if (arrows == 0) return const SizedBox.shrink();
    final up = value > 0;
    final color = up ? AppColors.positive : AppColors.error;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 3),
        // One, two or three arrows rather than the raw figure. The number was
        // a point on a hidden 0-100 scale the manager has never seen — "Squad
        // 6" reads as six of something unknowable. How far the room moves is
        // the whole of what it was trying to say.
        for (var i = 0; i < arrows; i++)
          Icon(
            up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            size: 13,
            color: color,
          ),
      ],
    );
  }
}
