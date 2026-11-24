import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// Europe's qualifying, before its play-off paths are drawn: the card under
/// the tables lists the sides the Nations Cup puts on course for them, says
/// why those sides are there and that it is only how things stand. The
/// tables themselves never mark them (owner, 1.1.2: a yellow fourth place
/// only puzzled), nor do the Nations Cup's own tables.
void main() {
  testWidgets('the paths on course: a card that explains them, nothing '
      'marked in the tables', (tester) async {
    final base = fakeContinentalData(seededNationId);
    // The third of each of the first four groups: never a top-two side.
    final seeds = [
      for (final g in base.qualifyingGroups.take(4)) g.standings[2].nationId,
    ];
    final data = ContinentalData(
      name: base.name,
      confederation: Confederation.europe,
      isPlayerRegion: base.isPlayerRegion,
      hostCount: base.hostCount,
      qualifyingGroups: base.qualifyingGroups,
      groups: const [],
      knockout: const [],
      champion: null,
      scorers: const [],
      honours: const [],
      nations: base.nations,
      playerNationId: base.playerNationId,
      playerNames: const {},
      playoffRoute: true,
      playoffCourse: [(letter: 'D', seeds: seeds, finalHostSemi: 0)],
    );
    final save = await seedSave(
      tester,
      overrides: [
        continentalDetailProvider((
          careerId: kSeededCareerId,
          confederation: Confederation.europe,
        )).overrideWith((ref) async => data),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.continental}?careerId=${save.careerId}'
      '&conf=${Confederation.europe.name}',
      size: const Size(390, 4000),
    );
    expect(tester.takeException(), isNull);
    // The tables read off the tables alone: no yellow, no key.
    expect(find.byKey(PlayoffStripeLegend.legendKey), findsNothing);
    expect(find.text(enL.playoffCourseFooter), findsOneWidget);
    expect(find.text(enL.euroPlayoffPath('D')), findsOneWidget);

    // A side on course, third in its group, carries no stripe of it.
    final name = base.nations[seeds.first]!.name;
    final row = find
        .ancestor(of: find.text(name).first, matching: find.byType(Container))
        .evaluate()
        .map((e) => e.widget as Container)
        .firstWhere(
          (c) =>
              c.decoration is BoxDecoration &&
              (c.decoration! as BoxDecoration).border != null,
        );
    final border = (row.decoration! as BoxDecoration).border! as Border;
    expect(border.left.color, isNot(AppColors.playoff));
  });

  // Yellow on the World Championship's tables is the best runners-up
  // alone, and the key says so.
  testWidgets('the key says yellow is the best runners-up', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: PlayoffStripeLegend()),
      ),
    );
    expect(find.textContaining('best runners-up'), findsOneWidget);
    expect(find.textContaining('Nations Cup'), findsNothing);
  });
}
