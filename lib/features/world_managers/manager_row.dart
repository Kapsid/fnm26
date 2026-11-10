import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/world_managers/manager_relation.dart';
import 'package:fnm/features/world_managers/manager_detail_screen.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// How the player regards a manager, in words.
String tieLabelText(AppLocalizations l, TieLabel t) => switch (t) {
  TieLabel.neutral => l.mgrTieNeutral,
  TieLabel.respect => l.mgrTieRespect,
  TieLabel.rival => l.mgrTieRival,
  TieLabel.grudge => l.mgrTieGrudge,
  TieLabel.successor => l.mgrTieSuccessor,
  TieLabel.protege => l.mgrTieProtege,
  TieLabel.formerPlayer => l.mgrTieFormerPlayer,
};

/// Why a spell ended, in words.
String spellEndText(AppLocalizations l, SpellEnd e) => switch (e) {
  SpellEnd.sacked => l.mgrEndSacked,
  SpellEnd.resigned => l.mgrEndResigned,
  SpellEnd.poached => l.mgrEndPoached,
  SpellEnd.retired => l.mgrEndRetired,
  SpellEnd.contractEnd => l.mgrEndContractEnd,
  SpellEnd.replacedByPlayer => l.mgrEndReplacedByPlayer,
};

/// A manager's style (a `NationStyle` name), in words.
String managerStyleText(AppLocalizations l, String style) => switch (style) {
  'possession' => l.mgrStylePossession,
  'highPress' => l.mgrStyleHighPress,
  'defensive' => l.mgrStyleDefensive,
  'direct' => l.mgrStyleDirect,
  'counter' => l.mgrStyleCounter,
  'flair' => l.mgrStyleFlair,
  'physical' => l.mgrStylePhysical,
  _ => l.mgrStyleBalanced,
};

/// A record as "3 W, 1 D, 2 L".
String managerRecordText(AppLocalizations l, int won, int drawn, int lost) =>
    l.mgrRecordWdl(won, drawn, lost);

/// The small tag naming the tie between the player and a manager.
class TieChip extends StatelessWidget {
  const TieChip(this.label, {super.key});

  final TieLabel label;

  @override
  Widget build(BuildContext context) {
    final color = switch (label) {
      TieLabel.rival || TieLabel.grudge => AppColors.error,
      TieLabel.respect ||
      TieLabel.protege ||
      TieLabel.formerPlayer => AppColors.positive,
      _ => AppColors.onSurfaceVariant,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadii.smAll,
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        tieLabelText(AppLocalizations.of(context), label),
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// The nation page's manager line: flag, name, age, when he took charge and
/// the nation's record under him. Watches its own provider, so the card's
/// "now" block is untouched; a tap opens his profile.
class ManagerRow extends ConsumerWidget {
  const ManagerRow({required this.careerId, required this.nationId, super.key});

  final int careerId;
  final int nationId;

  static const Key rowKey = Key('managerRow.row');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref
        .watch(nationManagerProvider((careerId: careerId, nationId: nationId)))
        .valueOrNull;
    if (view == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    return InkWell(
      key: rowKey,
      onTap: () => openWorldManager(
        context,
        careerId: careerId,
        managerId: view.m.managerId,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FlagDisc(view.m.nationality, size: 24),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  view.m.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMedium,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.onSurfaceVariant,
              ),
            ],
          ),
          Text(
            l.mgrRowDetail(
              view.age,
              AppDate.dayMonthYear(context, view.spell.fromDate),
            ),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(
            l.mgrRowRecord(
              managerRecordText(l, view.won, view.drawn, view.lost),
            ),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// The match preview's one line: the opposing manager and, when there is
/// something between you, the tie. Nothing when nobody is in charge on the
/// fixture's day.
class OpponentManagerLine extends ConsumerWidget {
  const OpponentManagerLine({
    required this.careerId,
    required this.nationId,
    required this.date,
    super.key,
  });

  final int careerId;
  final int nationId;
  final DateTime date;

  static const Key lineKey = Key('opponentManager.line');
  static const Key chipKey = Key('opponentManager.tie');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref
        .watch(
          opponentManagerProvider(
            (careerId: careerId, nationId: nationId, date: date),
          ),
        )
        .valueOrNull;
    if (view == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final tie = ref
        .watch(
          managerRelationProvider(
            (careerId: careerId, managerId: view.m.managerId),
          ),
        )
        .valueOrNull
        ?.label;
    return Padding(
      key: lineKey,
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      // A tap opens his page, as his name does everywhere else.
      child: InkWell(
        onTap: () => openWorldManager(
          context,
          careerId: careerId,
          managerId: view.m.managerId,
        ),
        child: Row(
          children: [
            Flexible(
              child: Text(
                l.mgrPreviewLine(view.m.name),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelMedium,
              ),
            ),
            if (tie != null && tie != TieLabel.neutral) ...[
              const SizedBox(width: AppSpacing.sm),
              TieChip(tie, key: chipKey),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// The dossier's manager lines: his style, and your record against him.
class OpponentManagerDossier extends ConsumerWidget {
  const OpponentManagerDossier({
    required this.careerId,
    required this.nationId,
    required this.date,
    super.key,
  });

  final int careerId;
  final int nationId;
  final DateTime date;

  static const Key styleKey = Key('opponentManager.style');
  static const Key recordKey = Key('opponentManager.record');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref
        .watch(
          opponentManagerProvider(
            (careerId: careerId, nationId: nationId, date: date),
          ),
        )
        .valueOrNull;
    if (view == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final rel = ref
        .watch(
          managerRelationProvider(
            (careerId: careerId, managerId: view.m.managerId),
          ),
        )
        .valueOrNull;
    const style = AppTypography.bodyMedium;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.mgrDossierStyle(managerStyleText(l, view.m.style)),
            key: styleKey,
            style: style,
          ),
          if (rel != null && rel.meetings > 0)
            Text(
              l.mgrDossierRecord(
                managerRecordText(l, rel.won, rel.drawn, rel.lost),
              ),
              key: recordKey,
              style: style,
            ),
        ],
      ),
    );
  }
}
