import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The tester's report: Asia's qualifying screen on calendar2 painted every
/// winner and runner-up orange, showed only the winners' ladder, and sent the
/// last two winners "to the intercontinental play-off" when they go to Asia's
/// fourth round. Now the screen has a colour key, the winners' ladder names
/// the fourth round, a runners-up ladder shows who joins them, and the
/// player's group paints its winner as that ladder does.
void main() {
  final ids = [
    for (final n in realNations)
      if (n.confederation == Confederation.asia) n.id,
  ];
  final groups = [
    for (var g = 0; g < 8; g++)
      (
        confederation: Confederation.asia,
        groupName: String.fromCharCode(65 + g),
        standings: standingsOf([for (var p = 0; p < 5; p++) ids[p * 8 + g]]),
      ),
  ];
  CupData data({required bool steps}) => CupData(
    groups: groups,
    nations: realNationsById,
    playerNationId: ids.first,
    playerConfederation: Confederation.asia,
    finalsGroups: const [],
    knockout: const [],
    champion: null,
    hostId: null,
    scorersQualifying: const [],
    scorersFinals: const [],
    honours: const [],
    playerNames: const {},
    confedSteps: steps,
  );

  Color? stripeOf(WidgetTester t, String name) {
    final row = find
        .ancestor(of: find.text(name), matching: find.byType(Container))
        .evaluate()
        .map((e) => e.widget as Container)
        .firstWhere(
          (c) =>
              c.decoration is BoxDecoration &&
              (c.decoration! as BoxDecoration).border is Border,
        );
    return ((row.decoration! as BoxDecoration).border! as Border).left.color;
  }

  testWidgets('Asia on calendar2: key, both ladders, the fourth round', (
    t,
  ) async {
    final save = await seedSave(
      t,
      overrides: [
        cupDetailProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => data(steps: true)),
      ],
    );
    await pumpRoute(t, save, '${Routes.cup}?careerId=${save.careerId}');
    await t.tap(find.text('QUALIFYING').first);
    await t.pumpAndSettle();

    expect(
      find.text('Green: on course for the finals, as things stand'),
      findsOneWidget,
    );
    expect(
      find.text('Yellow: on course for the Asian fourth round'),
      findsOneWidget,
    );
    expect(
      find.text('Orange: still in the race, but outside those places for now'),
      findsOneWidget,
    );

    // The player's group A winner: green exactly when it is one of the best
    // six winners, yellow when it is one of the fourth round's six.
    final tables = [for (final g in groups) g.standings];
    final direct = GroupAdvancement.worldCupDirectNations(
      Confederation.asia,
      tables,
      hosts: 0,
      confedSteps: true,
    );
    final winner = realNationsById[ids.first]!.name;
    expect(
      stripeOf(t, winner),
      direct.contains(ids.first) ? AppColors.positive : AppColors.playoff,
    );

    final list = find.byWidget(
      t.widget(
        find
            .ancestor(of: find.text(winner), matching: find.byType(Scrollable))
            .first,
      ),
    );
    await t.scrollUntilVisible(
      find.text('Top 4 advance to the Asian fourth round'),
      300,
      scrollable: list,
    );
    expect(find.textContaining('intercontinental play-off'), findsNothing);
    expect(
      find.text('The next 2 go to the Asian fourth round'),
      findsOneWidget,
    );
    await t.pumpWidget(const SizedBox());
  });

  testWidgets('without the step Asia keeps its old ladder and no orange key', (
    t,
  ) async {
    final save = await seedSave(
      t,
      overrides: [
        cupDetailProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => data(steps: false)),
      ],
    );
    await pumpRoute(t, save, '${Routes.cup}?careerId=${save.careerId}');
    await t.tap(find.text('QUALIFYING').first);
    await t.pumpAndSettle();
    expect(
      find.text('Green: on course for the finals, as things stand'),
      findsOneWidget,
    );
    expect(find.textContaining('fourth round'), findsNothing);
    await t.pumpWidget(const SizedBox());
  });
}
