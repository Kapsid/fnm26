import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/nations/nation_preview.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart';

/// Reads an auto-disposed future while holding it, as a screen would.
Future<T> _hold<T>(ProviderContainer c, ProviderListenable<Future<T>> p) async {
  final sub = c.listen(p, (_, _) {});
  try {
    return await sub.read();
  } finally {
    sub.close();
  }
}

Future<void> _pumpPreview(
  WidgetTester tester,
  SeededSave save,
  Nation nation,
) async {
  tester.view.physicalSize = kTabletSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: save.container,
      child: MaterialApp(
        theme: AppTheme.theme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(width: 340, child: NationPreview(nation: nation)),
          ),
        ),
      ),
    ),
  );
  await settle(tester);
}

Finder _in(Key key, String text) =>
    find.descendant(of: find.byKey(key), matching: find.text(text));

void main() {
  testWidgets("every fact is the save's own on its first day "
      '(Review Focus 1)', (tester) async {
    final save = await seedSave(tester);
    final c = save.container;
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    // What the career really holds, read BEFORE the preview is drawn.
    late int budget;
    late List<ObjectiveOutcome> outcomes;
    late int saveOverall;
    await tester.runAsync(() async {
      budget =
          (await c.read(careerRepositoryProvider).byId(save.careerId))!.budget;
      outcomes = await _hold(
        c,
        cycleObjectiveOutcomesProvider(save.careerId).future,
      );
      saveOverall = squadOverall(
        await c
            .read(playerRepositoryProvider)
            .byNation(me.id, saveSeed: save.career.rngSeed),
      );
      await c.read(nationStrengthsProvider.future);
      await c.read(nationsProvider.future);
    });
    expect(budget, greaterThan(0), reason: 'the opening grant is stored');
    final world = outcomes.firstWhere((o) => o.tier == TournamentTier.world);
    final continental = outcomes.firstWhere(
      (o) => o.tier == TournamentTier.continental,
    );
    expect(openingObjectiveTargets(me, save.nations), (
      world: world.target,
      continental: continental.target,
    ));

    await _pumpPreview(tester, save, me);
    expect(tester.takeException(), isNull);
    expect(_in(NationPreview.budgetKey, formatEuros(budget)), findsOneWidget);
    expect(_in(NationPreview.rankKey, '#${me.ranking}'), findsOneWidget);
    // The seeded France is asked for different things at the two
    // tournaments, so each demand is on screen exactly once.
    expect(
      _in(
        NationPreview.briefKey,
        objectiveDemandText(enL, TournamentTier.world, world.target),
      ),
      findsOneWidget,
    );
    expect(
      _in(
        NationPreview.briefKey,
        objectiveDemandText(
          enL,
          TournamentTier.continental,
          continental.target,
          competition: continental.competition,
        ),
      ),
      findsOneWidget,
    );
    expect(_in(NationPreview.briefKey, enL.objectiveWorldCup), findsOneWidget);
    // The world's reading of the best eleven; the save's own pool also feels
    // club minutes, which move it by a point or two.
    final strength = c.read(nationStrengthsProvider).requireValue[me.id]!;
    expect((strength.overall - saveOverall).abs(), lessThanOrEqualTo(2));
    expect(
      _in(NationPreview.overallKey, '${strength.overall}'),
      findsOneWidget,
    );
    expect(
      _in(NationPreview.strengthKey, enL.nationsStrengthOf(strength.tier)),
      findsOneWidget,
    );
    // The best player by position, age and rating; never by a name the save
    // will not use.
    expect(
      _in(NationPreview.bestKey, '${strength.best.overall}'),
      findsOneWidget,
    );
    expect(
      _in(NationPreview.bestKey, enL.nationsStarAge(strength.best.age)),
      findsOneWidget,
    );
    expect(find.text(strength.best.name), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the strongest fifth wears five bars, the weakest one', (
    tester,
  ) async {
    final save = await seedSave(tester);
    late Map<int, NationStrength> all;
    await tester.runAsync(() async {
      all = await save.container.read(nationStrengthsProvider.future);
    });
    expect(all.length, save.nations.length, reason: 'every nation has players');
    final best = all.values.reduce((a, b) => a.overall >= b.overall ? a : b);
    final worst = all.values.reduce((a, b) => a.overall <= b.overall ? a : b);
    expect(best.tier, 5);
    expect(worst.tier, 1);
    for (var tier = 1; tier <= 5; tier++) {
      expect(
        all.values.where((s) => s.tier == tier),
        isNotEmpty,
        reason: 'no nation in tier $tier',
      );
    }
  });

  testWidgets('the meter lights as many bars as the tier', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Center(child: StrengthMeter(tier: 3))),
      ),
    );
    expect(tester.getSize(find.byType(StrengthMeter)), const Size(28, 10));
    expect(find.bySemanticsLabel('Strength 3 of 5'), findsOneWidget);
  });
}
