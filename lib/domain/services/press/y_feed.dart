import 'package:fnm/core/util/text_variety.dart';

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

  /// The most a single event is worth saying.
  static const int maxPostsPerEvent = 3;

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

  /// The posts a match draws.
  ///
  /// A bigger occasion is louder: a routine result gets a line from the stats
  /// account and little else, a triumph or a humiliation brings out the pundit,
  /// the fans and — when you lose — someone enjoying it.
  static List<YPost> forMatch(
    YMatch m, {
    required String nation,
    required int seed,
  }) {
    final template = classify(m);
    final lost = m.scored < m.conceded;
    final loud = switch (template) {
      YTemplate.winUpset || YTemplate.lostBadly => 3,
      YTemplate.winTight || YTemplate.lost || YTemplate.drew => 2,
      _ => 1,
    };
    final voices = <YVoice>[
      YVoice.stats,
      if (loud >= 2) YVoice.fan,
      if (loud >= 3) YVoice.pundit,
      if (lost && loud >= 3) YVoice.rival,
    ].take(maxPostsPerEvent + 1).toList();

    final score = '${m.scored}–${m.conceded}';
    return [
      for (final voice in voices)
        _post(
          voice: voice,
          template: template,
          args: [m.opponent, score],
          date: m.date,
          key: m.key,
          nation: nation,
          seed: seed,
        ),
    ];
  }

  /// The post a one-off event draws — a draw made, a host named, a tournament
  /// coming up.
  static List<YPost> forEvent({
    required YTemplate template,
    required List<String> args,
    required DateTime date,
    required String key,
    required String nation,
    required int seed,
  }) =>
      [
        _post(
          voice: YVoice.stats,
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
      ];

  /// A player saying in public what he could not get said in your office.
  static List<YPost> forGrievance({
    required String playerName,
    required DateTime date,
    required String key,
    required String nation,
    required int seed,
  }) =>
      [
        _post(
          voice: YVoice.player,
          template: YTemplate.playerGrievance,
          args: [playerName],
          date: date,
          key: key,
          nation: nation,
          seed: seed,
          authorName: playerName,
        ),
      ];

  /// Newest first, and capped — a long save would otherwise build a feed
  /// nobody can scroll to the end of.
  static List<YPost> mostRecent(List<YPost> all, {int cap = 60}) {
    final sorted = [...all]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(cap).toList();
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
  }) {
    // Seeded by the event AND the voice, so two people reacting to the same
    // match never reach for the same sentence.
    final variant = varietySeed('$key|${voice.name}') % variantCount;
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
    );
  }

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
        return ('@OptaLite', 'Numbers');
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

  static const List<String> _rivalNames = [
    'NeighbourWatch',
    'BorderBanter',
    'RivalRuby',
    'SchadenfreudeFC',
    'ToldYouSoTina',
  ];
}
