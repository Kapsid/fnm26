import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/results/results_providers.dart';
import 'package:fnm/features/results/results_screen.dart';

import '../helpers/pump_app.dart';

/// The results screen opens where the manager is.
///
/// A career is endless, so this list only grows. Left in stored order it put
/// the oldest match of the oldest campaign at the top, which is the one thing
/// nobody opens the screen to see. What is coming goes first, what just
/// happened comes next, and every campaign before the current one waits
/// behind one line until it is asked for.
void main() {
  const careerId = 7;

  /// The player, and the two opponents the fixtures below are against.
  final nations = {
    for (var i = 1; i <= 3; i++)
      i: Nation(
        id: i,
        name: 'Nation $i',
        code: 'N$i',
        confederation: Confederation.europe,
        ranking: i,
      ),
  };

  /// One World Championship qualifying fixture. [competitionId] is the
  /// campaign it belongs to: 10 is a campaign from four years ago, 20 is the
  /// one being played now.
  Fixture qualifier({
    required int id,
    required int competitionId,
    required DateTime date,
    required bool played,
  }) => Fixture(
    id: id,
    careerId: careerId,
    competitionId: competitionId,
    matchday: id,
    date: date,
    homeNationId: 1,
    awayNationId: id.isEven ? 2 : 3,
    homeScore: played ? 2 : null,
    awayScore: played ? 1 : null,
    played: played,
  );

  /// Three matches from the old campaign, and the current one: two played,
  /// two still to come.
  final oldCampaign = [
    qualifier(
      id: 1,
      competitionId: 10,
      date: DateTime(2026, 3),
      played: true,
    ),
    qualifier(
      id: 2,
      competitionId: 10,
      date: DateTime(2026, 6),
      played: true,
    ),
    qualifier(
      id: 3,
      competitionId: 10,
      date: DateTime(2026, 9),
      played: true,
    ),
  ];
  final currentCampaign = [
    qualifier(
      id: 4,
      competitionId: 20,
      date: DateTime(2030, 3),
      played: true,
    ),
    qualifier(
      id: 5,
      competitionId: 20,
      date: DateTime(2030, 6),
      played: true,
    ),
    qualifier(
      id: 6,
      competitionId: 20,
      date: DateTime(2030, 9),
      played: false,
    ),
    qualifier(
      id: 7,
      competitionId: 20,
      date: DateTime(2030, 10),
      played: false,
    ),
  ];

  /// The repository hands fixtures over oldest first, which is exactly the
  /// order the screen used to print them in.
  final storedOrder = [...oldCampaign, ...currentCampaign];

  /// Asserts that every paragraph [finder] matches printed in full.
  ///
  /// `takeException` is not a width test: it passes for any amount of quiet
  /// ellipsis, and a date that reads "1 Sep 20..." has failed at its only job.
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

  /// Asserts that NOTHING anywhere on the screen ran out of room, including
  /// the label somebody added without a maxLines.
  void expectNothingCut(WidgetTester tester) {
    for (final element in find.byType(Text).evaluate()) {
      final paragraph = element.renderObject;
      if (paragraph is! RenderParagraph) continue;
      expect(
        paragraph.didExceedMaxLines,
        isFalse,
        reason:
            'something on the results screen is cut off: '
            '"${(element.widget as Text).data}"',
      );
    }
  }

  Future<void> pumpResults(
    WidgetTester tester, {
    double width = 400,
    Locale locale = const Locale('en'),
    List<Fixture>? fixtures,
  }) async {
    tester.view
      ..physicalSize = Size(width, 1600)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      const ResultsScreen(careerId: careerId),
      locale: locale,
      overrides: [
        resultsProvider(careerId).overrideWith(
          (ref) async => ResultsData(
            fixtures: fixtures ?? storedOrder,
            nations: nations,
            playerNationId: 1,
          ),
        ),
      ],
    );
    await tester.pumpAndSettle();
  }

  /// Where a date sits down the screen, so the order printed can be read
  /// back off the layout rather than off the widget tree.
  double topOf(WidgetTester tester, String date) =>
      tester.getTopLeft(find.text(date).first).dy;

  testWidgets('what is coming leads, and what just happened follows it', (
    tester,
  ) async {
    await pumpResults(tester);

    // Soonest unplayed first, then the rest of what is scheduled, then the
    // played matches of this campaign with the most recent at the top.
    final order = ['1 Sep 2030', '1 Oct 2030', '1 Jun 2030', '1 Mar 2030'];
    for (final date in order) {
      expect(find.text(date), findsOneWidget, reason: '$date is missing');
    }
    for (var i = 1; i < order.length; i++) {
      expect(
        topOf(tester, order[i]),
        greaterThan(topOf(tester, order[i - 1])),
        reason: '${order[i]} should sit below ${order[i - 1]}',
      );
    }
  });

  testWidgets('the campaign before this one waits behind one line', (
    tester,
  ) async {
    await pumpResults(tester);

    // Three matches from four years ago, none of them printed and all of
    // them counted.
    expect(find.text('1 Mar 2026'), findsNothing);
    expect(find.text('1 Jun 2026'), findsNothing);
    expect(find.text('1 Sep 2026'), findsNothing);
    expect(find.text('Earlier matches (3)'), findsOneWidget);
  });

  testWidgets('tapping the line opens the older campaign, newest first', (
    tester,
  ) async {
    await pumpResults(tester);

    await tester.tap(find.text('Earlier matches (3)'));
    await tester.pumpAndSettle();

    final older = ['1 Sep 2026', '1 Jun 2026', '1 Mar 2026'];
    for (final date in older) {
      expect(find.text(date), findsOneWidget, reason: '$date did not open');
    }
    for (var i = 1; i < older.length; i++) {
      expect(
        topOf(tester, older[i]),
        greaterThan(topOf(tester, older[i - 1])),
        reason: '${older[i]} should sit below ${older[i - 1]}',
      );
    }
    // And it sits below everything from the campaign being played now.
    expect(
      topOf(tester, '1 Sep 2026'),
      greaterThan(topOf(tester, '1 Mar 2030')),
    );
  });

  testWidgets('a competition with no history offers nothing to open', (
    tester,
  ) async {
    await pumpResults(tester, fixtures: currentCampaign);
    expect(find.textContaining('Earlier matches'), findsNothing);
  });

  /// The widest heading and the widest stage name the game can write, which
  /// are both Czech: "KVALIFIKACE KONTINENTÁLNÍHO POHÁRU" over a continental
  /// qualifier, and "SKUPINA FINÁLOVÉHO TURNAJE" over a finals group game.
  List<Fixture> widestWords() => [
    qualifier(
      id: 8,
      competitionId: 30,
      date: DateTime(2030, 3),
      played: true,
    ).copyWith(round: 'CQ'),
    qualifier(
      id: 9,
      competitionId: 40,
      date: DateTime(2030, 6),
      played: true,
    ).copyWith(round: 'GROUP'),
  ];

  for (final width in [360.0, 400.0]) {
    for (final locale in [const Locale('en'), const Locale('cs')]) {
      final at = 'at ${width.toInt()}px in ${locale.languageCode}';
      // Dates are written in the manager's language now (see AppDate), so a
      // Czech run reads "1. zář 2030" where an English one reads "1 Sep
      // 2030". Same day, same row, one more character.
      final czech = locale.languageCode == 'cs';
      final soonest = czech ? '1. zář 2030' : '1 Sep 2030';
      final oldest = czech ? '1. zář 2026' : '1 Sep 2026';

      testWidgets('the screen prints every word whole, $at', (tester) async {
        await pumpResults(tester, width: width, locale: locale);
        expectWhole(find.text(soonest), 'a fixture date');
        expectNothingCut(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('the widest names in the game still read whole, $at', (
        tester,
      ) async {
        await pumpResults(
          tester,
          width: width,
          locale: locale,
          fixtures: widestWords(),
        );
        expectNothingCut(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('the opened history prints every word whole, $at', (
        tester,
      ) async {
        await pumpResults(tester, width: width, locale: locale);
        final header = locale.languageCode == 'cs'
            ? 'Starší zápasy (3)'
            : 'Earlier matches (3)';
        expectWhole(find.text(header), 'the earlier-matches line');
        await tester.tap(find.text(header));
        await tester.pumpAndSettle();
        expectWhole(find.text(oldest), 'an older fixture date');
        expectNothingCut(tester);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
