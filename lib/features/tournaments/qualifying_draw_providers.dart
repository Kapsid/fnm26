import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';

/// The recomputed qualifying draw for the player's confederation, used by the
/// qualifying draw ceremony. Deterministic — it reruns [ScheduleGenerator] with
/// the exact seed [CareerService.buildCalendar] used, so it matches the
/// persisted groups.
class QualifyingDrawData {
  const QualifyingDrawData({
    required this.title,
    required this.groups,
    required this.nations,
    required this.playerNationId,
    required this.potByNation,
    required this.cycle,
    required this.watchedKind,
  });

  final String title;
  final List<({String name, List<int> nationIds})> groups;
  final Map<int, Nation> nations;
  final int playerNationId;
  final Map<int, int> potByNation;

  /// The cycle and draw key, so viewing the draw can mark it watched (it fires
  /// as a timeline event only once).
  final int cycle;
  final String watchedKind;
}

/// Argument for [qualifyingDrawProvider]: the save and which qualifying draw.
typedef QualifyingDrawArg = ({int careerId, bool worldCup});

final AutoDisposeFutureProviderFamily<QualifyingDrawData?, QualifyingDrawArg>
qualifyingDrawProvider = FutureProvider.autoDispose
    .family<QualifyingDrawData?, QualifyingDrawArg>((
      ref,
      arg,
    ) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref
          .watch(careerRepositoryProvider)
          .byId(arg.careerId);
      if (career == null) return null;
      final nations = {
        for (final n in await ref.watch(nationRepositoryProvider).all())
          n.id: n,
      };
      final conf = nations[career.nationId]?.confederation;
      if (conf == null) return null;

      // World Cup qualifying is drawn two years into the cycle off the LIVE
      // ranking (see HubService._drawWorldCupQualifyingIfDue), so its ceremony has
      // to read that draw's own snapshot or the pots on screen would disagree with
      // the groups actually drawn. Continental qualifying opens the cycle, so it
      // seeds from the cycle baseline.
      final rankById = arg.worldCup
          ? await ref.watch(
              drawRankByIdProvider((
                careerId: arg.careerId,
                cycle: career.cyclePointer,
                slot: drawSlotWorldCupQualifying,
              )).future,
            )
          : await ref.watch(
              seedRankByIdProvider((
                careerId: arg.careerId,
                cycle: career.cyclePointer,
              )).future,
            );
      int rankOf(Nation n) => rankById[n.id] ?? n.ranking;
      final members =
          nations.values.where((n) => n.confederation == conf).toList()
            ..sort((a, b) => rankOf(a).compareTo(rankOf(b)));
      if (members.length < 2) return null;

      final wcYear = CareerService.worldCupYear(career.cyclePointer);
      final GeneratedSchedule schedule;
      final String title;
      final String watchedKind;

      // The host sits out qualifying (friendlies only), so it's absent from the
      // group draw — mirror the exclusion in [CareerService.buildCalendar].
      final allNations = nations.values.toList();
      final List<Nation> drawMembers;

      if (arg.worldCup) {
        final hostIds = WorldCupHosts.worldCupHostIds(
          year: wcYear,
          nations: allNations,
          seed: career.rngSeed,
        );
        drawMembers = members.where((n) => !hostIds.contains(n.id)).toList();
        schedule = const ScheduleGenerator().generate(
          confederation: conf,
          nations: drawMembers,
          rngSeed:
              career.rngSeed ^
              (career.cyclePointer * 0x1B3D) ^
              (conf.index * 0x9E37),
          start: DateTime(wcYear - 2, 9),
          rankById: rankById,
        );
        title = 'WORLD CUP QUALIFYING DRAW';
        watchedKind = worldCupQualDrawKind;
      } else {
        final cont = ContinentalCups.byConfederation[conf];
        if (cont == null || members.length <= cont.size) return null;
        // The one shared definition of who is in the draw — see
        // [WorldCupHosts.continentalQualifiers]. Re-sorted by rank here because the
        // pot numbering below reads off this list's order.
        final field = {
          for (final n in WorldCupHosts.continentalQualifiers(
            confederation: conf,
            cycle: career.cyclePointer,
            seed: career.rngSeed,
            nations: allNations,
          ))
            n.id,
        };
        drawMembers = members.where((n) => field.contains(n.id)).toList();
        schedule = const ScheduleGenerator().generate(
          confederation: conf,
          nations: drawMembers,
          rngSeed: career.rngSeed ^ (career.cyclePointer * 0x71) ^ 0xCAFE,
          start: DateTime(wcYear - 4, 9),
          groupSize: 6,
          rankById: rankById,
        );
        title = '${cont.name.toUpperCase()} QUALIFYING DRAW';
        watchedKind = continentalQualDrawKind;
      }

      final groups = [
        for (final g in schedule.groups) (name: g.name, nationIds: g.nationIds),
      ];
      if (groups.isEmpty) return null;

      // Pots: the confederation seeded by ranking, split into as many pots as there
      // are groups (top group first).
      final groupCount = groups.length;
      final potByNation = <int, int>{
        for (var i = 0; i < drawMembers.length; i++)
          drawMembers[i].id: (i ~/ groupCount) + 1,
      };

      return QualifyingDrawData(
        title: title,
        groups: groups,
        nations: nations,
        playerNationId: career.nationId,
        potByNation: potByNation,
        cycle: career.cyclePointer,
        watchedKind: watchedKind,
      );
    });
