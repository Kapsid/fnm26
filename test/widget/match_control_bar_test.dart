import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Pumps the live match control bar's tactics pill content in isolation, at
/// a narrow phone width, so a test can check what survives the ellipsis.
Future<void> pumpMatchControlBar(
  WidgetTester tester, {
  required int spent,
  required int subsUsed,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SizedBox(
          width: 120,
          child: MatchTacticsPillContent(subsUsed: subsUsed, spent: spent),
        ),
      ),
    ),
  );
}

/// Pumps the whole control bar as the match screen builds it, in [locale].
Future<void> pumpWholeControlBar(
  WidgetTester tester, {
  required Locale locale,
  int spent = 0,
  int subsUsed = 0,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: MatchControlBar(
            playing: true,
            speed: 2,
            subsUsed: subsUsed,
            spent: spent,
            onPlayPause: () {},
            onSpeed: () {},
            onTactics: () {},
          ),
        ),
      ),
    ),
  );
}

void main() {
  /// Asserts that every [finder] match is rendered WHOLE, not ellipsised.
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

  testWidgets('sub count stays visible when the tired label is long', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpMatchControlBar(tester, spent: 5, subsUsed: 1);

    // The count is its own widget and is never the thing that gets clipped,
    // no matter how long the tired label grows.
    expect(find.text('1/$kMaxSubs'), findsOneWidget);
  });

  // A match the manager opened is a match he watches. The hub already lets him
  // simulate one without opening it, so the bar offers the clock and nothing
  // that jumps past it.
  testWidgets('the bar offers play/pause and the speed, and no way to skip', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpWholeControlBar(tester, locale: const Locale('en'));

    // What stays.
    expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    expect(find.text('2×'), findsOneWidget);

    // What is gone. The icon is named so a straight re-add is caught, and the
    // tooltip is checked separately so swapping the icon for another one
    // cannot walk the control back in: the skip pill was the only control on
    // this bar that carried a tooltip at all.
    expect(find.byIcon(Icons.skip_next_rounded), findsNothing);
    expect(find.byIcon(Icons.fast_forward_rounded), findsNothing);
    expect(find.byType(Tooltip), findsNothing);
  });

  for (final width in [360.0, 400.0]) {
    for (final locale in [const Locale('en'), const Locale('cs')]) {
      testWidgets(
        'the remaining controls fit whole at ${width.toInt()}px '
        'in ${locale.languageCode}',
        (tester) async {
          await tester.binding.setSurfaceSize(Size(width, 800));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          await pumpWholeControlBar(
            tester,
            locale: locale,
            spent: 5,
            subsUsed: 1,
          );

          expect(tester.takeException(), isNull);
          expectWhole(find.text('2×'), 'the speed');
          expectWhole(find.text('1/$kMaxSubs'), 'the sub count');
        },
      );
    }
  }
}
