import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_post_detail.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';
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

  group('the seam under the reserve', () {
    // The fix that put the tournaments back in the feed put them BELOW the
    // recent posts, where the dates jump back two years with nothing to say
    // so. A manager scrolling for the continental championship found what
    // looked like a fault in the feed. This is the heading that says it is
    // older news, and these are the two things that can go wrong with it: it
    // must sit exactly at the seam, and it must not appear at all when there
    // is no reserve.
    YPost chatter(int i) => (
      voice: YVoice.fan,
      handle: '@fan$i',
      displayName: 'Recent$i',
      template: YTemplate.winTight,
      variant: 0,
      args: const ['Spain', '2-1'],
      date: DateTime(2030, 6, 10 - i),
      key: 'fx:$i|fan',
      replyTo: null,
      mood: null,
    );

    YPost landmark(int i) => (
      voice: YVoice.breaking,
      handle: '@wire$i',
      displayName: 'Older$i',
      template: YTemplate.eliminated,
      variant: 0,
      args: const ['European Championship'],
      date: DateTime(2028, 6, 21 - i),
      key: 'out:cmp:$i|breaking',
      replyTo: null,
      mood: null,
    );

    /// Three recent posts, then two kept back from earlier in the cycle.
    YTimeline withReserve() => (
      posts: [chatter(0), chatter(1), chatter(2), landmark(0), landmark(1)],
      reserveFrom: 3,
    );

    Future<void> pumpFeed(
      WidgetTester tester,
      YTimeline feed, {
      double width = 400,
      Locale locale = const Locale('en'),
    }) async {
      tester.view
        ..physicalSize = Size(width, 1600)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // On the MaterialApp itself, not a Localizations.override around a
          // launcher: an override does not reach a route pushed out of it.
          locale: locale,
          home: Scaffold(body: YFeedList(feed: feed)),
        ),
      );
      await tester.pumpAndSettle();
    }

    /// The heading, in whichever language is on screen.
    Finder heading(WidgetTester tester) => find.text(
      AppLocalizations.of(
        tester.element(find.byType(YFeedList)),
      ).yEarlierHeading,
    );

    testWidgets('appears exactly once, at the seam', (tester) async {
      await pumpFeed(tester, withReserve());
      expect(heading(tester), findsOneWidget);
      // Between the last recent post and the first one kept back: an
      // unmarked jump from 2030 to 2028 is what the manager read as a bug.
      expect(
        tester.getTopLeft(heading(tester)).dy,
        greaterThan(tester.getTopLeft(find.text('Recent2')).dy),
      );
      expect(
        tester.getTopLeft(heading(tester)).dy,
        lessThan(tester.getTopLeft(find.text('Older0')).dy),
      );
      // And every post is still there: the extra row displaces nothing.
      for (final name in [
        'Recent0',
        'Recent1',
        'Recent2',
        'Older0',
        'Older1',
      ]) {
        expect(find.text(name), findsOneWidget, reason: name);
      }
    });

    testWidgets('is absent when nothing was kept back', (tester) async {
      await pumpFeed(tester, (
        posts: [chatter(0), chatter(1)],
        reserveFrom: null,
      ));
      expect(
        heading(tester),
        findsNothing,
        reason: 'a feed with no reserve shows no heading, not an empty one',
      );
      expect(find.byType(YPostTile), findsNWidgets(2));
    });

    for (final width in <double>[400, 360]) {
      for (final locale in [const Locale('en'), const Locale('cs')]) {
        testWidgets(
          'fits whole at ${width.toInt()}px in ${locale.languageCode}',
          (tester) async {
            await pumpFeed(
              tester,
              withReserve(),
              width: width,
              locale: locale,
            );
            expectWhole(heading(tester), 'the earlier-news heading');
            expect(tester.takeException(), isNull);
            expectNothingCut(tester);
          },
        );
      }
    }
  });
}
