import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/nation_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/squad/call_up_advice.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/adaptive_sheet.dart';
import 'package:fnm/shared/widgets/whole_text.dart';

/// Keys the tests find the advice by.
abstract final class CallUpAdviceKeys {
  static const Key ask = Key('assistant.ask');
  static const Key sheet = Key('assistant.sheet');
  static const Key apply = Key('assistant.apply');
  static const Key close = Key('assistant.close');
  static Key proposal(int index) => Key('assistant.proposal.$index');
}

/// The short words on a reason chip. [positions] are the places the reason
/// names (see [CallUpProposal.positions]) and [formation] the shape of a
/// change-of-tactics card.
String callUpReasonLabel(
  AppLocalizations l,
  CallUpReason r, {
  List<PlayerPosition> positions = const [],
  Formation? formation,
}) {
  String at(int i) => i < positions.length ? positions[i].label : '';
  return switch (r) {
    CallUpReason.topPick => l.assistantReasonTopPick,
    CallUpReason.lineCover => l.assistantReasonLineCover,
    CallUpReason.inForm => l.assistantReasonInForm,
    CallUpReason.fresh => l.assistantReasonFresh,
    CallUpReason.young => l.assistantReasonYoung,
    CallUpReason.experienced => l.assistantReasonExperienced,
    CallUpReason.injured => l.assistantReasonInjured,
    CallUpReason.banned => l.assistantReasonBanned,
    CallUpReason.tired => l.assistantReasonTired,
    CallUpReason.outOfForm => l.assistantReasonOutOfForm,
    CallUpReason.othersAhead => l.assistantReasonOthersAhead,
    // Without its places a cover reason says what the old chip said.
    CallUpReason.backup when positions.isEmpty => l.assistantReasonLineCover,
    CallUpReason.backup => l.assistantReasonBackup(at(0)),
    CallUpReason.covers when positions.length >= 3 =>
      l.assistantReasonCoversThree(at(0), at(1), at(2)),
    CallUpReason.covers when positions.length == 2 =>
      l.assistantReasonCoversTwo(at(0), at(1)),
    CallUpReason.covers => l.assistantReasonTopPick,
    CallUpReason.forChange when formation == null || positions.isEmpty =>
      l.assistantReasonTopPick,
    CallUpReason.forChange => l.assistantReasonForChange(
      formation!.label,
      at(0),
    ),
  };
}

/// The title of a proposal card.
String callUpVariantLabel(AppLocalizations l, CallUpProposal p) =>
    switch (p.variant) {
      CallUpVariant.main => l.assistantVariantMain,
      CallUpVariant.inForm => l.assistantVariantForm,
      CallUpVariant.fresherLegs => l.assistantVariantFresh,
      CallUpVariant.youth => l.assistantVariantYouth,
      CallUpVariant.experience => l.assistantVariantExperience,
      CallUpVariant.tacticsChange => l.assistantVariantTacticsChange(
        p.formation?.label ?? '',
      ),
    };

/// What this man reads, under the sheet's title, so a basic assistant's
/// advice is taken as what it is.
String assistantReadLabel(AppLocalizations l, StaffTier tier) => switch (tier) {
  StaffTier.none || StaffTier.basic => l.assistantReadBasic,
  StaffTier.good => l.assistantReadGood,
  StaffTier.elite => l.assistantReadElite,
};

/// "Ask the assistant": a full-width button, disabled with a note pointing
/// to the staff room while nobody is in the job.
class AskAssistantButton extends StatelessWidget {
  const AskAssistantButton({
    required this.tier,
    required this.onPressed,
    this.noteBeside = false,
    super.key,
  });

  final StaffTier tier;
  final VoidCallback? onPressed;

  /// Sets the note beside the disabled button rather than under it, so a
  /// phone's call-up header keeps its height for the pool below.
  final bool noteBeside;

  /// What an outlined icon button adds around its label: the icon, the gap
  /// and the padding either side.
  static const double _buttonChrome = 16 + 8 + 16 + 24 + 4;

  /// The most of the row the button may take with the note beside it.
  static const double _besideShare = 0.6;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final none = tier == StaffTier.none;
    final button = OutlinedButton.icon(
      key: CallUpAdviceKeys.ask,
      onPressed: none ? null : onPressed,
      icon: const Icon(Icons.record_voice_over_outlined, size: 16),
      label: WholeText(l.assistantAsk),
    );
    if (!none) return button;
    // A sentence: plain wrapping, so it breaks between words.
    final note = Text(
      l.assistantNoneNote,
      style: AppTypography.labelSmall.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
    );
    final stacked = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        button,
        const SizedBox(height: AppSpacing.xs),
        note,
      ],
    );
    if (!noteBeside) return stacked;
    // Beside only while the button, at its natural width, leaves the note a
    // fair share of the row: a long language, or large text, gets the full
    // width and the note under it, rather than a label broken inside a word.
    return LayoutBuilder(
      builder: (context, box) {
        final painter = TextPainter(
          text: TextSpan(
            text: l.assistantAsk,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
          maxLines: 1,
        )..layout();
        // The icon, its gap and the button's own padding.
        final needs = painter.width + _buttonChrome;
        painter.dispose();
        if (needs > box.maxWidth * _besideShare) return stacked;
        return Row(
          children: [
            SizedBox(width: needs, child: button),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: note),
          ],
        );
      },
    );
  }
}

/// What a proposal is compared with on its card.
enum CallUpAdviceBase {
  /// The squad being named on the screen right now.
  selection,

  /// Nothing is named yet: the squad named last time.
  lastSquad,

  /// Nothing to compare with: the card lists everyone he would name.
  none,
}

/// Shows his squad and alternatives; returns the one the manager chose to
/// apply, or null when he closed it.
Future<CallUpProposal?> showCallUpAdviceSheet(
  BuildContext context, {
  required CallUpAdviceSet advice,
  required StaffTier tier,
  required Map<int, Player> byId,
  required Set<int> base,
  required CallUpAdviceBase baseKind,
  Map<int, PlayerAbsence> absences = const {},
  Map<int, PlayerCondition> condition = const {},
  bool? opponentsStronger,
}) => showAdaptiveSheet<CallUpProposal>(
  context: context,
  backgroundColor: AppColors.surfaceContainerHigh,
  isScrollControlled: true,
  builder: (_) => _CallUpAdviceSheet(
    advice: advice,
    tier: tier,
    byId: byId,
    base: base,
    baseKind: baseKind,
    absences: absences,
    condition: condition,
    opponentsStronger: opponentsStronger,
  ),
);

class _CallUpAdviceSheet extends StatefulWidget {
  const _CallUpAdviceSheet({
    required this.advice,
    required this.tier,
    required this.byId,
    required this.base,
    required this.baseKind,
    required this.absences,
    required this.condition,
    required this.opponentsStronger,
  });

  final CallUpAdviceSet advice;
  final StaffTier tier;
  final Map<int, Player> byId;
  final Set<int> base;
  final CallUpAdviceBase baseKind;
  final Map<int, PlayerAbsence> absences;
  final Map<int, PlayerCondition> condition;
  final bool? opponentsStronger;

  @override
  State<_CallUpAdviceSheet> createState() => _CallUpAdviceSheetState();
}

class _CallUpAdviceSheetState extends State<_CallUpAdviceSheet> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final proposals = [widget.advice.main, ...widget.advice.alternatives];
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;
    return ConstrainedBox(
      key: CallUpAdviceKeys.sheet,
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.marginMobile,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: const BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: AppRadii.smAll,
                  ),
                ),
              ),
              WholeText(
                l.assistantSheetTitle,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              WholeText(
                assistantReadLabel(l, widget.tier),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Flexible(
                // A column, not a lazy list: three cards at most, and every
                // one of them is there to be compared.
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < proposals.length; i++) ...[
                        _ProposalCard(
                          key: CallUpAdviceKeys.proposal(i),
                          proposal: proposals[i],
                          selected: i == _selected,
                          onTap: () => setState(() => _selected = i),
                          tier: widget.tier,
                          byId: widget.byId,
                          base: widget.base,
                          baseKind: widget.baseKind,
                          absences: widget.absences,
                          condition: widget.condition,
                          // The elite man's read of the opponents decides the
                          // alternative he leads with, and says so on it.
                          note:
                              widget.tier == StaffTier.elite &&
                                  widget.opponentsStronger != null &&
                                  i == 1 &&
                                  (proposals[i].variant ==
                                          CallUpVariant.experience ||
                                      proposals[i].variant ==
                                          CallUpVariant.youth)
                              ? (widget.opponentsStronger!
                                    ? l.assistantVsStronger
                                    : l.assistantVsWeaker)
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        key: CallUpAdviceKeys.close,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: WholeText(l.assistantClose, maxLines: 1),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: FilledButton(
                        key: CallUpAdviceKeys.apply,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onPressed: () =>
                            Navigator.of(context).pop(proposals[_selected]),
                        child: WholeText(l.assistantApply, maxLines: 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One selectable squad: who comes in and who goes out against [base].
class _ProposalCard extends StatelessWidget {
  const _ProposalCard({
    required this.proposal,
    required this.selected,
    required this.onTap,
    required this.tier,
    required this.byId,
    required this.base,
    required this.baseKind,
    required this.absences,
    required this.condition,
    required this.note,
    super.key,
  });

  final CallUpProposal proposal;
  final bool selected;
  final VoidCallback onTap;
  final StaffTier tier;
  final Map<int, Player> byId;
  final Set<int> base;
  final CallUpAdviceBase baseKind;
  final Map<int, PlayerAbsence> absences;
  final Map<int, PlayerCondition> condition;
  final String? note;

  /// Line first, then the stronger man, so a list reads like a squad sheet.
  List<Player> _sorted(Iterable<int> ids) =>
      [
        for (final id in ids) ?byId[id],
      ]..sort((a, b) {
        final byLine = a.position.category.index.compareTo(
          b.position.category.index,
        );
        if (byLine != 0) return byLine;
        final byOverall = b.overall.compareTo(a.overall);
        return byOverall != 0 ? byOverall : a.id.compareTo(b.id);
      });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final meta = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    final ins = _sorted(proposal.squad.where((id) => !base.contains(id)));
    final outs = _sorted(base.where((id) => !proposal.squad.contains(id)));
    final against = switch (baseKind) {
      CallUpAdviceBase.selection => l.assistantVsSelection,
      CallUpAdviceBase.lastSquad => l.assistantVsLastSquad,
      CallUpAdviceBase.none => null,
    };
    return Material(
      color: selected
          ? AppColors.surfaceContainerHighest
          : AppColors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.baseAll,
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.outlineVariant,
          width: selected ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    size: 18,
                    color: selected
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WholeText(
                          callUpVariantLabel(l, proposal),
                          style: AppTypography.titleMedium,
                        ),
                        if (against != null) WholeText(against, style: meta),
                        if (note != null) WholeText(note!, style: meta),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              if (ins.isEmpty && outs.isEmpty)
                WholeText(l.assistantSameSquad, style: meta),
              if (ins.isNotEmpty) ...[
                WholeText(l.assistantNamesIn(ins.length), style: meta),
                for (final p in ins)
                  _AdviceRow(
                    leading: const Icon(
                      Icons.arrow_upward,
                      size: 14,
                      color: AppColors.positive,
                    ),
                    code: p.position.label,
                    name: p.name,
                    rating: p.overall,
                    label: switch (proposal.reasons[p.id]) {
                      final r? => callUpReasonLabel(
                        l,
                        r,
                        positions: proposal.positions[p.id] ?? const [],
                        formation: proposal.formation,
                      ),
                      null => null,
                    },
                  ),
              ],
              if (outs.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                WholeText(l.assistantNamesOut(outs.length), style: meta),
                for (final p in outs)
                  _AdviceRow(
                    leading: const Icon(
                      Icons.arrow_downward,
                      size: 14,
                      color: AppColors.error,
                    ),
                    code: p.position.label,
                    name: p.name,
                    rating: p.overall,
                    label: callUpReasonLabel(
                      l,
                      CallUpAdvice.leftOutReason(
                        p,
                        tier: tier,
                        absences: absences,
                        condition: condition,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// An arrow, a position code, the rating, a name that wraps or shortens
/// before it overflows, and the reason chip.
class _AdviceRow extends StatelessWidget {
  const _AdviceRow({
    required this.code,
    required this.name,
    required this.rating,
    required this.label,
    required this.leading,
  });

  final String code;
  final String name;

  /// His overall, exactly as the call-up list prints it beside his name: the
  /// men on these lists are the manager's own, so it is never a scouted guess.
  final int rating;

  /// The reason chip's words, or none.
  final String? label;
  final Widget leading;

  /// The most of the row a chip may take beside the name before it moves
  /// under it instead: a name squeezed to a sliver is worse than a row that
  /// runs to two lines.
  static const double _chipShare = 0.45;

  static const double _leadWidth = 16;
  static const double _codeWidth = 30;
  static const TextStyle _nameStyle = AppTypography.bodySmall;
  static final TextStyle _ratingStyle = AppTypography.labelSmall.copyWith(
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    final codeText = SizedBox(
      width: _codeWidth,
      child: Text(
        nationCodeLabel(code),
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
    final nameText = WholeText(
      name,
      shortText: initialledName(name),
      style: _nameStyle,
    );
    final lead = SizedBox(
      width: _leadWidth,
      child: Align(alignment: Alignment.centerLeft, child: leading),
    );
    // A slot as wide as the widest rating at the reader's text size, so the
    // names line up down the list whatever the numbers are.
    final ratingWidth = _naturalWidth(context, '99', _ratingStyle) + 6;
    final ratingText = SizedBox(
      width: ratingWidth,
      child: Text('$rating', style: _ratingStyle),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (label == null) {
            return Row(
              children: [
                lead,
                codeText,
                ratingText,
                Expanded(child: nameText),
              ],
            );
          }
          // The chip at its natural width, never scaled: measured with the
          // reader's own text size so a large-text phone is measured as it
          // will draw.
          final natural = _ReasonChip.naturalWidth(context, label);
          // Beside the name only while the name still has room to read
          // whole on its two lines; otherwise the chip goes under it.
          final nameRoom =
              constraints.maxWidth -
              _leadWidth -
              _codeWidth -
              ratingWidth -
              4 -
              natural;
          final nameNeeds =
              _naturalWidth(context, initialledName(name), _nameStyle) / 2;
          if (natural <= constraints.maxWidth * _chipShare &&
              nameRoom >= nameNeeds) {
            return Row(
              children: [
                lead,
                codeText,
                ratingText,
                Expanded(child: nameText),
                const SizedBox(width: AppSpacing.xs),
                _ReasonChip(label),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              lead,
              codeText,
              ratingText,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    nameText,
                    const SizedBox(height: 2),
                    _ReasonChip(label),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReasonChip extends StatelessWidget {
  const _ReasonChip(this.label);

  final String label;

  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 2,
  );

  static const TextStyle _style = AppTypography.labelSmall;

  /// The width the chip needs to draw [label] on one line at full size.
  static double naturalWidth(BuildContext context, String label) =>
      _naturalWidth(context, label, _style) + _padding.horizontal + 2;

  @override
  Widget build(BuildContext context) => Container(
    padding: _padding,
    decoration: BoxDecoration(
      color: AppColors.surfaceContainerLow,
      borderRadius: AppRadii.smAll,
      border: Border.all(color: AppColors.outlineVariant),
    ),
    child: WholeText(label, style: _style),
  );
}

/// The width [text] takes on one line in [style] at the reader's text size.
double _naturalWidth(BuildContext context, String text, TextStyle style) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
    maxLines: 1,
  )..layout();
  final width = painter.width;
  painter.dispose();
  return width;
}
