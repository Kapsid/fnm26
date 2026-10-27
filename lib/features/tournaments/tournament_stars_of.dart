import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/tournament_stars.dart';
import 'package:fnm/features/federation/career_pool.dart';

/// How deep each World Championship knockout round goes, for a nation's run.
const Map<String, int> worldChampionshipRoundDepth = {
  'R32': 1,
  'R16': 2,
  'QF': 3,
  'SF': 4,
  '3RD': 5,
  'FINAL': 5,
};

/// The same for a continental championship.
const Map<String, int> continentalRoundDepth = {
  'CR16': 1,
  'CQF': 2,
  'CSF': 3,
  'C3RD': 3,
  'CFINAL': 4,
};

/// A finished tournament's individual honours: the Team of the Tournament
/// (its first man is the Golden Ball) and the best keeper (the Golden Glove).
typedef TournamentStarsOf = ({List<StarPlayer> team, StarPlayer? keeper});

/// The ONE computation of a finished tournament's honours, shared by the
/// tournament screens (which show them) and the award service (which stores
/// them for the cabinet and the Player of the Year vote), so the two can
/// never disagree.
///
/// Everything is read off the competition itself, never off "this cycle":
/// the vote runs on 1 December, by which time a World Championship's cycle
/// has already turned over.
///
/// [knockout] is the tournament's knockout ties (round, home, away), each
/// scored through [roundDepth] into a nation's run. [fallbackGoals] supplies
/// the goals for an edition played before per-match ratings existed, which
/// has no lines to read them from.
///
/// With [stored] (the tournament's stored honours, see
/// [storedTournamentHonours]), the picks are THOSE: the team and the keeper
/// are rebuilt from the stored ids, with the numbers from the lines, so a
/// screen opened years later still names the men who were named when the
/// final was played, whatever re-rating has happened since. Without it they
/// are computed afresh (an edition finished before honours were stored).
Future<TournamentStarsOf> tournamentStarsOf(
  Ref ref,
  Career career, {
  required int competitionId,
  required Iterable<(String?, int, int)> knockout,
  required Map<String, int> roundDepth,
  required int? champion,
  Future<List<({int playerId, int nationId, int goals})>> Function()?
  fallbackGoals,
  List<PlayerAward> stored = const [],
}) async {
  final comp = ref.read(competitionRepositoryProvider);
  final runByNation = <int, int>{};
  for (final (round, home, away) in knockout) {
    final d = roundDepth[round] ?? 0;
    for (final nid in [home, away]) {
      if (d > (runByNation[nid] ?? 0)) runByNation[nid] = d;
    }
  }
  final lines = await comp.competitionPlayerLines(career.id, competitionId);
  final formByPlayer = {
    for (final l in lines)
      l.playerId: (apps: l.apps, meanRating: l.meanRating, motms: l.motms),
  };
  final cleanSheetsByPlayer = {
    for (final l in lines) l.playerId: l.cleanSheets,
  };
  final scorers = lines.isEmpty && fallbackGoals != null
      ? await fallbackGoals()
      : [
          for (final l in lines)
            if (l.goals > 0)
              (playerId: l.playerId, nationId: l.nationId, goals: l.goals),
        ];
  final goalsByPlayer = {for (final s in scorers) s.playerId: s.goals};
  final candidateNations = <int>{
    ...runByNation.keys,
    for (final s in scorers) s.nationId,
    for (final l in lines) l.nationId,
  };
  final candidates = <Player>[];
  for (final nid in candidateNations.toList()..sort()) {
    final squad = await careerPoolOf(
      ref,
      career,
      nid,
      // History: a man who retired since still played here.
      includeIntlRetired: true,
    );
    // Everyone who actually appeared — not the top sixteen by rating, which
    // both included players who never got on and excluded a squad player who
    // did.
    candidates.addAll(
      formByPlayer.isEmpty
          ? squad.take(16)
          : squad.where((p) => formByPlayer.containsKey(p.id)),
    );
  }
  if (stored.any((h) => h.kind == AwardKind.teamOfTournament)) {
    final byId = {for (final p in candidates) p.id: p};
    StarPlayer? star(int id) {
      final p = byId[id];
      if (p == null) return null;
      final f = formByPlayer[id];
      return StarPlayer(
        player: p,
        goals: goalsByPlayer[id] ?? 0,
        score: 0,
        apps: f?.apps ?? 0,
        meanRating: f?.meanRating ?? 0,
        motms: f?.motms ?? 0,
      );
    }

    int? idOf(AwardKind k) =>
        stored.where((h) => h.kind == k).map((h) => h.playerId).firstOrNull;
    final ball = idOf(AwardKind.goldenBall);
    final rest = [
      for (final h in stored)
        if (h.kind == AwardKind.teamOfTournament && h.playerId != ball)
          ?star(h.playerId),
    ]..sort((a, b) => b.meanRating.compareTo(a.meanRating));
    final glove = idOf(AwardKind.goldenGlove);
    return (
      team: [if (ball != null) ?star(ball), ...rest],
      keeper: glove == null ? null : star(glove),
    );
  }
  return (
    team: TournamentStars.teamOfTournament(
      candidates: candidates,
      goalsByPlayer: goalsByPlayer,
      runByNation: runByNation,
      champion: champion,
      formByPlayer: formByPlayer,
    ),
    keeper: TournamentStars.goldenGlove(
      candidates: candidates,
      formByPlayer: formByPlayer,
      cleanSheetsByPlayer: cleanSheetsByPlayer,
    ),
  );
}

/// [competition]'s stored individual honours for the edition whose final
/// was played in [year] (Golden Ball, Golden Boot, Golden Glove, Team of the
/// Tournament), or empty when they have not been stored.
Future<List<PlayerAward>> storedTournamentHonours(
  CompetitionRepository comp,
  int careerId, {
  required String competition,
  required int year,
}) async => [
  for (final h in await comp.playerHonoursForYear(careerId, year))
    if (h.competition == competition &&
        h.kind != AwardKind.playerOfYear &&
        h.kind != AwardKind.youngPlayerOfYear)
      h,
];
