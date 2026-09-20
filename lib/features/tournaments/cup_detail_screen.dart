import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/cross_group.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/features/tournaments/all_time_scorers_legend.dart';
import 'package:fnm/features/tournaments/best_thirds.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_bracket.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_screen.dart'
    show intercontinentalPlayoffProvider;
import 'package:fnm/features/tournaments/tournament_awards.dart';
import 'package:fnm/features/tournaments/tournament_bracket.dart';
import 'package:fnm/features/tournaments/tournament_history.dart';
import 'package:fnm/features/tournaments/tournament_holders_row.dart';
import 'package:fnm/features/tournaments/tournament_stats.dart';
import 'package:fnm/features/tournaments/tournament_summary.dart';
import 'package:fnm/features/tournaments/wc_host_theme.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// World Championship detail: the qualifying group stage for every
/// confederation (your region first), plus knockout/stats/history tabs that
/// arrive with the finals.
class CupDetailScreen extends ConsumerWidget {
  const CupDetailScreen({required this.careerId, super.key});

  final int careerId;

  /// The tab to land on: wherever the tournament actually is. Opening on
  /// qualifying while the final is being played makes the manager hunt for the
  /// live stage every time.
  /// The tab index to land on (in the 9-tab layout: 0 Summary, 1 Qualifying,
  /// 2 Play-off, 3 Finals, 4 Bracket, 5 Awards, 6 Scorers, 7 History,
  /// 8 Records).
  static int _liveTab(CupData? data) {
    if (data == null) return 0;
    if (data.knockout.isNotEmpty) return 4; // the bracket, even once crowned
    if (data.hasFinals && data.finalsDrawWatched) return 3; // finals groups
    return 1; // qualifying
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(cupDetailProvider(careerId));
    final liveTab = _liveTab(dataAsync.valueOrNull);
    // Once the opening ceremony has run, the WC takes on the host's colours.
    final host = ref.watch(wcHostThemeProvider(careerId)).valueOrNull;
    final themed = host?.active ?? false;
    final accent = themed ? host!.accent : AppColors.primary;

    return DefaultTabController(
      // Keyed by the landing tab because DefaultTabController reads
      // initialIndex once, in initState: the first build has no data yet, so
      // without this the index would be fixed at 0 before the stage is known.
      // A manual tab choice survives (the key only moves when the stage does).
      key: ValueKey(liveTab),
      length: 9,
      initialIndex: liveTab,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () =>
                context.go('${Routes.tournaments}?careerId=$careerId'),
          ),
          title: Text(
            l.tourCupTitle,
            style: AppTypography.labelMedium.copyWith(color: accent),
          ),
          centerTitle: true,
          // The tabs sit right on top of the content otherwise; the extra
          // height gives them room to breathe.
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kTournamentTabBarHeight),
            child: TabBar(
              isScrollable: true,
              labelColor: themed ? accent : AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: accent,
              tabs: [
                Tab(text: l.tourCupTabSummary),
                Tab(text: l.tourCupTabQualifying),
                Tab(text: l.tourCupTabPlayoff),
                Tab(text: l.tourCupTabFinals),
                Tab(text: l.tourCupTabBracket),
                Tab(text: l.tourCupTabAwards),
                Tab(text: l.tourCupTabScorers),
                Tab(text: l.tourCupTabHistory),
                Tab(text: l.tourCupTabRecords),
              ],
            ),
          ),
        ),
        body: dataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) =>
              Center(child: Text(l.tourCupLoadError(e.toString()))),
          data: (data) {
            if (data == null) return Center(child: Text(l.tourCupNoData));
            String code(int id) => data.nations[id]?.code ?? '??';
            String name(int id) => data.nations[id]?.name ?? l.tourCupUnknown;

            return Column(
              children: [
                // Host-nation strip once the tournament has kicked off.
                if (themed && host != null)
                  WcHostBanner(theme: host, code: code),
                // Who walks into this edition holding the trophy — the last
                // nation to win it, not the champion of the edition on screen.
                TournamentHoldersRow(
                  holders: data.holders,
                  code: code,
                  name: name,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Host cities, stadiums, mascot and ball — first, as an
                      // at-a-glance overview of the edition.
                      TournamentSummaryTab(
                        hostIds: data.hostIds,
                        hostCities: data.hostCities,
                        identity: data.identity,
                        trophyAsset: Trophies.worldCup,
                        code: code,
                        name: name,
                      ),
                      if (!data.qualDrawWatched)
                        _Soon(message: l.tourCupQualDrawSoon)
                      else
                        _Qualifying(
                          groups: data.groups,
                          playerConfederation: data.playerConfederation,
                          playerNationId: data.playerNationId,
                          code: code,
                          name: name,
                        ),
                      // The intercontinental play-off — its own tab, shown as a
                      // knockout bracket for the last two finals berths.
                      _PlayoffTab(careerId: careerId),
                      if (data.hasFinals && !data.finalsDrawWatched)
                        _Soon(message: l.tourCupFinalsDrawSoon)
                      else if (data.hasFinals)
                        _FinalsGroups(
                          groups: data.finalsGroups,
                          groupFixtures: data.groupFixtures,
                          playerNationId: data.playerNationId,
                          code: code,
                          name: name,
                        )
                      else
                        _Soon(message: l.tourCupFinalsDrawnAfterQual),
                      if (data.knockout.isNotEmpty)
                        TournamentBracket(
                          fixtures: data.knockout,
                          rounds: _rounds,
                          ladder: _ladder,
                          champion: data.champion,
                          championLabel: l.tourCupWorldChampions,
                          playerNationId: data.playerNationId,
                          runSummary: playerRunSummary(
                            playerNationId: data.playerNationId,
                            champion: data.champion,
                            knockout: data.knockout,
                            groups: data.finalsGroups,
                            championTitle: l.tourCupWorldChampionsTitle,
                          ),
                          groupSeeds: groupSeedsOf(data.finalsGroups),
                          code: code,
                          name: name,
                        )
                      else
                        _Soon(message: l.tourCupKnockoutSoon),
                      // Every individual honour for the edition in one place.
                      TournamentAwardsTab(
                        team: data.teamOfTournament,
                        goldenGlove: data.goldenGlove,
                        code: code,
                        name: name,
                      ),
                      _Scorers(
                        qualifying: data.scorersQualifying,
                        finals: data.scorersFinals,
                        allTime: data.allTimeScorers,
                        playerNames: data.playerNames,
                        code: code,
                      ),
                      // Not the shared TournamentHistory: the World Cup screen's
                      // history browses every competition, not just its own.
                      _History(honours: data.honours, name: name, code: code),
                      TournamentStatsTab(
                        // data.honours spans every competition here — the
                        // records are World-Cup-only.
                        honours: data.honours
                            .where((h) => h.competition == 'World Championship')
                            .toList(),
                        allTimeScorers: data.allTimeScorers,
                        topGames: data.topGames,
                        topCups: data.topCups,
                        highlightNations: data.myNationIds,
                        code: code,
                        name: name,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// The intercontinental play-off tab: the knockout for the last two finals
/// berths, drawn as a bracket. Shows a "not yet" note until every
/// confederation's qualifying is complete and the ties are decided.
class _PlayoffTab extends ConsumerWidget {
  const _PlayoffTab({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(intercontinentalPlayoffProvider(careerId));
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l.tourCupLoadError(e.toString()))),
      data: (data) {
        if (data == null) return _Soon(message: l.tourCupPlayoffSoon);
        String code(int id) => data.nations[id]?.code ?? '??';
        String name(int id) => data.nations[id]?.name ?? l.tourCupUnknown;
        return _PlayoffList(
          ties: data.ties,
          playerNationId: data.playerNationId,
          code: code,
          name: name,
        );
      },
    );
  }
}

class _Qualifying extends StatefulWidget {
  const _Qualifying({
    required this.groups,
    required this.playerConfederation,
    required this.playerNationId,
    required this.code,
    required this.name,
  });

  final List<ConfederationGroupTable> groups;
  final Confederation? playerConfederation;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;

  @override
  State<_Qualifying> createState() => _QualifyingState();
}

class _QualifyingState extends State<_Qualifying> {
  /// Selector value: `null` = all confederations, or a [Confederation] = one
  /// region. (The intercontinental play-off has its own tab now.)
  Object? _selection;
  bool _initialised = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (widget.groups.isEmpty) {
      return Center(child: Text(l.tourCupNoGroups));
    }
    final byConf = <Confederation, List<ConfederationGroupTable>>{};
    for (final g in widget.groups) {
      (byConf[g.confederation] ??= []).add(g);
    }
    final regions = byConf.keys.toList()
      ..sort((a, b) => a.index.compareTo(b.index));
    // Default to the manager's own confederation the first time.
    if (!_initialised) {
      _initialised = true;
      if (widget.playerConfederation != null &&
          byConf.containsKey(widget.playerConfederation)) {
        _selection = widget.playerConfederation;
      }
    }
    final filter = _selection is Confederation
        ? _selection! as Confederation
        : null;
    var confs = byConf.keys.toList()
      ..sort((a, b) {
        if (a == widget.playerConfederation) return -1;
        if (b == widget.playerConfederation) return 1;
        return a.index.compareTo(b.index);
      });
    if (filter != null) confs = confs.where((c) => c == filter).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.sm,
            AppSpacing.marginMobile,
            0,
          ),
          child: Row(
            children: [
              const Icon(Icons.public, size: 18, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: DropdownButton<Object?>(
                  value: _selection,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  items: [
                    DropdownMenuItem(
                      child: Text(l.tourCupAllConfederations),
                    ),
                    for (final c in regions)
                      DropdownMenuItem(
                        value: c,
                        child: Text(
                          c == widget.playerConfederation
                              ? l.tourCupRegionYours(c.label)
                              : c.label,
                        ),
                      ),
                  ],
                  onChanged: (v) => setState(() => _selection = v),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: _list(confs, byConf)),
      ],
    );
  }

  Widget _list(
    List<Confederation> confs,
    Map<Confederation, List<ConfederationGroupTable>> byConf,
  ) {
    final l = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        for (final conf in confs) ...[
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              bottom: AppSpacing.sm,
            ),
            child: Text(
              confederationLabel(l, conf).toUpperCase(),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          for (final g in _mineFirst(byConf[conf]!, widget.playerNationId)) ...[
            () {
              final adv = GroupAdvancement.worldCupQualifying(
                conf,
                byConf[conf]!.length,
              );
              return _GroupCard(
                group: g,
                playerNationId: widget.playerNationId,
                code: widget.code,
                name: widget.name,
                directCount: adv.direct,
                contentionPos: adv.contention,
              );
            }(),
            const SizedBox(height: AppSpacing.sm),
          ],
          // The cross-group ladder for the CONTESTED position — usually the
          // second-placed teams ranked against each other, but the group
          // WINNERS in a confederation with fewer berths than groups (Oceania
          // plays two groups for one place), exactly as a real qualifying table
          // reads.
          () {
            final ladder = _contentionLadder(conf, byConf[conf]!, l);
            if (ladder == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: BestThirdsCard(
                thirds: ladder.teams,
                qualifyCount: ladder.qualify,
                playerNationId: widget.playerNationId,
                code: widget.code,
                name: widget.name,
                title: ladder.title,
                destination: ladder.destination,
                adjustedForGroupSize: ladder.uneven,
              ),
            );
          }(),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

/// The intercontinental play-off ties, shown as a selector option under
/// qualifying — the two path finals decide the last two World Cup places. Kept
/// here (not only in the one-shot event) so the results stay accessible.
class _PlayoffList extends StatelessWidget {
  const _PlayoffList({
    required this.ties,
    required this.playerNationId,
    required this.code,
    required this.name,
  });

  final List<PlayoffTie> ties;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        Text(
          l.tourCupPlayoffIntro,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        IntercontinentalPlayoffBracket(
          ties: ties,
          code: code,
          name: name,
          playerNationId: playerNationId,
        ),
      ],
    );
  }
}

/// The cross-group ladder for the position a confederation's qualifying is
/// actually decided on: every group's team at that position, ranked, with how
/// many advance and to where. Returns null when there are too few groups to
/// form a ladder, or when nothing is contested.
({
  List<GroupStanding> teams,
  int qualify,
  String title,
  String destination,
  bool uneven,
})?
_contentionLadder(
  Confederation conf,
  List<ConfederationGroupTable> groups,
  AppLocalizations l,
) {
  if (groups.length < 2) return null;
  final fmt = QualificationFormat.forConfederation(conf);
  final adv = GroupAdvancement.worldCupQualifying(conf, groups.length);
  final pos = adv.contention;
  if (pos == null || adv.contentionQualify < 1) return null;
  final tables = [for (final g in groups) g.standings];
  final tier = crossGroupTier(tables, pos - 1);
  if (tier.isEmpty) return null;
  // Whether the places at this position lead to the finals, the play-off, or
  // both: a partly-filled tier of direct berths sends its best straight
  // through, and the play-off entrants come from just behind them.
  final directHere = fmt.directBerths % groups.length;
  final destination = directHere > 0
      ? (fmt.playoffEntrants > 0
            ? l.tourCupDestFinalsPlayoff
            : l.tourCupDestFinals)
      : l.tourCupDestIntercontPlayoff;
  return (
    teams: tier,
    qualify: directHere > 0 ? directHere : fmt.playoffEntrants,
    title: contentionLadderTitle(l, pos),
    destination: destination,
    uneven: CrossGroup.isUneven(tables),
  );
}

/// Orders a confederation's groups with the player's own group first, keeping
/// the rest in their existing order.
List<ConfederationGroupTable> _mineFirst(
  List<ConfederationGroupTable> groups,
  int playerNationId,
) {
  final mine = <ConfederationGroupTable>[];
  final others = <ConfederationGroupTable>[];
  for (final g in groups) {
    (g.standings.any((s) => s.nationId == playerNationId) ? mine : others).add(
      g,
    );
  }
  return [...mine, ...others];
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.group,
    required this.playerNationId,
    required this.code,
    required this.name,
    this.directCount = 2,
    this.contentionPos,
    this.matches = const [],
  });

  final ConfederationGroupTable group;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;

  /// Leading positions shown with a green "advancing" (guaranteed) marker.
  final int directCount;

  /// A single position marked amber — "in contention" (best runner-up / best
  /// third / play-off place), not yet safe. Null when there is no such spot.
  final int? contentionPos;

  /// The group's played matches, shown ABOVE the table in the same card.
  final List<Fixture> matches;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.tourCupGroupName(group.groupName),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (matches.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            for (final f in matches) MatchResultRow(fixture: f, code: code),
            const Divider(height: AppSpacing.lg),
          ],
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < group.standings.length; i++)
            _row(i + 1, group.standings[i]),
        ],
      ),
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
                color:
                    accent ??
                    (isPlayer ? AppColors.primary : AppColors.onSurfaceVariant),
                fontWeight: accent != null ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          FlagDisc(code(s.nationId), size: 22),
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
          // Goals for and against, not just the difference: a table that shows
          // only "+3" hides whether it was won 6:3 or 3:0.
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

class _FinalsGroups extends StatelessWidget {
  const _FinalsGroups({
    required this.groups,
    required this.groupFixtures,
    required this.playerNationId,
    required this.code,
    required this.name,
  });

  final List<FinalsGroupTable> groups;
  final List<Fixture> groupFixtures;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;

  bool _isMine(FinalsGroupTable g) =>
      g.standings.any((s) => s.nationId == playerNationId);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (groups.isEmpty) {
      return Center(child: Text(l.tourCupNoGroups));
    }

    // Every group's table and matches on one scrollable page — the manager's
    // own group first, then all the others in order, so nothing is a dropdown
    // click away.
    final mine = groups.where(_isMine).toList();
    final others = groups.where((g) => !_isMine(g)).toList();
    final ordered = [...mine, ...others];

    final tables = [for (final g in groups) g.standings];
    final uneven = CrossGroup.isUneven(tables);
    final thirds = crossGroupTier(tables, 2);
    final qualifyThirds = WorldCupFinals.bestThirdsFor(groups.length);

    List<Fixture> matchesOf(FinalsGroupTable g) {
      final ids = {for (final s in g.standings) s.nationId};
      return groupFixtures
          .where(
            (f) => ids.contains(f.homeNationId) && ids.contains(f.awayNationId),
          )
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        for (final g in ordered) ...[
          _GroupCard(
            group: (
              confederation: Confederation.europe,
              groupName: g.name,
              standings: g.standings,
            ),
            playerNationId: playerNationId,
            code: code,
            name: name,
            contentionPos: qualifyThirds > 0 ? 3 : null,
            matches: matchesOf(g),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (qualifyThirds > 0 && thirds.length > qualifyThirds) ...[
          BestThirdsCard(
            thirds: thirds,
            qualifyCount: qualifyThirds,
            playerNationId: playerNationId,
            code: code,
            name: name,
            adjustedForGroupSize: uneven,
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

/// The World Cup knockout rounds, for the bracket's list view.
const List<BracketRound> _rounds = [
  (WorldCupFinals.r32, 'Round of 32'),
  (WorldCupFinals.r16, 'Round of 16'),
  (WorldCupFinals.qf, 'Quarter-finals'),
  (WorldCupFinals.sf, 'Semi-finals'),
  (WorldCupFinals.third, 'Third place'),
  (WorldCupFinals.finalRound, 'Final'),
];

/// The main knockout ladder (excludes the third-place play-off, which hangs off
/// the side rather than feeding the final), for the visual bracket columns.
const List<BracketRound> _ladder = [
  (WorldCupFinals.r32, 'R32'),
  (WorldCupFinals.r16, 'R16'),
  (WorldCupFinals.qf, 'QF'),
  (WorldCupFinals.sf, 'SF'),
  (WorldCupFinals.finalRound, 'Final'),
];

/// The Golden Glove award: the finals' best goalkeeper.
class _Scorers extends StatefulWidget {
  const _Scorers({
    required this.qualifying,
    required this.finals,
    required this.allTime,
    required this.playerNames,
    required this.code,
  });

  final List<ScorerTally> qualifying;
  final List<ScorerTally> finals;

  /// All-time World Cup finals scorers across every cycle of this save, each
  /// flagged whether the player is still active.
  final List<AllTimeScorer> allTime;
  final Map<int, String> playerNames;
  final String Function(int) code;

  @override
  State<_Scorers> createState() => _ScorersState();
}

class _ScorersState extends State<_Scorers> {
  // 0 = qualifying, 1 = this edition's finals, 2 = all-time finals.
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final showAllTime = _tab == 2;
    // Unify the two chart shapes into rows of (rank, nation, name, goals,
    // active?), so all three tabs render the same way.
    final rows = showAllTime
        ? [
            for (final s in widget.allTime)
              (
                nationId: s.nationId,
                name: s.name,
                goals: s.goals,
                active: s.active,
              ),
          ]
        : [
            for (final s in (_tab == 1 ? widget.finals : widget.qualifying))
              (
                nationId: s.nationId,
                name: widget.playerNames[s.playerId] ?? l.tourCupUnknown,
                goals: s.goals,
                active: false,
              ),
          ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: SegmentedButton<int>(
            segments: [
              ButtonSegment(value: 0, label: Text(l.tourCupSegQualifying)),
              ButtonSegment(value: 1, label: Text(l.tourCupSegFinals)),
              ButtonSegment(value: 2, label: Text(l.tourCupSegAllTime)),
            ],
            selected: {_tab},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _tab = s.first),
          ),
        ),
        if (showAllTime)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.marginMobile,
              0,
              AppSpacing.marginMobile,
              AppSpacing.sm,
            ),
            child: const AllTimeScorersLegend(),
          ),
        if (rows.isEmpty)
          Expanded(
            child: _Soon(message: l.tourCupNoGoals),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.marginMobile,
              ),
              itemCount: rows.length,
              itemBuilder: (context, i) {
                final s = rows[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                      horizontal: AppSpacing.md,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text(
                            '${i + 1}',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        FlagDisc(widget.code(s.nationId), size: 24),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  s.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: s.active ? AppColors.positive : null,
                                    fontWeight: s.active
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (s.active) ...[
                                const SizedBox(width: AppSpacing.sm),
                                const ActiveBadge(),
                              ],
                            ],
                          ),
                        ),
                        Text(
                          '${s.goals}',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _History extends StatefulWidget {
  const _History({
    required this.honours,
    required this.name,
    required this.code,
  });

  final List<Honour> honours;
  final String Function(int) name;
  final String Function(int) code;

  @override
  State<_History> createState() => _HistoryState();
}

class _HistoryState extends State<_History> {
  static const _order = [
    'World Championship',
    'European Championship',
    'South America Cup',
  ];

  String? _competition;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (widget.honours.isEmpty) {
      return _Soon(message: l.tourCupNoHistory);
    }
    // The World Cup's history shows only World Cups — keep just the first
    // competition and drop the Europe / South America options (each continental
    // cup has its own detail screen with its own history).
    final comps = _order
        .where((c) => widget.honours.any((h) => h.competition == c))
        .take(1)
        .toList();
    final selected = _competition ?? (comps.isNotEmpty ? comps.first : null);
    final editions =
        widget.honours.where((h) => h.competition == selected).toList()
          ..sort((a, b) => b.year.compareTo(a.year));

    // Medal tally + records.
    final gold = <int, int>{};
    final silver = <int, int>{};
    final bronze = <int, int>{};
    for (final h in editions) {
      gold[h.championId] = (gold[h.championId] ?? 0) + 1;
      silver[h.runnerUpId] = (silver[h.runnerUpId] ?? 0) + 1;
      // Both bronze slots count — a cup with no third-place match shares the
      // bronze between its two beaten semi-finalists (thirdId + thirdId2).
      for (final b in [h.thirdId, h.thirdId2]) {
        if (b != null) bronze[b] = (bronze[b] ?? 0) + 1;
      }
    }
    final medalNations = {...gold.keys, ...silver.keys, ...bronze.keys}.toList()
      ..sort((a, b) {
        final g = (gold[b] ?? 0).compareTo(gold[a] ?? 0);
        if (g != 0) return g;
        final s = (silver[b] ?? 0).compareTo(silver[a] ?? 0);
        if (s != 0) return s;
        return (bronze[b] ?? 0).compareTo(bronze[a] ?? 0);
      });
    final mostTitles = medalNations.isEmpty ? null : medalNations.first;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        if (comps.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: SegmentedButton<String>(
              showSelectedIcon: false,
              segments: [
                for (final c in comps)
                  ButtonSegment(
                    value: c,
                    label: Text(
                      competitionLabel(l, c),
                    ),
                  ),
              ],
              selected: {selected!},
              onSelectionChanged: (s) => setState(() => _competition = s.first),
            ),
          ),

        // Records summary.
        if (mostTitles != null)
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.workspace_premium, color: AppColors.primary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.tourCupMostTitles,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        l.tourCupMostTitlesValue(
                          widget.name(mostTitles),
                          gold[mostTitles] ?? 0,
                          editions.length,
                        ),
                        style: AppTypography.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.md),

        // Medal table.
        Text(
          l.tourCupMedalTable,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: Column(
            children: [
              for (final id in medalNations.take(10))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      FlagDisc(widget.code(id), size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          widget.name(id),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall,
                        ),
                      ),
                      _medalCount('🥇', gold[id] ?? 0),
                      _medalCount('🥈', silver[id] ?? 0),
                      _medalCount('🥉', bronze[id] ?? 0),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Winners list.
        Text(
          l.tourCupPastWinners,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final h in editions) _editionCard(h),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _medalCount(String emoji, int n) => SizedBox(
    width: 34,
    child: Text(
      '$emoji$n',
      textAlign: TextAlign.center,
      style: AppTypography.labelSmall,
    ),
  );

  /// Every host of [h], falling back to the lone `Honour.hostId` for a row
  /// written before co-hosts were tracked as a list.
  List<int> _hostsOf(Honour h) =>
      h.hostIds.isNotEmpty ? h.hostIds : [if (h.hostId != null) h.hostId!];

  Widget _editionCard(Honour h) {
    final l = AppLocalizations.of(context);
    final score = (h.finalHomeScore != null && h.finalAwayScore != null)
        ? (h.finalHomeScore == h.finalAwayScore
              ? l.tourCupScorePens(h.finalHomeScore!, h.finalAwayScore!)
              : '${h.finalHomeScore}–${h.finalAwayScore}')
        : '';
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${h.year}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                if (_hostsOf(h).isNotEmpty)
                  Expanded(
                    child: Text(
                      _hostsOf(h).length == 1
                          ? l.tourCupHostLabel(widget.name(_hostsOf(h).single))
                          : l.tourCupHostLabelMulti(
                              _hostsOf(h).map(widget.code).join(' · '),
                            ),
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
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.sm),
                FlagDisc(widget.code(h.championId), size: 22),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    widget.name(h.championId),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(score, style: AppTypography.labelSmall),
                const SizedBox(width: AppSpacing.sm),
                FlagDisc(widget.code(h.runnerUpId), size: 18),
              ],
            ),
            // The beaten finalist, named — a bare flag left the runner-up
            // unreadable at a glance.
            const SizedBox(height: AppSpacing.xs),
            _podiumLine('🥈', h.runnerUpId),
            // Third place: the play-off winner, or BOTH beaten semi-finalists
            // for a cup with no third-place match. This card showed neither.
            for (final b in [h.thirdId, h.thirdId2])
              if (b != null) ...[
                const SizedBox(height: AppSpacing.xs),
                _podiumLine('🥉', b),
              ],
          ],
        ),
      ),
    );
  }

  /// One minor-medal line on an edition card: medal, flag and nation name.
  Widget _podiumLine(String medal, int nationId) => Row(
    children: [
      const SizedBox(width: 2),
      Text(medal, style: AppTypography.labelSmall),
      const SizedBox(width: AppSpacing.sm),
      FlagDisc(widget.code(nationId), size: 16),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Text(
          widget.name(nationId),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
    ],
  );
}

class _Soon extends StatelessWidget {
  const _Soon({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_empty, color: AppColors.outline),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
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
}
