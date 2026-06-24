import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/result/result.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/tactics.dart';
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

  /// The cycle starts on 1 September 2026.
  static final DateTime cycleStart = DateTime(2026, 9);

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
    await _generateSchedule(career);
    await _scheduleFriendlies(career, cycle: 0);
    await _generateDefaultTactic(career);
    await _seedHistory(career);
    _ref.invalidate(savesProvider);
    return Result.success(career);
  }

  /// Fills the gap between the nation's last qualifier and the finals with
  /// friendlies, so there's always something to play.
  Future<void> _scheduleFriendlies(Career career, {required int cycle}) async {
    final compRepo = _ref.read(competitionRepositoryProvider);
    final own = await compRepo.fixturesForNation(career.id, career.nationId);
    if (own.isEmpty) return;
    final lastQualifier = own
        .map((f) => f.date)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final nations = await _ref.read(nationRepositoryProvider).all();
    final specs = FriendlyScheduler.schedule(
      from: lastQualifier,
      until: DateTime(worldCupYear(cycle), 6),
      opponentPool: [
        for (final n in nations)
          if (n.id != career.nationId) n.id,
      ],
      seed: career.rngSeed ^ (cycle * 0x71),
    );
    await compRepo.saveFriendlies(
      careerId: career.id,
      nationId: career.nationId,
      cycle: cycle,
      friendlies: specs,
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
        .byNation(career.nationId);
    const formation = Formation.f433;
    await _ref
        .read(tacticsRepositoryProvider)
        .saveTactic(
          career.id,
          Tactic(formation: formation, lineup: bestEleven(formation, players)),
        );
  }

  /// Draws every confederation's World Cup qualifiers and persists the
  /// fixtures, so the whole world plays out (not just the player's region).
  Future<void> _generateSchedule(Career career) async {
    final nationRepo = _ref.read(nationRepositoryProvider);
    final compRepo = _ref.read(competitionRepositoryProvider);

    final byConfederation = <Confederation, List<Nation>>{};
    for (final n in await nationRepo.all()) {
      (byConfederation[n.confederation] ??= []).add(n);
    }

    for (final entry in byConfederation.entries) {
      if (entry.value.length < 2) continue;
      final schedule = const ScheduleGenerator().generate(
        confederation: entry.key,
        nations: entry.value,
        rngSeed: career.rngSeed ^ (entry.key.index * 0x9E37),
        start: career.inGameDate,
      );
      await compRepo.saveSchedule(careerId: career.id, schedule: schedule);
    }
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
