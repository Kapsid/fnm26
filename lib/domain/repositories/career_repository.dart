import 'package:fnm/domain/entities/career.dart';

/// A cycle's federation investment split (euros committed to each department).
typedef FederationInvestment = ({
  int youth,
  int commercial,
  int medical,
  int naturalization,
  int boardRelations,
});

/// One thing the manager said to the press, and what it moved.
typedef PressAnswerRow = ({
  String questionKey,
  String tone,
  int moraleDelta,
  int boardDelta,
  int cycle,
  DateTime answeredAt,
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

  /// All saves, most recently PLAYED first (falling back to creation order for
  /// a save that has never been opened since the field existed).
  Future<List<Career>> all();

  /// The save with [id], or `null` if none exists.
  Future<Career?> byId(int id);

  /// Stamps [at] as the save's last-played time — called when a save is opened
  /// so the saves list can order by it.
  Future<void> touch(int id, DateTime at);

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

  /// Names (or, with null, un-names) the squad captain.
  Future<void> setCaptain(int id, int? playerId);

  /// Marks the Y feed read up to [date] — the in-game date of its newest post.
  Future<void> setYReadAt(int id, DateTime date);

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
  /// Records what the manager told the press. One row per question answered;
  /// the key keeps a question from being asked twice.
  Future<void> recordPressAnswer({
    required int careerId,
    required int cycle,
    required String questionKey,
    required String tone,
    required int moraleDelta,
    required int boardDelta,
    required DateTime answeredAt,
  });

  /// Everything said this career, newest first. [cycle] limits it to one
  /// cycle's answers — press effects expire with the cycle they were given in.
  Future<List<PressAnswerRow>> pressAnswers(int careerId, {int? cycle});

  /// The base camp chosen for [tournament] (`GROUP` / `CGROUP`) in [cycle], or
  /// null when the manager has not picked one.
  Future<({int hostId, int campIndex})?> trainingCamp(
    int careerId,
    int cycle,
    String tournament,
  );

  /// Records the base camp for a tournament (replacing any earlier choice).
  Future<void> setTrainingCamp({
    required int careerId,
    required int cycle,
    required String tournament,
    required int hostId,
    required int campIndex,
  });

  Future<void> delete(int id);
}
