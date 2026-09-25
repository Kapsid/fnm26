/// A message is translated when it is READ, not when it is written.
///
/// The inbox used to store the sentence: `MessageService` asked the current
/// `AppLocalizations` for the words and put the result in `Messages.title` /
/// `Messages.body`. A message born while the app was in English was English for
/// ever, whatever the manager switched to afterwards, and a Czech save that had
/// ever been opened in English kept a permanent English patch in its archive.
///
/// What is stored now is what the message MEANS: the string that names it
/// ([MsgKey]) and the arguments it takes ([MsgText.args]) — a player's name, a
/// year, a count, a nested phrase, the canonical stored name of a competition.
/// The words are made at the moment the manager looks, out of the
/// `AppLocalizations` he is looking with.
///
/// The rendered columns are still written, and still read when no spec is
/// stored: a message filed before this change has nothing else, and shows what
/// it always showed. Everything from here on follows the language.
library;

import 'dart:convert';

import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Every string a stored message can be made of.
///
/// The name of each value IS its ARB key, and [renderMsgKey] is exhaustive over
/// them: a key added here that nobody teaches the renderer does not compile,
/// which is the whole reason this is an enum rather than a string. The stored
/// spec holds the value's name, so a value must not be renamed without
/// thinking about the saves that already name it — an unknown name reads back
/// as "no spec", and the message falls back to the words it was written in.
enum MsgKey {
  msgCycleTitle1,
  msgCycleTitle2,
  msgCycleTitle3,
  msgCycleTitle4,
  msgCycleBody1,
  msgCycleBody2,
  msgCycleBody3,
  msgCycleBody4,
  msgContHostTitle,
  msgContHostBody,
  msgContQualDrawTitle,
  msgContQualDrawBody,
  msgWcHostTitle,
  msgWcHostBody,
  msgWcQualDrawTitle,
  msgWcQualDrawBody,
  msgContFinalsDrawTitle,
  msgContFinalsDrawBody,
  msgWcFinalsDrawTitle,
  msgWcFinalsDrawBody,
  msgQualWcTitle1,
  msgQualWcTitle2,
  msgQualWcTitle3,
  msgQualWcTitle4,
  msgQualWcBody1,
  msgQualWcBody2,
  msgQualWcBody3,
  msgQualWcBody4,
  msgQualContTitle1,
  msgQualContTitle2,
  msgQualContTitle3,
  msgQualContBody1,
  msgQualContBody2,
  msgQualContBody3,
  msgFinalPensSuffix,
  msgFinalScoreSuffix,
  msgChampTitleMine1,
  msgChampTitleMine2,
  msgChampTitleMine3,
  msgChampTitleOther1,
  msgChampTitleOther2,
  msgChampTitleOther3,
  msgChampBodyMine1,
  msgChampBodyMine2,
  msgChampBodyMine3,
  msgChampBodyOther1,
  msgChampBodyOther2,
  msgWpotyTitle,
  msgWpotyBodyMine,
  msgWpotyBodyOther,
  msgYpotTitle,
  msgYpotBodyMine,
  msgYpotBodyOther,
  msgRankTitle,
  msgRankBody,
  msgRankLeadYou,
  msgRankLeadOther,
  msgRankHold1,
  msgRankHold2,
  msgRankHold3,
  msgRankUp1,
  msgRankUp2,
  msgRankUp3,
  msgRankDown1,
  msgRankDown2,
  msgRankDown3,
  msgRankJumpTitleUp,
  msgRankJumpTitleDown,
  msgRankJumpBodyUp,
  msgRankJumpBodyDown,
  msgCapsTitle,
  msgCapsBody,
  msgGoalsTitle,
  msgGoalsBody,
  msgDevTitle,
  msgThroughTitle,
  msgThroughNote,
  msgIntakeTitle,
  msgIntakeNoteBoth,
  msgIntakeNoteStanding,
  msgIntakeNoteAcademy,
  msgRetireTitle,
  msgRetireCaptainTitle,
  msgRetireBody,
  msgRetireBodyWith,
  msgTallyCaps,
  msgTallyGoals,
  msgArmbandVacant,
  msgHofTitle,
  msgHofBody,
  msgANation,
  msgAPlayer,
  msgAHostNation,
  newsRecordScorerTitle,
  newsRecordScorerBody,
  newsRecordCapsTitle,
  newsRecordCapsBody,
  newsARecordBreaker,
  newsTransferWindowTitle,
  newsNatzTitle,
  newsNatzStarTitle,
  newsNatzBody,
  newsNatzBodyStar,
  newsTheirNation,
  newsYourNation,
  newsWcMissTitle,
  newsWcMissBody,
  newsContMissTitle,
  newsContMissBody,
  newsWalkoutTitle,
  newsWalkoutBody,
  newsPotyTitle,
  newsPotyBody,
  newsPotyYoungSuffix,
  newsWatchTitle,
  newsWatchJump,
  newsWatchBand,
  newsWatchDebutTitle,
  newsWatchDebutBody,
  federationNaturalisedTitle,
  federationNaturalisedBody,
  hubBanTitle,
  hubBanBody,
  hubBanHowSecondYellow,
  hubBanHowViolent,
  hubBanHowRed,
  hubInjuryTitle,
  hubInjuryBody,
  hubRunnerUpTitle1,
  hubRunnerUpTitle2,
  hubRunnerUpTitle3,
  hubRunnerUpBody1,
  hubRunnerUpBody2,
  hubRunnerUpBody3,
  hubKnockedOutTitle1,
  hubKnockedOutTitle2,
  hubKnockedOutTitle3,
  hubKnockedOutBody1,
  hubKnockedOutBody2,
  hubKnockedOutBody3,
  hubGroupExitTitle1,
  hubGroupExitTitle2,
  hubGroupExitTitle3,
  hubGroupExitBody1,
  hubGroupExitBody2,
  hubGroupExitBody3,
  hubStageRoundOf32,
  hubStageThirdPlace,
  hubFinal,
  boardObjectiveMetTitle,
  boardObjectiveMissedTitle,
  boardObjectiveMetBody,
  boardObjectiveMissedBody,
  objectiveNcWinIt,
  objectiveNcReachFinal,
  objectiveNcFinalsFour,
  objectiveNcWinGroup,
  objectiveNcTopHalf,
  objectiveNcSurvive,
  objectiveWinTournament,
  objectiveReachFinal,
  objectiveReachSemis,
  objectiveReachQuarters,
  objectiveReachKnockouts,
  objectiveQualifyGeneric,
  objectiveQualifyingTopHalf,
  finishNcChampions,
  finishNcFinalsFour,
  finishNcGroupWinners,
  finishNcTopHalf,
  finishNcStayedUp,
  finishNcBottom,
  finishChampions,
  finishRunnersUp,
  finishSemiFinals,
  finishQuarterFinals,
  finishRoundOf16,
  finishGroupStage,
  finishQualifyingTopHalf,
  finishQualifyingBottomHalf,
  boardVerdictSackedTitle,
  boardVerdictSackedBody,
  boardVerdictDelightedTitle,
  boardVerdictDelightedBody,
  boardVerdictSolidTitle,
  boardVerdictSolidBody,
  boardVerdictExpectedMoreTitle,
  boardVerdictExpectedMoreBody,
  boardVerdictPressureTitle,
  boardVerdictPressureBody,
  boardVerdictHeroTitle,
  boardVerdictHeroNote,
  boardVerdictTheNation,
  boardVerdictBestQuiet,
  boardVerdictBestCycle,
  boardVerdictBestWorld,
  finishThirdPlace,
  finishFourthPlace,
  finishDidNotQualify,
}

/// The words for one [MsgText], in the language of [l].
///
/// EXHAUSTIVE on purpose, with no default branch — the same reason `yPostBody`
/// is: a hole would render as an empty title and nobody would notice for a
/// year. Every argument is read positionally, in the order the generated
/// method takes it.
String renderMsgKey(AppLocalizations l, MsgText text) {
  String s(int i) => _renderArg(l, text.args[i]);
  int n(int i) => (text.args[i]! as num).toInt();
  return switch (text.key) {
    MsgKey.msgCycleTitle1 => l.msgCycleTitle1,
    MsgKey.msgCycleTitle2 => l.msgCycleTitle2(n(0)),
    MsgKey.msgCycleTitle3 => l.msgCycleTitle3,
    MsgKey.msgCycleTitle4 => l.msgCycleTitle4,
    MsgKey.msgCycleBody1 => l.msgCycleBody1(n(0)),
    MsgKey.msgCycleBody2 => l.msgCycleBody2(n(0)),
    MsgKey.msgCycleBody3 => l.msgCycleBody3(n(0)),
    MsgKey.msgCycleBody4 => l.msgCycleBody4(n(0)),
    MsgKey.msgContHostTitle => l.msgContHostTitle(s(0), s(1)),
    MsgKey.msgContHostBody => l.msgContHostBody(s(0), s(1)),
    MsgKey.msgContQualDrawTitle => l.msgContQualDrawTitle(s(0)),
    MsgKey.msgContQualDrawBody => l.msgContQualDrawBody(s(0)),
    MsgKey.msgWcHostTitle => l.msgWcHostTitle(s(0), n(1)),
    MsgKey.msgWcHostBody => l.msgWcHostBody(s(0), n(1)),
    MsgKey.msgWcQualDrawTitle => l.msgWcQualDrawTitle,
    MsgKey.msgWcQualDrawBody => l.msgWcQualDrawBody,
    MsgKey.msgContFinalsDrawTitle => l.msgContFinalsDrawTitle(s(0)),
    MsgKey.msgContFinalsDrawBody => l.msgContFinalsDrawBody(s(0)),
    MsgKey.msgWcFinalsDrawTitle => l.msgWcFinalsDrawTitle,
    MsgKey.msgWcFinalsDrawBody => l.msgWcFinalsDrawBody(n(0)),
    MsgKey.msgQualWcTitle1 => l.msgQualWcTitle1,
    MsgKey.msgQualWcTitle2 => l.msgQualWcTitle2,
    MsgKey.msgQualWcTitle3 => l.msgQualWcTitle3,
    MsgKey.msgQualWcTitle4 => l.msgQualWcTitle4,
    MsgKey.msgQualWcBody1 => l.msgQualWcBody1(n(0)),
    MsgKey.msgQualWcBody2 => l.msgQualWcBody2(n(0)),
    MsgKey.msgQualWcBody3 => l.msgQualWcBody3(n(0)),
    MsgKey.msgQualWcBody4 => l.msgQualWcBody4(n(0)),
    MsgKey.msgQualContTitle1 => l.msgQualContTitle1(s(0)),
    MsgKey.msgQualContTitle2 => l.msgQualContTitle2(s(0)),
    MsgKey.msgQualContTitle3 => l.msgQualContTitle3(s(0)),
    MsgKey.msgQualContBody1 => l.msgQualContBody1(s(0)),
    MsgKey.msgQualContBody2 => l.msgQualContBody2(s(0)),
    MsgKey.msgQualContBody3 => l.msgQualContBody3(s(0)),
    MsgKey.msgFinalPensSuffix => l.msgFinalPensSuffix(n(0), n(1)),
    MsgKey.msgFinalScoreSuffix => l.msgFinalScoreSuffix(n(0), n(1)),
    MsgKey.msgChampTitleMine1 => l.msgChampTitleMine1(s(0)),
    MsgKey.msgChampTitleMine2 => l.msgChampTitleMine2(s(0)),
    MsgKey.msgChampTitleMine3 => l.msgChampTitleMine3(s(0)),
    MsgKey.msgChampTitleOther1 => l.msgChampTitleOther1(s(0)),
    MsgKey.msgChampTitleOther2 => l.msgChampTitleOther2(s(0)),
    MsgKey.msgChampTitleOther3 => l.msgChampTitleOther3(s(0)),
    MsgKey.msgChampBodyMine1 => l.msgChampBodyMine1(s(0), s(1), s(2), n(3)),
    MsgKey.msgChampBodyMine2 => l.msgChampBodyMine2(s(0), s(1), s(2), n(3)),
    MsgKey.msgChampBodyMine3 => l.msgChampBodyMine3(s(0), s(1), s(2), n(3)),
    MsgKey.msgChampBodyOther1 => l.msgChampBodyOther1(
      s(0),
      s(1),
      s(2),
      s(3),
      n(4),
    ),
    MsgKey.msgChampBodyOther2 => l.msgChampBodyOther2(
      s(0),
      s(1),
      s(2),
      s(3),
      n(4),
    ),
    MsgKey.msgWpotyTitle => l.msgWpotyTitle,
    MsgKey.msgWpotyBodyMine => l.msgWpotyBodyMine(s(0), s(1), n(2)),
    MsgKey.msgWpotyBodyOther => l.msgWpotyBodyOther(s(0), s(1), n(2)),
    MsgKey.msgYpotTitle => l.msgYpotTitle,
    MsgKey.msgYpotBodyMine => l.msgYpotBodyMine(s(0), s(1), n(2), n(3)),
    MsgKey.msgYpotBodyOther => l.msgYpotBodyOther(s(0), s(1), n(2), n(3)),
    MsgKey.msgRankTitle => l.msgRankTitle(n(0)),
    MsgKey.msgRankBody => l.msgRankBody(s(0), s(1)),
    MsgKey.msgRankLeadYou => l.msgRankLeadYou,
    MsgKey.msgRankLeadOther => l.msgRankLeadOther(s(0)),
    MsgKey.msgRankHold1 => l.msgRankHold1(n(0)),
    MsgKey.msgRankHold2 => l.msgRankHold2(n(0)),
    MsgKey.msgRankHold3 => l.msgRankHold3(n(0)),
    MsgKey.msgRankUp1 => l.msgRankUp1(n(0), n(1)),
    MsgKey.msgRankUp2 => l.msgRankUp2(n(0), n(1)),
    MsgKey.msgRankUp3 => l.msgRankUp3(n(0), n(1)),
    MsgKey.msgRankDown1 => l.msgRankDown1(n(0), n(1)),
    MsgKey.msgRankDown2 => l.msgRankDown2(n(0), n(1)),
    MsgKey.msgRankDown3 => l.msgRankDown3(n(0), n(1)),
    MsgKey.msgRankJumpTitleUp => l.msgRankJumpTitleUp(n(0)),
    MsgKey.msgRankJumpTitleDown => l.msgRankJumpTitleDown(n(0)),
    MsgKey.msgRankJumpBodyUp => l.msgRankJumpBodyUp(
      s(0),
      s(1),
      n(2),
      n(3),
      n(4),
    ),
    MsgKey.msgRankJumpBodyDown => l.msgRankJumpBodyDown(
      s(0),
      s(1),
      n(2),
      n(3),
      n(4),
    ),
    MsgKey.msgCapsTitle => l.msgCapsTitle(s(0), n(1)),
    MsgKey.msgCapsBody => l.msgCapsBody(s(0), n(1)),
    MsgKey.msgGoalsTitle => l.msgGoalsTitle(s(0), n(1)),
    MsgKey.msgGoalsBody => l.msgGoalsBody(s(0), n(1)),
    MsgKey.msgDevTitle => l.msgDevTitle(n(0)),
    MsgKey.msgThroughTitle => l.msgThroughTitle(n(0)),
    MsgKey.msgThroughNote => l.msgThroughNote,
    MsgKey.msgIntakeTitle => l.msgIntakeTitle(n(0)),
    MsgKey.msgIntakeNoteBoth => l.msgIntakeNoteBoth,
    MsgKey.msgIntakeNoteStanding => l.msgIntakeNoteStanding,
    MsgKey.msgIntakeNoteAcademy => l.msgIntakeNoteAcademy,
    MsgKey.msgRetireTitle => l.msgRetireTitle(s(0)),
    MsgKey.msgRetireCaptainTitle => l.msgRetireCaptainTitle(s(0)),
    MsgKey.msgRetireBody => l.msgRetireBody(s(0), n(1)),
    MsgKey.msgRetireBodyWith => l.msgRetireBodyWith(s(0), s(1), n(2)),
    MsgKey.msgTallyCaps => l.msgTallyCaps(n(0)),
    MsgKey.msgTallyGoals => l.msgTallyGoals(n(0)),
    MsgKey.msgArmbandVacant => l.msgArmbandVacant,
    MsgKey.msgHofTitle => l.msgHofTitle(s(0)),
    MsgKey.msgHofBody => l.msgHofBody(s(0), n(1), n(2)),
    MsgKey.msgANation => l.msgANation,
    MsgKey.msgAPlayer => l.msgAPlayer,
    MsgKey.msgAHostNation => l.msgAHostNation,
    MsgKey.newsRecordScorerTitle => l.newsRecordScorerTitle,
    MsgKey.newsRecordScorerBody => l.newsRecordScorerBody(s(0), n(1)),
    MsgKey.newsRecordCapsTitle => l.newsRecordCapsTitle,
    MsgKey.newsRecordCapsBody => l.newsRecordCapsBody(s(0), n(1)),
    MsgKey.newsARecordBreaker => l.newsARecordBreaker,
    MsgKey.newsTransferWindowTitle => l.newsTransferWindowTitle(n(0)),
    MsgKey.newsNatzTitle => l.newsNatzTitle(s(0), s(1)),
    MsgKey.newsNatzStarTitle => l.newsNatzStarTitle(s(0), s(1)),
    MsgKey.newsNatzBody => l.newsNatzBody(s(0), s(1), s(2), s(3), n(4), n(5)),
    MsgKey.newsNatzBodyStar => l.newsNatzBodyStar(
      s(0),
      s(1),
      s(2),
      s(3),
      n(4),
      n(5),
    ),
    MsgKey.newsTheirNation => l.newsTheirNation,
    MsgKey.newsYourNation => l.newsYourNation,
    MsgKey.newsWcMissTitle => l.newsWcMissTitle,
    MsgKey.newsWcMissBody => l.newsWcMissBody(n(0)),
    MsgKey.newsContMissTitle => l.newsContMissTitle(s(0)),
    MsgKey.newsContMissBody => l.newsContMissBody(s(0)),
    MsgKey.newsWalkoutTitle => l.newsWalkoutTitle(s(0)),
    MsgKey.newsWalkoutBody => l.newsWalkoutBody(s(0), n(1), n(2)),
    MsgKey.newsPotyTitle => l.newsPotyTitle(n(0)),
    MsgKey.newsPotyBody => l.newsPotyBody(s(0)),
    MsgKey.newsPotyYoungSuffix => l.newsPotyYoungSuffix(s(0)),
    MsgKey.newsWatchTitle => l.newsWatchTitle(n(0)),
    MsgKey.newsWatchJump => l.newsWatchJump(s(0), n(1), n(2)),
    MsgKey.newsWatchBand => l.newsWatchBand(s(0), s(1)),
    MsgKey.newsWatchDebutTitle => l.newsWatchDebutTitle(s(0)),
    MsgKey.newsWatchDebutBody => l.newsWatchDebutBody(s(0), n(1), n(2)),
    MsgKey.federationNaturalisedTitle => l.federationNaturalisedTitle(s(0)),
    MsgKey.federationNaturalisedBody => l.federationNaturalisedBody(s(0), s(1)),
    MsgKey.hubBanTitle => l.hubBanTitle(s(0)),
    MsgKey.hubBanBody => l.hubBanBody(s(0), s(1), n(2)),
    MsgKey.hubBanHowSecondYellow => l.hubBanHowSecondYellow,
    MsgKey.hubBanHowViolent => l.hubBanHowViolent,
    MsgKey.hubBanHowRed => l.hubBanHowRed,
    MsgKey.hubInjuryTitle => l.hubInjuryTitle(s(0)),
    MsgKey.hubInjuryBody => l.hubInjuryBody(s(0), n(1)),
    MsgKey.hubRunnerUpTitle1 => l.hubRunnerUpTitle1,
    MsgKey.hubRunnerUpTitle2 => l.hubRunnerUpTitle2,
    MsgKey.hubRunnerUpTitle3 => l.hubRunnerUpTitle3,
    MsgKey.hubRunnerUpBody1 => l.hubRunnerUpBody1(s(0), s(1)),
    MsgKey.hubRunnerUpBody2 => l.hubRunnerUpBody2(s(0), s(1)),
    MsgKey.hubRunnerUpBody3 => l.hubRunnerUpBody3(s(0), s(1)),
    MsgKey.hubKnockedOutTitle1 => l.hubKnockedOutTitle1,
    MsgKey.hubKnockedOutTitle2 => l.hubKnockedOutTitle2,
    MsgKey.hubKnockedOutTitle3 => l.hubKnockedOutTitle3,
    MsgKey.hubKnockedOutBody1 => l.hubKnockedOutBody1(s(0), s(1), s(2)),
    MsgKey.hubKnockedOutBody2 => l.hubKnockedOutBody2(s(0), s(1), s(2)),
    MsgKey.hubKnockedOutBody3 => l.hubKnockedOutBody3(s(0), s(1), s(2)),
    MsgKey.hubGroupExitTitle1 => l.hubGroupExitTitle1,
    MsgKey.hubGroupExitTitle2 => l.hubGroupExitTitle2,
    MsgKey.hubGroupExitTitle3 => l.hubGroupExitTitle3,
    MsgKey.hubGroupExitBody1 => l.hubGroupExitBody1(s(0)),
    MsgKey.hubGroupExitBody2 => l.hubGroupExitBody2(s(0)),
    MsgKey.hubGroupExitBody3 => l.hubGroupExitBody3(s(0)),
    MsgKey.hubStageRoundOf32 => l.hubStageRoundOf32,
    MsgKey.hubStageThirdPlace => l.hubStageThirdPlace,
    MsgKey.hubFinal => l.hubFinal,
    MsgKey.boardObjectiveMetTitle => l.boardObjectiveMetTitle(s(0)),
    MsgKey.boardObjectiveMissedTitle => l.boardObjectiveMissedTitle(s(0)),
    MsgKey.boardObjectiveMetBody => l.boardObjectiveMetBody(s(0), s(1), s(2)),
    MsgKey.boardObjectiveMissedBody => l.boardObjectiveMissedBody(
      s(0),
      s(1),
      s(2),
    ),
    MsgKey.objectiveNcWinIt => l.objectiveNcWinIt,
    MsgKey.objectiveNcReachFinal => l.objectiveNcReachFinal,
    MsgKey.objectiveNcFinalsFour => l.objectiveNcFinalsFour,
    MsgKey.objectiveNcWinGroup => l.objectiveNcWinGroup,
    MsgKey.objectiveNcTopHalf => l.objectiveNcTopHalf,
    MsgKey.objectiveNcSurvive => l.objectiveNcSurvive,
    MsgKey.objectiveWinTournament => l.objectiveWinTournament,
    MsgKey.objectiveReachFinal => l.objectiveReachFinal,
    MsgKey.objectiveReachSemis => l.objectiveReachSemis,
    MsgKey.objectiveReachQuarters => l.objectiveReachQuarters,
    MsgKey.objectiveReachKnockouts => l.objectiveReachKnockouts,
    MsgKey.objectiveQualifyGeneric => l.objectiveQualifyGeneric,
    MsgKey.objectiveQualifyingTopHalf => l.objectiveQualifyingTopHalf,
    MsgKey.finishNcChampions => l.finishNcChampions,
    MsgKey.finishNcFinalsFour => l.finishNcFinalsFour,
    MsgKey.finishNcGroupWinners => l.finishNcGroupWinners,
    MsgKey.finishNcTopHalf => l.finishNcTopHalf,
    MsgKey.finishNcStayedUp => l.finishNcStayedUp,
    MsgKey.finishNcBottom => l.finishNcBottom,
    MsgKey.finishChampions => l.finishChampions,
    MsgKey.finishRunnersUp => l.finishRunnersUp,
    MsgKey.finishSemiFinals => l.finishSemiFinals,
    MsgKey.finishQuarterFinals => l.finishQuarterFinals,
    MsgKey.finishRoundOf16 => l.finishRoundOf16,
    MsgKey.finishGroupStage => l.finishGroupStage,
    MsgKey.finishQualifyingTopHalf => l.finishQualifyingTopHalf,
    MsgKey.finishQualifyingBottomHalf => l.finishQualifyingBottomHalf,
    MsgKey.boardVerdictSackedTitle => l.boardVerdictSackedTitle,
    MsgKey.boardVerdictSackedBody => l.boardVerdictSackedBody(n(0)),
    MsgKey.boardVerdictDelightedTitle => l.boardVerdictDelightedTitle,
    MsgKey.boardVerdictDelightedBody => l.boardVerdictDelightedBody(n(0), s(1)),
    MsgKey.boardVerdictSolidTitle => l.boardVerdictSolidTitle,
    MsgKey.boardVerdictSolidBody => l.boardVerdictSolidBody(n(0)),
    MsgKey.boardVerdictExpectedMoreTitle => l.boardVerdictExpectedMoreTitle,
    MsgKey.boardVerdictExpectedMoreBody => l.boardVerdictExpectedMoreBody(n(0)),
    MsgKey.boardVerdictPressureTitle => l.boardVerdictPressureTitle,
    MsgKey.boardVerdictPressureBody => l.boardVerdictPressureBody(n(0)),
    MsgKey.boardVerdictHeroTitle => l.boardVerdictHeroTitle,
    MsgKey.boardVerdictHeroNote => l.boardVerdictHeroNote(s(0), n(1)),
    MsgKey.boardVerdictTheNation => l.boardVerdictTheNation,
    MsgKey.boardVerdictBestQuiet => l.boardVerdictBestQuiet,
    MsgKey.boardVerdictBestCycle => l.boardVerdictBestCycle,
    MsgKey.boardVerdictBestWorld => l.boardVerdictBestWorld(s(0)),
    MsgKey.finishThirdPlace => l.finishThirdPlace,
    MsgKey.finishFourthPlace => l.finishFourthPlace,
    MsgKey.finishDidNotQualify => l.finishDidNotQualify,
  };
}

/// One piece of a stored message: a string with its arguments, a competition's
/// name, or a run of pieces one after another.
sealed class MsgPart {
  const MsgPart();
}

/// A string from the ARB, with the arguments it takes.
///
/// An argument is a `String` (a name, already in nobody's language), an `int`,
/// or another [MsgPart] — a nested phrase, which is how the copy that reads a
/// fragment into a sentence ("{name} {how} and is banned for …") survives being
/// stored.
final class MsgText extends MsgPart {
  const MsgText(this.key, [this.args = const <Object?>[]]);

  /// Which string.
  final MsgKey key;

  /// Its arguments, in the order the generated method takes them.
  final List<Object?> args;
}

/// A competition's CANONICAL STORED name, written for the manager when it is
/// read — the same [competitionLabel] every screen goes through.
final class MsgComp extends MsgPart {
  const MsgComp(this.stored);

  /// The English name the save holds ('World Championship', 'Nations Cup').
  final String stored;
}

/// Several pieces one after another.
///
/// The copy this stores was written as concatenation: a suffix that opens with
/// a space (" on penalties, after a 2-1 final"), a tally joined with a comma.
/// Joining the PIECES keeps that shape without anybody having to build a
/// sentence out of the reader's language at writing time.
final class MsgJoin extends MsgPart {
  const MsgJoin(this.parts, {this.separator = ''});

  /// The pieces, in order.
  final List<Object?> parts;

  /// What goes between them.
  final String separator;
}

/// A piece in lower case — a stage name read into the middle of a sentence
/// ("out in the quarter-finals").
final class MsgLower extends MsgPart {
  const MsgLower(this.part);

  /// The piece to lower-case once it has been written.
  final MsgPart part;
}

/// The words for [part], in the language of [l].
String renderMsgPart(AppLocalizations l, MsgPart part) => switch (part) {
  MsgText() => renderMsgKey(l, part),
  MsgComp() => competitionLabel(l, part.stored),
  MsgJoin() => [
    for (final p in part.parts) _renderArg(l, p),
  ].join(part.separator),
  MsgLower() => renderMsgPart(l, part.part).toLowerCase(),
};

/// An argument as text: a nested piece is rendered, anything else printed.
String _renderArg(AppLocalizations l, Object? arg) =>
    arg is MsgPart ? renderMsgPart(l, arg) : '$arg';

/// The stage a knockout round is, as a stored key — the `stageLabelFor` ladder
/// with the words left out, so a message can carry the stage and be read in
/// whatever language the manager comes back in.
MsgKey stageMsgKey(String round) => switch (round) {
  'R32' => MsgKey.hubStageRoundOf32,
  'R16' || 'CR16' => MsgKey.finishRoundOf16,
  'QF' || 'CQF' => MsgKey.finishQuarterFinals,
  'SF' || 'CSF' || 'NSF' => MsgKey.finishSemiFinals,
  '3RD' || 'C3RD' => MsgKey.hubStageThirdPlace,
  'FINAL' || 'CFINAL' || 'NFINAL' => MsgKey.hubFinal,
  _ => MsgKey.finishGroupStage,
};

/// A stored placement ('Champions', 'Round of 16') as a key.
///
/// The career summary records how far a nation went in canonical English, the
/// way competition names are stored, and the board's verdict quotes it. Null
/// for anything this ladder has not been taught, which the caller passes
/// through as it came rather than blanking it.
MsgKey? placementMsgKey(String stored) => switch (stored.trim()) {
  'Champions' => MsgKey.finishChampions,
  'Runners-up' => MsgKey.finishRunnersUp,
  'Third place' => MsgKey.finishThirdPlace,
  'Fourth place' => MsgKey.finishFourthPlace,
  'Semi-finals' => MsgKey.finishSemiFinals,
  'Quarter-finals' => MsgKey.finishQuarterFinals,
  'Round of 16' => MsgKey.finishRoundOf16,
  'Round of 32' => MsgKey.hubStageRoundOf32,
  'Group stage' => MsgKey.finishGroupStage,
  'Did not qualify' => MsgKey.finishDidNotQualify,
  _ => null,
};

/// What a message means, as it is stored: the title, the body (absent when the
/// body is an encoded report the sheet lays out itself) and the note above such
/// a report.
typedef MessageSpec = ({MsgPart title, MsgPart? body, MsgPart? note});

/// The spec as it goes into `Messages.spec`.
String encodeMessageSpec({
  required MsgPart title,
  MsgPart? body,
  MsgPart? note,
}) => jsonEncode({
  't': _encodePart(title),
  if (body != null) 'b': _encodePart(body),
  if (note != null) 'n': _encodePart(note),
});

/// The spec a message carries, or null when it carries none — a message filed
/// before the column existed, or one whose spec this build cannot read (a key
/// that has since been removed). Either way the caller falls back to the words
/// the message was written in, which is what it always showed.
MessageSpec? decodeMessageSpec(String? source) {
  if (source == null || source.isEmpty) return null;
  try {
    final json = jsonDecode(source);
    if (json is! Map<String, Object?>) return null;
    final title = _decodePart(json['t']);
    if (title == null) return null;
    return (
      title: title,
      body: _decodePart(json['b']),
      note: _decodePart(json['n']),
    );
  } on Object {
    // Unreadable rather than absent, but a manager reading his inbox is owed
    // the sentence, not an exception.
    return null;
  }
}

Object? _encodeArg(Object? arg) => arg is MsgPart ? _encodePart(arg) : arg;

Map<String, Object?> _encodePart(MsgPart part) => switch (part) {
  MsgText() => {
    'k': part.key.name,
    if (part.args.isNotEmpty) 'a': [for (final a in part.args) _encodeArg(a)],
  },
  MsgComp() => {'c': part.stored},
  MsgJoin() => {
    'j': [for (final p in part.parts) _encodeArg(p)],
    if (part.separator.isNotEmpty) 's': part.separator,
  },
  MsgLower() => {'w': _encodePart(part.part)},
};

Object? _decodeArg(Object? json) =>
    json is Map<String, Object?> ? _decodePart(json) : json;

MsgPart? _decodePart(Object? json) {
  if (json is! Map<String, Object?>) return null;
  if (json['k'] case final String name) {
    final key = MsgKey.values.asNameMap()[name];
    if (key == null) return null;
    final args = json['a'];
    return MsgText(key, [
      if (args is List)
        for (final a in args) _decodeArg(a),
    ]);
  }
  if (json['c'] case final String stored) return MsgComp(stored);
  if (json['j'] case final List<Object?> parts) {
    return MsgJoin([
      for (final p in parts) _decodeArg(p),
    ], separator: json['s'] as String? ?? '');
  }
  if (json['w'] case final Map<String, Object?> inner) {
    final part = _decodePart(inner);
    return part == null ? null : MsgLower(part);
  }
  return null;
}

/// One inbox message, in the language the manager is reading in.
///
/// A message's stored `title` / `body` are the words it was written in, and are
/// used only when it carries no spec. The returned `note` is the line above an
/// encoded report, when one is stored as meaning rather than inside the report
/// itself.
({String title, String body, String? note}) readMessage(
  AppLocalizations l,
  MessageItem message,
) {
  final spec = decodeMessageSpec(message.spec);
  if (spec == null) {
    return (title: message.title, body: message.body, note: null);
  }
  return (
    title: renderMsgPart(l, spec.title),
    // No body in the spec means the stored body is an encoded report (a squad
    // development table, a transfer window, the year's awards) — structure, not
    // a sentence, and the sheet decodes it itself.
    body: spec.body == null ? message.body : renderMsgPart(l, spec.body!),
    note: spec.note == null ? null : renderMsgPart(l, spec.note!),
  );
}

/// Files a message whose words are stored as MEANING.
///
/// The rendered columns are written too, in the language being read now, so a
/// reader that has never heard of a spec (and any message this build cannot
/// resolve) still has the sentence. `rawBody` is for a body that is an encoded
/// report: it is stored as it comes and no body spec is written, so the sheet
/// decodes the report exactly as it always did.
extension MessageFiling on CompetitionRepository {
  /// Adds a message to the inbox, storing the words AND the meaning.
  Future<void> addTextMessage({
    required AppLocalizations l,
    required int careerId,
    required String dedupKey,
    required String category,
    required MsgPart title,
    required int year,
    MsgPart? body,
    String? rawBody,
    MsgPart? note,
  }) {
    assert(
      body == null || rawBody == null,
      'a message body is either meaning or an encoded report, not both',
    );
    return addMessage(
      careerId: careerId,
      dedupKey: dedupKey,
      category: category,
      title: renderMsgPart(l, title),
      body: rawBody ?? (body == null ? '' : renderMsgPart(l, body)),
      year: year,
      spec: encodeMessageSpec(title: title, body: body, note: note),
    );
  }
}
