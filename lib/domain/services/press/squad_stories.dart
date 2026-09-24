import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/press/press.dart';

/// One of the manager's men, as the press room sees him.
///
/// Everything here is already recorded somewhere — the pool, the stored XI,
/// the appearance ledger, the per-match ratings. Gathering it into one shape
/// is what lets the RULES below be a pure function: whether a drought is a
/// story is a judgement, and a judgement that lives inside a provider cannot
/// be asked a question without a database behind it.
typedef SquadMan = ({
  int playerId,
  String name,
  int age,
  int overall,

  /// Where he plays, exactly. A drought is a question for a forward, and a
  /// man left out is only left out of HIS OWN JOB — see [_dropped], which is
  /// the rule that needs the fine-grained answer rather than the broad one.
  PlayerPosition position,

  /// Senior caps for this nation, all-time.
  int caps,

  /// Whether he could be picked: called up, fit and not serving a ban.
  bool available,

  /// Whether the manager's stored XI has him in it.
  bool inXi,

  /// Competitive matches since his last goal, or null when the question does
  /// not arise (he has never played, or nobody is counting).
  int? gamesSinceGoal,

  /// How he was marked in the most recent match, or null if he did not play
  /// in it.
  double? lastRating,

  /// What he was rated a year ago, or null when the save is not a year old.
  int? overallLastYear,

  /// Whether he is wearing the armband right now.
  bool captain,

  /// His recent form and his career average, on the same 3–10 scale. Null
  /// until he has played enough for either to mean anything.
  double? formRating,
  double? careerRating,
});

/// One live story about a named man: which question it is, who it is about,
/// and the figure the question has to say out loud.
typedef SquadStory = ({
  PressTopic topic,
  int playerId,
  String name,

  /// The number the copy names — caps without a goal, his age, his rating.
  int count,
});

/// Which questions the squad is currently asking of the manager.
///
/// Pure, and deliberately so. These are the rules the spec argues about — how
/// long a drought is, how good a game has to be before a nineteen-year-old is
/// a story — and they are worth being able to test one line at a time rather
/// than through a simulated career.
///
/// At most one story per topic: the room asks about the striker, not about
/// every forward in the pool.
abstract final class SquadStories {
  /// How many matches without a goal make a forward's drought a question.
  ///
  /// Six competitive games is most of a qualifying campaign for a first-choice
  /// centre-forward, and short enough that it is still this season's problem.
  static const int droughtGames = 6;

  /// …and how many caps he needs before anybody expects goals from him at all.
  static const int droughtCaps = 6;

  /// Up to what age a good afternoon is a breakthrough rather than a good
  /// afternoon.
  static const int breakthroughAge = 21;

  /// The mark that makes it the game of his life. Eight is a man who decided
  /// a match; seven is a good day at the office.
  static const double breakthroughRating = 7.8;

  /// How far above the weakest man in the XI somebody has to be rated before
  /// leaving him out is a question rather than a preference.
  static const int droppedGap = 4;

  /// The age at which the room starts asking how much longer.
  static const int veteranAge = 34;

  /// …of a man who has actually been a regular. A thirty-four-year-old with
  /// two caps is not the end of an era.
  static const int veteranCaps = 20;

  /// How far his rating has to have fallen in a year for the decline to be
  /// visible rather than assumed.
  static const int veteranDrop = 2;

  /// How far a captain's recent form has to sit below his own career mark.
  static const double captainSlump = 0.6;

  /// …and how many caps he needs for that career mark to mean anything.
  static const int captainCaps = 10;

  /// Every story the squad is telling, in no particular order — the press
  /// selector does the ordering (see [Press.leadingSubjects]).
  static List<SquadStory> read(List<SquadMan> squad) {
    final out = <SquadStory>[];
    void add(SquadStory? story) {
      if (story != null) out.add(story);
    }

    add(_drought(squad));
    add(_breakthrough(squad));
    add(_dropped(squad));
    add(_captaincy(squad));
    add(_veteran(squad));
    add(_debut(squad));
    return out;
  }

  /// The man leading the line, and how long since he scored.
  static SquadStory? _drought(List<SquadMan> squad) {
    final forwards = [
      for (final m in squad)
        if (m.position.category == PositionCategory.forward && m.inXi) m,
    ];
    if (forwards.isEmpty) return null;
    // The FIRST-CHOICE forward: in a two-man front line the question is about
    // the one the country expects goals from.
    final lead = forwards.reduce((a, b) => b.overall > a.overall ? b : a);
    final since = lead.gamesSinceGoal;
    if (since == null || since < droughtGames) return null;
    if (lead.caps < droughtCaps) return null;
    return (
      topic: PressTopic.strikerDrought,
      playerId: lead.playerId,
      name: lead.name,
      count: since,
    );
  }

  /// A young man who has just had the game of his life.
  ///
  /// A first cap is NOT this: it is [PressTopic.debutant], which is a
  /// different question, so the two never describe the same man.
  static SquadStory? _breakthrough(List<SquadMan> squad) {
    final candidates = [
      for (final m in squad)
        if (m.age <= breakthroughAge &&
            m.caps > 1 &&
            (m.lastRating ?? 0) >= breakthroughRating)
          m,
    ];
    if (candidates.isEmpty) return null;
    final best = candidates.reduce(
      (a, b) => (b.lastRating ?? 0) > (a.lastRating ?? 0) ? b : a,
    );
    return (
      topic: PressTopic.youngsterBreakthrough,
      playerId: best.playerId,
      name: best.name,
      count: best.age,
    );
  }

  /// One of the best players in the country, watching from the bench.
  ///
  /// Measured against the weakest man in the XI IN HIS OWN POSITION, and the
  /// precision is the whole rule.
  ///
  /// Compared across the side it is not a question at all: the third-choice
  /// striker outrates the first-choice goalkeeper in every squad ever named,
  /// so a flat reading fired in week one of a brand-new save. Compared across
  /// a LINE it still fires, because a shape asks for two centre-backs and a
  /// left-back and a country's fourth-best centre-half outrates its only
  /// left-back. Compared against the man doing the same job it means what it
  /// says, and a default XI — which takes the best at each position — cannot
  /// trip it.
  static SquadStory? _dropped(List<SquadMan> squad) {
    final bar = <PlayerPosition, int>{};
    for (final m in squad) {
      if (!m.inXi) continue;
      final at = bar[m.position];
      if (at == null || m.overall < at) bar[m.position] = m.overall;
    }
    if (bar.isEmpty) return null;
    SquadMan? best;
    var widest = 0;
    for (final m in squad) {
      if (m.inXi || !m.available) continue;
      final weakest = bar[m.position];
      if (weakest == null) continue;
      final gap = m.overall - weakest;
      if (gap < droppedGap) continue;
      if (best == null || gap > widest) {
        best = m;
        widest = gap;
      }
    }
    if (best == null) return null;
    return (
      topic: PressTopic.droppedStar,
      playerId: best.playerId,
      name: best.name,
      count: best.overall,
    );
  }

  /// The captain, and whether he is still playing like one.
  ///
  /// Only the half of the spec's question the save can answer. Nothing records
  /// WHEN an armband was given — `careers.captainPlayerId` is a bare id — so
  /// "a new captain" cannot be told from one who has worn it for six years,
  /// and this asks about form alone rather than guessing.
  static SquadStory? _captaincy(List<SquadMan> squad) {
    for (final m in squad) {
      if (!m.captain) continue;
      if (m.caps < captainCaps) continue;
      final form = m.formRating;
      final career = m.careerRating;
      if (form == null || career == null) continue;
      if (career - form < captainSlump) continue;
      return (
        topic: PressTopic.captaincyQuestion,
        playerId: m.playerId,
        name: m.name,
        count: m.caps,
      );
    }
    return null;
  }

  /// A long career visibly ending.
  static SquadStory? _veteran(List<SquadMan> squad) {
    final candidates = [
      for (final m in squad)
        if (m.age >= veteranAge &&
            m.caps >= veteranCaps &&
            m.overallLastYear != null &&
            m.overallLastYear! - m.overall >= veteranDrop)
          m,
    ];
    if (candidates.isEmpty) return null;
    final oldest = candidates.reduce((a, b) => b.age > a.age ? b : a);
    return (
      topic: PressTopic.veteranEnd,
      playerId: oldest.playerId,
      name: oldest.name,
      count: oldest.age,
    );
  }

  /// A first cap, won in the match the country is still talking about.
  static SquadStory? _debut(List<SquadMan> squad) {
    for (final m in squad) {
      if (m.caps != 1) continue;
      if (m.lastRating == null) continue;
      return (
        topic: PressTopic.debutant,
        playerId: m.playerId,
        name: m.name,
        count: m.age,
      );
    }
    return null;
  }
}

/// One live story about the side the manager is about to play.
typedef OpponentStory = ({
  PressTopic topic,
  int nationId,

  /// The figure the question names: meetings, or the length of a run.
  int count,

  /// Whether that figure reads in the manager's favour — see
  /// [PressSubjectOpponent.favourable].
  bool favourable,
});

/// What the NEXT match is worth asking about, as opposed to the last one.
abstract final class OpponentStories {
  /// How many meetings make the next one a rivalry rather than a fixture.
  ///
  /// One more than the fiercest-rival card needs. That card is content and
  /// will call three games a rivalry; a press room asking "this one always
  /// means more" about three games is overselling it.
  static const int rivalryMeetings = 4;

  /// How long a run against one opponent has to be before it is a question.
  static const int runLength = 4;

  /// The stories, from the next opponent and the record against them.
  ///
  /// [results] is every past meeting with that opponent, NEWEST FIRST, as 1
  /// for a win, 0 for a draw and −1 for a defeat. [knockedUsOutId] is whoever
  /// ended the last tournament, which is a different thing from the record.
  static List<OpponentStory> read({
    required int? nextOpponentId,
    required int? rivalId,
    required int rivalMeetings,
    required List<int> results,
    required int? knockedUsOutId,
  }) {
    if (nextOpponentId == null) return const [];
    final out = <OpponentStory>[];

    if (rivalId == nextOpponentId && rivalMeetings >= rivalryMeetings) {
      out.add((
        topic: PressTopic.rivalryNext,
        nationId: nextOpponentId,
        count: rivalMeetings,
        favourable: true,
      ));
    }

    // A run is the LEADING stretch of the record, so it is current by
    // construction: a side unbeaten in five and then beaten last time is not
    // unbeaten in five.
    final unbeaten = _runOf(results, (r) => r >= 0);
    final winless = _runOf(results, (r) => r <= 0);
    // A run of draws is both at once. The sharper question wins the tie: four
    // without a win reads as a problem, four without defeat as a statistic.
    final run = unbeaten > winless ? unbeaten : winless;
    if (run >= runLength) {
      out.add((
        topic: PressTopic.headToHeadRun,
        nationId: nextOpponentId,
        count: run,
        favourable: unbeaten > winless,
      ));
    }

    if (knockedUsOutId == nextOpponentId) {
      out.add((
        topic: PressTopic.revengeMatch,
        nationId: nextOpponentId,
        count: 0,
        favourable: false,
      ));
    }
    return out;
  }

  /// How many of [results] from the front satisfy [test].
  static int _runOf(List<int> results, bool Function(int) test) {
    var n = 0;
    for (final r in results) {
      if (!test(r)) break;
      n++;
    }
    return n;
  }
}
