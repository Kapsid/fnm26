import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// One stop on the guided tour: a screen, and what it is for.
typedef TourStep = ({
  /// The route the tour navigates to, without its query string.
  String route,

  /// The heading on the caption card.
  String Function(AppLocalizations) title,

  /// The sentence or two underneath it.
  String Function(AppLocalizations) body,
});

/// The tour, in the order the game itself asks for these things.
///
/// The live match is deliberately absent. It is the one screen a manager
/// reaches with something already at stake, and a scrim over it would be an
/// interruption rather than a lesson.
const List<TourStep> kTourSteps = [
  (
    route: Routes.hub,
    title: _hubTitle,
    body: _hubBody,
  ),
  (
    route: Routes.budgetSetup,
    title: _budgetTitle,
    body: _budgetBody,
  ),
  (
    route: Routes.tactics,
    title: _tacticsTitle,
    body: _tacticsBody,
  ),
  (
    route: Routes.tactics,
    title: _squadTitle,
    body: _squadBody,
  ),
  (
    route: Routes.callUps,
    title: _callUpsTitle,
    body: _callUpsBody,
  ),
  (
    route: Routes.careers,
    title: _recordsTitle,
    body: _recordsBody,
  ),
  (
    route: Routes.tournaments,
    title: _cupsTitle,
    body: _cupsBody,
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
