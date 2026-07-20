import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/features/tournaments/tournaments_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// A championship tile's static presentation (name/region/icon/blurb). Its
/// status and whether it's playable come from [tournamentsOverviewProvider].
class _Championship {
  const _Championship({
    required this.name,
    required this.region,
    required this.icon,
    required this.description,
    this.confederation,
  });

  final String name;
  final String region;
  final IconData icon;
  final String description;

  /// The confederation this championship belongs to, or null for the global
  /// World Championship.
  final Confederation? confederation;
}

const _championships = <_Championship>[
  _Championship(
    name: 'World Championship',
    region: 'GLOBAL',
    icon: Icons.emoji_events,
    description: 'The pinnacle of international football.',
  ),
  _Championship(
    name: 'European Championship',
    region: 'EUROPE',
    icon: Icons.workspace_premium,
    description: 'The fight for the European crown.',
    confederation: Confederation.europe,
  ),
  _Championship(
    name: 'South America Cup',
    region: 'S. AMERICA',
    icon: Icons.flare,
    description: 'Passion and technique — the oldest continental tournament.',
    confederation: Confederation.southAmerica,
  ),
  _Championship(
    name: 'African Championship',
    region: 'AFRICA',
    icon: Icons.diamond,
    description: 'A celebration of pace and power across Africa.',
    confederation: Confederation.africa,
  ),
  _Championship(
    name: 'Asian Championship',
    region: 'ASIA',
    icon: Icons.explore,
    description: 'A dynamic stage for the rising stars of Asia.',
    confederation: Confederation.asia,
  ),
  _Championship(
    name: 'North America Cup',
    region: 'N. AMERICA',
    icon: Icons.public,
    description: 'The premier championship of the CONCACAF region.',
    confederation: Confederation.northAmerica,
  ),
  _Championship(
    name: 'Oceania Cup',
    region: 'OCEANIA',
    icon: Icons.sailing,
    description: 'The championship of the Pacific nations.',
    confederation: Confederation.oceania,
  ),
];

/// Tournaments overview (the "Trophy" destination). Lists every championship
/// with its live status; the World Championship and each continental cup open
/// their own detail screen.
class TournamentsScreen extends ConsumerWidget {
  const TournamentsScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(tournamentsOverviewProvider(careerId));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'COMPETITIONS',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard, color: AppColors.primary),
            tooltip: 'World ranking',
            onPressed: () =>
                context.go('${Routes.ranking}?careerId=$careerId'),
          ),
        ],
      ),
      bottomNavigationBar:
          AppBottomNav(careerId: careerId, current: AppTab.competitions),
      body: overviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load tournaments.\n$e')),
        data: (overview) {
          final playerConf = overview?.playerConfederation;
          // Your competitions (the World Cup + your own continental cup) sit in
          // their own section; the other continents follow.
          final mine = _championships
              .where((c) =>
                  c.confederation == null || c.confederation == playerConf)
              .toList();
          final others = _ordered(overview)
              .where((c) =>
                  c.confederation != null && c.confederation != playerConf)
              .toList();
          return ListView(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          children: [
            Text(
              'PRESTIGE STAGE',
              style:
                  AppTypography.labelMedium.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text('Overview', style: AppTypography.headlineLargeMobile),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              onTap: () => context.go('${Routes.ranking}?careerId=$careerId'),
              child: const Row(
                children: [
                  Icon(Icons.leaderboard, color: AppColors.primary),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'World Ranking',
                      style: AppTypography.titleMedium,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'YOUR COMPETITIONS',
              style:
                  AppTypography.labelMedium.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.sm),
            _tileGrid([
              for (final c in mine) _tile(context, overview, c),
              if (overview?.nationsCup != null)
                _ChampionshipTile(
                  championship: _Championship(
                    name: 'Nations Cup',
                    region: 'LEAGUE ${overview!.nationsCupLeague}',
                    icon: Icons.military_tech,
                    description: 'Your league — promotion and relegation.',
                  ),
                  status: overview.nationsCup,
                  championName: overview
                      .nations[overview.nationsCup!.championId]?.name,
                  onView: () =>
                      context.go('${Routes.nationsCup}?careerId=$careerId'),
                ),
              // The Continental Clash only sits among YOUR competitions when
              // your nation is one of the two entrants; otherwise it drops to
              // the other-competitions grid below.
              if (overview?.continentalClash != null &&
                  overview!.clashInvolvesPlayer)
                _clashTile(context, overview),
            ]),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'OTHER CONTINENTS',
              style:
                  AppTypography.labelMedium.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.sm),
            _tileGrid([
              for (final c in others) _tile(context, overview, c),
              if (overview?.continentalClash != null &&
                  !overview!.clashInvolvesPlayer)
                _clashTile(context, overview),
            ]),
            const SizedBox(height: AppSpacing.lg),
          ],
          );
        },
      ),
    );
  }

  /// Builds a championship tile from the overview data.
  Widget _tile(
    BuildContext context,
    TournamentsOverview? overview,
    _Championship c,
  ) {
    final championId = overview?.statuses[c.confederation]?.championId;
    return _ChampionshipTile(
      championship: c,
      status: overview?.statuses[c.confederation],
      championName:
          championId == null ? null : overview?.nations[championId]?.name,
      onView: () => _open(context, c),
    );
  }

  /// The Continental Clash tile, placed either among your competitions or the
  /// other-competitions grid depending on whether you're an entrant.
  Widget _clashTile(BuildContext context, TournamentsOverview overview) {
    return _ChampionshipTile(
      championship: const _Championship(
        name: 'Continental Clash',
        region: 'INTERCONTINENTAL',
        icon: Icons.flash_on,
        description: 'Champions of two continents, one match.',
      ),
      status: overview.continentalClash,
      championName:
          overview.nations[overview.continentalClash!.championId]?.name,
      onView: () =>
          context.go('${Routes.continentalClash}?careerId=$careerId'),
    );
  }

  /// Championships ordered by current relevance: competitions being contested
  /// now come first (the player's own region, then the World Championship, then
  /// others), followed by just-decided, upcoming and finally past editions.
  static List<_Championship> _ordered(TournamentsOverview? o) {
    int rank(int index, _Championship c) {
      final phase = o?.statuses[c.confederation]?.phase;
      final phaseRank = switch (phase) {
        TournamentPhase.live => 0,
        TournamentPhase.decided => 1,
        TournamentPhase.upcoming => 2,
        TournamentPhase.history => 3,
        null => 4,
      };
      final regionRank = c.confederation == null
          ? 1 // World Championship
          : c.confederation == o?.playerConfederation
              ? 0 // the player's own region
              : 2;
      return phaseRank * 100 + regionRank * 10 + index;
    }

    final indexed = _championships.asMap().entries.toList()
      ..sort((a, b) => rank(a.key, a.value).compareTo(rank(b.key, b.value)));
    return [for (final e in indexed) e.value];
  }

  /// Lays [tiles] out two-per-row as square cells, without introducing a nested
  /// scrollable (keeps the page a single scroll view).
  static Widget _tileGrid(List<Widget> tiles) {
    final rows = <Widget>[];
    for (var i = 0; i < tiles.length; i += 2) {
      final left = tiles[i];
      final right = i + 1 < tiles.length ? tiles[i + 1] : null;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: AspectRatio(aspectRatio: 1.25, child: left)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: right == null
                    ? const SizedBox.shrink()
                    : AspectRatio(aspectRatio: 1.25, child: right),
              ),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  void _open(BuildContext context, _Championship c) {
    if (c.confederation == null) {
      context.go('${Routes.cup}?careerId=$careerId');
    } else {
      final conf = c.confederation!.name;
      context.go('${Routes.continental}?careerId=$careerId&conf=$conf');
    }
  }
}

class _ChampionshipTile extends StatelessWidget {
  const _ChampionshipTile({
    required this.championship,
    required this.status,
    required this.championName,
    required this.onView,
  });

  final _Championship championship;
  final TournamentStatus? status;
  final String? championName;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final c = championship;
    final available = status?.available ?? false;
    final label = status?.label ?? 'SOON';
    // The competition being contested right now is highlighted green.
    final live = status?.phase == TournamentPhase.live;
    final accent = !available
        ? AppColors.onSurfaceVariant
        : live
            ? AppColors.positive
            : AppColors.primary;

    return AppCard(
      color: live ? AppColors.positive.withValues(alpha: 0.08) : null,
      border: live
          ? Border.all(color: AppColors.positive.withValues(alpha: 0.6))
          : null,
      onTap: available
          ? onView
          : () => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Tournament coming soon')),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          () {
            final trophy = Trophies.forCompetitionName(c.name);
            if (trophy == null) {
              return Icon(c.icon, size: 24, color: accent);
            }
            // The trophy artwork, dimmed until this competition is live.
            return Opacity(
              opacity: available ? 1 : 0.5,
              child: Image.asset(
                trophy,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    Icon(c.icon, size: 24, color: accent),
              ),
            );
          }(),
          const Spacer(),
          Text(
            c.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelLarge,
          ),
          const SizedBox(height: 2),
          Text(
            c.region,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: AppRadii.smAll,
                ),
                child: Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(color: accent),
                ),
              ),
              const Spacer(),
              if (championName != null)
                Flexible(
                  child: Text(
                    championName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
