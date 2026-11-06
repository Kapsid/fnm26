/// The Pitch view's live commentary: one short line for each real moment,
/// and nothing for the routine ones that flow on.
///
/// Every (moment type, outcome) pair has several wordings; which one a
/// moment gets is fixed by the match seed and the moment itself, so a
/// re-watched or re-simulated minute reads the same.
library;

import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The commentary line for [m], or null when [m] is routine and gets none.
///
/// Routine, as the pacer has it (it gives them no screen time): a routine
/// restart (a short free kick, a throw-in, a goal kick), a foul with no card
/// outside the box (advantage played or not), and an offside that ends
/// nothing. A foul in the box is never routine: it gives a penalty. Every
/// shot, sub, corner, dangerous free kick, long throw and card has a line,
/// including a shot the pacer folds into the set piece it came from.
///
/// [names] maps a player id to the name the match screen shows; every
/// player a moment names must be in it (asserted in debug). [events] is
/// always the match's own `MatchResult.events`: a foul's card points into it
/// (to tell a yellow, a second yellow and a red apart), and a card it cannot
/// resolve reads as a yellow, as the pacer times it. [score] is the score
/// after this goal, home first, counted from the events up to and including
/// the shot's `goalEventIndex`; given for every goal (penalties and set
/// pieces included), the goal's line carries it.
///
/// The wording is variant `(seed ^ m.seq ^ m.minute ^ m.stoppage) % n` of
/// the `n` that can be written: a variant naming the keeper or a second
/// player is left out when the moment has none.
String? pitchLine(
  AppLocalizations l,
  MatchMoment m,
  Map<int, String> names,
  int seed, {
  required List<MatchEvent> events,
  ({int home, int away})? score,
}) {
  if (isRoutineMoment(m)) return null;
  String name(int? id) {
    if (id == null) return l.pitchComSomeone;
    assert(names.containsKey(id), 'no name for player $id');
    return names[id] ?? l.pitchComSomeone;
  }

  String? pick(List<String> ok) => ok.isEmpty
      ? null
      : ok[(seed ^ m.seq ^ m.minute ^ m.stoppage) % ok.length];

  switch (m) {
    case final ShotMoment s:
      final p = name(s.shooterId);
      final k = s.keeperId == null ? null : name(s.keeperId);
      final o = s.assistId == null ? null : name(s.assistId);
      final line = pick(_shotVariants(l, s, p, k, o))!;
      if (s.outcome != ShotOutcome.goal || score == null) return line;
      return l.pitchComGoalScore(line, score.home, score.away);
    case final SetPieceMoment sp:
      final p = name(sp.takerId);
      return pick(switch (sp.kind) {
        SetPieceKind.corner => [
          l.pitchComCorner1(p),
          l.pitchComCorner2(p),
          l.pitchComCorner3(p),
        ],
        SetPieceKind.freeKick => [
          l.pitchComFreeKick1(p),
          l.pitchComFreeKick2(p),
          l.pitchComFreeKick3(p),
        ],
        SetPieceKind.longThrow => [
          l.pitchComLongThrow1(p),
          l.pitchComLongThrow2(p),
          l.pitchComLongThrow3(p),
        ],
        SetPieceKind.throwIn || SetPieceKind.goalKick => const [],
      });
    case final FoulMoment f:
      final card = _card(f, events);
      if (_inBox(f.zone)) {
        // The fouled man, then the fouler.
        final p = name(f.fouledId);
        final o = name(f.foulerId);
        return pick(switch (card) {
          null => [
            l.pitchComPenaltyAwarded1(p),
            l.pitchComPenaltyAwarded2(p, o),
            l.pitchComPenaltyAwarded3(p, o),
          ],
          _Card.yellow => [
            l.pitchComPenaltyAwardedYellow1(p, o),
            l.pitchComPenaltyAwardedYellow2(p, o),
            l.pitchComPenaltyAwardedYellow3(p, o),
          ],
          _Card.secondYellow => [
            l.pitchComPenaltyAwardedSecondYellow1(p, o),
            l.pitchComPenaltyAwardedSecondYellow2(p, o),
            l.pitchComPenaltyAwardedSecondYellow3(p, o),
          ],
          _Card.red => [
            l.pitchComPenaltyAwardedRed1(p, o),
            l.pitchComPenaltyAwardedRed2(p, o),
            l.pitchComPenaltyAwardedRed3(p, o),
          ],
        });
      }
      // The carded man, then the man he fouled.
      final p = name(f.foulerId);
      final o = name(f.fouledId);
      return pick(switch (card) {
        null => const [],
        _Card.yellow => [
          l.pitchComFoulYellow1(p),
          l.pitchComFoulYellow2(p, o),
          l.pitchComFoulYellow3(p, o),
        ],
        _Card.secondYellow => [
          l.pitchComFoulSecondYellow1(p),
          l.pitchComFoulSecondYellow2(p),
          l.pitchComFoulSecondYellow3(p),
        ],
        _Card.red => [
          l.pitchComFoulRed1(p),
          l.pitchComFoulRed2(p, o),
          l.pitchComFoulRed3(p),
        ],
      });
    case final OffsideMoment o:
      final p = name(o.playerId);
      return pick([
        l.pitchComOffside1(p),
        l.pitchComOffside2(p),
        l.pitchComOffside3(p),
      ]);
    case final SubMoment sub:
      final p = name(sub.onId);
      if (sub.offId == null) {
        return pick([
          l.pitchComSubFill1(p),
          l.pitchComSubFill2(p),
          l.pitchComSubFill3(p),
        ]);
      }
      final o = name(sub.offId);
      return pick([
        l.pitchComSub1(p, o),
        l.pitchComSub2(p, o),
        l.pitchComSub3(p, o),
      ]);
  }
}

/// The commentary line for an injury [e] (a staged window of its own, with
/// no moment behind it): variant
/// `(seed ^ e.minute ^ e.stoppage ^ e.playerId) % 3`. The injured man must
/// be in [names] (asserted in debug).
String pitchInjuryLine(
  AppLocalizations l,
  MatchEvent e,
  Map<int, String> names,
  int seed,
) {
  assert(names.containsKey(e.playerId), 'no name for player ${e.playerId}');
  final p = names[e.playerId] ?? l.pitchComSomeone;
  final variants = [
    l.pitchComInjury1(p),
    l.pitchComInjury2(p),
    l.pitchComInjury3(p),
  ];
  return variants[(seed ^ e.minute ^ e.stoppage ^ e.playerId) %
      variants.length];
}

/// Whether [m] flows on with no commentary line (see [pitchLine]).
bool isRoutineMoment(MatchMoment m) => switch (m) {
  ShotMoment _ || SubMoment _ => false,
  final SetPieceMoment p =>
    p.routine ||
        p.kind == SetPieceKind.throwIn ||
        p.kind == SetPieceKind.goalKick,
  final FoulMoment f => f.cardEventIndex == null && !_inBox(f.zone),
  final OffsideMoment o => !o.endsAttack,
};

bool _inBox(PitchZone z) =>
    z == PitchZone.boxCentre ||
    z == PitchZone.boxLeft ||
    z == PitchZone.boxRight ||
    z == PitchZone.sixYard;

enum _Card { yellow, secondYellow, red }

_Card? _card(FoulMoment f, List<MatchEvent> events) {
  final i = f.cardEventIndex;
  if (i == null) return null;
  if (i < 0 || i >= events.length) return _Card.yellow;
  final e = events[i];
  if (e.type != MatchEventType.redCard) return _Card.yellow;
  return e.secondYellow ? _Card.secondYellow : _Card.red;
}

/// A shot's wordings, by where it came from and how it ended. [k] (the
/// keeper) and [o] (the man who delivered it) are null when the shot has
/// none; the variants that name them are then left out.
List<String> _shotVariants(
  AppLocalizations l,
  ShotMoment s,
  String p,
  String? k,
  String? o,
) {
  switch (s.origin) {
    case ShotOrigin.penalty:
      return switch (s.outcome) {
        ShotOutcome.goal => [
          l.pitchComPenaltyGoal1(p),
          l.pitchComPenaltyGoal2(p),
          l.pitchComPenaltyGoal3(p),
        ],
        // A penalty the engine calls blocked can only have been stopped by
        // the keeper.
        ShotOutcome.saved || ShotOutcome.blocked => [
          if (k != null) l.pitchComPenaltySaved1(p, k),
          l.pitchComPenaltySaved2(p),
          if (k != null) l.pitchComPenaltySaved3(p, k),
        ],
        ShotOutcome.wide => [
          l.pitchComPenaltyMissed1(p),
          l.pitchComPenaltyMissed2(p),
          l.pitchComPenaltyMissed3(p),
        ],
        ShotOutcome.woodwork => [
          l.pitchComPenaltyWoodwork1(p),
          l.pitchComPenaltyWoodwork2(p),
          l.pitchComPenaltyWoodwork3(p),
        ],
      };
    case ShotOrigin.directFreeKick:
      return switch (s.outcome) {
        ShotOutcome.goal => [
          l.pitchComDirectFreeKickGoal1(p),
          l.pitchComDirectFreeKickGoal2(p),
          l.pitchComDirectFreeKickGoal3(p),
        ],
        ShotOutcome.saved => [
          if (k != null) l.pitchComDirectFreeKickSaved1(p, k),
          l.pitchComDirectFreeKickSaved2(p),
          if (k != null) l.pitchComDirectFreeKickSaved3(p, k),
        ],
        ShotOutcome.wide => [
          l.pitchComDirectFreeKickWide1(p),
          l.pitchComDirectFreeKickWide2(p),
          l.pitchComDirectFreeKickWide3(p),
        ],
        ShotOutcome.blocked => [
          l.pitchComDirectFreeKickBlocked1(p),
          l.pitchComDirectFreeKickBlocked2(p),
          l.pitchComDirectFreeKickBlocked3(p),
        ],
        ShotOutcome.woodwork => [
          l.pitchComDirectFreeKickWoodwork1(p),
          l.pitchComDirectFreeKickWoodwork2(p),
          l.pitchComDirectFreeKickWoodwork3(p),
        ],
      };
    case ShotOrigin.corner || ShotOrigin.freeKickCross || ShotOrigin.longThrow:
      return switch (s.outcome) {
        ShotOutcome.goal => [
          l.pitchComSetPieceGoal1(p),
          if (o != null) l.pitchComSetPieceGoal2(p, o),
          l.pitchComSetPieceGoal3(p),
        ],
        ShotOutcome.saved => [
          if (k != null) l.pitchComSetPieceSaved1(p, k),
          l.pitchComSetPieceSaved2(p),
          if (k != null) l.pitchComSetPieceSaved3(p, k),
        ],
        ShotOutcome.wide => [
          l.pitchComSetPieceWide1(p),
          l.pitchComSetPieceWide2(p),
          l.pitchComSetPieceWide3(p),
        ],
        ShotOutcome.blocked => [
          l.pitchComSetPieceBlocked1(p),
          l.pitchComSetPieceBlocked2(p),
          l.pitchComSetPieceBlocked3(p),
        ],
        ShotOutcome.woodwork => [
          l.pitchComSetPieceWoodwork1(p),
          l.pitchComSetPieceWoodwork2(p),
          l.pitchComSetPieceWoodwork3(p),
        ],
      };
    case ShotOrigin.openPlay when s.header:
      return switch (s.outcome) {
        ShotOutcome.goal => [
          l.pitchComHeaderGoal1(p),
          l.pitchComHeaderGoal2(p),
          l.pitchComHeaderGoal3(p),
        ],
        ShotOutcome.saved => [
          if (k != null) l.pitchComHeaderSaved1(p, k),
          l.pitchComHeaderSaved2(p),
          if (k != null) l.pitchComHeaderSaved3(p, k),
        ],
        ShotOutcome.wide => [
          l.pitchComHeaderWide1(p),
          l.pitchComHeaderWide2(p),
          l.pitchComHeaderWide3(p),
        ],
        ShotOutcome.blocked => [
          l.pitchComHeaderBlocked1(p),
          l.pitchComHeaderBlocked2(p),
          l.pitchComHeaderBlocked3(p),
        ],
        ShotOutcome.woodwork => [
          l.pitchComHeaderWoodwork1(p),
          l.pitchComHeaderWoodwork2(p),
          l.pitchComHeaderWoodwork3(p),
        ],
      };
    case ShotOrigin.openPlay:
      return switch (s.outcome) {
        ShotOutcome.goal => [
          l.pitchComShotGoal1(p),
          l.pitchComShotGoal2(p),
          l.pitchComShotGoal3(p),
        ],
        ShotOutcome.saved => [
          if (k != null) l.pitchComShotSaved1(p, k),
          l.pitchComShotSaved2(p),
          if (k != null) l.pitchComShotSaved3(p, k),
        ],
        ShotOutcome.wide => [
          l.pitchComShotWide1(p),
          l.pitchComShotWide2(p),
          l.pitchComShotWide3(p),
        ],
        ShotOutcome.blocked => [
          l.pitchComShotBlocked1(p),
          l.pitchComShotBlocked2(p),
          l.pitchComShotBlocked3(p),
        ],
        ShotOutcome.woodwork => [
          l.pitchComShotWoodwork1(p),
          l.pitchComShotWoodwork2(p),
          l.pitchComShotWoodwork3(p),
        ],
      };
  }
}
