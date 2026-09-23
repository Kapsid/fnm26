import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/y_feed.dart';

/// The three complaints the depth work exists to answer: it repeats itself,
/// the voices have no personality, and it remembers nothing.
///
/// Every assertion here fails against the feed as it was — four phrasings per
/// template chosen by a hash, a fresh author drawn for every post, and no
/// callback of any kind.
void main() {
  YContext ctx(
    int i, {
    String? opponent,
    int scored = 1,
    int conceded = 0,
    int ourRank = 20,
    int theirRank = 20,
  }) => (
    match: (
      opponent: opponent ?? 'Nation ${i % 7}',
      nationRank: ourRank,
      opponentRank: theirRank,
      scored: scored,
      conceded: conceded,
      date: DateTime(2030, 1, 1).add(Duration(days: i * 7)),
      key: 'fx:$i',
      competitive: true,
    ),
    scorerName: null,
    scorerGoals: null,
    winStreak: 0,
    lossStreak: 0,
    isRivalry: false,
    injuredNames: const [],
    boardMood: 50,
  );

  List<YPost> run(List<YContext> cs) =>
      YFeed.forRun(cs, nation: 'Czechia', seed: 99);

  group('it stops repeating itself', () {
    test('a long save reaches for many more phrasings than it used to', () {
      // Sixty matches of mixed fortune. The old feed had four wordings per
      // template and six per reply mood to cover all of it.
      final posts = run([
        for (var i = 0; i < 60; i++)
          ctx(
            i,
            scored: i % 4,
            conceded: (i * 3) % 5,
            ourRank: 20,
            theirRank: 5 + (i * 7) % 90,
          ),
      ]);
      // A reply's mood is part of its identity: every reaction shares one
      // template, so counting by template alone would file a furious "I want
      // names" and a despairing "well." as the same sentence.
      final shapes = posts
          .map((p) => '${p.template.name}|${p.mood?.name ?? ''}|${p.variant}')
          .toSet();
      // Measured: 60 at the time of writing, against 30 counted the same way
      // before the tone bands and the sentence-shaped no-repeat fix. The floor
      // sits below that so tuning has room, and high enough that collapsing a
      // template back onto a single band fails it.
      expect(
        shapes.length,
        greaterThan(50),
        reason:
            'a sixty-match save should not be drawing on a handful of '
            'sentences',
      );

      // And the feed is actually busy: one result post per match was the old
      // behaviour, and it was not deliberate.
      expect(
        posts.where((p) => p.mood == null).length,
        greaterThan(60),
        reason: 'more than one voice reports a match worth reporting',
      );
    });

    test('the deep templates really are deep', () {
      for (final t in [
        YTemplate.winUpset,
        YTemplate.winRoutine,
        YTemplate.winTight,
        YTemplate.drew,
        YTemplate.lost,
        YTemplate.lostBadly,
      ]) {
        expect(YFeed.variantsFor(t), YFeed.deepVariantCount, reason: t.name);
      }
      // And the ones that fire once a cycle are left alone: copy is expensive
      // and is spent where the repetition was.
      expect(YFeed.variantsFor(YTemplate.hostNamed), YFeed.variantCount);
    });
  });

  group('the voices have personalities', () {
    test('the same result is worded differently by different dispositions', () {
      // One event, one template, three dispositions: the wording has to land
      // in three different bands or the tone banding is decorative.
      final variants = {
        for (final tone in YTone.values)
          tone: YCast.variantFor(
            key: 'fx:1|fan',
            tone: tone,
            total: YFeed.deepVariantCount,
          ),
      };
      expect(variants.values.toSet(), hasLength(YTone.values.length));
    });

    test('a sour account and a generous one do not share a sentence', () {
      final generous = YCast.band(YTone.generous, YFeed.deepVariantCount);
      final sour = YCast.band(YTone.sour, YFeed.deepVariantCount);
      expect(generous.$1 + generous.$2, lessThanOrEqualTo(sour.$1));
    });

    test('the cast recurs instead of being redrawn every post', () {
      // The old feed drew a name per POST, so twenty matches meant twenty
      // strangers. A small standing cast is the whole point.
      final posts = run([for (var i = 0; i < 20; i++) ctx(i)]);
      final fans = posts
          .where((p) => p.voice == YVoice.fan)
          .map((p) => p.handle)
          .toSet();
      expect(fans.length, lessThanOrEqualTo(YCast.castSize));
      expect(fans, isNotEmpty);
    });
  });

  group('it remembers', () {
    test('the same opponent doing it again is called out', () {
      // Beaten by the same neighbours four times running.
      final posts = run([
        for (var i = 0; i < 4; i++)
          ctx(i, opponent: 'Slovakia', scored: 0, conceded: 2),
      ]);
      expect(
        posts.map((p) => p.template),
        contains(YTemplate.againstThemAgain),
        reason: 'four defeats to one side is a pattern, not four results',
      );
    });

    test('a run of the same afternoon becomes a story about the run', () {
      final posts = run([
        for (var i = 0; i < 6; i++)
          ctx(i, opponent: 'Nation $i', scored: 1, conceded: 1),
      ]);
      expect(posts.map((p) => p.template), contains(YTemplate.sameOldStory));
    });

    test('somebody says they told you so, but only after the hype', () {
      // Three good results, then a bad one. Without the good run first there
      // is nothing to have been right about.
      final hyped = run([
        for (var i = 0; i < 3; i++)
          ctx(i, ourRank: 40, theirRank: 5, scored: 2, conceded: 0),
        ctx(3, ourRank: 40, theirRank: 120, scored: 0, conceded: 1),
      ]);
      expect(hyped.map((p) => p.template), contains(YTemplate.toldYouSo));

      final unhyped = run([
        for (var i = 0; i < 3; i++)
          ctx(i, ourRank: 40, theirRank: 120, scored: 0, conceded: 2),
        ctx(3, ourRank: 40, theirRank: 120, scored: 0, conceded: 1),
      ]);
      expect(
        unhyped.map((p) => p.template),
        isNot(contains(YTemplate.toldYouSo)),
        reason: 'nobody has been proved right about a side nobody rated',
      );
    });

    test('a first match has nothing to remember', () {
      final posts = run([ctx(0)]);
      for (final callback in [
        YTemplate.againstThemAgain,
        YTemplate.sameOldStory,
        YTemplate.toldYouSo,
      ]) {
        expect(posts.map((p) => p.template), isNot(contains(callback)));
      }
    });
  });

  group('and it stays honest when you scroll back', () {
    // The property the whole derived-not-stored design exists to protect. A
    // stored stance would show today's opinion under a post from years ago.
    final full = [for (var i = 0; i < 30; i++) ctx(i, scored: i % 3)];

    test('the same save builds the same feed twice', () {
      expect(
        run(full).map((p) => '${p.key}|${p.variant}'),
        run(full).map((p) => '${p.key}|${p.variant}'),
      );
    });

    test('an older post says now what it said then', () {
      final early = run(full.take(10).toList());
      final later = run(full);
      final laterByKey = {for (final p in later) p.key: p};
      for (final p in early) {
        expect(
          laterByKey[p.key]?.variant,
          p.variant,
          reason: 'post ${p.key} was rewritten by events that came after it',
        );
        expect(laterByKey[p.key]?.handle, p.handle);
      }
    });
  });

  test('a result is read against who got it, everywhere', () {
    // The shared reading, seen from the feed: identical scoreline, opposite
    // stories.
    final minnow = YFeed.classify((
      opponent: 'Brazil',
      nationRank: 120,
      opponentRank: 2,
      scored: 1,
      conceded: 1,
      date: DateTime(2030),
      key: 'a',
      competitive: true,
    ));
    final giant = YFeed.classify((
      opponent: 'San Marino',
      nationRank: 2,
      opponentRank: 120,
      scored: 1,
      conceded: 1,
      date: DateTime(2030),
      key: 'b',
      competitive: true,
    ));
    expect(minnow, YTemplate.drew);
    expect(giant, YTemplate.drew);
    // Same template, but the room is not the same size.
    expect(
      Expectation.standing(
        nationRank: 120,
        opponentRank: 2,
        scored: 1,
        conceded: 1,
      ),
      isNot(
        Expectation.standing(
          nationRank: 2,
          opponentRank: 120,
          scored: 1,
          conceded: 1,
        ),
      ),
    );
  });
}
