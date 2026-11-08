import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/rating_colors.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/shared/widgets/rating_badge.dart';

import '../helpers/lineups_fixture.dart';
import '../helpers/seeded_save.dart';

/// The Lineups tab's rating badges and event markers.

Finder _badgeIn(int playerId) => find.descendant(
  of: find.byKey(MatchLineups.rowKey(playerId)),
  matching: find.byType(RatingBadge),
);

void main() {
  group('the badge', () {
    testWidgets('prints one decimal on its band colour', (tester) async {
      await pumpThemed(
        tester,
        const Column(
          children: [
            RatingBadge(5.9),
            RatingBadge(6.0),
            RatingBadge(7.04),
            RatingBadge(8.0, compact: true),
          ],
        ),
        const Size(320, 400),
      );
      for (final t in ['5.9', '6.0', '7.0', '8.0']) {
        expect(find.text(t), findsOneWidget);
      }
      Color fillOf(double r) =>
          (tester
                      .widget<Container>(
                        find.descendant(
                          of: find.byWidgetPredicate(
                            (w) => w is RatingBadge && w.rating == r,
                          ),
                          matching: find.byType(Container),
                        ),
                      )
                      .decoration!
                  as BoxDecoration)
              .color!;
      expect(fillOf(5.9), RatingBandColors.dark.poor);
      expect(fillOf(6.0), RatingBandColors.dark.fair);
      expect(fillOf(7.04), RatingBandColors.dark.good);
      expect(fillOf(8.0), RatingBandColors.dark.great);
    });

    testWidgets('the player of the match wears a star with a tooltip', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        const RatingBadge(8.6, motm: true),
        const Size(320, 200),
      );
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
      expect(find.byType(Tooltip), findsOneWidget);
      expect(
        tester.widget<Tooltip>(find.byType(Tooltip)).message,
        enL.ratingPlayerOfTheMatch,
      );
    });
  });

  group('the line-ups', () {
    for (final width in [320.0, 250.0, 360.0]) {
      testWidgets('every player who has played has a badge, no overflow at '
          '${width.toInt()}', (tester) async {
        await pumpThemed(tester, buildLineups(), Size(width, 1600));
        expect(tester.takeException(), isNull);
        // Ten of the home eleven still on, the newcomer, and the away
        // eleven: a badge each, plus the man taken off and the away
        // newcomer in the substitution rows, plus the two averages.
        expect(find.byType(RatingBadge), findsNWidgets(22 + 2 + 2));
        expect(_badgeIn(lineupsHomeXi[7].id), findsOneWidget);
        expect(_badgeIn(lineupsHomeSubOn.id), findsOneWidget);
        // A named substitute who has not played has none.
        expect(find.text(lineupsHomeBench.name), findsOneWidget);
        expect(find.text(enL.matchLiveRatingsNote), findsOneWidget);
      });
    }

    testWidgets('markers: goals counted, assist, cards, knock, subs', (
      tester,
    ) async {
      await pumpThemed(tester, buildLineups(), const Size(360, 1600));
      final scorer = lineupsHomeXi[7].id;
      expect(find.byKey(ValueKey(('goalMark', scorer))), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(ValueKey(('goalMark', scorer))),
          matching: find.text('2'),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(ValueKey(('assistMark', lineupsHomeXi[5].id))),
        findsOneWidget,
      );
      expect(
        find.byKey(ValueKey(('cardMark', lineupsHomeXi[3].id))),
        findsOneWidget,
      );
      expect(
        find.byKey(ValueKey(('cardMark', lineupsHomeXi[8].id))),
        findsOneWidget,
      );
      expect(
        find.byKey(ValueKey(('cardMark', lineupsAwayXi[1].id))),
        findsOneWidget,
      );
      expect(
        find.byKey(ValueKey(('injuryMark', lineupsAwayXi[7].id))),
        findsOneWidget,
      );
      expect(
        find.byKey(ValueKey(('subOnMark', lineupsHomeSubOn.id))),
        findsOneWidget,
      );
      expect(
        find.byKey(ValueKey(('subOffMark', lineupsAwayXi[7].id))),
        findsOneWidget,
      );
    });

    testWidgets('a narrow column keeps the names and every badge whole', (
      tester,
    ) async {
      // The tablet's Pitch-mode column on an 11 inch iPad.
      await pumpThemed(tester, buildLineups(), const Size(256, 1600));
      expect(tester.takeException(), isNull);
      // The markers go under the name, the energy figure is dropped.
      expect(
        find.byKey(ValueKey(('markersUnder', lineupsHomeXi[7].id))),
        findsOneWidget,
      );
      expect(find.textContaining('%'), findsNothing);
      // Every player's name keeps at least ten characters on screen.
      final style = DefaultTextStyle.of(
        tester.element(find.text(lineupsHomeXi[0].name).first),
      ).style;
      for (final p in [...lineupsHomeXi.take(10), lineupsHomeSubOn]) {
        final text = tester.renderObject<RenderParagraph>(
          find.descendant(
            of: find.byKey(MatchLineups.rowKey(p.id)),
            matching: find.text(p.name),
          ),
        );
        final tenChars = TextPainter(
          text: TextSpan(
            text: p.name.substring(0, p.name.length.clamp(0, 10)),
            style: text.text.style ?? style,
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        expect(
          text.size.width,
          greaterThanOrEqualTo(tenChars.width - 0.5),
          reason: p.name,
        );
      }
      // Every badge is drawn in full: none is clipped by its row.
      for (final badge in find.byType(RatingBadge).evaluate()) {
        final box = badge.renderObject! as RenderBox;
        final rect = box.localToGlobal(Offset.zero) & box.size;
        expect(rect.right, lessThanOrEqualTo(256), reason: '$rect');
        expect(box.size.width, greaterThanOrEqualTo(30));
      }
      // The man taken off still shows his badge in the substitution row.
      expect(
        find.descendant(
          of: find
              .ancestor(
                of: find.text(lineupsHomeXi[10].name),
                matching: find.byType(Row),
              )
              .first,
          matching: find.byType(RatingBadge),
        ),
        findsOneWidget,
      );
    });

    testWidgets('the star waits for the whistle', (tester) async {
      await pumpThemed(tester, buildLineups(), const Size(360, 1600));
      expect(find.byIcon(Icons.star_rounded), findsNothing);
      await pumpThemed(
        tester,
        buildLineups(fullTime: true),
        const Size(360, 1600),
      );
      expect(
        find.descendant(
          of: _badgeIn(lineupsHomeXi[7].id),
          matching: find.byIcon(Icons.star_rounded),
        ),
        findsOneWidget,
      );
      expect(find.text(enL.matchLiveRatingsNote), findsNothing);
    });
  });

  group('the match screen', () {
    for (final f in [FormFactor.phone, FormFactor.tablet]) {
      testWidgets('the Lineups tab shows rating badges (${f.name})', (
        tester,
      ) async {
        final save = await seedSave(tester, formFactor: f);
        final warm = save.container.listen(
          matchPreviewProvider(save.careerId),
          (_, _) {},
        );
        addTearDown(warm.close);
        await tester.runAsync(
          () => save.container.read(matchPreviewProvider(save.careerId).future),
        );
        await pumpRoute(
          tester,
          save,
          '${Routes.match}?careerId=${save.careerId}',
          size: f == FormFactor.tablet ? kTabletSize : const Size(320, 640),
        );
        await tester.tap(find.text(enL.matchTabLineups));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));
        expect(tester.takeException(), isNull);
        expect(find.byType(MatchLineups), findsOneWidget);
        // At kick-off every starter is on the neutral mark.
        expect(
          find.descendant(
            of: find.byType(MatchLineups),
            matching: find.byType(RatingBadge),
          ),
          findsWidgets,
        );
        expect(
          find.descendant(
            of: find.byType(MatchLineups),
            matching: find.text('6.5'),
          ),
          findsWidgets,
        );
        await tester.pumpWidget(const SizedBox());
      });
    }
  });
}
