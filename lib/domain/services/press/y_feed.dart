import 'package:fnm/core/util/text_variety.dart';
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

  /// A reply under somebody else's post. Its words come from a [YMood], not
  /// from what happened — see [YMood].
  reaction,
}

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
  /// How many phrasings each template has. Every extra one is two more
  /// translated strings per template; four is enough that a save does not
  /// repeat itself quickly.
  static const int variantCount = 4;

  /// How many phrasings a REPLY has. More than a template's, because one set
  /// of six moods answers every event in the game — the same reply would come
  /// round far faster than the same match report.
  static const int reactionVariantCount = 6;

  /// The most a single event is worth saying. Five rather than three now that
  /// a match can be worth more than its scoreline — the scorer, the run, the
  /// injury — but still a cap: a feed that says everything says nothing.
  static const int maxPostsPerEvent = 5;

  /// How the country reads a result, before anyone opens their mouth.
  static YTemplate classify(YMatch m) {
    final gap = m.opponentRank - m.nationRank; // + = we were favourites
    if (m.scored > m.conceded) {
      if (gap <= -25) return YTemplate.winUpset; // they were far better
      if (gap >= 25) return YTemplate.winRoutine; // we were far better
      return YTemplate.winTight;
    }
    if (m.scored == m.conceded) return YTemplate.drew;
    if (m.conceded - m.scored >= 3 || gap >= 25) return YTemplate.lostBadly;
    return YTemplate.lost;
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
    for (final context in contexts) {
      for (final post in forMatch(context, nation: nation, seed: seed)) {
        // A REPLY's shape is its mood and its wording: every reaction carries
        // the same template and no arguments, so shaping them like a report
        // would collapse a whole thread into its first line.
        final shape = post.mood == null
            ? '${post.template.name}|${post.args.join(",")}'
            : 'reaction|${post.mood!.name}|${post.variant}';
        if (recent.contains(shape)) continue;
        out.add(post);
        recent.add(shape);
        if (recent.length > noRepeatWindow) recent.removeAt(0);
      }
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
  }) {
    final m = context.match;
    final template = classify(m);
    final lost = m.scored < m.conceded;
    final loud = switch (template) {
      YTemplate.winUpset || YTemplate.lostBadly => 3,
      YTemplate.winTight || YTemplate.lost || YTemplate.drew => 2,
      _ => 1,
    };
    final score = '${m.scored}–${m.conceded}';
    final result = [m.opponent, score];

    // The result itself, in as many voices as the occasion deserves.
    final candidates = <(YVoice, YTemplate, List<String>)>[
      (YVoice.stats, template, result),
      if (loud >= 2) (YVoice.fan, template, result),
      if (loud >= 3) (YVoice.pundit, template, result),
      if (lost && loud >= 3) (YVoice.rival, template, result),
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

    final posts = [
      for (final (voice, shape, args) in candidates.take(maxPostsPerEvent))
        _post(
          voice: voice,
          template: shape,
          args: args,
          date: m.date,
          key: m.key,
          nation: nation,
          seed: seed,
        ),
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
      ),
    ];
  }

  /// How long a run has to be before anybody remarks on it.
  static const int streakThreshold = 3;

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
        // ':' and never '|': a post's key is `<event>|<voice>`, and the
        // detail view groups a conversation by the part before the FIRST
        // pipe — so a pipe in here would file every trophy ever won under
        // one conversation called "trophy".
        key: '${won ? "trophy" : "runnerup"}:$key',
      );
    }
    // Anything else that ENDS a nation's tournament ends it in the same way,
    // whether the last word was a knockout defeat or a group table: they are
    // out. Only the caller knows a campaign is over — see the provider.
    if (!finalsRounds.contains(core)) return null;
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

  /// Newest first, and capped — a long save would otherwise build a feed
  /// nobody can scroll to the end of.
  ///
  /// The cap counts POSTS OF THEIR OWN and carries each one's replies with it:
  /// counting replies too would let a busy thread crowd out a whole month, and
  /// cutting between a post and its replies would leave answers to nothing.
  static List<YPost> mostRecent(List<YPost> all, {int cap = 60}) {
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
    return [
      for (final root in roots.take(cap)) ...[
        root,
        ...?repliesByParent[root.key],
      ],
    ];
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
  }) {
    // Seeded by the event AND the voice, so two people reacting to the same
    // match never reach for the same sentence.
    final spread = mood == null ? variantCount : reactionVariantCount;
    final variant = varietySeed('$key|${voice.name}') % spread;
    final (handle, display) = authorName == null
        ? _author(voice, nation, seed, key)
        : ('@${authorName.replaceAll(' ', '')}', authorName);
    return (
      voice: voice,
      handle: handle,
      displayName: display,
      template: template,
      variant: variant,
      args: args,
      date: date,
      key: '$key|${voice.name}',
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
    // Keyed off the EVENT with a `re` segment: a post's key is
    // `<event>|<voice>`, and the detail view groups a conversation by the part
    // before the first `|`. A reply keyed any other way would either land
    // under an event of its own or collide with a top-level post by the same
    // voice.
    final event = parent.key.split('|').first;
    return [
      for (final voice in voices.take(count))
        _post(
          voice: voice,
          template: YTemplate.reaction,
          args: const [],
          date: parent.date,
          key: '$event|re',
          nation: nation,
          seed: seed,
          replyTo: parent.key,
          mood: mood,
        ),
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
    YTemplate.winStreak => YMood.smugness,
    YTemplate.winRoutine ||
    YTemplate.drew ||
    YTemplate.rivalry ||
    YTemplate.groupDrawn ||
    YTemplate.hostNamed ||
    YTemplate.tournamentSoon ||
    YTemplate.reaction => YMood.shrug,
  };

  static (String, String) _author(
    YVoice voice,
    String nation,
    int seed,
    String key,
  ) {
    switch (voice) {
      case YVoice.pundit:
        final handle = punditHandle(nation, seed);
        return (handle, handle.substring(1));
      case YVoice.stats:
        return ('@TheNumbersDesk', 'The Numbers Desk');
      case YVoice.breaking:
        return ('@TheWire', 'The Wire');
      case YVoice.meme:
        final n = _memeNames[varietySeed('meme|$key') % _memeNames.length];
        return ('@$n', n);
      case YVoice.expro:
        final n = _exProNames[varietySeed('expro|$key') % _exProNames.length];
        return ('@$n', n);
      case YVoice.fan:
        final n = _fanNames[varietySeed('fan|$key') % _fanNames.length];
        return ('@$n', n);
      case YVoice.player:
        // Never reached: a player's post always carries his own name, supplied
        // by [forGrievance]. Falling back to the nation would put a country's
        // name above a personal complaint.
        return ('@$nation', nation);
      case YVoice.rival:
        final n = _rivalNames[varietySeed('rival|$key') % _rivalNames.length];
        return ('@$n', n);
    }
  }

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
