import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/services/match/opponent_scouting.dart';
import 'package:fnm/features/match/scout_report_providers.dart';
import 'package:fnm/features/match/scout_report_view.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/pump_app.dart';
import '../helpers/seeded_save.dart';

const _glimpse = ScoutReport(
  depth: ScoutDepth.glimpse,
  worldRank: 7,
  leaning: ScoutLeaning.attacking,
);

const _full = ScoutReport(
  depth: ScoutDepth.full,
  worldRank: 7,
  formation: Formation.f4141,
  strengths: [ScoutStrength.pressing, ScoutStrength.quickForwards],
  weakness: ScoutWeakness.spaceBehind,
  approach: ScoutApproach.sitDeep,
);

Future<void> _pump(
  WidgetTester tester,
  ScoutReport report, {
  Locale locale = const Locale('en'),
  double width = 360,
  double textScale = 1.4,
}) async {
  tester.view.physicalSize = Size(width, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    Scaffold(
      body: MediaQuery(
        data: MediaQueryData(
          size: Size(width, 900),
          textScaler: TextScaler.linear(textScale),
        ),
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: ScoutReportSection(careerId: 1, nationId: 2, seed: 0),
        ),
      ),
    ),
    locale: locale,
    overrides: [
      scoutReportProvider((
        careerId: 1,
        nationId: 2,
      )).overrideWith((ref) async => report),
    ],
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('no scout: the ranking, one vague line and the hiring hint', (
    tester,
  ) async {
    await _pump(tester, _glimpse);
    final l = lookupAppLocalizations(const Locale('en'));
    expect(find.text(l.hubWorldRank(7)), findsOneWidget);
    expect(find.text(l.matchDossierHowTheyPlay), findsOneWidget);
    expect(find.text(l.matchScoutLeaningAttacking), findsOneWidget);
    expect(find.byKey(ScoutReportSection.hireHintKey), findsOneWidget);
    expect(find.textContaining('4-1-4-1'), findsNothing);
  });

  testWidgets('an elite scout: shape, strengths, weakness and approach', (
    tester,
  ) async {
    await _pump(tester, _full);
    final l = lookupAppLocalizations(const Locale('en'));
    final text = tester
        .widget<Text>(find.byKey(ScoutReportSection.linesKey))
        .data!;
    expect(text, contains('4-1-4-1'));
    expect(text, contains(l.matchScoutStrengthPressing));
    expect(text, contains(l.matchScoutStrengthQuickForwards));
    expect(text, contains(l.matchScoutWeakSpaceBehind));
    expect(text, contains(l.matchScoutApproachSitDeep));
    expect(find.byKey(ScoutReportSection.hireHintKey), findsNothing);
    expect(find.text(l.hubWorldRank(7)), findsOneWidget);
  });

  // Wrap, never truncate: the longest report in every language, at the
  // largest text size, on a phone and on a tablet column.
  for (final code in AppLocalizations.supportedLocales.map(
    (l) => l.languageCode,
  )) {
    testWidgets('fits at text scale 1.4 on a phone ($code)', (tester) async {
      for (final report in [_glimpse, _full]) {
        await _pump(tester, report, locale: Locale(code));
        expect(tester.takeException(), isNull);
        final lines = tester.widget<Text>(
          find.byKey(ScoutReportSection.linesKey),
        );
        expect(lines.maxLines, isNull);
        expect(lines.overflow, isNull);
      }
      await _pump(tester, _full, locale: Locale(code), width: 1180);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('the real dossier tab shows the report, read off the save', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.4;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.matchPreview}?careerId=${save.careerId}',
    );
    await tester.tap(find.text(enL.matchDossierTitle));
    await settle(tester);
    expect(tester.takeException(), isNull);
    // A fresh save has hired nobody: the ranking, a vague line and the hint.
    expect(find.byKey(ScoutReportSection.rankingKey), findsOneWidget);
    expect(find.byKey(ScoutReportSection.linesKey), findsOneWidget);
    expect(find.byKey(ScoutReportSection.hireHintKey), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
