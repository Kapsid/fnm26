import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/finances_screen.dart';
import 'package:fnm/features/hub/board_objectives_screen.dart';
import 'package:fnm/features/hub/hub_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

/// The hub's board strip as two tiles: the board's ring and mood, through to
/// the objectives, and the free funds, through to the finances.
void main() {
  /// The tiles alone, the board at [value] and 4.7M free, [width] wide.
  Future<({List<String> boardTaps, List<String> fundsTaps})> pumpTiles(
    WidgetTester tester, {
    required int? value,
    double width = 358,
    double textScale = 1,
    Locale locale = const Locale('en'),
    bool stacked = false,
  }) async {
    final taps = (boardTaps: <String>[], fundsTaps: <String>[]);
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    // A fresh scope each time: a ProviderScope keeps its first overrides.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          satisfactionProvider.overrideWith(
            (ref, id) => value == null
                ? Future<int>.delayed(const Duration(days: 1), () => 0)
                : Future.value(value),
          ),
          federationFundsProvider.overrideWith(
            (ref, id) async =>
                (balance: 5200000, wages: 500000, free: 4700000),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.theme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(
                size: const Size(390, 844),
                textScaler: TextScaler.linear(textScale),
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: width,
                  child: HubBoardTiles(
                    careerId: 1,
                    stacked: stacked,
                    onBoard: () => taps.boardTaps.add('board'),
                    onFunds: () => taps.fundsTaps.add('funds'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    return taps;
  }

  Color moodColor(WidgetTester tester, String word) =>
      tester.widget<Text>(find.text(word)).style!.color!;

  testWidgets('both tiles, labels and the amount are there', (tester) async {
    await pumpTiles(tester, value: 57);
    expect(find.byKey(HubBoardTiles.boardTileKey), findsOneWidget);
    expect(find.byKey(HubBoardTiles.fundsTileKey), findsOneWidget);
    expect(find.text(enL.hubBoard), findsOneWidget);
    expect(find.text(enL.hubFunds), findsOneWidget);
    expect(find.text('57'), findsOneWidget, reason: 'the figure in the ring');
    expect(find.text(enL.hubBoardPleased), findsOneWidget);
    expect(find.text('€4.7M'), findsOneWidget);
    // No separate percentage and no objectives button any more.
    expect(find.text('57%'), findsNothing);
    expect(find.text(enL.boardObjectivesTitle), findsNothing);
    // Equal tiles, side by side.
    final a = tester.getRect(find.byKey(HubBoardTiles.boardTileKey));
    final b = tester.getRect(find.byKey(HubBoardTiles.fundsTileKey));
    expect(a.width, closeTo(b.width, 0.5));
    expect(a.height, b.height);
    expect(b.left - a.right, HubBoardTiles.gap);
    expect(a.top, b.top);
  });

  testWidgets('each tile answers its own tap', (tester) async {
    final taps = await pumpTiles(tester, value: 57);
    await tester.tap(find.byKey(HubBoardTiles.boardTileKey));
    await tester.tap(find.byKey(HubBoardTiles.fundsTileKey));
    await tester.tap(find.byKey(HubBoardTiles.fundsTileKey));
    expect(taps.boardTaps, hasLength(1));
    expect(taps.fundsTaps, hasLength(2));
  });

  testWidgets('each mood has its colour', (tester) async {
    for (final (value, word, color) in [
      (80, enL.hubBoardDelighted, AppColors.positive),
      (60, enL.hubBoardPleased, AppColors.positive),
      (45, enL.hubBoardExpectingMore, AppColors.primary),
      (30, enL.hubBoardConcerned, AppColors.warning),
      (10, enL.hubBoardJobAtRisk, AppColors.error),
    ]) {
      await pumpTiles(tester, value: value);
      expect(moodColor(tester, word), color, reason: word);
      expect(hubBoardMoodColor(value), color, reason: word);
      // Only a job at risk turns the tile's edge red.
      final ink = tester.widget<Ink>(
        find.descendant(
          of: find.byKey(HubBoardTiles.boardTileKey),
          matching: find.byType(Ink),
        ),
      );
      final border = (ink.decoration! as BoxDecoration).border! as Border;
      expect(
        border.top.color,
        value < 25
            ? AppColors.error.withValues(alpha: 0.6)
            : AppColors.outlineVariant,
        reason: word,
      );
    }
  });

  testWidgets('one button each to a screen reader', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpTiles(tester, value: 57);
    expect(
      tester.getSemantics(find.byKey(HubBoardTiles.boardTileKey)),
      matchesSemantics(
        label: 'Board: Pleased, 57%',
        isButton: true,
        hasTapAction: true,
      ),
    );
    expect(
      tester.getSemantics(find.byKey(HubBoardTiles.fundsTileKey)),
      matchesSemantics(
        label: '${enL.federationFreeToSpend}: €4.7M',
        isButton: true,
        hasTapAction: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('long mood words wrap at the largest text size, never overflow', (
    tester,
  ) async {
    // The narrowest phone and the longest verdicts among the languages.
    for (final code in ['en', 'cs', 'de', 'fi', 'el', 'hu', 'tr', 'fil']) {
      final l = lookupAppLocalizations(Locale(code));
      for (final stacked in [false, true]) {
        await pumpTiles(
          tester,
          value: 10,
          width: stacked ? 200 : 288,
          textScale: kMaxAppTextScale,
          locale: Locale(code),
          stacked: stacked,
        );
        expect(tester.takeException(), isNull, reason: '$code $stacked');
        final word = find.text(l.hubBoardJobAtRisk);
        expect(word, findsOneWidget);
        // Whole: nothing ellipsised, clipped or scaled.
        final text = tester.widget<Text>(word);
        expect(text.maxLines, isNull);
        expect(text.overflow, isNull);
        expect(find.byType(FittedBox), findsNothing);
        final tile = tester.getRect(find.byKey(HubBoardTiles.boardTileKey));
        expect(
          tile.contains(tester.getRect(word).bottomRight - const Offset(1, 1)),
          isTrue,
          reason: '$code: the word stays inside its tile',
        );
      }
    }
  });

  testWidgets('phone hub: Board opens the objectives, Funds the finances', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, '${Routes.hub}?careerId=${save.careerId}');
    expect(find.byType(HubBoardTiles), findsOneWidget);
    expect(find.text(enL.boardObjectivesTitle), findsNothing);
    await tester.tap(find.byKey(HubBoardTiles.boardTileKey));
    await settle(tester);
    expect(find.byType(BoardObjectivesScreen), findsOneWidget);

    await pumpRoute(tester, save, '${Routes.hub}?careerId=${save.careerId}');
    await tester.tap(find.byKey(HubBoardTiles.fundsTileKey));
    await settle(tester);
    expect(find.byType(FinancesScreen), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('tablet hub: the board panel stacks the same two tiles', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.hub}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(HubScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(HubBoardTiles), findsOneWidget);
    final board = tester.getRect(find.byKey(HubBoardTiles.boardTileKey));
    final funds = tester.getRect(find.byKey(HubBoardTiles.fundsTileKey));
    expect(funds.top, greaterThan(board.bottom), reason: 'stacked');
    await tester.tap(find.byKey(HubBoardTiles.boardTileKey));
    await settle(tester);
    expect(find.byType(BoardObjectivesScreen), findsOneWidget);

    await pumpRoute(
      tester,
      save,
      '${Routes.hub}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    await tester.tap(find.byKey(HubBoardTiles.fundsTileKey));
    await settle(tester);
    expect(find.byType(FinancesScreen), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a competition tile wears the hub card edge', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.tournaments}?careerId=${save.careerId}',
    );
    final cards = tester.widgetList<AppCard>(find.byType(AppCard)).toList();
    expect(cards, isNotEmpty);
    // A non-live tile leaves AppCard's default edge in place.
    expect(cards.where((c) => c.border == null), isNotEmpty);
    await tester.pumpWidget(const SizedBox());
  });
}
