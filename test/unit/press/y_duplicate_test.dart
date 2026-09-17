import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/y_feed.dart';

/// A post's key is what the feed uses to hang replies off it and what the
/// detail view groups a conversation by. Two posts sharing one is a bug that
/// shows up on screen as the same words twice.
void main() {
  YMatch match({
    int scored = 3,
    int conceded = 1,
    String key = 'fx:1',
  }) => (
    opponent: 'Norway',
    nationRank: 30,
    opponentRank: 30,
    scored: scored,
    conceded: conceded,
    date: DateTime(2030, 6, 10),
    key: key,
    competitive: true,
  );

  YContext withScorer(YMatch m) => (
    match: m,
    scorerName: 'Radek Vlk',
    scorerGoals: 2,
    winStreak: 4,
    lossStreak: 0,
    isRivalry: false,
    injuredNames: const ['Jan Sobota'],
    boardMood: 20,
  );

  group('post keys', () {
    test('no two posts about one match share a key', () {
      final posts = YFeed.forMatch(
        withScorer(match()),
        nation: 'Czechia',
        seed: 4242,
      );
      final keys = posts.map((p) => p.key).toList();
      expect(keys.toSet().length, keys.length, reason: 'keys: $keys');
    });

    test('a reply thread is shown once, not once per author', () {
      final posts = YFeed.mostRecent(
        YFeed.forRun(
          [withScorer(match())],
          nation: 'Czechia',
          seed: 4242,
        ),
      );
      final replies = posts.where((p) => p.replyTo != null).toList();
      expect(
        replies.map((p) => p.key).toSet().length,
        replies.length,
        reason: 'the same reply came back more than once',
      );
    });

    test('every post still names the event it came from', () {
      // The detail view groups a conversation by the part of the key before
      // the first pipe, so the event must survive whatever else the key
      // carries.
      final posts = YFeed.forMatch(
        withScorer(match(key: 'fx:77')),
        nation: 'Czechia',
        seed: 1,
      );
      for (final p in posts) {
        expect(p.key.split('|').first, 'fx:77');
      }
    });
  });
}
