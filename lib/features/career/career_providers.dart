import 'package:fnm/features/career/play_time.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/result/result.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/competition/real_history.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/features/hub/hub_event.dart' show worldCupQualDrawKind;

/// All save games, most recent first (seeding the DB first if needed).
final savesProvider = FutureProvider<List<Career>>((ref) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  return ref.watch(careerRepositoryProvider).all();
});

/// A nation by id — used by the new-game and hub screens for display.
final FutureProviderFamily<Nation?, int> nationByIdProvider =
    FutureProvider.family<Nation?, int>((ref, id) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      return ref.watch(nationRepositoryProvider).byId(id);
    });

/// A single career by id.
final FutureProviderFamily<Career?, int> careerByIdProvider =
    FutureProvider.family<Career?, int>(
      (ref, id) => ref.watch(careerRepositoryProvider).byId(id),
    );

/// Creates and deletes save games, enforcing the slot limit.
class CareerService {
  CareerService(this._ref);

  final Ref _ref;

  /// The save opens in July 2026 (pre-season); the first qualifiers kick off in
  /// the September international window.
  static final DateTime cycleStart = DateTime(2026, 7);

  /// The World Cup year for a given cycle (clean cadence: 2030, 2034, …).
  static int worldCupYear(int cycle) => cycleStart.year + 4 * (cycle + 1);

  /// The month a year of development lands on. December, not January.
  ///
  /// The African and Asian championships are played in JANUARY (see
  /// [ContinentalCups]), so a calendar-year boundary re-rated the entire squad
  /// in the middle of those managers' own finals: a side that reached the
  /// semi-final was not the side that had come through the group. Ticking on 1
  /// December moves it into the gap between the November qualifying window and
  /// those finals, where no competition is being played.
  static const int developmentMonth = 12;

  /// Elapsed in-game years since the save began — how much to age the player
  /// pool, so squads evolve one season at a time as the calendar advances.
  ///
  /// Counted off [developmentMonth], so each tick falls between competitions
  /// rather than inside one.
  static int agingYears(Career c) {
    final d = c.inGameDate;
    final years =
        d.year - cycleStart.year + (d.month >= developmentMonth ? 1 : 0);
    return years.clamp(0, 400);
  }

  /// Creates a new save for [nationId], or a failure if all slots are in use.
  Future<Result<Career>> create({
    required int nationId,
    required String managerName,
  }) async {
    final repo = _ref.read(careerRepositoryProvider);
    final premium = _ref.read(premiumUnlockedProvider);
    final existing = await repo.all();
    final limit = maxSaveSlots(premiumUnlocked: premium);

    if (existing.length >= limit) {
      return Result.failure(
        Failure('All $limit save slots are in use.', code: 'slots_full'),
      );
    }

    final name = managerName.trim().isEmpty ? 'Manager' : managerName.trim();
    final career = await repo.create(
      managerName: name,
      nationId: nationId,
      rngSeed: _seed(),
      startDate: cycleStart,
    );
    await repo.recordStint(career.id, 0, nationId);
    final nations = await _ref.read(nationRepositoryProvider).all();
    // Endow the federation with an opening balance sized to its world standing
    // (a mid-table default if the nation isn't in the reference set).
    final rankById = {for (final n in nations) n.id: n.ranking};
    await repo.setBudget(
      career.id,
      FederationFinance.initialBudget(rankById[nationId] ?? 100),
    );
    // Seed the Nations Cup ladder from the world ranking, once — from here it
    // only moves by promotion/relegation.
    final tiers = NationsCup.seedTiers(nations, (n) => n.ranking);
    await repo.setNationsCupTiers(career.id, tiers);
    await buildCalendar(
      comp: _ref.read(competitionRepositoryProvider),
      nations: nations,
      careerId: career.id,
      nationId: career.nationId,
      rngSeed: career.rngSeed,
      cycle: 0,
      cycleStart: career.inGameDate,
      wcYear: worldCupYear(0),
      nationsCupTiers: tiers,
    );
    await _generateDefaultTactic(career);
    await _seedHistory(career);
    _ref.invalidate(savesProvider);
    return Result.success(career);
  }

  /// Builds a cycle's whole calendar in real-world order: the player's
  /// continental qualifying opens the cycle (autumn of the start year), the
  /// continental finals follow two years before the World Cup, then World Cup
  /// qualifying for every confederation runs into the WC year, with friendlies
  /// filling every empty international window. Shared by creation + rollover.
  static Future<void> buildCalendar({
    required CompetitionRepository comp,
    required List<Nation> nations,
    required int careerId,
    required int nationId,
    required int rngSeed,
    required int cycle,
    required DateTime cycleStart,
    required int wcYear,

    /// The frozen seeding ranking for this cycle (nationId → world position).
    /// Null seeds by the static seed ranking (used for the opening cycle).
    Map<int, int>? rankById,

    /// The persisted Nations Cup league of each nation (nationId → tier). Empty
    /// falls back to a ranking seed (the first cup / an un-laddered nation).
    Map<int, int> nationsCupTiers = const {},
  }) async {
    if (!nations.any((n) => n.id == nationId)) return; // nothing to schedule
    final me = nations.firstWhere((n) => n.id == nationId);
    int rankOf(Nation n) => rankById?[n.id] ?? n.ranking;
    final byConfederation = <Confederation, List<Nation>>{};
    for (final n in nations) {
      (byConfederation[n.confederation] ??= []).add(n);
    }

    // 1. Continental qualifying opens the cycle (autumn of the start year). The
    //    finals are drawn from the qualifiers two years before the World Cup.
    //
    //    EVERY confederation gets its championship, not just the manager's. The
    //    rest of the world used to have none at all, so no goal, cap or cup was
    //    ever recorded outside the continent the manager happened to be working
    //    in — the all-time world records were really one continent's records,
    //    and the Continental Clash could not be staged unless the manager was
    //    European or South American.
    //
    //    Only the manager's own confederation runs a qualifying campaign; the
    //    others seed their field straight from the ranking. That keeps the
    //    world's cups real (they are drawn, played and won) without adding five
    //    more qualifying campaigns' worth of background fixtures per cycle.
    for (final confederation in Confederation.values) {
      final cont = ContinentalCups.byConfederation[confederation];
      if (cont == null) continue;
      final contFinalsStart = DateTime(wcYear - 2, cont.month, 8);
      final members = (byConfederation[confederation] ?? <Nation>[]).toList()
        ..sort((a, b) => rankOf(a).compareTo(rankOf(b)));
      // The hosts (primary + any co-hosts) auto-qualify and sit out qualifying
      // (playing only friendlies in those windows), so drop them from the draw.
      final contHosts = WorldCupHosts.continentalHostsFor(
        confederation: confederation,
        cycle: cycle,
        seed: rngSeed,
        nations: nations,
      ).toSet();
      // Who is in the qualifying draw is asked in three places (here, and the
      // two screens that recompute the draw for display), so it is answered in
      // exactly one — see [WorldCupHosts.continentalQualifiers].
      final contField = {
        for (final n in WorldCupHosts.continentalQualifiers(
          confederation: confederation,
          cycle: cycle,
          seed: rngSeed,
          nations: nations,
        ))
          n.id,
      };
      // A confederation with no qualifying (Copa América) seeds its finals
      // field straight from the ranking; only qualifying confederations run a
      // group stage first.
      //
      // EVERY qualifying confederation runs its campaign, not just the
      // manager's. The rest of the world used to have its finals field seeded
      // off the ranking instead, so the continent the manager happened to work
      // in played a whole extra ten-matchday competition every cycle that
      // nobody else did — and the all-time world records were really a chart
      // of that one continent. It also meant no other continent's cup was ever
      // WON by a side that had to earn its place in it.
      if (cont.qualifying && members.length > cont.size) {
        final cq = const ScheduleGenerator().generate(
          confederation: confederation,
          nations: members.where((n) => contField.contains(n.id)).toList(),
          rngSeed: rngSeed ^ (cycle * 0x71) ^ 0xCAFE,
          start: DateTime(cycleStart.year, 9),
          // Groups of six (ten matchdays) spread qualifying across the first
          // season instead of finishing in three months, so friendlies fall
          // into shorter gaps between phases rather than one long block.
          groupSize: 6,
          rankById: rankById,
        );
        await comp.saveSchedule(
          careerId: careerId,
          schedule: GeneratedSchedule(
            confederation: confederation,
            name: '${cont.name} Qualifiers',
            groups: cq.groups,
          ),
          cycle: cycle,
          kind: CompetitionKind.continentalQualifying,
          fixtureRound: 'CQ',
        );
      } else if (members.length >= (cont.qualifying ? cont.size : 4)) {
        // No group-stage qualifying — a Copa-style all-in cup, a qualifying
        // confederation already down to its finals size, or another continent's
        // cup running in the background. Seed the finals field straight from
        // the ranking, and ALWAYS create it (even if the player didn't make the
        // field) so it's played out and can be followed rather than silently
        // vanishing. The hosts head the field: they qualify automatically.
        final seeded = [
          for (final n in members)
            if (contHosts.contains(n.id)) n,
          for (final n in members)
            if (!contHosts.contains(n.id)) n,
        ];
        final draw = WorldCupFinals.drawGroups(
          qualifierIds: seeded.take(cont.size).map((n) => n.id).toList(),
          rankingById: {for (final n in nations) n.id: rankOf(n)},
          rngSeed:
              rngSeed ^ (cycle * 0x71) ^ 0xC0FF ^ (confederation.index * 7),
          perGroup: cont.groupSize,
        );
        await comp.saveTournamentGroups(
          careerId: careerId,
          cycle: cycle,
          confederation: confederation,
          kind: CompetitionKind.continentalFinals,
          name: cont.name,
          draw: draw,
          groupStart: contFinalsStart,
          round: 'CGROUP',
        );
      }
    }

    // 1c. The Nations Cup runs AFTER the continental finals and before the
    //     World Cup — the real Nations League slot. It is a EUROPEAN
    //     competition only (like the real Nations League): Europe plays as a
    //     persistent ladder of leagues (League A, B, C…), each four groups of
    //     four home & away. Every league is played so the whole ladder moves;
    //     League A's group winners contest a Finals Four for the title. The
    //     ladder is seeded from the ranking only for the first cup and then
    //     changes solely by promotion/relegation (see [nationsCupTiers]).
    if (me.confederation == Confederation.europe) {
      final members = (byConfederation[me.confederation] ?? <Nation>[]).toList()
        ..sort((a, b) => rankOf(a).compareTo(rankOf(b)));
      // Effective ladder: the saved tiers, or a ranking seed for the first cup.
      var tiers = nationsCupTiers;
      if (tiers.isEmpty || !members.any((n) => tiers.containsKey(n.id))) {
        tiers = NationsCup.seedTiers(nations, rankOf);
      }
      // EVERY league is played out (real, persistent promotion/relegation for
      // the whole ladder). Groups are named with a league prefix ('B2' = League
      // B, group 2) so each league's results can be read back at rollover.
      final byTier = <int, List<Nation>>{};
      for (final n in members) {
        (byTier[tiers[n.id] ?? 0] ??= []).add(n);
      }
      final allGroups = <GeneratedGroup>[];
      for (final tier in byTier.keys.toList()..sort()) {
        final league = byTier[tier]!;
        if (league.length < 4) continue; // too small for a group stage
        final gen = const ScheduleGenerator().generate(
          confederation: me.confederation,
          nations: league,
          rngSeed: rngSeed ^ (cycle * 0x71) ^ 0x5A17 ^ (tier * 0x9E37),
          // Autumn of the continental-finals year (wcYear − 2), after the
          // summer finals — the real Nations League slot before the World Cup.
          start: DateTime(wcYear - 2, 9),
          groupSize: 4,
          rankById: rankById,
        );
        final letter = NationsCup.leagueLetter(tier);
        for (var i = 0; i < gen.groups.length; i++) {
          allGroups.add(
            GeneratedGroup(
              name:
                  '$letter${i + 1}', // 'A1'..'A4', 'B1'..'B4', … encodes league
              nationIds: gen.groups[i].nationIds,
              fixtures: gen.groups[i].fixtures,
            ),
          );
        }
      }
      if (allGroups.isNotEmpty) {
        await comp.saveSchedule(
          careerId: careerId,
          schedule: GeneratedSchedule(
            confederation: me.confederation,
            name: 'Nations Cup',
            groups: allGroups,
          ),
          cycle: cycle,
          kind: CompetitionKind.nationsLeague,
          fixtureRound: 'NGROUP',
        );
      }
    }

    // Friendlies are no longer auto-scheduled: the manager arranges 1–3 of them
    // per gap between competitive blocks, from the hub's "Arrange friendlies"
    // event (see friendliesProvider / FriendliesScreen).
  }

  /// The month of the World Cup year − 1 in which every confederation's
  /// qualifying campaign is drawn.
  ///
  /// Qualifying is drawn LAZILY, not with the rest of the cycle's calendar.
  /// Writing it up front meant the World Cup's groups existed from the cycle's
  /// first day — months before the continental championship that is supposed to
  /// come first had even been played — so the calendar read back to front and
  /// the qualifying "draw" was a replay of fixtures that had been sitting in
  /// the database all along. January is comfortably after the last continental
  /// final (June of wcYear − 2) and comfortably before qualifying kicks off in
  /// March.
  static const int wcQualifyingDrawMonth = 1;

  /// Whether [date] has reached the point in the cycle at which World Cup
  /// qualifying is drawn.
  static bool wcQualifyingDue(DateTime date, int wcYear) =>
      !date.isBefore(DateTime(wcYear - 1, wcQualifyingDrawMonth));

  /// Draws World Cup qualifying for every confederation, the back half of the
  /// cycle: it starts the spring AFTER the Nations Cup (which fills the autumn
  /// of wcYear − 2), so the calendar reads Euro → Nations Cup → WC qualifying →
  /// World Cup rather than qualifying overlapping the cup.
  ///
  /// The caller must check the competitions do not already exist.
  static Future<void> buildWorldCupQualifying({
    required CompetitionRepository comp,
    required List<Nation> nations,
    required int careerId,
    required int nationId,
    required int rngSeed,
    required int cycle,
    required int wcYear,
    Map<int, int>? rankById,
  }) async {
    if (!nations.any((n) => n.id == nationId)) return;
    final me = nations.firstWhere((n) => n.id == nationId);
    final byConfederation = <Confederation, List<Nation>>{};
    for (final n in nations) {
      (byConfederation[n.confederation] ??= []).add(n);
    }
    final wcQualStart = DateTime(wcYear - 1, 3);
    // Hosts auto-qualify and skip qualifying (friendlies only), so drop them
    // from every confederation's qualifying pool.
    final wcHostIds = WorldCupHosts.worldCupHostIds(
      year: wcYear,
      nations: nations,
      seed: rngSeed,
    );
    for (final entry in byConfederation.entries) {
      final quals = entry.value
          .where((n) => !wcHostIds.contains(n.id))
          .toList();
      if (quals.length < 2) continue;
      final schedule = const ScheduleGenerator().generate(
        confederation: entry.key,
        nations: quals,
        rngSeed: rngSeed ^ (cycle * 0x1B3D) ^ (entry.key.index * 0x9E37),
        start: wcQualStart,
        rankById: rankById,
      );
      await comp.saveSchedule(
        careerId: careerId,
        // Name it for the competition, not the confederation — otherwise the
        // hub labels the player's World Cup qualifying group "Europe".
        schedule: GeneratedSchedule(
          confederation: entry.key,
          name: 'World Cup Qualifiers',
          groups: schedule.groups,
        ),
        cycle: cycle,
      );
      // A single-group campaign (CONMEBOL — everyone plays everyone) has
      // nothing to draw, so mark the player's qualifying draw as already
      // watched and skip the ceremony.
      if (entry.key == me.confederation && schedule.groups.length <= 1) {
        await comp.markDrawWatched(careerId, cycle, worldCupQualDrawKind);
      }
    }
  }

  /// Seeds real World Cup / Euro / Copa history so the records section is
  /// populated from day one. Country-level facts only — no player names.
  Future<void> _seedHistory(Career career) async {
    final nations = await _ref.read(nationRepositoryProvider).all();
    final idByName = {for (final n in nations) n.name: n.id};
    int? resolve(String? name) {
      if (name == null) return null;
      return idByName[name] ?? idByName[RealHistory.aliases[name] ?? name];
    }

    final compRepo = _ref.read(competitionRepositoryProvider);
    for (final e in RealHistory.editions) {
      final champion = resolve(e.champion);
      final runnerUp = resolve(e.runnerUp);
      if (champion == null || runnerUp == null) continue; // skip if unmapped
      // Continental cups share the bronze between both beaten semi-finalists
      // (no third-place match), so those editions carry two bronzes here; all
      // others fall back to the single third-place team on the edition itself.
      final shared =
          RealHistory.continentalBronzes['${e.competition}|${e.year}'];
      await compRepo.recordHonour(
        careerId: career.id,
        year: e.year,
        competition: e.competition,
        championId: champion,
        runnerUpId: runnerUp,
        thirdId: shared != null ? resolve(shared.$1) : resolve(e.third),
        thirdId2: shared != null ? resolve(shared.$2) : null,
        hostId: resolve(e.host),
        finalHomeScore: e.finalHome,
        finalAwayScore: e.finalAway,
      );
    }
  }

  /// Picks a sensible starting XI (best players in a 4-3-3) so a new save is
  /// immediately playable.
  Future<void> _generateDefaultTactic(Career career) async {
    final players = await _ref
        .read(playerRepositoryProvider)
        .byNation(
          career.nationId,
          agingYears: CareerService.agingYears(career),
          saveSeed: career.rngSeed,
        );
    const formation = Formation.f433;
    await _ref
        .read(tacticsRepositoryProvider)
        .saveTactic(
          career.id,
          Tactic(formation: formation, lineup: bestEleven(formation, players)),
        );
  }

  /// Records that a save was just opened, so the saves list can show "last
  /// played" and put the most recent one first — and starts the clock that
  /// counts how long it is played for.
  Future<void> markPlayed(int id) async {
    await _ref.read(careerRepositoryProvider).touch(id, DateTime.now());
    _ref.read(playTimeTrackerProvider).start(id);
    _ref.invalidate(savesProvider);
  }

  /// Deletes a save.
  Future<void> delete(int id) async {
    await _ref.read(careerRepositoryProvider).delete(id);
    _ref.invalidate(savesProvider);
  }

  int _seed() => DateTime.now().microsecondsSinceEpoch & 0x7fffffff;
}

final Provider<CareerService> careerServiceProvider = Provider(
  CareerService.new,
);
