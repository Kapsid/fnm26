import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/awards/poty_history.dart';
import 'package:fnm/features/awards/poty_history_providers.dart';
import 'package:fnm/features/awards/poty_history_screen.dart';
import 'package:fnm/features/career/careers_screen.dart';
import 'package:fnm/features/nations/career_nations_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../helpers/expect_whole.dart';
import '../helpers/fake_poty_history.dart';
import '../helpers/seeded_save.dart' show realNations;

Map<int, Nation> get _nationsById => {for (final n in realNations) n.id: n};

void main() {
  Future<List<String>> pump(
    WidgetTester tester, {
    required String initial,
    PotyHistory? history,
    double width = 400,
    String locale = 'en',
    double textScale = 1,
  }) async {
    tester.view
      ..physicalSize = Size(width, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final visited = <String>[];
    final router = GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(
          path: Routes.careers,
          builder: (_, _) => const CareersScreen(careerId: 1),
        ),
        GoRoute(
          path: Routes.potyHistory,
          builder: (_, state) {
            visited.add(state.uri.toString());
            return const PotyHistoryScreen(careerId: 1);
          },
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          potyHistoryProvider(1).overrideWith((ref) async => history),
          careerNationsByIdProvider(
            1,
          ).overrideWith((ref) async => _nationsById),
        ],
        child: MaterialApp.router(
          locale: Locale(locale),
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return visited;
  }

  AppLocalizations strings(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(Scaffold).first));

  testWidgets('the block shows on My Career and opens the history', (
    tester,
  ) async {
    final h = fakePotyHistory();
    final visited = await pump(
      tester,
      initial: '${Routes.careers}?careerId=1',
      history: h,
    );
    final l = strings(tester);
    final block = find.byKey(PotyHistoryBlock.blockKey);
    expect(block, findsOneWidget);
    // The latest winner and the most decorated man.
    expect(
      find.descendant(
        of: block,
        matching: find.textContaining('${l.potyHistoryLatest} · 2030'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: block,
        matching: find.textContaining(l.potyHistoryWins(2)),
      ),
      findsOneWidget,
    );

    await tester.ensureVisible(block);
    await tester.tap(block);
    await tester.pumpAndSettle();
    expect(visited, ['${Routes.potyHistory}?careerId=1']);
    expect(find.byType(PotyHistoryScreen), findsOneWidget);
    expect(find.byKey(const Key('potyHistory.year.2030')), findsOneWidget);
    expect(find.byKey(const Key('potyHistory.ownSummary')), findsOneWidget);
    expect(
      find.text(
        l.potyHistoryYourNation(
          l.potyHistoryWinners(h.ownWinners),
          l.potyHistoryTopFive(h.ownFinishes.length),
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('before any vote: the block says what it is, the screen why '
      'it is empty', (tester) async {
    await pump(tester, initial: '${Routes.careers}?careerId=1');
    final l = strings(tester);
    expect(find.text(l.potyHistorySubtitle), findsOneWidget);

    await tester.ensureVisible(find.byKey(PotyHistoryBlock.blockKey));
    await tester.tap(find.byKey(PotyHistoryBlock.blockKey));
    await tester.pumpAndSettle();
    expect(find.byKey(PotyHistoryScreen.emptyKey), findsOneWidget);
    expect(find.text(l.potyHistoryEmpty), findsOneWidget);
  });

  group('fits 360 at text scale 1.4', () {
    for (final locale in ['de', 'fi', 'hu', 'el', 'pt', 'cs']) {
      testWidgets('history and block in $locale', (tester) async {
        final h = fakePotyHistory();
        await pump(
          tester,
          initial: '${Routes.potyHistory}?careerId=1',
          history: h,
          width: 360,
          locale: locale,
          textScale: 1.4,
        );
        expect(tester.takeException(), isNull);
        expectNothingCut(tester, 'the history in $locale');
        // Scroll the whole list, checking each part as it is built.
        final list = find.byType(Scrollable).first;
        for (var i = 0; i < 12; i++) {
          await tester.drag(list, const Offset(0, -500));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expectNothingCut(tester, 'the history in $locale');
        }

        await pump(
          tester,
          initial: '${Routes.careers}?careerId=1',
          history: h,
          width: 360,
          locale: locale,
          textScale: 1.4,
        );
        await tester.scrollUntilVisible(
          find.byKey(PotyHistoryBlock.blockKey),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        // The block only: the bottom bar's labels are not this screen's.
        for (final e
            in find
                .descendant(
                  of: find.byKey(PotyHistoryBlock.blockKey),
                  matching: find.byType(Text),
                )
                .evaluate()) {
          final paragraph = e.renderObject;
          if (paragraph is! RenderParagraph) continue;
          expect(
            paragraph.didExceedMaxLines,
            isFalse,
            reason: '"${(e.widget as Text).data}" is cut in $locale',
          );
        }
      });
    }
  });
}
