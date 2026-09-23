import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
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
  worldCupPlayoffKind,
  worldCupKickoffKind,
  continentalKickoffKind,
];

typedef _Outcome = ({
  String ending, // 'rollover' | 'stall'
  HubEventKind lastEvent,
  String lastLabel,
  int cyclePointer,
  int? champion,
  DateTime date,
});

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // The hub must never run out of things to offer. A career driven end to end
  // either reaches the cycle rollover or the wall; what it must never do is
  // sit on an event whose action changes nothing, which is a manager staring
  // at a button that does not work.
  for (final seed in [1, 7, 12345, 99, 2026, 31337, 555, 8080]) {
    for (final pick in ['host', 'strong', 'weak']) {
      test(
        'seed $seed / $pick: a next action at every end of cycle',
        () async {
          final out = await _driveFirstCycle(
            seed: seed,
            pickKind: pick,
            cycles: 3,
            premium: true,
          );
          expect(out.ending, isNot('stall'), reason: 'stalled: $out');
          expect(
            out.lastEvent,
            HubEventKind.cycleRollover,
            reason: 'the hub stopped offering the rollover: $out',
          );
        },
        timeout: const Timeout(Duration(minutes: 8)),
      );
    }
  }

  // ...and a free save meets the wall at the end of the FIRST cycle, not the
  // second. It used to roll out of cycle 0 untouched, which is why a tester
  // reported that nothing happened and he could play on for nothing.
  test(
    'a free save is walled at the end of its first cycle',
    () async {
      final out = await _driveFirstCycle(
        seed: 12345,
        pickKind: 'host',
        cycles: 5,
      );
      expect(out.ending, 'wall');
      expect(
        out.cyclePointer,
        0,
        reason: 'the wall must arrive at the end of the FIRST cycle',
      );
      expect(out.champion, isNotNull);
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}

Future<_Outcome> _driveFirstCycle({
  required int seed,
  required String pickKind,
  int cycles = 1,
  bool premium = false,
}) async {
  final db = createTestDatabase();
  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List<dynamic>)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList();

  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      premiumUnlockedProvider.overrideWith((ref) => premium),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(nationList: nations, playerList: const []),
      ),
    ],
  );
  addTearDown(container.dispose);
  addTearDown(db.close);

  await container.read(seedLoaderProvider).ensureSeeded();
  final hosts = WorldCupHosts.hostsFor(
    year: CareerService.worldCupYear(0),
    nations: nations,
    seed: seed,
  );
  final player = switch (pickKind) {
    'host' => nations.firstWhere((n) => n.id == hosts.first),
    'strong' => nations.reduce((a, b) => a.ranking <= b.ranking ? a : b),
    _ =>
      nations
          .where((n) => n.confederation == Confederation.europe)
          .reduce((a, b) => a.ranking >= b.ranking ? a : b),
  };
  final career =
      (await container
              .read(careerServiceProvider)
              .create(nationId: player.id, managerName: 'M', rngSeed: seed))
          .valueOrNull!;

  final season = container.read(seasonServiceProvider);
  final comp = container.read(competitionRepositoryProvider);
  var last = DateTime(1900);
  var event = await container.read(nextEventProvider(career.id).future);

  for (var i = 0; i < 2000; i++) {
    container
      ..invalidate(hubDataProvider)
      ..invalidate(nextEventProvider)
      ..invalidate(trainingCampPlanProvider);
    final hub = await container.read(hubDataProvider(career.id).future);
    if (hub == null) break;
    event = await container.read(nextEventProvider(career.id).future);
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
    final c0 = (await container
        .read(careerRepositoryProvider)
        .byId(career.id))!;
    if (event.kind == HubEventKind.cycleRollover) {
      // What CycleRolloverScreen._begin does.
      final blocked = await season.trialBlocksNextCycle(career.id);
      if (blocked) {
        return (
          ending: 'wall',
          lastEvent: event.kind,
          lastLabel: event.label,
          cyclePointer: c0.cyclePointer,
          champion: hub.championNationId,
          date: c0.inGameDate,
        );
      }
      if (c0.cyclePointer >= cycles - 1) {
        return (
          ending: 'rollover',
          lastEvent: event.kind,
          lastLabel: event.label,
          cyclePointer: c0.cyclePointer,
          champion: hub.championNationId,
          date: c0.inGameDate,
        );
      }
      await season.startNextCycle(career.id);
      final c1 = (await container
          .read(careerRepositoryProvider)
          .byId(career.id))!;
      if (c1.cyclePointer == c0.cyclePointer) {
        return (
          ending: 'roll-refused',
          lastEvent: event.kind,
          lastLabel: event.label,
          cyclePointer: c1.cyclePointer,
          champion: hub.championNationId,
          date: c1.inGameDate,
        );
      }
      last = DateTime(1900);
      continue;
    }
    await season.advance(career.id);
    container.invalidate(hubDataProvider);
    final now = await container.read(hubDataProvider(career.id).future);
    if (now == null) break;
    if (!now.career.inGameDate.isAfter(last)) {
      return (
        ending: 'stall',
        lastEvent: event.kind,
        lastLabel: event.label,
        cyclePointer: now.career.cyclePointer,
        champion: now.championNationId,
        date: now.career.inGameDate,
      );
    }
    last = now.career.inGameDate;
  }
  final end = (await container.read(careerRepositoryProvider).byId(career.id))!;
  return (
    ending: 'stall',
    lastEvent: event.kind,
    lastLabel: event.label,
    cyclePointer: end.cyclePointer,
    champion: await comp.worldChampion(career.id),
    date: end.inGameDate,
  );
}
