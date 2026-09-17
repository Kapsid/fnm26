import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/persona.dart';

/// The feed used to draw a fresh name for every post, so nobody appeared twice
/// and the country had no faces in it. These are the two properties that turn
/// a shuffle into a cast: the same people come back, and they have opinions
/// that move.
void main() {
  const names = [
    'HomeEndHarry',
    'ScarfAndFlask',
    'AwayDayAnna',
    'TerraceTom',
    'BadgeKisser',
    'EternalOptimist',
    'LongSufferingLen',
  ];

  List<YPersona> cast({String nation = 'Czechia', int seed = 7}) =>
      YCast.of(names, nation: nation, seed: seed, voiceKey: 'fan');

  group('the cast', () {
    test('is small, so the manager learns who they are', () {
      expect(cast(), hasLength(YCast.castSize));
    });

    test('is the same people all career', () {
      expect(cast(), cast());
    });

    test('is different next door', () {
      expect(cast(nation: 'Poland'), isNot(cast()));
    });

    test('is different in another save of the same nation', () {
      expect(cast(seed: 8), isNot(cast()));
    });

    test('never repeats a person within itself', () {
      final handles = cast().map((p) => p.handle).toList();
      expect(handles.toSet(), hasLength(handles.length));
    });

    test('a trait belongs to the name, not the slot', () {
      // The same account is the same character wherever it turns up, which is
      // what makes it a person rather than a reroll.
      final everywhere = [
        for (final n in ['Czechia', 'Poland', 'Brazil', 'Wales'])
          for (final p in cast(nation: n)) p,
      ];
      final byName = <String, Set<YTrait>>{};
      for (final p in everywhere) {
        (byName[p.displayName] ??= {}).add(p.trait);
      }
      for (final entry in byName.entries) {
        expect(entry.value, hasLength(1), reason: entry.key);
      }
    });

    test('the same event always draws the same author', () {
      final c = cast();
      expect(YCast.pick(c, 'fx:41'), YCast.pick(c, 'fx:41'));
    });
  });

  group('stance', () {
    YPersona of(YTrait t) => (handle: '@x', displayName: 'x', trait: t);

    test('starts where the character starts', () {
      expect(YCast.stance(of(YTrait.loyalist), const []), greaterThan(0));
      expect(YCast.stance(of(YTrait.doomer), const []), lessThan(0));
    });

    test('a run of humiliations turns everybody, in the same direction', () {
      final bad = List.filled(6, ResultStanding.humiliating);
      for (final t in YTrait.values) {
        final p = of(t);
        expect(
          YCast.stance(p, bad),
          lessThan(YCast.stance(p, const [])),
          reason: t.name,
        );
      }
    });

    test('but it turns a cynic further than a loyalist', () {
      final bad = List.filled(6, ResultStanding.humiliating);
      final cynicFall =
          YCast.stance(of(YTrait.cynic), const []) -
          YCast.stance(of(YTrait.cynic), bad);
      final loyalFall =
          YCast.stance(of(YTrait.loyalist), const []) -
          YCast.stance(of(YTrait.loyalist), bad);
      expect(cynicFall, greaterThan(loyalFall));
    });

    test('the numbers desk reacts less than anybody', () {
      // Not "less than 40" — that is a number I would have to keep in step
      // with the tuning. The property is that the stats account is the least
      // moved thing on the feed, whatever the dials say.
      final bad = List.filled(6, ResultStanding.humiliating);
      final good = List.filled(6, ResultStanding.heroic);
      int span(YTrait t) =>
          (YCast.stance(of(t), good) - YCast.stance(of(t), bad)).abs();
      final stats = span(YTrait.statshead);
      for (final t in YTrait.values) {
        if (t == YTrait.statshead) continue;
        expect(
          stats,
          lessThan(span(t)),
          reason: 'it should be steadier than a ${t.name}',
        );
      }
    });

    test('what just happened outweighs what happened a year ago', () {
      final p = of(YTrait.cynic);
      final recovering = [
        ...List.filled(5, ResultStanding.humiliating),
        ...List.filled(3, ResultStanding.heroic),
      ];
      final collapsing = [
        ...List.filled(5, ResultStanding.heroic),
        ...List.filled(3, ResultStanding.humiliating),
      ];
      expect(
        YCast.stance(p, recovering),
        greaterThan(YCast.stance(p, collapsing)),
      );
    });

    test('stays on the scale whatever it is fed', () {
      for (final t in YTrait.values) {
        for (final h in [
          List.filled(40, ResultStanding.heroic),
          List.filled(40, ResultStanding.humiliating),
        ]) {
          final s = YCast.stance(of(t), h);
          expect(s, inInclusiveRange(-100, 100), reason: t.name);
        }
      }
    });
  });

  group('tone', () {
    YPersona of(YTrait t) => (handle: '@x', displayName: 'x', trait: t);

    test('a loyalist is kinder about the same defeat than a doomer', () {
      final loyal = YCast.toneFor(
        of(YTrait.loyalist),
        ResultStanding.poor,
        YCast.stance(of(YTrait.loyalist), const []),
      );
      final doom = YCast.toneFor(
        of(YTrait.doomer),
        ResultStanding.poor,
        YCast.stance(of(YTrait.doomer), const []),
      );
      expect(loyal.index, lessThan(doom.index));
    });

    test('a contrarian takes the other side of a triumph', () {
      final tone = YCast.toneFor(
        of(YTrait.contrarian),
        ResultStanding.heroic,
        0,
      );
      expect(tone, YTone.sour);
    });

    test('the numbers desk has no tone at all', () {
      for (final s in ResultStanding.values) {
        expect(YCast.toneFor(of(YTrait.statshead), s, 90), YTone.neutral);
      }
    });
  });

  group('bands', () {
    test('split a template three ways and lose nothing', () {
      for (final total in [3, 4, 6, 8, 12]) {
        final covered = <int>{};
        for (final tone in YTone.values) {
          final (offset, size) = YCast.band(tone, total);
          for (var i = 0; i < size; i++) {
            covered.add(offset + i);
          }
        }
        expect(
          covered,
          {for (var i = 0; i < total; i++) i},
          reason: 'total $total leaves a phrasing unreachable',
        );
      }
    });

    test('a variant always lands inside its own band', () {
      for (final tone in YTone.values) {
        final (offset, size) = YCast.band(tone, 12);
        for (var i = 0; i < 50; i++) {
          final v = YCast.variantFor(key: 'fx:$i', tone: tone, total: 12);
          expect(v, inInclusiveRange(offset, offset + size - 1));
        }
      }
    });

    test('a tiny template still resolves', () {
      for (final tone in YTone.values) {
        expect(YCast.variantFor(key: 'k', tone: tone, total: 1), 0);
      }
    });
  });
}
