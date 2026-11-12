import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../../story/driver.dart';

/// "Simulate to the final": a tournament the manager is out of, or never in,
/// played out in one go from the hub's watch event. It is the same stepping
/// done for him, so it ends where stepping ends (the champion crowned, the
/// same champion from the same seed) and never plays or passes anything of
/// his. It stops with the final next, which is left to be watched.
void main() {
  // San Marino: in none of the finals of the cycle, so every one of them is
  // watched (the European Championship, the Nations Cup finals, the World
  // Championship).
  const sanMarino = 45;

  /// How many times a simulation stopped with a final still to watch.
  var finalsLeft = 0;

  /// Whether the tournament [route] watches has its final drawn and unplayed.
  Future<bool> finalNext(StoryDriver d, String route) async {
    final uri = Uri.parse(route);
    final conf = Confederation.values
        .where((c) => c.name == uri.queryParameters['conf'])
        .firstOrNull;
    final (kind, round) = switch (uri.path) {
      '/continental' => (CompetitionKind.continentalFinals, 'CFINAL'),
      '/nations-cup' => (CompetitionKind.nationsLeague, 'NFINAL'),
      _ => (CompetitionKind.worldCupFinals, 'FINAL'),
    };
    final finals = await d.c
        .read(competitionRepositoryProvider)
        .fixturesByRound(d.careerId, round, kind: kind, confederation: conf);
    return finals.isNotEmpty && finals.every((f) => !f.hasResult);
  }

  /// Drives a career to the end of its first cycle. At each watch event the
  /// tournament is either stepped (the event's own action) or simulated to
  /// its final in one go. Returns how many watch actions were taken.
  Future<int> drive(StoryDriver d, {required bool fast}) async {
    final season = d.c.read(seasonServiceProvider);
    var actions = 0;
    for (var i = 0; i < 6000; i++) {
      final e = await d.nextEvent();
      if (e.kind == HubEventKind.cycleRollover) break;
      if (e.kind == HubEventKind.watchTournament) {
        actions++;
        if (fast) {
          final before = (await d.c
              .read(careerRepositoryProvider)
              .byId(d.careerId))!;
          final played =
              (await d.c
                      .read(competitionRepositoryProvider)
                      .fixturesForNation(d.careerId, before.nationId))
                  .where((f) => f.hasResult)
                  .length;
          await season.simulateTournament(d.careerId);
          // Nothing of his is played by it.
          expect(
            (await d.c
                    .read(competitionRepositoryProvider)
                    .fixturesForNation(d.careerId, before.nationId))
                .where((f) => f.hasResult)
                .length,
            played,
          );
          // It lands on something other than this tournament's next round,
          // or on its final, which is left to be watched.
          final after = await d.nextEvent();
          if (after.kind == HubEventKind.watchTournament &&
              after.route == e.route) {
            expect(
              await finalNext(d, e.route!),
              isTrue,
              reason: 'stopped short of the final of ${e.route}',
            );
            finalsLeft++;
          }
          continue;
        }
      }
      await d.step();
    }
    return actions;
  }

  test(
    'the same champions as stepping, in far fewer taps',
    () async {
      final stepC = storyContainer();
      addTearDown(stepC.dispose);
      final fastC = storyContainer();
      addTearDown(fastC.dispose);
      final stepped = await StoryDriver.start(stepC, 5, nationId: sanMarino);
      final fast = await StoryDriver.start(fastC, 5, nationId: sanMarino);

      final steps = await drive(stepped, fast: false);
      final taps = await drive(fast, fast: true);

      final a = stepC.read(competitionRepositoryProvider);
      final b = fastC.read(competitionRepositoryProvider);
      expect(await a.worldChampion(stepped.careerId), isNotNull);
      expect(
        await b.worldChampion(fast.careerId),
        await a.worldChampion(stepped.careerId),
      );
      for (final conf in Confederation.values) {
        expect(
          await b.continentalChampion(fast.careerId, confederation: conf),
          await a.continentalChampion(stepped.careerId, confederation: conf),
          reason: '$conf',
        );
      }
      String honours(List<dynamic> list) =>
          (list
                  .map((h) => '${h.year} ${h.competition} ${h.championId}')
                  .toList()
                ..sort())
              .join('\n');
      expect(
        honours(await b.honours(fast.careerId)),
        honours(await a.honours(stepped.careerId)),
      );
      // The final, as stepping played it.
      final aFinal = (await a.fixturesByRound(
        stepped.careerId,
        'FINAL',
      )).single;
      final bFinal = (await b.fixturesByRound(fast.careerId, 'FINAL')).single;
      expect(
        (
          bFinal.homeNationId,
          bFinal.awayNationId,
          bFinal.homeScore,
          bFinal.awayScore,
        ),
        (
          aFinal.homeNationId,
          aFinal.awayNationId,
          aFinal.homeScore,
          aFinal.awayScore,
        ),
      );
      // Every tournament it played out stopped before its final, and each
      // of those finals is one more tap of its own.
      expect(finalsLeft, greaterThan(0));
      expect(
        taps - finalsLeft,
        lessThan(steps ~/ 3),
        reason: '$taps taps ($finalsLeft of them finals), $steps steps',
      );
      // And the hub's next step is the rollover, the champion known.
      expect((await fast.nextEvent()).kind, HubEventKind.cycleRollover);
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );

  test('anything but a watch event: nothing happens', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.start(c, 5, nationId: sanMarino);
    final repo = c.read(careerRepositoryProvider);
    for (var i = 0; i < 200; i++) {
      final e = await d.nextEvent();
      if (e.kind == HubEventKind.match) break;
      await d.step();
    }
    expect((await d.nextEvent()).kind, HubEventKind.match);
    final before = (await repo.byId(d.careerId))!.inGameDate;
    await c.read(seasonServiceProvider).simulateTournament(d.careerId);
    expect((await repo.byId(d.careerId))!.inGameDate, before);
    expect((await d.nextEvent()).kind, HubEventKind.match);
  });
}
