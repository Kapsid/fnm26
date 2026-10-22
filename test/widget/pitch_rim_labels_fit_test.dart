import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/card_status.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/expect_whole.dart';
import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

/// The two labels on a ball's rim — the position on top, what he has left
/// underneath — read at a glance during a match.
///
/// The manager's report: "Increase the text size under the player. Hard to
/// see how much fitness % they have remaining during the match. Also increase
/// the position text at the top of their circle." Both were 8pt. The balls
/// themselves cannot grow (see `_discWidthFraction`), so the labels grew into
/// the rim band instead, and these hold them there: large, whole, and on
/// nobody else's ball, at every phone width in the longest languages.
void main() {
  /// The smallest either label may be drawn at on a phone.
  const minRimFont = 11.0;

  for (final width in [320.0, 360.0, 400.0]) {
    for (final code in ['en', 'cs', 'de', 'el', 'pt']) {
      testWidgets('rim labels fit at ${width.toInt()}px in $code', (
        tester,
      ) async {
        // Every shape: the tightest pair of players is a different pair in
        // each, and a label only has to land on one ball to be the bug.
        for (final shape in Formation.values) {
          tester.view
            ..devicePixelRatio = 1
            ..physicalSize = Size(width, width * 4 / 3 + 200);
          addTearDown(tester.view.reset);
          final ids = [for (var i = 0; i < 11; i++) 100 + i];
          final squad = <int, Player>{
            for (var i = 0; i < 11; i++)
              100 + i: player(
                id: 100 + i,
                nationId: 1,
                name: 'Koto Rakotoharimalala$i',
                position: shape.positions[i],
              ),
          };
          await tester.pumpApp(
            ListView(
              children: [
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: TacticsPitch(
                    formation: shape,
                    // Narrow and high: the tightest the eleven ever stand.
                    instructions: const TacticalInstructions(
                      width: 0,
                      defensiveLine: 100,
                    ),
                    lineup: ids,
                    byId: squad,
                    // The widest figure the gauge can print, on everybody.
                    energyByPlayer: {for (final id in ids) id: 100},
                    cardsByPlayer: {
                      for (final id in ids)
                        if (id.isEven) id: MatchCard.yellow,
                    },
                    onTapSlot: (_) {},
                    onSwap: (_, _) {},
                    onBenchIn: (_, _) {},
                  ),
                ),
              ],
            ),
            locale: Locale(code),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expectNothingCut(tester, 'the pitch in $code');

          final discs = [
            for (var i = 0; i < 11; i++)
              tester.getRect(find.byKey(ValueKey('pitchDisc$i'))),
          ];
          for (var slot = 0; slot < 11; slot++) {
            for (final key in ['pitchPos$slot', 'pitchEnergy$slot']) {
              final badge = find.byKey(ValueKey(key));
              expect(badge, findsOneWidget, reason: '$key is missing');
              final text = find.descendant(
                of: badge,
                matching: find.byType(Text),
              );
              final style = tester.widget<Text>(text).style!;
              expect(
                style.fontSize,
                greaterThanOrEqualTo(minRimFont),
                reason: '$key is drawn at ${style.fontSize}',
              );
              // Whole and unscaled: a label the badge had to shrink back
              // down is the 8pt label again by another route.
              expect(
                shrinkOf(tester, text),
                greaterThan(0.99),
                reason: '$key had to shrink to fit',
              );
              final rect = tester.getRect(badge);
              for (var other = 0; other < 11; other++) {
                if (other == slot) continue;
                expect(
                  _touchesBall(rect, discs[other], rounded: true),
                  isFalse,
                  reason:
                      "$key lands on player $other's ball "
                      '(${shape.label}, ${width.toInt()}px, $code)',
                );
              }
            }
            if (find.byKey(ValueKey('pitchCard$slot')).evaluate().isEmpty) {
              continue;
            }
            final card = tester.getRect(find.byKey(ValueKey('pitchCard$slot')));
            for (var other = 0; other < 11; other++) {
              if (other == slot) continue;
              expect(
                _touchesBall(card, discs[other]),
                isFalse,
                reason: "player $slot's card lands on player $other's ball",
              );
            }
          }
        }
      });
    }
  }
}

/// Whether [rect] reaches inside the circle drawn in [disc]'s square.
///
/// The circle, not its bounding box: two balls set diagonally have
/// overlapping boxes long before anything touches the ball itself, and the
/// corner of one box is exactly where the next man's label sits. A [rounded]
/// rect is a pill rounded end to end — the shape the large rim labels are
/// drawn in — so its corners are measured as the arcs they are.
bool _touchesBall(Rect rect, Rect disc, {bool rounded = false}) {
  final r = rounded ? rect.shortestSide / 2 : 0.0;
  final core = rect.deflate(r);
  final c = disc.center;
  final nearest = Offset(
    c.dx.clamp(core.left, core.right),
    c.dy.clamp(core.top, core.bottom),
  );
  return (nearest - c).distance - r < disc.width / 2;
}
