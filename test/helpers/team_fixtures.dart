import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/features/friendlies/friendlies_providers.dart';
import 'package:fnm/features/stats/stats_providers.dart';

import 'competition_fixtures.dart';
import 'history_fixtures.dart';
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

/// The manager's team records after a few cycles, drawn from his real
/// squad: ten scorers, ten most-capped (from further down the squad) and
/// eight best-rated, every second man still playing.
TeamStatsData fakeTeamStats() {
  final squad = squadOf(seededNationId);
  return (
    nation: realNationsById[seededNationId],
    scorers: [
      for (var i = 0; i < 10; i++) (playerId: squad[i].id, value: 30 - 2 * i),
    ],
    appearances: [
      for (var i = 0; i < 10; i++)
        (playerId: squad[i + 5].id, value: 90 - 5 * i),
    ],
    ratings: [
      for (var i = 0; i < 8; i++)
        (
          playerId: squad[i].id,
          apps: 20 - i,
          meanRating: 7.6 - i * 0.1,
          motms: 6 - i ~/ 2,
        ),
    ],
    names: {for (final p in squad.take(15)) p.id: p.name},
    active: {for (var i = 0; i < 15; i += 2) squad[i].id},
  );
}

Override fakeTeamStatsOverride() => teamStatsProvider(
  kSeededCareerId,
).overrideWith((ref) async => fakeTeamStats());
