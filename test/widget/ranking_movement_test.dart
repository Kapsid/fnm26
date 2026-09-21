import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/ranking/world_ranking_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

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
  /// Asserts that every [finder] match is rendered WHOLE, not ellipsised.
  ///
  /// `takeException` alone is not enough and never was: it passes for any
  /// amount of quiet truncation.
  void expectWhole(Finder finder, String what) {
    final elements = finder.evaluate();
    expect(elements, isNotEmpty, reason: '$what is not on screen at all');
    for (final element in elements) {
      final paragraph = element.renderObject! as RenderParagraph;
      expect(
        paragraph.didExceedMaxLines,
        isFalse,
        reason:
            '$what is cut off: it wants '
            '${paragraph.getMaxIntrinsicWidth(double.infinity)}px '
            'and was given ${paragraph.size.width}px',
      );
    }
  }

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

  Widget row(int movement) => Padding(
    // The list's own padding, so the row gets exactly the width it gets on
    // the screen and the guard measures the real thing.
    padding: const EdgeInsets.all(16),
    child: RankRow(
      nation: nation(4, 'Peru'),
      rank: 4,
      points: 1987,
      movement: movement,
      // Not the manager's own row: that one carries a "your team" chip beside
      // the name, and the chip plus a long name overflows the row's name
      // column under the test font. That is its own fault, older than this
      // change, and nothing to do with the movement cell being measured here.
      isPlayer: false,
      onTap: () {},
    ),
  );

  group('a nation movement is on the row', () {
    testWidgets('a climb draws an up arrow and the number of places', (
      tester,
    ) async {
      await pumpAt(tester, row(21), width: 360, locale: 'en');

      expect(find.byIcon(Icons.arrow_drop_up), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
      expect(find.text('21'), findsOneWidget);
    });

    testWidgets('a slide draws a down arrow', (tester) async {
      await pumpAt(tester, row(-13), width: 360, locale: 'en');

      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_up), findsNothing);
      // The direction is the arrow; the figure itself is the distance, never
      // a minus sign the manager has to read twice.
      expect(find.text('13'), findsOneWidget);
    });

    testWidgets('standing still draws neither arrow', (tester) async {
      await pumpAt(tester, row(0), width: 360, locale: 'en');

      expect(find.byIcon(Icons.arrow_drop_up), findsNothing);
      expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
      expect(find.byIcon(Icons.remove), findsOneWidget);
    });

    for (final width in [360.0, 400.0]) {
      for (final locale in ['en', 'cs']) {
        testWidgets('the figure is whole at $width in $locale', (tester) async {
          // Three digits: the worst a 200-nation table can produce.
          await pumpAt(tester, row(-104), width: width, locale: locale);
          expectWhole(find.text('104'), 'the movement figure');
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
          expectWhole(find.text('121'), 'the header movement figure');
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
        });
      }
    }
  });
}
