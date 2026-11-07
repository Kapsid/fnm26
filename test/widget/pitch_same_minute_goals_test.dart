import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';
import 'package:fnm/features/match/pitch/pitch_mode_controller.dart';

import '../helpers/fixtures.dart';

/// The final review's C1: one player scoring twice in the same minute gave
/// both goals one key, so the first one shown held the second back for
/// ever and the Pitch clock pinned at the first goal. Reproduced on the
/// real controller with the reviewer's match, read the way the screen
/// reads it.
void main() {
  testWidgets('two goals by one player in one minute: the clock plays past '
      'both and both are reached', (tester) async {
    final home = ratedTeam(1, 70);
    final away = ratedTeam(2, 70);
    final result = const MatchEngine().play(
      home: home,
      away: away,
      rng: SeededRng.forFixture(0x1234, 3608),
      extraTimeIfLevel: true,
    );
    final events = result.events;
    final goals = [
      for (var i = 0; i < events.length; i++)
        if (events[i].type == MatchEventType.goal) i,
    ];
    final pair = [
      for (final i in goals)
        if (events[i].minute == 55 && events[i].playerId == 109) i,
    ];
    expect(pair, hasLength(2), reason: 'the reviewer saw 109 score twice');

    // The screen's reading of the clock, cut down to what C1 is about.
    var minute = 0;
    var added = 0;
    var held = <MatchEventKey>{};
    late final PitchModeController pc;
    bool reached(MatchEvent e) {
      if (e.minute != minute) return e.minute < minute;
      return e.stoppage <= added && !held.contains(matchEventKey(events, e));
    }

    var pins = 0;
    void onTick() {
      final stop = pc.dueStop(
        pc.clock!.value,
        (e) => !reached(e) && e.type == MatchEventType.goal,
      );
      if (stop != null) {
        pins++;
        pc.jump(stop);
      }
      pc.markRead();
      final now = pc.read(minute: minute, added: added, held: held);
      minute = now.minute;
      added = now.added;
      held = now.held;
    }

    pc = PitchModeController(
      vsync: tester,
      builder: (b) async => b.run(),
      onTick: onTick,
    );
    addTearDown(pc.dispose);
    final built = await pc.build(
      result: result,
      lineups: matchLineupsOf(home: home, away: away, result: result),
      speedStep: 1,
      seed: 7,
      isFinal: false,
      resume: false,
      place: (_) => Duration.zero,
    );
    expect(built, isTrue);
    final pb = pc.playback!;
    final second = pb.revealAt(pair[1]);
    pc.jump(Duration(microseconds: ((pb.revealAt(pair[0]) - 1) * 1e6).round()));
    pc.clock!.play();
    for (var i = 0; i < 1200; i++) {
      await tester.pump(const Duration(milliseconds: 16));
      if (pc.clock!.value.inMicroseconds / 1e6 > second + 1) break;
    }
    pc.clock!.pause();

    expect(
      pc.clock!.value.inMicroseconds / 1e6,
      greaterThan(second),
      reason: 'the clock pinned at the first goal',
    );
    expect(reached(events[pair[0]]), isTrue);
    expect(reached(events[pair[1]]), isTrue);
    // Each goal stops play once, as it goes in; nothing pins.
    expect(pins, lessThanOrEqualTo(2));
  });
}
