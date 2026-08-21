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

/// How a whole conference read once it was over — the line the back pages take
/// the next morning.
enum PressVerdict {
  /// It went well: the room got something and liked it.
  went,

  /// Something for everybody, which is to say nothing for anybody.
  mixed,

  /// It went badly.
  badly,

  /// Nothing was said at all, which is its own kind of story.
  flat,
}

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

/// The kind of reporter asking, which decides what they push on when they get
/// their turn.
///
/// A press conference used to be one anonymous question. It read as a form to
/// fill in rather than a room full of people, and — worse — nobody ever came
/// back at an answer, so a manager could back his players every single time
/// and never once be asked what that meant.
enum PressAngle {
  /// The tabloid. Wants a back page, so it pushes on blame and on jobs.
  tabloid,

  /// The national paper. Fair, and follows the thread of what was just said.
  broadsheet,

  /// The tactics writer. Interested in the team, not the temperature.
  analyst,

  /// The local radio voice, sitting with the supporters.
  local,

  /// The visiting correspondent, taking the long view.
  foreign,
}

/// A named reporter. The same handful turn up across a career, so the room
/// becomes people the manager recognises rather than a blank microphone.
///
/// [name] and [outlet] are invented and stay as written whatever the app's
/// language — they are proper nouns, like the club names.
typedef PressReporter = ({String name, String outlet, PressAngle angle});

/// What a follow-up presses on.
///
/// The first five are answers to a STANCE — they are what a room says back
/// when a manager has just committed to one — and the last three are a
/// reporter's own hobby-horse, used for the question that closes a conference.
enum PressProbe {
  /// You backed them. So is nobody responsible?
  accountability,

  /// You took it on yourself. Is your own job safe?
  yourFuture,

  /// You demanded more, in public. Have you lost them?
  dressingRoom,

  /// You talked the target up. Is that not a hostage to fortune?
  expectation,

  /// You said nothing at all. Say something.
  substance,

  /// Why does that team keep getting picked?
  selection,

  /// What do you say to the people who travel?
  theFans,

  /// Where is this actually going?
  bigPicture,
}

/// One exchange in a conference: who asked, what about, and what may be said
/// back. [probe] is null for the opening question, which is about the STORY —
/// every later one is a reaction to what the manager has just said.
typedef PressExchange = ({
  String key,
  PressReporter reporter,
  PressTopic topic,
  PressProbe? probe,
  int? subjectNationId,
  List<PressTone> options,

  /// How hard this answer lands, as a fraction of a full stance. The opening
  /// question is the one that carries; a follow-up is a nudge on a nudge.
  bool halfWeight,
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
  ///
  /// Cut from 45 days to 30 once the conference became a blocking event. At 45
  /// a manager could be asked about a hammering from a month and a half ago,
  /// which was the reported "I can answer older things". It cannot go below
  /// [quietDays] — a window shorter than the silence after an answer means
  /// every story goes stale inside the gap and the press never speak again —
  /// so the forcing does most of the work and this does the rest.
  static const int askWindowDays = 30;

  /// The minimum gap between questions, so the press are an occasional presence
  /// rather than a chore after every match.
  static const int quietDays = 30;

  /// How many of the live stories are in the draw when the press pick their
  /// question. Taking the single biggest one every time made the conference
  /// predictable — the same handful of situations in the same order — so the
  /// question is drawn from the top few, and a good week can be asked about
  /// instead of last month's defeat.
  static const int storyPool = 4;

  /// The prefix a topic's question key carries.
  ///
  /// The key is what gets stored when a question is answered, so it is also
  /// the only record of what the press have already asked about. Naming the
  /// mapping here — rather than leaving it implicit in a dozen string literals
  /// — is what lets [pick] avoid asking the same thing twice in a row.
  static String keyPrefixOf(PressTopic topic) => switch (topic) {
    PressTopic.heavyDefeat => 'defeat',
    PressTopic.underPressure => 'pressure',
    PressTopic.tournamentPreview => 'preview',
    PressTopic.tournamentOpening => 'opening',
    PressTopic.triumph => 'triumph',
    PressTopic.elimination => 'exit',
    PressTopic.bigWin => 'rout',
    PressTopic.qualified => 'qualified',
    PressTopic.missedOut => 'missed',
    PressTopic.unbeatenRun => 'unbeaten',
    PressTopic.newJob => 'newjob',
    PressTopic.rankingPeak => 'peak',
  };

  /// The topic a stored question key belongs to, or null if it is not a press
  /// question at all (a grievance is stored in the same table).
  static PressTopic? topicOfKey(String key) {
    final prefix = key.split(':').first;
    for (final topic in PressTopic.values) {
      if (keyPrefixOf(topic) == prefix) return topic;
    }
    return null;
  }

  /// Which of the live stories the press actually lead with.
  ///
  /// [candidates] arrive biggest-first. A topic the manager has just been
  /// asked about is pushed to the back rather than dropped: the press repeat
  /// themselves when nothing else has happened, but they do not open with the
  /// same question twice running while there is anything else to ask.
  static PressQuestion? pick(
    List<PressQuestion> candidates, {
    Set<PressTopic> recentTopics = const {},
    required int seed,
  }) {
    if (candidates.isEmpty) return null;
    final fresh = [
      for (final c in candidates)
        if (!recentTopics.contains(c.topic)) c,
    ];
    final pool = (fresh.isEmpty ? candidates : fresh).take(storyPool).toList();
    return pool[seed % pool.length];
  }

  /// How strongly a swing of [value] reads, as one, two or three arrows.
  ///
  /// The sheet used to print the raw number — "Squad 6" — which is a figure on
  /// a hidden 0–100 scale that the manager has never been shown and cannot
  /// place. Six of what? Arrows say the only thing the number was ever meant
  /// to say: whether this answer moves the room a little, a fair amount, or a
  /// great deal.
  ///
  /// The bands hold for a single answer and for a whole conference alike. One
  /// stance is worth at most six (see [effectOf]) and a follow-up half that,
  /// so a single answer spans the full range; a conference of four can total
  /// far more, and everything beyond a great deal is still a great deal.
  static int arrowsFor(int value) {
    final size = value.abs();
    if (size == 0) return 0;
    if (size <= 2) return 1;
    if (size <= 5) return 2;
    return 3;
  }

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
  /// What the manager can say to a question on [topic], given who he is.
  ///
  /// [target] is the height of the board's stated objective on the 2 (be
  /// there) … 7 (win it) scale, and [worldRank] is where the nation actually
  /// stands. Both are needed because a tone is only an option if it is a thing
  /// this manager could plausibly say: a side told to qualify, ranked
  /// sixtieth, being offered "we are here to win this" made the conference
  /// read as generic — the same four answers whoever you were, one of them
  /// absurd. [PressTone.playItDown] survives every filter, because saying as
  /// little as possible is always available to anybody.
  static List<PressTone> optionsFor(
    PressTopic topic, {
    int target = 7,
    int? worldRank,
  }) {
    final tones = _tonesFor(topic);
    // Talking the target up belongs to a side with something to talk up. An
    // UNKNOWN ranking is not evidence against him — a save before its first
    // release has no position yet, and a manager should not be silenced by the
    // game not having got round to ranking him.
    final canRaise =
        target > qualifyTarget && (worldRank == null || worldRank <= raiseRankBar);
    if (canRaise) return tones;
    final filtered = [
      for (final t in tones)
        if (t != PressTone.raiseTheBar) t,
    ];
    return filtered.isEmpty ? const [PressTone.playItDown] : filtered;
  }

  /// The objective height that means "just be there".
  static const int qualifyTarget = 2;

  /// The world ranking beyond which talking a target up is not a stance, it is
  /// a punchline.
  static const int raiseRankBar = 40;

  static List<PressTone> _tonesFor(PressTopic topic) => switch (topic) {
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

  /// The longest a conference can run to, for the sizes the UI has to reserve.
  static const int maxConferenceLength = 4;

  /// How many questions a conference runs to, by what it is ABOUT.
  ///
  /// It used to be three, always, which is what made it read as a form to fill
  /// in rather than a room: a World Cup final and a ranking milestone drew the
  /// same three questions. A triumph or an exit is a long afternoon; a nation
  /// climbing a place or two is a question and a thank-you.
  static int lengthFor(PressTopic topic) => switch (topic) {
    // The whole cycle in one room.
    PressTopic.triumph ||
    PressTopic.elimination ||
    PressTopic.tournamentPreview ||
    PressTopic.tournamentOpening => 4,
    // Something happened and it needs explaining.
    PressTopic.heavyDefeat ||
    PressTopic.underPressure ||
    PressTopic.missedOut ||
    PressTopic.qualified ||
    PressTopic.newJob => 3,
    // Worth a word, not an afternoon.
    PressTopic.bigWin || PressTopic.unbeatenRun => 2,
    PressTopic.rankingPeak => 1,
  };

  /// The reporters who cover this nation, drawn from the pool by [seed] so a
  /// manager sees the same faces across a career and a different set at his
  /// next job.
  ///
  /// One of each angle would be tidy and wrong: a room is not a panel, so the
  /// pool is drawn as it comes and a conference simply takes the next three.
  static List<PressReporter> roomFor(int seed) {
    final pool = [..._reporters];
    // A deterministic shuffle — a rotation plus a stride — so two saves get
    // different rooms without needing a random source in a pure function.
    final stride = 1 + seed.abs() % (pool.length - 1);
    final start = seed.abs() % pool.length;
    final out = <PressReporter>[];
    final taken = <int>{};
    var i = start;
    while (out.length < pool.length) {
      while (taken.contains(i % pool.length)) {
        i++;
      }
      taken.add(i % pool.length);
      out.add(pool[i % pool.length]);
      i += stride;
    }
    return out;
  }

  /// What the room comes back with after a manager has taken [tone].
  static PressProbe probeAfter(PressTone tone) => switch (tone) {
    PressTone.backThePlayers => PressProbe.accountability,
    PressTone.takeTheBlame => PressProbe.yourFuture,
    PressTone.demandMore => PressProbe.dressingRoom,
    PressTone.raiseTheBar => PressProbe.expectation,
    PressTone.playItDown => PressProbe.substance,
  };

  /// The question a reporter of this [angle] likes to finish on.
  static PressProbe closingProbe(PressAngle angle) => switch (angle) {
    PressAngle.tabloid => PressProbe.yourFuture,
    PressAngle.broadsheet => PressProbe.substance,
    PressAngle.analyst => PressProbe.selection,
    PressAngle.local => PressProbe.theFans,
    PressAngle.foreign => PressProbe.bigPicture,
  };

  /// The answers offered to a follow-up. Narrower than an opening question's:
  /// a comeback is pointed, and only some stances are an answer to it — but
  /// [PressTone.playItDown] is always there, as everywhere else.
  static List<PressTone> optionsForProbe(PressProbe probe) => switch (probe) {
    PressProbe.accountability => const [
      PressTone.takeTheBlame,
      PressTone.demandMore,
      PressTone.playItDown,
    ],
    PressProbe.yourFuture => const [
      PressTone.raiseTheBar,
      PressTone.takeTheBlame,
      PressTone.playItDown,
    ],
    PressProbe.dressingRoom => const [
      PressTone.backThePlayers,
      PressTone.demandMore,
      PressTone.playItDown,
    ],
    PressProbe.expectation => const [
      PressTone.raiseTheBar,
      PressTone.takeTheBlame,
      PressTone.playItDown,
    ],
    PressProbe.substance => const [
      PressTone.raiseTheBar,
      PressTone.backThePlayers,
      PressTone.demandMore,
      PressTone.playItDown,
    ],
    PressProbe.selection => const [
      PressTone.backThePlayers,
      PressTone.demandMore,
      PressTone.playItDown,
    ],
    PressProbe.theFans => const [
      PressTone.backThePlayers,
      PressTone.raiseTheBar,
      PressTone.playItDown,
    ],
    PressProbe.bigPicture => const [
      PressTone.raiseTheBar,
      PressTone.takeTheBlame,
      PressTone.playItDown,
    ],
  };

  /// The opening exchange of a conference about [question].
  static PressExchange openingExchange(
    PressQuestion question,
    PressReporter reporter,
  ) => (
    key: question.key,
    reporter: reporter,
    topic: question.topic,
    probe: null,
    subjectNationId: question.subjectNationId,
    options: question.options,
    halfWeight: false,
  );

  /// The exchange that follows [previous] once the manager has answered it
  /// with [tone]. [index] is its position in the conference (1 = the first
  /// follow-up), which is what keeps its stored key unique.
  static PressExchange followUp(
    PressQuestion question,
    PressReporter reporter,
    PressTone tone, {
    required int index,
  }) {
    // The last question of the conference belongs to whoever is asking it —
    // that is the one place a reporter gets to ride their own hobby-horse
    // rather than react to the manager.
    final probe = index >= lengthFor(question.topic) - 1
        ? closingProbe(reporter.angle)
        : probeAfter(tone);
    return (
      key: '${question.key}#$index',
      reporter: reporter,
      topic: question.topic,
      probe: probe,
      subjectNationId: question.subjectNationId,
      options: optionsForProbe(probe),
      halfWeight: true,
    );
  }

  /// What an answer to [exchange] costs, in the same points as [effectOf]. A
  /// follow-up is worth half a stance, rounded toward zero, so a whole
  /// conference is a strong statement rather than three of them.
  static PressEffect effectOfExchange(PressExchange exchange, PressTone tone) {
    final full = effectOf(tone);
    if (!exchange.halfWeight) return full;
    return (morale: full.morale ~/ 2, board: full.board ~/ 2);
  }

  /// How a conference LANDED, as a single verdict on everything said in it:
  /// the back page is written from the sum of the answers, not from any one.
  static PressVerdict verdictOf(PressEffect total) {
    final net = total.morale + total.board;
    if (total.morale == 0 && total.board == 0) return PressVerdict.flat;
    if (net >= 4) return PressVerdict.went;
    if (net <= -4) return PressVerdict.badly;
    return PressVerdict.mixed;
  }

  /// The invented press pack. Names and outlets are fiction and stay in this
  /// form in every language, exactly like the club names.
  static const List<PressReporter> _reporters = [
    (
      name: 'Elena Vasquez',
      outlet: 'The Daily Whistle',
      angle: PressAngle.tabloid,
    ),
    (
      name: 'Tomas Riedel',
      outlet: 'National Sport',
      angle: PressAngle.broadsheet,
    ),
    (name: 'Priya Anand', outlet: 'The Chalkboard', angle: PressAngle.analyst),
    (name: 'Danny Kerr', outlet: 'Radio Terrace', angle: PressAngle.local),
    (
      name: 'Ingrid Sollum',
      outlet: 'World Football Weekly',
      angle: PressAngle.foreign,
    ),
    (name: 'Marco Bellini', outlet: 'The Back Page', angle: PressAngle.tabloid),
    (name: 'Hana Okafor', outlet: 'The Standard', angle: PressAngle.broadsheet),
    (
      name: 'Ruben Sattler',
      outlet: 'Pressing Matters',
      angle: PressAngle.analyst,
    ),
    (name: 'Colette Auger', outlet: 'Supporters Hour', angle: PressAngle.local),
    (
      name: 'Yusuf Demir',
      outlet: 'Continental Review',
      angle: PressAngle.foreign,
    ),
  ];

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
