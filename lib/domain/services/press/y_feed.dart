import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/fan_mood.dart';
import 'package:fnm/domain/services/press/half_time_swing.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/statement.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/squad/camp_scandal.dart';
import 'package:fnm/domain/services/world_managers/manager_relation.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart'
    show PackYAccount;

/// Who is talking on Y.
enum YVoice {
  /// A named ex-player who keeps turning up across a career.
  pundit,

  /// One of your own. Delighted, furious, fickle.
  fan,

  /// Someone enjoying your misfortune.
  rival,

  /// An account that posts numbers and nothing else, which is what makes it
  /// useful — it is never pleased or annoyed.
  stats,

  /// One of your own players, saying in public what he could not get said in
  /// your office.
  player,

  /// The meme account. Says nothing useful and is the first thing everybody
  /// reads — a feed without one does not read like a feed.
  meme,

  /// A former international with a column and no patience. Blunt where the
  /// pundit is measured.
  expro,

  /// The wire: posts the fact, in capitals, seconds before anyone else.
  breaking,

  /// Somebody with no side in it: an account that watches all football and
  /// only turns up when something happens that the whole game is talking
  /// about. Its being there at all is what says an afternoon was big.
  neutral,

  /// The other lot's supporters. Their own cast per opponent (see
  /// [YFeed.personaFor]): beaten by us they are bitter or gracious, beating
  /// us they are unbearable.
  away,

  /// @IShowSlowness, the streamer who turns up under every camp scandal in
  /// every language, at full volume. One fixed account, not a cast.
  streamer,

  /// The Czech-only cameos (see [YFeed.czechCameos]): fixed accounts that a
  /// Czech feed has and no other language does.
  cameo,
}

/// The temperature of a reaction, which is all a reply needs to know.
///
/// Replies are keyed by MOOD rather than by what happened, so one set of
/// wordings serves every event: a rout, a shoot-out exit and a player walking
/// out all draw fury, and the room sounds the same about each.
enum YMood {
  /// It could not have gone better.
  elation,

  /// It could have gone much worse.
  relief,

  /// Somebody is going to hear about this.
  fury,

  /// There is nothing left to say.
  despair,

  /// Told you.
  smugness,

  /// It happened. Next.
  shrug,

  /// It is over, and it was more than anybody asked for: a run that ended
  /// further on than the side was ever expected to go (see
  /// `YTournaments.proudExit`). Grateful, not angry.
  pride,

  /// It is over, about where everybody expected it to be (see
  /// `YTournaments.parExit`). Disappointed, not angry.
  acceptance,
}

/// What a post is ABOUT. The words themselves are chosen at render, because
/// they are localised and Czech has seven cases — a sentence assembled from
/// fragments in here would not survive translation.
enum YTemplate {
  winUpset,
  winRoutine,
  winTight,
  drew,
  lost,
  lostBadly,
  trophy,
  runnerUp,
  eliminated,
  qualified,
  groupDrawn,
  hostNamed,
  tournamentSoon,

  /// A player who asked where he stood and was not answered.
  playerGrievance,

  /// A named scorer, and how many he got.
  scorerStar,

  /// A run of wins worth remarking on.
  winStreak,

  /// A run without a win, ditto.
  lossStreak,

  /// A result against the neighbours, which is never just a result.
  rivalry,

  /// Somebody important limping off.
  injuryBlow,

  /// One of ours walking, and the minute he did it.
  ///
  /// The first template drawn from something that happened ON THE PITCH
  /// rather than from a scoreline: the feed could see that a match was lost
  /// and never that it was lost a man short.
  sentOff,

  /// Two goals down at half time, and it finished level or won.
  ///
  /// The pair below read the match the way [sentOff] does rather than the
  /// scoreline, and they are the one pair whose Czech does not translate its
  /// English: see the copy, which says why.
  turnedItRound,

  /// Two goals up at half time, and it finished level or lost.
  threwItAway,

  /// The board's patience, in public.
  boardPressure,

  /// A final is coming, and the country has noticed.
  ///
  /// The only template drawn from a fixture that has NOT been played. Every
  /// other post on the feed reacts to a result, which left the biggest match
  /// of a cycle arriving in total silence and the reaction to it landing
  /// before any anticipation of it — the wrong way round for the one game
  /// everybody is waiting for.
  finalLooms,

  /// The same opponent, doing the same thing to us again.
  againstThemAgain,

  /// This exact afternoon has happened before, recently, and people have
  /// noticed.
  sameOldStory,

  /// Somebody who said it would go wrong, being right out loud.
  toldYouSo,

  /// A first cap, and the country arguing about him already.
  ///
  /// The first template drawn from the SQUAD rather than from a match. The
  /// feed could see a scoreline and a sending-off and never once see who the
  /// manager had picked.
  debut,

  /// A forward who has stopped scoring, and how long it has been.
  drought,

  /// The neighbours, next week.
  rivalryLooms,

  /// Something the manager said on the record, and it came true.
  ///
  /// Generic over every [StatementKind] on purpose: the wording names the
  /// nation and nothing else, so one set of lines serves a promised win, a job
  /// staked on three games and a player backed or blamed in public.
  statementKept,

  /// Something the manager said on the record, and it did not.
  statementBroken,

  /// A win by four or more that was not a shock: the scoreline is the story.
  ///
  /// The templates from here to [drewShame] are the MAGNITUDE of a result,
  /// which the feed used to have no word for: a 6–0 was filed as a routine
  /// win ("job done, nothing learned"), a knockout won on penalties as a
  /// draw, and a final as any other match.
  winRout,

  /// A knockout tie won on penalties.
  winShootout,

  /// The wire on a knockout tie won: through, and what is next.
  knockoutWin,

  /// The numbers desk on how far below the beaten side we were ranked.
  upsetGap,

  /// Somebody who wrote this side off, eating it in public.
  eatWords,

  /// The beaten side's own supporters, about us.
  awayFansWin,

  /// A neutral account on a result the whole game noticed.
  neutralWin,

  /// The man who got the goals, on a night that will be remembered.
  scorerHero,

  /// A one-goal defeat to a side we should beat comfortably.
  lostShock,

  /// A defeat by four or more to a side that was supposed to beat us. Not a
  /// disgrace, but a scoreline nobody can talk round.
  lostRout,

  /// A knockout tie lost on penalties.
  lostShootout,

  /// The wire on a knockout tie lost: out.
  knockoutLoss,

  /// The side that beat us, enjoying it.
  awayFansGloat,

  /// A neutral account on our humiliation.
  neutralLoss,

  /// The numbers desk on how far above the side that beat us we were ranked.
  downGap,

  /// A draw that was a triumph: held a side far above us.
  drewHeroic,

  /// A draw that was an embarrassment: held by a side far below us.
  drewShame,

  /// A reply under somebody else's post. Its words come from a [YMood], not
  /// from what happened — see [YMood].
  reaction,

  /// The stands in revolt: banners, a hashtag with the manager's name in it,
  /// photos of empty seats, talk of staying away. Drawn from the supporters'
  /// mood ([FanMood]), not from one result, and rate-limited.
  fansProtest,

  /// The stands in love: sold out, the best side in years.
  fansSellOut,

  /// One of ours calling time on his international career after a
  /// tournament: the wire, a fan, and the room split between the generous
  /// and the ones who say it is a tournament too late.
  legendRetires,

  /// A camp scandal breaking, one template per [ScandalKind] so each kind
  /// tells its own story: the wire has it first, a fan after.
  scandalParty,
  scandalCurfew,
  scandalNightclub,
  scandalCasino,

  /// The room once he has been sent home: the right call, discipline, or
  /// harsh, by who is talking.
  scandalSentHome,

  /// The room once he has been kept: anger and mockery.
  scandalKept,

  /// @IShowSlowness under the story, then under the decision.
  streamerBreaks,
  streamerSentHome,
  streamerKept,

  /// The federation has signed a dubious general sponsor (see `Sponsors`):
  /// the wire has it, a fan after.
  sponsorDubious,

  /// The room on the dubious sponsor: the one who says money is money, the
  /// dry and the appalled.
  sponsorMocked,

  /// Czech-only cameos (see [YFeed.czechCameos]). The copy exists in every
  /// language, as the copy file requires, but only a Czech feed posts them.
  cameoUjfaloci,
  cameoHavir,
  cameoLzimberskyHome,
  cameoLzimberskyKept,

  /// The Czech feed's regulars under a result (see [YFeed.withRegulars]):
  /// Mařena after a hammering, KudyChodíKrálík after a defeat, and POŠUK
  /// shouting now and then under any result.
  cameoMarena,
  cameoKralik,
  cameoPosuk,

  /// A shock win over a side far above us (see [YFeed.isGiantKilling]): not
  /// a good result but the night of a generation, and the stands euphoric.
  /// Tester feedback: Montenegro beating Sweden 6-2 drew a lukewarm room.
  winEuphoric,

  /// A draw with a side far above us: a point the whole country is proud
  /// of, louder than [drewHeroic]'s "a point earned".
  drewGiant,

  /// A place at a finals nobody expected us to book (see
  /// `YTournaments.qualifiedAgainstTheOdds`): the fans beside themselves,
  /// naming the championship. Owner's feedback: qualifying drew the same
  /// tame line whether a favourite strolled it or a minnow did the
  /// impossible.
  qualifiedEuphoric,

  /// A knockout tie won at a finals when we were not the heavy favourite:
  /// the dream goes on.
  knockoutEuphoric,

  /// A title won: the night of a lifetime, naming the championship.
  trophyEuphoric,

  /// Out early from a finals we were expected to go far in (see
  /// `YTournaments.painfulExit`): heartbroken rather than angry.
  exitHeartbreak,

  /// A pundit's call before a finals tournament: the favourite and a dark
  /// horse (see `PunditPredictions`).
  punditPick,

  /// Before a match against a manager with a history with ours (see
  /// [YFeed.forOpponentManager]): four wordings, banded by the speaker's
  /// tone.
  managerTieLooms,
  /// Out of a finals further on than anybody expected (see
  /// `YTournaments.proudExit`): proud of the run, not angry it ended. The
  /// mirror of [exitHeartbreak]. Tester feedback: Montenegro reached the last
  /// thirty-two of the World Championship and the feed called for the
  /// manager's head.
  exitProud,

  /// Out of a finals about where the side was expected to go (see
  /// `YTournaments.parExit`): a minnow out in its group, a side beaten by a
  /// better one. Accepting, not angry. A plain [eliminated] posted three
  /// times over was being pushed onto "Now the inquest." and "Somebody
  /// explain that to me." for an exit nobody could have been surprised by.
  exitAccepted,
}

/// What the feed remembers when it writes about a match.
///
/// The feed used to have no memory at all: [noRepeatWindow] stopped it saying
/// the same SENTENCE twice and put nothing in its place, so a side losing to
/// the same neighbours for the fourth time running got four unconnected match
/// reports. This is what lets a post say "again".
typedef YMemory = ({
  /// Every result before this one, oldest first.
  List<ResultStanding> standings,

  /// How many times this opponent has already been played.
  int metBefore,

  /// How many of the recent results read the same way as this one.
  int sameRecently,

  /// How many of those earlier meetings with this opponent were won.
  int beatenBefore,
});

/// A feed with nothing behind it — the first match of a save, and the shape
/// every caller that does not walk a run passes.
const YMemory blankMemory = (
  standings: <ResultStanding>[],
  metBefore: 0,
  sameRecently: 0,
  beatenBefore: 0,
);

/// One post on the feed.
typedef YPost = ({
  YVoice voice,
  String handle,
  String displayName,
  YTemplate template,
  int variant,

  /// The template's arguments. After [YFeed.renamedIn] this very list also
  /// carries the account behind the post: pass it on as it is, since a copy
  /// of it drops that identity.
  List<String> args,
  DateTime date,
  String key,

  /// The [key] of the post this answers, or null when it stands on its own.
  ///
  /// A flat list with a parent pointer rather than a nested one: a record
  /// typedef cannot refer to itself, and the feed has to stay a plain list for
  /// the date sort and the cap to mean anything.
  String? replyTo,

  /// For a [YTemplate.reaction], how it is meant. Null for every other post.
  YMood? mood,
});

/// The feed as it is shown: the posts in order, and where the reserved older
/// landmarks begin.
///
/// `reserveFrom` is an index into `posts`, or null when nothing was rescued —
/// which is the ordinary case for a career short enough to fit inside the
/// recency window, and the case in which the screen must draw no heading at
/// all rather than an empty one.
typedef YTimeline = ({List<YPost> posts, int? reserveFrom});

/// One thing worth a headline that is not a scoreline: a trophy lifted, a
/// tournament exit, a place at the finals booked, a tournament coming up.
///
/// The `key` must be stable for the event, so the same happening always draws
/// the same authors and the same phrasings every time the feed is rebuilt.
typedef YMilestone = ({
  YTemplate template,
  List<String> args,
  DateTime date,
  String key,
});

/// How big an afternoon was — see [YFeed.magnitudeOf].
typedef YMagnitude = ({
  /// 0 for a quiet afternoon, up to [YFeed.maxHeat] for one people date
  /// things from. The same scale for a triumph and a humiliation.
  int heat,

  /// How many ranking places apart the two sides stood.
  int gap,

  /// Whether the result went against the ranking: a win over a side above us
  /// or a defeat to one below.
  bool defied,
});

/// A result, as Y sees it.
typedef YMatch = ({
  String opponent,
  int nationRank,
  int opponentRank,
  int scored,
  int conceded,
  DateTime date,
  String key,

  /// Whether it counted. A summer friendly is not evidence, and the country
  /// does not react to one as though it were — see [Expectation.standing].
  bool competitive,

  /// What was riding on it — see [YFeed.stakesOf].
  YStakes stakes,

  /// For a knockout tie settled on penalties, whether we won the shoot-out;
  /// null for every match that was not. The scoreline of such a tie is level,
  /// and read on its own it was being reported as a draw.
  bool? shootoutWon,

  /// Whether it was played at the opponent's ground (not at home, not at a
  /// neutral finals ground): an upset there is bigger still.
  bool away,
});

/// What was riding on a match, which is half of how big it was.
enum YStakes {
  /// A friendly. Nothing, officially.
  friendly,

  /// A qualifier, or a league-format game of the Nations Cup.
  qualifier,

  /// A group game at a finals tournament.
  finals,

  /// A knockout tie: lose and you are out.
  knockout,

  /// A final.
  trophyFinal,
}

/// What the world knows when it writes about a match.
///
/// Everything here is already recorded elsewhere; gathering it is what lets a
/// post name a player and a streak rather than saying "a good result". Without
/// it every post is assembled from a scoreline and an opponent, which is why a
/// long save read the same four sentences over and over.
typedef YContext = ({
  YMatch match,
  String? scorerName,
  int? scorerGoals,
  int winStreak,
  int lossStreak,
  bool isRivalry,
  List<String> injuredNames,
  int boardMood,
});

/// A context for a match nothing else is known about — the shape the feed had
/// before it could read the save.
YContext plainContext(YMatch match) => (
  match: match,
  scorerName: null,
  scorerGoals: null,
  winStreak: 0,
  lossStreak: 0,
  isRivalry: false,
  injuredNames: const [],
  boardMood: 50,
);

/// The world talking about you.
///
/// Every post is derived from an event the world already recorded, and the
/// author and phrasing come from that event's own key — so scrolling back a
/// year shows the posts it showed then. Nothing is stored.
abstract final class YFeed {
  /// The floor: how many phrasings a template has when nothing else is said.
  ///
  /// Every extra one is two more hand-written sentences, so depth is bought
  /// only where it is spent — see [variantsFor].
  static const int variantCount = 4;

  /// The templates that fire every single match, and so are the ones a manager
  /// actually sees repeat.
  static const int deepVariantCount = 12;

  /// The ORDINARY results: a routine win, a tight win, a draw, a defeat.
  ///
  /// A shock and a hammering are rare by definition; these four are most of a
  /// career, and twelve wordings still came round within a couple of seasons
  /// (playtest feedback, 2026-10). Eighteen, six to each tone band. The six
  /// added wordings sit at the END of the ARB numbering (12..17), so the
  /// original twelve keep their keys; [YCast.arbSlot] maps a banded variant
  /// back onto that numbering.
  static const int everyMatchVariantCount = 18;

  /// The reply moods the ordinary results draw: shrug (a routine win, a
  /// draw), relief (a tight win) and fury (a defeat). Deepened alongside
  /// [everyMatchVariantCount], for the same reason.
  static const Set<YMood> deepReactionMoods = {
    YMood.shrug,
    YMood.relief,
    YMood.fury,
  };

  /// How many phrasings a reply in [mood] has.
  static int reactionVariantsFor(YMood mood) => deepReactionMoods.contains(mood)
      ? deepReactionVariantCount
      : mood == YMood.pride || mood == YMood.acceptance
      ? prideReactionVariantCount
      : reactionVariantCount;

  /// The depth of a [YMood.pride] or [YMood.acceptance] reply: three a band.
  /// Each answers one thing only, a finals exit, a handful of times a career.
  static const int prideReactionVariantCount = 9;

  /// The depth of a [deepReactionMoods] reply.
  static const int deepReactionVariantCount = 18;

  /// The ones that fire often but not always — a scorer, a streak, an injury.
  static const int midVariantCount = 8;

  /// The shock win and the hammering: the two results a manager remembers,
  /// and the ones every voice on the feed now turns up for at once. Twelve
  /// came round inside a cycle once three accounts each took one per match.
  /// Twenty-four, eight to a band; the added twelve are numbered from 12 on,
  /// a block per band (see [YCast.arbSlot]).
  static const int bigVariantCount = 24;

  /// The magnitude templates a big match draws as its main line: a draw that
  /// was a triumph or a disgrace, a shock defeat, a hammering by a better
  /// side, a knockout won or lost on the wire.
  static const int bigMidVariantCount = 12;

  /// The extra voices a big match brings out: the neutral, the other lot's
  /// supporters, the critic eating his words, the gap in the ranking, the man
  /// of the night, the shoot-out. Nine, three to a band.
  static const int extraVariantCount = 9;

  /// The templates drawn from the SQUAD rather than from a result.
  ///
  /// Six, not four, and the reason is the bands: [YCast.band] cuts a total
  /// into thirds, so four gives one generous wording, one neutral and two
  /// sour — too thin for the thing these are here for. A nostalgic and a
  /// hypeman have to sound like different people about the same debutant, and
  /// six gives each disposition a pair to choose between.
  static const int subjectVariantCount = 6;

  /// A camp scandal's story: three wordings a kind, one to a tone band.
  static const int scandalVariantCount = 3;

  /// @IShowSlowness: three bursts per moment.
  static const int streamerVariantCount = 3;

  /// A dubious sponsor's story: three wordings, one to a tone band.
  static const int sponsorVariantCount = 3;

  /// Ivan Havíř's lines; the first is his signature.
  static const int havirVariantCount = 8;

  /// Pitomo Lžimberský's lines, per decision.
  static const int lzimberskyVariantCount = 5;

  /// POŠUK's shouts.
  static const int posukVariantCount = 3;

  /// How many phrasings [t] has.
  ///
  /// Four for everything was the whole repetition problem: a host being named
  /// fires once a cycle and four is plenty, while a result fires every match
  /// and came round again within a dozen games. The counts are banded by tone
  /// (see [YCast.band]), so a deep template is three moods of four rather than
  /// twelve of the same.
  static int variantsFor(YTemplate t) => switch (t) {
    YTemplate.winRoutine ||
    YTemplate.winTight ||
    YTemplate.drew ||
    YTemplate.lost ||
    YTemplate.winRout => everyMatchVariantCount,
    YTemplate.winUpset || YTemplate.lostBadly => bigVariantCount,
    YTemplate.knockoutWin ||
    YTemplate.lostShock ||
    YTemplate.lostRout ||
    YTemplate.knockoutLoss ||
    YTemplate.drewHeroic ||
    YTemplate.drewShame ||
    YTemplate.winEuphoric ||
    YTemplate.drewGiant => bigMidVariantCount,
    YTemplate.qualifiedEuphoric ||
    YTemplate.knockoutEuphoric ||
    YTemplate.trophyEuphoric => euphoricVariantCount,
    YTemplate.exitHeartbreak => heartbreakVariantCount,
    YTemplate.exitProud => proudVariantCount,
    YTemplate.exitAccepted => acceptedVariantCount,
    YTemplate.punditPick => punditVariantCount,
    YTemplate.winShootout ||
    YTemplate.upsetGap ||
    YTemplate.eatWords ||
    YTemplate.awayFansWin ||
    YTemplate.neutralWin ||
    YTemplate.scorerHero ||
    YTemplate.lostShootout ||
    YTemplate.awayFansGloat ||
    YTemplate.neutralLoss ||
    YTemplate.downGap => extraVariantCount,
    YTemplate.scorerStar ||
    YTemplate.winStreak ||
    YTemplate.lossStreak ||
    YTemplate.rivalry ||
    YTemplate.injuryBlow ||
    YTemplate.sentOff ||
    YTemplate.boardPressure => midVariantCount,
    YTemplate.debut ||
    YTemplate.drought ||
    YTemplate.rivalryLooms ||
    // Six rather than four for the same reason the squad templates take six:
    // the bands cut a total into thirds, and a joke a loyalist tells and a
    // joke a cynic tells need a pair apiece to choose between.
    YTemplate.turnedItRound ||
    YTemplate.threwItAway ||
    // And for a statement judged: the loyalist who always believed him and
    // the cynic who never did both need a pair of their own.
    YTemplate.statementKept ||
    YTemplate.statementBroken ||
    // The stands, banded like the rest: the loyalist who still sings and the
    // cynic with the hashtag need a pair each.
    YTemplate.fansProtest ||
    YTemplate.fansSellOut ||
    // The decision, banded: the loyalist who backs the call and the cynic who
    // calls it a cover-up need a pair each.
    YTemplate.scandalSentHome ||
    YTemplate.scandalKept ||
    // The room on a dubious sponsor, banded: a pair a disposition.
    YTemplate.sponsorMocked => subjectVariantCount,
    YTemplate.sponsorDubious => sponsorVariantCount,
    YTemplate.scandalParty ||
    YTemplate.scandalCurfew ||
    YTemplate.scandalNightclub ||
    YTemplate.scandalCasino => scandalVariantCount,
    YTemplate.streamerBreaks ||
    YTemplate.streamerSentHome ||
    YTemplate.streamerKept => streamerVariantCount,
    // The owner's line, verbatim, and nothing else.
    YTemplate.cameoUjfaloci => 1,
    YTemplate.cameoHavir => havirVariantCount,
    YTemplate.cameoLzimberskyHome ||
    YTemplate.cameoLzimberskyKept => lzimberskyVariantCount,
    // The owner's lines, verbatim: one each, and POŠUK's three shouts.
    YTemplate.cameoMarena || YTemplate.cameoKralik => 1,
    YTemplate.cameoPosuk => posukVariantCount,
    _ => variantCount,
  };

  /// How many phrasings a euphoric post has: three per tone band, so the
  /// cynic who cannot help himself has as many lines as the believer.
  static const int euphoricVariantCount = 9;

  /// And a heartbroken one: two per band.
  static const int heartbreakVariantCount = 6;

  /// And a proud one: three per band, so even the cynic has a line that is
  /// grudging about the football rather than about the manager.
  static const int proudVariantCount = 9;

  /// And an accepting one: two per band.
  static const int acceptedVariantCount = 6;

  /// And a pundit's call before a tournament: two per band.
  static const int punditVariantCount = 6;

  /// How much a side may have been expected to win a knockout tie and still
  /// have its fans lose their minds over winning it (see [Expectation.of]):
  /// about thirty places of ranking. A giant beating a minnow in a last
  /// sixteen is the job, not a dream.
  static const double euphoricKnockoutBelow = 0.5;

  /// Whether a knockout win at a finals is one the fans lose their minds
  /// over: a decisive or shoot-out win in a finals knockout tie or final,
  /// when we were not the heavy favourite.
  static bool isEuphoricKnockout(YMatch m) {
    if (m.stakes != YStakes.knockout && m.stakes != YStakes.trophyFinal) {
      return false;
    }
    final won = m.scored > m.conceded || (m.shootoutWon ?? false);
    if (!won) return false;
    return Expectation.of(
          nationRank: m.nationRank,
          opponentRank: m.opponentRank,
        ) <
        euphoricKnockoutBelow;
  }

  /// How many phrasings a REPLY has.
  ///
  /// One set of moods answers EVERY event in the game — a rout, a shoot-out
  /// exit and a player walking out all draw fury — so a reply comes round far
  /// faster than any match report and needs the most depth of anything here.
  /// Twelve, banded by tone: a loyalist's fury and a doomer's fury are not the
  /// same sentence.
  static const int reactionVariantCount = 12;

  /// The most a single event is worth saying. Five rather than three now that
  /// a match can be worth more than its scoreline — the scorer, the run, the
  /// injury — but still a cap: a feed that says everything says nothing.
  static const int maxPostsPerEvent = 5;

  /// How the result read against what was expected of this side.
  static ResultStanding standingOf(YMatch m) => Expectation.standing(
    nationRank: m.nationRank,
    opponentRank: m.opponentRank,
    scored: m.scored,
    conceded: m.conceded,
    competitive: m.competitive,
  );

  /// How the country reads a result, before anyone opens their mouth.
  ///
  /// This used to be a ±25 ranking gap of its own, which is how the same 1–1
  /// came to be filed as the same story whether it rescued a minnow's cycle or
  /// ruined a favourite's. It now asks [Expectation], like everything else.
  static YTemplate classify(YMatch m) {
    // A tie settled on penalties has a level scoreline and is not a draw:
    // read as one, a quarter-final won in a shoot-out drew a shrug.
    if (m.shootoutWon case final won?) {
      return won ? YTemplate.winShootout : YTemplate.lostShootout;
    }
    final standing = standingOf(m);
    final margin = (m.scored - m.conceded).abs();
    if (m.scored > m.conceded) {
      // "Earned the hard way" is a close win. A creditable 3–0 is the margin
      // bonus talking, and was being reported as nervy and ugly.
      return switch (standing) {
        ResultStanding.heroic when isGiantKilling(m) => YTemplate.winEuphoric,
        ResultStanding.heroic => YTemplate.winUpset,
        // Four clear is a scoreline people repeat, whoever it was against: it
        // used to be filed as routine and worded "job done, nothing learned".
        _ when margin >= routMargin => YTemplate.winRout,
        ResultStanding.creditable when margin <= 2 => YTemplate.winTight,
        _ => YTemplate.winRoutine,
      };
    }
    if (m.scored == m.conceded) {
      // A point is a different story depending on whose point it was.
      return switch (standing) {
        ResultStanding.heroic ||
        ResultStanding.creditable when isGiantKilling(m) => YTemplate.drewGiant,
        ResultStanding.heroic ||
        ResultStanding.creditable => YTemplate.drewHeroic,
        ResultStanding.humiliating ||
        ResultStanding.poor => YTemplate.drewShame,
        ResultStanding.par => YTemplate.drew,
      };
    }
    // Only a defeat that shames you is a bad defeat. Losing 4–0 to the best
    // side in the world is a scoreline; losing 1–0 at home to a minnow is a
    // story, and the old rule had those the wrong way round.
    //
    // And it takes a margin to be a hammering: the bad-defeat wordings talk
    // about the scoreline, which a one-goal upset does not deserve. The
    // one-goal upset is a shock of its own, and a four-goal beating by a
    // better side is not a disgrace but is not "a defeat" either.
    if (standing == ResultStanding.humiliating) {
      return margin >= 2 ? YTemplate.lostBadly : YTemplate.lostShock;
    }
    return margin >= routMargin ? YTemplate.lostRout : YTemplate.lost;
  }

  /// Whether a result came against a side so far above us that holding or
  /// beating it is giant killing: [giantKillingGap] places or more (an away
  /// ground counts [awayUpsetBonus] places more), or one of the world's top
  /// [topSides] a long way above us. Competitive matches only: a friendly
  /// can be noticed, never celebrated.
  static bool isGiantKilling(YMatch m) {
    if (!m.competitive) return false;
    final gap = m.nationRank - m.opponentRank;
    if (gap <= 0) return false;
    return gap + (m.away ? awayUpsetBonus : 0) >= giantKillingGap ||
        (m.opponentRank <= topSides && gap >= topSideGap);
  }

  /// Ranking places below the opponent at which a win is euphoria and a
  /// draw a point the country is proud of.
  static const int giantKillingGap = 40;

  /// What doing it on their ground is worth, in ranking places.
  static const int awayUpsetBonus = 15;

  /// The world's elite: a result against one of these needs a smaller gap.
  static const int topSides = 10;

  /// The gap below a [topSides] side that still makes it giant killing.
  static const int topSideGap = 25;

  /// The round code of the manager's intercontinental play-off final (see
  /// `playoffFinalFixtureRound`).
  static const String playoffFinalRound = 'POFINAL';

  /// A margin this wide is a rout, either way.
  static const int routMargin = 4;

  /// What was riding on a fixture, read off its round code.
  ///
  /// Continental rounds prefix a C and the Nations Cup an N; the World
  /// Championship uses the bare code, and its qualifying carries none at all.
  /// A Nations Cup league game is a qualifier's worth of pressure, not a
  /// finals group's.
  static YStakes stakesOf(String? round) {
    if (round == Rounds.friendly) return YStakes.friendly;
    if (round == null) return YStakes.qualifier;
    // The intercontinental play-off final is a tie for a place, not a trophy.
    if (round == playoffFinalRound) return YStakes.knockout;
    if (round.endsWith('FINAL')) return YStakes.trophyFinal;
    if (Rounds.isKnockout(round)) return YStakes.knockout;
    if (round == 'GROUP' || round == 'CGROUP') return YStakes.finals;
    return YStakes.qualifier;
  }

  /// How big an afternoon was, 0 … [maxHeat], and the facts that made it so.
  ///
  /// The feed's volume used to hang off the five-word standing alone, so a
  /// 6–0 by a favourite drew one line from the stats desk, a final drew what
  /// a qualifier drew, and two shock wins were exactly as loud as each other.
  /// Heat adds up everything a supporter means by "big": how much of a shock
  /// it was, the margin, what was riding on it and how far apart the two
  /// sides stood. Defeats are graded on the same scale, so a humiliation is
  /// as loud as a triumph.
  static YMagnitude magnitudeOf(YMatch m) {
    final standing = standingOf(m);
    final margin = m.scored - m.conceded;
    // Positive when we were ranked below them.
    final rankGap = m.nationRank - m.opponentRank;
    var heat = switch (standing) {
      ResultStanding.heroic => 3,
      // A humiliation fills the room (the neutral account, the away fans)
      // only when it was a beating or a long way down the table. A one-goal
      // defeat by a side somewhat below is a shock, not a disgrace: the
      // board, too, keeps "humiliation" for a heavy defeat by a weaker side.
      ResultStanding.humiliating =>
        margin <= -2 || -rankGap >= humiliationGap ? 3 : 2,
      ResultStanding.creditable || ResultStanding.poor => 1,
      ResultStanding.par => 0,
    };
    // Two shocks are not equally shocking.
    final surprise = Expectation.surprise(
      nationRank: m.nationRank,
      opponentRank: m.opponentRank,
      scored: m.scored,
      conceded: m.conceded,
      competitive: m.competitive,
    );
    if (surprise.abs() >= _seismicSurprise) heat++;
    if (margin.abs() >= routMargin) heat++;
    if (margin.abs() >= routMargin + 2) heat++;
    heat += switch (m.stakes) {
      YStakes.knockout => 1,
      YStakes.trophyFinal => 2,
      YStakes.friendly || YStakes.qualifier || YStakes.finals => 0,
    };
    // Across a chasm in the ranking, in the direction nobody expected.
    final won = margin > 0 || (m.shootoutWon ?? false);
    final lost = margin < 0 || m.shootoutWon == false;
    final defied =
        (won && rankGap >= giantGap) || (lost && -rankGap >= giantGap);
    if (defied) heat++;
    // Giant killing fills the room even when it is a draw, and doing it on
    // their ground is louder still.
    final template = classify(m);
    final giant =
        template == YTemplate.winEuphoric || template == YTemplate.drewGiant;
    if (giant && heat < 2) heat = 2;
    if (giant && m.away) heat++;
    // A friendly can be noticed, never celebrated.
    if (!m.competitive && heat > 1) heat = 1;
    return (
      heat: heat.clamp(0, maxHeat),
      gap: rankGap.abs(),
      defied: (won && rankGap > 0) || (lost && rankGap < 0),
    );
  }

  /// Ranking places below us at which a one-goal humiliation brings the
  /// whole room out: half the span over which a tie is a foregone
  /// conclusion (see [Expectation.of]).
  static const int humiliationGap = 30;

  /// The loudest an afternoon gets.
  static const int maxHeat = 5;

  /// A surprise this large is a result people date things from.
  static const double _seismicSurprise = 1.75;

  /// Ranking places apart at which beating (or losing to) a side is giant
  /// killing in its own right.
  static const int giantGap = 50;

  /// Ranking places apart worth the numbers desk pointing out.
  static const int gapWorthNoting = 20;

  /// How many posts back a shape must not have been used.
  ///
  /// The feed used to be assembled event by event with no memory, so a run of
  /// similar results produced a run of near-identical posts. A shape is a
  /// template and its arguments together: the same sentence about a different
  /// opponent is not a repeat.
  ///
  /// Forty rather than ten: at ten, the same reply came back two seasons on
  /// under the next defeat, which reads as a feed on a loop. A reply that has
  /// no unused wording left is dropped rather than repeated.
  static const int noRepeatWindow = 40;

  /// A run of results, oldest first, as the world talked about it.
  ///
  /// Assembled in one pass so the feed can remember what it has just said —
  /// see [noRepeatWindow].
  ///
  /// The stands speak here too ([fansFor]): a run that leaves the supporters
  /// furious brings out the banners, one that leaves them euphoric sells the
  /// ground out. [fanEvents] are the tournaments' part of that mood, [manager]
  /// the name a protest hashtag is made of, and [managerSince] the day his
  /// spell began: nobody chants a man's name over results from before he
  /// arrived, nor before he has had [newManagerGrace] matches of his own.
  /// [homeKeys] are the keys of the matches played at home: only after one of
  /// those may a protest describe the ground ([protestVenueVariants]).
  /// [familyFirst] says the manager's name is written family name first (see
  /// [hashtagOf]). [proudExitKeys] are the keys of the defeats that ended a
  /// finals run further on than expected, [acceptedExitKeys] those that
  /// ended one about where expected (see [forMatch]): the stands do not put
  /// the manager's name on a banner the night of either.
  static List<YPost> forRun(
    List<YContext> contexts, {
    required String nation,
    required int seed,
    List<FanEvent> fanEvents = const [],
    String? manager,
    DateTime? managerSince,
    Set<String> homeKeys = const {},
    bool familyFirst = false,
    Set<String> proudExitKeys = const {},
    Set<String> acceptedExitKeys = const {},
  }) {
    final out = <YPost>[];
    final recent = <String>[];
    // The run as the stands remember it, and where they last spoke up.
    final fanResults = <FanResult>[];
    int? lastProtest;
    int? lastSellOut;
    var index = 0;
    var spellMatches = 0;
    // What the country has watched so far, oldest first. Rebuilt as the walk
    // goes rather than read from the end, so a post from three years ago is
    // written by the people who were watching THEN, in the mood they were in
    // then — which is what keeps a scrolled-back feed honest.
    final history = <ResultStanding>[];
    // How often each opponent has been faced, and how the last few afternoons
    // read — the two things a callback needs and the walk already knows.
    final met = <String, int>{};
    final beaten = <String, int>{};
    for (final context in contexts) {
      final standing = standingOf(context.match);
      final recentStandings = history.length <= callbackWindow
          ? history
          : history.sublist(history.length - callbackWindow);
      for (final post in forMatch(
        context,
        nation: nation,
        seed: seed,
        memory: (
          standings: history,
          metBefore: met[context.match.opponent] ?? 0,
          sameRecently: recentStandings.where((s) => s == standing).length,
          beatenBefore: beaten[context.match.opponent] ?? 0,
        ),
        proudExit: proudExitKeys.contains(context.match.key),
        acceptedExit: acceptedExitKeys.contains(context.match.key),
      )) {
        // A wording is the SENTENCE, not the subject: template and variant,
        // whatever the names in it.
        //
        // It used to carry the arguments too, so the same line came back
        // about a different opponent three matches later and counted as new;
        // and a repeat was DROPPED, so a busy stretch quietly lost posts.
        // Now a wording used inside the window moves on to a free one —
        // its own tone band first, so the speaker still sounds like himself —
        // and only a reply with nothing free left is dropped.
        final moved = _freshWording(post, recent);
        if (moved == null) continue;
        out.add(moved);
        recent.add(_wordingOf(moved));
        if (recent.length > noRepeatWindow) recent.removeAt(0);
      }
      // And the stands, once the result is in. Rate-limited per kind (see
      // [FanMood.postGap]), so a long slump is one protest every few matches
      // rather than a banner under every result.
      final m = context.match;
      fanResults.add((
        nationRank: m.nationRank,
        opponentRank: m.opponentRank,
        scored: m.scored,
        conceded: m.conceded,
        competitive: m.competitive,
        date: m.date,
        shootoutWon: m.shootoutWon,
      ));
      final mood = FanMood.of(
        results: fanResults,
        asOf: m.date,
        events: fanEvents,
      );
      final won = m.scored > m.conceded || (m.shootoutWon ?? false);
      final his = managerSince == null || !m.date.isBefore(managerSince);
      if (his) spellMatches++;
      // A new man is given a few matches before the stands put his name on a
      // banner: the slump he inherited is not his yet.
      final named =
          his && (managerSince == null || spellMatches >= newManagerGrace);
      final atHome = homeKeys.contains(m.key);
      YTemplate? cue;
      if (named &&
          !proudExitKeys.contains(m.key) &&
          !acceptedExitKeys.contains(m.key) &&
          FanMood.protests(mood, standing, won: won) &&
          (lastProtest == null || index - lastProtest >= FanMood.postGap)) {
        cue = YTemplate.fansProtest;
        lastProtest = index;
      } else if (FanMood.sellsOut(mood, won: won) &&
          (lastSellOut == null || index - lastSellOut >= FanMood.postGap)) {
        cue = YTemplate.fansSellOut;
        lastSellOut = index;
      }
      if (cue != null) {
        for (final post in fansFor(
          template: cue,
          nation: nation,
          manager: manager,
          familyFirst: familyFirst,
          date: m.date,
          key: 'fans:${m.key}',
          seed: seed,
          standing: standing,
          history: [...history],
        )) {
          var moved = _freshWording(post, recent);
          // Away, or at a finals abroad, there is no home ground to describe.
          if (moved != null && !atHome) moved = _awayFromGround(moved, recent);
          if (moved == null) continue;
          out.add(moved);
          recent.add(_wordingOf(moved));
          if (recent.length > noRepeatWindow) recent.removeAt(0);
        }
      }
      index++;
      history.add(standing);
      met.update(
        context.match.opponent,
        (v) => v + 1,
        ifAbsent: () => 1,
      );
      if (context.match.scored > context.match.conceded) {
        beaten.update(
          context.match.opponent,
          (v) => v + 1,
          ifAbsent: () => 1,
        );
      }
    }
    return out;
  }

  /// Matches a new manager is given before a protest names him.
  static const int newManagerGrace = 3;

  /// The protest wordings that describe the ground (the stand, the empty
  /// seats), and so only fit after a home game. One per tone band, each with
  /// a partner in its band that does not: [_groundFreePartner].
  static const Set<int> protestVenueVariants = {1, 2, 5};

  static const Map<int, int> _groundFreePartner = {1: 0, 2: 3, 5: 4};

  /// [p] moved off a wording that describes the home ground, for a protest
  /// after an away or neutral match: its band partner, else any free
  /// ground-free wording, else nothing (a reply-less silence beats a stadium
  /// that was not there).
  static YPost? _awayFromGround(YPost p, List<String> recent) {
    if (p.template != YTemplate.fansProtest || p.replyTo != null) return p;
    if (!protestVenueVariants.contains(p.variant)) return p;
    YPost withVariant(int v) => (
      voice: p.voice,
      handle: p.handle,
      displayName: p.displayName,
      template: p.template,
      variant: v,
      args: p.args,
      date: p.date,
      key: p.key,
      replyTo: p.replyTo,
      mood: p.mood,
    );
    final order = [
      _groundFreePartner[p.variant]!,
      for (final v in _groundFreePartner.values)
        if (v != _groundFreePartner[p.variant]) v,
    ];
    for (final v in order) {
      final candidate = withVariant(v);
      if (!recent.contains(_wordingOf(candidate))) return candidate;
    }
    return null;
  }

  /// What the stands say when their mood boils over either way: a supporter's
  /// post in the cast's own tone, and the thread under it.
  ///
  /// [manager] is turned into the hashtag a protest chants (his surname, no
  /// spaces); without one the nation's name stands in.
  static List<YPost> fansFor({
    required YTemplate template,
    required String nation,
    required DateTime date,
    required String key,
    required int seed,
    String? manager,
    bool familyFirst = false,
    ResultStanding standing = ResultStanding.par,
    List<ResultStanding> history = const [],
  }) {
    final who = manager == null || manager.trim().isEmpty ? nation : manager;
    final args = template == YTemplate.fansProtest
        ? [nation, hashtagOf(who, familyFirst: familyFirst)]
        : [nation];
    return _castPosts(
      voices: const [YVoice.fan],
      template: template,
      args: args,
      date: date,
      key: key,
      nation: nation,
      seed: seed,
      standing: standing,
      history: history,
    );
  }

  /// The part of [name] a hashtag is made of: the family name, letters and
  /// digits only. "Jan van der Berg" chants #Berg, the way the pitch shows a
  /// surname (its last word). A name written family name first ([familyFirst]:
  /// a Hungarian, Japanese, Korean or Vietnamese game, or a name in Chinese,
  /// Japanese or Korean script) chants its FIRST word: "Nagy Péter" is
  /// #Nagy. A name of one word is used whole.
  static String hashtagOf(String name, {bool familyFirst = false}) {
    final parts = name.trim().split(RegExp(r'\s+'))
      ..removeWhere((w) => w.isEmpty);
    if (parts.isEmpty) return '';
    final first = familyFirst || _eastAsianScript.hasMatch(name);
    final pick = first ? parts.first : parts.last;
    final cleaned = pick.replaceAll(_notLetterOrDigit, '');
    if (cleaned.isNotEmpty) return cleaned;
    return parts.join().replaceAll(_notLetterOrDigit, '');
  }

  static final RegExp _notLetterOrDigit = RegExp(
    r'[^\p{L}\p{M}\p{N}]',
    unicode: true,
  );

  /// Han, kana and Hangul: scripts whose names are written family name first.
  static final RegExp _eastAsianScript = RegExp(
    r'[\u3040-\u30ff\u3400-\u9fff\uac00-\ud7af]',
  );

  /// What [p] says, as the no-repeat window counts it.
  static String _wordingOf(YPost p) => p.mood == null
      ? '${p.template.name}|${p.variant}'
      : 'reaction|${p.mood!.name}|${p.variant}';

  /// [p], moved off any wording [recent] has already used.
  ///
  /// Its own tone band first, then the rest of the template; a report with
  /// every wording taken falls back to the one used longest ago rather than
  /// vanishing (a match must always say something), while a reply in the
  /// same spot is dropped, as it always was.
  static YPost? _freshWording(YPost p, List<String> recent) {
    if (!recent.contains(_wordingOf(p))) return p;
    final spread = p.mood == null
        ? variantsFor(p.template)
        : reactionVariantsFor(p.mood!);
    // The band the original wording sits in, then everything else, each in
    // order from the original so the choice is stable.
    YTone? bandOf(int v) {
      for (final tone in YTone.values) {
        final (offset, size) = YCast.band(tone, spread);
        if (v >= offset && v < offset + size) return tone;
      }
      return null;
    }

    final home = bandOf(p.variant);
    final order =
        [
          for (var i = 1; i < spread; i++) (p.variant + i) % spread,
        ]..sort((a, b) {
          final ah = bandOf(a) == home ? 0 : 1;
          final bh = bandOf(b) == home ? 0 : 1;
          return ah - bh;
        });
    YPost withVariant(int v) => (
      voice: p.voice,
      handle: p.handle,
      displayName: p.displayName,
      template: p.template,
      variant: v,
      args: p.args,
      date: p.date,
      key: p.key,
      replyTo: p.replyTo,
      mood: p.mood,
    );
    for (final v in order) {
      final candidate = withVariant(v);
      if (!recent.contains(_wordingOf(candidate))) return candidate;
    }
    if (p.mood != null) return null;
    // Everything used: the stalest wording, by its LAST appearance.
    var best = p.variant;
    var bestAt = recent.length;
    for (var v = 0; v < spread; v++) {
      final at = recent.lastIndexOf(_wordingOf(withVariant(v)));
      if (at < bestAt) {
        best = v;
        bestAt = at;
      }
    }
    return withVariant(best);
  }

  /// The posts a match that has not been played yet draws.
  ///
  /// [round] is the fixture's round code, [opponent] the other nation, and
  /// [days] how long there is to wait. Only the last rounds of a tournament
  /// get this: hype before a group game is not hype, it is noise.
  static List<YPost> forUpcoming({
    required String round,
    required String opponent,
    required DateTime date,
    required String nation,
    required int seed,
  }) {
    if (!hypeRounds.contains(round)) return const [];
    final key = 'looms|$round|${date.year}|$opponent';
    return [
      _post(
        voice: YVoice.breaking,
        template: YTemplate.finalLooms,
        args: [opponent],
        date: date,
        key: key,
        nation: nation,
        seed: seed,
      ),
      _post(
        voice: YVoice.fan,
        template: YTemplate.finalLooms,
        args: [opponent],
        date: date,
        key: key,
        nation: nation,
        seed: seed,
      ),
      _post(
        voice: YVoice.pundit,
        template: YTemplate.finalLooms,
        args: [opponent],
        date: date,
        key: key,
        nation: nation,
        seed: seed,
      ),
    ];
  }

  /// The rounds worth building hype for: the last four of either main
  /// tournament, and the Nations Cup's own final weekend.
  static const Set<String> hypeRounds = {
    'SF',
    'FINAL',
    'CSF',
    'CFINAL',
    'NSF',
    'NFINAL',
  };

  /// The posts a match draws.
  ///
  /// A bigger occasion is louder (see [magnitudeOf]): a routine result gets a
  /// line from the stats account and little else; a triumph or a humiliation
  /// brings out the pundit, the fans, a neutral, the other lot's supporters,
  /// the critic who wrote the side off, the wire on a knockout tie and the
  /// numbers desk on the gap in the ranking. What the world knows beyond the
  /// scoreline ([YContext]) adds its own shapes on top: the man who scored
  /// them, the run the side is on, the neighbours, the injury, the board.
  ///
  /// [proudExit] marks the defeat that ended a finals run which had already
  /// gone further than the side was expected to (see
  /// `YTournaments.proudExit`). The country reads THAT, not the scoreline:
  /// every one of ours words it generously, the replies are proud, and the
  /// posts that exist to put a bad afternoon on somebody (the board's
  /// patience, the pattern, the told-you-so, the humiliation in the ranking)
  /// stay away. [acceptedExit] is the same for a run that ended about where
  /// it was expected to (see `YTournaments.parExit`), answered with
  /// acceptance rather than pride.
  static List<YPost> forMatch(
    YContext context, {
    required String nation,
    required int seed,
    YMemory memory = blankMemory,
    bool proudExit = false,
    bool acceptedExit = false,
  }) {
    final m = context.match;
    // An exit at or beyond what was expected: nobody turns on the manager.
    final graceful = proudExit || acceptedExit;
    final template = classify(m);
    final standing = standingOf(m);
    final magnitude = magnitudeOf(m);
    // How loud the room gets, from how BIG the afternoon was rather than from
    // the scoreline alone. A favourite putting four past a minnow is the job;
    // the same four the other way, or in a final, brings everybody out.
    final heat = magnitude.heat;
    final shootout = m.shootoutWon != null;
    final won = m.scored > m.conceded || (m.shootoutWon ?? false);
    final lost = m.scored < m.conceded || m.shootoutWon == false;
    final decisive = (won || lost) && !shootout;
    final score = '${m.scored}–${m.conceded}';
    final result = [m.opponent, score];
    // A shoot-out line names the opponent only: its scoreline is level, and
    // "beat them 1–1" is nonsense in every language.
    final line = shootout ? [m.opponent] : result;
    final knockout =
        m.stakes == YStakes.knockout || m.stakes == YStakes.trophyFinal;
    // Somebody who had written the side off, if anybody had — read off the
    // run BEFORE this match, so he is the man who was wrong this morning.
    final critic = won && heat >= 3
        ? criticOf(nation, seed, memory.standings)
        : null;

    // The result itself, in as many voices as the occasion deserves.
    // A knockout tie won at a finals is a night the fans lose their minds
    // over, unless we were expected to stroll it. A giant killing already
    // has euphoric words of its own.
    final euphoric = template != YTemplate.winEuphoric && isEuphoricKnockout(m);
    final candidates = <(YVoice, YTemplate, List<String>)>[
      (YVoice.stats, template, line),
      if (euphoric)
        (YVoice.fan, YTemplate.knockoutEuphoric, [m.opponent])
      else if (heat >= 1)
        (YVoice.fan, template, line),
      if (heat >= 2) (YVoice.pundit, template, line),
      // The rival does not post the result: every result line is written as
      // one of ours ("we did not lay a glove on them"), so he gloats in the
      // replies instead, in words of his own.
      //
      // And then everyone a big afternoon brings out, loudest first.
      if (heat >= 2 && knockout && decisive)
        (
          YVoice.breaking,
          won ? YTemplate.knockoutWin : YTemplate.knockoutLoss,
          result,
        ),
    ];
    final scorer = context.scorerName;
    final goals = context.scorerGoals ?? 0;
    if (scorer != null && goals >= 1) {
      candidates.add(
        won && heat >= 3
            ? (YVoice.fan, YTemplate.scorerHero, [scorer, m.opponent])
            : (YVoice.stats, YTemplate.scorerStar, [scorer, '$goals']),
      );
    }
    if (heat >= 3 && decisive) {
      candidates
        ..addAll([
          if (won || !graceful)
            (
              YVoice.neutral,
              won ? YTemplate.neutralWin : YTemplate.neutralLoss,
              [nation, m.opponent, score],
            ),
        ])
        ..add((
          YVoice.away,
          won ? YTemplate.awayFansWin : YTemplate.awayFansGloat,
          [nation, score],
        ));
    }
    if (critic != null) {
      candidates.add((critic.voice, YTemplate.eatWords, [m.opponent]));
    }
    if (heat >= 2 &&
        decisive &&
        magnitude.defied &&
        magnitude.gap >= gapWorthNoting &&
        (won || !graceful)) {
      candidates.add((
        YVoice.stats,
        won ? YTemplate.upsetGap : YTemplate.downGap,
        [m.opponent, '${magnitude.gap}'],
      ));
    }

    // And what else the world happens to know.
    if (context.isRivalry) {
      candidates.add((
        lost ? YVoice.expro : YVoice.fan,
        YTemplate.rivalry,
        result,
      ));
    }
    if (context.winStreak >= streakThreshold) {
      candidates.add((
        YVoice.pundit,
        YTemplate.winStreak,
        ['${context.winStreak}'],
      ));
    }
    if (context.lossStreak >= streakThreshold && !graceful) {
      candidates.add((
        YVoice.pundit,
        YTemplate.lossStreak,
        ['${context.lossStreak}'],
      ));
    }
    if (context.injuredNames.isNotEmpty) {
      candidates.add((
        YVoice.pundit,
        YTemplate.injuryBlow,
        [context.injuredNames.first],
      ));
    }
    if (context.boardMood <= boardPressureBelow && !graceful) {
      candidates.add((YVoice.pundit, YTemplate.boardPressure, const ['']));
    }
    // What the country REMEMBERS, which is the half a feed with no history
    // could never say. A fourth defeat to the same neighbours is not a fourth
    // result, it is a pattern, and somebody says so.
    if (memory.metBefore >= callbackMeetings &&
        memory.beatenBefore == 0 &&
        Expectation.weight(standing) < 0 &&
        !graceful) {
      candidates.add((
        YVoice.fan,
        YTemplate.againstThemAgain,
        [m.opponent, '${memory.metBefore + 1}'],
      ));
    }
    // "A pattern, not a run of luck" is a complaint: only bad afternoons make
    // one, and a losing streak already said so.
    if (memory.sameRecently >= callbackRepeats &&
        Expectation.weight(standing) < 0 &&
        context.lossStreak < streakThreshold &&
        !graceful) {
      candidates.add((
        YVoice.pundit,
        YTemplate.sameOldStory,
        ['${memory.sameRecently + 1}'],
      ));
    }
    // The one post that needs a run behind it AND somebody sour enough to
    // enjoy it: a bad afternoon straight after everyone was told it was fine.
    if (Expectation.weight(standing) < 0 &&
        _wasHyped(memory.standings) &&
        !graceful) {
      candidates.add((YVoice.expro, YTemplate.toldYouSo, const ['']));
    }

    final posts = [
      for (final (voice, shape, args) in candidates.take(maxPostsFor(heat)))
        () {
          // Who is posting decides HOW it is worded. The same 1–1 is unlucky
          // from a loyalist and terminal from a doomer, and a run of results
          // moves both of them.
          final persona = switch (shape) {
            YTemplate.eatWords => critic!.persona,
            // The other lot's supporters belong to the OTHER nation: their own
            // cast, so a manager meets the same faces from the same rivals.
            _ when voice == YVoice.away => personaFor(
              voice,
              m.opponent,
              seed,
              m.key,
            ),
            _ => personaFor(voice, nation, seed, m.key),
          };
          final tone = switch (voice) {
            // The rival is here to enjoy it: never generous about our misery.
            YVoice.rival => YTone.sour,
            // A run that went further than anybody asked: ours are proud of
            // it, whoever they are.
            _ when graceful && voice != YVoice.away => YTone.generous,
            // The other lot read the afternoon the other way round, and our
            // run of results is none of their business.
            YVoice.away => YCast.toneFor(
              persona,
              mirrorOf(standing),
              YCast.stance(persona, const []),
            ),
            _ => YCast.toneFor(
              persona,
              standing,
              YCast.stance(persona, memory.standings),
            ),
          };
          return _post(
            voice: voice,
            template: shape,
            args: args,
            date: m.date,
            key: m.key,
            nation: nation,
            seed: seed,
            tone: tone,
            as: persona,
          );
        }(),
    ];
    // The room answers itself. Only the LOUDEST post of an event draws a
    // thread — every post drawing one would bury the feed under its own
    // replies, and a match is one conversation, not five.
    if (posts.isEmpty) return posts;
    return distinctWording([
      ...posts,
      ...repliesTo(
        posts.first,
        mood: proudExit
            ? YMood.pride
            : acceptedExit
            ? YMood.acceptance
            : moodOf(template),
        nation: nation,
        seed: seed,
        standing: proudExit
            ? ResultStanding.heroic
            : acceptedExit && Expectation.weight(standing) < 0
            ? ResultStanding.par
            : standing,
        history: memory.standings,
        heat: heat,
      ),
    ]);
  }

  /// How many posts an event of [heat] is worth: the old five for an ordinary
  /// afternoon, one more per step above that.
  static int maxPostsFor(int heat) =>
      maxPostsPerEvent + (heat > 1 ? heat - 1 : 0);

  /// The same afternoon read from the other dressing room.
  static ResultStanding mirrorOf(ResultStanding s) => switch (s) {
    ResultStanding.heroic => ResultStanding.humiliating,
    ResultStanding.creditable => ResultStanding.poor,
    ResultStanding.par => ResultStanding.par,
    ResultStanding.poor => ResultStanding.creditable,
    ResultStanding.humiliating => ResultStanding.heroic,
  };

  /// The pundit or former international who has been hardest on the side
  /// over [history], if anybody has been hard on it at all.
  ///
  /// Derived, like every stance: nothing remembers who said what, but the
  /// account whose disposition and the run of results leave it the sourest is
  /// by definition the one who wrote the side off, and a shock win is when he
  /// has to say so.
  static ({YVoice voice, YPersona persona})? criticOf(
    String nation,
    int seed,
    List<ResultStanding> history,
  ) {
    // Nobody has written off a side that has not played.
    if (history.isEmpty) return null;
    ({YVoice voice, YPersona persona, int stance})? worst;
    for (final voice in const [YVoice.expro, YVoice.pundit]) {
      final cast = YCast.of(
        _namesFor(voice),
        nation: nation,
        seed: seed,
        voiceKey: voice.name,
      );
      for (final p in cast) {
        // The numbers have no opinion to eat.
        if (p.trait == YTrait.statshead) continue;
        final stance = YCast.stance(p, history);
        if (worst == null || stance < worst.stance) {
          worst = (voice: voice, persona: p, stance: stance);
        }
      }
    }
    if (worst == null || worst.stance >= criticBelow) return null;
    return (voice: worst.voice, persona: worst.persona);
  }

  /// How sour an account has to be to count as having written the side off.
  static const int criticBelow = -10;

  /// How long a run has to be before anybody remarks on it.
  static const int streakThreshold = 3;

  /// How many previous meetings make the next one "again".
  static const int callbackMeetings = 2;

  /// How far back "recently" reaches when looking for a pattern.
  static const int callbackWindow = 6;

  /// How many recent results have to read alike before it is a pattern.
  static const int callbackRepeats = 2;

  /// Whether the side had just been talked up — the setup a told-you-so needs.
  static bool _wasHyped(List<ResultStanding> standings) {
    if (standings.length < 2) return false;
    final recent = standings.sublist(
      standings.length < 3 ? 0 : standings.length - 3,
    );
    return recent.every((s) => Expectation.weight(s) > 0);
  }

  /// The board mood at or below which the pundits start counting the days.
  static const int boardPressureBelow = 30;

  /// The post a one-off event draws — a draw made, a host named, a tournament
  /// coming up.
  static List<YPost> forEvent({
    required YTemplate template,
    required List<String> args,
    required DateTime date,
    required String key,
    required String nation,
    required int seed,

    /// What the fan posts in place of `template`, and in what tone, when the
    /// occasion is bigger than its template (see [forMilestone]). The room
    /// then answers in `mood` rather than the template's own.
    YTemplate? fanTemplate,
    YTone fanTone = YTone.neutral,
    YMood? mood,

    /// The same for the former international's column, and the tone the wire
    /// breaks it in. A proud exit (see [forMilestone]) needs both: the column
    /// is the fans' story, not the exit's, and the wire's neutral wording of
    /// an exit pushed the others along onto "the inquest".
    YTemplate? exproTemplate,
    YTone exproTone = YTone.neutral,
    YTone wireTone = YTone.neutral,
  }) {
    // The wire breaks it, the fans react, and — for the events that matter —
    // the ex-pro has a column to fill.
    final posts = [
      _post(
        voice: YVoice.breaking,
        template: template,
        args: args,
        date: date,
        key: key,
        nation: nation,
        seed: seed,
        tone: wireTone,
      ),
      _post(
        voice: YVoice.fan,
        template: fanTemplate ?? template,
        args: args,
        date: date,
        key: key,
        nation: nation,
        seed: seed,
        tone: fanTone,
      ),
      if (_bigEvents.contains(template))
        _post(
          voice: YVoice.expro,
          template: exproTemplate ?? template,
          args: args,
          date: date,
          key: key,
          nation: nation,
          seed: seed,
          tone: exproTone,
        ),
    ];
    return distinctWording([
      ...posts,
      ...repliesTo(
        posts.first,
        mood: mood ?? moodOf(template),
        nation: nation,
        seed: seed,
      ),
    ]);
  }

  /// The posts a tournament milestone draws: [forEvent], with the fans losing
  /// their minds when the moment deserves it.
  ///
  /// A title always does. A place booked does when nobody expected it
  /// ([againstTheOdds], see `YTournaments.qualifiedAgainstTheOdds`); an exit
  /// breaks hearts rather than tempers when the side was expected to go far
  /// ([painful], see `YTournaments.painfulExit`). The fan who says so is
  /// worded by who he is, as on a match (tone follows the speaker): the cynic
  /// cannot help himself, the believer always knew. [history] is the run as
  /// it stood on the day.
  ///
  /// An exit that came further on than the side was ever expected to go
  /// ([proud], see `YTournaments.proudExit`) is a run the country is proud
  /// of: the fan and the former international both say so, the wire breaks
  /// it gently, and nobody replies in anger.
  static List<YPost> forMilestone(
    YMilestone m, {
    required String nation,
    required int seed,
    bool againstTheOdds = false,
    bool painful = false,
    bool proud = false,
    bool accepted = false,
    List<ResultStanding> history = const [],
  }) {
    // An exit at ([accepted], see `YTournaments.parExit`) or beyond
    // ([proud]) what was expected: the wire breaks it gently, and the fan
    // and the former international say it in their own family of words.
    final graceful = !painful && (proud || accepted);
    if (m.template == YTemplate.eliminated && graceful) {
      final reading = proud ? ResultStanding.heroic : ResultStanding.par;
      final family = proud ? YTemplate.exitProud : YTemplate.exitAccepted;
      YTone toneOf(YVoice voice) {
        final p = personaFor(voice, nation, seed, m.key);
        return YCast.toneFor(p, reading, YCast.stance(p, history));
      }

      return forEvent(
        template: m.template,
        args: m.args,
        date: m.date,
        key: m.key,
        nation: nation,
        seed: seed,
        fanTemplate: family,
        fanTone: toneOf(YVoice.fan),
        exproTemplate: family,
        exproTone: toneOf(YVoice.expro),
        wireTone: YTone.generous,
        mood: moodOf(family),
      );
    }
    final (fanTemplate, standing) = switch (m.template) {
      YTemplate.trophy => (YTemplate.trophyEuphoric, ResultStanding.heroic),
      YTemplate.qualified when againstTheOdds => (
        YTemplate.qualifiedEuphoric,
        ResultStanding.heroic,
      ),
      YTemplate.eliminated when painful => (
        YTemplate.exitHeartbreak,
        ResultStanding.poor,
      ),
      _ => (null, ResultStanding.par),
    };
    if (fanTemplate == null) {
      return forEvent(
        template: m.template,
        args: m.args,
        date: m.date,
        key: m.key,
        nation: nation,
        seed: seed,
      );
    }
    final fan = personaFor(YVoice.fan, nation, seed, m.key);
    return forEvent(
      template: m.template,
      args: m.args,
      date: m.date,
      key: m.key,
      nation: nation,
      seed: seed,
      fanTemplate: fanTemplate,
      fanTone: YCast.toneFor(fan, standing, YCast.stance(fan, history)),
      mood: moodOf(fanTemplate),
    );
  }

  /// The pundits' call before a finals tournament, on Y: the nation's pundit
  /// and its former international, each naming the favourite and a dark
  /// horse for [competition], worded by who they are (tone follows the
  /// speaker). The same call the inbox piece makes, read off its key.
  static List<YPost> forPundits({
    required String competition,
    required String favourite,
    required String darkHorse,
    required DateTime date,
    required String key,
    required String nation,
    required int seed,
    List<ResultStanding> history = const [],
  }) {
    return distinctWording([
      for (final voice in const [YVoice.pundit, YVoice.expro])
        () {
          final persona = personaFor(voice, nation, seed, key);
          return _post(
            voice: voice,
            template: YTemplate.punditPick,
            args: [competition, favourite, darkHorse],
            date: date,
            key: key,
            nation: nation,
            seed: seed,
            tone: YCast.toneFor(
              persona,
              ResultStanding.par,
              YCast.stance(persona, history),
            ),
            as: persona,
          );
        }(),
    ]);
  }

  /// [posts] about one event, with no two of them saying the same sentence.
  ///
  /// Each account picks its wording from its own seed and tone band, and a
  /// once-a-cycle template has only four, so the wire, a fan and the ex-pro
  /// were posting the identical line about one exit. A wording already taken
  /// moves the later post on to the next free one.
  static List<YPost> distinctWording(List<YPost> posts) {
    final used = <String, Set<int>>{};
    return [
      for (final p in posts)
        () {
          final group = p.mood == null
              ? 't:${p.template.name}'
              : 'm:${p.mood!.name}';
          final spread = p.mood == null
              ? variantsFor(p.template)
              : reactionVariantsFor(p.mood!);
          final taken = used.putIfAbsent(group, () => <int>{});
          var variant = p.variant;
          for (var i = 0; i < spread && taken.contains(variant); i++) {
            variant = (variant + 1) % spread;
          }
          taken.add(variant);
          return variant == p.variant
              ? p
              : (
                  voice: p.voice,
                  handle: p.handle,
                  displayName: p.displayName,
                  template: p.template,
                  variant: variant,
                  args: p.args,
                  date: p.date,
                  key: p.key,
                  replyTo: p.replyTo,
                  mood: p.mood,
                );
        }(),
    ];
  }

  /// One thing that happened to a nation that is not a scoreline — a trophy, a
  /// exit, a place booked — ready to be handed to [forEvent].
  ///
  /// These templates have had full copy in both languages since the feed was
  /// built and NONE of them ever reached a screen: [forEvent] was written,
  /// tested, and never called by the app. A manager could win the World Cup and
  /// the country would post four match reports about the final and not one word
  /// about the trophy.
  static YMilestone? endOfCampaign({
    required String? round,
    required String competition,
    required bool won,
    required DateTime date,
    required String key,
    bool goneAtGroup = false,
  }) {
    if (round == null || round == Rounds.friendly) return null;
    // Continental rounds prefix a C, the Nations Cup an N; the World Cup uses
    // the bare code. What a round MEANS is its suffix.
    final core = round.startsWith('C') || round.startsWith('N')
        ? round.substring(1)
        : round;
    if (core == 'FINAL') {
      return (
        template: won ? YTemplate.trophy : YTemplate.runnerUp,
        args: [competition],
        date: date,
        // ':' and never '|': a post's key starts with the event, and the
        // detail view groups a conversation by the part before the FIRST
        // pipe — so a pipe in here would file every trophy ever won under
        // one conversation called "trophy".
        key: '${won ? "trophy" : "runnerup"}:$key',
      );
    }
    if (!finalsRounds.contains(core)) return null;
    // A knockout defeat is an exit and says so on its own. A GROUP table is
    // not: a side with no fixtures left may have topped the group and be
    // waiting on a draw nobody has made yet, or have gone up a league while
    // the trophy is settled above them. Only the caller can see whether the
    // tournament actually moved on without them, so until it says so this
    // stays quiet rather than telling a group winner he is out.
    if (core == 'GROUP' && !goneAtGroup) return null;
    return (
      template: YTemplate.eliminated,
      args: [competition],
      date: date,
      key: 'out:$key',
    );
  }

  /// The round codes (suffixes) a FINALS tournament is played in. Qualifying
  /// carries 'Q' or no code at all, and a qualifying campaign ending is not an
  /// elimination — it is either a place booked or a miss.
  ///
  /// Public because the feed provider has to tell a tournament from a campaign
  /// to know which of those two a finished competition was.
  static const Set<String> finalsRounds = {
    'GROUP',
    'R32',
    'R16',
    'QF',
    'SF',
    '3RD',
    'FINAL',
  };

  /// The events big enough that a former international writes about them.
  static const Set<YTemplate> _bigEvents = {
    YTemplate.trophy,
    YTemplate.runnerUp,
    YTemplate.eliminated,
    YTemplate.qualified,
  };

  /// A player saying in public what he could not get said in your office.
  static List<YPost> forGrievance({
    required String playerName,
    required DateTime date,
    required String key,
    required String nation,
    required int seed,
  }) {
    final post = _post(
      voice: YVoice.player,
      template: YTemplate.playerGrievance,
      args: [playerName],
      date: date,
      key: key,
      nation: nation,
      seed: seed,
      authorName: playerName,
    );
    return [
      post,
      ...repliesTo(post, mood: YMood.fury, nation: nation, seed: seed),
    ];
  }

  /// The results as they stood on [when]: every standing dated on or before
  /// it, oldest first, ignoring anything that came after.
  ///
  /// A post derived from the save is rebuilt on every open, so whatever it is
  /// toned by has to be what was known on ITS day. Hand it today's run and a
  /// statement judged months ago re-words itself after every later result.
  static List<ResultStanding> standingsAsOf(
    List<({DateTime date, ResultStanding standing})> dated,
    DateTime when,
  ) => [
    for (final d in dated)
      if (!d.date.isAfter(when)) d.standing,
  ];

  /// What the country says once something the manager put on the record has
  /// been judged: it came true, or it did not.
  ///
  /// Nothing for a statement still [StatementStatus.open] (there is nothing
  /// to say yet) or [StatementStatus.lapsed] (the window closed on a job he no
  /// longer holds, and the country has moved on with him). Keyed by the
  /// statement's id and dated the day it was judged, so it lands in the feed
  /// next to the match that decided it and reads the same on every rebuild.
  static List<YPost> forStatement({
    required PressStatement s,
    required String nation,
    required int seed,
    ResultStanding standing = ResultStanding.par,
    List<ResultStanding> history = const [],
  }) {
    final judgedOn = s.judgedOn;
    final template = switch (s.status) {
      StatementStatus.kept => YTemplate.statementKept,
      StatementStatus.broken => YTemplate.statementBroken,
      StatementStatus.open || StatementStatus.lapsed => null,
    };
    if (template == null || judgedOn == null) return const [];
    final key = 'stmt:${s.id}';
    final persona = personaFor(YVoice.fan, nation, seed, key);
    final post = _post(
      voice: YVoice.fan,
      template: template,
      args: [nation],
      date: judgedOn,
      key: key,
      nation: nation,
      seed: seed,
      tone: YCast.toneFor(persona, standing, YCast.stance(persona, history)),
    );
    return [
      post,
      ...repliesTo(
        post,
        mood: moodOf(template),
        nation: nation,
        seed: seed,
        standing: standing,
        history: history,
      ),
    ];
  }

  /// What the country says about one thing that happened on the pitch.
  ///
  /// It takes the SAME [PressSubjectIncident] the press room does, so the
  /// question a reporter puts to the manager and the post a supporter writes
  /// are two readings of one event rather than two systems that happen to
  /// agree. Only a sending-off of one of ours is worth a post today: a knock
  /// already has [YTemplate.injuryBlow] behind it, and a goal has the match
  /// report.
  ///
  /// [standing] and [history] are what make the cast read differently about
  /// the same red card — a loyalist reaches for the generous third of the
  /// wordings and a cynic for the sour one, exactly as they do about a
  /// result. Nothing here is a second persona system; see [YCast].
  static List<YPost> forIncident({
    required PressSubjectIncident incident,
    required DateTime date,
    required String key,
    required String nation,
    required int seed,
    ResultStanding standing = ResultStanding.par,
    List<ResultStanding> history = const [],
  }) {
    if (incident.type != MatchEventType.redCard || !incident.ours) {
      return const [];
    }
    final name = incident.name;
    // A post that cannot name him would be the generality the feed already
    // had too much of.
    if (name == null) return const [];
    final args = [name, '${incident.minute}'];
    final posts = [
      for (final voice in const [YVoice.fan, YVoice.expro])
        () {
          final persona = personaFor(voice, nation, seed, key);
          return _post(
            voice: voice,
            template: YTemplate.sentOff,
            args: args,
            date: date,
            key: key,
            nation: nation,
            seed: seed,
            tone: YCast.toneFor(
              persona,
              standing,
              YCast.stance(persona, history),
            ),
          );
        }(),
    ];
    return [
      ...posts,
      ...repliesTo(
        posts.first,
        mood: YMood.fury,
        nation: nation,
        seed: seed,
        standing: standing,
        history: history,
      ),
    ];
  }

  /// What the country says about one of the manager's MEN.
  ///
  /// The same [PressSubjectPlayer] the conference is built on, so the question
  /// a reporter puts and the post a supporter writes are two readings of one
  /// selection rather than two systems that happen to agree — exactly as
  /// [forIncident] does for a red card.
  ///
  /// Not every player topic is worth a post: a dropped star and a captain out
  /// of form are arguments for a press room, where somebody has to answer
  /// them. The two the country talks about on its own are the boy who has just
  /// been handed a shirt and the forward who has stopped scoring.
  static List<YPost> forPlayer({
    required PressTopic topic,
    required PressSubjectPlayer subject,
    required DateTime date,
    required String key,
    required String nation,
    required int seed,
    ResultStanding standing = ResultStanding.par,
    List<ResultStanding> history = const [],
  }) {
    final (template, args) = switch (topic) {
      PressTopic.debutant => (YTemplate.debut, [subject.name]),
      PressTopic.strikerDrought => (
        YTemplate.drought,
        [subject.name, '${subject.count}'],
      ),
      _ => (null, const <String>[]),
    };
    if (template == null) return const [];
    return _castPosts(
      voices: const [YVoice.fan, YVoice.expro],
      template: template,
      args: args,
      date: date,
      key: key,
      nation: nation,
      seed: seed,
      standing: standing,
      history: history,
    );
  }

  /// …and about the side it is about to play.
  ///
  /// Only a rivalry: a head-to-head run and a grudge from a tournament exit
  /// are what a reporter opens a conference with, and a feed that posted every
  /// fixture's record would be the stats desk talking to itself.
  static List<YPost> forOpponent({
    required PressTopic topic,
    required PressSubjectOpponent subject,
    required String opponent,
    required DateTime date,
    required String key,
    required String nation,
    required int seed,
    ResultStanding standing = ResultStanding.par,
    List<ResultStanding> history = const [],
  }) {
    if (topic != PressTopic.rivalryNext) return const [];
    return _castPosts(
      voices: const [YVoice.fan, YVoice.rival],
      template: YTemplate.rivalryLooms,
      args: [opponent, '${subject.count}'],
      date: date,
      key: key,
      nation: nation,
      seed: seed,
      standing: standing,
      history: history,
    );
  }

  /// …and about the man in the other dugout: one post before a match against
  /// [manager] when the player has a tie with him ([label] not neutral),
  /// none otherwise. No thread under it: it is a line, not a story.
  ///
  /// One of the fans says it, in his own tone (see [YCast.toneFor]): the
  /// tie decides that there is a post, the speaker decides how it sounds.
  /// [nation] is the player's nation, whose fans these are; [manager] is a
  /// name and is never translated.
  static List<YPost> forOpponentManager({
    required String manager,
    required TieLabel label,
    required DateTime date,
    required String key,
    required String nation,
    required int seed,
    ResultStanding standing = ResultStanding.par,
  }) {
    if (label == TieLabel.neutral || manager.trim().isEmpty) return const [];
    const voice = YVoice.fan;
    final persona = personaFor(voice, nation, seed, key);
    return [
      _post(
        voice: voice,
        template: YTemplate.managerTieLooms,
        args: [manager],
        date: date,
        key: key,
        nation: nation,
        seed: seed,
        tone: YCast.toneFor(
          persona,
          standing,
          YCast.stance(persona, const []),
        ),
        as: persona,
      ),
    ];
  }

  /// One subject, said by each of [voices] in its own persona's tone, with the
  /// thread the loudest of them draws.
  ///
  /// The shared body of [forPlayer] and [forOpponent] — and the shape
  /// [forIncident] already had, written out once instead of three times.
  static List<YPost> _castPosts({
    required List<YVoice> voices,
    required YTemplate template,
    required List<String> args,
    required DateTime date,
    required String key,
    required String nation,
    required int seed,
    required ResultStanding standing,
    required List<ResultStanding> history,
  }) {
    final posts = [
      for (final voice in voices)
        () {
          final persona = personaFor(voice, nation, seed, key);
          return _post(
            voice: voice,
            template: template,
            args: args,
            date: date,
            key: key,
            nation: nation,
            seed: seed,
            tone: YCast.toneFor(
              persona,
              standing,
              YCast.stance(persona, history),
            ),
          );
        }(),
    ];
    return [
      ...posts,
      ...repliesTo(
        posts.first,
        mood: moodOf(template),
        nation: nation,
        seed: seed,
        standing: standing,
        history: history,
      ),
    ];
  }

  /// What the country says about an afternoon the second half turned over.
  ///
  /// It reads the same [halfTimeSwingOf] the press room does, so the question a
  /// reporter puts to the manager and the posts under it are two readings of
  /// one match rather than two systems that happen to agree.
  ///
  /// The wordings are where this one is unusual: in Czech they are built on a
  /// local in-joke and in English they are not, deliberately. The DOMAIN knows
  /// nothing about that — it decides that there is a post and which band of
  /// wordings the author reaches for, exactly as it does for a red card.
  static List<YPost> forSwing({
    required HalfTimeSwing swing,
    required String opponent,
    required DateTime date,
    required String key,
    required String nation,
    required int seed,
    ResultStanding standing = ResultStanding.par,
    List<ResultStanding> history = const [],
  }) {
    final template = swing == HalfTimeSwing.comeback
        ? YTemplate.turnedItRound
        : YTemplate.threwItAway;
    final posts = [
      // The same two accounts a red card draws: one of our own, and the former
      // international with a column. The supporters' pool holds no loyalist and
      // the ex-pros' holds both a loyalist and a cynic, which is what lets one
      // afternoon read two ways.
      for (final voice in const [YVoice.fan, YVoice.expro])
        () {
          final persona = personaFor(voice, nation, seed, key);
          return _post(
            voice: voice,
            template: template,
            args: [opponent],
            date: date,
            key: key,
            nation: nation,
            seed: seed,
            tone: YCast.toneFor(
              persona,
              standing,
              YCast.stance(persona, history),
            ),
          );
        }(),
    ];
    return [
      ...posts,
      ...repliesTo(
        posts.first,
        mood: moodOf(template),
        nation: nation,
        seed: seed,
        standing: standing,
        history: history,
      ),
    ];
  }

  /// The things that happen to a nation a handful of times a cycle, as opposed
  /// to the running commentary on its results.
  ///
  /// These get a reserved share of the feed. Every one of them is outnumbered
  /// hundreds to one by match reports, and a feed capped purely by recency
  /// therefore buried them: by the time a manager reached the World
  /// Championship, the continental championship two years earlier — the place
  /// booked, the group drawn, the way it ended — had scrolled off the bottom
  /// and the country appeared never to have mentioned it at all.
  static const Set<YTemplate> landmarks = {
    YTemplate.trophy,
    YTemplate.runnerUp,
    YTemplate.eliminated,
    YTemplate.qualified,
    YTemplate.qualifiedEuphoric,
    YTemplate.trophyEuphoric,
    YTemplate.exitHeartbreak,
    YTemplate.exitProud,
    YTemplate.exitAccepted,
    YTemplate.punditPick,
    YTemplate.groupDrawn,
    YTemplate.hostNamed,
    YTemplate.tournamentSoon,
  };

  /// Newest first, and capped — a long save would otherwise build a feed
  /// nobody can scroll to the end of.
  ///
  /// The cap counts POSTS OF THEIR OWN and carries each one's replies with it:
  /// counting replies too would let a busy thread crowd out a whole month, and
  /// cutting between a post and its replies would leave answers to nothing.
  ///
  /// [landmarkCap] is a second, smaller window reserved for the [landmarks] —
  /// the tournaments themselves — so that a cycle's story survives the chatter
  /// of the matches that fill the months between them. Twenty-four roots is
  /// comfortably a whole cycle's worth: a tournament speaks two or three times
  /// (the wire, the fans, and for the big ones a former international), and a
  /// cycle holds about eight such moments.
  static List<YPost> mostRecent(
    List<YPost> all, {
    int cap = 60,
    int landmarkCap = 24,
  }) => timeline(all, cap: cap, landmarkCap: landmarkCap).posts;

  /// The same feed, with the seam reported.
  ///
  /// The rescued landmarks sit BELOW the recency window, which means the feed
  /// jumps back in time partway down — from this spring to a tournament two
  /// summers ago, with nothing on screen to say so. That reads as a bug in the
  /// feed rather than as older news, so the screen draws a heading at the
  /// seam. It is told where the seam is rather than left to infer it from the
  /// dates: this is the only place that knows which posts were rescued, and a
  /// widget guessing from a date gap would be wrong the moment two tournaments
  /// fell in the same month.
  static YTimeline timeline(
    List<YPost> all, {
    int cap = 60,
    int landmarkCap = 24,
  }) {
    final repliesByParent = <String, List<YPost>>{};
    final roots = <YPost>[];
    for (final p in all) {
      if (p.replyTo case final parent?) {
        (repliesByParent[parent] ??= []).add(p);
      } else {
        roots.add(p);
      }
    }
    roots.sort((a, b) => b.date.compareTo(a.date));
    final kept = roots.take(cap).toList();
    final keptKeys = {for (final r in kept) r.key};
    // Whatever the recency window cut, the newest landmarks come back — never
    // more than [landmarkCap] of them, so an endless career cannot grow a feed
    // of nothing but old trophies.
    //
    // Appended rather than merged and re-sorted: every rescued root is older
    // than everything the window kept, so the two runs are already in order,
    // and concatenating them keeps the reserve one unbroken block with a seam
    // that can be pointed at.
    final rescued = [
      for (final r in roots)
        if (landmarks.contains(r.template) && !keptKeys.contains(r.key)) r,
    ].take(landmarkCap).toList();

    final posts = <YPost>[];
    for (final root in kept) {
      posts
        ..add(root)
        ..addAll(repliesByParent[root.key] ?? const []);
    }
    final reserveFrom = rescued.isEmpty ? null : posts.length;
    for (final root in rescued) {
      posts
        ..add(root)
        ..addAll(repliesByParent[root.key] ?? const []);
    }
    return (posts: posts, reserveFrom: reserveFrom);
  }

  /// The nation's pundit: the same man all career, a different one next door.
  static String punditHandle(String nation, int seed) {
    final names = _punditNames;
    return '@${names[(varietySeed(nation) ^ seed) % names.length]}';
  }

  static YPost _post({
    required YVoice voice,
    required YTemplate template,
    required List<String> args,
    required DateTime date,
    required String key,
    required String nation,
    required int seed,
    String? authorName,
    String? replyTo,
    YMood? mood,
    YTone tone = YTone.neutral,
    YPersona? as,
  }) {
    // Seeded by the event AND the voice, so two people reacting to the same
    // match never reach for the same sentence — and banded by TONE, so the
    // sentence reached for is one this account would actually write. Twelve
    // wordings picked by a hash is still one voice; twelve wordings picked by
    // disposition is a room.
    final spread = mood == null
        ? variantsFor(template)
        : reactionVariantsFor(mood);
    final variant = YCast.variantFor(
      key: '$key|${voice.name}',
      tone: tone,
      total: spread,
    );
    final persona =
        as ??
        (authorName == null
            ? personaFor(voice, nation, seed, key)
            : (
                handle: '@${authorName.replaceAll(' ', '')}',
                displayName: authorName,
                trait: YTrait.loyalist,
              ));
    final handle = persona.handle;
    final display = persona.displayName;
    return (
      voice: voice,
      handle: handle,
      displayName: display,
      template: template,
      variant: variant,
      args: args,
      date: date,
      // The TEMPLATE is part of the key, not just the voice. One match is
      // worth several things to the same account — the stats desk posts the
      // scoreline AND the man who got them — and keyed by voice alone those
      // two posts were the same post twice over: [mostRecent] hung the whole
      // reply thread off each of them, so the country said the same words
      // twice under one match, and the detail view hid the second post from
      // its own conversation.
      key: '$key|${voice.name}|${template.name}',
      replyTo: replyTo,
      mood: mood,
    );
  }

  /// The replies under [parent] — the bit that makes a feed read like a feed
  /// rather than a noticeboard.
  ///
  /// Who piles in depends on the mood: good news brings the meme account and
  /// the fans, bad news brings the ex-pro and whoever is enjoying it.
  static List<YPost> repliesTo(
    YPost parent, {
    required YMood mood,
    required String nation,
    required int seed,
    ResultStanding standing = ResultStanding.par,
    List<ResultStanding> history = const [],
    int heat = 0,
  }) {
    final voices = switch (mood) {
      YMood.elation => const [YVoice.meme, YVoice.fan],
      YMood.relief => const [YVoice.fan, YVoice.expro],
      YMood.fury => const [YVoice.expro, YVoice.rival, YVoice.meme],
      // The rival first: a crushing result is the one he always turns up for,
      // and he no longer posts the result itself (see [forMatch]).
      YMood.despair => const [YVoice.rival, YVoice.meme, YVoice.expro],
      YMood.smugness => const [YVoice.rival, YVoice.meme],
      YMood.shrug => const [YVoice.meme],
      // Nobody is enjoying this one: the rival has nothing to gloat about in
      // a run that went further than ours were ever meant to.
      YMood.pride ||
      YMood.acceptance => const [YVoice.fan, YVoice.meme, YVoice.expro],
    };
    // How many of them actually bother, drawn from the parent so the same post
    // always draws the same thread. A big afternoon brings every one of them.
    final count = heat >= 3
        ? voices.length
        : 1 + varietySeed('replies|${parent.key}') % voices.length;
    // Keyed off the EVENT with a `re` segment: the detail view groups a
    // conversation by the part before the first `|`, so a reply keyed any
    // other way would land under an event of its own.
    final event = parent.key.split('|').first;
    return [
      for (final voice in voices.take(count))
        () {
          final persona = personaFor(voice, nation, seed, event);
          // Our fury is the rival's fun: he answers it smug, never in the
          // home fans' own words.
          final rival = voice == YVoice.rival;
          return _post(
            voice: voice,
            template: YTemplate.reaction,
            args: const [],
            date: parent.date,
            key: '$event|re',
            nation: nation,
            seed: seed,
            replyTo: parent.key,
            mood: rival ? YMood.smugness : mood,
            tone: rival
                ? YTone.sour
                : YCast.toneFor(
                    persona,
                    standing,
                    YCast.stance(persona, history),
                  ),
          );
        }(),
    ];
  }

  /// How a template reads to the room, for the replies it draws.
  static YMood moodOf(YTemplate template) => switch (template) {
    YTemplate.winUpset ||
    YTemplate.trophy ||
    YTemplate.scorerStar => YMood.elation,
    // The magnitude of a result reads the way the result does, louder.
    YTemplate.winRout ||
    YTemplate.winShootout ||
    YTemplate.knockoutWin ||
    YTemplate.upsetGap ||
    YTemplate.neutralWin ||
    YTemplate.scorerHero => YMood.elation,
    YTemplate.drewHeroic => YMood.relief,
    YTemplate.winEuphoric || YTemplate.drewGiant => YMood.elation,
    YTemplate.qualifiedEuphoric ||
    YTemplate.knockoutEuphoric ||
    YTemplate.trophyEuphoric => YMood.elation,
    YTemplate.exitHeartbreak => YMood.despair,
    YTemplate.exitProud => YMood.pride,
    YTemplate.exitAccepted => YMood.acceptance,
    // A prediction is anticipation, like a final looming: nerves.
    YTemplate.punditPick => YMood.relief,
    // Our supporters are not sorry for theirs, and enjoy a critic being wrong.
    YTemplate.eatWords || YTemplate.awayFansWin => YMood.smugness,
    YTemplate.lostShock ||
    YTemplate.drewShame ||
    YTemplate.downGap ||
    YTemplate.awayFansGloat => YMood.fury,
    YTemplate.lostRout ||
    YTemplate.lostShootout ||
    YTemplate.knockoutLoss ||
    YTemplate.neutralLoss => YMood.despair,
    YTemplate.winTight || YTemplate.qualified => YMood.relief,
    // Anticipation, which is nerves — the replies under it should read like a
    // country holding its breath, not celebrating something that has not
    // happened.
    YTemplate.finalLooms => YMood.relief,
    YTemplate.lost ||
    YTemplate.lossStreak ||
    YTemplate.playerGrievance => YMood.fury,
    YTemplate.lostBadly ||
    YTemplate.runnerUp ||
    YTemplate.eliminated ||
    YTemplate.injuryBlow ||
    YTemplate.boardPressure => YMood.despair,
    // A knock is bad luck and a red card is somebody's fault, which is the
    // difference between the room despairing and the room turning on him.
    YTemplate.sentOff => YMood.fury,
    // Coming from two down is the best afternoon there is short of a trophy;
    // losing from two up is the one the room does not forgive.
    YTemplate.turnedItRound => YMood.elation,
    YTemplate.threwItAway => YMood.fury,
    YTemplate.winStreak || YTemplate.toldYouSo => YMood.smugness,
    // A boy handed a shirt is the one bit of good news that is not a result,
    // and a forward who cannot score is the one bit of bad news that is not
    // one either. A rivalry coming up is nerves, which is what relief reads as
    // before the fact.
    YTemplate.debut => YMood.elation,
    YTemplate.drought => YMood.fury,
    YTemplate.rivalryLooms => YMood.relief,
    YTemplate.managerTieLooms => YMood.relief,
    // He said it on the record. Delivering it is a good day; failing to is
    // the room turning on him, like a grievance aired in public.
    YTemplate.statementKept => YMood.elation,
    YTemplate.statementBroken => YMood.fury,
    YTemplate.fansProtest => YMood.fury,
    YTemplate.fansSellOut => YMood.elation,
    // Selling the shirt to a joke of a brand: the room laughing at its own.
    YTemplate.sponsorDubious || YTemplate.sponsorMocked => YMood.despair,
    // A night out in the papers is the room turning on one of its own; a man
    // sent home for it is a relief, a man kept is the fury again.
    YTemplate.scandalParty ||
    YTemplate.scandalCurfew ||
    YTemplate.scandalNightclub ||
    YTemplate.scandalCasino ||
    YTemplate.scandalKept => YMood.fury,
    YTemplate.scandalSentHome => YMood.relief,
    // Replies of their own, like [YTemplate.reaction].
    YTemplate.streamerBreaks ||
    YTemplate.streamerSentHome ||
    YTemplate.streamerKept ||
    YTemplate.cameoUjfaloci ||
    YTemplate.cameoHavir ||
    YTemplate.cameoLzimberskyHome ||
    YTemplate.cameoLzimberskyKept ||
    YTemplate.cameoMarena ||
    YTemplate.cameoKralik ||
    YTemplate.cameoPosuk => YMood.shrug,
    YTemplate.legendRetires => YMood.shrug,
    // A repeat is read by what it repeats: being done over by the same side
    // again is fury, and a familiar bad afternoon is weariness.
    YTemplate.againstThemAgain => YMood.fury,
    YTemplate.sameOldStory => YMood.despair,
    YTemplate.winRoutine ||
    YTemplate.drew ||
    YTemplate.rivalry ||
    YTemplate.groupDrawn ||
    YTemplate.hostNamed ||
    YTemplate.tournamentSoon ||
    YTemplate.reaction => YMood.shrug,
  };

  /// @IShowSlowness: a streamer who has never used his indoor voice, under
  /// every camp scandal in every language. A loose parody of the genre, no
  /// one streamer's catchphrases.
  static const YPersona streamerPersona = (
    handle: '@IShowSlowness',
    displayName: 'IShowSlowness',
    trait: YTrait.streamer,
  );

  /// Tomáš Ujfaloči: one line under every camp scandal, in a Czech feed only.
  static const YPersona ujfalociPersona = (
    handle: '@TomasUjfaloci',
    displayName: 'Tomáš Ujfaloči',
    trait: YTrait.cynic,
  );

  /// Ivan Havíř: an old-school former federation boss, fatalistic, in a
  /// Czech feed only and rarely (see [withHavir]).
  static const YPersona havirPersona = (
    handle: '@IvanHavir',
    displayName: 'Ivan Havíř',
    trait: YTrait.doomer,
  );

  /// Pitomo Lžimberský: a populist blowhard who takes the player's side
  /// against the "hypocritical media", in a Czech feed only.
  static const YPersona lzimberskyPersona = (
    handle: '@PitomoLzimbersky',
    displayName: 'Pitomo Lžimberský',
    trait: YTrait.contrarian,
  );

  /// Mařena: sure she could do the job herself, after a hammering. Czech
  /// feed only (see [withRegulars]).
  static const YPersona marenaPersona = (
    handle: '@Marena',
    displayName: 'Mařena',
    trait: YTrait.cynic,
  );

  /// KudyChodíKrálík: a crisp brand's account that turns every defeat into
  /// an advert. Czech feed only (see [withRegulars]).
  static const YPersona kralikPersona = (
    handle: '@KudyChodiKralik',
    displayName: 'KudyChodíKrálík',
    trait: YTrait.contrarian,
  );

  /// POŠUK: shouts nonsense in capitals under a result now and then. Czech
  /// feed only (see [withRegulars]).
  static const YPersona posukPersona = (
    handle: '@POSUK',
    displayName: 'POŠUK',
    trait: YTrait.doomer,
  );

  /// The accounts only a Czech feed has.
  ///
  /// Owner-requested cameos, Czech in-jokes that would mean nothing anywhere
  /// else. The DOMAIN decides whether they post ([forScandal]'s
  /// `czechCameos`, [withHavir]); the copy exists in every language because
  /// the copy file requires it, but no other language ever shows it.
  static const List<YPersona> czechCameos = [
    ujfalociPersona,
    havirPersona,
    lzimberskyPersona,
    marenaPersona,
    kralikPersona,
    posukPersona,
  ];

  /// The template a scandal of [kind] breaks with.
  static YTemplate scandalTemplate(ScandalKind kind) => switch (kind) {
    ScandalKind.party => YTemplate.scandalParty,
    ScandalKind.curfew => YTemplate.scandalCurfew,
    ScandalKind.nightclub => YTemplate.scandalNightclub,
    ScandalKind.casino => YTemplate.scandalCasino,
  };

  /// The templates a camp scandal breaks with.
  static const Set<YTemplate> scandalTemplates = {
    YTemplate.scandalParty,
    YTemplate.scandalCurfew,
    YTemplate.scandalNightclub,
    YTemplate.scandalCasino,
  };

  /// What the country says when the federation signs a dubious general
  /// sponsor (the risky deal of `Sponsors`): the wire has the story and a fan
  /// after, then the room piles in under it, the rival enjoying it most.
  /// [brand] is the brand's name as the manager reads it.
  static List<YPost> forSponsor({
    required String brand,
    required DateTime date,
    required String key,
    required String nation,
    required int seed,
    ResultStanding standing = ResultStanding.par,
    List<ResultStanding> history = const [],
  }) {
    YTone toneOf(YVoice voice) {
      final persona = personaFor(voice, nation, seed, key);
      return YCast.toneFor(persona, standing, YCast.stance(persona, history));
    }

    final roots = distinctWording([
      _post(
        voice: YVoice.breaking,
        template: YTemplate.sponsorDubious,
        args: [brand],
        date: date,
        key: key,
        nation: nation,
        seed: seed,
      ),
      _post(
        voice: YVoice.fan,
        template: YTemplate.sponsorDubious,
        args: [brand],
        date: date,
        key: key,
        nation: nation,
        seed: seed,
        tone: toneOf(YVoice.fan),
      ),
    ]);
    final story = roots.first;
    final replies = distinctWording([
      for (final voice in const [YVoice.fan, YVoice.expro, YVoice.rival])
        _post(
          voice: voice,
          template: YTemplate.sponsorMocked,
          args: [brand],
          date: date,
          key: '$key|re',
          nation: nation,
          seed: seed,
          replyTo: story.key,
          // The rival has been waiting for this one: sour.
          tone: voice == YVoice.rival ? YTone.sour : toneOf(voice),
        ),
    ]);
    return [...roots, ...replies];
  }

  /// What the country says about a camp scandal: the story breaking, and,
  /// once the manager has answered ([choice]), the room on what he did.
  ///
  /// The wire has it first and a fan after; @IShowSlowness replies under the
  /// story and again under the decision. Sent home draws the right call,
  /// discipline or harsh, by who is talking; kept draws anger, and the rival
  /// mocking it. With [czechCameos], Tomáš Ujfaloči says his one line and
  /// Pitomo Lžimberský defends the lad.
  static List<YPost> forScandal({
    required ScandalKind kind,
    required String playerName,
    required ScandalChoice? choice,
    required DateTime date,
    required String key,
    required String nation,
    required int seed,
    bool czechCameos = false,
    bool familyFirst = false,
    ResultStanding standing = ResultStanding.par,
    List<ResultStanding> history = const [],
  }) {
    final template = scandalTemplate(kind);
    final args = [playerName, hashtagOf(playerName, familyFirst: familyFirst)];
    YTone toneOf(YVoice voice) {
      final persona = personaFor(voice, nation, seed, key);
      return YCast.toneFor(persona, standing, YCast.stance(persona, history));
    }

    final roots = distinctWording([
      _post(
        voice: YVoice.breaking,
        template: template,
        args: args,
        date: date,
        key: key,
        nation: nation,
        seed: seed,
      ),
      _post(
        voice: YVoice.fan,
        template: template,
        args: args,
        date: date,
        key: key,
        nation: nation,
        seed: seed,
        tone: toneOf(YVoice.fan),
      ),
    ]);
    final story = roots.first;
    YPost reply(
      YVoice voice,
      YTemplate t, {
      YPersona? as,
      YTone? tone,
      List<String> args = const [],
    }) => _post(
      voice: voice,
      template: t,
      args: args,
      date: date,
      key: '$key|re',
      nation: nation,
      seed: seed,
      replyTo: story.key,
      as: as,
      tone: tone ?? YTone.neutral,
    );

    final replies = <YPost>[
      // He is under the story the moment it breaks, whatever happens next.
      _spread(reply(YVoice.streamer, YTemplate.streamerBreaks), '$key|sb'),
      if (choice != null) ...[
        _spread(
          reply(
            YVoice.streamer,
            choice == ScandalChoice.sentHome
                ? YTemplate.streamerSentHome
                : YTemplate.streamerKept,
          ),
          '$key|sd',
        ),
        ...distinctWording([
          for (final voice
              in choice == ScandalChoice.sentHome
                  ? const [YVoice.fan, YVoice.expro]
                  : const [YVoice.fan, YVoice.expro, YVoice.rival])
            reply(
              voice,
              choice == ScandalChoice.sentHome
                  ? YTemplate.scandalSentHome
                  : YTemplate.scandalKept,
              args: [playerName],
              // The rival enjoys a kept man as much as a lost match: sour.
              tone: voice == YVoice.rival ? YTone.sour : toneOf(voice),
            ),
        ]),
      ],
      if (czechCameos) ...[
        reply(YVoice.cameo, YTemplate.cameoUjfaloci, as: ujfalociPersona),
        if (choice != null)
          _spread(
            reply(
              YVoice.cameo,
              choice == ScandalChoice.sentHome
                  ? YTemplate.cameoLzimberskyHome
                  : YTemplate.cameoLzimberskyKept,
              as: lzimberskyPersona,
            ),
            '$key|lz',
          ),
      ],
    ];
    return [...roots, ...replies];
  }

  /// [p] with its wording drawn across ALL of its template's phrasings,
  /// seeded by [seed], rather than out of one tone band: a fixed account has
  /// one voice, not three moods.
  static YPost _spread(YPost p, String seed) {
    final total = variantsFor(p.template);
    return _withVariant(p, varietySeed(seed) % total);
  }

  static YPost _withVariant(YPost p, int variant) => (
    voice: p.voice,
    handle: p.handle,
    displayName: p.displayName,
    template: p.template,
    variant: variant,
    args: p.args,
    date: p.date,
    key: p.key,
    replyTo: p.replyTo,
    mood: p.mood,
  );

  /// The disappointments Ivan Havíř turns up for: an exit, a knockout lost, a
  /// hammering. A heavy defeat only now and then (see [withHavir]).
  static const Set<YTemplate> havirExits = {
    YTemplate.eliminated,
    YTemplate.knockoutLoss,
  };
  static const Set<YTemplate> havirHeavyDefeats = {
    YTemplate.lostBadly,
    YTemplate.lostRout,
  };

  /// The shortest gap between two Havíř posts: about a window. He is a
  /// cameo, and a cameo every week is a regular.
  static const Duration havirGap = Duration(days: 30);

  /// How many heavy defeats a year he may turn up for, counting everything
  /// else he said that year. A weak side loses heavily most windows, and
  /// with only the gap above he became a regular under every one of them.
  static const int havirHeavyPerYear = 1;

  /// The lines that fit a camp scandal, which comes before any match: the
  /// signature, "I said so in September", the pond freezing, the old boot.
  /// The others talk about a result.
  static const List<int> havirScandalLines = [0, 2, 5, 6];

  /// [posts] with Ivan Havíř's shrug added under the big disappointments, for
  /// a Czech feed only: with [czechCameos] false, [posts] come back as they
  /// went in.
  ///
  /// He replies under a camp scandal, a finals exit and a knockout lost, and
  /// posts on his own when a qualifying campaign came up short ([misses]:
  /// there is no wire post to reply to). Those are rare by nature. A heavy
  /// defeat draws him one time in four, and only if he has said nothing else
  /// in the year before it ([havirHeavyPerYear]). Never more than one in
  /// [havirGap], so at most one a window. Derived like the rest of the feed,
  /// so the same save always draws him in the same places.
  static List<YPost> withHavir(
    List<YPost> posts, {
    required bool czechCameos,
    List<({DateTime date, String key})> misses = const [],
  }) {
    if (!czechCameos) return posts;
    // One root per event: the first post of that event that qualifies.
    final seen = <String>{};
    final major = <({DateTime date, String event, YPost? parent})>[];
    final heavy = <({DateTime date, String event, YPost? parent})>[];
    for (final p in posts) {
      if (p.replyTo != null) continue;
      final event = p.key.split('|').first;
      if (seen.contains(event)) continue;
      final isMajor =
          scandalTemplates.contains(p.template) ||
          havirExits.contains(p.template);
      final isHeavy =
          havirHeavyDefeats.contains(p.template) &&
          varietySeed('havir|heavy|$event') % 4 == 0;
      if (!isMajor && !isHeavy) continue;
      seen.add(event);
      (isMajor ? major : heavy).add((date: p.date, event: event, parent: p));
    }
    for (final m in misses) {
      major.add((date: m.date, event: m.key, parent: null));
    }
    int byDate(
      ({DateTime date, String event, YPost? parent}) a,
      ({DateTime date, String event, YPost? parent}) b,
    ) {
      final d = a.date.compareTo(b.date);
      return d != 0 ? d : a.event.compareTo(b.event);
    }

    major.sort(byDate);
    heavy.sort(byDate);
    final placed = <({DateTime date, String event, YPost? parent})>[];
    bool clear(DateTime d) =>
        placed.every((p) => d.difference(p.date).abs() >= havirGap);
    // The big disappointments first, so a hammering in March never crowds
    // out the exit in June; then the odd hammering where the year is quiet.
    for (final c in major) {
      if (clear(c.date)) placed.add(c);
    }
    for (final c in heavy) {
      if (!clear(c.date)) continue;
      final yearBefore = placed
          .where(
            (p) =>
                !p.date.isAfter(c.date) &&
                c.date.difference(p.date) < const Duration(days: 365),
          )
          .length;
      if (yearBefore >= havirHeavyPerYear) continue;
      placed.add(c);
    }
    final out = [...posts];
    for (final c in placed) {
      final h = varietySeed('havir|${c.event}');
      final parent = c.parent;
      final onScandal =
          parent != null && scandalTemplates.contains(parent.template);
      // The signature line one time in three; otherwise one of the others
      // that fits what he is answering.
      final variant = onScandal
          ? havirScandalLines[h % havirScandalLines.length]
          : (h % 3 == 0 ? 0 : 1 + (h ~/ 3) % (havirVariantCount - 1));
      out.add(
        _withVariant(
          (
            voice: YVoice.cameo,
            handle: havirPersona.handle,
            displayName: havirPersona.displayName,
            template: YTemplate.cameoHavir,
            variant: 0,
            args: const <String>[],
            date: c.date,
            key: parent == null
                ? '${c.event}|cameo|${YTemplate.cameoHavir.name}'
                : '${c.event}|re|cameo|${YTemplate.cameoHavir.name}',
            replyTo: parent?.key,
            mood: null,
          ),
          variant,
        ),
      );
    }
    return out;
  }

  /// The headline of a match: what [classify] can call a result. The first
  /// post of every match carries one (see [forMatch]).
  static const Set<YTemplate> resultTemplates = {
    YTemplate.winShootout,
    YTemplate.winEuphoric,
    YTemplate.winUpset,
    YTemplate.winRout,
    YTemplate.winTight,
    YTemplate.winRoutine,
    YTemplate.drewGiant,
    YTemplate.drewHeroic,
    YTemplate.drewShame,
    YTemplate.drew,
    ...defeatTemplates,
  };

  /// The results that are a defeat, a shoot-out lost included.
  static const Set<YTemplate> defeatTemplates = {
    YTemplate.lost,
    YTemplate.lostShock,
    YTemplate.lostRout,
    YTemplate.lostBadly,
    YTemplate.lostShootout,
  };

  /// The shortest gap between two posts by the same regular (see
  /// [withRegulars]): about a window, as with Havíř.
  static const Duration regularGap = havirGap;

  /// [posts] with the Czech feed's regulars added under the results, for a
  /// Czech feed only: with [czechCameos] false, [posts] come back as they
  /// went in. Run it after [withHavir], whose replies it reads.
  ///
  /// - Mařena under a heavy defeat ([havirHeavyDefeats]) one time in three,
  ///   never under one Havíř already answered.
  /// - KudyChodíKrálík under a defeat one time in four, never under one
  ///   Mařena answered.
  /// - POŠUK under any result one time in ten, with one of his three shouts.
  ///
  /// Each at most once in [regularGap], so at most once a window. Derived
  /// like the rest of the feed, so a save always draws them in the same
  /// places.
  static List<YPost> withRegulars(
    List<YPost> posts, {
    required bool czechCameos,
  }) {
    if (!czechCameos) return posts;
    String eventOf(YPost p) => p.key.split('|').first;
    final havirEvents = {
      for (final p in posts)
        if (p.handle == havirPersona.handle) eventOf(p),
    };
    // One headline per match: the first root post that is a result.
    final seen = <String>{};
    final results = <({YPost parent, String event})>[];
    for (final p in posts) {
      if (p.replyTo != null || !resultTemplates.contains(p.template)) continue;
      final event = eventOf(p);
      if (!seen.add(event)) continue;
      results.add((parent: p, event: event));
    }
    results.sort((a, b) {
      final d = a.parent.date.compareTo(b.parent.date);
      return d != 0 ? d : a.event.compareTo(b.event);
    });

    final out = [...posts];
    // Picks, in date order, the results [persona] answers: the ones [wants]
    // and at least [regularGap] after the last one it answered.
    Set<String> place(
      YPersona persona,
      YTemplate template,
      bool Function(YPost parent, String event) wants, {
      int Function(String event)? variantOf,
    }) {
      final placed = <String>{};
      DateTime? last;
      for (final r in results) {
        if (!wants(r.parent, r.event)) continue;
        final date = r.parent.date;
        if (last != null && date.difference(last).abs() < regularGap) {
          continue;
        }
        last = date;
        placed.add(r.event);
        out.add(
          _withVariant(
            (
              voice: YVoice.cameo,
              handle: persona.handle,
              displayName: persona.displayName,
              template: template,
              variant: 0,
              args: const <String>[],
              date: date,
              key: '${r.event}|re|cameo|${template.name}',
              replyTo: r.parent.key,
              mood: null,
            ),
            variantOf?.call(r.event) ?? 0,
          ),
        );
      }
      return placed;
    }

    final marena = place(
      marenaPersona,
      YTemplate.cameoMarena,
      (p, e) =>
          havirHeavyDefeats.contains(p.template) &&
          !havirEvents.contains(e) &&
          varietySeed('marena|$e') % 3 == 0,
    );
    place(
      kralikPersona,
      YTemplate.cameoKralik,
      (p, e) =>
          defeatTemplates.contains(p.template) &&
          !marena.contains(e) &&
          varietySeed('kralik|$e') % 4 == 0,
    );
    place(
      posukPersona,
      YTemplate.cameoPosuk,
      (p, e) => varietySeed('posuk|$e') % 10 == 0,
      variantOf: (e) => varietySeed('posuk|line|$e') % posukVariantCount,
    );
    return out;
  }

  /// The account that wrote [post], re-derived from the post itself.
  ///
  /// The profile needs a disposition and a [YPost] does not carry one, on
  /// purpose: a stance is read off the run of results up to the post's own
  /// date, so storing one would show today's opinion under a post from 2031.
  /// The trait is the part that never moves, and it comes from the name — so
  /// this is a pure function of what is already above the post, and the same
  /// account opened from a post two careers apart gives the same answer.
  ///
  /// An account a custom world renamed ([renamedIn]) is read under the name
  /// it had, so it keeps the voice the feed gave it. A post [renamedIn]
  /// passed over carries that name itself ([_accountOf]): the account's
  /// identity, never the name shown, which two accounts can share in one
  /// language. Any other post (one built by hand) falls back to the screen
  /// world's reverse lookup ([ActiveWorld.yAccountOriginal]).
  static YPersona personaOf(YPost post) {
    final name = post.voice == YVoice.player
        ? post.displayName
        : _accountOf[post.args] ??
              ActiveWorld.current.yAccountOriginal(post.displayName) ??
              post.displayName;
    return _personaOf(post, name);
  }

  /// The account behind each post [renamedIn] passed over, by the post's
  /// own `args` list (copied per post there, so no two posts share one): a
  /// record cannot be an [Expando] key, and a [YPost] has no field for it.
  static final Expando<String> _accountOf = Expando('Y account');

  static YPersona _personaOf(YPost post, String name) => (
    handle: post.handle,
    displayName: post.displayName,
    trait: switch (post.voice) {
      // The desks are fixed accounts with fixed dispositions — see
      // [personaFor], which builds them the same way.
      YVoice.stats || YVoice.breaking => YTrait.statshead,
      // A player posts under his own name, which is not a cast name and must
      // not be run through the cast's arithmetic: he is one of yours.
      YVoice.player => YTrait.loyalist,
      YVoice.streamer => YTrait.streamer,
      // A cameo is a fixed account with a fixed disposition, looked up by
      // the name above the post like everything else here.
      YVoice.cameo =>
        czechCameos.where((c) => c.displayName == name).firstOrNull?.trait ??
            YCast.traitFor(name),
      _ => YCast.traitFor(name),
    },
  );

  /// The handle of an account a custom world renamed to [name]: `@` and the
  /// name without its spaces, cut to [PackRules.handleMax].
  static String handleFor(String name) {
    final full = '@${name.replaceAll(RegExp(r'\s'), '')}';
    if (full.length <= PackRules.handleMax) return full;
    final out = StringBuffer();
    for (final r in full.runes) {
      final ch = String.fromCharCode(r);
      if (out.length + ch.length > PackRules.handleMax) break;
      out.write(ch);
    }
    return out.toString();
  }

  /// [feed] with the accounts [world] renamed shown under their new names
  /// and handles ([handleFor]), in [world]'s language
  /// ([ActiveWorld.inLanguage]); and the accounts the career's own world
  /// added ([added], from the copy whose uuid is [addedWorld]) under their
  /// names in that language, where it gives one.
  ///
  /// Applied LAST, to the finished feed: every post was written, and every
  /// stance taken, by the account under its original name, so a renamed
  /// account says exactly what it would have said and in the same voice. A
  /// player posts under his own name and is never renamed here.
  ///
  /// Whenever a name can change, every other post carries the account that
  /// wrote it ([_accountOf]), so [personaOf] reads each by its identity even
  /// when two accounts show the same name in this language.
  static YTimeline renamedIn(
    YTimeline feed,
    ActiveWorld world, {
    List<PackYAccount> added = const [],
    String? addedWorld,
  }) {
    final pack = world.pack;
    if (pack == null) return feed;
    // An added account posts under its main name; lowest id first, should a
    // pack carry two under one name.
    final addedNames = <String, String>{};
    for (final a in [...added]..sort((x, y) => x.id.compareTo(y.id))) {
      final shown = world.addedYName(a.id, world: addedWorld);
      if (shown != null) addedNames.putIfAbsent(a.name, () => shown);
    }
    final renames =
        pack.yAccounts.isNotEmpty ||
        addedNames.isNotEmpty ||
        (world.language != null &&
            pack.localized.keys.any((k) => k.startsWith('yAccounts.')));
    if (!renames) return feed;
    YPost renamed(YPost p) {
      if (p.voice == YVoice.player) return p;
      final name = world.yAccount(p.displayName) ?? addedNames[p.displayName];
      final args = List<String>.of(p.args);
      _accountOf[args] = p.displayName;
      return (
        voice: p.voice,
        handle: name == null ? p.handle : handleFor(name),
        displayName: name ?? p.displayName,
        template: p.template,
        variant: p.variant,
        args: args,
        date: p.date,
        key: p.key,
        replyTo: p.replyTo,
        mood: p.mood,
      );
    }

    return (
      posts: [for (final p in feed.posts) renamed(p)],
      reserveFrom: feed.reserveFrom,
    );
  }

  /// The numbers desk: the stats voice's fixed account.
  static const YPersona numbersDesk = (
    handle: '@TheNumbersDesk',
    displayName: 'The Numbers Desk',
    trait: YTrait.statshead,
  );

  /// The wire: the breaking voice's fixed account. It reports; it does not
  /// have a view.
  static const YPersona theWire = (
    handle: '@TheWire',
    displayName: 'The Wire',
    trait: YTrait.statshead,
  );

  /// An account a custom world added, as it posts: under its own name and
  /// [handleFor] handle, with the disposition its name gives it
  /// ([YCast.traitFor]), or the desk's when it posts numbers ([personaOf]
  /// reads it back the same way).
  static YPersona _addedPersona(PackYAccount a) => (
    handle: handleFor(a.name),
    displayName: a.name,
    trait: a.voice == YVoice.stats ? YTrait.statshead : YCast.traitFor(a.name),
  );

  /// Which of [builtIns] and [added] (both non-empty) posts about [key].
  /// Added accounts take at most 50% of the picks, as added sponsors do.
  ///
  /// While the added accounts are no more than the built-in ones, it is a
  /// plain [YCast.pick] over both, so every account is equally likely. Once
  /// they outnumber the built-ins, a fair split decides: the built-ins keep
  /// half of the picks between them and the added accounts share the other
  /// half.
  static YPersona _pickWithAdded(
    List<YPersona> builtIns,
    List<YPersona> added,
    String key,
  ) {
    if (added.length <= builtIns.length) {
      return YCast.pick([...builtIns, ...added], key)!;
    }
    final slot = varietySeed(key) % (2 * builtIns.length);
    if (slot < builtIns.length) return builtIns[slot];
    return YCast.pick(added, '$key|added')!;
  }

  /// The nation's recurring account for [voice], and what sort of person it
  /// is.
  ///
  /// This used to draw a fresh name per POST — a different fan under every
  /// match, out of a list of seven. Nobody ever appeared twice, so nobody
  /// could have a history with you, and the feed was a crowd of strangers
  /// wearing eight labels. Now each voice has a small standing cast, and one
  /// of them is picked for the event.
  static YPersona personaFor(
    YVoice voice,
    String nation,
    int seed,
    String key,
  ) {
    final added = YAccountsScope.current;
    if (voice == YVoice.stats) {
      // A world's own numbers accounts take turns with the desk; with none,
      // the desk is the only one, as it always was.
      final more = [
        for (final a in added)
          if (a.voice == YVoice.stats) _addedPersona(a),
      ];
      if (more.isEmpty) return numbersDesk;
      return _pickWithAdded(const [numbersDesk], more, '$key|${voice.name}');
    }
    final fixed = switch (voice) {
      YVoice.stats => numbersDesk,
      YVoice.breaking => theWire,
      // Never reached: a player's post always carries his own name, supplied
      // by [forGrievance]. Falling back to the nation would put a country's
      // name above a personal complaint.
      YVoice.player => (
        handle: '@$nation',
        displayName: nation,
        trait: YTrait.loyalist,
      ),
      YVoice.streamer => streamerPersona,
      // Never reached: a cameo always posts as itself (see [havirPersona] and
      // the rest), never through a cast.
      YVoice.cameo => havirPersona,
      _ => null,
    };
    if (fixed != null) return fixed;
    final cast = YCast.of(
      _namesFor(voice),
      nation: nation,
      seed: seed,
      voiceKey: voice.name,
    );
    // Every account the world added in this voice joins the standing cast,
    // so its creator sees it post (see [YAccountsScope]).
    final more = [
      for (final a in added)
        if (a.voice == voice) _addedPersona(a),
    ];
    if (more.isNotEmpty && cast.isNotEmpty) {
      return _pickWithAdded(cast, more, '$key|${voice.name}');
    }
    return YCast.pick([...cast, ...more], '$key|${voice.name}') ??
        (handle: '@$nation', displayName: nation, trait: YTrait.loyalist);
  }

  /// Every fixed account's name: the cast names of every voice, the two
  /// desks, the streamer and the Czech cameos. What a custom world's Y
  /// account section lists, and what no renamed account may take
  /// (`PackRules`).
  static final List<String> namedAccounts = List.unmodifiable(<String>{
    numbersDesk.displayName,
    theWire.displayName,
    streamerPersona.displayName,
    ..._punditNames,
    ..._memeNames,
    ..._exProNames,
    ..._fanNames,
    ..._rivalNames,
    ..._neutralNames,
    ..._awayNames,
    for (final c in czechCameos) c.displayName,
  });

  /// The names [voice]'s cast is drawn from.
  static List<String> _namesFor(YVoice voice) => switch (voice) {
    YVoice.pundit => _punditNames,
    YVoice.meme => _memeNames,
    YVoice.expro => _exProNames,
    YVoice.fan => _fanNames,
    YVoice.rival => _rivalNames,
    YVoice.neutral => _neutralNames,
    YVoice.away => _awayNames,
    YVoice.stats ||
    YVoice.breaking ||
    YVoice.player ||
    YVoice.streamer ||
    YVoice.cameo => const <String>[],
  };

  /// Every name an account in the cast can be given.
  ///
  /// Public so a width guard can measure the LONGEST name the feed can
  /// actually produce rather than a typical one — the difference between a
  /// profile header that fits and one that fits until somebody adds
  /// SundayLeagueEnergy to a list.
  static List<String> get castNames => const [
    ..._punditNames,
    ..._fanNames,
    ..._memeNames,
    ..._exProNames,
    ..._rivalNames,
    ..._neutralNames,
    ..._awayNames,
  ];

  /// Invented names — never a real pundit, player or journalist.
  static const List<String> _punditNames = [
    'TheOldStopper',
    'ViewFromTheBox',
    'GaffersCorner',
    'SecondBallSam',
    'TouchlineTerry',
    'ThePressBoxPen',
  ];

  static const List<String> _fanNames = [
    'HomeEndHarry',
    'ScarfAndFlask',
    'AwayDayAnna',
    'TerraceTom',
    'BadgeKisser',
    'EternalOptimist',
    'LongSufferingLen',
  ];

  /// The account that posts a picture with three words on it. Nobody knows who
  /// runs it and everybody reads it first.
  static const List<String> _memeNames = [
    'OffsideTrapHouse',
    'SundayLeagueEnergy',
    'ParkTheBusDepot',
    'ThePostAndOut',
    'VarDecisionPending',
    'BallDidntMove',
  ];

  /// Former internationals with a column and no patience left.
  static const List<String> _exProNames = [
    'CappedTwiceOnly',
    'TheOldNumberTen',
    'BootsInTheAttic',
    'NinetyCapsNoTrophy',
    'HeUsedToRun',
  ];

  /// Accounts that watch all football and side with nobody.
  static const List<String> _neutralNames = [
    'NeutralsCorner',
    'WorldGameWatch',
    'GroundhopperGus',
    'FootballAtLarge',
    'AllTheLeagues',
  ];

  /// The other lot's supporters. A cast is drawn per OPPONENT, so these are
  /// different people from one rival to the next.
  static const List<String> _awayNames = [
    'AwayEndAce',
    'TravellingSupport',
    'VisitorsSection',
    'OtherEndOlly',
    'GuestTerrace',
  ];

  static const List<String> _rivalNames = [
    'NeighbourWatch',
    'BorderBanter',
    'RivalRuby',
    'SchadenfreudeFC',
    'ToldYouSoTina',
  ];
}
