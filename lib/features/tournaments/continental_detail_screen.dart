import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/cross_group.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/features/tournaments/best_thirds.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/tournament_awards.dart';
import 'package:fnm/features/tournaments/tournament_bracket.dart';
import 'package:fnm/features/tournaments/tournament_history.dart';
import 'package:fnm/features/tournaments/tournament_holders_row.dart';
import 'package:fnm/features/tournaments/tournament_stats.dart';
import 'package:fnm/features/tournaments/tournament_summary.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'continental_detail_view.dart';

/// Continental-championship detail: this cycle's knockout bracket (for the
/// player's own region), the scorer chart, and the full roll of honour for the
/// competition (which includes background-simulated editions of other regions).
class ContinentalDetailScreen extends ConsumerWidget {
  const ContinentalDetailScreen({
    required this.careerId,
    required this.confederation,
    super.key,
  });

  final int careerId;
  final Confederation confederation;

  static const List<BracketRound> _bracketRounds = [
    ('CR16', 'Round of 16'),
    ('CQF', 'Quarter-finals'),
    ('CSF', 'Semi-finals'),
    ('CFINAL', 'Final'),
  ];

  /// The main knockout ladder (excludes the third-place play-off, which hangs
  /// off the side rather than feeding the final), for the bracket columns.
  static const List<BracketRound> _ladder = [
    ('CR16', 'R16'),
    ('CQF', 'QF'),
    ('CSF', 'SF'),
    ('CFINAL', 'Final'),
  ];

  static const Key tabletLayoutKey = Key('continentalDetail.tabletLayout');

  /// Whether this cup is reached through a qualifying campaign at all.
  ///
  /// The South America Cup is contested by the whole confederation — every
  /// CONMEBOL nation is in it, so there is nothing to qualify for. Its
  /// qualifying tab was permanently empty and only ever explained its own
  /// absence, so the cup simply doesn't have one.
  static bool _hasQualifyingFor(Confederation c) =>
      ContinentalCups.byConfederation[c]?.qualifying ?? true;

  bool get _hasQualifying => _hasQualifyingFor(confederation);

  /// The tab to land on: wherever this championship actually is, as a real tab
  /// index (0 = summary) — everything after summary shifts down by one on a cup
  /// with no qualifying tab.
  static int _liveTabFor(Confederation c, ContinentalData? data) {
    final finals = _hasQualifyingFor(c) ? 2 : 1;
    final bracket = finals + 1;
    final history = bracket + 3; // awards, scorers, history
    if (data == null) return 0;
    // Another confederation's cup is simulated in the background but now has
    // real fixtures — land on its bracket if one exists, else its history.
    if (!data.isPlayerRegion) {
      return data.knockout.isNotEmpty ? bracket : history;
    }
    if (data.knockout.isNotEmpty) return bracket;
    if (data.groups.isNotEmpty && data.finalsDrawWatched) return finals;
    // Qualifying when there is one, else the finals group stage.
    return 1;
  }

  int _liveTab(ContinentalData? data) => _liveTabFor(confederation, data);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (TabletShellScope.isActive(context)) {
      return _ContinentalDetailTabletLayout(
        careerId: careerId,
        confederation: confederation,
      );
    }
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(
      continentalDetailProvider((
        careerId: careerId,
        confederation: confederation,
      )),
    );
    final liveTab = _liveTab(dataAsync.valueOrNull);

    return DefaultTabController(
      // See CupDetailScreen: initialIndex is read once, before the data lands.
      key: ValueKey(liveTab),
      length: _hasQualifying ? 8 : 7,
      initialIndex: liveTab,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () =>
                context.go('${Routes.tournaments}?careerId=$careerId'),
          ),
          title: Text(
            dataAsync.maybeWhen(
              data: (d) => d == null
                  ? l.tourContChampionship
                  : competitionLabel(l, d.name).capsIn(l.localeName),
              orElse: () => l.tourContChampionship,
            ),
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
              tabs: _continentalTabs(l, confederation),
            ),
          ),
        ),
        body: dataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) =>
              Center(child: Text(l.tourContCouldNotLoadCup(e.toString()))),
          data: (data) {
            if (data == null) {
              return Center(child: Text(l.tourContNoCupData));
            }
            String code(int id) => data.nations[id]?.code ?? '??';
            String name(int id) => data.nations[id]?.name ?? l.tourContUnknown;

            final tabs = TabBarView(
              children: _continentalTabViews(
                context,
                data,
                careerId: careerId,
                confederation: confederation,
              ),
            );

            return Column(
              children: [
                // Who walks into this edition holding the trophy — the last
                // nation to win it, not the champion of the edition on screen.
                TournamentHoldersRow(
                  holders: data.holders,
                  code: code,
                  name: name,
                ),
                Expanded(child: tabs),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// A continental championship's tabs, in the order [_continentalTabViews]
/// builds their bodies. A cup the whole confederation plays has no
/// qualifying tab.
List<Tab> _continentalTabs(AppLocalizations l, Confederation c) => [
  Tab(text: l.tourContTabSummary),
  if (ContinentalDetailScreen._hasQualifyingFor(c))
    Tab(text: l.tourContTabQualifying),
  Tab(text: l.tourContTabFinals),
  Tab(text: l.tourContTabBracket),
  Tab(text: l.tourContTabAwards),
  Tab(text: l.tourContTabScorers),
  Tab(text: l.tourContTabHistory),
  Tab(text: l.tourContTabRecords),
];

/// The tab bodies. Shared by the phone screen and [ContinentalDetailView]:
/// [grid] (a tablet) lays the group tables out in columns and opens the
/// bracket full width.
List<Widget> _continentalTabViews(
  BuildContext context,
  ContinentalData data, {
  required int careerId,
  required Confederation confederation,
  bool grid = false,
}) {
  final l = AppLocalizations.of(context);
  String code(int id) => data.nations[id]?.code ?? '??';
  String name(int id) => data.nations[id]?.name ?? l.tourContUnknown;

  Widget qualifyingTab() {
    if (data.qualifyingGroups.isEmpty) {
      return TournamentSoon(
        message: data.isPlayerRegion
            ? l.tourContQualSeeded
            : l.tourContBackgroundRegion(
                competitionLabel(l, data.name),
              ),
      );
    }
    if (!data.qualDrawWatched) {
      return TournamentSoon(message: l.tourContGroupsToBeDrawnQual);
    }
    final size =
        ContinentalCups.byConfederation[data.confederation]?.size ?? 24;
    // Hosts reserve finals berths, so fewer teams (and fewer
    // best-thirds) come through qualifying.
    final adv = GroupAdvancement.continentalQualifying(
      (size - data.hostCount).clamp(1, size),
      data.qualifyingGroups.length,
    );
    return _Groups(
      careerId: careerId,
      groups: data.qualifyingGroups,
      playerNationId: data.playerNationId,
      directCount: adv.direct,
      contentionPos: adv.contention,
      contentionQualify: adv.contentionQualify,
      // The contested places lead to the finals here, not to a
      // knockout round.
      contentionDestination: l.tourCupDestFinals,
      code: code,
      name: name,
      grid: grid,
    );
  }

  return [
    TournamentSummaryTab(
      hostIds: data.hostIds,
      hostCities: data.hostCities,
      hostEstates: data.hostEstates,
      identity: data.identity,
      trophyAsset: Trophies.forConfederation(data.confederation),
      teamCount:
          ContinentalCups.byConfederation[data.confederation]?.size ?? 24,
      code: code,
      name: name,
    ),
    if (ContinentalDetailScreen._hasQualifyingFor(confederation))
      qualifyingTab(),
    if (data.groups.isNotEmpty && !data.finalsDrawWatched)
      TournamentSoon(
        message: l.tourContGroupsToBeDrawnFinals,
      )
    else if (data.groups.isNotEmpty)
      () {
        // Copa América: two groups of five, top four into the
        // quarters. Every other format advances the top two (plus
        // any best-thirds).
        final copa =
            data.groups.length == 2 &&
            data.groups.every((g) => g.standings.length >= 5);
        return _ContFinalsGroups(
          careerId: careerId,
          groups: data.groups,
          groupFixtures: data.groupFixtures,
          playerNationId: data.playerNationId,
          // Finals: top two advance; best thirds are in contention
          // (top four for the Copa América groups of five).
          directCount: copa ? 4 : 2,
          contentionPos: copa
              ? null
              : WorldCupFinals.bestThirdsFor(data.groups.length) > 0
              ? 3
              : null,
          thirdsQualify: copa
              ? 0
              : WorldCupFinals.bestThirdsFor(data.groups.length),
          code: code,
          name: name,
          grid: grid,
        );
      }()
    else
      TournamentSoon(
        message: data.isPlayerRegion
            ? l.tourContFinalsDrawAfterQual
            : l.tourContBackgroundRegion(
                competitionLabel(l, data.name),
              ),
      ),
    if (data.knockout.isNotEmpty)
      TournamentBracket(
        careerId: careerId,
        fixtures: data.knockout,
        wide: grid,
        rounds: ContinentalDetailScreen._bracketRounds,
        ladder: ContinentalDetailScreen._ladder,
        champion: data.champion,
        championLabel: l.tourContChampionsHeading(
          competitionLabel(l, data.name).capsIn(l.localeName),
        ),
        playerNationId: data.playerNationId,
        // Only the manager's own confederation is played out, so a
        // run to highlight exists only there.
        runSummary: !data.isPlayerRegion
            ? null
            : playerRunSummary(
                l,
                playerNationId: data.playerNationId,
                champion: data.champion,
                knockout: data.knockout,
                groups: data.groups,
                championTitle: l.tourContWinnersTitle(
                  competitionLabel(l, data.name),
                ),
              ),
        groupSeeds: groupSeedsOf(data.groups),
        code: code,
        name: name,
      )
    else
      TournamentSoon(
        message: data.isPlayerRegion
            ? l.tourContContestedBeforeWc
            : l.tourContBackgroundRegion(
                competitionLabel(l, data.name),
              ),
      ),
    TournamentAwardsTab(
      highlightNations: data.myNationIds,
      team: data.teamOfTournament,
      goldenGlove: data.goldenGlove,
      code: code,
      name: name,
    ),
    TournamentScorers(
      scorers: data.scorers,
      playerNames: data.playerNames,
      allTime: data.allTimeScorers,
      code: code,
      emptyMessage: l.tourContNoGoalsYet,
      highlightNations: data.myNationIds,
    ),
    TournamentHistory(
      honours: data.honours,
      name: name,
      code: code,
    ),
    TournamentStatsTab(
      honours: data.honours,
      allTimeScorers: data.allTimeScorers,
      topGames: data.topGames,
      topCups: data.topCups,
      highlightNations: data.myNationIds,
      code: code,
      name: name,
    ),
  ];
}

class _Groups extends StatelessWidget {
  const _Groups({
    required this.careerId,
    required this.groups,
    required this.playerNationId,
    required this.directCount,
    required this.contentionPos,
    required this.code,
    required this.name,
    this.contentionQualify = 0,
    this.contentionDestination,
    this.grid = false,
  });

  final int careerId;
  final List<FinalsGroupTable> groups;
  final int playerNationId;

  /// Positions that advance/qualify outright (green).
  final int directCount;

  /// A single position marked "in contention" (amber — best runner-up / best
  /// third), or null when there is no such spot.
  final int? contentionPos;

  /// How many teams at [contentionPos] actually go through. Drives the
  /// cross-group ladder card, so the amber stripe is backed by a real "1 of 2
  /// advance" list rather than left to be guessed at.
  final int contentionQualify;

  /// Where the contested places lead, written for the manager and in the case
  /// the ladder's sentence wants. Null takes the knockouts, which is where a
  /// finals group stage leads.
  final String? contentionDestination;

  /// A tablet: the group tables in columns rather than stacked.
  final bool grid;

  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // Cross-group ladders compare teams that never met, so they run on
    // comparable records when the groups are uneven (see CrossGroup).
    final tables = [for (final g in groups) g.standings];
    final uneven = CrossGroup.isUneven(tables);
    // The contested tier — second-placed sides, or fourth-placed ones in a
    // confederation where the field reaches that deep.
    final contended = contentionPos == null
        ? const <GroupStanding>[]
        : crossGroupTier(tables, contentionPos! - 1);

    // The player's own group first, the rest in their drawn order.
    final ordered = [
      for (final g in groups)
        if (g.standings.any((s) => s.nationId == playerNationId)) g,
      for (final g in groups)
        if (!g.standings.any((s) => s.nationId == playerNationId)) g,
    ];

    Widget card(FinalsGroupTable g) => AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.tourContGroupHeading(g.name),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < g.standings.length; i++)
            _row(i + 1, g.standings[i]),
        ],
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        if (grid) ...[
          ColumnFlow(children: [for (final g in ordered) card(g)]),
          const SizedBox(height: AppSpacing.sm),
        ] else
          for (final g in ordered) ...[
            card(g),
            const SizedBox(height: AppSpacing.sm),
          ],
        if (contentionPos case final pos?)
          if (contentionQualify > 0 && contended.length > contentionQualify)
            BestThirdsCard(
              thirds: contended,
              qualifyCount: contentionQualify,
              playerNationId: playerNationId,
              code: code,
              name: name,
              destination: contentionDestination,
              title: contentionLadderTitle(l, pos),
              adjustedForGroupSize: uneven,
              careerId: careerId,
            ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _row(int pos, GroupStanding s) {
    final isPlayer = s.nationId == playerNationId;
    final advancing = pos <= directCount;
    final inContention = pos == contentionPos;
    final accent = advancing
        ? AppColors.positive
        : inContention
        ? AppColors.warning
        : null;
    final gd = s.goalDifference;
    return Container(
      decoration: BoxDecoration(
        color: isPlayer ? AppColors.surfaceContainerHigh : null,
        border: Border(
          left: BorderSide(
            color: accent ?? Colors.transparent,
            width: 3,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: Text(
              '$pos',
              style: AppTypography.labelSmall.copyWith(
                color: accent ?? AppColors.onSurfaceVariant,
                fontWeight: accent != null ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: NationTap(
              careerId: careerId,
              nationId: s.nationId,
              child: Row(
                children: [
                  FlagDisc(code(s.nationId), size: 22),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      name(s.nationId),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: isPlayer
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _cell('${s.played}'),
          _cell('${s.goalsFor}:${s.goalsAgainst}', width: 42),
          _cell(gd > 0 ? '+$gd' : '$gd'),
          _cell('${s.points}', emphasize: true),
        ],
      ),
    );
  }

  Widget _cell(String text, {bool emphasize = false, double width = 30}) =>
      SizedBox(
        width: width,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTypography.labelSmall.copyWith(
            color: emphasize ? AppColors.primary : AppColors.onSurface,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      );
}

/// The continental FINALS groups view: every group's table and matches on one
/// scrollable page, the player's own group first, then the rest.
class _ContFinalsGroups extends StatefulWidget {
  const _ContFinalsGroups({
    required this.careerId,
    required this.groups,
    required this.groupFixtures,
    required this.playerNationId,
    required this.directCount,
    required this.contentionPos,
    required this.thirdsQualify,
    required this.code,
    required this.name,
    this.grid = false,
  });

  final int careerId;
  final List<FinalsGroupTable> groups;
  final List<Fixture> groupFixtures;
  final int playerNationId;
  final int directCount;
  final int? contentionPos;
  final int thirdsQualify;
  final String Function(int) code;
  final String Function(int) name;

  /// A tablet: the group tables in columns rather than stacked.
  final bool grid;

  @override
  State<_ContFinalsGroups> createState() => _ContFinalsGroupsState();
}

class _ContFinalsGroupsState extends State<_ContFinalsGroups> {
  bool _isMine(FinalsGroupTable g) =>
      g.standings.any((s) => s.nationId == widget.playerNationId);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final groups = widget.groups;
    if (groups.isEmpty) {
      return Center(child: Text(l.tourContNoGroupsDrawn));
    }
    // Every group on one page — the player's own group first, then the rest.
    final ordered = [
      ...groups.where(_isMine),
      ...groups.where((g) => !_isMine(g)),
    ];
    final tables = [for (final g in groups) g.standings];
    final uneven = CrossGroup.isUneven(tables);
    final thirds = crossGroupTier(tables, 2);

    List<Fixture> matchesOf(FinalsGroupTable g) {
      final ids = {for (final s in g.standings) s.nationId};
      return widget.groupFixtures
          .where(
            (f) => ids.contains(f.homeNationId) && ids.contains(f.awayNationId),
          )
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    }

    Widget card(FinalsGroupTable g) => AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.tourContGroupHeading(g.name),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          // Matches on top, then the table — one box per group.
          if (matchesOf(g) case final ms when ms.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            for (final f in ms)
              MatchResultRow(
                fixture: f,
                code: widget.code,
                careerId: widget.careerId,
              ),
            const Divider(height: AppSpacing.lg),
          ],
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < g.standings.length; i++)
            _row(i + 1, g.standings[i]),
        ],
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        if (widget.grid) ...[
          ColumnFlow(children: [for (final g in ordered) card(g)]),
          const SizedBox(height: AppSpacing.md),
        ] else
          for (final g in ordered) ...[
            card(g),
            const SizedBox(height: AppSpacing.md),
          ],
        if (widget.thirdsQualify > 0 &&
            thirds.length > widget.thirdsQualify) ...[
          BestThirdsCard(
            thirds: thirds,
            qualifyCount: widget.thirdsQualify,
            playerNationId: widget.playerNationId,
            code: widget.code,
            name: widget.name,
            adjustedForGroupSize: uneven,
            careerId: widget.careerId,
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _row(int pos, GroupStanding s) {
    final isPlayer = s.nationId == widget.playerNationId;
    final advancing = pos <= widget.directCount;
    final inContention = pos == widget.contentionPos;
    final accent = advancing
        ? AppColors.positive
        : inContention
        ? AppColors.warning
        : null;
    final gd = s.goalDifference;
    return Container(
      decoration: BoxDecoration(
        color: isPlayer ? AppColors.surfaceContainerHigh : null,
        border: Border(
          left: BorderSide(color: accent ?? Colors.transparent, width: 3),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: Text(
              '$pos',
              style: AppTypography.labelSmall.copyWith(
                color: accent ?? AppColors.onSurfaceVariant,
                fontWeight: accent != null ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: NationTap(
              careerId: widget.careerId,
              nationId: s.nationId,
              child: Row(
                children: [
                  FlagDisc(widget.code(s.nationId), size: 22),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      widget.name(s.nationId),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: isPlayer
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _cell('${s.played}'),
          _cell('${s.goalsFor}:${s.goalsAgainst}', width: 42),
          _cell(gd > 0 ? '+$gd' : '$gd'),
          _cell('${s.points}', emphasize: true),
        ],
      ),
    );
  }

  Widget _cell(String text, {bool emphasize = false, double width = 30}) =>
      SizedBox(
        width: width,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTypography.labelSmall.copyWith(
            color: emphasize ? AppColors.primary : AppColors.onSurface,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      );
}
