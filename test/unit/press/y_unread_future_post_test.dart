import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/y/y_providers.dart';

import '../../helpers/test_database.dart';

YPost _post(String key, DateTime date) => (
  voice: YVoice.fan,
  handle: '@$key',
  displayName: key,
  template: YTemplate.winTight,
  variant: 0,
  args: const ['Spain', '2–1'],
  date: date,
  key: key,
  replyTo: null,
  mood: null,
);

/// The "tournament soon" and "final looms" posts are dated at the event they
/// announce, which is in the future. Opening the feed used to stamp the read
/// watermark at that future date, so every friendly played before it arrived
/// already "read" and the badge never lit for them.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late int careerId;
  late List<YPost> feed;

  final friendly1 = DateTime(2030, 3, 20);
  final friendly2 = DateTime(2030, 3, 27);
  final opener = DateTime(2030, 6, 11);

  setUp(() async {
    db = createTestDatabase();
    addTearDown(db.close);
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    feed = [_post('friendly1', friendly1), _post('soon', opener)];
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
        yFeedProvider.overrideWith(
          (ref, id) async => (posts: feed, reserveFrom: null),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(seedLoaderProvider).ensureSeeded();
    careerId =
        (await container
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!
            .id;
    await container
        .read(careerRepositoryProvider)
        .updateInGameDate(careerId, friendly1);
  });

  test(
    'a future-dated landmark does not swallow the friendlies before it',
    () async {
      // Only the post already dated counts: the landmark is not news yet.
      expect(await container.read(yUnreadCountProvider(careerId).future), 1);

      await container.read(yReadServiceProvider).markRead(careerId);
      final career = await container
          .read(careerRepositoryProvider)
          .byId(careerId);
      expect(career!.yReadAt, friendly1, reason: 'capped at inGameDate');

      // The next friendly is played a week later.
      feed = [...feed, _post('friendly2', friendly2)];
      await container
          .read(careerRepositoryProvider)
          .updateInGameDate(careerId, friendly2);
      container
        ..invalidate(yFeedProvider(careerId))
        ..invalidate(yUnreadCountProvider(careerId));
      expect(await container.read(yUnreadCountProvider(careerId).future), 1);

      // The landmark counts once its day arrives.
      await container.read(yReadServiceProvider).markRead(careerId);
      await container
          .read(careerRepositoryProvider)
          .updateInGameDate(careerId, opener);
      container.invalidate(yUnreadCountProvider(careerId));
      expect(await container.read(yUnreadCountProvider(careerId).future), 1);
    },
  );

  test('the tablet panel shows only posts already dated', () {
    final shown = yPostsUpTo(feed, friendly1);
    expect(shown.map((p) => p.key), ['friendly1']);
  });
}
