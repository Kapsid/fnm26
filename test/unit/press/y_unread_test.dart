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

/// Y posts are derived from events rather than stored, so "read" cannot be a
/// flag on a row: it is a watermark, and the count is everything newer.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late int careerId;
  late List<YPost> feed;

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

    // A feed with three posts in it, so the count has something to count.
    feed = [
      for (var i = 0; i < 3; i++)
        (
          voice: YVoice.fan,
          handle: '@fan$i',
          displayName: 'Fan $i',
          template: YTemplate.winTight,
          variant: 0,
          args: const ['Spain', '2–1'],
          date: DateTime(2030, 6, 10 + i),
          key: 'fx:$i|fan',
          replyTo: null,
          mood: null,
        ),
    ];

    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
        // The feed itself is not what is under test — the watermark is. A
        // fixed feed keeps the count honest and the test fast.
        yFeedProvider.overrideWith((ref, id) async => feed),
      ],
    );
    addTearDown(container.dispose);
    await container.read(seedLoaderProvider).ensureSeeded();
    careerId =
        (await container
                .read(careerServiceProvider)
                .create(
                  nationId: nations.first.id,
                  managerName: 'M',
                ))
            .valueOrNull!
            .id;
  });

  test('a manager who has never looked has everything unread', () async {
    expect(await container.read(yUnreadCountProvider(careerId).future), 3);
  });

  test('opening the feed clears the badge', () async {
    await container.read(yReadServiceProvider).markRead(careerId);
    container.invalidate(yUnreadCountProvider(careerId));
    expect(await container.read(yUnreadCountProvider(careerId).future), 0);
  });

  test('a post written afterwards is unread again', () async {
    await container.read(yReadServiceProvider).markRead(careerId);
    feed = [
      ...feed,
      (
        voice: YVoice.pundit,
        handle: '@pundit',
        displayName: 'Pundit',
        template: YTemplate.lost,
        variant: 0,
        args: const ['Italy', '0–2'],
        date: DateTime(2030, 7, 1),
        key: 'fx:9|pundit',
        replyTo: null,
        mood: null,
      ),
    ];
    container
      ..invalidate(yFeedProvider(careerId))
      ..invalidate(yUnreadCountProvider(careerId));
    expect(await container.read(yUnreadCountProvider(careerId).future), 1);
  });
}
