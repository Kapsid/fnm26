import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('phone match in Pitch mode', (tester) async {
    final save = await seedSave(tester);
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
    // The bake shows a spinner until the ground is in: settle waits for it.
    await pumpRoute(tester, save, '${Routes.match}?careerId=${save.careerId}');
    expect(find.byType(PitchMatchView), findsOneWidget);
    expect(find.byType(PitchCommentaryLine), findsOneWidget);
    // Stopped, then on a fixed moment: the 20th minute's first staged one.
    await tester.tap(find.byIcon(Icons.pause_rounded));
    await tester.pump();
    final screen = tester.state(find.byType(MatchScreen)) as MatchScreenProbe;
    final pb = screen.pitchMode.playback!;
    final from = pb.pacer.screenAt(20, 0).inMicroseconds / 1e6;
    final w = pb.script.windows.firstWhere((w) => w.start >= from);
    screen.seekPitch(
      Duration(microseconds: ((w.start + w.end) / 2 * 1e6).round()),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 3)); // any flash clears
    await expectAppGolden('goldens/match_phone_pitch.png');
    await tester.pumpWidget(const SizedBox());
  });
}
