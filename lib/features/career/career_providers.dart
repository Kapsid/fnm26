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
import 'package:fnm/domain/services/competition/friendly_scheduler.dart';
import 'package:fnm/domain/services/competition/real_history.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';

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
    await buildCalendar(
      comp: _ref.read(competitionRepositoryProvider),
      nations: await _ref.read(nationRepositoryProvider).all(),
      careerId: career.id,
      nationId: career.nationId,
      rngSeed: career.rngSeed,
      cycle: 0,
      cycleStart: career.inGameDate,
      wcYear: worldCupYear(0),
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
    final cont = ContinentalCups.byConfederation[me.confederation];
    final contFinalsStart =
        cont == null ? null : DateTime(wcYear - 2, cont.month, 8);
    if (cont != null && contFinalsStart != null) {
      final members =
          (byConfederation[me.confederation] ?? <Nation>[]).toList()
            ..sort((a, b) => rankOf(a).compareTo(rankOf(b)));
      if (members.length > cont.size) {
        final cq = const ScheduleGenerator().generate(
          confederation: me.confederation,
          nations: members,
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
            confederation: me.confederation,
            name: '${cont.name} Qualifiers',
            groups: cq.groups,
          ),
          cycle: cycle,
          kind: CompetitionKind.continentalQualifying,
          fixtureRound: 'CQ',
        );
      } else if (members.length >= cont.size &&
          members.take(cont.size).any((n) => n.id == me.id)) {
        // A confederation too small to run a group stage seeds its finals.
        final draw = WorldCupFinals.drawGroups(
          qualifierIds: members.take(cont.size).map((n) => n.id).toList(),
          rankingById: {for (final n in nations) n.id: rankOf(n)},
          rngSeed: rngSeed ^ (cycle * 0x71) ^ 0xC0FF,
        );
        await comp.saveTournamentGroups(
          careerId: careerId,
          cycle: cycle,
          confederation: me.confederation,
          kind: CompetitionKind.continentalFinals,
          name: cont.name,
          draw: draw,
          groupStart: contFinalsStart,
          round: 'CGROUP',
        );
      }
    }

    // 2. World Cup qualifying for every confederation runs the back half of the
    //    cycle (autumn of WC year − 2 into the WC year), so it leads straight
    //    into the finals.
    final wcQualStart = DateTime(wcYear - 2, 9);
    for (final entry in byConfederation.entries) {
      if (entry.value.length < 2) continue;
      final schedule = const ScheduleGenerator().generate(
        confederation: entry.key,
        nations: entry.value,
        rngSeed: rngSeed ^ (cycle * 0x1B3D) ^ (entry.key.index * 0x9E37),
        start: wcQualStart,
        rankById: rankById,
      );
      await comp.saveSchedule(
        careerId: careerId,
        schedule: schedule,
        cycle: cycle,
      );
    }

    // 3. Friendlies fill every window that has no competitive fixture, keeping
    //    clear of the two finals windows (the player may reach either).
    final own = await comp.fixturesForNation(careerId, nationId);
    final occupied = <(int, int)>{
      for (final f in own)
        if (!f.date.isBefore(cycleStart)) (f.date.year, f.date.month),
    };
    if (contFinalsStart != null) {
      occupied.add((contFinalsStart.year, contFinalsStart.month));
    }
    occupied.add((wcYear, 6)); // World Cup finals window.
    final pool = [for (final n in nations) if (n.id != nationId) n.id];
    final friendlies = FriendlyScheduler.schedule(
      from: cycleStart,
      until: DateTime(wcYear, 6),
      opponentPool: pool,
      seed: rngSeed ^ (cycle * 0x71),
      max: 14,
      skipWindows: occupied,
    );
    await comp.saveFriendlies(
      careerId: careerId,
      nationId: nationId,
      cycle: cycle,
      friendlies: friendlies,
    );
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
      await compRepo.recordHonour(
        careerId: career.id,
        year: e.year,
        competition: e.competition,
        championId: champion,
        runnerUpId: runnerUp,
        thirdId: resolve(e.third),
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
        .byNation(career.nationId, agingCycles: career.cyclePointer);
    const formation = Formation.f433;
    await _ref
        .read(tacticsRepositoryProvider)
        .saveTactic(
          career.id,
          Tactic(formation: formation, lineup: bestEleven(formation, players)),
        );
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
