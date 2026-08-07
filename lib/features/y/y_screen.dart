import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// The words for a post.
///
/// EXHAUSTIVE on purpose — no default branch. A `_ => \'\'` fallback would turn a
/// missing string into an invisible bug: the post renders as an empty row and
/// nobody notices for a year. The widget test walks every (template, variant)
/// pair, and a hole here fails it loudly.
String yPostBody(AppLocalizations l, YPost p) {
  final a0 = p.args.isNotEmpty ? p.args[0] : '';
  final a1 = p.args.length > 1 ? p.args[1] : '';
  return switch ((p.template, p.variant)) {
      (YTemplate.winUpset, 0) => l.yWinUpset0(a0, a1),
      (YTemplate.winUpset, 1) => l.yWinUpset1(a0, a1),
      (YTemplate.winUpset, 2) => l.yWinUpset2(a0, a1),
      (YTemplate.winUpset, 3) => l.yWinUpset3(a0, a1),
      (YTemplate.winRoutine, 0) => l.yWinRoutine0(a0, a1),
      (YTemplate.winRoutine, 1) => l.yWinRoutine1(a0, a1),
      (YTemplate.winRoutine, 2) => l.yWinRoutine2(a0, a1),
      (YTemplate.winRoutine, 3) => l.yWinRoutine3(a0, a1),
      (YTemplate.winTight, 0) => l.yWinTight0(a0, a1),
      (YTemplate.winTight, 1) => l.yWinTight1(a0, a1),
      (YTemplate.winTight, 2) => l.yWinTight2(a0, a1),
      (YTemplate.winTight, 3) => l.yWinTight3(a0, a1),
      (YTemplate.drew, 0) => l.yDrew0(a0, a1),
      (YTemplate.drew, 1) => l.yDrew1(a0, a1),
      (YTemplate.drew, 2) => l.yDrew2(a0, a1),
      (YTemplate.drew, 3) => l.yDrew3(a0, a1),
      (YTemplate.lost, 0) => l.yLost0(a0, a1),
      (YTemplate.lost, 1) => l.yLost1(a0, a1),
      (YTemplate.lost, 2) => l.yLost2(a0, a1),
      (YTemplate.lost, 3) => l.yLost3(a0, a1),
      (YTemplate.lostBadly, 0) => l.yLostBadly0(a0, a1),
      (YTemplate.lostBadly, 1) => l.yLostBadly1(a0, a1),
      (YTemplate.lostBadly, 2) => l.yLostBadly2(a0, a1),
      (YTemplate.lostBadly, 3) => l.yLostBadly3(a0, a1),
      (YTemplate.trophy, 0) => l.yTrophy0(a0),
      (YTemplate.trophy, 1) => l.yTrophy1(a0),
      (YTemplate.trophy, 2) => l.yTrophy2(a0),
      (YTemplate.trophy, 3) => l.yTrophy3(a0),
      (YTemplate.runnerUp, 0) => l.yRunnerUp0(a0),
      (YTemplate.runnerUp, 1) => l.yRunnerUp1(a0),
      (YTemplate.runnerUp, 2) => l.yRunnerUp2(a0),
      (YTemplate.runnerUp, 3) => l.yRunnerUp3(a0),
      (YTemplate.eliminated, 0) => l.yEliminated0(a0),
      (YTemplate.eliminated, 1) => l.yEliminated1(a0),
      (YTemplate.eliminated, 2) => l.yEliminated2(a0),
      (YTemplate.eliminated, 3) => l.yEliminated3(a0),
      (YTemplate.qualified, 0) => l.yQualified0(a0),
      (YTemplate.qualified, 1) => l.yQualified1(a0),
      (YTemplate.qualified, 2) => l.yQualified2(a0),
      (YTemplate.qualified, 3) => l.yQualified3(a0),
      (YTemplate.groupDrawn, 0) => l.yGroupDrawn0(a0),
      (YTemplate.groupDrawn, 1) => l.yGroupDrawn1(a0),
      (YTemplate.groupDrawn, 2) => l.yGroupDrawn2(a0),
      (YTemplate.groupDrawn, 3) => l.yGroupDrawn3(a0),
      (YTemplate.hostNamed, 0) => l.yHostNamed0(a0),
      (YTemplate.hostNamed, 1) => l.yHostNamed1(a0),
      (YTemplate.hostNamed, 2) => l.yHostNamed2(a0),
      (YTemplate.hostNamed, 3) => l.yHostNamed3(a0),
      (YTemplate.tournamentSoon, 0) => l.yTournamentSoon0(a0),
      (YTemplate.tournamentSoon, 1) => l.yTournamentSoon1(a0),
      (YTemplate.tournamentSoon, 2) => l.yTournamentSoon2(a0),
      (YTemplate.tournamentSoon, 3) => l.yTournamentSoon3(a0),
      // Unreachable: variant is always < YFeed.variantCount, which is 4.
      _ => throw ArgumentError('no words for ${p.template} v${p.variant}'),
  };
}

/// Y — where the world talks about you.
///
/// Read-only. The manager already has a voice at press conferences, with real
/// consequences; this is the place he is talked ABOUT.
class YScreen extends ConsumerWidget {
  const YScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(yFeedProvider(careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(l.yTitle, style: AppTypography.titleMedium),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (posts) {
          if (posts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  l.yEmpty,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            itemCount: posts.length,
            itemBuilder: (context, i) => _PostRow(post: posts[i]),
          );
        },
      ),
    );
  }
}

class _PostRow extends StatelessWidget {
  const _PostRow({required this.post});

  final YPost post;

  Color get _tint => switch (post.voice) {
        YVoice.pundit => AppColors.primary,
        YVoice.fan => AppColors.positive,
        YVoice.rival => AppColors.error,
        YVoice.stats => AppColors.onSurfaceVariant,
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _tint.withValues(alpha: 0.16),
              ),
              child: Text(
                post.displayName.characters.first,
                style: AppTypography.labelMedium.copyWith(color: _tint),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          post.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelMedium,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Flexible(
                        child: Text(
                          post.handle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('d MMM yy').format(post.date),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(yPostBody(l, post), style: AppTypography.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
