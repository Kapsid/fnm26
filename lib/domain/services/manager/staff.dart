import 'package:fnm/core/rng/seeded_rng.dart';

/// The people the manager hires around him.
///
/// Two problems, one answer. The federation budget had almost nothing to spend
/// on beyond its own departments, and the months between international windows
/// were empty — the calendar simply skipped them. Staff are a standing cost
/// that buys a standing effect, so the money means something and the gap has a
/// decision in it.
enum StaffRole {
  /// Runs the training between windows: the side's conditioning, how fast a
  /// shape beds in, and the hours put into the youngest players.
  assistant,

  /// Reads what a young player will BECOME rather than what he is.
  scout,

  /// Keeps them on the pitch.
  fitnessCoach,
}

/// How good the person in the job is. [none] is the default and costs nothing —
/// a save that never hires anybody plays exactly as it did before.
enum StaffTier { none, basic, good, elite }

abstract final class Staff {
  /// What a tier costs per four-year cycle, in euros. Charged at the rollover
  /// alongside the federation's other outgoings.
  ///
  /// Priced against `FederationFinance.initialBudget`, which starts a mid-table
  /// nation around €12M a cycle: a full set of elite staff is a real chunk of
  /// that and has to be chosen over a department.
  static int costPerCycle(StaffTier tier) => switch (tier) {
    StaffTier.none => 0,
    StaffTier.basic => 400000,
    StaffTier.good => 1200000,
    StaffTier.elite => 2800000,
  };

  /// The whole wage bill for one cycle.
  static int totalCost(Map<StaffRole, StaffTier> staff) {
    var total = 0;
    for (final role in StaffRole.values) {
      total += costPerCycle(staff[role] ?? StaffTier.none);
    }
    return total;
  }

  /// How much of the training actually lands, as a multiplier.
  ///
  /// [StaffTier.none] is ZERO rather than a fraction. It used to be 0.6 — a
  /// manager with no assistant still trains his side, he just gets less out of
  /// it — which was right while the focus was a separate CHOICE the manager
  /// made. Now that the assistant IS the training, "nobody in the job" has to
  /// mean "no effect", or hiring nobody would quietly buy a bonus and a save
  /// from before any of this existed would stop playing the way it did.
  static double trainingEffect(StaffTier assistant) => switch (assistant) {
    StaffTier.none => 0.0,
    StaffTier.basic => 1.0,
    StaffTier.good => 1.3,
    StaffTier.elite => 1.6,
  };

  /// How many caps it takes before a player's ceiling is KNOWN rather than
  /// estimated — a better scout tells you sooner, which is the whole value of
  /// one: you find out before you have spent three years finding out.
  ///
  /// [baseCaps] is what the game would ask for with no scout at all.
  static int capsToKnow(StaffTier scout, int baseCaps) => switch (scout) {
    StaffTier.none => baseCaps,
    StaffTier.basic => (baseCaps * 0.75).round(),
    StaffTier.good => (baseCaps * 0.5).round(),
    StaffTier.elite => (baseCaps * 0.25).round(),
  };

  /// A multiplier on the side's injury rate. Compounds with the federation's
  /// medical department rather than replacing it: money and people are two
  /// different ways of keeping a squad fit.
  static double injuryFactor(StaffTier fitnessCoach) => switch (fitnessCoach) {
    StaffTier.none => 1.0,
    StaffTier.basic => 0.94,
    StaffTier.good => 0.87,
    StaffTier.elite => 0.78,
  };

  /// What the ASSISTANT's conditioning work is worth on top of the fitness
  /// coach's, as a multiplier on the injury rate.
  ///
  /// This, [familiarityGain] and [youthTalentBonus] are what became of the
  /// training focus. The manager used to pick one of fitness, cohesion or
  /// youth work and get its full effect; the choice was noise, because there
  /// was never a reason to change it once made. The assistant now does all
  /// three, each at HALF the old weight — so a manager gives nothing up to get
  /// any of them, and a side with no assistant sits exactly where it always
  /// did.
  static double assistantInjuryFactor(StaffTier assistant) =>
      1 - 0.06 * trainingEffect(assistant);

  /// The multiplier on how fast a shape beds in.
  static double familiarityGain(StaffTier assistant) =>
      1 + 0.12 * trainingEffect(assistant);

  /// Added to the youth-talent bonus, on top of the federation's academy
  /// spending and the manager's own eye for a young player.
  static double youthTalentBonus(StaffTier assistant) =>
      0.025 * trainingEffect(assistant);
}

/// One person available for one job: who he is, and how good.
///
/// Hiring used to be a choice of TIER — "good scout", "elite assistant" — which
/// is a price list, not a room. A staff room is people, so the manager picks a
/// person and the tier comes with him.
typedef StaffCandidate = ({
  int id,
  String name,
  String country,
  StaffRole role,
  StaffTier tier,
});

/// Who is available to hire, and how a candidate id remembers his tier.
///
/// Every candidate is DERIVED from `(saveSeed, cycle, role, slot)` — nothing is
/// stored but the id of the person actually hired, and his tier is recoverable
/// from that id alone. It is the same trick the newgen player ids use, and for
/// the same reason: no lookup table, no table to migrate, and a save that
/// reopens next year finds the man it hired still in the job.
abstract final class StaffMarket {
  /// How many people apply for each job each cycle.
  ///
  /// Three is enough to be a choice — there is always someone cheap, someone
  /// good and someone in between — without turning a side decision into a
  /// shortlist to work through.
  static const int candidatesPerRole = 3;

  /// Candidate ids sit in their own range, well clear of both the seeded
  /// player ids (≤ ~21k) and the newgen base (1e9), so an id can never be
  /// mistaken for a footballer.
  static const int idBase = 900000000;
  static const int _cycleStride = 10000;
  static const int _roleStride = 1000;
  static const int _tierStride = 100;

  /// Whether [id] is a staff candidate rather than any other kind of id.
  static bool isCandidateId(int id) =>
      id >= idBase && id < idBase + _cycleStride * 10000;

  /// The tier of the person with this [id], read straight back out of it.
  static StaffTier tierOf(int id) =>
      StaffTier.values[((id - idBase) ~/ _tierStride) % 10];

  /// The role the person with this [id] was hired for.
  static StaffRole roleOf(int id) =>
      StaffRole.values[((id - idBase) ~/ _roleStride) % 10];

  /// The people applying for [role] this [cycle].
  ///
  /// [namePool] is a map of flag code to the names that country produces —
  /// the manager's own nation and a handful of others.
  ///
  /// Coaching is an international trade and always has been: a federation
  /// hires the best man who will come, not the best man who happens to hold
  /// its passport. Drawing every candidate from the home pool made a staff
  /// room that read like a village, so the market now offers foreigners
  /// alongside locals and the flag beside a name means something.
  ///
  /// The tiers offered are spread deliberately: the first slot is always
  /// affordable and the last is always the best on offer, so a manager with no
  /// money still has somebody to hire and a manager with money always has
  /// something to spend it on.
  static List<StaffCandidate> forRole({
    required int saveSeed,
    required int cycle,
    required StaffRole role,
    required Map<String, List<String>> namePool,
  }) {
    final countries = [
      for (final e in namePool.entries)
        if (e.value.isNotEmpty) e.key,
    ]..sort();
    if (countries.isEmpty) return const [];
    final rng = SeededRng(
      (saveSeed * 0x9E3779B1) ^ (cycle * 0x85EBCA77) ^ (role.index * 0x27D4EB2F),
    );
    // Basic / good / elite, in that order: the cheap option first, because
    // that is the one a manager reads past on his way to what he cannot yet
    // afford.
    const tiers = [StaffTier.basic, StaffTier.good, StaffTier.elite];
    return [
      for (var slot = 0; slot < candidatesPerRole; slot++)
        () {
          final from = countries[rng.nextInt(countries.length)];
          return (
            id:
                idBase +
                cycle * _cycleStride +
                role.index * _roleStride +
                tiers[slot].index * _tierStride +
                slot,
            name: _nameFrom(namePool[from]!, rng),
            country: from,
            role: role,
            tier: tiers[slot],
          );
        }(),
    ];
  }

  /// A coach's name, built from the nation's own pool the way a newgen's is:
  /// somebody's first name and somebody else's surname, so the result is
  /// culturally plausible and belongs to nobody who exists.
  static String _nameFrom(List<String> pool, SeededRng rng) {
    final first = pool[rng.nextInt(pool.length)].trim().split(' ').first;
    final lastSource = pool[rng.nextInt(pool.length)].trim().split(' ');
    final last = lastSource.length > 1 ? lastSource.last : lastSource.first;
    return '$first $last';
  }
}
