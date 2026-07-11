import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/tournaments/tournaments_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          'TOURNAMENTS',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: overviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load tournaments.\n$e')),
        data: (overview) => ListView(
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
            for (final c in _ordered(overview)) ...[
              _ChampionshipTile(
                championship: c,
                status: overview?.statuses[c.confederation],
                championName: () {
                  final id = overview?.statuses[c.confederation]?.championId;
                  return id == null ? null : overview?.nations[id]?.name;
                }(),
                isPlayerRegion:
                    c.confederation == overview?.playerConfederation,
                nextMatch: overview?.nextMatches[c.confederation],
                hostId: c.confederation == null
                    ? overview?.worldCupHostId
                    : null,
                nations: overview?.nations ?? const {},
                onView: () => _open(context, c),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
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
    required this.isPlayerRegion,
    required this.nextMatch,
    required this.hostId,
    required this.nations,
    required this.onView,
  });

  final _Championship championship;
  final TournamentStatus? status;
  final String? championName;
  final bool isPlayerRegion;
  final Fixture? nextMatch;
  final int? hostId;
  final Map<int, Nation> nations;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final c = championship;
    final available = status?.available ?? false;
    final label = status?.label ?? 'SOON';

    // One compact context line: your next match, else the champion, else host.
    Widget? detail;
    if (nextMatch != null) {
      detail = _UpNext(fixture: nextMatch!, nations: nations);
    } else if (championName != null) {
      detail = _iconLine(Icons.emoji_events, 'WINNER', championName!);
    } else if (hostId != null) {
      detail = _iconLine(
        Icons.stadium_rounded,
        'HOST',
        nations[hostId!]?.name ?? '—',
      );
    }

    return AppCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
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
          Row(
            children: [
              Icon(
                c.icon,
                size: 20,
                color: available
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  c.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelLarge,
                ),
              ),
              if (isPlayerRegion) ...[
                const TacticalChip('YOU', emphasized: true),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: available
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.onSurfaceVariant,
              ),
            ],
          ),
          if (detail != null) ...[
            const SizedBox(height: AppSpacing.xs),
            detail,
          ],
        ],
      ),
    );
  }

  Widget _iconLine(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall,
          ),
        ),
      ],
    );
  }
}

/// A compact "up next" strip on a championship tile: the player's next fixture
/// in that competition (home code vs away code + date).
class _UpNext extends StatelessWidget {
  const _UpNext({required this.fixture, required this.nations});

  final Fixture fixture;
  final Map<int, Nation> nations;

  @override
  Widget build(BuildContext context) {
    String code(int id) => nations[id]?.code ?? '??';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadii.smAll,
      ),
      child: Row(
        children: [
          Text(
            'UP NEXT',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          FlagDisc(code(fixture.homeNationId), size: 18),
          const SizedBox(width: AppSpacing.xs),
          Text(code(fixture.homeNationId), style: AppTypography.labelSmall),
          Text(
            '  v  ',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(code(fixture.awayNationId), style: AppTypography.labelSmall),
          const SizedBox(width: AppSpacing.xs),
          FlagDisc(code(fixture.awayNationId), size: 18),
          const Spacer(),
          Text(
            DateFormat('d MMM').format(fixture.date),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
