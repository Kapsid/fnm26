import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/tactics/assistant_advice.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tactics/assistant_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/adaptive_sheet.dart';
import 'package:fnm/shared/widgets/whole_text.dart';

/// Keys the tests find the advice by.
abstract final class AssistantAdviceKeys {
  static const Key ask = Key('assistant.ask');
  static const Key sheet = Key('assistant.sheet');
  static const Key apply = Key('assistant.apply');
  static const Key close = Key('assistant.close');
  static Key proposal(int index) => Key('assistant.proposal.$index');
  static Key sub(int index) => Key('assistant.sub.$index');
}

/// The short words on a reason chip.
String adviceReasonLabel(AppLocalizations l, AdviceReason r) => switch (r) {
  AdviceReason.bestFit => l.assistantReasonBestFit,
  AdviceReason.inForm => l.assistantReasonInForm,
  AdviceReason.fresh => l.assistantReasonFresh,
  AdviceReason.covering => l.assistantReasonCovering,
  AdviceReason.coverDefence => l.assistantReasonCoverDefence,
  AdviceReason.coverMidfield => l.assistantReasonCoverMidfield,
  AdviceReason.coverAttack => l.assistantReasonCoverAttack,
  AdviceReason.tired => l.assistantReasonTired,
  AdviceReason.booked => l.assistantReasonBooked,
  AdviceReason.injured => l.assistantReasonInjured,
  AdviceReason.outOfPosition => l.assistantReasonOutOfPosition,
  AdviceReason.chasing => l.assistantReasonChasing,
};

/// The title of a proposal card.
String adviceVariantLabel(AppLocalizations l, AdviceVariant v) => switch (v) {
  AdviceVariant.main => l.assistantVariantMain,
  AdviceVariant.fresherLegs => l.assistantVariantFresh,
  AdviceVariant.inForm => l.assistantVariantForm,
  AdviceVariant.attacking => l.assistantVariantAttacking,
  AdviceVariant.solid => l.assistantVariantSolid,
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
    super.key,
  });

  final StaffTier tier;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final none = tier == StaffTier.none;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          key: AssistantAdviceKeys.ask,
          onPressed: none ? null : onPressed,
          icon: const Icon(Icons.record_voice_over_outlined, size: 18),
          label: WholeText(l.assistantAsk, maxLines: 1),
        ),
        if (none) ...[
          const SizedBox(height: AppSpacing.xs),
          // A sentence: plain wrapping, so it breaks between words ("staff
          // r/oom" was WholeText breaking inside one).
          Text(
            l.assistantNoneNote,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// Shows his lineup proposal and alternatives; returns the one the manager
/// chose to apply, or null when he closed it.
Future<LineupAdvice?> showLineupAdviceSheet(
  BuildContext context, {
  required PreMatchAdvice advice,
  required StaffTier tier,
  required List<PlayerPosition> places,
  required Map<int, Player> byId,
  required List<int?> current,
  bool? opponentStronger,
}) => showAdaptiveSheet<LineupAdvice>(
  context: context,
  backgroundColor: AppColors.surfaceContainerHigh,
  isScrollControlled: true,
  builder: (_) => _LineupAdviceSheet(
    advice: advice,
    tier: tier,
    places: places,
    byId: byId,
    current: current,
    opponentStronger: opponentStronger,
  ),
);

/// Shows the changes he would make; returns the ones the manager kept ticked
/// and applied, or null when he closed it.
Future<List<SubAdvice>?> showSubAdviceSheet(
  BuildContext context, {
  required List<SubAdvice> subs,
  required StaffTier tier,
  required Map<int, Player> byId,
}) => showAdaptiveSheet<List<SubAdvice>>(
  context: context,
  backgroundColor: AppColors.surfaceContainerHigh,
  isScrollControlled: true,
  builder: (_) => _SubAdviceSheet(subs: subs, tier: tier, byId: byId),
);

/// The frame both sheets share: a handle, the title and what he reads, a
/// scrolling body capped at most of the screen, and Close / Apply.
class _AdviceFrame extends StatelessWidget {
  const _AdviceFrame({
    required this.tier,
    required this.title,
    required this.children,
    required this.onApply,
  });

  final StaffTier tier;
  final String title;
  final List<Widget> children;
  final VoidCallback? onApply;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;
    return ConstrainedBox(
      key: AssistantAdviceKeys.sheet,
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
                title,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              WholeText(
                assistantReadLabel(l, tier),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: children,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        key: AssistantAdviceKeys.close,
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
                        key: AssistantAdviceKeys.apply,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onPressed: onApply,
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

class _LineupAdviceSheet extends StatefulWidget {
  const _LineupAdviceSheet({
    required this.advice,
    required this.tier,
    required this.places,
    required this.byId,
    required this.current,
    required this.opponentStronger,
  });

  final PreMatchAdvice advice;
  final StaffTier tier;
  final List<PlayerPosition> places;
  final Map<int, Player> byId;
  final List<int?> current;
  final bool? opponentStronger;

  @override
  State<_LineupAdviceSheet> createState() => _LineupAdviceSheetState();
}

class _LineupAdviceSheetState extends State<_LineupAdviceSheet> {
  int _selected = 0;

  List<LineupAdvice> get _proposals => [
    widget.advice.main,
    ...widget.advice.alternatives,
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final proposals = _proposals;
    final main = widget.advice.main;
    return _AdviceFrame(
      tier: widget.tier,
      title: l.assistantSheetTitle,
      onApply: () => Navigator.of(context).pop(proposals[_selected]),
      children: [
        for (var i = 0; i < proposals.length; i++) ...[
          _ProposalCard(
            key: AssistantAdviceKeys.proposal(i),
            proposal: proposals[i],
            selected: i == _selected,
            onTap: () => setState(() => _selected = i),
            // His pick in full; an alternative only where it differs, so
            // the cards say what the choice actually is.
            slots: [
              for (var s = 0; s < proposals[i].lineup.length; s++)
                if (i == 0 || proposals[i].lineup[s] != main.lineup[s]) s,
            ],
            showBench: i == 0 || !_sameBench(proposals[i].bench, main.bench),
            places: widget.places,
            byId: widget.byId,
            changes: proposals[i].newMenAgainst(widget.current),
            // The elite man's opponent read decides the alternative he leads
            // with, and says so on that card.
            note:
                widget.tier == StaffTier.elite &&
                    widget.opponentStronger != null &&
                    i == 1 &&
                    (proposals[i].variant == AdviceVariant.solid ||
                        proposals[i].variant == AdviceVariant.attacking)
                ? (widget.opponentStronger!
                      ? l.assistantVsStronger
                      : l.assistantVsWeaker)
                : null,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }

  static bool _sameBench(
    List<({int playerId, AdviceReason reason})> a,
    List<({int playerId, AdviceReason reason})> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].playerId != b[i].playerId) return false;
    }
    return true;
  }
}

/// One selectable proposal.
class _ProposalCard extends StatelessWidget {
  const _ProposalCard({
    required this.proposal,
    required this.selected,
    required this.onTap,
    required this.slots,
    required this.showBench,
    required this.places,
    required this.byId,
    required this.changes,
    required this.note,
    super.key,
  });

  final LineupAdvice proposal;
  final bool selected;
  final VoidCallback onTap;
  final List<int> slots;
  final bool showBench;
  final List<PlayerPosition> places;
  final Map<int, Player> byId;
  final int changes;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final meta = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
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
                          adviceVariantLabel(l, proposal.variant),
                          style: AppTypography.titleMedium,
                        ),
                        WholeText(l.assistantChanges(changes), style: meta),
                        if (note != null) WholeText(note!, style: meta),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              for (final s in slots)
                _AdviceRow(
                  code: places[s].label,
                  name: byId[proposal.lineup[s]]?.name ?? '',
                  reason: proposal.reasons[s],
                ),
              if (showBench && proposal.bench.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                WholeText(l.assistantBench, style: meta, maxLines: 1),
                for (final b in proposal.bench)
                  _AdviceRow(
                    code: byId[b.playerId]?.position.label ?? '',
                    name: byId[b.playerId]?.name ?? '',
                    reason: b.reason,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A place code, a name that wraps or shortens before it overflows, and the
/// reason chip.
class _AdviceRow extends StatelessWidget {
  const _AdviceRow({
    required this.code,
    required this.name,
    required this.reason,
    this.leading,
  });

  final String code;
  final String name;
  final AdviceReason? reason;
  final Widget? leading;

  /// The most of the row a chip may take beside the name before it moves
  /// under it instead: a name squeezed to a sliver is worse than a row that
  /// runs to two lines.
  static const double _chipShare = 0.45;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final label = reason == null ? null : adviceReasonLabel(l, reason!);
    final codeText = SizedBox(
      width: 30,
      child: Text(
        code,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
    final nameText = WholeText(
      name,
      shortText: initialledName(name),
      style: AppTypography.bodySmall,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (label == null) {
            return Row(
              children: [
                ?leading,
                codeText,
                Expanded(child: nameText),
              ],
            );
          }
          // The chip at its natural width, never scaled: measured with the
          // reader's own text size so a large-text phone is measured as it
          // will draw.
          final natural = _ReasonChip.naturalWidth(context, label);
          final beside = natural <= constraints.maxWidth * _chipShare;
          if (beside) {
            return Row(
              children: [
                ?leading,
                codeText,
                Expanded(child: nameText),
                const SizedBox(width: AppSpacing.xs),
                _ReasonChip(label),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ?leading,
              codeText,
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
  static double naturalWidth(BuildContext context, String label) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: _style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    final width = painter.width + _padding.horizontal + 2;
    painter.dispose();
    return width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadii.smAll,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: WholeText(label, style: _style),
    );
  }
}

class _SubAdviceSheet extends StatefulWidget {
  const _SubAdviceSheet({
    required this.subs,
    required this.tier,
    required this.byId,
  });

  final List<SubAdvice> subs;
  final StaffTier tier;
  final Map<int, Player> byId;

  @override
  State<_SubAdviceSheet> createState() => _SubAdviceSheetState();
}

class _SubAdviceSheetState extends State<_SubAdviceSheet> {
  /// Every change starts ticked; the manager unticks the ones he disagrees
  /// with rather than having to pick each one.
  late final Set<int> _kept = {
    for (var i = 0; i < widget.subs.length; i++) i,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final subs = widget.subs;
    return _AdviceFrame(
      tier: widget.tier,
      title: l.assistantSubsTitle,
      onApply: _kept.isEmpty
          ? null
          : () => Navigator.of(context).pop([
              for (var i = 0; i < subs.length; i++)
                if (_kept.contains(i)) subs[i],
            ]),
      children: [
        if (subs.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: WholeText(l.assistantNoSubs, style: AppTypography.bodySmall),
          ),
        for (var i = 0; i < subs.length; i++)
          InkWell(
            key: AssistantAdviceKeys.sub(i),
            onTap: () => setState(() {
              if (!_kept.remove(i)) _kept.add(i);
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Checkbox(
                    value: _kept.contains(i),
                    visualDensity: VisualDensity.compact,
                    onChanged: (_) => setState(() {
                      if (!_kept.remove(i)) _kept.add(i);
                    }),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _AdviceRow(
                          leading: const Icon(
                            Icons.arrow_downward,
                            size: 14,
                            color: AppColors.error,
                          ),
                          code:
                              widget.byId[subs[i].offId]?.position.label ?? '',
                          name: widget.byId[subs[i].offId]?.name ?? '',
                          reason: subs[i].reason,
                        ),
                        _AdviceRow(
                          leading: const Icon(
                            Icons.arrow_upward,
                            size: 14,
                            color: AppColors.positive,
                          ),
                          code: widget.byId[subs[i].onId]?.position.label ?? '',
                          name: widget.byId[subs[i].onId]?.name ?? '',
                          reason: null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// The tactics screen's "Ask the assistant": opens his proposal for the side
/// as it stands and, on Apply, puts the chosen eleven in through
/// [TacticService.setLineup].
///
/// Watches [lineupAdviceProvider] so the proposal is worked out before the
/// tap, and is never a snapshot of a squad from before the last change.
class LineupAssistantButton extends ConsumerWidget {
  const LineupAssistantButton({
    required this.careerId,
    required this.data,
    super.key,
  });

  final int careerId;
  final TacticData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tier =
        ref.watch(careerByIdProvider(careerId)).valueOrNull?.staffAssistant ??
        StaffTier.none;
    return AskAssistantButton(
      tier: tier,
      onPressed: () async {
        // Read fresh on the tap, held open only while it is worked out: the
        // squad, its condition and the opponent as they stand right now.
        final container = ProviderScope.containerOf(context, listen: false);
        final sub = container.listen(
          lineupAdviceProvider(careerId).future,
          (_, _) {},
        );
        LineupAdviceRead? read;
        try {
          read = await sub.read();
        } on Object {
          read = null;
        } finally {
          sub.close();
        }
        final advice = read?.advice;
        if (advice == null || !context.mounted) return;
        final chosen = await showLineupAdviceSheet(
          context,
          advice: advice,
          tier: read!.tier,
          places: data.tactic.positions,
          byId: data.byId,
          current: data.tactic.lineup,
          opponentStronger: read.opponentStronger,
        );
        if (chosen == null) return;
        await ref
            .read(tacticServiceProvider)
            .setLineup(careerId, chosen.lineup);
      },
    );
  }
}
