import 'dart:math' as math;

import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/competition/rounds.dart';

/// How the player regards a world manager.
enum TieLabel {
  neutral,
  respect,
  rival,
  grudge,
  successor,
  protege,
  formerPlayer,
}

/// The player's standing with one manager, derived on read.
typedef ManagerRelation = ({
  int warmth,
  TieLabel label,
  int meetings,
  int won,
  int drawn,
  int lost,
});

const ManagerRelation _none = (
  warmth: 0,
  label: TieLabel.neutral,
  meetings: 0,
  won: 0,
  drawn: 0,
  lost: 0,
);

const double _daysPerYear = 365.25;

/// A rivalry lapses after two cycles (eight years) without a meeting.
const int _rivalYears = 8;

TieLabel? _structural(TieKind k) => switch (k) {
  TieKind.grudge => TieLabel.grudge,
  TieKind.successor => TieLabel.successor,
  TieKind.protege => TieLabel.protege,
  TieKind.formerPlayer => TieLabel.formerPlayer,
  TieKind.pressDig || TieKind.pressRespect => null,
};

/// The player's relation with one manager, from his [spells], the player's
/// competitive [meetings] with those nations and his [ties]. [playerSideAt]
/// names the nation(s) the player managed on a date.
ManagerRelation readRelation({
  required List<ManagerSpell> spells,
  required List<Fixture> meetings,
  required Set<int> Function(DateTime d) playerSideAt,
  required List<ManagerTie> ties,
  required DateTime today,
}) {
  // (date, delta, isKnockoutElimination, order) events.
  final events = <({DateTime date, int delta, bool ko, int order})>[];
  var won = 0;
  var drawn = 0;
  var lost = 0;
  var met = 0;
  DateTime? lastKo;
  var koCount = 0;

  bool underHim(int nationId, DateTime d) => spells.any(
    (s) =>
        s.nationId == nationId &&
        !d.isBefore(s.fromDate) &&
        (s.toDate == null || d.isBefore(s.toDate!)),
  );

  for (final f in meetings) {
    if (!f.hasResult || f.round == Rounds.friendly) continue;
    final side = playerSideAt(f.date);
    final bool mineHome;
    if (side.contains(f.homeNationId) && underHim(f.awayNationId, f.date)) {
      mineHome = true;
    } else if (side.contains(f.awayNationId) &&
        underHim(f.homeNationId, f.date)) {
      mineHome = false;
    } else {
      continue;
    }
    final mine = (mineHome ? f.homeScore : f.awayScore)!;
    final theirs = (mineHome ? f.awayScore : f.homeScore)!;
    // A shootout is stored with the winner one goal up, but a level score
    // with penalties is read by the penalties too.
    final myPens = mineHome ? f.homePenalties : f.awayPenalties;
    final theirPens = mineHome ? f.awayPenalties : f.homePenalties;
    final decided =
        mine != theirs ||
        (myPens != null && theirPens != null && myPens != theirPens);
    met++;
    if (mine > theirs) {
      won++;
    } else if (mine == theirs) {
      drawn++;
    } else {
      lost++;
    }
    final ko =
        Rounds.isKnockout(f.round) &&
        !(f.round?.endsWith('3RD') ?? false) &&
        decided;
    var delta = 0;
    if (ko) {
      delta = -10;
      koCount++;
      if (lastKo == null || f.date.isAfter(lastKo)) lastKo = f.date;
    } else if (mine - theirs >= 3) {
      delta = -5;
    }
    events.add((date: f.date, delta: delta, ko: ko, order: 0));
  }
  for (final t in ties) {
    events.add((date: t.date, delta: t.delta, ko: false, order: 1));
  }
  if (events.isEmpty) return _none;

  events.sort((a, b) {
    final c = a.date.compareTo(b.date);
    return c != 0 ? c : a.order.compareTo(b.order);
  });

  double decay(DateTime from, DateTime to) {
    final days = to.difference(from).inDays;
    if (days <= 0) return 1;
    return math.pow(0.75, days / _daysPerYear).toDouble();
  }

  var warmth = 0.0;
  var last = events.first.date;
  for (final e in events) {
    warmth = (warmth * decay(last, e.date) + e.delta).clamp(-100.0, 100.0);
    if (e.date.isAfter(last)) last = e.date;
  }
  warmth = (warmth * decay(last, today)).clamp(-100.0, 100.0);
  final rounded = warmth.round();

  ManagerTie? latest;
  for (final t in ties) {
    if (_structural(t.kind) == null) continue;
    if (latest == null ||
        t.date.isAfter(latest.date) ||
        (t.date.isAtSameMomentAs(latest.date) && t.tieNo > latest.tieNo)) {
      latest = t;
    }
  }
  final structural = latest == null ? null : _structural(latest.kind);
  final TieLabel label;
  if (structural != null) {
    label = structural;
  } else if (koCount >= 2 &&
      lastKo != null &&
      today.difference(lastKo).inDays <= _rivalYears * _daysPerYear) {
    label = TieLabel.rival;
  } else if (rounded >= 30) {
    label = TieLabel.respect;
  } else {
    label = TieLabel.neutral;
  }
  return (
    warmth: rounded,
    label: label,
    meetings: met,
    won: won,
    drawn: drawn,
    lost: lost,
  );
}
