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
import 'package:fnm/features/hub/round_popup.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

import '../../helpers/test_database.dart';

/// Both main finals tournaments, as one table.
///
/// The bug this guards is the shape "one works and the other silently does
/// not": the continental final was shown round by round and the World
/// Championship's was not, so its champion simply appeared. Everything asserted
/// below is asserted for BOTH competitions from the same table, so neither can
/// drift away from the other again.
const _competitions = <({String name, String finalRound, List<String> rounds})>[
  (
    name: 'continental championship',
    finalRound: 'CFINAL',
    rounds: ['CGROUP', 'CR16', 'CQF', 'CSF', 'CFINAL'],
  ),
  (
    name: 'World Championship',
    finalRound: 'FINAL',
    rounds: ['GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'],
  ),
];

/// What one advance did to one tournament: the rounds it completed, the event
/// the hub offered before it, and the round popup it produced.
typedef _Step = ({
  Set<String> rounds,
  HubEventKind event,
  String? competition,
  String? stage,
});

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// A manager in neither final follows both of them from the stands. Whatever
  /// the continental final emits, the World Championship's final must emit too.
  test(
    'both finals are presented the same way to a manager watching',
    () async {
      final steps = await _run(
        pick: (nations) => nations
            .where((n) => n.confederation == Confederation.europe)
            .reduce((a, b) => a.ranking >= b.ranking ? a : b),
        cycles: 1,
      );

      final rows = <String, _Step>{};
      for (final c in _competitions) {
        final row = steps.firstWhere(
          (s) => s.rounds.contains(c.finalRound),
          orElse: () => (
            rounds: <String>{},
            event: HubEventKind.advance,
            competition: null,
            stage: null,
          ),
        );
        expect(
          row.rounds,
          isNotEmpty,
          reason: "the ${c.name}'s final was never played",
        );
        rows[c.name] = row;
      }

      final continental = rows['continental championship']!;
      final worldChampionship = rows['World Championship']!;

      expect(
        worldChampionship.event,
        continental.event,
        reason:
            'the World Championship final was reached through a different kind '
            'of event than the continental final: '
            '${worldChampionship.event.name} vs ${continental.event.name}. '
            'Only HubEventKind.watchTournament shows the round it just played.',
      );
      for (final c in _competitions) {
        final row = rows[c.name]!;
        expect(
          row.event,
          HubEventKind.watchTournament,
          reason: "the ${c.name}'s final must be a round the manager steps",
        );
        expect(
          row.stage,
          'Final',
          reason: "the ${c.name}'s final must be reported as the final",
        );
        expect(
          row.rounds,
          {c.finalRound},
          reason:
              "the ${c.name}'s final must be a step of its own, not one of "
              'several rounds resolved in a single simulation',
        );
      }
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );

  /// …and a manager who is IN a final does not lose the round played just
  /// before it.
  ///
  /// Every path that moves the world except the watch-a-round step catches up
  /// to a single date and plays everything due by it. The World Championship is
  /// the only tournament with two fixtures at its end — the third-place
  /// play-off two days before the final — so a manager carried to his own final
  /// had the play-off resolved silently underneath it. The continental
  /// championship has no third-place play-off, which is exactly why it looked
  /// fine while this one did not.
  test(
    'no advance resolves two rounds of the same finals at once',
    () async {
      final steps = await _run(
        // The World Championship host: auto-qualified, so he contests the finals
        // himself and can reach the final.
        pick: (nations) {
          final hosts = WorldCupHosts.hostsFor(
            year: CareerService.worldCupYear(0),
            nations: nations,
            seed: 12345,
          );
          return nations.firstWhere((n) => n.id == hosts.first);
        },
        seed: 12345,
        cycles: 3,
      );

      for (final c in _competitions) {
        for (final step in steps) {
          final mine = step.rounds.where(c.rounds.contains).toSet();
          expect(
            mine.length,
            lessThan(2),
            reason:
                'one advance completed ${mine.length} rounds of the ${c.name} '
                '($mine) — the manager was shown at most the last of them',
          );
        }
      }
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}

/// Plays [cycles] cycles passively, taking every ceremony as it comes, and
/// returns every advance that completed a round of either main finals.
Future<List<_Step>> _run({
  required Nation Function(List<Nation>) pick,
  int cycles = 1,
  int? seed,
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
      premiumUnlockedProvider.overrideWith((ref) => true),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(nationList: nations, playerList: const []),
      ),
    ],
  );
  addTearDown(container.dispose);
  addTearDown(db.close);

  await container.read(seedLoaderProvider).ensureSeeded();
  final player = pick(nations);
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
  final out = <_Step>[];
  var last = DateTime(1900);

  Future<Set<String>> completed() async {
    final done = <String>{};
    for (final c in _competitions) {
      final isCont = c.finalRound.startsWith('C');
      for (final r in c.rounds) {
        final fx = await comp.fixturesByRound(
          career.id,
          r,
          kind: isCont
              ? CompetitionKind.continentalFinals
              : CompetitionKind.worldCupFinals,
          confederation: isCont ? player.confederation : null,
        );
        if (fx.isNotEmpty && fx.every((f) => f.hasResult)) done.add(r);
      }
    }
    return done;
  }

  var before = await completed();

  for (var i = 0; i < 2000; i++) {
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
      final c = await container.read(careerRepositoryProvider).byId(career.id);
      if (c == null || c.cyclePointer >= cycles - 1) break;
      await season.startNextCycle(career.id);
      before = <String>{};
      last = DateTime(1900);
      continue;
    }
    final kindBefore = event.kind;
    await season.advance(career.id);
    container
      ..invalidate(hubDataProvider)
      ..invalidate(latestRoundPopupProvider);
    final after = await completed();
    final fresh = after.difference(before);
    before = after;
    if (fresh.isNotEmpty) {
      final popup = await container.read(
        latestRoundPopupProvider(career.id).future,
      );
      out.add((
        rounds: fresh,
        event: kindBefore,
        competition: popup?.competition,
        stage: popup?.stage,
      ));
    }
    final now = await container.read(hubDataProvider(career.id).future);
    if (now == null) break;
    if (!now.career.inGameDate.isAfter(last)) break;
    last = now.career.inGameDate;
  }
  return out;
}

/// The one-shot steps a cycle forces on the manager, and the keys that record
/// them as taken.
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
