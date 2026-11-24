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
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/nation/nation_geography.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/host_bid_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

// The joint host bid end to end, in a career created now (stadium bars on):
// the offer's partners, lodging with one, the rollover paying and deciding
// it, and the news naming both hosts.

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

final HostBar _euro = HostStadiumRules.continentalLighter(
  Confederation.europe,
);

List<int> _seats(Nation n) =>
    HostStadiumRules.qualifyingSeats(nationId: n.id, editionCycle: 1);

bool _brings(Nation n) =>
    _seats(n).where((s) => s >= _euro.otherSeats).length >=
    HostStadiumRules.minGroundsPerCoHost;

String _sub(Nation n) =>
    NationGeography.subregionFor(n.code, n.confederation.name);

final List<Nation> _europe =
    _nations.where((n) => n.confederation == Confederation.europe).toList()
      ..sort((a, b) => a.ranking.compareTo(b.ranking));

/// A European side short of the EURO's bar alone that a neighbour's grounds
/// carry over it.
final Nation _short = _europe.firstWhere(
  (n) =>
      !HostStadiumRules.meets(_seats(n), _euro) &&
      _brings(n) &&
      _europe.any(
        (p) =>
            p.id != n.id &&
            _sub(p) == _sub(n) &&
            _brings(p) &&
            HostStadiumRules.meets([..._seats(n), ..._seats(p)], _euro),
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
  await c.read(careerRepositoryProvider).setBudget(career.id, 30000000);
  return (c: c, careerId: career.id);
}

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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('partners: neighbours first, of the same confederation, never the '
      'bidder, each with its answer; asked again, the same answers', () async {
    final ger = _code('GER');
    final w = await _world(ger);
    expect(
      (await _contStatus(w)).offer,
      isNull,
      reason: 'no offer before the window',
    );
    await _finishCycle(w);
    final offer = (await _contStatus(w)).offer!;
    expect(offer.soloAllowed, isTrue);
    expect(offer.partners, isNotEmpty);
    expect(offer.partners.length, lessThanOrEqualTo(maxCoHostOptions));
    var seenDistant = false;
    for (final o in offer.partners) {
      expect(o.nation.id, isNot(ger.id));
      expect(o.nation.confederation, Confederation.europe);
      expect(o.neighbour, _sub(o.nation) == _sub(ger));
      // Neighbours are listed before the rest.
      if (!o.neighbour) seenDistant = true;
      if (seenDistant) expect(o.neighbour, isFalse);
      // Pooled grounds score at least what the lead's alone do.
      expect(o.size, greaterThanOrEqualTo(offer.size));
    }
    final again = (await _contStatus(w)).offer!;
    expect(
      [for (final o in again.partners) (o.nation.id, o.decline)],
      [for (final o in offer.partners) (o.nation.id, o.decline)],
    );
  });

  test('short of the bar alone: open only jointly; a partner that '
      'declines cannot be named; one that agrees is lodged beside the '
      'pledge', () async {
    final w = await _world(_short);
    await _finishCycle(w);
    final s = await _contStatus(w);
    expect(s.belowBar, isTrue);
    final offer = s.offer;
    expect(offer, isNotNull, reason: '${_short.name}: no joint offer');
    expect(offer!.soloAllowed, isFalse);
    for (final o in offer.partners) {
      expect(
        HostStadiumRules.meets([..._seats(_short), ..._seats(o.nation)], _euro),
        isTrue,
        reason: o.nation.name,
      );
    }
    final service = w.c.read(hostBidServiceProvider);
    // Alone: refused.
    expect(await service.place(offer, 1), isFalse);
    // Not one of the offer's partners: refused.
    expect(await service.place(offer, 1, partnerId: _code('BRA').id), isFalse);
    for (final o in offer.partners.where((o) => !o.agrees)) {
      expect(await service.place(offer, 1, partnerId: o.nation.id), isFalse);
    }
    final yes = offer.partners.firstWhere((o) => o.agrees);
    expect(await service.place(offer, 2, partnerId: yes.nation.id), isTrue);
    final comp = w.c.read(competitionRepositoryProvider);
    final kinds = await hostBidKinds(comp, w.careerId);
    expect(
      HostBidPartnerMarker.partnerIn(
        kinds,
        HostBidComp.continental,
        1,
        _short.id,
      ),
      yes.nation.id,
    );
    final pledge = kinds
        .map(HostBidMarker.decodePledge)
        .firstWhere((m) => m != null)!;
    expect(
      pledge.permille,
      HostBidOdds.permilleOf(offer.quote(2, partner: yes)),
    );
    final after = await _contStatus(w);
    expect(after.lodged, isTrue);
    expect(after.pledgePartner?.id, yes.nation.id);
    // A pledge is no part of the draw yet: the partner rides on no nation.
    final world = await w.c
        .read(nationRepositoryProvider)
        .forCareer(w.careerId);
    expect(
      world.any(
        (n) => n.hostBids.containsKey(
          HostBidding.partnerKey(HostBidComp.continental, 1),
        ),
      ),
      isFalse,
    );
  });

  test('the rollover pays the joint bid, both nations host, the grant is '
      'shared and the news names both hosts', () async {
    final ger = _code('GER');
    final w = await _world(ger);
    await _finishCycle(w);
    final offer = (await _contStatus(w)).offer!;
    final partner = offer.partners.firstWhere((o) => o.agrees).nation;
    // A bid all but certain to win (the chance the screen would show is
    // pinned in the domain tests): the pledge as the service writes it.
    final comp = w.c.read(competitionRepositoryProvider);
    const levels = 4;
    await comp.markDrawWatched(
      w.careerId,
      1,
      HostBidMarker(
        comp: HostBidComp.continental,
        editionCycle: 1,
        nationId: ger.id,
        levels: levels,
        permille: 999,
      ).encodePledge(),
    );
    await comp.markDrawWatched(
      w.careerId,
      1,
      HostBidding.newBuildKind(HostBidComp.continental, 1, ger.id),
    );
    await comp.markDrawWatched(
      w.careerId,
      1,
      HostBidPartnerMarker(
        comp: HostBidComp.continental,
        editionCycle: 1,
        nationId: ger.id,
        partnerId: partner.id,
      ).encode(),
    );
    final careers = w.c.read(careerRepositoryProvider);
    final closing = (await careers.byId(w.careerId))!;
    final money = await rolloverMoney(w.c.read(_refProvider), closing);

    await w.c.read(seasonServiceProvider).startNextCycle(w.careerId);
    final rolled = (await careers.byId(w.careerId))!;
    expect(rolled.cyclePointer, 1);

    final world = await w.c
        .read(nationRepositoryProvider)
        .forCareer(w.careerId);
    final hosts = WorldCupHosts.continentalHostsFor(
      confederation: Confederation.europe,
      cycle: 1,
      seed: 11,
      nations: world,
    );
    expect(hosts, [ger.id, partner.id]);
    final kinds = await hostBidKinds(comp, w.careerId);
    final result = kinds
        .map(HostBidding.decodeResult)
        .firstWhere(
          (r) => r != null,
        )!;
    expect(result.won, isTrue);
    expect(result.bonus, HostBidOdds.jointBonusFor(levels));
    expect(
      rolled.budget,
      money.balance -
          levels * HostBidOdds.levelPrice +
          HostBidOdds.jointBonusFor(levels),
    );
    final messages = await comp.messages(w.careerId);
    final news = messages.where((m) => m.title.startsWith('Bid won'));
    expect(news, hasLength(1));
    expect(news.first.body, contains('${ger.name} & ${partner.name}'));
    // Neither host plays the qualifiers.
    final field = {
      for (final n in WorldCupHosts.continentalQualifiers(
        confederation: Confederation.europe,
        cycle: 1,
        seed: 11,
        nations: world,
      ))
        n.id,
    };
    expect(field.contains(ger.id), isFalse);
    expect(field.contains(partner.id), isFalse);
  }, timeout: const Timeout(Duration(minutes: 4)));
}

final Provider<Ref> _refProvider = Provider<Ref>((ref) => ref);
