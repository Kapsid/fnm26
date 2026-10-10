import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/y/y_trends.dart';

import '../../helpers/federation_fixtures.dart';

void main() {
  test('trending: the most-posted conversations above the seam', () {
    final trends = yTrending(fakeYTimeline());
    // The win (four posts), then the draw (two). The exit is below the
    // seam: history, not news.
    expect([for (final t in trends) t.head.key], ['fx:1|fan', 'fx:2|fan']);
    expect([for (final t in trends) t.posts], [4, 2]);
  });

  test('trending heads a conversation with its opening post', () {
    final feed = fakeYTimeline();
    // Replies first in the list: the head is still the post they answer.
    final shuffled = (
      posts: [feed.posts[1], feed.posts[2], feed.posts[0], feed.posts[3]],
      reserveFrom: null,
    );
    expect(yTrending(shuffled).single.head.key, 'fx:1|fan');
  });

  test('trending is capped', () {
    expect(yTrending(fakeYTimeline(), limit: 1), hasLength(1));
  });

  test('voices: who posts most, then by name, across the whole feed', () {
    final voices = yVoices(fakeYTimeline());
    expect(voices.first.persona.handle, '@AnaFan');
    expect(voices.first.posts, 2);
    expect(
      [for (final v in voices.skip(1)) v.persona.displayName],
      [
        'Ben Stats',
        'Cid Rival',
        'Dee Pundit',
        'Eli Meme',
        'Fay Wire',
      ],
    );
    expect(yVoices(fakeYTimeline(), limit: 3), hasLength(3));
  });
}
