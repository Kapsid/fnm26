import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';

import '../../helpers/fixtures.dart';

/// A reported save: to be offered a small nation, a manager had to lose on
/// purpose for two cycles. Two smaller nations from other continents now
/// join the end-of-cycle offers whatever his record.
void main() {
  // A world of 120, the continents dealt round in turn, strongest first.
  final world = [
    for (var i = 0; i < 120; i++)
      nation(
        id: i + 1,
        ranking: i + 1,
        confederation: Confederation.values[i % Confederation.values.length],
      ),
  ];

  test('two smaller nations, each from a continent of its own, none from '
      'his', () {
    for (var seed = 0; seed < 50; seed++) {
      final used = <int>{world[9].id};
      final offers = smallerNationOffers(
        ordered: world,
        currentPos: 10,
        used: used,
        ownConfederation: world[9].confederation,
        rng: SeededRng(seed),
      );
      expect(offers, hasLength(smallerOffers));
      final confs = offers.map((o) => o.nation.confederation).toSet();
      expect(confs, hasLength(smallerOffers));
      expect(confs, isNot(contains(world[9].confederation)));
      for (final o in offers) {
        expect(o.position, greaterThan(25), reason: 'well below world #10');
        expect(o.nation.ranking, o.position);
        expect(used, contains(o.nation.id));
      }
    }
  });

  test('never a nation already on the table', () {
    final used = {for (var i = 26; i <= 120; i++) i}..remove(100);
    final offers = smallerNationOffers(
      ordered: world,
      currentPos: 10,
      used: used,
      ownConfederation: null,
      rng: SeededRng(1),
    );
    expect(offers.map((o) => o.nation.id), [100]);
  });

  test('none for a job already near the bottom', () {
    final offers = smallerNationOffers(
      ordered: world,
      currentPos: 110,
      used: {110},
      ownConfederation: world[109].confederation,
      rng: SeededRng(1),
    );
    expect(offers, isEmpty);
  });
}
