import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_post_detail.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/pump_app.dart';

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
      // A reply is worded by mood, and has more wordings than a report — so it
      // is walked over its own moods rather than over the template variants.
      final moods = t == YTemplate.reaction ? YMood.values : const [null];
      final spread = t == YTemplate.reaction
          ? YFeed.reactionVariantCount
          : YFeed.variantCount;
      for (final mood in moods) {
        for (var v = 0; v < spread; v++) {
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
              replyTo: null,
              mood: mood,
            ),
          );
          expect(body.trim(), isNotEmpty, reason: '$t variant $v is blank');
        }
      }
    }
  });

  group('a post opens', () {
    YPost post(String voice, String key) => (
      voice: YVoice.fan,
      handle: '@$voice',
      displayName: voice,
      template: YTemplate.winTight,
      variant: 0,
      args: const ['Spain', '2–1'],
      date: DateTime(2030, 6, 10),
      key: key,
      replyTo: null,
      mood: null,
    );

    final posts = [
      post('Alice', 'fx:1|fan'),
      post('Bob', 'fx:1|stats'),
      post('Cara', 'fx:2|fan'),
    ];

    testWidgets('a tapped post opens its detail', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: ListView(
            children: [
              for (final p in posts)
                YPostTile(
                  post: p,
                  onTap: () =>
                      Navigator.of(tester.element(find.byType(ListView))).push(
                        MaterialPageRoute<void>(
                          builder: (_) => YPostDetail(post: p, all: posts),
                        ),
                      ),
                ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(YPostTile).first);
      await tester.pumpAndSettle();
      expect(find.byType(YPostDetail), findsOneWidget);
    });

    testWidgets('the detail shows what else was said about that match', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: YPostDetail(post: posts.first, all: posts),
        ),
      );
      await tester.pumpAndSettle();

      // Bob was talking about the same match; Cara was not.
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Cara'), findsNothing);
    });

    testWidgets('a post nobody replied to shows no replies heading', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: YPostDetail(post: posts.last, all: posts),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('ALSO ABOUT THIS MATCH'), findsNothing);
    });
  });
}
