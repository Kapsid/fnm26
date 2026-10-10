import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_post_detail.dart';

/// One conversation people are having: the post that opened it and how many
/// posts it has run to.
typedef YTrend = ({YPost head, int posts});

/// One account in the feed and how often it has spoken.
typedef YVoiceCount = ({YPersona persona, int posts});

/// The conversations with the most posts in the recent part of [feed], most
/// first, newest first among equals, at most [limit]. Only the posts above
/// the seam count: the landmarks kept back from earlier in the cycle are
/// history, not what anyone is talking about. A conversation is every post
/// about the same event (see [YPostDetail.eventOf]); its head is the post the
/// others answer.
List<YTrend> yTrending(YTimeline feed, {int limit = 5}) {
  final seam = feed.reserveFrom;
  final recent = seam == null ? feed.posts : feed.posts.take(seam);
  final byEvent = <String, List<YPost>>{};
  for (final p in recent) {
    (byEvent[YPostDetail.eventOf(p)] ??= []).add(p);
  }
  final trends =
      [
        for (final posts in byEvent.values)
          (
            head: posts.firstWhere(
              (p) => p.replyTo == null,
              orElse: () => posts.first,
            ),
            posts: posts.length,
          ),
      ]..sort((a, b) {
        final byCount = b.posts.compareTo(a.posts);
        return byCount != 0 ? byCount : b.head.date.compareTo(a.head.date);
      });
  return trends.take(limit).toList();
}

/// Who has said the most across the whole feed, most first, by name among
/// equals, at most [limit]. The persona is re-derived from a post, as the
/// profile page does, so nothing is stored.
List<YVoiceCount> yVoices(YTimeline feed, {int limit = 8}) {
  final byHandle = <String, List<YPost>>{};
  for (final p in feed.posts) {
    (byHandle[p.handle] ??= []).add(p);
  }
  final voices =
      [
        for (final posts in byHandle.values)
          (persona: YFeed.personaOf(posts.first), posts: posts.length),
      ]..sort((a, b) {
        final byCount = b.posts.compareTo(a.posts);
        return byCount != 0
            ? byCount
            : a.persona.displayName.compareTo(b.persona.displayName);
      });
  return voices.take(limit).toList();
}
