import 'package:freezed_annotation/freezed_annotation.dart';

part 'career.freezed.dart';

/// A save game: the manager's ongoing journey with a chosen nation.
///
/// [rngSeed] anchors the deterministic simulation for the whole save, so
/// results are reproducible and replay/cloud-restore safe. [cyclePointer]
/// tracks which 4-year cycle is active (the free demo allows only cycle `0`).
///
/// Persisted via Drift only — there is no per-entity JSON because cloud backup
/// uploads the whole SQLite file, not individual records.
@freezed
abstract class Career with _$Career {
  const factory Career({
    required int id,
    required String managerName,
    required int nationId,
    required int rngSeed,
    required DateTime createdAt,
    required DateTime inGameDate,
    @Default(0) int cyclePointer,

    /// Real-world timestamp of the last time this save was opened. Drives the
    /// "last played" line on the saves list and its most-recent-first order.
    /// Null only for saves written before the field existed.
    DateTime? lastPlayedAt,

    /// The federation's cash balance (euros), spent on department investments
    /// and replenished each cycle by central funding, prize money and
    /// commercial returns. Player-driven mutable state (not seed-derived).
    @Default(0) int budget,

    /// The player wearing the armband, or null if the manager has not named a
    /// captain. Only ever a player in the current squad — see `Captaincy`.
    int? captainPlayerId,

    /// The in-game date of the newest Y post the manager has seen, or null if
    /// he has never opened the feed. Posts are derived rather than stored, so
    /// this watermark is what "unread" is counted against.
    DateTime? yReadAt,
  }) = _Career;
}
