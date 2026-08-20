import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/club/club_history.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/awards/award_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/player/club_history_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
        final nations = await ref.watch(nationRepositoryProvider).all();
        for (final n in nations) {
          nationsById[n.id] = n;
        }
        nation = nationsById[player.nationId];
        // All-time goals for this player in the career (across every competition).
        final tallies = await comp.nationTopScorers(
          arg.careerId,
          player.nationId,
          limit: 500,
        );
        goals = tallies
            .where((t) => t.playerId == player.id)
            .fold(0, (s, t) => s + t.goals);
        stats = await comp.playerCareerStats(arg.careerId, player.id);
        history = await comp.playerMatchHistory(arg.careerId, player.id);
      }
      return (
        saveSeed: career?.rngSeed ?? 0,
        player: player,
        nation: nation,
        goals: goals,
        stats: stats,
        history: history,
        nationsById: nationsById,
      );
    });

/// A player's detail card: identity, club/value, and the ten attributes. Base
/// data for now — reachable from anywhere a player is listed.
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final viewAsync = ref.watch(
      _playerDetailProvider((careerId: careerId, playerId: playerId)),
    );

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
      body: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.playerLoadError('$e'))),
        data: (view) {
          final p = view.player;
          if (p == null) return Center(child: Text(l.playerNotFound));
          final a = p.attributes;

          // The four numbers that actually identify a footballer — how old he
          // is, where he plays, how often he's played and what he's produced —
          // read as headlines rather than as rows in a list of facts.
          final caps = view.stats?.caps ?? view.history.length;
          final goals = view.goals > (view.stats?.goals ?? 0)
              ? view.goals
              : (view.stats?.goals ?? 0);

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              AppCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.10),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            '${p.overall}',
                            style: AppTypography.headlineLargeMobile.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                style: AppTypography.headlineMedium,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  if (view.nation != null)
                                    FlagDisc(view.nation!.code, size: 18),
                                  const SizedBox(width: AppSpacing.xs),
                                  Flexible(
                                    child: Text(
                                      view.nation?.name ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        _HeadlineStat(
                          value: '${p.age}',
                          label: l.playerAge,
                        ),
                        _HeadlineStat(
                          value: p.position.label,
                          label: l.playerPosition,
                          accent: true,
                        ),
                        _HeadlineStat(
                          value: '$caps',
                          label: l.playerStatCaps,
                        ),
                        _HeadlineStat(
                          value: '$goals',
                          label: l.playerStatGoals,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Abilities as filled rings — three numbers on a bar chart all
              // look alike, three dials do not: a lopsided player reads as
              // lopsided at a glance.
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.playerAttributes.toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        for (final s in <(String, int)>[
                          (l.playerAttrPhysical, a.physical),
                          (l.playerAttrTechnical, a.technical),
                          (l.playerAttrStamina, a.stamina),
                        ])
                          Expanded(
                            child: _AbilityRing(label: s.$1, value: s.$2),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // What this player is KNOWN for. A squad of twenty-three ratings
              // is forgettable; a hothead, an iron man and a big-game striker
              // are not — and each one changes how they should be used.
              if (PlayerTraits.of(p, saveSeed: view.saveSeed) case final traits
                  when traits.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.playerTraitsTitle,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      for (final t in traits) _TraitRow(trait: t),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(
                  children: [
                    _clubFact(p, l.playerClub),
                    _fact(l.playerPosition, p.position.roleName),
                    _fact(l.playerAge, '${p.age}'),
                    // A coarse scouted ceiling for prospects — deliberately
                    // fuzzy (5 buckets), so developing youth stays a gamble.
                    if (p.age <= 21)
                      _fact(l.playerPotential, _potentialStars(p.id)),
                    _fact(l.playerValue, money(p.value)),
                  ],
                ),
              ),
              _ClubHistoryCard(careerId: careerId, playerId: p.id),
              _TrophyCabinet(careerId: careerId, playerId: p.id),
              const SizedBox(height: AppSpacing.md),
              Text(
                l.playerCareerRecord,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (view.stats case final s?)
                _CareerStatsCard(stats: s, goals: view.goals)
              else
                AppCard(
                  child: _fact(l.playerInternationalGoals, '${view.goals}'),
                ),
              if (view.history.length >= 3) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  l.playerRecentForm,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: _FormSparkline(
                    // Oldest → newest, capped to the last dozen games.
                    ratings: [
                      for (final m in view.history.take(12).toList().reversed)
                        m.rating,
                    ],
                  ),
                ),
              ],
              if (view.history.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  l.playerMatchHistory,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
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
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }

  /// The club row, with the club's country flag beside its name, hard-aligned
  /// to the right (the trailing group takes the remaining width and ends right).
  Widget _clubFact(Player p, String clubLabel) => Padding(
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
                FlagDisc(p.clubCountry, size: 18),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(
                child: Text(
                  p.club,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMedium,
                ),
              ),
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
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(value, style: AppTypography.bodyMedium),
      ],
    ),
  );
}

/// One of the four headline facts across the top of the player card — the
/// number large, its name small underneath.
class _HeadlineStat extends StatelessWidget {
  const _HeadlineStat({
    required this.value,
    required this.label,
    this.accent = false,
  });

  final String value;
  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            child: Text(
              value,
              maxLines: 1,
              style: AppTypography.headlineMedium.copyWith(
                color: accent ? AppColors.primary : AppColors.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// One ability as a filled dial: the arc sweeps in proportion to the rating and
/// takes its colour from the same band scale the rest of the app uses, so a 40
/// and an 85 are different shapes AND different colours.
class _AbilityRing extends StatelessWidget {
  const _AbilityRing({required this.label, required this.value});

  final String label;
  final int value;

  /// Ratings live in roughly 20–99; mapping from 20 (not 0) means the dial uses
  /// its whole sweep on the range players actually occupy.
  double get _fraction => ((value - 20) / 75).clamp(0.04, 1.0);

  Color get _color => value >= 80
      ? AppColors.positive
      : value >= 68
      ? AppColors.primary
      : value >= 55
      ? AppColors.warning
      : AppColors.error;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 68,
          height: 68,
          child: CustomPaint(
            painter: _RingPainter(fraction: _fraction, color: _color),
            child: Center(
              child: Text(
                '$value',
                style: AppTypography.titleMedium.copyWith(color: _color),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label.toUpperCase(),
          textAlign: TextAlign.center,
          maxLines: 2,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.fraction, required this.color});

  final double fraction;
  final Color color;

  static const double _stroke = 6;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final inset = rect.deflate(_stroke / 2 + 1);
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..color = AppColors.outlineVariant;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas
      ..drawArc(inset, 0, 2 * math.pi, false, track)
      // Start at twelve o'clock and sweep clockwise, the way a dial reads.
      ..drawArc(inset, -math.pi / 2, 2 * math.pi * fraction, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction || old.color != color;
}

/// One match on the player's history list: date, opponent, the scoreline from
/// this player's perspective (win/draw/loss coloured), any goals, and the mark.
/// Where a player has played, season by season, collapsed into spells.
///
/// Clubs follow a player's rating, so this is the transfer record the save has
/// been writing all along without ever showing it: the move up after a good
/// cycle, the drop down as he fades, the years he stayed put.
class _ClubHistoryCard extends ConsumerWidget {
  const _ClubHistoryCard({required this.careerId, required this.playerId});

  final int careerId;
  final int playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final spells =
        ref
            .watch(
              clubHistoryProvider((
                careerId: careerId,
                playerId: playerId,
              )),
            )
            .valueOrNull ??
        const <ClubSpell>[];
    // One spell is just the club already shown at the top of the card.
    if (spells.length < 2) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text(
          l.playerClubHistory,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              // Newest first — where he is now, then how he got here.
              for (final s in spells.reversed)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 74,
                        child: Text(
                          s.fromYear == s.toYear
                              ? '${s.fromYear}'
                              : '${s.fromYear}–${s.toYear}',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (s.country.isNotEmpty) ...[
                        FlagDisc(s.country, size: 18),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Expanded(
                        child: Text(
                          s.club,
                          style: AppTypography.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text(
          l.playerHonoursTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
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
                      Icon(
                        _glyph(a.kind),
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          awardName(l, a.kind),
                          style: AppTypography.bodyMedium,
                        ),
                      ),
                      Text(
                        a.competition.isEmpty
                            ? '${a.year}'
                            : '${competitionLabel(l, a.competition)} '
                                  '${a.year}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
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
    final isHome = stat.homeNationId == playerNationId;
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
            width: 58,
            child: Text(
              DateFormat('d MMM yy').format(stat.date),
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
          if (stat.motm) ...[
            const Icon(Icons.star_rounded, size: 13, color: AppColors.primary),
            const SizedBox(width: AppSpacing.xs),
          ],
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
          _RatingBadge(stat.rating),
        ],
      ),
    );
  }
}

/// A compact coloured match-rating badge (green strong → red poor).
/// A coarse 5-star rendering of a prospect's hidden development ceiling. Bucketed
/// (not the raw multiplier) so it hints at potential without giving the exact
/// number away — developing youth stays a judgement call.
String _potentialStars(int id) {
  final pot = PlayerLifecycle.developmentPotential(id);
  final filled = pot < 0.7
      ? 1
      : pot < 0.95
      ? 2
      : pot < 1.2
      ? 3
      : pot < 1.45
      ? 4
      : 5;
  return '★' * filled + '☆' * (5 - filled);
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge(this.rating);

  final double rating;

  Color get _color => AppColors.ratingColor(rating);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.16),
        borderRadius: AppRadii.smAll,
      ),
      child: Text(
        rating.toStringAsFixed(1),
        style: AppTypography.labelMedium.copyWith(color: _color),
      ),
    );
  }
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
    return AppCard(
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: [for (final t in tiles) _StatTile(label: t.$1, value: t.$2)],
      ),
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
            label.toUpperCase(),
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

  static Color _colorFor(double r) => AppColors.ratingColor(r);

  @override
  Widget build(BuildContext context) {
    const trackHeight = 52.0;
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
                    color: _colorFor(r),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppRadii.smAll,
              border: Border.all(color: color.withValues(alpha: 0.6)),
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(color: color),
                ),
                Text(
                  blurb,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
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
