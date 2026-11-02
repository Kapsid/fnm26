import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

/// A 4-3-3 with a switch drawn the way a real shape with those places is:
/// the DM stepped up among the CMs reads as a flat three, stepped up to AM
/// as a ten behind the striker.
void main() {
  const f = Formation.f433;
  final squad = <int, Player>{
    for (var i = 0; i < 11; i++)
      100 + i: player(
        id: 100 + i,
        nationId: 1,
        name: 'Player Number$i',
        position: f.positions[i],
      ),
  };

  for (final (name, switches) in [
    ('dm_cm', const SlotSwitches({5: PlayerPosition.cm})),
    ('dm_am', const SlotSwitches({5: PlayerPosition.am})),
    ('cm_am', const SlotSwitches({6: PlayerPosition.am})),
    (
      'cm_dm_lw_lm',
      const SlotSwitches({6: PlayerPosition.dm, 8: PlayerPosition.lm}),
    ),
  ]) {
    testWidgets('4-3-3 switched $name', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 520);
      addTearDown(tester.view.reset);
      await tester.pumpApp(
        RepaintBoundary(
          key: const ValueKey('pitch'),
          child: TacticsPitch(
            formation: f,
            instructions: const TacticalInstructions(),
            lineup: [for (var i = 0; i < 11; i++) 100 + i],
            byId: squad,
            switches: switches,
            onTapSlot: (_) {},
            onSwap: (_, _) {},
            onBenchIn: (_, _) {},
          ),
        ),
      );
      await expectLater(
        find.byKey(const ValueKey('pitch')),
        matchesGoldenFile('goldens/switched_433_$name.png'),
      );
    });
  }
}
