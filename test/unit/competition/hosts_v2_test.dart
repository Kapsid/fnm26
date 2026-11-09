import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/host_stadium_rules.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/national_stadium_data.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';

// The host rules v2 (stadium bars) at work on the host draw and the venues:
// only an edition carrying `HostBidding.rules2Kind` follows them, and every
// other edition is decided exactly as before.

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

final Map<int, Nation> _byId = {for (final n in _nations) n.id: n};

/// The cycles every check walks.
const int _cycles = 6;

int _year(int cycle) => 2030 + 4 * cycle;

/// The world as a career managing Norway sees it: decided under the current
/// rules from cycle 0 (the rules marker), and under the stadium bars from
/// [v2From] on (none when null). Norway did not bid, so it never hosts.
List<Nation> _world({int? v2From, bool rulesMarker = true}) => [
  for (final n in _nations)
    if (n.code == 'NOR')
      n.copyWith(
        hostBids: {
          if (rulesMarker) HostBidding.managerKey(0): 1,
          if (v2From != null)
            for (var c = v2From; c < _cycles + 2; c++)
              HostBidding.rules2Key(c): 1,
        },
      )
    else
      n,
];

final List<Nation> _v2World = _world(v2From: 0);

List<int> _seats(int id) =>
    HostStadiumRules.qualifyingSeats(nationId: id, editionCycle: 0);

bool _meetsAlone(int id, HostBar bar) =>
    HostStadiumRules.meets(_seats(id), bar);

/// Every race of a cycle: the World Championship, then each confederation's
/// championship.
typedef _Race = ({
  String label,
  HostBidComp comp,
  HostBar bar,
  List<int> hosts,
  List<HostBid> bids,
  HostGroundPlan? plan,
  int count,
});

List<_Race> _races(List<Nation> world, int seed, int cycle) => [
  (
    label: 'wc $cycle',
    comp: HostBidComp.worldChampionship,
    bar: HostStadiumRules.worldChampionship,
    hosts: WorldCupHosts.hostsFor(
      year: _year(cycle),
      nations: world,
      seed: seed,
    ),
    bids: WorldCupHosts.worldCupBids(
      year: _year(cycle),
      nations: world,
      seed: seed,
    ),
    plan: WorldCupHosts.worldCupGroundPlan(
      year: _year(cycle),
      nations: world,
      seed: seed,
    ),
    count: VenueGenerator.countForField(48),
  ),
  for (final conf in Confederation.values)
    (
      label: '${conf.name} $cycle',
      comp: HostBidComp.continental,
      bar: HostStadiumRules.continental(conf),
      hosts: WorldCupHosts.continentalHostsFor(
        confederation: conf,
        cycle: cycle,
        seed: seed,
        nations: world,
      ),
      bids: WorldCupHosts.continentalBids(
        confederation: conf,
        cycle: cycle,
        seed: seed,
        nations: world,
      ),
      plan: WorldCupHosts.continentalGroundPlan(
        confederation: conf,
        cycle: cycle,
        seed: seed,
        nations: world,
      ),
      count: VenueGenerator.countForField(
        ContinentalCups.byConfederation[conf]?.size ?? 0,
      ),
    ),
];

Map<int, List<Venue>> _venues(
  List<int> hosts,
  HostGroundPlan plan,
  int count, {
  Map<int, List<int>>? planned,
}) => VenueGenerator.forHosts(
  hostIds: hosts,
  citiesByHost: {
    for (final h in hosts)
      if (_cities[h] != null) h: _cities[h]!,
  },
  count: count,
  rules: VenueRules.scaled,
  qualifyingOnly: true,
  minSeats: plan.minSeats,
  planned: planned ?? plan.planned,
);

bool _broken(HostGroundPlan plan) => plan.promised.entries.any(
  (e) => (plan.planned[e.key]?.length ?? 0) < e.value.length,
);

void main() {
  test('no v2 edition is hosted below its bar for seeds 1..40', () {
    var joint = 0;
    var promised = 0;
    for (var seed = 1; seed <= 40; seed++) {
      for (var c = 0; c < _cycles; c++) {
        for (final r in _races(_v2World, seed, c)) {
          final why = 'seed $seed ${r.label} hosts ${r.hosts}';
          expect(r.hosts, isNotEmpty, reason: why);
          final plan = r.plan;
          // Decided under the bars: no fallback to the old draw.
          expect(plan, isNotNull, reason: why);
          expect(plan!.minSeats, r.bar.otherSeats, reason: why);
          expect(r.hosts.length, lessThanOrEqualTo(3), reason: why);
          expect(r.hosts, isNot(contains(_code('NOR').id)), reason: why);
          final seats = [
            for (final h in r.hosts) ..._seats(h),
            for (final p in plan.promised.values) ...p,
          ];
          expect(HostStadiumRules.meets(seats, r.bar), isTrue, reason: why);
          for (final h in plan.promised.keys) {
            expect(r.hosts, contains(h), reason: why);
          }
          if (r.hosts.length > 1) {
            joint++;
            expect(plan.promised, isEmpty, reason: why);
            final conf = _byId[r.hosts.first]!.confederation;
            int biggest(int h) =>
                _seats(h).fold<int>(0, (a, b) => a > b ? a : b);
            for (final h in r.hosts) {
              expect(_byId[h]!.confederation, conf, reason: why);
              expect(
                _seats(h).where((s) => s >= r.bar.otherSeats).length,
                greaterThanOrEqualTo(HostStadiumRules.minGroundsPerCoHost),
                reason: '$why: co-host $h brings too few grounds',
              );
              // The primary holds the final ground.
              expect(
                biggest(r.hosts.first),
                greaterThanOrEqualTo(biggest(h)),
                reason: why,
              );
            }
          }
          if (plan.promised.isNotEmpty) {
            promised++;
            final h = r.hosts.single;
            expect(_meetsAlone(h, r.bar), isFalse, reason: why);
            expect(
              _byId[h]!.ranking,
              lessThanOrEqualTo(HostStadiumRules.plannedRankCutoff),
              reason: why,
            );
            expect(
              plan.promised[h]!.length,
              lessThanOrEqualTo(HostStadiumRules.plannedCap(r.comp)),
              reason: why,
            );
          }
        }
      }
    }
    // Not vacuous: both ways of closing a gap turn up.
    expect(joint, greaterThan(0));
    expect(promised, greaterThan(0));
  });

  test("an unmarked edition picks exactly today's hosts for seeds 1..40", () {
    // The bars start at cycle 3: every cycle before decides as it did.
    final today = _world();
    final later = _world(v2From: 3);
    // A v2 key with no rules marker (no current-rules edition at all) reads
    // as the legacy draw throughout.
    final legacy = _world(v2From: 0, rulesMarker: false);
    for (var seed = 1; seed <= 40; seed++) {
      for (var c = 0; c < _cycles; c++) {
        final now = _races(today, seed, c);
        final legacyNow = _races(_nations, seed, c);
        final legacyMarked = _races(legacy, seed, c);
        for (var i = 0; i < now.length; i++) {
          final why = 'seed $seed ${now[i].label}';
          expect(now[i].plan, isNull, reason: why);
          expect(legacyMarked[i].plan, isNull, reason: why);
          expect(legacyMarked[i].hosts, legacyNow[i].hosts, reason: why);
          expect(legacyMarked[i].bids, legacyNow[i].bids, reason: why);
        }
        if (c >= 3) continue;
        final then = _races(later, seed, c);
        for (var i = 0; i < now.length; i++) {
          final why = 'seed $seed ${now[i].label}';
          expect(then[i].hosts, now[i].hosts, reason: why);
          expect(then[i].bids, now[i].bids, reason: why);
          expect(then[i].plan, isNull, reason: why);
        }
      }
    }
  });

  test('a small nation hosts only inside a joint bid', () {
    var smallInJoint = 0;
    for (var seed = 1; seed <= 40; seed++) {
      for (var c = 0; c < _cycles; c++) {
        for (final r in _races(_v2World, seed, c)) {
          final why = 'seed $seed ${r.label}';
          // On the ballot: a nation short of the bar stands alone only with
          // planned grounds, which only the top 30 may count.
          for (final b in r.bids) {
            if (b.length != 1 || _meetsAlone(b.single, r.bar)) continue;
            expect(
              _byId[b.single]!.ranking,
              lessThanOrEqualTo(HostStadiumRules.plannedRankCutoff),
              reason: '$why: bid $b',
            );
          }
          // Hosting: a nation that is short and may not plan is a co-host.
          for (final h in r.hosts) {
            if (_meetsAlone(h, r.bar)) continue;
            if (r.plan!.promised.containsKey(h)) continue;
            expect(r.hosts.length, greaterThan(1), reason: '$why: host $h');
            smallInJoint++;
          }
        }
      }
    }
    expect(smallInJoint, greaterThan(0));

    // A single, hand-made world: two small neighbours that make the bar only
    // together, and nobody else of their confederation.
    final a = Nation(
      id: _code('NED').id,
      name: 'NED',
      code: 'NED',
      confederation: Confederation.europe,
      ranking: 40,
    );
    final b = Nation(
      id: _code('BEL').id,
      name: 'BEL',
      code: 'BEL',
      confederation: Confederation.europe,
      ranking: 41,
    );
    final euro = HostStadiumRules.continental(Confederation.europe);
    expect(_meetsAlone(a.id, euro), isFalse);
    expect(_meetsAlone(b.id, euro), isFalse);
    expect(
      HostStadiumRules.meets([..._seats(a.id), ..._seats(b.id)], euro),
      isTrue,
    );
    final manager = _code('NOR').copyWith(
      ranking: 200,
      hostBids: {HostBidding.managerKey(0): 1, HostBidding.rules2Key(0): 1},
    );
    for (var seed = 1; seed <= 40; seed++) {
      final hosts = WorldCupHosts.continentalHostsFor(
        confederation: Confederation.europe,
        cycle: 0,
        seed: seed,
        nations: [a, b, manager],
      );
      expect(hosts.toSet(), {a.id, b.id}, reason: 'seed $seed');
    }
  });

  test(
    'v2 venues are all qualifying and number 10 to 16 for the World '
    'Championship',
    () {
      for (var seed = 1; seed <= 40; seed++) {
        for (var c = 0; c < _cycles; c++) {
          for (final r in _races(_v2World, seed, c)) {
            final why = 'seed $seed ${r.label} hosts ${r.hosts}';
            final plan = r.plan!;
            final byHost = _venues(r.hosts, plan, r.count);
            var total = 0;
            for (final h in r.hosts) {
              final seed = nationalStadiumData[h] ?? const <(String, int)>[];
              final planned = [...?plan.planned[h]];
              for (final v in byHost[h] ?? const <Venue>[]) {
                total++;
                expect(
                  v.capacity,
                  greaterThanOrEqualTo(r.bar.otherSeats),
                  reason: '$why: $v',
                );
                final isSeed = seed.any(
                  (g) => g.$1 == v.city && g.$2 == v.capacity,
                );
                final isPlanned =
                    v.stadium == NationalStadiums.newStadiumName(v.city) &&
                    planned.remove(v.capacity);
                expect(isSeed || isPlanned, isTrue, reason: '$why: $v');
              }
            }
            expect(total, lessThanOrEqualTo(r.count), reason: why);
            final floor = r.bar.grounds - (_broken(plan) ? 1 : 0);
            expect(total, greaterThanOrEqualTo(floor), reason: why);
            if (r.comp == HostBidComp.worldChampionship && !_broken(plan)) {
              expect(total, inInclusiveRange(10, 16), reason: why);
            }
          }
        }
      }
    },
  );

  test(
    'an AI broken promise plays in one fewer ground and bars the next two '
    'editions',
    () {
      var found = 0;
      var kept = 0;
      for (var seed = 1; seed <= 400 && found < 3; seed++) {
        for (var c = 0; c + 2 < _cycles; c++) {
          final races = _races(_v2World, seed, c);
          for (var i = 0; i < races.length; i++) {
            final r = races[i];
            final plan = r.plan!;
            for (final MapEntry(key: h, value: promise)
                in plan.promised.entries) {
              final why = 'seed $seed ${r.label} host $h';
              final roll = SeededRng(
                varietySeed('host2:promise:$seed:${r.comp.code}:$c:$h'),
              ).nextDouble();
              final delivered = plan.planned[h] ?? const <int>[];
              if (roll >= 0.10) {
                kept++;
                expect(delivered, promise, reason: why);
                continue;
              }
              found++;
              expect(delivered.length, promise.length - 1, reason: why);
              int grounds(Map<int, List<Venue>> v) =>
                  v.values.fold<int>(0, (s, l) => s + l.length);
              final played = grounds(_venues(r.hosts, plan, r.count));
              final promisedGrounds = grounds(
                _venues(r.hosts, plan, r.count, planned: plan.promised),
              );
              expect(
                played,
                promisedGrounds >= r.count && played == r.count
                    ? r.count
                    : promisedGrounds - 1,
                reason: why,
              );
              // Barred from the next two editions of that tournament.
              for (var k = 1; k <= 2; k++) {
                final next = _races(_v2World, seed, c + k)[i];
                expect(next.hosts, isNot(contains(h)), reason: '$why +$k');
                for (final b in next.bids) {
                  expect(b, isNot(contains(h)), reason: '$why +$k');
                }
              }
            }
          }
        }
      }
      expect(found, greaterThan(0), reason: 'no broken promise found');
      expect(kept, greaterThan(0));
    },
  );

  test('an edition with a legacy pledge is not stamped', () {
    const pledge = HostBidMarker(
      comp: HostBidComp.continental,
      editionCycle: 3,
      nationId: 12,
      levels: 2,
      permille: 250,
    );
    // A pledge or a bid of the old format holds its edition back.
    expect(HostBidding.hasLegacyBid([pledge.encodePledge()], 3), isTrue);
    expect(HostBidding.hasLegacyBid([pledge.encode()], 3), isTrue);
    // Another edition's, or any other host marker, does not.
    expect(HostBidding.hasLegacyBid([pledge.encodePledge()], 4), isFalse);
    expect(
      HostBidding.hasLegacyBid([
        HostBidding.rules2Kind(3),
        HostBidding.rulesKind(3, 12),
        HostBidding.lapsedKind(HostBidComp.continental, 3),
      ], 3),
      isFalse,
    );
    expect(HostBidding.hasLegacyBid(const [], 3), isFalse);
  });
}

Nation _code(String code) => _nations.firstWhere((n) => n.code == code);
