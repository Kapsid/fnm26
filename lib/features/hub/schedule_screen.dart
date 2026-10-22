import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/schedule_providers.dart';
import 'package:fnm/features/hub/schedule_widgets.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:go_router/go_router.dart';

/// The nation's whole cycle, window by window: what has been played above,
/// what is still to come below, opening at the match the nation is on.
///
/// Past blocks sit above the scroll origin (the current block is the
/// `CustomScrollView.center`), so the screen opens at today with no
/// post-frame jump. Expects `?careerId=`.
class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({required this.careerId, super.key});

  static const Key tabletLayoutKey = Key('schedule.tabletLayout');
  static const Key todayKey = Key('schedule.today');
  static const Key _centerKey = Key('schedule.center');

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final schedule = ref.watch(scheduleProvider(careerId));
    final data = schedule.valueOrNull;
    final next = ref.watch(nextEventProvider(careerId)).valueOrNull;
    // A load that failed (or found no career) ends in the empty line, not a
    // spinner that never stops.
    final content = data != null
        ? _list(context, l, data, next)
        : schedule.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Center(child: _noMoreLine(l));
    if (TabletShellScope.isActive(context)) {
      return TabletPage(
        scaffoldKey: tabletLayoutKey,
        title: l.scheduleTitle,
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
          onPressed: () => context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(l.scheduleTitle, style: AppTypography.labelMedium),
        centerTitle: true,
      ),
      body: content,
    );
  }

  Widget _list(
    BuildContext context,
    AppLocalizations l,
    ScheduleData data,
    HubEvent? next,
  ) {
    final current = data.currentIndex;
    Widget block(int i) {
      final b = data.blocks[i];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (i == current)
              Padding(
                key: todayKey,
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_right_rounded,
                      color: AppColors.primary,
                    ),
                    Text(
                      l.scheduleToday.capsIn(l.localeName),
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Text(
                AppDate.monthYear(
                  context,
                  DateTime(b.year, b.month),
                ).capsIn(l.localeName),
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            Text(
              MatchStage.category(l, b.fixtures.first.round),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            for (final f in b.fixtures)
              ScheduleFixtureRow(
                fixture: f,
                nationId: data.nationId,
                opponent:
                    data.nations[f.homeNationId == data.nationId
                        ? f.awayNationId
                        : f.homeNationId],
                opponentKnown: opponentKnown(data, f),
                onTap: scheduleRowTap(
                  context,
                  careerId: careerId,
                  data: data,
                  fixture: f,
                  next: next,
                ),
              ),
            if (b.pending != null) SchedulePendingRow(pending: b.pending!),
          ],
        ),
      );
    }

    // With nothing current (cycle over, eliminated, champion) the last block
    // is the origin, so the screen opens on the latest fixtures with the
    // closing line just below, not on the oldest block at the top.
    final centre = current >= 0 ? current : data.blocks.length - 1;
    return CustomScrollView(
      center: centre < 0 ? null : _centerKey,
      slivers: [
        for (var i = 0; i < data.blocks.length; i++)
          SliverToBoxAdapter(
            key: i == centre ? _centerKey : null,
            child: block(i),
          ),
        // The closing line only when no stage is still to come (the hub
        // card's UpcomingRows rule), else it contradicts the pending row.
        if (current < 0 && data.blocks.lastOrNull?.pending == null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _noMoreLine(l),
            ),
          )
        else
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
      ],
    );
  }

  Widget _noMoreLine(AppLocalizations l) => Text(
    l.hubNoMoreFixtures,
    style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
  );
}
