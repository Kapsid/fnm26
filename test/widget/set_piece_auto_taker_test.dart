import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';
import '../helpers/fixtures.dart';

/// The set-piece slots used to sit blank until the manager named somebody,
/// which read as "nobody is taking these" — while the engine had already
/// decided it would be the best technical man in the side. These tests hold
/// the screen to the engine's own answer, and hold the names on it to their
/// full width on a 360px phone in both languages.
void main() {
  const formation = Formation.f442;

  /// Asserts that every [finder] match is rendered WHOLE, not ellipsised.
  ///
  /// `takeException` alone is not enough and never was: it passes for any
  /// amount of quiet truncation. A taker's name cut to "Karel Vondráče…" is
  /// exactly the guessing this feature exists to end.
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

  /// The best technical man on the pitch, and a long name at that: the slot
  /// has to name him whether or not he fits comfortably.
  const bestName = 'Vondráčkovský-Nejedlý';

  /// Eleven starters. Id 7 is the technical pick; the keeper (id 1) is better
  /// still, so a penalty slot that names him would be following the wrong
  /// rule. Five substitutes sit on the bench.
  List<Player> squad() => [
    for (var i = 0; i < 11; i++)
      player(
        id: i + 1,
        nationId: 1,
        name: i == 6 ? bestName : 'Starter${i + 1}',
        position: formation.positions[i],
        attributes: flatAttributes(
          switch (i) {
            0 => 95, // the keeper: best of all, and not a penalty taker
            6 => 90,
            _ => 70,
          },
        ),
      ),
    for (var i = 12; i <= 16; i++)
      player(id: i, nationId: 1, name: 'Bench$i', attributes: flatAttributes()),
  ];

  /// Opens the real in-match editor and lands on its tactics tab, where the
  /// set-piece takers live.
  ///
  /// The locale goes on the MaterialApp, NOT on a `Localizations.override`
  /// around the launcher: the editor is a route pushed under the root
  /// Navigator, so an override there leaves the sheet in English and turns a
  /// Czech width case into the English one run twice.
  Future<AppLocalizations> openTakers(
    WidgetTester tester, {
    List<int?>? lineup,
    ({int? penalty, int? deadBall}) takers = (penalty: null, deadBall: null),
    double width = 400,
    Locale locale = const Locale('en'),
  }) async {
    tester.view
      ..physicalSize = Size(width, 1800)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.theme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (inner) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => showInMatchTactics(
                    inner,
                    minute: 60,
                    formation: formation,
                    lineup: lineup ?? [for (var i = 1; i <= 11; i++) i],
                    instructions: const TacticalInstructions(),
                    pool: squad(),
                    startingIds: {for (var i = 1; i <= 11; i++) i},
                    maxSubs: 5,
                    takers: takers,
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    final l = await AppLocalizations.delegate.load(locale);
    await tester.tap(find.text(l.tacticsTabTactics));
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.text(l.tacticsSetPieceTakers),
      find.byType(ListView).last,
      const Offset(0, -120),
    );
    await tester.pumpAndSettle();
    return l;
  }

  /// The summary line for a set piece: the label (with the automatic marker
  /// when there is one) over the name.
  Finder summaryLabel(String text) => find.descendant(
    of: find.byType(SetPieceTakerSummary),
    matching: find.text(text),
  );

  testWidgets("an unnamed penalty slot names the engine's own pick", (
    tester,
  ) async {
    final l = await openTakers(tester);

    // The keeper is the best technical man in the side, but the engine never
    // hands him a penalty: that slot names the best OUTFIELDER. The dead ball
    // has no such rule, so it does name him — two rules, two names, and the
    // screen has to tell them apart the way the engine does.
    expect(summaryLabel(bestName), findsOneWidget);
    expect(summaryLabel('Starter1'), findsOneWidget);
    expect(
      summaryLabel('${l.tacticsPenalties}  ·  ${l.tacticsTakerAuto}'),
      findsOneWidget,
    );
    expect(
      summaryLabel('${l.tacticsCornersFreeKicks}  ·  ${l.tacticsTakerAuto}'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('naming a man drops the automatic marker', (tester) async {
    final l = await openTakers(tester, takers: (penalty: 3, deadBall: null));

    expect(summaryLabel(l.tacticsPenalties), findsOneWidget);
    expect(
      summaryLabel('${l.tacticsPenalties}  ·  ${l.tacticsTakerAuto}'),
      findsNothing,
    );
    expect(summaryLabel('Starter3'), findsOneWidget);
    // The dead ball is still nobody's, so it still says so.
    expect(
      summaryLabel('${l.tacticsCornersFreeKicks}  ·  ${l.tacticsTakerAuto}'),
      findsOneWidget,
    );
  });

  testWidgets('a named taker off the pitch falls back to automatic', (
    tester,
  ) async {
    // Starter3 was the penalty taker and has already been substituted.
    final l = await openTakers(
      tester,
      lineup: [1, 2, 12, 4, 5, 6, 7, 8, 9, 10, 11],
      takers: (penalty: 3, deadBall: null),
    );

    expect(
      summaryLabel('${l.tacticsPenalties}  ·  ${l.tacticsTakerAuto}'),
      findsOneWidget,
      reason: 'a taker who has left the side goes back to automatic',
    );
    expect(summaryLabel(bestName), findsWidgets);
  });

  for (final width in [360.0, 400.0]) {
    testWidgets('the taker names survive ${width.toInt()}px in English', (
      tester,
    ) async {
      final l = await openTakers(tester, width: width);

      expectWhole(summaryLabel(bestName), "the automatic taker's name");
      expectWhole(
        summaryLabel('${l.tacticsPenalties}  ·  ${l.tacticsTakerAuto}'),
        'the penalty slot label',
      );
      expectWhole(
        summaryLabel('${l.tacticsCornersFreeKicks}  ·  ${l.tacticsTakerAuto}'),
        'the dead-ball slot label',
      );
      expect(tester.takeException(), isNull);
      expectNothingCut(tester);
      // The picker row beneath spells the same man's name in a [WholeText],
      // which no ellipsis guard can fail because it scales itself down
      // instead. What is held there is how far it had to: it was a plain
      // [Text] with an ellipsis and read "Vondrackovs..." at 360 points.
      expectLegible(
        tester,
        find.descendant(
          of: find.byType(WholeText),
          matching: find.text(bestName),
        ),
        "the taker list's name",
      );
    });

    testWidgets('the taker names survive ${width.toInt()}px in Czech', (
      tester,
    ) async {
      final l = await openTakers(
        tester,
        width: width,
        locale: const Locale('cs'),
      );

      // A silent fall back to English would render this screen in English and
      // run the case above twice, so prove the Czech is really on screen.
      expect(l.tacticsSetPieceTakers, 'EXEKUTOŘI STANDARDEK');
      expect(find.text('EXEKUTOŘI STANDARDEK'), findsOneWidget);

      expectWhole(summaryLabel(bestName), "the automatic taker's name");
      expectWhole(
        summaryLabel('${l.tacticsPenalties}  ·  ${l.tacticsTakerAuto}'),
        'the penalty slot label',
      );
      expectWhole(
        summaryLabel('${l.tacticsCornersFreeKicks}  ·  ${l.tacticsTakerAuto}'),
        'the dead-ball slot label',
      );
      expect(tester.takeException(), isNull);
      expectNothingCut(tester);
      // The picker row beneath spells the same man's name in a [WholeText],
      // which no ellipsis guard can fail because it scales itself down
      // instead. What is held there is how far it had to: it was a plain
      // [Text] with an ellipsis and read "Vondrackovs..." at 360 points.
      expectLegible(
        tester,
        find.descendant(
          of: find.byType(WholeText),
          matching: find.text(bestName),
        ),
        "the taker list's name",
      );
    });
  }
}
