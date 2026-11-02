import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/friendlies/warm_up_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';

import '../../story/driver.dart';

/// A tournament the manager is only watching is opened as it starts: on the
/// eve of its first match.
///
/// San Marino, out of every finals of the cycle, used to see the European
/// Championship 2028 opened on 9 June 2027: with nothing of theirs on the
/// calendar before it, the ceremony fired the moment the draw was watched.
/// Now the hub offers a plain advance, the world is played on to the eve of
/// the opener, and the ceremony is held there. Every warm-up offer is
/// taken, so the manager has matches of his own just before both openers,
/// and none of them may be passed by.
void main() {
  test(
    'San Marino: each finals opened on its eve, none of theirs passed',
    () async {
      final c = storyContainer();
      addTearDown(c.dispose);
      final d = await StoryDriver.start(c, 5, nationId: 45);
      final comp = c.read(competitionRepositoryProvider);
      final repo = c.read(careerRepositoryProvider);
      final svc = c.read(warmUpOfferServiceProvider);
      final nations = {for (final n in storyNations) n.id: n};
      final opened = <String, DateTime>{};
      var accepted = 0;
      for (var i = 0; i < 6000; i++) {
        final career = (await repo.byId(d.careerId))!;
        final e = await d.nextEvent();
        if (e.kind == HubEventKind.cycleRollover) break;
        if (e.kind == HubEventKind.warmUpOffer) {
          final o = (await pendingWarmUpOffers(comp, career, nations)).first;
          await svc.accept(d.careerId, o);
          accepted++;
          continue;
        }
        if (e.kind == HubEventKind.tournamentKickoff) {
          final conf = Uri.parse(e.route!).queryParameters['conf'];
          final kind = conf == null
              ? CompetitionKind.worldCupFinals
              : CompetitionKind.continentalFinals;
          final first = await comp.earliestUnplayedDateOfKind(
            d.careerId,
            kind,
            confederation: conf == null ? null : Confederation.europe,
          );
          // Nothing of it played yet, and opened on the eve of its first
          // matchday.
          expect(
            career.inGameDate,
            DateTime(first!.year, first.month, first.day - 1),
            reason: '${conf ?? 'wc'} opened early',
          );
          opened[conf ?? 'wc'] = career.inGameDate;
        }
        // Nothing of his is ever left behind the clock.
        final mine = await comp.fixturesForNation(d.careerId, 45);
        expect(
          mine.where(
            (f) => !f.hasResult && f.date.isBefore(career.inGameDate),
          ),
          isEmpty,
          reason: 'a match of his passed by on ${career.inGameDate}',
        );
        await d.step();
      }
      expect(opened['europe'], DateTime(2028, 6, 7));
      expect(opened['wc'], DateTime(2030, 6, 10));
      expect(accepted, greaterThan(0));
      final mine = await comp.fixturesForNation(d.careerId, 45);
      expect(mine.every((f) => f.hasResult), isTrue);
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );
}
