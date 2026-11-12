import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/features/match/sound/match_audio.dart';
import 'package:fnm/features/match/sound/match_sound_director.dart';

import '../../helpers/fake_match_audio.dart';

/// The stadium's sound: silent unless the manager turned it on; the home
/// fans roar their goals and groan at the other side's; whistles at the
/// kick-off, the interval and full time; a pause ducks the bed, a skip and
/// leaving stop it; the bed's size follows the crowd.
void main() {
  const home = 1;
  const away = 2;

  ShotMoment shot({
    ShotOutcome outcome = ShotOutcome.saved,
    double xg = 0.3,
    ShotOrigin origin = ShotOrigin.openPlay,
  }) => ShotMoment(
    minute: 20,
    stoppage: 0,
    seq: 0,
    teamNationId: home,
    shooterId: 10,
    zone: PitchZone.boxCentre,
    xg: xg,
    outcome: outcome,
    origin: origin,
  );

  const foul = FoulMoment(
    minute: 30,
    stoppage: 0,
    seq: 0,
    teamNationId: home,
    foulerId: 20,
    fouledId: 10,
    zone: PitchZone.boxCentre,
  );

  late FakeMatchAudio audio;
  late DateTime now;
  late MatchSoundDirector d;

  void on({
    bool playing = true,
    bool ducked = false,
    bool foreground = true,
    double volume = 1,
  }) => d.sync(
    enabled: true,
    volume: volume,
    playing: playing,
    ducked: ducked,
    foreground: foreground,
  );

  setUp(() {
    audio = FakeMatchAudio();
    now = DateTime(2026);
    d = MatchSoundDirector(audio, clock: () => now)
      ..setGround(intensity: 0.8, homeFansNationId: home);
  });

  group('off (the default)', () {
    testWidgets('nothing reaches the audio, whatever happens', (tester) async {
      MatchSoundDirector(audio, clock: () => now)
        ..setGround(intensity: 1, homeFansNationId: home)
        ..kickOff()
        ..goal(home)
        ..goal(away)
        ..pitchMoment(shot(outcome: ShotOutcome.woodwork), build: true)
        ..pitchMoment(shot(outcome: ShotOutcome.woodwork), build: false)
        ..timelineMoments([shot(outcome: ShotOutcome.woodwork), foul])
        ..interval()
        ..fullTime()
        ..matchOver(won: true);
      await tester.pump(const Duration(seconds: 5));
      expect(audio.calls, isEmpty);
    });

    test('synced off, still silent', () {
      d
        ..sync(enabled: false, volume: 1, playing: true)
        ..kickOff()
        ..goal(home);
      expect(audio.calls, isEmpty);
    });

    test('turned off mid-match, the bed stops', () {
      on();
      expect(audio.loops, isNotEmpty);
      d.sync(enabled: false, volume: 1, playing: true);
      expect(audio.loops, isEmpty);
      d.goal(home);
      expect(audio.cues, isEmpty);
    });
  });

  group('the crowd', () {
    test('a home goal roars', () {
      on();
      d.goal(home);
      expect(audio.cues, [SoundCue.roar]);
    });

    test('an away goal: a cheer from the away end, a groan from the rest', () {
      on();
      d.goal(away);
      expect(audio.cues, [SoundCue.cheerAway, SoundCue.groan]);
    });

    test('at a neutral ground either goal is a roar, a smaller one', () {
      on();
      d.goal(home);
      final full = audio.calls.last;
      d
        ..setGround(intensity: 0.8)
        ..goal(away);
      expect(audio.cues, [SoundCue.roar, SoundCue.roar]);
      double vol(String c) => double.parse(c.split(' ').last);
      expect(vol(audio.calls.last), lessThan(vol(full)));
    });

    test('a big chance swells as it builds; woodwork and big saves groan', () {
      on();
      d
        ..pitchMoment(shot(outcome: ShotOutcome.woodwork), build: true)
        ..pitchMoment(shot(outcome: ShotOutcome.woodwork), build: false)
        ..pitchMoment(shot(xg: 0.4), build: false);
      expect(audio.cues, [SoundCue.swell, SoundCue.groan, SoundCue.groan]);
    });

    test('a half chance is not a moment', () {
      on();
      d
        ..pitchMoment(shot(xg: 0.05), build: true)
        ..pitchMoment(shot(xg: 0.05, outcome: ShotOutcome.wide), build: false);
      expect(audio.cues, isEmpty);
    });

    testWidgets('the Timeline swells, then groans a moment later', (
      tester,
    ) async {
      on();
      d.timelineMoments([shot(outcome: ShotOutcome.woodwork)]);
      expect(audio.cues, [SoundCue.swell]);
      await tester.pump(const Duration(seconds: 1));
      expect(audio.cues, [SoundCue.swell, SoundCue.groan]);
    });
  });

  group('the whistle', () {
    test('kick-off, half time, full time', () {
      on();
      d
        ..kickOff()
        ..interval()
        ..fullTime();
      expect(audio.cues, [
        SoundCue.whistleKickoff,
        SoundCue.whistleHalfTime,
        SoundCue.whistleFullTime,
      ]);
    });

    test('a foul that matters whistles, sparingly', () {
      on();
      d.pitchMoment(foul, build: false);
      now = now.add(const Duration(seconds: 2));
      d.pitchMoment(foul, build: false);
      expect(audio.cues, [SoundCue.whistleShort]);
      now = now.add(MatchSoundDirector.whistleGap);
      d.pitchMoment(foul, build: false);
      expect(audio.cues, [SoundCue.whistleShort, SoundCue.whistleShort]);
    });

    test('a routine foul is not whistled', () {
      on();
      d.pitchMoment(
        const FoulMoment(
          minute: 30,
          stoppage: 0,
          seq: 0,
          teamNationId: home,
          foulerId: 20,
          fouledId: 10,
          zone: PitchZone.midfield,
        ),
        build: false,
      );
      expect(audio.cues, isEmpty);
    });
  });

  group('the bed', () {
    test('plays while the match does, ducks under a pause', () {
      on();
      final loud = Map.of(audio.loops);
      expect(loud, isNotEmpty);
      on(ducked: true);
      for (final e in audio.loops.entries) {
        expect(
          e.value,
          closeTo(loud[e.key]! * MatchSoundDirector.duckFactor, 1e-9),
        );
      }
      on();
      expect(audio.loops, loud);
    });

    test('stops in the background and at full time', () {
      on();
      on(foreground: false);
      expect(audio.loops, isEmpty);
      on();
      expect(audio.loops, isNotEmpty);
      on(playing: false);
      expect(audio.loops, isEmpty);
    });

    testWidgets('a skip silences everything for good', (tester) async {
      on();
      d
        ..timelineMoments([shot(outcome: ShotOutcome.woodwork)])
        ..skip();
      expect(audio.calls.last, 'stopAll');
      expect(audio.loops, isEmpty);
      final before = audio.calls.length;
      await tester.pump(const Duration(seconds: 2));
      on();
      d
        ..fullTime()
        ..matchOver(won: true);
      await tester.pump(const Duration(seconds: 3));
      expect(audio.calls.length, before, reason: audio.calls.join('\n'));
    });

    test('leaving stops everything', () {
      on();
      d.dispose();
      expect(audio.calls.last, 'stopAll');
      d.goal(home);
      expect(audio.calls.last, 'stopAll');
    });

    test('follows the volume setting', () {
      on();
      final full = Map.of(audio.loops);
      on(volume: 0.5);
      for (final e in audio.loops.entries) {
        expect(e.value, closeTo(full[e.key]! * 0.5, 1e-9));
      }
    });

    test('a big full ground is the full crowd, a small one the thin', () {
      d
        ..setGround(intensity: 1, homeFansNationId: home)
        ..sync(enabled: true, volume: 1, playing: true);
      expect(audio.loops.keys, [SoundLoop.crowdFull]);
      final big = audio.loops[SoundLoop.crowdFull]!;

      final small = FakeMatchAudio();
      MatchSoundDirector(small)
        ..setGround(intensity: 0.05, homeFansNationId: home)
        ..sync(enabled: true, volume: 1, playing: true);
      expect(small.loops.keys, [SoundLoop.crowdThin]);
      expect(small.loops[SoundLoop.crowdThin], lessThan(big));
    });
  });

  group('crowdIntensity', () {
    test('rises with the crowd and how full the ground is', () {
      final tiny = crowdIntensity(attendance: 2000, capacity: 10000);
      final half = crowdIntensity(attendance: 30000, capacity: 60000);
      final packed = crowdIntensity(attendance: 80000, capacity: 80000);
      expect(tiny, lessThan(half));
      expect(half, lessThan(packed));
      expect(packed, 1);
    });

    test('a knockout and a final lift it', () {
      const a = 30000;
      const c = 50000;
      final plain = crowdIntensity(attendance: a, capacity: c);
      final big = crowdIntensity(attendance: a, capacity: c, bigMatch: true);
      final last = crowdIntensity(
        attendance: a,
        capacity: c,
        bigMatch: true,
        isFinal: true,
      );
      expect(plain, lessThan(big));
      expect(big, lessThan(last));
    });

    test('an empty ground is nearly silent', () {
      expect(crowdIntensity(attendance: 0, capacity: 0), 0.05);
    });
  });

  testWidgets('a win cheers once at the end, a loss does not', (tester) async {
    on(playing: false);
    d
      ..matchOver(won: true)
      ..matchOver(won: true);
    await tester.pump(const Duration(seconds: 3));
    expect(audio.cues, [SoundCue.winCheer]);

    final lost = FakeMatchAudio();
    MatchSoundDirector(lost)
      ..sync(enabled: true, volume: 1, playing: false)
      ..matchOver(won: false);
    await tester.pump(const Duration(seconds: 3));
    expect(lost.cues, isEmpty);
  });
}
