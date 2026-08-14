import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/tournament_stars.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/qualification.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';
import 'package:fnm/domain/services/competition/tournament_identity.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart'
    show AllTimeScorer, CupPlayerRecord;

/// Identifies one continental championship within a save.
typedef ContinentalKey = ({int careerId, Confederation confederation});

/// Data for the continental-championship detail screen.
class ContinentalData {
  const ContinentalData({
    required this.name,
    required this.confederation,
    required this.isPlayerRegion,
    required this.hostCount,
    required this.qualifyingGroups,
    required this.groups,
    required this.knockout,
    this.groupFixtures = const [],
    required this.champion,
    required this.scorers,
    required this.honours,
    required this.nations,
    required this.playerNationId,
    required this.playerNames,
    this.allTimeScorers = const [],
    this.hostIds = const [],
    this.hostCities = const {},
    this.qualDrawWatched = true,
    this.finalsDrawWatched = true,
    this.identity,
    this.teamOfTournament = const [],
    this.goldenGlove,
    this.topGames = const [],
    this.topCups = const [],
    this.myNationIds = const {},
  });

  /// The edition's best XI and best goalkeeper (empty until it's decided).
  final List<StarPlayer> teamOfTournament;
  final ({int nationId, String name})? goldenGlove;

  /// This edition's mascot and match ball (null until the finals are drawn).
  final TournamentIdentity? identity;

  final String name;
  final Confederation confederation;

  /// Whether the player has watched the qualifying / finals draw ceremonies —
  /// the groups stay hidden ("to be drawn") until they have.
  final bool qualDrawWatched;
  final bool finalsDrawWatched;

  /// Every championship host (primary first), empty before it's decided.
  final List<int> hostIds;

  /// How many hosts (primary + co-hosts) auto-qualify — they reserve finals
  /// berths, so that many fewer teams come through qualifying.
  final int hostCount;

  /// Each host's real cities (biggest first), keyed by nation id, for the
  /// venues card.
  final Map<int, List<String>> hostCities;

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

  /// This cycle's finals group-stage fixtures (round 'CGROUP').
  final List<Fixture> groupFixtures;
  final int? champion;
  final List<ScorerTally> scorers;

  /// All-time scorers of THIS continental championship across every cycle,
  /// with names and an active flag — the cup's own record, like the World Cup.
  final List<AllTimeScorer> allTimeScorers;

  /// Past editions of this championship, newest first.
  final List<Honour> honours;
  final Map<int, Nation> nations;
  final int playerNationId;
  final Map<int, String> playerNames;

  /// All-time player leaderboards for this continental cup, most first (up to
  /// ten): most matches played, and most editions attended. Empty before there
  /// is any history.
  final List<CupPlayerRecord> topGames;
  final List<CupPlayerRecord> topCups;

  /// Every nation the manager has led (current + past stints), for highlighting
  /// their record-holders in the leaderboards.
  final Set<int> myNationIds;
}

/// The continental knockout rounds in bracket order.
const _rounds = ['CR16', 'CQF', 'CSF', 'CFINAL'];

/// The drawn continental group stage, for the pot-draw ceremony.
class ContinentalDrawData {
  const ContinentalDrawData({
    required this.draw,
    required this.nations,
    required this.playerNationId,
  });
  final FinalsDraw draw;
  final Map<int, Nation> nations;

  /// The player's nation, highlighted throughout the ceremony.
  final int playerNationId;
}

/// Recomputes the player's continental group draw deterministically (same seed
/// and qualifiers as creation) so the ceremony matches the stored groups.
/// Returns null when the player's region isn't contesting a finals this cycle.
final AutoDisposeFutureProviderFamily<ContinentalDrawData?, ContinentalKey>
continentalDrawProvider = FutureProvider.autoDispose.family<ContinentalDrawData?, ContinentalKey>((
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
  if (all.firstWhere((n) => n.id == career.nationId).confederation !=
      key.confederation) {
    return null;
  }
  // The pots use the live ranking snapshotted when the continental finals draw
  // was generated (post-qualifying), so the ceremony reproduces the real pots.
  final rankById = await ref.watch(
    seedRankByIdProvider((
      careerId: key.careerId,
      cycle: drawSeedCycle(career.cyclePointer, drawSlotContinentalFinals),
    )).future,
  );
  int rankOf(Nation n) => rankById[n.id] ?? n.ranking;

  // Mirror _generateContinentalFinals EXACTLY so the shown draw matches the
  // played tournament: for a qualifying cup the hosts auto-qualify and reserve
  // a berth each (so only size − hosts come through qualifying), and are then
  // appended. A no-qualifying cup (Copa) has no host reservation — its field is
  // the top `size` by ranking, as the calendar builder creates it. Getting this
  // wrong showed a cutoff qualifier in the draw that the real field then dropped.
  final hosts = config.qualifying
      ? WorldCupHosts.continentalHostsFor(
          confederation: key.confederation,
          cycle: career.cyclePointer,
          seed: career.rngSeed,
          nations: all,
        )
      : const <int>[];
  final berths = (config.size - hosts.length).clamp(1, config.size);
  List<int> qualifierIds;
  // Named confederation throughout: every confederation runs its own qualifying
  // campaign now, and this screen may be showing any of them.
  if (await comp.hasTournament(
        key.careerId,
        CompetitionKind.continentalQualifying,
        confederation: key.confederation,
      ) &&
      await comp.allPlayedForKind(
        key.careerId,
        CompetitionKind.continentalQualifying,
        confederation: key.confederation,
      )) {
    final tables = await comp.tournamentGroupTables(
      key.careerId,
      CompetitionKind.continentalQualifying,
      confederation: key.confederation,
    );
    qualifierIds = Qualification.qualifiers(
      tables.map((t) => t.standings).toList(),
      berths,
    );
  } else {
    final members =
        all.where((n) => n.confederation == key.confederation).toList()
          ..sort((a, b) => rankOf(a).compareTo(rankOf(b)));
    qualifierIds = members.take(berths).map((n) => n.id).toList();
  }
  if (qualifierIds.length < berths) return null;

  final field = [
    ...qualifierIds,
    for (final h in hosts)
      if (!qualifierIds.contains(h)) h,
  ].take(config.size).toList();

  final draw = WorldCupFinals.drawGroups(
    qualifierIds: field,
    rankingById: {for (final n in all) n.id: rankOf(n)},
    rngSeed: career.rngSeed ^ (career.cyclePointer * 0x71) ^ 0xC0FF,
    hosts: hosts,
    perGroup: config.groupSize,
  );
  return ContinentalDrawData(
    draw: draw,
    nations: {for (final n in all) n.id: n},
    playerNationId: career.nationId,
  );
});

/// Recomputes the continental qualifying group draw deterministically (same
/// seed and members as creation), for the qualifying draw ceremony. Returns
/// null when the player's region has no qualifying this cycle.
final AutoDisposeFutureProviderFamily<ContinentalDrawData?, ContinentalKey>
continentalQualifyingDrawProvider = FutureProvider.autoDispose
    .family<ContinentalDrawData?, ContinentalKey>((
      ref,
      key,
    ) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref
          .watch(careerRepositoryProvider)
          .byId(key.careerId);
      if (career == null) return null;
      if (ContinentalCups.byConfederation[key.confederation] == null)
        return null;

      final comp = ref.watch(competitionRepositoryProvider);
      if (!await comp.hasTournament(
        key.careerId,
        CompetitionKind.continentalQualifying,
        confederation: key.confederation,
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
      // The one shared definition of who is in the draw — see
      // [WorldCupHosts.continentalQualifiers].
      final members = WorldCupHosts.continentalQualifiers(
        confederation: key.confederation,
        cycle: career.cyclePointer,
        seed: career.rngSeed,
        nations: all,
      );
      final schedule = const ScheduleGenerator().generate(
        confederation: key.confederation,
        nations: members,
        rngSeed: career.rngSeed ^ (career.cyclePointer * 0x71) ^ 0xCAFE,
        start: DateTime(CareerService.cycleStart.year, 9),
        // Must match the played schedule (career_providers buildCalendar) so the
        // ceremony's groups are the real ones — groups of six, not four.
        groupSize: 6,
        rankById: rankById,
      );
      return ContinentalDrawData(
        draw: FinalsDraw(
          groups: [
            for (final g in schedule.groups)
              FinalsGroupDraw(
                name: g.name,
                nationIds: g.nationIds,
                fixtures: [],
              ),
          ],
        ),
        nations: {for (final n in all) n.id: n},
        playerNationId: career.nationId,
      );
    });

final AutoDisposeFutureProviderFamily<ContinentalData?, ContinentalKey>
continentalDetailProvider = FutureProvider.autoDispose.family<ContinentalData?, ContinentalKey>((
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

  // The player's region runs qualifying live; every region's FINALS now exist
  // as real fixtures (the player's day by day, the rest simulated in the
  // background), so a region's groups, bracket and scorers are shown once its
  // cup has been drawn — not only the player's.
  final knockout = <Fixture>[];
  final groupFixtures = <Fixture>[];
  var groups = <FinalsGroupTable>[];
  var qualifyingGroups = <FinalsGroupTable>[];
  // Every confederation qualifies for its own cup now, so the qualifying tables
  // are shown for whichever continent this screen is on — not only the
  // manager's, which was the only one that used to have any.
  qualifyingGroups = await comp.tournamentGroupTables(
    key.careerId,
    CompetitionKind.continentalQualifying,
    confederation: key.confederation,
  );
  if (await comp.hasTournament(
    key.careerId,
    CompetitionKind.continentalFinals,
    confederation: key.confederation,
  )) {
    groups = await comp.tournamentGroupTables(
      key.careerId,
      CompetitionKind.continentalFinals,
      confederation: key.confederation,
    );
    groupFixtures.addAll(
      await comp.fixturesByRound(
        key.careerId,
        'CGROUP',
        kind: CompetitionKind.continentalFinals,
        confederation: key.confederation,
      ),
    );
    for (final round in _rounds) {
      knockout.addAll(
        await comp.fixturesByRound(
          key.careerId,
          round,
          kind: CompetitionKind.continentalFinals,
          confederation: key.confederation,
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

  final scorers = groups.isNotEmpty || knockout.isNotEmpty
      ? await comp.topScorers(
          key.careerId,
          kind: CompetitionKind.continentalFinals,
          confederation: key.confederation,
          limit: 15,
        )
      : const <ScorerTally>[];

  // The competition's full roll of honour — all past winners, including the
  // pre-seeded real-world history.
  final allHonours = await comp.honours(key.careerId);
  final honours = allHonours.where((h) => h.competition == config.name).toList()
    ..sort((a, b) => b.year.compareTo(a.year));

  final playerRepo = ref.watch(playerRepositoryProvider);
  final aging = CareerService.agingYears(career);
  final youth = await ref.watch(youthBonusByCycleProvider(key.careerId).future);
  final careerDev = await ref.watch(
    careerDevBonusProvider(key.careerId).future,
  );

  // Per-player all-time records for THIS continental cup: most matches played
  // and most finals tournaments attended, each resolved to the holder's name.
  final cupRecords = await comp.playerCupRecords(
    key.careerId,
    kind: CompetitionKind.continentalFinals,
    confederation: key.confederation,
  );
  // The top ten by a chosen count (games or editions), holders resolved to
  // their names — so the records tab can show a leaderboard, not just the leader.
  Future<List<CupPlayerRecord>> topRecords(
    int Function(({int playerId, int nationId, int games, int finals})) key,
  ) async {
    final ranked = cupRecords.where((r) => key(r) > 0).toList()
      ..sort((a, b) => key(b).compareTo(key(a)));
    final out = <CupPlayerRecord>[];
    for (final r in ranked.take(10)) {
      final p = await playerRepo.byId(
        r.playerId,
        agingYears: aging,
        saveSeed: career.rngSeed,
        youthBonusByCycle: youth,
        careerStartsByPlayer: careerDev,
      );
      out.add((
        playerId: r.playerId,
        name: p?.name ?? 'Unknown',
        nationId: r.nationId,
        count: key(r),
      ));
    }
    return out;
  }

  final topGames = await topRecords((r) => r.games);
  final topCups = await topRecords((r) => r.finals);
  final playerNames = <int, String>{};
  for (final id in {for (final s in scorers) s.playerId}) {
    final p = await playerRepo.byId(
      id,
      agingYears: aging,
      saveSeed: career.rngSeed,
      youthBonusByCycle: youth,
      careerStartsByPlayer: careerDev,
    );
    if (p != null) playerNames[id] = p.name;
  }

  // The edition's honours — Team of the Tournament + Golden Glove — computed
  // exactly like the World Cup's, scoped to this continental finals.
  var teamOfTournament = const <StarPlayer>[];
  ({int nationId, String name})? goldenGlove;
  // Only once every match of the tournament has been played — see the same
  // gate on the World Cup's detail provider.
  if (champion != null &&
      knockout.isNotEmpty &&
      TournamentStars.isComplete([...groupFixtures, ...knockout])) {
    const roundDepth = {'CR16': 1, 'CQF': 2, 'CSF': 3, 'C3RD': 3, 'CFINAL': 4};
    final runByNation = <int, int>{};
    for (final f in knockout) {
      final d = roundDepth[f.round] ?? 0;
      for (final nid in [f.homeNationId, f.awayNationId]) {
        if (d > (runByNation[nid] ?? 0)) runByNation[nid] = d;
      }
    }
    // How everyone actually played, so the awards are earned rather than
    // assumed — see `TournamentStars`.
    final lines = await comp.competitionPlayerLines(
      key.careerId,
      knockout.first.competitionId,
    );
    final formByPlayer = {
      for (final l in lines)
        l.playerId: (apps: l.apps, meanRating: l.meanRating, motms: l.motms),
    };
    final cleanSheetsByPlayer = {
      for (final l in lines) l.playerId: l.cleanSheets,
    };

    // Golden Glove fallback for an edition with no rating data: the keeper of
    // the meanest defence among the knockout sides.
    final concededByNation = <int, int>{
      for (final g in groups)
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
        agingYears: aging,
        saveSeed: career.rngSeed,
      );
      final keeper = squad
          .where((p) => p.category == PositionCategory.goalkeeper)
          .firstOrNull;
      if (keeper != null) goldenGlove = (nationId: meanest, name: keeper.name);
    }
    final allFinalsScorers = await comp.topScorers(
      key.careerId,
      kind: CompetitionKind.continentalFinals,
      confederation: key.confederation,
      limit: 500,
    );
    final goalsByPlayer = {
      for (final s in allFinalsScorers) s.playerId: s.goals,
    };
    final candidateNations = <int>{
      ...runByNation.keys,
      for (final s in allFinalsScorers) s.nationId,
      for (final l in lines) l.nationId,
    };
    final candidates = <Player>[];
    for (final nid in candidateNations) {
      final squad = await playerRepo.byNation(
        nid,
        agingYears: aging,
        saveSeed: career.rngSeed,
      );
      candidates.addAll(
        formByPlayer.isEmpty
            ? squad.take(16)
            : squad.where((p) => formByPlayer.containsKey(p.id)),
      );
    }
    teamOfTournament = TournamentStars.teamOfTournament(
      candidates: candidates,
      goalsByPlayer: goalsByPlayer,
      runByNation: runByNation,
      champion: champion,
      formByPlayer: formByPlayer,
    );
    final bestKeeper = TournamentStars.goldenGlove(
      candidates: candidates,
      formByPlayer: formByPlayer,
      cleanSheetsByPlayer: cleanSheetsByPlayer,
    );
    if (bestKeeper != null) {
      goldenGlove = (nationId: bestKeeper.nationId, name: bestKeeper.name);
    }
  }

  // This championship's own all-time scorers across every cycle (scoped to the
  // region), each with a name and whether they're still playing.
  final allTimeTally = await comp.allTimeTopScorers(
    key.careerId,
    kind: CompetitionKind.continentalFinals,
    confederation: key.confederation,
    limit: 30,
  );
  final allTimeScorers = <AllTimeScorer>[];
  for (final s in allTimeTally) {
    final p = await playerRepo.byId(
      s.playerId,
      agingYears: aging,
      saveSeed: career.rngSeed,
      youthBonusByCycle: youth,
      careerStartsByPlayer: careerDev,
    );
    allTimeScorers.add((
      playerId: s.playerId,
      nationId: s.nationId,
      name: p?.name ?? 'Unknown',
      goals: s.goals,
      active: p != null && p.age < PlayerLifecycle.retirementAge,
    ));
  }

  // Every host, primary first. The co-hosts used to be fetched only to be
  // counted for the berth maths and then thrown away, so a jointly-hosted
  // championship showed one country's grounds.
  final allHosts = WorldCupHosts.continentalHostsFor(
    confederation: key.confederation,
    cycle: career.cyclePointer,
    seed: career.rngSeed,
    nations: nations.values.toList(),
  );
  final hostCount = allHosts.length;

  // Only reveal the player's own groups/host once the relevant draw was watched.
  // A background region (not the player's own) has nothing to "watch", so its
  // finals count as drawn immediately.
  final qualDrawWatched =
      !isPlayerRegion ||
      await comp.hasWatchedDraw(
        key.careerId,
        career.cyclePointer,
        continentalQualDrawKind,
      );
  final finalsDrawWatched =
      !isPlayerRegion ||
      await comp.hasWatchedDraw(
        key.careerId,
        career.cyclePointer,
        continentalFinalsDrawKind,
      );

  // The host and its stadiums show for ANY drawn edition, not just the player's
  // own region — the host is deterministic per edition, so a background cup
  // (e.g. AFCON when you manage elsewhere) gets a full summary rather than a
  // lone trophy. Gated on the HOST-selection ceremony (earlier than the finals
  // draw) so the player's own host appears as soon as it's revealed (a
  // background region is always "drawn").
  final hostDrawWatched =
      !isPlayerRegion ||
      await comp.hasWatchedDraw(
        key.careerId,
        career.cyclePointer,
        continentalHostDrawKind,
      );
  // NOT gated on the finals groups existing. It used to be, which meant the
  // continental championship had no summary at all until its finals draw — the
  // one tournament in the game where the host, its cities and its stadiums
  // stayed hidden through the entire qualifying campaign, while the World Cup
  // showed all of it from the moment its host was revealed. The host is
  // deterministic per edition and already public once its ceremony is watched,
  // so there is nothing to hold back.
  final hostIds = hostDrawWatched ? allHosts : const <int>[];
  final cities = await ref.watch(countryCitiesProvider.future);
  final hostCities = {
    for (final h in hostIds) h: cities[h] ?? const <String>[],
  };

  return ContinentalData(
    name: config.name,
    confederation: key.confederation,
    isPlayerRegion: isPlayerRegion,
    hostIds: hostIds,
    hostCount: hostCount,
    qualifyingGroups: qualifyingGroups,
    groups: groups,
    knockout: knockout,
    groupFixtures: groupFixtures,
    champion: champion,
    scorers: scorers,
    allTimeScorers: allTimeScorers,
    honours: honours,
    topGames: topGames,
    topCups: topCups,
    myNationIds: {
      career.nationId,
      ...(await ref.watch(careerRepositoryProvider).stints(key.careerId))
          .values,
    },
    nations: nations,
    playerNationId: career.nationId,
    playerNames: playerNames,
    hostCities: hostCities,
    qualDrawWatched: qualDrawWatched,
    finalsDrawWatched: finalsDrawWatched,
    identity: (groups.isEmpty || hostIds.isEmpty)
        ? null
        : TournamentBranding.forEdition(
            hostName: nations[hostIds.first]?.name ?? 'Host',
            year: CareerService.worldCupYear(career.cyclePointer) - 2,
            seed: career.rngSeed,
          ),
    teamOfTournament: teamOfTournament,
    goldenGlove: goldenGlove,
  );
});
