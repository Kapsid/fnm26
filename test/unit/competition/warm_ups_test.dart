import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/warm_ups.dart';
import 'package:fnm/domain/services/squad/nomination.dart';
import 'package:fnm/features/friendlies/friendlies_providers.dart';
import 'package:fnm/features/friendlies/warm_up_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';

import '../../story/driver.dart';

/// The warm-up window before every finals tournament: two friendlies in the
/// days before the opener. A qualified side books them like any window, with
/// the tournament's squad; a side that missed out hears from one to three
/// qualified nations that want a send-off, and may take up two.
void main() {
  group('WarmUps', () {
    test('two dates just before the opener, across a year end too', () {
      expect(WarmUps.datesBefore(DateTime(2030, 6, 11)), [
        DateTime(2030, 6, 2),
        DateTime(2030, 6, 5),
      ]);
      expect(WarmUps.datesBefore(DateTime(2028, 1, 8)), [
        DateTime(2027, 12, 30),
        DateTime(2028, 1, 2),
      ]);
    });

    Nation nation(int id, Confederation c, int ranking) => Nation(
      id: id,
      name: 'N$id',
      code: 'N$id',
      confederation: c,
      ranking: ranking,
    );

    test('one to three offers, own confederation first', () {
      final me = nation(1, Confederation.europe, 120);
      final nations = <int, Nation>{
        1: me,
        for (var i = 10; i < 18; i++) i: nation(i, Confederation.europe, i * 3),
        for (var i = 20; i < 44; i++)
          i: nation(i, Confederation.values[i % 5 + 1], i),
      };
      final groups = [
        for (var g = 0; g < 8; g++)
          [
            for (final id in [...nations.keys.where((k) => k != 1)])
              if ([...nations.keys.where((k) => k != 1)].indexOf(id) % 8 == g)
                id,
          ],
      ];
      final counts = <int>{};
      for (var seed = 0; seed < 200; seed++) {
        final offers = WarmUps.offers(
          seed: seed,
          cycle: 0,
          tournament: 1,
          me: me,
          nations: nations,
          groups: groups,
        );
        counts.add(offers.length);
        expect(offers.length, inInclusiveRange(1, 3));
        expect(offers.toSet().length, offers.length);
        expect(offers, isNot(contains(1)));
        // Deterministic.
        expect(
          WarmUps.offers(
            seed: seed,
            cycle: 0,
            tournament: 1,
            me: me,
            nations: nations,
            groups: groups,
          ),
          offers,
        );
        // The most plausible offer is a European side whenever one plays.
        expect(nations[offers.first]!.confederation, Confederation.europe);
      }
      expect(counts, {1, 2, 3});
    });
  });

  group('Nomination', () {
    Fixture fx(int id, DateTime date, String round, {int matchday = 1}) =>
        Fixture(
          id: id,
          careerId: 1,
          competitionId: 1,
          matchday: matchday,
          date: date,
          homeNationId: 1,
          awayNationId: 2,
          round: round,
          played: id == 1,
          homeScore: id == 1 ? 1 : null,
          awayScore: id == 1 ? 0 : null,
        );

    test(
      'the warm-ups and the finals are one squad, called up 10 days out',
      () {
        final fixtures = [
          fx(1, DateTime(2030, 3, 9), 'CQ', matchday: 8),
          fx(2, DateTime(2030, 6, 2), 'FRIENDLY'),
          fx(3, DateTime(2030, 6, 5), 'FRIENDLY', matchday: 2),
          fx(4, DateTime(2030, 6, 11), 'GROUP'),
          fx(5, DateTime(2030, 6, 14), 'GROUP', matchday: 2),
        ];
        expect(Nomination.currentPeriod(fixtures).map((f) => f.id), [
          2,
          3,
          4,
          5,
        ]);
        expect(Nomination.callUpDay(fixtures), DateTime(2030, 6, 1));
      },
    );
  });

  test(
    'a qualified side books its warm-ups; they are played before the opener '
    'by the tournament squad',
    () async {
      final c = storyContainer();
      addTearDown(c.dispose);
      final d = await StoryDriver.start(c, 3);
      final comp = c.read(competitionRepositoryProvider);
      final repo = c.read(careerRepositoryProvider);
      List<DateTime>? booked;
      DateTime? opener;
      for (var i = 0; i < 4000; i++) {
        final career = (await repo.byId(d.careerId))!;
        if (career.inGameDate.isAfter(DateTime(2028, 7))) break;
        final e = await d.nextEvent();
        if (e.kind == HubEventKind.friendlies && booked == null) {
          c.invalidate(friendliesPlanProvider(d.careerId));
          final sub = c.listen(
            friendliesPlanProvider(d.careerId).future,
            (_, _) {},
          );
          final plan = (await sub.read())!;
          sub.close();
          final nations = {for (final n in storyNations) n.id: n};
          final finals = (await upcomingWarmUpFinals(
            comp,
            career,
            nations,
          )).where((f) => inWarmUpFinals(f, career.nationId)).toList();
          if (finals.isNotEmpty) {
            opener = finals.first.opener;
            final dates = WarmUps.datesBefore(opener);
            expect(plan.windows, containsAll(dates));
            // Offered once the last window before it is over: a save in
            // the gap between March and the finals gets it.
            final mine = await comp.fixturesForNation(
              d.careerId,
              career.nationId,
            );
            expect(
              mine.where((f) => !f.hasResult && f.date.isBefore(dates.first)),
              isEmpty,
            );
            final others = [
              for (final g in finals.first.groups)
                for (final id in g)
                  if (id != career.nationId) id,
            ];
            await c
                .read(friendliesServiceProvider)
                .arrange(
                  d.careerId,
                  nationId: career.nationId,
                  cycle: career.cyclePointer,
                  picks: {dates[0]: others[0], dates[1]: others[1]},
                  allWindows: plan.windows,
                );
            booked = dates;
            continue;
          }
        }
        await d.step();
        if (opener != null &&
            (await repo.byId(d.careerId))!.inGameDate.isAfter(opener)) {
          break;
        }
      }
      expect(booked, isNotNull, reason: 'never offered the warm-ups');
      final career = (await repo.byId(d.careerId))!;
      final mine = await comp.fixturesForNation(d.careerId, career.nationId);
      for (final day in booked!) {
        final f = mine.singleWhere(
          (f) => f.round == 'FRIENDLY' && f.date == day,
        );
        expect(f.hasResult, isTrue, reason: 'warm-up on $day played');
        expect(f.homeNationId, career.nationId, reason: 'a send-off at home');
        // One squad: the warm-ups opened the camp, the opener did not.
        expect(
          await comp.hasWatchedDraw(
            d.careerId,
            career.cyclePointer,
            'callup:${f.id}',
          ),
          f.date == booked.first,
        );
      }
      final openerMatch = mine.firstWhere(
        (f) => f.round == 'CGROUP' && f.matchday == 1,
      );
      expect(openerMatch.date, opener);
      expect(openerMatch.hasResult, isTrue);
      expect(
        await comp.hasWatchedDraw(
          d.careerId,
          career.cyclePointer,
          'callup:${openerMatch.id}',
        ),
        isFalse,
      );
      await _expectNoDoubleDays(c, d.careerId);
    },
    timeout: const Timeout(Duration(minutes: 15)),
  );

  test(
    'a side that missed out hears from qualified nations, and may take two',
    () async {
      final c = storyContainer();
      addTearDown(c.dispose);
      // San Marino: no Euro for them.
      final d = await StoryDriver.start(c, 5, nationId: 45);
      final comp = c.read(competitionRepositoryProvider);
      final repo = c.read(careerRepositoryProvider);
      final svc = c.read(warmUpOfferServiceProvider);
      final nations = {for (final n in storyNations) n.id: n};
      final accepted = <WarmUpOffer>[];
      var declined = 0;
      var offered = 0;
      DateTime? opener;
      for (var i = 0; i < 4000; i++) {
        final career = (await repo.byId(d.careerId))!;
        if (career.inGameDate.isAfter(DateTime(2028, 7))) break;
        final e = await d.nextEvent();
        if (e.kind == HubEventKind.warmUpOffer) {
          // As the offer screen does when it opens.
          await svc.fileMessages(d.careerId);
          final open = await pendingWarmUpOffers(comp, career, nations);
          if (offered == 0) {
            offered = open.length;
            expect(offered, inInclusiveRange(1, 3));
            final finals = (await upcomingWarmUpFinals(
              comp,
              career,
              nations,
            )).first;
            opener = finals.opener;
            for (final o in open) {
              expect(inWarmUpFinals(finals, o.nationId), isTrue);
            }
            expect(
              await comp.messageKeys(d.careerId),
              containsAll([
                for (final o in open)
                  warmUpOfferMessageKey(o.cycle, o.tournament, o.nationId),
              ]),
              reason: 'each offer is in the inbox',
            );
          }
          final o = open.first;
          final before = (await comp.fixturesForNation(
            d.careerId,
            career.nationId,
          )).length;
          if (offered == 3 && declined == 0) {
            // Declining books nothing.
            await svc.decline(d.careerId, o);
            declined++;
            expect(
              (await comp.fixturesForNation(
                d.careerId,
                career.nationId,
              )).length,
              before,
            );
          } else {
            await svc.accept(d.careerId, o);
            accepted.add(o);
            final mine = await comp.fixturesForNation(
              d.careerId,
              career.nationId,
            );
            expect(mine.length, before + 1);
            final f = mine.singleWhere(
              (f) =>
                  f.round == 'FRIENDLY' &&
                  (f.homeNationId == o.nationId ||
                      f.awayNationId == o.nationId) &&
                  !f.hasResult,
            );
            expect(
              f.date,
              WarmUps.datesBefore(opener!)[accepted.length - 1],
              reason: 'the first free warm-up date',
            );
            expect(
              f.homeNationId,
              o.theyHost ? o.nationId : career.nationId,
            );
          }
          continue;
        }
        await d.step();
      }
      expect(offered, greaterThan(0), reason: 'no offer ever came');
      expect(accepted.length, lessThanOrEqualTo(WarmUps.maxAccepted));
      expect(accepted.length, offered == 3 ? 2 : offered);
      final career = (await repo.byId(d.careerId))!;
      final mine = await comp.fixturesForNation(d.careerId, career.nationId);
      for (final o in accepted) {
        final f = mine.singleWhere(
          (f) =>
              f.round == 'FRIENDLY' &&
              (f.homeNationId == o.nationId || f.awayNationId == o.nationId),
        );
        expect(f.hasResult, isTrue);
        expect(f.date.isBefore(opener!), isTrue);
      }
      // The warm-ups were a window of their own, with a call-up.
      final first = mine
          .where((f) => f.round == 'FRIENDLY' && !f.date.isAfter(opener!))
          .reduce((a, b) => a.date.isBefore(b.date) ? a : b);
      expect(
        await comp.hasWatchedDraw(
          d.careerId,
          career.cyclePointer,
          'callup:${first.id}',
        ),
        isTrue,
      );
      await _expectNoDoubleDays(c, d.careerId);
    },
    timeout: const Timeout(Duration(minutes: 15)),
  );
}

/// Nobody, anywhere in the world, plays twice on one day.
Future<void> _expectNoDoubleDays(ProviderContainer c, int careerId) async {
  final all = await c.read(competitionRepositoryProvider).allFixtures(careerId);
  final seen = <(int, DateTime)>{};
  for (final f in all) {
    for (final id in [f.homeNationId, f.awayNationId]) {
      expect(seen.add((id, f.date)), isTrue, reason: '$id twice on ${f.date}');
    }
  }
}
