import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/host_bid_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';

import 'driver.dart';

/// The owner: "confirm that bidding at the end is working okay now". Two
/// things moved at the end of a cycle in 1.0.7: the 1 December vote stop and
/// a host's friendlies being offered ahead of other events. These drive real
/// careers through the hub, event by event, to the end of the cycle and
/// check the bid window is still where it belongs, on the rollover.
final Map<int, List<String>> cities = {
  for (final e
      in (jsonDecode(File('assets/data/country_cities.json').readAsStringSync())
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (e.value! as List).cast<String>(),
};

void main() {
  const seed = 7;
  final Provider<Ref> refProvider = Provider<Ref>((ref) => ref);

  /// Drives [d] to the cycle-rollover event, checking on the way that no bid
  /// is offered while the cycle is still being played. Returns every event
  /// kind seen.
  Future<List<HubEventKind>> toRollover(StoryDriver d) async {
    final kinds = <HubEventKind>[];
    final careers = d.c.read(careerRepositoryProvider);
    for (var i = 0; i < 3000; i++) {
      final e = await d.nextEvent();
      kinds.add(e.kind);
      if (e.kind == HubEventKind.cycleRollover) return kinds;
      final career = (await careers.byId(d.careerId))!;
      // Spot checks rather than every step: offers are only for a cycle
      // whose World Championship is decided.
      if (i % 25 == 0 &&
          career.inGameDate.isBefore(
            DateTime(CareerService.worldCupYear(0), 7),
          )) {
        expect(
          await d.c.read(
            hostBidOffersProvider((
              careerId: d.careerId,
              nationId: null,
            )).future,
          ),
          isEmpty,
          reason: 'a bid offered mid-cycle, ${career.inGameDate}',
        );
      }
      await d.step();
    }
    fail('never reached the rollover');
  }

  Future<List<HostBidOffer>> offers(StoryDriver d) {
    d.c.invalidate(hostBidStatusProvider);
    d.c.invalidate(hostBidOffersProvider);
    return d.c.read(
      hostBidOffersProvider((careerId: d.careerId, nationId: null)).future,
    );
  }

  /// A mid-table European side the rotation lets bid for the next European
  /// Championship.
  Nation bidder() {
    final europe =
        storyNations
            .where((n) => n.confederation == Confederation.europe)
            .toList()
          ..sort((a, b) => a.ranking.compareTo(b.ranking));
    return europe
        .skip(12)
        .firstWhere(
          (n) =>
              WorldCupHosts.continentalBidStanding(
                confederation: Confederation.europe,
                cycle: 1,
                seed: seed,
                nations: storyNations,
                nationId: n.id,
              ).eligible &&
              HostingRequirements.meets(
                [
                  for (final v in VenueGenerator.forHost(
                    hostId: n.id,
                    cities: cities[n.id],
                    count: 16,
                  ).take(8))
                    v.capacity,
                ],
                HostingRequirements.continental(n.confederation),
              ),
        );
  }

  test(
    'the bid is offered at the rollover, placed, paid once and decided; '
    'the other one is declined',
    () async {
      final db = storyDb();
      final c = storyContainer(db);
      addTearDown(() async {
        c.dispose();
        await db.close();
      });
      final d = await StoryDriver.start(c, seed, nationId: bidder().id);
      final kinds = await toRollover(d);
      // The rollover was reached as its own event, not stepped past.
      expect(kinds.last, HubEventKind.cycleRollover);

      final open = await offers(d);
      final cont = open
          .where((o) => o.comp == HostBidComp.continental)
          .firstOrNull;
      expect(cont, isNotNull, reason: 'no continental bid at the rollover');
      expect(cont!.editionCycle, 1);
      final service = c.read(hostBidServiceProvider);
      final careers = c.read(careerRepositoryProvider);
      final comp = c.read(competitionRepositoryProvider);

      // Declining the other offer, if there is one: asked no more.
      final wc = open
          .where((o) => o.comp == HostBidComp.worldChampionship)
          .firstOrNull;
      if (wc != null) {
        await service.decline(wc);
        expect(
          (await offers(
            d,
          )).any((o) => o.comp == HostBidComp.worldChampionship),
          isFalse,
        );
      }

      // Placing: pledged, nothing paid yet, and the hub still offers the
      // rollover.
      final levels = cont.maxLevels.clamp(1, 2);
      final before = (await careers.byId(d.careerId))!;
      expect(await service.place(cont, levels), isTrue);
      expect((await careers.byId(d.careerId))!.budget, before.budget);
      expect(
        (await hostBidKinds(
          comp,
          d.careerId,
        )).where((k) => HostBidMarker.decodePledge(k) != null),
        hasLength(1),
      );
      expect((await d.nextEvent()).kind, HubEventKind.cycleRollover);

      // The rollover (the driver confirms it as the screen does) pays the
      // pledge once and decides it.
      final money = await rolloverMoney(c.read(refProvider), before);
      await d.step();
      final rolled = (await careers.byId(d.careerId))!;
      expect(rolled.cyclePointer, 1);
      final kindsAfter = await hostBidKinds(comp, d.careerId);
      final result = kindsAfter
          .map(HostBidding.decodeResult)
          .whereType<Object>()
          .toList();
      expect(result, hasLength(1), reason: 'decided once');
      final won = kindsAfter.any(
        (k) => HostBidding.decodeResult(k)?.won ?? false,
      );
      final cost = levels * HostBidOdds.levelPrice;
      final bonus = won ? HostBidOdds.bonusFor(levels) : 0;
      expect(rolled.budget, money.balance - cost + bonus);
      // Nothing is offered again in the new cycle's first days.
      expect(await offers(d), isEmpty);
    },
    timeout: const Timeout(Duration(minutes: 30)),
  );

  test(
    'a host gets its friendlies through the cycle and the bid offer at '
    'the end',
    () async {
      // A world whose European Championship host may then bid for the next
      // World Championship (the rotation bars it from the next European
      // one, which it has just hosted).
      late int hostSeed;
      late int host;
      for (var s = 1; ; s++) {
        expect(s, lessThan(200), reason: 'no such world');
        final h = WorldCupHosts.continentalHostsFor(
          confederation: Confederation.europe,
          cycle: 0,
          seed: s,
          nations: storyNations,
        ).first;
        // Read as the career managing it sees the world: its cycle-0 hosts
        // decided under the current rules and the stadium bars.
        final world = [
          for (final n in storyNations)
            n.id == h
                ? n.copyWith(
                    hostBids: {
                      HostBidding.managerKey(0): 1,
                      HostBidding.rules2Key(0): 1,
                    },
                  )
                : n,
        ];
        final wc = WorldCupHosts.worldCupBidStanding(
          year: CareerService.worldCupYear(1),
          nations: world,
          seed: s,
          nationId: h,
          managerNationId: h,
        );
        if (wc.eligible &&
            HostingRequirements.meets(
              [
                for (final v in VenueGenerator.forHost(
                  hostId: h,
                  cities: cities[h],
                  count: 16,
                ).take(8))
                  v.capacity,
              ],
              HostingRequirements.worldChampionship,
            )) {
          hostSeed = s;
          host = h;
          break;
        }
      }
      final db = storyDb();
      final c = storyContainer(db);
      addTearDown(() async {
        c.dispose();
        await db.close();
      });
      final d = await StoryDriver.start(c, hostSeed, nationId: host);
      final kinds = await toRollover(d);
      expect(kinds, contains(HubEventKind.friendlies));
      expect(kinds.last, HubEventKind.cycleRollover);
      final open = await offers(d);
      final statuses = await c.read(
        hostBidStatusProvider((careerId: d.careerId, nationId: null)).future,
      );
      // Every bid it may make is on offer now: the window is open for each
      // eligible competition whose grounds are big enough.
      for (final s in statuses) {
        expect(s.windowOpen, isTrue, reason: s.comp.name);
        if (s.rulesOk && s.estateOk && !s.lodged && !s.declined) {
          expect(
            open.any((o) => o.comp == s.comp),
            isTrue,
            reason: s.comp.name,
          );
        }
      }
      expect(
        open.any((o) => o.comp == HostBidComp.worldChampionship),
        isTrue,
        reason: 'the host was offered no World Championship bid',
      );
    },
    timeout: const Timeout(Duration(minutes: 30)),
  );
}
