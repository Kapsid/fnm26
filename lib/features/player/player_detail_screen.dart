import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/routing/back_navigation.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/theme/rating_colors.dart';
import 'package:fnm/core/util/squad_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/club/club_form.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/features/tactics/condition_mark.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/features/tactics/player_form_look.dart';
import 'package:fnm/features/tactics/call_up_screen.dart'
    show clubStandingLabel;
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/domain/services/player/international_retirement.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/awards/award_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/player/club_history_card.dart';
import 'package:fnm/features/player/club_history_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:fnm/core/util/club_label.dart';

part 'player_tablet_layout.dart';

typedef _PlayerView = ({
  Player? player,
  Nation? nation,
  int goals,
  PlayerCareerStats? stats,
  List<PlayerMatchStat> history,
  Map<int, Nation> nationsById,

  /// The save's RNG seed, so derived facts (traits, clubs) match the rest of
  /// the save rather than being recomputed from a different stream.
  int saveSeed,

  /// The in-game date, which decides WHICH transfer window a club standing is
  /// read for — the same player is a first-choice one season and a squad man
  /// the next.
  DateTime asOf,

  /// Who is reading young players' ceilings for this save, so the potential
  /// shown here is the same read the youth screens give.
  StaffTier scout,

  /// His international retirement in this save (and comeback), if any.
  IntlRetirement? intlRetirement,

  /// The save's custom world, if any, for the potential read.
  WorldZoneData? world,
});
typedef _PlayerArg = ({int careerId, int playerId});

final AutoDisposeFutureProviderFamily<_PlayerView, _PlayerArg>
_playerDetailProvider = FutureProvider.autoDispose
    .family<_PlayerView, _PlayerArg>((
      ref,
      arg,
    ) async {
      final career = await ref
          .watch(careerRepositoryProvider)
          .byId(arg.careerId);
      // Resolved with the save's development inputs, exactly as every list that
      // shows this player is. Without them the detail card read the base rating
      // while the squad and call-up lists read the developed one, so the same
      // player was two different numbers depending on where you tapped him.
      final player = await ref
          .watch(playerRepositoryProvider)
          .byId(
            arg.playerId,
            agingYears: career == null ? 0 : CareerService.agingYears(career),
            saveSeed: career?.rngSeed ?? 0,
            careerId: career?.id,
            youthBonusByCycle: career == null
                ? const {}
                : await ref.watch(
                    youthBonusByCycleProvider(arg.careerId).future,
                  ),
            careerStartsByPlayer: career == null
                ? const {}
                : await ref.watch(
                    careerDevBonusProvider(arg.careerId).future,
                  ),
          );
      Nation? nation;
      var goals = 0;
      PlayerCareerStats? stats;
      var history = const <PlayerMatchStat>[];
      final nationsById = <int, Nation>{};
      if (player != null) {
        final comp = ref.watch(competitionRepositoryProvider);
        final nations = await ref
            .watch(nationRepositoryProvider)
            .forCareer(arg.careerId);
        for (final n in nations) {
          nationsById[n.id] = n;
        }
        nation = nationsById[player.nationId];
        // All-time goals for this player in the career (across every
        // competition). A naturalised man reads as his new nation, but the
        // goals he scored for the old one were logged under it: count both.
        final scoredFor = {
          player.nationId,
          for (final link
              in await ref
                  .watch(careerRepositoryProvider)
                  .acceptedNaturalizations(arg.careerId))
            if (link.playerId == player.id) link.sourceNationId,
        };
        for (final nid in scoredFor) {
          final tallies = await comp.nationTopScorers(
            arg.careerId,
            nid,
            limit: 500,
          );
          goals += tallies
              .where((t) => t.playerId == player.id)
              .fold(0, (s, t) => s + t.goals);
        }
        stats = await comp.playerCareerStats(arg.careerId, player.id);
        history = await comp.playerMatchHistory(arg.careerId, player.id);
      }
      final retirement = career == null
          ? null
          : (await ref
                .watch(playerRepositoryProvider)
                .internationalRetirements(career.id))[arg.playerId];
      final world = career == null
          ? null
          : await ref.watch(careerWorldZoneProvider(career.id).future);
      return (
        world: world,
        intlRetirement: retirement,
        saveSeed: career?.rngSeed ?? 0,
        asOf: career?.inGameDate ?? CareerService.cycleStart,
        scout: career?.staffScout ?? StaffTier.none,
        player: player,
        nation: nation,
        goals: goals,
        stats: stats,
        history: history,
        nationsById: nationsById,
      );
    });

/// Drops every cached player detail, so a card on show re-reads its player.
/// The sim's cascade calls it after a step: on a tablet a [PlayerView] (a
/// pane beside the history, squad and ranking grids, or the player page)
/// stays on show while the top bar's Continue runs the sim. The detail reads
/// the appearances and goals imperatively, the club history moves each 1
/// December and the cabinet fills when a tournament ends, so nothing else
/// would notice the step.
void invalidatePlayerDetails(Ref ref) {
  ref
    ..invalidate(_playerDetailProvider)
    ..invalidate(clubHistoryProvider)
    ..invalidate(playerAwardsProvider);
}

/// One player's detail read, for tests that check the cascade hands it a
/// fresh future. The value is the private view record, so it is exposed only
/// as an [Object].
@visibleForTesting
ProviderListenable<Future<Object?>> playerDetailFuture(
  int careerId,
  int playerId,
) => _playerDetailProvider((careerId: careerId, playerId: playerId)).future;

/// A player's page: a silver header card (rating, name, nation, position,
/// age and four key numbers) over three tabs, Overview, Stats and Career.
/// Reachable from anywhere a player is listed.
class PlayerDetailScreen extends ConsumerWidget {
  const PlayerDetailScreen({
    required this.careerId,
    required this.playerId,
    super.key,
  });

  final int careerId;
  final int playerId;

  static String money(int euros) {
    if (euros >= 1000000) return '€${(euros / 1000000).toStringAsFixed(1)}M';
    if (euros >= 1000) return '€${(euros / 1000).round()}K';
    return '€$euros';
  }

  static const Key tabletLayoutKey = Key('player.tabletLayout');
  static const Key profileKey = Key('player.profile');
  static const Key recordKey = Key('player.record');
  static const Key clubKey = Key('player.club');
  static const Key headerKey = Key('player.header');
  static const Key tabOverviewKey = Key('player.tab.overview');
  static const Key tabStatsKey = Key('player.tab.stats');
  static const Key tabCareerKey = Key('player.tab.career');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (TabletShellScope.isActive(context)) {
      return _PlayerTabletLayout(careerId: careerId, playerId: playerId);
    }
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop()
              ? context.pop()
              : Navigator.of(context).maybePop(),
        ),
        title: Text(
          l.playerTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: PlayerView(careerId: careerId, playerId: playerId),
    );
  }
}

/// A player's whole page in one column: the header card, the tab control
/// and the open tab's blocks. The body of [PlayerDetailScreen], on its own so
/// a tablet detail pane can show the same page beside a list.
///
/// Scrolls itself; give it a bounded height.
class PlayerView extends ConsumerStatefulWidget {
  const PlayerView({
    required this.careerId,
    required this.playerId,
    this.padding = const EdgeInsets.all(AppSpacing.marginMobile),
    super.key,
  });

  final int careerId;
  final int playerId;
  final EdgeInsetsGeometry padding;

  @override
  ConsumerState<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends ConsumerState<PlayerView> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final viewAsync = ref.watch(
      _playerDetailProvider((
        careerId: widget.careerId,
        playerId: widget.playerId,
      )),
    );

    return viewAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l.playerLoadError('$e'))),
      data: (view) {
        final p = view.player;
        if (p == null) return Center(child: Text(l.playerNotFound));
        final s = _playerSections(context, view, p, widget.careerId);
        return ListView(
          padding: widget.padding,
          children: [
            s.header,
            const SizedBox(height: AppSpacing.md),
            ProfileTabs(
              labels: [
                l.profileTabOverview,
                l.profileTabStats,
                l.profileTabCareer,
              ],
              keys: const [
                PlayerDetailScreen.tabOverviewKey,
                PlayerDetailScreen.tabStatsKey,
                PlayerDetailScreen.tabCareerKey,
              ],
              selected: _tab,
              onSelect: (i) => setState(() => _tab = i),
            ),
            ..._spaced(switch (_tab) {
              0 => s.overview,
              1 => s.stats,
              _ => s.career,
            }),
            const SizedBox(height: AppSpacing.xl),
          ],
        );
      },
    );
  }
}

/// [blocks] with the page's gap above each one.
List<Widget> _spaced(List<Widget> blocks) => [
  for (final b in blocks)
    Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: b,
    ),
];

/// The player page in its parts: the header card, then each tab's blocks.
/// One column shows the header, the tab control and the open tab
/// ([PlayerView]); the tablet's page puts the header and Overview on the
/// left and Stats or Career on the right.
///
/// - Overview: abilities, recent form, form and fitness now, traits, and his
///   club with the facts about him (position, age, potential, value).
/// - Stats: his international record.
/// - Career: honours, club history and every international match.
({
  Widget header,
  List<Widget> overview,
  List<Widget> stats,
  List<Widget> career,
})
_playerSections(
  BuildContext context,
  _PlayerView view,
  Player p,
  int careerId,
) {
  final l = AppLocalizations.of(context);
  final a = p.attributes;

  // The numbers that identify a footballer, across the header.
  final caps = view.stats?.caps ?? view.history.length;
  final goals = view.goals > (view.stats?.goals ?? 0)
      ? view.goals
      : (view.stats?.goals ?? 0);
  final form = view.stats?.formRating ?? 0;

  final header = ProfileHeaderCard(
    key: PlayerDetailScreen.headerKey,
    disc: '${p.overall}',
    name: p.name,
    meta: [
      if (view.nation != null) ...[
        FlagDisc(view.nation!.code, size: 16),
        const SizedBox(width: AppSpacing.xs),
      ],
      Flexible(
        child: Text(
          view.nation?.name ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: profileMetaStyle,
        ),
      ),
      profileMetaDot(),
      Flexible(flex: 0, child: ProfileChip(p.position.label)),
      profileMetaDot(),
      Flexible(
        flex: 0,
        child: Text(
          l.tacticsAgeOnly(p.age),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: profileMetaStyle,
        ),
      ),
    ],
    notes: [
      if (view.intlRetirement case final r?)
        Text(
          r.comebackYear == null
              ? l.playerIntlRetired(r.retiredYear)
              : l.playerIntlComeback(r.comebackYear!),
          style: profileMetaStyle.copyWith(fontStyle: FontStyle.italic),
        ),
    ],
    stats: [
      ProfileKeyStat.text('$caps', label: l.playerStatCaps),
      ProfileKeyStat.text('$goals', label: l.playerStatGoals),
      ProfileKeyStat.text(
        form > 0 ? form.toStringAsFixed(1) : '-',
        label: l.playerStatForm,
      ),
      ProfileKeyStat(
        value: _FitnessDot(careerId: careerId, playerId: p.id),
        label: l.playerStatFitness,
      ),
    ],
  );

  // How much football he is actually getting at his club. Every player has
  // one, and it sits next to the club it is about.
  final clubStanding = _fact(
    l.playerClubRole,
    clubStandingLabel(
      l,
      ClubForm.standingFor(
        playerId: p.id,
        overall: p.overall,
        age: p.age,
        saveSeed: view.saveSeed,
        windowIndex: ClubForm.windowIndexFor(view.asOf),
      ),
    ),
  );

  return (
    header: header,
    overview: [
      // Abilities as bars with the number at the end: a lopsided player
      // reads as lopsided at a glance.
      ProfileBlock(
        title: l.playerAttributes,
        child: _AttributeBars(
          rows: [
            (l.playerAttrPhysical, a.physical),
            (l.playerAttrTechnical, a.technical),
            (l.playerAttrStamina, a.stamina),
          ],
        ),
      ),
      if (view.history.length >= 3)
        ProfileBlock(
          title: l.playerRecentForm,
          child: _FormSparkline(
            // Oldest to newest, the last eight games.
            ratings: [
              for (final m in view.history.take(8).toList().reversed) m.rating,
            ],
          ),
        ),
      // His form and legs right now: what the call-up row's icons mean for
      // him, and what they do to him next match.
      _FormSection(careerId: careerId, playerId: p.id),
      // What this player is KNOWN for: each trait changes how he should be
      // used, so its effect is spelled out under its chip.
      if (PlayerTraits.of(p, saveSeed: view.saveSeed) case final traits
          when traits.isNotEmpty)
        ProfileBlock(
          title: l.playerTraitsTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [for (final t in traits) _TraitRow(trait: t)],
          ),
        ),
      ProfileBlock(
        key: PlayerDetailScreen.clubKey,
        child: Column(
          children: [
            _clubFact(p, l.playerClub, clubName(l, p.club)),
            clubStanding,
            _fact(l.playerPosition, positionName(l, p.position)),
            _fact(l.playerAge, '${p.age}'),
            // The scouted ceiling for prospects: the same read the youth
            // screens give, so developing youth stays a gamble and a better
            // scout narrows it.
            if (p.age <= 21)
              _fact(
                l.playerPotential,
                WorldZone.runFor(
                  view.world,
                  () => _potentialStars(
                    p,
                    caps: view.stats?.caps ?? 0,
                    scout: view.scout,
                  ),
                ),
              ),
            _fact(l.playerValue, PlayerDetailScreen.money(p.value)),
          ],
        ),
      ),
    ],
    stats: [
      if (view.stats case final s?)
        ProfileBlock(
          title: l.playerCareerRecord,
          child: _CareerStatsCard(stats: s, goals: view.goals),
        )
      else
        ProfileBlock(
          title: l.playerCareerRecord,
          child: _fact(l.playerInternationalGoals, '${view.goals}'),
        ),
    ],
    career: [
      _TrophyCabinet(careerId: careerId, playerId: p.id),
      ClubHistoryCard(careerId: careerId, playerId: p.id),
      if (view.history.isNotEmpty)
        ProfileBlock(
          title: l.playerMatchHistory,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final m in view.history)
                _HistoryRow(
                  stat: m,
                  playerNationId: p.nationId,
                  nationsById: view.nationsById,
                ),
            ],
          ),
        ),
    ],
  );
}

/// The club row, with the club's country flag beside its name, hard-aligned
/// to the right (the trailing group takes the remaining width and ends right).
Widget _clubFact(Player p, String clubLabel, String club) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 3),
  child: Row(
    children: [
      Text(
        clubLabel,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (p.clubCountry.isNotEmpty) ...[
              FlagDisc(p.clubCountry, size: 24),
              const SizedBox(width: AppSpacing.sm),
            ],
            Flexible(
              child: Text(
                club,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyLarge,
              ),
            ),
            if (p.clubStars > 0) ...[
              const SizedBox(width: AppSpacing.sm),
              ClubStars(p.clubStars),
            ],
          ],
        ),
      ),
    ],
  ),
);

Widget _fact(String label, String value) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 3),
  child: Row(
    children: [
      // A Builder only for the locale: the label is set in the language's
      // own capitals, and this helper is handed no context of its own.
      Builder(
        builder: (context) => Text(
          label.capsIn(Localizations.localeOf(context).languageCode),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
      // Takes the rest of the row and keeps the value at its right edge; a
      // narrow pane ellipsises the value instead of overflowing.
      Expanded(
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium,
          ),
        ),
      ),
    ],
  ),
);

/// The three abilities as bars: the name, the bar, the number at its end.
/// The bar maps 20 to 95 (where players actually sit) onto its length; the
/// number takes the band colour the rest of the app uses.
class _AttributeBars extends StatelessWidget {
  const _AttributeBars({required this.rows});

  final List<(String, int)> rows;

  static Color _color(int value) => value >= 80
      ? AppColors.positive
      : value >= 68
      ? AppColors.primary
      : value >= 55
      ? AppColors.warning
      : AppColors.error;

  @override
  Widget build(BuildContext context) {
    // A table, so the bars all start at the widest name, in any language.
    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        for (final r in rows)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: AppSpacing.md,
                  top: 5,
                  bottom: 5,
                ),
                child: Text(r.$1, style: AppTypography.bodySmall),
              ),
              ProfileBar(fraction: ((r.$2 - 20) / 75).clamp(0.04, 1.0)),
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.textScalerOf(context).scale(26),
                  ),
                  child: Text(
                    '${r.$2}',
                    textAlign: TextAlign.end,
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _color(r.$2),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

/// The header's fitness dot: how fresh his legs are, green to red, for a
/// player the squad's condition covers; a quiet grey dot for anyone else.
class _FitnessDot extends ConsumerWidget {
  const _FitnessDot({required this.careerId, required this.playerId});

  final int careerId;
  final int playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final state = ref
        .watch(squadConditionProvider(careerId))
        .valueOrNull?[playerId]
        ?.fatigueState;
    final (color, words) = switch (state) {
      FatigueState.fresh => (AppColors.positive, l.playerStatFitness),
      FatigueState.ready => (AppColors.primary, l.tacticsFatigueMatchLegs),
      FatigueState.tired => (AppColors.warning, l.tacticsFatigueTired),
      FatigueState.exhausted => (AppColors.error, l.tacticsFatigueExhausted),
      null => (AppColors.outlineVariant, l.playerStatFitness),
    };
    final d = MediaQuery.textScalerOf(context).scale(14);
    return Semantics(
      label: words,
      child: Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            if (state != null)
              BoxShadow(color: color.withValues(alpha: 0.45), blurRadius: 6),
          ],
        ),
      ),
    );
  }
}

/// What he has won.
///
/// A player who has won nothing shows nothing at all — an empty cabinet is a
/// statement of its own and does not need a caption explaining it.
class _TrophyCabinet extends ConsumerWidget {
  const _TrophyCabinet({required this.careerId, required this.playerId});

  final int careerId;
  final int playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final awards =
        ref
            .watch(
              playerAwardsProvider((
                careerId: careerId,
                playerId: playerId,
              )),
            )
            .valueOrNull ??
        const <PlayerAward>[];
    if (awards.isEmpty) return const SizedBox.shrink();

    return ProfileBlock(
      title: l.playerHonoursTitle,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (final a in awards)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Icon(_glyph(a.kind), size: 16, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      awardName(l, a.kind),
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      a.competition.isEmpty
                          ? '${a.year}'
                          : '${competitionLabel(l, a.competition)} '
                                '${a.year}',
                      textAlign: TextAlign.end,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  IconData _glyph(AwardKind kind) => switch (kind) {
    AwardKind.goldenBall => Icons.emoji_events_rounded,
    AwardKind.goldenBoot => Icons.sports_soccer_rounded,
    AwardKind.goldenGlove => Icons.back_hand_outlined,
    AwardKind.teamOfTournament => Icons.groups_rounded,
    AwardKind.playerOfYear => Icons.workspace_premium_rounded,
    AwardKind.youngPlayerOfYear => Icons.auto_awesome_rounded,
  };
}

/// What an award is called.
String awardName(AppLocalizations l, AwardKind kind) => switch (kind) {
  AwardKind.goldenBall => l.awardGoldenBall,
  AwardKind.goldenBoot => l.awardGoldenBoot,
  AwardKind.goldenGlove => l.awardGoldenGlove,
  AwardKind.teamOfTournament => l.awardTeamOfTournament,
  AwardKind.playerOfYear => l.awardPlayerOfYear,
  AwardKind.youngPlayerOfYear => l.awardYoungPlayerOfYear,
};

/// One match on the player's history list: date, opponent, the scoreline from
/// this player's perspective (win/draw/loss coloured), any goals, and the mark.
class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.stat,
    required this.playerNationId,
    required this.nationsById,
  });

  final PlayerMatchStat stat;
  final int playerNationId;
  final Map<int, Nation> nationsById;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // The side he was on THAT day: a naturalised man's early lines were for
    // the nation he left. [playerNationId] only for a line with no nation.
    final side = stat.nationId != 0 ? stat.nationId : playerNationId;
    final isHome = stat.homeNationId == side;
    final opponentId = isHome ? stat.awayNationId : stat.homeNationId;
    final opp = nationsById[opponentId];
    final my = isHome ? stat.homeScore : stat.awayScore;
    final other = isHome ? stat.awayScore : stat.homeScore;
    final resultColor = (my == null || other == null)
        ? AppColors.onSurfaceVariant
        : my > other
        ? AppColors.positive
        : my < other
        ? AppColors.error
        : AppColors.onSurfaceVariant;
    final score = (my == null || other == null) ? '–' : '$my–$other';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          SizedBox(
            // 80, not the 58 it was. "30 Nov 30" is nine monospace characters
            // and wanted 70 points before this change ever touched it; the
            // Czech "30. lis 30" wants ten. Both were wrapping onto a second
            // line inside a row built for one.
            width: 80,
            child: Text(
              AppDate.dayMonthShortYear(context, stat.date),
              maxLines: 1,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          FlagDisc(opp?.code ?? '??', size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              opp?.name ?? l.playerUnknown,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall,
            ),
          ),
          if (stat.goals > 0) ...[
            const Icon(
              Icons.sports_soccer,
              size: 13,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 2),
            Text(
              '${stat.goals}',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          if (stat.assists > 0) ...[
            const Icon(
              Icons.assistant_direction_outlined,
              size: 13,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 2),
            Text(
              '${stat.assists}',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          SizedBox(
            width: 34,
            child: Text(
              score,
              textAlign: TextAlign.center,
              style: AppTypography.labelMedium.copyWith(color: resultColor),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          RatingBadge(stat.rating, motm: stat.motm),
        ],
      ),
    );
  }
}

/// A coarse 5-star rendering of a prospect's hidden development ceiling. Bucketed
/// (not the raw multiplier) so it hints at potential without giving the exact
/// number away — developing youth stays a judgement call.
String _potentialStars(
  Player p, {
  required int caps,
  required StaffTier scout,
}) {
  final filled = Prospects.read(
    p.id,
    age: p.age,
    caps: caps,
    scout: scout,
  ).stars;
  return '★' * filled + '☆' * (5 - filled);
}

/// The player's aggregated international record as a grid of stat tiles.
class _CareerStatsCard extends StatelessWidget {
  const _CareerStatsCard({required this.stats, required this.goals});

  final PlayerCareerStats stats;

  /// All-time goals from the scorer charts (spans quick-simmed games too), used
  /// when it exceeds the rated-match goal tally.
  final int goals;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final totalGoals = goals > stats.goals ? goals : stats.goals;
    final tiles = <(String, String)>[
      (l.playerStatCaps, '${stats.caps}'),
      (l.playerStatGoals, '$totalGoals'),
      (l.playerStatAssists, '${stats.assists}'),
      (l.playerStatAvgRating, stats.avgRating.toStringAsFixed(2)),
      (l.playerStatForm, stats.formRating.toStringAsFixed(2)),
      (l.playerStatMotm, '${stats.motm}'),
      (l.playerStatCleanSheets, '${stats.cleanSheets}'),
      (l.playerStatBestGame, stats.bestRating.toStringAsFixed(1)),
      (l.playerStatCards, l.playerCardsValue(stats.yellows, stats.reds)),
    ];
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [for (final t in tiles) _StatTile(label: t.$1, value: t.$2)],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTypography.titleMedium),
          Text(
            label.capsIn(Localizations.localeOf(context).languageCode),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// A tiny bar sparkline of recent match ratings (oldest → newest), each bar
/// coloured by its rating band, so a player's form reads at a glance.
class _FormSparkline extends StatelessWidget {
  const _FormSparkline({required this.ratings});

  final List<double> ratings;

  @override
  Widget build(BuildContext context) {
    const trackHeight = 40.0;
    // The badge's own band colours, so a bar and the match's badge agree.
    final bands = RatingBandColors.of(context);
    return SizedBox(
      height: trackHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final r in ratings)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                child: Container(
                  // Map the 3.0–10.0 mark onto the bar height.
                  height: (((r - 3) / 7).clamp(0.06, 1.0)) * trackHeight,
                  decoration: BoxDecoration(
                    color: bands.fill(RatingBand.of(r)),
                    borderRadius: AppRadii.smAll,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The form card under the abilities, once the squad's condition is known
/// and only for a player it covers.
class _FormSection extends ConsumerWidget {
  const _FormSection({required this.careerId, required this.playerId});

  final int careerId;
  final int playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final condition = ref
        .watch(squadConditionProvider(careerId))
        .valueOrNull?[playerId];
    if (condition == null) return const SizedBox.shrink();
    return _FormCard(condition: condition);
  }
}

/// His current form and fitness, in words: what the call-up row's icons
/// mean for this player, and the rating shift they put on him next match.
class _FormCard extends StatelessWidget {
  const _FormCard({required this.condition});

  final PlayerCondition condition;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final look = formLook(condition.form);
    final delta = condition.overallDelta;
    final fatigue = switch (condition.fatigueState) {
      FatigueState.exhausted => l.tacticsFatigueExhausted,
      FatigueState.tired => l.tacticsFatigueTired,
      FatigueState.ready => l.tacticsFatigueMatchLegs,
      FatigueState.fresh => null,
    };
    final muted = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return ProfileBlock(
      title: l.playerFormTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(look.icon, size: 18, color: look.color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  formLabel(l, condition.form),
                  style: AppTypography.labelMedium.copyWith(color: look.color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            condition.formRating > 0
                ? l.playerFormAverage(condition.formRating.toStringAsFixed(1))
                : l.playerFormNoGames,
            style: muted,
          ),
          if (fatigue != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(
                  Icons.battery_alert_rounded,
                  size: 14,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(child: Text(fatigue, style: muted)),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          Text(
            delta == 0
                ? l.playerFormNoEffect
                : l.playerFormNextMatch(delta > 0 ? '+$delta' : '−${-delta}'),
            style: AppTypography.labelSmall.copyWith(
              color: delta > 0
                  ? AppColors.positive
                  : delta < 0
                  ? AppColors.error
                  : AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          // The squad list shows only his own share of the shift; say how
          // much of the number above every man in the squad has, so the two
          // never seem to disagree.
          if (delta != 0 && delta != condition.personalDelta)
            Text(
              l.playerFormSquadShare(
                signedDelta(delta - condition.personalDelta),
              ),
              style: muted,
            ),
        ],
      ),
    );
  }
}

/// One trait on the player card: its glyph, name and what it actually does.
///
/// The effect is spelled out rather than hinted at — a trait the manager can't
/// act on is just decoration, and the whole point is that these change how a
/// player should be used.
class _TraitRow extends StatelessWidget {
  const _TraitRow({required this.trait});

  final PlayerTrait trait;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (icon, label, blurb, positive) = _describe(l, trait);
    final color = positive ? AppColors.positive : AppColors.warning;
    // The trait as a chip (its glyph and name), what it does underneath.
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppRadii.smAll,
              border: Border.all(color: color.withValues(alpha: 0.45)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSmall.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            blurb,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// A trait's icon, name, effect blurb, and whether it helps the manager.
///
/// Icons, not emoji: emoji render at the mercy of the platform font, sit off
/// the text baseline and pull the whole screen away from the app's flat,
/// monochrome look. A Material glyph tints with the trait's own colour and
/// lines up with every other icon in the app.
/// Public so the squad list's legend can name the same glyphs it prints
/// without keeping a second copy of the mapping. A tester could read the form
/// arrows and guess the flame, and could not work out the rest, which is a
/// legend's job rather than a reason to change the icons.
(IconData, String, String, bool) describeTrait(
  AppLocalizations l,
  PlayerTrait t,
) => _describe(l, t);

(IconData, String, String, bool) _describe(
  AppLocalizations l,
  PlayerTrait t,
) => switch (t) {
  PlayerTrait.bigGame => (
    Icons.bolt_rounded,
    l.traitBigGame,
    l.traitBigGameBlurb,
    true,
  ),
  PlayerTrait.setPiece => (
    Icons.gps_fixed_rounded,
    l.traitSetPiece,
    l.traitSetPieceBlurb,
    true,
  ),
  PlayerTrait.hothead => (
    Icons.local_fire_department_rounded,
    l.traitHothead,
    l.traitHotheadBlurb,
    false,
  ),
  PlayerTrait.ironMan => (
    Icons.shield_rounded,
    l.traitIronMan,
    l.traitIronManBlurb,
    true,
  ),
  PlayerTrait.wonderkid => (
    Icons.auto_awesome_rounded,
    l.traitWonderkid,
    l.traitWonderkidBlurb,
    true,
  ),
  PlayerTrait.leader => (
    Icons.military_tech_rounded,
    l.traitLeader,
    l.traitLeaderBlurb,
    true,
  ),
  PlayerTrait.pacey => (
    Icons.speed_rounded,
    l.traitPacey,
    l.traitPaceyBlurb,
    true,
  ),
  PlayerTrait.oldHead => (
    Icons.psychology_rounded,
    l.traitOldHead,
    l.traitOldHeadBlurb,
    true,
  ),
  PlayerTrait.wasteful => (
    Icons.report_gmailerrorred_rounded,
    l.traitWasteful,
    l.traitWastefulBlurb,
    false,
  ),
};

/// The compact glyph strip used in squad lists, where there is no room for
/// names or blurbs. Empty when the player has no traits.
class PlayerTraitGlyphs extends StatelessWidget {
  const PlayerTraitGlyphs({
    required this.player,
    required this.saveSeed,
    super.key,
  });

  final Player player;
  final int saveSeed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final traits = PlayerTraits.of(player, saveSeed: saveSeed);
    if (traits.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final t in traits)
          () {
            final (icon, label, _, positive) = _describe(l, t);
            return Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Tooltip(
                message: label,
                child: Icon(
                  icon,
                  size: 13,
                  color: positive ? AppColors.positive : AppColors.warning,
                ),
              ),
            );
          }(),
      ],
    );
  }
}
