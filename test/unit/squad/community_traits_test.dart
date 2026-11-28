import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_traits.dart';

import '../../helpers/seed_pool.dart';

/// The community traits (1.1.5): rolled by chance on the player's id and the
/// save seed, nudged by his attributes, into room the older traits leave.
const _community = [
  PlayerTrait.twelfthMan,
  PlayerTrait.consistent,
  PlayerTrait.inconsistent,
  PlayerTrait.injuryProne,
  PlayerTrait.easilyTired,
  PlayerTrait.poorUnderPressure,
  PlayerTrait.individualistic,
];
const _positive = {PlayerTrait.twelfthMan, PlayerTrait.consistent};

/// Saves the distribution is checked in.
const _seeds = [0, 42, 7];

/// A digest of every player's OLDER traits over the seed pool, for each of
/// [_seeds], taken from the build before the community traits: adding them
/// must not have moved one.
const _earnedDigest = {0: 644284956, 42: 1537037777, 7: 713132871};

int _digest(List<Player> pool, int seed) {
  var h = 17;
  for (final p in pool) {
    for (final x in PlayerTraits.earnedOf(p, saveSeed: seed)) {
      h = (h * 31 + p.id * 13 + x.index + 1) & 0x7fffffff;
    }
    h = (h * 31 + 7) & 0x7fffffff;
  }
  return h;
}

void main() {
  final pool = seedPool();

  group('the older traits are untouched', () {
    for (final seed in _seeds) {
      test('seed $seed: every player keeps exactly the traits he had', () {
        expect(_digest(pool, seed), _earnedDigest[seed]);
        for (final p in pool) {
          final earned = PlayerTraits.earnedOf(p, saveSeed: seed);
          final now = PlayerTraits.of(p, saveSeed: seed);
          expect(now.take(earned.length).toList(), earned, reason: '${p.id}');
          // Whatever was added is a community trait, in a free slot.
          expect(now.skip(earned.length).every(_community.contains), isTrue);
        }
      });
    }
  });

  group('distribution over the seed pool', () {
    for (final seed in _seeds) {
      test('seed $seed: each trait on about 3-6% of players, negatives '
          'rarer', () {
        final counts = {for (final t in _community) t: 0};
        for (final p in pool) {
          for (final t in PlayerTraits.of(p, saveSeed: seed)) {
            if (counts.containsKey(t)) counts[t] = counts[t]! + 1;
          }
        }
        final share = {
          for (final e in counts.entries) e.key: e.value / pool.length,
        };
        for (final e in share.entries) {
          expect(e.value, inInclusiveRange(0.03, 0.06), reason: '${e.key}');
        }
        double mean(Iterable<double> v) => v.reduce((a, b) => a + b) / v.length;
        final pos = mean([
          for (final t in _community)
            if (_positive.contains(t)) share[t]!,
        ]);
        final neg = mean([
          for (final t in _community)
            if (!_positive.contains(t)) share[t]!,
        ]);
        expect(neg, lessThan(pos));
        // Still a distinguishing mark: most players carry no trait at all.
        final none = pool
            .where((p) => PlayerTraits.of(p, saveSeed: seed).isEmpty)
            .length;
        expect(none / pool.length, greaterThan(0.5));
      });
    }

    test('attributes nudge the odds, chance decides', () {
      double shareOf(PlayerTrait t, bool Function(Player) who) {
        final group = pool.where(who).toList();
        return group
                .where((p) => PlayerTraits.of(p, saveSeed: 42).contains(t))
                .length /
            group.length;
      }

      bool outfield(Player p) => p.category != PositionCategory.goalkeeper;
      expect(
        shareOf(
          PlayerTrait.easilyTired,
          (p) => outfield(p) && p.attributes.stamina < 62,
        ),
        greaterThan(
          2 *
              shareOf(
                PlayerTrait.easilyTired,
                (p) => outfield(p) && p.attributes.stamina >= 80,
              ),
        ),
      );
      expect(
        shareOf(
          PlayerTrait.individualistic,
          (p) =>
              p.category == PositionCategory.forward &&
              p.attributes.technical >= 76,
        ),
        greaterThan(
          2 *
              shareOf(
                PlayerTrait.individualistic,
                (p) => p.category == PositionCategory.defender,
              ),
        ),
      );
      // A high-stamina man can still tire easily: it is mostly chance.
      expect(
        shareOf(
          PlayerTrait.easilyTired,
          (p) => outfield(p) && p.attributes.stamina >= 80,
        ),
        greaterThan(0),
      );
    });
  });

  group('rules', () {
    test('the cap, one community trait at most, and the exclusions', () {
      for (final seed in _seeds) {
        for (final p in pool) {
          final t = PlayerTraits.of(p, saveSeed: seed);
          expect(t.length, lessThanOrEqualTo(PlayerTraits.maxTraits));
          expect(t.toSet().length, t.length);
          expect(t.where(_community.contains).length, lessThanOrEqualTo(1));
          for (final a in t) {
            for (final b in t) {
              expect(PlayerTraits.excludes(a, b), isFalse, reason: '$t');
            }
          }
          if (p.category == PositionCategory.goalkeeper) {
            expect(t, isNot(contains(PlayerTrait.twelfthMan)));
            expect(t, isNot(contains(PlayerTrait.easilyTired)));
            expect(t, isNot(contains(PlayerTrait.individualistic)));
          }
        }
      }
      expect(
        PlayerTraits.excludes(PlayerTrait.injuryProne, PlayerTrait.ironMan),
        isTrue,
      );
      expect(
        PlayerTraits.excludes(PlayerTrait.ironMan, PlayerTrait.easilyTired),
        isTrue,
      );
      expect(
        PlayerTraits.excludes(
          PlayerTrait.bigGame,
          PlayerTrait.poorUnderPressure,
        ),
        isTrue,
      );
      expect(
        PlayerTraits.excludes(PlayerTrait.leader, PlayerTrait.injuryProne),
        isFalse,
      );
    });

    test('stable across sessions: a pure function of id and save', () {
      for (final p in pool.take(3000)) {
        expect(
          PlayerTraits.of(p, saveSeed: 9),
          PlayerTraits.of(p, saveSeed: 9),
        );
        // A copy of the player (as a reload builds) rolls the same.
        expect(
          PlayerTraits.of(p.copyWith(), saveSeed: 9),
          PlayerTraits.of(p, saveSeed: 9),
        );
      }
    });

    test('a world pack or editor pick overrides the roll', () {
      final p = pool.firstWhere(
        (p) => PlayerTraits.of(p, saveSeed: 42).isEmpty,
      );
      final picked = p.copyWith(
        fixedTraits: const [PlayerTrait.twelfthMan, PlayerTrait.consistent],
      );
      expect(PlayerTraits.of(picked, saveSeed: 42), [
        PlayerTrait.twelfthMan,
        PlayerTrait.consistent,
      ]);
      // And a pick of none rolls nothing, community traits included.
      final rolled = pool.firstWhere(
        (p) => PlayerTraits.of(
          p,
          saveSeed: 42,
        ).any(_community.contains),
      );
      expect(
        PlayerTraits.of(rolled.copyWith(fixedTraits: const []), saveSeed: 42),
        isEmpty,
      );
    });
  });
}
