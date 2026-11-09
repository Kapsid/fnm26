import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/real_history.dart';
import 'package:fnm/domain/services/competition/world_pedigree.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';

/// Who stands on the World Championship podium.
///
/// `world_variance_test` guards the champion; this guards the whole podium.
/// Measured on whole careers (`test/story/medalists_lab_test.dart`, 94
/// editions) before the finals knockout edge, the twelve traditional powers
/// took only 64-79% of the medals (real football since 1990: about 93%),
/// sides seeded below 20th took about 11% (real: about 4%), and a top-eight
/// side that went out before the quarter-finals did so again next time at
/// the same high base rate: nothing carried a giant's standing from one
/// finals to the next.
///
/// The cheap stand-in: the real start-of-save strengths of the top 32 seeds,
/// a drawn 32-team knockout (as the finals' R32 onward), a third-place match,
/// and the pedigree carried from edition to edition through a chain of cycles
/// that starts from the real roll of honour, exactly as the background path
/// reads it.
void main() {
  const sim = RatingMatchSimulator();
  const powers = {
    'Spain', 'Argentina', 'France', 'England', 'Brazil', 'Portugal', //
    'Belgium', 'Netherlands', 'Germany', 'Croatia', 'Italy', 'Uruguay',
  };

  /// The top 32 seeds: (name, start background strength), in seed order.
  const field = <(String, int)>[
    ('Spain', 87),
    ('Argentina', 87),
    ('France', 88),
    ('England', 86),
    ('Brazil', 87),
    ('Morocco', 84),
    ('Portugal', 87),
    ('Belgium', 85),
    ('Netherlands', 85),
    ('Mexico', 83),
    ('Colombia', 83),
    ('Germany', 85),
    ('Croatia', 83),
    ('Switzerland', 81),
    ('Italy', 85),
    ('United States', 81),
    ('Japan', 82),
    ('Senegal', 82),
    ('Norway', 79),
    ('Uruguay', 83),
    ('Denmark', 82),
    ('Iran', 82),
    ('Austria', 81),
    ('Egypt', 80),
    ('Ecuador', 75),
    ('Nigeria', 79),
    ('Türkiye', 78),
    ('Australia', 82),
    ('Algeria', 79),
    ('Canada', 79),
    ('Ivory Coast', 80),
    ('South Korea', 81),
  ];

  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List)
          .cast<Map<String, Object?>>();
  final idByName = <String, int>{
    for (final n in nations)
      ((n['englishName'] as String?)?.isNotEmpty ?? false
              ? n['englishName']! as String
              : n['name']! as String):
          n['id']! as int,
  };
  int? resolve(String? name) => name == null
      ? null
      : idByName[name] ?? idByName[RealHistory.aliases[name] ?? name];
  final realHonours = <Honour>[
    for (final e in RealHistory.editions)
      if (e.competition == RealHistory.worldChampionship &&
          resolve(e.champion) != null &&
          resolve(e.runnerUp) != null)
        _honour(
          e.year,
          resolve(e.champion)!,
          resolve(e.runnerUp)!,
          resolve(e.third),
        ),
  ];
  final ids = [for (final (name, _) in field) idByName[name]!];
  final strengthOf = {
    for (final (name, s) in field) idByName[name]!: s,
  };
  final nameOf = {for (final (name, _) in field) idByName[name]!: name};
  final seedOf = {for (var i = 0; i < ids.length; i++) ids[i]: i + 1};

  /// One knockout tie as the background path plays it; returns the winner.
  int tie(int a, int b, SeededRng rng, Map<int, double>? pedigree) {
    final edge = pedigree == null
        ? 0.0
        : RatingMatchSimulator.finalsKnockoutEdge(
            homeStrength: strengthOf[a]!,
            awayStrength: strengthOf[b]!,
            homePedigree: pedigree[a] ?? 0,
            awayPedigree: pedigree[b] ?? 0,
          );
    final r = sim.simulate(
      homeStrength: strengthOf[a]!,
      awayStrength: strengthOf[b]!,
      rng: rng,
      homeAdvantage: false,
      strengthEdge: edge,
    );
    if (r.homeScore != r.awayScore) return r.homeScore > r.awayScore ? a : b;
    final ko = WorldCupFinals.decideKnockout(
      r.homeScore,
      r.awayScore,
      rng,
      homeStrength: RatingMatchSimulator.knockoutWeight(strengthOf[a]! + edge),
      awayStrength: RatingMatchSimulator.knockoutWeight(strengthOf[b]!),
    );
    return ko.homeWon ? a : b;
  }

  /// Plays [chains] saves of [cycles] finals each and tallies the podiums.
  /// [withEdge] off plays the finals as they were before the edge.
  _Tally play({required bool withEdge, int chains = 250, int cycles = 8}) {
    final t = _Tally();
    for (var c = 0; c < chains; c++) {
      final rng = SeededRng(7100 + c);
      final honours = [...realHonours];
      final earlyBefore = <int, bool>{};
      for (var cy = 0; cy < cycles; cy++) {
        final year = 2030 + 4 * cy;
        final pedigree = withEdge
            ? WorldPedigree.edges(
                honours: honours,
                year: year,
                idByEnglishName: idByName,
              )
            : null;
        // R32: each of the top 16 meets a drawn side from the bottom 16, and
        // the ties land on the bracket in drawn order.
        final top = rng.shuffled(ids.sublist(0, 16));
        final bottom = rng.shuffled(ids.sublist(16));
        var alive = <int>[
          for (var i = 0; i < 16; i++) tie(top[i], bottom[i], rng, pedigree),
        ];
        final reachedQf = <int>{};
        var beatenSemis = <int>[];
        var silver = -1;
        while (alive.length > 1) {
          if (alive.length == 8) reachedQf.addAll(alive);
          final next = <int>[];
          final losers = <int>[];
          for (var i = 0; i < alive.length; i += 2) {
            final w = tie(alive[i], alive[i + 1], rng, pedigree);
            next.add(w);
            losers.add(w == alive[i] ? alive[i + 1] : alive[i]);
          }
          if (alive.length == 4) beatenSemis = losers;
          if (alive.length == 2) silver = losers.single;
          alive = next;
        }
        final gold = alive.single;
        final third = tie(beatenSemis[0], beatenSemis[1], rng, pedigree);
        t.add(
          podium: [gold, silver, third],
          seedOf: seedOf,
          isPower: (id) => powers.contains(nameOf[id]),
        );
        honours.insert(0, _honour(year, gold, silver, third));
        for (final id in ids.take(8)) {
          final early = !reachedQf.contains(id);
          t.giantEditions++;
          if (early) t.giantEarly++;
          if (earlyBefore[id] ?? false) {
            t.afterEarly++;
            if (early) t.earlyAgain++;
          }
          earlyBefore[id] = early;
        }
      }
    }
    return t;
  }

  test('the traditional powers take the great majority of the medals', () {
    final before = play(withEdge: false);
    final after = play(withEdge: true);
    // Printed so both numbers are on the record, not just asserted.
    // ignore: avoid_print
    print('without the finals edge: $before\nwith it:                $after');

    expect(
      after.powerShare,
      greaterThanOrEqualTo(0.80),
      reason: 'the powers should take most of the medals',
    );
    expect(
      after.powerShare,
      lessThan(0.97),
      reason: 'but a surprise medallist must still happen',
    );
    expect(
      after.outsiderShare,
      lessThanOrEqualTo(0.06),
      reason: 'a side seeded below 20th medals rarely',
    );
    expect(after.outsiderShare, greaterThan(0), reason: 'but it can');
    // Within one world an early exit is still an independent event (a
    // giant's chance does not drop because it flopped last time), but the
    // pedigree it keeps makes the flop itself rarer: two in a row used to
    // happen at the old base rate and must now happen clearly less.
    expect(
      after.repeatRate,
      lessThan(before.earlyRate - 0.03),
      reason: 'a giant that went out early is less likely to again',
    );
    expect(
      after.powerShare,
      greaterThan(before.powerShare),
      reason: 'the edge is what concentrates the podium',
    );
  });
}

Honour _honour(int year, int gold, int silver, int? third) => (
  year: year,
  competition: RealHistory.worldChampionship,
  championId: gold,
  coChampionId: null,
  runnerUpId: silver,
  thirdId: third,
  thirdId2: null,
  hostId: null,
  hostIds: const <int>[],
  finalHomeScore: null,
  finalAwayScore: null,
  topScorerName: null,
  topScorerGoals: null,
);

class _Tally {
  int medals = 0;
  int powerMedals = 0;
  int outsiderMedals = 0;
  int giantEditions = 0;
  int giantEarly = 0;
  int afterEarly = 0;
  int earlyAgain = 0;

  void add({
    required List<int> podium,
    required Map<int, int> seedOf,
    required bool Function(int) isPower,
  }) {
    for (final id in podium) {
      medals++;
      if (isPower(id)) powerMedals++;
      if (seedOf[id]! > 20) outsiderMedals++;
    }
  }

  double get powerShare => powerMedals / medals;
  double get outsiderShare => outsiderMedals / medals;
  double get earlyRate => giantEarly / giantEditions;
  double get repeatRate => earlyAgain / afterEarly;

  @override
  String toString() =>
      'powers ${(powerShare * 100).toStringAsFixed(1)}% of medals, '
      'seeded >20th ${(outsiderShare * 100).toStringAsFixed(1)}%, '
      'top-8 out before the QF ${(earlyRate * 100).toStringAsFixed(1)}%, '
      'again after an early exit ${(repeatRate * 100).toStringAsFixed(1)}%';
}
