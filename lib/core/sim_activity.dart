/// Whether the simulation is part-way through a world-changing step.
///
/// Advancing, skipping to the champion and rolling the cycle each commit many
/// transactions in a row. A whole-database snapshot is consistent per
/// transaction, not per step, so one taken in between would hold a world
/// part-way through a round. The automatic backup asks this before it
/// snapshots and leaves the job to the trigger the step fires when it ends.
///
/// Process-wide on purpose: it must be right even across the in-app restart a
/// restore performs, which rebuilds every provider.
abstract final class SimActivity {
  static int _running = 0;

  /// True while any step is running.
  static bool get busy => _running > 0;

  /// Runs [body] counted as a step.
  static Future<T> track<T>(Future<T> Function() body) async {
    _running++;
    try {
      return await body();
    } finally {
      _running--;
    }
  }
}
