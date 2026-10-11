import 'package:flutter/widgets.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:go_router/go_router.dart';

/// What Android's system back does on a screen with nothing beneath it.
///
/// Almost every move in the app is a `context.go`, which replaces the stack,
/// so the router usually has nothing to pop and the platform default closed
/// the app from anywhere. Each screen's AppBar arrow already names where it
/// leads; this is the same map, held in one place for the system button.
@immutable
sealed class BackAction {
  const BackAction();
}

/// Let the platform close the app (the home screen).
final class ExitApp extends BackAction {
  const ExitApp();
}

/// Swallow the press: an event screen the manager leaves by finishing it,
/// which shows no back arrow either.
final class StayPut extends BackAction {
  const StayPut();
}

/// Go to [location], the screen the AppBar arrow leads to.
final class GoBackTo extends BackAction {
  const GoBackTo(this.location);
  final String location;

  @override
  bool operator ==(Object other) =>
      other is GoBackTo && other.location == location;

  @override
  int get hashCode => location.hashCode;

  @override
  String toString() => 'GoBackTo($location)';
}

/// Event screens with no way out but through.
const Set<String> _stayPut = {
  Routes.match,
  Routes.roundResults,
  Routes.trainingCamp,
  Routes.naturalization,
  Routes.hostDraw,
  Routes.intercontinentalPlayoff,
  Routes.finalsDraw,
  Routes.qualifyingDraw,
  Routes.continentalDraw,
  Routes.nationsCupDraw,
  Routes.cycleRollover,
  Routes.tournamentKickoff,
};

/// In-save screens and the screen their AppBar arrow leads to. Anything not
/// listed falls back to the hub.
const Map<String, String> _inSaveParents = {
  Routes.managerHistory: Routes.careers,
  Routes.achievements: Routes.careers,
  Routes.challenges: Routes.careers,
  Routes.ranking: Routes.tournaments,
  Routes.cup: Routes.tournaments,
  Routes.continental: Routes.tournaments,
  Routes.continentalClash: Routes.tournaments,
  Routes.nationsCup: Routes.tournaments,
  Routes.nationVitrine: Routes.ranking,
  Routes.allTimeRecords: Routes.records,
  Routes.headToHead: Routes.records,
  Routes.h2hMeetings: Routes.headToHead,
};

/// Screens outside a save and where they lead back to.
const Map<String, String> _outOfSaveParents = {
  Routes.nations: Routes.home,
  Routes.saves: Routes.home,
  Routes.settings: Routes.home,
  Routes.gallery: Routes.home,
  Routes.diagnostics: Routes.settings,
  Routes.newGame: Routes.nations,
  Routes.startFromBottom: Routes.nations,
};

/// Where system back goes from [uri] when the navigator has nothing to pop.
BackAction systemBackAction(Uri uri) {
  final path = uri.path.isEmpty ? Routes.home : uri.path;
  if (path == Routes.home) return const ExitApp();
  if (_stayPut.contains(path)) return const StayPut();

  final careerId = uri.queryParameters['careerId'];
  if (careerId == null) {
    return GoBackTo(_outOfSaveParents[path] ?? Routes.home);
  }
  // The hub's own arrow leaves the save for the home screen.
  if (path == Routes.hub) return const GoBackTo(Routes.home);

  final String parent;
  if (path == Routes.callUps) {
    // Same split as the call-up screen's own exit: an event goes back to the
    // hub, a visit from the squad screen goes back there.
    parent = uri.queryParameters['event'] != null ? Routes.hub : Routes.tactics;
  } else {
    parent = _inSaveParents[path] ?? Routes.hub;
  }
  return GoBackTo('$parent?careerId=$careerId');
}

/// Gives Android's back button somewhere to go.
///
/// A child dispatcher hears the press ahead of the router: an open dialog, a
/// pushed screen or a [PopScope] still get it first, and only when nothing
/// would pop does [systemBackAction] pick the screen the AppBar arrow leads
/// to. The root dispatcher has no callback until the router has built, so
/// [attach] takes priority after the first frame.
class SystemBackHandler {
  SystemBackHandler(this._router);

  final GoRouter _router;
  ChildBackButtonDispatcher? _dispatcher;

  void attach() {
    if (_dispatcher != null) return;
    final dispatcher =
        _router.backButtonDispatcher.createChildBackButtonDispatcher()
          ..addCallback(_onBack);
    _dispatcher = dispatcher;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (identical(_dispatcher, dispatcher)) dispatcher.takePriority();
    });
  }

  /// Dropping the last callback also detaches it from the root dispatcher.
  void dispose() {
    _dispatcher?.removeCallback(_onBack);
    _dispatcher = null;
  }

  Future<bool> _onBack() async {
    final navigator = _router.routerDelegate.navigatorKey.currentState;
    if (navigator != null && await navigator.maybePop()) return true;
    switch (systemBackAction(_router.routerDelegate.currentConfiguration.uri)) {
      case ExitApp():
        return false;
      case StayPut():
        return true;
      case GoBackTo(:final location):
        _router.go(location);
        return true;
    }
  }
}
