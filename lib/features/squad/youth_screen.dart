import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/features/squad/youth_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The nation's youth pyramid: five levels, from the eleven-year-olds who have
/// just come in to the twenty-year-olds about to be seniors.
///
/// The levels are watched, not managed — there are no youth fixtures. What this
/// screen is for is the one thing the game could never show before: the same
/// boy, season after season, becoming a player. The stars are a SCOUTING READ,
/// and it is deliberately vaguer the younger he is — a star out either way from
/// seventeen, two stars below that — so bringing a teenager through is a
/// decision rather than a lookup.
class YouthScreen extends ConsumerWidget {
  const YouthScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(youthPyramidProvider(careerId));

    return DefaultTabController(
      length: YouthLevel.values.length,
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
              for (final level in YouthLevel.values) Tab(text: level.label),
            ],
          ),
        ),
        body: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (pyramid) => TabBarView(
            children: [
              for (final level in YouthLevel.values)
                _LevelTab(
                  prospects: pyramid.byLevel[level] ?? const [],
                  released: pyramid.releasedByLevel[level] ?? const [],
                  careerId: careerId,
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
  });

  final List<Prospect> prospects;
  final List<String> released;
  final int careerId;

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
          _ProspectRow(prospect: p, careerId: careerId),
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
  const _ProspectRow({required this.prospect, required this.careerId});

  final Prospect prospect;
  final int careerId;

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
          const SizedBox(width: AppSpacing.sm),
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
