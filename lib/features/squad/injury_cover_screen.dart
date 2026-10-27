import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/squad_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/squad/squad_selection.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/squad/injury_cover_providers.dart';
import 'package:fnm/features/tactics/nomination_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// A squad player was hurt earlier in the window: call anyone up in his place,
/// in any position, or keep him and play on. Reached from the hub, which
/// offers it until the manager answers (see [pendingInjuryCoverProvider]).
class InjuryCoverScreen extends ConsumerStatefulWidget {
  const InjuryCoverScreen({required this.careerId, super.key});

  /// The tablet layout's scaffold, for tests.
  static const Key tabletLayoutKey = Key('injuryCover.tabletLayout');

  final int careerId;

  @override
  ConsumerState<InjuryCoverScreen> createState() => _InjuryCoverScreenState();
}

class _InjuryCoverScreenState extends ConsumerState<InjuryCoverScreen> {
  int? _picked;
  bool _busy = false;

  /// Youngest a player may be to be brought in: the call-up floor, the same as
  /// the call-up screen's, since a called-up U-17 can be fielded.
  static const int _minAge = PlayerLifecycle.callUpMinAge;

  Future<void> _answer(InjuryCover cover, {int? replacement}) async {
    setState(() => _busy = true);
    final container = ProviderScope.containerOf(context);
    final router = GoRouter.of(context);
    final id = widget.careerId;
    if (replacement != null) {
      await container
          .read(squadServiceProvider)
          .replaceInjured(id, outId: cover.playerId, inId: replacement);
    }
    final career = await container.read(careerRepositoryProvider).byId(id);
    if (career != null) {
      await container
          .read(competitionRepositoryProvider)
          .markDrawWatched(
            id,
            career.cyclePointer,
            injuryCoverKey(cover.fixtureId, cover.playerId),
          );
    }
    container
      ..invalidate(pendingInjuryCoverProvider(id))
      ..invalidate(nextEventProvider(id))
      ..invalidate(hubDataProvider(id));
    if (router.state.uri.path == Routes.injuryCover) {
      router.go('${Routes.hub}?careerId=$id');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final id = widget.careerId;
    final cover = ref.watch(pendingInjuryCoverProvider(id));
    final squad = ref.watch(squadDataProvider(id));
    final window = ref.watch(nominationWindowProvider(id));
    final content = switch ((cover, squad, window)) {
      (
        AsyncData(value: final c?),
        AsyncData(value: final s?),
        AsyncData(
          value: final w,
        ),
      ) =>
        _body(l, c, s, w.matches.length),
      // Answered (or healed) meanwhile: nothing left to decide here.
      (AsyncData(value: null), _, _) => Center(
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
        scaffoldKey: InjuryCoverScreen.tabletLayoutKey,
        title: l.injuryCoverTitle,
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
        title: Text(l.injuryCoverTitle, style: AppTypography.labelMedium),
        centerTitle: true,
      ),
      body: content,
    );
  }

  Widget _body(
    AppLocalizations l,
    InjuryCover cover,
    SquadData squad,
    int coverage,
  ) {
    // Strongest first, whatever the position: the best cover leads.
    final candidates = [
      for (final p in squad.pool)
        if (!squad.callUps.contains(p.id) &&
            p.age >= _minAge &&
            SquadSelection.usableInPeriod(squad.absences[p.id], coverage))
          p,
    ]..sort((a, b) => b.overall.compareTo(a.overall));
    final picked = candidates.where((p) => p.id == _picked).firstOrNull;
    final out = squad.pool.where((p) => p.id == cover.playerId).firstOrNull;
    final outPosition = out == null ? '' : positionName(l, out.position);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (out != null) ...[
              _outTile(l, out, outPosition),
              const SizedBox(height: AppSpacing.sm),
            ],
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.injuryCoverBanner(cover.playerName, outPosition),
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l.hubEventInjuryCoverSub(cover.matchesOut),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: candidates.isEmpty
                  ? Center(
                      child: Text(
                        l.injuryCoverNone,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: candidates.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.xs),
                      itemBuilder: (_, i) => _row(
                        candidates[i],
                        samePosition: candidates[i].position == out?.position,
                      ),
                    ),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: picked == null
                  ? l.injuryCoverPick
                  : l.injuryCoverConfirm(picked.name),
              icon: Icons.how_to_reg_rounded,
              isLoading: _busy,
              onPressed: picked == null || _busy
                  ? null
                  : () => unawaited(_answer(cover, replacement: picked.id)),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: _busy ? null : () => unawaited(_answer(cover)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(l.injuryCoverKeep(cover.playerName)),
            ),
          ],
        ),
      ),
    );
  }

  /// The man being replaced, in the same shape as a candidate row, with the
  /// reason he is out (the call-up list's medical cross) in place of
  /// the radio dot, so the position being filled is plain to see.
  Widget _outTile(AppLocalizations l, Player p, String position) {
    const color = AppColors.error;
    return Container(
      key: const Key('injuryCover.outTile'),
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
          const Icon(Icons.medical_services, size: 20, color: color),
          const SizedBox(width: AppSpacing.md),
          SizedBox(width: 40, child: TacticalChip(p.position.label)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: AppTypography.bodyMedium),
                Text(
                  position,
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
        onTap: _busy ? null : () => setState(() => _picked = p.id),
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
