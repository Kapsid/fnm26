import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
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

/// The player's relation with one world manager, derived on read. Read only
/// by the screens that show it, never by a hub, career-load or careers-list
/// provider.
final AutoDisposeFutureProviderFamily<
  ManagerRelation,
  ({int careerId, int managerId})
>
managerRelationProvider = FutureProvider.autoDispose
    .family<ManagerRelation, ({int careerId, int managerId})>((ref, key) async {
      final repo = ref.read(worldManagerRepositoryProvider);
      final spells = await repo.spellsOf(key.careerId, key.managerId);
      final ties = [
        for (final t in await repo.ties(key.careerId))
          if (t.managerId == key.managerId) t,
      ];
      final career = await ref
          .read(careerRepositoryProvider)
          .byId(key.careerId);
      final stints = await ref
          .read(careerRepositoryProvider)
          .stints(key.careerId);
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

      final comp = ref.read(competitionRepositoryProvider);
      final byId = <int, Fixture>{};
      for (final nationId in {for (final s in spells) s.nationId}) {
        for (final f in await comp.fixturesForNation(key.careerId, nationId)) {
          byId[f.id] = f;
        }
      }
      return readRelation(
        spells: spells,
        meetings: byId.values.toList(),
        playerSideAt: (d) => {
          stints[CareerService.cycleForYear(d.year)] ?? career.nationId,
        },
        ties: ties,
        today: career.inGameDate,
      );
    });
