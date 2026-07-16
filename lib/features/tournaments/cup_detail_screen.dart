import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';
import 'package:fnm/domain/services/competition/tournament_stars.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/features/tournaments/best_thirds.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';
import 'package:fnm/features/tournaments/tournament_bracket.dart';
import 'package:fnm/features/tournaments/tournament_history.dart';
import 'package:fnm/features/tournaments/venues_card.dart';
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
  static int _liveTab(CupData? data) {
    if (data == null) return 0;
    // The bracket, including once a champion is crowned.
    if (data.knockout.isNotEmpty) return 2;
    if (data.hasFinals && data.finalsDrawWatched) return 1; // finals groups
    return 0; // qualifying
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(cupDetailProvider(careerId));
    final liveTab = _liveTab(dataAsync.valueOrNull);

    return DefaultTabController(
      // Keyed by the landing tab because DefaultTabController reads
      // initialIndex once, in initState: the first build has no data yet, so
      // without this the index would be fixed at 0 before the stage is known.
      // A manual tab choice survives (the key only moves when the stage does).
      key: ValueKey(liveTab),
      length: 5,
      initialIndex: liveTab,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () =>
                context.go('${Routes.tournaments}?careerId=$careerId'),
          ),
          title: Text(
            'WORLD CHAMPIONSHIP',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          centerTitle: true,
          // The tabs sit right on top of the content otherwise; the extra
          // height gives them room to breathe.
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(kTournamentTabBarHeight),
            child: TabBar(
              isScrollable: true,
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: 'QUALIFYING'),
                Tab(text: 'FINALS'),
                Tab(text: 'BRACKET'),
                Tab(text: 'SCORERS'),
                Tab(text: 'HISTORY'),
              ],
            ),
          ),
        ),
        body: dataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Could not load cup.\n$e')),
          data: (data) {
            if (data == null) return const Center(child: Text('No cup data.'));
            String code(int id) => data.nations[id]?.code ?? '??';
            String name(int id) => data.nations[id]?.name ?? 'Unknown';

            return Column(
              children: [
                if (data.hostId != null)
                  _HostBar(
                    hosts: [
                      for (final h
                          in (data.hostIds.isEmpty
                              ? [data.hostId!]
                              : data.hostIds))
                        (code: code(h), name: name(h)),
                    ],
                  ),
                Expanded(
                  child: TabBarView(
                    children: [
                      if (!data.qualDrawWatched)
                        const _Soon(
                          message:
                              'Groups to be drawn — watch the qualifying '
                              'draw from the hub to reveal them.',
                        )
                      else
                        _Qualifying(
                          groups: data.groups,
                          playerConfederation: data.playerConfederation,
                          playerNationId: data.playerNationId,
                          code: code,
                          name: name,
                        ),
                      if (data.hasFinals && !data.finalsDrawWatched)
                        const _Soon(
                          message:
                              'Groups to be drawn — watch the World Cup '
                              'draw from the hub to reveal them.',
                        )
                      else if (data.hasFinals)
                        _FinalsGroups(
                          groups: data.finalsGroups,
                          playerNationId: data.playerNationId,
                          hostIds: data.hostIds,
                          hostCities: data.hostCities,
                          code: code,
                          name: name,
                        )
                      else
                        const _Soon(
                          message: 'The finals are drawn once qualifying ends.',
                        ),
                      if (data.knockout.isNotEmpty)
                        TournamentBracket(
                          fixtures: data.knockout,
                          rounds: _rounds,
                          ladder: _ladder,
                          champion: data.champion,
                          championLabel: 'WORLD CHAMPIONS',
                          playerNationId: data.playerNationId,
                          runSummary: playerRunSummary(
                            playerNationId: data.playerNationId,
                            champion: data.champion,
                            knockout: data.knockout,
                            groups: data.finalsGroups,
                            championTitle: 'World Champions! 🏆',
                          ),
                          extraHeader: data.teamOfTournament.isEmpty
                              ? null
                              : _TeamOfTournament(
                                  stars: data.teamOfTournament,
                                  code: code,
                                  name: name,
                                ),
                          groupSeeds: groupSeedsOf(data.finalsGroups),
                          code: code,
                          name: name,
                        )
                      else
                        const _Soon(
                          message:
                              'The knockout bracket begins after the '
                              'finals group stage.',
                        ),
                      // The Golden Glove goes INSIDE the scorers tab: as a sibling it
                      // was a sixth child of a five-tab view, shifting scorers into
                      // the history slot whenever a keeper won it.
                      _Scorers(
                        qualifying: data.scorersQualifying,
                        finals: data.scorersFinals,
                        playerNames: data.playerNames,
                        code: code,
                        header: data.goldenGlove == null
                            ? null
                            : _GoldenGloveCard(
                                name: data.goldenGlove!.name,
                                nation: name(data.goldenGlove!.nationId),
                                code: code(data.goldenGlove!.nationId),
                              ),
                      ),
                      // Not the shared TournamentHistory: the World Cup screen's
                      // history browses every competition, not just its own.
                      _History(honours: data.honours, name: name, code: code),
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

/// A slim banner naming the World Cup host nation (shown across the cup tabs).
class _HostBar extends StatelessWidget {
  const _HostBar({required this.hosts});

  final List<({String code, String name})> hosts;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surfaceContainerHigh,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.marginMobile,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          const Icon(Icons.stadium_rounded, size: 16, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Text(
            hosts.length > 1 ? 'HOSTS' : 'HOST',
            style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: 4,
              children: [
                for (final h in hosts)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FlagDisc(h.code, size: 18),
                      const SizedBox(width: AppSpacing.xs),
                      Text(h.name, style: AppTypography.labelMedium),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
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
  Confederation? _filter;

  @override
  Widget build(BuildContext context) {
    if (widget.groups.isEmpty) {
      return const Center(child: Text('No groups drawn.'));
    }
    final byConf = <Confederation, List<ConfederationGroupTable>>{};
    for (final g in widget.groups) {
      (byConf[g.confederation] ??= []).add(g);
    }
    var confs = byConf.keys.toList()
      ..sort((a, b) {
        if (a == widget.playerConfederation) return -1;
        if (b == widget.playerConfederation) return 1;
        return a.index.compareTo(b.index);
      });
    if (_filter != null) confs = confs.where((c) => c == _filter).toList();

    return Column(
      children: [
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.marginMobile,
            ),
            children: [
              _regionChip('ALL', _filter == null, () {
                setState(() => _filter = null);
              }),
              for (final c
                  in byConf.keys.toList()
                    ..sort((a, b) => a.index.compareTo(b.index)))
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.sm),
                  child: _regionChip(
                    c.label.toUpperCase(),
                    _filter == c,
                    () => setState(() => _filter = c),
                  ),
                ),
            ],
          ),
        ),
        Expanded(child: _list(confs, byConf)),
      ],
    );
  }

  Widget _regionChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: active
              ? AppColors.secondaryContainer
              : AppColors.surfaceContainer,
          borderRadius: AppRadii.xlAll,
          border: Border.all(
            color: active ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: active
                ? AppColors.onSecondaryContainer
                : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _list(
    List<Confederation> confs,
    Map<Confederation, List<ConfederationGroupTable>> byConf,
  ) {
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
              conf.label.toUpperCase(),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          for (final g in _mineFirst(byConf[conf]!, widget.playerNationId)) ...[
            () {
              final adv = _qualAdvance(conf, byConf[conf]!.length);
              return _GroupCard(
                group: g,
                playerNationId: widget.playerNationId,
                code: widget.code,
                name: widget.name,
                directCount: adv.direct,
                contentionPos: adv.contention,
                caption: GroupAdvancement.caption(
                  kind: CompetitionKind.worldCupQualifying,
                  adv: (
                    direct: adv.direct,
                    contention: adv.contention,
                    relegate: 0,
                  ),
                ),
              );
            }(),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

/// How a confederation's qualifying group resolves, from its real World Cup
/// berths and how many groups it plays: how many advance directly (green) and
/// which single position is still "in contention" (amber — best runner-up /
/// play-off). A single-league confederation (CONMEBOL) shows its top N direct.
({int direct, int? contention}) _qualAdvance(
  Confederation conf,
  int groupCount,
) {
  final fmt = QualificationFormat.forConfederation(conf);
  final groups = groupCount < 1 ? 1 : groupCount;
  final direct = (fmt.directBerths ~/ groups).clamp(1, 99);
  final leftover = fmt.directBerths - direct * groups; // via best runners-up
  final hasContention = leftover > 0 || fmt.playoffEntrants > 0;
  return (direct: direct, contention: hasContention ? direct + 1 : null);
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
    this.caption = '',
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

  /// A plain-English note on what qualifies from the group.
  final String caption;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GROUP ${group.groupName}',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < group.standings.length; i++)
            _row(i + 1, group.standings[i]),
          if (caption.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              caption,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
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
          _cell(gd > 0 ? '+$gd' : '$gd'),
          _cell('${s.points}', emphasize: true),
        ],
      ),
    );
  }

  Widget _cell(String text, {bool emphasize = false}) => SizedBox(
    width: 30,
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
    required this.playerNationId,
    required this.hostIds,
    required this.hostCities,
    required this.code,
    required this.name,
  });

  final List<FinalsGroupTable> groups;
  final int playerNationId;

  /// Every host, primary first — a World Cup can be shared.
  final List<int> hostIds;
  final Map<int, List<String>> hostCities;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    final thirds = [
      for (final g in groups)
        if (g.standings.length > 2) g.standings[2],
    ]..sort(rankStandings);
    final qualifyThirds = WorldCupFinals.bestThirdsFor(groups.length);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        if (hostIds.isNotEmpty) ...[
          () {
            final byHost = VenueGenerator.forHosts(
              hostIds: hostIds,
              citiesByHost: hostCities,
            );
            return VenuesCard(
              hosts: [
                for (final h in hostIds)
                  (code: code(h), name: name(h), venues: byHost[h] ?? const []),
              ],
            );
          }(),
          const SizedBox(height: AppSpacing.sm),
        ],
        for (final g in groups) ...[
          _GroupCard(
            group: (
              confederation: Confederation.europe,
              groupName: g.name,
              standings: g.standings,
            ),
            playerNationId: playerNationId,
            code: code,
            name: name,
            // Finals groups: top two advance, best thirds are in contention.
            contentionPos: qualifyThirds > 0 ? 3 : null,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (qualifyThirds > 0 && thirds.length > qualifyThirds) ...[
          const SizedBox(height: AppSpacing.sm),
          BestThirdsCard(
            thirds: thirds,
            qualifyCount: qualifyThirds,
            playerNationId: playerNationId,
            code: code,
            name: name,
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
class _GoldenGloveCard extends StatelessWidget {
  const _GoldenGloveCard({
    required this.name,
    required this.nation,
    required this.code,
  });

  final String name;
  final String nation;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: AppCard(
        child: Row(
          children: [
            const Icon(Icons.sports_mma, color: AppColors.primary, size: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GOLDEN GLOVE',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(name, style: AppTypography.bodyLarge),
                ],
              ),
            ),
            FlagDisc(code, size: 22),
            const SizedBox(width: AppSpacing.sm),
            Text(
              nation,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The Team of the Tournament: the best XI, grouped by line.
class _TeamOfTournament extends StatelessWidget {
  const _TeamOfTournament({
    required this.stars,
    required this.code,
    required this.name,
  });

  final List<StarPlayer> stars;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    List<StarPlayer> line(PositionCategory c) =>
        stars.where((s) => s.position.category == c).toList();
    const order = [
      PositionCategory.goalkeeper,
      PositionCategory.defender,
      PositionCategory.midfielder,
      PositionCategory.forward,
    ];
    return AppCard(
      color: AppColors.secondaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'TEAM OF THE TOURNAMENT',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final cat in order)
            for (final s in line(cat)) _row(s),
        ],
      ),
    );
  }

  Widget _row(StarPlayer s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 34, child: TacticalChip(s.position.label)),
          const SizedBox(width: AppSpacing.sm),
          FlagDisc(code(s.nationId), size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              s.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall,
            ),
          ),
          if (s.goals > 0) ...[
            const Icon(Icons.sports_soccer, size: 12, color: AppColors.primary),
            const SizedBox(width: 2),
            Text('${s.goals}', style: AppTypography.labelSmall),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            '${s.overall}',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _Scorers extends StatefulWidget {
  const _Scorers({
    required this.qualifying,
    required this.finals,
    required this.playerNames,
    required this.code,
    this.header,
  });

  final List<ScorerTally> qualifying;
  final List<ScorerTally> finals;
  final Map<int, String> playerNames;
  final String Function(int) code;

  /// Shown above the chart — the Golden Glove belongs with the other awards,
  /// not as a tab of its own.
  final Widget? header;

  @override
  State<_Scorers> createState() => _ScorersState();
}

class _ScorersState extends State<_Scorers> {
  bool _finals = false;

  @override
  Widget build(BuildContext context) {
    final list = _finals ? widget.finals : widget.qualifying;
    return Column(
      children: [
        if (widget.header != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.marginMobile,
              AppSpacing.marginMobile,
              AppSpacing.marginMobile,
              0,
            ),
            child: widget.header,
          ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Qualifying')),
              ButtonSegment(value: true, label: Text('Finals')),
            ],
            selected: {_finals},
            onSelectionChanged: (s) => setState(() => _finals = s.first),
          ),
        ),
        if (list.isEmpty)
          const Expanded(
            child: _Soon(message: 'No goals scored yet.'),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.marginMobile,
              ),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final s = list[i];
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
                          child: Text(
                            widget.playerNames[s.playerId] ?? 'Unknown',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodyMedium,
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
    if (widget.honours.isEmpty) {
      return const _Soon(message: 'No tournament history yet.');
    }
    final comps = _order
        .where((c) => widget.honours.any((h) => h.competition == c))
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
      if (h.thirdId != null) {
        bronze[h.thirdId!] = (bronze[h.thirdId!] ?? 0) + 1;
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
                      switch (c) {
                        'World Championship' => 'World',
                        'European Championship' => 'Europe',
                        _ => 'S. America',
                      },
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
                        'MOST TITLES',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '${widget.name(mostTitles)} · '
                        '${gold[mostTitles]} · ${editions.length} editions',
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
          'MEDAL TABLE',
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
          'PAST WINNERS',
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

  Widget _editionCard(Honour h) {
    final score = (h.finalHomeScore != null && h.finalAwayScore != null)
        ? (h.finalHomeScore == h.finalAwayScore
              ? '${h.finalHomeScore}–${h.finalAwayScore} (pens)'
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
                const Spacer(),
                if (h.hostId != null)
                  Text(
                    'Host: ${widget.name(h.hostId!)}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
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
          ],
        ),
      ),
    );
  }
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
