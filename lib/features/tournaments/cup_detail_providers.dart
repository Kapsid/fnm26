import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/tournament_stars.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';

/// Data for the cup-detail (World Championship) screen.
class CupData {
  const CupData({
    required this.groups,
    required this.nations,
    required this.playerNationId,
    required this.playerConfederation,
    required this.finalsGroups,
    required this.knockout,
    required this.champion,
    required this.hostId,
    required this.scorersQualifying,
    required this.scorersFinals,
    required this.honours,
    required this.playerNames,
    this.hostIds = const [],
    this.teamOfTournament = const [],
    this.hostCities = const {},
    this.goldenGlove,
    this.qualDrawWatched = true,
    this.finalsDrawWatched = true,
  });

  /// The Golden Glove: the keeper of the finals' meanest defence (fewest goals
  /// conceded among the knockout sides), once the champion is decided.
  final ({int nationId, String name})? goldenGlove;

  /// Each host's real cities (biggest first), keyed by nation id, for the
  /// venues card. Keyed rather than flattened so a co-hosted tournament can
  /// show whose grounds are whose — and so one host can't consume the whole
  /// venue budget.
  final Map<int, List<String>> hostCities;

  /// Whether the player has watched the qualifying / finals draw ceremonies —
  /// the groups stay hidden ("to be drawn") until they have.
  final bool qualDrawWatched;
  final bool finalsDrawWatched;

  /// Every confederation's qualifying groups.
  final List<ConfederationGroupTable> groups;
  final Map<int, Nation> nations;
  final int playerNationId;
  final Confederation? playerConfederation;

  /// Finals group tables (empty until the finals are drawn).
  final List<FinalsGroupTable> finalsGroups;

  /// All finals knockout fixtures (empty until the bracket begins).
  final List<Fixture> knockout;

  /// The World Cup winner once decided.
  final int? champion;

  /// The host nation of this cycle's World Cup (known from the start of the
  /// cycle — the rotation is deterministic).
  final int? hostId;

  /// All hosts (primary + any co-hosts) of this cycle's World Cup.
  final List<int> hostIds;

  /// Top scorers in qualifying and in the finals.
  final List<ScorerTally> scorersQualifying;
  final List<ScorerTally> scorersFinals;

  /// Roll of honour (past champions), newest first.
  final List<Honour> honours;

  /// Names for any player id referenced by the scorer charts.
  final Map<int, String> playerNames;

  /// The Team of the Tournament (best XI), once the champion is decided.
  final List<StarPlayer> teamOfTournament;

  bool get hasFinals => finalsGroups.isNotEmpty;
}

/// Deepest knockout round each nation reached (0 = group stage only).
const _roundDepth = {
  'R32': 1,
  'R16': 2,
  'QF': 3,
  'SF': 4,
  '3RD': 5,
  'FINAL': 5,
};

final AutoDisposeFutureProviderFamily<CupData?, int> cupDetailProvider =
    FutureProvider.autoDispose.family<CupData?, int>((ref, careerId) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final comp = ref.watch(competitionRepositoryProvider);
      final groups = await comp.allGroupTablesByConfederation(careerId);
      final finalsGroups = await comp.finalsGroupTables(careerId);
      final knockout = await comp.finalsKnockoutFixtures(careerId);
      final champion = await comp.worldChampion(careerId);
      final scorersQualifying = await comp.topScorers(
        careerId,
        kind: CompetitionKind.worldCupQualifying,
        limit: 15,
      );
      final scorersFinals = await comp.topScorers(
        careerId,
        kind: CompetitionKind.worldCupFinals,
        limit: 15,
      );
      // The competition's full roll of honour — all past winners, including the
      // pre-seeded real-world history (career summary is the career-only view).
      final honours = await comp.honours(careerId);
      final nations = {
        for (final n in await ref.watch(nationRepositoryProvider).all())
          n.id: n,
      };

      final hostIds = WorldCupHosts.hostsFor(
        year: CareerService.worldCupYear(career.cyclePointer),
        nations: nations.values.toList(),
        seed: career.rngSeed,
      );
      final hostId = hostIds.first;
      final cityData = await ref.watch(countryCitiesProvider.future);
      // Venues span all hosts, each contributing its own cities.
      final hostCities = {
        for (final h in hostIds) h: cityData[h] ?? const <String>[],
      };

      final playerRepo = ref.watch(playerRepositoryProvider);
      final scorerIds = {
        for (final s in scorersQualifying) s.playerId,
        for (final s in scorersFinals) s.playerId,
      };
      final playerNames = <int, String>{};
      for (final id in scorerIds) {
        final p = await playerRepo.byId(id, saveSeed: career.rngSeed);
        if (p != null) playerNames[id] = p.name;
      }

      // Team of the Tournament — only once the champion is crowned.
      var teamOfTournament = const <StarPlayer>[];
      ({int nationId, String name})? goldenGlove;
      if (champion != null && knockout.isNotEmpty) {
        final runByNation = <int, int>{};
        for (final f in knockout) {
          final d = _roundDepth[f.round] ?? 0;
          for (final nid in [f.homeNationId, f.awayNationId]) {
            if (d > (runByNation[nid] ?? 0)) runByNation[nid] = d;
          }
        }

        // Golden Glove — the keeper of the meanest defence among the knockout
        // sides (goals conceded across the group stage and the knockouts).
        final concededByNation = <int, int>{
          for (final g in finalsGroups)
            for (final s in g.standings) s.nationId: s.goalsAgainst,
        };
        for (final f in knockout) {
          concededByNation
            ..update(
              f.homeNationId,
              (v) => v + (f.awayScore ?? 0),
              ifAbsent: () => f.awayScore ?? 0,
            )
            ..update(
              f.awayNationId,
              (v) => v + (f.homeScore ?? 0),
              ifAbsent: () => f.homeScore ?? 0,
            );
        }
        int? meanest;
        var fewest = 1 << 30;
        for (final nid in runByNation.keys) {
          final c = concededByNation[nid] ?? fewest;
          if (c < fewest) {
            fewest = c;
            meanest = nid;
          }
        }
        if (meanest != null) {
          final squad = await playerRepo.byNation(
            meanest,
            agingYears: CareerService.agingYears(career),
            saveSeed: career.rngSeed,
          );
          Player? keeper;
          for (final p in squad) {
            if (p.category == PositionCategory.goalkeeper) {
              keeper = p;
              break;
            }
          }
          if (keeper != null) {
            goldenGlove = (nationId: meanest, name: keeper.name);
          }
        }
        // Candidates: every nation that reached the knockout, plus the nations
        // of the finals' leading scorers (a group-stage golden boot counts).
        final allFinalsScorers = await comp.topScorers(
          careerId,
          kind: CompetitionKind.worldCupFinals,
          limit: 500,
        );
        final goalsByPlayer = {
          for (final s in allFinalsScorers) s.playerId: s.goals,
        };
        final candidateNations = <int>{
          for (final n in runByNation.keys) n,
          for (final s in allFinalsScorers) s.nationId,
        };
        final candidates = <Player>[];
        for (final nid in candidateNations) {
          final squad = await playerRepo.byNation(
            nid,
            agingYears: CareerService.agingYears(career),
            saveSeed: career.rngSeed,
          );
          candidates.addAll(squad.take(16)); // top 16 by overall
        }
        teamOfTournament = TournamentStars.teamOfTournament(
          candidates: candidates,
          goalsByPlayer: goalsByPlayer,
          runByNation: runByNation,
          champion: champion,
        );
      }

      final qualDrawWatched = await comp.hasWatchedDraw(
        careerId,
        career.cyclePointer,
        worldCupQualDrawKind,
      );
      final finalsDrawWatched = await comp.hasWatchedDraw(
        careerId,
        career.cyclePointer,
        worldCupDrawKind,
      );

      return CupData(
        groups: groups,
        nations: nations,
        playerNationId: career.nationId,
        playerConfederation: nations[career.nationId]?.confederation,
        finalsGroups: finalsGroups,
        knockout: knockout,
        champion: champion,
        hostId: hostId,
        hostIds: hostIds,
        scorersQualifying: scorersQualifying,
        scorersFinals: scorersFinals,
        honours: honours,
        playerNames: playerNames,
        teamOfTournament: teamOfTournament,
        hostCities: hostCities,
        goldenGlove: goldenGlove,
        qualDrawWatched: qualDrawWatched,
        finalsDrawWatched: finalsDrawWatched,
      );
    });
