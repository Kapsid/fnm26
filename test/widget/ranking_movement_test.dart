import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/ranking/world_ranking_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';

/// What the ranking screen says about movement: the direction a nation has
/// gone since the last freeze, how far, and — for the manager's own nation —
/// the two places it came from and went to, spelled out above the table.
///
/// A World Championship can move a nation twenty places now, so the figure is
/// no longer a single digit's worth of drift and the old 9pt number in a 20px
/// box would have cut it. Every number here is a plain [Text] with maxLines: 1
/// so `expectWhole` can actually fail: this project's WholeText scales itself
/// down to fit, which makes a width guard blind inside one.
void main() {
  Nation nation(int id, String name) => Nation(
    id: id,
    name: name,
    code: 'AAA',
    confederation: Confederation.southAmerica,
    ranking: id,
  );

  /// Pumps [child] at [width] in [locale], with the locale on the MaterialApp
  /// itself rather than a Localizations.override around the child.
  Future<void> pumpAt(
    WidgetTester tester,
    Widget child, {
    required double width,
    required String locale,
  }) async {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
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

  Widget rankRow(int movement, {bool isPlayer = false, String name = 'Peru'}) =>
      RankRow(
        nation: nation(4, name),
        rank: 4,
        points: 1987,
        movement: movement,
        isPlayer: isPlayer,
        onTap: () {},
      );

  /// The row as the list lays it out: the list's own side padding, so the row
  /// gets exactly the width it gets on the screen.
  Widget row(int movement, {bool isPlayer = false, String name = 'Peru'}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: rankRow(movement, isPlayer: isPlayer, name: name),
      );

  // "Some nations show 19 instead of 194" (owner, 1.1.4): the rank sat in a
  // fixed 30px cell, and three digits under a larger text size were cut.
  for (final scale in [1.0, 1.3, 1.6]) {
    testWidgets('a three-digit rank is whole at text size $scale', (
      tester,
    ) async {
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await pumpAt(
        tester,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RankRow(
            nation: nation(194, 'Turks and Caicos Islands'),
            rank: 194,
            points: 812,
            movement: -12,
            isPlayer: false,
            onTap: () {},
          ),
        ),
        width: 360,
        locale: 'en',
      );
      final paragraph = tester.renderObject<RenderParagraph>(
        find.descendant(of: find.text('194'), matching: find.byType(RichText)),
      );
      expect(paragraph.didExceedMaxLines, isFalse);
      expect(tester.takeException(), isNull);
    });
  }

  group('a nation movement is on the row', () {
    testWidgets('a climb draws an up arrow and the number of places', (
      tester,
    ) async {
      await pumpAt(tester, row(21), width: 360, locale: 'en');

      expect(find.text('▲21'), findsOneWidget);
    });

    testWidgets('a slide draws a down arrow', (tester) async {
      await pumpAt(tester, row(-13), width: 360, locale: 'en');

      // The direction is the arrow; the figure itself is the distance, never
      // a minus sign the manager has to read twice.
      expect(find.text('▼13'), findsOneWidget);
    });

    testWidgets('standing still draws neither arrow', (tester) async {
      await pumpAt(tester, row(0), width: 360, locale: 'en');

      expect(find.textContaining('▲'), findsNothing);
      expect(find.textContaining('▼'), findsNothing);
      expect(find.text('–'), findsOneWidget);
    });

    // The dense row is 44 high: its flag must still come out round, on the
    // manager's own row (with its tag) as on any other.
    for (final (movement, mine) in [(0, false), (-13, true)]) {
      testWidgets('the flag stays square at the row height ($movement)', (
        tester,
      ) async {
        await pumpAt(
          tester,
          SizedBox(
            height: kRankRowHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: rankRow(movement, isPlayer: mine),
            ),
          ),
          width: 360,
          locale: 'en',
        );
        expect(tester.getSize(find.byType(FlagDisc)), const Size(22, 22));
        expectNothingCut(tester);
      });
    }

    for (final width in [360.0, 400.0]) {
      for (final locale in ['en', 'cs']) {
        testWidgets('the figure is whole at $width in $locale', (tester) async {
          // Three digits: the worst a 200-nation table can produce.
          await pumpAt(tester, row(-104), width: width, locale: locale);
          expectWhole(find.text('▼104'), 'the movement figure');
          expectNothingCut(tester);
        });

        testWidgets('the own row with its tag fits at $width in $locale', (
          tester,
        ) async {
          await pumpAt(
            tester,
            row(-104, isPlayer: true, name: 'Bosnia and Herzegovina'),
            width: width,
            locale: locale,
          );
          final l = AppLocalizations.of(tester.element(find.byType(RankRow)));
          expectWhole(find.text(l.rankingYourTeam), 'the your-team tag');
          expectWhole(find.text('1987'), 'the points');
          expectNothingCut(tester);
        });
      }
    }
  });

  group('the header says what the arrows measure, and the own move', () {
    for (final width in [360.0, 400.0]) {
      for (final locale in ['en', 'cs']) {
        testWidgets('whole at $width in $locale after a championship', (
          tester,
        ) async {
          await pumpAt(
            tester,
            const RankMovementHeader(
              baseline: RankBaseline.worldChampionshipDraw,
              from: 125,
              now: 4,
            ),
            width: width,
            locale: locale,
          );

          final l = AppLocalizations.of(
            tester.element(find.byType(RankMovementHeader)),
          );
          expectWhole(find.text(l.rankingSinceWcDraw), 'the arrows caption');
          expectWhole(
            find.text(l.rankingMovedFromTo(125, 4)),
            'the from-and-to figure',
          );
          expectWhole(find.text('▲121'), 'the header movement figure');
          expectNothingCut(tester);
        });

        testWidgets('whole at $width in $locale before any draw', (
          tester,
        ) async {
          await pumpAt(
            tester,
            const RankMovementHeader(
              baseline: RankBaseline.cycleStart,
              from: 30,
              now: 28,
            ),
            width: width,
            locale: locale,
          );

          final l = AppLocalizations.of(
            tester.element(find.byType(RankMovementHeader)),
          );
          expectWhole(
            find.text(l.rankingSinceCycleStart),
            'the arrows caption',
          );
          expectNothingCut(tester);
        });
      }
    }

    testWidgets('a nation missing from the baseline shows the caption alone', (
      tester,
    ) async {
      await pumpAt(
        tester,
        const RankMovementHeader(
          baseline: RankBaseline.cycleStart,
          from: null,
          now: null,
        ),
        width: 360,
        locale: 'en',
      );

      expect(find.byType(RankMovement), findsNothing);
    });
  });

  group('the inbox message about the jump fits the phone', () {
    for (final width in [360.0, 400.0]) {
      for (final locale in ['en', 'cs']) {
        testWidgets('title and body are whole at $width in $locale', (
          tester,
        ) async {
          // Built exactly as the inbox builds it, then laid out the way the
          // list tile lays the title out (one line, ellipsised) and the sheet
          // lays the body out (wrapping, but capped here so the guard can
          // fail on a body that runs away).
          final l = lookupAppLocalizations(Locale(locale));
          final title = l.msgRankJumpTitleUp(4);
          final body = l.msgRankJumpBodyUp(
            'World Championship',
            'Argentina',
            25,
            4,
            21,
          );
          await pumpAt(
            tester,
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // The message list gives the title one line beside an icon,
                  // a year and a chevron: about 90px of furniture.
                  SizedBox(
                    width: width - 32 - 90,
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(body, maxLines: 6, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            width: width,
            locale: locale,
          );

          expectWhole(find.text(title), 'the jump message title');
          expectWhole(find.text(body), 'the jump message body');
          expectNothingCut(tester);
        });
      }
    }
  });
}
