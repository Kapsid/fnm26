import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/venues.dart';

import '../../helpers/legacy_hosts.dart';

final List<Nation> _nations =
    (jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

final Map<int, List<String>> _cities = {
  for (final e
      in (jsonDecode(File('assets/data/country_cities.json').readAsStringSync())
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (e.value! as List).cast<String>(),
};

/// The static stadium list the career seam returns today.
List<Venue> _stadiums(int id) =>
    VenueGenerator.forHost(hostId: id, cities: _cities[id], count: 16);

/// [nations] with [nationId] carrying a bid for [key] at [permille].
List<Nation> _withBid(
  List<Nation> nations,
  int nationId,
  String key,
  int permille,
) => [
  for (final n in nations)
    n.id == nationId ? n.copyWith(hostBids: {key: permille}) : n,
];

int _wcYear(int cycle) => 2030 + 4 * cycle;

/// The European nation ranked [place]th within Europe (1 = strongest).
Nation _european(int place) =>
    (_nations.where((n) => n.confederation == Confederation.europe).toList()
      ..sort((a, b) => a.ranking.compareTo(b.ranking)))[place - 1];

void main() {
  group('the chance model', () {
    test('rises with every level, and never past the ceiling', () {
      for (final size in [0.0, 0.05, 0.3, 0.5, 1.0]) {
        for (final today in [0.0, 0.08, 0.18]) {
          var last = -1.0;
          for (var lv = 0; lv <= HostBidOdds.maxLevels; lv++) {
            final q = HostBidOdds.quote(size: size, today: today, levels: lv);
            expect(q.total, greaterThan(last), reason: 's=$size t=$today');
            expect(q.total, lessThanOrEqualTo(q.cap + 1e-9));
            expect(q.base, greaterThanOrEqualTo(today - 1e-9));
            expect(q.total, closeTo(q.base + q.invest, 1e-9));
            last = q.total;
          }
        }
      }
    });

    test('diminishing returns: each level adds less than the one before', () {
      double add(int lv) =>
          HostBidOdds.quote(size: 0.5, today: 0, levels: lv).total -
          HostBidOdds.quote(size: 0.5, today: 0, levels: lv - 1).total;
      for (var lv = 2; lv <= HostBidOdds.maxLevels; lv++) {
        expect(add(lv), lessThan(add(lv - 1)));
      }
    });

    test('nobody is ever near certain; the biggest stays under 66%', () {
      final top = HostBidOdds.quote(
        size: 1,
        today: 0.2,
        levels: HostBidOdds.maxLevels,
      );
      expect(top.total, lessThan(0.66));
      expect(top.cap, closeTo(0.65, 1e-9));
    });

    test('a small nation cannot get far; a big one gets further', () {
      final andorra = HostBidOdds.sizeScore(_stadiums(2));
      final germany = HostBidOdds.sizeScore(_stadiums(20));
      final czechia = HostBidOdds.sizeScore(_stadiums(12));
      expect(andorra, lessThan(0.05));
      expect(germany, greaterThan(0.9));
      expect(czechia, inExclusiveRange(andorra, germany));
      final small = HostBidOdds.quote(
        size: andorra,
        today: 0,
        levels: HostBidOdds.maxLevels,
      );
      final big = HostBidOdds.quote(
        size: germany,
        today: 0,
        levels: HostBidOdds.maxLevels,
      );
      expect(small.total, lessThan(0.13));
      expect(big.total, greaterThan(small.total * 3));
    });

    test('the grant: the stake back and half again, at least a level', () {
      expect(HostBidOdds.bonusFor(1), 2000000);
      expect(HostBidOdds.bonusFor(5), 7000000);
      expect(HostBidOdds.bonusFor(10), 15000000);
      for (var lv = 1; lv <= HostBidOdds.maxLevels; lv++) {
        final stake = lv * HostBidOdds.levelPrice;
        expect(HostBidOdds.bonusFor(lv), greaterThan(stake));
        expect(HostBidOdds.bonusFor(lv), lessThanOrEqualTo(stake * 2));
      }
    });
  });

  group('no bid: every host is the one drawn today', () {
    test('World Championship, every edition, 60 worlds', () {
      for (var seed = 1; seed <= 60; seed++) {
        for (var c = 0; c <= 5; c++) {
          final y = _wcYear(c);
          expect(
            WorldCupHosts.hostsFor(year: y, nations: _nations, seed: seed),
            LegacyWorldCupHosts.hostsFor(
              year: y,
              nations: _nations,
              seed: seed,
            ),
            reason: 'seed $seed $y',
          );
          expect(
            WorldCupHosts.worldCupBids(year: y, nations: _nations, seed: seed),
            LegacyWorldCupHosts.worldCupBids(
              year: y,
              nations: _nations,
              seed: seed,
            ),
          );
        }
      }
    });

    test('every continental championship, 60 worlds', () {
      for (var seed = 1; seed <= 60; seed++) {
        for (final conf in Confederation.values) {
          for (var c = 0; c <= 5; c++) {
            expect(
              WorldCupHosts.continentalHostsFor(
                confederation: conf,
                cycle: c,
                seed: seed,
                nations: _nations,
              ),
              LegacyWorldCupHosts.continentalHostsFor(
                confederation: conf,
                cycle: c,
                seed: seed,
                nations: _nations,
              ),
              reason: 'seed $seed $conf $c',
            );
            expect(
              WorldCupHosts.continentalBids(
                confederation: conf,
                cycle: c,
                seed: seed,
                nations: _nations,
              ),
              LegacyWorldCupHosts.continentalBids(
                confederation: conf,
                cycle: c,
                seed: seed,
                nations: _nations,
              ),
            );
          }
        }
      }
    });
  });

  group('who may bid for the World Championship', () {
    test('never the last host confederation, never a recent host', () {
      for (var seed = 1; seed <= 25; seed++) {
        for (var c = 1; c <= 4; c++) {
          final y = _wcYear(c);
          final prior = [
            for (var k = 1; k <= 3 && c - k >= 0; k++)
              LegacyWorldCupHosts.hostsFor(
                year: _wcYear(c - k),
                nations: _nations,
                seed: seed,
              ),
          ];
          final barred = _nations
              .firstWhere((n) => n.id == prior.first.first)
              .confederation;
          final recent = {for (final h in prior) ...h};
          for (final n in _nations) {
            final standing = WorldCupHosts.worldCupBidStanding(
              year: y,
              nations: _nations,
              seed: seed,
              nationId: n.id,
            );
            expect(
              standing.eligible,
              n.confederation != barred && !recent.contains(n.id),
              reason: 'seed $seed $y ${n.name}',
            );
            if (!standing.eligible) expect(standing.today, 0);
          }
        }
      }
    });
  });

  group('a lodged bid', () {
    final bidder = _european(14);
    final contKey = HostBidding.nationKey(HostBidComp.continental, 1);

    test('wins about as often as it promised, and only ever helps', () {
      const permille = 300;
      final world = _withBid(_nations, bidder.id, contKey, permille);
      var eligible = 0;
      var wins = 0;
      for (var seed = 1; seed <= 1200; seed++) {
        final standing = WorldCupHosts.continentalBidStanding(
          confederation: Confederation.europe,
          cycle: 1,
          seed: seed,
          nations: _nations,
          nationId: bidder.id,
        );
        final before = LegacyWorldCupHosts.continentalHostsFor(
          confederation: Confederation.europe,
          cycle: 1,
          seed: seed,
          nations: _nations,
        );
        final after = WorldCupHosts.continentalHostsFor(
          confederation: Confederation.europe,
          cycle: 1,
          seed: seed,
          nations: world,
        );
        if (!standing.eligible) {
          expect(after, before, reason: 'an ineligible bid changes nothing');
          continue;
        }
        eligible++;
        if (after.contains(bidder.id)) wins++;
        // Monotone: a world it already won stays won, and a world it loses
        // has the very host it would have had without bidding.
        if (before.contains(bidder.id)) expect(after, before);
        if (!after.contains(bidder.id)) expect(after, before);
        // The ballot the ceremony shows carries the bidder.
        final ballot = WorldCupHosts.continentalBids(
          confederation: Confederation.europe,
          cycle: 1,
          seed: seed,
          nations: world,
        );
        expect(ballot.any((b) => b.contains(bidder.id)), isTrue);
      }
      expect(eligible, greaterThan(800));
      expect(wins / eligible, closeTo(permille / 1000, 0.05));
    });

    test('it never touches an edition already drawn (the cycle before)', () {
      for (var seed = 1; seed <= 200; seed++) {
        final world = _withBid(_nations, bidder.id, contKey, 600);
        expect(
          WorldCupHosts.continentalHostsFor(
            confederation: Confederation.europe,
            cycle: 0,
            seed: seed,
            nations: world,
          ),
          LegacyWorldCupHosts.continentalHostsFor(
            confederation: Confederation.europe,
            cycle: 0,
            seed: seed,
            nations: _nations,
          ),
        );
        final wcWorld = _withBid(
          _nations,
          bidder.id,
          HostBidding.nationKey(HostBidComp.worldChampionship, 1),
          600,
        );
        expect(
          WorldCupHosts.hostsFor(
            year: _wcYear(0),
            nations: wcWorld,
            seed: seed,
          ),
          LegacyWorldCupHosts.hostsFor(
            year: _wcYear(0),
            nations: _nations,
            seed: seed,
          ),
        );
      }
    });

    test('a winner is barred from the next three editions like any host', () {
      var checked = 0;
      for (var seed = 1; seed <= 300 && checked < 20; seed++) {
        final world = _withBid(_nations, bidder.id, contKey, 650);
        final won = WorldCupHosts.continentalHostsFor(
          confederation: Confederation.europe,
          cycle: 1,
          seed: seed,
          nations: world,
        );
        if (!won.contains(bidder.id)) continue;
        checked++;
        for (var c = 2; c <= 4; c++) {
          expect(
            WorldCupHosts.continentalBidStanding(
              confederation: Confederation.europe,
              cycle: c,
              seed: seed,
              nations: world,
              nationId: bidder.id,
            ).eligible,
            isFalse,
            reason: 'seed $seed cycle $c',
          );
        }
      }
      expect(checked, 20);
    });

    test('a World Championship bid works the same way', () {
      final wcKey = HostBidding.nationKey(HostBidComp.worldChampionship, 2);
      final world = _withBid(_nations, bidder.id, wcKey, 250);
      var eligible = 0;
      var wins = 0;
      for (var seed = 1; seed <= 800; seed++) {
        final y = _wcYear(2);
        final standing = WorldCupHosts.worldCupBidStanding(
          year: y,
          nations: _nations,
          seed: seed,
          nationId: bidder.id,
        );
        final before = LegacyWorldCupHosts.hostsFor(
          year: y,
          nations: _nations,
          seed: seed,
        );
        final after = WorldCupHosts.hostsFor(
          year: y,
          nations: world,
          seed: seed,
        );
        if (!standing.eligible) {
          expect(after, before);
          continue;
        }
        eligible++;
        if (after.contains(bidder.id)) wins++;
        if (!after.contains(bidder.id)) expect(after, before);
      }
      expect(eligible, greaterThan(200));
      expect(wins / eligible, closeTo(0.25, 0.06));
    });
  });

  group('the markers', () {
    test('a bid round-trips, and anything else reads as no bid', () {
      const m = HostBidMarker(
        comp: HostBidComp.worldChampionship,
        editionCycle: 3,
        nationId: 20,
        levels: 4,
        permille: 412,
      );
      final back = HostBidMarker.decode(m.encode())!;
      expect(back.comp, m.comp);
      expect(back.editionCycle, 3);
      expect(back.nationId, 20);
      expect(back.levels, 4);
      expect(back.permille, 412);
      expect(back.invested, 4 * HostBidOdds.levelPrice);
      expect(back.nationKey, 'wc:3');
      for (final other in [
        'budgetSet',
        'campaign:transplant',
        'dormantNation:212',
        'hostBid:wc:3:20:4',
        'hostBid:xx:3:20:4:412',
        'hostBid:wc:3:20:4:1000',
        HostBidding.declinedKind(HostBidComp.continental, 2),
        HostBidding.resultKind(
          HostBidComp.continental,
          2,
          won: true,
          bonus: 7000000,
        ),
      ]) {
        expect(HostBidMarker.decode(other), isNull, reason: other);
      }
    });

    test('the decline and result markers never match the bid prefix', () {
      expect(
        HostBidding.declinedKind(
          HostBidComp.continental,
          1,
        ).startsWith(HostBidMarker.prefix),
        isFalse,
      );
      final r = HostBidding.resultKind(
        HostBidComp.worldChampionship,
        2,
        won: false,
        bonus: 0,
      );
      expect(r.startsWith(HostBidMarker.prefix), isFalse);
      final back = HostBidding.decodeResult(r)!;
      expect(back.comp, HostBidComp.worldChampionship);
      expect(back.editionCycle, 2);
      expect(back.won, isFalse);
      expect(back.bonus, 0);
    });
  });
}
