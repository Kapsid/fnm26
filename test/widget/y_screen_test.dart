import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

void main() {
  testWidgets('every template and variant renders real words', (tester) async {
    // A blank post is the failure mode this guards: a template or variant with
    // no string behind it renders as nothing at all, and the feed silently
    // develops holes.
    late AppLocalizations l;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l = AppLocalizations.of(context);
            return const SizedBox();
          },
        ),
      ),
    );

    for (final t in YTemplate.values) {
      for (var v = 0; v < YFeed.variantCount; v++) {
        final body = yPostBody(
          l,
          (
            voice: YVoice.fan,
            handle: '@someone',
            displayName: 'Someone',
            template: t,
            variant: v,
            args: const ['Norway', '2–1', 'Spain'],
            date: DateTime(2030, 6, 10),
            key: 'k',
          ),
        );
        expect(body.trim(), isNotEmpty, reason: '$t variant $v is blank');
      }
    }
  });
}
