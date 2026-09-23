import 'package:flutter/widgets.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// One stop on the guided tour: a screen, and what it is for.
typedef TourStep = ({
  /// The route the tour navigates to, without its query string.
  String route,

  /// The heading on the caption card.
  String Function(AppLocalizations) title,

  /// The sentence or two underneath it.
  String Function(AppLocalizations) body,

  /// The control this step is ABOUT, cut out of the scrim and lit.
  ///
  /// Null dims the whole screen instead. Nothing uses that any more — a step
  /// with nothing lit is a step that teaches nothing, which is what the first
  /// version of this was — but it stays as the fallback for a target that
  /// turns out not to be on screen.
  GlobalKey? target,
});

/// The tour, in the order the game itself asks for these things.
///
/// The live match is deliberately absent. It is the one screen a manager
/// reaches with something already at stake, and a scrim over it would be an
/// interruption rather than a lesson.
final List<TourStep> kTourSteps = [
  (
    route: Routes.hub,
    title: _hubTitle,
    body: _hubBody,
    target: TourKeys.hubAction,
  ),
  (
    route: Routes.hub,
    title: _boardTitle,
    body: _boardBody,
    target: TourKeys.hubBoard,
  ),
  (
    route: Routes.budgetSetup,
    title: _budgetTitle,
    body: _budgetBody,
    target: TourKeys.budgetDepartments,
  ),
  (
    route: Routes.budgetSetup,
    title: _staffTitle,
    body: _staffBody,
    target: TourKeys.budgetStaff,
  ),
  (
    route: Routes.tactics,
    title: _tacticsTitle,
    body: _tacticsBody,
    target: TourKeys.tacticsFormation,
  ),
  (
    route: Routes.tactics,
    title: _playstyleTitle,
    body: _playstyleBody,
    target: TourKeys.tacticsPlaystyle,
  ),
  (
    route: Routes.tactics,
    title: _squadTitle,
    body: _squadBody,
    target: TourKeys.squadTab,
  ),
  (
    route: Routes.callUps,
    title: _callUpsTitle,
    body: _callUpsBody,
    target: TourKeys.callUpCount,
  ),
  (
    route: Routes.careers,
    title: _recordsTitle,
    body: _recordsBody,
    target: TourKeys.careerHistory,
  ),
  (
    route: Routes.tournaments,
    title: _cupsTitle,
    body: _cupsBody,
    target: TourKeys.worldRanking,
  ),
];

// Top-level functions rather than closures so the list can stay const.
String _hubTitle(AppLocalizations l) => l.tourHubTitle;
String _hubBody(AppLocalizations l) => l.tourHubBody;
String _budgetTitle(AppLocalizations l) => l.tourBudgetTitle;
String _budgetBody(AppLocalizations l) => l.tourBudgetBody;
String _tacticsTitle(AppLocalizations l) => l.tourTacticsTitle;
String _tacticsBody(AppLocalizations l) => l.tourTacticsBody;
String _squadTitle(AppLocalizations l) => l.tourSquadTitle;
String _squadBody(AppLocalizations l) => l.tourSquadBody;
String _callUpsTitle(AppLocalizations l) => l.tourCallUpsTitle;
String _callUpsBody(AppLocalizations l) => l.tourCallUpsBody;
String _recordsTitle(AppLocalizations l) => l.tourRecordsTitle;
String _recordsBody(AppLocalizations l) => l.tourRecordsBody;
String _cupsTitle(AppLocalizations l) => l.tourCupsTitle;
String _cupsBody(AppLocalizations l) => l.tourCupsBody;
String _boardTitle(AppLocalizations l) => l.tourBoardTitle;
String _boardBody(AppLocalizations l) => l.tourBoardBody;
String _staffTitle(AppLocalizations l) => l.tourStaffTitle;
String _staffBody(AppLocalizations l) => l.tourStaffBody;
String _playstyleTitle(AppLocalizations l) => l.tourPlaystyleTitle;
String _playstyleBody(AppLocalizations l) => l.tourPlaystyleBody;
