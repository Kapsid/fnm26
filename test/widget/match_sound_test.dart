import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/config/testing_flags.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart'
    show kMatchViewModePrefsKey;
import 'package:fnm/features/match/sound/match_audio.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fake_match_audio.dart';
import '../helpers/fixtures.dart';
import '../helpers/seeded_save.dart' show enL;

/// The live match screen's stadium sound, on the Timeline: silent by
/// default; with it on, the whistles, the crowd's goals and near misses, a
/// ducked bed under a pause and at half time, and silence on leaving or
/// skipping. A fake audio plays nothing and writes it all down.

/// A friendly at home: the home side scores at 10', hits the post at 20',
/// the visitors equalise at 60'. Played from salt 0, so the screen plays
/// this result as it stands.
MatchPreview _preview() {
  Player at(int id, int nationId, PlayerPosition position) =>
      player(id: id, nationId: nationId, position: position);
  List<Player> xi(int base, int nationId) => [
    at(base, nationId, PlayerPosition.gk),
    for (var i = 1; i <= 4; i++) at(base + i, nationId, PlayerPosition.cb),
    for (var i = 5; i <= 7; i++) at(base + i, nationId, PlayerPosition.cm),
    for (var i = 8; i <= 10; i++) at(base + i, nationId, PlayerPosition.st),
  ];
  const instructions = TacticalInstructions();
  return MatchPreview(
    fixture: Fixture(
      id: 7,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      date: DateTime(2026, 7, 7),
      homeNationId: 1,
      awayNationId: 2,
      round: 'FRIENDLY',
    ),
    result: const MatchResult(
      homeScore: 1,
      awayScore: 1,
      events: [
        MatchEvent(
          minute: 10,
          type: MatchEventType.goal,
          teamNationId: 1,
          playerId: 9,
          playerName: 'Home Nine',
        ),
        MatchEvent(
          minute: 60,
          type: MatchEventType.goal,
          teamNationId: 2,
          playerId: 109,
          playerName: 'Away Nine',
        ),
      ],
      moments: [
        ShotMoment(
          minute: 20,
          stoppage: 0,
          seq: 0,
          teamNationId: 1,
          shooterId: 9,
          zone: PitchZone.boxCentre,
          xg: 0.4,
          outcome: ShotOutcome.woodwork,
          origin: ShotOrigin.openPlay,
        ),
      ],
      homeShots: 3,
      awayShots: 2,
      homePossession: 50,
    ),
    nations: {1: nation(id: 1), 2: nation(id: 2)},
    homeTeam: MatchTeam(nationId: 1, xi: xi(1, 1), instructions: instructions),
    awayTeam: MatchTeam(
      nationId: 2,
      xi: xi(101, 2),
      instructions: instructions,
    ),
    playerNationId: 1,
    bench: [for (var i = 50; i < 57; i++) at(i, 1, PlayerPosition.cm)],
    saveSeed: 42,
    ground: (
      stadium: 'Test Park',
      city: 'Testville',
      groundNationId: 1,
      capacity: 40000,
      attendance: 36000,
      soldOut: false,
    ),
  );
}

Future<(ProviderContainer, FakeMatchAudio)> _pump(
  WidgetTester tester, {
  bool? soundOn,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    kMatchViewModePrefsKey: 'timeline',
  });
  tester.view
    ..physicalSize = const Size(400, 900)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final audio = FakeMatchAudio();
  final c = ProviderContainer(
    overrides: [
      matchPreviewProvider(1).overrideWith((ref) async => _preview()),
      soundHapticsEnabledProvider.overrideWith((ref) => false),
      matchAttemptSaltProvider.overrideWithValue(() => 0),
      matchAudioProvider.overrideWithValue(audio),
      if (soundOn != null)
        matchSoundEnabledProvider.overrideWith((ref) => soundOn),
    ],
  );
  addTearDown(c.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        theme: AppTheme.theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MatchScreen(careerId: 1),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
  return (c, audio);
}

MatchScreenProbe _screen(WidgetTester tester) =>
    tester.state(find.byType(MatchScreen)) as MatchScreenProbe;

/// Pumps 100 ms frames until [done] (or two minutes of fake time).
Future<void> _until(WidgetTester tester, bool Function() done) async {
  for (var i = 0; i < 1200 && !done(); i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(done(), isTrue, reason: 'never got there');
}

bool _shown(WidgetTester tester, int minute) =>
    _screen(tester).shownEvents.any((e) => e.minute == minute);

bool _halfTime(WidgetTester tester) =>
    find.text(enL.matchContinue).evaluate().isNotEmpty;

void main() {
  testWidgets('off by default: a whole match plays without a sound', (
    tester,
  ) async {
    final (c, audio) = await _pump(tester);
    expect(c.read(matchSoundEnabledProvider), isFalse);
    await _until(tester, () => _halfTime(tester));
    await tester.tap(find.text(enL.matchContinue));
    await _until(tester, () => _shown(tester, 60));
    // On to the whistle and past it.
    for (var i = 0; i < 60; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    await tester.pump(const Duration(seconds: 5));
    expect(audio.calls, isEmpty);
  });

  testWidgets('on: whistles, the crowd, a ducked bed, silence on leaving', (
    tester,
  ) async {
    final (_, audio) = await _pump(tester, soundOn: true);
    await tester.pump(const Duration(milliseconds: 50));
    expect(audio.cues.first, SoundCue.whistleKickoff);
    expect(audio.loops, isNotEmpty, reason: 'the bed plays from kick-off');
    final loud = Map.of(audio.loops);

    // 10': the home side scores in front of its own fans.
    await _until(tester, () => _shown(tester, 10));
    expect(audio.cues, contains(SoundCue.roar));

    // 20': the post. The crowd swells, then groans.
    await _until(tester, () => audio.cues.contains(SoundCue.groan));
    expect(
      audio.cues.indexOf(SoundCue.swell),
      lessThan(audio.cues.indexOf(SoundCue.groan)),
    );

    // Paused: the bed ducks; played on: back up.
    await tester.tap(find.byIcon(Icons.pause_rounded));
    await tester.pump();
    for (final e in audio.loops.entries) {
      expect(e.value, lessThan(loud[e.key]!));
    }
    await tester.tap(find.byIcon(Icons.play_arrow_rounded).first);
    await tester.pump();
    expect(audio.loops, loud);

    // Half time: two short blasts, the bed low under the interval.
    await _until(tester, () => _halfTime(tester));
    expect(audio.cues.last, SoundCue.whistleHalfTime);
    for (final e in audio.loops.entries) {
      expect(e.value, lessThan(loud[e.key]!));
    }
    await tester.tap(find.text(enL.matchContinue));
    await tester.pump();
    expect(audio.cues.last, SoundCue.whistleKickoff);

    // 60': the visitors score; the away end cheers, the home end groans.
    final before = audio.cues.length;
    await _until(tester, () => _shown(tester, 60));
    expect(
      audio.cues.sublist(before),
      containsAllInOrder([SoundCue.cheerAway, SoundCue.groan]),
    );
    expect(audio.cues.sublist(before), isNot(contains(SoundCue.roar)));

    // Full time: short, short, long, and the bed fades away.
    await _until(
      tester,
      () => audio.cues.contains(SoundCue.whistleFullTime),
    );
    await tester.pump();
    expect(audio.loops, isEmpty);
    expect(audio.cues, isNot(contains(SoundCue.winCheer)), reason: '1-1');

    // Leaving the screen stops everything.
    await tester.pumpWidget(const SizedBox());
    expect(audio.calls.last, 'stopAll');
  });

  testWidgets('on: leaving mid-match stops the bed at once', (tester) async {
    final (_, audio) = await _pump(tester, soundOn: true);
    await tester.pump(const Duration(seconds: 1));
    expect(audio.loops, isNotEmpty);
    await tester.pumpWidget(const SizedBox());
    expect(audio.calls.last, 'stopAll');
    expect(audio.loops, isEmpty);
  });

  testWidgets('on: going to the background stops the bed', (tester) async {
    final (_, audio) = await _pump(tester, soundOn: true);
    await tester.pump(const Duration(seconds: 1));
    expect(audio.loops, isNotEmpty);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    expect(audio.loops, isEmpty);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(audio.loops, isNotEmpty);
  });

  testWidgets(
    'on: skipping to full time silences it',
    skip: !kShowSkipMatch,
    (tester) async {
      final (_, audio) = await _pump(tester, soundOn: true);
      await tester.pump(const Duration(seconds: 1));
      expect(audio.loops, isNotEmpty);
      await tester.tap(find.byIcon(Icons.skip_next_rounded));
      await tester.pump();
      expect(audio.loops, isEmpty);
      final after = audio.calls.length;
      await tester.pump(const Duration(seconds: 5));
      expect(audio.calls.length, after, reason: audio.calls.join('\n'));
    },
  );
}
