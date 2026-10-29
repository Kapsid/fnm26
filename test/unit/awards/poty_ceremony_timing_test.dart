import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/awards/award_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';

import '../../story/driver.dart';

/// When the yearly Player of the Year ceremony is offered.
///
/// The vote is on 1 December, after the November window. It used to be filed
/// only by the step AFTER the one that crossed December, so a side whose next
/// match was months away met "Player of the Year 2029" in the middle of the
/// 2030 finals, and the 2030 one did not come until well into 2031.
void main() {
  group('voteStopBefore', () {
    test('a step over 1 December stops on it', () {
      expect(
        voteStopBefore(DateTime(2029, 10, 9), DateTime(2030, 6, 11)),
        DateTime(2029, 12),
      );
      expect(
        voteStopBefore(DateTime(2029, 11, 30), DateTime(2029, 12, 2)),
        DateTime(2029, 12),
      );
    });

    test('a step that stays on one side of it does not', () {
      expect(
        voteStopBefore(DateTime(2029, 9, 9), DateTime(2029, 11, 19)),
        isNull,
      );
      // Already on (or past) the day: the vote is filed at this step's end.
      expect(
        voteStopBefore(DateTime(2029, 12), DateTime(2030, 3, 20)),
        isNull,
      );
      expect(
        voteStopBefore(DateTime(2030, 3, 9), DateTime(2030, 6, 11)),
        isNull,
      );
      // A match ON 1 December is played; the vote follows it.
      expect(
        voteStopBefore(DateTime(2029, 11, 19), DateTime(2029, 12)),
        isNull,
      );
    });
  });

  // One career through a whole cycle, two finals and into the next: every
  // year's ceremony is offered once, on 1 December, before anything else
  // moves the clock, and none is passed by unseen.
  for (final (name, nation) in [('England', england), ('Senegal', 142)]) {
    test(
      '$name: one ceremony a year, on 1 December, never during the finals',
      () async {
        final db = storyDb();
        final c = storyContainer(db);
        addTearDown(c.dispose);
        final d = await StoryDriver.start(c, 3, nationId: nation);
        final comp = c.read(competitionRepositoryProvider);
        final repo = c.read(careerRepositoryProvider);
        final offered = <int, List<DateTime>>{};
        var rolledOver = false;
        for (var i = 0; i < 6000; i++) {
          final career = (await repo.byId(d.careerId))!;
          if (career.inGameDate.isAfter(DateTime(2031, 4))) break;
          final e = await d.nextEvent();
          if (e.kind == HubEventKind.cycleRollover) rolledOver = true;
          if (e.kind == HubEventKind.awardsCeremony) {
            final year = int.parse(
              Uri.parse(e.route!).queryParameters['year']!,
            );
            (offered[year] ??= []).add(career.inGameDate);
            // Never while a finals tournament is on: the 2029 one used to turn
            // up between the 2030 World Championship's group games.
            expect(
              career.inGameDate.month,
              isNot(anyOf(6, 7)),
              reason: '$year offered during the finals',
            );
          }
          await d.step();
        }
        expect(rolledOver, isTrue, reason: 'never reached the 2030 final');
        for (final year in [2026, 2027, 2028, 2029, 2030]) {
          // Offered at exactly one hub moment (the driver takes it there),
          // on the day of the vote.
          expect(offered[year], [DateTime(year, 12)], reason: '$year');
          expect(
            await comp.hasWatchedDraw(d.careerId, 0, potySeenKind(year)),
            isTrue,
          );
        }
        // The 2030 one, after the championship, in the new cycle.
        expect(offered[2030], isNotNull);
      },
      timeout: const Timeout(Duration(minutes: 10)),
    );
  }
}
