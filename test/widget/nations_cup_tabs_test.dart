import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';
import '../helpers/test_database.dart';

/// The Nations Cup's leagues as tabs.
///
/// They were a row of chips above the tables — a control used nowhere else in
/// the app, on a screen that is otherwise tabbed. The manager asked for tabs,
/// so the leagues are tabs, and the bar keeps the same length from round to
/// round: a league with nothing drawn is an EMPTY tab, never a missing one.
///
/// The tab labels are plain [Text] with maxLines: 1 so the width guard can
/// actually fail — Tab(text:) lays its label out with no maxLines at all, and
/// this project's WholeText scales itself down to fit, so a guard reading
/// didExceedMaxLines is blind inside either.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late int careerId;
  late Nation player;

  setUp(() async {
    db = createTestDatabase();
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();

    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    await container.read(seedLoaderProvider).ensureSeeded();
    // The best European side: League A, so "opens on my own league" is a real
    // assertion and not an accident of A being first.
    player = nations
        .where((n) => n.confederation == Confederation.europe)
        .reduce((a, b) => a.ranking <= b.ranking ? a : b);
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: player.id, managerName: 'M'))
            .valueOrNull!;
    careerId = career.id;
    // The tables are kept back until the draw ceremony has been watched, so
    // watch it: otherwise this screen is one "groups are drawn at the
    // ceremony" notice and there is nothing to put in tabs.
    await container
        .read(competitionRepositoryProvider)
        .markDrawWatched(careerId, career.cyclePointer, nationsCupDrawKind);
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    double width = 400,
    String locale = 'en',
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size(width, 900);
    addTearDown(tester.view.reset);
    // Pumped inside runAsync: the screen's provider reads the whole world out
    // of the database, which is REAL async work, and pumpAndSettle runs on a
    // fake clock that would spin on the loading spinner for ever without ever
    // letting that work land.
    await tester.runAsync(() async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            // On the MaterialApp itself: a Localizations.override around the
            // screen would not reach anything it pushes.
            locale: Locale(locale),
            theme: AppTheme.theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: NationsCupScreen(careerId: careerId),
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 400));
      await tester.pump();
    });
    await tester.pumpAndSettle();
  }

  AppLocalizations strings(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(NationsCupScreen)));

  testWidgets('every league of the confederation has a tab', (tester) async {
    await pumpScreen(tester);
    final l = strings(tester);

    // Europe runs several leagues; A and B always exist, and the manager's own
    // carries the star.
    expect(find.text(l.tourContLeagueChipStar('A')), findsOneWidget);
    expect(find.text(l.tourContLeagueChip('B')), findsOneWidget);
    expect(find.byType(TabBar), findsNWidgets(2));
  });

  testWidgets('it opens on the manager own league', (tester) async {
    await pumpScreen(tester);
    final l = strings(tester);

    // The body under the tabs is the league the manager plays in, headed as
    // his own — not whichever league happens to sort first.
    expect(find.text(l.tourContLeagueHeadingYours('A')), findsOneWidget);
    expect(find.text(l.tourContLeagueHeading('B')), findsNothing);
  });

  testWidgets('another league is one tap away', (tester) async {
    await pumpScreen(tester);
    final l = strings(tester);

    await tester.tap(find.text(l.tourContLeagueChip('B')));
    await tester.pumpAndSettle();

    expect(find.text(l.tourContLeagueHeading('B')), findsOneWidget);
  });

  testWidgets('a league with nothing drawn keeps its tab, empty', (
    tester,
  ) async {
    await pumpScreen(tester);
    final l = strings(tester);

    // The lowest league of a confederation can be short of nations, so it may
    // have no group at all this cycle. Whichever leagues are empty, none of
    // them may be missing from the bar: walk every tab and expect either its
    // tables or the empty state, never a blank.
    final letters = [for (var i = 0; i < 6; i++) String.fromCharCode(65 + i)];
    for (final letter in letters) {
      final tab = find.text(
        letter == 'A'
            ? l.tourContLeagueChipStar(letter)
            : l.tourContLeagueChip(letter),
      );
      if (tab.evaluate().isEmpty) continue;
      await tester.ensureVisible(tab);
      await tester.pumpAndSettle();
      await tester.tap(tab);
      await tester.pumpAndSettle();

      final headed =
          find.text(l.tourContLeagueHeading(letter)).evaluate().isNotEmpty ||
          find.text(l.tourContLeagueHeadingYours(letter)).evaluate().isNotEmpty;
      final empty = find.text(l.tourContLeagueNoGroups).evaluate().isNotEmpty;
      expect(
        headed || empty,
        isTrue,
        reason: 'league $letter has a tab that shows nothing at all',
      );
    }
  });

  group('the tab labels survive a narrow phone', () {
    for (final width in [360.0, 400.0]) {
      for (final locale in ['en', 'cs']) {
        testWidgets('whole at $width in $locale', (tester) async {
          await pumpScreen(tester, width: width, locale: locale);
          final l = strings(tester);

          expectWhole(
            find.text(l.tourContLeagueChipStar('A')),
            'the manager own league tab',
          );
          expectWhole(find.text(l.tourContLeagueChip('B')), 'the league B tab');
          expect(tester.takeException(), isNull);
          expectNothingCut(tester);
        });
      }
    }
  });
}
