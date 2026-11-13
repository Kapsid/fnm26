import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/press/press_sheet.dart';
import 'package:fnm/features/press/press_ticker.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../helpers/press_room.dart';
import '../helpers/seeded_save.dart';

/// The press room (1.1.2 redesign): variant F for the questions, variant C
/// for the end screen, as the bottom sheet the hub opens. Phone goldens for
/// a post-match conference, tall ones for a preview (where the sheet has
/// room for everything).
void main() {
  final l = AppLocalizationsEn();

  Future<void> pumpRoom(
    WidgetTester tester,
    PendingConference c, {
    required Size size,
    required bool played,
    bool tablet = false,
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final room = pressContextFor(
      l,
      conference: c,
      nationId: PressRoom.england,
      fixtures: played ? PressRoom.afterTwo : PressRoom.beforeAny,
      nations: PressRoom.nations,
      group: PressRoom.group,
      groupNames: PressRoom.groupNames,
      dateLabel: PressRoom.dateLabel,
    );
    await tester.pumpWidget(
      RepaintBoundary(
        key: kAppRoot,
        child: ProviderScope(
          overrides: [
            conferenceServiceProvider.overrideWithValue(FakePressService()),
          ],
          child: MaterialApp(
            theme: AppTheme.theme,
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              backgroundColor: AppColors.surface,
              // A phone shows the room as a bottom sheet; a tablet as the
              // 560-wide dialog `showAdaptiveSheet` opens.
              body: Align(
                alignment: tablet ? Alignment.center : Alignment.bottomCenter,
                child: Material(
                  color: AppColors.surfaceContainer,
                  borderRadius: tablet
                      ? const BorderRadius.all(Radius.circular(16))
                      : const BorderRadius.vertical(top: Radius.circular(28)),
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: tablet ? 560 : null,
                    child: PressSheet(
                      careerId: 1,
                      conference: c,
                      playerNames: const {9: 'Svoboda'},
                      opponentName: 'Senegal',
                      competitionName: 'World Championship',
                      rivalName: 'Netherlands',
                      ticker: room.ticker,
                      opener: room.opener,
                      next: room.next,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> answer(WidgetTester tester, int i) async {
    await tester.ensureVisible(find.byType(AnswerTile).at(i));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AnswerTile).at(i));
    await tester.pumpAndSettle();
  }

  testWidgets('phone: a post-match question', (tester) async {
    await pumpRoom(tester, PressRoom.postMatch, size: kPhoneSize, played: true);
    expect(find.byKey(PressTickerStrip.stripKey), findsOneWidget);
    await expectAppGolden('goldens/press_question_phone.png');
  });

  testWidgets('phone: the end of a post-match conference', (tester) async {
    await pumpRoom(tester, PressRoom.postMatch, size: kPhoneSize, played: true);
    // Promise the next win, then deflect.
    await answer(tester, 2);
    await answer(tester, 2);
    expect(find.byKey(PressPromiseCard.cardKey), findsOneWidget);
    await expectAppGolden('goldens/press_end_phone.png');
  });

  testWidgets('tall: a preview question', (tester) async {
    await pumpRoom(
      tester,
      PressRoom.preview,
      size: const Size(390, 2400),
      played: false,
    );
    await expectAppGolden('goldens/press_question_phone_tall.png');
  });

  testWidgets('tall: the end of a preview, a target on the record', (
    tester,
  ) async {
    await pumpRoom(
      tester,
      PressRoom.preview,
      size: const Size(390, 2400),
      played: false,
    );
    await answer(tester, 0);
    await answer(tester, 0);
    await answer(tester, 0);
    expect(find.byKey(PressPromiseCard.cardKey), findsOneWidget);
    await expectAppGolden('goldens/press_end_phone_tall.png');
  });

  testWidgets('tablet: a post-match question in the dialog', (tester) async {
    await pumpRoom(
      tester,
      PressRoom.postMatch,
      size: const Size(1194, 834),
      played: true,
      tablet: true,
    );
    await expectAppGolden('goldens/press_question_tablet.png');
  });

  testWidgets('tablet: the end screen in the dialog', (tester) async {
    await pumpRoom(
      tester,
      PressRoom.postMatch,
      size: const Size(1194, 834),
      played: true,
      tablet: true,
    );
    await answer(tester, 2);
    await answer(tester, 2);
    await expectAppGolden('goldens/press_end_tablet.png');
  });
}
