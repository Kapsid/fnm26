import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/seed/legacy_seed_ranking.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/host_cities.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/venues.dart';

/// Tester feedback (1.0.7): "World Cup host(s) should have more than 8 host
/// cities as the tournament is 48 teams". A 48-team World Championship is
/// staged in up to sixteen grounds: all sixteen when the hosts can credibly
/// offer them, fewer for a smaller host, and never stuck at the old eight
/// when more real cities exist. The host draw itself is untouched.
void main() {
  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList();
  final cities =
      (jsonDecode(File('assets/data/country_cities.json').readAsStringSync())
              as Map)
          .map(
            (k, v) =>
                MapEntry(int.parse(k as String), (v as List).cast<String>()),
          );
  final legacy = [
    for (final n in nations)
      n.copyWith(ranking: legacySeedRanking[n.id] ?? n.ranking),
  ];

  // Every winning bid the game produces over many saves and editions, on
  // the current starting ranking and on the one older careers keep.
  final bids = <String, List<int>>{};
  for (final world in [nations, legacy]) {
    for (var s = 0; s < 120; s++) {
      final seed = s * 7919 + 13;
      for (var year = 2030; year <= 2090; year += 4) {
        final h = WorldCupHosts.hostsFor(
          year: year,
          nations: world,
          seed: seed,
        );
        bids[h.join(',')] = h;
      }
    }
  }
  const count = 16; // VenueGenerator.countForField(48)

  Map<int, List<Venue>> venues(List<int> hosts, VenueRules rules) =>
      VenueGenerator.forHosts(
        hostIds: hosts,
        citiesByHost: {for (final h in hosts) h: cities[h]!},
        count: count,
        rules: rules,
      );

  /// Every real ground [host] can offer a finals.
  int available(int host) => VenueGenerator.forHost(
    hostId: host,
    cities: cities[host],
    count: 1000,
    finals: true,
  ).length;

  test('a 48-team finals is played in sixteen grounds', () {
    expect(VenueGenerator.countForField(48), count);
  });

  test('the draw produces solo and joint hosts to check', () {
    expect(bids.values.where((b) => b.length == 1).length, greaterThan(30));
    expect(bids.values.where((b) => b.length == 2).length, greaterThan(20));
    expect(bids.values.where((b) => b.length == 3).length, greaterThan(10));
  });

  test('every host stages as many distinct grounds as it can, up to 16', () {
    for (final hosts in bids.values) {
      final byHost = venues(hosts, VenueRules.scaled);
      final all = [for (final h in hosts) ...byHost[h]!];
      final offered = hosts.fold<int>(0, (s, h) => s + available(h));
      expect(
        all,
        hasLength(offered < count ? offered : count),
        reason: '$hosts',
      );
      expect(
        {for (final v in all) '${v.city}|${v.stadium}'},
        hasLength(all.length),
        reason: '$hosts: a ground listed twice',
      );
      // Never fewer than before, and never the old eight when there are
      // more real cities.
      final before = venues(
        hosts,
        VenueRules.original,
      ).values.fold<int>(0, (s, v) => s + v.length);
      expect(all.length, greaterThanOrEqualTo(before), reason: '$hosts');
      if (offered > 8) {
        expect(all.length, greaterThan(8), reason: '$hosts');
      }
    }
  });

  test('a solo host of any real size offers ten or more', () {
    for (final hosts in bids.values.where((b) => b.length == 1)) {
      final n = venues(hosts, VenueRules.scaled)[hosts.single]!.length;
      // Only the island nations with a handful of towns stage fewer.
      if (available(hosts.single) >= 10) {
        expect(n, greaterThanOrEqualTo(10), reason: '$hosts');
      }
    }
  });

  test('co-hosts share sixteen by size, each with a fair minimum', () {
    for (final hosts in bids.values.where((b) => b.length > 1)) {
      final byHost = venues(hosts, VenueRules.scaled);
      final total = byHost.values.fold<int>(0, (s, v) => s + v.length);
      expect(total, count, reason: '$hosts');
      final floor = count ~/ (2 * hosts.length);
      for (final h in hosts) {
        expect(
          byHost[h]!.length,
          greaterThanOrEqualTo(floor < 2 ? 2 : floor),
          reason: '$hosts: $h',
        );
      }
    }
  });

  test('the split follows size: the bigger partner stages more', () {
    final shares = VenueGenerator.scaledShares(
      count: 16,
      // The 2026 finals: a giant and two smaller neighbours.
      grounds: [
        (available: 16, seats: 1100000),
        (available: 16, seats: 600000),
        (available: 16, seats: 350000),
      ],
    );
    expect(shares.fold<int>(0, (s, t) => s + t), 16);
    expect(shares[0], greaterThan(shares[1]));
    expect(shares[1], greaterThanOrEqualTo(shares[2]));
    expect(shares[2], greaterThanOrEqualTo(2));
    // A partner short of grounds hands the rest on.
    expect(
      VenueGenerator.scaledShares(
        count: 16,
        grounds: [
          (available: 3, seats: 900000),
          (available: 16, seats: 300000),
        ],
      ),
      [3, 13],
    );
    // Nobody stages grounds it does not have.
    expect(
      VenueGenerator.scaledShares(
        count: 16,
        grounds: [(available: 5, seats: 50000)],
      ),
      [5],
    );
  });

  test('the original rules (a cycle already under way) are unchanged', () {
    // Croatia alone, and a joint Spain-Portugal bid, as every build before
    // this one staged them.
    expect(venues([10], VenueRules.original)[10], hasLength(10));
    final joint = venues([50, 41], VenueRules.original);
    expect([joint[50]!.length, joint[41]!.length], [8, 8]);
    // The default is the original rules.
    final byDefault = VenueGenerator.forHosts(
      hostIds: const [10],
      citiesByHost: {10: cities[10]!},
      count: count,
    );
    expect(byDefault[10], venues([10], VenueRules.original)[10]);
  });

  test('the finals cities never reach the estate a career builds on', () {
    for (final e in finalsHostCities.entries) {
      final estate = VenueGenerator.forHost(
        hostId: e.key,
        cities: cities[e.key],
        count: 16,
      );
      for (final city in e.value) {
        expect(
          estate.map((v) => v.city),
          isNot(contains(city)),
          reason: '${e.key}: $city',
        );
      }
      // And none of them repeats a city the nation already has.
      final known = {...cities[e.key]!, ...?extraHostCities[e.key]};
      for (final city in e.value) {
        expect(known, isNot(contains(city)), reason: '${e.key}: $city');
      }
    }
  });

  test('a manager host keeps its estate and adds the finals cities', () {
    final estate = VenueGenerator.forHost(
      hostId: 142,
      cities: cities[142],
      count: 16,
    );
    final byHost = VenueGenerator.forHosts(
      hostIds: const [142],
      citiesByHost: {142: cities[142]!},
      count: count,
      estates: {142: estate},
      rules: VenueRules.scaled,
    );
    expect(byHost[142]!.take(estate.length), estate);
    expect(byHost[142]!.length, greaterThan(estate.length));
  });
}
