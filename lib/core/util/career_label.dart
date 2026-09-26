import 'package:fnm/domain/services/competition/cycle_finish.dart';
import 'package:fnm/domain/services/manager/job_market.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Writing a manager's own career in his own language.
///
/// The same arrangement as `squad_label.dart` and `federation_label.dart`, for
/// the same reason. These four were the last English the sweeps could not
/// reach: they were not in `lib/domain` at all but in `lib/features`, decided
/// by a provider and printed by the widget next door, so the guard that cleared
/// the domain never saw them and a Czech manager still met "Iconic", "Step up",
/// "Semi-finals" and "Did not qualify" on the two screens that sum up his
/// career.

/// How far a nation got, as the career history and the results list print it.
///
/// [CycleFinish.roundOf32] borrows the hub's wording: the same round, already
/// written in both languages once.
String cycleFinishLabel(AppLocalizations l, CycleFinish f) => switch (f) {
  CycleFinish.champions => l.finishChampions,
  CycleFinish.runnersUp => l.finishRunnersUp,
  CycleFinish.thirdPlace => l.finishThirdPlace,
  CycleFinish.fourthPlace => l.finishFourthPlace,
  CycleFinish.semiFinals => l.finishSemiFinals,
  CycleFinish.quarterFinals => l.finishQuarterFinals,
  CycleFinish.roundOf16 => l.finishRoundOf16,
  CycleFinish.roundOf32 => l.hubStageRoundOf32,
  CycleFinish.groupStage => l.finishGroupStage,
  CycleFinish.didNotQualify => l.finishDidNotQualify,
};

/// A nation's Nations Cup cycle in one phrase: which league it played in, and
/// either the Finals Four it reached or where it came in its group.
///
/// One string rather than two, because Czech puts the league after the word for
/// league and English does not, and a screen joining fragments with a middle
/// dot cannot know that.
String nationsCupFinishLabel(
  AppLocalizations l, {
  required String league,
  required int position,
  NationsCupFinish? finals,
}) => switch (finals) {
  NationsCupFinish.champions => l.careerNationsCupWon(league),
  NationsCupFinish.runnersUp => l.careerNationsCupRunnerUp(league),
  NationsCupFinish.semiFinalist => l.careerNationsCupSemi(league),
  null => l.careerNationsCupPlaced(league, position),
};

/// What an offer between cycles would be, on the tile that carries it.
String offerTierLabel(AppLocalizations l, OfferTier t) => switch (t) {
  OfferTier.stepUp => l.hubOfferStepUp,
  OfferTier.lateral => l.hubOfferLateral,
  OfferTier.rebuild => l.hubOfferRebuild,
};

/// A career-long standing (0-100) as the one word the rollover screen shows.
///
/// The bands are the job market's own, unchanged; only the words moved. Written
/// as a ladder rather than a switch on an enum because the number is what the
/// market reads and the word is only ever printed — see `moraleLabel`, which is
/// the same shape for the same reason.
String reputationLabel(AppLocalizations l, int reputation) => reputation >= 85
    ? l.careerRepIconic
    : reputation >= 70
    ? l.careerRepRenowned
    : reputation >= 50
    ? l.careerRepEstablished
    : reputation >= 30
    ? l.careerRepRising
    : l.careerRepUnproven;
