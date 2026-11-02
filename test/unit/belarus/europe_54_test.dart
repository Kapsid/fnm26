import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';

/// Europe with Belarus has 54 nations. Every Europe-shaped draw takes them
/// cleanly, across many seeds and cycles: groups of a playable size, nobody
/// twice in a draw or twice on one day, and a Nations Cup ladder whose
/// leagues keep their sizes through promotion and relegation.
void main() {
  final base =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList()
        ..sort((a, b) => a.ranking.compareTo(b.ranking));
  final world = DormantNations.worldFrom(base, {
    DormantNations.belarusId,
  }, dormant: (_) => DormantNations.belarus);
  final europe = [
    for (final n in world)
      if (n.confederation == Confederation.europe) n,
  ];

  test('the world gains Belarus and nobody else', () {
    expect(world, hasLength(base.length + 1));
    expect(europe, hasLength(54));
    expect(europe.map((n) => n.id), contains(DormantNations.belarusId));
  });

  void expectSound(GeneratedSchedule s, int teams, int min, int max) {
    final seen = <int>{};
    for (final g in s.groups) {
      expect(g.nationIds.length, inInclusiveRange(min, max));
      for (final id in g.nationIds) {
        expect(seen.add(id), isTrue, reason: 'nation $id in two groups');
      }
      final booked = <(int, DateTime)>{};
      for (final f in g.fixtures) {
        expect(booked.add((f.homeNationId, f.date)), isTrue);
        expect(booked.add((f.awayNationId, f.date)), isTrue);
      }
    }
    expect(seen, hasLength(teams));
  }

  test('World Championship qualifying: 54, or 52-53 after hosts, in groups '
      'of four or five', () {
    final target = QualificationFormat.forConfederation(
      Confederation.europe,
    ).targetGroupSize;
    for (final drop in [0, 1, 2]) {
      final field = europe.skip(drop).toList();
      for (var seed = 1; seed <= 40; seed++) {
        final s = const ScheduleGenerator().generate(
          confederation: Confederation.europe,
          nations: field,
          rngSeed: seed,
          groupSize: target,
        );
        expect(s.groups, hasLength(11));
        expectSound(s, field.length, 4, 5);
      }
    }
  });

  test('continental qualifying: groups of five or six', () {
    for (final drop in [0, 1, 2]) {
      final field = europe.skip(drop).toList();
      for (var seed = 1; seed <= 40; seed++) {
        final s = const ScheduleGenerator().generate(
          confederation: Confederation.europe,
          nations: field,
          rngSeed: seed,
          groupSize: 6,
        );
        expectSound(s, field.length, 5, 6);
      }
    }
  });

  test('the Nations Cup ladder: 16, 16, 16 and 6, through ten cycles of '
      'promotion and relegation', () {
    var tiers = NationsCup.seedTiers(world, (n) => n.ranking);
    final confOf = {for (final n in world) n.id: n.confederation};
    Map<int, int> europeSizes(Map<int, int> t) {
      final out = <int, int>{};
      for (final n in europe) {
        out[t[n.id]!] = (out[t[n.id]!] ?? 0) + 1;
      }
      return out;
    }

    expect(europeSizes(tiers), {0: 16, 1: 16, 2: 16, 3: 6});
    final rng = Random(6);
    for (var cycle = 0; cycle < 10; cycle++) {
      final groups = <LadderGroup>[];
      for (final tier in europeSizes(tiers).keys.toList()..sort()) {
        final league = [
          for (final n in europe)
            if (tiers[n.id] == tier) n,
        ];
        final s = const ScheduleGenerator().generate(
          confederation: Confederation.europe,
          nations: league,
          rngSeed: cycle * 31 + tier,
          groupSize: 4,
        );
        expectSound(s, league.length, 3, 4);
        for (final g in s.groups) {
          final order = [...g.nationIds]..shuffle(rng);
          final rows = [
            for (var i = 0; i < order.length; i++)
              GroupStanding(order[i])..won = order.length - i,
          ];
          groups.add((tier: tier, winner: rows.first, bottom: rows.last));
        }
      }
      tiers = NationsCup.mergeRemainders(
        NationsCup.promoteRelegate(tiers: tiers, groups: groups),
        (id) => confOf[id],
      );
      expect(europeSizes(tiers), {
        0: 16,
        1: 16,
        2: 16,
        3: 6,
      }, reason: 'cycle $cycle');
    }
  });
}
