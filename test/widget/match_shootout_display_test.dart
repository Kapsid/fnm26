import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_clock.dart';
import 'package:fnm/features/match/pitch/pitch_commentary.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

/// Promo-reel run (1.1.3): three things went wrong once a knockout went to
/// penalties.
void main() {
  // 1-1 after extra time, won 4-3 on penalties by the home side.
  const outcome = KnockoutOutcome(
    homeScore: 1,
    awayScore: 1,
    afterExtraTime: true,
    homeKicks: [true, true, true, true],
    awayKicks: [true, false, true, true],
  );
  const result = MatchResult(
    homeScore: 1,
    awayScore: 1,
    events: [],
    homeShots: 10,
    awayShots: 8,
    homePossession: 50,
  );

  group('the scoreboard after a shootout', () {
    test('stays level: no extra goal for the side that won the kicks', () {
      expect(fullTimeShownScore(result, outcome), (1, 1));
    });

    test('a match settled in ninety minutes shows the engine score', () {
      const won = MatchResult(
        homeScore: 2,
        awayScore: 0,
        events: [],
        homeShots: 10,
        awayShots: 8,
        homePossession: 50,
      );
      expect(fullTimeShownScore(won, null), (2, 0));
    });
  });

  group('the shootout commentary', () {
    final l = AppLocalizationsEn();
    const names = {7: 'Evans', 1: 'Keeper'};
    ShootoutKick kick(KickResult r) =>
        ShootoutKick(takerId: 7, result: r, lane: 0, diveLane: 1);

    test('says each kick, naming the taker', () {
      final scored = [
        l.pitchComPenaltyGoal1('Evans'),
        l.pitchComPenaltyGoal2('Evans'),
        l.pitchComPenaltyGoal3('Evans'),
      ];
      for (var i = 0; i < 6; i++) {
        final line = shootoutKickLine(
          l,
          kick(KickResult.scored),
          names,
          99,
          index: i,
          keeperId: 1,
        );
        expect(scored, contains(line));
      }
      final saved = shootoutKickLine(
        l,
        kick(KickResult.saved),
        names,
        99,
        index: 2,
        keeperId: 1,
      );
      expect(
        [
          l.pitchComPenaltySaved1('Evans', 'Keeper'),
          l.pitchComPenaltySaved2('Evans'),
          l.pitchComPenaltySaved3('Evans', 'Keeper'),
        ],
        contains(saved),
      );
      for (final r in [KickResult.wide, KickResult.post]) {
        expect(
          shootoutKickLine(l, kick(r), names, 3, index: 1),
          contains('Evans'),
        );
      }
    });

    testWidgets('replaces the last open-play line under the pitch', (
      tester,
    ) async {
      final clock = PitchClock(
        vsync: tester,
        pacer: PitchPacer(result, PitchSpeed.mid),
      );
      addTearDown(clock.dispose);
      Future<void> pump(String? shootoutLine) => tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: PitchCommentaryLine(
              clock: clock,
              countAt: (_) => 1,
              lineAt: (_) => 'Over the bar from Evans.',
              shootoutLine: shootoutLine,
            ),
          ),
        ),
      );
      await pump(null);
      await tester.pumpAndSettle();
      expect(find.text('Over the bar from Evans.'), findsOneWidget);
      await pump('GOAL! Evans buries the penalty.');
      await tester.pumpAndSettle();
      expect(find.text('Over the bar from Evans.'), findsNothing);
      expect(find.text('GOAL! Evans buries the penalty.'), findsOneWidget);
    });
  });

  testWidgets('the bar drops the tactics key in a shootout and fits a phone', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: MatchControlBar(
              playing: true,
              speed: 2,
              subsUsed: 0,
              maxSubs: 6,
              spent: 3,
              onPlayPause: () {},
              onSpeed: () {},
              onTactics: null,
              viewToggle: MatchViewToggle(
                current: MatchViewMode.pitch,
                compact: true,
                onChoose: (_) {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(MatchTacticsPillContent), findsNothing);
    expect(find.text('0/6'), findsNothing);
  });
}
