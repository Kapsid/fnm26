import 'package:fnm/domain/services/match/match_engine.dart';

/// What an answer does to the dressing room and to the board, in points on
/// their 0–100 scales. Deliberately small: a press answer is a nudge, not a
/// result.
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

/// Which story about a named man, or about the next opponent, is live.
///
/// This is what is left of the old question-picking press room: the squad and
/// opponent readings ([SquadStories], [OpponentStories]) still describe the
/// stories the country is talking about, and the Y feed turns them into posts.
/// A conference is no longer built from a topic; see `conference.dart`.
enum PressTopic {
  /// The first-choice forward, and how long it is since he scored.
  strikerDrought,

  /// A young man who has just had the game of his life.
  youngsterBreakthrough,

  /// One of the best players in the country, watching from the bench.
  droppedStar,

  /// The captain, and whether he is still playing like one.
  captaincyQuestion,

  /// A thirty-four-year-old regular whose level is going.
  veteranEnd,

  /// A first cap.
  debutant,

  /// The next match is against the side this nation has met most often.
  rivalryNext,

  /// A long run against the next opponent, without defeat or without a win.
  headToHeadRun,

  /// The next opponent is the side that put this nation out last time.
  revengeMatch,
}

/// WHO or WHAT a story is about. Copy for a subject-bearing story takes
/// ARGUMENTS: it names a man, a minute or an opponent.
sealed class PressSubject {
  const PressSubject();
}

/// A named man: a selection, a drought, a first cap.
///
/// [count] is the FIGURE the story names: the caps without a goal, the age,
/// the rating he is carrying.
final class PressSubjectPlayer extends PressSubject {
  const PressSubjectPlayer({
    required this.playerId,
    required this.name,
    this.count = 0,
  });

  final int playerId;
  final String name;
  final int count;
}

/// The other side, when the story is about THEM rather than about the
/// afternoon.
///
/// [count] is the figure that makes it a story, meetings or the length of a
/// run, and [favourable] says which way that run reads, because "five without
/// defeat against them" and "five without a win against them" are the same
/// number and opposite stories.
final class PressSubjectOpponent extends PressSubject {
  const PressSubjectOpponent(
    this.nationId, {
    this.count = 0,
    this.favourable = true,
  });

  final int nationId;
  final int count;
  final bool favourable;
}

/// One thing that happened on the pitch, with the minute it happened in.
///
/// [name] is the player it happened to, already resolved, so a widget need
/// not reach into a repository to find out who number eight was. [ours] says
/// whose man he is, which is the difference between a late winner and a late
/// equaliser conceded.
final class PressSubjectIncident extends PressSubject {
  const PressSubjectIncident({
    required this.type,
    required this.minute,
    this.playerId,
    this.name,
    this.ours = true,
    this.fromLastMatch = true,
  });

  final MatchEventType type;
  final int minute;
  final int? playerId;
  final String? name;
  final bool ours;

  /// Whether it happened in the match the country is still talking about.
  final bool fromLastMatch;
}

abstract final class Press {
  /// How strongly a swing of [value] reads, as one, two or three arrows.
  ///
  /// The sheet used to print the raw number, which is a figure on a hidden
  /// 0-100 scale the manager has never been shown. Arrows say the only thing
  /// the number was ever meant to say: whether an answer moves the room a
  /// little, a fair amount, or a great deal. The bands hold for a single
  /// answer and for a whole conference alike; everything beyond a great deal is
  /// still a great deal.
  static int arrowsFor(int value) {
    final size = value.abs();
    if (size == 0) return 0;
    if (size <= 2) return 1;
    if (size <= 5) return 2;
    return 3;
  }

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

  /// This cycle's press, plus half of last cycle's: what was said lingers
  /// rather than vanishing at the turn of the cycle. Capped like [totalOf].
  static PressEffect carryOver(
    Iterable<PressEffect> current,
    Iterable<PressEffect> previous,
  ) {
    final prev = totalOf(previous);
    return totalOf([
      ...current,
      (morale: prev.morale ~/ 2, board: prev.board ~/ 2),
    ]);
  }
}
