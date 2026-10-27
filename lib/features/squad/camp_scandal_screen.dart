import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/squad_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/squad/camp_scandal.dart';
import 'package:fnm/domain/services/squad/squad_selection.dart';
import 'package:fnm/features/squad/camp_scandal_providers.dart';
import 'package:fnm/features/tactics/nomination_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The words for a scandal's story, by kind.
String scandalStory(AppLocalizations l, ScandalKind kind, String player) =>
    switch (kind) {
      ScandalKind.party => l.scandalStoryParty(player),
      ScandalKind.curfew => l.scandalStoryCurfew(player),
      ScandalKind.nightclub => l.scandalStoryNightclub(player),
      ScandalKind.casino => l.scandalStoryCasino(player),
    };

/// A man in the squad that has just gathered is in the papers: send him home
/// (calling somebody up in his place, outside a finals) or keep him and pay
/// for it. Reached from the hub, which offers it until the manager answers
/// (see [pendingScandalProvider]); the injury-cover screen's shape.
class CampScandalScreen extends ConsumerStatefulWidget {
  const CampScandalScreen({required this.careerId, super.key});

  /// The tablet layout's scaffold, for tests.
  static const Key tabletLayoutKey = Key('campScandal.tabletLayout');

  /// The two answers, for tests.
  static const Key sendHomeKey = Key('campScandal.sendHome');
  static const Key keepKey = Key('campScandal.keep');

  final int careerId;

  @override
  ConsumerState<CampScandalScreen> createState() => _CampScandalScreenState();
}

class _CampScandalScreenState extends ConsumerState<CampScandalScreen> {
  int? _picked;
  bool _busy = false;

  static const int _minAge = PlayerLifecycle.callUpMinAge;

  Future<void> _answer(
    PendingScandal s, {
    required bool sendHome,
    int? replacement,
  }) async {
    setState(() => _busy = true);
    final container = ProviderScope.containerOf(context);
    final router = GoRouter.of(context);
    final id = widget.careerId;
    final service = container.read(campScandalServiceProvider);
    try {
      if (sendHome) {
        await service.sendHome(id, s, replacement: replacement);
      } else {
        await service.keep(id, s);
      }
    } finally {
      // A failed write must not leave both answers dead.
      if (mounted) setState(() => _busy = false);
    }
    if (router.state.uri.path == Routes.campScandal) {
      router.go('${Routes.hub}?careerId=$id');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final id = widget.careerId;
    final scandal = ref.watch(pendingScandalProvider(id));
    final squad = ref.watch(squadDataProvider(id));
    final window = ref.watch(nominationWindowProvider(id));
    final content = switch ((scandal, squad, window)) {
      (
        AsyncData(value: final s?),
        AsyncData(value: final q?),
        AsyncData(value: final w),
      ) =>
        _body(l, s, q, w.matches.length),
      // Answered meanwhile, or something could not be read: nothing to
      // decide here, so the way out is always on screen. (Leaving through
      // the hub without an answer counts as keeping him.)
      (AsyncData(value: null), _, _) ||
      (AsyncError(), _, _) ||
      (_, AsyncError(), _) ||
      (_, AsyncData(value: null), _) ||
      (_, _, AsyncError()) => Center(
        child: SizedBox(
          width: 320,
          child: PrimaryButton(
            label: l.federationContinue,
            icon: Icons.check_rounded,
            onPressed: () => context.go('${Routes.hub}?careerId=$id'),
          ),
        ),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
    if (TabletShellScope.isActive(context)) {
      return TabletPage(
        scaffoldKey: CampScandalScreen.tabletLayoutKey,
        title: l.scandalTitle,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: content,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.hub}?careerId=$id'),
        ),
        title: Text(l.scandalTitle, style: AppTypography.labelMedium),
        centerTitle: true,
      ),
      body: content,
    );
  }

  Widget _body(
    AppLocalizations l,
    PendingScandal s,
    SquadData squad,
    int coverage,
  ) {
    final candidates = s.finals
        ? const <Player>[]
        : ([
            for (final p in squad.pool)
              if (!squad.callUps.contains(p.id) &&
                  p.age >= _minAge &&
                  SquadSelection.usableInPeriod(squad.absences[p.id], coverage))
                p,
          ]..sort((a, b) => b.overall.compareTo(a.overall)));
    final picked = candidates.where((p) => p.id == _picked).firstOrNull;
    final him = squad.pool.where((p) => p.id == s.playerId).firstOrNull;
    final muted = AppTypography.bodySmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  if (him != null) ...[
                    _himTile(l, him),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scandalStory(l, s.kind, s.playerName),
                          style: AppTypography.bodyMedium,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(l.scandalKeepNote, style: muted),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          s.finals
                              ? l.scandalFinalsNote
                              : l.scandalSendHomeNote,
                          style: muted,
                        ),
                      ],
                    ),
                  ),
                  if (!s.finals && candidates.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l.scandalPickCover,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    for (final p in candidates) ...[
                      _row(p, samePosition: p.position == him?.position),
                      const SizedBox(height: AppSpacing.xs),
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              key: CampScandalScreen.sendHomeKey,
              label: picked == null
                  ? l.scandalSendHome
                  : l.scandalSendHomeCover(picked.name),
              icon: Icons.flight_takeoff_rounded,
              isLoading: _busy,
              onPressed: _busy
                  ? null
                  : () => unawaited(
                      _answer(s, sendHome: true, replacement: picked?.id),
                    ),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              key: CampScandalScreen.keepKey,
              onPressed: _busy
                  ? null
                  : () => unawaited(_answer(s, sendHome: false)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(
                l.scandalKeep(s.playerName),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The man in the papers, in the shape of a candidate row.
  Widget _himTile(AppLocalizations l, Player p) {
    const color = AppColors.warning;
    return Container(
      key: const Key('campScandal.himTile'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: AppRadii.baseAll,
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_bar_rounded, size: 20, color: color),
          const SizedBox(width: AppSpacing.md),
          SizedBox(width: 40, child: TacticalChip(p.position.label)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: AppTypography.bodyMedium),
                Text(
                  positionName(l, p.position),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('${p.overall}', style: AppTypography.labelLarge),
        ],
      ),
    );
  }

  Widget _row(Player p, {required bool samePosition}) {
    final selected = p.id == _picked;
    return Material(
      color: selected
          ? AppColors.surfaceContainerHigh
          : AppColors.surfaceContainer,
      borderRadius: AppRadii.baseAll,
      child: InkWell(
        borderRadius: AppRadii.baseAll,
        // A second tap clears the pick: the replacement is optional.
        onTap: _busy
            ? null
            : () => setState(() => _picked = selected ? null : p.id),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: TacticalChip(p.position.label, emphasized: samePosition),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  p.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMedium,
                ),
              ),
              Text(
                '${p.age}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text('${p.overall}', style: AppTypography.labelLarge),
              const SizedBox(width: AppSpacing.sm),
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: 20,
                color: selected ? AppColors.primary : AppColors.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
