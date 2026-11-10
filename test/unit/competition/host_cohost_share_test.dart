@Tags(['slow'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/host_stadium_rules.dart';
import 'package:fnm/domain/services/competition/hosts.dart';

// How often a tournament is co-hosted under the stadium bars, first bars
// against the lighter ones (`HostBidding.rules3Kind`), over 20 cycles of
// eight worlds. Owner feedback (2026-11-10): the bar was so high that most
// nations could not host alone, so nearly every edition went to a joint bid.
// Joint bids still happen; they are no longer the rule.

final List<Nation> _nations =
    (jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

const int _cycles = 20;
const List<int> _seeds = [1, 7, 42, 99, 1234, 2026, 31337, 88];

/// A career managing Norway (never bidding), every edition under the stadium
/// bars: the [lighter] ones or the first.
List<Nation> _world({required bool lighter}) => [
  for (final n in _nations)
    if (n.code == 'NOR')
      n.copyWith(
        hostBids: {
          HostBidding.managerKey(0): 1,
          for (var c = 0; c <= _cycles; c++) ...{
            HostBidding.rules2Key(c): 1,
            if (lighter) HostBidding.rules3Key(c): 1,
          },
        },
      )
    else
      n,
];

typedef _Tally = ({int editions, int joint, int triple});

const _Tally _none = (editions: 0, joint: 0, triple: 0);

_Tally _add(_Tally t, List<int> hosts) => (
  editions: t.editions + 1,
  joint: t.joint + (hosts.length > 1 ? 1 : 0),
  triple: t.triple + (hosts.length > 2 ? 1 : 0),
);

double _share(_Tally t) => t.joint / t.editions;

double _tripleShare(_Tally t) => t.triple / t.editions;

({_Tally wc, Map<Confederation, _Tally> cont}) _measure(List<Nation> world) {
  var wc = _none;
  final cont = {for (final c in Confederation.values) c: _none};
  for (final seed in _seeds) {
    for (var c = 0; c < _cycles; c++) {
      wc = _add(
        wc,
        WorldCupHosts.hostsFor(year: 2030 + 4 * c, nations: world, seed: seed),
      );
      for (final conf in Confederation.values) {
        final hosts = WorldCupHosts.continentalHostsFor(
          confederation: conf,
          cycle: c,
          seed: seed,
          nations: world,
        );
        if (hosts.isNotEmpty) cont[conf] = _add(cont[conf]!, hosts);
      }
    }
  }
  return (wc: wc, cont: cont);
}

_Tally _sum(Iterable<_Tally> ts) => ts.fold(
  _none,
  (a, t) => (
    editions: a.editions + t.editions,
    joint: a.joint + t.joint,
    triple: a.triple + t.triple,
  ),
);

/// How many nations reach [comp]'s bar alone on their seed grounds.
int _alone(HostBidComp comp, {required bool lighter, Confederation? conf}) => [
  for (final n in _nations)
    if (conf == null || n.confederation == conf)
      if (HostStadiumRules.meets(
        HostStadiumRules.qualifyingSeats(nationId: n.id, editionCycle: 0),
        HostStadiumRules.of(comp, n.confederation, lighter: lighter),
      ))
        n,
].length;

void main() {
  test('the lighter bars make a joint bid the exception', () {
    final first = _measure(_world(lighter: false));
    final light = _measure(_world(lighter: true));
    String pct(double v) => '${(100 * v).toStringAsFixed(1)}%';
    String row(String label, _Tally a, _Tally b) =>
        '$label: co-hosted ${pct(_share(a))} -> ${pct(_share(b))}, '
        'three hosts ${pct(_tripleShare(a))} -> ${pct(_tripleShare(b))}';
    String alone(HostBidComp comp, [Confederation? c]) =>
        '${_alone(comp, lighter: false, conf: c)} -> '
        '${_alone(comp, lighter: true, conf: c)}';
    final lines = [
      'nations able to host alone (first -> lighter):',
      '  WC ${alone(HostBidComp.worldChampionship)}',
      for (final c in Confederation.values)
        '  ${c.name} ${alone(HostBidComp.continental, c)}',
      row('WC', first.wc, light.wc),
      for (final c in Confederation.values)
        row(c.name, first.cont[c]!, light.cont[c]!),
      row('continental', _sum(first.cont.values), _sum(light.cont.values)),
    ];
    // A measurement: the numbers are the point of running it.
    // ignore: avoid_print
    print(lines.join('\n'));

    final firstCont = _sum(first.cont.values);
    final lightCont = _sum(light.cont.values);
    expect(_share(light.wc), lessThan(_share(first.wc)));
    expect(_share(lightCont), lessThan(_share(firstCont)));
    // Most editions have one host; three is rare.
    expect(_share(light.wc), lessThanOrEqualTo(0.30));
    expect(_share(lightCont), lessThanOrEqualTo(0.30));
    expect(_tripleShare(light.wc), lessThanOrEqualTo(0.05));
    expect(_tripleShare(lightCont), lessThanOrEqualTo(0.05));
    // Co-hosting has not been switched off.
    expect(light.wc.joint, greaterThan(0));
    expect(lightCont.joint, greaterThan(0));
  });
}
