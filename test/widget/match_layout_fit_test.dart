import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_preview_screen.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/tournaments/wc_host_theme.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';

/// The match screens as a Czech player with the system font turned up sees
/// them: a Galaxy A56 is about 412 wide, and the playtest that found these ran
/// Czech at an enlarged font scale. 360 is the narrow Android floor.
///
/// Three reports from that playtest: Tactics wrapping beside Kick-off, the
/// live score sitting off the middle, and Continue pushed below the fold at
/// half time by the team talk above it.
const _widths = [360.0, 412.0];
const _scale = TextScaler.linear(1.3);

Widget _app(Widget home, {String locale = 'cs'}) => MaterialApp(
  locale: Locale(locale),
  theme: AppTheme.theme,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: _scale),
    child: child!,
  ),
  home: home,
);

void main() {
  group('pre-match bottom bar', () {
    for (final width in _widths) {
      testWidgets('Tactics stays on one line at $width', (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              // No fixture: the body shows its empty state, and the bar under
              // it, which is what this measures, is built all the same.
              matchPreviewProvider(1).overrideWith((ref) async => null),
              wcHostThemeProvider(
                1,
              ).overrideWith((ref) => Completer<WcHostTheme>().future),
              continentalHostThemeProvider(
                1,
              ).overrideWith((ref) => Completer<WcHostTheme>().future),
            ],
            child: _app(const MatchPreviewScreen(careerId: 1)),
          ),
        );
        await tester.pump();
        final l = AppLocalizations.of(
          tester.element(find.byType(MatchPreviewScreen)),
        );
        final tactics = find.text(l.matchTactics);
        expectOneLine(tactics, 'the Tactics label');
        expectWhole(tactics, 'the Tactics label');
        // Scaled down to fit is acceptable; scaled to a smear is not.
        expect(shrinkOf(tester, tactics), greaterThan(0.75));
        expectOneLine(find.text(l.matchKickOff), 'the Kick-off label');
        // Kick-off no longer towers over its neighbour.
        final kick = tester.getSize(find.byType(PrimaryButton));
        final out = tester.getSize(find.byType(OutlinedButton));
        expect(kick.height, out.height);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('live scoreboard', () {
    for (final width in _widths) {
      for (final (home, away, hs, as_) in [
        ('Bosna a Hercegovina', 'Čad', 1, 0),
        ('Čad', 'Středoafrická republika', 10, 1),
      ]) {
        testWidgets('$hs : $as_ between "$home" and "$away" at $width', (
          tester,
        ) async {
          await tester.binding.setSurfaceSize(Size(width, 800));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await tester.pumpWidget(
            _app(
              Scaffold(
                body: Column(
                  children: [
                    MatchScoreboard(
                      homeCode: 'BIH',
                      awayCode: 'CHA',
                      homeName: home,
                      awayName: away,
                      homeOverall: 71,
                      awayOverall: 58,
                      homeScore: hs,
                      awayScore: as_,
                      clock: 'PO PRODLOUŽENÍ',
                      live: false,
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.pump();
          final centre = width / 2;
          // The colon is the scoreline's centre, whatever the numbers are.
          expect(
            tester.getCenter(find.text(' : ')).dx,
            closeTo(centre, 0.5),
            reason: 'the score is off the centre line',
          );
          expect(
            tester.getCenter(find.text('PO PRODLOUŽENÍ')).dx,
            closeTo(centre, 0.5),
            reason: 'the clock is off the centre line',
          );
          expectOneLine(find.text('PO PRODLOUŽENÍ'), 'the clock');
          expect(tester.takeException(), isNull);
        });
      }
    }
  });

  group('half-time team talk', () {
    // The body the overlay covers: a ~800-tall phone less the status bar, the
    // app's own top bar and the pinned match controls under it.
    const bodyHeight = 620.0;
    for (final width in _widths) {
      for (final options in [
        TeamTalkTone.values.take(3).toList(),
        TeamTalkTone.values.reversed.take(3).toList(),
      ]) {
        testWidgets('Continue is on screen at $width with $options', (
          tester,
        ) async {
          await tester.binding.setSurfaceSize(Size(width, bodyHeight));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          var continued = false;
          await tester.pumpWidget(
            _app(
              Scaffold(
                body: Stack(
                  children: [
                    HalfTimePrompt(
                      heading: 'PRODLOUŽENÍ · POLOČAS',
                      homeCode: 'CZE',
                      awayCode: 'BRA',
                      homeScore: 1,
                      awayScore: 1,
                      playerIsHome: true,
                      possession: 48,
                      subsUsed: 2,
                      selectedTalk: options.first,
                      options: options,
                      onTalk: (_) {},
                      onTactics: () {},
                      onContinue: () => continued = true,
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.pump();
          final l = AppLocalizations.of(
            tester.element(find.byType(HalfTimePrompt)),
          );
          final button = find.text(l.matchContinue);
          final rect = tester.getRect(button);
          expect(
            rect.bottom,
            lessThanOrEqualTo(bodyHeight),
            reason: 'Continue is below the fold',
          );
          // Reachable without scrolling: a tap where it is drawn lands on it.
          await tester.tap(button);
          expect(continued, isTrue);
          expectOneLine(
            find.text(l.matchTacticsWithSubs(2, kMaxSubs)),
            'the tactics button',
          );
          expect(tester.takeException(), isNull);
        });
      }
    }
  });
}
