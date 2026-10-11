import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/statement.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The words of a press conference: what the reporter asks, what the manager
/// can answer, and the line that tells him an answer went on the record.
///
/// Every mapping is an exhaustive `switch`, so a new [BeatKind],
/// [AnswerKind], [ConferenceReason] or [StatementKind] fails to compile here
/// until it has copy, rather than reaching a player mute.

/// The competition a preview [campaign] is about, as the manager reads it:
/// the World Championship, or his own confederation's championship.
String previewCompetitionName(
  AppLocalizations l,
  PreviewCampaign campaign,
  Confederation? confederation,
) {
  if (campaign.isWorld) return l.objectiveWorldCup;
  final cup = confederation == null
      ? null
      : ContinentalCups.byConfederation[confederation];
  return cup == null ? l.objectiveWorldCup : competitionLabel(l, cup.name);
}

T _pick<T>(List<T> list, int seed) => list[seed.abs() % list.length];

/// The reporter's attitude to the MANAGER, read off his credibility: a room
/// that has stopped believing him is hostile even after a win.
enum _Tone { warm, neutral, hostile }

_Tone _toneOf(CredibilityBand band) => switch (band) {
  CredibilityBand.low => _Tone.hostile,
  CredibilityBand.mid => _Tone.neutral,
  CredibilityBand.high => _Tone.warm,
};

/// The question [beat] is asked with, in the room's tone for [c].
///
/// [playerName] fills the questions that name a player (the standout, the
/// struggler, and a throwback to a statement about him); [opponentName] fills
/// the opening question. [seed] picks between the two wordings of each.
String beatQuestion(
  AppLocalizations l,
  Beat beat,
  PendingConference c, {
  required String? playerName,
  required String opponentName,
  required int seed,

  /// A preview's competition and group rival, for its own questions.
  String competitionName = '',
  String rivalName = '',
}) {
  final tone = _toneOf(Credibility.band(c.credibility));
  final names =
      beat.kind == BeatKind.standout ||
      beat.kind == BeatKind.struggler ||
      beat.kind == BeatKind.keyPlayer ||
      (beat.kind == BeatKind.throwback &&
          _namesPlayer(c.facts.throwback!.kind));
  final player = names ? _named(playerName) : playerName ?? '';
  return switch (beat.kind) {
    BeatKind.moment => _pick(
      _moment(l, c.facts.reason, tone, opponentName),
      seed,
    ),
    BeatKind.whoToBlame ||
    BeatKind.ifYouDont ||
    BeatKind.followUp ||
    BeatKind.standout ||
    BeatKind.struggler => _pick(_beat(l, beat.kind, tone, player), seed),
    BeatKind.throwback => _throwback(
      l,
      c.facts.throwback!.kind,
      _kept(c.facts.throwback!.status),
      tone,
      player,
    ),
    BeatKind.aim => _pick(
      _aim(
        l,
        qualifying: c.facts.preview?.campaign.isQualifying ?? false,
        tone: tone,
        competition: competitionName,
      ),
      seed,
    ),
    BeatKind.rival => _pick(_rival(l, tone, rivalName), seed),
    BeatKind.keyPlayer => _pick(_keyPlayer(l, tone, player), seed),
  };
}

/// What the manager says when he picks [a]: one of four wordings by [seed].
String answerLabel(
  AppLocalizations l,
  AnswerKind a, {
  required String? playerName,
  required int seed,
}) {
  final player = _namesPlayer(ConferenceBuilder.statementOf(a))
      ? _named(playerName)
      : playerName ?? '';
  final variants = switch (a) {
    AnswerKind.creditPlayers => [
      l.pressReplyCreditPlayers1,
      l.pressReplyCreditPlayers2,
      l.pressReplyCreditPlayers3,
      l.pressReplyCreditPlayers4,
    ],
    AnswerKind.takeResponsibility => [
      l.pressReplyTakeResponsibility1,
      l.pressReplyTakeResponsibility2,
      l.pressReplyTakeResponsibility3,
      l.pressReplyTakeResponsibility4,
    ],
    AnswerKind.demandMore => [
      l.pressReplyDemandMore1,
      l.pressReplyDemandMore2,
      l.pressReplyDemandMore3,
      l.pressReplyDemandMore4,
    ],
    AnswerKind.promiseWinNext => [
      l.pressReplyPromiseWinNext1,
      l.pressReplyPromiseWinNext2,
      l.pressReplyPromiseWinNext3,
      l.pressReplyPromiseWinNext4,
    ],
    AnswerKind.jobOnTheLine => [
      l.pressReplyJobOnTheLine1,
      l.pressReplyJobOnTheLine2,
      l.pressReplyJobOnTheLine3,
      l.pressReplyJobOnTheLine4,
    ],
    AnswerKind.backPlayer => [
      l.pressReplyBackPlayer1(player),
      l.pressReplyBackPlayer2(player),
      l.pressReplyBackPlayer3(player),
      l.pressReplyBackPlayer4(player),
    ],
    AnswerKind.blamePlayer => [
      l.pressReplyBlamePlayer1(player),
      l.pressReplyBlamePlayer2(player),
      l.pressReplyBlamePlayer3(player),
      l.pressReplyBlamePlayer4(player),
    ],
    AnswerKind.deflect => [
      l.pressReplyDeflect1,
      l.pressReplyDeflect2,
      l.pressReplyDeflect3,
      l.pressReplyDeflect4,
    ],
    AnswerKind.takeCredit => [
      l.pressReplyTakeCredit1,
      l.pressReplyTakeCredit2,
      l.pressReplyTakeCredit3,
      l.pressReplyTakeCredit4,
    ],
    AnswerKind.standByIt => [
      l.pressReplyStandByIt1,
      l.pressReplyStandByIt2,
      l.pressReplyStandByIt3,
      l.pressReplyStandByIt4,
    ],
    AnswerKind.admitMistake => [
      l.pressReplyAdmitMistake1,
      l.pressReplyAdmitMistake2,
      l.pressReplyAdmitMistake3,
      l.pressReplyAdmitMistake4,
    ],
    AnswerKind.aimHigher => [l.pressReplyAimHigher1, l.pressReplyAimHigher2],
    AnswerKind.matchBrief => [l.pressReplyMatchBrief1, l.pressReplyMatchBrief2],
    AnswerKind.playDown => [l.pressReplyPlayDown1, l.pressReplyPlayDown2],
    AnswerKind.promiseQualify => [
      l.pressReplyPromiseQualify1,
      l.pressReplyPromiseQualify2,
    ],
    AnswerKind.fearNobody => [l.pressReplyFearNobody1, l.pressReplyFearNobody2],
    AnswerKind.respectRival => [
      l.pressReplyRespectRival1,
      l.pressReplyRespectRival2,
    ],
    AnswerKind.teamFirst => [l.pressReplyTeamFirst1, l.pressReplyTeamFirst2],
  };
  return _pick(variants, seed);
}

/// The note under an answer that goes on the record, or null for an answer
/// nobody will hold against him.
///
/// [aim] is the target an aim answer states, worded as a board objective.
String? onRecordLine(
  AppLocalizations l,
  AnswerKind a, {
  required String? playerName,
  String aim = '',
}) {
  final player = _namesPlayer(ConferenceBuilder.statementOf(a))
      ? _named(playerName)
      : playerName ?? '';
  return switch (ConferenceBuilder.statementOf(a)) {
    StatementKind.target when a == AnswerKind.playDown =>
      l.pressOnRecordPlayDown,
    StatementKind.target => l.pressOnRecordTarget(aim),
    StatementKind.winNext => l.pressOnRecordWinNext,
    StatementKind.jobOnTheLine => l.pressOnRecordJob,
    StatementKind.backPlayer => l.pressOnRecordBack(player),
    StatementKind.blamePlayer => l.pressOnRecordBlame(player),
    null => null,
  };
}

/// Every question wording there is, with the reason it belongs to (moments
/// only) and its beat kind, filled with sample names. For the copy guards.
List<(ConferenceReason?, BeatKind, String)> allQuestionVariants(
  AppLocalizations l,
) {
  const player = 'Novák';
  const opponent = 'Brazil';
  return [
    for (final reason in ConferenceReason.values)
      for (final tone in _Tone.values)
        for (final text in _moment(l, reason, tone, opponent))
          (reason, BeatKind.moment, text),
    for (final kind in BeatKind.values)
      if (kind != BeatKind.moment && kind != BeatKind.throwback)
        for (final tone in _Tone.values)
          for (final text in _beat(l, kind, tone, player)) (null, kind, text),
    for (final tone in _Tone.values) ...[
      for (final qualifying in const [true, false])
        for (final text in _aim(
          l,
          qualifying: qualifying,
          tone: tone,
          competition: 'World Championship',
        ))
          (ConferenceReason.preview, BeatKind.aim, text),
      for (final text in _rival(l, tone, opponent))
        (ConferenceReason.preview, BeatKind.rival, text),
      for (final text in _keyPlayer(l, tone, player))
        (ConferenceReason.preview, BeatKind.keyPlayer, text),
    ],
    for (final kind in StatementKind.values)
      for (final kept in const [true, false])
        for (final tone in _Tone.values)
          (null, BeatKind.throwback, _throwback(l, kind, kept, tone, player)),
  ];
}

/// Whether a statement of [kind] (or the answer that makes one) is about a
/// named player.
bool _namesPlayer(StatementKind? kind) =>
    kind == StatementKind.backPlayer || kind == StatementKind.blamePlayer;

/// A line that names a player must be handed his name: a blank in its place
/// is a lookup that went wrong upstream (a player of another nation, say), so
/// it fails loudly in debug and degrades to an empty name in release.
String _named(String? playerName) {
  assert(playerName != null, 'a line that names a player was given no name');
  return playerName ?? '';
}

bool _kept(StatementStatus s) => switch (s) {
  StatementStatus.kept => true,
  StatementStatus.broken ||
  StatementStatus.open ||
  StatementStatus.lapsed => false,
};

List<String> _moment(
  AppLocalizations l,
  ConferenceReason reason,
  _Tone tone,
  String opponent,
) => switch ((reason, tone)) {
  (ConferenceReason.bigWin, _Tone.warm) => [
    l.pressMomentBigWinWarm1(opponent),
    l.pressMomentBigWinWarm2(opponent),
  ],
  (ConferenceReason.bigWin, _Tone.neutral) => [
    l.pressMomentBigWinNeutral1(opponent),
    l.pressMomentBigWinNeutral2(opponent),
  ],
  (ConferenceReason.bigWin, _Tone.hostile) => [
    l.pressMomentBigWinHostile1(opponent),
    l.pressMomentBigWinHostile2(opponent),
  ],
  (ConferenceReason.bigLoss, _Tone.warm) => [
    l.pressMomentBigLossWarm1(opponent),
    l.pressMomentBigLossWarm2(opponent),
  ],
  (ConferenceReason.bigLoss, _Tone.neutral) => [
    l.pressMomentBigLossNeutral1(opponent),
    l.pressMomentBigLossNeutral2(opponent),
  ],
  (ConferenceReason.bigLoss, _Tone.hostile) => [
    l.pressMomentBigLossHostile1(opponent),
    l.pressMomentBigLossHostile2(opponent),
  ],
  (ConferenceReason.crisis, _Tone.warm) => [
    l.pressMomentCrisisWarm1(opponent),
    l.pressMomentCrisisWarm2(opponent),
  ],
  (ConferenceReason.crisis, _Tone.neutral) => [
    l.pressMomentCrisisNeutral1(opponent),
    l.pressMomentCrisisNeutral2(opponent),
  ],
  (ConferenceReason.crisis, _Tone.hostile) => [
    l.pressMomentCrisisHostile1(opponent),
    l.pressMomentCrisisHostile2(opponent),
  ],
  (ConferenceReason.jobVerdict, _Tone.warm) => [
    l.pressMomentJobVerdictWarm1(opponent),
    l.pressMomentJobVerdictWarm2(opponent),
  ],
  (ConferenceReason.jobVerdict, _Tone.neutral) => [
    l.pressMomentJobVerdictNeutral1(opponent),
    l.pressMomentJobVerdictNeutral2(opponent),
  ],
  (ConferenceReason.jobVerdict, _Tone.hostile) => [
    l.pressMomentJobVerdictHostile1(opponent),
    l.pressMomentJobVerdictHostile2(opponent),
  ],
  // A preview opens on its own question (see [_aim]).
  (ConferenceReason.preview, _) => const [],
};

/// A preview's opening: what is he aiming for in [competition]?
List<String> _aim(
  AppLocalizations l, {
  required bool qualifying,
  required _Tone tone,
  required String competition,
}) => switch ((qualifying, tone)) {
  (true, _Tone.warm) => [
    l.pressAimQualWarm1(competition),
    l.pressAimQualWarm2(competition),
  ],
  (true, _Tone.neutral) => [
    l.pressAimQualNeutral1(competition),
    l.pressAimQualNeutral2(competition),
  ],
  (true, _Tone.hostile) => [
    l.pressAimQualHostile1(competition),
    l.pressAimQualHostile2(competition),
  ],
  (false, _Tone.warm) => [
    l.pressAimFinalsWarm1(competition),
    l.pressAimFinalsWarm2(competition),
  ],
  (false, _Tone.neutral) => [
    l.pressAimFinalsNeutral1(competition),
    l.pressAimFinalsNeutral2(competition),
  ],
  (false, _Tone.hostile) => [
    l.pressAimFinalsHostile1(competition),
    l.pressAimFinalsHostile2(competition),
  ],
};

List<String> _rival(AppLocalizations l, _Tone tone, String rival) =>
    switch (tone) {
      _Tone.warm => [
        l.pressBeatRivalWarm1(rival),
        l.pressBeatRivalWarm2(rival),
      ],
      _Tone.neutral => [
        l.pressBeatRivalNeutral1(rival),
        l.pressBeatRivalNeutral2(rival),
      ],
      _Tone.hostile => [
        l.pressBeatRivalHostile1(rival),
        l.pressBeatRivalHostile2(rival),
      ],
    };

List<String> _keyPlayer(AppLocalizations l, _Tone tone, String player) =>
    switch (tone) {
      _Tone.warm => [
        l.pressBeatKeyPlayerWarm1(player),
        l.pressBeatKeyPlayerWarm2(player),
      ],
      _Tone.neutral => [
        l.pressBeatKeyPlayerNeutral1(player),
        l.pressBeatKeyPlayerNeutral2(player),
      ],
      _Tone.hostile => [
        l.pressBeatKeyPlayerHostile1(player),
        l.pressBeatKeyPlayerHostile2(player),
      ],
    };

/// The reaction and player questions. [BeatKind.moment] and
/// [BeatKind.throwback] have copy of their own and land here empty.
List<String> _beat(
  AppLocalizations l,
  BeatKind kind,
  _Tone tone,
  String player,
) => switch ((kind, tone)) {
  (BeatKind.whoToBlame, _Tone.warm) => [
    l.pressBeatWhoToBlameWarm1,
    l.pressBeatWhoToBlameWarm2,
  ],
  (BeatKind.whoToBlame, _Tone.neutral) => [
    l.pressBeatWhoToBlameNeutral1,
    l.pressBeatWhoToBlameNeutral2,
  ],
  (BeatKind.whoToBlame, _Tone.hostile) => [
    l.pressBeatWhoToBlameHostile1,
    l.pressBeatWhoToBlameHostile2,
  ],
  (BeatKind.ifYouDont, _Tone.warm) => [
    l.pressBeatIfYouDontWarm1,
    l.pressBeatIfYouDontWarm2,
  ],
  (BeatKind.ifYouDont, _Tone.neutral) => [
    l.pressBeatIfYouDontNeutral1,
    l.pressBeatIfYouDontNeutral2,
  ],
  (BeatKind.ifYouDont, _Tone.hostile) => [
    l.pressBeatIfYouDontHostile1,
    l.pressBeatIfYouDontHostile2,
  ],
  (BeatKind.followUp, _Tone.warm) => [
    l.pressBeatFollowUpWarm1,
    l.pressBeatFollowUpWarm2,
  ],
  (BeatKind.followUp, _Tone.neutral) => [
    l.pressBeatFollowUpNeutral1,
    l.pressBeatFollowUpNeutral2,
  ],
  (BeatKind.followUp, _Tone.hostile) => [
    l.pressBeatFollowUpHostile1,
    l.pressBeatFollowUpHostile2,
  ],
  (BeatKind.standout, _Tone.warm) => [
    l.pressBeatStandoutWarm1(player),
    l.pressBeatStandoutWarm2(player),
  ],
  (BeatKind.standout, _Tone.neutral) => [
    l.pressBeatStandoutNeutral1(player),
    l.pressBeatStandoutNeutral2(player),
  ],
  (BeatKind.standout, _Tone.hostile) => [
    l.pressBeatStandoutHostile1(player),
    l.pressBeatStandoutHostile2(player),
  ],
  (BeatKind.struggler, _Tone.warm) => [
    l.pressBeatStrugglerWarm1(player),
    l.pressBeatStrugglerWarm2(player),
  ],
  (BeatKind.struggler, _Tone.neutral) => [
    l.pressBeatStrugglerNeutral1(player),
    l.pressBeatStrugglerNeutral2(player),
  ],
  (BeatKind.struggler, _Tone.hostile) => [
    l.pressBeatStrugglerHostile1(player),
    l.pressBeatStrugglerHostile2(player),
  ],
  (BeatKind.moment, _) ||
  (BeatKind.throwback, _) ||
  (BeatKind.aim, _) ||
  (BeatKind.rival, _) ||
  (BeatKind.keyPlayer, _) => const [],
};

/// The question that confronts him with a statement the results have judged.
/// For [StatementKind.blamePlayer], kept means the player stayed poor (he was
/// right); broken means the player answered him.
String _throwback(
  AppLocalizations l,
  StatementKind kind,
  bool kept,
  _Tone tone,
  String player,
) => switch ((kind, kept, tone)) {
  (StatementKind.winNext, true, _Tone.warm) => l.pressThrowbackWinNextKeptWarm,
  (StatementKind.winNext, true, _Tone.neutral) =>
    l.pressThrowbackWinNextKeptNeutral,
  (StatementKind.winNext, true, _Tone.hostile) =>
    l.pressThrowbackWinNextKeptHostile,
  (StatementKind.winNext, false, _Tone.warm) =>
    l.pressThrowbackWinNextBrokenWarm,
  (StatementKind.winNext, false, _Tone.neutral) =>
    l.pressThrowbackWinNextBrokenNeutral,
  (StatementKind.winNext, false, _Tone.hostile) =>
    l.pressThrowbackWinNextBrokenHostile,
  (StatementKind.jobOnTheLine, true, _Tone.warm) => l.pressThrowbackJobKeptWarm,
  (StatementKind.jobOnTheLine, true, _Tone.neutral) =>
    l.pressThrowbackJobKeptNeutral,
  (StatementKind.jobOnTheLine, true, _Tone.hostile) =>
    l.pressThrowbackJobKeptHostile,
  (StatementKind.jobOnTheLine, false, _Tone.warm) =>
    l.pressThrowbackJobBrokenWarm,
  (StatementKind.jobOnTheLine, false, _Tone.neutral) =>
    l.pressThrowbackJobBrokenNeutral,
  (StatementKind.jobOnTheLine, false, _Tone.hostile) =>
    l.pressThrowbackJobBrokenHostile,
  (StatementKind.backPlayer, true, _Tone.warm) => l.pressThrowbackBackKeptWarm(
    player,
  ),
  (StatementKind.backPlayer, true, _Tone.neutral) =>
    l.pressThrowbackBackKeptNeutral(player),
  (StatementKind.backPlayer, true, _Tone.hostile) =>
    l.pressThrowbackBackKeptHostile(player),
  (StatementKind.backPlayer, false, _Tone.warm) =>
    l.pressThrowbackBackBrokenWarm(player),
  (StatementKind.backPlayer, false, _Tone.neutral) =>
    l.pressThrowbackBackBrokenNeutral(player),
  (StatementKind.backPlayer, false, _Tone.hostile) =>
    l.pressThrowbackBackBrokenHostile(player),
  (StatementKind.blamePlayer, true, _Tone.warm) =>
    l.pressThrowbackBlameKeptWarm(player),
  (StatementKind.blamePlayer, true, _Tone.neutral) =>
    l.pressThrowbackBlameKeptNeutral(player),
  (StatementKind.blamePlayer, true, _Tone.hostile) =>
    l.pressThrowbackBlameKeptHostile(player),
  (StatementKind.blamePlayer, false, _Tone.warm) =>
    l.pressThrowbackBlameBrokenWarm(player),
  (StatementKind.blamePlayer, false, _Tone.neutral) =>
    l.pressThrowbackBlameBrokenNeutral(player),
  (StatementKind.blamePlayer, false, _Tone.hostile) =>
    l.pressThrowbackBlameBrokenHostile(player),
  (StatementKind.target, true, _Tone.warm) => l.pressThrowbackTargetKeptWarm,
  (StatementKind.target, true, _Tone.neutral) =>
    l.pressThrowbackTargetKeptNeutral,
  (StatementKind.target, true, _Tone.hostile) =>
    l.pressThrowbackTargetKeptHostile,
  (StatementKind.target, false, _Tone.warm) => l.pressThrowbackTargetBrokenWarm,
  (StatementKind.target, false, _Tone.neutral) =>
    l.pressThrowbackTargetBrokenNeutral,
  (StatementKind.target, false, _Tone.hostile) =>
    l.pressThrowbackTargetBrokenHostile,
};
