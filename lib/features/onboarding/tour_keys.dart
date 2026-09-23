import 'package:flutter/widgets.dart';

/// The things the tour points AT.
///
/// A key per control rather than a key per screen: the tour's job is to say
/// "this button, here, is the one that moves the game on", and it cannot do
/// that without knowing where the button is.
///
/// Every one is optional at the far end. A step whose target is not on screen
/// — the screen scrolled elsewhere, the control not applicable to this save —
/// falls back to dimming the whole screen with the same caption, so a missing
/// key degrades to the old behaviour rather than to a crash.
abstract final class TourKeys {
  /// The hub's primary action: the one button the whole game runs through.
  static final hubAction = GlobalKey(debugLabel: 'tour.hubAction');

  /// The board's confidence and the objectives it has set.
  static final hubBoard = GlobalKey(debugLabel: 'tour.hubBoard');

  /// The staff the federation pays for, on the budget screen.
  static final budgetStaff = GlobalKey(debugLabel: 'tour.budgetStaff');

  /// The departments the rest of the money is split between.
  static final budgetDepartments = GlobalKey(
    debugLabel: 'tour.budgetDepartments',
  );

  /// The shape the side plays.
  static final tacticsFormation = GlobalKey(debugLabel: 'tour.tacticsFormation');

  /// Its way of playing.
  static final tacticsPlaystyle = GlobalKey(debugLabel: 'tour.tacticsPlaystyle');

  /// The tab that holds the whole pool.
  static final squadTab = GlobalKey(debugLabel: 'tour.squadTab');

  /// How many are named, and how many may be.
  static final callUpCount = GlobalKey(debugLabel: 'tour.callUpCount');

  /// The record of everything the manager has done.
  static final careerHistory = GlobalKey(debugLabel: 'tour.careerHistory');

  /// Where the rest of the world's competitions live.
  static final worldRanking = GlobalKey(debugLabel: 'tour.worldRanking');
}
