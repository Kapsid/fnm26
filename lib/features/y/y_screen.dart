import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_post_detail.dart';
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
    (YTemplate.playerGrievance, 0) => l.yPlayerGrievance0,
    (YTemplate.playerGrievance, 1) => l.yPlayerGrievance1,
    (YTemplate.playerGrievance, 2) => l.yPlayerGrievance2,
    (YTemplate.playerGrievance, 3) => l.yPlayerGrievance3,
    (YTemplate.scorerStar, 0) => l.yScorerStar0(a0, a1),
    (YTemplate.scorerStar, 1) => l.yScorerStar1(a0, a1),
    (YTemplate.scorerStar, 2) => l.yScorerStar2(a0, a1),
    (YTemplate.scorerStar, 3) => l.yScorerStar3(a0, a1),
    (YTemplate.winStreak, 0) => l.yWinStreak0(a0),
    (YTemplate.winStreak, 1) => l.yWinStreak1(a0),
    (YTemplate.winStreak, 2) => l.yWinStreak2(a0),
    (YTemplate.winStreak, 3) => l.yWinStreak3(a0),
    (YTemplate.lossStreak, 0) => l.yLossStreak0(a0),
    (YTemplate.lossStreak, 1) => l.yLossStreak1(a0),
    (YTemplate.lossStreak, 2) => l.yLossStreak2(a0),
    (YTemplate.lossStreak, 3) => l.yLossStreak3(a0),
    (YTemplate.rivalry, 0) => l.yRivalry0(a0, a1),
    (YTemplate.rivalry, 1) => l.yRivalry1(a0, a1),
    (YTemplate.rivalry, 2) => l.yRivalry2(a0, a1),
    (YTemplate.rivalry, 3) => l.yRivalry3(a0, a1),
    (YTemplate.injuryBlow, 0) => l.yInjuryBlow0(a0),
    (YTemplate.injuryBlow, 1) => l.yInjuryBlow1(a0),
    (YTemplate.injuryBlow, 2) => l.yInjuryBlow2(a0),
    (YTemplate.injuryBlow, 3) => l.yInjuryBlow3(a0),
    (YTemplate.boardPressure, 0) => l.yBoardPressure0,
    (YTemplate.boardPressure, 1) => l.yBoardPressure1,
    (YTemplate.boardPressure, 2) => l.yBoardPressure2,
    (YTemplate.boardPressure, 3) => l.yBoardPressure3,
    // A reply's words come from its MOOD, not from what happened — one set of
    // six answers every event in the game (see [YMood]).
    (YTemplate.reaction, _) => _reactionBody(l, p),
    // Unreachable: variant is always < YFeed.variantCount, which is 4.
    _ => throw ArgumentError('no words for ${p.template} v${p.variant}'),
  };
}

/// The words for a reply, by mood and variant.
String _reactionBody(AppLocalizations l, YPost p) {
  final options = switch (p.mood ?? YMood.shrug) {
    YMood.elation => [
      l.yReactionElation0,
      l.yReactionElation1,
      l.yReactionElation2,
      l.yReactionElation3,
      l.yReactionElation4,
      l.yReactionElation5,
    ],
    YMood.relief => [
      l.yReactionRelief0,
      l.yReactionRelief1,
      l.yReactionRelief2,
      l.yReactionRelief3,
      l.yReactionRelief4,
      l.yReactionRelief5,
    ],
    YMood.fury => [
      l.yReactionFury0,
      l.yReactionFury1,
      l.yReactionFury2,
      l.yReactionFury3,
      l.yReactionFury4,
      l.yReactionFury5,
    ],
    YMood.despair => [
      l.yReactionDespair0,
      l.yReactionDespair1,
      l.yReactionDespair2,
      l.yReactionDespair3,
      l.yReactionDespair4,
      l.yReactionDespair5,
    ],
    YMood.smugness => [
      l.yReactionSmugness0,
      l.yReactionSmugness1,
      l.yReactionSmugness2,
      l.yReactionSmugness3,
      l.yReactionSmugness4,
      l.yReactionSmugness5,
    ],
    YMood.shrug => [
      l.yReactionShrug0,
      l.yReactionShrug1,
      l.yReactionShrug2,
      l.yReactionShrug3,
      l.yReactionShrug4,
      l.yReactionShrug5,
    ],
  };
  return options[p.variant % options.length];
}

/// Y — where the world talks about you.
///
/// Read-only. The manager already has a voice at press conferences, with real
/// consequences; this is the place he is talked ABOUT.
class YScreen extends ConsumerStatefulWidget {
  const YScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<YScreen> createState() => _YScreenState();
}

class _YScreenState extends ConsumerState<YScreen> {
  /// Whether the feed has been stamped read on this visit — once per visit, so
  /// a rebuild does not keep writing the same watermark.
  bool _marked = false;

  @override
  Widget build(BuildContext context) {
    final careerId = widget.careerId;
    final l = AppLocalizations.of(context);
    final async = ref.watch(yFeedProvider(careerId));
    // Opening the feed IS reading it: the badge counts what has been said
    // since, not what has been tapped.
    if (!_marked && async.hasValue) {
      _marked = true;
      unawaited(ref.read(yReadServiceProvider).markRead(careerId));
    }

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
            itemBuilder: (context, i) => YPostTile(
              post: posts[i],
              // A post is the start of a conversation, not a dead line of
              // text: opening it shows everyone who said something about the
              // same match.
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => YPostDetail(post: posts[i], all: posts),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// One post in the feed. Public so the detail view — and the tests — can use
/// the same row rather than a second, subtly different one.
class YPostTile extends StatelessWidget {
  const YPostTile({required this.post, this.onTap, super.key});

  final YPost post;
  final VoidCallback? onTap;

  Color get _tint => switch (post.voice) {
    YVoice.pundit => AppColors.primary,
    YVoice.fan => AppColors.positive,
    YVoice.rival => AppColors.error,
    YVoice.stats || YVoice.breaking => AppColors.onSurfaceVariant,
    YVoice.player => AppColors.warning,
    YVoice.meme => AppColors.tertiary,
    YVoice.expro => AppColors.error,
  };

  /// Whether this post answers another one, in which case it is drawn stepped
  /// in under it rather than as a card of its own — the thread has to LOOK
  /// like a thread or the replies read as unrelated non-sequiturs.
  bool get _isReply => post.replyTo != null;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSpacing.sm,
        left: _isReply ? AppSpacing.xl : 0,
      ),
      child: AppCard(
        onTap: onTap,
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
                        child: WholeText(
                          post.displayName,
                          maxLines: 1,
                          style: AppTypography.labelMedium,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Flexible(
                        child: WholeText(
                          post.handle,
                          maxLines: 1,
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
