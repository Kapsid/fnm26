import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Writing positions, roles and squad morale in the manager's own language.
///
/// The same arrangement as `competition_label.dart`, for the same reason: the
/// domain layer has no business importing [AppLocalizations], so an enum that
/// the manager reads is translated HERE, at the display edge, keyed off the
/// enum value itself. The enums used to carry an English `label` getter and
/// every screen printed it, which is why a Czech manager met "Buoyant",
/// "Poacher" and "Centre Back" in a Czech app.

/// A playing position written out in full (e.g. `Defensive Mid`).
///
/// [PlayerPosition.label] is the short code (`DM`) and needs no translating.
String positionName(AppLocalizations l, PlayerPosition p) => switch (p) {
  PlayerPosition.gk => l.positionGoalkeeper,
  PlayerPosition.lb => l.positionLeftBack,
  PlayerPosition.cb => l.positionCentreBack,
  PlayerPosition.rb => l.positionRightBack,
  PlayerPosition.dm => l.positionDefensiveMid,
  PlayerPosition.cm => l.positionCentralMid,
  PlayerPosition.am => l.positionAttackingMid,
  PlayerPosition.lm => l.positionLeftMid,
  PlayerPosition.rm => l.positionRightMid,
  PlayerPosition.lw => l.positionLeftWing,
  PlayerPosition.rw => l.positionRightWing,
  PlayerPosition.st => l.positionStriker,
};

/// A tactical role's short name, for the role picker and the pitch.
String playerRoleLabel(AppLocalizations l, PlayerRole r) => switch (r) {
  PlayerRole.none => l.roleNone,
  PlayerRole.targetMan => l.roleTargetMan,
  PlayerRole.poacher => l.rolePoacher,
  PlayerRole.playmaker => l.rolePlaymaker,
  PlayerRole.ballWinner => l.roleBallWinner,
  PlayerRole.invertedWinger => l.roleInvertedWinger,
  PlayerRole.ballPlayingDefender => l.roleBallPlayingDefender,
};

/// One line on what a tactical role does, under its name in the picker.
String playerRoleBlurb(AppLocalizations l, PlayerRole r) => switch (r) {
  PlayerRole.none => l.roleNoneBlurb,
  PlayerRole.targetMan => l.roleTargetManBlurb,
  PlayerRole.poacher => l.rolePoacherBlurb,
  PlayerRole.playmaker => l.rolePlaymakerBlurb,
  PlayerRole.ballWinner => l.roleBallWinnerBlurb,
  PlayerRole.invertedWinger => l.roleInvertedWingerBlurb,
  PlayerRole.ballPlayingDefender => l.roleBallPlayingDefenderBlurb,
};

/// A morale value (0–100) as the one word the hub badge shows.
///
/// The bands come from `Condition.moraleLabel`, which used to return the
/// English word itself; the numbers are the game's, the words are the copy's.
String moraleLabel(AppLocalizations l, int morale) => morale >= 78
    ? l.moraleBuoyant
    : morale >= 60
    ? l.moralePositive
    : morale >= 42
    ? l.moraleSettled
    : morale >= 25
    ? l.moraleUneasy
    : l.moraleRockBottom;
