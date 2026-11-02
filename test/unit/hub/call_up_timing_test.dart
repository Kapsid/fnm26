import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/squad/nomination.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../../story/driver.dart';

/// When the squad call-up is offered: ten days before the window it is for,
/// not the moment the previous window's last match is played. Until then the
/// hub offers a plain advance, which plays the rest of the world on and stops
/// on the call-up day.
void main() {
  Fixture fx(
    int id,
    DateTime date, {
    String? round = 'CQ',
    int matchday = 2,
    bool played = false,
  }) => Fixture(
    id: id,
    careerId: 1,
    competitionId: 1,
    matchday: matchday,
    date: date,
    homeNationId: 1,
    awayNationId: 2,
    round: round,
    played: played,
    homeScore: played ? 1 : null,
    awayScore: played ? 0 : null,
  );

  group('Nomination.callUpDay', () {
    test('ten days before the window that is about to open', () {
      final fixtures = [
        fx(1, DateTime(2026, 11, 9), played: true),
        fx(2, DateTime(2026, 11, 12), played: true),
        fx(3, DateTime(2027, 3, 20)),
        fx(4, DateTime(2027, 3, 23)),
      ];
      expect(Nomination.callUpDay(fixtures), DateTime(2027, 3, 10));
    });

    test('none in the middle of a window', () {
      final fixtures = [
        fx(1, DateTime(2027, 3, 20), played: true),
        fx(2, DateTime(2027, 3, 23)),
      ];
      expect(Nomination.callUpDay(fixtures), isNull);
    });

    test('a finals squad is called up ten days before the opener', () {
      final fixtures = [
        fx(1, DateTime(2030, 3, 20), played: true),
        fx(2, DateTime(2030, 6, 11), round: 'GROUP', matchday: 1),
        fx(3, DateTime(2030, 6, 16), round: 'GROUP', matchday: 2),
      ];
      expect(Nomination.callUpDay(fixtures), DateTime(2030, 6, 1));
    });

    test('across a year end', () {
      final fixtures = [
        fx(1, DateTime(2027, 11, 12), played: true),
        fx(2, DateTime(2028, 1, 8), round: 'CGROUP', matchday: 1),
      ];
      expect(Nomination.callUpDay(fixtures), DateTime(2027, 12, 29));
    });
  });

  test(
    'through a cycle: advance to ten days out, then the call-up',
    () async {
      final c = storyContainer();
      addTearDown(c.dispose);
      final d = await StoryDriver.start(c, 3);
      final comp = c.read(competitionRepositoryProvider);
      final repo = c.read(careerRepositoryProvider);

      var callUps = 0;
      var stopsLanded = 0;
      var namedSquadKept = false;
      for (var i = 0; i < 3000; i++) {
        final career = (await repo.byId(d.careerId))!;
        if (career.inGameDate.isAfter(DateTime(2028, 7))) break;
        final e = await d.nextEvent();
        final fixtures = await comp.cycleFixturesForNation(
          d.careerId,
          career.nationId,
        );
        final event = e.route == null
            ? null
            : Uri.parse(e.route!).queryParameters['event'];

        if (e.kind == HubEventKind.callUp &&
            (event ?? '').startsWith('callup:')) {
          // Never before the call-up day: at most ten days ahead of the
          // window (or of a tournament's opener).
          final day = Nomination.callUpDay(fixtures)!;
          expect(
            career.inGameDate.isBefore(day),
            isFalse,
            reason: 'called up on ${career.inGameDate} for $day',
          );
          callUps++;
        }

        final stop = await pendingCallUpStop(comp, career);
        if (stop != null) {
          // The squad is not offered early: a plain advance takes its place.
          expect(e.kind, isNot(HubEventKind.callUp));
          if (e.kind == HubEventKind.advance) {
            // Once, a save from before this build that had already named
            // the squad for the coming window keeps it, and is never
            // stopped for it.
            if (!namedSquadKept && callUps > 3) {
              final period = Nomination.currentPeriod(fixtures);
              final key = 'callup:${period.first.id}';
              await comp.markDrawWatched(d.careerId, career.cyclePointer, key);
              expect(await pendingCallUpStop(comp, career), isNull);
              final after = await d.nextEvent();
              expect(
                after.kind == HubEventKind.callUp && after.route!.contains(key),
                isFalse,
              );
              namedSquadKept = true;
              continue;
            }
            final played = fixtures.where((f) => f.hasResult).length;
            await d.step();
            final moved = (await repo.byId(d.careerId))!;
            // Never past the call-up day, and nothing of his is played.
            expect(moved.inGameDate.isAfter(stop), isFalse);
            final mine = await comp.cycleFixturesForNation(
              d.careerId,
              career.nationId,
            );
            expect(mine.where((f) => f.hasResult).length, played);
            if (moved.inGameDate == stop) stopsLanded++;
            continue;
          }
        }
        await d.step();
      }
      expect(callUps, greaterThan(5));
      expect(stopsLanded, greaterThan(3));
      expect(namedSquadKept, isTrue);
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );
}
