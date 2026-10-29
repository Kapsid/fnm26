// The host rules after build 15 (brief b14):
//
//  a) the bid card never judges by, names or hints at a host not yet
//     revealed;
//  b) no nation hosts two tournaments in a row, of any type;
//  c) the manager's nation hosts only when it bid.
//
// Both rules ride on a per-career marker stamped when a cycle's hosts are
// decided (`HostBidding.rulesKind`), so an edition an older save already
// decided keeps its host.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/host_bid_providers.dart';
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/legacy_hosts.dart';
import '../../helpers/test_database.dart';

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

int _wcYear(int cycle) => 2030 + 4 * cycle;

/// [nations] with [managerId] marked as the manager's nation for every cycle
/// in [cycles], plus any [bids] (`HostBidding.nationKey` to permille) on it.
List<Nation> _world(
  int managerId,
  Iterable<int> cycles, {
  List<Nation>? nations,
  Map<String, int> bids = const {},
}) => [
  for (final n in nations ?? _nations)
    if (n.id == managerId)
      n.copyWith(
        hostBids: {
          ...n.hostBids,
          for (final c in cycles) HostBidding.managerKey(c): 1,
          ...bids,
        },
      )
    else
      n,
];

/// The host slots of a world in the order they are played: cycle c's
/// continental championships (all the same summer), then its World
/// Championship.
List<Set<int>> _slots(List<Nation> world, int seed, int cycles) => [
  for (var c = 0; c < cycles; c++) ...[
    {
      for (final conf in Confederation.values)
        ...WorldCupHosts.continentalHostsFor(
          confederation: conf,
          cycle: c,
          seed: seed,
          nations: world,
        ),
    },
    WorldCupHosts.hostsFor(
      year: _wcYear(c),
      nations: world,
      seed: seed,
    ).toSet(),
  ],
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('b) reproduced: the rules before this fix', () {
    test('a host followed itself across types, and even within the '
        'continental championship (exclusions read naive picks)', () {
      var cross = 0;
      var contRepeat = 0;
      for (var seed = 1; seed <= 30; seed++) {
        final slots = _slots(_nations, seed, 5);
        for (var i = 1; i < slots.length; i++) {
          if (slots[i].intersection(slots[i - 1]).isNotEmpty) cross++;
        }
        for (final conf in Confederation.values) {
          for (var c = 1; c < 5; c++) {
            final a = WorldCupHosts.continentalHostsFor(
              confederation: conf,
              cycle: c - 1,
              seed: seed,
              nations: _nations,
            );
            final b = WorldCupHosts.continentalHostsFor(
              confederation: conf,
              cycle: c,
              seed: seed,
              nations: _nations,
            );
            if (a.any(b.contains)) contRepeat++;
          }
        }
      }
      // An unmarked world is decided exactly as before (an older save).
      expect(cross, greaterThan(0));
      expect(contRepeat, greaterThan(0));
    });
  });

  group('b) and c) under the current rules', () {
    test('30 careers x 5 cycles: nobody hosts two tournaments in a row, the '
        "manager's nation never hosts without a bid, and the per-type rules "
        'still hold', () {
      final rng = SeededRng(0xB14);
      for (var seed = 1; seed <= 30; seed++) {
        // Any nation may be managed; the strong ones are the ones at stake.
        final manager = rng.nextDouble() < 0.6
            ? (_nations.where((n) => n.ranking <= 30).toList()..sort(
                (a, b) => a.id.compareTo(b.id),
              ))[rng.nextInt(30)]
            : _nations[rng.nextInt(_nations.length)];
        final world = _world(manager.id, [for (var c = 0; c < 5; c++) c]);
        final slots = _slots(world, seed, 5);
        for (var i = 0; i < slots.length; i++) {
          expect(
            slots[i],
            isNot(contains(manager.id)),
            reason: 'seed $seed slot $i manager ${manager.name}',
          );
          if (i > 0) {
            expect(
              slots[i].intersection(slots[i - 1]),
              isEmpty,
              reason: 'seed $seed slots ${i - 1}/$i',
            );
          }
        }
        // The World Championship: never the last host's confederation,
        // never one of the last three hosts.
        final wc = [
          for (var c = 0; c < 5; c++)
            WorldCupHosts.hostsFor(
              year: _wcYear(c),
              nations: world,
              seed: seed,
            ),
        ];
        for (var c = 1; c < 5; c++) {
          expect(
            _byId[wc[c].first]!.confederation,
            isNot(_byId[wc[c - 1].first]!.confederation),
            reason: 'seed $seed wc $c',
          );
          for (var k = 1; k <= 3 && c - k >= 0; k++) {
            expect(wc[c].any(wc[c - k].contains), isFalse);
          }
        }
        // The continental championships: never one of the last three hosts
        // where the confederation is big enough to rotate; never the last
        // one anywhere.
        for (final conf in Confederation.values) {
          final hosts = [
            for (var c = 0; c < 5; c++)
              WorldCupHosts.continentalHostsFor(
                confederation: conf,
                cycle: c,
                seed: seed,
                nations: world,
              ),
          ];
          final big = {
            Confederation.europe,
            Confederation.africa,
            Confederation.asia,
          }.contains(conf);
          for (var c = 1; c < 5; c++) {
            for (var k = 1; k <= (big ? 3 : 1) && c - k >= 0; k++) {
              expect(
                hosts[c].any(hosts[c - k].contains),
                isFalse,
                reason: 'seed $seed $conf $c vs ${c - k}',
              );
            }
            for (final h in hosts[c]) {
              expect(_byId[h]!.confederation, conf);
            }
          }
          if (_nations.any((n) => n.confederation == conf)) {
            expect(hosts.every((h) => h.isNotEmpty), isTrue);
          }
        }
        // The ceremony shows a ballot the winner came from.
        for (var c = 0; c < 5; c++) {
          final bids = WorldCupHosts.worldCupBids(
            year: _wcYear(c),
            nations: world,
            seed: seed,
          );
          expect(bids.any((b) => b.contains(wc[c].first)), isTrue);
          expect(bids.any((b) => b.contains(manager.id)), isFalse);
        }
      }
    });

    test('an older save keeps every host it decided; the rules start with '
        'the first cycle decided after the update', () {
      for (var seed = 1; seed <= 30; seed++) {
        final manager = _nations[(seed * 7) % _nations.length];
        // Updated during cycle 1: cycle 2 is the first decided now.
        final world = _world(manager.id, [2, 3, 4]);
        for (var c = 0; c <= 1; c++) {
          expect(
            WorldCupHosts.hostsFor(
              year: _wcYear(c),
              nations: world,
              seed: seed,
            ),
            LegacyWorldCupHosts.hostsFor(
              year: _wcYear(c),
              nations: _nations,
              seed: seed,
            ),
          );
          for (final conf in Confederation.values) {
            expect(
              WorldCupHosts.continentalHostsFor(
                confederation: conf,
                cycle: c,
                seed: seed,
                nations: world,
              ),
              LegacyWorldCupHosts.continentalHostsFor(
                confederation: conf,
                cycle: c,
                seed: seed,
                nations: _nations,
              ),
            );
          }
        }
        // From cycle 2 on nobody follows itself, the legacy cycle 1 World
        // Championship host included.
        final slots = _slots(world, seed, 5);
        for (var i = 4; i < slots.length; i++) {
          expect(
            slots[i].intersection(slots[i - 1]),
            isEmpty,
            reason: 'seed $seed slot $i',
          );
          expect(slots[i], isNot(contains(manager.id)));
        }
      }
    });

    test('with a winning bid the manager hosts as before, a joint '
        'candidature included', () {
      var joint = 0;
      for (var seed = 1; seed <= 60; seed++) {
        // One of the strongest Europeans, so it stands on the ballot itself
        // (alone or jointly), not only as a lodged bid at the bottom.
        final manager =
            (_nations
                .where((n) => n.confederation == Confederation.europe)
                .toList()
              ..sort((a, b) => a.ranking.compareTo(b.ranking)))[3 + seed % 8];
        final key = HostBidding.nationKey(HostBidComp.continental, 1);
        final plain = _world(manager.id, [0, 1]);
        final standing = WorldCupHosts.continentalBidStanding(
          confederation: Confederation.europe,
          cycle: 1,
          seed: seed,
          nations: plain,
          nationId: manager.id,
        );
        if (!standing.eligible) continue;
        final bid = _world(manager.id, [0, 1], bids: {key: 999});
        final hosts = WorldCupHosts.continentalHostsFor(
          confederation: Confederation.europe,
          cycle: 1,
          seed: seed,
          nations: bid,
        );
        expect(hosts, contains(manager.id), reason: 'seed $seed');
        if (hosts.length > 1) joint++;
        // The ballot it won from.
        final bids = WorldCupHosts.continentalBids(
          confederation: Confederation.europe,
          cycle: 1,
          seed: seed,
          nations: bid,
        );
        expect(bids.any((b) => b.join() == hosts.join()), isTrue);
        // And without the bid, never.
        expect(
          WorldCupHosts.continentalHostsFor(
            confederation: Confederation.europe,
            cycle: 1,
            seed: seed,
            nations: plain,
          ),
          isNot(contains(manager.id)),
        );
      }
      expect(joint, greaterThan(0), reason: 'a joint bid can still win');
    });

    test('a bid wins about as often as it promised', () {
      var won = 0;
      var tried = 0;
      var promised = 0.0;
      for (var seed = 1; seed <= 400; seed++) {
        final manager = _nations
            .where((n) => n.confederation == Confederation.europe)
            .toList()[10 + seed % 15];
        final standing = WorldCupHosts.continentalBidStanding(
          confederation: Confederation.europe,
          cycle: 1,
          seed: seed,
          nations: _world(manager.id, [0, 1]),
          nationId: manager.id,
        );
        if (!standing.eligible) continue;
        const permille = 300;
        tried++;
        promised += permille / 1000;
        final hosts = WorldCupHosts.continentalHostsFor(
          confederation: Confederation.europe,
          cycle: 1,
          seed: seed,
          nations: _world(
            manager.id,
            [0, 1],
            bids: {HostBidding.nationKey(HostBidComp.continental, 1): permille},
          ),
        );
        if (hosts.contains(manager.id)) won++;
      }
      expect(tried, greaterThan(200));
      expect((won - promised).abs() / tried, lessThan(0.07));
    });

    test('a bidder for the World Championship who hosts that summer is not '
        'eligible: the standing says so', () {
      // A cycle-1 continental host bidding for the cycle-1 World
      // Championship (its own bid won the continental one).
      for (var seed = 1; seed <= 40; seed++) {
        final manager = _nations
            .where((n) => n.confederation == Confederation.europe)
            .toList()[12];
        final world = _world(
          manager.id,
          [0, 1],
          bids: {HostBidding.nationKey(HostBidComp.continental, 1): 999},
        );
        final won = WorldCupHosts.continentalHostsFor(
          confederation: Confederation.europe,
          cycle: 1,
          seed: seed,
          nations: world,
        ).contains(manager.id);
        if (!won) continue;
        final st = WorldCupHosts.worldCupBidStanding(
          year: _wcYear(1),
          nations: world,
          seed: seed,
          nationId: manager.id,
        );
        expect(st.eligible, isFalse);
        expect(st.previousSlotHost, isTrue);
        return;
      }
      fail('no world found');
    });
  });

  group('careers', () {
    Future<({ProviderContainer c, int careerId})> start(
      int seed,
      int nationId,
    ) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final db = createTestDatabase();
      final c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
          seedSourceProvider.overrideWithValue(
            InMemorySeedSource(nationList: _nations, playerList: const []),
          ),
          countryCitiesProvider.overrideWith((ref) async => _cities),
        ],
      );
      addTearDown(c.dispose);
      addTearDown(db.close);
      await c.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(nationId: nationId, managerName: 'M', rngSeed: seed))
              .valueOrNull!;
      return (c: c, careerId: career.id);
    }

    Future<List<HostBidStatus>> statuses(
      ({ProviderContainer c, int careerId}) w, [
      int? nationId,
    ]) {
      w.c.invalidate(hostBidStatusProvider);
      return w.c.read(
        hostBidStatusProvider((
          careerId: w.careerId,
          nationId: nationId,
        )).future,
      );
    }

    test('c) a new save is stamped and its nation does not host cycle 0, '
        'even where the old draw would have handed it the World '
        'Championship', () async {
      // A world whose old draw made this nation the 2030 host.
      const seed = 5;
      final host = LegacyWorldCupHosts.hostFor(
        year: 2030,
        nations: _nations,
        seed: seed,
      );
      final w = await start(seed, host);
      final comp = w.c.read(competitionRepositoryProvider);
      expect(
        await comp.hasWatchedDraw(
          w.careerId,
          0,
          HostBidding.rulesKind(0, host),
        ),
        isTrue,
      );
      final world = await w.c
          .read(nationRepositoryProvider)
          .forCareer(w.careerId);
      expect(
        WorldCupHosts.hostsFor(year: 2030, nations: world, seed: seed),
        isNot(contains(host)),
      );
      expect(
        WorldCupHosts.continentalHostsFor(
          confederation: _byId[host]!.confederation,
          cycle: 0,
          seed: seed,
          nations: world,
        ),
        isNot(contains(host)),
      );
    });

    test('a) before the reveal the card never judges by this cycle\'s '
        'hosts; after it, it does, and agrees with b)', () async {
      // A European manager in a world whose 2030 host is European: the
      // rotation would bar every European nation from 2034, which is a
      // hint at the host.
      int? found;
      int? wcHost;
      final manager = _nations
          .where((n) => n.confederation == Confederation.europe)
          .toList()
          .last;
      for (var seed = 1; seed < 400 && found == null; seed++) {
        final world = _world(manager.id, [0]);
        final h = WorldCupHosts.hostFor(
          year: 2030,
          nations: world,
          seed: seed,
        );
        if (_byId[h]!.confederation == Confederation.europe) {
          found = seed;
          wcHost = h;
        }
      }
      expect(found, isNotNull);
      final w = await start(found!, manager.id);
      final comp = w.c.read(competitionRepositoryProvider);

      // Before: no rule names or hints at the hidden host, for the manager's
      // nation or for the host itself (a job he might take).
      for (final id in [manager.id, wcHost!]) {
        for (final s in await statuses(w, id)) {
          expect(s.barredConfederation, isNull, reason: '$id ${s.comp}');
          expect(s.recentHost, isFalse, reason: '$id ${s.comp}');
          expect(s.backToBack, isFalse, reason: '$id ${s.comp}');
          expect(s.rulesPending, isTrue, reason: '$id ${s.comp}');
          expect(s.offer, isNull);
        }
      }

      // The continental host ceremony alone does not reveal the World
      // Championship's.
      await comp.markDrawWatched(w.careerId, 0, continentalHostDrawKind);
      for (final s in await statuses(w, wcHost)) {
        expect(s.barredConfederation, isNull);
        expect(s.backToBack, isFalse);
        expect(s.recentHost, isFalse);
        expect(s.rulesPending, isTrue);
      }

      // After the World Championship host reveal.
      await comp.markDrawWatched(w.careerId, 0, worldCupHostDrawKind);
      final mine = await statuses(w);
      final myWc = mine.firstWhere(
        (s) => s.comp == HostBidComp.worldChampionship,
      );
      expect(myWc.barredConfederation, Confederation.europe);
      expect(myWc.rulesPending, isFalse);
      final theirs = await statuses(w, wcHost);
      final theirCont = theirs.firstWhere(
        (s) => s.comp == HostBidComp.continental,
      );
      final theirWc = theirs.firstWhere(
        (s) => s.comp == HostBidComp.worldChampionship,
      );
      // b): the 2030 host may not host the 2032 continental championship.
      expect(theirCont.backToBack, isTrue);
      expect(theirCont.eligible, isFalse);
      expect(theirWc.recentHost, isTrue);
      expect(theirWc.barredConfederation, Confederation.europe);
    });

    test('c) a campaign keeps its designed world: no rules marker, the hosts '
        'the old rules gave it', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final db = createTestDatabase();
      final c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
          countryCitiesProvider.overrideWith((ref) async => _cities),
        ],
      );
      addTearDown(c.dispose);
      addTearDown(db.close);
      await c.read(seedLoaderProvider).ensureSeeded();
      final def = Campaigns.all.firstWhere((d) => !d.needsPro);
      final career = await c
          .read(campaignServiceProvider)
          .start(def, managerName: 'M');
      final comp = c.read(competitionRepositoryProvider);
      final rules = [
        for (final r in await comp.watchedKindsWithPrefix(
          HostBidding.rulesPrefix,
        ))
          if (r.careerId == career.id) r.kind,
      ];
      expect(rules, isEmpty);
      final world = await c.read(nationRepositoryProvider).forCareer(career.id);
      expect(
        WorldCupHosts.hostsFor(year: 2030, nations: world, seed: def.rngSeed),
        LegacyWorldCupHosts.hostsFor(
          year: 2030,
          nations: world,
          seed: def.rngSeed,
        ),
      );
    });
  });
}
