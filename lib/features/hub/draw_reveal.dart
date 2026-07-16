import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

/// The watched-draw key that unlocks a fixture's schedule, from its round, or
/// null for fixtures that are always visible (friendlies).
///
/// Shared by the Results feed and the hub so a competition's fixtures — and the
/// opponent/group they reveal — never appear before the player has watched the
/// draw that produced them.
String? drawKindForFixture(Fixture f) {
  final round = f.round;
  if (round == null) {
    // A group game with no round label is a qualifying-group fixture; a fixture
    // with neither round nor group is a friendly (always shown).
    return f.groupId != null ? worldCupQualDrawKind : null;
  }
  if (round == 'CQ') return continentalQualDrawKind;
  if (round.startsWith('C')) return continentalFinalsDrawKind; // CGROUP, CR16…
  // NGROUP/NSF/NFINAL — the Nations Cup has its own ceremony. Without this they
  // fell through to the World Cup key below and were hidden until December of
  // the cycle's third year, long after they were played.
  if (round.startsWith('N')) return nationsCupDrawKind;
  return worldCupDrawKind; // WC finals: GROUP/R32/R16/QF/SF/3RD/FINAL
}

/// The watched-draw key that unlocks a group table, from its competition
/// [kind], or null for a competition with no ceremony.
String? groupDrawKind(CompetitionKind kind) => switch (kind) {
      CompetitionKind.worldCupFinals => worldCupDrawKind,
      CompetitionKind.continentalFinals => continentalFinalsDrawKind,
      CompetitionKind.worldCupQualifying => worldCupQualDrawKind,
      CompetitionKind.continentalQualifying => continentalQualDrawKind,
      // The Nations Cup is drawn at a ceremony like the rest. Returning null
      // here left the hub's group table ungated, so it showed the groups while
      // the "Watch the Nations Cup draw" button was still sitting on the very
      // same screen.
      CompetitionKind.nationsLeague => nationsCupDrawKind,
      // No ceremony: a friendly is arranged, and the Clash is just the two
      // champions.
      CompetitionKind.friendly || CompetitionKind.finalissima => null,
    };

/// Whether the draw for the player's next fixture has been watched, so the hub
/// can hide the opponent and the group table until the balls come out.
final FutureProviderFamily<bool, int> nextDrawWatchedProvider =
    FutureProvider.family<bool, int>((ref, careerId) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return true;
  final comp = ref.watch(competitionRepositoryProvider);
  final next = await comp.nextFixtureForNation(careerId, career.nationId);
  if (next == null) return true;
  final kind = drawKindForFixture(next);
  if (kind == null) return true; // friendly — nothing to draw
  return comp.hasWatchedDraw(careerId, career.cyclePointer, kind);
});
