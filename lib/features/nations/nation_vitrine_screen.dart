import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/features/nations/nation_vitrine_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

const _gold = AppColors.medalGold;
const _silver = AppColors.medalSilver;
const _bronze = AppColors.medalBronze;

/// A country's trophy room: honours, all-time record-breakers, and how its
/// world standing has moved across the save. Opened from the world ranking.
class NationVitrineScreen extends ConsumerWidget {
  const NationVitrineScreen({
    required this.careerId,
    required this.nationId,
    super.key,
  });

  final int careerId;
  final int nationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(
      nationVitrineProvider((careerId: careerId, nationId: nationId)),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('${Routes.ranking}?careerId=$careerId'),
        ),
        title: Text(
          l.nationsVitrineTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.nationsCouldNotLoad(e.toString()))),
        data: (v) {
          if (v == null) return Center(child: Text(l.nationsNoNation));
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              _Header(v),
              const SizedBox(height: AppSpacing.md),
              _sectionLabel(l.nationsHonours),
              const SizedBox(height: AppSpacing.sm),
              _HonoursCard(v),
              const SizedBox(height: AppSpacing.md),
              _sectionLabel(l.nationsRankingHistory),
              const SizedBox(height: AppSpacing.sm),
              _RankingHistoryCard(v),
              const SizedBox(height: AppSpacing.md),
              _sectionLabel(l.nationsTopScorers),
              const SizedBox(height: AppSpacing.sm),
              _TopScorersCard(v),
              if (v.titles.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                _sectionLabel(l.nationsTitles),
                const SizedBox(height: AppSpacing.sm),
                _TitlesCard(v),
              ],
              const SizedBox(height: AppSpacing.lg),
            ],
          );
        },
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
  );
}

class _Header extends StatelessWidget {
  const _Header(this.v);
  final NationVitrine v;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      child: Row(
        children: [
          FlagDisc(v.nation.code, size: 56, highlighted: v.isPlayerNation),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        v.nation.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineMedium,
                      ),
                    ),
                    if (v.isPlayerNation) ...[
                      const SizedBox(width: AppSpacing.sm),
                      TacticalChip(l.nationsYourTeam, emphasized: true),
                    ],
                  ],
                ),
                if (NationIdentity.nicknameOf(v.nation.code) case final nick?)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '“$nick”',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  '${confederationLabel(l, v.nation.confederation)} · '
                  '${v.nation.code}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (v.currentRank != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '#${v.currentRank}',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  l.nationsWorld,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _HonoursCard extends StatelessWidget {
  const _HonoursCard(this.v);
  final NationVitrine v;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        children: [
          _MedalRow(label: l.nationsWorldCup, haul: v.worldCup),
          const Divider(height: AppSpacing.lg),
          _MedalRow(label: l.nationsContinental, haul: v.continental),
        ],
      ),
    );
  }
}

class _MedalRow extends StatelessWidget {
  const _MedalRow({required this.label, required this.haul});
  final String label;
  final MedalHaul haul;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.titleMedium),
              Text(
                l.nationsAppearances(haul.appearances),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        _medal(_gold, haul.golds),
        const SizedBox(width: AppSpacing.md),
        _medal(_silver, haul.silvers),
        const SizedBox(width: AppSpacing.md),
        _medal(_bronze, haul.bronzes),
      ],
    );
  }

  Widget _medal(Color color, int count) {
    final dim = count == 0;
    return Row(
      children: [
        Icon(
          Icons.emoji_events,
          size: 18,
          color: dim ? AppColors.outlineVariant : color,
        ),
        const SizedBox(width: 3),
        Text(
          '$count',
          style: AppTypography.titleMedium.copyWith(
            color: dim ? AppColors.onSurfaceVariant : AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}

class _RankingHistoryCard extends StatelessWidget {
  const _RankingHistoryCard(this.v);
  final NationVitrine v;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final history = v.rankHistory;
    if (history.length < 2) {
      return AppCard(
        child: Text(
          l.nationsNotEnoughHistory,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }
    final best = history.map((p) => p.rank).reduce((a, b) => a < b ? a : b);
    final worst = history.map((p) => p.rank).reduce((a, b) => a > b ? a : b);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.nationsBestRank(best),
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Text(
                l.nationsNowRank(history.last.rank),
                style: AppTypography.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 120,
            child: CustomPaint(
              size: Size.infinite,
              painter: _RankLinePainter(history, best: best, worst: worst),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${history.first.year}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '${history.last.year}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankLinePainter extends CustomPainter {
  _RankLinePainter(this.history, {required this.best, required this.worst});

  final List<RankPoint> history;
  final int best;
  final int worst;

  @override
  void paint(Canvas canvas, Size size) {
    // Rank 1 is best, so a smaller number should sit higher on the chart.
    final span = (worst - best) == 0 ? 1 : worst - best;
    final n = history.length;
    double x(int i) => n == 1 ? size.width / 2 : size.width * i / (n - 1);
    double y(int rank) {
      final t = (rank - best) / span; // 0 at best … 1 at worst
      return size.height * (0.10 + 0.80 * t);
    }

    final grid = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.4)
      ..strokeWidth = 1;
    canvas
      ..drawLine(Offset(0, y(best)), Offset(size.width, y(best)), grid)
      ..drawLine(Offset(0, y(worst)), Offset(size.width, y(worst)), grid);

    final path = Path();
    for (var i = 0; i < n; i++) {
      final o = Offset(x(i), y(history[i].rank));
      if (i == 0) {
        path.moveTo(o.dx, o.dy);
      } else {
        path.lineTo(o.dx, o.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );

    for (var i = 0; i < n; i++) {
      final p = history[i];
      final o = Offset(x(i), y(p.rank));
      canvas.drawCircle(
        o,
        p.isNow ? 5 : 3,
        Paint()..color = p.isNow ? _gold : AppColors.primary,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RankLinePainter old) => old.history != history;
}

class _TopScorersCard extends StatelessWidget {
  const _TopScorersCard(this.v);
  final NationVitrine v;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (v.topScorers.isEmpty) {
      return AppCard(
        child: Text(
          l.nationsNoGoals,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }
    return AppCard(
      child: Column(
        children: [
          for (var i = 0; i < v.topScorers.length; i++) ...[
            if (i > 0) const Divider(height: AppSpacing.md),
            Row(
              children: [
                SizedBox(
                  width: 22,
                  child: Text(
                    '${i + 1}',
                    style: AppTypography.titleMedium.copyWith(
                      color: i == 0 ? _gold : AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    v.topScorers[i].name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyLarge,
                  ),
                ),
                Text(
                  '${v.topScorers[i].goals}',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  l.nationsGoalsAbbrev,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TitlesCard extends StatelessWidget {
  const _TitlesCard(this.v);
  final NationVitrine v;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        children: [
          for (var i = 0; i < v.titles.length; i++) ...[
            if (i > 0) const Divider(height: AppSpacing.md),
            Row(
              children: [
                const Icon(Icons.emoji_events, size: 18, color: _gold),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    competitionLabel(l, v.titles[i].competition),
                    style: AppTypography.bodyLarge,
                  ),
                ),
                if (v.titles[i].wasHost) ...[
                  TacticalChip(l.nationsHosts),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  '${v.titles[i].year}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
