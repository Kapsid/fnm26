import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/features/tournaments/nations_cup_providers.dart';
import 'package:fnm/shared/widgets/playoff_badge.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// A Nations Cup side on course for a play-off path carries its own tag
/// beside the name, apart from the promotion stripe: a group winner keeps
/// its green and shows the tag too (it used to lose the yellow to the
/// green and nothing said it was headed for the play-off). The legend
/// over the league says what each mark means.
void main() {
  testWidgets('a group winner on course for the play-off is tagged and '
      'keeps its green', (tester) async {
    final base = fakeNationsCup(seededNationId);
    final b1 = base.groups.singleWhere((g) => g.name == 'B1').standings;
    final winner = b1.first.nationId;
    final third = b1[2].nationId;
    final save = await seedSave(
      tester,
      overrides: [
        nationsCupProvider((
          careerId: kSeededCareerId,
          confederation: null,
        )).overrideWith(
          (ref) async => (
            confederation: base.confederation,
            cupName: base.cupName,
            format: base.format,
            isMine: base.isMine,
            playerLeague: base.playerLeague,
            playerGroup: base.playerGroup,
            groups: base.groups,
            roundOf16: base.roundOf16,
            quarters: base.quarters,
            semis: base.semis,
            finalFx: base.finalFx,
            honours: base.honours,
            scorers: base.scorers,
            playerNames: base.playerNames,
            drawWatched: base.drawWatched,
            playerNationId: base.playerNationId,
            myNationIds: base.myNationIds,
            nations: base.nations,
            maxTier: base.maxTier,
            playoffNations: {winner, third},
            playoffForWorld: true,
          ),
        ),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.nationsCup}?careerId=${save.careerId}',
      size: const Size(390, 1600),
    );

    // League B, the lowest here (maxTier 1): winners go up, nobody goes
    // down, and the tag.
    expect(find.text(enL.ncLegendWinnerUp), findsOneWidget);
    expect(find.text(enL.ncLegendLastDown), findsNothing);
    expect(find.text(enL.ncWcPlayoffLegend), findsOneWidget);
    // One tag in the legend, one beside each marked side.
    expect(find.byKey(PlayoffBadge.badgeKey), findsNWidgets(3));

    // The winner's row: green stripe, and the tag beside the name.
    final name = base.nations[winner]!.name;
    final row = find
        .ancestor(of: find.text(name), matching: find.byType(Container))
        .evaluate()
        .map((e) => e.widget as Container)
        .firstWhere(
          (c) =>
              c.decoration is BoxDecoration &&
              (c.decoration! as BoxDecoration).border != null,
        );
    final border = (row.decoration! as BoxDecoration).border! as Border;
    expect(border.left.color, AppColors.positive);
    expect(
      find.descendant(
        of: find.ancestor(of: find.text(name), matching: find.byType(Row)).first,
        matching: find.byKey(PlayoffBadge.badgeKey),
      ),
      findsOneWidget,
    );
  });
}
