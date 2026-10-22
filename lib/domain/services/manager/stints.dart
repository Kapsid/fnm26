/// Reading the manager's spells in charge: `stints` maps each cycle to the
/// nation he managed in it (see `CareerRepository.stints`).
///
/// A career is keyed by the manager, not the nation, so anything that belongs
/// to a JOB (the board's memory, what he told the press, the results his board
/// judges him on, the players naturalised for a federation) has to be read
/// through these, or it follows him to the next job.
abstract final class Stints {
  /// The cycle his current spell at [nationId] began: [cycle] itself on
  /// arrival, earlier for a manager who stayed. A cycle with no stint
  /// recorded (a save older than stints) counts as the same job.
  static int arrivalCycle(Map<int, int> stints, int cycle, int nationId) {
    var c = cycle;
    while (c > 0 && (stints[c - 1] ?? nationId) == nationId) {
      c--;
    }
    return c;
  }

  /// The nation he managed in [cycle]: its stint, else the nearest earlier
  /// one, else [fallback].
  static int nationAt(Map<int, int> stints, int cycle, int fallback) {
    for (var c = cycle; c >= 0; c--) {
      final n = stints[c];
      if (n != null) return n;
    }
    return fallback;
  }
}
