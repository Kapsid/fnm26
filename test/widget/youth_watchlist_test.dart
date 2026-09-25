import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/features/squad/youth_providers.dart';
import 'package:fnm/features/squad/youth_screen.dart';
import 'package:fnm/features/squad/youth_watch_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';
import '../helpers/fixtures.dart';

/// The shortlist: the boys a manager marked, and what has become of them.
///
/// Two things are under test. One, that MOVEMENT is on screen — a watchlist
/// that only shows what a boy is now is a second squad list. Two, that a boy
/// who is gone from a DERIVED pyramid is still accounted for by name instead of
/// silently disappearing, which is the failure the pool being derived invites.
const _widths = [320.0, 360.0, 400.0];
const _locales = ['en', 'cs'];

void main() {
  YouthMark mark({
    required int id,
    required int rating,
    required int age,
    int year = 1,
    String name = 'Novák',
  }) => (playerId: id, name: name, rating: rating, age: age, year: year);

  Player lad({
    required int id,
    required int rating,
    required int age,
    String name = 'Novák',
  }) => player(
    id: id,
    nationId: 1,
    name: name,
    age: age,
    attributes: flatAttributes(rating),
  );

  WatchedBoy following(YouthMark m, Player now, {int caps = 0}) => (
    mark: m,
    status: WatchedStatus.following,
    player: now,
    caps: caps,
    stars: 4,
    certain: false,
  );

  WatchedBoy departed(YouthMark m, WatchedStatus status) => (
    mark: m,
    status: status,
    player: null,
    caps: 0,
    stars: 0,
    certain: false,
  );

  Future<void> pump(
    WidgetTester tester,
    List<WatchedBoy> boys, {
    double width = 400,
    String locale = 'en',
    Map<YouthLevel, List<Prospect>> byLevel = const {},
  }) async {
    await tester.binding.setSurfaceSize(Size(width, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          youthPyramidProvider(1).overrideWith(
            (ref) async => (
              byLevel: byLevel,
              releasedByLevel: const <YouthLevel, List<String>>{},
              years: 4,
            ),
          ),
          youthMarksProvider(1).overrideWith(
            (ref) async => [for (final b in boys) b.mark],
          ),
          youthShortlistProvider(1).overrideWith((ref) async => boys),
        ],
        child: MaterialApp(
          locale: Locale(locale),
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const YouthScreen(careerId: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  AppLocalizations copy(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(YouthWatchTab)));

  testWidgets('an empty shortlist says how to fill it', (tester) async {
    await pump(tester, const []);
    expect(find.text(copy(tester).youthWatchEmpty), findsOneWidget);
  });

  testWidgets('a marked boy is shown with his movement, not just his rating', (
    tester,
  ) async {
    await pump(tester, [
      following(
        mark(id: 1, rating: 48, age: 14),
        lad(id: 1, rating: 55, age: 16),
      ),
    ]);
    final l = copy(tester);

    expect(find.text('Novák'), findsOneWidget);
    // What he is now, what he was when he was marked, and the move between.
    expect(find.text('55'), findsOneWidget);
    expect(find.text(l.youthWatchMarked(48, 14)), findsOneWidget);
    expect(find.text('+7'), findsOneWidget);
  });

  testWidgets('a boy who has gone backwards says so', (tester) async {
    await pump(tester, [
      following(
        mark(id: 1, rating: 55, age: 17),
        lad(id: 1, rating: 53, age: 18),
      ),
    ]);
    expect(find.text('-2'), findsOneWidget);
  });

  testWidgets('a boy who left the pyramid is accounted for, not vanished', (
    tester,
  ) async {
    await pump(tester, [
      departed(
        mark(id: 1, rating: 44, age: 13, name: 'Released Lad'),
        WatchedStatus.released,
      ),
      departed(
        mark(id: 2, rating: 62, age: 20, name: 'Grown Lad'),
        WatchedStatus.gone,
      ),
    ]);
    final l = copy(tester);

    // Named off the MARK, because a released boy is not in the derived pool to
    // be looked up.
    expect(find.text('Released Lad'), findsOneWidget);
    expect(find.text('Grown Lad'), findsOneWidget);
    expect(find.text(l.youthWatchReleased), findsOneWidget);
    expect(find.text(l.youthWatchGone), findsOneWidget);
  });

  testWidgets('a boy who came through is followed into the senior pool', (
    tester,
  ) async {
    await pump(tester, [
      (
        mark: mark(id: 1, rating: 50, age: 17, name: 'Novák'),
        status: WatchedStatus.senior,
        player: lad(id: 1, rating: 71, age: 22, name: 'Novák'),
        caps: 8,
        stars: 5,
        certain: true,
      ),
    ]);
    expect(find.text(copy(tester).youthWatchSenior), findsOneWidget);
    expect(find.text('71'), findsOneWidget);
    expect(find.text('+21'), findsOneWidget);
  });

  group('the shortlist copy fits a phone', () {
    for (final width in _widths) {
      for (final locale in _locales) {
        testWidgets('a full list at $width in $locale', (tester) async {
          await pump(
            tester,
            [
              following(
                mark(id: 1, rating: 48, age: 14),
                lad(id: 1, rating: 55, age: 16),
                caps: 3,
              ),
              (
                mark: mark(id: 2, rating: 50, age: 17, name: 'Dvořák'),
                status: WatchedStatus.senior,
                player: lad(id: 2, rating: 71, age: 22, name: 'Dvořák'),
                caps: 8,
                stars: 5,
                certain: true,
              ),
              departed(
                mark(id: 3, rating: 44, age: 13, name: 'Pokorný'),
                WatchedStatus.released,
              ),
              departed(
                mark(id: 4, rating: 62, age: 20, name: 'Urban'),
                WatchedStatus.gone,
              ),
            ],
            width: width,
            locale: locale,
          );
          expectLocale(tester, find.byType(YouthWatchTab), locale);
          final l = copy(tester);

          // Each new string is asserted ON SCREEN before it is measured:
          // expectWhole reports an empty finder, but a typo in a fixture would
          // otherwise be a silent pass.
          for (final text in [
            l.youthWatchMarked(48, 14),
            l.youthWatchSenior,
            l.youthWatchReleased,
            l.youthWatchGone,
          ]) {
            final finder = find.text(text);
            expect(finder, findsOneWidget, reason: '"$text" is not on screen');
            expectWhole(finder, '"$text"');
          }
          expectNothingCut(tester, 'the youth shortlist at $width in $locale');
        });

        testWidgets('the empty state at $width in $locale', (tester) async {
          await pump(tester, const [], width: width, locale: locale);
          expectLocale(tester, find.byType(YouthWatchTab), locale);
          final finder = find.text(copy(tester).youthWatchEmpty);
          expect(finder, findsOneWidget);
          expectWhole(finder, 'the empty shortlist copy');
          expectNoBrokenWord(finder, 'the empty shortlist copy');
        });
      }
    }
  });

  // The bookmark takes 34 points out of every prospect row, and the pyramid's
  // own rows were never width-tested: a button added to a tight row is exactly
  // how the age line beside a name gets cut.
  group('the pyramid rows still fit with a bookmark on them', () {
    for (final width in _widths) {
      for (final locale in _locales) {
        testWidgets('a U-19 row at $width in $locale', (tester) async {
          await pump(
            tester,
            const [],
            width: width,
            locale: locale,
            byLevel: {
              YouthLevel.u19: [
                (
                  player: lad(id: 9, rating: 61, age: 18, name: 'Dvořák'),
                  yearGain: 4,
                  caps: 3,
                  stars: 4,
                  certain: true,
                ),
              ],
            },
          );
          // Driven through the controller rather than by tapping the tab: at
          // 320 the U-19 tab has scrolled off the right of a six-tab strip, and
          // a tap that lands on nothing is a silently empty screen.
          DefaultTabController.of(
            tester.element(find.byType(TabBarView)),
          ).animateTo(YouthLevel.u19.index + 1);
          await tester.pumpAndSettle();
          final l = AppLocalizations.of(tester.element(find.text('Dvořák')));

          for (final text in [l.u21AgeCaps(18, 3), l.u21Breakout(4)]) {
            final finder = find.text(text);
            expect(finder, findsOneWidget, reason: '"$text" is not on screen');
            expectWhole(finder, '"$text"');
          }
          expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);
        });
      }
    }
  });
}
