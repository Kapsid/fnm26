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
import 'package:fnm/domain/services/competition/friendly_scheduler.dart';
import 'package:fnm/domain/services/competition/real_history.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';
import 'package:fnm/domain/services/competition/tournament_sim.dart';
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
    await _generateSchedule(career);
    await fillGap(
      comp: _ref.read(competitionRepositoryProvider),
      nations: await _ref.read(nationRepositoryProvider).all(),
      careerId: career.id,
      nationId: career.nationId,
      rngSeed: career.rngSeed,
      cycle: 0,
      qualifyingStart: career.inGameDate,
      wcYear: worldCupYear(0),
    );
    await _generateDefaultTactic(career);
    await _seedHistory(career);
    _ref.invalidate(savesProvider);
    return Result.success(career);
  }

  /// Fills the gap between the nation's last qualifier and the finals with a
  /// Nations League mini-group (if there's room) followed by friendlies, so
  /// there's always a competitive match to play. Shared by creation + rollover.
  static Future<void> fillGap({
    required CompetitionRepository comp,
    required List<Nation> nations,
    required int careerId,
    required int nationId,
    required int rngSeed,
    required int cycle,
    required DateTime qualifyingStart,
    required int wcYear,
  }) async {
    final own = await comp.fixturesForNation(careerId, nationId);
    final thisCycle = own
        .where((f) => !f.date.isBefore(qualifyingStart))
        .toList();
    if (thisCycle.isEmpty) return;
    final lastQualifier = thisCycle
        .map((f) => f.date)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    var gapStart = lastQualifier;
    final me = nations.firstWhere((n) => n.id == nationId);

    // Continental championship (played) — if the player qualifies (top seeds of
    // the confederation) and qualifying ends before it kicks off.
    final cont = ContinentalCups.byConfederation[me.confederation];
    final contStart =
        cont == null ? null : DateTime(wcYear - 2, cont.month, 8);
    if (cont != null &&
        contStart != null &&
        lastQualifier.isBefore(contStart)) {
      final members =
          nations.where((n) => n.confederation == me.confederation).toList()
            ..sort((a, b) => a.ranking.compareTo(b.ranking));
      if (members.length >= cont.size &&
          members.take(cont.size).any((n) => n.id == me.id)) {
        await comp.createKnockout(
          careerId: careerId,
          cycle: cycle,
          confederation: me.confederation,
          kind: CompetitionKind.continentalFinals,
          name: cont.name,
          pairings: TournamentSim.bracketPairs(
            members.take(cont.size).map((n) => n.id).toList(),
            cont.size,
          ),
          date: contStart,
          firstRound: cont.size == 16 ? 'CR16' : 'CQF',
        );
        gapStart = contStart.add(const Duration(days: 75));
      }
    }

    // Nations League: only if there's a full season of room before the finals.
    if (gapStart.isBefore(DateTime(wcYear - 1))) {
      final peers =
          nations
              .where(
                (n) => n.confederation == me.confederation && n.id != me.id,
              )
              .toList()
            ..sort(
              (a, b) => (a.ranking - me.ranking).abs().compareTo(
                (b.ranking - me.ranking).abs(),
              ),
            );
      if (peers.length >= 3) {
        final group = [me, ...peers.take(3)];
        final generated = const ScheduleGenerator().generate(
          confederation: me.confederation,
          nations: group,
          rngSeed: rngSeed ^ (cycle * 0x71) ^ 0x4E1,
          start: gapStart,
        );
        final nl = GeneratedSchedule(
          confederation: generated.confederation,
          name: 'Nations League',
          groups: generated.groups,
        );
        await comp.saveSchedule(
          careerId: careerId,
          schedule: nl,
          cycle: cycle,
          kind: CompetitionKind.nationsLeague,
          fixtureRound: 'NL',
        );
        gapStart = generated.groups
            .expand((g) => g.fixtures)
            .map((f) => f.date)
            .fold(gapStart, (m, d) => d.isAfter(m) ? d : m);
      }
    }

    final specs = FriendlyScheduler.schedule(
      from: gapStart,
      until: DateTime(wcYear, 6),
      opponentPool: [
        for (final n in nations)
          if (n.id != nationId) n.id,
      ],
      seed: rngSeed ^ (cycle * 0x71),
    );
    await comp.saveFriendlies(
      careerId: careerId,
      nationId: nationId,
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
