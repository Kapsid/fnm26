/// What a player is unhappy about.
enum GrievanceKind {
  /// In the squad, never on the pitch.
  gameTime,

  /// Good enough for the pool and repeatedly left out of it.
  ///
  /// NOT RAISED. Being asked why a man was not named turned up far too often
  /// to be an event — a squad is 23 of a pool of hundreds, so somebody is
  /// always the one left out, and the question had no answer worth giving.
  /// The member stays so keys stored by older saves still resolve.
  squadPlace,

  /// Played out of position, again and again.
  ///
  /// NOT RAISED YET. `PlayerRatings` records what a player did in a match but
  /// not the position he was played in, so this is not derivable from anything
  /// the save stores — it needs a new column, a schema bump and a wiped save.
  /// The member is here so adding it later is a detection rule rather than a
  /// migration of everything that switches on this enum.
  role,
}

/// How a manager answers a player who has come to see him.
enum GrievanceTone {
  /// You are in my plans.
  reassure,

  /// You are behind others, and here is why.
  honest,

  /// I pick the team.
  dismiss,
}

/// What an answer does to the dressing room and to the manager's standing.
typedef GrievanceEffect = ({int morale, int board});

/// A player who wants a word.
typedef Grievance = ({
  int playerId,
  String playerName,
  GrievanceKind kind,
  int age,
  int caps,

  /// Stable and unique — a grievance with this key is never raised twice.
  String key,
});

/// What a player needs to know about his own standing, for detection.
typedef SquadStanding = ({
  int playerId,
  String playerName,
  int age,
  int caps,
  int overall,

  /// Whether he is in the squad the manager has named.
  bool calledUp,

  /// How many of the nation's most recent played matches he appeared in.
  int recentAppearances,
});

/// Players who want something, and what it costs to ignore them.
///
/// The squad used to be inventory: nobody asked why he was not playing and
/// nobody minded being left out. Every grievance here is read from data the
/// save already holds — who is in the squad, who has been playing, how many
/// caps a man has — so nothing new is stored to make the dressing room talk.
abstract final class Grievances {
  /// How many of the nation's recent matches count when judging whether a man
  /// is being played.
  static const int recentWindow = 3;

  /// A squad player with no minutes in [recentWindow] matches has a case.
  static const int gameTimeThreshold = 0;

  /// How highly a man must be rated in his nation's pool before being left out
  /// is an insult rather than a fact of life.
  static const int poolTop = 25;

  /// Below this age, being left out is waiting your turn.
  static const int squadPlaceMinAge = 24;

  /// How many men are unhappy at once. ONE: the hub is a place to manage a
  /// team, and a queue of complaints is not a dressing room, it is an inbox.
  static const int maxActive = 1;

  /// How many men may come to the office in a single year. A dressing room that
  /// produces a grievance every window is not a dressing room either.
  static const int maxPerYear = 3;

  /// The age at which a man walks away rather than sulks.
  static const int walkoutAge = 30;

  /// Windows an ignored grievance stands before a veteran leaves for good.
  static const int walkoutPatience = 2;

  /// What the dressing room loses while a grievance stands unanswered.
  static const int ignoredMoraleCost = -4;

  /// Who wants a word — at most [maxActive], most senior first.
  ///
  /// [standings] is the nation's pool with each man's situation; [poolRank] is
  /// his position by rating (1 = the best in the country); [year] keys the
  /// grievance, so a man who is ignored does not come back every window with a
  /// fresh complaint — he asks once a year, like a person.
  ///
  /// [squadNamed] is false before the manager has ever picked a squad. Nobody
  /// may complain about being left out of a team that does not exist yet —
  /// without this the whole country turns up on day one, because an empty
  /// squad reads as everybody being dropped.
  ///
  /// [raisedThisYear] is how many have already come forward, so a season has a
  /// couple of these rather than one every window.
  static List<Grievance> raise(
    List<SquadStanding> standings, {
    required Map<int, int> poolRank,
    required int year,
    bool squadNamed = true,
    int raisedThisYear = 0,
    Set<String> alreadyRaised = const {},
  }) {
    if (!squadNamed) return const [];
    if (raisedThisYear >= maxPerYear) return const [];
    final out = <Grievance>[];
    for (final s in standings) {
      final kind = _kindFor(s, poolRank[s.playerId]);
      if (kind == null) continue;
      final key = 'grv:${kind.name}:${s.playerId}:$year';
      if (alreadyRaised.contains(key)) continue;
      out.add((
        playerId: s.playerId,
        playerName: s.playerName,
        kind: kind,
        age: s.age,
        caps: s.caps,
        key: key,
      ));
    }
    // The most-capped man speaks: he is the one with the standing to.
    out.sort((a, b) => b.caps.compareTo(a.caps));
    return out.take(maxActive).toList();
  }

  /// One player's grievance, or null if he has nothing to complain about.
  ///
  /// One man, one grievance, and only one kind of it: a player who IS in the
  /// squad and never gets on. Not being picked at all is no longer raised.
  static GrievanceKind? _kindFor(SquadStanding s, int? rank) {
    if (s.calledUp) {
      if (s.recentAppearances <= gameTimeThreshold && s.caps > 0) {
        return GrievanceKind.gameTime;
      }
      return null;
    }
    // A man not in the squad says nothing: see [GrievanceKind.squadPlace].
    return null;
  }

  /// What a tone costs and buys.
  ///
  /// Sized like a press answer: a nudge, not a result. [GrievanceTone.honest]
  /// is deliberately the safe answer and [GrievanceTone.reassure] the cheap
  /// one — promises are not tracked and broken here, so an unkept promise costs
  /// nothing later, and telling a man the truth must therefore never be worse
  /// than lying to him.
  static GrievanceEffect effectOf(GrievanceTone tone) => switch (tone) {
    GrievanceTone.reassure => (morale: 3, board: -1),
    GrievanceTone.honest => (morale: 1, board: 1),
    GrievanceTone.dismiss => (morale: -3, board: 1),
  };

  /// Whether a man whose grievance has stood unanswered for [windows] walks
  /// away from international football. Younger men sulk; a proud veteran goes.
  static bool walksOut({required int age, required int windows}) =>
      age >= walkoutAge && windows >= walkoutPatience;
}
