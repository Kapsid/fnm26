import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/seeded_save.dart';

Future<void> _shoot(
  WidgetTester tester,
  MatchViewMode mode,
  String file,
) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await tester.runAsync(() => const MatchViewModeStore().save(mode));
  final warm = save.container.listen(
    matchPreviewProvider(save.careerId),
    (_, _) {},
  );
  addTearDown(warm.close);
  await tester.runAsync(
    () => save.container.read(matchPreviewProvider(save.careerId).future),
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.match}?careerId=${save.careerId}',
    size: kTabletSize,
  );
  await tester.tap(find.byIcon(Icons.pause_rounded));
  await tester.pump();
  final screen = tester.state(find.byType(MatchScreen)) as MatchScreenProbe;
  if (mode == MatchViewMode.pitch) {
    // A fixed moment: the 30th minute's first staged one, with the first
    // half's lines in the feed.
    final pb = screen.pitchMode.playback!;
    final from = pb.pacer.screenAt(30, 0).inMicroseconds / 1e6;
    final w = pb.script.windows.firstWhere((w) => w.start >= from);
    screen.seekPitch(
      Duration(microseconds: ((w.start + w.end) / 2 * 1e6).round()),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 3)); // any flash clears
    // The moments the jump passed take the header's strip in turn; then it
    // is the figures again.
    for (var i = 0; i < kTvEventQueueMax + 1; i++) {
      await tester.pump(kTvEventHold);
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(find.byKey(matchTvEventStripKey), findsNothing);
  }
  await expectAppGolden(file);
  await tester.pumpWidget(const SizedBox());
}

void main() {
  testWidgets('tablet match asks before kick-off', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await tester.runAsync(() => const MatchViewModeStore().load());
    final warm = save.container.listen(
      matchPreviewProvider(save.careerId),
      (_, _) {},
    );
    addTearDown(warm.close);
    await tester.runAsync(
      () => save.container.read(matchPreviewProvider(save.careerId).future),
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.match}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    await expectAppGolden('goldens/match_tablet_chooser.png');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('tablet match in Pitch mode', (tester) async {
    await _shoot(tester, MatchViewMode.pitch, 'goldens/match_tablet_pitch.png');
  });

  testWidgets('tablet match in Timeline mode', (tester) async {
    await _shoot(
      tester,
      MatchViewMode.timeline,
      'goldens/match_tablet_timeline.png',
    );
  });

  // The broadcast header on a 12.9 inch iPad, the goal on its strip and
  // nothing over the picture.
  testWidgets('tablet match in Pitch mode, a goal', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await tester.runAsync(
      () => const MatchViewModeStore().save(MatchViewMode.pitch),
    );
    final warm = save.container.listen(
      matchPreviewProvider(save.careerId),
      (_, _) {},
    );
    addTearDown(warm.close);
    await tester.runAsync(
      () => save.container.read(matchPreviewProvider(save.careerId).future),
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.match}?careerId=${save.careerId}',
      size: const Size(1366, 1024),
    );
    await tester.tap(find.byIcon(Icons.pause_rounded));
    await tester.pump();
    final screen = tester.state(find.byType(MatchScreen)) as MatchScreenProbe;
    final pb = screen.pitchMode.playback!;
    final r = screen.result!;
    final gi = r.events.indexWhere((e) => e.type == MatchEventType.goal);
    screen.seekPitch(
      Duration(microseconds: ((pb.revealAt(gi) + 0.05) * 1e6).round()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.byKey(matchTvEventStripKey), findsOneWidget);
    await expectAppGolden('goldens/match_tablet_pitch_goal.png');
    await tester.pump(const Duration(seconds: 8));
    await tester.pumpWidget(const SizedBox());
  });
}
