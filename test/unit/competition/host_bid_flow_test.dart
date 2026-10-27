import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/host_bid_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';
import '../../story/driver.dart';

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

List<Venue> _static(int id) =>
    VenueGenerator.forHost(hostId: id, cities: _cities[id], count: 16);

bool _estateMeets(int id, HostingRequirement req) => HostingRequirements.meets(
  [for (final v in _static(id).take(8)) v.capacity],
  req,
);

final List<Nation> _europe =
    _nations.where((n) => n.confederation == Confederation.europe).toList()
      ..sort((a, b) => a.ranking.compareTo(b.ranking));

/// A mid-table European side whose grounds are big enough for the European
/// Championship: may bid, never a favourite.
final Nation _bidder = _europe
    .skip(12)
    .firstWhere(
      (n) =>
          _estateMeets(n.id, HostingRequirements.continental(n.confederation)),
    );

/// A mid-table European side whose grounds are too small for it.
final Nation _small = _europe
    .skip(12)
    .firstWhere(
      (n) =>
          !_estateMeets(n.id, HostingRequirements.continental(n.confederation)),
    );

typedef _World = ({ProviderContainer c, int careerId});

Future<_World> _world({
  required int seed,
  bool premium = true,
  Nation? nation,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final db = createTestDatabase();
  final c = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      premiumUnlockedProvider.overrideWith((ref) => premium),
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
              .create(
                nationId: (nation ?? _bidder).id,
                managerName: 'M',
                rngSeed: seed,
              ))
          .valueOrNull!;
  return (c: c, careerId: career.id);
}

HostBidArg _arg(_World w, [int? nationId]) =>
    (careerId: w.careerId, nationId: nationId);

Future<List<HostBidOffer>> _offers(_World w, [int? nationId]) {
  w.c.invalidate(hostBidStatusProvider);
  w.c.invalidate(hostBidOffersProvider);
  return w.c.read(hostBidOffersProvider(_arg(w, nationId)).future);
}

Future<List<HostBidStatus>> _statuses(_World w, [int? nationId]) {
  w.c.invalidate(hostBidStatusProvider);
  return w.c.read(hostBidStatusProvider(_arg(w, nationId)).future);
}

Future<int> _budget(_World w) async =>
    (await w.c.read(careerRepositoryProvider).byId(w.careerId))!.budget;

/// Records a World Championship final in the career's current cycle, so the
/// cycle is over: the bid window is open and the save may roll.
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

/// Whether a continental bid by [_bidder] at [levels] would win the cycle-1
/// edition of world [seed], or null when the rotation bars it. Worked out on
/// the domain alone, so the flow below can be pointed at a win and at a loss.
bool? _wouldWin(int seed, int levels) {
  final standing = WorldCupHosts.continentalBidStanding(
    confederation: Confederation.europe,
    cycle: 1,
    seed: seed,
    nations: _nations,
    nationId: _bidder.id,
  );
  if (!standing.eligible) return null;
  final permille = HostBidOdds.permilleOf(
    HostBidOdds.quote(
      size: HostBidOdds.sizeScore(_static(_bidder.id)),
      today: standing.today,
      levels: levels,
    ),
  );
  final world = [
    for (final n in _nations)
      n.id == _bidder.id
          ? n.copyWith(
              hostBids: {
                HostBidding.nationKey(HostBidComp.continental, 1): permille,
              },
            )
          : n,
  ];
  return WorldCupHosts.continentalHostsFor(
    confederation: Confederation.europe,
    cycle: 1,
    seed: seed,
    nations: world,
  ).contains(_bidder.id);
}

int _seedWhere(bool? Function(int seed) wanted, Object? value) {
  var seed = 100;
  while (wanted(seed) != value) {
    seed++;
  }
  return seed;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'a save that never bid: its world and its money are untouched',
    () async {
      final w = await _world(seed: 41);
      final repo = w.c.read(nationRepositoryProvider);
      expect(await repo.forCareer(w.careerId), await repo.all());
      final before = await _budget(w);
      final service = w.c.read(hostBidServiceProvider);
      expect(await service.resolveDue(w.careerId), isFalse);
      expect(await service.resolveDue(w.careerId, atRollover: true), isFalse);
      expect(await _budget(w), before);
    },
  );

  test('b) during the cycle nothing is offered; the window opens once the '
      'cycle is over, for the cycle about to begin', () async {
    final seed = _seedWhere((s) => _wouldWin(s, 1) != null, true);
    final w = await _world(seed: seed);
    expect(await _offers(w), isEmpty);
    final early = await _statuses(w);
    final cont = early.firstWhere((s) => s.comp == HostBidComp.continental);
    expect(cont.windowOpen, isFalse);
    expect(cont.eligible, isTrue);
    expect(cont.editionCycle, 1);
    expect(cont.year, CareerService.continentalFinalsYear(1));

    await _finishCycle(w);
    final offers = await _offers(w);
    final career = (await w.c.read(careerRepositoryProvider).byId(w.careerId))!;
    expect(offers, isNotEmpty);
    for (final o in offers) {
      expect(o.editionCycle, career.cyclePointer + 1);
    }
    final wc = WorldCupHosts.worldCupBidStanding(
      year: CareerService.worldCupYear(1),
      nations: _nations,
      seed: seed,
      nationId: _bidder.id,
    );
    expect(
      offers.any((o) => o.comp == HostBidComp.worldChampionship),
      wc.eligible &&
          _estateMeets(_bidder.id, HostingRequirements.worldChampionship),
    );
    // The funds are what the rollover will bank, less the wages.
    final money = await rolloverMoney(
      w.c.read(_refProvider),
      career,
    );
    expect(offers.first.freeFunds, money.balance - money.wages);
    expect(offers.first.freeFunds, greaterThan(career.budget));
  });

  test('f) a nation whose grounds are too small may not bid, and the card '
      'says how many stadiums it lacks', () async {
    final w = await _world(seed: 41, nation: _small);
    await _finishCycle(w);
    final cont = (await _statuses(
      w,
    )).firstWhere((s) => s.comp == HostBidComp.continental);
    expect(cont.estateOk, isFalse);
    expect(cont.offer, isNull);
    expect(
      cont.shortfall.grounds + cont.shortfall.bigGrounds,
      greaterThan(0),
    );
    final seats = [for (final v in _static(_small.id).take(8)) v.capacity];
    expect(
      cont.shortfall,
      HostingRequirements.shortfall(seats, cont.requirement),
    );
  });

  test(
    'g) the rotation: a recent host may not bid, and the card says so',
    () async {
      // A world where the bidder hosted cycle 0's championship: barred from
      // cycle 1's.
      var seed = 1;
      while (!WorldCupHosts.continentalHostsFor(
        confederation: Confederation.europe,
        cycle: 0,
        seed: seed,
        nations: _nations,
      ).contains(_bidder.id)) {
        seed++;
      }
      final w = await _world(seed: seed);
      await _finishCycle(w);
      final cont = (await _statuses(
        w,
      )).firstWhere((s) => s.comp == HostBidComp.continental);
      expect(cont.recentHost, isTrue);
      expect(cont.eligible, isFalse);
      expect(cont.offer, isNull);
      // And the World Championship: the confederation that hosted 2030 may
      // not host 2034.
      final wcHost = WorldCupHosts.hostFor(
        year: CareerService.worldCupYear(0),
        nations: _nations,
        seed: seed,
      );
      final hostConf = _nations.firstWhere((n) => n.id == wcHost).confederation;
      final wc = (await _statuses(
        w,
      )).firstWhere((s) => s.comp == HostBidComp.worldChampionship);
      expect(
        wc.barredConfederation,
        hostConf == Confederation.europe ? Confederation.europe : isNull,
      );
    },
  );

  test('a free save is never offered a bid', () async {
    final w = await _world(seed: 41, premium: false);
    await _finishCycle(w);
    expect(await _statuses(w), isEmpty);
  });

  test('placing: a pledge, nothing paid yet, the world untouched until the '
      'rollover; twice is refused', () async {
    final seed = _seedWhere((s) => _wouldWin(s, 1) != null, true);
    final w = await _world(seed: seed);
    await _finishCycle(w);
    final comp = w.c.read(competitionRepositoryProvider);
    final fixturesBefore = [
      for (final f in await comp.allFixtures(w.careerId))
        '${f.id}:${f.homeNationId}:${f.awayNationId}:${f.date}',
    ];
    final offer = (await _offers(
      w,
    )).firstWhere((o) => o.comp == HostBidComp.continental);
    final before = await _budget(w);
    final service = w.c.read(hostBidServiceProvider);
    expect(await service.place(offer, 4), isTrue);
    expect(await service.place(offer, 4), isFalse);
    expect(await _budget(w), before);
    final kinds = await hostBidKinds(comp, w.careerId);
    expect(
      kinds.where((k) => HostBidMarker.decodePledge(k) != null),
      hasLength(1),
    );
    expect(kinds.where((k) => HostBidMarker.decode(k) != null), isEmpty);
    // The draw cannot see a pledge.
    expect(
      await w.c.read(nationRepositoryProvider).forCareer(w.careerId),
      await w.c.read(nationRepositoryProvider).all(),
    );
    final cont = (await _statuses(
      w,
    )).firstWhere((s) => s.comp == HostBidComp.continental);
    expect(cont.lodged, isTrue);
    expect(cont.offer, isNull);
    expect([
      for (final f in await comp.allFixtures(w.careerId))
        '${f.id}:${f.homeNationId}:${f.awayNationId}:${f.date}',
    ], fixturesBefore);
  });

  test(
    'pledges together never pass the money the rollover will have',
    () async {
      final seed = _seedWhere((s) => _wouldWin(s, 1) != null, true);
      final w = await _world(seed: seed);
      // An empty bank: the offer lives on the income still to come.
      await w.c.read(careerRepositoryProvider).setBudget(w.careerId, 0);
      await _finishCycle(w);
      final offer = (await _offers(
        w,
      )).firstWhere((o) => o.comp == HostBidComp.continental);
      final service = w.c.read(hostBidServiceProvider);
      expect(await service.place(offer, offer.maxLevels + 1), isFalse);
      expect(await service.place(offer, offer.maxLevels), isTrue);
      final left = offer.freeFunds - offer.maxLevels * HostBidOdds.levelPrice;
      // A second pledge (a stale offer that still shows the old funds) only
      // fits in what is left.
      HostBidOffer wc(int funds) => HostBidOffer(
        careerId: offer.careerId,
        comp: HostBidComp.worldChampionship,
        editionCycle: offer.editionCycle,
        year: CareerService.worldCupYear(1),
        nation: offer.nation,
        size: offer.size,
        today: 0,
        freeFunds: funds,
      );
      final room = left ~/ HostBidOdds.levelPrice;
      if (room + 1 <= HostBidOdds.maxLevels) {
        expect(await service.place(wc(offer.freeFunds), room + 1), isFalse);
      }
      if (room >= 1) {
        expect(
          await service.place(wc(offer.freeFunds), room.clamp(1, 10)),
          isTrue,
        );
      }
      expect(await _budget(w), 0);
    },
  );

  test('a campaign run is never offered a bid: A Greenland Century', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.startCampaign(c, Campaigns.greenland);
    final id = d.careerId;
    final comp = c.read(competitionRepositoryProvider);
    Future<List<HostBidStatus>> statuses() {
      c.invalidate(hostBidStatusProvider);
      return c.read(
        hostBidStatusProvider((careerId: id, nationId: null)).future,
      );
    }

    expect(await statuses(), isEmpty);
    // It is the campaign that bars it: moved into the saves, the card is
    // there.
    await comp.markDrawWatched(id, 0, campaignMovedKind);
    expect(await statuses(), isNotEmpty);
  });

  test('turning it down: asked no more, nothing spent', () async {
    final seed = _seedWhere((s) => _wouldWin(s, 1) != null, true);
    final w = await _world(seed: seed);
    await _finishCycle(w);
    final offer = (await _offers(
      w,
    )).firstWhere((o) => o.comp == HostBidComp.continental);
    final before = await _budget(w);
    await w.c.read(hostBidServiceProvider).decline(offer);
    expect(
      (await _offers(w)).any((o) => o.comp == HostBidComp.continental),
      isFalse,
    );
    final cont = (await _statuses(
      w,
    )).firstWhere((s) => s.comp == HostBidComp.continental);
    expect(cont.declined, isTrue);
    expect(await _budget(w), before);
  });

  for (final wanted in [true, false]) {
    test('the rollover pays the pledge once, decides it, and builds the new '
        'cycle on that host: a ${wanted ? 'win' : 'loss'}', () async {
      final seed = _seedWhere((s) => _wouldWin(s, 10), wanted);
      final w = await _world(seed: seed);
      final careers = w.c.read(careerRepositoryProvider);
      final comp = w.c.read(competitionRepositoryProvider);
      // Rich enough for the full bid.
      await careers.setBudget(w.careerId, 30000000);
      await _finishCycle(w);
      final offer = (await _offers(
        w,
      )).firstWhere((o) => o.comp == HostBidComp.continental);
      expect(offer.maxLevels, HostBidOdds.maxLevels);
      final service = w.c.read(hostBidServiceProvider);
      expect(await service.place(offer, HostBidOdds.maxLevels), isTrue);
      final closing = (await careers.byId(w.careerId))!;
      final money = await rolloverMoney(w.c.read(_refProvider), closing);

      await w.c.read(seasonServiceProvider).startNextCycle(w.careerId);
      final rolled = (await careers.byId(w.careerId))!;
      expect(rolled.cyclePointer, 1);
      final cost = HostBidOdds.maxLevels * HostBidOdds.levelPrice;
      final bonus = wanted ? HostBidOdds.bonusFor(HostBidOdds.maxLevels) : 0;
      expect(rolled.budget, money.balance - cost + bonus);

      // The pledge became the bid, and the bid was decided.
      final kinds = await hostBidKinds(comp, w.careerId);
      expect(
        kinds.any((k) => HostBidMarker.decode(k)?.editionCycle == 1),
        isTrue,
      );
      expect(
        kinds.any((k) => HostBidding.decodeResult(k)?.won == wanted),
        isTrue,
      );
      final keys = await comp.messageKeys(w.careerId);
      expect(keys, contains('hostBid:cont:1'));

      // The ordering pinned: the cycle's continental qualifying, built in the
      // same rollover, already knows the host. A winner sits it out; a loser
      // plays it.
      final world = await w.c
          .read(nationRepositoryProvider)
          .forCareer(w.careerId);
      final hosts = WorldCupHosts.continentalHostsFor(
        confederation: Confederation.europe,
        cycle: 1,
        seed: seed,
        nations: world,
      );
      expect(hosts.contains(_bidder.id), wanted);
      // Cycle 1's qualifiers only (the list is all-time).
      bool cycle1Cq(Fixture f) =>
          f.round == 'CQ' && !f.date.isBefore(CareerService.cycleOpens(1));
      final mine = await comp.fixturesForNation(w.careerId, _bidder.id);
      expect(mine.any(cycle1Cq), !wanted);
      for (final h in hosts) {
        final theirs = await comp.fixturesForNation(w.careerId, h);
        expect(theirs.where(cycle1Cq), isEmpty, reason: '$h');
      }

      // A rollover retried from the top banks and charges nothing twice.
      await careers.advanceCycle(w.careerId, 0, closing.inGameDate);
      await w.c.read(seasonServiceProvider).startNextCycle(w.careerId);
      expect(await _budget(w), rolled.budget);
    }, timeout: const Timeout(Duration(minutes: 4)));
  }

  test('a World Championship bid is settled in the rollover, before that '
      "edition's qualifying exists: a winner never plays it", () async {
    // A big side whose grounds meet the World Championship's rule.
    final big = _europe.firstWhere(
      (n) => _estateMeets(n.id, HostingRequirements.worldChampionship),
    );
    final year = CareerService.worldCupYear(1);
    bool? wins(int seed) {
      final st = WorldCupHosts.worldCupBidStanding(
        year: year,
        nations: _nations,
        seed: seed,
        nationId: big.id,
      );
      if (!st.eligible) return null;
      final permille = HostBidOdds.permilleOf(
        HostBidOdds.quote(
          size: HostBidOdds.sizeScore(_static(big.id)),
          today: st.today,
          levels: 10,
        ),
      );
      final world = [
        for (final n in _nations)
          n.id == big.id
              ? n.copyWith(
                  hostBids: {
                    HostBidding.nationKey(HostBidComp.worldChampionship, 1):
                        permille,
                  },
                )
              : n,
      ];
      final hosts = WorldCupHosts.hostsFor(
        year: year,
        nations: world,
        seed: seed,
      );
      final without = WorldCupHosts.hostsFor(
        year: year,
        nations: _nations,
        seed: seed,
      );
      // A world the bid itself turns.
      return hosts.contains(big.id) && !without.contains(big.id);
    }

    final seed = _seedWhere(wins, true);
    final w = await _world(seed: seed, nation: big);
    final careers = w.c.read(careerRepositoryProvider);
    final comp = w.c.read(competitionRepositoryProvider);
    await careers.setBudget(w.careerId, 30000000);
    await _finishCycle(w);
    final offer = (await _offers(
      w,
    )).firstWhere((o) => o.comp == HostBidComp.worldChampionship);
    expect(
      await w.c
          .read(hostBidServiceProvider)
          .place(offer, HostBidOdds.maxLevels),
      isTrue,
    );
    await w.c.read(seasonServiceProvider).startNextCycle(w.careerId);
    // No World Championship qualifying yet: it is drawn later in the cycle,
    // from hosts that are already final.
    bool wcQual(Fixture f) =>
        f.round == null &&
        f.groupId != null &&
        !f.date.isBefore(CareerService.cycleOpens(1));
    expect(
      (await comp.allFixtures(w.careerId)).where(wcQual),
      isEmpty,
    );
    final world = await w.c
        .read(nationRepositoryProvider)
        .forCareer(w.careerId);
    final hosts = WorldCupHosts.worldCupHostIds(
      year: year,
      nations: world,
      seed: seed,
    );
    expect(hosts, contains(big.id));
    await CareerService.buildWorldCupQualifying(
      comp: comp,
      nations: world,
      careerId: w.careerId,
      nationId: big.id,
      rngSeed: seed,
      cycle: 1,
      wcYear: year,
    );
    expect((await comp.allFixtures(w.careerId)).where(wcQual), isNotEmpty);
    for (final h in hosts) {
      final theirs = await comp.fixturesForNation(w.careerId, h);
      expect(theirs.where(wcQual), isEmpty, reason: 'host $h');
    }
  }, timeout: const Timeout(Duration(minutes: 4)));

  test('a pledge for a nation the manager then leaves lapses unpaid', () async {
    final seed = _seedWhere((s) => _wouldWin(s, 1) != null, true);
    final w = await _world(seed: seed);
    await _finishCycle(w);
    final offer = (await _offers(
      w,
    )).firstWhere((o) => o.comp == HostBidComp.continental);
    final service = w.c.read(hostBidServiceProvider);
    expect(await service.place(offer, 3), isTrue);
    final careers = w.c.read(careerRepositoryProvider);
    final money = await rolloverMoney(
      w.c.read(_refProvider),
      (await careers.byId(w.careerId))!,
    );
    final elsewhere = _europe.firstWhere((n) => n.id != _bidder.id).id;
    await w.c
        .read(seasonServiceProvider)
        .startNextCycle(w.careerId, switchToNationId: elsewhere);
    expect(await _budget(w), money.balance);
    final kinds = await hostBidKinds(
      w.c.read(competitionRepositoryProvider),
      w.careerId,
    );
    expect(kinds, contains(HostBidding.lapsedKind(HostBidComp.continental, 1)));
    expect(kinds.any((k) => HostBidMarker.decode(k) != null), isFalse);
    // And the manager is told: nothing stands, nothing was charged.
    final keys = await w.c
        .read(competitionRepositoryProvider)
        .messageKeys(w.careerId);
    expect(keys, contains('hostBidLapsed:cont:1:${_bidder.id}'));
  }, timeout: const Timeout(Duration(minutes: 4)));

  test('a pledge is per nation: one made for another job does not read as '
      'lodged for the nation kept, which may still bid', () async {
    final seed = _seedWhere((s) => _wouldWin(s, 1) != null, true);
    final w = await _world(seed: seed);
    await _finishCycle(w);
    // Another European side the manager was offered, whose grounds pass.
    final other = _europe.firstWhere(
      (n) =>
          n.id != _bidder.id &&
          _estateMeets(n.id, HostingRequirements.continental(n.confederation)),
    );
    final service = w.c.read(hostBidServiceProvider);
    final theirs = (await _statuses(
      w,
      other.id,
    )).firstWhere((s) => s.comp == HostBidComp.continental);
    if (theirs.offer != null) {
      expect(await service.place(theirs.offer!, 2), isTrue);
    } else {
      // Rotation-barred in this world: plant its pledge as the screen would.
      await w.c
          .read(competitionRepositoryProvider)
          .markDrawWatched(
            w.careerId,
            1,
            HostBidMarker(
              comp: HostBidComp.continental,
              editionCycle: 1,
              nationId: other.id,
              levels: 2,
              permille: 100,
            ).encodePledge(),
          );
    }
    // Back on the nation he keeps: its card is open, not "lodged", and its
    // free funds are not held back by the other nation's pledge.
    final mine = (await _statuses(
      w,
    )).firstWhere((s) => s.comp == HostBidComp.continental);
    expect(mine.lodged, isFalse);
    expect(mine.offer, isNotNull);
    final money = await rolloverMoney(
      w.c.read(_refProvider),
      (await w.c.read(careerRepositoryProvider).byId(w.careerId))!,
    );
    expect(mine.offer!.freeFunds, money.balance - money.wages);
    expect(await service.place(mine.offer!, 1), isTrue);
    // He keeps his job: his pledge is paid, the other lapses, with a message.
    await w.c.read(seasonServiceProvider).startNextCycle(w.careerId);
    expect(
      await _budget(w),
      money.balance -
          HostBidOdds.levelPrice +
          ((await hostBidKinds(
                w.c.read(competitionRepositoryProvider),
                w.careerId,
              )).any((k) => HostBidding.decodeResult(k)?.won ?? false)
              ? HostBidOdds.bonusFor(1)
              : 0),
    );
    final kinds = await hostBidKinds(
      w.c.read(competitionRepositoryProvider),
      w.careerId,
    );
    expect(
      kinds
          .where((k) => HostBidMarker.decode(k) != null)
          .map(
            (k) => HostBidMarker.decode(k)!.nationId,
          ),
      [_bidder.id],
    );
    final keys = await w.c
        .read(competitionRepositoryProvider)
        .messageKeys(w.careerId);
    expect(keys, contains('hostBidLapsed:cont:1:${other.id}'));
  }, timeout: const Timeout(Duration(minutes: 4)));

  test('an old save mid-cycle with a next-cycle bid already lodged: honoured '
      'as it was, decided in January, never charged again', () async {
    final seed = _seedWhere((s) => _wouldWin(s, 10), true);
    final w = await _world(seed: seed);
    final careers = w.c.read(careerRepositoryProvider);
    final comp = w.c.read(competitionRepositoryProvider);
    // What the first 1.0.7 builds left: the bid marker for cycle 1, lodged
    // and paid at the opening of cycle 0.
    final standing = WorldCupHosts.continentalBidStanding(
      confederation: Confederation.europe,
      cycle: 1,
      seed: seed,
      nations: _nations,
      nationId: _bidder.id,
    );
    final old = HostBidMarker(
      comp: HostBidComp.continental,
      editionCycle: 1,
      nationId: _bidder.id,
      levels: 10,
      permille: HostBidOdds.permilleOf(
        HostBidOdds.quote(
          size: HostBidOdds.sizeScore(_static(_bidder.id)),
          today: standing.today,
          levels: 10,
        ),
      ),
    );
    await comp.markDrawWatched(w.careerId, 1, old.encode());
    await careers.setBudget(w.careerId, 20000000);

    // Mid-cycle: the card says the bid is in; nothing new is offered.
    var cont = (await _statuses(
      w,
    )).firstWhere((s) => s.comp == HostBidComp.continental);
    expect(cont.lodged, isTrue);

    // January: decided as it was promised, the grant paid once.
    await careers.updateInGameDate(w.careerId, DateTime(2027, 1, 2));
    final service = w.c.read(hostBidServiceProvider);
    expect(await service.resolveDue(w.careerId), isTrue);
    final bonus = HostBidOdds.bonusFor(10);
    expect(await _budget(w), 20000000 + bonus);

    // At the close of the cycle there is still no second offer for it.
    await _finishCycle(w);
    cont = (await _statuses(
      w,
    )).firstWhere((s) => s.comp == HostBidComp.continental);
    expect(cont.offer, isNull);
    expect(cont.lodged, isTrue);

    // The rollover charges nothing for it and the host stands.
    final closing = (await careers.byId(w.careerId))!;
    final money = await rolloverMoney(w.c.read(_refProvider), closing);
    await w.c.read(seasonServiceProvider).startNextCycle(w.careerId);
    expect(await _budget(w), money.balance);
    final world = await w.c
        .read(nationRepositoryProvider)
        .forCareer(w.careerId);
    expect(
      WorldCupHosts.continentalHostsFor(
        confederation: Confederation.europe,
        cycle: 1,
        seed: seed,
        nations: world,
      ),
      contains(_bidder.id),
    );
  }, timeout: const Timeout(Duration(minutes: 4)));
}

/// A provider that hands the test a [Ref], for the helpers that take one.
final Provider<Ref> _refProvider = Provider<Ref>((ref) => ref);
