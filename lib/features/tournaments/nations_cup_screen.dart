import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/career_label.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/cross_group.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tournaments/best_thirds.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';
import 'package:fnm/features/tournaments/tournament_history.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

typedef _NcView = ({
  /// Whose cup this is, and whether it is the manager's own (the one with a
  /// draw ceremony, a league or zone of his, and his name in it).
  Confederation confederation,
  String cupName,
  NationsCupFormat format,
  bool isMine,
  String playerLeague,
  String? playerGroup,
  List<FinalsGroupTable> groups,
  List<Fixture> roundOf16,
  List<Fixture> quarters,
  List<Fixture> semis,
  List<Fixture> finalFx,
  List<Honour> honours,
  List<ScorerTally> scorers,
  Map<int, String> playerNames,
  bool drawWatched,
  int playerNationId,

  /// The nations the manager has led, current and past: their scorers are
  /// highlighted.
  Set<int> myNationIds,
  Map<int, Nation> nations,

  /// The lowest league in the cup's confederation — its bottom sides have
  /// nowhere to fall, so they aren't shown as relegated.
  int maxTier,
});

/// Which cup to show: [confederation]'s, or (null) the manager's own — Europe's
/// for a manager whose confederation has none.
typedef _NcKey = ({int careerId, Confederation? confederation});

final AutoDisposeFutureProviderFamily<_NcView?, _NcKey>
_nationsCupProvider = FutureProvider.autoDispose.family<_NcView?, _NcKey>((
  ref,
  key,
) async {
  final careerId = key.careerId;
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  final mine = NationsCups.ofManager(nations[career.nationId]?.confederation);
  final conf = key.confederation ?? mine ?? Confederation.europe;
  final cup = NationsCups.forConfederation(conf);
  if (cup == null) return null;
  final isMine = conf == mine;
  // Every lookup names the cup: all three live in the cycle as competitions
  // of the same kind.
  final groups =
      await comp.tournamentGroupTables(
          careerId,
          CompetitionKind.nationsLeague,
          confederation: conf,
        )
        ..sort((a, b) => a.name.compareTo(b.name));
  final tiers = await ref
      .watch(careerRepositoryProvider)
      .nationsCupTiers(careerId);
  // The group the manager's nation plays in (for "my group first").
  String? playerGroup;
  for (final g in groups) {
    if (g.standings.any((s) => s.nationId == career.nationId)) {
      playerGroup = g.name;
      break;
    }
  }
  // His league is the one his group is drawn in ('B3' -> 'B'); the stored
  // ladder only stands in before the draw. A save seeded before CONCACAF's
  // remainder was folded into League B stores its last three as League C.
  final playerLeague = !isMine
      ? 'A'
      : (playerGroup != null && playerGroup.isNotEmpty)
      ? playerGroup[0]
      : NationsCup.leagueLetter(tiers[career.nationId] ?? 0);
  final honours = [
    for (final h in await comp.honours(careerId))
      if (h.competition == cup.name) h,
  ]..sort((a, b) => b.year.compareTo(a.year));
  Future<List<Fixture>> round(String r) => comp.fixturesByRound(
    careerId,
    r,
    kind: CompetitionKind.nationsLeague,
    confederation: conf,
  );
  // The finals: a ladder cup's Finals Four (League A's group winners contest
  // two semis then a final), or Africa's knockouts, which open with a Round
  // of 16.
  final roundOf16 = await round('NR16');
  final quarters = await round('NQF');
  final semis = await round('NSF');
  final finalFx = await round('NFINAL');
  // Only the manager's own cup is drawn at a ceremony; the others are there to
  // browse from the start.
  final drawWatched =
      !isMine ||
      await comp.hasWatchedDraw(
        careerId,
        career.cyclePointer,
        nationsCupDrawKind,
      );
  final maxTier = NationsCup.lowestTier(
    tiers: tiers,
    confederation: conf,
    confederationOf: (id) => nations[id]?.confederation,
  );

  // The cup's scorer chart — the goals were always recorded, nothing ever read
  // them back for this competition.
  final scorers = await comp.topScorers(
    careerId,
    kind: CompetitionKind.nationsLeague,
    confederation: conf,
    limit: 15,
  );
  final playerRepo = ref.watch(playerRepositoryProvider);
  // A generated player is reconstructed from his id rather than read from a
  // row, and the reconstruction only reaches an intake year that has already
  // happened — so the lookup has to say which year of the save it is asking
  // about, or every newgen scorer comes back null and prints as "Unknown".
  //
  // The year and the seed are all a NAME needs. The two development maps
  // (youth-academy bonuses, career starts) only shift attribute magnitudes,
  // and the career-starts one is an appearance-table scan across the whole
  // save — a real cost for a chart that reads nothing but `p.name`.
  final playerNames = <int, String>{};
  for (final id in {for (final s in scorers) s.playerId}) {
    final p = await playerRepo.byId(
      id,
      agingYears: CareerService.agingYears(career),
      saveSeed: career.rngSeed,
    );
    if (p != null) playerNames[id] = p.name;
  }

  return (
    confederation: conf,
    cupName: cup.name,
    format: cup.format,
    isMine: isMine,
    playerLeague: playerLeague,
    playerGroup: playerGroup,
    groups: groups,
    roundOf16: roundOf16,
    quarters: quarters,
    semis: semis,
    finalFx: finalFx,
    honours: honours,
    scorers: scorers,
    playerNames: playerNames,
    drawWatched: drawWatched,
    playerNationId: career.nationId,
    myNationIds: {
      career.nationId,
      ...(await ref.watch(careerRepositoryProvider).stints(careerId)).values,
    },
    nations: nations,
    maxTier: maxTier,
  );
});

/// A Nations Cup: the manager's league group standings by default (their own
/// group first), with a selector to browse the other leagues — or, for the
/// African cup, its four zones and its knockouts. [confederation] picks the
/// cup; null opens the manager's own.
class NationsCupScreen extends ConsumerStatefulWidget {
  const NationsCupScreen({
    required this.careerId,
    this.confederation,
    super.key,
  });

  final int careerId;
  final Confederation? confederation;

  @override
  ConsumerState<NationsCupScreen> createState() => _NationsCupScreenState();
}

class _NationsCupScreenState extends ConsumerState<NationsCupScreen> {
  /// The tab to land on: wherever the cup actually is.
  static int _liveTab(_NcView? v) {
    if (v == null) return 0;
    // The finals are the business end — go there once they're drawn.
    if (v.roundOf16.isNotEmpty ||
        v.quarters.isNotEmpty ||
        v.semis.isNotEmpty ||
        v.finalFx.isNotEmpty) {
      return 1;
    }
    // Out of season there are no tables to show, so the honours are the point.
    if (v.groups.isEmpty) return 3;
    return 0; // leagues / zones
  }

  _NcKey get _key =>
      (careerId: widget.careerId, confederation: widget.confederation);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(_nationsCupProvider(_key));
    final view = async.valueOrNull;
    final liveTab = _liveTab(view);
    final zones = view?.format == NationsCupFormat.zones;
    // Europe's cup keeps the title it always had; the others are named.
    final title = view == null || view.cupName == NationsCups.europe
        ? l.tourContNationsCup
        : competitionLabel(l, view.cupName).toUpperCase();
    return DefaultTabController(
      // See CupDetailScreen: initialIndex is read once, before the data lands.
      key: ValueKey((liveTab, zones)),
      length: 4,
      initialIndex: liveTab,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => context.canPop()
                ? context.pop()
                : context.go(
                    '${Routes.tournaments}?careerId=${widget.careerId}',
                  ),
          ),
          // The named cups ("COUPE DES NATIONS D’AMÉRIQUE DU NORD") are wider
          // than a 320px app bar beside its back button: two lines, not "…".
          title: Text(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          centerTitle: true,
          // The tabs sit right on top of the content otherwise; the extra
          // height gives them room to breathe.
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kTournamentTabBarHeight),
            child: TabBar(
              isScrollable: true,
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: zones ? l.tourContTabZones : l.tourContTabLeagues),
                Tab(
                  text: zones
                      ? l.tourContTabFinalsEight
                      : l.tourContTabFinalsFour,
                ),
                Tab(text: l.tourContTabScorers),
                Tab(text: l.tourContTabHistory),
              ],
            ),
          ),
        ),
        body: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) =>
              Center(child: Text(l.tourContCouldNotLoad(e.toString()))),
          data: (v) {
            if (v == null) {
              return Center(child: Text(l.tourContNoSaveFound));
            }
            String name(int id) => v.nations[id]?.name ?? l.tourContUnknown;
            String code(int id) => v.nations[id]?.code ?? '??';

            return TabBarView(
              children: [
                if (v.format == NationsCupFormat.zones)
                  _zones(v, name, code)
                else
                  _leagues(v, name, code),
                _finals(v, name, code),
                TournamentScorers(
                  scorers: v.scorers,
                  playerNames: v.playerNames,
                  code: code,
                  emptyMessage: l.tourContNoNationsCupGoals,
                  highlightNations: v.myNationIds,
                ),
                // Always reachable: the roll of honour used to be visible only
                // out of season, so the cup's history vanished the moment it
                // kicked off.
                TournamentHistory(
                  honours: v.honours,
                  name: name,
                  code: code,
                  emptyMessage: l.tourContNoNationsCupChampions,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Why there are no tables to show yet, or null when there are.
  Widget? _notYet(_NcView v) {
    final l = AppLocalizations.of(context);
    if (v.groups.isEmpty) {
      return TournamentSoon(
        message: l.tourContNationsCupOffSeason,
      );
    }
    // Groups exist but the draw ceremony hasn't been watched — keep it a
    // surprise.
    if (!v.drawWatched) {
      return TournamentSoon(
        message: l.tourContNationsCupGroupsSoon,
      );
    }
    return null;
  }

  /// The league tables, or why there aren't any yet.
  Widget _leagues(
    _NcView v,
    String Function(int) name,
    String Function(int) code,
  ) {
    final l = AppLocalizations.of(context);
    final notYet = _notYet(v);
    if (notYet != null) return notYet;

    // Every league of the confederation, in order (A, B, C…) — not only the
    // ones with a group drawn this round. A league with nothing on is an
    // EMPTY tab, never a missing one: a tab bar that changes length between
    // rounds is a tab bar the manager cannot learn.
    final leagues = <String>{
      for (var tier = 0; tier <= v.maxTier; tier++)
        String.fromCharCode(65 + tier),
      for (final g in v.groups) g.name[0],
      if (v.isMine) v.playerLeague,
    }.toList()..sort();

    return _LeagueTabs(
      leagues: leagues,
      playerLeague: v.isMine ? v.playerLeague : '',
      builder: (context, league) {
        // Groups of this league; the player's own group first when it's his.
        final shown = v.groups.where((g) => g.name[0] == league).toList()
          ..sort((a, b) {
            if (a.name == v.playerGroup) return -1;
            if (b.name == v.playerGroup) return 1;
            return a.name.compareTo(b.name);
          });
        if (shown.isEmpty) {
          return TournamentSoon(message: l.tourContLeagueNoGroups);
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          children: [
            Text(
              v.isMine && league == v.playerLeague
                  ? l.tourContLeagueHeadingYours(league)
                  : l.tourContLeagueHeading(league),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            for (final g in shown) ...[
              _GroupCard(
                group: g,
                confederation: v.confederation,
                playerNationId: v.playerNationId,
                name: name,
                code: code,
                isLowestLeague: NationsCup.tierOfGroupName(g.name) >= v.maxTier,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        );
      },
    );
  }

  /// The African cup's zones: each zone's groups under its name, the
  /// manager's own zone (and group) first, after the line that says what a
  /// group is played for.
  Widget _zones(
    _NcView v,
    String Function(int) name,
    String Function(int) code,
  ) {
    final l = AppLocalizations.of(context);
    final notYet = _notYet(v);
    if (notYet != null) return notYet;
    final myZone = v.playerGroup == null
        ? null
        : NationsCups.zoneOfGroupName(v.playerGroup!);
    final order = [
      if (myZone != null) myZone,
      for (final z in AfricaZone.values)
        if (z != myZone) z,
    ];
    // The race for the last two Round of 16 places, always shown under the
    // tables: every group's runner-up, ranked across all groups. The manager's
    // own zone, and his group within it, come first.
    final standings = [
      for (final g in v.groups)
        if (NationsCups.zoneOfGroupName(g.name) != null) g.standings,
    ];
    final runnersUp = NationsCups.knockoutField(
      standings,
      (id) => v.nations[id]?.ranking ?? 1 << 20,
    ).runnersUp;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        Text(
          l.tourContZoneAdvancement,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final zone in order) ...[
          Text(
            zone == myZone
                ? l.tourContZoneHeadingYours(
                    africaZoneLabel(l, zone).toUpperCase(),
                  )
                : africaZoneLabel(l, zone).toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final g
              in [
                for (final g in v.groups)
                  if (NationsCups.zoneOfGroupName(g.name) == zone) g,
              ]..sort((a, b) {
                if (a.name == v.playerGroup) return -1;
                if (b.name == v.playerGroup) return 1;
                return a.name.compareTo(b.name);
              })) ...[
            _GroupCard(
              group: g,
              confederation: v.confederation,
              playerNationId: v.playerNationId,
              name: name,
              code: code,
              isLowestLeague: true,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.sm),
        ],
        // Below every table, as in the other cups' group tabs.
        if (runnersUp.isNotEmpty) ...[
          BestThirdsCard(
            thirds: runnersUp,
            qualifyCount: NationsCups.runnersUpThrough,
            playerNationId: v.playerNationId,
            code: code,
            name: name,
            title: contentionLadderTitle(l, 2),
            destination: l.tourCupDestRoundOf16,
            adjustedForGroupSize: CrossGroup.isUneven(standings),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ],
    );
  }

  /// The finals: a ladder cup's Finals Four (League A's group winners contest
  /// two semis and a final), or the African knockouts.
  Widget _finals(
    _NcView v,
    String Function(int) name,
    String Function(int) code,
  ) {
    final l = AppLocalizations.of(context);
    final zones = v.format == NationsCupFormat.zones;
    if (v.roundOf16.isEmpty &&
        v.quarters.isEmpty &&
        v.semis.isEmpty &&
        v.finalFx.isEmpty) {
      return TournamentSoon(
        message: zones ? l.tourContFinalsEightSoon : l.tourContFinalsFourSoon,
      );
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        _FinalsCard(
          title: zones ? l.tourContTabFinalsEight : l.tourContTabFinalsFour,
          roundOf16: v.roundOf16,
          quarters: v.quarters,
          semis: v.semis,
          finalFx: v.finalFx,
          playerNationId: v.playerNationId,
          name: name,
          code: code,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

/// The leagues of the Nations Cup as tabs, opening on the manager's own.
///
/// They used to be a row of chips above the tables, which is a control the
/// rest of the app does not use anywhere else; the tournament screens are
/// tabbed, so these are tabs too, at the same [kTournamentTabBarHeight].
class _LeagueTabs extends StatelessWidget {
  const _LeagueTabs({
    required this.leagues,
    required this.playerLeague,
    required this.builder,
  });

  /// Every league of the confederation, A first — including any with no
  /// matches this round, which get an empty tab rather than none.
  final List<String> leagues;

  /// The league the manager's nation plays in: the tab this opens on, and the
  /// one carrying the star.
  final String playerLeague;

  final Widget Function(BuildContext context, String league) builder;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final mine = leagues.indexOf(playerLeague);
    return DefaultTabController(
      length: leagues.length,
      initialIndex: mine < 0 ? 0 : mine,
      child: Column(
        children: [
          SizedBox(
            height: kTournamentTabBarHeight,
            child: TabBar(
              // Scrollable, so each label is laid out at the width it asks
              // for: a confederation can run to half a dozen leagues, and a
              // fixed bar would divide the phone between them and cut every
              // one of them in half.
              isScrollable: true,
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              tabs: [
                for (final league in leagues)
                  Tab(
                    // A plain Text, not a Tab(text:) — that one wraps its
                    // label with softWrap off and no maxLines, so a width
                    // guard reading didExceedMaxLines never fires on it.
                    child: Text(
                      league == playerLeague
                          ? l.tourContLeagueChipStar(league)
                          : l.tourContLeagueChip(league),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                for (final league in leagues) builder(context, league),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.group,
    required this.confederation,
    required this.playerNationId,
    required this.name,
    required this.code,
    required this.isLowestLeague,
  });

  final FinalsGroupTable group;

  /// Whose cup the group is in: a ladder group sends its winner up and its
  /// bottom side down, an African zone group relegates nobody.
  final Confederation confederation;
  final int playerNationId;
  final String Function(int) name;
  final String Function(int) code;

  /// The lowest league has nowhere to fall, so its bottom side isn't relegated.
  final bool isLowestLeague;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final mine = group.standings.any((s) => s.nationId == playerNationId);
    return AppCard(
      border: mine
          ? Border.all(color: AppColors.primary.withValues(alpha: 0.5))
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.tourContGroupHeading(group.name),
            style: AppTypography.labelMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < group.standings.length; i++)
            _row(i + 1, group.standings[i], group.standings.length),
        ],
      ),
    );
  }

  Widget _row(int pos, GroupStanding s, int total) {
    final isPlayer = s.nationId == playerNationId;
    // Winner (green) is promoted; the bottom side (red) relegated — or, in an
    // African zone group, the winner (green) reaches the Round of 16 and the
    // runner-up (amber) may follow. Shared
    // with the hub's group table so the two never disagree.
    final adv = GroupAdvancement.forGroup(
      kind: CompetitionKind.nationsLeague,
      confederation: confederation,
      groupCount: 1,
      continentalSize: 0,
      isLowestLeague: isLowestLeague,
    );
    final zone = pos <= adv.direct
        ? AppColors.positive
        : pos == adv.contention
        ? AppColors.warning
        : adv.relegate > 0 && pos > total - adv.relegate
        ? AppColors.error
        : null;
    final gd = s.goalDifference;
    return Container(
      decoration: BoxDecoration(
        color: isPlayer ? AppColors.surfaceContainerHigh : null,
        border: Border(
          left: BorderSide(color: zone ?? Colors.transparent, width: 3),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: Text(
              '$pos',
              style: AppTypography.labelSmall.copyWith(
                color: zone ?? AppColors.onSurfaceVariant,
              ),
            ),
          ),
          FlagDisc(code(s.nationId), size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name(s.nationId),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: isPlayer ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          _cell('${s.played}'),
          _cell('${s.goalsFor}:${s.goalsAgainst}', width: 42),
          _cell(gd > 0 ? '+$gd' : '$gd'),
          _cell('${s.points}', bold: true),
        ],
      ),
    );
  }

  Widget _cell(String t, {bool bold = false, double width = 30}) => SizedBox(
    width: width,
    child: Text(
      t,
      textAlign: TextAlign.center,
      style: AppTypography.labelSmall.copyWith(
        color: bold ? AppColors.primary : AppColors.onSurface,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
      ),
    ),
  );
}

/// A Nations Cup's finals bracket — the Finals Four's two semi-finals and
/// final, or the African Round of 16 and quarter-finals before them — with
/// results once played, so the climax is visible whether or not the manager's
/// nation reached it.
class _FinalsCard extends StatelessWidget {
  const _FinalsCard({
    required this.title,
    required this.roundOf16,
    required this.quarters,
    required this.semis,
    required this.finalFx,
    required this.playerNationId,
    required this.name,
    required this.code,
  });

  final String title;
  final List<Fixture> roundOf16;
  final List<Fixture> quarters;
  final List<Fixture> semis;
  final List<Fixture> finalFx;
  final int playerNationId;
  final String Function(int) name;
  final String Function(int) code;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget heading(String text, {bool primary = false}) => Text(
      text,
      style: AppTypography.labelSmall.copyWith(
        color: primary ? AppColors.primary : AppColors.onSurfaceVariant,
      ),
    );
    return AppCard(
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(title, style: AppTypography.labelMedium),
            ],
          ),
          if (roundOf16.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            heading(l.resultsStageRoundOf16),
            const SizedBox(height: AppSpacing.xs),
            for (final f in roundOf16) _tie(f, l),
          ],
          if (quarters.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            heading(l.tourContQuarterFinals),
            const SizedBox(height: AppSpacing.xs),
            for (final f in quarters) _tie(f, l),
          ],
          if (semis.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            heading(l.tourContSemiFinals),
            const SizedBox(height: AppSpacing.xs),
            for (final f in semis) _tie(f, l),
          ],
          if (finalFx.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            heading(l.tourContFinal, primary: true),
            const SizedBox(height: AppSpacing.xs),
            for (final f in finalFx) _tie(f, l),
          ],
        ],
      ),
    );
  }

  Widget _tie(Fixture f, AppLocalizations l) {
    final done = f.hasResult;
    final homeWon = done && f.homeScore! >= f.awayScore!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: _side(f.homeNationId, done && homeWon, right: true)),
          SizedBox(
            width: 54,
            child: Text(
              done ? '${f.homeScore} - ${f.awayScore}' : l.tourContVersusShort,
              textAlign: TextAlign.center,
              style: AppTypography.labelMedium.copyWith(
                color: done ? AppColors.onSurface : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: _side(f.awayNationId, done && !homeWon)),
        ],
      ),
    );
  }

  Widget _side(int id, bool winner, {bool right = false}) {
    final isPlayer = id == playerNationId;
    final label = Flexible(
      child: Text(
        name(id),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: right ? TextAlign.right : TextAlign.left,
        style: AppTypography.bodySmall.copyWith(
          color: winner ? AppColors.primary : AppColors.onSurface,
          fontWeight: (winner || isPlayer) ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
    final flag = FlagDisc(code(id), size: 18);
    return Row(
      mainAxisAlignment: right
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: right
          ? [label, const SizedBox(width: AppSpacing.xs), flag]
          : [flag, const SizedBox(width: AppSpacing.xs), label],
    );
  }
}
