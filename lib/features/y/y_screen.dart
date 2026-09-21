import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_post_detail.dart';
import 'package:fnm/features/y/y_profile_sheet.dart';
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
    (YTemplate.winUpset, 4) => l.yWinUpset4(a0, a1),
    (YTemplate.winUpset, 5) => l.yWinUpset5(a0, a1),
    (YTemplate.winUpset, 6) => l.yWinUpset6(a0, a1),
    (YTemplate.winUpset, 7) => l.yWinUpset7(a0, a1),
    (YTemplate.winUpset, 8) => l.yWinUpset8(a0, a1),
    (YTemplate.winUpset, 9) => l.yWinUpset9(a0, a1),
    (YTemplate.winUpset, 10) => l.yWinUpset10(a0, a1),
    (YTemplate.winUpset, 11) => l.yWinUpset11(a0, a1),
    (YTemplate.winRoutine, 0) => l.yWinRoutine0(a0, a1),
    (YTemplate.winRoutine, 1) => l.yWinRoutine1(a0, a1),
    (YTemplate.winRoutine, 2) => l.yWinRoutine2(a0, a1),
    (YTemplate.winRoutine, 3) => l.yWinRoutine3(a0, a1),
    (YTemplate.winRoutine, 4) => l.yWinRoutine4(a0, a1),
    (YTemplate.winRoutine, 5) => l.yWinRoutine5(a0, a1),
    (YTemplate.winRoutine, 6) => l.yWinRoutine6(a0, a1),
    (YTemplate.winRoutine, 7) => l.yWinRoutine7(a0, a1),
    (YTemplate.winRoutine, 8) => l.yWinRoutine8(a0, a1),
    (YTemplate.winRoutine, 9) => l.yWinRoutine9(a0, a1),
    (YTemplate.winRoutine, 10) => l.yWinRoutine10(a0, a1),
    (YTemplate.winRoutine, 11) => l.yWinRoutine11(a0, a1),
    (YTemplate.winTight, 0) => l.yWinTight0(a0, a1),
    (YTemplate.winTight, 1) => l.yWinTight1(a0, a1),
    (YTemplate.winTight, 2) => l.yWinTight2(a0, a1),
    (YTemplate.winTight, 3) => l.yWinTight3(a0, a1),
    (YTemplate.winTight, 4) => l.yWinTight4(a0, a1),
    (YTemplate.winTight, 5) => l.yWinTight5(a0, a1),
    (YTemplate.winTight, 6) => l.yWinTight6(a0, a1),
    (YTemplate.winTight, 7) => l.yWinTight7(a0, a1),
    (YTemplate.winTight, 8) => l.yWinTight8(a0, a1),
    (YTemplate.winTight, 9) => l.yWinTight9(a0, a1),
    (YTemplate.winTight, 10) => l.yWinTight10(a0, a1),
    (YTemplate.winTight, 11) => l.yWinTight11(a0, a1),
    (YTemplate.drew, 0) => l.yDrew0(a0, a1),
    (YTemplate.drew, 1) => l.yDrew1(a0, a1),
    (YTemplate.drew, 2) => l.yDrew2(a0, a1),
    (YTemplate.drew, 3) => l.yDrew3(a0, a1),
    (YTemplate.drew, 4) => l.yDrew4(a0, a1),
    (YTemplate.drew, 5) => l.yDrew5(a0, a1),
    (YTemplate.drew, 6) => l.yDrew6(a0, a1),
    (YTemplate.drew, 7) => l.yDrew7(a0, a1),
    (YTemplate.drew, 8) => l.yDrew8(a0, a1),
    (YTemplate.drew, 9) => l.yDrew9(a0, a1),
    (YTemplate.drew, 10) => l.yDrew10(a0, a1),
    (YTemplate.drew, 11) => l.yDrew11(a0, a1),
    (YTemplate.lost, 0) => l.yLost0(a0, a1),
    (YTemplate.lost, 1) => l.yLost1(a0, a1),
    (YTemplate.lost, 2) => l.yLost2(a0, a1),
    (YTemplate.lost, 3) => l.yLost3(a0, a1),
    (YTemplate.lost, 4) => l.yLost4(a0, a1),
    (YTemplate.lost, 5) => l.yLost5(a0, a1),
    (YTemplate.lost, 6) => l.yLost6(a0, a1),
    (YTemplate.lost, 7) => l.yLost7(a0, a1),
    (YTemplate.lost, 8) => l.yLost8(a0, a1),
    (YTemplate.lost, 9) => l.yLost9(a0, a1),
    (YTemplate.lost, 10) => l.yLost10(a0, a1),
    (YTemplate.lost, 11) => l.yLost11(a0, a1),
    (YTemplate.lostBadly, 0) => l.yLostBadly0(a0, a1),
    (YTemplate.lostBadly, 1) => l.yLostBadly1(a0, a1),
    (YTemplate.lostBadly, 2) => l.yLostBadly2(a0, a1),
    (YTemplate.lostBadly, 3) => l.yLostBadly3(a0, a1),
    (YTemplate.lostBadly, 4) => l.yLostBadly4(a0, a1),
    (YTemplate.lostBadly, 5) => l.yLostBadly5(a0, a1),
    (YTemplate.lostBadly, 6) => l.yLostBadly6(a0, a1),
    (YTemplate.lostBadly, 7) => l.yLostBadly7(a0, a1),
    (YTemplate.lostBadly, 8) => l.yLostBadly8(a0, a1),
    (YTemplate.lostBadly, 9) => l.yLostBadly9(a0, a1),
    (YTemplate.lostBadly, 10) => l.yLostBadly10(a0, a1),
    (YTemplate.lostBadly, 11) => l.yLostBadly11(a0, a1),
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
    (YTemplate.finalLooms, 0) => l.yFinalLooms0(a0),
    (YTemplate.finalLooms, 1) => l.yFinalLooms1(a0),
    (YTemplate.finalLooms, 2) => l.yFinalLooms2(a0),
    (YTemplate.finalLooms, 3) => l.yFinalLooms3(a0),
    (YTemplate.playerGrievance, 0) => l.yPlayerGrievance0,
    (YTemplate.playerGrievance, 1) => l.yPlayerGrievance1,
    (YTemplate.playerGrievance, 2) => l.yPlayerGrievance2,
    (YTemplate.playerGrievance, 3) => l.yPlayerGrievance3,
    (YTemplate.scorerStar, 0) => l.yScorerStar0(a0, a1),
    (YTemplate.scorerStar, 1) => l.yScorerStar1(a0, a1),
    (YTemplate.scorerStar, 2) => l.yScorerStar2(a0, a1),
    (YTemplate.scorerStar, 3) => l.yScorerStar3(a0, a1),
    (YTemplate.scorerStar, 4) => l.yScorerStar4(a0, a1),
    (YTemplate.scorerStar, 5) => l.yScorerStar5(a0, a1),
    (YTemplate.scorerStar, 6) => l.yScorerStar6(a0, a1),
    (YTemplate.scorerStar, 7) => l.yScorerStar7(a0, a1),
    (YTemplate.winStreak, 0) => l.yWinStreak0(a0),
    (YTemplate.winStreak, 1) => l.yWinStreak1(a0),
    (YTemplate.winStreak, 2) => l.yWinStreak2(a0),
    (YTemplate.winStreak, 3) => l.yWinStreak3(a0),
    (YTemplate.winStreak, 4) => l.yWinStreak4(a0),
    (YTemplate.winStreak, 5) => l.yWinStreak5(a0),
    (YTemplate.winStreak, 6) => l.yWinStreak6(a0),
    (YTemplate.winStreak, 7) => l.yWinStreak7(a0),
    (YTemplate.lossStreak, 0) => l.yLossStreak0(a0),
    (YTemplate.lossStreak, 1) => l.yLossStreak1(a0),
    (YTemplate.lossStreak, 2) => l.yLossStreak2(a0),
    (YTemplate.lossStreak, 3) => l.yLossStreak3(a0),
    (YTemplate.lossStreak, 4) => l.yLossStreak4(a0),
    (YTemplate.lossStreak, 5) => l.yLossStreak5(a0),
    (YTemplate.lossStreak, 6) => l.yLossStreak6(a0),
    (YTemplate.lossStreak, 7) => l.yLossStreak7(a0),
    (YTemplate.rivalry, 0) => l.yRivalry0(a0, a1),
    (YTemplate.rivalry, 1) => l.yRivalry1(a0, a1),
    (YTemplate.rivalry, 2) => l.yRivalry2(a0, a1),
    (YTemplate.rivalry, 3) => l.yRivalry3(a0, a1),
    (YTemplate.rivalry, 4) => l.yRivalry4(a0, a1),
    (YTemplate.rivalry, 5) => l.yRivalry5(a0, a1),
    (YTemplate.rivalry, 6) => l.yRivalry6(a0, a1),
    (YTemplate.rivalry, 7) => l.yRivalry7(a0, a1),
    (YTemplate.injuryBlow, 0) => l.yInjuryBlow0(a0),
    (YTemplate.injuryBlow, 1) => l.yInjuryBlow1(a0),
    (YTemplate.injuryBlow, 2) => l.yInjuryBlow2(a0),
    (YTemplate.injuryBlow, 3) => l.yInjuryBlow3(a0),
    (YTemplate.injuryBlow, 4) => l.yInjuryBlow4(a0),
    (YTemplate.injuryBlow, 5) => l.yInjuryBlow5(a0),
    (YTemplate.injuryBlow, 6) => l.yInjuryBlow6(a0),
    (YTemplate.injuryBlow, 7) => l.yInjuryBlow7(a0),
    (YTemplate.boardPressure, 0) => l.yBoardPressure0,
    (YTemplate.boardPressure, 1) => l.yBoardPressure1,
    (YTemplate.boardPressure, 2) => l.yBoardPressure2,
    (YTemplate.boardPressure, 3) => l.yBoardPressure3,
    (YTemplate.boardPressure, 4) => l.yBoardPressure4,
    (YTemplate.boardPressure, 5) => l.yBoardPressure5,
    (YTemplate.boardPressure, 6) => l.yBoardPressure6,
    (YTemplate.boardPressure, 7) => l.yBoardPressure7,
    // A reply's words come from its MOOD, not from what happened — one set of
    (YTemplate.againstThemAgain, 0) => l.yAgainstThemAgain0(a0, a1),
    (YTemplate.againstThemAgain, 1) => l.yAgainstThemAgain1(a0, a1),
    (YTemplate.againstThemAgain, 2) => l.yAgainstThemAgain2(a0, a1),
    (YTemplate.againstThemAgain, 3) => l.yAgainstThemAgain3(a0, a1),
    (YTemplate.againstThemAgain, 4) => l.yAgainstThemAgain4(a0, a1),
    (YTemplate.againstThemAgain, 5) => l.yAgainstThemAgain5(a0, a1),
    (YTemplate.sameOldStory, 0) => l.ySameOldStory0(a0),
    (YTemplate.sameOldStory, 1) => l.ySameOldStory1(a0),
    (YTemplate.sameOldStory, 2) => l.ySameOldStory2(a0),
    (YTemplate.sameOldStory, 3) => l.ySameOldStory3(a0),
    (YTemplate.sameOldStory, 4) => l.ySameOldStory4(a0),
    (YTemplate.sameOldStory, 5) => l.ySameOldStory5(a0),
    (YTemplate.toldYouSo, 0) => l.yToldYouSo0,
    (YTemplate.toldYouSo, 1) => l.yToldYouSo1,
    (YTemplate.toldYouSo, 2) => l.yToldYouSo2,
    (YTemplate.toldYouSo, 3) => l.yToldYouSo3,
    (YTemplate.toldYouSo, 4) => l.yToldYouSo4,
    (YTemplate.toldYouSo, 5) => l.yToldYouSo5,
    // six answers every event in the game (see [YMood]).
    (YTemplate.reaction, _) => _reactionBody(l, p),
    // Unreachable: a variant is always inside its own template's range —
    // see [YFeed.variantsFor], which a unit test pins.
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
      l.yReactionElation6,
      l.yReactionElation7,
      l.yReactionElation8,
      l.yReactionElation9,
      l.yReactionElation10,
      l.yReactionElation11,
    ],
    YMood.relief => [
      l.yReactionRelief0,
      l.yReactionRelief1,
      l.yReactionRelief2,
      l.yReactionRelief3,
      l.yReactionRelief4,
      l.yReactionRelief5,
      l.yReactionRelief6,
      l.yReactionRelief7,
      l.yReactionRelief8,
      l.yReactionRelief9,
      l.yReactionRelief10,
      l.yReactionRelief11,
    ],
    YMood.fury => [
      l.yReactionFury0,
      l.yReactionFury1,
      l.yReactionFury2,
      l.yReactionFury3,
      l.yReactionFury4,
      l.yReactionFury5,
      l.yReactionFury6,
      l.yReactionFury7,
      l.yReactionFury8,
      l.yReactionFury9,
      l.yReactionFury10,
      l.yReactionFury11,
    ],
    YMood.despair => [
      l.yReactionDespair0,
      l.yReactionDespair1,
      l.yReactionDespair2,
      l.yReactionDespair3,
      l.yReactionDespair4,
      l.yReactionDespair5,
      l.yReactionDespair6,
      l.yReactionDespair7,
      l.yReactionDespair8,
      l.yReactionDespair9,
      l.yReactionDespair10,
      l.yReactionDespair11,
    ],
    YMood.smugness => [
      l.yReactionSmugness0,
      l.yReactionSmugness1,
      l.yReactionSmugness2,
      l.yReactionSmugness3,
      l.yReactionSmugness4,
      l.yReactionSmugness5,
      l.yReactionSmugness6,
      l.yReactionSmugness7,
      l.yReactionSmugness8,
      l.yReactionSmugness9,
      l.yReactionSmugness10,
      l.yReactionSmugness11,
    ],
    YMood.shrug => [
      l.yReactionShrug0,
      l.yReactionShrug1,
      l.yReactionShrug2,
      l.yReactionShrug3,
      l.yReactionShrug4,
      l.yReactionShrug5,
      l.yReactionShrug6,
      l.yReactionShrug7,
      l.yReactionShrug8,
      l.yReactionShrug9,
      l.yReactionShrug10,
      l.yReactionShrug11,
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
        data: (feed) {
          if (feed.posts.isEmpty) {
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
          return YFeedList(feed: feed);
        },
      ),
    );
  }
}

/// The feed itself.
///
/// Its own widget so the seam heading can be tested without a save behind it:
/// what this draws is entirely decided by the [YTimeline] handed to it.
class YFeedList extends StatelessWidget {
  const YFeedList({required this.feed, super.key});

  final YTimeline feed;

  @override
  Widget build(BuildContext context) {
    final posts = feed.posts;
    final seam = feed.reserveFrom;
    // One extra row for the heading, and only when there is a reserve to head.
    // A feed short enough to fit inside the recency window draws no heading at
    // all rather than an empty one.
    final rows = posts.length + (seam == null ? 0 : 1);
    return ListView.builder(
      // No page padding: a feed runs edge to edge and each row carries its own
      // margins, so the hairlines between conversations reach the sides of the
      // screen the way they do in a timeline.
      padding: EdgeInsets.zero,
      itemCount: rows,
      itemBuilder: (context, row) {
        if (seam != null && row == seam) return const _YEarlierHeading();
        // Everything below the heading has shifted down by its row.
        final i = seam != null && row > seam ? row - 1 : row;
        return YPostTile(
          post: posts[i],
          // A rule ABOVE each new conversation, and none inside one: a post
          // and its replies are one thing being talked about, and a line
          // through the middle of them read as unrelated posts. The heading
          // draws its own, so the post directly under it needs none.
          topRule: i > 0 && posts[i].replyTo == null && row != (seam ?? -1) + 1,
          // A post is the start of a conversation, not a dead line of text:
          // opening it shows everyone who said something about the same match.
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => YPostDetail(post: posts[i], all: posts),
            ),
          ),
          onAccountTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => YProfileSheet(
                persona: YFeed.personaOf(posts[i]),
                all: posts,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// The seam between the recent feed and the tournaments kept back from earlier
/// in the cycle.
///
/// Without it the feed simply jumps back in time partway down — from this
/// spring to a summer two years ago, with no date headers anywhere to explain
/// it — and the manager who went looking for the continental championship
/// found something that read like a fault rather than like older news.
class _YEarlierHeading extends StatelessWidget {
  const _YEarlierHeading();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant),
          bottom: BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.marginMobile,
        vertical: AppSpacing.sm,
      ),
      // A plain [Text], not a [WholeText]: this is a fixed heading in two
      // known languages, and a widget that quietly scales itself down to fit
      // would hide a copy change that no longer does — the width test reads
      // `didExceedMaxLines`, which only a real Text can fail.
      child: Text(
        l.yEarlierHeading,
        maxLines: 1,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// One post in the feed. Public so the detail view — and the tests — can use
/// the same row rather than a second, subtly different one.
///
/// A FLAT ROW, not a card. Every post used to sit in its own raised, rounded
/// box with a gap under it, which is the shape of a list of separate notices —
/// a noticeboard. A feed is a single column of voices divided by hairlines,
/// with replies hanging off the post they answer on a visible rail, and that
/// difference is most of what makes one read as a conversation and the other
/// as an inbox.
class YPostTile extends StatelessWidget {
  const YPostTile({
    required this.post,
    this.onTap,
    this.onAccountTap,
    this.topRule = false,
    super.key,
  });

  final YPost post;
  final VoidCallback? onTap;

  /// Tapping the avatar or the name opens whoever wrote this, rather than
  /// what they wrote. Null leaves the account inert, which is what the
  /// profile's own list of posts wants: it is already that account.
  final VoidCallback? onAccountTap;

  /// Whether a hairline is drawn above this row — true for the first post of
  /// each conversation, so the rules separate stories rather than sentences.
  final bool topRule;

  Color get _tint => switch (post.voice) {
    YVoice.pundit => AppColors.primary,
    YVoice.fan => AppColors.positive,
    YVoice.rival => AppColors.error,
    YVoice.stats || YVoice.breaking => AppColors.onSurfaceVariant,
    YVoice.player => AppColors.warning,
    YVoice.meme => AppColors.tertiary,
    YVoice.expro => AppColors.error,
  };

  /// How the name is written, which is the only sign the manager gets that it
  /// can be opened.
  ///
  /// [AppColors.primary] is this app's one interactive tint: it is on every
  /// back arrow, every action icon and every selected state, so a name in it
  /// reads as something you can press without inventing a link convention
  /// this app has nowhere else. A name that opens nothing is written in the
  /// ordinary colour, because an affordance that lies is worse than none: the
  /// profile lists its own posts, and there is nothing behind those names.
  TextStyle get _nameStyle => onAccountTap == null
      ? AppTypography.labelMedium
      : AppTypography.labelMedium.copyWith(color: AppColors.primary);

  /// Whether this post answers another one, in which case it is drawn stepped
  /// in under it rather than as a story of its own — the thread has to LOOK
  /// like a thread or the replies read as unrelated non-sequiturs.
  bool get _isReply => post.replyTo != null;

  /// The avatar. Smaller for a reply, which is what puts the parent visually
  /// above its answers without indenting the text off the screen.
  double get _avatarSize => _isReply ? 28 : 40;

  /// How far a reply is stepped in from the edge.
  static const double _replyIndent = 22;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: topRule
              ? const BorderSide(color: AppColors.outlineVariant)
              : BorderSide.none,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // The rail a reply hangs off, drawn FULL HEIGHT down the gutter it
            // is indented by. Positioned rather than laid out beside the
            // avatar: a rail that has to stretch to the row's height cannot be
            // an Expanded inside a Row aligned to the top — the column it
            // would sit in has no height to expand into. Consecutive replies
            // each draw their own segment, so a thread of three is one
            // unbroken line.
            if (_isReply)
              const Positioned(
                top: 0,
                bottom: 0,
                left: AppSpacing.marginMobile + _replyIndent / 2 - 1,
                width: 2,
                child: ColoredBox(color: AppColors.outlineVariant),
              ),
            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.marginMobile + (_isReply ? _replyIndent : 0),
                right: AppSpacing.marginMobile,
                top: _isReply ? 6 : AppSpacing.sm,
                bottom: _isReply ? 6 : AppSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Account(
                    onTap: onAccountTap,
                    child: Container(
                      width: _avatarSize,
                      height: _avatarSize,
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
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name, handle and date on ONE line, in that order —
                        // the date sat right-aligned at the far edge before,
                        // which put a column of dates down the side of the
                        // feed and read as a table of records rather than as
                        // people talking.
                        Row(
                          children: [
                            // The name and the handle open the ACCOUNT; the
                            // rest of the row opens the post. Tapping a name
                            // in a feed has meant "who is this" for twenty
                            // years, and this feed has a cast worth asking
                            // about.
                            //
                            // ONE target, not two. Two gestures around two
                            // words left a pair of glyph-sized hit boxes with
                            // a dead gap between them; wrapping the pair and
                            // padding it out gives a finger something to land
                            // on, and [HitTestBehavior.opaque] means the
                            // padding counts.
                            Flexible(
                              child: _Account(
                                onTap: onAccountTap,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.xs,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: WholeText(
                                          post.displayName,
                                          maxLines: 1,
                                          style: _nameStyle,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.xs),
                                      Flexible(
                                        child: WholeText(
                                          post.handle,
                                          maxLines: 1,
                                          style: AppTypography.labelSmall
                                              .copyWith(
                                                color:
                                                    AppColors.onSurfaceVariant,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              ' · ${DateFormat('d MMM yy').format(post.date)}',
                              maxLines: 1,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          yPostBody(l, post),
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Whatever part of a row identifies the account, made tappable.
///
/// A plain [GestureDetector] rather than an [InkWell]: the whole tile is
/// already an InkWell, and a second one nested inside it would paint a ripple
/// over the name at the same time as the row's own. The gesture still wins the
/// tap, which is the part that matters. A null [onTap] leaves the child
/// exactly as it was, so a profile listing its own posts offers no way to open
/// itself again.
class _Account extends StatelessWidget {
  const _Account({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => onTap == null
      ? child
      : GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: child,
        );
}
