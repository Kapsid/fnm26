import 'dart:math' as math;

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/world_managers/manager_decisions.dart';

/// What one lab run measured.
typedef LabStats = ({
  /// Manager-years observed in the run (ongoing spells included) over the
  /// spells that ended in it: the censoring-free mean, `1 / yearly share`.
  double meanTenureYears,

  /// The same manager-years over every spell observed, ended or not.
  double yearsPerObservedSpell,
  double yearlyChangeShare,
  double postFinalsShare,
  double maxPointShare,

  /// The most nations, as a share, that changed in one World Championship
  /// year (its point and the rollover after it), worst cycle.
  double maxWcYearShare,
  int changes,
  int completedSpells,
});

/// A synthetic world of [nations] AI nations (ranked 1..n), run with no
/// database through [cycles] four-year cycles. Each nation sees two finals
/// decision points a cycle, its continental finals (one point per
/// confederation, as the season hooks them) and the World Championship
/// (one point for the world), then the rollover. Windows are noise:
/// briefNet ~ N(0, 1.2) rounded, surpriseSum ~ N(0, 1.5).
LabStats runManagerLab({
  required int seed,
  int cycles = 5,
  int nations = 209,
  int freePool = 60,
}) {
  final rng = SeededRng(varietySeed('lab:$seed'));
  double normal(double sd) {
    final u1 = math.max(rng.nextDouble(), 1e-12);
    final u2 = rng.nextDouble();
    return sd * math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2);
  }

  final start = DateTime(2026, 8, 20);
  final rankById = {for (var n = 1; n <= nations; n++) n: n};
  final managers = <WorldManager>[];
  final spells = <ManagerSpell>[];
  var nextId = 1;
  WorldManager newManager(DateTime asOf, int minAge, int maxAge) {
    final m = WorldManager(
      managerId: nextId++,
      name: 'M$nextId',
      nationality: 'N${rng.rangeInt(1, nations)}',
      birthYear: asOf.year - rng.rangeInt(minAge, maxAge),
      style: 'balanced',
      origin: ManagerOrigin.fresh,
      enteredAt: asOf,
    );
    managers.add(m);
    return m;
  }

  for (var n = 1; n <= nations; n++) {
    final m = newManager(start, 38, 66);
    final from = start.subtract(Duration(days: rng.nextInt(6 * 365 + 1)));
    final years = rng.rangeInt(2, 6);
    var until = DateTime(from.year + years, from.month, from.day);
    final floor = DateTime(start.year + 1, start.month, start.day);
    if (until.isBefore(floor)) until = floor;
    spells.add(
      ManagerSpell(
        spellNo: spells.length + 1,
        managerId: m.managerId,
        nationId: n,
        fromDate: from,
        contractUntil: until,
      ),
    );
  }
  for (var i = 0; i < freePool; i++) {
    newManager(start, 38, 66);
  }

  var world = ManagerWorld(managers: managers, spells: spells);
  final metOn = <int, DateTime>{};
  final all = rankById.keys.toSet();
  // The six confederations, sized as the real world (the last one takes the
  // rest), dealt from a shuffle so each holds strong and weak nations.
  const sizes = [55, 54, 46, 35, 10];
  // How many of each confederation reach its finals (the last: 8 of 9).
  const finalsSlots = [24, 24, 24, 16, 10, 8];
  final dealt = rng.shuffled(all.toList());
  final confeds = <Set<int>>[];
  var at = 0;
  for (final n in sizes) {
    confeds.add(dealt.sublist(at, math.min(at + n, dealt.length)).toSet());
    at = math.min(at + n, dealt.length);
  }
  confeds.add(dealt.sublist(at).toSet());
  var changes = 0;
  var finalsChanges = 0;
  var maxShare = 0.0;
  var maxWcYear = 0.0;
  final wcYear = <int>{};

  void step(
    DateTime date,
    String key, {
    required bool rollover,
    Set<int>? scope,
    int finalists = 0,
  }) {
    final inScope = scope ?? all;
    final windows = <int, NationWindow>{};
    if (!rollover) {
      // The best-ranked [finalists] of the scope played the finals, so only
      // they settle a finals brief; the rest settle a qualifying brief.
      final atFinals = ([...inScope]..sort()).take(finalists).toSet();
      for (final n in inScope) {
        final b = normal(1.2).round();
        windows[n] = (
          briefNet: b,
          surpriseSum: normal(1.5),
          settledFinalsBriefMet: atFinals.contains(n) && b >= 0,
          anyBriefSettled: true,
        );
      }
    }
    final entrants = <WorldManager>[];
    if (rollover) {
      final free = world.free(date).length;
      for (var i = free; i < freePool; i++) {
        entrants.add(
          WorldManager(
            managerId: world.nextManagerId + entrants.length,
            name: 'E$i',
            nationality: 'N${rng.rangeInt(1, nations)}',
            birthYear: date.year - rng.rangeInt(38, 52),
            style: 'balanced',
            origin: ManagerOrigin.fresh,
            enteredAt: date,
          ),
        );
      }
    }
    final c = ManagerDecisions.decide(
      world,
      windows,
      (
        date: date,
        rankById: rankById,
        scope: inScope,
        playerNationIds: const <int>{},
        rngSeed: seed,
        key: key,
        rollover: rollover,
      ),
      entrants: entrants,
      finalsBriefMetOn: metOn,
    );
    for (final e in windows.entries) {
      if (e.value.settledFinalsBriefMet) metOn[e.key] = date;
    }
    world = applyManagerChanges(world, c);
    if (key.startsWith('wc:') || key.startsWith('roll:')) {
      wcYear.addAll(c.moves.map((m) => m.nationId));
    }
    final n = c.moves.length;
    changes += n;
    if (!rollover) finalsChanges += n;
    maxShare = math.max(maxShare, n / nations);
  }

  for (var cy = 0; cy < cycles; cy++) {
    final y = start.year + 4 * cy;
    // Each continental finals settles on its own, as Task 7 hooks them.
    for (var c = 0; c < confeds.length; c++) {
      step(
        DateTime(y + 2, 7, 15),
        'cont:$c:$cy',
        rollover: false,
        scope: confeds[c],
        finalists: finalsSlots[c],
      );
    }
    step(DateTime(y + 4, 7, 19), 'wc:$cy', rollover: false, finalists: 48);
    step(DateTime(y + 4, 8, 20), 'roll:$cy', rollover: true);
    maxWcYear = math.max(maxWcYear, wcYear.length / nations);
    wcYear.clear();
  }

  // Every spell's time in post inside the run, ongoing spells included.
  final end = DateTime(start.year + 4 * cycles, 8, 20);
  var exposure = 0.0;
  var observed = 0;
  var ended = 0;
  for (final s in world.spells) {
    final from = s.fromDate.isBefore(start) ? start : s.fromDate;
    final to = s.toDate ?? end;
    if (to.isBefore(from)) continue;
    observed++;
    if (s.toDate != null) ended++;
    exposure += to.difference(from).inDays / 365.25;
  }
  return (
    meanTenureYears: ended == 0 ? 0 : exposure / ended,
    yearsPerObservedSpell: observed == 0 ? 0 : exposure / observed,
    yearlyChangeShare: changes / (nations * cycles * 4),
    postFinalsShare: changes == 0 ? 0 : finalsChanges / changes,
    maxPointShare: maxShare,
    maxWcYearShare: maxWcYear,
    changes: changes,
    completedSpells: ended,
  );
}

/// [w] with [c] applied, as the repository would store it.
ManagerWorld applyManagerChanges(ManagerWorld w, ManagerChanges c) {
  final updated = {for (final m in c.updated) m.managerId: m};
  final replaced = {
    for (final s in [...c.closed, ...c.renewed]) s.spellNo: s,
  };
  return ManagerWorld(
    managers: [
      for (final m in w.managers) updated[m.managerId] ?? m,
      ...c.added,
    ],
    spells: [
      for (final s in w.spells) replaced[s.spellNo] ?? s,
      ...c.opened,
    ],
  );
}
