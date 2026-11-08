import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';

import '../helpers/seeded_save.dart';

/// The 2D TV's sending-off: the referee with the red card up by the man,
/// and the red card banner down from under the score stripe.
///
/// The seeded save's match, played from an attempt salt whose match has a
/// red card in open play (20'), its one earlier goal flashed and cleared
/// first.
const int _salt = 5;

/// With `--dart-define=RED_FRAMES=<dir>`, also writes the moment as a
/// sequence of PNG frames there, for a look outside the test.
const String _framesDir = String.fromEnvironment('RED_FRAMES');

void main() {
  testWidgets('phone match in Pitch mode: the red card', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [matchAttemptSaltProvider.overrideWithValue(() => _salt)],
    );
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
    await pumpRoute(tester, save, '${Routes.match}?careerId=${save.careerId}');
    final screen = tester.state(find.byType(MatchScreen)) as MatchScreenProbe;
    final pb = screen.pitchMode.playback!;
    final events = pb.result.events;
    final ri = events.indexWhere((e) => e.type == MatchEventType.redCard);
    expect(ri, greaterThanOrEqualTo(0), reason: 'a red card to show');
    expect(events[ri].minute, lessThan(45), reason: 'before half-time');
    final reveal = pb.revealAt(ri);
    // The goals before it first, each flashed and cleared, so nothing but
    // the card is on show when it comes.
    for (var i = 0; i < ri; i++) {
      if (events[i].type != MatchEventType.goal) continue;
      screen.seekPitch(_at(pb.revealAt(i) + 0.05));
      await tester.pump();
      await tester.pump(kGoalFlashHold + const Duration(milliseconds: 100));
    }

    if (_framesDir.isNotEmpty) {
      // From the run-in to the walk: every 0.25 s of match pace.
      screen.seekPitch(_at(reveal - 1.6));
      await tester.pump();
      for (var i = 0; i <= 16; i++) {
        await _writeFrame(
          tester,
          '$_framesDir/frame_${i.toString().padLeft(2, '0')}.png',
        );
        await tester.pump(const Duration(milliseconds: 250));
      }
    }

    // Just short of the card, playing: the banner comes down as it goes up.
    screen.seekPitch(_at(reveal - 0.3));
    for (
      var i = 0;
      i < 400 && find.byKey(matchRedCardBannerKey).evaluate().isEmpty;
      i++
    ) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(find.byKey(matchRedCardBannerKey), findsOneWidget);
    // Fully out, the card at full stretch.
    await tester.pump(kGoalBannerSlide + const Duration(milliseconds: 50));
    if (_framesDir.isNotEmpty) {
      await _writeFrame(tester, '$_framesDir/still_banner.png');
    }
    await expectAppGolden('goldens/match_phone_pitch_red_card.png');
    await tester.pumpWidget(const SizedBox());
  });
}

Duration _at(double s) => Duration(microseconds: (s * 1e6).round());

Future<void> _writeFrame(WidgetTester tester, String path) async {
  final boundary =
      tester.renderObject(find.byKey(kAppRoot)) as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    final file = File(path)..parent.createSync(recursive: true);
    file.writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}
