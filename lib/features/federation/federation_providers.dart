import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/manager/manager_skills.dart';
import 'package:fnm/domain/services/player/intake_standing.dart';
import 'package:fnm/features/career/career_providers.dart';

/// The talent shift applied to the manager's nation's newgen intakes, keyed by
/// the cycle each intake was born in. Two things feed it, and both are derived
/// from stored history so it re-produces identically on replay/restore:
///
///  * the youth-academy investment committed for that cycle, and
///  * how the senior side moved in the world ranking over the cycle before —
///    a nation on the way up starts producing better kids, one sliding down
///    produces worse, and what it won doing it (see
///    [intakeStandingByCycleProvider]).
///
/// Passed only for the player's own nation's pool.
final AutoDisposeFutureProviderFamily<Map<int, double>, int>
youthBonusByCycleProvider = FutureProvider.autoDispose.family<Map<int, double>, int>((
  ref,
  careerId,
) async {
  final invests = await ref
      .watch(careerRepositoryProvider)
      .investments(careerId);
  // The academy's own funding, per cycle.
  final bonuses = <int, double>{
    for (final e in invests.entries)
      if (e.value.youth > 0)
        e.key: FederationFinance.youthTalentBonus(e.value.youth),
  };
  // Plus the manager's own eye for a young player and any hours the side has
  // been putting into them. Applied to EVERY cycle rather than only the funded
  // ones: a manager who develops players does so whether or not the federation
  // has written a cheque, and a cycle with no academy money should still show
  // his hand.
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career != null) {
    final fromManager =
        ManagerSkills.youthTalentBonus(career.skillYouthDevelopment) +
        Staff.youthTalentBonus(career.staffAssistant);
    if (fromManager != 0) {
      for (var cycle = 0; cycle <= career.cyclePointer; cycle++) {
        bonuses[cycle] = (bonuses[cycle] ?? 0) + fromManager;
      }
    }
  }

  // Plus what the senior side's own standing pulled through. Kept as its own
  // provider so the inbox can say which of the two brought a better crop in.
  final standing = await ref.watch(
    intakeStandingByCycleProvider(careerId).future,
  );
  for (final e in standing.entries) {
    bonuses[e.key] = (bonuses[e.key] ?? 0) + e.value;
  }
  return bonuses;
});

/// The part of [youthBonusByCycleProvider] that the senior side EARNED, keyed
/// by the cycle whose intake inherits it: how far the nation moved in the world
/// ranking over the cycle just finished, and what it won doing it.
///
/// Split out from the academy's own money so the intake report can name the
/// cause (see `intakeNote`) instead of quietly handing over a better crop. The
/// number itself is [IntakeStanding.bonus]; everything here is the bookkeeping
/// that feeds it, all of it read from stored history so it re-produces
/// identically on replay or restore.
final AutoDisposeFutureProviderFamily<Map<int, double>, int>
intakeStandingByCycleProvider =
    FutureProvider.autoDispose.family<Map<int, double>, int>((
      ref,
      careerId,
    ) async {
      // Where the nation finished each cycle in the world ranking. Releases
      // arrive oldest-first, so the last one written for a cycle is that
      // cycle's standing.
      final releases = await ref
          .watch(rankingReleaseRepositoryProvider)
          .all(careerId);
      final rankByCycle = <int, int>{};
      final nationByCycle = <int, int>{};
      for (final r in releases) {
        rankByCycle[r.cycle] = r.playerRank;
        nationByCycle[r.cycle] = r.nationId;
      }
      if (rankByCycle.isEmpty) return const {};

      // What the side won in each cycle. A continental cup is played two years
      // before its cycle's World Championship, so an honour belongs to the
      // cycle whose World Championship is the next one on or after it — the
      // same mapping the career summary's trophy cabinet uses.
      final honours = await ref
          .watch(competitionRepositoryProvider)
          .honours(careerId);
      final titlesByCycle = <int, Set<String>>{};
      for (final h in honours) {
        // Never the decades of real history a fresh career is seeded with. A
        // 2026 edition predates the save, and the ceil below would file it
        // under cycle 0 — handing the intake a bonus for a tournament nobody
        // played. The save's own cycle 0 is contested in 2028 and 2030.
        if (!CareerService.isOwnHonourYear(h.year)) continue;
        final c = ((h.year - CareerService.worldCupYear(0)) / 4).ceil();
        final cycle = c < 0 ? 0 : c;
        // Only the nation the manager actually held that cycle; the roll of
        // honour covers the whole world, and a decade of pre-seeded history.
        if (h.championId != nationByCycle[cycle]) continue;
        (titlesByCycle[cycle] ??= <String>{}).add(h.competition);
      }

      final out = <int, double>{};
      for (final cycle in rankByCycle.keys) {
        final before = rankByCycle[cycle - 1];
        // Never measure a "climb" across a change of nation — taking over a
        // better side is not the same as having improved the one you had. The
        // trophies still count: you won those.
        final sameNation =
            before != null &&
            nationByCycle[cycle - 1] == nationByCycle[cycle];
        final now = rankByCycle[cycle]!;
        final bonus = IntakeStanding.bonus(
          worldRank: now,
          // A lower rank number is better, so a drop in the number is a climb.
          rankChangeOverCycle: sameNation ? before - now : 0,
          titlesWon: titlesByCycle[cycle] ?? const {},
        );
        // The intake that arrives at the NEXT cycle boundary is the one that
        // inherits it — the kids who watched the run, not the ones already in.
        if (bonus != 0) out[cycle + 1] = bonus;
      }
      return out;
    });

/// Total tournament STARTS per player across the save (playerId → starts) — the
/// career-development signal. A player who has started many matches grows a
/// touch (weighted by their club-league tier). Derived from stored appearance
/// rows, so it re-produces identically on replay.
final AutoDisposeFutureProviderFamily<Map<int, int>, int>
careerDevBonusProvider = FutureProvider.autoDispose.family<Map<int, int>, int>(
  (ref, careerId) =>
      ref.watch(competitionRepositoryProvider).careerStartsByPlayer(careerId),
);
