import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/career_label.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/cross_group.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/features/tournaments/best_thirds.dart';
import 'package:fnm/features/tournaments/nations_cup_providers.dart';
import 'package:fnm/features/tournaments/tournament_history.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'nations_cup_view.dart';

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

  /// The key of the tablet layout.
  static const Key tabletLayoutKey = Key('nationsCup.tabletLayout');

  @override
  ConsumerState<NationsCupScreen> createState() => _NationsCupScreenState();
}

class _NationsCupScreenState extends ConsumerState<NationsCupScreen>
    with _NationsCupBodies<NationsCupScreen> {
  @override
  bool get grid => false;

  NationsCupKey get _key =>
      (careerId: widget.careerId, confederation: widget.confederation);

  @override
  Widget build(BuildContext context) {
    if (TabletShellScope.isActive(context)) {
      return _NationsCupTabletLayout(
        careerId: widget.careerId,
        confederation: widget.confederation,
      );
    }
    final l = AppLocalizations.of(context);
    final async = ref.watch(nationsCupProvider(_key));
    final view = async.valueOrNull;
    final liveTab = _ncLiveTab(view);
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
              tabs: _tabs(l, zones: zones),
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
            return TabBarView(children: _tabViews(v));
          },
        ),
      ),
    );
  }
}

/// The tab to land on: wherever the cup actually is.
int _ncLiveTab(NationsCupData? v) {
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

/// The cup's tabs and their bodies, shared by the phone screen and
/// [NationsCupView]. [grid] (a tablet) lays each league's or zone's group
/// tables out in columns.
mixin _NationsCupBodies<T extends StatefulWidget> on State<T> {
  bool get grid;

  List<Tab> _tabs(AppLocalizations l, {required bool zones}) => [
    Tab(text: zones ? l.tourContTabZones : l.tourContTabLeagues),
    Tab(text: zones ? l.tourContTabFinalsEight : l.tourContTabFinalsFour),
    Tab(text: l.tourContTabScorers),
    Tab(text: l.tourContTabHistory),
  ];

  List<Widget> _tabViews(NationsCupData v) {
    final l = AppLocalizations.of(context);
    String name(int id) => v.nations[id]?.name ?? l.tourContUnknown;
    String code(int id) => v.nations[id]?.code ?? '??';
    return [
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
    ];
  }

  /// Why there are no tables to show yet, or null when there are.
  Widget? _notYet(NationsCupData v) {
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
    NationsCupData v,
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
        Widget card(FinalsGroupTable g) => _GroupCard(
          group: g,
          confederation: v.confederation,
          playerNationId: v.playerNationId,
          name: name,
          code: code,
          isLowestLeague: NationsCup.tierOfGroupName(g.name) >= v.maxTier,
        );
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
            if (grid) ...[
              ColumnFlow(children: [for (final g in shown) card(g)]),
              const SizedBox(height: AppSpacing.md),
            ] else
              for (final g in shown) ...[
                card(g),
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
    NationsCupData v,
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
    List<FinalsGroupTable> groupsOf(AfricaZone zone) =>
        [
          for (final g in v.groups)
            if (NationsCups.zoneOfGroupName(g.name) == zone) g,
        ]..sort((a, b) {
          if (a.name == v.playerGroup) return -1;
          if (b.name == v.playerGroup) return 1;
          return a.name.compareTo(b.name);
        });
    Widget card(FinalsGroupTable g) => _GroupCard(
      group: g,
      confederation: v.confederation,
      playerNationId: v.playerNationId,
      name: name,
      code: code,
      isLowestLeague: true,
    );
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
          if (grid) ...[
            ColumnFlow(children: [for (final g in groupsOf(zone)) card(g)]),
            const SizedBox(height: AppSpacing.md),
          ] else
            for (final g in groupsOf(zone)) ...[
              card(g),
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
    NationsCupData v,
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
