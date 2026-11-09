import 'dart:math' as math;

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/world_managers/manager_decisions.dart';

/// What one lab run measured.
typedef LabStats = ({
  double meanTenureYears,
  double yearlyChangeShare,
  double postFinalsShare,
  double maxPointShare,
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

  void step(
    DateTime date,
    String key, {
    required bool rollover,
    Set<int>? scope,
  }) {
    final inScope = scope ?? all;
    final windows = <int, NationWindow>{};
    if (!rollover) {
      for (final n in inScope) {
        final b = normal(1.2).round();
        windows[n] = (
          briefNet: b,
          surpriseSum: normal(1.5),
          settledFinalsBriefMet: b >= 0,
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
      );
    }
    step(DateTime(y + 4, 7, 19), 'wc:$cy', rollover: false);
    step(DateTime(y + 4, 8, 20), 'roll:$cy', rollover: true);
  }

  final ended = [
    for (final s in world.spells)
      if (s.toDate case final to?) to.difference(s.fromDate).inDays / 365.25,
  ];
  return (
    meanTenureYears: ended.isEmpty
        ? 0
        : ended.reduce((a, b) => a + b) / ended.length,
    yearlyChangeShare: changes / (nations * cycles * 4),
    postFinalsShare: changes == 0 ? 0 : finalsChanges / changes,
    maxPointShare: maxShare,
    changes: changes,
    completedSpells: ended.length,
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
