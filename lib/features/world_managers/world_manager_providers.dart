import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/world_managers/manager_relation.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_managers/world_manager_service.dart';

/// The world managers of every career (see [WorldManagerService]). Kept for
/// the app's life, so a career's seeding is shared by all who ask.
final worldManagerServiceProvider = Provider<WorldManagerService>(
  WorldManagerService.new,
);

/// Whether the AI's tactics read the world manager in charge (see
/// [WorldManagerService.styleOn]). Always on in the app; a test switches it
/// off to replay a world exactly as it was before world managers.
final worldManagerStyleEnabledProvider = Provider<bool>((_) => true);

/// The nations the player has led: every cycle's in [stints], and the one
/// he leads now ([current]).
Set<int> playerNationsOf(Map<int, int> stints, int current) => {
  ...stints.values,
  current,
};

/// The player's relation with manager [managerId], from what a reader has
/// already loaded: the career's [spells] and [ties] (any manager's; his are
/// picked out), the fixtures of every nation the player has led
/// ([playerFixtures], see [playerNationsOf]), his [stints] and the nation he
/// leads now. The one derivation every reader shares, so the news, the
/// press and Y all read the same label for the same man.
ManagerRelation relationWithPlayer({
  required int managerId,
  required List<ManagerSpell> spells,
  required List<ManagerTie> ties,
  required List<Fixture> playerFixtures,
  required Map<int, int> stints,
  required int currentNationId,
  required DateTime today,
}) => readRelation(
  spells: [
    for (final sp in spells)
      if (sp.managerId == managerId) sp,
  ],
  meetings: playerFixtures,
  playerSideAt: (d) => {
    stints[CareerService.cycleForYear(d.year)] ?? currentNationId,
  },
  ties: [
    for (final t in ties)
      if (t.managerId == managerId) t,
  ],
  today: today,
);

/// The player's relation with one world manager, derived on read. Read only
/// by the screens that show it, never by a hub, career-load or careers-list
/// provider.
///
/// Reads: his spells, the career's ties, and the player's own fixtures in
/// one query (a meeting counts only if the player was in it).
final AutoDisposeFutureProviderFamily<
  ManagerRelation,
  ({int careerId, int managerId})
>
managerRelationProvider = FutureProvider.autoDispose
    .family<ManagerRelation, ({int careerId, int managerId})>((ref, key) async {
      final repo = ref.read(worldManagerRepositoryProvider);
      final career = await ref
          .read(careerRepositoryProvider)
          .byId(key.careerId);
      if (career == null) {
        return (
          warmth: 0,
          label: TieLabel.neutral,
          meetings: 0,
          won: 0,
          drawn: 0,
          lost: 0,
        );
      }
      final stints = await ref
          .read(careerRepositoryProvider)
          .stints(key.careerId);
      return relationWithPlayer(
        managerId: key.managerId,
        spells: await repo.spellsOf(key.careerId, key.managerId),
        ties: await repo.ties(key.careerId),
        playerFixtures: await ref
            .read(competitionRepositoryProvider)
            .fixturesForNations(
              key.careerId,
              playerNationsOf(stints, career.nationId),
            ),
        stints: stints,
        currentNationId: career.nationId,
        today: career.inGameDate,
      );
    });
