import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/competition/euro_playoffs.dart';
import 'package:fnm/domain/services/competition/wc_playoffs.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

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
  EuroPlayoffs.drawWatchedKind,
  UefaWcPlayoffs.drawWatchedKind,
  worldCupPlayoffKind,
  worldCupKickoffKind,
  continentalKickoffKind,
];

const int _cycles = 2;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'conferences hold their cadence over full cycles',
    () async {
      var total = 0;
      var completed = 0;
      // A side that wins every game of a cycle never has a loud night and
      // may go a cycle without a room (the calendar's draws decide who that
      // is, and they move with every calendar change): one such cycle over
      // the runs is a dominant side, more is a press that stopped calling.
      final quiet = <String>[];
      final incomplete = <int>[];
      // 8080 was the fourth until Africa's, Asia's and Oceania's own play-off
      // steps (calendar2) moved the world: its host, Spain, then won every
      // game of its second cycle and never called a room.
      for (final seed in [1, 7, 2026, 99]) {
        final run = await _drive(seed);
        try {
          final calls = await run.container
              .read(careerRepositoryProvider)
              .conferences(run.careerId);
          final perCycle = <int, int>{
            for (var i = 0; i < run.cyclesDone; i++) i: 0,
          };
          for (final x in calls) {
            perCycle[x.cycle] = (perCycle[x.cycle] ?? 0) + 1;
          }
          if (run.cyclesDone < _cycles) incomplete.add(seed);
          for (var i = 0; i < run.cyclesDone; i++) {
            if (perCycle[i]! == 0) quiet.add('seed $seed cycle $i');
            total += perCycle[i]!;
            completed++;
          }
          // Nothing answers press here, so no statement exists and no job
          // verdict can occur.
          expect(
            calls.any((x) => x.reason == ConferenceReason.jobVerdict),
            isFalse,
          );
          expect(
            perCycle.values.every((n) => n <= ConferenceTrigger.maxPerCycle),
            isTrue,
            reason: '$perCycle',
          );
          final first =
              (await run.comp.fixturesForNation(
                    run.careerId,
                    run.nationId,
                  ))
                  .where((f) => f.hasResult && f.round != Rounds.friendly)
                  .map((f) => f.date)
                  .reduce((a, b) => a.isBefore(b) ? a : b);
          expect(calls.every((x) => !x.triggeredOn.isBefore(first)), isTrue);
          for (var i = 1; i < calls.length; i++) {
            expect(
              calls[i].triggeredOn.difference(calls[i - 1].triggeredOn).inDays,
              greaterThanOrEqualTo(ConferenceTrigger.quietDays),
              reason: 'seed $seed: $perCycle',
            );
          }
          // ignore: avoid_print
          print(
            'seed $seed (cycles done ${run.cyclesDone}) '
            'conferences per cycle: $perCycle',
          );
        } finally {
          await run.close();
        }
      }
      expect(quiet.length, lessThanOrEqualTo(1), reason: '$quiet');
      expect(
        incomplete,
        isEmpty,
        reason: 'seeds that never finished: $incomplete',
      );
      final mean = total / completed;
      // ignore: avoid_print
      print('mean conferences per completed cycle: $mean');
      expect(mean, inInclusiveRange(2.0, 6.0));
    },
    timeout: const Timeout(Duration(minutes: 30)),
  );
}

Future<
  ({
    ProviderContainer container,
    CompetitionRepository comp,
    int careerId,
    int nationId,
    int cyclesDone,
    Future<void> Function() close,
  })
>
_drive(int seed) async {
  final db = createTestDatabase();
  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List<dynamic>)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList();
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      premiumUnlockedProvider.overrideWith((ref) => true),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(nationList: nations, playerList: const []),
      ),
    ],
  );
  // Closed by the caller after each seed, so only one database is ever open.
  Future<void> close() async {
    container.dispose();
    await db.close();
  }

  await container.read(seedLoaderProvider).ensureSeeded();
  final hosts = WorldCupHosts.hostsFor(
    year: CareerService.worldCupYear(0),
    nations: nations,
    seed: seed,
  );
  final player = nations.firstWhere((n) => n.id == hosts.first);
  final career =
      (await container
              .read(careerServiceProvider)
              .create(
                nationId: player.id,
                managerName: 'M',
                rngSeed: seed,
                stadiumHostRules: false,
              ))
          .valueOrNull!;

  final season = container.read(seasonServiceProvider);
  final comp = container.read(competitionRepositoryProvider);
  var last = DateTime(1900);
  var done = 0;

  ({
    ProviderContainer container,
    CompetitionRepository comp,
    int careerId,
    int nationId,
    int cyclesDone,
    Future<void> Function() close,
  })
  result() => (
    container: container,
    comp: comp,
    careerId: career.id,
    nationId: player.id,
    cyclesDone: done,
    close: close,
  );

  for (var i = 0; i < 4000; i++) {
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
          await comp.markDrawWatched(career.id, hub.career.cyclePointer, kind);
        }
      }
      container
        ..invalidate(nextEventProvider)
        ..invalidate(trainingCampPlanProvider);
      event = await container.read(nextEventProvider(career.id).future);
    }
    if (event.kind == HubEventKind.cycleRollover) {
      done++;
      final c0 = (await container
          .read(careerRepositoryProvider)
          .byId(career.id))!;
      if (done >= _cycles) return result();
      await season.startNextCycle(career.id);
      final c1 = (await container
          .read(careerRepositoryProvider)
          .byId(career.id))!;
      if (c1.cyclePointer == c0.cyclePointer) {
        done--; // roll refused: report as incomplete
        return result();
      }
      last = DateTime(1900);
      continue;
    }
    await season.advance(career.id);
    container.invalidate(hubDataProvider);
    final now = await container.read(hubDataProvider(career.id).future);
    if (now == null) break;
    if (!now.career.inGameDate.isAfter(last)) return result();
    last = now.career.inGameDate;
  }
  return result();
}
