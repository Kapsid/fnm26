import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';
import 'package:fnm/features/tournaments/tournament_history.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

typedef _NcView = ({
  String playerLeague,
  String? playerGroup,
  List<FinalsGroupTable> groups,
  List<Fixture> semis,
  List<Fixture> finalFx,
  List<Honour> honours,
  List<ScorerTally> scorers,
  Map<int, String> playerNames,
  bool drawWatched,
  int playerNationId,
  Map<int, Nation> nations,

  /// The lowest league in the player's confederation — its bottom sides have
  /// nowhere to fall, so they aren't shown as relegated.
  int maxTier,
});

final AutoDisposeFutureProviderFamily<_NcView?, int>
_nationsCupProvider = FutureProvider.autoDispose.family<_NcView?, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  final groups =
      await comp.tournamentGroupTables(
          careerId,
          CompetitionKind.nationsLeague,
        )
        ..sort((a, b) => a.name.compareTo(b.name));
  final tiers = await ref
      .watch(careerRepositoryProvider)
      .nationsCupTiers(careerId);
  final playerLeague = String.fromCharCode(65 + (tiers[career.nationId] ?? 0));
  // The group the manager's nation plays in (for "my group first").
  String? playerGroup;
  for (final g in groups) {
    if (g.standings.any((s) => s.nationId == career.nationId)) {
      playerGroup = g.name;
      break;
    }
  }
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  final honours = [
    for (final h in await comp.honours(careerId))
      if (h.competition == 'Nations Cup') h,
  ]..sort((a, b) => b.year.compareTo(a.year));
  // The Finals Four: League A's group winners contest two semis then a final.
  final semis = await comp.fixturesByRound(
    careerId,
    'NSF',
    kind: CompetitionKind.nationsLeague,
  );
  final finalFx = await comp.fixturesByRound(
    careerId,
    'NFINAL',
    kind: CompetitionKind.nationsLeague,
  );
  final drawWatched = await comp.hasWatchedDraw(
    careerId,
    career.cyclePointer,
    nationsCupDrawKind,
  );
  final conf = nations[career.nationId]?.confederation ?? Confederation.europe;
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
    limit: 15,
  );
  final playerRepo = ref.watch(playerRepositoryProvider);
  final playerNames = <int, String>{};
  for (final id in {for (final s in scorers) s.playerId}) {
    final p = await playerRepo.byId(id, saveSeed: career.rngSeed);
    if (p != null) playerNames[id] = p.name;
  }

  return (
    playerLeague: playerLeague,
    playerGroup: playerGroup,
    groups: groups,
    semis: semis,
    finalFx: finalFx,
    honours: honours,
    scorers: scorers,
    playerNames: playerNames,
    drawWatched: drawWatched,
    playerNationId: career.nationId,
    nations: nations,
    maxTier: maxTier,
  );
});

/// The Nations Cup: the manager's league group standings by default (their own
/// group first), with a selector to browse the other leagues.
class NationsCupScreen extends ConsumerStatefulWidget {
  const NationsCupScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<NationsCupScreen> createState() => _NationsCupScreenState();
}

class _NationsCupScreenState extends ConsumerState<NationsCupScreen> {
  String? _league; // selected league letter (null → the player's own league)

  /// The tab to land on: wherever the cup actually is.
  static int _liveTab(_NcView? v) {
    if (v == null) return 0;
    // The Finals Four is the business end — go there once it's drawn.
    if (v.semis.isNotEmpty || v.finalFx.isNotEmpty) return 1;
    // Out of season there are no tables to show, so the honours are the point.
    if (v.groups.isEmpty) return 3;
    return 0; // leagues
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(_nationsCupProvider(widget.careerId));
    final liveTab = _liveTab(async.valueOrNull);
    return DefaultTabController(
      // See CupDetailScreen: initialIndex is read once, before the data lands.
      key: ValueKey(liveTab),
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
          title: Text(
            l.tourContNationsCup,
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
                Tab(text: l.tourContTabLeagues),
                Tab(text: l.tourContTabFinalsFour),
                Tab(text: l.tourContTabScorers),
                Tab(text: l.tourContTabHistory),
              ],
            ),
          ),
        ),
        body: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l.tourContCouldNotLoad(e.toString()))),
          data: (v) {
            if (v == null) {
              return Center(child: Text(l.tourContNoSaveFound));
            }
            String name(int id) => v.nations[id]?.name ?? l.tourContUnknown;
            String code(int id) => v.nations[id]?.code ?? '??';

            return TabBarView(
              children: [
                _leagues(v, name, code),
                _finalsFour(v, name, code),
                TournamentScorers(
                  scorers: v.scorers,
                  playerNames: v.playerNames,
                  code: code,
                  emptyMessage: l.tourContNoNationsCupGoals,
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

  /// The league tables, or why there aren't any yet.
  Widget _leagues(
    _NcView v,
    String Function(int) name,
    String Function(int) code,
  ) {
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

    // Leagues present, in order (A, B, C…).
    final leagues = {for (final g in v.groups) g.name[0]}.toList()..sort();
    final selected = _league ?? v.playerLeague;

    // Groups of the selected league; the player's own group first when it's
    // their league.
    final shown = v.groups.where((g) => g.name[0] == selected).toList()
      ..sort((a, b) {
        if (a.name == v.playerGroup) return -1;
        if (b.name == v.playerGroup) return 1;
        return a.name.compareTo(b.name);
      });

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        if (leagues.length > 1)
          _LeagueSelector(
            leagues: leagues,
            selected: selected,
            playerLeague: v.playerLeague,
            onSelect: (l) => setState(() => _league = l),
          ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          selected == v.playerLeague
              ? l.tourContLeagueHeadingYours(selected)
              : l.tourContLeagueHeading(selected),
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final g in shown) ...[
          _GroupCard(
            group: g,
            playerNationId: v.playerNationId,
            name: name,
            code: code,
            isLowestLeague: NationsCup.tierOfGroupName(g.name) >= v.maxTier,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  /// The Finals Four: League A's group winners contest two semis and a final.
  Widget _finalsFour(
    _NcView v,
    String Function(int) name,
    String Function(int) code,
  ) {
    final l = AppLocalizations.of(context);
    if (v.semis.isEmpty && v.finalFx.isEmpty) {
      return TournamentSoon(
        message: l.tourContFinalsFourSoon,
      );
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        _FinalsFourCard(
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

class _LeagueSelector extends StatelessWidget {
  const _LeagueSelector({
    required this.leagues,
    required this.selected,
    required this.playerLeague,
    required this.onSelect,
  });

  final List<String> leagues;
  final String selected;
  final String playerLeague;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final l in leagues)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: GestureDetector(
                onTap: () => onSelect(l),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: l == selected
                        ? AppColors.secondaryContainer
                        : AppColors.surfaceContainer,
                    borderRadius: AppRadii.xlAll,
                    border: Border.all(
                      color: l == selected
                          ? AppColors.primary
                          : AppColors.outlineVariant,
                    ),
                  ),
                  child: Text(
                    l == playerLeague
                        ? loc.tourContLeagueChipStar(l)
                        : loc.tourContLeagueChip(l),
                    style: AppTypography.labelSmall.copyWith(
                      color: l == selected
                          ? AppColors.onSecondaryContainer
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
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
    required this.playerNationId,
    required this.name,
    required this.code,
    required this.isLowestLeague,
  });

  final FinalsGroupTable group;
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
          Text(l.tourContGroupHeading(group.name),
              style: AppTypography.labelMedium),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < group.standings.length; i++)
            _row(i + 1, group.standings[i], group.standings.length),
        ],
      ),
    );
  }

  Widget _row(int pos, GroupStanding s, int total) {
    final isPlayer = s.nationId == playerNationId;
    // Winner (green) is promoted; the bottom side (red) relegated. Shared with
    // the hub's group table so the two never disagree.
    final adv = GroupAdvancement.forGroup(
      kind: CompetitionKind.nationsLeague,
      confederation: Confederation.europe, // unused for the Nations Cup
      groupCount: 1,
      continentalSize: 0,
      isLowestLeague: isLowestLeague,
    );
    final zone = pos <= adv.direct
        ? AppColors.positive
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

/// The Nations Cup Finals Four bracket: the two semi-finals and the final,
/// with results once played — so the climax is visible whether or not the
/// manager's nation reached it.
class _FinalsFourCard extends StatelessWidget {
  const _FinalsFourCard({
    required this.semis,
    required this.finalFx,
    required this.playerNationId,
    required this.name,
    required this.code,
  });

  final List<Fixture> semis;
  final List<Fixture> finalFx;
  final int playerNationId;
  final String Function(int) name;
  final String Function(int) code;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, size: 16, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(l.tourContTabFinalsFour, style: AppTypography.labelMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.tourContSemiFinals,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final f in semis) _tie(f, l),
          if (finalFx.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l.tourContFinal,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
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
