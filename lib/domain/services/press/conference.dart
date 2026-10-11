import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/press.dart' show PressEffect;
import 'package:fnm/domain/services/press/statement.dart';

/// Why the season called a press conference.
///
/// [preview] is the one called BEFORE a match: the opening of a campaign the
/// manager is in (see [PreviewCampaign]). Every other reason answers a result.
enum ConferenceReason { bigWin, bigLoss, crisis, jobVerdict, preview }

/// The campaigns that open with a preview conference.
enum PreviewCampaign {
  worldQualifying,
  continentalQualifying,
  worldFinals,
  continentalFinals;

  bool get isQualifying =>
      this == worldQualifying || this == continentalQualifying;

  bool get isWorld => this == worldQualifying || this == worldFinals;

  /// The brief the press hold him to, from the board's [boardTarget] for the
  /// tier. Qualifying asks only that the side gets there; at the finals,
  /// being there is already done, so the floor is getting out of the group,
  /// or "match the brief" would be a promise kept the day it was made.
  int briefFor(int boardTarget) =>
      isQualifying ? boardTarget.clamp(0, 2) : boardTarget.clamp(3, 7);

  /// The campaign a fixture's round code opens, or null when it opens none:
  /// World Championship qualifying carries no round code at all.
  static PreviewCampaign? ofRound(String? round) => switch (round) {
    null => worldQualifying,
    'CQ' => continentalQualifying,
    'GROUP' => worldFinals,
    'CGROUP' => continentalFinals,
    _ => null,
  };
}

/// What a preview conference is about: the campaign, the board's brief for it
/// (a 0–7 ordinal, capped at "qualify" for a qualifying campaign), the
/// best-ranked other side in his group and his best called-up player.
typedef PreviewFacts = ({
  PreviewCampaign campaign,
  int brief,
  int? rivalNationId,
  int? keyPlayerId,
});

/// Whether the manager has opened a conference the season called.
enum ConferenceStatus { pending, held, skipped }

/// A press conference the season has called, as stored.
typedef PressConferenceRow = ({
  int id,
  int cycle,
  ConferenceReason reason,
  int fixtureId,
  DateTime triggeredOn, // the match date
  ConferenceStatus status,
});

/// A competitive match from his record.
typedef OwnMatch = ({
  int fixtureId,
  DateTime date,
  int scored,
  int conceded,
  bool knockout,
  bool lastGroupMatch,
  ResultStanding standing,
});

/// A conference beat: its topic, answer options, and an optional player.
enum BeatKind {
  moment,
  whoToBlame,
  ifYouDont,
  standout,
  struggler,
  followUp,
  throwback,

  /// A preview's opening: what is he aiming for?
  aim,

  /// A preview's question about the strongest side in his group.
  rival,

  /// A preview's question about his best player.
  keyPlayer,
}

enum AnswerKind {
  creditPlayers,
  takeResponsibility,
  demandMore,
  promiseWinNext,
  jobOnTheLine,
  backPlayer,
  blamePlayer,
  deflect,
  takeCredit,
  standByIt,
  admitMistake,

  /// Preview answers. The first four put a target on the record.
  aimHigher,
  matchBrief,
  playDown,
  promiseQualify,
  fearNobody,
  respectRival,
  teamFirst,
}

typedef ConferenceFacts = ({
  ConferenceReason reason,
  int? bestPlayerId,
  int? worstPlayerId,
  bool hasOpenWinNext,
  bool hasOpenJob,
  Set<int> playersWithOpenStatement,
  PressStatement? throwback,

  /// Set for a [ConferenceReason.preview] only.
  PreviewFacts? preview,
});

typedef Beat = ({
  BeatKind kind,
  List<AnswerKind> answers,
  int? playerId,
});

abstract final class ConferenceTrigger {
  static const int quietDays = 45;
  static const int maxPerCycle = 6;
  static const int crisisBoardBelow = 40;
  static const int runLength = 3;

  static ConferenceReason? reasonFor({
    required List<OwnMatch> played,
    required int board,
    required bool jobJustBroken,
    required int conferencesThisCycle,
    required DateTime? lastConference,
  }) {
    // Callers pass post-match conferences only: a preview is called on its
    // own calendar and neither counts toward the cap nor starts the quiet.
    if (played.isEmpty) return null;
    if (jobJustBroken) return ConferenceReason.jobVerdict;
    final ms = [...played]
      ..sort((a, b) {
        final dateCompare = a.date.compareTo(b.date);
        return dateCompare != 0
            ? dateCompare
            : a.fixtureId.compareTo(b.fixtureId);
      });
    final latest = ms.last;
    if (lastConference != null &&
        latest.date.difference(lastConference).inDays < quietDays) {
      return null;
    }
    if (conferencesThisCycle >= maxPerCycle) return null;

    bool won(OwnMatch m) => m.scored > m.conceded;
    // The trailing run ending at [end] (exclusive of later matches): its
    // length and kind (wins, or winless).
    ({int length, bool wins, int losses}) runEndingAt(int end) {
      if (end < 0) return (length: 0, wins: false, losses: 0);
      final kind = won(ms[end]);
      var n = 0;
      var losses = 0;
      for (var i = end; i >= 0 && won(ms[i]) == kind; i--) {
        n++;
        if (ms[i].scored < ms[i].conceded) losses++;
      }
      return (length: n, wins: kind, losses: losses);
    }

    final now = runEndingAt(ms.length - 1);
    final crisis =
        (!now.wins && now.length >= runLength && now.losses >= 2) ||
        (board < crisisBoardBelow && !won(latest));
    if (crisis) return ConferenceReason.crisis;

    final loud =
        latest.standing == ResultStanding.heroic ||
        latest.standing == ResultStanding.humiliating;
    if (!loud) return null;
    final before = runEndingAt(ms.length - 2);
    final endsRun = before.length >= runLength && before.wins != now.wins;
    final startsRun = now.length == runLength;
    if (!(latest.knockout || latest.lastGroupMatch || endsRun || startsRun)) {
      return null;
    }
    return latest.standing == ResultStanding.heroic
        ? ConferenceReason.bigWin
        : ConferenceReason.bigLoss;
  }
}

abstract final class ConferenceBuilder {
  static const Map<AnswerKind, PressEffect> _base = {
    AnswerKind.creditPlayers: (morale: 5, board: -2),
    AnswerKind.takeResponsibility: (morale: 3, board: -1),
    AnswerKind.demandMore: (morale: -4, board: 4),
    AnswerKind.promiseWinNext: (morale: 3, board: 2),
    AnswerKind.jobOnTheLine: (morale: 2, board: 3),
    AnswerKind.backPlayer: (morale: 3, board: 0),
    AnswerKind.blamePlayer: (morale: -2, board: 2),
    AnswerKind.deflect: (morale: 0, board: 0),
    AnswerKind.takeCredit: (morale: -1, board: 3),
    AnswerKind.standByIt: (morale: 1, board: -3),
    AnswerKind.admitMistake: (morale: 1, board: 1),
    AnswerKind.aimHigher: (morale: 3, board: 2),
    AnswerKind.matchBrief: (morale: 2, board: 1),
    AnswerKind.playDown: (morale: 0, board: -2),
    AnswerKind.promiseQualify: (morale: 2, board: 1),
    AnswerKind.fearNobody: (morale: 3, board: 0),
    AnswerKind.respectRival: (morale: 1, board: 1),
    AnswerKind.teamFirst: (morale: 2, board: 0),
  };

  static PressEffect effectOf(AnswerKind a, int credibility) {
    final b = _base[a]!;
    final k = Credibility.multiplier(credibility);
    return (morale: (b.morale * k).round(), board: (b.board * k).round());
  }

  static StatementKind? statementOf(AnswerKind a) => switch (a) {
    AnswerKind.promiseWinNext => StatementKind.winNext,
    AnswerKind.jobOnTheLine => StatementKind.jobOnTheLine,
    AnswerKind.backPlayer => StatementKind.backPlayer,
    AnswerKind.blamePlayer => StatementKind.blamePlayer,
    AnswerKind.aimHigher ||
    AnswerKind.matchBrief ||
    AnswerKind.playDown ||
    AnswerKind.promiseQualify => StatementKind.target,
    _ => null,
  };

  /// The ordinal an aim answer puts on the record, against the preview's
  /// brief; null for any other answer.
  static int? statedTarget(AnswerKind a, PreviewFacts p) => switch (a) {
    AnswerKind.aimHigher => (p.brief + 1).clamp(0, 7),
    AnswerKind.matchBrief => p.brief,
    AnswerKind.promiseQualify => 2,
    AnswerKind.playDown => (p.brief - 1).clamp(0, 7),
    _ => null,
  };

  /// Every beat of a preview, fixed up front: the aim, then the draw when he
  /// has a group rival, then his key man when he can still be named.
  static List<Beat> previewBeats(ConferenceFacts f) {
    final p = f.preview!;
    final key = _nameable(f, p.keyPlayerId);
    return [
      (
        kind: BeatKind.aim,
        answers: p.campaign.isQualifying
            ? const [
                AnswerKind.promiseQualify,
                AnswerKind.playDown,
                AnswerKind.deflect,
              ]
            : [
                if (p.brief < 7) AnswerKind.aimHigher,
                AnswerKind.matchBrief,
                AnswerKind.playDown,
              ],
        playerId: null,
      ),
      if (p.rivalNationId != null)
        (
          kind: BeatKind.rival,
          answers: const [
            AnswerKind.fearNobody,
            AnswerKind.respectRival,
            AnswerKind.deflect,
          ],
          playerId: null,
        ),
      if (key != null)
        (
          kind: BeatKind.keyPlayer,
          answers: const [
            AnswerKind.backPlayer,
            AnswerKind.teamFirst,
            AnswerKind.deflect,
          ],
          playerId: key,
        ),
    ];
  }

  static bool asksAboutFuture(Beat b, ConferenceReason r) =>
      b.kind == BeatKind.moment &&
      (r == ConferenceReason.crisis || r == ConferenceReason.jobVerdict);

  static Beat opening(ConferenceFacts f) {
    if (f.reason == ConferenceReason.preview) return previewBeats(f).first;
    final answers = switch (f.reason) {
      ConferenceReason.bigWin => [
        AnswerKind.creditPlayers,
        AnswerKind.demandMore,
        if (!f.hasOpenWinNext) AnswerKind.promiseWinNext,
        AnswerKind.deflect,
      ],
      ConferenceReason.bigLoss => [
        AnswerKind.takeResponsibility,
        AnswerKind.demandMore,
        if (!f.hasOpenWinNext) AnswerKind.promiseWinNext,
        AnswerKind.deflect,
      ],
      ConferenceReason.crisis => [
        AnswerKind.takeResponsibility,
        AnswerKind.demandMore,
        if (!f.hasOpenJob) AnswerKind.jobOnTheLine,
        AnswerKind.deflect,
      ],
      ConferenceReason.jobVerdict => [
        AnswerKind.takeResponsibility,
        AnswerKind.creditPlayers,
        AnswerKind.deflect,
      ],
      ConferenceReason.preview => const <AnswerKind>[],
    };
    return (
      kind: BeatKind.moment,
      answers: answers,
      playerId: null,
    );
  }

  static const Beat _followUp = (
    kind: BeatKind.followUp,
    answers: [
      AnswerKind.takeResponsibility,
      AnswerKind.demandMore,
      AnswerKind.deflect,
    ],
    playerId: null,
  );

  static int? _nameable(ConferenceFacts f, int? id) =>
      id == null || f.playersWithOpenStatement.contains(id) ? null : id;

  static Beat reaction(ConferenceFacts f, AnswerKind first) => switch (first) {
    AnswerKind.demandMore => _demandMoreReaction(f),
    AnswerKind.promiseWinNext => (
      kind: BeatKind.ifYouDont,
      answers: [
        if (!f.hasOpenJob) AnswerKind.jobOnTheLine,
        AnswerKind.takeResponsibility,
        AnswerKind.deflect,
      ],
      playerId: null,
    ),
    AnswerKind.deflect => _followUp,
    AnswerKind.creditPlayers ||
    AnswerKind.takeResponsibility ||
    AnswerKind.jobOnTheLine ||
    AnswerKind.backPlayer ||
    AnswerKind.blamePlayer ||
    AnswerKind.takeCredit ||
    AnswerKind.standByIt ||
    AnswerKind.admitMistake ||
    // A preview's beats are fixed up front (see [previewBeats]); these never
    // reach a post-match reaction.
    AnswerKind.aimHigher ||
    AnswerKind.matchBrief ||
    AnswerKind.playDown ||
    AnswerKind.promiseQualify ||
    AnswerKind.fearNobody ||
    AnswerKind.respectRival ||
    AnswerKind.teamFirst => _otherAnswerReaction(f),
  };

  static Beat _demandMoreReaction(ConferenceFacts f) {
    final worst = _nameable(f, f.worstPlayerId);
    if (worst == null) return _followUp;
    return (
      kind: BeatKind.whoToBlame,
      answers: [
        AnswerKind.blamePlayer,
        AnswerKind.takeResponsibility,
        AnswerKind.deflect,
      ],
      playerId: worst,
    );
  }

  static Beat _otherAnswerReaction(ConferenceFacts f) {
    if (f.reason == ConferenceReason.bigWin) {
      final best = _nameable(f, f.bestPlayerId);
      if (best == null) return _followUp;
      return (
        kind: BeatKind.standout,
        answers: [
          AnswerKind.backPlayer,
          AnswerKind.creditPlayers,
          AnswerKind.deflect,
        ],
        playerId: best,
      );
    }
    final worst = _nameable(f, f.worstPlayerId);
    if (worst == null) return _followUp;
    return (
      kind: BeatKind.struggler,
      answers: [
        AnswerKind.backPlayer,
        AnswerKind.blamePlayer,
        AnswerKind.deflect,
      ],
      playerId: worst,
    );
  }

  static Beat? throwback(ConferenceFacts f) {
    final s = f.throwback;
    if (s == null) return null;
    final kept = s.status == StatementStatus.kept;
    return (
      kind: BeatKind.throwback,
      answers: kept
          ? [
              AnswerKind.takeCredit,
              AnswerKind.creditPlayers,
              AnswerKind.deflect,
            ]
          : [
              AnswerKind.admitMistake,
              AnswerKind.standByIt,
              AnswerKind.deflect,
            ],
      playerId: s.playerId,
    );
  }
}
