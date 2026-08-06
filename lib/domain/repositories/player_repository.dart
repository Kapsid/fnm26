import 'package:fnm/domain/entities/player.dart';

/// Read access to the player reference data.
///
/// `agingYears` ages the returned players by that many years (0 = the base seed
/// state) — callers pass the save's elapsed in-game years, so squads evolve one
/// season at a time rather than jumping four years each cycle.
///
/// `saveSeed` varies the *procedurally-generated* players (the fringe depth and
/// newgens — never the real, named internationals) per save, so two saves with
/// the same nation don't field identical squads. Callers pass the save's
/// `rngSeed`; 0 means no variation (the base seed state, used by tests).
///
/// `youthBonusByCycle` optionally lifts a nation's newgen intakes (keyed by the
/// cycle each was born in) — the federation's youth-academy investment. Only
/// the manager's own nation is passed a non-empty map.
abstract interface class PlayerRepository {
  /// All players eligible for [nationId], ordered by overall (best first).
  ///
  /// `careerStartsByPlayer` (playerId → tournament starts) applies the
  /// career-development bump — a well-used player grows a touch. Optional; an
  /// empty map (the default, and every non-manager call) means no development.
  ///
  /// `minAge` is the youngest age returned — seventeen by default, the senior
  /// pool. Only the player's own call-up path asks for fifteen.
  Future<List<Player>> byNation(
    int nationId, {
    int agingYears,
    int saveSeed,
    Map<int, double> youthBonusByCycle,
    Map<int, int> careerStartsByPlayer,
    int minAge,
  });

  /// The nation's youth pyramid (ages 11–20), for the Youth screen. Never used
  /// by the simulation.
  Future<List<Player>> youthByNation(
    int nationId, {
    int agingYears,
    int saveSeed,
    Map<int, double> youthBonusByCycle,
    Map<int, int> careerStartsByPlayer,
  });

  /// Every player across all nations (unordered).
  Future<List<Player>> all();

  /// The player with [id], or `null` if none exists.
  Future<Player?> byId(
    int id, {
    int agingYears,
    int saveSeed,
    Map<int, double> youthBonusByCycle,
    Map<int, int> careerStartsByPlayer,
  });
}
