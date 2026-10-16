import 'package:fnm/domain/services/manager/manager_skills.dart';
import 'package:fnm/domain/services/manager/staff.dart';
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

    /// Real-world seconds spent playing this save. Zero for a save that
    /// predates the counter — its earlier hours were never measured, and
    /// inventing a number for them would be worse than starting at nothing.
    @Default(0) int playedSeconds,

    /// What the manager himself is good at, 1–20 apiece. All four start at
    /// [ManagerSkills.starting], which every effect reads as neutral — so a
    /// save that predates them is unaffected until a point is spent.
    @Default(ManagerSkills.starting) int skillManManagement,
    @Default(ManagerSkills.starting) int skillTactical,
    @Default(ManagerSkills.starting) int skillYouthDevelopment,
    @Default(ManagerSkills.starting) int skillNegotiation,

    /// The staff he has hired. Nobody, by default, which costs nothing.
    @Default(StaffTier.none) StaffTier staffAssistant,
    @Default(StaffTier.none) StaffTier staffScout,
    @Default(StaffTier.none) StaffTier staffFitnessCoach,

    /// WHO is in each job, or null when the post is vacant. The tier above
    /// stays the source of truth for every effect; this is the person.
    int? staffAssistantId,
    int? staffScoutId,
    int? staffFitnessCoachId,

    /// Where the board's gauge finished the previous cycle, or null before a
    /// cycle has closed.
    int? lastCycleBoard,

  }) = _Career;
}
