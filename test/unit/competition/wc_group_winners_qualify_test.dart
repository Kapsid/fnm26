import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/qualification.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';

/// The Palestine report: an Asian side won its World Cup qualifying group, was
/// painted green, and did not go to the finals. Each World Cup host used to
/// replace the weakest-RANKED qualifier in the whole world, which was nearly
/// always some small confederation's group winner. A host's place now comes
/// out of its own confederation's allocation, and the qualifying tables cut
/// the same, shorter, ladder.
///
/// Every seed builds the real qualifying draw (hosts left out, as the career
/// does), plays it with strength-weighted results, and checks the finals field
/// against what the tables show, for every confederation.
void main() {
  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List<dynamic>)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList();
  final byId = {for (final n in nations) n.id: n};
  final rankById = {for (final n in nations) n.id: n.ranking};

  int goals(Random rng, double mean) {
    // Poisson by inversion.
    final l = exp(-mean);
    var k = 0;
    var p = 1.0;
    do {
      k++;
      p *= rng.nextDouble();
    } while (p > l);
    return k - 1;
  }

  /// One cycle's qualifying, played: confederation -> group tables.
  Map<Confederation, List<List<GroupStanding>>> playQualifying(
    int seed,
    List<int> hosts,
  ) {
    final rng = Random(seed);
    final out = <Confederation, List<List<GroupStanding>>>{};
    for (final c in Confederation.values) {
      final quals = [
        for (final n in nations)
          if (n.confederation == c && !hosts.contains(n.id)) n,
      ];
      final s = const ScheduleGenerator().generate(
        confederation: c,
        nations: quals,
        rngSeed: seed ^ (c.index * 0x9E37),
        rankById: rankById,
      );
      out[c] = [
        for (final g in s.groups)
          GroupStanding.table(g.nationIds, [
            for (final f in g.fixtures)
              () {
                final edge =
                    (rankById[f.awayNationId]! - rankById[f.homeNationId]!) /
                    60.0;
                return Fixture(
                  id: 0,
                  careerId: 0,
                  competitionId: 0,
                  matchday: f.matchday,
                  date: f.date,
                  homeNationId: f.homeNationId,
                  awayNationId: f.awayNationId,
                  homeScore: goals(rng, (1.3 + edge).clamp(0.2, 4)),
                  awayScore: goals(rng, (1.1 - edge).clamp(0.2, 4)),
                  played: true,
                );
              }(),
          ]),
      ];
    }
    return out;
  }

  test('every confederation: the field is exactly what the tables show', () {
    var asianHostCycles = 0;
    var cycles = 0;
    for (var seed = 1; seed <= 40; seed++) {
      for (var cycle = 0; cycle < 6; cycle++) {
        cycles++;
        final year = 2030 + cycle * 4;
        final hosts = WorldCupHosts.hostsFor(
          year: year,
          nations: nations,
          seed: seed,
        );
        final tables = playQualifying(seed * 7919 + cycle, hosts);
        final hostBerths = WorldCupFinals.hostBerths(
          hosts: hosts,
          confederationOf: (id) => byId[id]?.confederation,
          byConfederation: tables,
        );
        if ((hostBerths[Confederation.asia] ?? 0) > 0) asianHostCycles++;
        final finalists = WorldCupFinals.selectFinalists(
          byConfederation: tables,
          rankingById: rankById,
          hosts: hosts,
          hostBerths: hostBerths,
        );
        final pool = WorldCupFinals.playoffPoolFor(
          byConfederation: tables,
          rankingById: rankById,
          hostBerths: hostBerths,
        ).toSet();
        final where = 'seed $seed cycle $cycle hosts $hosts';

        expect(finalists, hasLength(48), reason: where);
        expect(finalists.toSet(), hasLength(48), reason: where);
        expect(finalists, containsAll(hosts), reason: where);

        for (final e in tables.entries) {
          final conf = e.key;
          final groups = e.value;
          final hostsHere = hostBerths[conf] ?? 0;
          final adv = GroupAdvancement.worldCupQualifying(
            conf,
            groups.length,
            hosts: hostsHere,
          );
          final shownPlayoff = GroupAdvancement.worldCupPlayoffNations(
            conf,
            groups,
            hosts: hostsHere,
          );
          final direct = Qualification.qualifiers(
            groups,
            QualificationFormat.forConfederation(
              conf,
            ).qualifyingBerths(hostsHere),
          ).toSet();
          // Green on the table means in the finals.
          for (final g in groups) {
            for (var pos = 0; pos < adv.direct && pos < g.length; pos++) {
              expect(
                finalists,
                contains(g[pos].nationId),
                reason:
                    '$where: ${byId[g[pos].nationId]!.name} finished '
                    '${pos + 1} in ${conf.name} and was shown qualified',
              );
            }
            // A group winner is never simply dropped: it qualifies, or the
            // table puts it in contention for a place or the play-off.
            final winner = g.first.nationId;
            expect(
              finalists.contains(winner) ||
                  pool.contains(winner) ||
                  adv.contention == 1,
              isTrue,
              reason:
                  '$where: ${byId[winner]!.name} won a ${conf.name} group '
                  'and went nowhere',
            );
          }
          // Yellow on the table is the play-off pool.
          expect(pool, containsAll(shownPlayoff), reason: where);
          // Everyone from this confederation in the field got there by the
          // shown ladder, the play-off or as host: nobody was bumped.
          for (final id in finalists) {
            if (byId[id]!.confederation != conf || hosts.contains(id)) {
              continue;
            }
            expect(
              direct.contains(id) || pool.contains(id),
              isTrue,
              reason: '$where: ${byId[id]!.name}',
            );
          }
          expect(
            finalists.where(direct.contains),
            hasLength(direct.length),
            reason: '$where: ${conf.name} lost a direct qualifier',
          );
        }

        // Asia without an Asian host: eight places, eight groups, every
        // winner through (the reported case).
        if ((hostBerths[Confederation.asia] ?? 0) == 0) {
          for (final g in tables[Confederation.asia]!) {
            expect(
              finalists,
              contains(g.first.nationId),
              reason: '$where: ${byId[g.first.nationId]!.name}',
            );
          }
        }
      }
    }
    // The run covered the case where Asia gives a place up, too.
    expect(cycles, 240);
    expect(asianHostCycles, greaterThan(0));
  });

  test('a host its confederation has no room for still makes the field', () {
    // Oceania has one place. Two Oceanian co-hosts: the first takes it, the
    // second falls back to replacing the weakest qualifier, so the field stays
    // 48.
    final oc = [
      for (final n in nations)
        if (n.confederation == Confederation.oceania) n.id,
    ];
    final hosts = [oc[0], oc[1]];
    final tables = playQualifying(99, hosts);
    final finalists = WorldCupFinals.selectFinalists(
      byConfederation: tables,
      rankingById: rankById,
      hosts: hosts,
      hostBerths: WorldCupFinals.hostBerths(
        hosts: hosts,
        confederationOf: (id) => byId[id]?.confederation,
        byConfederation: tables,
      ),
    );
    expect(finalists.toSet(), hasLength(48));
    expect(finalists, containsAll(hosts));
  });

  test('a cycle on the old rule (no host berths) is read unchanged', () {
    final hosts = WorldCupHosts.hostsFor(
      year: 2034,
      nations: nations,
      seed: 5,
    );
    final tables = playQualifying(5, hosts);
    final finalists = WorldCupFinals.selectFinalists(
      byConfederation: tables,
      rankingById: rankById,
      hosts: hosts,
      hostBerths: const {},
    );
    // The old cut: every confederation's full allocation, then hosts bump.
    expect(finalists.toSet(), hasLength(48));
    expect(finalists, containsAll(hosts));
  });
}
