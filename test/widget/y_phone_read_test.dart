import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/y/y_providers.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone's Y feed marks itself read on opening: the tablet's re-mark
/// (on a refresh while open) shares that code, so pin it on a phone.
void main() {
  testWidgets('opening Y marks the feed read up to its newest post', (
    tester,
  ) async {
    final feed = fakeYTimeline();
    final newest = feed.posts
        .map((p) => p.date)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final save = await seedSave(
      tester,
      overrides: [
        yFeedProvider(kSeededCareerId).overrideWith((ref) async => feed),
        // The read mark invalidates the unread count, which nothing on this
        // page rebuilds.
        // Test-only, no app change: in riverpod 2.6.1 (async_notifier/base.dart
        // 461-466) an invalidated FutureProvider element that is never rebuilt
        // before the container is disposed has its future completed a second
        // time on that dispose ("Bad state: Future already completed"). A value
        // with no awaits is never left in that state. Revisit at the Riverpod 3
        // upgrade.
        yUnreadCountProvider(kSeededCareerId).overrideWith((ref) async => 0),
      ],
    );
    Future<DateTime?> readAt() async => (await tester.runAsync(
      () => save.container.read(careerRepositoryProvider).byId(save.careerId),
    ))?.yReadAt;
    final before = await readAt();
    expect(before == null || before.isBefore(newest), isTrue);
    await pumpRoute(tester, save, '${Routes.y}?careerId=${save.careerId}');
    expect(tester.takeException(), isNull);
    expect(await readAt(), newest);
    await tester.pumpWidget(const SizedBox());
  });
}
