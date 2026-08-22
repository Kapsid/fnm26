import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/features/match/setup_warning.dart';
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

import '../helpers/pump_app.dart';

/// The warning has to fire when something CHANGES, not only on day one.
///
/// Asking whether an id had been stored meant it warned once, at the start,
/// and then never again: a captain who picked up a six-week injury, or a
/// penalty taker dropped from the squad, left his id sitting in the save and
/// the strip silent — on precisely the match where it was needed.
void main() {
  Player player(int id) => Player(
    id: id,
    nationId: 1,
    name: 'Player $id',
    position: PlayerPosition.cm,
    age: 27,
    club: 'Club',
    attributes: const PlayerAttributes(
      physical: 80,
      technical: 80,
      stamina: 80,
    ),
  );

  const captainId = 1;
  const takerId = 2;

  Future<bool> warns(
    WidgetTester tester, {
    required Set<int> callUps,
    required Map<int, PlayerAbsence> absences,
  }) async {
    await tester.pumpApp(
      const Scaffold(body: SquadSetupWarning(careerId: 1)),
      overrides: [
        captainProvider(1).overrideWith((ref) async => player(captainId)),
        setPieceTakersProvider(
          1,
        ).overrideWith((ref) async => (penalty: takerId, deadBall: takerId)),
        squadDataProvider(1).overrideWith(
          (ref) async => SquadData(
            pool: [player(captainId), player(takerId)],
            callUps: callUps,
            absences: absences,
          ),
        ),
      ],
    );
    await tester.pumpAndSettle();
    return find.byIcon(Icons.error_outline_rounded).evaluate().isNotEmpty;
  }

  testWidgets('a side that is properly set up says nothing', (tester) async {
    expect(
      await warns(
        tester,
        callUps: const {captainId, takerId},
        absences: const {},
      ),
      isFalse,
    );
  });

  testWidgets('an injured captain is not a captain', (tester) async {
    expect(
      await warns(
        tester,
        callUps: const {captainId, takerId},
        absences: const {
          captainId: PlayerAbsence(playerId: captainId, injuryMatches: 6),
        },
      ),
      isTrue,
      reason: 'the armband is on a man who cannot play',
    );
  });

  testWidgets('a suspended penalty taker is not a penalty taker', (
    tester,
  ) async {
    expect(
      await warns(
        tester,
        callUps: const {captainId, takerId},
        absences: const {
          takerId: PlayerAbsence(playerId: takerId, banMatches: 1),
        },
      ),
      isTrue,
    );
  });

  testWidgets('a taker dropped from the squad is not a taker', (tester) async {
    expect(
      await warns(tester, callUps: const {captainId}, absences: const {}),
      isTrue,
      reason: 'he is not in the squad any more',
    );
  });

  testWidgets('a captain dropped from the squad is not a captain', (
    tester,
  ) async {
    expect(
      await warns(tester, callUps: const {takerId}, absences: const {}),
      isTrue,
    );
  });

  testWidgets('a yellow card is not an absence', (tester) async {
    // One booking is not a ban, and warning about it would be the nag this
    // strip is trying not to be.
    expect(
      await warns(
        tester,
        callUps: const {captainId, takerId},
        absences: const {
          captainId: PlayerAbsence(playerId: captainId, yellows: 1),
        },
      ),
      isFalse,
    );
  });
}
