import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';

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
///
/// [onSkip] is the bar's own off switch for the skip-to-full-time aid: the
/// match screen passes `kShowSkipMatch ? _skip : null`, so a null here is
/// exactly what the bar is handed once that constant is flipped to false.
Future<void> pumpWholeControlBar(
  WidgetTester tester, {
  required Locale locale,
  int spent = 0,
  int subsUsed = 0,
  VoidCallback? onSkip,
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
            onSkip: onSkip,
          ),
        ),
      ),
    ),
  );
}

void main() {
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

  // Skip-to-full-time is a TESTING AID behind `kShowSkipMatch`, and an aid
  // with no off switch is how one ships. These two tests are the switch, both
  // ways: the bar shows the pill when the screen hands it a skip callback and
  // has no trace of it when the flag turns that callback into null.
  testWidgets('the aid on: the bar offers the clock and a skip pill', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    var skipped = 0;
    await pumpWholeControlBar(
      tester,
      locale: const Locale('en'),
      onSkip: () => skipped++,
    );

    // The clock controls, as always.
    expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    expect(find.text('2×'), findsOneWidget);

    // And the aid: the icon, its tooltip, and a pill that really fires.
    expect(find.byIcon(Icons.skip_next_rounded), findsOneWidget);
    expect(find.byTooltip('Skip to full time'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.skip_next_rounded));
    expect(skipped, 1, reason: 'the skip pill must be wired, not decorative');
  });

  testWidgets('the aid off: no pill, no icon, no tooltip', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // What `kShowSkipMatch = false` hands the bar.
    await pumpWholeControlBar(tester, locale: const Locale('en'));

    expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    expect(find.text('2×'), findsOneWidget);

    // The icon is named so a straight re-add is caught, and the tooltip is
    // checked separately so swapping the icon for another one cannot walk the
    // control back in: the skip pill is the only control on this bar that
    // carries a tooltip at all.
    expect(find.byIcon(Icons.skip_next_rounded), findsNothing);
    expect(find.byIcon(Icons.fast_forward_rounded), findsNothing);
    expect(find.byType(Tooltip), findsNothing);
  });

  for (final width in [360.0, 400.0]) {
    for (final locale in [const Locale('en'), const Locale('cs')]) {
      // The shipped bar, with the testing aid off: nothing on it is cut, in
      // either language, at either phone width.
      testWidgets(
        'the shipped bar fits whole at ${width.toInt()}px '
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
          expectNothingCut(tester, 'the control bar in ${locale.languageCode}');
        },
      );

      // The same bar with the aid on, which is one more pill on the row. The
      // tactics pill is built to give its LABEL away first and never the
      // count, so the tired label is allowed to ellipsise here; the numbers
      // the manager is actually reading are not, and nothing overflows.
      testWidgets(
        'the bar still holds the numbers at ${width.toInt()}px '
        'in ${locale.languageCode} with the skip pill on',
        (tester) async {
          await tester.binding.setSurfaceSize(Size(width, 800));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          await pumpWholeControlBar(
            tester,
            locale: locale,
            spent: 5,
            subsUsed: 1,
            onSkip: () {},
          );

          expect(tester.takeException(), isNull);
          expectWhole(find.text('2×'), 'the speed');
          expectWhole(find.text('1/$kMaxSubs'), 'the sub count');
          expect(find.byIcon(Icons.skip_next_rounded), findsOneWidget);
        },
      );
    }
  }
}
