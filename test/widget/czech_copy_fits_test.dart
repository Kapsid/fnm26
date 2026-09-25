import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/util/federation_label.dart';
import 'package:fnm/core/util/squad_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';

/// The copy this batch added, measured on a phone, in both languages.
///
/// Czech is the longer language almost everywhere ("STATISTIKY" against
/// "STATS", "Lékařský a vědecký úsek" against "Medical & Sports Science"), so
/// a string that fits in English says nothing about the app the manager
/// actually plays. Each screen below is pumped at 320, 360 and 400 in `en` and
/// in `cs`, and the locale is read back off the screen before anything is
/// measured.
const _widths = [320.0, 360.0, 400.0];
const _locales = ['en', 'cs'];

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  required double width,
  required String locale,
}) async {
  await tester.binding.setSurfaceSize(Size(width, 800));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale(locale),
      theme: AppTheme.theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('the live match tab strip', () {
    for (final width in _widths) {
      for (final locale in _locales) {
        testWidgets('three tabs share $width in $locale', (tester) async {
          await _pump(
            tester,
            const DefaultTabController(
              length: 3,
              child: Column(children: [MatchDetailTabs()]),
            ),
            width: width,
            locale: locale,
          );
          expectLocale(tester, find.byType(MatchDetailTabs), locale);
          final l = AppLocalizations.of(
            tester.element(find.byType(MatchDetailTabs)),
          );

          // The labels are WholeText, which scales itself down rather than
          // being cut, so no ellipsis guard can fail inside one and the
          // question is how far it had to shrink. Each is asserted to be ON
          // SCREEN first: expectLegible passes silently on an empty finder.
          for (final label in [
            l.matchTabTimeline,
            l.matchTabStats,
            l.matchTabLineups,
          ]) {
            final finder = find.text(label);
            expect(finder, findsOneWidget, reason: '"$label" is not on screen');
            expectOneLine(finder, 'the "$label" tab');
            expectLegible(tester, finder, 'the "$label" tab');
          }
        });
      }
    }
  });

  group('the half-time interval', () {
    for (final width in _widths) {
      for (final locale in _locales) {
        testWidgets('the first half read back at $width in $locale', (
          tester,
        ) async {
          await _pump(
            tester,
            Stack(
              children: [
                HalfTimePrompt(
                  heading: 'X',
                  homeCode: 'CZE',
                  awayCode: 'BRA',
                  homeScore: 3,
                  awayScore: 0,
                  playerIsHome: true,
                  possession: 60,
                  subsUsed: 0,
                  selectedTalk: null,
                  options: TeamTalkTone.values.take(3).toList(),
                  onTalk: (_) {},
                  onTactics: () {},
                  onContinue: () {},
                ),
              ],
            ),
            width: width,
            locale: locale,
          );
          expectLocale(tester, find.byType(HalfTimePrompt), locale);
          final l = AppLocalizations.of(
            tester.element(find.byType(HalfTimePrompt)),
          );

          // "You lead by 3 goals · 60% possession" — one line of copy carrying
          // two facts, and the Czech is longer than both halves of it.
          final read = find.text(
            '${l.matchStateLead(3)} · ${l.matchPossessionShare(60)}',
          );
          expect(read, findsOneWidget, reason: 'the half-time read is missing');
          expectNoBrokenWord(read, 'the half-time read');
          expectNothingCut(tester, 'the half-time interval');
        });
      }
    }
  });

  group('the federation invest sliders', () {
    for (final width in _widths) {
      for (final locale in _locales) {
        testWidgets('department names and blurbs at $width in $locale', (
          tester,
        ) async {
          await _pump(
            tester,
            SingleChildScrollView(
              child: InvestmentEditor(
                available: 8000000,
                initial: const (
                  youth: 1000000,
                  commercial: 0,
                  medical: 0,
                  naturalization: 0,
                  boardRelations: 0,
                ),
                onChanged: (_) {},
              ),
            ),
            width: width,
            locale: locale,
          );
          expectLocale(tester, find.byType(InvestmentEditor), locale);
          final l = AppLocalizations.of(
            tester.element(find.byType(InvestmentEditor)),
          );

          // Both the name and the blurb are allowed to WRAP here (the name
          // shares its row with the euro figure, the blurb has the column to
          // itself), and neither carries a maxLines — so no ellipsis guard can
          // fail on either, and what a too-long Czech word does instead is get
          // broken across lines wherever the edge falls.
          for (final d in Department.values) {
            final name = find.text(departmentLabel(l, d));
            expect(name, findsOneWidget, reason: 'no row for $d');
            expectNoBrokenWord(name, 'the $d name');
            final blurb = find.text(departmentBlurb(l, d));
            expect(blurb, findsOneWidget, reason: 'no blurb for $d');
            expectNoBrokenWord(blurb, 'the $d blurb');
          }
          expectNothingCut(tester, 'the invest sliders');
        });
      }
    }
  });

  group('a position written out in full', () {
    for (final locale in _locales) {
      testWidgets('fits the role picker heading in $locale', (tester) async {
        // The longest of them, uppercased, is what the role picker's heading
        // carries: `l.tacticsPickRole(positionName(l, p).toUpperCase())`.
        await _pump(
          tester,
          Builder(
            builder: (context) {
              final l = AppLocalizations.of(context);
              final longest = PlayerPosition.values
                  .map((p) => positionName(l, p))
                  .reduce((a, b) => a.length >= b.length ? a : b);
              return Text(l.tacticsPickRole(longest.toUpperCase()));
            },
          ),
          width: 320,
          locale: locale,
        );
        expectLocale(tester, find.byType(Text).first, locale);
        expectNoBrokenWord(find.byType(Text).first, 'the role picker heading');
      });
    }
  });
}
