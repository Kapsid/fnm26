import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

/// Every switch a shape allows, one or two at a time.
List<SlotSwitches> everySwitch(Formation f) {
  final ps = f.positions;
  final singles = <(int, PlayerPosition)>[
    for (var s = 0; s < ps.length; s++)
      for (final to in SlotSwitches.alternativesFor(ps[s])) (s, to),
  ];
  return [
    for (final a in singles) SlotSwitches({a.$1: a.$2}),
    for (var i = 0; i < singles.length; i++)
      for (var j = i + 1; j < singles.length; j++)
        if (singles[i].$1 != singles[j].$1)
          SlotSwitches({
            singles[i].$1: singles[i].$2,
            singles[j].$1: singles[j].$2,
          }),
  ];
}

/// A switched slot's disc moves into the row of the place it plays, so the
/// balls' clearance (see tactics_pitch_test's `_minBallClearance`) has to
/// hold for every switched shape too, not only for the formation tables.
/// Walked at the tightest case that test found: the smallest phone, the
/// narrowest width, the highest line.
void main() {
  testWidgets('every switched shape keeps the balls clear', (tester) async {
    const pitchWidth = 320.0;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(pitchWidth, pitchWidth * 4 / 3 + 200);
    addTearDown(tester.view.reset);
    for (final shape in Formation.values) {
      final squad = <int, Player>{
        for (var i = 0; i < 11; i++)
          100 + i: player(
            id: 100 + i,
            nationId: 1,
            name: 'Koto Rakotoharimalala$i',
            position: shape.positions[i],
          ),
      };
      for (final switches in everySwitch(shape)) {
        await tester.pumpApp(
          ListView(
            children: [
              AspectRatio(
                aspectRatio: 3 / 4,
                child: TacticsPitch(
                  formation: shape,
                  instructions: const TacticalInstructions(
                    width: 0,
                    defensiveLine: 100,
                  ),
                  lineup: [for (var i = 0; i < 11; i++) 100 + i],
                  byId: squad,
                  switches: switches,
                  energyByPlayer: {for (var i = 0; i < 11; i++) 100 + i: 60},
                  onTapSlot: (_) {},
                  onSwap: (_, _) {},
                  onBenchIn: (_, _) {},
                ),
              ),
            ],
          ),
        );
        final discs = [
          for (var i = 0; i < 11; i++)
            tester.getRect(find.byKey(ValueKey('pitchDisc$i'))),
        ];
        for (var a = 0; a < 11; a++) {
          expect(
            discs[a].top >= 0 && discs[a].left >= 0,
            isTrue,
            reason: '${shape.label} $switches: player $a off the pitch',
          );
          for (var b = a + 1; b < 11; b++) {
            final apart = (discs[a].center - discs[b].center).distance;
            expect(
              apart,
              greaterThanOrEqualTo(discs[a].width * 1.10),
              reason:
                  '${shape.label} $switches: '
                  "player $a's ball crowds player $b's",
            );
          }
        }
      }
    }
  });
}
