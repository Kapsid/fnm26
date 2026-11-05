import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/world_pack/pack_ranking.dart';

void main() {
  // A small world: ids 1..12 ranked 1..12, the default strength falling from
  // 80 at the top to 47 at the bottom.
  final base = {for (var i = 1; i <= 12; i++) i: i};
  final defaults = {for (var i = 1; i <= 12; i++) i: 83 - 3 * i};

  test('an untouched pack gives exactly the base ranks', () {
    expect(
      PackRanking.startingRanks(
        baseRanks: base,
        defaultStrength: defaults,
        packStrength: defaults,
      ),
      base,
    );
  });

  test('a shared base place stays shared when nothing changes', () {
    // As Belarus (6) shares Palestine's (185) place in the default world.
    final shared = {50: 1, 185: 2, 6: 2, 60: 3};
    final s = {50: 70, 185: 60, 6: 60, 60: 59};
    expect(
      PackRanking.startingRanks(
        baseRanks: shared,
        defaultStrength: s,
        packStrength: s,
      ),
      shared,
    );
  });

  test('Andorra at 90 overall climbs into the top 10', () {
    // Andorra sits 170th on about 48; a squad of 90s is +42, 168 places.
    final world = {for (var i = 1; i <= 210; i++) i: i};
    const andorra = 170;
    final strength = {
      for (var i = 1; i <= 210; i++) i: 85 - i ~/ 5,
      andorra: 48,
    };
    final ranks = PackRanking.startingRanks(
      baseRanks: world,
      defaultStrength: strength,
      packStrength: {...strength, andorra: 90},
    );
    expect(ranks[andorra], 3);
    expect(ranks.values.toSet(), {for (var i = 1; i <= 210; i++) i});
  });

  test('a weakened nation drops, ties broken by base rank', () {
    final ranks = PackRanking.startingRanks(
      baseRanks: base,
      defaultStrength: defaults,
      // Nation 1 loses one point: -1 - 4 = -5, level with nation 5, which
      // it still heads on base rank.
      packStrength: {...defaults, 1: defaults[1]! - 1},
    );
    expect(ranks[2], 1);
    expect(ranks[4], 3);
    expect(ranks[1], 4);
    expect(ranks[5], 5);
  });

  test('a nation the pack leaves out keeps its score', () {
    final pack = {...defaults}..remove(3);
    expect(
      PackRanking.startingRanks(
        baseRanks: base,
        defaultStrength: defaults,
        packStrength: pack,
      ),
      base,
    );
  });

  test('strength is the mean of the best 18', () {
    expect(PackRanking.strength([for (var i = 0; i < 23; i++) 50 + i]), 64);
    expect(PackRanking.strength([60, 70]), 65);
    expect(PackRanking.strength(const []), 0);
  });
}
