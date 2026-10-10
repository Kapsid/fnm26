import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/y/y_post_detail.dart';
import 'package:fnm/features/y/y_profile_sheet.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/features/y/y_screen.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The feed a test can change under an open screen, as a sim step would.
final _feed = StateProvider<YTimeline>((ref) => fakeYTimeline());

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      yFeedProvider(kSeededCareerId).overrideWith(
        (ref) async => ref.watch(_feed),
      ),
      // Not on show here, but the read mark invalidates it, and in debug mode
      // riverpod 2.6.1 mounts an unwatched autoDispose provider to check an
      // invalidate: the real one is auto-disposed between its awaits, watches
      // the feed after that, and the teardown disposes it twice ("Future
      // already completed"). See phone_guard_y_test.dart.
      yUnreadCountProvider(kSeededCareerId).overrideWith((ref) async => 0),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.y}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder _inFeed(Finder f) =>
    find.descendant(of: find.byType(YFeedList), matching: f);

Future<DateTime?> _readAt(WidgetTester tester, SeededSave save) async {
  late DateTime? at;
  await tester.runAsync(() async {
    at =
        (await save.container
                .read(careerRepositoryProvider)
                .byId(save.careerId))
            ?.yReadAt;
  });
  return at;
}

void main() {
  final feed = fakeYTimeline();

  for (final size in kTabletSizes) {
    testWidgets('the timeline, trending and voices beside it, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(YScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final timeline = tester.getRect(find.byType(YFeedList));
      final trending = tester.getRect(find.byKey(YScreen.trendingKey));
      final voices = tester.getRect(find.byKey(YScreen.voicesKey));
      expect(trending.left, greaterThan(timeline.right));
      expect(voices.top, greaterThan(trending.bottom));
      // The win heads trending; Ana heads the voices.
      expect(
        find.descendant(
          of: find.byKey(YScreen.trendingKey),
          matching: find.text(yPostBody(enL, feed.posts.first)),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(YScreen.voicesKey),
          matching: find.text('Ana Fan'),
        ),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a post opens beside the feed, its author from there', (
    tester,
  ) async {
    await _open(tester, kTabletSize);
    // Three posts in the fixture share this wording; the first is Ana's,
    // the opening post at the top of the feed.
    await tester.tap(
      _inFeed(find.text(yPostBody(enL, feed.posts.first))).first,
    );
    await settle(tester);
    // Beside the feed, not a page of its own.
    expect(find.byType(YPostDetail), findsNothing);
    expect(find.byKey(YScreen.sideThreadKey), findsOneWidget);
    expect(
      tester.widget<YPostThread>(find.byType(YPostThread)).post.key,
      'fx:1|fan',
    );
    expect(find.byKey(YScreen.trendingKey), findsNothing);
    await tester.tap(
      find
          .descendant(
            of: find.byKey(YScreen.sideThreadKey),
            matching: find.text('Ben Stats'),
          )
          .first,
    );
    await settle(tester);
    expect(find.byType(YProfileSheet), findsNothing);
    expect(
      tester.widget<YProfileView>(find.byType(YProfileView)).persona.handle,
      '@BenStats',
    );
    await tester.tap(find.byKey(YScreen.sideCloseKey));
    await settle(tester);
    expect(find.byKey(YScreen.trendingKey), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a voice opens the account beside the feed', (tester) async {
    await _open(tester, kTabletSize);
    await tester.tap(
      find.descendant(
        of: find.byKey(YScreen.voicesKey),
        matching: find.text('Ana Fan'),
      ),
    );
    await settle(tester);
    expect(
      tester.widget<YProfileView>(find.byType(YProfileView)).persona.handle,
      '@AnaFan',
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('posts that arrive while the feed is open are read too', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    expect(await _readAt(tester, save), DateTime(2027, 6, 10));
    // A step adds a post to the feed on show.
    final later = fakePost(
      'Gus Fan',
      YVoice.fan,
      'fx:3|fan',
      DateTime(2027, 6, 20),
    );
    save.container.read(_feed.notifier).state = (
      posts: [later, ...feed.posts],
      reserveFrom: 7,
    );
    await settle(tester);
    expect(_inFeed(find.text('Gus Fan')), findsOneWidget);
    expect(await _readAt(tester, save), DateTime(2027, 6, 20));
    await tester.pumpWidget(const SizedBox());
  });
}
