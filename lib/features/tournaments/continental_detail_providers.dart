import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';

/// Identifies one continental championship within a save.
typedef ContinentalKey = ({int careerId, Confederation confederation});

/// Data for the continental-championship detail screen.
class ContinentalData {
  const ContinentalData({
    required this.name,
    required this.confederation,
    required this.isPlayerRegion,
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
  if (isPlayerRegion &&
      await comp.hasTournament(
        key.careerId,
        CompetitionKind.continentalFinals,
      )) {
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
    knockout: knockout,
    champion: champion,
    scorers: scorers,
    honours: honours,
    nations: nations,
    playerNationId: career.nationId,
    playerNames: playerNames,
  );
});
