import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/tournaments/continental_clash_screen.dart';
import 'package:fnm/features/tournaments/continental_detail_screen.dart';
import 'package:fnm/features/tournaments/cup_detail_screen.dart';
import 'package:fnm/features/tournaments/nations_cup_screen.dart';
import 'package:fnm/features/tournaments/tournaments_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'tournaments_tablet_layout.dart';

/// A championship tile's static presentation (name/zone/icon).
///
/// [name] is the CANONICAL English competition name, the one a save stores and
/// [Trophies.forCompetitionName] is keyed on — never printed as it stands.
/// [competitionLabel] writes it for the manager on the tile. [zone] is the
/// strap under it, which is pure presentation and so is an l10n key from the
/// start. Status and whether the tile is playable come from
/// [tournamentsOverviewProvider].
class _Championship {
  const _Championship({
    required this.name,
    required this.zone,
    required this.icon,
    this.confederation,
  });

  final String name;

  /// Reads the zone strap out of the copy: "GLOBAL", "S. AMERICA", … It takes
  /// the localisations rather than holding a string because the list of tiles
  /// below is const, built long before there is a context to read them with.
  final String Function(AppLocalizations) zone;
  final IconData icon;

  /// The confederation this championship belongs to, or null for the global
  /// World Championship.
  final Confederation? confederation;
}

const _championships = <_Championship>[
  _Championship(
    name: 'World Championship',
    zone: _zoneGlobal,
    icon: Icons.emoji_events,
  ),
  _Championship(
    name: 'European Championship',
    zone: _zoneEurope,
    icon: Icons.workspace_premium,
    confederation: Confederation.europe,
  ),
  _Championship(
    name: 'South America Cup',
    zone: _zoneSouthAmerica,
    icon: Icons.flare,
    confederation: Confederation.southAmerica,
  ),
  _Championship(
    name: 'African Championship',
    zone: _zoneAfrica,
    icon: Icons.diamond,
    confederation: Confederation.africa,
  ),
  _Championship(
    name: 'Asian Championship',
    zone: _zoneAsia,
    icon: Icons.explore,
    confederation: Confederation.asia,
  ),
  _Championship(
    name: 'North America Cup',
    zone: _zoneNorthAmerica,
    icon: Icons.public,
    confederation: Confederation.northAmerica,
  ),
  _Championship(
    name: 'Oceania Cup',
    zone: _zoneOceania,
    icon: Icons.sailing,
    confederation: Confederation.oceania,
  ),
];

// Top-level functions rather than closures: the list above is `const`, and a
// closure is not.
String _zoneGlobal(AppLocalizations l) => l.tourZoneGlobal;
String _zoneEurope(AppLocalizations l) => l.tourZoneEurope;
String _zoneSouthAmerica(AppLocalizations l) => l.tourZoneSouthAmerica;
String _zoneNorthAmerica(AppLocalizations l) => l.tourZoneNorthAmerica;
String _zoneAfrica(AppLocalizations l) => l.tourZoneAfrica;
String _zoneAsia(AppLocalizations l) => l.tourZoneAsia;
String _zoneOceania(AppLocalizations l) => l.tourZoneOceania;
String _zoneIntercontinental(AppLocalizations l) => l.tourZoneIntercontinental;

/// What the overview can open.
enum _PickKind { worldChampionship, continental, nationsCup, clash }

/// One openable competition: its kind, and whose it is where that matters.
typedef _Pick = ({_PickKind kind, Confederation? conf});

/// One competition as both layouts list it: how its tile looks, where it
/// stands, who won it, where its own page is, and what the tablet opens.
typedef _Spec = ({
  _Championship championship,
  TournamentStatus? status,
  String? championName,
  String route,
  _Pick pick,
});

/// Tournaments overview (the "Trophy" destination). Lists every championship
/// with its live status; the World Championship and each continental cup open
/// their own detail screen.
class TournamentsScreen extends ConsumerWidget {
  const TournamentsScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (TabletShellScope.isActive(context)) {
      return _TournamentsTabletLayout(careerId: careerId);
    }
    final l = AppLocalizations.of(context);
    final overviewAsync = ref.watch(tournamentsOverviewProvider(careerId));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l.tourSharedCompetitions,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard, color: AppColors.primary),
            tooltip: l.tourSharedWorldRanking,
            onPressed: () => context.go('${Routes.ranking}?careerId=$careerId'),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        careerId: careerId,
        current: AppTab.competitions,
      ),
      body: overviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            Center(child: Text(l.tourSharedCouldNotLoadTournaments)),
        data: (overview) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              Text(
                l.tourSharedPrestigeStage,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l.tourSharedOverview,
                style: AppTypography.headlineLargeMobile,
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                key: TourKeys.worldRanking,
                onTap: () => context.go('${Routes.ranking}?careerId=$careerId'),
                child: Row(
                  children: [
                    const Icon(Icons.leaderboard, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        l.tourWorldRanking,
                        style: AppTypography.titleMedium,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.onSurfaceVariant,
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l.tourYourCompetitions,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _tileGrid(context, [
                for (final s in _mineSpecs(careerId, overview))
                  _specTile(context, s),
              ]),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l.tourOtherContinents,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _tileGrid(context, [
                for (final s in _otherSpecs(careerId, overview))
                  _specTile(context, s),
              ]),
              const SizedBox(height: AppSpacing.lg),
            ],
          );
        },
      ),
    );
  }

  static const Key tabletLayoutKey = Key('tournaments.tabletLayout');

  /// A championship's spec from the overview data: the World Championship or
  /// a continental cup.
  static _Spec _championshipSpec(
    int careerId,
    TournamentsOverview? overview,
    _Championship c,
  ) {
    final conf = c.confederation;
    final championId = overview?.statuses[conf]?.championId;
    return (
      championship: c,
      status: overview?.statuses[conf],
      championName: championId == null
          ? null
          : overview?.nations[championId]?.name,
      route: conf == null
          ? '${Routes.cup}?careerId=$careerId'
          : '${Routes.continental}?careerId=$careerId&conf=${conf.name}',
      pick: (
        kind: conf == null
            ? _PickKind.worldChampionship
            : _PickKind.continental,
        conf: conf,
      ),
    );
  }

  /// A Nations Cup: the manager's own (strapped with his league on a ladder
  /// cup) or another confederation's, opening that cup's screen.
  static _Spec _nationsCupSpec(
    int careerId,
    TournamentsOverview overview,
    Confederation conf,
    TournamentStatus status, {
    bool mine = false,
  }) {
    final cup = NationsCups.forConfederation(conf);
    final ladder = cup?.format == NationsCupFormat.ladder;
    return (
      championship: _Championship(
        name: cup?.name ?? NationsCups.europe,
        zone: (l) => mine && ladder
            ? l.tourZoneLeague(overview.nationsCupLeague)
            : _confederationZone(l, conf),
        icon: Icons.military_tech,
      ),
      status: status,
      championName: overview.nations[status.championId]?.name,
      route: '${Routes.nationsCup}?careerId=$careerId&conf=${conf.name}',
      pick: (kind: _PickKind.nationsCup, conf: conf),
    );
  }

  static String _confederationZone(AppLocalizations l, Confederation c) =>
      switch (c) {
        Confederation.europe => l.tourZoneEurope,
        Confederation.southAmerica => l.tourZoneSouthAmerica,
        Confederation.northAmerica => l.tourZoneNorthAmerica,
        Confederation.africa => l.tourZoneAfrica,
        Confederation.asia => l.tourZoneAsia,
        Confederation.oceania => l.tourZoneOceania,
      };

  /// The Continental Clash, placed either among your competitions or the
  /// other competitions depending on whether you're an entrant.
  static _Spec _clashSpec(int careerId, TournamentsOverview overview) => (
    championship: const _Championship(
      name: 'Continental Clash',
      zone: _zoneIntercontinental,
      icon: Icons.flash_on,
    ),
    status: overview.continentalClash,
    championName: overview.nations[overview.continentalClash!.championId]?.name,
    route: '${Routes.continentalClash}?careerId=$careerId',
    pick: (kind: _PickKind.clash, conf: null),
  );

  /// Your competitions: the World Championship and your own continental cup,
  /// your Nations Cup, and the Continental Clash when your nation is one of
  /// its two entrants.
  static List<_Spec> _mineSpecs(int careerId, TournamentsOverview? overview) {
    final playerConf = overview?.playerConfederation;
    return [
      for (final c in _championships)
        if (c.confederation == null || c.confederation == playerConf)
          _championshipSpec(careerId, overview, c),
      if (overview?.nationsCup != null)
        _nationsCupSpec(
          careerId,
          overview!,
          overview.nationsCupConfederation ?? Confederation.europe,
          overview.nationsCup!,
          mine: true,
        ),
      // The Continental Clash only sits among YOUR competitions when your
      // nation is one of the two entrants; otherwise it drops to the others.
      if (overview?.continentalClash != null && overview!.clashInvolvesPlayer)
        _clashSpec(careerId, overview),
    ];
  }

  /// The other continents' championships (most relevant first), their
  /// Nations Cups, and the Clash when your nation is not in it.
  static List<_Spec> _otherSpecs(int careerId, TournamentsOverview? overview) {
    final playerConf = overview?.playerConfederation;
    return [
      for (final c in _ordered(overview))
        if (c.confederation != null && c.confederation != playerConf)
          _championshipSpec(careerId, overview, c),
      if (overview != null)
        for (final e in overview.otherNationsCups.entries)
          _nationsCupSpec(careerId, overview, e.key, e.value),
      if (overview?.continentalClash != null && !overview!.clashInvolvesPlayer)
        _clashSpec(careerId, overview),
    ];
  }

  /// A spec as the phone draws it: a tile opening the competition's page.
  Widget _specTile(BuildContext context, _Spec s) => _ChampionshipTile(
    championship: s.championship,
    status: s.status,
    championName: s.championName,
    onView: () => context.go(s.route),
  );

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
  ///
  /// The cells are 1.25:1. Under a larger text size a row grows to its taller
  /// tile instead (both tiles of a row kept the same height), so the tile's
  /// copy never spills out of a cell sized for the normal text.
  static Widget _tileGrid(BuildContext context, List<Widget> tiles) {
    final grows = MediaQuery.textScalerOf(context).scale(16) > 16;
    final rows = <Widget>[];
    for (var i = 0; i < tiles.length; i += 2) {
      final left = tiles[i];
      final right = i + 1 < tiles.length ? tiles[i + 1] : null;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: grows
              ? LayoutBuilder(
                  builder: (context, box) {
                    final cell = (box.maxWidth - AppSpacing.sm) / 2;
                    return ConstrainedBox(
                      constraints: BoxConstraints(minHeight: cell / 1.25),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: left),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(child: right ?? const SizedBox.shrink()),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AspectRatio(aspectRatio: 1.25, child: left),
                    ),
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
    final l = AppLocalizations.of(context);
    final c = championship;
    final available = status?.available ?? false;
    final label = status?.label ?? l.tourSharedSoon;
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
                SnackBar(content: Text(l.tourSharedComingSoon)),
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
            // A Nations Cup tile says just that: the strap under it names the
            // continent, and "Coupe des Nations d’Amérique du Nord" cannot
            // fit two lines of a half-width tile in any language.
            NationsCups.isNationsCup(c.name)
                ? l.compNationsCup
                : competitionLabel(l, c.name),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelLarge,
          ),
          const SizedBox(height: 2),
          Text(
            c.zone(l),
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
