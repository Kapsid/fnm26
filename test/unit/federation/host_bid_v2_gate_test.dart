import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/host_stadium_rules.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/host_bid_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

// The host bid under the stadium bars (host rules v2): a bid lodged by this
// build keeps its edition under the bars, and a nation short of the bar may
// not lodge one at all. An older build's pledge keeps its edition on the old
// rules (also pinned on real old saves in save_upgrade_test).

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

Nation _code(String code) => _nations.firstWhere((n) => n.code == code);

/// The EURO's bar in a career created now: its editions are stamped with
/// the lighter bars (`HostBidding.rules3Kind`).
final HostBar _euro = HostStadiumRules.continentalLighter(
  Confederation.europe,
);

bool _meetsEuro(Nation n) => HostStadiumRules.meets(
  HostStadiumRules.qualifyingSeats(nationId: n.id, editionCycle: 1),
  _euro,
);

/// A European side whose grounds pass the old size check but fall short of
/// the EURO's stadium bar: only the bar stops it.
final Nation _short =
    (_nations.where((n) => n.confederation == Confederation.europe).toList()
          ..sort((a, b) => a.ranking.compareTo(b.ranking)))
        .firstWhere(
          (n) =>
              !_meetsEuro(n) &&
              HostingRequirements.meets(
                [
                  for (final v in VenueGenerator.forHost(
                    hostId: n.id,
                    cities: _cities[n.id],
                    count: 16,
                  ).take(8))
                    v.capacity,
                ],
                HostingRequirements.continental(Confederation.europe),
              ),
        );

typedef _World = ({ProviderContainer c, int careerId});

Future<_World> _world(Nation nation, {int seed = 11}) async {
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
              .create(nationId: nation.id, managerName: 'M', rngSeed: seed))
          .valueOrNull!;
  // Rich enough for any bid.
  await c.read(careerRepositoryProvider).setBudget(career.id, 30000000);
  return (c: c, careerId: career.id);
}

/// Records a World Championship final in the current cycle: the window opens.
Future<void> _finishCycle(_World w) async {
  final comp = w.c.read(competitionRepositoryProvider);
  final cycle =
      (await w.c.read(careerRepositoryProvider).byId(w.careerId))!.cyclePointer;
  await comp.createKnockout(
    careerId: w.careerId,
    cycle: cycle,
    confederation: Confederation.europe,
    kind: CompetitionKind.worldCupFinals,
    name: 'World Championship',
    pairings: [(26, 1)],
    date: DateTime(CareerService.worldCupYear(cycle), 7, 19),
    firstRound: 'FINAL',
  );
  final fin = await comp.fixturesByRound(w.careerId, 'FINAL');
  await comp.recordResult(fixtureId: fin.last.id, homeScore: 1, awayScore: 0);
}

Future<HostBidStatus> _contStatus(_World w) async {
  w.c.invalidate(hostBidStatusProvider);
  final all = await w.c.read(
    hostBidStatusProvider((careerId: w.careerId, nationId: null)).future,
  );
  return all.firstWhere((s) => s.comp == HostBidComp.continental);
}

Future<bool> _stamped(_World w, int cycle) => w.c
    .read(competitionRepositoryProvider)
    .hasWatchedDraw(w.careerId, cycle, HostBidding.rules2Kind(cycle));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a nation short of the stadium bar cannot lodge a bid', () async {
    final w = await _world(_short);
    await _finishCycle(w);
    final s = await _contStatus(w);
    expect(s.windowOpen, isTrue);
    expect(s.belowBar, isTrue);
    expect(s.eligible, isFalse);
    expect(s.offer, isNull);
    // Nor through a stale offer: place refuses it inside its transaction.
    final stale = HostBidOffer(
      careerId: w.careerId,
      comp: HostBidComp.continental,
      editionCycle: 1,
      year: CareerService.continentalFinalsYear(1),
      nation: _short,
      size: 0.3,
      today: 0.02,
      freeFunds: 30000000,
    );
    expect(
      await w.c.read(hostBidServiceProvider).place(stale, 1),
      isFalse,
    );
    final kinds = await hostBidKinds(
      w.c.read(competitionRepositoryProvider),
      w.careerId,
    );
    expect(kinds.where((k) => HostBidMarker.decodePledge(k) != null), isEmpty);
  });

  test('a pledge lodged by this build leads to a v2-stamped edition', () async {
    final ger = _code('GER');
    expect(_meetsEuro(ger), isTrue);
    final w = await _world(ger);
    await _finishCycle(w);
    final s = await _contStatus(w);
    expect(s.belowBar, isFalse);
    final offer = s.offer;
    expect(offer, isNotNull, reason: 'no EURO offer for Germany');
    expect(await w.c.read(hostBidServiceProvider).place(offer!, 1), isTrue);
    final comp = w.c.read(competitionRepositoryProvider);
    final kinds = await hostBidKinds(comp, w.careerId);
    expect(
      kinds,
      contains(HostBidding.newBuildKind(HostBidComp.continental, 1, ger.id)),
    );
    expect(HostBidding.hasLegacyBid(kinds, 1), isFalse);

    await w.c.read(seasonServiceProvider).startNextCycle(w.careerId);
    expect(
      (await w.c.read(careerRepositoryProvider).byId(w.careerId))!.cyclePointer,
      1,
    );
    expect(await _stamped(w, 1), isTrue);
    expect(
      await comp.hasWatchedDraw(w.careerId, 1, HostBidding.rules3Kind(1)),
      isTrue,
      reason: 'held to the lighter bars',
    );
    // The pledge was paid and became the bid.
    expect(
      (await hostBidKinds(comp, w.careerId)).any(
        (k) => HostBidMarker.decode(k)?.editionCycle == 1,
      ),
      isTrue,
    );
  });

  test(
    'an edition an earlier build stamped v2 alone keeps the first bars',
    () async {
      final w = await _world(_code('GER'));
      final comp = w.c.read(competitionRepositoryProvider);
      // Cycle 0 was created by this build: lighter.
      expect(await lighterBarsFor(comp, w.careerId, 0), isTrue);
      // Cycle 1 not decided yet: this build's rollover will stamp it lighter.
      expect(await lighterBarsFor(comp, w.careerId, 1), isTrue);
      // As the build before the lighter bars stamped it: v2 alone.
      await comp.markDrawWatched(w.careerId, 1, HostBidding.rules2Kind(1));
      expect(await lighterBarsFor(comp, w.careerId, 1), isFalse);
      final world = await w.c
          .read(nationRepositoryProvider)
          .forCareer(w.careerId);
      expect(WorldCupHosts.isV2(1, world), isTrue);
      expect(WorldCupHosts.isV3(1, world), isFalse);
      expect(WorldCupHosts.isV3(0, world), isTrue);
    },
  );

  test('an older build pledge keeps its edition on the old rules', () async {
    final ger = _code('GER');
    final w = await _world(ger);
    await _finishCycle(w);
    // As an older build wrote it: the pledge alone, no companion.
    await w.c
        .read(competitionRepositoryProvider)
        .markDrawWatched(
          w.careerId,
          1,
          HostBidMarker(
            comp: HostBidComp.continental,
            editionCycle: 1,
            nationId: ger.id,
            levels: 1,
            permille: 100,
          ).encodePledge(),
        );
    await w.c.read(seasonServiceProvider).startNextCycle(w.careerId);
    expect(await _stamped(w, 1), isFalse);
  });

  test(
    'a short pledge that reaches the rollover under the bars lapses quietly',
    () async {
      final w = await _world(_short);
      await _finishCycle(w);
      final comp = w.c.read(competitionRepositoryProvider);
      // A pledge of this build for a nation short of the bar (the offer
      // refuses one; this is the rollover's backstop).
      await comp.markDrawWatched(
        w.careerId,
        1,
        HostBidMarker(
          comp: HostBidComp.continental,
          editionCycle: 1,
          nationId: _short.id,
          levels: 1,
          permille: 100,
        ).encodePledge(),
      );
      await comp.markDrawWatched(
        w.careerId,
        1,
        HostBidding.newBuildKind(HostBidComp.continental, 1, _short.id),
      );
      await w.c.read(seasonServiceProvider).startNextCycle(w.careerId);
      expect(await _stamped(w, 1), isTrue);
      final kinds = await hostBidKinds(comp, w.careerId);
      expect(
        kinds,
        contains(HostBidding.lapsedKind(HostBidComp.continental, 1)),
      );
      // Never paid, so never a bid the draw could count.
      expect(kinds.any((k) => HostBidMarker.decode(k) != null), isFalse);
    },
  );

  test('turning a bid down under the bars: no pledge, and the edition is '
      'still stamped', () async {
    final ger = _code('GER');
    final w = await _world(ger);
    await _finishCycle(w);
    final offer = (await _contStatus(w)).offer;
    expect(offer, isNotNull);
    final careers = w.c.read(careerRepositoryProvider);
    final before = (await careers.byId(w.careerId))!.budget;
    await w.c.read(hostBidServiceProvider).decline(offer!);
    final comp = w.c.read(competitionRepositoryProvider);
    var kinds = await hostBidKinds(comp, w.careerId);
    expect(
      kinds.where((k) => k.startsWith('hostBidDeclined:')),
      isNotEmpty,
    );
    expect(
      kinds,
      isNot(
        contains(HostBidding.newBuildKind(HostBidComp.continental, 1, ger.id)),
      ),
    );
    // A decline is never read as an older build's bid.
    expect(HostBidding.hasLegacyBid(kinds, 1), isFalse);
    expect((await careers.byId(w.careerId))!.budget, before);

    await w.c.read(seasonServiceProvider).startNextCycle(w.careerId);
    expect(await _stamped(w, 1), isTrue);
    kinds = await hostBidKinds(comp, w.careerId);
    expect(kinds.any((k) => HostBidMarker.decode(k) != null), isFalse);
  });

  for (final seed in [11, 12, 13, 14]) {
    test('a bid paid under the bars is decided, and a win stages the EURO in '
        'qualifying grounds only (seed $seed)', () async {
      final ger = _code('GER');
      final w = await _world(ger, seed: seed);
      await _finishCycle(w);
      final offer = (await _contStatus(w)).offer!;
      expect(
        await w.c.read(hostBidServiceProvider).place(offer, offer.maxLevels),
        isTrue,
      );
      await w.c.read(seasonServiceProvider).startNextCycle(w.careerId);
      expect(await _stamped(w, 1), isTrue);
      final comp = w.c.read(competitionRepositoryProvider);
      final kinds = await hostBidKinds(comp, w.careerId);
      final results = [
        for (final k in kinds) ?HostBidding.decodeResult(k),
      ];
      expect(results, hasLength(1), reason: 'decided once');
      final won = results.single.won;
      final world = await w.c
          .read(nationRepositoryProvider)
          .forCareer(w.careerId);
      final hosts = WorldCupHosts.continentalHostsFor(
        confederation: Confederation.europe,
        cycle: 1,
        seed: seed,
        nations: world,
      );
      expect(hosts.contains(ger.id), won);
      final plan = WorldCupHosts.continentalGroundPlan(
        confederation: Confederation.europe,
        cycle: 1,
        seed: seed,
        nations: world,
      );
      expect(plan, isNotNull, reason: 'decided under the bars');
      final venues = VenueGenerator.forHosts(
        hostIds: hosts,
        citiesByHost: {
          for (final h in hosts)
            if (_cities[h] != null) h: _cities[h]!,
        },
        count: VenueGenerator.countForField(24),
        rules: VenueRules.scaled,
        qualifyingOnly: true,
        minSeats: plan!.minSeats,
        planned: plan.planned,
      );
      final grounds = [for (final v in venues.values) ...v];
      expect(grounds, isNotEmpty);
      for (final v in grounds) {
        expect(v.capacity, greaterThanOrEqualTo(_euro.otherSeats));
      }
    });
  }
}
