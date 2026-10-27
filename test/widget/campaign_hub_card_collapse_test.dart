import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/features/campaign/campaign_brief_sheet.dart';
import 'package:fnm/features/campaign/campaign_hub_card.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/campaign/campaigns_screen.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/seeded_save.dart';

/// The hub campaign card folds away to one row; the choice is remembered.
void main() {
  CampaignProgress progress(CampaignDef def) =>
      def.goal == CampaignGoal.titleTreble
      // Finish the Legacy, between its titles: the European Championship won,
      // the Nations Cup at its Finals Four, the World Championship to come.
      ? (
          def: def,
          settled: false,
          stars: 0,
          reached: 1,
          myPosition: null,
          rivalPosition: null,
          goalDifferenceGap: null,
          ordinal: 7,
          rivalWins: 0,
          rivalMatchesPlayed: 0,
          rivalsBeaten: const <int>{},
          cycleRuns: const [(ordinal: 7, over: true)],
          worldRuns: const [(ordinal: 0, over: false)],
          nationsCupRun: (ordinal: 5, over: false),
        )
      : (
          def: def,
          settled: false,
          stars: 0,
          reached: 0,
          myPosition: 2,
          rivalPosition: def.rivalNationId == null ? null : 4,
          goalDifferenceGap: 3,
          ordinal: 2,
          rivalWins: 1,
          rivalMatchesPlayed: 3,
          rivalsBeaten: const <int>{},
          cycleRuns: const [
            (ordinal: 2, over: true),
            (ordinal: 0, over: false),
          ],
          worldRuns: def.goal == CampaignGoal.qualifyWorldThenTitles
              ? const [(ordinal: 3, over: true), (ordinal: 0, over: false)]
              : const [],
          nationsCupRun: null,
        );

  Future<void> pumpCard(
    WidgetTester tester,
    CampaignDef def, {
    Size size = const Size(360, 800),
    Locale locale = const Locale('en'),
    Key? key,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        key: key,
        overrides: [
          campaignProgressProvider(
            1,
          ).overrideWith((ref) async => progress(def)),
          for (final n in realNations)
            nationByIdProvider(n.id).overrideWith((ref) async => n),
        ],
        child: MaterialApp(
          theme: AppTheme.theme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(child: CampaignHubCard(careerId: 1)),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  testWidgets('collapsed by default: title and summary, no goal lines', (
    tester,
  ) async {
    await pumpCard(tester, Campaigns.grudge);
    expect(find.byKey(CampaignHubCard.summaryKey), findsOneWidget);
    expect(find.byKey(CampaignHubCard.qualifyingKey), findsNothing);
    expect(find.byKey(CampaignHubCard.rivalKey), findsNothing);
  });

  testWidgets('tap expands, persists, and survives a rebuild', (tester) async {
    await pumpCard(tester, Campaigns.grudge);
    await tester.tap(find.byKey(CampaignHubCard.headerKey));
    await tester.pumpAndSettle();
    expect(find.byKey(CampaignHubCard.qualifyingKey), findsOneWidget);
    expect(find.byKey(CampaignHubCard.rivalKey), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('campaign_card_open_v1:grudge'), isTrue);
    await pumpCard(tester, Campaigns.grudge, key: UniqueKey());
    await tester.pumpAndSettle();
    expect(find.byKey(CampaignHubCard.qualifyingKey), findsOneWidget);
    await tester.tap(find.byKey(CampaignHubCard.headerKey));
    await tester.pumpAndSettle();
    expect(find.byKey(CampaignHubCard.qualifyingKey), findsNothing);
  });

  testWidgets('Guineas expanded lists rivals and cup cycles', (tester) async {
    SharedPreferences.setMockInitialValues({
      'campaign_card_open_v1:${Campaigns.guineas.id}': true,
    });
    await pumpCard(tester, Campaigns.guineas);
    await tester.pumpAndSettle();
    expect(find.byKey(CampaignHubCard.cupCycleKey(0)), findsOneWidget);
    expect(find.byKey(CampaignHubCard.cupCycleKey(1)), findsOneWidget);
  });

  testWidgets('Young Finns expanded lists both championships per cycle', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'campaign_card_open_v1:${Campaigns.youngFinns.id}': true,
    });
    await pumpCard(tester, Campaigns.youngFinns);
    await tester.pumpAndSettle();
    for (var c = 0; c < 2; c++) {
      expect(find.byKey(CampaignHubCard.cupCycleKey(c)), findsOneWidget);
      expect(find.byKey(CampaignHubCard.worldCycleKey(c)), findsOneWidget);
    }
    expect(find.textContaining('World Championship'), findsWidgets);
    expect(find.textContaining('European Championship'), findsWidgets);
    // No rival lines: the goal has none.
    expect(find.byKey(CampaignHubCard.rivalKey), findsNothing);
  });

  testWidgets('Finish the Legacy: its three titles in order, the Nations Cup '
      'the one of the moment', (tester) async {
    await pumpCard(tester, Campaigns.legacy);
    await tester.pumpAndSettle();
    // Folded: the summary is the Nations Cup, the title still being played.
    expect(find.text('Nations Cup 2028: Finals Four'), findsOneWidget);
    await tester.tap(find.byKey(CampaignHubCard.headerKey));
    await tester.pumpAndSettle();
    final cup = tester.getTopLeft(find.byKey(CampaignHubCard.cupCycleKey(0)));
    final nc = tester.getTopLeft(find.byKey(CampaignHubCard.nationsCupKey));
    final world = tester.getTopLeft(
      find.byKey(CampaignHubCard.worldCycleKey(0)),
    );
    expect(cup.dy, lessThan(nc.dy));
    expect(nc.dy, lessThan(world.dy));
    expect(find.textContaining('European Championship 2028'), findsOneWidget);
    expect(find.text('World Championship 2030: To be decided'), findsOneWidget);
  });

  // b8 item 1: mid-run, the full brief with its stars is one tap away, and
  // nothing in it starts, resumes or throws the run away.
  testWidgets('the info button opens the full brief, read only, with the '
      'stars earned so far', (tester) async {
    await pumpCard(tester, Campaigns.legacy);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(CampaignHubCard.briefKey));
    await tester.pumpAndSettle();
    expect(find.byKey(CampaignBriefSheet.sheetKey), findsOneWidget);
    expect(find.text(enL.campaignLegacyIntro), findsOneWidget);
    expect(find.text(enL.campaignLegacyGoal), findsWidgets);
    for (final star in [
      enL.campaignStars1Legacy,
      enL.campaignStars2Legacy,
      enL.campaignStars3Legacy,
    ]) {
      expect(find.text(star), findsOneWidget);
    }
    // The run stands at one star: the first is ticked, the others are not.
    expect(find.text(enL.campaignStarsSoFar(1, 3)), findsOneWidget);
    expect(find.byKey(CampaignStarRules.earnedKey(0)), findsOneWidget);
    expect(find.byKey(CampaignStarRules.earnedKey(1)), findsNothing);
    expect(find.byKey(CampaignStarRules.earnedKey(2)), findsNothing);
    // Read only: none of the brief screen's run actions.
    expect(find.text(enL.campaignStart), findsNothing);
    expect(find.text(enL.campaignAbandon), findsNothing);
    expect(find.text(enL.campaignResume), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final size in const [Size(360, 740), Size(1194, 834)]) {
    for (final code in const ['de', 'fi', 'hu', 'el', 'pt', 'cs']) {
      testWidgets('the full brief fits ${size.width} $code at text 1.4', (
        tester,
      ) async {
        tester.platformDispatcher.textScaleFactorTestValue = 1.4;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await pumpCard(
          tester,
          Campaigns.grudge,
          size: size,
          locale: Locale(code),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.byKey(CampaignHubCard.briefKey));
        await tester.pumpAndSettle();
        expect(find.byKey(CampaignBriefSheet.sheetKey), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final w in [320.0, 360.0]) {
    for (final loc in const [Locale('en'), Locale('cs')]) {
      for (final def in [
        Campaigns.grudge,
        Campaigns.guineas,
        Campaigns.youngFinns,
        Campaigns.legacy,
      ]) {
        testWidgets('no overflow at $w ${loc.languageCode} ${def.id}', (
          tester,
        ) async {
          SharedPreferences.setMockInitialValues({
            'campaign_card_open_v1:${def.id}': true,
          });
          await pumpCard(tester, def, size: Size(w, 800), locale: loc);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.tap(find.byKey(CampaignHubCard.headerKey));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
