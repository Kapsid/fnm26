import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
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
}
