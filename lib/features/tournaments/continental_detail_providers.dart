import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/qualification.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';

/// Identifies one continental championship within a save.
typedef ContinentalKey = ({int careerId, Confederation confederation});

/// Data for the continental-championship detail screen.
class ContinentalData {
  const ContinentalData({
    required this.name,
    required this.confederation,
    required this.isPlayerRegion,
    required this.qualifyingGroups,
    required this.groups,
    required this.knockout,
    required this.champion,
    required this.scorers,
    required this.honours,
    required this.nations,
    required this.playerNationId,
    required this.playerNames,
  });

  final String name;
  final Confederation confederation;

  /// Whether this is the player's region (the only one played in detail; other
  /// regions are simulated in the background and only appear in History).
  final bool isPlayerRegion;

  /// This cycle's continental qualifying group tables (empty when seeded).
  final List<FinalsGroupTable> qualifyingGroups;

  /// This cycle's finals group tables (empty for non-player regions / before
  /// the finals are drawn).
  final List<FinalsGroupTable> groups;

  /// This cycle's knockout fixtures (empty for non-player regions / no edition).
  final List<Fixture> knockout;
  final int? champion;
  final List<ScorerTally> scorers;

  /// Past editions of this championship, newest first.
  final List<Honour> honours;
  final Map<int, Nation> nations;
  final int playerNationId;
  final Map<int, String> playerNames;
}

/// The continental knockout rounds in bracket order.
const _rounds = ['CR16', 'CQF', 'CSF', 'C3RD', 'CFINAL'];

/// The drawn continental group stage, for the pot-draw ceremony.
class ContinentalDrawData {
  const ContinentalDrawData({required this.draw, required this.nations});
  final FinalsDraw draw;
  final Map<int, Nation> nations;
}

/// Recomputes the player's continental group draw deterministically (same seed
/// and qualifiers as creation) so the ceremony matches the stored groups.
/// Returns null when the player's region isn't contesting a finals this cycle.
final AutoDisposeFutureProviderFamily<ContinentalDrawData?, ContinentalKey>
    continentalDrawProvider =
    FutureProvider.autoDispose.family<ContinentalDrawData?, ContinentalKey>((
  ref,
  key,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(key.careerId);
  if (career == null) return null;
  final config = ContinentalCups.byConfederation[key.confederation];
  if (config == null) return null;

  final comp = ref.watch(competitionRepositoryProvider);
  if (!await comp.hasTournament(
    key.careerId,
    CompetitionKind.continentalFinals,
  )) {
    return null;
  }
  final all = await ref.watch(nationRepositoryProvider).all();
  if (all
          .firstWhere((n) => n.id == career.nationId)
          .confederation !=
      key.confederation) {
    return null;
  }
  final rankById = await ref.watch(
    seedRankByIdProvider((
      careerId: key.careerId,
      cycle: career.cyclePointer,
    )).future,
  );
  int rankOf(Nation n) => rankById[n.id] ?? n.ranking;
  // The finals field comes from continental qualifying when it was played;
  // otherwise (the seeded fallback) from the confederation's ranking.
  List<int> qualifierIds;
  if (await comp.hasTournament(
        key.careerId,
        CompetitionKind.continentalQualifying,
      ) &&
      await comp.allPlayedForKind(
        key.careerId,
        CompetitionKind.continentalQualifying,
      )) {
    final tables = await comp.tournamentGroupTables(
      key.careerId,
      CompetitionKind.continentalQualifying,
    );
    qualifierIds = Qualification.qualifiers(
      tables.map((t) => t.standings).toList(),
      config.size,
    );
  } else {
    final members = all
        .where((n) => n.confederation == key.confederation)
        .toList()
      ..sort((a, b) => rankOf(a).compareTo(rankOf(b)));
    qualifierIds = members.take(config.size).map((n) => n.id).toList();
  }
  if (qualifierIds.length < config.size) return null;

  final draw = WorldCupFinals.drawGroups(
    qualifierIds: qualifierIds,
    rankingById: {for (final n in all) n.id: rankOf(n)},
    rngSeed: career.rngSeed ^ (career.cyclePointer * 0x71) ^ 0xC0FF,
  );
  return ContinentalDrawData(
    draw: draw,
    nations: {for (final n in all) n.id: n},
  );
});

/// Recomputes the continental qualifying group draw deterministically (same
/// seed and members as creation), for the qualifying draw ceremony. Returns
/// null when the player's region has no qualifying this cycle.
final AutoDisposeFutureProviderFamily<ContinentalDrawData?, ContinentalKey>
    continentalQualifyingDrawProvider =
    FutureProvider.autoDispose.family<ContinentalDrawData?, ContinentalKey>((
  ref,
  key,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(key.careerId);
  if (career == null) return null;
  if (ContinentalCups.byConfederation[key.confederation] == null) return null;

  final comp = ref.watch(competitionRepositoryProvider);
  if (!await comp.hasTournament(
    key.careerId,
    CompetitionKind.continentalQualifying,
  )) {
    return null;
  }
  final all = await ref.watch(nationRepositoryProvider).all();
  if (all.firstWhere((n) => n.id == career.nationId).confederation !=
      key.confederation) {
    return null;
  }
  final rankById = await ref.watch(
    seedRankByIdProvider((
      careerId: key.careerId,
      cycle: career.cyclePointer,
    )).future,
  );
  final members =
      all.where((n) => n.confederation == key.confederation).toList();
  final schedule = const ScheduleGenerator().generate(
    confederation: key.confederation,
    nations: members,
    rngSeed: career.rngSeed ^ (career.cyclePointer * 0x71) ^ 0xCAFE,
    start: DateTime(CareerService.worldCupYear(career.cyclePointer) - 3, 9),
    groupSize: 4,
    rankById: rankById,
  );
  return ContinentalDrawData(
    draw: FinalsDraw(
      groups: [
        for (final g in schedule.groups)
          FinalsGroupDraw(name: g.name, nationIds: g.nationIds, fixtures: []),
      ],
    ),
    nations: {for (final n in all) n.id: n},
  );
});

final AutoDisposeFutureProviderFamily<ContinentalData?, ContinentalKey>
    continentalDetailProvider =
    FutureProvider.autoDispose.family<ContinentalData?, ContinentalKey>((
  ref,
  key,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(key.careerId);
  if (career == null) return null;
  final config = ContinentalCups.byConfederation[key.confederation];
  if (config == null) return null;

  final comp = ref.watch(competitionRepositoryProvider);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  final playerConf = nations[career.nationId]?.confederation;
  final isPlayerRegion = playerConf == key.confederation;

  // Only the player's region is contested as live fixtures this cycle.
  final knockout = <Fixture>[];
  var groups = <FinalsGroupTable>[];
  var qualifyingGroups = <FinalsGroupTable>[];
  if (isPlayerRegion) {
    qualifyingGroups = await comp.tournamentGroupTables(
      key.careerId,
      CompetitionKind.continentalQualifying,
    );
  }
  if (isPlayerRegion &&
      await comp.hasTournament(
        key.careerId,
        CompetitionKind.continentalFinals,
      )) {
    groups = await comp.tournamentGroupTables(
      key.careerId,
      CompetitionKind.continentalFinals,
    );
    for (final round in _rounds) {
      knockout.addAll(
        await comp.fixturesByRound(
          key.careerId,
          round,
          kind: CompetitionKind.continentalFinals,
        ),
      );
    }
  }
  knockout.sort((a, b) => a.date.compareTo(b.date));

  int? champion;
  final finalTie = knockout.where((f) => f.round == 'CFINAL');
  if (finalTie.isNotEmpty && finalTie.first.hasResult) {
    final f = finalTie.first;
    champion = f.homeScore! >= f.awayScore! ? f.homeNationId : f.awayNationId;
  }

  final scorers = isPlayerRegion
      ? await comp.topScorers(
          key.careerId,
          kind: CompetitionKind.continentalFinals,
          limit: 15,
        )
      : const <ScorerTally>[];

  final allHonours = await comp.honours(key.careerId);
  final honours =
      allHonours.where((h) => h.competition == config.name).toList()
        ..sort((a, b) => b.year.compareTo(a.year));

  final playerRepo = ref.watch(playerRepositoryProvider);
  final playerNames = <int, String>{};
  for (final id in {for (final s in scorers) s.playerId}) {
    final p = await playerRepo.byId(id);
    if (p != null) playerNames[id] = p.name;
  }

  return ContinentalData(
    name: config.name,
    confederation: key.confederation,
    isPlayerRegion: isPlayerRegion,
    qualifyingGroups: qualifyingGroups,
    groups: groups,
    knockout: knockout,
    champion: champion,
    scorers: scorers,
    honours: honours,
    nations: nations,
    playerNationId: career.nationId,
    playerNames: playerNames,
  );
});
