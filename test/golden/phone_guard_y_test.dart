import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/y/y_post_detail.dart';
import 'package:fnm/features/y/y_profile_sheet.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/features/y/y_screen.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone Y feed, a post's page and an account's page, pinned before
/// their bodies are shared with the tablet's side column.
void main() {
  final feed = fakeYTimeline();

  Future<SeededSave> open(WidgetTester tester, Size size) async {
    final save = await seedSave(
      tester,
      overrides: [
        yFeedProvider(kSeededCareerId).overrideWith((ref) async => feed),
        // Nothing on these pages shows the unread count, but the read mark
        // invalidates it, and in debug mode riverpod 2.6.1 MOUNTS an unwatched
        // autoDispose provider to check an invalidate. The real one then gets
        // auto-disposed between its awaits, watches the feed after that, and
        // the container's teardown disposes it a second time ("Future already
        // completed"). A value with no awaits cannot outlive its disposal.
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

  for (final (name, size) in [
    ('y_phone', kPhoneSize),
    ('y_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      await open(tester, size);
      expect(find.byType(YFeedList), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }

  testWidgets('y_post_phone and y_profile_phone', (tester) async {
    await open(tester, kPhoneSize);
    // Three posts in the fixture share this wording; the first is Ana's,
    // the opening post at the top of the feed.
    await tester.tap(find.text(yPostBody(enL, feed.posts.first)).first);
    await settle(tester);
    expect(find.byType(YPostDetail), findsOneWidget);
    await expectAppGolden('goldens/y_post_phone.png');
    await tester.tap(find.text('Ben Stats').last);
    await settle(tester);
    expect(find.byType(YProfileSheet), findsOneWidget);
    await expectAppGolden('goldens/y_profile_phone.png');
  });
}
