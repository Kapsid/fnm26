import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/y_feed.dart';

void main() {
  YMatch match({
    int mine = 30,
    int theirs = 30,
    int scored = 1,
    int conceded = 1,
    String key = 'fx:1',
  }) =>
      (
        opponent: 'Norway',
        nationRank: mine,
        opponentRank: theirs,
        scored: scored,
        conceded: conceded,
        date: DateTime(2030, 6, 10),
        key: key,
      );

  List<YPost> posts(YMatch m) =>
      YFeed.forMatch(m, nation: 'Czechia', seed: 4242);

  group('YFeed.forMatch', () {
    test('every match is worth saying something about', () {
      expect(posts(match()), isNotEmpty);
    });

    test('the same match always produces the same feed', () {
      final a = posts(match());
      final b = posts(match());
      expect(
        [for (final p in a) '${p.handle}|${p.template}|${p.variant}'],
        [for (final p in b) '${p.handle}|${p.template}|${p.variant}'],
      );
    });

    test('an upset win is read as an upset', () {
      final p = posts(match(mine: 70, theirs: 4, scored: 2, conceded: 1));
      expect(p.map((x) => x.template), contains(YTemplate.winUpset));
    });

    test('a routine win is read as routine', () {
      final p = posts(match(mine: 4, theirs: 70, scored: 3, conceded: 0));
      expect(p.map((x) => x.template), contains(YTemplate.winRoutine));
    });

    test('a humiliation brings out the rivals', () {
      final p = posts(match(mine: 4, theirs: 70, scored: 0, conceded: 3));
      expect(p.map((x) => x.template), contains(YTemplate.lostBadly));
      expect(p.map((x) => x.voice), contains(YVoice.rival));
    });

    test('a bad day says more than a routine one', () {
      final routine = posts(match(mine: 4, theirs: 70, scored: 2, conceded: 0));
      final disaster = posts(match(mine: 4, theirs: 70, scored: 0, conceded: 4));
      expect(disaster.length, greaterThan(routine.length));
    });

    test('every variant index is renderable', () {
      // The UI switches on (template, variant); an index outside the range
      // would render as a blank post.
      for (var i = 0; i < 200; i++) {
        for (final p in posts(match(key: 'fx:$i', scored: i % 4))) {
          expect(p.variant, inInclusiveRange(0, YFeed.variantCount - 1));
        }
      }
    });

    test('every post carries the arguments its template needs', () {
      for (final p in posts(match())) {
        expect(p.args, isNotEmpty);
        expect(p.handle, startsWith('@'));
        expect(p.displayName, isNotEmpty);
      }
    });
  });

  group('mostRecent', () {
    YPost at(DateTime d) => (
          voice: YVoice.stats,
          handle: '@s',
          displayName: 's',
          template: YTemplate.drew,
          variant: 0,
          args: const ['Norway', '1–1'],
          date: d,
          key: 'k${d.millisecondsSinceEpoch}',
        );

    test('newest first, and capped', () {
      final all = [for (var i = 0; i < 120; i++) at(DateTime(2030, 1, 1 + i))];
      final feed = YFeed.mostRecent(all..shuffle());
      expect(feed, hasLength(60));
      for (var i = 1; i < feed.length; i++) {
        expect(feed[i].date.isAfter(feed[i - 1].date), isFalse);
      }
    });

    test('a short feed is left alone', () {
      expect(YFeed.mostRecent([at(DateTime(2030, 1, 1))]), hasLength(1));
    });
  });

  group('the pundit', () {
    test('is the same man all career', () {
      expect(YFeed.punditHandle('Czechia', 4242),
          YFeed.punditHandle('Czechia', 4242));
    });

    test('but a different one in another country', () {
      expect(YFeed.punditHandle('Czechia', 4242),
          isNot(YFeed.punditHandle('Brazil', 4242)));
    });
  });

  group('YFeed.forEvent', () {
    test('a one-off event still produces a post', () {
      final p = YFeed.forEvent(
        template: YTemplate.hostNamed,
        args: const ['Spain'],
        date: DateTime(2030, 1, 5),
        key: 'host:2034',
        nation: 'Czechia',
        seed: 4242,
      );
      expect(p, isNotEmpty);
      expect(p.first.template, YTemplate.hostNamed);
    });
  });
}
