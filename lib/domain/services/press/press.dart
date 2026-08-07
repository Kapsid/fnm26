/// The tone a manager takes with the press. Each is a real trade: the dressing
/// room and the boardroom want different things said, and no answer pleases
/// both.
enum PressTone {
  /// Back the players publicly. They love it; the board hears excuses.
  backThePlayers,

  /// Take it on your own shoulders. Steadies everyone, costs a little standing.
  takeTheBlame,

  /// Demand more, out loud. The board likes the steel; the squad does not.
  demandMore,

  /// Talk the target up. The board is delighted, the players feel the weight.
  raiseTheBar,

  /// Say as little as possible. Nobody is moved either way — always available,
  /// and the honest choice when a question has no good answer.
  playItDown,
}

/// What a tone does to the dressing room and to the board, in points on their
/// 0–100 scales. Deliberately small: a press answer is a nudge, not a result.
typedef PressEffect = ({int morale, int board});

/// One question, asked once.
typedef PressQuestion = ({
  /// Stable and unique — a question with this key is never asked again.
  String key,

  /// Which situation prompted it, for the wording.
  PressTopic topic,

  /// The other nation involved, when the question is about a specific match.
  int? subjectNationId,

  /// The tones on offer, in the order they are shown.
  List<PressTone> options,
});

/// What the press want to talk about. The wording lives in the UI layer (it is
/// localised); the domain only decides that there is a question and what the
/// answers cost.
enum PressTopic {
  /// After a heavy defeat.
  heavyDefeat,

  /// After a run of poor results, with the board watching.
  underPressure,

  /// Before a tournament starts.
  tournamentPreview,

  /// The tournament has been opened — the manager faces the world's press on
  /// the eve of their first match. Unlike every other topic this one is not
  /// optional: it is asked once per tournament the nation is contesting, as a
  /// step in the timeline rather than a card that may be ignored.
  tournamentOpening,

  /// After winning a trophy.
  triumph,

  /// After going out of a tournament.
  elimination,

  /// After putting a side to the sword — the mirror of [heavyDefeat], and the
  /// question a manager gets asked when everything went right.
  bigWin,

  /// A place at the finals has been booked.
  qualified,

  /// The qualifying campaign ended without a place.
  missedOut,

  /// A long run without defeat, with everyone asking how long it can last.
  unbeatenRun,

  /// The first days in the job, before a ball has been kicked.
  newJob,

  /// The nation has climbed to a world ranking it has never held before.
  rankingPeak,
}

abstract final class Press {
  /// How long a question stays askable. Press conferences are about something
  /// that just happened — an unanswered question about a match six weeks ago
  /// is stale, so it is dropped rather than queued.
  static const int askWindowDays = 45;

  /// The minimum gap between questions, so the press are an occasional presence
  /// rather than a chore after every match.
  static const int quietDays = 30;

  /// How many of the live stories are in the draw when the press pick their
  /// question. Taking the single biggest one every time made the conference
  /// predictable — the same handful of situations in the same order — so the
  /// question is drawn from the top few, and a good week can be asked about
  /// instead of last month's defeat.
  static const int storyPool = 4;

  /// What each tone does.
  static PressEffect effectOf(PressTone tone) => switch (tone) {
    PressTone.backThePlayers => (morale: 6, board: -3),
    PressTone.takeTheBlame => (morale: 4, board: -1),
    PressTone.demandMore => (morale: -5, board: 4),
    PressTone.raiseTheBar => (morale: -3, board: 6),
    PressTone.playItDown => (morale: 0, board: 0),
  };

  /// The answers offered for a topic. Every question keeps [PressTone.playItDown]
  /// as a way out, so a manager is never forced into a stance.
  static List<PressTone> optionsFor(PressTopic topic) => switch (topic) {
    PressTopic.heavyDefeat => const [
      PressTone.backThePlayers,
      PressTone.takeTheBlame,
      PressTone.demandMore,
      PressTone.playItDown,
    ],
    PressTopic.underPressure => const [
      PressTone.takeTheBlame,
      PressTone.demandMore,
      PressTone.raiseTheBar,
      PressTone.playItDown,
    ],
    PressTopic.tournamentPreview => const [
      PressTone.raiseTheBar,
      PressTone.backThePlayers,
      PressTone.playItDown,
    ],
    PressTopic.tournamentOpening => const [
      PressTone.raiseTheBar,
      PressTone.backThePlayers,
      PressTone.demandMore,
      PressTone.playItDown,
    ],
    PressTopic.triumph => const [
      PressTone.backThePlayers,
      PressTone.raiseTheBar,
      PressTone.playItDown,
    ],
    PressTopic.elimination => const [
      PressTone.takeTheBlame,
      PressTone.backThePlayers,
      PressTone.demandMore,
      PressTone.playItDown,
    ],
    // A night that went well is an invitation to talk the side up — or to
    // refuse to get carried away, which is its own kind of answer.
    PressTopic.bigWin => const [
      PressTone.backThePlayers,
      PressTone.raiseTheBar,
      PressTone.demandMore,
      PressTone.playItDown,
    ],
    PressTopic.qualified => const [
      PressTone.backThePlayers,
      PressTone.raiseTheBar,
      PressTone.demandMore,
      PressTone.playItDown,
    ],
    PressTopic.missedOut => const [
      PressTone.takeTheBlame,
      PressTone.backThePlayers,
      PressTone.demandMore,
      PressTone.playItDown,
    ],
    PressTopic.unbeatenRun => const [
      PressTone.backThePlayers,
      PressTone.raiseTheBar,
      PressTone.playItDown,
    ],
    PressTopic.newJob => const [
      PressTone.raiseTheBar,
      PressTone.backThePlayers,
      PressTone.demandMore,
      PressTone.playItDown,
    ],
    PressTopic.rankingPeak => const [
      PressTone.backThePlayers,
      PressTone.raiseTheBar,
      PressTone.playItDown,
    ],
  };

  /// The combined effect of everything said this cycle, clamped so a manager
  /// cannot talk their way to a title. Answers from earlier cycles are gone.
  static PressEffect totalOf(Iterable<PressEffect> answers) {
    var morale = 0;
    var board = 0;
    for (final a in answers) {
      morale += a.morale;
      board += a.board;
    }
    return (morale: morale.clamp(-12, 12), board: board.clamp(-10, 10));
  }
}
