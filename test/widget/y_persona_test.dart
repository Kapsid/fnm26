import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_post_detail.dart';
import 'package:fnm/features/y/y_profile_sheet.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';

/// The accounts on Y are somebody.
///
/// The cast and its dispositions existed in [YCast] all along and never
/// reached the screen, so eight voices read as one personality wearing
/// different names. These are the three things that have to be true for a name
/// to be worth reading: it is on the post, it opens into somebody, and that
/// somebody is the same person in 2031 as he was in 2027.
void main() {
  /// A post by [name], said on [date].
  YPost post(
    String name, {
    required DateTime date,
    required String key,
    YVoice voice = YVoice.fan,
  }) => (
    voice: voice,
    // A player's handle is his name with the spaces taken out, exactly as
    // [YFeed] builds it.
    handle: '@${name.replaceAll(' ', '')}',
    displayName: name,
    template: YTemplate.winTight,
    variant: 0,
    args: const ['Spain', '2-1'],
    date: date,
    key: key,
    replyTo: null,
    mood: null,
  );

  /// A finder for text that may have been given invisible break
  /// opportunities, which is how a space-free handle is allowed to wrap
  /// instead of being cut.
  Finder wrappable(String text) => find.byWidgetPredicate(
    (w) => w is Text && w.data?.replaceAll('​', '') == text,
    description: 'text "$text"',
  );

  Future<void> pump(
    WidgetTester tester,
    Widget home, {
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
        // On the MaterialApp itself: a Localizations.override around a
        // launcher does not reach the route the tap pushes.
        locale: locale,
        home: home,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('a post says who wrote it', () {
    testWidgets('the name and the handle are both on the row', (tester) async {
      await pump(
        tester,
        Scaffold(
          body: YFeedList(
            feed: (
              posts: [
                post('LongSufferingLen', date: DateTime(2030, 6, 10), key: 'a'),
              ],
              reserveFrom: null,
            ),
          ),
        ),
      );
      expect(wrappable('LongSufferingLen'), findsOneWidget);
      expect(wrappable('@LongSufferingLen'), findsOneWidget);
    });

    testWidgets('tapping the name opens the account, not the post', (
      tester,
    ) async {
      await pump(
        tester,
        Scaffold(
          body: YFeedList(
            feed: (
              posts: [
                post('LongSufferingLen', date: DateTime(2030, 6, 10), key: 'a'),
              ],
              reserveFrom: null,
            ),
          ),
        ),
      );
      await tester.tap(wrappable('LongSufferingLen'));
      await tester.pumpAndSettle();
      expect(find.byType(YProfileSheet), findsOneWidget);
    });
  });

  group('the profile', () {
    /// Len said two things this save; somebody else said a third.
    final feed = [
      post('LongSufferingLen', date: DateTime(2027, 6, 10), key: 'a'),
      post('LongSufferingLen', date: DateTime(2031, 3, 2), key: 'b'),
      post('BadgeKisser', date: DateTime(2029, 9, 1), key: 'c'),
    ];

    Widget sheetFor(String name, List<YPost> posts) => YProfileSheet(
      persona: YFeed.personaOf(
        posts.firstWhere((p) => p.displayName == name),
      ),
      all: posts,
    );

    testWidgets('names the account and its disposition', (tester) async {
      await pump(tester, sheetFor('LongSufferingLen', feed));
      expect(wrappable('LongSufferingLen'), findsWidgets);
      expect(wrappable('@LongSufferingLen'), findsWidgets);

      final l = AppLocalizations.of(tester.element(find.byType(YProfileSheet)));
      final trait = YCast.traitFor('LongSufferingLen');
      expect(find.text(yTraitLine(l, trait)), findsOneWidget);
    });

    testWidgets("lists this account's posts and nobody else's", (
      tester,
    ) async {
      await pump(tester, sheetFor('LongSufferingLen', feed));
      // Two of Len's posts, newest first, and none of BadgeKisser's.
      expect(find.byType(YPostTile), findsNWidgets(2));
      expect(wrappable('BadgeKisser'), findsNothing);
      final first = tester.widget<YPostTile>(find.byType(YPostTile).first);
      expect(first.post.key, 'b', reason: 'newest first');
    });

    testWidgets('every trait has words behind it', (tester) async {
      await pump(tester, const Scaffold(body: SizedBox()));
      final l = AppLocalizations.of(tester.element(find.byType(Scaffold)));
      final lines = <String>{};
      for (final t in YTrait.values) {
        final line = yTraitLine(l, t);
        expect(line.trim(), isNotEmpty, reason: '$t has no disposition line');
        lines.add(line);
      }
      expect(
        lines,
        hasLength(YTrait.values.length),
        reason: 'two traits sharing a line is two accounts reading the same',
      );
    });
  });

  group('the same account reads the same across a career', () {
    // The point of the whole design: nothing about a persona is stored, so
    // the profile has to re-derive it. A stance IS stored nowhere for the same
    // reason — it is read off the run of results up to the post's own date —
    // and the trait, the part that never moves, comes from the name. If this
    // ever fails, an account the manager has known for four cycles has quietly
    // become somebody else.

    test('the trait is a pure function of the name', () {
      for (final name in YFeed.castNames) {
        expect(YCast.traitFor(name), YCast.traitFor(name));
      }
      // And it agrees with the cast the feed actually draws from, in every
      // nation and every save: that is what makes LongSufferingLen the same
      // man wherever he turns up.
      for (final nation in ['Norway', 'Peru', 'Japan']) {
        for (final seed in [1, 7, 9001]) {
          for (final voice in YVoice.values) {
            final cast = YCast.of(
              YFeed.castNames,
              nation: nation,
              seed: seed,
              voiceKey: voice.name,
            );
            for (final p in cast) {
              expect(
                p.trait,
                YCast.traitFor(p.displayName),
                reason: '${p.displayName} changed in $nation/$seed',
              );
            }
          }
        }
      }
    });

    testWidgets('read four years apart, the disposition is identical', (
      tester,
    ) async {
      // Early in the career: Len has said one thing.
      final early = [
        post('LongSufferingLen', date: DateTime(2027, 6, 10), key: 'a'),
      ];
      // Four years on: a career's worth of results behind him, and the run of
      // form that decides his TONE is completely different.
      final late = [
        ...early,
        for (var i = 0; i < 12; i++)
          post('LongSufferingLen', date: DateTime(2031, 1, 1 + i), key: 'l$i'),
        post('BadgeKisser', date: DateTime(2031, 5, 1), key: 'z'),
      ];

      await pump(
        tester,
        YProfileSheet(persona: YFeed.personaOf(early.first), all: early),
      );
      final l = AppLocalizations.of(tester.element(find.byType(YProfileSheet)));
      final then = yTraitLine(l, YFeed.personaOf(early.first).trait);
      expect(find.text(then), findsOneWidget);

      // A DIFFERENT account, opened from the same feed, must not be Len. The
      // other name is chosen for having a different trait, so the assertion
      // is about the screen rather than about a one-in-seven collision.
      final other = YFeed.castNames.firstWhere(
        (n) => YCast.traitFor(n) != YCast.traitFor('LongSufferingLen'),
      );
      final theirs = [
        ...late,
        post(other, date: DateTime(2031, 6, 1), key: 'o'),
      ];
      await pump(
        tester,
        YProfileSheet(persona: YFeed.personaOf(theirs.last), all: theirs),
      );
      expect(find.text(then), findsNothing);

      await pump(
        tester,
        YProfileSheet(persona: YFeed.personaOf(late[1]), all: late),
      );
      expect(
        find.text(then),
        findsOneWidget,
        reason: 'Len in 2031 is the same man as Len in 2027',
      );
    });
  });

  group('a name that opens somebody looks like it', () {
    /// The [WholeText] a row writes [name] in.
    Finder nameText(String name) => find.byWidgetPredicate(
      (w) => w is WholeText && w.text == name,
      description: 'the name "$name" on a post row',
    );

    final len = post('LongSufferingLen', date: DateTime(2030, 6, 10), key: 'a');

    testWidgets('in the feed it carries the interactive tint', (tester) async {
      await pump(
        tester,
        Scaffold(
          body: YFeedList(feed: (posts: [len], reserveFrom: null)),
        ),
      );
      expect(
        tester.widget<YPostTile>(find.byType(YPostTile)).onAccountTap,
        isNotNull,
      );
      expect(
        tester.widget<WholeText>(nameText('LongSufferingLen')).style?.color,
        AppColors.primary,
        reason:
            'a profile nobody can tell is there answers the complaint no '
            'better than no profile',
      );
    });

    testWidgets('on its own profile it does not', (tester) async {
      await pump(
        tester,
        YProfileSheet(persona: YFeed.personaOf(len), all: [len]),
      );
      // The header writes the name as a plain Text; the row below writes it
      // as a WholeText, and that is the one that must look inert.
      final style = tester
          .widget<WholeText>(nameText('LongSufferingLen'))
          .style;
      expect(
        style?.color,
        isNot(AppColors.primary),
        reason: 'an affordance that lies is worse than none',
      );
      expect(style?.color, AppTypography.labelMedium.color);
    });

    testWidgets('and tapping it cannot push the profile onto itself', (
      tester,
    ) async {
      await pump(
        tester,
        YProfileSheet(persona: YFeed.personaOf(len), all: [len]),
      );
      expect(
        tester.widget<YPostTile>(find.byType(YPostTile)).onAccountTap,
        isNull,
        reason: 'the account is already open; the name opens nothing',
      );
      await tester.tap(nameText('LongSufferingLen'));
      await tester.pumpAndSettle();
      // The tap still LANDS: it goes to the post, which is what the rest of
      // the row has always done. A self-push would have put a second profile
      // on top instead, and this page is opaque, so the one underneath would
      // be gone from the tree either way.
      expect(find.byType(YPostDetail), findsOneWidget);
      expect(find.byType(YProfileSheet), findsNothing);
    });
  });

  group('the feed row fits', () {
    // The row gained a tint and a padded tap target, so it is measured again
    // at both widths in both languages. Its name and handle are WholeTexts,
    // which no ellipsis guard can fail: they are only checked to be on
    // screen and unellipsised, and [shrinkOf] says why the amount they were
    // scaled by is not asserted on. The date beside them is a plain Text and
    // is held to the ordinary guard.
    final longestCast = YFeed.castNames.reduce(
      (a, b) => b.length > a.length ? b : a,
    );

    for (final width in <double>[400, 360]) {
      for (final locale in [const Locale('en'), const Locale('cs')]) {
        testWidgets(
          '$longestCast at ${width.toInt()}px in ${locale.languageCode}',
          (tester) async {
            final p = post(
              longestCast,
              date: DateTime(2031, 12, 30),
              key: 'a',
            );
            await pump(
              tester,
              Scaffold(body: YFeedList(feed: (posts: [p], reserveFrom: null))),
              width: width,
              locale: locale,
            );
            // Present and never ellipsised, whatever the face they are
            // drawn in; see [shrinkOf] for why the amount is recorded here
            // rather than asserted on.
            expect(shrinkOf(tester, wrappable(longestCast)), greaterThan(0));
            expect(
              shrinkOf(tester, wrappable('@$longestCast')),
              greaterThan(0),
            );
            // Written in the manager's language now (see AppDate): "30. pro
            // 31" in Czech against "30 Dec 31" in English, one character
            // longer, in the tightest row the feed has.
            expectWhole(
              find.textContaining(
                locale.languageCode == 'cs' ? '30. pro 31' : '30 Dec 31',
                findRichText: false,
              ),
              'the date',
            );
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  });

  group('the profile fits', () {
    /// The longest name the feed can actually hand a profile, and the longest
    /// a player can post under: "Nomenjanahary Randriamampionona" is the
    /// worst case the name pools can produce, and its handle is that again
    /// with the space taken out.
    final longestCast = YFeed.castNames.reduce(
      (a, b) => b.length > a.length ? b : a,
    );
    const longestPlayer = 'Nomenjanahary Randriamampionona';

    for (final name in <String>{longestCast, longestPlayer}) {
      for (final width in <double>[400, 360]) {
        for (final locale in [const Locale('en'), const Locale('cs')]) {
          testWidgets(
            '$name at ${width.toInt()}px in ${locale.languageCode}',
            (tester) async {
              final p = post(
                name,
                date: DateTime(2031, 12, 30),
                key: 'a',
                voice: name == longestPlayer ? YVoice.player : YVoice.fan,
              );
              await pump(
                tester,
                YProfileSheet(persona: YFeed.personaOf(p), all: [p]),
                width: width,
                locale: locale,
              );
              final l = AppLocalizations.of(
                tester.element(find.byType(YProfileSheet)),
              );
              expectWhole(wrappable(name), 'the display name');
              expectWhole(
                wrappable(
                  '@${name.replaceAll(' ', '')}',
                ),
                'the handle',
              );
              expectWhole(
                find.text(yTraitLine(l, YFeed.personaOf(p).trait)),
                'the disposition',
              );
              expectWhole(find.text(l.yProfilePosts), 'the posts heading');
              expect(tester.takeException(), isNull);
            },
          );
        }
      }
    }
  });
}
