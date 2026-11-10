import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/routing/back_navigation.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/features/world_managers/manager_row.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'manager_detail_tablet_layout.dart';

/// Opens a world manager's page (see [ManagerDetailScreen]).
///
/// From inside a sheet or dialog, close it BEFORE calling this, or the page
/// lands underneath.
void openWorldManager(
  BuildContext context, {
  required int careerId,
  required int managerId,
}) {
  unawaited(
    context.push(
      '${Routes.worldManager}?careerId=$careerId&managerId=$managerId',
    ),
  );
}

/// The background a manager came from, in words.
String managerOriginText(AppLocalizations l, ManagerOrigin o) => switch (o) {
  ManagerOrigin.fresh => l.mgrOriginFresh,
  ManagerOrigin.exPlayer => l.mgrTieFormerPlayer,
  ManagerOrigin.exAssistant => l.mgrOriginExAssistant,
};

/// One world manager's page, the counterpart of the player's: who he is and
/// where he works now, his record over every national team job, how your
/// sides have fared against him, and his career, spell by spell, with how
/// each one ended.
///
/// Everything is derived on read from the stored spells
/// ([managerDetailProvider]); nothing new is persisted.
class ManagerDetailScreen extends ConsumerWidget {
  const ManagerDetailScreen({
    required this.careerId,
    required this.managerId,
    super.key,
  });

  final int careerId;
  final int managerId;

  static const Key tabletLayoutKey = Key('managerDetail.tabletLayout');
  static const Key profileKey = Key('managerDetail.profile');
  static const Key careerKey = Key('managerDetail.career');
  static const Key spellRowKey = Key('managerDetail.spell');
  static const Key recordKey = Key('managerDetail.record');
  static const Key vsYouKey = Key('managerDetail.vsYou');
  static const Key tieKey = Key('managerDetail.tie');

  /// Back to the screen that opened him; opened by a link with nothing
  /// beneath, the parent the system back button would pick.
  static void leave(BuildContext context, int careerId) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    final uri = GoRouterState.of(context).uri;
    context.go(switch (systemBackAction(uri)) {
      GoBackTo(:final location) => location,
      _ => '${Routes.managers}?careerId=$careerId',
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (TabletShellScope.isActive(context)) {
      return _ManagerDetailTabletLayout(
        careerId: careerId,
        managerId: managerId,
      );
    }
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => leave(context, careerId),
        ),
        title: Text(
          l.mgrRowLabel.capsIn(l.localeName),
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: _ManagerDetailBody(
        careerId: careerId,
        managerId: managerId,
        builder: (context, sections) => ListView(
          key: profileKey,
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          children: [...sections.profile, ...sections.career],
        ),
      ),
    );
  }
}

/// The page's two runs: `profile` (who he is, his record, you and him) and
/// `career` (every spell). One column on a phone, side by side on a tablet.
typedef _Sections = ({List<Widget> profile, List<Widget> career});

/// Loads the page and hands its sections to [builder]; the loading, error
/// and not-found states are the same in both layouts.
class _ManagerDetailBody extends ConsumerWidget {
  const _ManagerDetailBody({
    required this.careerId,
    required this.managerId,
    required this.builder,
  });

  final int careerId;
  final int managerId;
  final Widget Function(BuildContext, _Sections) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(
      managerDetailProvider((careerId: careerId, managerId: managerId)),
    );
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l.commonSomethingWentWrong)),
      data: (d) {
        if (d == null) return Center(child: Text(l.mgrDetailNotFound));
        final nations =
            ref.watch(managerNationsProvider(careerId)).valueOrNull ??
            const <int, Nation>{};
        return builder(context, _sections(context, d, nations));
      },
    );
  }
}

_Sections _sections(
  BuildContext context,
  ManagerDetail d,
  Map<int, Nation> nations,
) {
  final l = AppLocalizations.of(context);
  final p = d.profile;
  final m = p.m;
  var won = 0;
  var drawn = 0;
  var lost = 0;
  var trophies = 0;
  for (final s in d.spells) {
    won += s.won;
    drawn += s.drawn;
    lost += s.lost;
    trophies += s.trophies;
  }
  final matches = won + drawn + lost;
  final current = d.spells.where((s) => s.spell.current).firstOrNull;
  final job = current != null
      ? l.mgrDetailCurrentJob(nations[current.spell.nationId]?.name ?? '')
      : m.retiredAt != null
      ? l.mgrEndRetired
      : l.mgrDetailFree;
  final led = {for (final s in d.spells) s.spell.nationId}.length;
  final label = AppTypography.labelSmall.copyWith(color: AppColors.primary);
  final muted = AppTypography.bodyMedium.copyWith(
    color: AppColors.onSurfaceVariant,
  );
  final r = p.relation;

  return (
    profile: [
      AppCard(
        child: Column(
          children: [
            Row(
              children: [
                // His reputation where a player's card has his rating: the
                // one number that says how big a name he is.
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.10),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: Text(
                    '${p.reputation}',
                    style: AppTypography.headlineLargeMobile.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name, style: AppTypography.headlineMedium),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          FlagDisc(m.nationality, size: 18),
                          const SizedBox(width: AppSpacing.xs),
                          Flexible(
                            child: Text(
                              d.homeland?.name ?? m.nationality,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _HeadlineStat(value: '${p.age}', label: l.mgrProfileAge),
                _HeadlineStat(value: '$matches', label: l.mgrDetailMatches),
                _HeadlineStat(
                  value: matches == 0
                      ? '-'
                      : '${(won * 100 / matches).round()}%',
                  label: l.mgrDetailWinRate,
                  accent: true,
                ),
                _HeadlineStat(value: '$trophies', label: l.mgrDetailTrophies),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      AppCard(
        key: ManagerDetailScreen.recordKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.mgrDetailRecord.capsIn(l.localeName), style: label),
            const SizedBox(height: AppSpacing.sm),
            Text(
              managerRecordText(l, won, drawn, lost),
              style: AppTypography.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.sm,
              children: [
                _Fact(l.mgrProfileReputation, '${p.reputation}'),
                _Fact(l.mgrDetailNationsLed, '$led'),
                _Fact(l.mgrProfileStyle, managerStyleText(l, m.style)),
                _Fact(l.mgrDetailBackground, managerOriginText(l, m.origin)),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      // [r] is read from the player's side (his wins are `won`); this page is
      // all from HIS side, so his record against you swaps wins and losses.
      AppCard(
        key: ManagerDetailScreen.vsYouKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.mgrProfileRecordVsYou.capsIn(l.localeName), style: label),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Text(
                    r.meetings == 0
                        ? l.mgrProfileNoMeetings
                        : managerRecordText(l, r.lost, r.drawn, r.won),
                    style: r.meetings == 0 ? muted : AppTypography.titleMedium,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                KeyedSubtree(
                  key: ManagerDetailScreen.tieKey,
                  child: TieChip(r.label),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
    career: [
      const SizedBox(height: AppSpacing.md),
      Text(
        l.mgrProfileSpells,
        style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
      ),
      const SizedBox(height: AppSpacing.sm),
      AppCard(
        key: ManagerDetailScreen.careerKey,
        padding: EdgeInsets.zero,
        child: d.spells.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(l.mgrDetailNoSpells, style: muted),
              )
            : Column(
                children: [
                  // Newest first: where he is now, then how he got here.
                  for (var i = 0; i < d.spells.length; i++)
                    _SpellRow(
                      record: d.spells[i],
                      nation: nations[d.spells[i].spell.nationId],
                      // The oldest spell is where he started, not a move.
                      isMove: i != d.spells.length - 1,
                    ),
                ],
              ),
      ),
    ],
  );
}

/// One spell of the career list: the years, the nation, its record under
/// him, how it ended and any titles won.
class _SpellRow extends StatelessWidget {
  const _SpellRow({
    required this.record,
    required this.nation,
    required this.isMove,
  });

  final ManagerSpellRecord record;
  final Nation? nation;
  final bool isMove;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = record.spell;
    final from = s.fromDate.year;
    final to = s.toDate?.year;
    final years = to == null
        ? '$from–'
        : from == to
        ? '$from'
        : '$from–$to';
    final end = s.endReason;
    final status = s.current
        ? l.mgrDetailInCharge
        : end == null
        ? ''
        : spellEndText(l, end);
    final statusColor = switch (end) {
      _ when s.current => AppColors.positive,
      SpellEnd.sacked => AppColors.error,
      _ => AppColors.onSurfaceVariant,
    };
    final muted = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return Padding(
      key: ManagerDetailScreen.spellRowKey,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            child: Tooltip(
              message: [
                AppDate.dayMonthYear(context, s.fromDate),
                if (s.toDate case final to?) AppDate.dayMonthYear(context, to),
              ].join(' - '),
              child: Text(years, style: muted),
            ),
          ),
          Icon(
            isMove ? Icons.east_rounded : Icons.circle,
            size: isMove ? 14 : 8,
            color: isMove
                ? AppColors.onSurfaceVariant
                : AppColors.outlineVariant,
          ),
          const SizedBox(width: AppSpacing.sm),
          if (nation != null) ...[
            FlagDisc(nation!.code, size: 18),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nation?.name ?? '',
                  style: AppTypography.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // A spell from before the save began has no fixtures to
                // count; a row of zeros would read as a man who never won.
                if (record.won + record.drawn + record.lost > 0)
                  Text(
                    managerRecordText(
                      l,
                      record.won,
                      record.drawn,
                      record.lost,
                    ),
                    style: muted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (status.isNotEmpty)
                  Text(
                    status,
                    style: AppTypography.labelSmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (record.trophies > 0) ...[
            const SizedBox(width: AppSpacing.sm),
            const Icon(
              Icons.emoji_events_rounded,
              size: 16,
              color: AppColors.primary,
            ),
            Text(
              '${record.trophies}',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// One of the four headline facts across the top of the card: the number
/// large, its name small underneath (as on the player's card).
class _HeadlineStat extends StatelessWidget {
  const _HeadlineStat({
    required this.value,
    required this.label,
    this.accent = false,
  });

  final String value;
  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            child: Text(
              value,
              maxLines: 1,
              style: AppTypography.headlineMedium.copyWith(
                color: accent ? AppColors.primary : AppColors.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.capsIn(Localizations.localeOf(context).languageCode),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      Text(value, style: AppTypography.titleMedium),
    ],
  );
}
