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
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

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

  static const List<(String, String)> _bracketRounds = [
    ('CR16', 'Round of 16'),
    ('CQF', 'Quarter-finals'),
    ('CSF', 'Semi-finals'),
    ('C3RD', 'Third place'),
    ('CFINAL', 'Final'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(
      continentalDetailProvider((
        careerId: careerId,
        confederation: confederation,
      )),
    );

    final canWatchDraw = dataAsync.maybeWhen(
      data: (d) => d != null && d.groups.isNotEmpty,
      orElse: () => false,
    );
    final canWatchQualiDraw = dataAsync.maybeWhen(
      data: (d) => d != null && d.qualifyingGroups.isNotEmpty,
      orElse: () => false,
    );

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
            dataAsync.maybeWhen(
              data: (d) => d?.name.toUpperCase() ?? 'CHAMPIONSHIP',
              orElse: () => 'CHAMPIONSHIP',
            ),
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          centerTitle: true,
          actions: [
            if (canWatchQualiDraw)
              IconButton(
                icon: const Icon(Icons.shuffle, color: AppColors.primary),
                tooltip: 'Watch the qualifying draw',
                onPressed: () => context.go(
                  '${Routes.continentalDraw}?careerId=$careerId'
                  '&conf=${confederation.name}&stage=qualifying',
                ),
              ),
            if (canWatchDraw)
              IconButton(
                icon: const Icon(Icons.casino, color: AppColors.primary),
                tooltip: 'Watch the finals draw',
                onPressed: () => context.go(
                  '${Routes.continentalDraw}?careerId=$careerId'
                  '&conf=${confederation.name}',
                ),
              ),
          ],
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
            if (data == null) {
              return const Center(child: Text('No cup data.'));
            }
            String code(int id) => data.nations[id]?.code ?? '??';
            String name(int id) => data.nations[id]?.name ?? 'Unknown';

            return TabBarView(
              children: [
                if (data.qualifyingGroups.isNotEmpty)
                  _Groups(
                    groups: data.qualifyingGroups,
                    playerNationId: data.playerNationId,
                    code: code,
                    name: name,
                    onViewDraw: () => context.go(
                      '${Routes.qualifyingDraw}?careerId=$careerId'
                      '&worldCup=false',
                    ),
                  )
                else
                  _Soon(
                    message: data.isPlayerRegion
                        ? 'Qualifying is seeded by ranking this cycle.'
                        : 'Only your own confederation is played in detail. '
                            '${data.name} is decided in the background — see '
                            'its winners under History.',
                  ),
                if (data.groups.isNotEmpty)
                  _Groups(
                    groups: data.groups,
                    playerNationId: data.playerNationId,
                    code: code,
                    name: name,
                  )
                else
                  _Soon(
                    message: data.isPlayerRegion
                        ? 'The finals draw happens once qualifying ends.'
                        : 'Only your own confederation is played in detail. '
                            '${data.name} is decided in the background — see '
                            'its winners under History.',
                  ),
                if (data.knockout.isNotEmpty)
                  _Bracket(
                    fixtures: data.knockout,
                    champion: data.champion,
                    championLabel: data.name,
                    playerNationId: data.playerNationId,
                    rounds: _bracketRounds,
                    code: code,
                    name: name,
                  )
                else
                  _Soon(
                    message: data.isPlayerRegion
                        ? 'Your continental championship is contested in the '
                            'season before the World Cup.'
                        : 'Only your own confederation is played in detail. '
                            '${data.name} is decided in the background — see '
                            'its winners under History.',
                  ),
                if (data.scorers.isEmpty)
                  const _Soon(message: 'No goals recorded yet.')
                else
                  _Scorers(
                    scorers: data.scorers,
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

class _Groups extends StatelessWidget {
  const _Groups({
    required this.groups,
    required this.playerNationId,
    required this.code,
    required this.name,
    this.onViewDraw,
  });

  final List<FinalsGroupTable> groups;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;
  final VoidCallback? onViewDraw;

  /// Top two of each group advance to the knockout.
  static const _advance = 2;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        if (onViewDraw != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onViewDraw,
              icon: const Icon(Icons.casino, size: 18),
              label: const Text('View qualifying draw'),
            ),
          ),
        for (final g in groups) ...[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GROUP ${g.name}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                for (var i = 0; i < g.standings.length; i++)
                  _row(i + 1, g.standings[i]),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _row(int pos, GroupStanding s) {
    final isPlayer = s.nationId == playerNationId;
    final advancing = pos <= _advance;
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
                    : AppColors.onSurfaceVariant,
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

class _Bracket extends StatelessWidget {
  const _Bracket({
    required this.fixtures,
    required this.champion,
    required this.championLabel,
    required this.playerNationId,
    required this.rounds,
    required this.code,
    required this.name,
  });

  final List<Fixture> fixtures;
  final int? champion;
  final String championLabel;
  final int playerNationId;
  final List<(String, String)> rounds;
  final String Function(int) code;
  final String Function(int) name;

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
                        'CHAMPIONS',
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
        for (final (round, label) in rounds)
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

class _Scorers extends StatelessWidget {
  const _Scorers({
    required this.scorers,
    required this.playerNames,
    required this.code,
  });

  final List<ScorerTally> scorers;
  final Map<int, String> playerNames;
  final String Function(int) code;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      itemCount: scorers.length,
      itemBuilder: (context, i) {
        final s = scorers[i];
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
                FlagDisc(code(s.nationId), size: 24),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    playerNames[s.playerId] ?? 'Unknown',
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
      return const _Soon(message: 'No past winners yet.');
    }

    final gold = <int, int>{};
    final silver = <int, int>{};
    final bronze = <int, int>{};
    for (final h in honours) {
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

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
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
                      FlagDisc(code(id), size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          name(id),
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
        Text(
          'PAST WINNERS',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final h in honours) _editionCard(h),
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
                  style: AppTypography.labelMedium
                      .copyWith(color: AppColors.primary),
                ),
                const Spacer(),
                if (h.hostId != null)
                  Text(
                    'Host: ${name(h.hostId!)}',
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.onSurfaceVariant),
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
                FlagDisc(code(h.championId), size: 22),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    name(h.championId),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(score, style: AppTypography.labelSmall),
                const SizedBox(width: AppSpacing.sm),
                FlagDisc(code(h.runnerUpId), size: 18),
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
