import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/features/friendlies/friendlies_providers.dart';

import 'competition_fixtures.dart';
import 'seeded_save.dart';

// Fakes for the team screens a fresh save has nothing to show on yet (an
// open friendly gap, the team's records), drawn with the REAL nations and
// players.

/// Two open windows before the next qualifier, March (away) and June (home)
/// of 2027, the manager's three qualifying rivals marked, and the
/// twenty-four best-ranked other sides dealt between the windows.
FriendliesPlan fakeFriendliesPlan() {
  final field = fieldOf(seededNationId, 25);
  return FriendliesPlan(
    windows: [DateTime(2027, 3, 14), DateTime(2027, 6, 14)],
    rivals: field.sublist(1, 4),
    reason: FriendlyReason.qualifyingGroup,
    opponents: field.sublist(1),
    nations: realNationsById,
    playerNationId: seededNationId,
    cycle: 0,
  );
}

/// Confirming invalidates the plan; the override has no awaits, so a plan
/// invalidated and never re-read does not trip riverpod 2.6.1 at teardown.
Override fakeFriendliesOverride() => friendliesPlanProvider(
  kSeededCareerId,
).overrideWith((ref) async => fakeFriendliesPlan());
