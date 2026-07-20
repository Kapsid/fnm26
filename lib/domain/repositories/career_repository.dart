import 'package:fnm/domain/entities/career.dart';

/// A cycle's federation investment split (euros committed to each department).
typedef FederationInvestment = ({
  int youth,
  int commercial,
  int medical,
  int naturalization,
  int boardRelations,
});

/// A naturalised-player link: a foreign player's original id, the nation they
/// came from, and the cycle the offer was made.
typedef NaturalizationLink = ({
  int playerId,
  int sourceNationId,
  int cycle,
});

/// Persists and retrieves save games.
abstract interface class CareerRepository {
  /// Creates a new save and returns it (with its assigned id).
  ///
  /// [startDate] seeds both the creation timestamp and the initial in-game
  /// date; the cycle pointer starts at `0`.
  Future<Career> create({
    required String managerName,
    required int nationId,
    required int rngSeed,
    required DateTime startDate,
  });

  /// All saves, most recently created first.
  Future<List<Career>> all();

  /// The save with [id], or `null` if none exists.
  Future<Career?> byId(int id);

  /// Advances (or sets) the in-game date of a save.
  Future<void> updateInGameDate(int id, DateTime date);

  /// Advances the save to a new cycle, setting [cyclePointer] and [date].
  Future<void> advanceCycle(int id, int cyclePointer, DateTime date);

  /// Moves the manager to a new nation (a between-cycles job change).
  Future<void> switchNation(int id, int nationId);

  /// Records that the manager led [nationId] during [cycle] (idempotent).
  Future<void> recordStint(int careerId, int cycle, int nationId);

  /// The nation the manager led in each cycle (cycle → nation id).
  Future<Map<int, int>> stints(int careerId);

  /// Sets the federation cash balance (euros) for a save.
  Future<void> setBudget(int id, int budget);

  /// The investment allocation committed for [cycle] (zeros if none).
  Future<FederationInvestment> investment(int careerId, int cycle);

  /// Every committed investment allocation, keyed by cycle — for re-deriving
  /// past cycles' youth intake.
  Future<Map<int, FederationInvestment>> investments(int careerId);

  /// Commits [investment] for [cycle] (overwrites any existing allocation).
  Future<void> setInvestment(int careerId, int cycle, FederationInvestment i);

  /// Records a foreign player's pending offer to switch allegiance. The
  /// [playerId] resolves the player's live attributes/name; [sourceNationId]
  /// is the nation they came from.
  Future<void> addNaturalizationOffer({
    required int careerId,
    required int playerId,
    required int sourceNationId,
    required int cycle,
  });

  /// The pending naturalisation offer awaiting a decision, or null if none.
  Future<NaturalizationLink?> pendingNaturalization(int careerId);

  /// Sets the [status] of a naturalisation offer ('accepted' / 'declined').
  Future<void> setNaturalizationStatus(
    int careerId,
    int playerId,
    String status,
  );

  /// Every accepted naturalised player's link (playerId + source nation), so
  /// the pool can graft them into the manager's nation.
  Future<List<NaturalizationLink>> acceptedNaturalizations(int careerId);

  /// The saved Nations Cup league of each nation (nationId → tier), empty until
  /// first seeded.
  Future<Map<int, int>> nationsCupTiers(int careerId);

  /// Persists the Nations Cup leagues (nationId → tier), overwriting.
  Future<void> setNationsCupTiers(int careerId, Map<int, int> tiers);

  /// Deletes the save with [id] (no-op if it does not exist).
  Future<void> delete(int id);
}
