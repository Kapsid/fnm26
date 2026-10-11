import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/features/squad/youth_providers.dart';
import 'package:fnm/features/squad/youth_watch_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The nation's youth pyramid: five levels, from the eleven-year-olds who have
/// just come in to the twenty-year-olds about to be seniors, with the manager's
/// own shortlist in front of them.
///
/// The levels are watched, not managed — there are no youth fixtures. What this
/// screen is for is the one thing the game could never show before: the same
/// boy, season after season, becoming a player. The stars are a SCOUTING READ,
/// and it is deliberately vaguer the younger he is — a star out either way from
/// seventeen, two stars below that — so bringing a teenager through is a
/// decision rather than a lookup.
///
/// The shortlist tab comes FIRST because it is the manager's own list: he put
/// those boys on it, and a nation's pyramid runs to thirty-odd names he did
/// not. Its empty state is how the bookmark beside each boy is found.
class YouthScreen extends ConsumerWidget {
  const YouthScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(youthPyramidProvider(careerId));
    final marked = {
      for (final m
          in ref.watch(youthMarksProvider(careerId)).valueOrNull ??
              const <YouthMark>[])
        m.playerId,
    };

    return DefaultTabController(
      length: YouthLevel.values.length + 1,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => context.canPop()
                ? context.pop()
                : context.go('${Routes.hub}?careerId=$careerId'),
          ),
          title: Text(l.youthTitle, style: AppTypography.titleMedium),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppColors.onSurface,
            unselectedLabelColor: AppColors.onSurfaceVariant,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: l.youthWatching),
              for (final level in YouthLevel.values) Tab(text: level.label),
            ],
          ),
        ),
        body: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (pyramid) => TabBarView(
            children: [
              YouthWatchTab(careerId: careerId, years: pyramid.years),
              for (final level in YouthLevel.values)
                _LevelTab(
                  prospects: pyramid.byLevel[level] ?? const [],
                  released: pyramid.releasedByLevel[level] ?? const [],
                  careerId: careerId,
                  years: pyramid.years,
                  marked: marked,
                ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: OutlinedButton.icon(
              onPressed: () =>
                  context.go('${Routes.callUps}?careerId=$careerId'),
              icon: const Icon(Icons.how_to_reg_rounded, size: 18),
              label: Text(l.u21CallUps),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.outlineVariant),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One level's squad, best prospect first, with the boys who left it this year.
class _LevelTab extends StatelessWidget {
  const _LevelTab({
    required this.prospects,
    required this.released,
    required this.careerId,
    required this.years,
    required this.marked,
  });

  final List<Prospect> prospects;
  final List<String> released;
  final int careerId;
  final int years;
  final Set<int> marked;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (prospects.isEmpty && released.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            l.youthEmptyLevel,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        for (final p in prospects) ...[
          _ProspectRow(
            prospect: p,
            careerId: careerId,
            years: years,
            marked: marked.contains(p.player.id),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        // Boys who were here last year and have been let go. Shown, because a
        // career that ends at fifteen still happened.
        if (released.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l.youthReleased,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final name in released)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                name,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _ProspectRow extends StatelessWidget {
  const _ProspectRow({
    required this.prospect,
    required this.careerId,
    required this.years,
    required this.marked,
  });

  final Prospect prospect;
  final int careerId;
  final int years;
  final bool marked;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = prospect.player;
    return AppCard(
      onTap: () => context.push(
        '${Routes.player}?careerId=$careerId&playerId=${p.id}',
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          SizedBox(width: 38, child: TacticalChip(p.position.label)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        p.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                    if (prospect.yearGain >= 3) ...[
                      const SizedBox(width: AppSpacing.xs),
                      _Tag(
                        label: l.u21Breakout(prospect.yearGain),
                        color: AppColors.positive,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  prospect.caps > 0
                      ? l.u21AgeCaps(p.age, prospect.caps)
                      : l.u21AgeUncapped(p.age),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${p.overall}',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              _Stars(stars: prospect.stars, certain: prospect.certain),
            ],
          ),
          _WatchButton(
            careerId: careerId,
            playerId: p.id,
            player: p,
            years: years,
            marked: marked,
          ),
        ],
      ),
    );
  }
}

/// The bookmark that puts a boy on the shortlist, and takes him off it.
///
/// A bookmark rather than a star: the five stars beside him are the SCOUT's
/// read on his ceiling, and a sixth star meaning something else entirely would
/// be read as part of that scale.
class _WatchButton extends ConsumerWidget {
  const _WatchButton({
    required this.careerId,
    required this.playerId,
    required this.years,
    required this.marked,
    this.player,
  });

  final int careerId;
  final int playerId;
  final int years;
  final bool marked;

  /// Him as he is now. Null for a boy who is gone: only the id is needed to
  /// take him OFF the list, and nobody can be put on it who cannot be read.
  final Player? player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final p = player;
    return IconButton(
      icon: Icon(
        marked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        size: 20,
        color: marked ? AppColors.primary : AppColors.onSurfaceVariant,
      ),
      tooltip: marked ? l.youthWatchUnmark : l.youthWatchMark,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 34, height: 34),
      onPressed: marked
          ? () => ref.read(youthWatchStoreProvider).unmark(careerId, playerId)
          : p == null
          ? null
          : () => ref.read(youthWatchStoreProvider).mark(careerId, p, years),
    );
  }
}

/// The manager's shortlist: the boys he marked, and what has happened to them
/// since.
///
/// MOVEMENT is the whole content. A list of who they are now would be a second
/// squad list; what a watchlist is for is the difference between the reading
/// that made him mark the boy and the reading today.
class YouthWatchTab extends ConsumerWidget {
  const YouthWatchTab({
    required this.careerId,
    required this.years,
    super.key,
  });

  final int careerId;
  final int years;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(youthShortlistProvider(careerId));
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (boys) {
        if (boys.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The control itself, above the words: the copy says to mark
                  // a boy without naming a shape, so this is what says which
                  // shape to look for beside his name.
                  const Icon(
                    Icons.bookmark_border_rounded,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l.youthWatchEmpty,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          children: [
            for (final boy in boys) ...[
              _WatchRow(boy: boy, careerId: careerId, years: years),
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.xl),
          ],
        );
      },
    );
  }
}

class _WatchRow extends StatelessWidget {
  const _WatchRow({
    required this.boy,
    required this.careerId,
    required this.years,
  });

  final WatchedBoy boy;
  final int careerId;
  final int years;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final player = boy.player;
    final mark = boy.mark;
    final move = player == null ? null : player.overall - mark.rating;
    return AppCard(
      onTap: player == null
          ? null
          : () => context.push(
              '${Routes.player}?careerId=$careerId&playerId=${player.id}',
            ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (player != null)
                SizedBox(width: 38, child: TacticalChip(player.position.label)),
              if (player != null) const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        player?.name ?? mark.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                    if (move != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      _Tag(
                        label: move > 0 ? '+$move' : '$move',
                        color: move > 0
                            ? AppColors.positive
                            : move < 0
                            ? AppColors.error
                            : AppColors.onSurfaceVariant,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              if (player != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${player.overall}',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    _Stars(stars: boy.stars, certain: boy.certain),
                  ],
                ),
              _WatchButton(
                careerId: careerId,
                playerId: mark.playerId,
                player: player,
                years: years,
                marked: true,
              ),
            ],
          ),
          const SizedBox(height: 2),
          // Both lines run the full width of the card rather than sharing the
          // narrow column beside the rating: at 320 that column is under a
          // hundred points wide, and "Through to the senior pool" was cut in
          // half in it.
          Text(
            switch (boy.status) {
              WatchedStatus.following =>
                player == null
                    ? l.youthWatchGone
                    : boy.caps > 0
                    ? l.u21AgeCaps(player.age, boy.caps)
                    : l.u21AgeUncapped(player.age),
              WatchedStatus.senior => l.youthWatchSenior,
              WatchedStatus.released => l.youthWatchReleased,
              WatchedStatus.gone => l.youthWatchGone,
            },
            maxLines: 2,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          // The reading that put him on the list. Without it the rating beside
          // him is just a rating.
          Text(
            l.youthWatchMarked(mark.rating, mark.age),
            maxLines: 2,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// The ceiling read. An uncapped player's stars are hollow — the scout is
/// guessing, and the younger he is the wider that guess runs.
class _Stars extends StatelessWidget {
  const _Stars({required this.stars, required this.certain});

  final int stars;
  final bool certain;

  @override
  Widget build(BuildContext context) {
    final color = certain ? AppColors.primary : AppColors.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            i <= stars
                ? (certain ? Icons.star_rounded : Icons.star_half_rounded)
                : Icons.star_outline_rounded,
            size: 13,
            color: i <= stars ? color : AppColors.outlineVariant,
          ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: AppRadii.smAll,
    ),
    child: Text(
      label,
      style: AppTypography.labelSmall.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
        fontSize: 9,
      ),
    ),
  );
}
