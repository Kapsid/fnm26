import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// World Championship detail: the qualifying group stage for every
/// confederation (your region first), plus knockout/stats/history tabs that
/// arrive with the finals.
class CupDetailScreen extends ConsumerWidget {
  const CupDetailScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(cupDetailProvider(careerId));

    return DefaultTabController(
      length: 5,
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
          bottom: const TabBar(
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
        body: dataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Could not load cup.\n$e')),
          data: (data) {
            if (data == null) return const Center(child: Text('No cup data.'));
            String code(int id) => data.nations[id]?.code ?? '??';
            String name(int id) => data.nations[id]?.name ?? 'Unknown';

            return TabBarView(
              children: [
                _Qualifying(
                  groups: data.groups,
                  playerConfederation: data.playerConfederation,
                  playerNationId: data.playerNationId,
                  code: code,
                  name: name,
                ),
                if (data.hasFinals)
                  _FinalsGroups(
                    groups: data.finalsGroups,
                    playerNationId: data.playerNationId,
                    code: code,
                    name: name,
                    onWatchDraw: () =>
                        context.go('${Routes.finalsDraw}?careerId=$careerId'),
                  )
                else
                  const _Soon(
                    message: 'The finals are drawn once qualifying ends.',
                  ),
                if (data.knockout.isNotEmpty)
                  _Bracket(
                    fixtures: data.knockout,
                    champion: data.champion,
                    playerNationId: data.playerNationId,
                    code: code,
                    name: name,
                  )
                else
                  const _Soon(
                    message:
                        'The knockout bracket begins after the '
                        'finals group stage.',
                  ),
                _Scorers(
                  qualifying: data.scorersQualifying,
                  finals: data.scorersFinals,
                  playerNames: data.playerNames,
                  code: code,
                ),
                _History(honours: data.honours, name: name, code: code),
              ],
            );
          },
        ),
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
              for (final c in byConf.keys.toList()
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
            child: Row(
              children: [
                Text(
                  conf.label.toUpperCase(),
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                if (conf == widget.playerConfederation) ...[
                  const SizedBox(width: AppSpacing.sm),
                  const TacticalChip('YOUR REGION', emphasized: true),
                ],
              ],
            ),
          ),
          for (final g in byConf[conf]!) ...[
            _GroupCard(
              group: g,
              playerNationId: widget.playerNationId,
              code: widget.code,
              name: widget.name,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.group,
    required this.playerNationId,
    required this.code,
    required this.name,
  });

  final ConfederationGroupTable group;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;

  /// Leading positions shown with a green "advancing" marker.
  static const advanceCount = 2;

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
        ],
      ),
    );
  }

  Widget _row(int pos, GroupStanding s) {
    final isPlayer = s.nationId == playerNationId;
    final advancing = pos <= advanceCount;
    final gd = s.goalDifference;
    return Container(
      decoration: BoxDecoration(
        color: isPlayer ? AppColors.surfaceContainerHigh : null,
        border: Border(
          left: BorderSide(
            color: advancing ? AppColors.positive : Colors.transparent,
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
                color: advancing
                    ? AppColors.positive
                    : (isPlayer
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant),
                fontWeight: advancing ? FontWeight.w700 : FontWeight.w500,
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
    required this.code,
    required this.name,
    required this.onWatchDraw,
  });

  final List<FinalsGroupTable> groups;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;
  final VoidCallback onWatchDraw;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onWatchDraw,
            icon: const Icon(Icons.casino, size: 18),
            label: const Text('Watch the draw'),
          ),
        ),
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
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _Bracket extends StatelessWidget {
  const _Bracket({
    required this.fixtures,
    required this.champion,
    required this.playerNationId,
    required this.code,
    required this.name,
  });

  final List<Fixture> fixtures;
  final int? champion;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;

  static const List<(String, String)> _rounds = [
    (WorldCupFinals.r16, 'Round of 16'),
    (WorldCupFinals.qf, 'Quarter-finals'),
    (WorldCupFinals.sf, 'Semi-finals'),
    (WorldCupFinals.third, 'Third place'),
    (WorldCupFinals.finalRound, 'Final'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        if (champion != null)
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: AppColors.primary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WORLD CHAMPIONS',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(name(champion!), style: AppTypography.titleMedium),
                    ],
                  ),
                ),
                FlagDisc(code(champion!), size: 40, highlighted: true),
              ],
            ),
          ),
        for (final (round, label) in _rounds) ...[
          () {
            final inRound = fixtures.where((f) => f.round == round).toList();
            if (inRound.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final f in inRound) _tie(f),
                ],
              ),
            );
          }(),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _tie(Fixture f) {
    final decided = f.hasResult;
    final homeWon = decided && f.homeScore! >= f.awayScore!;
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(child: _side(f.homeNationId, decided && homeWon)),
          Text(
            decided ? '${f.homeScore} - ${f.awayScore}' : 'vs',
            style: AppTypography.labelMedium,
          ),
          Expanded(
            child: _side(f.awayNationId, decided && !homeWon, end: true),
          ),
        ],
      ),
    );
  }

  Widget _side(int nationId, bool winner, {bool end = false}) {
    final isPlayer = nationId == playerNationId;
    final label = Flexible(
      child: Text(
        name(nationId),
        textAlign: end ? TextAlign.end : TextAlign.start,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.bodySmall.copyWith(
          fontWeight: winner || isPlayer ? FontWeight.w700 : FontWeight.w400,
          color: winner ? AppColors.onSurface : AppColors.onSurfaceVariant,
        ),
      ),
    );
    final flag = FlagDisc(code(nationId), size: 22, highlighted: isPlayer);
    final children = end
        ? [label, const SizedBox(width: AppSpacing.sm), flag]
        : [flag, const SizedBox(width: AppSpacing.sm), label];
    return Row(
      mainAxisAlignment: end ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: children,
    );
  }
}

class _Scorers extends StatefulWidget {
  const _Scorers({
    required this.qualifying,
    required this.finals,
    required this.playerNames,
    required this.code,
  });

  final List<ScorerTally> qualifying;
  final List<ScorerTally> finals;
  final Map<int, String> playerNames;
  final String Function(int) code;

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

class _History extends StatelessWidget {
  const _History({
    required this.honours,
    required this.name,
    required this.code,
  });

  final List<Honour> honours;
  final String Function(int) name;
  final String Function(int) code;

  @override
  Widget build(BuildContext context) {
    if (honours.isEmpty) {
      return const _Soon(
        message: 'No tournaments completed yet. Winners are recorded here as '
            'each World Championship is decided.',
      );
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        for (final h in honours)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${h.year} · ${h.competition}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _medal(
                    Icons.emoji_events,
                    AppColors.primary,
                    'Champions',
                    h.championId,
                  ),
                  _medal(
                    Icons.military_tech,
                    AppColors.onSurfaceVariant,
                    'Runners-up',
                    h.runnerUpId,
                  ),
                  if (h.thirdId != null)
                    _medal(
                      Icons.workspace_premium,
                      AppColors.outline,
                      'Third',
                      h.thirdId!,
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _medal(IconData icon, Color color, String label, int nationId) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          FlagDisc(code(nationId), size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name(nationId),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
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
