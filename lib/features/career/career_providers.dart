import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/result/result.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/tactics.dart';
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
    await _generateDefaultTactic(career);
    _ref.invalidate(savesProvider);
    return Result.success(career);
  }

  /// Picks a sensible starting XI (best players in a 4-3-3) so a new save is
  /// immediately playable.
  Future<void> _generateDefaultTactic(Career career) async {
    final players =
        await _ref.read(playerRepositoryProvider).byNation(career.nationId);
    const formation = Formation.f433;
    await _ref.read(tacticsRepositoryProvider).saveTactic(
          career.id,
          Tactic(formation: formation, lineup: bestEleven(formation, players)),
        );
  }

  /// Draws the player's confederation qualifiers and persists the fixtures.
  Future<void> _generateSchedule(Career career) async {
    final nationRepo = _ref.read(nationRepositoryProvider);
    final nation = await nationRepo.byId(career.nationId);
    if (nation == null) return;
    final confederationNations = (await nationRepo.all())
        .where((n) => n.confederation == nation.confederation)
        .toList();
    final schedule = const ScheduleGenerator().generate(
      confederation: nation.confederation,
      nations: confederationNations,
      rngSeed: career.rngSeed,
      start: career.inGameDate,
    );
    await _ref
        .read(competitionRepositoryProvider)
        .saveSchedule(careerId: career.id, schedule: schedule);
  }

  /// Deletes a save.
  Future<void> delete(int id) async {
    await _ref.read(careerRepositoryProvider).delete(id);
    _ref.invalidate(savesProvider);
  }

  int _seed() => DateTime.now().microsecondsSinceEpoch & 0x7fffffff;
}

final Provider<CareerService> careerServiceProvider =
    Provider(CareerService.new);
