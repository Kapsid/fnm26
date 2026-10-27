import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/international_retirement.dart';

/// Marks a career created by 1.0.6 or later, whose players are named from the
/// richer pools (`country_names.json` plus `country_names_more.json`).
///
/// Names are not stored: every read derives them from the save seed and the
/// pools, so a save from before the richer pools has to go on reading the old
/// ones or every player in it is renamed. Stored with the career's watched
/// events at cycle 0, so no schema change; a career without it (any older
/// save, or a bundle exported by an older version) keeps the classic pools.
const namePoolsV2Kind = 'namePools2';

/// Marks a career created by 1.0.7 or later, which reads every name pool in
/// full, names appended after a pool first shipped included.
///
/// For the same reason as [namePoolsV2Kind]: names are derived on every
/// read, so lengthening a pool would rename everyone in a save that already
/// had that nation. A career without this mark reads only the names each
/// pool first shipped with (the legacy lengths in `DriftPlayerRepository`),
/// so nobody in it is renamed. Greenland's 1.0.7 additions are the first.
const namePoolsV3Kind = 'namePools3';

/// Marks a career created after Greenland's surnames were reworked (1.0.7),
/// which reads the current pools where a pool's names were replaced rather
/// than appended: Greenland's German- and foreign-reading surnames gave way
/// to Greenlandic ones.
///
/// For the same reason as [namePoolsV2Kind]. A career with [namePoolsV3Kind]
/// but not this mark reads the lists as they stood before (frozen in
/// `dormant_seed.dart`), so nobody in it is renamed.
const namePoolsV4Kind = 'namePools4';

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
/// `careerId` names the career the players belong to. Its name-pool marker
/// (see [namePoolsV2Kind]) decides which pools their names are drawn from, so
/// every save-bound caller passes it beside `saveSeed`; null reads the classic
/// pools, as a career from before the marker does.
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
  ///
  /// With a `careerId`, players who have retired from international football
  /// in that career are left out (the SELECTION pool). History reads (a past
  /// tournament's team, an award, a record) pass `includeIntlRetired` so a man
  /// who retired after the tournament still appears in what he did there.
  Future<List<Player>> byNation(
    int nationId, {
    int agingYears,
    int saveSeed,
    int? careerId,
    Map<int, double> youthBonusByCycle,
    Map<int, int> careerStartsByPlayer,
    int minAge,
    bool includeIntlRetired,
  });

  /// The nation's youth pyramid (ages 11–20), for the Youth screen. Never used
  /// by the simulation.
  Future<List<Player>> youthByNation(
    int nationId, {
    int agingYears,
    int saveSeed,
    int? careerId,
    Map<int, double> youthBonusByCycle,
    Map<int, int> careerStartsByPlayer,
  });

  /// The international retirements (and comebacks) [careerId] has seen, by
  /// player id. [byNation] already leaves out whoever is retired at the year
  /// it is asked for; this is for the screens that SAY so (the player page)
  /// and for the service that decides them.
  Future<Map<int, IntlRetirement>> internationalRetirements(int careerId);

  /// [internationalRetirements] grouped by the nation each player retired
  /// from (0 for a marker that names none), then by player id.
  Future<Map<int, Map<int, IntlRetirement>>> internationalRetirementsByNation(
    int careerId,
  );

  /// Every player across all nations (unordered).
  Future<List<Player>> all();

  /// The player with [id], or `null` if none exists.
  Future<Player?> byId(
    int id, {
    int agingYears,
    int saveSeed,
    int? careerId,
    Map<int, double> youthBonusByCycle,
    Map<int, int> careerStartsByPlayer,
  });
}
