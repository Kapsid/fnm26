import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/qualification.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';
import 'package:fnm/features/tournaments/wc_host_berths.dart';

import '../../helpers/test_database.dart';

const Set<HubEventKind> _ceremonies = {
  HubEventKind.budget,
  HubEventKind.managerSkills,
  HubEventKind.draw,
  HubEventKind.tournamentKickoff,
  HubEventKind.trainingCamp,
};

const List<String> _ceremonyKinds = [
  budgetSetupKind,
  skillsPromptKind,
  worldCupHostDrawKind,
  continentalHostDrawKind,
  worldCupQualDrawKind,
  continentalQualDrawKind,
  worldCupDrawKind,
  continentalFinalsDrawKind,
  nationsCupDrawKind,
  worldCupPlayoffKind,
  worldCupKickoffKind,
  continentalKickoffKind,
];

/// The El Salvador report: a nation won its intercontinental play-off tie on
/// the bracket, and was not in the World Championship finals.
///
/// Drives real careers through whole cycles and, the moment each finals is
/// drawn, checks the stored field against the play-off bracket the screen
/// shows and the qualifying ladder: direct qualifiers + hosts + play-off
/// winners, nothing missing and nothing extra. The managed nations are play-off
/// regulars, so the manager's own ties (played, not modelled) are covered too.
///
/// `WC_SWEEP=1` widens it to a few dozen careers.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List<dynamic>)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList();

  final sweep = Platform.environment['WC_SWEEP'] != null;
  const managedPool = [
    'El Salvador',
    'United Arab Emirates',
    'Cameroon',
    'New Zealand',
    'Solomon Islands',
    'Jamaica',
    'Peru',
    'Germany',
  ];
  final cases = <(String, int)>[
    ('Germany', 11),
    ('El Salvador', 7),
    ('United Arab Emirates', 99),
    ('New Zealand', 31337),
    if (sweep)
      for (var i = 0; i < 32; i++)
        (managedPool[i % managedPool.length], 1000 + i * 7919),
  ];
  const cycles = 2;

  for (final (managed, seed) in cases) {
    test(
      'managing $managed (seed $seed): every finals = direct + hosts + '
      'play-off winners',
      () async {
        final db = createTestDatabase();
        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            premiumUnlockedProvider.overrideWith((ref) => true),
            seedSourceProvider.overrideWithValue(
              InMemorySeedSource(nationList: nations, playerList: const []),
            ),
          ],
        );
        addTearDown(container.dispose);
        addTearDown(db.close);
        await container.read(seedLoaderProvider).ensureSeeded();

        final player = nations.firstWhere((n) => n.name == managed);
        final career =
            (await container
                    .read(careerServiceProvider)
                    .create(
                      nationId: player.id,
                      managerName: 'M',
                      rngSeed: seed,
                    ))
                .valueOrNull!;
        final season = container.read(seasonServiceProvider);
        final comp = container.read(competitionRepositoryProvider);

        var checked = 0;
        var checkedThisCycle = false;
        // Each tie the manager is not in, as the bracket showed it: slot ->
        // (home, away, winner). Playing his own tie must never move one.
        var shown = <int, (int, int, int)>{};
        var last = DateTime(1900);
        for (var i = 0; i < 8000 && checked < cycles; i++) {
          if (!checkedThisCycle && await comp.allQualifyingPlayed(career.id)) {
            container.invalidate(intercontinentalPlayoffProvider);
            final view = await container.read(
              intercontinentalPlayoffProvider(career.id).future,
            );
            if (view != null && !await comp.hasFinals(career.id)) {
              await _expectNothingBeforeSeeding(
                container,
                db,
                career.id,
                '$managed/$seed',
              );
            }
            for (final (slot, t) in (view?.ties ?? const []).indexed) {
              if (t.home == player.id || t.away == player.id) continue;
              final seen = shown[slot];
              if (seen != null && seen.$1 == t.home && seen.$2 == t.away) {
                expect(
                  t.winner,
                  seen.$3,
                  reason:
                      '$managed/$seed: play-off tie $slot changed winner '
                      'after the manager played',
                );
              }
              shown[slot] = (t.home, t.away, t.winner);
            }
          }
          if (!checkedThisCycle && await comp.hasFinals(career.id)) {
            await _checkField(container, career.id, '$managed/$seed');
            checkedThisCycle = true;
            checked++;
            if (checked >= cycles) break;
          }
          container
            ..invalidate(hubDataProvider)
            ..invalidate(nextEventProvider)
            ..invalidate(trainingCampPlanProvider);
          final hub = await container.read(hubDataProvider(career.id).future);
          if (hub == null) break;
          var event = await container.read(nextEventProvider(career.id).future);
          var guard = 0;
          while (_ceremonies.contains(event.kind) && guard++ < 60) {
            if (event.kind == HubEventKind.trainingCamp) {
              final plan = await container.read(
                trainingCampPlanProvider(career.id).future,
              );
              if (plan != null && plan.options.isNotEmpty) {
                await container
                    .read(trainingCampServiceProvider)
                    .choose(career.id, plan, plan.options.first);
              }
            } else {
              for (final kind in _ceremonyKinds) {
                await comp.markDrawWatched(
                  career.id,
                  hub.career.cyclePointer,
                  kind,
                );
              }
            }
            container
              ..invalidate(nextEventProvider)
              ..invalidate(trainingCampPlanProvider);
            event = await container.read(nextEventProvider(career.id).future);
          }
          if (event.kind == HubEventKind.cycleRollover) {
            await season.startNextCycle(career.id);
            checkedThisCycle = false;
            shown = {};
            last = DateTime(1900);
            continue;
          }
          await season.advance(career.id);
          container.invalidate(hubDataProvider);
          final now = await container.read(hubDataProvider(career.id).future);
          if (now == null) break;
          expect(
            now.career.inGameDate.isAfter(last),
            isTrue,
            reason: 'stalled on ${event.kind} / ${event.label}',
          );
          last = now.career.inGameDate;
        }
        expect(checked, cycles, reason: 'every cycle reached its finals');
      },
      timeout: const Timeout(Duration(minutes: 20)),
    );
  }
}

/// Between the world's last qualifier and the hub seeding the play-off, the
/// play-off has no seeding to replay. The screen used to draw a bracket on an
/// empty ranking anyway (every entrant alike, coin flips, the wrong order) and
/// show it as decided. Emulated here by lifting the seeding out for a moment
/// and putting the very same one back.
Future<void> _expectNothingBeforeSeeding(
  ProviderContainer container,
  AppDatabase db,
  int careerId,
  String label,
) async {
  final c = (await container.read(careerRepositoryProvider).byId(careerId))!;
  final slot = drawSeedCycle(c.cyclePointer, drawSlotWorldCupPlayoff);
  final repo = container.read(seedRankingRepositoryProvider);
  final frozen = await repo.forCycle(careerId, slot);
  await (db.delete(db.seedRankings)..where(
        (t) => t.careerId.equals(careerId) & t.cycle.equals(slot),
      ))
      .go();
  container
    ..invalidate(seedRankByIdProvider)
    ..invalidate(intercontinentalPlayoffProvider);
  final unseeded = await container.read(
    intercontinentalPlayoffProvider(careerId).future,
  );
  expect(unseeded, isNull, reason: '$label: no bracket before seeding');
  await repo.snapshot(careerId, slot, frozen);
  container
    ..invalidate(seedRankByIdProvider)
    ..invalidate(intercontinentalPlayoffProvider);
}

/// The stored finals field must be exactly the direct qualifiers, the hosts
/// and the two play-off winners the bracket shows.
Future<void> _checkField(
  ProviderContainer container,
  int careerId,
  String label,
) async {
  final comp = container.read(competitionRepositoryProvider);
  final c = (await container.read(careerRepositoryProvider).byId(careerId))!;
  final byId = {
    for (final n
        in await container.read(nationRepositoryProvider).forCareer(careerId))
      n.id: n,
  };
  String nm(int id) => byId[id]?.name ?? '#$id';

  final field = {
    for (final t in await comp.finalsGroupTables(careerId))
      for (final s in t.standings) s.nationId,
  };
  container.invalidate(intercontinentalPlayoffProvider);
  final view = await container.read(
    intercontinentalPlayoffProvider(careerId).future,
  );
  expect(view, isNotNull, reason: '$label: a six-team play-off was held');
  final winners = {
    for (final t in view!.ties)
      if (t.isFinal) t.winner,
  };
  final losers = {
    for (final t in view.ties) t.home == t.winner ? t.away : t.home,
  };

  final grouped = <Confederation, List<List<GroupStanding>>>{};
  for (final t in await comp.allGroupTablesByConfederation(careerId)) {
    (grouped[t.confederation] ??= []).add(t.standings);
  }
  final hostBerths = await resolveWorldCupHostBerths(
    comp: comp,
    seedRanks: container.read(seedRankingRepositoryProvider),
    career: c,
    nations: byId,
    byConfederation: grouped,
  );
  final hosts = WorldCupHosts.hostsFor(
    year: CareerService.worldCupYear(c.cyclePointer),
    nations: byId.values.toList(),
    seed: c.rngSeed,
  );
  final direct = <int>{
    for (final e in grouped.entries)
      ...Qualification.qualifiers(
        e.value,
        QualificationFormat.forConfederation(
          e.key,
        ).qualifyingBerths(hostBerths[e.key] ?? 0),
      ),
  };
  final expected = {...direct, ...hosts, ...winners};

  // Printed so a failure (and the sweep) can be read without a debugger.
  // ignore: avoid_print
  print(
    '$label cycle ${c.cyclePointer}: play-off '
    '${[for (final t in view.ties) '${nm(t.home)} v ${nm(t.away)} -> ${nm(t.winner)}']} '
    'hosts ${hosts.map(nm).toList()} hostBerths $hostBerths '
    'missing ${expected.difference(field).map(nm).toList()} '
    'extra ${field.difference(expected).map(nm).toList()}',
  );

  expect(field.length, 48, reason: label);
  for (final w in winners) {
    expect(field, contains(w), reason: '$label: ${nm(w)} won the play-off');
  }
  for (final l in losers) {
    expect(field, isNot(contains(l)), reason: '$label: ${nm(l)} lost');
  }
  expect(field, expected, reason: label);
}
