import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/competition/rounds.dart';

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

  /// A reply under somebody else's post. Its words come from a [YMood], not
  /// from what happened — see [YMood].
  reaction,
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
});

/// A feed with nothing behind it — the first match of a save, and the shape
/// every caller that does not walk a run passes.
const YMemory blankMemory = (
  standings: <ResultStanding>[],
  metBefore: 0,
  sameRecently: 0,
);

/// One post on the feed.
typedef YPost = ({
  YVoice voice,
  String handle,
  String displayName,
  YTemplate template,
  int variant,
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
});

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

  /// The ones that fire often but not always — a scorer, a streak, an injury.
  static const int midVariantCount = 8;

  /// How many phrasings [t] has.
  ///
  /// Four for everything was the whole repetition problem: a host being named
  /// fires once a cycle and four is plenty, while a result fires every match
  /// and came round again within a dozen games. The counts are banded by tone
  /// (see [YCast.band]), so a deep template is three moods of four rather than
  /// twelve of the same.
  static int variantsFor(YTemplate t) => switch (t) {
    YTemplate.winUpset ||
    YTemplate.winRoutine ||
    YTemplate.winTight ||
    YTemplate.drew ||
    YTemplate.lost ||
    YTemplate.lostBadly => deepVariantCount,
    YTemplate.scorerStar ||
    YTemplate.winStreak ||
    YTemplate.lossStreak ||
    YTemplate.rivalry ||
    YTemplate.injuryBlow ||
    YTemplate.boardPressure => midVariantCount,
    _ => variantCount,
  };

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
    final standing = standingOf(m);
    if (m.scored > m.conceded) {
      return switch (standing) {
        ResultStanding.heroic => YTemplate.winUpset,
        ResultStanding.creditable => YTemplate.winTight,
        _ => YTemplate.winRoutine,
      };
    }
    if (m.scored == m.conceded) return YTemplate.drew;
    // Only a defeat that shames you is a bad defeat. Losing 4–0 to the best
    // side in the world is a scoreline; losing 1–0 at home to a minnow is a
    // story, and the old rule had those the wrong way round.
    return standing == ResultStanding.humiliating
        ? YTemplate.lostBadly
        : YTemplate.lost;
  }

  /// How many posts back a shape must not have been used.
  ///
  /// The feed used to be assembled event by event with no memory, so a run of
  /// similar results produced a run of near-identical posts. A shape is a
  /// template and its arguments together: the same sentence about a different
  /// opponent is not a repeat.
  static const int noRepeatWindow = 10;

  /// A run of results, oldest first, as the world talked about it.
  ///
  /// Assembled in one pass so the feed can remember what it has just said —
  /// see [noRepeatWindow].
  static List<YPost> forRun(
    List<YContext> contexts, {
    required String nation,
    required int seed,
  }) {
    final out = <YPost>[];
    final recent = <String>[];
    // What the country has watched so far, oldest first. Rebuilt as the walk
    // goes rather than read from the end, so a post from three years ago is
    // written by the people who were watching THEN, in the mood they were in
    // then — which is what keeps a scrolled-back feed honest.
    final history = <ResultStanding>[];
    // How often each opponent has been faced, and how the last few afternoons
    // read — the two things a callback needs and the walk already knows.
    final met = <String, int>{};
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
        ),
      )) {
        // A shape is the SENTENCE, not the subject: template, wording and
        // arguments together.
        //
        // Leaving the wording out looked equivalent and quietly gutted the
        // feed. Every voice reporting one match carries the same template and
        // the same two arguments, so the fan's and the pundit's reports were
        // dropped as repeats of the stats desk's — one result post per match,
        // ever, and the whole `loud` calculation about how big an occasion it
        // was decided nothing at all.
        final shape = post.mood == null
            ? '${post.template.name}|${post.variant}|${post.args.join(",")}'
            : 'reaction|${post.mood!.name}|${post.variant}';
        if (recent.contains(shape)) continue;
        out.add(post);
        recent.add(shape);
        if (recent.length > noRepeatWindow) recent.removeAt(0);
      }
      history.add(standing);
      met.update(
        context.match.opponent,
        (v) => v + 1,
        ifAbsent: () => 1,
      );
    }
    return out;
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
  /// A bigger occasion is louder: a routine result gets a line from the stats
  /// account and little else, a triumph or a humiliation brings out the pundit,
  /// the fans and — when you lose — someone enjoying it. What the world knows
  /// beyond the scoreline ([YContext]) adds its own shapes on top: the man who
  /// scored them, the run the side is on, the neighbours, the injury, the
  /// board.
  static List<YPost> forMatch(
    YContext context, {
    required String nation,
    required int seed,
    YMemory memory = blankMemory,
  }) {
    final m = context.match;
    final template = classify(m);
    final standing = standingOf(m);
    final lost = m.scored < m.conceded;
    // How loud the room gets, from how surprising the afternoon was rather
    // than from the scoreline. A favourite putting four past a minnow is the
    // job and draws a line from the stats account; the same four the other way
    // brings everybody out.
    final loud = switch (standing) {
      ResultStanding.heroic || ResultStanding.humiliating => 3,
      ResultStanding.creditable || ResultStanding.poor => 2,
      ResultStanding.par => 1,
    };
    final score = '${m.scored}–${m.conceded}';
    final result = [m.opponent, score];

    // The result itself, in as many voices as the occasion deserves.
    final candidates = <(YVoice, YTemplate, List<String>)>[
      (YVoice.stats, template, result),
      if (loud >= 2) (YVoice.fan, template, result),
      if (loud >= 3) (YVoice.pundit, template, result),
      // Somebody enjoys it only when there is something to enjoy. Any old
      // defeat used to bring the rival account out, which made it noise.
      if (lost && standing == ResultStanding.humiliating)
        (YVoice.rival, template, result),
    ];

    // And what else the world happens to know.
    final scorer = context.scorerName;
    final goals = context.scorerGoals ?? 0;
    if (scorer != null && goals >= 1) {
      candidates.add((YVoice.stats, YTemplate.scorerStar, [scorer, '$goals']));
    }
    if (context.isRivalry) {
      candidates.add((
        lost ? YVoice.rival : YVoice.fan,
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
    if (context.lossStreak >= streakThreshold) {
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
    if (context.boardMood <= boardPressureBelow) {
      candidates.add((YVoice.pundit, YTemplate.boardPressure, const ['']));
    }
    // What the country REMEMBERS, which is the half a feed with no history
    // could never say. A fourth defeat to the same neighbours is not a fourth
    // result, it is a pattern, and somebody says so.
    if (memory.metBefore >= callbackMeetings &&
        Expectation.weight(standing) < 0) {
      candidates.add((
        YVoice.fan,
        YTemplate.againstThemAgain,
        [m.opponent, '${memory.metBefore + 1}'],
      ));
    }
    if (memory.sameRecently >= callbackRepeats) {
      candidates.add((
        YVoice.pundit,
        YTemplate.sameOldStory,
        ['${memory.sameRecently + 1}'],
      ));
    }
    // The one post that needs a run behind it AND somebody sour enough to
    // enjoy it: a bad afternoon straight after everyone was told it was fine.
    if (Expectation.weight(standing) < 0 && _wasHyped(memory.standings)) {
      candidates.add((YVoice.expro, YTemplate.toldYouSo, const ['']));
    }

    final posts = [
      for (final (voice, shape, args) in candidates.take(maxPostsPerEvent))
        () {
          // Who is posting decides HOW it is worded. The same 1–1 is unlucky
          // from a loyalist and terminal from a doomer, and a run of results
          // moves both of them.
          final persona = personaFor(voice, nation, seed, m.key);
          final tone = YCast.toneFor(
            persona,
            standing,
            YCast.stance(persona, memory.standings),
          );
          return _post(
            voice: voice,
            template: shape,
            args: args,
            date: m.date,
            key: m.key,
            nation: nation,
            seed: seed,
            tone: tone,
          );
        }(),
    ];
    // The room answers itself. Only the LOUDEST post of an event draws a
    // thread — every post drawing one would bury the feed under its own
    // replies, and a match is one conversation, not five.
    if (posts.isEmpty) return posts;
    return [
      ...posts,
      ...repliesTo(
        posts.first,
        mood: lost && template == YTemplate.lostBadly
            ? YMood.despair
            : moodOf(template),
        nation: nation,
        seed: seed,
        standing: standing,
        history: memory.standings,
      ),
    ];
  }

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
      ),
      _post(
        voice: YVoice.fan,
        template: template,
        args: args,
        date: date,
        key: key,
        nation: nation,
        seed: seed,
      ),
      if (_bigEvents.contains(template))
        _post(
          voice: YVoice.expro,
          template: template,
          args: args,
          date: date,
          key: key,
          nation: nation,
          seed: seed,
        ),
    ];
    return [
      ...posts,
      ...repliesTo(
        posts.first,
        mood: moodOf(template),
        nation: nation,
        seed: seed,
      ),
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
  }) {
    // Seeded by the event AND the voice, so two people reacting to the same
    // match never reach for the same sentence — and banded by TONE, so the
    // sentence reached for is one this account would actually write. Twelve
    // wordings picked by a hash is still one voice; twelve wordings picked by
    // disposition is a room.
    final spread = mood == null ? variantsFor(template) : reactionVariantCount;
    final variant = YCast.variantFor(
      key: '$key|${voice.name}',
      tone: tone,
      total: spread,
    );
    final persona = authorName == null
        ? personaFor(voice, nation, seed, key)
        : (
            handle: '@${authorName.replaceAll(' ', '')}',
            displayName: authorName,
            trait: YTrait.loyalist,
          );
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
  }) {
    final voices = switch (mood) {
      YMood.elation => const [YVoice.meme, YVoice.fan],
      YMood.relief => const [YVoice.fan, YVoice.expro],
      YMood.fury => const [YVoice.expro, YVoice.rival, YVoice.meme],
      YMood.despair => const [YVoice.meme, YVoice.expro, YVoice.rival],
      YMood.smugness => const [YVoice.rival, YVoice.meme],
      YMood.shrug => const [YVoice.meme],
    };
    // How many of them actually bother, drawn from the parent so the same post
    // always draws the same thread.
    final count = 1 + varietySeed('replies|${parent.key}') % voices.length;
    // Keyed off the EVENT with a `re` segment: the detail view groups a
    // conversation by the part before the first `|`, so a reply keyed any
    // other way would land under an event of its own.
    final event = parent.key.split('|').first;
    return [
      for (final voice in voices.take(count))
        () {
          final persona = personaFor(voice, nation, seed, event);
          return _post(
            voice: voice,
            template: YTemplate.reaction,
            args: const [],
            date: parent.date,
            key: '$event|re',
            nation: nation,
            seed: seed,
            replyTo: parent.key,
            mood: mood,
            tone: YCast.toneFor(
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
    YTemplate.winStreak || YTemplate.toldYouSo => YMood.smugness,
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

  /// The account that wrote [post], re-derived from the post itself.
  ///
  /// The profile needs a disposition and a [YPost] does not carry one, on
  /// purpose: a stance is read off the run of results up to the post's own
  /// date, so storing one would show today's opinion under a post from 2031.
  /// The trait is the part that never moves, and it comes from the name — so
  /// this is a pure function of what is already above the post, and the same
  /// account opened from a post two careers apart gives the same answer.
  static YPersona personaOf(YPost post) => (
    handle: post.handle,
    displayName: post.displayName,
    trait: switch (post.voice) {
      // The desks are fixed accounts with fixed dispositions — see
      // [personaFor], which builds them the same way.
      YVoice.stats || YVoice.breaking => YTrait.statshead,
      // A player posts under his own name, which is not a cast name and must
      // not be run through the cast's arithmetic: he is one of yours.
      YVoice.player => YTrait.loyalist,
      _ => YCast.traitFor(post.displayName),
    },
  );

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
    final fixed = switch (voice) {
      YVoice.stats => (
        handle: '@TheNumbersDesk',
        displayName: 'The Numbers Desk',
        trait: YTrait.statshead,
      ),
      YVoice.breaking => (
        handle: '@TheWire',
        displayName: 'The Wire',
        // The wire reports; it does not have a view.
        trait: YTrait.statshead,
      ),
      // Never reached: a player's post always carries his own name, supplied
      // by [forGrievance]. Falling back to the nation would put a country's
      // name above a personal complaint.
      YVoice.player => (
        handle: '@$nation',
        displayName: nation,
        trait: YTrait.loyalist,
      ),
      _ => null,
    };
    if (fixed != null) return fixed;
    final names = switch (voice) {
      YVoice.pundit => _punditNames,
      YVoice.meme => _memeNames,
      YVoice.expro => _exProNames,
      YVoice.fan => _fanNames,
      YVoice.rival => _rivalNames,
      _ => const <String>[],
    };
    final cast = YCast.of(
      names,
      nation: nation,
      seed: seed,
      voiceKey: voice.name,
    );
    return YCast.pick(cast, '$key|${voice.name}') ??
        (handle: '@$nation', displayName: nation, trait: YTrait.loyalist);
  }

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

  static const List<String> _rivalNames = [
    'NeighbourWatch',
    'BorderBanter',
    'RivalRuby',
    'SchadenfreudeFC',
    'ToldYouSoTina',
  ];
}
