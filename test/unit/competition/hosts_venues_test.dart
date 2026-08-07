import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/venues.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('WorldCupHosts.hostFromConfederation', () {
    // 20 nations in one confederation, ranking 1 (best) … 20.
    final nations = [
      for (var r = 1; r <= 20; r++)
        nation(id: r, confederation: Confederation.europe, ranking: r),
    ];

    test('is deterministic for a given seed', () {
      int host(int seed) => WorldCupHosts.hostFromConfederation(
            confederation: Confederation.europe,
            nations: nations,
            seed: seed,
          );
      expect(host(1234), host(1234));
    });

    test('the host favours strong nations but the race is open', () {
      var topTwelve = 0;
      var topThree = 0;
      for (var seed = 0; seed < 400; seed++) {
        final host = WorldCupHosts.hostFromConfederation(
          confederation: Confederation.europe,
          nations: nations,
          seed: seed,
        );
        // ids equal ranking here, so id <= k means a top-k nation.
        if (host <= 12) topTwelve++;
        if (host <= 3) topThree++;
      }
      // The shortlist is the strongest twelve, and an outsider standing last on
      // the ballot almost never wins — but "almost" is the point of it.
      expect(topTwelve / 400, greaterThan(0.95));
      // …the best are favoured, but it's an open race — not a lock.
      expect(topThree / 400, greaterThan(0.25));
      expect(topThree / 400, lessThan(0.6));
    });
  });

  group('WorldCupHosts.hostsFor co-hosting', () {
    final nations = [
      for (var r = 1; r <= 20; r++)
        nation(id: r, confederation: Confederation.europe, ranking: r),
    ];
    // The FIRST edition bars nobody (no previous host to exclude), so this
    // all-European pool is fully eligible — later editions bar the previous
    // host's confederation, which an all-European pool couldn't satisfy.
    const euroYear = 2030;

    /// The share of editions with 1 host, 2 hosts and 3 hosts over many seeds.
    ({double solo, double joint, double triple}) rates() {
      var solo = 0;
      var joint = 0;
      var triple = 0;
      const runs = 600;
      for (var seed = 0; seed < runs; seed++) {
        final hosts = WorldCupHosts.hostsFor(
          year: euroYear,
          nations: nations,
          seed: seed,
        );
        if (hosts.length == 1) solo++;
        if (hosts.length == 2) joint++;
        if (hosts.length >= 3) triple++;
      }
      return (solo: solo / runs, joint: joint / runs, triple: triple / runs);
    }

    test('a solo host is the normal case', () {
      // Regression: one roll gave ~65% co-hosted and ~30% triple-hosted, while
      // the doc comment claimed "co-hosting is the exception, not the rule".
      // A joint bid is now a regular feature of the calendar rather than a
      // once-a-career curiosity, but a single host still wins most editions.
      final r = rates();
      expect(r.solo, greaterThan(0.55), reason: 'most editions have one host');
    });

    test('joint bids happen, but are a talking point', () {
      final r = rates();
      expect(r.joint, greaterThan(0.10));
      expect(r.joint, lessThan(0.40));
    });

    test('a triple bid is rare', () {
      final r = rates();
      expect(r.triple, lessThan(0.15));
      expect(
        r.triple,
        lessThan(r.joint),
        reason: 'sharing three ways is rarer than sharing two',
      );
    });

    test('every host is a real, distinct nation of the confederation', () {
      final ids = nations.map((n) => n.id).toSet();
      for (var seed = 0; seed < 50; seed++) {
        final hosts = WorldCupHosts.hostsFor(
          year: euroYear,
          nations: nations,
          seed: seed,
        );
        expect(hosts, isNotEmpty);
        expect(hosts.toSet(), hasLength(hosts.length), reason: 'no duplicates');
        expect(hosts.toSet().difference(ids), isEmpty);
      }
    });

    test('is deterministic for a given seed', () {
      expect(
        WorldCupHosts.hostsFor(year: euroYear, nations: nations, seed: 99),
        WorldCupHosts.hostsFor(year: euroYear, nations: nations, seed: 99),
      );
    });
  });

  group('WorldCupHosts.hostBids', () {
    final nations = [
      for (var r = 1; r <= 20; r++)
        nation(id: r, confederation: Confederation.europe, ranking: r),
    ];
    // The first edition bars nobody, so this all-European pool is eligible.
    const euroYear = 2030;

    List<HostBid> bids(int seed) => WorldCupHosts.worldCupBids(
          year: euroYear,
          nations: nations,
          seed: seed,
        );

    test('the winner is always one of the bids on the table', () {
      // The whole point of (b): joint candidatures are visible BEFORE the
      // envelope opens, because the draw picks a bid rather than a nation and
      // then inventing partners for it afterwards.
      for (var seed = 0; seed < 200; seed++) {
        final table = bids(seed);
        final winner = WorldCupHosts.hostsFor(
          year: euroYear,
          nations: nations,
          seed: seed,
        );
        expect(
          table.any(
            (b) =>
                b.length == winner.length &&
                b.every(winner.contains),
          ),
          isTrue,
          reason: 'seed $seed: the winning bid must be a listed candidature',
        );
      }
    });

    test('bids partition the shortlist — nobody bids twice', () {
      var outsiders = 0;
      for (var seed = 0; seed < 50; seed++) {
        final table = bids(seed);
        final flat = table.expand((b) => b).toList();
        expect(flat.toSet(), hasLength(flat.length), reason: 'seed $seed');
        // The shortlist is the strongest twelve; anything below it is the one
        // outsider, which stands alone and stands last.
        final outside = flat.where((id) => id > 12).toList();
        expect(outside.length, lessThanOrEqualTo(1), reason: 'seed $seed');
        if (outside.isNotEmpty) {
          outsiders++;
          expect(table.last, [outside.single], reason: 'seed $seed');
        }
      }
      // Rare, but it does happen — that is the whole point of the outsider.
      expect(outsiders, greaterThan(0));
      expect(outsiders, lessThan(25));
    });

    test('some bids are joint, most are not', () {
      var joint = 0;
      var total = 0;
      for (var seed = 0; seed < 200; seed++) {
        for (final b in bids(seed)) {
          total++;
          if (b.length > 1) joint++;
        }
      }
      expect(joint, greaterThan(0), reason: 'joint bids must exist to be shown');
      expect(joint / total, lessThan(0.3), reason: 'and stay the exception');
    });

    test('joint bidders are ranking neighbours', () {
      // A joint bid is comparable neighbours, not a giant adopting a minnow.
      for (var seed = 0; seed < 60; seed++) {
        for (final b in bids(seed).where((b) => b.length > 1)) {
          final sorted = [...b]..sort();
          for (var i = 1; i < sorted.length; i++) {
            expect(sorted[i] - sorted[i - 1], 1, reason: 'seed $seed: $b');
          }
        }
      }
    });

    test('a primary host is always the first name on its bid', () {
      for (var seed = 0; seed < 50; seed++) {
        final winner =
            WorldCupHosts.hostsFor(year: euroYear, nations: nations, seed: seed);
        expect(
          WorldCupHosts.hostFor(year: euroYear, nations: nations, seed: seed),
          winner.first,
        );
      }
    });

    test('is deterministic for a given seed', () {
      expect(bids(7).toString(), bids(7).toString());
    });
  });

  group('VenueGenerator.forHost', () {
    test('is deterministic and yields the requested count', () {
      final a = VenueGenerator.forHost(hostId: 42);
      final b = VenueGenerator.forHost(hostId: 42);
      expect(a.map((v) => v.stadium), b.map((v) => v.stadium));
      expect(a, hasLength(8));
    });

    test('co-hosts each get grounds, sharing the tournament', () {
      // Regression: asking one host for all 8 exhausted its city list (nations
      // have at most 8), so a joint tournament showed only the first country's
      // stadiums.
      const cities = {
        1: ['Aville', 'Bville', 'Cville', 'Dville'],
        2: ['Xton', 'Yton', 'Zton', 'Wton'],
      };
      final byHost = VenueGenerator.forHosts(
        hostIds: const [1, 2],
        citiesByHost: cities,
      );
      expect(byHost.keys, containsAll([1, 2]));
      expect(byHost[1], isNotEmpty);
      expect(byHost[2], isNotEmpty, reason: 'the co-host stages games too');
      // Each host's grounds are in its own cities.
      expect(byHost[1]!.every((v) => cities[1]!.contains(v.city)), isTrue);
      expect(byHost[2]!.every((v) => cities[2]!.contains(v.city)), isTrue);
    });

    test('the venue budget is split, not spent twice', () {
      final byHost = VenueGenerator.forHosts(
        hostIds: const [1, 2],
        citiesByHost: const {
          1: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'],
          2: ['P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W'],
        },
      );
      final total = byHost.values.fold<int>(0, (s, v) => s + v.length);
      expect(total, 8, reason: 'a tournament has one venue budget');
      expect(byHost[1], hasLength(4));
      expect(byHost[2], hasLength(4));
    });

    test('an odd budget favours the primary host', () {
      final byHost = VenueGenerator.forHosts(
        hostIds: const [1, 2, 3],
        citiesByHost: const {
          1: ['A', 'B', 'C'],
          2: ['P', 'Q', 'R'],
          3: ['X', 'Y', 'Z'],
        },
      );
      expect(byHost.values.fold<int>(0, (s, v) => s + v.length), 8);
      expect(byHost[1], hasLength(3));
      expect(byHost[2], hasLength(3));
      expect(byHost[3], hasLength(2), reason: 'the remainder goes to the top');
    });

    test('a solo host still takes the whole tournament', () {
      final byHost = VenueGenerator.forHosts(hostIds: const [1]);
      expect(byHost[1], hasLength(8));
    });

    test('no hosts, no venues', () {
      expect(VenueGenerator.forHosts(hostIds: const []), isEmpty);
    });

    test('venues are the biggest cities, largest first, with real capacities',
        () {
      final venues = VenueGenerator.forHost(hostId: 7, count: 6);
      // Ordered biggest-first.
      for (var i = 1; i < venues.length; i++) {
        expect(
          venues[i].capacity,
          lessThanOrEqualTo(venues[i - 1].capacity),
        );
      }
      expect(venues.every((v) => v.capacity >= 32000 && v.capacity <= 85000),
          isTrue);
      expect(venues.map((v) => v.city).toSet(), hasLength(venues.length));
    });
  });

  group('WorldCupHosts.continentalQualifiers', () {
    final nations = [
      for (var r = 1; r <= 40; r++)
        nation(id: r, confederation: Confederation.europe, ranking: r),
      // Another continent, to prove the field is confederation-scoped.
      for (var r = 41; r <= 50; r++)
        nation(id: r, confederation: Confederation.asia, ranking: r),
    ];

    List<int> hosts(int cycle) => WorldCupHosts.continentalHostsFor(
          confederation: Confederation.europe,
          cycle: cycle,
          seed: 4242,
          nations: nations,
        );

    List<int> field(int cycle) => [
          for (final n in WorldCupHosts.continentalQualifiers(
            confederation: Confederation.europe,
            cycle: cycle,
            seed: 4242,
            nations: nations,
          ))
            n.id,
        ];

    test('excludes EVERY host, co-hosts included', () {
      // The bug this pins: the draw ceremony dropped only the primary host, so
      // on a co-hosted edition it drew a field the calendar had never drawn.
      // Co-hosting fires on roughly a third of editions, so a run of cycles is
      // certain to contain one.
      var sawCoHosted = false;
      for (var cycle = 0; cycle < 40; cycle++) {
        final h = hosts(cycle);
        if (h.length > 1) sawCoHosted = true;
        final f = field(cycle);
        for (final id in h) {
          expect(f, isNot(contains(id)),
              reason: 'host $id still in the draw at cycle $cycle');
        }
        expect(f.length, 40 - h.length);
      }
      expect(sawCoHosted, isTrue,
          reason: 'no co-hosted edition in 40 cycles — sample is not testing '
              'the case the bug lived in');
    });

    test('is confederation-scoped and deterministic', () {
      expect(field(3), field(3));
      expect(field(3).every((id) => id <= 40), isTrue);
    });
  });
}
