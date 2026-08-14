import 'package:flutter/material.dart';
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
}
