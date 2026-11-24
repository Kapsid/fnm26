import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/nation/nation_geography.dart';

// A joint host bid: the manager's federation bids with a co-host partner.
// The marker, the evaluation (pure), the partner's answer, and the host draw
// it plugs into.

final List<Nation> _nations =
    (jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

Nation _code(String code) => _nations.firstWhere((n) => n.code == code);

String _sub(Nation n) =>
    NationGeography.subregionFor(n.code, n.confederation.name);

/// A mid-table European lead and a neighbour of the same subregion.
final Nation _lead = _code('CZE');
final Nation _partner =
    (_nations
            .where(
              (n) =>
                  n.id != _lead.id &&
                  n.confederation == _lead.confederation &&
                  _sub(n) == _sub(_lead),
            )
            .toList()
          ..sort(
            (a, b) => (a.ranking - _lead.ranking).abs().compareTo(
              (b.ranking - _lead.ranking).abs(),
            ),
          ))
        .first;

/// The world of a career managed by [_lead] through cycles 0 and 1 (the
/// current host rules), with its continental bid for cycle 1 at [permille]
/// (none when null) and the co-host it names ([partner], none when null).
List<Nation> _world({int? permille, int? partner, bool v2 = false}) => [
  for (final n in _nations)
    if (n.id == _lead.id)
      n.copyWith(
        hostBids: {
          HostBidding.managerKey(0): 1,
          HostBidding.managerKey(1): 1,
          if (v2) ...{
            for (var c = 0; c <= 1; c++) ...{
              HostBidding.rules2Key(c): 1,
              HostBidding.rules3Key(c): 1,
            },
          },
          HostBidding.nationKey(HostBidComp.continental, 1): ?permille,
          HostBidding.partnerKey(HostBidComp.continental, 1): ?partner,
        },
      )
    else
      n,
];

List<int> _contHosts(List<Nation> world, int seed) =>
    WorldCupHosts.continentalHostsFor(
      confederation: Confederation.europe,
      cycle: 1,
      seed: seed,
      nations: world,
    );

void main() {
  test('the neighbour picked for the tests is a real European neighbour', () {
    expect(_partner.confederation, Confederation.europe);
    expect(_sub(_partner), _sub(_lead));
  });

  group('the partner marker', () {
    test('round-trips, and no read of the bids takes it for one', () {
      const m = HostBidPartnerMarker(
        comp: HostBidComp.worldChampionship,
        editionCycle: 3,
        nationId: 12,
        partnerId: 47,
      );
      final kind = m.encode();
      expect(kind, 'hostBidPartner:wc:3:12:47');
      final back = HostBidPartnerMarker.decode(kind)!;
      expect(back.comp, HostBidComp.worldChampionship);
      expect(back.editionCycle, 3);
      expect(back.nationId, 12);
      expect(back.partnerId, 47);
      expect(HostBidMarker.decode(kind), isNull);
      expect(HostBidMarker.decodePledge(kind), isNull);
      expect(HostBidding.decodeResult(kind), isNull);
      expect(HostBidPartnerMarker.decode('hostBid:wc:3:12:5:300'), isNull);
      expect(
        HostBidPartnerMarker.partnerIn([kind], m.comp, 3, 12),
        47,
      );
      expect(HostBidPartnerMarker.partnerIn([kind], m.comp, 3, 13), isNull);
    });

    test('its nation key is no bid key', () {
      for (final c in HostBidComp.values) {
        expect(
          HostBidding.partnerKey(c, 2),
          isNot(HostBidding.nationKey(c, 2)),
        );
        expect(HostBidding.partnerKey(c, 2).startsWith('mgr:'), isFalse);
      }
    });
  });

  group('the joint evaluation', () {
    test('pooled grounds raise the base and the ceiling', () {
      final solo = HostBidOdds.quote(size: 0.3, today: 0.04, levels: 3);
      final joint = HostBidOdds.jointQuote(
        size: 0.6,
        today: 0.04,
        levels: 3,
        partnerRank: 30,
        neighbour: true,
      );
      expect(joint.base, greaterThan(solo.base));
      expect(joint.cap, greaterThan(solo.cap));
      expect(joint.total, greaterThan(solo.total));
    });

    test('a strong neighbour helps more than a weak one far away', () {
      HostBidQuote q({required int rank, required bool neighbour}) =>
          HostBidOdds.jointQuote(
            size: 0.5,
            today: 0.05,
            levels: 5,
            partnerRank: rank,
            neighbour: neighbour,
          );
      final strong = q(rank: 3, neighbour: true);
      final weak = q(rank: 150, neighbour: true);
      final far = q(rank: 3, neighbour: false);
      expect(strong.total, greaterThan(weak.total));
      expect(strong.total, greaterThan(far.total));
      expect(HostBidOdds.partnerAppeal(partnerRank: 1, neighbour: true), 0.03);
      expect(
        HostBidOdds.partnerAppeal(partnerRank: 200, neighbour: false),
        closeTo(-0.06, 1e-9),
      );
    });

    test('never certain, never below the floor, money still helps', () {
      for (final size in [0.0, 0.3, 1.0]) {
        for (final rank in [1, 60, 200]) {
          for (final near in [true, false]) {
            var last = -1.0;
            for (var l = 0; l <= HostBidOdds.maxLevels; l++) {
              final q = HostBidOdds.jointQuote(
                size: size,
                today: 0.1,
                levels: l,
                partnerRank: rank,
                neighbour: near,
              );
              expect(q.total, lessThanOrEqualTo(0.65 + 1e-9));
              expect(q.total, greaterThan(0));
              expect(q.base, lessThanOrEqualTo(q.cap));
              expect(q.total, greaterThanOrEqualTo(last));
              last = q.total;
            }
          }
        }
      }
    });

    test('a won joint bid pays a share of the grant', () {
      for (var l = 1; l <= HostBidOdds.maxLevels; l++) {
        expect(HostBidOdds.jointBonusFor(l), lessThan(HostBidOdds.bonusFor(l)));
        expect(
          HostBidOdds.jointBonusFor(l),
          HostBidOdds.bonusFor(l) * 3 ~/ 4,
        );
      }
    });
  });

  group("the partner's answer", () {
    CoHostDecline? ask(
      int partnerId, {
      double leadToday = 0.1,
      double partnerToday = 0.05,
      bool neighbour = true,
    }) => CoHostAnswer.of(
      seed: 7,
      comp: HostBidComp.continental,
      editionCycle: 1,
      leadId: _lead.id,
      partnerId: partnerId,
      leadToday: leadToday,
      partnerToday: partnerToday,
      neighbour: neighbour,
    );

    test('is the same every time it is asked', () {
      for (var id = 1; id < 60; id++) {
        expect(ask(id), ask(id));
      }
    });

    test('a weaker neighbour declines only for lack of funds, now and '
        'again', () {
      final answers = [for (var id = 1; id <= 400; id++) ask(id)];
      expect(answers.where((a) => a == CoHostDecline.ownBid), isEmpty);
      expect(answers.where((a) => a == CoHostDecline.tooFar), isEmpty);
      final funds = answers.where((a) => a == CoHostDecline.funds).length;
      expect(funds / answers.length, closeTo(CoHostAnswer.fundsChance, 0.05));
    });

    test('a stronger nation often prefers its own bid; a distant one finds '
        'it too far', () {
      final strong = [
        for (var id = 1; id <= 400; id++)
          ask(id, leadToday: 0.02, partnerToday: 0.2),
      ];
      final own = strong.where((a) => a == CoHostDecline.ownBid).length;
      expect(own / strong.length, closeTo(CoHostAnswer.ownBidChance, 0.07));
      final far = [for (var id = 1; id <= 400; id++) ask(id, neighbour: false)];
      expect(far.where((a) => a == CoHostDecline.tooFar), isNotEmpty);
      expect(far.where((a) => a == CoHostDecline.ownBid), isEmpty);
    });
  });

  group('the host draw', () {
    test('a joint bid stands on the ballot as one candidature, and the '
        'partner stands in no other', () {
      final world = _world(permille: 300, partner: _partner.id);
      for (var seed = 1; seed <= 20; seed++) {
        final bids = WorldCupHosts.continentalBids(
          confederation: Confederation.europe,
          cycle: 1,
          seed: seed,
          nations: world,
        );
        final mine = bids.where((b) => b.contains(_lead.id)).toList();
        // The lead may be barred in some worlds (a recent host); then no
        // joint bid stands either.
        if (mine.isEmpty) {
          expect(bids.any((b) => b.contains(_partner.id)), isFalse);
          continue;
        }
        expect(mine.single, [_lead.id, _partner.id]);
        expect(
          bids.where((b) => b.contains(_partner.id)),
          hasLength(1),
          reason: 'seed $seed',
        );
      }
    });

    for (final v2 in [false, true]) {
      test('won, both nations host (lead first) and neither plays the '
          'qualifiers; lost, the lead does not host${v2 ? ' (bars)' : ''}', () {
        final world = _world(permille: 500, partner: _partner.id, v2: v2);
        var wins = 0;
        var losses = 0;
        for (var seed = 1; seed <= 60 && (wins < 2 || losses < 2); seed++) {
          final hosts = _contHosts(world, seed);
          if (hosts.contains(_lead.id)) {
            wins++;
            expect(hosts, [_lead.id, _partner.id], reason: 'seed $seed');
            final field = {
              for (final n in WorldCupHosts.continentalQualifiers(
                confederation: Confederation.europe,
                cycle: 1,
                seed: seed,
                nations: world,
              ))
                n.id,
            };
            expect(field.contains(_lead.id), isFalse);
            expect(field.contains(_partner.id), isFalse);
            // The finals are staged over both nations' grounds.
            final venues = VenueGenerator.forHosts(hostIds: hosts);
            expect(venues.keys, containsAll(<int>[_lead.id, _partner.id]));
            expect(venues[_partner.id], isNotEmpty);
          } else {
            losses++;
            expect(hosts, isNot(contains(_partner.id)), reason: 'seed $seed');
          }
        }
        expect(wins, greaterThan(0));
        expect(losses, greaterThan(0));
      });
    }

    test('it wins as often as the chance it froze', () {
      final world = _world(permille: 400, partner: _partner.id);
      var stood = 0;
      var won = 0;
      for (var seed = 1; seed <= 300; seed++) {
        final bids = WorldCupHosts.continentalBids(
          confederation: Confederation.europe,
          cycle: 1,
          seed: seed,
          nations: world,
        );
        if (!bids.any((b) => b.contains(_lead.id))) continue;
        stood++;
        if (_contHosts(world, seed).contains(_lead.id)) won++;
      }
      expect(stood, greaterThan(150));
      expect(won / stood, closeTo(0.40, 0.08));
    });

    test('a partner of another confederation is ignored: the bid is drawn '
        'as the solo bid it then is', () {
      final foreign = _code('BRA');
      final joint = _world(permille: 300, partner: foreign.id);
      final solo = _world(permille: 300);
      for (var seed = 1; seed <= 30; seed++) {
        expect(_contHosts(joint, seed), _contHosts(solo, seed));
      }
    });

    test('a World Championship joint bid: both host when it wins', () {
      List<Nation> world(int? partner) => [
        for (final n in _nations)
          if (n.id == _lead.id)
            n.copyWith(
              hostBids: {
                HostBidding.managerKey(0): 1,
                HostBidding.managerKey(1): 1,
                HostBidding.nationKey(HostBidComp.worldChampionship, 1): 600,
                HostBidding.partnerKey(HostBidComp.worldChampionship, 1):
                    ?partner,
              },
            )
          else
            n,
      ];
      final joint = world(_partner.id);
      var wins = 0;
      for (var seed = 1; seed <= 40 && wins < 2; seed++) {
        final hosts = WorldCupHosts.hostsFor(
          year: 2034,
          nations: joint,
          seed: seed,
        );
        if (!hosts.contains(_lead.id)) continue;
        wins++;
        expect(hosts, [_lead.id, _partner.id]);
        final bids = WorldCupHosts.worldCupBids(
          year: 2034,
          nations: joint,
          seed: seed,
        );
        expect(bids, anyElement(equals([_lead.id, _partner.id])));
      }
      expect(wins, greaterThan(0));
    });
  });
}
